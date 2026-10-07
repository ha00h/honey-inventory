import '../entities/inventory_models.dart';

/// 무료 벌집: 가운데 + 한 겹(19칸). 7칸은 첫 링만이라 집이 비어 보인다.
const freeHiveCells = 19;

const attendanceHoney = 8;
const rewardedAdHoney = 6;
const maxRewardedAdsPerDay = 2;

class HiveCellPack {
  const HiveCellPack({required this.cells, required this.honey});

  final int cells;
  final int honey;
}

const hivePackSmall = HiveCellPack(cells: 5, honey: 28);
const hivePackLarge = HiveCellPack(cells: 10, honey: 48);

const hiveCellPacks = [hivePackSmall, hivePackLarge];

class HiveCapacityException implements Exception {
  const HiveCapacityException();

  @override
  String toString() => '벌집 칸이 가득 찼어요.';
}

class HiveHoneyShortException implements Exception {
  const HiveHoneyShortException();

  @override
  String toString() => '꿀이 부족해요.';
}

/// 표시용. 예: `28꿀`
String honeyLabel(int amount) => '$amount꿀';

DateTime hiveCalendarDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

bool canClaimAttendance(DateTime? lastAttendanceDate, {DateTime? now}) {
  final today = hiveCalendarDay(now ?? DateTime.now());
  if (lastAttendanceDate == null) {
    return true;
  }
  return hiveCalendarDay(lastAttendanceDate).isBefore(today);
}

int adsRemainingToday({
  required bool isPro,
  required DateTime? lastAdWatchDate,
  required int adsWatchedToday,
  DateTime? now,
}) {
  if (isPro) {
    return 0;
  }
  final today = hiveCalendarDay(now ?? DateTime.now());
  if (lastAdWatchDate == null || hiveCalendarDay(lastAdWatchDate) != today) {
    return maxRewardedAdsPerDay;
  }
  return (maxRewardedAdsPerDay - adsWatchedToday).clamp(
    0,
    maxRewardedAdsPerDay,
  );
}

bool canFitNewHiveProducts({
  required bool isPro,
  required int unlockedHiveCells,
  required int productCount,
  required int newCount,
}) {
  if (isPro || newCount <= 0) {
    return true;
  }
  return productCount + newCount <= unlockedHiveCells;
}

bool canAddHiveProduct({
  required bool isPro,
  required int unlockedHiveCells,
  required int productCount,
}) {
  return canFitNewHiveProducts(
    isPro: isPro,
    unlockedHiveCells: unlockedHiveCells,
    productCount: productCount,
    newCount: 1,
  );
}

int newHiveCellsNeededForCart({
  required List<CartItem> items,
  required Iterable<Product> products,
}) {
  final existingIds = {for (final product in products) product.id};
  final existingNames = {
    for (final product in products) product.name.trim().toLowerCase(),
  };
  final countedNames = <String>{};
  var needed = 0;

  for (final item in items) {
    final productId = item.productId;
    if (productId != null && existingIds.contains(productId)) {
      continue;
    }
    final name = item.label().trim().toLowerCase();
    if (name.isEmpty || name == '물품') {
      needed += 1;
      continue;
    }
    if (existingNames.contains(name) || countedNames.contains(name)) {
      continue;
    }
    countedNames.add(name);
    needed += 1;
  }

  return needed;
}

/// 잠긴 칸이 시작되는 인덱스. 프로는 잠금 없음.
int lockedHiveCellStart({
  required bool isPro,
  required int unlockedHiveCells,
  required int productCount,
}) {
  if (isPro) {
    return 1 << 20;
  }
  return unlockedHiveCells > productCount ? unlockedHiveCells : productCount;
}

int migratedUnlockedCells({
  required int currentUnlocked,
  required int productCount,
}) {
  var next = currentUnlocked;
  if (next < freeHiveCells) {
    next = freeHiveCells;
  }
  if (productCount > next) {
    next = productCount;
  }
  return next;
}
