import 'package:flutter/material.dart';

Future<String?> showBulkCompleteStoreDialog({
  required BuildContext context,
  required int itemCount,
}) {
  final controller = TextEditingController();

  return showDialog<String?>(
    context: context,
    builder: (dialogContext) => AlertDialog(
        title: const Text('벌집 만들기'),
        content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$itemCount개 물품을 벌집에 넣을게요.'),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '구매처 (선택)',
              hintText: '예: 이마트',
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
            final storeName = controller.text.trim();
            Navigator.of(dialogContext).pop(storeName.isEmpty ? '' : storeName);
          },
          child: const Text('넣기'),
        ),
      ],
    ),
  );
}
