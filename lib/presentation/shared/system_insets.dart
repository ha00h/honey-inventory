import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Bottom inset for the Android/iOS system navigation area.
///
/// Android 15 edge-to-edge often reports 0 via [MediaQuery.padding], so this
/// also checks the Flutter view and falls back to 48dp on Android.
double systemBottomInset(BuildContext context) {
  final media = MediaQuery.of(context);
  final view = View.of(context);
  final dpr = view.devicePixelRatio;
  final inset = [
    media.padding.bottom,
    media.viewPadding.bottom,
    media.systemGestureInsets.bottom,
    view.padding.bottom / dpr,
    view.viewPadding.bottom / dpr,
    view.systemGestureInsets.bottom / dpr,
  ].fold<double>(0, (current, value) => value > current ? value : current);
  if (inset > 0) {
    return inset;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 48;
  }
  return 0;
}
