import 'dart:math' as math;
import 'dart:ui';

/// Pointy-top regular hexagon: width / height = √3 / 2.
const hexWidthToHeight = 0.8660254037844386;

/// Cube/axial neighbor order used to walk each ring.
const _axialDirections = <(int, int)>[
  (1, -1),
  (1, 0),
  (0, 1),
  (-1, 1),
  (-1, 0),
  (0, -1),
];

/// Smallest complete honeycomb that can hold [filled] cells.
/// Always at least the first ring (7), so an empty hive still looks like a comb.
int completeHiveSlots(int filled) {
  var slots = 1;
  var ring = 0;
  final need = math.max(filled, 1);
  while (slots < need || ring < 1) {
    ring += 1;
    slots += 6 * ring;
  }
  return slots;
}

int hiveRingCount(int slots) {
  var ring = 0;
  var n = 1;
  while (n < slots) {
    ring += 1;
    n += 6 * ring;
  }
  return ring;
}

/// Axial coordinates in center-out spiral order: origin, then ring 1, ring 2, …
List<(int q, int r)> hexSpiral(int count) {
  if (count <= 0) {
    return const [];
  }

  final cells = <(int, int)>[(0, 0)];
  var ring = 1;
  while (cells.length < count) {
    var q = -ring;
    var r = 0;
    for (var d = 0; d < 6; d++) {
      for (var step = 0; step < ring; step++) {
        cells.add((q, r));
        if (cells.length >= count) {
          return cells;
        }
        q += _axialDirections[d].$1;
        r += _axialDirections[d].$2;
      }
    }
    ring += 1;
  }
  return cells;
}

class HexPixelLayout {
  const HexPixelLayout({
    required this.width,
    required this.height,
    required this.origins,
  });

  final double width;
  final double height;
  final List<Offset> origins;
}

/// Pixel positions for pointy-top hexes whose left/top is the cell origin.
HexPixelLayout layoutHoneycomb({
  required int slotCount,
  required double hexWidth,
  required double hexHeight,
}) {
  final coords = hexSpiral(slotCount);
  final centers = <Offset>[
    for (final coord in coords)
      Offset(hexWidth * (coord.$1 + coord.$2 / 2), hexHeight * 0.75 * coord.$2),
  ];

  var minX = 0.0;
  var minY = 0.0;
  var maxX = 0.0;
  var maxY = 0.0;
  for (final center in centers) {
    minX = math.min(minX, center.dx);
    minY = math.min(minY, center.dy);
    maxX = math.max(maxX, center.dx);
    maxY = math.max(maxY, center.dy);
  }

  return HexPixelLayout(
    width: (maxX - minX) + hexWidth,
    height: (maxY - minY) + hexHeight,
    origins: [
      for (final center in centers) Offset(center.dx - minX, center.dy - minY),
    ],
  );
}

/// Apple Watch-style scale: 1 at the focus, smaller toward the edges.
double honeycombWatchScale(double distance, double falloff) {
  if (falloff <= 0) {
    return 1;
  }
  final t = (distance / falloff).clamp(0.0, 1.0);
  final smooth = t * t * (3 - 2 * t);
  return 1.0 - smooth * 0.52;
}

/// 2.5D tilt in radians: (rotateX, rotateY).
(double rotateX, double rotateY) honeycombWatchTilt(
  Offset delta,
  double falloff,
) {
  if (falloff <= 0) {
    return (0, 0);
  }
  final nx = (delta.dx / falloff).clamp(-1.0, 1.0);
  final ny = (delta.dy / falloff).clamp(-1.0, 1.0);
  return (ny * 0.55, -nx * 0.55);
}

/// Maps a display UV (0–1) to the source UV sampled by the hive magnifier.
Offset hiveLensSourceUv(Offset uv, {double amount = 1.0}) {
  final c = Offset(uv.dx - 0.5, uv.dy - 0.5);
  final t = _smoothstep(0, 0.88, c.distance);
  final warped = 0.68 + 0.32 * t;
  final scale = 1.0 + (warped - 1.0) * amount;
  return Offset(0.5 + c.dx * scale, 0.5 + c.dy * scale);
}

/// Maps a local display point to the child point shown under the lens.
Offset hiveLensSourcePoint(Offset local, Size size, {double amount = 1.0}) {
  if (size.isEmpty) {
    return local;
  }
  final uv = Offset(local.dx / size.width, local.dy / size.height);
  final src = hiveLensSourceUv(uv, amount: amount);
  return Offset(src.dx * size.width, src.dy * size.height);
}

double _smoothstep(double edge0, double edge1, double x) {
  if (edge1 == edge0) {
    return x >= edge1 ? 1.0 : 0.0;
  }
  final t = ((x - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
  return t * t * (3 - 2 * t);
}
