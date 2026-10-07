import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/domain/services/hive_slots.dart';

void main() {
  test('빈 칸 번호는 가장 앞 구멍을 고른다', () {
    expect(nextEmptyHiveSlot(const []), 0);
    expect(nextEmptyHiveSlot(const [0, 1, 2]), 3);
    expect(nextEmptyHiveSlot(const [0, 2, 3]), 1);
  });

  test('빈 칸으로 옮기면 원래 자리는 비운다', () {
    final next = applyHiveMove(
      slotsByProductId: {'a': 0, 'b': 1},
      movingProductId: 'a',
      toSlot: 4,
    );
    expect(next, {'a': 4, 'b': 1});
  });

  test('채워진 칸으로 옮기면 자리를 맞바꾼다', () {
    final next = applyHiveMove(
      slotsByProductId: {'a': 0, 'b': 2, 'c': 3},
      movingProductId: 'a',
      toSlot: 3,
    );
    expect(next, {'a': 3, 'b': 2, 'c': 0});
  });

  test('같은 칸이면 그대로 둔다', () {
    final slots = {'a': 1, 'b': 2};
    expect(
      applyHiveMove(
        slotsByProductId: slots,
        movingProductId: 'a',
        toSlot: 1,
      ),
      slots,
    );
  });

  test('백업에 칸 번호가 없으면 앞에서부터 채운다', () {
    expect(resolveImportedHiveSlots(const [null, null, null]), [0, 1, 2]);
  });

  test('칸 번호가 겹치면 뒤에 온 물품만 빈 칸으로 보낸다', () {
    expect(resolveImportedHiveSlots(const [0, 0, 2]), [0, 1, 2]);
  });
}
