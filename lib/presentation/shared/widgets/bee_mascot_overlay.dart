import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/inventory_models.dart';
import 'brand_art.dart';

class BeeMascotOverlay extends StatelessWidget {
  const BeeMascotOverlay({
    required this.reminders,
    required this.onViewAll,
    required this.onAddToCart,
    required this.onDismiss,
    super.key,
  });

  final List<ReminderItem> reminders;
  final VoidCallback onViewAll;
  final VoidCallback onAddToCart;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) {
      return const SizedBox.shrink();
    }

    final first = reminders.first;
    final extra = reminders.length - 1;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 88,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        color: AppColors.beeYellow,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandImage.bee(size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '꿀벌이 알려드려요!',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColors.onHoneyPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          first.message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.onHoneySecondary),
                        ),
                        if (extra > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '외 $extra개 알림이 더 있어요.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.onHoneySecondary,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDismiss,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.onHoneyPrimary,
                    ),
                    tooltip: '닫기',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text(
                      '전체 보기',
                      style: TextStyle(color: AppColors.onHoneyPrimary),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: onAddToCart,
                    child: const Text('장바구니 담기'),
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
