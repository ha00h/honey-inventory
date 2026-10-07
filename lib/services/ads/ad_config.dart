import 'dart:io';

import 'package:flutter/foundation.dart';

/// AdMob IDs. Debug builds use Google sample units so accidental clicks
/// never touch production inventory.
abstract final class AdConfig {
  /// Android production App ID (AdMob console).
  static const androidAppId = 'ca-app-pub-3960156374112844~6676840514';

  /// iOS production App ID (AdMob console).
  static const iosAppId = 'ca-app-pub-3960156374112844~7327577205';

  static const _androidRewardedProd = 'ca-app-pub-3960156374112844/6649910035';
  static const _iosRewardedProd = 'ca-app-pub-3960156374112844/7655869940';
  static const _androidRewardedTest = 'ca-app-pub-3940256099942544/5224354917';
  static const _iosRewardedTest = 'ca-app-pub-3940256099942544/1712485313';

  /// Set true only for store builds that should serve live ads.
  static const useProductionAds = bool.fromEnvironment(
    'USE_PRODUCTION_ADS',
    defaultValue: false,
  );

  static bool get _live => useProductionAds && kReleaseMode;

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _live ? _androidRewardedProd : _androidRewardedTest;
    }
    if (Platform.isIOS) {
      return _live ? _iosRewardedProd : _iosRewardedTest;
    }
    throw UnsupportedError('Unsupported platform for ads');
  }
}
