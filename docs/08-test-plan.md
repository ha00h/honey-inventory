# 08. 전체 테스트 기준서

> 허니 인벤토리 QA 체크리스트. 자동 테스트(`flutter test`)와 수동 테스트(실기기/시뮬레이터) 기준을 통합합니다.

## 문서 정보

| 항목 | 내용 |
|------|------|
| 대상 버전 | v1.0.0+1 |
| 플랫폼 | iOS, Android |
| 최종 갱신 | 2026-07-10 |

---

## 0. 이 문서 사용법

### 체크 기호

| 기호 | 의미 |
|------|------|
| ☐ | 미실행 |
| ☑ | 통과 |
| ✗ | 실패 |
| △ | 부분 통과 (일부만 확인) |
| — | 해당 없음 / 미구현 |

### 기본 기능 전수 점검 순서 (권장)

1. **§3** 사전 준비 + 테스트 데이터 3종 등록
2. **§4 P0** 표를 위에서 아래로 순서대로 체크 (iOS / Android 각각)
3. 막히면 **§4.8 재현 절차**에서 해당 ID 단계 확인
4. v0.2·부가 기능은 **§5 P1** 이어서 진행

### 기능 명세 ↔ 체크리스트 매핑

| 기능 (05/07) | 체크 ID | 비고 |
|--------------|---------|------|
| 온보딩 3슬라이드 | NAV-01a, NAV-01b | 건너뛰기 / 완주 분리 |
| 하단 탭 | NAV-02 | |
| 벌집 셀 → 상세 | NAV-04 | **P0에 신규** |
| 상세 → 뒤로 | NAV-03 | |
| AppBar 알림 목록 | NAV-05 | **P0에 신규** |
| AppBar 영수증 스캔 | OCR-01, OCR-02 | P1 |
| FAB 물품 등록 | PRD-01 | |
| 등록 시 구매 주기 | PRD-05 | PRD US-10 P0 |
| 중복명 merge | PRD-02 | |
| 수정 / 삭제 | PRD-03, PRD-04 | |
| ±1·±5·직접입력 | STK-01~03 | |
| 부족·fill 표시 | STK-04, STK-05 | |
| 꿀단지 담기 (3경로) | CRT-01a~c | 경로별 분리 |
| 검색·stepper·완료 | CRT-06~08 | |
| 구매처 그룹·max 제안 | CRT-02, CRT-04 | |
| 인앱·BeeMascot·푸시 | NTF-01~06 | |
| 백업·오프라인 | DAT-01~03 | |
| 주기 UI·추정 | CYC-01~04 | P1 |
| 설정 (정렬·테마·알림) | SET-01~05 | |

---

## 1. 테스트 범위 요약

| 레벨 | 도구 | 담당 | 통과 기준 |
|------|------|------|-----------|
| L0 단위/도메인 | `flutter test` | CI / 개발 | 11/11 통과 |
| L1 위젯 스모크 | `flutter test test/widget_test.dart` | CI | 앱 기동·벌집 홈 표시 |
| L2 iOS 시뮬레이터 | Xcode Simulator + 수동 | QA | P0 시나리오 100% |
| L3 Android 에뮬레이터 | AVD + 수동 | QA | P0 시나리오 100% |
| L4 실기기 | iPhone / Android 실제 기기 | QA | P0 + 플랫폼 특화(P1) |

---

## 2. 자동 테스트 (L0–L1)

### 실행 방법

```bash
cd HoneyInventory
flutter analyze          # 정적 분석 0건
flutter test             # 전체 단위·위젯 테스트
```

### 현재 자동 테스트 목록

| 파일 | 검증 내용 |
|------|-----------|
| `test/widget_test.dart` | 앱 기동 후 벌집 홈 화면 표시 |
| `test/receipt_parser_test.dart` | 영수증 OCR 텍스트 파싱 (가격·수량 패턴) |
| `test/product_matcher_test.dart` | OCR 품목 ↔ 기존 물품 퍼지 매칭 |
| `test/cart_search_test.dart` | 꿀단지 검색·그룹핑·방문순 정렬 |
| `test/cycle_and_sort_test.dart` | 주기 일/주/월 변환, 카테고리 정렬 |

### 자동 테스트 통과 기준

- [x] `flutter analyze` — error 0건 (2026-07-09 확인)
- [x] `flutter test` — 11/11 통과 (2026-07-09 확인)
- [ ] 신규 기능 추가 시 관련 도메인 테스트 1개 이상 권장

---

## 3. 수동 테스트 공통 준비

### 사전 조건

