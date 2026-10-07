import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/local_only_sync_service.dart';
import '../../../domain/entities/cart_complete_result.dart';
import '../../../domain/entities/inventory_models.dart' as domain;
import '../../../domain/entities/receipt_models.dart';
import '../../../domain/services/hive_economy.dart';
import '../../../domain/services/inventory_services.dart';
import '../../../domain/services/notification_scheduler.dart';
import '../../../domain/services/sync_service.dart';
import '../../../services/ads/rewarded_ad_service.dart';
import '../../../services/notification_background.dart';
import 'repository_providers.dart';
import 'settings_providers.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return LocalOnlySyncService();
});

final rewardedAdServiceProvider = Provider<RewardedAdService>((ref) {
  return RewardedAdService();
});

final appStartupProvider = FutureProvider<void>((ref) async {
  final repository = ref.read(inventoryRepositoryProvider);
  final notificationService = ref.read(localNotificationServiceProvider);
  await notificationService.initialize();
  await refreshScheduledNotifications(
    inventoryRepository: repository,
    settingsRepository: ref.read(settingsRepositoryProvider),
    notificationService: notificationService,
  );
  await ensureNotificationBackgroundWorkScheduled();
  // Ad SDK init can take several seconds; never block the hive on it.
  unawaited(ref.read(rewardedAdServiceProvider).preload());
});

final productsProvider = StreamProvider<List<domain.Product>>((ref) {
  ref.watch(appStartupProvider);
  return ref.watch(inventoryRepositoryProvider).watchProducts();
});

final cyclesProvider = StreamProvider<List<domain.PurchaseCycle>>((ref) {
  ref.watch(appStartupProvider);
  return ref.watch(inventoryRepositoryProvider).watchCycles();
});

final cartItemsProvider = StreamProvider<List<domain.CartItem>>((ref) {
  ref.watch(appStartupProvider);
  return ref.watch(inventoryRepositoryProvider).watchCartItems();
});

final cartStoreContextProvider = FutureProvider<CartStoreContext>((ref) async {
  await ref.watch(appStartupProvider.future);
  final repository = ref.watch(inventoryRepositoryProvider);
  return CartStoreContext(
    storeNameByProductId: await repository.latestStoreNameByProductId(),
    lastVisitByStoreName: await repository.latestVisitByStoreName(),
  );
});

final groupedCartProvider = Provider<AsyncValue<List<CartStoreGroup>>>((ref) {
  final cartItems = ref.watch(cartItemsProvider);
  final storeContext = ref.watch(cartStoreContextProvider);

  return cartItems.when(
    data: (items) => storeContext.when(
      data: (context) => AsyncData(
        groupCartItemsByStore(
          cartItems: items,
          storeNameByProductId: context.storeNameByProductId,
          lastVisitByStoreName: context.lastVisitByStoreName,
        ),
      ),
      error: (error, stackTrace) => AsyncError(error, stackTrace),
      loading: () => const AsyncLoading(),
    ),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
    loading: () => const AsyncLoading(),
  );
});

final remindersProvider = Provider<AsyncValue<List<domain.ReminderItem>>>((
  ref,
) {
  final products = ref.watch(productsProvider);
  final cycles = ref.watch(cyclesProvider);
  final settings = ref.watch(settingsProvider);
  final cycleList = cycles.maybeWhen(
    data: (items) => items,
    orElse: () => const <domain.PurchaseCycle>[],
  );
  final snoozedIds = settings.maybeWhen(
    skipLoadingOnReload: true,
    data: (value) => value.activeSnoozedProductIds(),
    orElse: () => <String>{},
  );

  return products.whenData((productList) {
    return buildReminderItems(
      products: productList,
      cycles: cycleList,
      snoozedProductIds: snoozedIds,
    );
  });
});

