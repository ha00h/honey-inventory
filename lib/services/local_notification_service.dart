import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/entities/app_settings.dart';
import '../domain/entities/inventory_models.dart';

typedef NotificationTapHandler = void Function(String? payload);

class LocalNotificationService {
  LocalNotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  NotificationTapHandler? _onNotificationTap;

  static const _dailyDigestId = 100;
  static const _itemNotificationBaseId = 200;
  static const _itemNotificationMax = 399;

  void setNotificationTapHandler(NotificationTapHandler? handler) {
    _onNotificationTap = handler;
  }

  Future<String?> consumeLaunchPayload() async {
    if (!_initialized) {
      await initialize();
    }
    if (!_initialized) {
      return null;
    }

    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp != true) {
        return null;
      }
      return details?.notificationResponse?.payload;
    } catch (_) {
      return null;
    }
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz_data.initializeTimeZones();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          _onNotificationTap?.call(response.payload);
        },
      );
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  Future<bool> requestPermissions() async {
    if (!_initialized) {
      await initialize();
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<bool> areNotificationsEnabled() async {
    if (!_initialized) {
      await initialize();
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }

    return true;
  }

  Future<void> scheduleDailyReminder({
    required AppSettings settings,
    required List<ReminderItem> reminders,
  }) async {
    if (!_initialized) {
      return;
    }

    await _cancelItemNotifications();

    if (!settings.notificationsEnabled || reminders.isEmpty) {
      await _plugin.cancel(id: _dailyDigestId);
      return;
    }

    final scheduledDate = _nextInstanceOfTime(settings.notificationTime);
    final details = _notificationDetails();

    for (var index = 0; index < reminders.length && index < 20; index++) {
      final reminder = reminders[index];
      final notificationId = _itemNotificationBaseId + index;
      try {
        await _plugin.zonedSchedule(
          id: notificationId,
          title: reminder.productName,
          body: reminder.message,
          scheduledDate: scheduledDate,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'product:${reminder.productId}',
          notificationDetails: details,
        );
      } catch (_) {
        // 개별 알림 실패 시 digest로 폴백
      }
    }

    if (reminders.length > 1) {
      final body = reminders.take(3).map((item) => item.productName).join(', ');
      try {
        await _plugin.zonedSchedule(
          id: _dailyDigestId,
          title: '허니 인벤토리 알림',
          body: '$body 외 ${reminders.length - 1}개 확인이 필요해요.',
          scheduledDate: scheduledDate,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'notifications',
          notificationDetails: details,
        );
      } catch (_) {
        await showImmediateDigest(reminders);
      }
    }
  }

  Future<void> showImmediateDigest(List<ReminderItem> reminders) async {
    if (!_initialized || reminders.isEmpty) {
      return;
    }

    final body = reminders.take(3).map((item) => item.productName).join(', ');

    try {
      await _plugin.show(
        id: 101,
        title: '허니 인벤토리 알림',
        body: '$body 확인이 필요해요.',
        payload: 'notifications',
        notificationDetails: _notificationDetails(),
      );
    } catch (_) {}
  }

  Future<void> _cancelItemNotifications() async {
    for (var id = _itemNotificationBaseId; id <= _itemNotificationMax; id++) {
      await _plugin.cancel(id: id);
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'honey_inventory_daily',
        '허니 인벤토리 알림',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