- [ ] 앱 최초 설치 또는 데이터 초기화(설정 → 백업 복원 전 빈 상태)
- [ ] 온보딩 3슬라이드 완료 → 빈 벌집 확인
- [ ] 알림 권한: 허용 / 거부 각각 1회씩 별도 세션으로 검증

### 테스트 데이터 (권장 시드)

| 물품명 | 카테고리 | 재고 | min | max | 주기 |
|--------|----------|------|-----|-----|------|
| 휴지 | 위생 | 2 | 3 | 10 | 14일 |
| 생수 | 식료품 | 8 | 4 | 12 | 7일 |
| 세제 | 세탁 | 1 | 1 | 3 | 30일 |

> 시드 자동 삽입은 제거됨. 위 데이터를 수동 등록하거나 QA용 백업 JSON 사용.

**QA 데모 시드** (`docs/qa/seed-demo.json`): 우유·티슈·물티슈·생수·A4 용지·치즈 + 꿀단지(탄산수·가위). Android는 설정 → 백업 복원 또는 `adb push … /sdcard/Download/` 후 파일 선택. iOS는 복원 후 `Documents/honey_inventory.sqlite` 경로 확인(Flutter `getApplicationDocumentsDirectory`).

---

## 4. P0 — 반드시 통과 (출시 차단)

### 4.1 온보딩 & 네비게이션

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| NAV-01a | 온보딩 건너뛰기 | 건너뛰기 → 빈 벌집 홈, 재실행 시 온보딩 미표시 | ☑ | ☑ |
| NAV-01b | 온보딩 완주 | 3슬라이드 순회 → [시작하기] → 빈 벌집 홈 | ☑ | ☑ |
| NAV-02 | 하단 탭 | 벌집 ↔ 꿀단지 ↔ 설정 전환, 각 화면 정상 표시 | ☑ | ☑ |
| NAV-03 | 뒤로가기 | 물품 상세 ← → 벌집 복귀 | ☑ | ☑ |
| NAV-04 | 벌집 셀 탭 | 등록 물품 칸 탭 → `/product/:id` 상세 진입 | ☑ | ☑ |
| NAV-05 | 알림 목록 | AppBar 🔔 → `/notifications` 리스트 표시 | ☑ | ☑ |

### 4.2 물품 CRUD

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| PRD-01 | 물품 등록 | 필수값 저장 → 벌집에 표시 | ☑ | ☑ |
| PRD-02 | 중복명 merge | 동일명 등록 → [기존에 추가] → 주기 추정 다이얼로그 | ☑ | △ |
| PRD-03 | 물품 수정 | ⋮ → 수정 → 이름·재고 변경 반영 | ☑ | △ |
| PRD-04 | soft delete | ⋮ → 삭제 확인 → 벌집 제거, 상세 이력 유지 | ☑ | ☑ |
| PRD-05 | 등록 시 주기 | 등록 폼에 구매 주기(일) 입력 → 저장 후 상세에 주기 표시 | ☑ | ☑ |
| PRD-06 | 유효성 검증 | 물품명 공백 또는 min>max 시 저장 불가 + 안내 | ☑ | ☑ |

### 4.3 재고 조정

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| STK-01 | 상세 ±1 + 사유 | StockHistory 기록 | △ | ☑ |
| STK-02 | long press ±5 | QuickStockSheet 동작 | ☑ | ☑ |
| STK-03 | 직접 입력 | 숫자·사유 다이얼로그 → 재고 반영 | ☑ | ☑ |
| STK-04 | 부족 표시 | currentStock ≤ minStock 시 🐝·테두리·색상 강조 | ☑ | ☑ |
| STK-05 | fill 게이지 | 상세·벌집 셀에 재고/max 비율(0~100%) 시각화 | △ | ☑ |

### 4.4 꿀단지 (장바구니)

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| CRT-01a | 담기 (상세) | 물품 상세 [꿀단지에 담기] → 꿀단지에 항목 추가 | ☑ | ☑ |
| CRT-01b | 담기 (long press) | 벌집 long press → QuickStockSheet [담기] | ☑ | ☑ |
| CRT-01c | 담기 (알림) | BeeMascot 또는 알림 목록 [꿀단지 담기] | △ | ☑ |
| CRT-02 | 구매처 그룹 | storeName 있는 항목 구매처별 섹션, 최근 방문순 | △ | ☑ |
| CRT-03 | 일괄 구매 완료 | 체크 → [구매 완료] → 재고↑ + PurchaseRecord + 항목 제거 | ☑ | ☑ |
| CRT-04 | maxStock 제안 | 구매 완료 후 재고 > max → 상향 다이얼로그 | ☑ | ☑ |
| CRT-05 | 스와이프 삭제 | 꿀단지 항목 스와이프 → 목록에서 제거 | ☐ | ☐ |
| CRT-06 | 검색 추가 | 꿀단지 검색 → 미담기 물품 선택 → 담기 | ☑ | △ |
| CRT-07 | 수량 stepper | 꿀단지 카드 +/- → 수량 변경 유지 | △ | ☑ |
| CRT-08 | 빈 상태 | 물품 0개 담김 시 "꿀단지가 비었어요" + 검색 CTA | ☑ | ☑ |

