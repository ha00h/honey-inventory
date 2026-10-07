import 'dart:convert';

/// Household-scale backup payload for QA: many everyday products plus a
/// ledger-like history on 3겹 화장지.
String householdSimulationBackupJson() {
  const tissueId = 'sim_tissue';
  final tissue = _foldStock(
    productId: tissueId,
    idPrefix: 'sim_tissue',
    events: const [
      (at: '2026-05-12T10:00:00.000', delta: 12.0, reason: 'initial'),
      (at: '2026-05-15T19:10:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-05-18T18:40:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-05-21T20:05:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-05-24T19:30:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-05-27T09:15:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-05-30T21:00:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-06-02T19:20:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-06-05T18:50:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-06-08T11:10:00.000', delta: -2.0, reason: 'usage'),
      (at: '2026-06-10T16:45:00.000', delta: 12.0, reason: 'purchase'),
      (at: '2026-06-13T19:00:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-06-16T20:30:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-06-19T18:15:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-06-22T19:40:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-06-25T08:20:00.000', delta: -1.0, reason: 'discard'),
      (at: '2026-06-28T19:10:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-01T18:55:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-04T19:25:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-07T20:00:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-10T09:40:00.000', delta: -1.0, reason: 'adjust'),
      (at: '2026-07-13T19:05:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-16T18:30:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-18T17:20:00.000', delta: 12.0, reason: 'purchase'),
      (at: '2026-07-21T19:15:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-24T18:45:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-27T19:50:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-07-30T20:10:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-02T19:00:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-05T18:20:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-08T19:35:00.000', delta: -2.0, reason: 'usage'),
      (at: '2026-08-12T18:55:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-15T19:40:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-18T20:05:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-21T19:10:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-24T09:00:00.000', delta: -1.0, reason: 'discard'),
      (at: '2026-08-26T16:30:00.000', delta: 10.0, reason: 'purchase'),
      (at: '2026-08-29T19:20:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-01T18:40:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-03T19:15:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-05T20:00:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-06T18:30:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-07T19:45:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-08T08:20:00.000', delta: -1.0, reason: 'usage'),
    ],
  );

  final water = _foldStock(
    productId: 'sim_water',
    idPrefix: 'sim_water',
    events: const [
      (at: '2026-08-01T11:00:00.000', delta: 12.0, reason: 'initial'),
      (at: '2026-08-08T19:00:00.000', delta: -2.0, reason: 'usage'),
      (at: '2026-08-16T18:30:00.000', delta: -2.0, reason: 'usage'),
      (at: '2026-08-24T19:10:00.000', delta: -2.0, reason: 'usage'),
      (at: '2026-08-30T17:00:00.000', delta: 12.0, reason: 'purchase'),
      (at: '2026-09-04T19:20:00.000', delta: -2.0, reason: 'usage'),
    ],
  );

  final milk = _foldStock(
    productId: 'sim_milk',
    idPrefix: 'sim_milk',
    events: const [
      (at: '2026-08-20T09:00:00.000', delta: 4.0, reason: 'initial'),
      (at: '2026-08-23T08:00:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-26T08:10:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-28T07:50:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-08-29T18:00:00.000', delta: 4.0, reason: 'purchase'),
      (at: '2026-09-01T08:00:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-04T08:20:00.000', delta: -1.0, reason: 'usage'),
      (at: '2026-09-07T08:00:00.000', delta: -1.0, reason: 'usage'),
    ],
  );

  const colors = [
    '#3D2E1F',
    '#F5C842',
    '#E8A838',
    '#FF8C69',
    '#E57373',
    '#F48FB1',
    '#CE93D8',
    '#64B5F6',
    '#4DB6AC',
    '#81C784',
    '#FFD54F',
    '#FFB74D',
    '#A1887F',
    '#90A4AE',
    '#5D4037',
  ];

  final products = <Map<String, dynamic>>[
    _product(
      id: tissueId,
      name: '3겹 화장지',
      category: 'hygiene',
      unit: '롤',
      current: tissue.stock,
      max: 16,
      min: 8,
      iconKey: 'tissue',
      iconColor: '#F5C842',
      createdAt: '2026-05-12T10:00:00.000',
    ),
    _product(
      id: 'sim_water',
      name: '생수 2L',
      category: 'food',
      unit: '병',
      current: water.stock,
      max: 24,
      min: 6,
      iconKey: 'water',
      iconColor: '#64B5F6',
      createdAt: '2026-08-01T11:00:00.000',
    ),
    _product(
      id: 'sim_milk',
      name: '우유',
      category: 'food',
      unit: '팩',
      current: milk.stock,
      max: 6,
      min: 2,
      iconKey: 'milk',
      iconColor: '#FFFFFF',
      createdAt: '2026-08-20T09:00:00.000',
    ),
    ..._catalogProducts(colors),
  ];

  final cycles = [
    _cycle(
      id: 'sim_tissue_cycle',
      productId: tissueId,
      intervalDays: 14,
      lastPurchase: '2026-08-26T16:30:00.000',
      nextReminder: '2026-09-09T09:00:00.000',
    ),
    _cycle(
      id: 'sim_water_cycle',
      productId: 'sim_water',
      intervalDays: 10,
      lastPurchase: '2026-08-30T17:00:00.000',
      nextReminder: '2026-09-09T09:00:00.000',
    ),
    _cycle(
      id: 'sim_milk_cycle',
      productId: 'sim_milk',
      intervalDays: 7,
      lastPurchase: '2026-08-29T18:00:00.000',
      nextReminder: '2026-09-05T09:00:00.000',
    ),
    _cycle(
      id: 'sim_detergent_cycle',
      productId: 'sim_detergent',
      intervalDays: 30,
      lastPurchase: '2026-08-01T10:00:00.000',
      nextReminder: '2026-08-31T09:00:00.000',
    ),
    _cycle(
      id: 'sim_shampoo_cycle',
      productId: 'sim_shampoo',
      intervalDays: 21,
      lastPurchase: '2026-08-20T10:00:00.000',
      nextReminder: '2026-09-10T09:00:00.000',
    ),
    _cycle(
      id: 'sim_rice_cycle',
      productId: 'sim_rice',
      intervalDays: 45,
      lastPurchase: '2026-07-20T11:00:00.000',
      nextReminder: '2026-09-03T09:00:00.000',
    ),
  ];

  final payload = {
    'version': 1,
    'exportedAt': '2026-09-08T11:00:00.000',
    'settings': {
      'notificationsEnabled': true,
      'notificationHour': 9,
      'notificationMinute': 0,
      'hasSeenOnboarding': true,
      'snoozedUntilByProductId': <String, String>{},
      'dismissedReminderProductIds': <String>[],
      'themeMode': 'light',
      'honeyPoints': 0,
      'unlockedHiveCells': 61,
      'isPro': false,
      'adsWatchedToday': 0,
    },
    'products': products,
    'purchaseCycles': cycles,
    'stockHistories': [
      ...tissue.histories,
      ...water.histories,
      ...milk.histories,
      for (final product in products)
        if (product['id'] != tissueId &&
            product['id'] != 'sim_water' &&
            product['id'] != 'sim_milk')
          {
            'id': '${product['id']}_h0',
            'productId': product['id'],
            'delta': product['currentStock'],
            'stockAfter': product['currentStock'],
            'reason': 'initial',
            'createdAt': product['createdAt'],
          },
    ],
    'purchaseRecords': [
      ...tissue.purchases,
      ...water.purchases,
      ...milk.purchases,
    ],
    'cartItems': [
      {
        'id': 'sim_cart_tissue',
        'productId': tissueId,
        'quantity': 1.0,
        'preferredStoreName': '이마트',
        'note': '3겹 30롤',
        'addedAt': '2026-09-08T08:30:00.000',
      },
      {
        'id': 'sim_cart_milk',
        'productId': 'sim_milk',
        'quantity': 2.0,
        'preferredStoreName': '편의점',
        'note': null,
        'addedAt': '2026-09-07T21:00:00.000',
      },
      {
        'id': 'sim_cart_battery',
        'productId': 'sim_battery',
        'quantity': 1.0,
        'preferredStoreName': null,
        'note': 'AA 8알',
        'addedAt': '2026-09-06T12:00:00.000',
      },
    ],
  };

  return const JsonEncoder.withIndent('  ').convert(payload);
}

