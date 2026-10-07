import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/inventory_models.dart';
import '../../domain/services/inventory_services.dart';
import '../shared/icon_catalog.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/system_insets.dart';
import '../shared/widgets/purchase_cycle_editor.dart';
import 'widgets/stock_history_ledger.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.id, super.key});

  final String id;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  HistoryLedgerFilter _historyFilter = HistoryLedgerFilter.all;
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productValue = ref.watch(productDetailProvider(widget.id));
    final liveProduct = ref
        .watch(productsProvider)
        .maybeWhen(
          data: (items) {
            for (final item in items) {
              if (item.id == widget.id) {
                return item;
              }
            }
            return null;
          },
          orElse: () => null,
        );
    final cycleValue = ref.watch(productCycleProvider(widget.id));
    final historyValue = ref.watch(stockHistoryProvider(widget.id));
    final recordValue = ref.watch(purchaseRecordsProvider(widget.id));
    final cycle = cycleValue.maybeWhen(
      data: (value) => value,
      orElse: () => null,
    );

    return productValue.when(
      data: (loaded) {
        final product = liveProduct ?? loaded;
        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('물품 상세')),
            body: const Center(child: Text('물품을 찾을 수 없어요.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('물품 상세'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    await context.push('/product/${product.id}/edit');
                  } else if (value == 'delete') {
                    await _confirmDelete(product);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('수정')),
                  PopupMenuItem(value: 'delete', child: Text('삭제')),
                ],
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DetailHeader(product: product, cycle: cycle),
                    const SizedBox(height: 10),
                    _StockSummary(product: product),
                    const SizedBox(height: 10),
                    _StockAdjustSection(product: product),
                  ],
                ),
              ),
              TabBar(
                controller: _tabs,
                labelPadding: EdgeInsets.zero,
                tabs: const [
                  Tab(text: '이력', height: 42),
                  Tab(text: '주기', height: 42),
                  Tab(text: '구매', height: 42),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                      child: historyValue.when(
                        data: (histories) => StockHistoryLedger(
                          histories: histories,
                          filter: _historyFilter,
                          showTitle: false,
                          onFilterChanged: (value) =>
                              setState(() => _historyFilter = value),
                        ),
                        error: (error, stackTrace) =>
                            Center(child: Text('이력을 불러오지 못했어요: $error')),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    _CycleTab(product: product, cycle: cycle),
                    _PurchaseTab(records: recordValue),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SizedBox(height: systemBottomInset(context)),
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('물품 상세')),
        body: Center(child: Text('물품을 불러오지 못했어요: $error')),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('물품 상세')),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('물품 삭제'),
        content: Text('${product.name}을(를) 벌집에서 제거할까요?\n이력은 유지됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(inventoryActionsProvider).deleteProduct(product.id);
      if (mounted) {
        context.pop();
      }
    }
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.product, required this.cycle});

  final Product product;
  final PurchaseCycle? cycle;

  @override
  Widget build(BuildContext context) {
    final color = parseIconColor(product.iconColor);
    final category = product.category == null
        ? '기타'
        : categoryLabels[product.category] ?? product.category!.label;
    final cycleDue = isPurchaseCycleDue(cycle);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Icon(
                iconForKey(product.iconKey),
                color: contrastOnColor(color),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '$category · ${product.unit}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (product.isLowStock || cycleDue) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (product.isLowStock)
                const _AlertBadge(
                  icon: Icons.warning_rounded,
                  label: '재고 부족',
                  color: AppColors.honeyLowStock,
                ),
              if (cycleDue)
                const _AlertBadge(
                  icon: Icons.event_repeat_rounded,
                  label: '구매 주기 지남',
                  color: AppColors.honeyCycleDue,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StockSummary extends StatelessWidget {
  const _StockSummary({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _StockStat(
                label: '현재',
                value: '${_formatStock(product.currentStock)} ${product.unit}',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StockStat(
                label: '최소',
                value: _formatStock(product.minStock),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StockStat(
                label: '최대',
                value: _formatStock(product.maxStock),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: stockFillRatio(product),
          minHeight: 8,
          borderRadius: BorderRadius.circular(999),
          backgroundColor: AppColors.emptyCell,
          color: product.isLowStock ? AppColors.lowStock : AppColors.honeyGold,
        ),
      ],
    );
  }
}

class _StockStat extends StatelessWidget {
  const _StockStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _StockAdjustSection extends ConsumerStatefulWidget {
  const _StockAdjustSection({required this.product});

  final Product product;

  @override
  ConsumerState<_StockAdjustSection> createState() =>
      _StockAdjustSectionState();
}

class _StockAdjustSectionState extends ConsumerState<_StockAdjustSection> {
  bool _busy = false;
  late final TextEditingController _directController;
  late final FocusNode _directFocus;

  @override
  void initState() {
    super.initState();
    _directController = TextEditingController(
      text: _formatStock(widget.product.currentStock),
    );
    _directFocus = FocusNode()..addListener(_onDirectFocusChange);
  }

  @override
  void didUpdateWidget(covariant _StockAdjustSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.currentStock != widget.product.currentStock &&
        !_directFocus.hasFocus) {
      _directController.text = _formatStock(widget.product.currentStock);
    }
  }

  @override
  void dispose() {
    _directFocus
      ..removeListener(_onDirectFocusChange)
      ..dispose();
    _directController.dispose();
    super.dispose();
  }

  void _onDirectFocusChange() {
    if (_directFocus.hasFocus || _busy) {
      return;
    }
    _applyDirectStock(_directController.text);
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _adjust({
    required double delta,
    required StockChangeReason reason,
  }) {
    return _run(
      () => ref
          .read(inventoryActionsProvider)
          .adjustStock(product: widget.product, delta: delta, reason: reason),
    );
  }

  Future<void> _setStock({
    required double targetStock,
    required StockChangeReason reason,
  }) {
    return _run(
      () => ref
          .read(inventoryActionsProvider)
          .setStock(
            product: widget.product,
            targetStock: targetStock,
            reason: reason,
          ),
    );
  }

  Future<void> _discardAll() async {
    if (widget.product.currentStock <= 0) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전량 폐기'),
        content: Text(
          '${widget.product.name} 재고 '
          '${_formatStock(widget.product.currentStock)} '
          '${widget.product.unit}을(를) 모두 폐기할까요?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('폐기'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _setStock(targetStock: 0, reason: StockChangeReason.discard);
    }
  }

  Future<void> _applyDirectStock(String raw) async {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      _directController.text = _formatStock(widget.product.currentStock);
      return;
    }
    final value = double.tryParse(trimmed);
    if (value == null || value < 0) {
      _directController.text = _formatStock(widget.product.currentStock);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('0 이상의 숫자를 입력해주세요.')));
      }
      return;
    }
    if (value == widget.product.currentStock) {
      _directController.text = _formatStock(value);
      return;
    }
    await _setStock(targetStock: value, reason: StockChangeReason.adjust);
  }

  Future<void> _addToCart() async {
    await _run(() async {
      await ref
          .read(inventoryActionsProvider)
          .addToCart(productId: widget.product.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('장바구니에 담았어요.')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final canDecrease = !_busy && product.currentStock > 0;
    final canFillToMin = !_busy && product.currentStock < product.minStock;
    final canFillToMax = !_busy && product.currentStock < product.maxStock;
    final canTap = !_busy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _StockActionButton(
                label: '사용 -1',
                onPressed: canDecrease
                    ? () => _adjust(delta: -1, reason: StockChangeReason.usage)
                    : null,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _StockActionButton(
                label: '폐기 -1',
                onPressed: canDecrease
                    ? () =>
                          _adjust(delta: -1, reason: StockChangeReason.discard)
                    : null,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _StockActionButton(
                label: '전량폐기',
                tone: _StockActionTone.danger,
                onPressed: canDecrease ? _discardAll : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _StockActionButton(
                label: '조정 +1',
                onPressed: canTap
                    ? () => _adjust(delta: 1, reason: StockChangeReason.adjust)
                    : null,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _StockActionButton(
                label: '조정 최소량까지',
                onPressed: canFillToMin
                    ? () => _setStock(
                        targetStock: product.minStock,
                        reason: StockChangeReason.adjust,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _StockActionButton(
                label: '구매 최대량',
                onPressed: canFillToMax
                    ? () => _setStock(
                        targetStock: product.maxStock,
                        reason: StockChangeReason.purchase,
                      )
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Semantics(
                textField: true,
                label: '재고 직접 입력',
                child: TextField(
                  controller: _directController,
                  focusNode: _directFocus,
                  enabled: canTap,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onHoneyPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '직접',
                    suffixText: product.unit,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: AppColors.honeyGold,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: AppColors.honeyAmber,
                        width: 1.5,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppColors.honeyGold.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                  ),
                  onTapOutside: (_) => _directFocus.unfocus(),
                  onSubmitted: (_) => _directFocus.unfocus(),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _StockActionButton(
                label: '담기',
                tone: _StockActionTone.emphasis,
                onPressed: canTap ? _addToCart : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum _StockActionTone { normal, danger, emphasis }

class _StockActionButton extends StatelessWidget {
  const _StockActionButton({
    required this.label,
    required this.onPressed,
    this.tone = _StockActionTone.normal,
  });

  final String label;
  final VoidCallback? onPressed;
  final _StockActionTone tone;

  @override
  Widget build(BuildContext context) {
    final child = Text(
      label,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    final style = ButtonStyle(
      visualDensity: VisualDensity.compact,
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      ),
      textStyle: WidgetStatePropertyAll(
        Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.15,
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: switch (tone) {
        _StockActionTone.emphasis => FilledButton(
          onPressed: onPressed,
          style: style,
          child: child,
        ),
        _StockActionTone.danger => OutlinedButton(
          onPressed: onPressed,
          style: style.copyWith(
            foregroundColor: const WidgetStatePropertyAll(
              AppColors.honeyLowStockDeep,
            ),
            side: const WidgetStatePropertyAll(
              BorderSide(color: AppColors.honeyLowStock, width: 1.5),
            ),
          ),
          child: child,
        ),
        _StockActionTone.normal => OutlinedButton(
          onPressed: onPressed,
          style: style.copyWith(
            foregroundColor: const WidgetStatePropertyAll(
              AppColors.onHoneyPrimary,
            ),
            side: const WidgetStatePropertyAll(
              BorderSide(color: AppColors.honeyGold, width: 1.5),
            ),
          ),
          child: child,
        ),
      },
    );
  }
}

class _CycleTab extends ConsumerWidget {
  const _CycleTab({required this.product, required this.cycle});

  final Product product;
  final PurchaseCycle? cycle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        if (cycle != null && cycle!.isEnabled)
          Text('현재 ${cycle!.intervalDays}일 주기로 관리 중이에요.')
        else
          const Text('구매 주기를 설정하면 적절한 시점에 알려드려요.'),
        if (cycle?.nextReminderDate case final nextDate?)
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 8),
            child: Text(
              '다음 알림 예정: ${_dateText(nextDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          const SizedBox(height: 8),
        PurchaseCycleEditor(
          productId: product.id,
          cycle: cycle,
          onSave:
              ({
                required intervalDays,
                required isEnabled,
                required lastPurchaseDate,
              }) async {
                await ref
                    .read(inventoryActionsProvider)
                    .updatePurchaseCycle(
                      productId: product.id,
                      intervalDays: intervalDays,
                      isEnabled: isEnabled,
                      lastPurchaseDate: lastPurchaseDate,
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('구매 주기를 저장했어요.')),
                  );
                }
              },
        ),
      ],
    );
  }
}

class _PurchaseTab extends StatelessWidget {
  const _PurchaseTab({required this.records});

  final AsyncValue<List<PurchaseRecord>> records;

  @override
  Widget build(BuildContext context) {
    return records.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('아직 구매 이력이 없어요.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${_formatStock(item.quantity)} 구매'),
              subtitle: Text(item.storeName ?? '구매처 미정'),
              trailing: Text(_dateText(item.purchasedAt)),
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 1),
        );
      },
      error: (error, stackTrace) =>
          Center(child: Text('구매 이력을 불러오지 못했어요: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

String _formatStock(double value) {
  return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
}

String _dateText(DateTime date) {
  return '${date.month}/${date.day}';
}
