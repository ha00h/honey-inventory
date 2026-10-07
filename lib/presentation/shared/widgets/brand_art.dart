import 'package:flutter/material.dart';

abstract final class BrandAssets {
  static const bee = 'assets/brand/bee.png';
  static const hexagon = 'assets/brand/hexagon.png';
  static const honeyJar = 'assets/brand/honey_jar.png';
  static const honey = 'assets/brand/honey.png';
  static const settings = 'assets/brand/settings.png';
}

class BrandImage extends StatelessWidget {
  const BrandImage.bee({this.size = 88, this.zoom = 1, super.key})
    : asset = BrandAssets.bee;

  const BrandImage.hexagon({this.size = 88, this.zoom = 1, super.key})
    : asset = BrandAssets.hexagon;

  const BrandImage.honeyJar({this.size = 88, this.zoom = 1, super.key})
    : asset = BrandAssets.honeyJar;

  const BrandImage.honey({this.size = 88, this.zoom = 1, super.key})
    : asset = BrandAssets.honey;

  const BrandImage.settings({this.size = 88, this.zoom = 1, super.key})
    : asset = BrandAssets.settings;

  final String asset;
  final double size;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
    if (zoom == 1) {
      return image;
    }
    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: Transform.scale(scale: zoom, child: image),
      ),
    );
  }
}
