import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/domain/services/receipt_parser.dart';

void main() {
  test('영수증 텍스트에서 품목과 구매처를 파싱한다', () {
    const text = '''
이마트 성수점
휴지 2 x 12000원
생수 6,500원
합계 18,500원
''';

    final result = parseReceiptText(text);

    expect(result.storeName, '이마트 성수점');
    expect(result.items.length, greaterThanOrEqualTo(1));
    expect(result.items.first.name, contains('휴지'));
  });

  test('품목명 뒤 수량 패턴을 파싱한다', () {
    const text = '''
코스트코
생수 2L 6병
휴지 3개
''';

    final result = parseReceiptText(text);

    expect(result.items.length, greaterThanOrEqualTo(2));
    expect(result.items.any((item) => item.name.contains('생수')), isTrue);
  });
}
