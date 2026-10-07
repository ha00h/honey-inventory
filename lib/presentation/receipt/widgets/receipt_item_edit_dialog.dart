import 'package:flutter/material.dart';

import '../../../domain/entities/receipt_models.dart';

class ReceiptItemEditResult {
  const ReceiptItemEditResult({required this.name, required this.quantity});

  final String name;
  final double quantity;
}

Future<ReceiptItemEditResult?> showReceiptItemEditDialog({
  required BuildContext context,
  required ReceiptLineItem item,
}) {
  final nameController = TextEditingController(text: item.name);
  final quantityController = TextEditingController(
    text: item.quantity % 1 == 0
        ? item.quantity.toInt().toString()
        : item.quantity.toString(),
  );

  return showDialog<ReceiptItemEditResult>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('품목 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '품목명',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '수량',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final name = nameController.text.trim();
            final quantity = double.tryParse(quantityController.text.trim());
            if (name.isEmpty || quantity == null || quantity <= 0) {
              return;
            }
            Navigator.of(
              dialogContext,
            ).pop(ReceiptItemEditResult(name: name, quantity: quantity));
          },
          child: const Text('저장'),
        ),
      ],
    ),
  );
}