### 4.5 알림

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| NTF-01 | 부족 알림 | 인앱 알림 목록 표시 | ☑ | ☑ |
| NTF-02 | 주기 알림 | nextReminderDate 도래 시 표시 | ☑ | △ |
| NTF-03 | BeeMascot | 벌집 하단 오버레이 (미확인 시) | ☑ | ☑ |
| NTF-04 | 담기 dismiss | 담기 후 BeeMascot·알림 목록에서 해당 물품 숨김 | ☑ | ☑ |
| NTF-05 | snooze 3일 | [나중에] → 3일간 해당 물품 알림 숨김 | ☑ | ☑ |
| NTF-06 | 로컬 푸시 | 설정 알림 시간에 OS 푸시 수신 (권한 허용 시) | ☐ | ☐ |
| NTF-07 | 알림→상세 | 알림 목록 항목 탭 → 해당 물품 상세 | ☑ | ☑ |

### 4.6 데이터

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| DAT-01 | JSON 백업 | 파일 공유·저장 | △ | ☑ |
| DAT-02 | JSON 복원 | 데이터 전체 교체 | △ | ☑ |
| DAT-03 | 오프라인 | 비행기 모드에서 CRUD 동작 | ☐ | ☑ |

### 4.7 권한

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| PERM-01 | 알림 권한 허용 | 최초 요청 → 허용 → NTF-06 검증 가능 | ☑ | ☑ |
| PERM-02 | 알림 권한 거부 | 거부 → 인앱 알림은 동작, OS 푸시 없음 (크래시 없음) | ☑ | ☑ |

### 4.8 P0 재현 절차 (일일 체크용)

> **사전**: §3 테스트 데이터 3종(휴지·생수·세제) 등록 완료. 온보딩 완료 상태.

| ID | 단계 | 확인 |
|----|------|------|
| NAV-01a | 앱 삭제·재설치 → 온보딩 [건너뛰기] | 빈 벌집, 재실행 시 온보딩 없음 |
| NAV-01b | 재설치 → [다음]×2 → [시작하기] | 빈 벌집 |
| NAV-02 | 하단 탭 3개 순서대로 탭 | 각 탭 화면·선택 상태 정상 |
| NAV-03 | 벌집 → 휴지 칸 → 상세 → ← 뒤로 | 벌집 복귀 |
| NAV-04 | 벌집에서 휴지 칸 탭 | 상세에 이름·재고 표시 |
| NAV-05 | 벌집 AppBar 🔔 | 알림 목록 화면 |
| PRD-01 | FAB → 폼 작성 → [저장] (스크롤) | 벌집에 새 칸 |
| PRD-02 | 동일명 "휴지" 재등록 → [기존에 추가] | merge + 주기 다이얼로그 |
| PRD-03 | 상세 ⋮ → 수정 → 이름 변경 → 저장 | 벌집·상세 반영 |
| PRD-04 | 상세 ⋮ → 삭제 → 확인 | 벌집에서 사라짐 |
| PRD-05 | 등록 시 구매 주기 `14` 입력 | 상세에 14일·다음 알림일 |
| PRD-06 | 이름 공백 저장 시도 / min>max 입력 | Snackbar·저장 불가 |
| STK-01 | 상세 +1 → 사유 선택 | 재고+1, 이력 1건 |
| STK-02 | 벌집 휴지 long press → +5 | 재고+5 |
| STK-03 | 상세 [직접 입력] → 숫자·사유 | 재고 반영 |
| STK-04 | 휴지(재고2, min3) 벌집 확인 | 🐝·강조 스타일 |
| STK-05 | 생수(8/12) 상세·벌집 | fill 약 67% 표시 |
| CRT-01a | 휴지 상세 → [꿀단지에 담기] | 꿀단지 1건 |
| CRT-01b | 벌집 long press → [담기] | 꿀단지 추가 |
| CRT-01c | 부족 알림 → [꿀단지 담기] | 담기 + dismiss(NTF-04) |
| CRT-02 | 구매 이력 있는 2매장 항목 담기 | 섹션 2개·방문순 |
| CRT-03 | 2건 체크 → [구매 완료] | 재고↑·항목 제거·이력 |
| CRT-04 | max=3인 물품 5개 구매 완료 | max 상향 다이얼로그 |
| CRT-05 | 꿀단지 항목 스와이프 삭제 | 목록에서 제거 |
| CRT-06 | 꿀단지 검색 "세제" → 추가 | 담김 |
| CRT-07 | 꿀단지 stepper 1→3 | 수량 3 유지 |
| CRT-08 | 모든 항목 제거 후 꿀단지 탭 | 빈 상태 문구 |
| NTF-01 | 휴지 부족 상태 → 🔔 목록 | low_stock 알림 1건+ |
| NTF-02 | 주기 14일·lastPurchase 15일 전 | cycle_due 알림 |
| NTF-03 | 미확인 알림 시 벌집 | 하단 BeeMascot |
| NTF-04 | BeeMascot [담기] 후 | 오버레이·목록에서 숨김 |
| NTF-05 | 알림 [나중에] | 3일간 숨김 |
| NTF-06 | 알림 시간 1분 후로 설정·백그라운드 | OS 푸시 수신 |
| NTF-07 | 알림 목록 항목 탭 | 해당 상세 |
| DAT-01 | 설정 → 백업 → 파일 저장 | JSON 생성 |
| DAT-02 | 데이터 변경 후 복원 | 이전 스냅샷으로 복구 |
| DAT-03 | 비행기 모드 → 재고 조정 | 오프라인 CRUD·동기화 없음 |
| PERM-01 | 알림 권한 허용 플로우 | NTF-06 가능 |
| PERM-02 | 권한 거부 후 앱 사용 | 크래시 없음 |

