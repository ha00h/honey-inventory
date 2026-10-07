import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/settings_repository.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/services/notification_scheduler.dart';
import 'repository_providers.dart';

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  return ref.read(settingsRepositoryProvider).load();
});

final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  ref.watch(settingsProvider);
  return ref.read(localNotificationServiceProvider).areNotificationsEnabled();
});

class SettingsActions {
  SettingsActions(this._ref);

  final Ref _ref;

  SettingsRepository get _repository => _ref.read(settingsRepositoryProvider);

  Future<AppSettings> _current() => _ref.read(settingsProvider.future);

  Future<void> _save(AppSettings settings) async {
    await _repository.save(settings);
    _ref.invalidate(settingsProvider);
    await refreshScheduledNotifications(
      inventoryRepository: _ref.read(inventoryRepositoryProvider),
      settingsRepository: _repository,
      notificationService: _ref.read(localNotificationServiceProvider),
    );
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    if (enabled) {
      final granted = await _ref
          .read(localNotificationServiceProvider)
          .requestPermissions();
      _ref.invalidate(notificationPermissionProvider);
      if (!granted) {
        return;
      }
    }

    final current = await _current();
    await _save(current.copyWith(notificationsEnabled: enabled));
  }

  Future<bool> requestNotificationPermission() async {
    final granted = await _ref
        .read(localNotificationServiceProvider)
        .requestPermissions();
    _ref.invalidate(notificationPermissionProvider);
    return granted;
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    final current = await _current();
    await _save(current.copyWith(notificationTime: time));
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final current = await _current();
    await _save(current.copyWith(themeMode: mode));
  }

  Future<void> completeOnboarding() async {
    final current = await _current();
    await _save(current.copyWith(hasSeenOnboarding: true));
  }

  Future<void> snoozeReminder(String productId) async {
    final current = await _current();
    await _repository.snoozeProduct(current: current, productId: productId);
    _ref.invalidate(settingsProvider);
    await refreshScheduledNotifications(
      inventoryRepository: _ref.read(inventoryRepositoryProvider),
      settingsRepository: _repository,
      notificationService: _ref.read(localNotificationServiceProvider),
    );
  }

  Future<void> dismissReminder(String productId) async {
    final current = await _current();
    await _repository.dismissReminder(current: current, productId: productId);
    _ref.invalidate(settingsProvider);
  }

  Future<void> pruneDismissedReminders(Set<String> activeReminderProductIds) {
    return _current()
        .then((current) {
          return _repository.pruneDismissedReminders(
            current: current,
            activeReminderProductIds: activeReminderProductIds,
          );
        })
        .then((_) => _ref.invalidate(settingsProvider));
  }
}

final settingsActionsProvider = Provider<SettingsActions>((ref) {
  return SettingsActions(ref);
});
