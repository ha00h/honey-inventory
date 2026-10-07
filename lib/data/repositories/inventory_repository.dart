import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/cart_complete_result.dart';
import '../../domain/entities/inventory_models.dart' as domain;
import '../../domain/entities/receipt_models.dart';
import '../../domain/services/hive_slots.dart';
import '../../domain/services/inventory_services.dart';
import '../../domain/services/product_matcher.dart';
import '../database/app_database.dart';

class InventoryRepository {
  InventoryRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Future<List<domain.Product>> watchProductsOnce() async {
    final rows =
        await (_database.select(_database.products)
              ..where((table) => table.isActive.equals(true))
              ..orderBy([(table) => OrderingTerm.asc(table.hiveSlot)]))
            .get();
    return rows.map(_mapProduct).toList();
  }

  Stream<List<domain.Product>> watchProducts() {
    final query = _database.select(_database.products)
      ..where((table) => table.isActive.equals(true))
      ..orderBy([(table) => OrderingTerm.asc(table.hiveSlot)]);
    return query.watch().map((rows) => rows.map(_mapProduct).toList());
  }

  Stream<List<domain.CartItem>> watchCartItems() {
    final query = _database.select(_database.cartItems)
      ..orderBy([(table) => OrderingTerm.desc(table.addedAt)]);
    return query.watch().map((rows) => rows.map(_mapCartItem).toList());
  }

  Future<List<domain.PurchaseCycle>> watchCyclesOnce() async {
    final rows = await _database.select(_database.purchaseCycles).get();
    return rows.map(_mapCycle).toList();
  }

  Stream<List<domain.PurchaseCycle>> watchCycles() {
    return _database
        .select(_database.purchaseCycles)
        .watch()
        .map((rows) => rows.map(_mapCycle).toList());
  }

