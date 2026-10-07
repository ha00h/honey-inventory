import 'package:flutter/material.dart';

import '../services/hive_economy.dart';

enum AppThemeMode { light, dark, system }

extension AppThemeModeLabel on AppThemeMode {
  String get label => switch (this) {
    AppThemeMode.light => '라이트',
    AppThemeMode.dark => '다크',
    AppThemeMode.system => '시스템 설정',
  };
}

class AppSettings {
  const AppSettings({
    required this.notificationsEnabled,
    required this.notificationTime,
    required this.hasSeenOnboarding,
    required this.snoozedUntilByProductId,
    required this.dismissedReminderProductIds,
    required this.themeMode,
    this.honeyPoints = 0,
    this.unlockedHiveCells = freeHiveCells,
    this.isPro = false,
    this.lastAttendanceDate,
    this.lastAdWatchDate,
    this.adsWatchedToday = 0,
  });

  final bool notificationsEnabled;
  final TimeOfDay notificationTime;
  final bool hasSeenOnboarding;
  final Map<String, DateTime> snoozedUntilByProductId;
  final Set<String> dismissedReminderProductIds;
  final AppThemeMode themeMode;
  final int honeyPoints;
  final int unlockedHiveCells;
  final bool isPro;
  final DateTime? lastAttendanceDate;
  final DateTime? lastAdWatchDate;
  final int adsWatchedToday;

  factory AppSettings.defaults() {
    return const AppSettings(
      notificationsEnabled: true,
      notificationTime: TimeOfDay(hour: 9, minute: 0),
      hasSeenOnboarding: false,
      snoozedUntilByProductId: {},
      dismissedReminderProductIds: {},
      themeMode: AppThemeMode.light,
      honeyPoints: 0,
      unlockedHiveCells: freeHiveCells,
      isPro: false,
      adsWatchedToday: 0,
    );
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    TimeOfDay? notificationTime,
    bool? hasSeenOnboarding,
    Map<String, DateTime>? snoozedUntilByProductId,
    Set<String>? dismissedReminderProductIds,
    AppThemeMode? themeMode,
    int? honeyPoints,
    int? unlockedHiveCells,
    bool? isPro,
    DateTime? lastAttendanceDate,
    DateTime? lastAdWatchDate,
    int? adsWatchedToday,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      snoozedUntilByProductId:
          snoozedUntilByProductId ?? this.snoozedUntilByProductId,
      dismissedReminderProductIds:
          dismissedReminderProductIds ?? this.dismissedReminderProductIds,
      themeMode: themeMode ?? this.themeMode,
      honeyPoints: honeyPoints ?? this.honeyPoints,
      unlockedHiveCells: unlockedHiveCells ?? this.unlockedHiveCells,
      isPro: isPro ?? this.isPro,
      lastAttendanceDate: lastAttendanceDate ?? this.lastAttendanceDate,
      lastAdWatchDate: lastAdWatchDate ?? this.lastAdWatchDate,
      adsWatchedToday: adsWatchedToday ?? this.adsWatchedToday,
    );
  }

  Set<String> activeSnoozedProductIds([DateTime? now]) {
    final current = now ?? DateTime.now();
    return snoozedUntilByProductId.entries
        .where((entry) => entry.value.isAfter(current))
        .map((entry) => entry.key)
        .toSet();
  }
}
