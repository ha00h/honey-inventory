import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/services/hive_economy.dart';

class SettingsRepository {
  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _notificationHourKey = 'notification_hour';
  static const _notificationMinuteKey = 'notification_minute';
  static const _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const _snoozedProductsKey = 'snoozed_products';
  static const _dismissedRemindersKey = 'dismissed_reminders';
  static const _themeModeKey = 'theme_mode';
  static const _honeyPointsKey = 'honey_points';
  static const _unlockedHiveCellsKey = 'unlocked_hive_cells';
  static const _isProKey = 'is_pro';
  static const _lastAttendanceDateKey = 'last_attendance_date';
  static const _lastAdWatchDateKey = 'last_ad_watch_date';
  static const _adsWatchedTodayKey = 'ads_watched_today';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final defaults = AppSettings.defaults();
    final snoozedRaw = prefs.getString(_snoozedProductsKey);
    final snoozedMap = <String, DateTime>{};

    if (snoozedRaw != null) {
      final decoded = jsonDecode(snoozedRaw) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        snoozedMap[entry.key] = DateTime.parse(entry.value as String);
      }
    }

    final cleanedSnoozed = _cleanExpiredSnoozes(snoozedMap);
    if (cleanedSnoozed.length != snoozedMap.length) {
      await _saveSnoozes(prefs, cleanedSnoozed);
    }

    final dismissedRaw = prefs.getStringList(_dismissedRemindersKey) ?? [];

    return AppSettings(
      notificationsEnabled:
          prefs.getBool(_notificationsEnabledKey) ??
          defaults.notificationsEnabled,
      notificationTime: TimeOfDay(
        hour:
            prefs.getInt(_notificationHourKey) ??
            defaults.notificationTime.hour,
        minute:
            prefs.getInt(_notificationMinuteKey) ??
            defaults.notificationTime.minute,
      ),
      hasSeenOnboarding:
          prefs.getBool(_hasSeenOnboardingKey) ?? defaults.hasSeenOnboarding,
      snoozedUntilByProductId: cleanedSnoozed,
      dismissedReminderProductIds: dismissedRaw.toSet(),
      themeMode: AppThemeMode.values.byName(
        prefs.getString(_themeModeKey) ?? defaults.themeMode.name,
      ),
      honeyPoints: prefs.getInt(_honeyPointsKey) ?? defaults.honeyPoints,
      unlockedHiveCells:
          prefs.getInt(_unlockedHiveCellsKey) ?? defaults.unlockedHiveCells,
      isPro: prefs.getBool(_isProKey) ?? defaults.isPro,
      lastAttendanceDate: _parseDate(prefs.getString(_lastAttendanceDateKey)),
      lastAdWatchDate: _parseDate(prefs.getString(_lastAdWatchDateKey)),
      adsWatchedToday:
          prefs.getInt(_adsWatchedTodayKey) ?? defaults.adsWatchedToday,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      _notificationsEnabledKey,
      settings.notificationsEnabled,
    );
    await prefs.setInt(_notificationHourKey, settings.notificationTime.hour);
    await prefs.setInt(
      _notificationMinuteKey,
      settings.notificationTime.minute,
    );
    await prefs.setBool(_hasSeenOnboardingKey, settings.hasSeenOnboarding);
    await _saveSnoozes(prefs, settings.snoozedUntilByProductId);
    await prefs.setStringList(
      _dismissedRemindersKey,
      settings.dismissedReminderProductIds.toList(),
    );
    await prefs.setString(_themeModeKey, settings.themeMode.name);
    await prefs.setInt(_honeyPointsKey, settings.honeyPoints);
    await prefs.setInt(_unlockedHiveCellsKey, settings.unlockedHiveCells);
    await prefs.setBool(_isProKey, settings.isPro);
    await _setOptionalDate(
      prefs,
      _lastAttendanceDateKey,
      settings.lastAttendanceDate,
    );
    await _setOptionalDate(prefs, _lastAdWatchDateKey, settings.lastAdWatchDate);
    await prefs.setInt(_adsWatchedTodayKey, settings.adsWatchedToday);
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  Future<void> _setOptionalDate(
    SharedPreferences prefs,
    String key,
    DateTime? value,
  ) async {
    if (value == null) {
      await prefs.remove(key);
      return;
    }
    await prefs.setString(key, hiveCalendarDay(value).toIso8601String());
  }

  Future<void> snoozeProduct({
    required AppSettings current,
    required String productId,
    Duration duration = const Duration(days: 3),
  }) async {
    final nextSnoozes = Map<String, DateTime>.from(
      current.snoozedUntilByProductId,
    )..[productId] = DateTime.now().add(duration);
    await save(current.copyWith(snoozedUntilByProductId: nextSnoozes));
  }

  Future<void> dismissReminder({
    required AppSettings current,
    required String productId,
  }) async {
    final nextDismissed = {...current.dismissedReminderProductIds, productId};
    await save(current.copyWith(dismissedReminderProductIds: nextDismissed));
  }

  Future<void> pruneDismissedReminders({
    required AppSettings current,
    required Set<String> activeReminderProductIds,
  }) async {
    final pruned = current.dismissedReminderProductIds
        .where(activeReminderProductIds.contains)
        .toSet();
    if (pruned.length != current.dismissedReminderProductIds.length) {
      await save(current.copyWith(dismissedReminderProductIds: pruned));
    }
  }

  Map<String, DateTime> _cleanExpiredSnoozes(Map<String, DateTime> snoozes) {
    final now = DateTime.now();
    return {
      for (final entry in snoozes.entries)
        if (entry.value.isAfter(now)) entry.key: entry.value,
    };
  }

  Future<void> _saveSnoozes(
    SharedPreferences prefs,
    Map<String, DateTime> snoozes,
  ) async {
    final encoded = jsonEncode({
      for (final entry in snoozes.entries)
        entry.key: entry.value.toIso8601String(),
    });
    await prefs.setString(_snoozedProductsKey, encoded);
  }
}