  Stream<List<domain.StockHistory>> watchStockHistory(String productId) {
    final query = _database.select(_database.stockHistories)
      ..where((table) => table.productId.equals(productId))
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);
    return query.watch().map((rows) => rows.map(_mapStockHistory).toList());
  }

  Stream<List<domain.PurchaseRecord>> watchPurchaseRecords(String productId) {
    final query = _database.select(_database.purchaseRecords)
      ..where((table) => table.productId.equals(productId))
      ..orderBy([(table) => OrderingTerm.desc(table.purchasedAt)]);
    return query.watch().map((rows) => rows.map(_mapPurchaseRecord).toList());
  }

  Future<domain.Product?> getProductById(String id) async {
    final row = await (_database.select(
      _database.products,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _mapProduct(row);
  }

  Future<Map<String, String?>> latestStoreNameByProductId() async {
    final records = await (_database.select(
      _database.purchaseRecords,
    )..orderBy([(table) => OrderingTerm.desc(table.purchasedAt)])).get();

    final result = <String, String?>{};
    for (final row in records) {
      result.putIfAbsent(row.productId, () => row.storeName);
    }
    return result;
  }

  Future<List<domain.PurchaseRecord>> getPurchaseRecordsForProduct(
    String productId,
  ) async {
    final rows =
        await (_database.select(_database.purchaseRecords)
              ..where((table) => table.productId.equals(productId))
              ..orderBy([(table) => OrderingTerm.asc(table.purchasedAt)]))
            .get();
    return rows.map(_mapPurchaseRecord).toList();
  }

  Future<String?> _latestStoreNameForProduct(String productId) async {
    final row =
        await (_database.select(_database.purchaseRecords)
              ..where((table) => table.productId.equals(productId))
              ..orderBy([(table) => OrderingTerm.desc(table.purchasedAt)])
              ..limit(1))
            .getSingleOrNull();
    return row?.storeName;
  }

  PurchaseCycleSuggestion? _buildCycleSuggestion({
    required domain.Product product,
    required List<domain.PurchaseRecord> records,
    domain.PurchaseCycle? cycle,
  }) {
    final estimated = estimateIntervalDays(records);
    if (estimated < 1) {
      return null;
    }

    if (cycle != null && cycle.isEnabled && !cycle.isAutoEstimated) {
      return null;
    }

    return PurchaseCycleSuggestion(
      productId: product.id,
      productName: product.name,
      intervalDays: estimated,
    );
  }

  Future<Map<String, DateTime>> latestVisitByStoreName() async {
    final records =
        await (_database.select(_database.purchaseRecords)
              ..where((table) => table.storeName.isNotNull())
              ..orderBy([(table) => OrderingTerm.desc(table.purchasedAt)]))
            .get();

    final result = <String, DateTime>{};
    for (final row in records) {
      final name = row.storeName;
      if (name != null) {
        result.putIfAbsent(name, () => row.purchasedAt);
      }
    }
    return result;
  }

  Future<PurchaseCycleSuggestion?> mergeToExistingProduct({
    required String productId,
    required domain.ProductFormData data,
  }) async {
    final product = await getProductById(productId);
    if (product == null) {
      return null;
    }

    if (data.currentStock > 0) {
      await _recordPurchase(
        product: product,
        quantity: data.currentStock,
        source: domain.PurchaseSource.manual,
      );
    }

    if (data.purchaseIntervalDays != null) {
      await updatePurchaseCycle(
        productId: productId,
        intervalDays: data.purchaseIntervalDays!,
      );
    }

    final updated = await getProductById(productId);
    if (updated == null) {
      return null;
    }

    final records = await getPurchaseRecordsForProduct(productId);
    final cycle = await (_database.select(
      _database.purchaseCycles,
    )..where((table) => table.productId.equals(productId))).getSingleOrNull();

    return _buildCycleSuggestion(
      product: updated,
      records: records,
      cycle: cycle == null ? null : _mapCycle(cycle),
    );
  }

  Future<domain.Product?> findActiveProductByName(String name) async {
    return findActiveProductByNameExcluding(name: name);
  }

  Future<domain.Product?> findActiveProductByNameExcluding({
    required String name,
    String? excludeProductId,
  }) async {
    final row =
        await (_database.select(_database.products)..where(
              (table) =>
                  table.isActive.equals(true) &
                  table.name.equals(name.trim()) &
                  (excludeProductId == null
                      ? const Constant(true)
                      : table.id.equals(excludeProductId).not()),
            ))
            .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _mapProduct(row);
  }

  Future<String> addProduct(
    domain.ProductFormData data, {
    DateTime? createdAt,
  }) async {
    final now = createdAt ?? DateTime.now();
    final productId = _uuid.v4();
    final occupied = await (_database.select(
      _database.products,
    )..where((table) => table.isActive.equals(true))).get();
    final hiveSlot = nextEmptyHiveSlot(occupied.map((row) => row.hiveSlot));
    await _database.transaction(() async {
      await _database
          .into(_database.products)
          .insert(
            ProductsCompanion.insert(
              id: productId,
              name: data.name,
              category: Value(data.category?.name),
              unit: data.unit,
              currentStock: data.currentStock,
              maxStock: data.maxStock,
              minStock: data.minStock,
              iconKey: data.iconKey,
              iconColor: Value(data.iconColor),
              hiveSlot: Value(hiveSlot),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _database
          .into(_database.stockHistories)
          .insert(
            StockHistoriesCompanion.insert(
              id: _uuid.v4(),
              productId: productId,
              delta: data.currentStock,
              stockAfter: data.currentStock,
              reason: domain.StockChangeReason.initial.name,
              createdAt: now,
            ),
          );

      if (data.purchaseIntervalDays != null && data.purchaseIntervalDays! > 0) {
        final nextReminderDate = calculateNextReminderDate(
          now,
          data.purchaseIntervalDays!,
        );
        await _database
            .into(_database.purchaseCycles)
            .insert(
              PurchaseCyclesCompanion.insert(
                id: _uuid.v4(),
                productId: productId,
                intervalDays: data.purchaseIntervalDays!,
                lastPurchaseDate: Value(now),
                nextReminderDate: Value(nextReminderDate),
              ),
            );
      }
    });
    return productId;
  }

  Future<void> updateProduct({
    required String productId,
    required domain.ProductFormData data,
  }) async {
    final existing = await getProductById(productId);
    if (existing == null) {
      return;
    }

    final now = DateTime.now();
    await _database.transaction(() async {
      await (_database.update(
        _database.products,
      )..where((table) => table.id.equals(productId))).write(
        ProductsCompanion(
          name: Value(data.name),
          category: Value(data.category?.name),
          unit: Value(data.unit),
          currentStock: Value(data.currentStock),
          maxStock: Value(data.maxStock),
          minStock: Value(data.minStock),
          iconKey: Value(data.iconKey),
          iconColor: Value(data.iconColor),
          updatedAt: Value(now),
        ),
      );

      if (data.currentStock != existing.currentStock) {
        await _database
            .into(_database.stockHistories)
            .insert(
              StockHistoriesCompanion.insert(
                id: _uuid.v4(),
                productId: productId,
                delta: data.currentStock - existing.currentStock,
                stockAfter: data.currentStock,
                reason: domain.StockChangeReason.adjust.name,
                createdAt: now,
              ),
            );
      }

      final cycle = await (_database.select(
        _database.purchaseCycles,
      )..where((table) => table.productId.equals(productId))).getSingleOrNull();

      if (data.purchaseIntervalDays != null && data.purchaseIntervalDays! > 0) {
        final nextReminderDate = calculateNextReminderDate(
          cycle?.lastPurchaseDate ?? now,
          data.purchaseIntervalDays!,
        );

        if (cycle == null) {
          await _database
              .into(_database.purchaseCycles)
              .insert(
                PurchaseCyclesCompanion.insert(
                  id: _uuid.v4(),
                  productId: productId,
                  intervalDays: data.purchaseIntervalDays!,
                  lastPurchaseDate: Value(now),
                  nextReminderDate: Value(nextReminderDate),
                ),
              );
        } else {
          await (_database.update(
            _database.purchaseCycles,
          )..where((table) => table.id.equals(cycle.id))).write(
            PurchaseCyclesCompanion(
              intervalDays: Value(data.purchaseIntervalDays!),
              isEnabled: const Value(true),
              nextReminderDate: Value(nextReminderDate),
            ),
          );
        }
      } else if (cycle != null) {
        await (_database.update(_database.purchaseCycles)
              ..where((table) => table.id.equals(cycle.id)))
            .write(const PurchaseCyclesCompanion(isEnabled: Value(false)));
      }
    });
  }

  Future<void> moveHiveProduct({
    required int fromSlot,
    required int toSlot,
  }) async {
    if (fromSlot == toSlot) {
      return;
    }
    final products = await watchProductsOnce();
    final moving = [
      for (final product in products)
        if (product.hiveSlot == fromSlot) product,
    ];
    if (moving.isEmpty) {
      return;
    }
    final nextSlots = applyHiveMove(
      slotsByProductId: {
        for (final product in products) product.id: product.hiveSlot,
      },
      movingProductId: moving.first.id,
      toSlot: toSlot,
    );
    await _database.transaction(() async {
      for (final product in products) {
        final slot = nextSlots[product.id];
        if (slot == null || slot == product.hiveSlot) {
          continue;
        }
        await (_database.update(_database.products)
              ..where((table) => table.id.equals(product.id)))
            .write(ProductsCompanion(hiveSlot: Value(slot)));
      }
    });
  }

  Future<void> deleteProduct(String productId) async {
    final now = DateTime.now();
    await _database.transaction(() async {
      await (_database.update(
        _database.products,
      )..where((table) => table.id.equals(productId))).write(
        ProductsCompanion(isActive: const Value(false), updatedAt: Value(now)),
      );

      await (_database.delete(
        _database.cartItems,
      )..where((table) => table.productId.equals(productId))).go();
    });
  }

  Future<void> setStock({
    required domain.Product product,
    required double targetStock,
    required domain.StockChangeReason reason,
  }) async {
    final delta = targetStock - product.currentStock;
    if (delta == 0) {
      return;
    }
    await adjustStock(product: product, delta: delta, reason: reason);
  }

  Future<void> updateProductMaxStock({
    required String productId,
    required double maxStock,
  }) async {
    await (_database.update(
      _database.products,
    )..where((table) => table.id.equals(productId))).write(
      ProductsCompanion(
        maxStock: Value(maxStock),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> adjustStock({
    required domain.Product product,
    required double delta,
    required domain.StockChangeReason reason,
  }) async {
    final nextStock = (product.currentStock + delta).clamp(0.0, 999999.0);
    final now = DateTime.now();

    await _database.transaction(() async {
      await (_database.update(
        _database.products,
      )..where((table) => table.id.equals(product.id))).write(
        ProductsCompanion(
          currentStock: Value(nextStock),
          updatedAt: Value(now),
          maxStock: Value(
            nextStock > product.maxStock ? nextStock : product.maxStock,
          ),
        ),
      );

      await _database
          .into(_database.stockHistories)
          .insert(
            StockHistoriesCompanion.insert(
              id: _uuid.v4(),
              productId: product.id,
              delta: delta,
              stockAfter: nextStock,
              reason: reason.name,
              createdAt: now,
            ),
          );
    });
  }

  Future<void> updatePurchaseCycle({
    required String productId,
    required int intervalDays,
    bool isAutoEstimated = false,
    bool isEnabled = true,
    DateTime? lastPurchaseDate,
  }) async {
    final effectiveLastPurchase = lastPurchaseDate ?? DateTime.now();
    final cycle = await (_database.select(
      _database.purchaseCycles,
    )..where((table) => table.productId.equals(productId))).getSingleOrNull();
    final nextReminderDate = isEnabled && intervalDays > 0
        ? calculateNextReminderDate(effectiveLastPurchase, intervalDays)
        : null;

    if (cycle == null) {
      if (!isEnabled || intervalDays <= 0) {
        return;
      }
      await _database
          .into(_database.purchaseCycles)
          .insert(
            PurchaseCyclesCompanion.insert(
              id: _uuid.v4(),
              productId: productId,
              intervalDays: intervalDays,
              isAutoEstimated: Value(isAutoEstimated),
              isEnabled: Value(isEnabled),
              lastPurchaseDate: Value(effectiveLastPurchase),
              nextReminderDate: Value(nextReminderDate),
            ),
          );
      return;
    }

    await (_database.update(
      _database.purchaseCycles,
    )..where((table) => table.id.equals(cycle.id))).write(
      PurchaseCyclesCompanion(
        intervalDays: Value(intervalDays),
        isAutoEstimated: Value(isAutoEstimated),
        isEnabled: Value(isEnabled),
        lastPurchaseDate: Value(effectiveLastPurchase),
        nextReminderDate: Value(nextReminderDate),
      ),
    );
  }

  Future<void> applyEstimatedCycle({
    required String productId,
    required int intervalDays,
  }) {
    return updatePurchaseCycle(
      productId: productId,
      intervalDays: intervalDays,
      isAutoEstimated: true,
    );
  }

  Future<void> addToCart({
    required String productId,
    required double quantity,
  }) async {
    final preferredStoreName = await _latestStoreNameForProduct(productId);
    final existing = await (_database.select(
      _database.cartItems,
    )..where((table) => table.productId.equals(productId))).getSingleOrNull();

    if (existing != null) {
      await (_database.update(
        _database.cartItems,
      )..where((table) => table.id.equals(existing.id))).write(
        CartItemsCompanion(quantity: Value(existing.quantity + quantity)),
      );
      return;
    }

    await _database
        .into(_database.cartItems)
        .insert(
          CartItemsCompanion.insert(
            id: _uuid.v4(),
            productId: Value(productId),
            quantity: quantity,
            preferredStoreName: Value(preferredStoreName),
            addedAt: DateTime.now(),
          ),
        );
  }

  Future<void> addNamedItemToCart(String name, {double quantity = 1}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final existingProduct = await findActiveProductByName(trimmed);
    if (existingProduct != null) {
      await addToCart(productId: existingProduct.id, quantity: quantity);
      return;
    }

    final rows = await _database.select(_database.cartItems).get();
    for (final row in rows) {
      final pending = row.pendingName?.trim().toLowerCase();
      if (pending == trimmed.toLowerCase()) {
        await updateCartQuantity(
          cartItemId: row.id,
          quantity: row.quantity + quantity,
        );
        return;
      }
    }

    await _database
        .into(_database.cartItems)
        .insert(
          CartItemsCompanion.insert(
            id: _uuid.v4(),
            pendingName: Value(trimmed),
            quantity: quantity,
            addedAt: DateTime.now(),
          ),
        );
  }

  Future<void> updateCartQuantity({
    required String cartItemId,
    required double quantity,
  }) async {
    if (quantity <= 0) {
      await removeCartItem(cartItemId);
      return;
    }

    await (_database.update(_database.cartItems)
          ..where((table) => table.id.equals(cartItemId)))
        .write(CartItemsCompanion(quantity: Value(quantity)));
  }

  Future<void> removeCartItem(String cartItemId) async {
    await (_database.delete(
      _database.cartItems,
    )..where((table) => table.id.equals(cartItemId))).go();
  }

  Future<CartCompleteResult?> completeCartItem({
    required domain.CartItem cartItem,
    String? storeName,
  }) async {
    final product = cartItem.productId == null
        ? null
        : await getProductById(cartItem.productId!);
    if (product == null) {
      return null;
    }

    final resolvedStoreName = storeName ?? cartItem.preferredStoreName;
    final now = DateTime.now();
    final nextStock = product.currentStock + cartItem.quantity;
    MaxStockSuggestion? maxStockSuggestion;
    if (nextStock > product.maxStock) {
      maxStockSuggestion = MaxStockSuggestion(
        productId: product.id,
        productName: product.name,
        previousMaxStock: product.maxStock,
        newStock: nextStock,
        suggestedMaxStock: nextStock,
      );
    }

    await _database.transaction(() async {
      await (_database.update(
        _database.products,
      )..where((table) => table.id.equals(product.id))).write(
        ProductsCompanion(
          currentStock: Value(nextStock),
          updatedAt: Value(now),
        ),
      );

      await _database
          .into(_database.stockHistories)
          .insert(
            StockHistoriesCompanion.insert(
              id: _uuid.v4(),
              productId: product.id,
              delta: cartItem.quantity,
              stockAfter: nextStock,
              reason: domain.StockChangeReason.purchase.name,
              createdAt: now,
            ),
          );

      await _database
          .into(_database.purchaseRecords)
          .insert(
            PurchaseRecordsCompanion.insert(
              id: _uuid.v4(),
              productId: product.id,
              quantity: cartItem.quantity,
              purchasedAt: now,
              source: domain.PurchaseSource.cart.name,
              storeName: Value(resolvedStoreName),
            ),
          );

      final cycle =
          await (_database.select(_database.purchaseCycles)
                ..where((table) => table.productId.equals(product.id)))
              .getSingleOrNull();

      if (cycle != null) {
        await (_database.update(
          _database.purchaseCycles,
        )..where((table) => table.id.equals(cycle.id))).write(
          PurchaseCyclesCompanion(
            lastPurchaseDate: Value(now),
            nextReminderDate: Value(
              calculateNextReminderDate(now, cycle.intervalDays),
            ),
          ),
        );
      }

      await (_database.delete(
        _database.cartItems,
      )..where((table) => table.id.equals(cartItem.id))).go();
    });

    final records = await getPurchaseRecordsForProduct(product.id);
    final cycle = await (_database.select(
      _database.purchaseCycles,
    )..where((table) => table.productId.equals(product.id))).getSingleOrNull();
    final cycleSuggestion = _buildCycleSuggestion(
      product: product,
      records: records,
      cycle: cycle == null ? null : _mapCycle(cycle),
    );
    return CartCompleteResult(
      cycleSuggestion: cycleSuggestion,
      maxStockSuggestion: maxStockSuggestion,
    );
  }

  Future<List<CartCompleteResult>> completeCartItems(
    List<domain.CartItem> cartItems, {
    String? storeName,
  }) async {
    final results = <CartCompleteResult>[];

    for (final item in cartItems) {
      final result = await completeCartItem(
        cartItem: item,
        storeName: storeName,
      );
      if (result != null) {
        results.add(result);
      }
    }

    return results;
  }

  Future<int> importReceiptItems({
    required String? storeName,
    required List<ReceiptImportItem> items,
    int? remainingNewProductSlots,
  }) async {
    var importedCount = 0;
    var remainingNew = remainingNewProductSlots;

    for (final item in items) {
      domain.Product? product;
      if (item.matchedProductId != null) {
        product = await getProductById(item.matchedProductId!);
      }
      product ??= await findActiveProductByName(item.name);
      if (product == null) {
        final products = await watchProductsOnce();
        product = matchProductByName(item.name, products)?.product;
      }

      if (product == null) {
        if (remainingNew != null) {
          if (remainingNew <= 0) {
            continue;
          }
          remainingNew -= 1;
        }
        final data = domain.ProductFormData(
          name: item.name,
          unit: '개',
          currentStock: 0,
          maxStock: item.quantity * 2,
          minStock: 1,
          iconKey: 'basket',
        );
        await addProduct(data);
        product = await findActiveProductByName(item.name);
      }

      if (product == null) {
        continue;
      }

      await _recordPurchase(
        product: product,
        quantity: item.quantity,
        storeName: storeName,
        source: domain.PurchaseSource.receipt,
      );
      importedCount++;
    }

    return importedCount;
  }

  Future<void> _recordPurchase({
    required domain.Product product,
    required double quantity,
    String? storeName,
    required domain.PurchaseSource source,
  }) async {
    if (quantity <= 0) {
      return;
    }

    final now = DateTime.now();
    await _database.transaction(() async {
      final nextStock = product.currentStock + quantity;
      await (_database.update(
        _database.products,
      )..where((table) => table.id.equals(product.id))).write(
        ProductsCompanion(
          currentStock: Value(nextStock),
          updatedAt: Value(now),
          maxStock: Value(
            nextStock > product.maxStock ? nextStock : product.maxStock,
          ),
        ),
      );

      await _database
          .into(_database.stockHistories)
          .insert(
            StockHistoriesCompanion.insert(
              id: _uuid.v4(),
              productId: product.id,
              delta: quantity,
              stockAfter: nextStock,
              reason: domain.StockChangeReason.purchase.name,
              createdAt: now,
            ),
          );

      await _database
          .into(_database.purchaseRecords)
          .insert(
            PurchaseRecordsCompanion.insert(
              id: _uuid.v4(),
              productId: product.id,
              quantity: quantity,
              purchasedAt: now,
              source: source.name,
              storeName: Value(storeName),
            ),
          );

      final cycle =
          await (_database.select(_database.purchaseCycles)
                ..where((table) => table.productId.equals(product.id)))
              .getSingleOrNull();

      if (cycle != null) {
        await (_database.update(
          _database.purchaseCycles,
        )..where((table) => table.id.equals(cycle.id))).write(
          PurchaseCyclesCompanion(
            lastPurchaseDate: Value(now),
            nextReminderDate: Value(
              calculateNextReminderDate(now, cycle.intervalDays),
            ),
          ),
        );
      }
    });
  }

  domain.Product _mapProduct(Product row) {
    return domain.Product(
      id: row.id,
      name: row.name,
      category: _parseCategory(row.category),
      unit: row.unit,
      currentStock: row.currentStock,
      maxStock: row.maxStock,
      minStock: row.minStock,
      iconKey: row.iconKey,
      iconColor: row.iconColor,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      hiveSlot: row.hiveSlot,
    );
  }

  domain.PurchaseCycle _mapCycle(PurchaseCycle row) {
    return domain.PurchaseCycle(
      id: row.id,
      productId: row.productId,
      intervalDays: row.intervalDays,
      isAutoEstimated: row.isAutoEstimated,
      lastPurchaseDate: row.lastPurchaseDate,
      nextReminderDate: row.nextReminderDate,
      isEnabled: row.isEnabled,
    );
  }

  domain.CartItem _mapCartItem(CartItem row) {
    return domain.CartItem(
      id: row.id,
      productId: row.productId,
      pendingName: row.pendingName,
      quantity: row.quantity,
      addedAt: row.addedAt,
      preferredStoreName: row.preferredStoreName,
      note: row.note,
    );
  }

  domain.StockHistory _mapStockHistory(StockHistory row) {
    return domain.StockHistory(
      id: row.id,
      productId: row.productId,
      delta: row.delta,
      stockAfter: row.stockAfter,
      reason: domain.StockChangeReason.values.byName(row.reason),
      createdAt: row.createdAt,
    );
  }

  domain.PurchaseRecord _mapPurchaseRecord(PurchaseRecord row) {
    return domain.PurchaseRecord(
      id: row.id,
      productId: row.productId,
      quantity: row.quantity,
      purchasedAt: row.purchasedAt,
      source: domain.PurchaseSource.values.byName(row.source),
      storeName: row.storeName,
      note: row.note,
    );
  }

  domain.ProductCategory? _parseCategory(String? name) {
    if (name == null || name.isEmpty) {
      return null;
    }
    return domain.ProductCategory.values.byName(name);
  }
}
