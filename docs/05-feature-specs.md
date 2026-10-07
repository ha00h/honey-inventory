# 05. 기능별 상세 명세

> **구현 현황 (2026-07-09)**: MVP·v0.2 핵심 완료. 클라우드·홈 위젯만 미완.

## 1. 재고 관리

### 1.1 벌집 메인 화면 ✅

**진입**: 앱 실행 시 기본 탭

**동작**
1. `isActive == true` 인 모든 Product 로드
2. HexagonGrid에 렌더 (이름 가나다순 또는 최근 수정순 — 설정 가능, 기본: 카테고리 그룹)
3. pull-to-refresh: 데이터 리로드
4. FAB 탭 → 물품 등록 화면

**정렬 옵션 (v0.2)**
- 이름순
- 재고 부족순
- 최근 수정순
- 카테고리별

**빈 상태**
- 빈 벌집 일러스트 + 꿀벌 "첫 꿀을 채워볼까요? 🐝"
- CTA: "물품 추가하기"

---

### 1.2 물품 등록 ✅

**진입 경로**
- FAB
- 장바구니 → 직접 추가

**플로우**

```
[입력 폼]
  물품명 ─────────────────
  카테고리 [칩 선택]
  현재 재고 [숫자] [단위]
  최소 재고 (선택)
  최대 재고 / fill 기준 (선택)
  구매 주기 (선택) [N] [일/주/월]
  아이콘 [그리드 선택]
        [저장]
```

**검증**
- 물품명: 1~50자, 공백만 불가
- currentStock ≥ 0
- minStock ≤ maxStock (둘 다 있을 때)

**저장 시**
1. Product 생성
2. StockHistory (reason: initial) 기록
3. PurchaseCycle 있으면 생성, nextReminderDate 계산
4. 벌집 메인으로 pop

**중복 물품명 처리** ✅ (merge 시 PurchaseRecord·주기 추정 포함)

---

### 1.3 물품 상세 / 재고 조정 ✅

**표시 정보**
- 히어로 HexagonCell (large)
- 현재 재고 / 단위
- fill 게이지 바
- 구매 주기, 다음 알림일
- 최근 StockHistory 5건
- 최근 PurchaseRecord 5건

**재고 조정**
- Steppers: -1 / +1 (long press: -5 / +5)
- 직접 입력 다이얼로그 ✅
- 사유 선택: 사용 / 폐기 / 조정 / 구매 (상세 화면·QuickStockSheet)

**삭제**
- Soft delete (`isActive = false`)
- 확인 다이얼로그: "벌집에서 제거할까요? (이력은 유지됩니다)"

---

### 1.4 영수증 스캔 ✅ (기본 구현, 포맷별 품질은 실기기 검증 필요)

**플로우**
1. 카메라 or 갤러리
2. OCR 처리 (Google ML Kit / Naver Clova 등)
3. 파싱 결과 리스트 (품목, 수량, 가격, 매장)
4. 사용자 체크/수정
5. 일괄 등록 or 기존 물품 매칭

---

## 2. 주기별 구매 알림

### 2.1 주기 등록 (수동) ✅

- 일 / 주 / 월 단위 (내부 일수 변환)
- 물품별 알림 on/off 토글
- 마지막 구매일 날짜 피커

### 2.2 주기 자동 추정

**트리거**: 기존 Product에 PurchaseRecord 추가 시

**UI**
```
┌────────────────────────────┐
│ 🐝 구매 패턴을 발견했어요!   │
│                            │
│ 휴지는 약 13일마다          │
│ 구매하시는 것 같아요.       │
│                            │
│ [이 주기 적용]  [직접 입력]  │
└────────────────────────────┘
```

**로직**
- `estimateIntervalDays()` 호출
- 결과 < 1일: 무시, 수동 요청
- 적용 시: `PurchaseCycle.isAutoEstimated = true`

### 2.3 알림

**유형**

| type | 조건 | 메시지 예시 |
|------|------|-------------|
| cycle_due | today ≥ nextReminderDate | "휴지 구매할 때가 됐어요! 🍯" |
| low_stock | currentStock ≤ minStock | "휴지 칸의 꿀이 말라가고 있어요! 웽웽!" |

**전달 채널**
- 인앱: BeeMascot 오버레이 (벌집 하단, 미확인 알림) ✅
- 로컬 푸시: 물품별 알림 + 요약 digest (설정 시간) ✅
- 푸시 탭 → 물품 상세 / 알림 목록 ✅

**알림 액션**
- [꿀단지에 담기] → CartItem 추가 + 알림 dismiss
- [나중에] → snooze 3일

**스케줄링**
```dart
// 앱 시작 / 매일 background task
for (cycle in enabledCycles) {
  if (today >= cycle.nextReminderDate) scheduleNotification(...);
}
for (product in activeProducts) {
  if (product.minStock != null && product.currentStock <= product.minStock) {
    scheduleLowStockNotification(...);
  }
}
```

---

## 3. 장바구니 (꿀단지)

### 3.1 아이템 추가

**진입 경로**
- 물품 상세 → "꿀단지에 담기"
- 알림 → "꿀단지에 담기"
- 벌집 long press → 빠른 담기
- 장바구니 내 검색 추가

**기본 수량**
- 1 (단위 = Product.unit)
- preferredStoreId: 해당 Product 최근 PurchaseRecord의 storeId

### 3.2 목록 표시

**MVP (플랫 리스트)**
- HoneyJarCard 리스트
- addedAt 내림차순

**v0.2 (구매처 그룹)**

```
groupBy(cartItems, preferredStoreId ?? 'unknown')
  → Store.name or "구매처 미정"
  → sort groups: lastVisitedAt desc
```

**카드 정보**
- 아이콘, 이름, 수량 stepper
- 스와이프 삭제

### 3.3 구매 완료

**단일 완료**
1. 체크박스 on
2. PurchaseRecord 생성 (source: cart)
3. Product.currentStock += quantity
4. StockHistory (purchase)
5. PurchaseCycle.lastPurchaseDate 갱신, nextReminderDate 재계산
6. 주기 추정 (해당 시)
7. CartItem 삭제

**일괄 완료**
- "구매 완료" 버튼 → 체크된 항목 전부 처리
- 선택적: 구매처·날짜 한번에 입력

---

## 4. 설정 (MVP 최소)

| 항목 | 기본값 |
|------|--------|
| 알림 시간 | 09:00 |
| 알림 on/off | on |
| 벌집 정렬 | 카테고리 |
| 테마 | 라이트 |

---

## 5. 에지 케이스

| 상황 | 처리 |
|------|------|
| 재고 0, minStock 미설정 | fill 0%, 특별 강조 없음 |
| 주기 off | 알림만 비활성, 벌집 표시 유지 |
| 동일 물품 장바구니 중복 | 수량 merge |
| 구매 완료 후 재고 > maxStock | maxStock 상향 제안 다이얼로그 ✅ |
| 앱 삭제 후 재설치 | 로컬 데이터 소실 (MVP 한계, v1.0 백업) |
