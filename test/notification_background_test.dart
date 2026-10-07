import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/data/database/app_database.dart';
import 'package:honey_inventory/services/notification_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('백그라운드 알림 작업 ID는 Info.plist 식별자와 같다', () {
    expect(
      notificationRefreshUniqueName,
      'com.homeanimals.honey_inventory.refresh_notifications',
    );
    expect(notificationRefreshTaskName, 'refresh_notifications');
  });

  test('알림 재스케줄 작업은 빈 저장소에서도 예외 없이 끝난다', () async {
    SharedPreferences.setMockInitialValues({});
    final database = AppDatabase.forTesting();
    addTearDown(database.close);
    await runNotificationRefreshJob(database: database);
  });
}
