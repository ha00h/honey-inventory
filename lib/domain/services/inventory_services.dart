import '../entities/inventory_models.dart';

enum HiveHoneyStatus { normal, lowStock, cycleDue }

double stockFillRatio(Product product) {
  if (product.maxStock <= 0) {
    return 0;
  }

  return (product.currentStock / product.maxStock).clamp(0.0, 1.0);
}

bool isPurchaseCycleDue(PurchaseCycle? cycle, {DateTime? now}) {
  if (cycle == null || !cycle.isEnabled) {
    return false;
  }
  final nextReminderDate = cycle.nextReminderDate;
  if (nextReminderDate == null) {
    return false;
  }
  final today = now ?? DateTime.now();
  return !nextReminderDate.isAfter(
    DateTime(today.year, today.month, today.day),
  );
}

HiveHoneyStatus hiveHoneyStatus({
  required Product product,
  PurchaseCycle? cycle,
  DateTime? now,
}) {
  if (product.isLowStock) {
    return HiveHoneyStatus.lowStock;
  }
  if (isPurchaseCycleDue(cycle, now: now)) {
    return HiveHoneyStatus.cycleDue;
  }
  return HiveHoneyStatus.normal;
}

DateTime? calculateNextReminderDate(
  DateTime? lastPurchaseDate,
  int intervalDays,
) {
  if (lastPurchaseDate == null || intervalDays <= 0) {
    return null;
  }

  return DateTime(
    lastPurchaseDate.year,
    lastPurchaseDate.month,
    lastPurchaseDate.day + intervalDays,
  );
}

int estimateIntervalDays(List<PurchaseRecord> records) {
  if (records.length < 2) {
    return 0;
  }

  final sorted = [...records]
    ..sort((a, b) => a.purchasedAt.compareTo(b.purchasedAt));
  final startIndex = sorted.length > 5 ? sorted.length - 5 : 0;
  final recent = sorted.sublist(startIndex);
  final intervals = <int>[];

  for (var index = 1; index < recent.length; index++) {
    final days = recent[index].purchasedAt
        .difference(recent[index - 1].purchasedAt)
        .inDays;
    if (days > 0) {
      intervals.add(days);
    }
  }

  if (intervals.isEmpty) {
    return 0;
  }

  final average =
      intervals.reduce((left, right) => left + right) / intervals.length;
  return average.round();
}

List<ReminderItem> buildReminderItems({
  required List<Product> products,
  required List<PurchaseCycle> cycles,
  DateTime? now,
  Set<String> snoozedProductIds = const {},
}) {
  final today = now ?? DateTime.now();
  final cycleByProductId = {for (final cycle in cycles) cycle.productId: cycle};

  final reminders = <ReminderItem>[];

  for (final product in products.where((item) => item.isActive)) {
    if (snoozedProductIds.contains(product.id)) {
      continue;
    }
    if (product.isLowStock) {
      reminders.add(
        ReminderItem(
          productId: product.id,
          productName: product.name,
          message: '${product.name} 칸의 꿀이 말라가고 있어요!',
          type: ReminderType.lowStock,
          createdAt: today,
        ),
      );
      continue;
    }

    final cycle = cycleByProductId[product.id];
    if (isPurchaseCycleDue(cycle, now: today)) {
      reminders.add(
        ReminderItem(
          productId: product.id,
          productName: product.name,
          message: '${product.name} 구매할 때가 된 것 같아요.',
          type: ReminderType.cycleDue,
          createdAt: today,
        ),
      );
    }
  }

  reminders.sort((left, right) => left.type.index.compareTo(right.type.index));
  return reminders;
}

class CartStoreGroup {
  const CartStoreGroup({required this.storeName, required this.items});

  final String storeName;
  final List<CartItem> items;
}

class CartStoreContext {
  const CartStoreContext({
    required this.storeNameByProductId,
    required this.lastVisitByStoreName,
  });

  final Map<String, String?> storeNameByProductId;
  final Map<String, DateTime> lastVisitByStoreName;
}

List<CartStoreGroup> groupCartItemsByStore({
  required List<CartItem> cartItems,
  required Map<String, String?> storeNameByProductId,
  Map<String, DateTime> lastVisitByStoreName = const {},
}) {
  final grouped = <String, List<CartItem>>{};

  for (final item in cartItems) {
    final storeName =
        item.preferredStoreName ??
        (item.productId == null
            ? null
            : storeNameByProductId[item.productId]) ??
        '구매처 미정';
    grouped.putIfAbsent(storeName, () => []).add(item);
  }

  final groups = grouped.entries
      .map((entry) => CartStoreGroup(storeName: entry.key, items: entry.value))
      .toList();

  groups.sort((left, right) {
    final leftUnknown = left.storeName == '구매처 미정';
    final rightUnknown = right.storeName == '구매처 미정';
    if (leftUnknown != rightUnknown) {
      return leftUnknown ? 1 : -1;
    }

    final leftVisit = lastVisitByStoreName[left.storeName];
    final rightVisit = lastVisitByStoreName[right.storeName];
    if (leftVisit != null && rightVisit != null) {
      return rightVisit.compareTo(leftVisit);
    }
    if (leftVisit != null) {
      return -1;
    }
    if (rightVisit != null) {
      return 1;
    }

    return left.storeName.compareTo(right.storeName);
  });

  for (final group in groups) {
    group.items.sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  return groups;
}

List<CartStoreGroup> filterCartGroupsByQuery({
  required List<CartStoreGroup> groups,
  required Map<String, String> productNameById,
  required String query,
}) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return groups;
  }

  final lower = trimmed.toLowerCase();
  final filtered = <CartStoreGroup>[];

  for (final group in groups) {
    final items = group.items.where((item) {
      final name = item.pendingName ??
          (item.productId == null
              ? ''
              : (productNameById[item.productId] ?? ''));
      return name.toLowerCase().contains(lower);
    }).toList();
    if (items.isNotEmpty) {
      filtered.add(CartStoreGroup(storeName: group.storeName, items: items));
    }
  }

  return filtered;
}

List<Product> findProductsToAddToCart({
  required String query,
  required List<Product> products,
  required Set<String> cartProductIds,
}) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return const [];
  }

  final lower = trimmed.toLowerCase();
  return products
      .where(
        (product) =>
            !cartProductIds.contains(product.id) &&
            product.name.toLowerCase().contains(lower),
      )
      .take(5)
      .toList();
}

Product? findExactProductByName({
  required String query,
  required List<Product> products,
}) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  final lower = trimmed.toLowerCase();
  for (final product in products) {
    if (product.name.toLowerCase() == lower) {
      return product;
    }
  }
  return null;
}

bool shouldCreateProductFromCartQuery({
  required String query,
  required List<Product> products,
}) {
  return query.trim().isNotEmpty &&
      findExactProductByName(query: query, products: products) == null;
}

ProductFormData quickCartProductForm(String name) {
  return ProductFormData(
    name: name.trim(),
    unit: '개',
    currentStock: 0,
    maxStock: 3,
    minStock: 0,
    iconKey: 'basket',
    category: ProductCategory.other,
  );
}
