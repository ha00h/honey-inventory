import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/backup_repository.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/services/hive_economy.dart';
import '../shared/providers/backup_providers.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/providers/settings_providers.dart';
import '../shared/widgets/brand_art.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsValue = ref.watch(settingsProvider);
    final permissionValue = ref.watch(notificationPermissionProvider);
    final syncStatus = ref.watch(syncServiceProvider).getStatus();

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: settingsValue.when(
        data: (settings) => ListView(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: const Text('알림 받기'),
              subtitle: Text(settings.notificationsEnabled ? '켜짐' : '꺼짐'),
              value: settings.notificationsEnabled,
              onChanged: (value) async {
                await ref
                    .read(settingsActionsProvider)
                    .setNotificationsEnabled(value);
                if (!context.mounted) {
                  return;
                }
                if (value) {
                  final granted = await ref.read(
                    notificationPermissionProvider.future,
                  );
                  if (!context.mounted) {
                    return;
                  }
                  if (!granted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('알림 권한이 필요해요. 아래에서 허용해주세요.'),
                      ),
                    );
                  }
                }
              },
            ),
            permissionValue.when(
              data: (granted) {
                if (granted) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  leading: const Icon(Icons.notification_important_outlined),
                  title: const Text('알림 권한 허용'),
                  subtitle: const Text('기기에서 알림을 받으려면 권한이 필요해요.'),
                  trailing: FilledButton.tonal(
                    onPressed: () async {
                      final success = await ref
                          .read(settingsActionsProvider)
                          .requestNotificationPermission();
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? '알림 권한이 허용되었어요.'
                                : '알림 권한이 거부되었어요. 기기 설정에서 허용해주세요.',
                          ),
                        ),
                      );
                    },
                    child: const Text('허용'),
                  ),
                );
              },
              error: (_, _) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_rounded),
              title: const Text('알림 시간'),
              subtitle: Text(_formatTime(settings.notificationTime)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: settings.notificationTime,
                );
                if (picked != null) {
                  await ref
                      .read(settingsActionsProvider)
                      .setNotificationTime(picked);
                }
              },
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '벌집',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const BrandImage.honey(size: 28),
              title: const Text('벌집 상점'),
              subtitle: Text(
                settings.isPro
                    ? '프로 · 칸 무제한'
                    : '${honeyLabel(settings.honeyPoints)} · ${settings.unlockedHiveCells}칸',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/hive/shop'),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('화면', style: Theme.of(context).textTheme.titleMedium),
            ),
            ...AppThemeMode.values.map((mode) {
              final selected = settings.themeMode == mode;
              return ListTile(
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? AppColors.honeyGold : null,
                ),
                title: Text(mode.label),
                onTap: () =>
                    ref.read(settingsActionsProvider).setThemeMode(mode),
              );
            }),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '데이터',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.ios_share_rounded),
              title: const Text('데이터 백업'),
              subtitle: const Text('JSON 파일로 보내기'),
              onTap: () => _exportBackup(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.restore_rounded),
              title: const Text('백업 복원'),
              subtitle: const Text('백업 파일에서 데이터 불러오기'),
              onTap: () => _restoreBackup(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.science_rounded),
              title: const Text('사용 시뮬레이션 넣기'),
              subtitle: const Text('생활용품 50여 개 + 화장지 가계부 이력'),
              onTap: () => _restoreSimulation(context, ref),
            ),
            FutureBuilder(
              future: syncStatus,
              builder: (context, snapshot) {
                final message = snapshot.data?.message ?? '클라우드 동기화는 준비 중이에요.';
                return ListTile(
                  leading: const Icon(Icons.cloud_off_outlined),
                  title: const Text('클라우드 동기화'),
                  subtitle: Text(message),
                  enabled: false,
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.widgets_outlined),
              title: Text('홈 화면 위젯'),
              subtitle: Text('준비 중 — iOS/Android 네이티브 연동 필요'),
              enabled: false,
            ),
            const Divider(height: 1),
            const ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('앱 정보'),
              subtitle: Text('허니 인벤토리 v1.0'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.beeYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '알림은 설정한 시간에 물품별로 전달되며, snooze한 항목은 3일간 숨겨집니다. '
                  '앱을 다시 열면 알림 스케줄이 갱신됩니다.',
                  style: TextStyle(color: AppColors.onHoneySecondary),
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) =>
            Center(child: Text('설정을 불러오지 못했어요: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(backupActionsProvider).exportAndShare();
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('백업에 실패했어요: $error')));
    }
  }

  Future<void> _restoreBackup(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('백업 복원'),
        content: const Text('현재 데이터가 백업 파일 내용으로 모두 교체됩니다.\n계속할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('복원'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    try {
      await ref
          .read(backupActionsProvider)
          .restoreFromFile(result.files.single.path!);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('백업을 복원했어요.')));
    } on BackupException catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('복원에 실패했어요: $error')));
    }
  }

  Future<void> _restoreSimulation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용 시뮬레이션'),
        content: const Text(
          '지금 있는 물품을 모두 지우고, 생활용품 50여 개와 화장지 가계부 이력을 넣을까요?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('넣기'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(backupActionsProvider).restoreHouseholdSimulation();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시뮬레이션 데이터를 넣었어요. 벌집에서 둘러보세요.')),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('시뮬레이션을 넣지 못했어요: $error')));
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? '오전' : '오후';
    return '$period $hour:$minute';
  }
}
