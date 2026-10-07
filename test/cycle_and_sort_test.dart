import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/domain/entities/cycle_interval.dart';
import 'package:honey_inventory/domain/entities/inventory_models.dart';
import 'package:honey_inventory/domain/services/inventory_services.dart';

void main() {
  test('주/월 단위를 일수로 변환한다', () {
    expect(
      intervalToDays(value: 2, unit: CycleIntervalUnit.week),
      14,
    );
    expect(
      intervalToDays(value: 1, unit: CycleIntervalUnit.month),
      30,
    );
  });

  test('구매 주기가 오늘이거나 지났으면 도래로 본다', () {
    final cycle = PurchaseCycle(
      id: 'c1',
      productId: 'p1',
      intervalDays: 7,
      isAutoEstimated: false,
      isEnabled: true,
      nextReminderDate: DateTime(2026, 9, 5),
    );

    expect(
      isPurchaseCycleDue(cycle, now: DateTime(2026, 9, 8)),
      isTrue,
    );
    expect(
      isPurchaseCycleDue(
        cycle,
        now: DateTime(2026, 9, 4),
      ),
      isFalse,
    );
  });

  test('부족이면 빨간 꿀, 주기 지남이면 초록 꿀, 양은 재고 비율이다', () {
    final low = Product(
      id: 'p1',
      name: '휴지',
      unit: '롤',
      currentStock: 2,
      maxStock: 8,
      minStock: 4,
      iconKey: 'tissue',
      isActive: true,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    final dueCycle = PurchaseCycle(
      id: 'c1',
      productId: 'p2',
      intervalDays: 14,
      isAutoEstimated: false,
      isEnabled: true,
      nextReminderDate: DateTime(2026, 9, 1),
    );
    final healthy = Product(
      id: 'p2',
      name: '세제',
      unit: '개',
      currentStock: 2,
      maxStock: 4,
      minStock: 1,
      iconKey: 'detergent',
      isActive: true,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    expect(stockFillRatio(low), 0.25);
    expect(hiveHoneyStatus(product: low, cycle: dueCycle), HiveHoneyStatus.lowStock);
    expect(
      hiveHoneyStatus(
        product: healthy,
        cycle: dueCycle,
        now: DateTime(2026, 9, 8),
      ),
      HiveHoneyStatus.cycleDue,
    );
    expect(hiveHoneyStatus(product: healthy), HiveHoneyStatus.normal);
  });
}
