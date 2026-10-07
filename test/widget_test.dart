import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:honey_inventory/app.dart';
import 'package:honey_inventory/domain/entities/app_settings.dart';
import 'package:honey_inventory/domain/entities/inventory_models.dart';
import 'package:honey_inventory/domain/services/inventory_services.dart';
import 'package:honey_inventory/presentation/shared/providers/inventory_providers.dart';
import 'package:honey_inventory/presentation/shared/providers/settings_providers.dart';

void main() {
  testWidgets('앱이 벌집 홈 화면을 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStartupProvider.overrideWith((ref) async {}),
          settingsProvider.overrideWith(
            (ref) async =>
                AppSettings.defaults().copyWith(hasSeenOnboarding: true),
          ),
          productsProvider.overrideWith(
            (ref) => Stream.value([
              Product(
                id: 'test',
                name: '휴지',
                unit: '롤',
                currentStock: 2,
                maxStock: 6,
                minStock: 1,
                iconKey: 'tissue',
                isActive: true,
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            ]),
          ),
          cyclesProvider.overrideWith(
            (ref) => Stream.value(const <PurchaseCycle>[]),
          ),
          notificationPermissionProvider.overrideWith((ref) async => true),
        ],
        child: const HoneyInventoryApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('허니 인벤토리'), findsOneWidget);
    expect(find.text('재고'), findsOneWidget);
    expect(find.text('장바구니'), findsOneWidget);
    expect(find.bySemanticsLabel('빈 칸, 물품 추가'), findsWidgets);
    expect(find.text('물품 추가'), findsNothing);
  });

  testWidgets('장바구니 삭제는 벌집에서 빼기 확인을 연다', (tester) async {
    final cartItem = CartItem(
      id: 'c1',
      productId: 'p1',
      quantity: 2,
      addedAt: DateTime(2026),
    );
    final tissue = Product(
      id: 'p1',
      name: '휴지',
      unit: '롤',
      currentStock: 2,
      maxStock: 6,
      minStock: 1,
      iconKey: 'tissue',
      isActive: true,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStartupProvider.overrideWith((ref) async {}),
          settingsProvider.overrideWith(
            (ref) async =>
                AppSettings.defaults().copyWith(hasSeenOnboarding: true),
          ),
          productsProvider.overrideWith((ref) => Stream.value([tissue])),
          groupedCartProvider.overrideWith(
            (ref) => AsyncData([
              CartStoreGroup(storeName: '구매처 미정', items: [cartItem]),
            ]),
          ),
          cyclesProvider.overrideWith(
            (ref) => Stream.value(const <PurchaseCycle>[]),
          ),
          notificationPermissionProvider.overrideWith((ref) async => true),
        ],
        child: const HoneyInventoryApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('장바구니'));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('휴지, 벌집에서 빼기'), findsOneWidget);
    await tester.tap(find.byTooltip('벌집에서 빼기'));
    await tester.pumpAndSettle();
    expect(find.text('벌집에서 빼겠습니까?'), findsOneWidget);
  });
}
