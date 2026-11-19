# 결정 기록 (Decision Log)

> Flutter 앱의 결정과 근거를 시간순으로 추가한다. 번호는 `FL-xxx`이고 공통 결정 D-xxx(`../futureETP/docs/decisions.md`)와 겹치지 않는다.
> 번복 시 기존 항목은 지우지 말고 상태를 `대체됨`으로 바꾼다. 공통으로 바뀌어야 할 결정(제품·API·화면 동작)은 여기가 아니라 futureETP에 D-xxx로 적는다.

<!--
## FL-001: <제목>
- 날짜: YYYY-MM-DD
- 상태: 확정 | 검토중 | 대체됨(FL-xxx)
- 맥락:
- 선택지:
- 결정:
- 근거:
- 영향:
-->

## FL-001: 공통 문서는 futureETP 원본을 상대경로로 읽는다
- 날짜: 2026-11-18
- 상태: 확정 (사용자 요청, D-141)
- 맥락: 같은 서버로 RN·Flutter·Swift·Kotlin 앱 네 개를 만든다. 제품·화면·API 계약 문서를 저장소마다 둘지 정해야 했다.
- 선택지: (a) futureETP 원본 + 상대경로 참조 (b) 저장소마다 복사 (c) 상위 공통 폴더로 이동
- 결정: (a). 이 저장소는 `CLAUDE.md`·`TODO.md`·`docs/tech-stack.md`·`architecture.md`·`decisions.md`만 갖고, 나머지는 `../futureETP/...`를 읽는다. 두 저장소는 같은 상위 폴더(`_project/`)에 나란히 있어야 한다.
- 근거: 복사하면 제품 결정이 바뀔 때 네 곳을 고쳐야 해 어긋난다. 원본 변경은 futureETP가 이 저장소 `TODO.md`의 "원본 변경 반영"에 적는다.
- 영향: `CLAUDE.md` "공통 문서", `TODO.md` "원본 변경 반영".

## FL-002: 앱 ID를 RN과 같이 쓰고 `appVersion` 접두사로 구분한다
- 날짜: 2026-11-18
- 상태: 확정 (사용자 요청, D-141)
- 맥락: 앱마다 다른 ID면 한 기기에 함께 설치할 수 있지만 서버 푸시 설정(FCM 앱 등록·APNs topic)을 여러 앱으로 늘려야 한다.
- 결정: 앱 ID `io.github.seyoon.futureetp`, dev 변형 `io.github.seyoon.futureetp.dev`. `PUT /v1/devices`의 `appVersion`은 `fl-<버전>`.
- 근거: 서버·Firebase·APNs 설정을 바꾸지 않는다. `appVersion`은 64자 문자열이라 스키마 변경 없이 어느 클라이언트인지 서버 기록에서 알 수 있다.
- 영향: 한 기기에 RN 앱과 함께 설치할 수 없다. 바꿔 설치하면 새 installation ID로 새 기기 행이 생겨 접근 키·기기 설정을 다시 넣는다. 서명 키가 다르면 기존 앱을 지운 뒤 설치해야 한다(Android).