final unacknowledgedRemindersProvider =
    Provider<AsyncValue<List<domain.ReminderItem>>>((ref) {
      final reminders = ref.watch(remindersProvider);
      final settings = ref.watch(settingsProvider);
      final dismissedIds = settings.maybeWhen(
        skipLoadingOnReload: true,
        data: (value) => value.dismissedReminderProductIds,
        orElse: () => <String>{},
      );

      return reminders.whenData((items) {
        return items
            .where((item) => !dismissedIds.contains(item.productId))
            .toList();
      });
    });

final productDetailProvider = FutureProvider.family<domain.Product?, String>((
  ref,
  productId,
) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(inventoryRepositoryProvider).getProductById(productId);
});

final stockHistoryProvider =
    StreamProvider.family<List<domain.StockHistory>, String>((ref, productId) {
      ref.watch(appStartupProvider);
      return ref
          .watch(inventoryRepositoryProvider)
          .watchStockHistory(productId);
    });

final purchaseRecordsProvider =
    StreamProvider.family<List<domain.PurchaseRecord>, String>((
      ref,
      productId,
    ) {
      ref.watch(appStartupProvider);
      return ref
          .watch(inventoryRepositoryProvider)
          .watchPurchaseRecords(productId);
    });

final productCycleProvider =
    StreamProvider.family<domain.PurchaseCycle?, String>((ref, productId) {
      ref.watch(appStartupProvider);
      return ref.watch(inventoryRepositoryProvider).watchCycles().map((items) {
        for (final item in items) {
          if (item.productId == productId) {
            return item;
          }
        }
        return null;
      });
    });

class InventoryActions {
  InventoryActions(this._ref);

  final Ref _ref;

  InventoryRepository get _repository => _ref.read(inventoryRepositoryProvider);

  Future<void> _refreshNotifications() {
    return refreshScheduledNotifications(
      inventoryRepository: _repository,
      settingsRepository: _ref.read(settingsRepositoryProvider),
      notificationService: _ref.read(localNotificationServiceProvider),
    );
  }

  Future<String> addProduct(domain.ProductFormData data) async {
    final settings = await _ref.read(settingsProvider.future);
    final products = await _repository.watchProductsOnce();
    if (!canAddHiveProduct(
      isPro: settings.isPro,
      unlockedHiveCells: settings.unlockedHiveCells,
      productCount: products.length,
    )) {
      throw const HiveCapacityException();
    }
    final productId = await _repository.addProduct(data);
    await _refreshNotifications();
    return productId;
  }

  Future<PurchaseCycleSuggestion?> mergeToExistingProduct({
    required String productId,
    required domain.ProductFormData data,
  }) async {
    final suggestion = await _repository.mergeToExistingProduct(
      productId: productId,
      data: data,
    );
    await _refreshNotifications();
    return suggestion;
  }

  Future<void> updateProduct({
    required String productId,
    required domain.ProductFormData data,
  }) async {
    await _repository.updateProduct(productId: productId, data: data);
    await _refreshNotifications();
  }

  Future<void> deleteProduct(String productId) async {
    await _repository.deleteProduct(productId);
    await _refreshNotifications();
  }

  Future<void> moveHiveProduct({required int fromSlot, required int toSlot}) {
    return _repository.moveHiveProduct(fromSlot: fromSlot, toSlot: toSlot);
  }

  Future<void> adjustStock({
    required domain.Product product,
    required double delta,
    required domain.StockChangeReason reason,
  }) async {
    await _repository.adjustStock(
      product: product,
      delta: delta,
      reason: reason,
    );
    await _refreshNotifications();
  }

  Future<void> setStock({
    required domain.Product product,
    required double targetStock,
    required domain.StockChangeReason reason,
  }) async {
    await _repository.setStock(
      product: product,
      targetStock: targetStock,
      reason: reason,
    );
    await _refreshNotifications();
  }

  Future<void> updateProductMaxStock({
    required String productId,
    required double maxStock,
  }) async {
    await _repository.updateProductMaxStock(
      productId: productId,
      maxStock: maxStock,
    );
  }

