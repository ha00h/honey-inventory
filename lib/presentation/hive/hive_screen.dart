import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/inventory_models.dart';
import '../../domain/services/hive_economy.dart';
import '../../domain/services/inventory_services.dart';
import '../shared/providers/hive_economy_providers.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/providers/settings_providers.dart';
import '../receipt/receipt_image_picker.dart';
import '../shared/widgets/bee_mascot_overlay.dart';
import '../shared/widgets/brand_art.dart';
import 'hive_capacity_dialog.dart';
import 'widgets/hexagon_grid.dart';
import 'widgets/hive_lens.dart';

class HiveScreen extends ConsumerWidget {
  const HiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider);
    final productsValue = ref.watch(productsProvider);
    final remindersValue = ref.watch(unacknowledgedRemindersProvider);
    final cyclesValue = ref.watch(cyclesProvider);
    final products = productsValue.maybeWhen(
      data: (items) => items,
      orElse: () => const <Product>[],
    );
    final cycleDueProductIds = {
      for (final cycle in cyclesValue.maybeWhen(
        data: (items) => items,
        orElse: () => const <PurchaseCycle>[],
      ))
        if (isPurchaseCycleDue(cycle)) cycle.productId,
    };
    final lowStockNames = products
        .where((product) => product.isLowStock)
        .map((product) => product.name)
        .take(2)
        .join(', ');
    final reminderCount = remindersValue.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );
    final overlayReminders = remindersValue.maybeWhen(
      data: (items) => items,
      orElse: () => const <ReminderItem>[],
    );
    final settings = ref
        .watch(settingsProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    ref.listen(productsProvider, (previous, next) {
      next.whenData((items) {
        ref
            .read(hiveEconomyActionsProvider)
            .ensureCapacityForExistingProducts(items.length);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('허니 인벤토리'),
        actions: [
          IconButton(
            onPressed: () => _startReceiptScan(context),
            icon: const Icon(Icons.document_scanner_outlined),
            tooltip: '영수증 스캔',
          ),
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: Badge(
              isLabelVisible: reminderCount > 0,
              label: Text('$reminderCount'),
              child: const Icon(Icons.notifications_none_rounded),
            ),
            tooltip: '알림',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.beeYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const BrandImage.bee(size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminderCount > 0
                                ? '지금 확인할 알림이 $reminderCount개 있어요'
                                : products.isEmpty
                                ? '빈 벌집을 채워보세요'
                                : '벌집이 잘 채워지고 있어요',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.onHoneyPrimary,
                                  fontSize: 15,
                                  height: 1.2,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lowStockNames.isNotEmpty
                                ? '$lowStockNames 재고를 먼저 확인해보세요.'
                                : products.isEmpty
                                ? '빈 칸을 누르면 가운데부터 꿀이 쌓여요.'
                                : '벌집을 드래그해 둘러보고, 오래 누르면 자리를 옮길 수 있어요.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.onHoneySecondary,
                                  fontSize: 12,
                                  height: 1.25,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _HiveEconomyChip(productCount: products.length),
                  ],
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.15),
                      radius: 0.95,
                      colors: [Color(0xFFFFF6DC), AppColors.warmCream],
                    ),
                  ),
                  child: startup.when(
                    data: (_) {
                      return productsValue.when(
                        data: (products) {
                          return HiveLens(
                            child: HexagonGrid(
                              products: products,
                              cycleDueProductIds: cycleDueProductIds,
                              unlockedCells:
                                  settings?.unlockedHiveCells ?? freeHiveCells,
                              isPro: settings?.isPro ?? false,
                              onProductTap: (product) =>
                                  context.push('/product/${product.id}'),
                              onMoveProduct: (fromSlot, toSlot) {
                                ref
                                    .read(inventoryActionsProvider)
                                    .moveHiveProduct(
                                      fromSlot: fromSlot,
                                      toSlot: toSlot,
                                    );
                              },
                              onEmptyCellTap: () async {
                                if (settings != null &&
                                    !canAddHiveProduct(
                                      isPro: settings.isPro,
                                      unlockedHiveCells:
                                          settings.unlockedHiveCells,
                                      productCount: products.length,
                                    )) {
                                  await showHiveCapacityDialog(context);
                                  return;
                                }
                                if (context.mounted) {
                                  context.push('/product/new');
                                }
                              },
                              onLockedCellTap: () => context.push('/hive/shop'),
                            ),
                          );
                        },
                        error: (error, stackTrace) => ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 120),
                            Center(child: Text('벌집을 불러오지 못했어요: $error')),
                          ],
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    },
                    error: (error, stackTrace) =>
                        Center(child: Text('초기화에 실패했어요: $error')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
          BeeMascotOverlay(
            reminders: overlayReminders,
            onViewAll: () => context.push('/notifications'),
            onAddToCart: () async {
              final first = overlayReminders.first;
              await ref
                  .read(inventoryActionsProvider)
                  .addToCart(productId: first.productId);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('장바구니에 담았어요.')));
              }
            },
            onDismiss: () async {
              final settings = ref.read(settingsActionsProvider);
              for (final item in overlayReminders) {
                await settings.dismissReminder(item.productId);
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _startReceiptScan(BuildContext context) async {
  final imagePath = await pickReceiptImageSource(context);
  if (imagePath == null || !context.mounted) {
    return;
  }
  await context.push('/receipt/scan?path=${Uri.encodeComponent(imagePath)}');
}

class _HiveEconomyChip extends ConsumerWidget {
  const _HiveEconomyChip({required this.productCount});

  final int productCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref
        .watch(settingsProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    final isPro = settings?.isPro ?? false;
    final points = settings?.honeyPoints ?? 0;
    final limit = settings?.unlockedHiveCells ?? freeHiveCells;
    return ActionChip(
      visualDensity: VisualDensity.compact,
      avatar: isPro
          ? const Icon(
              Icons.workspace_premium_rounded,
              size: 18,
              color: AppColors.onHoneyPrimary,
            )
          : const BrandImage.honey(size: 18),
      label: Text(
        isPro ? '프로' : '$productCount/$limit · ${honeyLabel(points)}',
        style: const TextStyle(
          color: AppColors.onHoneyPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
      backgroundColor: const Color(0xFFFFFBF0),
      side: const BorderSide(color: AppColors.honeyGold),
      onPressed: () => context.push('/hive/shop'),
    );
  }
}
