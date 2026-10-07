# 허니 인벤토리 — 에셋

## 앱 이름 (확정)

| 용도 | 이름 |
|------|------|
| 한글 표시명 | 허니 인벤토리 |
| 영문명 | Honey Inventory |
| 패키지 ID (예정) | `com.homeanimals.honey_inventory` |

---

## 아이콘 목록

### 앱 / 네비게이션

| 파일 | 용도 |
|------|------|
| `icons/app_icon.png` | 런처 아이콘 (스토어 제출용 리사이즈 필요) |
| `icons/hive_tab_icon.png` | 하단 탭 — 벌집 (홈) |
| `icons/honey_jar_cart.png` | 하단 탭 — 꿀단지 (장바구니) |
| `icons/bee_mascot.png` | 온보딩, 알림, 빈 상태 일러스트 |

### 물품 카테고리 (벌집 칸)

| 파일 | 물품 |
|------|------|
| `icons/icon_tissue.png` | 휴지 / 위생용품 |
| `icons/icon_water.png` | 생수 / 음료 |
| `icons/icon_detergent.png` | 세제 / 세탁 |
| `icons/product_icons_set1.png` | 4종 세트 참고용 (2×2 그리드) |

---

## Flutter 연동 (예정)

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/icons/
```

```dart
Image.asset('assets/icons/icon_tissue.png')
```

---

## 스토어 제출 전 작업

- [x] `appstore_1024.png` → 1024×1024 PNG, 알파 없음 (iOS App Store / Play 고해상도 아이콘)
- [x] Android adaptive icon (foreground + background)
- [x] 스플래시 화면용 `splash_logo.png`
- [ ] 나머지 카테고리 아이콘 8종 추가 (주방, 욕실, 식료, 의약 등)

스토어 문구: [docs/store-listing-ko.md](../docs/store-listing-ko.md)

---

## 스타일 가이드

- 따뜻한 꿀색·파스텔 톤
- 육각형(hexagon) 프레임 또는 벌집 모티프
- 둥글고 귀여운 flat vector 스타일
- 상세: [docs/03-ui-ux-design.md](../docs/03-ui-ux-design.md)