List<Map<String, dynamic>> _catalogProducts(List<String> colors) {
  const rows = <List<Object>>[
    ['sim_wipes', '물티슈', 'hygiene', '팩', 3, 8, 2, 'wipes'],
    ['sim_detergent', '주방세제', 'kitchen', '개', 1, 3, 1, 'detergent'],
    ['sim_laundry', '세탁세제', 'laundry', '개', 2, 3, 1, 'laundry'],
    ['sim_softener', '섬유유연제', 'laundry', '개', 1, 2, 1, 'laundry'],
    ['sim_shampoo', '샴푸', 'hygiene', '개', 1, 2, 1, 'shampoo'],
    ['sim_rinse', '린스', 'hygiene', '개', 1, 2, 1, 'shampoo'],
    ['sim_bodywash', '바디워시', 'bathroom', '개', 2, 3, 1, 'soap'],
    ['sim_soap', '비누', 'hygiene', '개', 4, 8, 2, 'soap'],
    ['sim_toothbrush', '칫솔', 'hygiene', '개', 6, 10, 3, 'toothbrush'],
    ['sim_toothpaste', '치약', 'hygiene', '개', 2, 4, 1, 'toothbrush'],
    ['sim_towel', '수건', 'bathroom', '장', 8, 12, 4, 'towel'],
    ['sim_trashbag', '쓰레기봉투', 'household', '묶음', 5, 10, 2, 'trash'],
    ['sim_sponge', '수세미', 'kitchen', '개', 6, 12, 3, 'sponge'],
    ['sim_wrap', '랩', 'kitchen', '개', 2, 4, 1, 'wrap'],
    ['sim_foil', '알루미늄 호일', 'kitchen', '개', 1, 3, 1, 'wrap'],
    ['sim_kitchentowel', '키친타올', 'kitchen', '롤', 4, 8, 2, 'tissue'],
    ['sim_egg', '달걀', 'food', '판', 1, 3, 1, 'egg'],
    ['sim_rice', '쌀 10kg', 'food', '포대', 1, 2, 1, 'rice'],
    ['sim_ramen', '라면', 'food', '봉지', 8, 20, 6, 'ramen'],
    ['sim_coffee', '커피', 'food', '봉지', 2, 4, 1, 'coffee'],
    ['sim_oil', '식용유', 'food', '병', 1, 2, 1, 'seasoning'],
    ['sim_soy', '간장', 'food', '병', 2, 3, 1, 'seasoning'],
    ['sim_pepper', '고춧가루', 'food', '통', 1, 2, 1, 'seasoning'],
    ['sim_onion', '양파', 'food', '망', 2, 4, 1, 'apple'],
    ['sim_bread', '식빵', 'food', '봉', 1, 2, 1, 'bread'],
    ['sim_snack', '과자', 'food', '봉', 5, 10, 2, 'snack'],
    ['sim_battery', '건전지 AA', 'electronics', '팩', 1, 4, 1, 'battery'],
    ['sim_light', '전구', 'electronics', '개', 3, 6, 1, 'light'],
    ['sim_bandage', '밴드', 'medicine', '통', 2, 4, 1, 'bandage'],
    ['sim_coldmed', '종합감기약', 'medicine', '통', 1, 2, 1, 'pill'],
    ['sim_diaper', '기저귀', 'baby', '팩', 2, 4, 1, 'diaper'],
    ['sim_petfood', '반려견 사료', 'pet', '포대', 1, 2, 1, 'pet'],
    ['sim_mask', '마스크', 'hygiene', '통', 1, 4, 1, 'mask'],
    ['sim_gloves', '고무장갑', 'kitchen', '켤레', 2, 4, 1, 'gloves'],
    ['sim_cotton', '면봉', 'hygiene', '통', 2, 3, 1, 'cotton'],
    ['sim_lotion', '로션', 'hygiene', '개', 1, 2, 1, 'lotion'],
    ['sim_spray', '락스', 'household', '개', 1, 2, 1, 'spray'],
    ['sim_toilet', '변기세정제', 'bathroom', '개', 2, 4, 1, 'toilet'],
    ['sim_sanitizer', '손세정제', 'hygiene', '개', 2, 4, 1, 'spray'],
    ['sim_bag', '지퍼백', 'kitchen', '박스', 3, 5, 1, 'bag'],
    ['sim_dehumidifier', '제습제', 'household', '개', 4, 8, 2, 'home'],
    ['sim_candle', '방향제', 'household', '개', 2, 4, 1, 'candle'],
    ['sim_umbrella', '우산', 'household', '개', 3, 4, 1, 'umbrella'],
    ['sim_sock', '양말', 'household', '켤레', 10, 16, 4, 'sock'],
    ['sim_paper', 'A4 용지', 'household', '권', 2, 5, 1, 'paper'],
    ['sim_tape', '박스테이프', 'household', '개', 3, 6, 1, 'tape'],
    ['sim_scissors', '가위', 'household', '개', 2, 3, 1, 'scissors'],
    ['sim_fan', '선풍기 필터', 'electronics', '개', 1, 2, 1, 'fan'],
  ];

  return [
    for (var i = 0; i < rows.length; i++)
      _product(
        id: rows[i][0] as String,
        name: rows[i][1] as String,
        category: rows[i][2] as String,
        unit: rows[i][3] as String,
        current: (rows[i][4] as num).toDouble(),
        max: (rows[i][5] as num).toDouble(),
        min: (rows[i][6] as num).toDouble(),
        iconKey: rows[i][7] as String,
        iconColor: colors[i % colors.length],
        createdAt: '2026-07-${((i % 28) + 1).toString().padLeft(2, '0')}T10:00:00.000',
      ),
  ];
}

