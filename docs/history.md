# History

> `TODO.md`에서 끝난 블록을 같은 절 이름 아래로 옮겨 둔다. 최신이 아래.

## 원본 변경 반영
- [x] API 계약 JSON Schema 생성(2026-11-19, futureETP D-142): `../futureETP_ReactNative/packages/shared/contract/`. 3단계 응답 모델은 이 파일을 기준으로 한다(TODO 3단계 응답 모델 항목에 반영됨, 2026-11-19 확인)
- [x] 레이어 import 방향 lint 강제(2026-11-19, futureETP D-041 변경): feature 간 import 금지, 공용 계층 → features·라우트 금지. `docs/architecture.md` "규칙"과 TODO 2단계에 반영됨 (2026-11-19 확인)
- [x] 첫 로딩 가운데 스피너(2026-11-19, futureETP 527a3b2): 첫 조회 중 스켈레톤(공용 막대·차트 격자) 위 가운데에 큰 스피너를 겹친다. 차트 탭은 차트 자리 가운데이고, 데이터가 온 뒤 첫 기간 맞춤 전(차트를 감춘 동안)에도 띄운다(e94b2c2). `../futureETP_ReactNative/docs/wireframes/screens.md` 공통 로딩 항목. 공용 막대(`LoadingView`·`CenterSpinner`)는 넣음, 차트 격자 스켈레톤은 C-a와 함께 넣음(2026-11-19, `ChartSkeleton`). 첫 기간 맞춤은 첫 프레임 전에 끝나 감출 동안이 없다(FL-027)
- [x] 휴장 달력 일정을 기기 로컬로(2026-11-23, futureETP D-144, FL `local_schedule.dart`·FL-037): 예외 일정을 시장 날짜 대신 기기 로컬 날짜 칸에 둔다. 시각 있는 일정은 `at`(시장 현지)을, CLOSED는 정규 개장 시각(CME 전날 17:00 CT, KRX 09:00 KST, NYSE 09:30 ET)을 로컬로 바꾼 날짜. 목록과 날짜 칸 점은 로컬 시각순(휴장은 정규 개장 시각, 같은 시각은 시장 순). 문구 시각은 로컬 `HH:mm`이고 시간대 표기 없음(`calendar.kinds`의 `{{tz}}`·`calendar.timeZones` 삭제). 조회 범위를 앞뒤 하루씩 넓히고 3개월 밖 연도 `missing`은 숨김. 같은 날 같은 시장 점이 둘일 수 있음. futureETP `features/calendar/localSchedule.ts`, screens.md A-a
- [x] rare 레벨 입력 규칙 강화(2026-11-21, futureETP 품질 검증 B2/D1·D3): rare 레벨은 소수 첫째 자리로 반올림한 값으로 중복을 본다(1과 1.00000000001은 중복). C-a `levels` query는 `^d+(.d+)?(,d+(.d+)?)*$`만 받는다(공백·`0x8`·`1e1` 거절, 계약 `disparityQuery`). 앱 입력 검증이 같은 규칙인지, 직렬화가 숫자 기본 문자열(`1`, `2.5`)인지 확인. 반영: 중복은 반올림 값으로 보고 반올림 값으로 저장(`hasDuplicateRareLevels`·`roundRareLevel`), 입력은 `^\d+(\.\d+)?$`, `levels` 직렬화는 `1`·`2.5`(`DisparityParams`, 41949c4)
- [x] 휴장 달력 화면 A-a(2026-11-21, futureETP D-143): A title-bar [⚙] 왼쪽에 [📅](`calendar-month-outline`) → 이번 달~다다음 달 3개월 세로 달력, 오늘(기기 로컬)·CME/KRX/NYSE 휴장(채운 점)·조기 마감/개장 지연(빈 점)·달별 휴일 이름 목록·미입력 안내. API `GET /v1/calendar?from&to`(계약 `calendar`·`calendarQuery`), 색 `colors.market`·`today`, 문구 `calendar.*`. `../futureETP_ReactNative/docs/wireframes/screens.md` A-a. 캐시: 응답 `missing`이 비어 있으면 12시간, 있으면 5분 stale(화면 재진입·앱 복귀 때 다시 조회, 서버 import 뒤 재시작 없이 반영. futureETP `useMarketCalendar.ts`)
  - [x] 모델·`getCalendar`·`calendarProvider`(캐시 규칙)
  - [x] 3개월 달력 화면·색 토큰·`calendar.*` 문구(D-144 로컬 날짜·시각 포함, `CalendarScreen`)
  - [x] A 제목 줄 [📅] 버튼·라우팅(`/calendar`)
  - [x] 기기 확인: 3개월 달력 모양·스크롤·홈 인디케이터 여백, 스크린 리더 문구(iOS 시뮬레이터 2026-11-23. 일정 시각이 UTC로 나오던 것·월 제목에 목록 문구가 합쳐 읽히던 것 수정)

