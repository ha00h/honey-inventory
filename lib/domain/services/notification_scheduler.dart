import '../../data/repositories/inventory_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/entities/app_settings.dart';
import '../../services/local_notification_service.dart';
import 'inventory_services.dart';

Future<void> refreshScheduledNotifications({
  required InventoryRepository inventoryRepository,
  required SettingsRepository settingsRepository,
  required LocalNotificationService notificationService,
}) async {
  final settings = await settingsRepository.load();
  final products = await inventoryRepository.watchProductsOnce();
  final cycles = await inventoryRepository.watchCyclesOnce();
  final reminders = buildReminderItems(
    products: products,
    cycles: cycles,
    snoozedProductIds: settings.activeSnoozedProductIds(),
  );

  await notificationService.scheduleDailyReminder(
    settings: settings,
    reminders: reminders,
  );
}

Future<AppSettings> loadSettings(SettingsRepository repository) {
  return repository.load();
}
