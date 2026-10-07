import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/cart/cart_screen.dart';
import '../presentation/hive/hive_screen.dart';
import '../presentation/hive/hive_shop_screen.dart';
import '../presentation/notifications/notifications_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/product/product_detail_screen.dart';
import '../presentation/product/product_form_screen.dart';
import '../presentation/receipt/receipt_scan_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/shared/providers/settings_providers.dart';
import '../presentation/shared/widgets/main_shell.dart';
import '../services/notification_routes.dart';

final onboardingSeenProvider = Provider<bool?>((ref) {
  return ref.watch(settingsProvider).maybeWhen(
    skipLoadingOnReload: true,
    skipError: true,
    data: (settings) => settings.hasSeenOnboarding,
    orElse: () => null,
  );
});

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final custom = routeForCustomScheme(state.uri);
      if (custom != null && state.matchedLocation != custom) {
        return custom;
      }

      final onboardingSeen = ref.read(onboardingSeenProvider);
      if (onboardingSeen == null) {
        return null;
      }
      final isOnboarding = state.matchedLocation == '/onboarding';
      if (!onboardingSeen && !isOnboarding) {
        return '/onboarding';
      }
      if (onboardingSeen && isOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HiveScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/hive/shop',
        builder: (context, state) => const HiveShopScreen(),
      ),
      GoRoute(
        path: '/product/new',
        builder: (context, state) => const ProductFormScreen(),
      ),
      GoRoute(
        path: '/product/:id/edit',
        builder: (context, state) {
          return ProductFormScreen(productId: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          return ProductDetailScreen(id: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/receipt/scan',
        builder: (context, state) {
          final imagePath = state.uri.queryParameters['path'];
          if (imagePath == null || imagePath.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('영수증 이미지를 찾을 수 없어요.')),
            );
          }
          return ReceiptScanScreen(imagePath: imagePath);
        },
      ),
    ],
  );

  ref.listen<bool?>(onboardingSeenProvider, (previous, next) {
    if (previous != next) {
      router.refresh();
    }
  });
  ref.onDispose(router.dispose);
  return router;
});