## 0. 환경
- [x] Flutter SDK 설치(현재 Mac에 없음): 공식 안내대로 설치하고 `flutter doctor`가 Android·iOS 모두 통과하는지 확인
- [x] `flutter config --jdk-dir`로 Zulu JDK 17(RN과 같은 JDK)을 쓰게 하고 Android SDK·에뮬레이터 `Pixel_API_36`은 RN과 함께 쓴다
- [x] iOS: Xcode 27.2·CocoaPods 또는 Swift Package Manager 통합 중 어느 쪽인지 `flutter doctor` 결과로 정한다
  - 결과(2026-11-19): Flutter 3.50.0·Dart 3.14.0, `flutter doctor` 이슈 없음, iOS는 SwiftPM(FL-003)

## 1. 스택 확정
- [x] `docs/tech-stack.md`의 후보를 하나씩 정한다(2026-11-19, FL-004~FL-010 확정, FL-011 푸시는 iOS만 5단계로 남김). 버전은 pub.dev API로 확인
- [x] 차트 방식은 2단계 뒤 C-a 스파이크(4단계 첫 항목)로 정한다 (2026-11-19, `CustomPainter` 직접 구현, FL-025)

## 2. 스캐폴딩
- [x] 프로젝트 생성, 앱 ID `io.github.seyoon.futureetp`·dev `.dev` 두 변형, 앱 이름·아이콘(RN `apps/mobile/assets` 재사용)
- [x] lint·format·test 설정과 검사 명령 하나(`check`), CLAUDE.md Commands를 실제 명령으로 갱신
  - import 방향 규칙(architecture.md "규칙")을 검사에 넣는다. 후보: dart 검사 스크립트(테스트로 `lib/` import 경로 검사) 또는 lint 플러그인
- [x] dev 변형이 로컬 dev 서버 `GET /v1/health`를 부르는 최소 화면으로 연결 확인
  - 결과(2026-11-19): flavor는 FL-012, lint·import 방향 검사는 FL-010, material_ui는 FL-013. dev 변형이 iOS 시뮬레이터·Android 에뮬레이터에서 로컬 dev 서버 health 응답을 보였다
- [x] (선택) 원격 저장소·CI(GitHub Actions에서 `./tool/check.sh`) (2026-11-19, FL-014)

