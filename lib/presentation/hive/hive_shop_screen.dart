import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/services/hive_economy.dart';
import '../../services/ads/rewarded_ad_service.dart';
import '../shared/providers/hive_economy_providers.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/providers/settings_providers.dart';
import '../shared/system_insets.dart';
import '../shared/widgets/brand_art.dart';

class HiveShopScreen extends ConsumerWidget {
  const HiveShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsValue = ref.watch(settingsProvider);
    final productCount = ref.watch(productsProvider).maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('벌집 상점')),
      body: settingsValue.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _StatusCard(settings: settings, productCount: productCount),
            const SizedBox(height: 16),
            Text('꿀 모으기', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _AttendanceCard(settings: settings),
            const SizedBox(height: 8),
            _AdCard(settings: settings),
            const SizedBox(height: 16),
            Text('칸 늘리기', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final pack in hiveCellPacks) ...[
              _PackCard(settings: settings, pack: pack),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            Text('프로', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _ProCard(settings: settings),
            if (!settings.isPro) ...[
              const SizedBox(height: 20),
              const _BannerPlaceholder(),
            ],
          ],
        ),
        error: (error, stackTrace) =>
            Center(child: Text('상점을 불러오지 못했어요: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SizedBox(height: systemBottomInset(context)),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.settings, required this.productCount});

  final AppSettings settings;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    final limitLabel = settings.isPro ? '무제한' : '${settings.unlockedHiveCells}칸';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.beeYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const BrandImage.honey(size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings.isPro ? '프로로 확장된 벌집' : '무료 $freeHiveCells칸부터 시작',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onHoneyPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '사용 $productCount / $limitLabel · ${honeyLabel(settings.honeyPoints)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onHoneySecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceCard extends ConsumerWidget {
  const _AttendanceCard({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = canClaimAttendance(settings.lastAttendanceDate);
    return _ActionTile(
      leading: const BrandImage.honey(size: 26),
      title: '오늘 출석',
      subtitle: available
          ? '+${honeyLabel(attendanceHoney)}'
          : '내일 다시 받을 수 있어요',
      actionLabel: available ? '받기' : '완료',
      enabled: available,
      onPressed: available
          ? () async {
              await ref.read(hiveEconomyActionsProvider).claimAttendance();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('출석 꿀을 받았어요.')),
                );
              }
            }
          : null,
    );
  }
}

class _AdCard extends ConsumerWidget {
  const _AdCard({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = adsRemainingToday(
      isPro: settings.isPro,
      lastAdWatchDate: settings.lastAdWatchDate,
      adsWatchedToday: settings.adsWatchedToday,
    );
    final enabled = remaining > 0;
    return _ActionTile(
      leading: const BrandImage.honey(size: 26),
      title: '광고 보고 꿀 받기',
      subtitle: settings.isPro
          ? '프로는 광고가 없어요'
          : enabled
          ? '+${honeyLabel(rewardedAdHoney)} · 오늘 $remaining회 남음'
          : '오늘은 더 볼 수 없어요',
      actionLabel: '보기',
      enabled: enabled,
      onPressed: enabled
          ? () async {
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(
                const SnackBar(content: Text('광고를 불러오는 중…')),
              );
              final result = await ref
                  .read(rewardedAdServiceProvider)
                  .show();
              if (!context.mounted) {
                return;
              }
              messenger.hideCurrentSnackBar();
              switch (result) {
                case RewardedAdShowResult.rewarded:
                  await ref
                      .read(hiveEconomyActionsProvider)
                      .collectRewardedAd();
                  if (context.mounted) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('광고 꿀을 받았어요.')),
                    );
                  }
                case RewardedAdShowResult.dismissed:
                  messenger.showSnackBar(
                    const SnackBar(content: Text('광고를 끝까지 봐야 꿀을 받을 수 있어요.')),
                  );
                case RewardedAdShowResult.failedToLoad:
                case RewardedAdShowResult.failedToShow:
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('지금은 광고를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'),
                    ),
                  );
              }
            }
          : null,
    );
  }
}

class _PackCard extends ConsumerWidget {
  const _PackCard({required this.settings, required this.pack});

  final AppSettings settings;
  final HiveCellPack pack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canBuy = !settings.isPro && settings.honeyPoints >= pack.honey;
    return _ActionTile(
      leading: const BrandImage.honey(size: 26),
      title: '${pack.cells}칸 구매',
      subtitle: settings.isPro
          ? '프로는 칸이 무제한이에요'
          : honeyLabel(pack.honey),
      actionLabel: '구매',
      enabled: canBuy,
      onPressed: canBuy
          ? () async {
              try {
                await ref.read(hiveEconomyActionsProvider).buyCellPack(pack);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${pack.cells}칸을 열었어요.')),
                  );
                }
              } on HiveHoneyShortException {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('꿀이 부족해요.')),
                  );
                }
              }
            }
          : null,
    );
  }
}

class _ProCard extends ConsumerWidget {
  const _ProCard({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium_rounded, color: AppColors.honeyAmber),
                const SizedBox(width: 8),
                Text(
                  '허니 프로',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('벌집 칸 무제한 · 광고 없음'),
            const SizedBox(height: 4),
            Text(
              '가격은 곧 안내할 예정이에요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onHoneySecondary,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () async {
                  await ref
                      .read(hiveEconomyActionsProvider)
                      .setProPreview(!settings.isPro);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          settings.isPro
                              ? '프로 미리보기를 껐어요.'
                              : '프로 미리보기를 켰어요. 가격은 나중에 정해져요.',
                        ),
                      ),
                    );
                  }
                },
                child: Text(settings.isPro ? '미리보기 끄기' : '미리보기로 켜기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.enabled,
    required this.leading,
    this.onPressed,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String actionLabel;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: enabled ? onPressed : null,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEFE6D4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.hexBorder),
      ),
      child: const SizedBox(
        height: 56,
        child: Center(
          child: Text(
            '광고 영역 · 프로면 사라져요',
            style: TextStyle(color: AppColors.onHoneySecondary),
          ),
        ),
      ),
    );
  }
}

