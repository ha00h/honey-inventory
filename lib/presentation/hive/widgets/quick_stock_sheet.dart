import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/inventory_models.dart';
import '../../shared/providers/inventory_providers.dart';
import '../../shared/providers/repository_providers.dart';
import '../../shared/widgets/stock_reason_selector.dart';

Future<void> showQuickStockSheet({
  required BuildContext context,
  required Product product,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _QuickStockSheet(product: product),
  );
}

class _QuickStockSheet extends ConsumerStatefulWidget {
  const _QuickStockSheet({required this.product});

  final Product product;

  @override
  ConsumerState<_QuickStockSheet> createState() => _QuickStockSheetState();
}

class _QuickStockSheetState extends ConsumerState<_QuickStockSheet> {
  late Product _product;
  bool _adjusting = false;
  bool _addingToCart = false;
  StockChangeReason _negativeReason = StockChangeReason.usage;
  StockChangeReason _positiveReason = StockChangeReason.adjust;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  Future<void> _adjust(double delta) async {
    if (_adjusting) {
      return;
    }

    setState(() => _adjusting = true);
    final reason = delta < 0 ? _negativeReason : _positiveReason;

    await ref
        .read(inventoryActionsProvider)
        .adjustStock(product: _product, delta: delta, reason: reason);

    final updated = await ref
        .read(inventoryRepositoryProvider)
        .getProductById(_product.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _adjusting = false;
      if (updated != null) {
        _product = updated;
      }
    });
  }

  Future<void> _addToCart() async {
    if (_addingToCart) {
      return;
    }

    setState(() => _addingToCart = true);
    await ref.read(inventoryActionsProvider).addToCart(productId: _product.id);

    if (!mounted) {
      return;
    }

    setState(() => _addingToCart = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${_product.name}을(를) 장바구니에 담았어요.')));
    Navigator.of(context).pop();
  }

  String _formatStock(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _product.name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '현재 ${_formatStock(_product.currentStock)} ${_product.unit}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text('줄일 때', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            StockReasonSelector(
              selected: _negativeReason,
              options: const [
                StockChangeReason.usage,
                StockChangeReason.discard,
              ],
              onChanged: (reason) => setState(() => _negativeReason = reason),
            ),
            const SizedBox(height: 12),
            Text('늘릴 때', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            StockReasonSelector(
              selected: _positiveReason,
              options: const [
                StockChangeReason.adjust,
                StockChangeReason.purchase,
              ],
              onChanged: (reason) => setState(() => _positiveReason = reason),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _AdjustChip(label: '-5', onPressed: () => _adjust(-5)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _AdjustChip(label: '-1', onPressed: () => _adjust(-1)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _AdjustChip(label: '+1', onPressed: () => _adjust(1)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _AdjustChip(label: '+5', onPressed: () => _adjust(5)),
                ),
              ],
            ),
            if (_adjusting) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _addingToCart ? null : _addToCart,
              icon: _addingToCart
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.shopping_basket_rounded),
              label: Text(_addingToCart ? '담는 중...' : '장바구니에 담기'),
            ),
            const SizedBox(height: 8),
            Text(
              '길게 눌러 재고를 조정하거나 장바구니에 담을 수 있어요.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdjustChip extends StatelessWidget {
  const _AdjustChip({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}