## 3. 공통 기반
- [x] installation ID(첫 실행 UUID) 생성·보안 저장소 보관 (D-120, FL-015)
- [x] API client: 헤더(Bearer·`X-Device-Id`), 타임아웃 15초, 봉투 디코딩, `AppError`, 재시도 규칙 (D-042, D-072, FL-016). `UNAUTHORIZED` → B-b 이동은 접근 키 항목
- [x] 응답 모델: `../futureETP_ReactNative/packages/shared/contract/schemas/*.json`과 맞춘 모델(손으로 또는 생성 도구) + 계약 테스트(실제 dev 서버 응답을 저장한 예시를 모델로 디코딩하고, 같은 예시가 JSON Schema를 통과하는지) (D-142, FL-017)
- [x] 접근 키 B-b: 붙여넣기·QR(`futureetp-key:v1:` 접두사), `GET /v1/settings`로 확인 뒤 저장, 키 없으면 첫 화면이 B-b, `UNAUTHORIZED`면 어느 화면에서든 B-b + 거절 줄 (D-044, D-077~D-079) (FL-018)
- [x] i18n ko/en, 앱 안 언어 설정을 서버 기기 설정과 맞춤 (D-033, D-073, D-137). iOS 카메라 권한 문구 한국어(InfoPlist.strings, D-078 보충) (FL-019)
- [x] 테마 토큰(다크 전용)·등락 색 설정 저장 (D-031, D-073) (FL-019, FL-020)
- [x] 숫자·날짜 포맷(RN `formatNumber`·`formatDateTime`과 같은 결과) 단위 테스트 (FL-021, `formatAmount`도 함께)
- [x] 공용 조회 UI: 기준 시각 줄(freshness)·로딩/오류/빈 상태 분기·`nextUpdateAt` + 1분 자동 새로고침·앱 복귀 재조회 (D-048, D-075) (FL-022)
- [x] 앱 실행 때 시간대 PATCH (D-084), 세로 잠금·[⟲] 가로 전환 (D-076) (FL-023, FL-024. [⟲] 버튼은 C-a와 함께)
- [x] 실행 화면(splash) 검정 배경·아이콘(RN `splash-icon.png` 76pt, `flutter_native_splash`. Android 첫 프레임 전 바탕도 검정. iOS 시뮬레이터·Android 에뮬레이터 API 37에서 확인)
- [x] 2단계 임시 화면 `features/dev_health`·`devHealth*` 문구 지움(B 화면과 함께) (2026-11-20, FL-026, FL-031)
- [x] 접근 키 QR 읽기 실기기 확인(키 스크립트 QR, iPhone 14 Pro prod Release) (2026-11-23, FL-018)

