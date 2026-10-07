# 06. 기술 아키텍처

## 기술 스택

| 영역 | 선택 | 이유 |
|------|------|------|
| Framework | Flutter 3.x | iOS/Android 동시 개발 |
| Language | Dart 3.x | |
| State | Riverpod 2.x | 테스트 용이, DI 친화 |
| Local DB | Drift (SQLite) | 관계형, 타입 안전 쿼리 |
| Navigation | go_router | 선언적 라우팅, 딥링크 |
| Notifications | flutter_local_notifications | 오프라인 로컬 알림 |
| Icons | phosphor_flutter 또는 커스텀 SVG | 둥근 스타일 |
| Animation | flutter_animate (선택) | shimmer, fly-in |

---

## 프로젝트 구조

```
lib/
├── main.dart
├── app.dart                    # MaterialApp, 테마, 라우터
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   ├── constants/
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── stock_utils.dart
│   └── extensions/
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   └── tables/
│   ├── models/                 # DB ↔ Domain 매핑
│   └── repositories/
│       ├── product_repository.dart
│       ├── cart_repository.dart
│       ├── purchase_repository.dart
│       └── notification_repository.dart
├── domain/
│   ├── entities/
│   └── services/
│       ├── cycle_estimator.dart
│       ├── stock_calculator.dart
│       └── reminder_scheduler.dart
├── presentation/
│   ├── hive/                   # 벌집 메인
│   │   ├── hive_screen.dart
│   │   ├── widgets/
│   │   │   ├── hexagon_cell.dart
│   │   │   ├── hexagon_grid.dart
│   │   │   └── honey_fill.dart
│   │   └── providers/
│   ├── product/
│   │   ├── product_detail_screen.dart
│   │   ├── product_form_screen.dart
│   │   └── providers/
│   ├── cart/
│   │   ├── cart_screen.dart
│   │   ├── widgets/
│   │   │   ├── honey_jar_card.dart
│   │   │   └── store_group_header.dart
│   │   └── providers/
│   ├── settings/
│   └── shared/
│       ├── widgets/
│       │   ├── bee_mascot.dart
│       │   └── bee_notification_overlay.dart
│       └── providers/
└── routes/
    └── app_router.dart
```

---

## 레이어 아키텍처

```
┌─────────────────────────────────────┐
│         Presentation (UI)           │
│   Screens, Widgets, Riverpod        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           Domain (Services)         │
│   CycleEstimator, StockCalculator   │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data (Repositories)         │
│   Drift DAO, Model mapping          │
└─────────────────────────────────────┘
```

**원칙**
- UI → Repository 직접 호출 지양 (간단한 CRUD는 `@riverpod` provider에서 repository 주입)
- 비즈니스 로직(주기 추정, fill 계산)은 domain/services

---

## 핵심 구현 노트

### Hexagon Grid

```dart
// honeycomb offset: 짝수 행은 x offset = cellWidth * 0.5
class HexagonGrid extends StatelessWidget {
  // Option A: flutter_staggered_grid_view (hexagon mask per child)
  // Option B: Custom layout with HexagonClipper + Wrap with manual offset
  // 권장: CustomScrollView + Sliver, 열 3개 고정
}
```

```dart
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();
    return path;
  }
}
```

### Honey Fill

```dart
Stack(
  children: [
    HexagonBorder(),
    ClipPath(
      clipper: HexagonClipper(),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: fillRatio,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.honeyFillStart, AppColors.honeyFillEnd],
              ),
            ),
          ),
        ),
      ),
    ),
    // icon + label
  ],
)
```

### 알림 스케줄링

- 앱 `resumed` 시 `ReminderScheduler.checkAndSchedule()` 호출
- `workmanager` (optional): Android 백그라운드 일일 체크
- iOS: UNUserNotificationCenter, 정확한 시간보다 "매일 9시" repeating

---

## 의존성 (pubspec.yaml 초안)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  go_router: ^14.0.0
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  path: ^1.9.0
  flutter_local_notifications: ^17.0.0
  intl: ^0.19.0
  uuid: ^4.0.0
  phosphor_flutter: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  drift_dev: ^2.18.0
  riverpod_generator: ^2.4.0
  flutter_lints: ^4.0.0
```

---

## 테스트 전략

| 레벨 | 대상 |
|------|------|
| Unit | CycleEstimator, stockFillRatio, nextReminderDate |
| Widget | HexagonCell states, HoneyJarCard |
| Integration | 등록 → 벌집 표시 → 장바구니 → 구매완료 플로우 |

---

## 빌드 & 배포

- **iOS**: min 13.0
- **Android**: min SDK 21
- 앱 ID: `com.homeanimals.honey_inventory`
- 앱 표시명: 허니 인벤토리

---

## 보안 & 프라이버시

- 모든 데이터 기기 로컬 저장
- 영수증 이미지 (Post-MVP): 처리 후 삭제 옵션
- MVP: 계정/로그인 없음

---

## 향후 확장 포인트

| 기능 | 접근 |
|------|------|
| 클라우드 동기화 | Supabase / Firebase |
| OCR | google_mlkit_text_recognition |
| 가족 공유 | 공유 household ID + RLS |
| 홈 위젯 | iOS WidgetKit / Android Glance |
