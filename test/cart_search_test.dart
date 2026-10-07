import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/domain/entities/inventory_models.dart';
import 'package:honey_inventory/domain/services/inventory_services.dart';

void main() {
  test('검색어로 장바구니 그룹을 필터링한다', () {
    final groups = [
      CartStoreGroup(
        storeName: '이마트',
        items: [
          CartItem(
            id: 'c1',
            productId: 'p1',
            quantity: 1,
            addedAt: DateTime(2026),
          ),
        ],
      ),
    ];

    final filtered = filterCartGroupsByQuery(
      groups: groups,
      productNameById: const {'p1': '휴지'},
      query: '휴지',
    );

    expect(filtered, hasLength(1));
    expect(filtered.first.items, hasLength(1));
  });

  test('구매처 그룹을 최근 방문순으로 정렬한다', () {
    final groups = groupCartItemsByStore(
      cartItems: [
        CartItem(
          id: 'c1',
          productId: 'p1',
          quantity: 1,
          preferredStoreName: '이마트',
          addedAt: DateTime(2026, 1, 1),
        ),
        CartItem(
          id: 'c2',
          productId: 'p2',
          quantity: 1,
          preferredStoreName: '코스트코',
          addedAt: DateTime(2026, 1, 2),
        ),
        CartItem(
          id: 'c3',
          productId: 'p3',
          quantity: 1,
          preferredStoreName: '구매처 미정',
          addedAt: DateTime(2026, 1, 3),
        ),
      ],
      storeNameByProductId: const {},
      lastVisitByStoreName: {
        '이마트': DateTime(2026, 6, 1),
        '코스트코': DateTime(2026, 7, 1),
      },
    );

    expect(groups.map((group) => group.storeName).toList(), [
      '코스트코',
      '이마트',
      '구매처 미정',
    ]);
  });

  test('검색어로 담을 수 있는 물품을 찾는다', () {
    final products = [
      Product(
        id: 'p2',
        name: '생수',
        unit: '병',
        currentStock: 2,
        maxStock: 6,
        minStock: 1,
        iconKey: 'water',
        isActive: true,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    ];

    final addable = findProductsToAddToCart(
      query: '생수',
      products: products,
      cartProductIds: const {'p1'},
    );

    expect(addable, hasLength(1));
    expect(addable.first.name, '생수');
  });

  test('같은 이름이 없으면 장바구니에서 새로 만들 수 있다', () {
    final products = [
      Product(
        id: 'p2',
        name: '생수',
        unit: '병',
        currentStock: 2,
        maxStock: 6,
        minStock: 1,
        iconKey: 'water',
        isActive: true,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    ];

    expect(
      shouldCreateProductFromCartQuery(query: '휴지', products: products),
      isTrue,
    );
    expect(
      shouldCreateProductFromCartQuery(query: '생수', products: products),
      isFalse,
    );
    expect(
      findExactProductByName(query: ' 생수 ', products: products)?.id,
      'p2',
    );
  });
}