## 4. 화면 수직 슬라이스
- [x] C-a 차트 스파이크: 봉 756개 + 이평선·rare-level 밴드, 핀치·드래그·십자선, 가장 과거 봉이 보이면 이전 3년 이어 받기에서 범위 유지, 60fps 이상 (D-056, D-087, D-104, D-106) → 차트 방식 결정 (2026-11-19, FL-025. Android 에뮬레이터 API 37 `-gpu host` profile 빌드로 측정, iOS·실기기는 설치 때)
- [x] A 원자재 목록: `GET /v1/commodities`, 대표월물 ●·알림 🔔·거래 없음, 당겨서 새로고침(햅틱·터치 차단·5초 시간 초과 Alert, D-138), [⚙] 알림 꺼짐 점(D-124) (2026-11-19, FL-026. Android 에뮬레이터 API 37 dev 서버로 확인. 행 누르기는 C 화면과 함께)
- [x] A 원자재 목록 남은 것: 행을 누르면 선택 햅틱·C-a 이동·C-a 미리 조회(C 화면과 함께, D-085, D-109) (2026-11-19, FL-027)
- [x] C-a 이격도차트: `GET /v1/commodities/:code/disparity`, 기간 버튼 6개(D-102), [⟲] 버튼(`lockLandscape`·ETP 탭·C 밖에서 `lockPortrait`, FL-024), 롤 음영, 십자선 상세, 가로 모드, 이전 3년 받기 중 화면 터치 차단·5초 시간 초과·실패 Alert (D-086, D-103, D-108, D-139). `lib/core/charts`(FL-025)를 이어 쓰고, 스파이크 화면은 지웠다 (2026-11-19, FL-027. Android 에뮬레이터 API 37 dev 서버로 확인, 실기기 손동작·성능은 남김)
- [x] C-c 월물차트: `GET /v1/commodities/:code/contracts`, log y축(0 이하면 선형), 끝값 라벨, 범례, 십자선 상세 롤 수익률, 이전 3년 받기 (D-092, D-093, D-113, D-118). 차트 코어를 선만 그리기·선형 축으로 일반화하고 C-a와 탭 상태를 함께 쓴다 (2026-11-20, FL-028. Android 에뮬레이터 API 37 dev 서버로 확인, 실기기 손동작은 C-a 항목과 함께)
- [x] C-b 월물커브: `GET /v1/commodities/:code/curve?baseDate`, 기준일 휠 시트, 이전·다음 기준일, [↻], 변화율 라벨 배치, 롤 수익률, 휴장일 옮김 안내 (D-090, D-091, D-114~D-123) (2026-11-20, FL-029. Android 에뮬레이터 API 37 dev 서버로 확인, Android도 휠 시트로 바꿈)
- [x] C-d ETP 목록(필터·정렬은 앱에서)·C-d-a 상세: `GET /v1/commodities/:code/etps`·`GET /v1/etps/:id`, 세그먼트 필터·정렬 값, 수집 시각 줄, 시리즈 줄, 운용사 페이지 열기 (D-017, D-047) (2026-11-20, FL-030. 위젯 테스트로 확인, 기기 확인은 TODO에 남김)
- [x] B 설정·B-a 알림 설정·데이터 출처: 직렬·낙관적 PATCH, rare-level 입력 검증·정렬 저장, [초기화], 알림 대상·거부 시간 시트, 알림 대상이 바뀌면 A 목록 다시 받기, B-b title-bar `ScreenHeader`, 앱 버전 줄 (D-081~D-083, D-124) (2026-11-20, FL-031. 위젯 테스트로 확인, 기기 확인은 TODO에 남김, 권한 배너는 FL-033)
- [x] 화면별 세부 동작을 `../futureETP_ReactNative/docs/wireframes/screens.md`와 대조(A·B·B-a·B-b·C·C-a~C-d-a·공통 규칙, X 푸시는 5단계). 고친 차이: C-a·C-c 가로 격자·y 눈금·롤 음영을 위 정보 줄 뒤까지, C-a·C-c [↻]를 C-b와 같은 전체 폭 가운데로, C-a 기준값 안내를 둘째 줄 위에 띄움, C-a 저점대비·고점대비를 화면에 걸친 봉까지 셈(RN `visibleRange`) (D-117) (2026-11-20)
- [x] RN 앱과 iOS 시뮬레이터 화면 대조(2026-11-23, iPhone 17 두 대에 RN·FL dev를 나란히 띄워 A·A-a·B·B-a·B-b·데이터 출처·C-a~C-d-a 비교). 고친 차이: Material 3 글자 기하(줄 높이 1.43·자간 0.25)를 빼 줄 높이·자간을 RN과 같게(A 대표월물 ● 잘림 포함), C-d 목록 위 안전 영역 빈칸·기기 로캘 한국어면 한글 이름 먼저 정렬, C 탭바 높이 49, C-d-a 운용사 링크 크기, 차트 탭 안내 위쪽 배치·C-b 기준일 버튼 여백, y축 눈금 라벨 겹침 높이(글자 11 + 6)·x축 양끝 바깥 봉까지 월 경계, 아이콘을 RN과 같은 MDI 글꼴로(FL-038), B-a 거부 시간 줄 높이(iOS 스위치 31), B-b 입력 칸 44·글자 14·버튼 터치 여백. 남긴 차이: 한글 섞인 줄이 줄마다 0.67pt 높음(FL-039)
- [x] iOS 실기기 확인(iPhone 14 Pro, prod Release, Personal Team 서명): C-a·C-b·C-c 핀치·드래그·십자선·햅틱·성능·기준일 휠 시트, B·B-a rare-level 키패드 [완료] 줄·끌어서 닫기·저장·오류 줄·거부 시간 시트·앱 버전 줄. Android는 TODO에 남김 (2026-11-23, FL-025, FL-027~FL-029, FL-031)

## 5. 푸시
- [x] Android FCM 토큰 등록·알림 권한·채널(`alerts`·`ops`), `PUT /v1/devices`(`appVersion` `fl-<버전>`), 앱 사용 중 알림 표시, 알림 탭으로 C-a·A 이동. 에뮬레이터 수신 확인은 4단계 기기 확인으로 (D-037, D-045, D-120, FL-032) (2026-11-20)
- [x] B-a 알림 권한 배너: 꺼져 있을 때만, 다시 물을 수 있으면 [허용] 아니면 [설정 열기], 앱 복귀 때 다시 읽음(`permission_handler`). 기기 확인은 4단계로 (screens.md B-a, FL-033) (2026-11-20)

## 6. 기기 설치·운영
- [x] Android release 서명(RN과 같은 키), versionCode 10000 + 커밋 수(RN 앱 위 덮어 설치), arm64-v8a만(27.4MB), `tool/build_android_release.sh` (D-039, FL-034) (2026-11-20)
- [x] 설치·업데이트 방식: Mac에서 adb 직접 설치, OTA 없음, `tool/install_android_release.sh`, 절차와 RN ↔ FL 바꿔 설치는 `docs/ops.md` (FL-035) (2026-11-20)
