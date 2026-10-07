# 03. UI/UX 디자인 가이드

## 디자인 철학

> **Compact & Sweet** — 정보는 컴팩트하게, 감성은 달콤하게.

육각형 그리드는 많은 물품을 작은 공간에 예쁘게 담는다. 과한 장식보다 **꿀 fill 애니메이션**과 **꿀벌 포인트**로 개성을 낸다.

---

## 컬러 팔레트

### Primary — 꿀 & 벌

| 이름 | HEX | 용도 |
|------|-----|------|
| Honey Gold | `#F5C842` | Primary, FAB, 강조 |
| Honey Amber | `#E8A838` | 버튼 pressed, 그라데이션 |
| Bee Yellow | `#FFF3C4` | 배경, 카드 배경 |
| Warm Cream | `#FFFBF0` | 앱 배경 |

### Secondary — 파스텔 악센트

| 이름 | HEX | 용도 |
|------|-----|------|
| Soft Peach | `#FFD4B8` | 카테고리 배지 |
| Mint Leaf | `#B8E8D0` | 충분 재고, 성공 |
| Sky Petal | `#B8D4F0` | 정보, 링크 |
| Lavender Bloom | `#D4B8F0` | 위생용품 카테고리 |

### Semantic

| 이름 | HEX | 용도 |
|------|-----|------|
| Low Stock | `#FF8C69` | 재고 부족, 경고 |
| Empty Cell | `#E8E0D0` | 재고 0%, 빈 칸 |
| Honey Fill | `#F5A623` → `#F5C842` | fill 그라데이션 (아래→위) |
| Text Primary | `#3D2E1F` | 본문 (따뜻한 다크 브라운) |
| Text Secondary | `#8B7355` | 보조 텍스트 |

### 다크 모드 (v0.2+)

- 배경: `#1A1510`
- 벌집 칸: `#2A2218`
- 꿀 fill 색상 유지 (대비 확보)

---

## 타이포그래피

| 스타일 | 크기 | 굵기 | 용도 |
|--------|------|------|------|
| Display | 28sp | Bold | 앱 타이틀, 빈 상태 |
| Title | 20sp | SemiBold | 화면 제목 |
| Cell Label | 11sp | Medium | 벌집 칸 물품명 |
| Body | 16sp | Regular | 본문 |
| Caption | 12sp | Regular | 보조 정보, 날짜 |

**권장 폰트**
- 한글: Pretendard 또는 Noto Sans KR
- 영문/숫자: Pretendard 통합 또는 Nunito (둥근 느낌)

---

## 핵심 컴포넌트

### 1. HexagonCell (벌집 칸)

```
        ___
       /   \
      / 🧻  \     ← 아이콘 (상단 40%)
     /~~~~~~~\    ← 꿀 fill (하단에서 위로, 재고 비율)
    /  휴지   \   ← 라벨 (하단)
    \_________/
```

**상태별 스타일**

| 상태 | 테두리 | Fill | 추가 |
|------|--------|------|------|
| 충분 (>50%) | `#E8D5A0` 1.5px | 50~100% 꿀 그라데이션 | — |
| 보통 (20~50%) | `#E8D5A0` | 20~50% | — |
| 부족 (<20%) | `#FF8C69` 2px | 0~20% | 작은 🐝 배지 |
| 비어있음 (0%) | `#E8E0D0` 점선 | 없음 | 흐릿한 아이콘 |

**인터랙션**
- Tap: scale 0.95 → 상세 화면
- Long press: 빠른 재고 조정 바텀시트

**애니메이션**
- 재고 변경 시 fill이 `AnimatedContainer` 400ms easeOut으로 출렁
- 부족 상태: fill surface에 subtle shimmer (2s loop)

### 2. HoneyFill (꿀 채움 레이어)

- `ClipPath` (hexagon) + `LinearGradient` (bottom → top)
- fill 비율 = `currentStock / maxStock` (maxStock = 최대 보유량 또는 사용자 설정 상한)
- wave 효과: 선택적 `CustomPainter` sine wave on top edge