**P0 합계: 39항목** (플랫폼별 iOS/Android 각각 체크)

---

## 5. P1 — 권장 (출시 후 빠른 수정)

### 5.1 구매 주기

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| CYC-01 | 일/주/월 입력 | 내부 일수 변환 저장 | ☐ | ☐ |
| CYC-02 | 알림 off | isEnabled false, 벌집 유지 | ☐ | ☐ |
| CYC-03 | 마지막 구매일 | 날짜 피커 → nextReminderDate 갱신 | ☐ | ☐ |
| CYC-04 | 자동 추정 | 구매 완료 후 다이얼로그 [적용/직접입력] | ☐ | ☐ |

### 5.2 영수증 OCR

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| OCR-01 | 갤러리 선택 | 스캔 화면 진입 | ☐ | ☐ |
| OCR-02 | 카메라 촬영 | 스캔 화면 진입 | ☐ | ☐ |
| OCR-03 | 품목 수정 | 체크·수정 후 일괄 등록 | ☐ | ☐ |
| OCR-04 | 기존 매칭 | 퍼지 매칭으로 merge | ☐ | ☐ |

### 5.3 설정 & UI

| ID | 시나리오 | 기대 결과 | iOS | Android |
|----|----------|-----------|-----|---------|
| SET-01 | 벌집 정렬 | 이름/부족/최근/카테고리 | ☐ | ☐ |
| SET-02 | 다크 모드 | 라이트/다크/시스템 전환 | ☐ | ☐ |
| SET-03 | pull-to-refresh | 벌집 당겨서 갱신 | ☐ | ☐ |
| SET-04 | 알림 시간 변경 | 시간 변경 → 로컬 푸시 스케줄 재등록 | ☐ | ☐ |
| SET-05 | 알림 on/off | 알림 끄기 → 인앱·푸시 미표시, 켜기 시 복구 | ☐ | ☐ |

---

## 6. P2 — 플랫폼 특화 / 미구현

| ID | 시나리오 | 기대 결과 | 비고 |
|----|----------|-----------|------|
| PLT-01 | 푸시 탭 딥링크 | 물품 상세 / 알림 화면 이동 | iOS/Android 각각 |
| PLT-02 | 백그라운드 알림 갱신 | 앱 미실행 시 스케줄 유지 | workmanager 미적용, 재개 시 갱신 |
| PLT-03 | 클라우드 동기화 | — | 준비 중 (스캐폴드만) |
| PLT-04 | 홈 위젯 | — | 미구현 |
| ACC-01 | VoiceOver / TalkBack | 주요 버튼 읽기 | Semantics 부분 적용 |

---

## 6.1 플랫폼별 최소 스모크 (15분)

