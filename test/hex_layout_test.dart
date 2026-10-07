import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/presentation/hive/widgets/hex_layout.dart';

void main() {
  test('빈 벌집도 첫 링 7칸을 유지한다', () {
    expect(completeHiveSlots(0), 7);
    expect(completeHiveSlots(1), 7);
    expect(completeHiveSlots(7), 7);
    expect(completeHiveSlots(8), 19);
  });

  test('나선은 가운데부터 이웃 링으로 쌓인다', () {
    final ring1 = hexSpiral(7);
    expect(ring1.first, (0, 0));
    expect(ring1.toSet().length, 7);

    final neighbors = ring1.skip(1).toSet();
    expect(neighbors, {(-1, 0), (0, -1), (1, -1), (1, 0), (0, 1), (-1, 1)});
  });

  test('육각 픽셀 배치는 맞물리는 너비를 만든다', () {
    const hexW = 100.0;
    const hexH = hexW / hexWidthToHeight;
    final layout = layoutHoneycomb(
      slotCount: 7,
      hexWidth: hexW,
      hexHeight: hexH,
    );

    expect(layout.origins.length, 7);
    expect(layout.width, closeTo(3 * hexW, 0.001));
    expect(layout.height, closeTo(2.5 * hexH, 0.001));
  });

  test('워치 초점은 가운데가 크고 가장자리는 작다', () {
    expect(honeycombWatchScale(0, 100), 1);
    expect(honeycombWatchScale(100, 100), closeTo(0.48, 0.001));
    expect(honeycombWatchScale(40, 100), lessThan(1));
    expect(honeycombWatchScale(40, 100), greaterThan(0.48));
  });

  test('워치 기울기는 오른쪽에서 왼쪽으로 기울어진다', () {
    final tilt = honeycombWatchTilt(const Offset(100, 0), 100);
    expect(tilt.$1, 0);
    expect(tilt.$2, lessThan(0));
  });

  test('돋보기는 가운데를 확대한다', () {
    expect(hiveLensSourceUv(const Offset(0.5, 0.5)), const Offset(0.5, 0.5));
    final sampled = hiveLensSourceUv(const Offset(0.6, 0.5));
    expect(sampled.dx, greaterThan(0.5));
    expect(sampled.dx, lessThan(0.6));
    expect(
      hiveLensSourceUv(const Offset(0.6, 0.5), amount: 0),
      const Offset(0.6, 0.5),
    );
  });
}
