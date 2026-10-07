# 04. 데이터 모델

## ER 개요

```
┌─────────────┐       ┌──────────────────┐
│   Product   │──1:N──│  StockHistory    │
│  (물품)     │       │  (재고 변동)      │
└──────┬──────┘       └──────────────────┘
       │
       │1:N
       ▼
┌─────────────┐       ┌──────────────────┐
│ PurchaseCycle│      │  PurchaseRecord  │
│ (구매 주기)  │       │  (구매 이력)      │
└─────────────┘       └────────┬─────────┘
                               │
                               │N:1
                               ▼
                      ┌──────────────────┐
                      │      Store       │
                      │   (구매처)        │
                      └──────────────────┘

┌─────────────┐
│ CartItem    │──N:1── Product
│ (장바구니)  │
└─────────────┘
```

---

## 엔티티 정의

### Product (물품)

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | String (UUID) | O | PK |
| name | String | O | 물품명 |
| category | Category enum | X | 카테고리 |
| iconKey | String | X | 아이콘 식별자 |
| unit | String | O | 단위 (개, 롤, 박스…) |
| currentStock | double | O | 현재 재고 |
| maxStock | double | X | fill 100% 기준 (null이면 currentStock 기준 동적) |
| minStock | double | X | 부족 임계값 |
| isActive | bool | O | false면 벌집에서 숨김 |
| createdAt | DateTime | O | |
| updatedAt | DateTime | O | |

```dart
enum Category {
  household,   // 생활용품
  food,        // 식료품
  hygiene,     // 위생용품
  kitchen,     // 주방
  laundry,     // 세탁
  bathroom,    // 욕실
  electronics, // 전자
  medicine,    // 의약
  pet,         // 반려
  baby,        // 육아
  other,       // 기타
}
```

### PurchaseCycle (구매 주기)

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | String | O | PK |
| productId | String | O | FK → Product |
| intervalDays | int | O | 구매 주기 (일) |
| isAutoEstimated | bool | O | 자동 추정 여부 |
| lastPurchaseDate | DateTime | X | 마지막 구매일 |
| nextReminderDate | DateTime | X | 다음 알림 예정일 |
| isEnabled | bool | O | 알림 on/off |

**nextReminderDate 계산**
```
nextReminderDate = lastPurchaseDate + intervalDays
```

### PurchaseRecord (구매 이력)

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | String | O | PK |
| productId | String | O | FK |
| storeId | String | X | FK → Store |
| quantity | double | O | 구매 수량 |
| unitPrice | double | X | 단가 |
| purchasedAt | DateTime | O | 구매 일시 |
| note | String | X | 메모 |
| source | PurchaseSource | O | manual / receipt / cart |

```dart
enum PurchaseSource { manual, receipt, cart }
```

### Store (구매처)

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | String | O | PK |
| name | String | O | 매장명 |
| lastVisitedAt | DateTime | X | 최근 방문 |

### StockHistory (재고 변동 이력)

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | String | O | PK |
| productId | String | O | FK |
| delta | double | O | 변동량 (+/-) |
| stockAfter | double | O | 변동 후 재고 |
| reason | StockChangeReason | O | |
| createdAt | DateTime | O | |

```dart
enum StockChangeReason {
  purchase,  // 구매
  usage,     // 사용
  discard,   // 폐기
  adjust,    // 수동 조정
  initial,   // 최초 등록
}
```

### CartItem (장바구니)

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | String | O | PK |
| productId | String | O | FK |
| quantity | double | O | 담을 수량 |
| preferredStoreId | String | X | 선호 구매처 (이력 기반) |
| addedAt | DateTime | O | |
| note | String | X | |

---

## 주기 자동 추정 알고리즘

동일 `productId`에 새 `PurchaseRecord`가 추가될 때:

```
intervals = [ record[i].purchasedAt - record[i-1].purchasedAt for i in 1..n ]
estimatedDays = round( average(intervals) )
```

- 기록 2건 미만: 추정 불가 → 사용자에게 수동 입력 요청
- 2건 이상: 추정값 제시, 사용자 확인 후 `PurchaseCycle` 업데이트
- 이동 평균: 최근 5건까지만 반영 (급격한 변화 완화)

```dart
int estimateIntervalDays(List<PurchaseRecord> records) {
  if (records.length < 2) return 0;
  final sorted = [...records]..sort((a, b) => a.purchasedAt.compareTo(b.purchasedAt));
  final recent = sorted.length > 5 ? sorted.sublist(sorted.length - 5) : sorted;
  final intervals = <int>[];
  for (var i = 1; i < recent.length; i++) {
    intervals.add(recent[i].purchasedAt.difference(recent[i - 1].purchasedAt).inDays);
  }
  return (intervals.reduce((a, b) => a + b) / intervals.length).round();
}
```

---

## 재고 Fill 비율 계산

```dart
double stockFillRatio(Product p) {
  final max = p.maxStock ?? max(p.currentStock, p.minStock ?? 1);
  if (max <= 0) return 0;
  return (p.currentStock / max).clamp(0.0, 1.0);
}
```

---

## 로컬 DB (MVP)

**권장**: `drift` (SQLite) 또는 `isar`

| 테이블 | 인덱스 |
|--------|--------|
| products | id PK, isActive |
| purchase_cycles | productId UNIQUE |
| purchase_records | productId, purchasedAt |
| stores | id PK, name |
| stock_histories | productId, createdAt |
| cart_items | productId |

---

## 샘플 데이터

```json
{
  "product": {
    "id": "p-001",
    "name": "휴지",
    "category": "hygiene",
    "iconKey": "tissue",
    "unit": "롤",
    "currentStock": 6,
    "maxStock": 12,
    "minStock": 3
  },
  "purchaseCycle": {
    "productId": "p-001",
    "intervalDays": 14,
    "isAutoEstimated": false,
    "lastPurchaseDate": "2026-06-25",
    "isEnabled": true
  },
  "cartItem": {
    "productId": "p-002",
    "quantity": 2,
    "preferredStoreId": "s-emart"
  }
}
```
