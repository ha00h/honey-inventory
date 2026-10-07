import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/domain/entities/inventory_models.dart';
import 'package:honey_inventory/domain/services/product_matcher.dart';

Product _product(String id, String name) {
  return Product(
    id: id,
    name: name,
    unit: '개',
    currentStock: 1,
    maxStock: 3,
    minStock: 1,
    iconKey: 'basket',
    isActive: true,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  final products = [
    _product('1', '휴지'),
    _product('2', '생수'),
    _product('3', '세제'),
  ];

  test('정확한 이름으로 물품을 매칭한다', () {
    final match = matchProductByName('휴지', products);
    expect(match?.product.id, '1');
    expect(match?.matchType, ProductMatchType.exact);
  });

  test('공백을 무시하고 물품을 매칭한다', () {
    final match = matchProductByName('생 수', products);
    expect(match?.product.id, '2');
    expect(match?.matchType, ProductMatchType.normalized);
  });

  test('부분 일치 이름으로 물품을 매칭한다', () {
    final match = matchProductByName('생수 2L', products);
    expect(match?.product.id, '2');
    expect(match?.matchType, ProductMatchType.contains);
  });
}
