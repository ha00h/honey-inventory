import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showHiveCapacityDialog(BuildContext context) async {
  final goShop = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('벌집 칸이 가득 찼어요'),
      content: const Text(
        '출석이나 광고로 꿀을 모아 칸을 늘리거나, 프로로 무제한 확장할 수 있어요.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('닫기'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('상점'),
        ),
      ],
    ),
  );
  if (goShop == true && context.mounted) {
    await context.push('/hive/shop');
  }
}