  Future<void> updatePurchaseCycle({
    required String productId,
    required int intervalDays,
    bool isAutoEstimated = false,
    bool isEnabled = true,
    DateTime? lastPurchaseDate,
  }) async {
    await _repository.updatePurchaseCycle(
      productId: productId,
      intervalDays: intervalDays,
      isAutoEstimated: isAutoEstimated,
      isEnabled: isEnabled,
      lastPurchaseDate: lastPurchaseDate,
    );
    await _refreshNotifications();
  }

  Future<void> applyEstimatedCycle({
    required String productId,
    required int intervalDays,
  }) async {
    await _repository.applyEstimatedCycle(
      productId: productId,
      intervalDays: intervalDays,
    );
    await _refreshNotifications();
  }

  Future<CartCompleteResult?> completeCartItem(domain.CartItem item) async {
    final result = await _repository.completeCartItem(cartItem: item);
    await _refreshNotifications();
    return result;
  }

  Future<List<CartCompleteResult>> completeCartItems(
    List<domain.CartItem> items, {
    String? storeName,
  }) async {
    final results = await _repository.completeCartItems(
      items,
      storeName: storeName,
    );
    await _refreshNotifications();
    return results;
  }

  Future<int> importReceiptItems({
    required String? storeName,
    required List<ReceiptImportItem> items,
  }) async {
    final settings = await _ref.read(settingsProvider.future);
    final products = await _repository.watchProductsOnce();
    final remaining = settings.isPro
        ? 1 << 20
        : (settings.unlockedHiveCells - products.length).clamp(0, 1 << 20);
    final count = await _repository.importReceiptItems(
      storeName: storeName,
      items: items,
      remainingNewProductSlots: remaining,
    );
    await _refreshNotifications();
    return count;
  }

  Future<void> addToCart({
    required String productId,
    double quantity = 1,
  }) async {
    await _repository.addToCart(productId: productId, quantity: quantity);
    await _ref.read(settingsActionsProvider).dismissReminder(productId);
  }

  Future<void> addNamedItemToCart(String name, {double quantity = 1}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    await _repository.addNamedItemToCart(trimmed, quantity: quantity);
  }

  Future<List<CartCompleteResult>> buildHiveFromCart({
    required List<domain.CartItem> items,
    String? storeName,
  }) async {
    if (items.isEmpty) {
      return const [];
    }

    final settings = await _ref.read(settingsProvider.future);
    final products = await _repository.watchProductsOnce();
    final needed = newHiveCellsNeededForCart(items: items, products: products);
    if (!canFitNewHiveProducts(
      isPro: settings.isPro,
      unlockedHiveCells: settings.unlockedHiveCells,
      productCount: products.length,
      newCount: needed,
    )) {
      throw const HiveCapacityException();
    }

    final resolved = <domain.CartItem>[];
    for (final item in items) {
      var productId = item.productId;
      final existingProduct = productId == null
          ? null
          : await _repository.getProductById(productId);
      if (existingProduct == null) {
        final name = item.label(existingProduct?.name);
        final matched = await _repository.findActiveProductByName(name);
        if (matched != null) {
          productId = matched.id;
        } else {
          productId = await _repository.addProduct(quickCartProductForm(name));
        }
      }
      resolved.add(
        domain.CartItem(
          id: item.id,
          productId: productId,
          pendingName: item.pendingName,
          quantity: item.quantity,
          addedAt: item.addedAt,
          preferredStoreName: item.preferredStoreName,
          note: item.note,
        ),
      );
    }

    final results = await _repository.completeCartItems(
      resolved,
      storeName: storeName,
    );
    await _refreshNotifications();
    return results;
  }

  Future<void> updateCartQuantity({
    required String cartItemId,
    required double quantity,
  }) async {
    await _repository.updateCartQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );
  }

  Future<void> removeCartItem(String cartItemId) async {
    await _repository.removeCartItem(cartItemId);
  }

  Future<void> scheduleLocalReminders() => _refreshNotifications();

  Future<void> refreshData() async {
    _ref.invalidate(cartStoreContextProvider);
    await _refreshNotifications();
  }
}

final inventoryActionsProvider = Provider<InventoryActions>((ref) {
  return InventoryActions(ref);
});