## FL-003: iOS 의존성 통합
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: Flutter 3.44부터 iOS·macOS 기본 의존성 관리가 Swift Package Manager(SwiftPM)이고, CocoaPods 저장소는 2026-12-02 읽기 전용이 된다. 이 Mac의 Flutter 3.50.0은 `enable-swift-package-manager`가 기본 켜짐(`flutter doctor -v`), CocoaPods 1.17.0도 설치돼 있다.
- 선택지: (a) SwiftPM 기본 (b) pubspec에서 끄고 CocoaPods
- 결정: (a). 끄지 않는다. SwiftPM을 지원하지 않는 플러그인은 Flutter가 CocoaPods로 대신 통합하므로 CocoaPods는 지우지 않고 둔다.
- 근거: Flutter 기본값이고 CocoaPods는 유지보수 단계다. 이 앱 후보 플러그인(FL-008·FL-009·FL-011)이 SwiftPM을 지원하지 않으면 스캐폴딩 때 `flutter build ios` 경고로 확인한다.
- 출처: [Flutter 블로그 "Saying goodbye to CocoaPods"](https://flutter.dev/blog/saying-goodbye-to-cocoapods-swift-package-manager-is-soon-the-default-in-flutter) (2026-11-19 확인)

## FL-004: 상태 관리는 Riverpod 3, 코드 생성 없이
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: RN의 TanStack Query(서버 상태)와 Zustand(기기 설정)를 한 상태 계층으로 옮긴다.
- 선택지: (a) `flutter_riverpod` 수동 Provider (b) (a) + `riverpod_generator` (c) Bloc
- 결정: (a) `flutter_riverpod` 3.5.0. `Notifier`·`AsyncNotifier`와 family만 쓰고 `legacy.dart`(StateProvider·StateNotifier)는 쓰지 않는다.
- 근거: CLAUDE.md 레이어(Widget → Notifier → repository)가 Riverpod 전제. Riverpod 3.4.1 changelog가 4.0이 곧 나온다고 밝혀 생성기 API가 흔들릴 수 있고, Provider 수가 적어 생성기 이득이 작다. 코드 생성은 모델(FL-007)에만 둔다.
- 영향: 4.0이 나오면 이전 비용을 보고 다시 정한다.

## FL-005: 내비게이션은 go_router
- 날짜: 2026-11-19
- 상태: 확정
- 결정: `go_router` 18.1.4. C 하단 탭은 `StatefulShellRoute.indexedStack`으로 탭별 상태를 유지하고, C-d-a는 셸 밖 라우트.
- 근거: Flutter 팀 관리 패키지이고 유지보수 단계(기능 고정, 버그 수정)라 안정적. Expo Router의 A → C 스택 + C 안 하단 탭 + 탭 밖 상세 구조와 1:1로 대응한다.

## FL-006: HTTP는 dio
- 날짜: 2026-11-19
- 상태: 확정
- 선택지: (a) `dio` (b) `http` + 직접 래퍼
- 결정: (a) `dio` 5.11.1. 재시도는 패키지 없이 D-072 규칙(`NETWORK`·`TIMEOUT`·`INTERNAL`만 2회, 변경 요청 제외)대로 API client에 직접 구현한다.
- 근거: 요청별 타임아웃·`CancelToken`·인터셉터(헤더 주입)가 기본이고, `DioException` 종류(`connectionTimeout`·`receiveTimeout`·`connectionError`)를 `AppError`의 `TIMEOUT`·`NETWORK`로 바로 나눌 수 있다. `http`는 이를 직접 만들어야 한다.

## FL-007: 응답 모델은 freezed 손 작성 + JSON Schema 계약 테스트
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-142로 계약이 `../futureETP/packages/shared/contract/schemas/*.json`(draft 2020-12)에 있다.
- 선택지: (a) `freezed` + `json_serializable`로 손 작성 + 계약 테스트 (b) 스키마에서 모델 자동 생성(quicktype 등)
- 결정: (a) `freezed` 4.0.3·`freezed_annotation` 3.1.0·`json_serializable` 6.15.2·`json_annotation` 4.12.0·`build_runner` 2.17.1. 계약 테스트는 `json_schema` 5.2.2(draft 2020-12 지원)로 저장한 dev 서버 응답이 스키마를 통과하는지와 모델로 디코딩되는지를 함께 본다.
- 근거: 스키마 생성 도구는 nullable·enum·`pattern` 표현이 거칠고 생성 결과를 손봐야 해 재생성이 어렵다. 스키마가 15개로 적어 손 작성 비용이 작고, 어긋남은 계약 테스트가 잡는다. 디코딩 실패는 `SCHEMA_MISMATCH`(D-042).
- 영향: 스키마가 바뀌면(원본 변경 반영) 모델과 fixture를 함께 고친다.

## FL-008: 저장소 패키지
- 날짜: 2026-11-19
- 상태: 확정
- 결정: 접근 키·installation ID는 `flutter_secure_storage` 11.2.0(Android 최소 SDK 24), 언어·등락 색은 `shared_preferences` 2.5.6의 `SharedPreferencesAsync`.
- 근거: D-043·D-044. `SharedPreferencesAsync`는 패키지가 권장하는 새 API로 캐시 불일치가 없다. 값이 두 개뿐이라 로컬 DB는 쓰지 않는다.

## FL-009: QR·i18n
- 날짜: 2026-11-19
- 상태: 확정
- 결정: QR은 `mobile_scanner` 7.5.0(D-078). i18n은 `flutter_localizations` + `intl`(Flutter SDK가 고정하는 버전, 현재 0.20.x) + gen-l10n, ARB는 `lib/l10n`(D-033, D-073).

## FL-010: lint는 very_good_analysis
- 날짜: 2026-11-19
- 상태: 확정
- 선택지: (a) `flutter_lints` 6.0.0 (b) `very_good_analysis` 11.0.0
- 결정: (b). `public_member_api_docs`만 끈다(개인 앱, 공개 API 없음).
- 근거: `flutter_lints`는 2025-05 뒤 갱신이 없고 규칙이 느슨하다. `very_good_analysis`는 2026-09 갱신, 엄격 규칙(타입 명시·불변·async 실수)이 RN의 strict TypeScript 수준에 가깝다.
- 영향: import 방향 검사(D-041)는 lint 플러그인(`custom_lint` 0.8.1은 2025-09 뒤 갱신 없음) 대신 2단계에서 `lib/` import 경로를 검사하는 테스트로 정하는 쪽을 우선 검토한다.

## FL-011: 푸시 패키지
- 날짜: 2026-11-19
- 상태: 검토중(iOS는 5단계에서 확정)
- 맥락: 서버는 Android FCM HTTP v1, iOS APNs 직접 발송(D-037). RN은 `expo-notifications`의 `getDevicePushTokenAsync`로 두 OS의 네이티브 토큰을 받는다(Firebase iOS 설정 없음).
- 결정: Android는 `firebase_messaging` 17.1.0 + `firebase_core` 5.2.0. iOS는 Firebase iOS 앱 등록 없이 APNs 기기 토큰을 받는 방법(작은 플랫폼 채널 vs `firebase_messaging.getAPNSToken()` + GoogleService-Info.plist)을 Apple 가입 뒤 5단계에서 정한다.
- 근거: RN과 같이 iOS에 Firebase 설정을 두지 않는 쪽이 서버·Firebase 설정을 바꾸지 않는다(FL-002).
