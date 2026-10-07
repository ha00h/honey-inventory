import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../services/local_notification_service.dart';
import '../../../services/receipt_ocr_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.watch(appDatabaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService();
});

final receiptOcrServiceProvider = Provider<ReceiptOcrService>((ref) {
  final service = ReceiptOcrService();
  ref.onDispose(service.dispose);
  return service;
});
