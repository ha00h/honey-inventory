import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/inventory_models.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/providers/settings_providers.dart';
import '../shared/widgets/brand_art.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersValue = ref.watch(unacknowledgedRemindersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('알림')),
      body: remindersValue.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrandImage.bee(size: 88),
                  SizedBox(height: 16),
                  Text('지금은 확인할 알림이 없어요.'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return _NotificationCard(
                item: item,
                onTap: () => context.push('/product/${item.productId}'),
                onAddToCart: () async {
                  await ref
                      .read(inventoryActionsProvider)
                      .addToCart(productId: item.productId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('장바구니에 담았어요.')));
                  }
                },
                onSnooze: () async {
                  await ref
                      .read(settingsActionsProvider)
                      .snoozeReminder(item.productId);
                  await ref
                      .read(settingsActionsProvider)
                      .dismissReminder(item.productId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('3일 뒤에 다시 알려드릴게요.')),
                    );
                  }
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: items.length,
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text('알림을 불러오지 못했어요: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onTap,
    required this.onAddToCart,
    required this.onSnooze,
  });

  final ReminderItem item;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback onSnooze;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${item.productName} 알림: ${item.message}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: onTap,
                minVerticalPadding: 12,
                leading: const BrandImage.bee(size: 32),
                title: Text(item.message),
                subtitle: Text(item.productName),
              ),
              Row(
                children: [
                  Semantics(
                    button: true,
                    label: '${item.productName} 나중에 알림',
                    child: TextButton(
                      onPressed: onSnooze,
                      child: const Text('나중에'),
                    ),
                  ),
                  const Spacer(),
                  Semantics(
                    button: true,
                    label: '${item.productName} 장바구니에 담기',
                    child: FilledButton(
                      onPressed: onAddToCart,
                      child: const Text('담기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
