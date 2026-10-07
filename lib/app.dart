import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'domain/entities/app_settings.dart';
import 'presentation/shared/providers/inventory_providers.dart';
import 'presentation/shared/providers/repository_providers.dart';
import 'presentation/shared/providers/settings_providers.dart';
import 'routes/app_router.dart';
import 'services/notification_routes.dart';

class HoneyInventoryApp extends ConsumerStatefulWidget {
  const HoneyInventoryApp({super.key});

  @override
  ConsumerState<HoneyInventoryApp> createState() => _HoneyInventoryAppState();
}

class _HoneyInventoryAppState extends ConsumerState<HoneyInventoryApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      _configureNotificationHandler();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(inventoryActionsProvider).scheduleLocalReminders();
    }
  }

  void _configureNotificationHandler() {
    final service = ref.read(localNotificationServiceProvider);
    service.setNotificationTapHandler(_openFromNotification);
    service.consumeLaunchPayload().then((payload) {
      if (!mounted || payload == null) {
        return;
      }
      _openFromNotification(payload);
    });
  }

  void _openFromNotification(String? payload) {
    ref.read(routerProvider).push(routeForNotificationPayload(payload));
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    final themeMode = settings.maybeWhen(
      skipLoadingOnReload: true,
      data: (value) => switch (value.themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      },
      orElse: () => ThemeMode.light,
    );

    return MaterialApp.router(
      title: '허니 인벤토리',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
