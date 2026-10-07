enum ProductCategory {
  household,
  food,
  hygiene,
  kitchen,
  laundry,
  bathroom,
  electronics,
  medicine,
  pet,
  baby,
  other,
}

extension ProductCategoryLabel on ProductCategory {
  String get label => switch (this) {
    ProductCategory.household => '생활용품',
    ProductCategory.food => '식료품',
    ProductCategory.hygiene => '위생용품',
    ProductCategory.kitchen => '주방',
    ProductCategory.laundry => '세탁',
    ProductCategory.bathroom => '욕실',
    ProductCategory.electronics => '전자',
    ProductCategory.medicine => '의약',
    ProductCategory.pet => '반려',
    ProductCategory.baby => '육아',
    ProductCategory.other => '기타',
  };
}

enum StockChangeReason { purchase, usage, discard, adjust, initial }

enum PurchaseSource { manual, receipt, cart }

enum ReminderType { lowStock, cycleDue }

const defaultIconColorHex = '#3D2E1F';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.unit,
    required this.currentStock,
    required this.maxStock,
    required this.minStock,
    required this.iconKey,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.iconColor = defaultIconColorHex,
    this.hiveSlot = 0,
  });

  final String id;
  final String name;
  final ProductCategory? category;
  final String unit;
  final double currentStock;
  final double maxStock;
  final double minStock;
  final String iconKey;
  final String iconColor;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int hiveSlot;

  bool get isLowStock => currentStock <= minStock;
}

class PurchaseCycle {
  const PurchaseCycle({
    required this.id,
    required this.productId,
    required this.intervalDays,
    required this.isAutoEstimated,
    required this.isEnabled,
    this.lastPurchaseDate,
    this.nextReminderDate,
  });

  final String id;
  final String productId;
  final int intervalDays;
  final bool isAutoEstimated;
  final DateTime? lastPurchaseDate;
  final DateTime? nextReminderDate;
  final bool isEnabled;
}

class CartItem {
  const CartItem({
    required this.id,
    required this.quantity,
    required this.addedAt,
    this.productId,
    this.pendingName,
    this.preferredStoreName,
    this.note,
  });

  final String id;
  final String? productId;
  final String? pendingName;
  final double quantity;
  final DateTime addedAt;
  final String? preferredStoreName;
  final String? note;

  String label([String? productName]) {
    final fromProduct = productName?.trim() ?? '';
    if (fromProduct.isNotEmpty) {
      return fromProduct;
    }
    return pendingName?.trim() ?? '물품';
  }
}

class PurchaseRecord {
  const PurchaseRecord({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.purchasedAt,
    required this.source,
    this.storeName,
    this.note,
  });

  final String id;
  final String productId;
  final double quantity;
  final DateTime purchasedAt;
  final PurchaseSource source;
  final String? storeName;
  final String? note;
}

class StockHistory {
  const StockHistory({
    required this.id,
    required this.productId,
    required this.delta,
    required this.stockAfter,
    required this.reason,
    required this.createdAt,
  });

  final String id;
  final String productId;
  final double delta;
  final double stockAfter;
  final StockChangeReason reason;
  final DateTime createdAt;
}

class ReminderItem {
  const ReminderItem({
    required this.productId,
    required this.productName,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  final String productId;
  final String productName;
  final String message;
  final ReminderType type;
  final DateTime createdAt;
}

class ProductFormData {
  const ProductFormData({
    required this.name,
    required this.unit,
    required this.currentStock,
    required this.maxStock,
    required this.minStock,
    required this.iconKey,
    this.category,
    this.purchaseIntervalDays,
    this.iconColor = defaultIconColorHex,
  });

  final String name;
  final ProductCategory? category;
  final String unit;
  final double currentStock;
  final double maxStock;
  final double minStock;
  final String iconKey;
  final String iconColor;
  final int? purchaseIntervalDays;
}
