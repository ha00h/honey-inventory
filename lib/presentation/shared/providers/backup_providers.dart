import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/backup_repository.dart';
import '../../../data/simulation/household_simulation.dart';
import '../../../domain/services/notification_scheduler.dart';
import 'repository_providers.dart';
import 'settings_providers.dart';

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(
    database: ref.watch(appDatabaseProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
  );
});

class BackupActions {
  BackupActions(this._ref);

  final Ref _ref;

  BackupRepository get _repository => _ref.read(backupRepositoryProvider);

  Future<void> exportAndShare() => _repository.shareBackup();

  Future<void> restoreFromFile(String path) async {
    final json = await File(path).readAsString();
    await _repository.importFromJson(json);
    _ref.invalidate(settingsProvider);
    await refreshScheduledNotifications(
      inventoryRepository: _ref.read(inventoryRepositoryProvider),
      settingsRepository: _ref.read(settingsRepositoryProvider),
      notificationService: _ref.read(localNotificationServiceProvider),
    );
  }

  Future<void> restoreHouseholdSimulation() async {
    await _repository.importFromJson(householdSimulationBackupJson());
    _ref.invalidate(settingsProvider);
    await refreshScheduledNotifications(
      inventoryRepository: _ref.read(inventoryRepositoryProvider),
      settingsRepository: _ref.read(settingsRepositoryProvider),
      notificationService: _ref.read(localNotificationServiceProvider),
    );
  }
}

final backupActionsProvider = Provider<BackupActions>((ref) {
  return BackupActions(ref);
});
