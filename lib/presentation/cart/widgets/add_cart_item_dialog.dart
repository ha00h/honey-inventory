import 'package:flutter/material.dart';

Future<String?> showAddCartItemDialog({required BuildContext context}) {
  final controller = TextEditingController();

  return showDialog<String?>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('장바구니에 담기'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            final name = value.trim();
            Navigator.of(dialogContext).pop(name.isEmpty ? null : name);
          },
          decoration: const InputDecoration(
            labelText: '물품 이름',
            hintText: '예: 휴지',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              Navigator.of(dialogContext).pop(name.isEmpty ? null : name);
            },
            child: const Text('담기'),
          ),
        ],
      );
    },
  );
}
