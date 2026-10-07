import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../domain/entities/inventory_models.dart';
import '../../../../domain/services/hive_economy.dart';
import 'hex_layout.dart';
import 'hexagon_cell.dart';

typedef HiveMoveCallback = void Function(int fromSlot, int toSlot);

class HexagonGrid extends StatefulWidget {
  const HexagonGrid({
    required this.products,
    required this.onProductTap,
    required this.onEmptyCellTap,
    this.unlockedCells = freeHiveCells,
    this.isPro = false,
    this.cycleDueProductIds = const {},
    this.onMoveProduct,
    this.onLockedCellTap,
    super.key,
  });

  final List<Product> products;
  final Set<String> cycleDueProductIds;
  final ValueChanged<Product> onProductTap;
  final HiveMoveCallback? onMoveProduct;
  final VoidCallback onEmptyCellTap;
  final VoidCallback? onLockedCellTap;
  final int unlockedCells;
  final bool isPro;

  @override
  State<HexagonGrid> createState() => _HexagonGridState();
}

class _HexagonGridState extends State<HexagonGrid>
    with SingleTickerProviderStateMixin {
  /// Overlap so gold rims fuse into shared wax walls.
  static const _nest = 18.0;

  late final AnimationController _snap;
  Offset? _userPan;
  Offset? _snapFrom;
  Offset? _snapTo;
  bool _reordering = false;
  int? _draggingSlot;

  @override
  void initState() {
    super.initState();
    _snap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _snap.dispose();
    super.dispose();
  }

  Offset _panFor({
    required HexPixelLayout layout,
    required Size viewport,
    required double cellWidth,
    required double cellHeight,
    required int index,
  }) {
    final origin = layout.origins[index];
    final focus = Offset(viewport.width / 2, viewport.height / 2);
    return focus - origin - Offset(cellWidth / 2, cellHeight / 2);
  }

  Offset _clampedPan(
    Offset pan, {
    required HexPixelLayout layout,
    required Size viewport,
    required double cellWidth,
    required double cellHeight,
  }) {
    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;
    for (var i = 0; i < layout.origins.length; i++) {
      final centered = _panFor(
        layout: layout,
        viewport: viewport,
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        index: i,
      );
      minX = math.min(minX, centered.dx);
      minY = math.min(minY, centered.dy);
      maxX = math.max(maxX, centered.dx);
      maxY = math.max(maxY, centered.dy);
    }
    return Offset(pan.dx.clamp(minX, maxX), pan.dy.clamp(minY, maxY));
  }

  Offset _nearestPan(
    Offset pan, {
    required HexPixelLayout layout,
    required Size viewport,
    required double cellWidth,
    required double cellHeight,
  }) {
    var best = pan;
    var bestDist = double.infinity;
    for (var i = 0; i < layout.origins.length; i++) {
      final candidate = _panFor(
        layout: layout,
        viewport: viewport,
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        index: i,
      );
      final dist = (candidate - pan).distanceSquared;
      if (dist < bestDist) {
        bestDist = dist;
        best = candidate;
      }
    }
    return best;
  }

  void _animateTo(Offset target) {
    final begin = _displayedPan();
    _snapFrom = begin;
    _snapTo = target;
    _userPan = target;
    _snap.forward(from: 0);
  }

  Offset _displayedPan() {
    if (_snap.isAnimating && _snapFrom != null && _snapTo != null) {
      final t = Curves.easeOutCubic.transform(_snap.value);
      return Offset.lerp(_snapFrom!, _snapTo!, t)!;
    }
    return _userPan ?? Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);
        final bySlot = <int, Product>{
          for (final product in widget.products) product.hiveSlot: product,
        };
        var occupiedEnd = 0;
        for (final product in widget.products) {
          if (product.hiveSlot + 1 > occupiedEnd) {
            occupiedEnd = product.hiveSlot + 1;
          }
        }
        final slotCount = widget.isPro
            ? completeHiveSlots(occupiedEnd)
            : () {
                final owned = widget.unlockedCells > occupiedEnd
                    ? widget.unlockedCells
                    : occupiedEnd;
                if (widget.products.length >= widget.unlockedCells) {
                  return completeHiveSlots(owned + 1);
                }
                return completeHiveSlots(owned);
              }();
        final hexWidth = math.min(
          122.0,
          math.max(100.0, viewport.width * 0.33),
        );
        final hexHeight = hexWidth / hexWidthToHeight;
        final cellW = hexWidth + _nest;
        final cellH = hexHeight + _nest;
        final layout = layoutHoneycomb(
          slotCount: slotCount,
          hexWidth: hexWidth,
          hexHeight: hexHeight,
        );
        final centered = _panFor(
          layout: layout,
          viewport: viewport,
          cellWidth: cellW,
          cellHeight: cellH,
          index: 0,
        );
        final pan = (_userPan == null && !_snap.isAnimating)
            ? centered
            : _clampedPan(
                _displayedPan(),
                layout: layout,
                viewport: viewport,
                cellWidth: cellW,
                cellHeight: cellH,
              );

        final look = pan - centered;
        final tiltX = (look.dy / (hexHeight * 1.6)).clamp(-1.0, 1.0) * 0.26;
        final tiltY = -(look.dx / (hexWidth * 1.6)).clamp(-1.0, 1.0) * 0.26;

        final hive = SizedBox(
          width: layout.width + _nest,
          height: layout.height + _nest + 28,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: layout.width + _nest,
                height: layout.height + _nest,
                child: CustomPaint(
                  size: Size(layout.width + _nest, layout.height + _nest),
                  painter: _WaxBedPainter(
                    origins: layout.origins,
                    cellWidth: cellW,
                    cellHeight: cellH,
                    cornerRadius: 1.5,
                  ),
                ),
              ),
              for (var i = 0; i < layout.origins.length; i++)
                Positioned(
                  left: layout.origins[i].dx,
                  top: layout.origins[i].dy,
                  width: cellW,
                  height: cellH,
                  child: _buildCell(
                    i,
                    bySlot: bySlot,
                    cellWidth: cellW,
                    cellHeight: cellH,
                  ),
                ),
              for (var i = 0; i < layout.origins.length; i++)
                if (bySlot[i] != null && _draggingSlot != i)
                  Positioned(
                    left: layout.origins[i].dx,
                    top: layout.origins[i].dy + cellH * 0.78,
                    width: cellW,
                    child: HiveCellCaption(product: bySlot[i]!),
                  ),
            ],
          ),
        );

        return Semantics(
          hint: '벌집을 드래그해 둘러보고, 오래 누르면 자리를 옮길 수 있어요',
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: _reordering
                ? null
                : (_) {
                    if (_snap.isAnimating) {
                      _userPan = _displayedPan();
                      _snap.stop();
                    }
                  },
            onPanUpdate: _reordering
                ? null
                : (details) {
                    setState(() {
                      final next = (_userPan ?? pan) + details.delta;
                      _userPan = _clampedPan(
                        next,
                        layout: layout,
                        viewport: viewport,
                        cellWidth: cellW,
                        cellHeight: cellH,
                      );
                    });
                  },
            onPanEnd: _reordering
                ? null
                : (details) {
                    final projected =
                        (_userPan ?? pan) +
                        details.velocity.pixelsPerSecond * 0.12;
                    final target = _nearestPan(
                      _clampedPan(
                        projected,
                        layout: layout,
                        viewport: viewport,
                        cellWidth: cellW,
                        cellHeight: cellH,
                      ),
                      layout: layout,
                      viewport: viewport,
                      cellWidth: cellW,
                      cellHeight: cellH,
                    );
                    _animateTo(target);
                  },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Color(0x00FFFBF0), Color(0x4DFFFBF0)],
                          stops: [0.58, 1],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: pan.dx,
                  top: pan.dy,
                  child: Transform(
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.medium,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.00105)
                      ..rotateX(tiltX)
                      ..rotateY(tiltY),
                    child: hive,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(
    int index, {
    required Map<int, Product> bySlot,
    required double cellWidth,
    required double cellHeight,
  }) {
    final product = bySlot[index];
    final lockedFrom = lockedHiveCellStart(
      isPro: widget.isPro,
      unlockedHiveCells: widget.unlockedCells,
      productCount: widget.products.length,
    );
    final locked = index >= lockedFrom;

    Widget cell;
    if (product != null) {
      cell = LongPressDraggable<int>(
        data: index,
        delay: const Duration(milliseconds: 350),
        hapticFeedbackOnStart: true,
        onDragStarted: () {
          setState(() {
            _reordering = true;
            _draggingSlot = index;
          });
        },
        onDragEnd: (_) {
          setState(() {
            _reordering = false;
            _draggingSlot = null;
          });
        },
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: cellWidth,
            height: cellHeight,
            child: HexagonCell(
              product: product,
              compact: true,
              cycleDue: widget.cycleDueProductIds.contains(product.id),
              onTap: () {},
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.28,
          child: HexagonCell(
            product: product,
            compact: true,
            cycleDue: widget.cycleDueProductIds.contains(product.id),
            onTap: () {},
          ),
        ),
        child: HexagonCell(
          product: product,
          compact: true,
          cycleDue: widget.cycleDueProductIds.contains(product.id),
          onTap: () => widget.onProductTap(product),
        ),
      );
    } else if (locked) {
      cell = LockedCombCell(
        onTap: widget.onLockedCellTap ?? widget.onEmptyCellTap,
      );
    } else {
      cell = EmptyCombCell(onTap: widget.onEmptyCellTap);
    }

    if (locked || widget.onMoveProduct == null) {
      return cell;
    }

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) {
        widget.onMoveProduct!(details.data, index);
      },
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        return AnimatedScale(
          scale: hovering ? 1.06 : 1,
          duration: const Duration(milliseconds: 120),
          child: cell,
        );
      },
    );
  }
}

class _WaxBedPainter extends CustomPainter {
  const _WaxBedPainter({
    required this.origins,
    required this.cellWidth,
    required this.cellHeight,
    required this.cornerRadius,
  });

  final List<Offset> origins;
  final double cellWidth;
  final double cellHeight;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final wax = Paint()..color = const Color(0xFFF5C842);
    for (final origin in origins) {
      final path = roundedHexagonPath(
        Size(cellWidth, cellHeight),
        cornerRadius,
      ).shift(origin);
      canvas.drawPath(path, wax);
    }
  }

  @override
  bool shouldRepaint(covariant _WaxBedPainter oldDelegate) {
    return oldDelegate.origins != origins ||
        oldDelegate.cellWidth != cellWidth ||
        oldDelegate.cellHeight != cellHeight ||
        oldDelegate.cornerRadius != cornerRadius;
  }
}