한 플랫폼에서 **전체(P0)** 후, 다른 플랫폼에서는 아래만 반복:

1. 앱 기동 + 온보딩
2. 물품 1개 등록
3. 재고 조정 (직접 입력)
4. 꿀단지 담기 → 구매 완료
5. 알림 권한 + 푸시 1회
6. 카메라 또는 갤러리 OCR 1회
7. JSON 백업 → 복원

---

## 7. 회귀 테스트 절차 (릴리스 전)

```
1. flutter analyze && flutter test
2. iOS 시뮬레이터 — P0 전체 (§4)
3. Android 에뮬레이터 — P0 전체 (§4)
4. 실기기 1대 — §6.1 플랫폼 스모크 + OCR·알림
5. 체크리스트 서명 (테스터, 날짜, 빌드 번호)
```

### 실행 명령 (iOS 시뮬레이터)

```bash
open -a Simulator
# iOS 15.5+ 및 ML Kit Apple Silicon 패치가 Podfile에 적용되어 있어야 함
flutter build ios --simulator --debug
xcrun simctl install booted build/ios/iphonesimulator/Runner.app
xcrun simctl launch booted com.homeanimals.honeyInventory
# 또는
flutter run -d <simulator_id>
```

> **iOS 26 + Apple Silicon**: `google_mlkit_commons` 0.12+ 의 `mlkit_apple_silicon_simulator_patch` 필요.  
> `flutter run`이 TARGET_BUILD_DIR 오류 시 `flutter build ios --simulator` 후 `simctl install` 사용.

### Mobile MCP (Cursor 자동 UI 테스트)

`~/.cursor/mcp.json`에 등록됨. **Cursor 재시작 후** Agent에서 `mobile-mcp` 도구 사용.

#### 앱 식별자

| 플랫폼 | `packageName` / `bundle_id` |
|--------|----------------------------|
| Android | `com.homeanimals.honey_inventory` |
| iOS | `com.homeanimals.honeyInventory` |

#### MCP 기본 루프 (P0 항목 1개당)

```
1. mobile_list_available_devices     → device ID (에뮬레이터 기동 필수)
2. mobile_launch_app                 → 앱 기동
3. mobile_list_elements_on_screen    → 라벨·좌표 (매 단계, 캐시 금지)
4. mobile_click / long_press / swipe → 조작
5. mobile_type_keys                  → 텍스트 (필드 포커스 후)
6. mobile_take_screenshot            → 시각 검증·증빙
```

> Android `mobile_press_button(BACK)`은 **폼을 닫음**. 키보드는 빈 영역 탭으로 닫기.

#### P0 자동화 등급

| 등급 | 의미 | 대략 |
|------|------|------|
| **A** | 라벨 탭 → 화면·라벨 변화로 통과 판정 | ~28항목 |
| **B** | UI 자동 + 스크린샷·시드 데이터·사람 판단 | ~8항목 |
| **C** | OS 설정·파일·시간 — MCP만으로 어려움 | ~3항목 |

| 구간 | 등급 | MCP 힌트 |
|------|------|----------|
| NAV, PRD, STK-01~04, CRT-01~08, NTF-01~05·07 | A | `건너뛰기`, `물품 추가`, `저장`(스크롤 후), `휴지, 재고 … 부족`, `꿀단지에 담기` |
| STK-05, CRT-02·04, PERM | B | fill·다이얼로그는 스크린샷; 2매장 시드 필요 |
| NTF-06, DAT-01~03 | C | 푸시 대기·공유 시트·비행기 모드 |

**실질 동작 검증**: 탭 전환·등록·재고 변경·담기·알림 UI는 **가능**. DB 이력·푸시 수신·백업 JSON은 **간접/수동**.

#### 접근성 (앱 현황)

- **잘 잡힘**: 탭, FAB, AppBar tooltip, 벌집 셀 Semantics, ChoiceChip, `저장`(스크롤 후)
- **약함**: TextField(좌표+type_keys), fill 게이지(스크린샷), ⋮ 메뉴

#### MCP 실행 전 체크

- [ ] `mobile_list_available_devices`에 시뮬레이터/에뮬레이터 표시
- [ ] debug APK/IPA 설치됨
- [ ] §3 시드 3종 또는 `mobile_uninstall_app` 후 재설치

### 실행 명령 (Android 에뮬레이터)

```bash
# AVD 기동 (이미 있으면 생략)
~/Library/Android/sdk/emulator/emulator -avd Medium_Phone_API_35

flutter run -d emulator-5554
# 스크린샷
adb exec-out screencap -p > docs/screenshots/android-emulator-home.png
```

