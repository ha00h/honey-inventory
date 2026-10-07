import 'package:flutter/material.dart';

import '../../../domain/entities/cart_complete_result.dart';

Future<bool?> showMaxStockSuggestionDialog({
  required BuildContext context,
  required MaxStockSuggestion suggestion,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('최대 재고 조정'),
      content: Text(
        '${suggestion.productName} 재고가 최대치(${_format(suggestion.previousMaxStock)})를 넘었어요.\n'
        '최대 재고를 ${_format(suggestion.suggestedMaxStock)}으로 올릴까요?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('유지'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('올리기'),
        ),
      ],
    ),
  );
}

String _format(double value) {
  return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
}
