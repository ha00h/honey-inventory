import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/domain/entities/inventory_models.dart';
import 'package:honey_inventory/domain/services/hive_economy.dart';

void main() {
  test('무료 칸은 19이고 7칸보다 한 겹 더 넓다', () {
    expect(freeHiveCells, 19);
  });

  test('출석은 하루에 한 번만 받을 수 있다', () {
    final today = DateTime(2026, 9, 8, 10);
    expect(canClaimAttendance(null, now: today), isTrue);
    expect(canClaimAttendance(DateTime(2026, 9, 8), now: today), isFalse);
    expect(canClaimAttendance(DateTime(2026, 9, 7), now: today), isTrue);
  });

  test('광고는 하루 2회까지 꿀을 준다', () {
    expect(
      adsRemainingToday(
        isPro: false,
        lastAdWatchDate: null,
        adsWatchedToday: 0,
        now: DateTime(2026, 9, 8),
      ),
      2,
    );
    expect(
      adsRemainingToday(
        isPro: false,
        lastAdWatchDate: DateTime(2026, 9, 8),
        adsWatchedToday: 2,
        now: DateTime(2026, 9, 8),
      ),
      0,
    );
    expect(
      adsRemainingToday(
        isPro: true,
        lastAdWatchDate: null,
        adsWatchedToday: 0,
        now: DateTime(2026, 9, 8),
      ),
      0,
    );
  });

  test('프로가 아니면 해금 칸만큼만 추가할 수 있다', () {
    expect(
      canAddHiveProduct(
        isPro: false,
        unlockedHiveCells: 19,
        productCount: 18,
      ),
      isTrue,
    );
    expect(
      canAddHiveProduct(
        isPro: false,
        unlockedHiveCells: 19,
        productCount: 19,
      ),
      isFalse,
    );
    expect(
      canAddHiveProduct(
        isPro: true,
        unlockedHiveCells: 19,
        productCount: 80,
      ),
      isTrue,
    );
  });

  test('이미 있는 물품 수보다 칸이 적으면 기존 칸을 맞춰 준다', () {
    expect(
      migratedUnlockedCells(currentUnlocked: 19, productCount: 50),
      50,
    );
    expect(
      migratedUnlockedCells(currentUnlocked: 7, productCount: 3),
      19,
    );
  });

  test('하루 꿀 상한은 팩보다 낮고 10칸 팩이 칸당 더 싸다', () {
    final dailyMax = attendanceHoney + rewardedAdHoney * maxRewardedAdsPerDay;
    expect(dailyMax, lessThan(hivePackSmall.honey));
    expect(dailyMax, lessThan(hivePackLarge.honey));
    expect(
      hivePackLarge.honey / hivePackLarge.cells,
      lessThan(hivePackSmall.honey / hivePackSmall.cells),
    );
  });

  test('장바구니 새 이름은 칸이 필요하고 있는 물품은 필요 없다', () {
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
    expect(
      newHiveCellsNeededForCart(
        items: [
          CartItem(
            id: 'c1',
            productId: 'p1',
            quantity: 1,
            addedAt: DateTime(2026),
          ),
          CartItem(
            id: 'c2',
            pendingName: '새세제',
            quantity: 1,
            addedAt: DateTime(2026),
          ),
        ],
        products: [tissue],
      ),
      1,
    );
    expect(
      canFitNewHiveProducts(
        isPro: false,
        unlockedHiveCells: 19,
        productCount: 19,
        newCount: 1,
      ),
      isFalse,
    );
  });
}
