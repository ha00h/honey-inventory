import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

enum RewardedAdShowResult { rewarded, dismissed, failedToLoad, failedToShow }

class RewardedAdService {
  RewardedAd? _loaded;
  bool _loading = false;
  Future<void>? _initializing;

  Future<void> initialize() {
    return _initializing ??= MobileAds.instance.initialize().then((_) {});
  }

  Future<void> preload() async {
    if (_loaded != null || _loading) {
      return;
    }
    _loading = true;
    try {
      await initialize();
      final completer = Completer<void>();
      await RewardedAd.load(
        adUnitId: AdConfig.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _loaded = ad;
            _loading = false;
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
          onAdFailedToLoad: (error) {
            debugPrint('Rewarded ad failed to load: $error');
            _loaded = null;
            _loading = false;
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        ),
      );
      await completer.future;
    } catch (error, stackTrace) {
      debugPrint('Rewarded ad load threw: $error\n$stackTrace');
      _loading = false;
      _loaded = null;
    }
  }

  /// Shows a rewarded ad. Returns [RewardedAdShowResult.rewarded] only when
  /// the user earns the reward callback.
  Future<RewardedAdShowResult> show() async {
    if (_loaded == null) {
      await preload();
    }
    final ad = _loaded;
    if (ad == null) {
      return RewardedAdShowResult.failedToLoad;
    }

    _loaded = null;
    final completer = Completer<RewardedAdShowResult>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (dismissed) {
        dismissed.dispose();
        unawaited(preload());
        if (!completer.isCompleted) {
          completer.complete(
            earned
                ? RewardedAdShowResult.rewarded
                : RewardedAdShowResult.dismissed,
          );
        }
      },
      onAdFailedToShowFullScreenContent: (failed, error) {
        debugPrint('Rewarded ad failed to show: $error');
        failed.dispose();
        unawaited(preload());
        if (!completer.isCompleted) {
          completer.complete(RewardedAdShowResult.failedToShow);
        }
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (ad, reward) {
          earned = true;
        },
      );
    } catch (error, stackTrace) {
      debugPrint('Rewarded ad show threw: $error\n$stackTrace');
      ad.dispose();
      unawaited(preload());
      return RewardedAdShowResult.failedToShow;
    }

    return completer.future;
  }
}