### 3. BeeMascot (꿀벌 캐릭터)

**용도**
- 온보딩 안내
- 재고 부족 알림 오버레이
- 빈 상태 일러스트

**스타일**
- 둥근 몸통, 작은 날개, 큰 눈
- 2~3프레임 idle 애니메이션 (날개 짓)
- 말풍선: 둥근 모서리, 꼬리 삼각형

**알림 연출**
```
[벌집 화면]
     🐝 ← 날아옴 (CurvedAnimation)
   ┌──────────────┐
   │ 휴지 칸의 꿀이  │
   │ 말라가고 있어요!│
   │   웽웽! 🍯    │
   └──────────────┘
   [장바구니 담기]
```

### 4. HoneyJarCard (장바구니 아이템)

- 둥근 항아리 실루엣 카드
- 좌: 아이콘 / 중: 이름·수량 / 우: 체크박스
- 구매처 헤더: 작은 가게 아이콘 + 매장명 pill

### 5. HexagonGrid (벌집 레이아웃)

- **Honeycomb staggered grid**: 홀수 행 offset
- 칸 크기: 화면 너비 기준 ~3열 (padding 16)
- 칸 간격: 4px
- 스크롤: `CustomScrollView` + Sliver

```
  ⬡   ⬡   ⬡
    ⬡   ⬡   ⬡
  ⬡   ⬡   ⬡
```

---

## 화면별 레이아웃 요약

### 메인 (벌집)

```
┌─────────────────────────┐
│  🍯 허니 인벤토리  [🔔] │  AppBar
├─────────────────────────┤
│      ⬡  ⬡  ⬡          │
│    ⬡  ⬡  ⬡  ⬡        │  HexagonGrid
│      ⬡  ⬡  ⬡          │
├─────────────────────────┤
│  [벌집]  [꿀단지]  [⚙️]  │  BottomNav
└─────────────────────────┘
         [+] FAB
```

### 물품 상세

- 상단: 큰 HexagonCell (히어로)
- 재고 슬라이더 / +/- 스테퍼
- 구매 주기, 최근 구매일, 이력 리스트
- CTA: "꿀단지에 담기"

### 장바구니 (꿀단지)

```
┌─────────────────────────┐
│  🏺 꿀단지               │
├─────────────────────────┤
│  🏪 이마트 (3)           │  StoreGroup
│   [항아리 카드] ×3       │
│  🏪 쿠팡 (1)             │
│   [항아리 카드]          │
│  📦 구매처 미정 (2)       │
├─────────────────────────┤
│  [구매 완료]             │
└─────────────────────────┘
```

---

## 아이콘 시스템

- 물품: 이모지 스타일 일러스트 또는 Phosphor / Lucide 아이콘 (rounded)
- 카테고리 프리셋 12종: 생활, 식료, 위생, 주방, 세탁, 욕실, 전자, 의약, 반려, 육아, 기타
- 앱 아이콘: 육각형 안에 꿀방울 + 작은 벌

---

## 모션 가이드

| 동작 | Duration | Curve |
|------|----------|-------|
| Fill 변경 | 400ms | easeOutCubic |
| 화면 전환 | 300ms | easeInOut |
| 꿀벌 fly-in | 600ms | elasticOut |
| 바텀시트 | 250ms | easeOut |
| FAB | 200ms | easeOut |

**원칙**: 장식 애니메이션은 사용자 액션에 반응할 때만. idle shimmer는 부족 칸만.

---

## 간격 & 라운드

| 토큰 | 값 |
|------|-----|
| spacing-xs | 4 |
| spacing-sm | 8 |
| spacing-md | 16 |
| spacing-lg | 24 |
| radius-sm | 8 |
| radius-md | 16 |
| radius-lg | 24 |
| radius-full | 999 |

---

## 접근성

- 벌집 칸: 최소 72×83pt (hexagon bounding box)
- 재고 상태: 색상 + 아이콘 (🐝 부족 배지) 병행
- 스크린 리더: "휴지, 재고 3롤, 보통 수준"
- 알림: 시각 + 로컬 푸시 병행
