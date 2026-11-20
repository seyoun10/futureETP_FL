# Architecture

> Flutter 앱의 구조. API 규약·화면 동작은 원본(`../futureETP/docs/architecture.md`·`wireframes/screens.md`)을 따르고, 여기에는 이 앱의 구조와 대응만 적는다.
> 디렉터리는 계획 구조다. 현재 있는 것은 `app/`(app·router), `core/config`, `core/api`, `core/storage`, `core/settings`, `core/theme`, `core/util`, `core/widgets`, `core/query`, `core/charts`, `features/access_key`, `features/commodity_list`, `features/commodity`(C 껍데기·C-a·C-b·C-c·C-d·C-d-a, 차트 탭 공통 `chart_tab.dart`), `features/settings`(B), `features/alert_settings`(B-a), `features/data_sources`, `l10n`이다.

## 디렉터리 구조

```
lib/
├─ main.dart                     진입점 하나. 변형은 appFlavor, dev 값은 dart-define(FL-012)
├─ app/                          라우터(go_router), 앱 루트, 테마 적용
├─ features/                     화면 단위: 화면 Widget·전용 위젯·Provider
│  ├─ commodity_list/            A
│  ├─ settings/ alert_settings/ access_key/ data_sources/   B, B-a, B-b, 데이터 출처
│  └─ commodity/                 C: disparity_chart(C-a)·contract_chart(C-c)·curve(C-b)·etp(C-d, C-d-a)
├─ core/
│  ├─ config/                    변형·서버 주소(AppConfig)
│  ├─ api/                       HTTP 래퍼, AppError, 엔드포인트 함수, 응답 모델(`models/`, FL-017)
│  ├─ query/                     자동 새로고침·앱 복귀 재조회(`AutoRefreshNotifier`, FL-022)
│  ├─ charts/                    CustomPainter 차트·뷰포트(핀치·드래그)
│  ├─ widgets/                   공용 UI(ScreenHeader, FreshnessLine, QueryStateView, SegmentedControl, SectionHeader)
│  ├─ settings/                  기기 UI 설정 저장(언어·등락 색, FL-019), 서버 기기 설정 조회·직렬 PATCH(FL-031)
│  ├─ storage/                   보안 저장소 인스턴스(FL-015)
│  ├─ theme/                     테마 토큰(다크 전용), ThemeData, 등락 색(FL-020)
│  ├─ push/                      기기 푸시 경계(PushService)·토큰 등록·알림 권한 상태, 알림 data → 이동 원자재(FL-032, FL-033). 탭 이동 자체는 app/notification_taps.dart
│  └─ util/                      숫자·날짜 포맷, 햅틱, 실패 Alert
└─ l10n/                         app_ko.arb, app_en.arb, 생성 코드 app_localizations*.dart
test/                            lib와 같은 구조, architecture/(import 방향 검사), contract/(계약 스키마 복사본·dev 서버 응답 fixture), cross/(RN 순수 함수 결과와 비교, FL-036)
tool/                            check.sh, ios_flavors.rb, sync_contract.sh, sync_rn_cross.sh(+ rn_cross/generate.mts, FL-036)
env/                             dev.example.json(커밋), dev.json(커밋 안 함)
docs/                            tech-stack, architecture, decisions
```

규칙
- 화면 → Riverpod Notifier → repository → API client 한 방향. 화면은 HTTP·저장소를 직접 부르지 않는다.
- 화면 전용 코드는 해당 feature 안에, 두 곳 이상에서 쓰면 공용 계층(`core`)으로 옮긴다.
- import 방향(RN D-041, 2026-11-19 lint로 강제): feature끼리 import하지 않는다(컴포넌트·헬퍼·조회도 다른 feature가 쓰면 `lib/core`로 옮긴다). `lib/core`는 features·`lib/app`을 import하지 않고, features는 `lib/app`(라우트)을 import하지 않는다. `test/architecture/import_direction_test.dart`가 강제한다(FL-010).
- RN에서 공용으로 옮긴 것: `SectionHeader`·`SettingsHeaderButton`(공용 UI), 에러 code → 사용자 문구 함수 `errorText`(API의 `AppError` 옆), ETP 정렬 기준 `ETP_SORTS`(util).
- 월물 심볼은 서버 표준형(`CLZ26`)만 쓴다. 표시 표기(`DEC26`)는 포맷 함수가 만든다.

## 레이어

| 계층 | 맡는 것 | 하지 않는 것 |
|---|---|---|
| 화면(Widget(화면)) | 그리기, 사용자 입력, 상태 구독 | HTTP, 저장소, 계산 |
| 상태(Riverpod Notifier) | 화면 상태(로딩·데이터·오류), 사용자 동작 처리, 자동 새로고침 타이머 | HTTP 세부 |
| repository | 조회 캐시(staleTime·gcTime), 무한 조회(`before`·`hasMore`), 낙관적 PATCH | 화면 문구 |
| API client | 헤더, 타임아웃, 봉투 디코딩, `AppError`, 재시도 | 캐시 |

- 캐시 규칙은 RN과 같다: C 차트 조회는 `staleTime`을 `nextUpdateAt`까지, `gcTime` 1시간. C-a·C-c는 3년(756거래일) 단위로 받고 가장 과거 봉이 보이면 이전 3년을 더 받는다(D-104). 커브는 서버가 저장·캐시하지 않고(D-046), 앱은 RN처럼 기준일마다 1시간 둔다.

## RN 구조 대응

| RN(`../futureETP/apps/mobile/src`) | 이 앱 |
|---|---|
| `src/app/`(Expo Router) | `lib/app/router.dart`(go_router) |
| `src/features/*` | `lib/features/*` |
| `src/api`(fetch 래퍼·AppError·query key) | `lib/core/api` + Riverpod Provider(캐시 키 = Provider family 인자) |
| `src/charts`(Victory + Skia) | `lib/core/charts`(CustomPainter) |
| `src/stores`(Zustand persist) | `lib/core/settings` + Notifier |
| `src/theme` | `lib/core/theme`(ThemeExtension 토큰) |
| `src/i18n` | `lib/l10n`(ARB, gen-l10n) |
| `src/push` | `lib/core/push` |
| `src/lib` | `lib/core/util` |

## D-번호 적용

공통 결정은 `../futureETP/docs/decisions.md`. 이 앱에 어떻게 적용하는지만 나눈다.

- 그대로 적용: 제품·화면·API·UX 결정. 예) D-001~D-026(제품), D-036·D-042·D-044·D-048·D-072(API·에러·접근 키·자동 새로고침), D-075~D-086, D-090~D-093, D-102~D-125, D-137~D-139(화면 동작)
- 플랫폼 수단으로 바꿔 적용: D-030(상태·패칭), D-031(스타일·테마), D-033(i18n), D-041(레이어), D-043·D-052(변형), D-073(표시 설정 저장), D-087(차트 부품), D-128(deprecated API 금지 → 이 언어의 deprecated 경고를 오류로), D-039의 Android release 서명·ABI(FL-034)
- 적용 안 함(RN·Expo 전용): D-027·D-029·D-032·D-050(Expo·Router·Victory·스캐폴딩), D-039의 EAS Update, D-054·D-140(jest-expo·Jest 캐시)
- 판단이 애매하면 해당 D 항목을 읽고 `decisions.md`에 FL-xxx로 적용 방식을 적는다.
