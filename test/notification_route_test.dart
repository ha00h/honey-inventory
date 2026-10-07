import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/services/notification_routes.dart';

void main() {
  test('알림 페이로드를 화면 경로로 바꾼다', () {
    expect(routeForNotificationPayload(null), '/notifications');
    expect(routeForNotificationPayload('notifications'), '/notifications');
    expect(routeForNotificationPayload('product:abc'), '/product/abc');
    expect(routeForNotificationPayload('/product/abc'), '/product/abc');
    expect(routeForNotificationPayload('product:'), '/notifications');
    expect(
      routeForNotificationPayload('honeyinventory://open'),
      '/notifications',
    );
    expect(
      routeForNotificationPayload('honeyinventory://open/notifications'),
      '/notifications',
    );
    expect(
      routeForNotificationPayload('honeyinventory://open/product/abc'),
      '/product/abc',
    );
  });

  test('커스텀 스킴 URI를 GoRouter 경로로 바꾼다', () {
    expect(
      routeForCustomScheme(Uri.parse('honeyinventory://open/notifications')),
      '/notifications',
    );
    expect(routeForCustomScheme(Uri.parse('/cart')), isNull);
  });
}
