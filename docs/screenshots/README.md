# 허니 인벤토리 — 화면 캡처 갤러리

> 캡처일: 2026-07-11 · 빌드: v1.0.0+1 debug (NTF-04 수정 반영)

## Android (`docs/screenshots/android/`)

| # | 파일 | 화면 |
|---|------|------|
| 01 | `01-onboarding-1.png` | 온보딩 1 — 벌집에 물품 채우기 |
| 02 | `02-onboarding-2.png` | 온보딩 2 — 꿀벌 알림 |
| 03 | `03-onboarding-3.png` | 온보딩 3 — 꿀단지 |
| 04 | `04-hive-empty.png` | 벌집 홈 (빈 상태) |
| 05 | `05-hive-home.png` | 벌집 홈 (데모 시드 + BeeMascot) |
| 06 | `06-notifications.png` | 알림 목록 |
| 07 | `07-cart.png` | 꿀단지 (구매처 그룹) |
| 08 | `08-settings.png` | 설정 (알림·정렬) |
| 09 | `09-product-detail.png` | 물품 상세 |
| 10 | `10-product-edit.png` | 물품 수정 |
| 11 | `11-product-new.png` | 물품 등록 |
| 12 | `12-receipt-picker.png` | 영수증 가져오기 (바텀시트) |
| 13 | `13-quick-stock-sheet.png` | 빠른 재고 조정 (long press) |
| 14 | `14-settings-data.png` | 설정 — 데이터 백업/복원 |

## iOS (`docs/screenshots/ios/`)

동일 번호·화면 구성. `14-settings-data.png`는 설정 하단 데이터 섹션.

## 라우트 매핑

| 라우트 | 캡처 |
|--------|------|
| `/onboarding` | 01–03 |
| `/` | 04–05, 13 |
| `/notifications` | 06 |
| `/cart` | 07 |
| `/settings` | 08, 14 |
| `/product/:id` | 09 |
| `/product/:id/edit` | 10 |
| `/product/new` | 11 |
| 영수증 OCR 진입 | 12 |
| `/receipt/scan` | *(이미지 없이 진입 시 에러 화면 — 갤러리/카메라 필요)* |

## 미포함 (모달·조건부)

- 중복명 merge 다이얼로그, maxStock 제안, 구매 주기 추정 다이얼로그
- 백업 복원 확인 다이얼로그, OS 권한 다이얼로그
- 꿀단지 빈 상태, 영수증 OCR 결과 화면
- 다크 모드 변형
