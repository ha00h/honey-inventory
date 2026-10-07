import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../data/database/app_database.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../domain/services/notification_scheduler.dart';
import 'local_notification_service.dart';

/// Unique name + iOS BGTaskScheduler identifier.
/// Must match [BGTaskSchedulerPermittedIdentifiers] in Info.plist.
const notificationRefreshUniqueName =
    'com.homeanimals.honey_inventory.refresh_notifications';

const notificationRefreshTaskName = 'refresh_notifications';

@pragma('vm:entry-point')
void notificationBackgroundDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await runNotificationRefreshJob();
      return true;
    } catch (_) {
      return false;
    }
  });
}

/// Opens local storage and reschedules daily reminder notifications.
Future<void> runNotificationRefreshJob({AppDatabase? database}) async {
  final ownsDatabase = database == null;
  final db = database ?? AppDatabase();
  try {
    final notificationService = LocalNotificationService();
    await notificationService.initialize();
    await refreshScheduledNotifications(
      inventoryRepository: InventoryRepository(db),
      settingsRepository: SettingsRepository(),
      notificationService: notificationService,
    );
  } finally {
    if (ownsDatabase) {
      await db.close();
    }
  }
}

/// Initializes Workmanager and registers the daily refresh job.
Future<void> ensureNotificationBackgroundWorkScheduled() async {
  try {
    await Workmanager().initialize(notificationBackgroundDispatcher);
    await Workmanager().registerPeriodicTask(
      notificationRefreshUniqueName,
      notificationRefreshTaskName,
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(minutes: 30),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(networkType: NetworkType.notRequired),
    );
  } catch (_) {
    // 테스트·미지원 플랫폼에서는 백그라운드 작업을 생략한다.
  }
}
