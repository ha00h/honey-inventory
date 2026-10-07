import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/inventory_models.dart';
import '../../../../domain/services/inventory_services.dart';
import '../../shared/icon_catalog.dart';

class HexagonCell extends StatelessWidget {
  const HexagonCell({
    required this.product,
    required this.onTap,
    this.onLongPress,
    this.expanded = false,
    this.compact = false,
    this.cycleDue = false,
    super.key,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool expanded;

  /// Grid cells: icon only. Name/stock are drawn as an overlay caption.
  final bool compact;
  final bool cycleDue;

  @override
  Widget build(BuildContext context) {
    final fillRatio = stockFillRatio(product);
    final honeyStatus = product.isLowStock
        ? HiveHoneyStatus.lowStock
        : cycleDue
        ? HiveHoneyStatus.cycleDue
        : HiveHoneyStatus.normal;
    final stockText = product.currentStock % 1 == 0
        ? product.currentStock.toInt().toString()
        : product.currentStock.toStringAsFixed(1);

    return Semantics(
      button: true,
      label:
          '${product.name}, 재고 $stockText ${product.unit}${switch (honeyStatus) {
            HiveHoneyStatus.lowStock => ', 부족',
            HiveHoneyStatus.cycleDue => ', 구매 주기',
            HiveHoneyStatus.normal => '',
          }}',
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortest = math.min(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final scale = (shortest / 110).clamp(0.72, 1.25);
            final iconSize =
                (expanded
                    ? 44.0
                    : compact
                    ? 34.0
                    : 30.0) *
                scale;
            final corner = shortest * 0.04;

            return CustomPaint(
              painter: HoneycombPainter(
                fillRatio: fillRatio,
                honeyStatus: honeyStatus,
                cornerRadius: corner,
                castShadow: !compact,
                drawRim: !compact,
              ),
              child: ClipPath(
                clipper: RoundedHexClipper(cornerRadius: corner),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: compact ? shortest * 0.06 : shortest * 0.18,
                        ),
                        child: Icon(
                          iconForKey(product.iconKey),
                          size: iconSize,
                          color: _hiveIconColor(product.iconColor),
                        ),
                      ),
                    ),
                    if (!compact && !expanded)
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: shortest * 0.12,
                        child: Column(
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontSize: 12 * scale,
                                    height: 1.1,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onHoneyPrimary,
                                  ),
                            ),
                            Text(
                              '$stockText ${product.unit}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 11 * scale,
                                    height: 1.1,
                                    color: AppColors.onHoneySecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    if (expanded)
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 22,
                        child: Column(
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onHoneyPrimary,
                                  ),
                            ),
                            Text(
                              '$stockText ${product.unit}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: AppColors.onHoneySecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Color _hiveIconColor(String hex) {
  final color = parseIconColor(hex);
  if (color.computeLuminance() > 0.82) {
    return AppColors.onHoneyPrimary;
  }
  return color;
}

class HiveCellCaption extends StatelessWidget {
  const HiveCellCaption({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xF7FFFBF2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 11,
                height: 1.1,
                fontWeight: FontWeight.w700,
                color: AppColors.onHoneyPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCombCell extends StatelessWidget {
  const EmptyCombCell({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '빈 칸, 물품 추가',
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortest = math.min(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final corner = shortest * 0.04;
            return CustomPaint(
              painter: HoneycombPainter(
                fillRatio: 0,
                honeyStatus: HiveHoneyStatus.normal,
                isEmpty: true,
                cornerRadius: corner,
                castShadow: false,
                drawRim: false,
              ),
              child: ClipPath(
                clipper: RoundedHexClipper(cornerRadius: corner),
                child: Center(
                  child: Icon(
                    Icons.add_rounded,
                    size: (shortest * 0.26).clamp(18.0, 32.0),
                    color: AppColors.honeyAmber.withValues(alpha: 0.75),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LockedCombCell extends StatelessWidget {
  const LockedCombCell({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '잠긴 칸, 벌집 상점에서 열기',
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortest = math.min(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final corner = shortest * 0.04;
            return CustomPaint(
              painter: HoneycombPainter(
                fillRatio: 0,
                honeyStatus: HiveHoneyStatus.normal,
                isEmpty: true,
                cornerRadius: corner,
                castShadow: false,
                drawRim: false,
              ),
              child: ClipPath(
                clipper: RoundedHexClipper(cornerRadius: corner),
                child: ColoredBox(
                  color: const Color(0x66E8E0D0),
                  child: Center(
                    child: Icon(
                      Icons.lock_rounded,
                      size: (shortest * 0.22).clamp(16.0, 28.0),
                      color: AppColors.onHoneySecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HoneycombPainter extends CustomPainter {
  const HoneycombPainter({
    required this.fillRatio,
    required this.honeyStatus,
    this.isEmpty = false,
    this.cornerRadius = 16,
    this.castShadow = true,
    this.drawRim = true,
  });

  final double fillRatio;
  final HiveHoneyStatus honeyStatus;
  final bool isEmpty;
  final double cornerRadius;
  final bool castShadow;
  final bool drawRim;

  Color get _honeyColor => switch (honeyStatus) {
    HiveHoneyStatus.lowStock => AppColors.honeyLowStock,
    HiveHoneyStatus.cycleDue => AppColors.honeyCycleDue,
    HiveHoneyStatus.normal => AppColors.honeyFillStart,
  };

  Color get _innerColor => switch (honeyStatus) {
    HiveHoneyStatus.lowStock => const Color(0xFFFFF3EC),
    HiveHoneyStatus.cycleDue => const Color(0xFFE8F5E9),
    HiveHoneyStatus.normal => const Color(0xFFFFFBF2),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final outer = roundedHexagonPath(size, cornerRadius);
    final rim = (size.shortestSide * 0.12).clamp(12.0, 16.0);
    final inner = roundedHexagonPath(
      Size(size.width - rim * 2, size.height - rim * 2),
      cornerRadius * 0.7,
    ).shift(Offset(rim, rim));

    if (drawRim) {
      if (castShadow) {
        canvas.drawShadow(outer, const Color(0x3D000000), 8, false);
      }
      canvas.drawPath(
        outer,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isEmpty
                ? const [
                    Color(0xFFF0E0B0),
                    Color(0xFFE0C878),
                    Color(0xFFD4B45C),
                  ]
                : const [
                    Color(0xFFFFE89A),
                    Color(0xFFF5C842),
                    Color(0xFFE09A28),
                  ],
          ).createShader(Offset.zero & size),
      );
    }

    canvas.drawPath(
      inner,
      Paint()..color = isEmpty ? const Color(0xFFF6EDD8) : _innerColor,
    );

    canvas.save();
    canvas.clipPath(inner);
    canvas.drawRect(
      Rect.fromLTWH(
        rim,
        rim,
        size.width - rim * 2,
        (size.height - rim * 2) * 0.38,
      ),
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0x22000000), const Color(0x00000000)],
            ).createShader(
              Rect.fromLTWH(rim, rim, size.width - rim * 2, size.height * 0.4),
            ),
    );

    if (!isEmpty && fillRatio > 0) {
      final innerHeight = size.height - rim * 2;
      final honeyHeight = innerHeight * fillRatio.clamp(0.0, 1.0);
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          rim + innerHeight - honeyHeight,
          size.width,
          honeyHeight,
        ),
        Paint()..color = _honeyColor,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HoneycombPainter oldDelegate) {
    return oldDelegate.fillRatio != fillRatio ||
        oldDelegate.honeyStatus != honeyStatus ||
        oldDelegate.isEmpty != isEmpty ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.castShadow != castShadow ||
        oldDelegate.drawRim != drawRim;
  }
}

Path roundedHexagonPath(Size size, double radius) {
  final vertices = <Offset>[
    Offset(size.width * 0.5, 0),
    Offset(size.width, size.height * 0.25),
    Offset(size.width, size.height * 0.75),
    Offset(size.width * 0.5, size.height),
    Offset(0, size.height * 0.75),
    Offset(0, size.height * 0.25),
  ];

  final path = Path();
  for (var i = 0; i < vertices.length; i++) {
    final prev = vertices[(i + vertices.length - 1) % vertices.length];
    final curr = vertices[i];
    final next = vertices[(i + 1) % vertices.length];
    final toPrev = curr - prev;
    final toNext = next - curr;
    final dPrev = toPrev.distance;
    final dNext = toNext.distance;
    final corner = math.min(radius, math.min(dPrev, dNext) / 2.4);
    final start = curr - toPrev * (corner / dPrev);
    final end = curr + toNext * (corner / dNext);
    if (i == 0) {
      path.moveTo(start.dx, start.dy);
    } else {
      path.lineTo(start.dx, start.dy);
    }
    path.quadraticBezierTo(curr.dx, curr.dy, end.dx, end.dy);
  }
  path.close();
  return path;
}

class RoundedHexClipper extends CustomClipper<Path> {
  const RoundedHexClipper({required this.cornerRadius});

  final double cornerRadius;

  @override
  Path getClip(Size size) => roundedHexagonPath(size, cornerRadius);

  @override
  bool shouldReclip(covariant RoundedHexClipper oldClipper) {
    return oldClipper.cornerRadius != cornerRadius;
  }
}