Map<String, dynamic> _product({
  required String id,
  required String name,
  required String category,
  required String unit,
  required double current,
  required double max,
  required double min,
  required String iconKey,
  required String iconColor,
  required String createdAt,
}) {
  return {
    'id': id,
    'name': name,
    'category': category,
    'unit': unit,
    'currentStock': current,
    'maxStock': max,
    'minStock': min,
    'iconKey': iconKey,
    'iconColor': iconColor,
    'isActive': true,
    'createdAt': createdAt,
    'updatedAt': '2026-09-08T09:00:00.000',
  };
}

Map<String, dynamic> _cycle({
  required String id,
  required String productId,
  required int intervalDays,
  required String lastPurchase,
  required String nextReminder,
}) {
  return {
    'id': id,
    'productId': productId,
    'intervalDays': intervalDays,
    'isAutoEstimated': false,
    'lastPurchaseDate': lastPurchase,
    'nextReminderDate': nextReminder,
    'isEnabled': true,
  };
}

({
  double stock,
  List<Map<String, dynamic>> histories,
  List<Map<String, dynamic>> purchases,
})
_foldStock({
  required String productId,
  required String idPrefix,
  required List<({String at, double delta, String reason})> events,
}) {
  var stock = 0.0;
  final histories = <Map<String, dynamic>>[];
  final purchases = <Map<String, dynamic>>[];
  for (var i = 0; i < events.length; i++) {
    final event = events[i];
    stock = (stock + event.delta).clamp(0.0, 9999.0);
    histories.add({
      'id': '${idPrefix}_h$i',
      'productId': productId,
      'delta': event.delta,
      'stockAfter': stock,
      'reason': event.reason,
      'createdAt': event.at,
    });
    if (event.reason == 'purchase') {
      purchases.add({
        'id': '${idPrefix}_p$i',
        'productId': productId,
        'quantity': event.delta,
        'storeName': i % 2 == 0 ? '이마트' : '쿠팡',
        'note': null,
        'source': 'manual',
        'purchasedAt': event.at,
      });
    }
  }
  return (stock: stock, histories: histories, purchases: purchases);
}