> **Core Library Desugaring**: `flutter_local_notifications` 사용을 위해 `android/app/build.gradle.kts`에  
> `isCoreLibraryDesugaringEnabled = true` 및 `desugar_jdk_libs` 의존성이 필요함.

### 스크린샷

| 파일 | 플랫폼 | 내용 |
|------|--------|------|
| `docs/qa/seed-demo.json` | 공통 | QA 데모 데이터 (8물품 + 꿀단지 2건) |
| `android-hive-demo.png` | Android | 벌집 8물품 + 알림 4건 |
| `android-notifications-short-due.png` | Android | 기한 임박 알림 (가위·우유·탄산수·티슈) |
| `android-long-due-a4.png` | Android | A4 용지 — 다음 알림 9/6 (장기) |
| `android-cart-demo.png` | Android | 꿀단지 탄산수·가위 (5일·7일 주기) |
| `ios-hive-demo.png` | iOS | 벌집 8물품 |
| `ios-notifications-short-due.png` | iOS | 기한 임박 알림 목록 |
| `ios-long-due-a4.png` | iOS | A4 용지 장기 주기 |
| `ios-medium-due-wettissue.png` | iOS | 물티슈 — 다음 알림 7/16 (중기) |
| `ios-cart-demo.png` | iOS | 꿀단지 탄산수·가위 |

### 스크린샷 (2026-07-09)

| 파일 | 플랫폼 | 내용 |
|------|--------|------|
| `docs/screenshots/ios-simulator-home.png` | iOS | 온보딩 1슬라이드 |
| `docs/screenshots/android-emulator-onboarding.png` | Android | 온보딩 1슬라이드 |
| `docs/screenshots/android-emulator-home.png` | Android | 빈 벌집 홈 + BeeMascot 배너 |
| `docs/screenshots/android-emulator-cart.png` | Android | 꿀단지 탭 |
| `docs/screenshots/android-emulator-settings.png` | Android | 설정 탭 |
| `docs/screenshots/android-emulator-product.png` | Android | 물품 등록 후 벌집 + 알림 오버레이 |

---

## 8. 결함 심각도 기준

| 등급 | 정의 | 예시 |
|------|------|------|
| S1 치명 | 앱 크래시, 데이터 손실 | 복원 후 DB 깨짐 |
| S2 높음 | P0 기능 불가 | 구매 완료 시 재고 미반영 |
| S3 중간 | 우회 가능 | OCR 파싱 오류 (수동 수정 가능) |
| S4 낮음 | UI/문구 | 정렬 라벨 오타 |

---

## 9. 테스트 결과 기록 템플릿

```markdown
## 테스트 결과 — YYYY-MM-DD

- 빌드: v1.0.0+1
- 테스터: 
- 환경: iPhone 17 Simulator / iOS 26.5

| 구분 | 통과 | 실패 | 보류 |
|------|------|------|------|
| P0 | /39 | | |
| P1 | /13 | | |
| 자동 | 11/11 | | |

### 실패 항목
- [ID] 설명 / 재현步骤 / 스크린샷

### 비고
```

### 최근 스모크 결과 — 2026-07-10 (P0 전수 진행 3차)

- **시드**: Android `seed-demo.json` 복원 ☑ / iOS `honey_inventory.sqlite` 복사 ☑
- **도구**: mobile-mcp (`emulator-5554`, iPhone 17 `2DAC7ACA-…`)
- **P0 진행**: iOS **~32/39 ☑**, Android **~35/39 ☑** (△·미실행 별도)
- **코드 수정**: NTF-04 — `NotificationsScreen`이 `unacknowledgedRemindersProvider` 사용 + `addToCart` 시 `dismissReminder` 일괄 호출 (long press·검색 담기 포함)

**이번 세션 통과**
- NAV-01a/b (양쪽, 재설치 후)
- PRD-06 iOS, CRT-01b (양쪽 long press 담기)
- NTF-04 (양쪽, 수정 후 가위 담기 → 목록·배지에서 숨김)
- NTF-05 iOS (우유 snooze → 3→2건)
- PERM-02 iOS (권한 거부 후 인앱 알림·빈 목록 정상)
- DAT-02 Android (Downloads `seed-demo.json` 복원)

