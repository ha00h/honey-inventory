# 07. 화면 흐름 및 네비게이션

## 앱 구조 (Bottom Navigation)

```
┌─────────┬─────────┬─────────┐
│  🍯     │  🏺     │  ⚙️     │
│  벌집   │ 꿀단지  │  설정   │
│ (Home)  │ (Cart)  │(Settings)│
└─────────┴─────────┴─────────┘
```

| 탭 | Route | 설명 |
|----|-------|------|
| 벌집 | `/` | 메인 재고 화면 |
| 꿀단지 | `/cart` | 장바구니 |
| 설정 | `/settings` | 알림, 정렬, 정보 |

---

## 전체 화면 맵

```
                    ┌──────────────┐
                    │  Onboarding  │ (최초 1회)
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
              ┌─────│   벌집 (/)   │─────┐
              │     └──────┬───────┘     │
              │            │             │
     ┌────────▼───┐  ┌─────▼─────┐  ┌───▼────────┐
     │ 물품 등록   │  │ 물품 상세  │  │ 알림 목록   │
     │ /product/new│  │ /product/:id│ │ /notifications│
     └────────────┘  └─────┬─────┘  └────────────┘
                           │
                    ┌──────▼───────┐
                    │ 재고 조정 BS  │ (바텀시트)
                    └──────────────┘

     ┌────────────┐     ┌──────────────┐
     │ 꿀단지     │────▶│ 구매 완료     │
     │ /cart      │     │ 다이얼로그    │
     └────────────┘     └──────────────┘

     ┌────────────┐
     │ 설정       │
     │ /settings  │
     └────────────┘
```

---

## 화면별 상세

### Onboarding (최초 실행)

**슬라이드 3장**
1. "벌집에 물품을 채워보세요 🍯" — 벌집 일러스트
2. "꿀벌이 구매 시기를 알려줘요 🐝" — 알림 일러스트
3. "꿀단지에 담고 한번에 장보기 🏺" — 장바구니 일러스트

**마지막**: [시작하기] → `/` + 샘플 물품 0개

---

### 벌집 (Home) — `/`

| 요소 | 동작 |
|------|------|
| AppBar 타이틀 | "허니 인벤토리" |
| 🔔 | `/notifications` |
| 📄 스캔 | `/receipt/scan` (카메라·갤러리) |
| HexagonGrid | 칸 탭 → `/product/:id` |
| Long press | QuickStockSheet (재고 조정 + 꿀단지 담기) |
| Pull-to-refresh | 데이터·알림 스케줄 갱신 |
| FAB + | `/product/new` |
| BeeMascot overlay | 미확인 알림 시 하단 오버레이 (담기/전체보기/닫기) |

---

### 물품 등록 — `/product/new`

| 요소 | 동작 |
|------|------|
| 뒤로 | pop (미저장 확인) |
| 저장 | validate → create → pop |
| 중복명 감지 | 다이얼로그 |

**Query params (선택)**
- `?name=휴지` — 알림/검색에서 프리필

---

### 물품 상세 — `/product/:id`

| 요소 | 동작 |
|------|------|
| 히어로 cell | — |
| +/- | 재고 조정 |
| 직접 입력 | 재고 숫자·사유 다이얼로그 |
| 구매 주기 섹션 | 일/주/월, 알림 토글, 마지막 구매일 |
| 이력 | "더보기" → 전체 이력 (v0.2) |
| 꿀단지에 담기 | cart add + snackbar |
| ⋮ 메뉴 | 수정 `/product/:id/edit`, 삭제 |

---

### 꿀단지 — `/cart`

| 요소 | 동작 |
|------|------|
| 빈 상태 | "꿀단지가 비었어요" + 검색으로 추가 |
| 검색 | 담긴 물품 필터 + 미담기 물품 추가 |
| 아이템 | stepper, swipe delete, 체크박스 |
| 구매처 그룹 | 최근 방문순 정렬 (구매 이력 기준) |
| 구매 완료 | 체크 항목 일괄 완료 + 구매처 입력 |

---

### 알림 — `/notifications`

| 요소 | 동작 |
|------|------|
| 리스트 | type, 메시지, 시간 |
| 탭 | 해당 product 상세 |
| 액션 | 꿀단지 담기 / snooze |

---

### 설정 — `/settings`

- 알림 시간 / on/off / 권한 요청
- 벌집 정렬 (이름·부족·최근·카테고리)
- 테마 (라이트·다크·시스템)
- 데이터 백업·복원 (JSON)
- 클라우드 동기화 (준비 중)
- 홈 위젯 (준비 중)
- 앱 정보

### 영수증 스캔 — `/receipt/scan`

- 벌집 AppBar 스캔 버튼 → 카메라 or 갤러리
- ML Kit OCR → 품목 확인·수정 → 일괄 등록

---

## 주요 사용자 플로우

### Flow A: 첫 물품 등록

```
앱 실행 → Onboarding → 벌집 (빈) → FAB
  → 물품 등록 폼 → 저장
  → 벌집에 새 hexagon 표시
```

### Flow B: 재고 부족 → 구매

```
(백그라운드) 알림 "휴지 꿀이 말라가고 있어요"
  → 앱 열기 → Bee overlay
  → [꿀단지에 담기]
  → /cart 에 항목 추가
  → 마트에서 구매
  → 체크 → 구매 완료
  → 재고 +3, 이력 기록, 알림 해제
```

### Flow C: 주기 기반 재구매

```
14일 경과 → 푸시 "휴지 구매할 때가 됐어요"
  → 꿀단지 담기
  → 구매 완료
  → lastPurchaseDate 갱신
  → nextReminderDate = today + 14
```

### Flow D: 같은 물품 재등록 (주기 추정)

```
물품 등록 "휴지" → 중복 감지
  → [기존에 추가]
  → PurchaseRecord 추가
  → "약 13일 주기" 다이얼로그
  → [적용] → PurchaseCycle 업데이트
```

---

## 라우트 정의 (go_router)

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) => MainShell(nav: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (_, __) => const HiveScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ]),
      ],
    ),
    GoRoute(path: '/product/new', builder: (_, __) => const ProductFormScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (_, state) => ProductDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: '/receipt/scan', builder: ...), // query: path=이미지경로
    GoRoute(path: '/onboarding', builder: ...),
  ],
);
```

---

## 바텀시트 & 다이얼로그

| 이름 | 트리거 | 내용 |
|------|--------|------|
| QuickStockSheet | 벌집 long press | +/- , 사유, 꿀단지 담기 |
| BulkCompleteDialog | 장바구니 N개 완료 | 구매처 입력 (선택) |
| DuplicateProductDialog | 등록 시 중복 | 기존 추가 / 새로 |
| CycleEstimateDialog | 구매·merge 이력 | 주기 적용 |
| ReceiptItemEditDialog | 영수증 스캔 | 품목명·수량 수정 |
| DeleteConfirmDialog | 상세 삭제 | 확인 |

---

## 딥링크 (v0.2+)

| URI | 동작 |
|-----|------|
| `honeyinventory://product/:id` | 물품 상세 |
| `honeyinventory://cart` | 장바구니 |
| `honeyinventory://notifications` | 알림 |
