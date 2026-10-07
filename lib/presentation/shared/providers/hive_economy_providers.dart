import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../domain/services/hive_economy.dart';
import 'repository_providers.dart';
import 'settings_providers.dart';

class HiveEconomyActions {
  HiveEconomyActions(this._ref);

  final Ref _ref;

  Future<AppSettings> _current() => _ref.read(settingsProvider.future);

  Future<void> _persist(AppSettings settings) async {
    await _ref.read(settingsRepositoryProvider).save(settings);
    _ref.invalidate(settingsProvider);
  }

  Future<void> ensureCapacityForExistingProducts(int productCount) async {
    final current = await _current();
    if (current.isPro) {
      return;
    }
    final next = migratedUnlockedCells(
      currentUnlocked: current.unlockedHiveCells,
      productCount: productCount,
    );
    if (next == current.unlockedHiveCells) {
      return;
    }
    await _persist(current.copyWith(unlockedHiveCells: next));
  }

  Future<void> claimAttendance({DateTime? now}) async {
    final current = await _current();
    final at = now ?? DateTime.now();
    if (!canClaimAttendance(current.lastAttendanceDate, now: at)) {
      return;
    }
    await _persist(
      current.copyWith(
        honeyPoints: current.honeyPoints + attendanceHoney,
        lastAttendanceDate: hiveCalendarDay(at),
      ),
    );
  }

  Future<void> collectRewardedAd({DateTime? now}) async {
    final current = await _current();
    final at = now ?? DateTime.now();
    final remaining = adsRemainingToday(
      isPro: current.isPro,
      lastAdWatchDate: current.lastAdWatchDate,
      adsWatchedToday: current.adsWatchedToday,
      now: at,
    );
    if (remaining <= 0) {
      return;
    }
    final today = hiveCalendarDay(at);
    final alreadyToday =
        current.lastAdWatchDate != null &&
        hiveCalendarDay(current.lastAdWatchDate!) == today;
    await _persist(
      current.copyWith(
        honeyPoints: current.honeyPoints + rewardedAdHoney,
        lastAdWatchDate: today,
        adsWatchedToday: alreadyToday ? current.adsWatchedToday + 1 : 1,
      ),
    );
  }

  Future<void> buyCellPack(HiveCellPack pack) async {
    final current = await _current();
    if (current.isPro) {
      return;
    }
    if (current.honeyPoints < pack.honey) {
      throw const HiveHoneyShortException();
    }
    await _persist(
      current.copyWith(
        honeyPoints: current.honeyPoints - pack.honey,
        unlockedHiveCells: current.unlockedHiveCells + pack.cells,
      ),
    );
  }

  Future<void> setProPreview(bool enabled) async {
    final current = await _current();
    await _persist(current.copyWith(isPro: enabled));
  }
}

final hiveEconomyActionsProvider = Provider<HiveEconomyActions>((ref) {
  return HiveEconomyActions(ref);
});