**4차 세션 추가 통과 (2026-07-10 밤)**
- PERM-02 Android: 재설치 → 설정 [허용] → OS [Don't allow] → `POST_NOTIFICATIONS granted=false`, 인앱 알림 4건·BeeMascot 정상, 크래시 없음
- DAT-03 Android: 비행기 모드 ON → 티슈 재고 +1(1→2), 생수 꿀단지 담기, `TestSoap` 신규 등록 → SQLite 반영 확인

**△ / 미완**
| ID | 사유 |
|----|------|
| PRD-02 Android | 한글 입력 불가 (mobile-mcp) |
| PRD-03 Android | 한글 수정 불가 |
| CRT-05 | Dismissible 스와이프 MCP 한계 |
| CRT-06 Android | 검색 한글 입력 불가 |
| NTF-06 | OS 로컬 푸시 — 시간·백그라운드 수동 검증 필요 |
| DAT-01 iOS | 공유 시트 MCP 미포착 (버튼 탭은 동작) |
| DAT-02 iOS | JSON 파일선택 UI 대신 sqlite 복사로 시드 적용 |
| DAT-03 iOS | 오프라인 CRUD 미실행 |

### 최근 스모크 결과 — 2026-07-10 (P0 전수 진행 2차)

- **도구**: mobile-mcp 양 플랫폼
- **P0 진행**: iOS **23/39 ☑**, Android **27/39 ☑** (△ 별도)

**이번 세션 추가 통과 (iOS)**
- NAV-03, PRD-02(티슈 merge), PRD-04(치즈 삭제), STK-03(직접입력), CRT-06(우유 검색 담기)

**이번 세션 추가 통과 (Android)**
- PRD-04, PRD-05(주기 14일), STK-03(탄산수 1→5)

**△ / 미완 (수동·재설치 필요)**
| ID | 사유 |
|----|------|
| NAV-01a/b | 앱 재설치 필요 (온보딩) |
| PRD-02 Android | 한글 입력 불가 (mobile-mcp) |
| PRD-06 iOS | 미실행 |
| CRT-05 | Dismissible 스와이프 MCP 한계 |
| CRT-06 Android | 검색 한글 입력 불가 |
| CRT-01b | long press 담기 미완(iOS) / △(Android) |
| NTF-04 | 담기 후 알림 목록 미숨김 (코드 이슈 의심) |
| NTF-05 iOS, NTF-06 | 미실행 (시간·권한) |
| DAT-01 iOS, DAT-02 iOS | 공유시트·파일선택 MCP 미포착 |
| DAT-03 | 오프라인 +1 △ (좌표 재검증 필요) |
| PERM-02 | 권한 거부 시나리오 미실행 |

### 최근 스모크 결과 — 2026-07-10 (P0 계속, QA 데모 시드)

- **시드**: `docs/qa/seed-demo.json` 유지 (Android 복원 / iOS sqlite)
- **도구**: mobile-mcp (`emulator-5554`, iPhone 17 `2DAC7ACA-…`)
- **P0 진행**: iOS **18/39**, Android **24/39** (☑ 기준, △ 별도)

**이번 세션 Android ☑**
- NAV-03, STK-01(+1), STK-02(long press +5), STK-05(ProgressBar)
- CRT-01a(생수 담기), CRT-02(이마트·코스트코·편의점), CRT-03·04(가위 구매완료+max제안), CRT-07(탄산수 2→3)
- NTF-05(탄산수 snooze), NTF-07(우유→상세), DAT-01(JSON 공유 시트), PRD-06(min>max 저장 차단)

**이번 세션 iOS ☑**
- STK-02(+5), PRD-03(가위→가위다용도가위), NTF-02(🍯 주기 알림), NTF-07(가위→상세)

**△ / 미완 / 이슈**
- PRD-03 Android: 한글 `type_keys` 미지원 → 숫자 필드만 자동화 가능
- NTF-04: [담기] 후 알림 목록에 항목 잔존 — `NotificationsScreen`이 `remindersProvider` 직접 사용( dismiss 필터 미적용) 의심
- CRT-05: mobile-mcp 스와이프로 Dismissible 트리거 어려움
- CRT-06: 꿀단지 검색 필드 MCP 좌표 미노출
- NAV-01a/b, PRD-02·04, DAT-03, NTF-06, PERM-02 등 미실행

### 최근 스모크 결과 — 2026-07-10 (QA 데모 시드 + mobile-mcp)

- **시드**: `docs/qa/seed-demo.json` 복원 (Android 설정→복원, iOS `Documents/honey_inventory.sqlite`)
- **벌집**: 우유·티슈·물티슈·생수·A4 용지·치즈·탄산수·가위
- **구매 이력**: 이마트·코스트코·다이소·문구점 등 수량 지정
- **알림**: 기한 임박 4건(부족+주기), A4는 9/6, 물티슈는 7/16
- **꿀단지**: 탄산수(5일 주기)·가위(7일 주기)
- **P0 추가**: DAT-02 Android ☑, NAV-04 양쪽 ☑, 데모 베이스 위 스크린샷 10장

### 최근 스모크 결과 — 2026-07-10 (mobile-mcp)

- **빌드**: v1.0.0+1 debug
- **테스터**: Agent + mobile-mcp
- **환경**
  - iOS: iPhone 17 Simulator, iOS 26.5 (`mobile-mcp` device `2DAC7ACA-…`)
  - Android: Medium_Phone_API_35 (`emulator-5554`, mobile-mcp)

| 구분 | iOS 통과 | Android 통과 | 미실행 |
|------|----------|--------------|--------|
| P0 (39) | 14 | 11 | 나머지 |
| 도구 | mobile-mcp 전 구간 | mobile-mcp 전 구간 | — |

**iOS 통과 (mobile-mcp)**
- NAV-02, NAV-04, NAV-05
- PRD-01, PRD-05
- STK-04; STK-01·03 △ (텍스트필드 덮어쓰기 어려움, 이력 +11 기록됨)
- NTF-01, NTF-03
- CRT-01a, CRT-03, CRT-04, CRT-08

**Android 통과 (mobile-mcp)**
- NAV-02, NAV-05
- PRD-01, STK-04 (기존 데이터)
- NTF-01, NTF-03
- CRT-01c, CRT-08
- PERM-01 (OS 권한 Allow)

**체크리스트 진행성**
- §4.8 재현 절차 순서대로 mobile-mcp `list_elements` → `click` → 검증 **가능**
- NAV-01a/b는 앱 재설치 없이 △ (이미 온보딩 완료 상태)
- 2026-07-10 후속: Android P0 24/39, iOS P0 18/39 — 상세는 위 「P0 계속」 절 참고
- 미실행: NAV-01b, PRD-02·04, STK-03, CRT-05·06, DAT-01 iOS, DAT-03, NTF-04·06, PERM-02 등

**스크린샷**: `docs/screenshots/ios-p0-test-final.png`, `android-p0-test-final.png`

### 최근 스모크 결과 — 2026-07-09

- **빌드**: v1.0.0+1
- **테스터**: Agent (adb / simctl)
- **환경**
  - iOS: iPhone 17 Simulator, iOS 26.5 (`flutter build ios --simulator` + `simctl`)
  - Android: Medium_Phone_API_35 (API 35), `emulator-5554` (`flutter run`)

| 구분 | 통과 | 실패 | 보류 |
|------|------|------|------|
| L0 자동 | 11/11 | 0 | 0 |
| L2 iOS 스모크 | 1 | 0 | 31 (P0 미실행) |
| L3 Android 스모크 | 8 | 0 | 24 (P0 미실행) |

**iOS 확인 항목** (2026-07-09 스모크, P0 전수 미완)
- △ NAV-01a: 온보딩 1슬라이드 렌더링 (`ios-simulator-home.png`)
- 앱 기동·빌드 성공 (ML Kit Apple Silicon 패치 적용)

**Android 확인 항목** (2026-07-09 스모크, P0 전수 미완)
- ☑ NAV-01a: 건너뛰기 → 빈 벌집 홈
- ☑ NAV-02: 벌집 / 꿀단지 / 설정 탭 전환
- ☑ PRD-01: `Tissue` 물품 등록 → 벌집 셀 표시
- ☑ STK-04: min 이하 부족 🐝·주황 채움
- ☑ NTF-01: 상단 알림 배너 (1건)
- ☑ NTF-03: BeeMascot 하단 오버레이

> 2026-07-10 문서 개정: P0 38항목·재현 절차(§4.8) 추가. 위 스모크는 전체 P0의 일부만 해당.

**비고**
- Android 물품 등록 폼: 저장 버튼이 스크롤 아래에 있어 `adb` 자동화 시 스크롤 필요
- `KEYCODE_BACK`은 폼을 닫으므로 키보드 닫기에 사용 금지
- iOS 실기기(🎲): Development Team 미설정으로 설치 실패
- Mobile MCP: Cursor 재시작 후 UI 자동화 가능

---

## 10. 관련 문서

- [02-prd.md](./02-prd.md) — 사용자 스토리·수용 기준
- [05-feature-specs.md](./05-feature-specs.md) — 기능 상세
- [07-screen-flow.md](./07-screen-flow.md) — 화면 흐름
- [README.md](./README.md) — 구현 현황
