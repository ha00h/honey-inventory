import 'package:flutter/material.dart';

import '../../../domain/entities/inventory_models.dart';
import 'stock_reason_selector.dart';

class StockDirectInputResult {
  const StockDirectInputResult({
    required this.targetStock,
    required this.reason,
  });

  final double targetStock;
  final StockChangeReason reason;
}

Future<StockDirectInputResult?> showStockDirectInputDialog({
  required BuildContext context,
  required Product product,
}) {
  return showDialog<StockDirectInputResult>(
    context: context,
    builder: (context) => _StockDirectInputDialog(product: product),
  );
}

class _StockDirectInputDialog extends StatefulWidget {
  const _StockDirectInputDialog({required this.product});

  final Product product;

  @override
  State<_StockDirectInputDialog> createState() =>
      _StockDirectInputDialogState();
}

class _StockDirectInputDialogState extends State<_StockDirectInputDialog> {
  late final TextEditingController _controller;
  StockChangeReason _reason = StockChangeReason.adjust;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _format(widget.product.currentStock),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('재고 직접 입력'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '현재: ${_format(widget.product.currentStock)} ${widget.product.unit}',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: '변경할 재고',
              suffixText: widget.product.unit,
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          Text('사유', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          StockReasonSelector(
            selected: _reason,
            options: const [
              StockChangeReason.usage,
              StockChangeReason.discard,
              StockChangeReason.adjust,
              StockChangeReason.purchase,
            ],
            onChanged: (reason) => setState(() => _reason = reason),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final value = double.tryParse(_controller.text.trim());
            if (value == null || value < 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('0 이상의 숫자를 입력해주세요.')),
              );
              return;
            }
            Navigator.of(
              context,
            ).pop(StockDirectInputResult(targetStock: value, reason: _reason));
          },
          child: const Text('적용'),
        ),
      ],
    );
  }

  String _format(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }
}
