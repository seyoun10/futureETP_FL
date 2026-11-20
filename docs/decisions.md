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
- 영향: import 방향 검사(D-041)는 lint 플러그인(`custom_lint` 0.8.1은 2025-09 뒤 갱신 없음) 대신 `test/architecture/import_direction_test.dart`가 `lib/`의 import·export 경로를 검사한다(2단계, `flutter test`에 포함). 분석 경고는 `--fatal-infos`로 모두 실패 처리, deprecated 사용은 오류(D-128).

## FL-011: 푸시 패키지
- 날짜: 2026-11-19
- 상태: 검토중(iOS는 5단계에서 확정)
- 맥락: 서버는 Android FCM HTTP v1, iOS APNs 직접 발송(D-037). RN은 `expo-notifications`의 `getDevicePushTokenAsync`로 두 OS의 네이티브 토큰을 받는다(Firebase iOS 설정 없음).
- 결정: Android는 `firebase_messaging` 17.1.0 + `firebase_core` 5.2.0. iOS는 Firebase iOS 앱 등록 없이 APNs 기기 토큰을 받는 방법(작은 플랫폼 채널 vs `firebase_messaging.getAPNSToken()` + GoogleService-Info.plist)을 Apple 가입 뒤 5단계에서 정한다.
- 근거: RN과 같이 iOS에 Firebase 설정을 두지 않는 쪽이 서버·Firebase 설정을 바꾸지 않는다(FL-002).

## FL-012: 변형(flavor) 구성 방법
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-043(dev·prod 변형)을 Flutter `--flavor`로 옮긴다. iOS는 Xcode 구성·scheme을 직접 만들어야 한다.
- 선택지: (a) Android Gradle `productFlavors` + iOS는 `xcodeproj` gem 스크립트 (b) `flutter_flavorizr` (c) 진입점 파일만 나누고 앱 ID는 하나
- 결정: (a). iOS는 `tool/ios_flavors.rb`가 `Debug|Release|Profile`을 `-dev`·`-prod`로 복제해 bundle ID·`APP_DISPLAY_NAME`을 넣고 scheme `dev`·`prod`를 만든다(CocoaPods에 들어 있는 xcodeproj gem 사용, 한 번만 실행). Android 앱 이름은 `manifestPlaceholders`(AGP 9가 `resValue`를 기본으로 막음). dev만 평문 HTTP 허용(`android/app/src/dev/AndroidManifest.xml`). 앱 코드는 진입점 하나(`lib/main.dart`)에서 `appFlavor`로 변형을 읽고, prod 서버 주소는 코드 상수, dev 주소·토큰만 `env/dev.json`.
- 근거: flavorizr는 템플릿 파일을 덮어쓰고 설정 범위가 넓다. 필요한 변경이 작아 직접 스크립트가 투명하다. (c)는 FL-002의 dev `.dev` ID를 만들 수 없다.
- 영향: `flutter run`에 `--flavor`가 꼭 필요하다(기본 `Runner` scheme 없음). iOS 서명·release 설정은 6단계.

## FL-013: material_ui 패키지
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: Flutter 3.50의 `flutter create`가 Material 위젯을 프레임워크 밖 `material_ui` 패키지(1.11.x)로 import한다. `flutter_localizations`의 `GlobalMaterialLocalizations`와 이름이 겹친다.
- 결정: 앱 코드는 `package:material_ui/material_ui.dart`를 쓴다. 문구 delegate는 `AppLocalizations.delegate` + `material_ui`의 `GlobalMaterialLocalizations.delegates`(`lib/app/app.dart`의 `appLocalizationsDelegates`). `flutter_localizations`는 gen-l10n 생성 코드가 import해서 의존성으로만 둔다.
- 근거: `flutter_localizations`의 delegate를 쓰면 `material_ui` 위젯이 ko 문구를 찾지 못한다(위젯 테스트로 확인).
- 영향: `package:flutter/material.dart`에 기대는 외부 패키지(차트·날짜 피커 등)는 `MaterialUiCompatibilityBridge`가 필요할 수 있다. 4단계 차트 스파이크에서 확인.

## FL-014: 원격 저장소와 CI
- 날짜: 2026-11-19
- 상태: 확정 (사용자 선택)
- 결정: GitHub `seyoun10/futureETP_FL`(public, RN 저장소와 같음). `.github/workflows/check.yml`이 push(main)·PR마다 Ubuntu에서 Flutter 3.50.0으로 `./tool/check.sh`를 돌린다. 앱 빌드(Android·iOS)는 CI에서 하지 않는다.
- 근거: 개인 앱이고 설치는 로컬 빌드(D-039 대응)라 빌드 산출물이 필요 없다. 검사만 돌리면 Linux 러너 하나로 충분하다.
- 영향: 로컬 Flutter를 올리면 워크플로의 `flutter-version`도 함께 올린다. 커밋된 파일에 비밀값을 두지 않는다(env/dev.json·google-services.json·서명 파일은 .gitignore).

## FL-015: installation ID와 보안 저장소 옵션
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-120의 installation ID(첫 실행 UUID)와 D-044 접근 키를 `flutter_secure_storage`에 둔다. RN은 `expo-secure-store` 동기 읽기 + `Math.random` UUID였고, Android 자동 백업에서 SecureStore 값을 뺐다.
- 결정:
  - 저장소 인스턴스는 `lib/core/storage/secure_storage.dart`의 `secureStorageProvider` 하나. iOS `KeychainAccessibility.first_unlock_this_device`(백업으로 다른 기기에 옮겨지지 않음), Android는 기본 cipher.
  - Android `allowBackup="false"`. 복원된 암호문은 읽을 수 없고, 같은 installation ID가 두 기기에 생기지 않게 한다.
  - `DeviceIdStore`(`lib/core/api/device_id.dart`)가 처음 부를 때 읽고, 없거나 UUID v4가 아니면 `Random.secure()`로 만들어 저장한다. 읽기·쓰기 실패는 이번 실행만 만든 값을 쓴다(RN과 같음). Flutter 저장소는 비동기라 값은 `Future`로 메모리에 둔다.
- 근거: 별도 uuid 패키지 없이 `dart:math`로 충분하다. 백업 제외 대상이 보안 저장소뿐인데 표시 설정(shared_preferences)도 복원할 가치가 작아 백업 전체를 끄는 편이 단순하다.
- 영향: 앱을 지웠다 다시 깔면 Android는 새 기기, iOS는 Keychain이 남아 같은 기기일 수 있다(RN과 같음).

## FL-016: API client를 dio로 옮긴 방법
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-042·D-072의 RN `apiRequest`(fetch + zod + TanStack Query `retry`)를 dio + Riverpod로 옮긴다.
- 결정:
  - `ApiClient.request<T>(path, decode, {method, query, body, auth, token, cancelToken})` 하나가 모든 호출의 경로다(`lib/core/api/api_client.dart`). `decode`가 던지는 예외는 무엇이든 `SCHEMA_MISMATCH`.
  - dio는 `validateStatus: (_) => true`·`ResponseType.plain`으로 받아 봉투를 직접 판정한다. 봉투가 아니거나 모르는 에러 코드면 5xx `INTERNAL`, 그 밖은 `SCHEMA_MISMATCH`(D-072 그대로).
  - 타임아웃은 dio의 connect·receive 타임아웃(바이트 사이 간격)이 아니라 `Timer` 15초 + 내부 `CancelToken`으로 전체 시간을 잰다. 호출자 `CancelToken`을 내부 토큰에 잇고, 호출자 취소는 `DioException`(cancel) 그대로 던진다.
  - 재시도는 루트 `ProviderScope(retry: appRetry)`(Riverpod 3 자동 재시도). `AppError`의 `NETWORK`·`TIMEOUT`·`INTERNAL`만 최대 2회, 간격 1초·2초(TanStack 기본값과 같음). 변경 요청은 Provider 밖에서 부르므로 재시도되지 않는다.
  - 접근 키는 `AccessTokenReader`로 주입한다. 지금은 dev `DEV_API_TOKEN`만, B-b 항목에서 보안 저장소 키로 바꾼다. 키가 없으면 요청하지 않고 `UNAUTHORIZED`.
- 근거: Riverpod 기본 재시도(10회, 모든 Exception)를 그대로 두면 4xx도 재시도한다. 봉투 판정을 dio 인터셉터에 두면 dio 예외 형식에 묶여 테스트가 복잡해진다.
- 영향: 화면이 쓰는 Provider는 `ref.onDispose`로 `CancelToken`을 취소한다(화면을 떠나면 요청 취소).

## FL-017: 응답 모델 세부와 계약 테스트 배치
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: FL-007로 freezed 손 작성 + JSON Schema 계약 테스트를 정했다. CI는 이 저장소만 checkout해 `../futureETP`의 스키마를 읽을 수 없다.
- 결정:
  - 모델은 `lib/core/api/models/`. 응답 9개(health는 손 작성 그대로)와 요청 본문 2개(`SettingsPatch`·`DeviceRegistration`, 손 작성 `toJson`).
  - 시각(`asOf` 등)은 `DateTime`, CME 거래일·월물(`YYYY-MM-DD`·`YYYY-MM`)은 `String`(달력 시각이 아님). 가격 등 number는 `double`, integer는 `int`.
  - enum은 Dart enum + `@JsonEnum`(이름을 SCREAMING_SNAKE로, 이평선은 `days` 값). 모르는 값은 디코딩 실패 → `SCHEMA_MISMATCH`. 서버가 새 필드를 더하는 것은 허용(무시).
  - PATCH에서 "보내지 않음"과 "null로 지움"을 나누려고 지울 수 있는 필드는 `PatchValue<T?>`로 감싼다.
  - 스키마는 `tool/sync_contract.sh`로 `test/contract/schemas/`에 복사해 커밋한다. 원본이 옆에 있으면 복사본이 같은지 테스트가 보고(다르면 실패), CI는 그 검사만 건너뛴다.
  - fixture(`test/contract/fixtures/`)는 로컬 dev 서버 실제 응답의 `data`. 차트 두 개는 저장소 크기 때문에 마지막 60거래일만 남긴다. 테스트는 스키마 통과 + 모델 디코딩 + `toJson` 왕복이 원래 JSON과 같은지 본다.
  - 생성 파일(`*.g.dart`·`*.freezed.dart`)은 커밋한다(CI가 build_runner를 돌리지 않음, l10n과 같음).
- 근거: 왕복 비교가 모델의 필드 누락·타입 변환 오류를 잡는다. 복사본 비교로 원본 변경을 놓치지 않는다.
- 영향: 원본 계약이 바뀌면 `./tool/sync_contract.sh` → 모델 수정 → `dart run build_runner build` → fixture 다시 저장.

## FL-018: 접근 키 B-b를 Riverpod·go_router로 옮긴 방법
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-044·D-077~D-079(RN: 동기 SecureStore 읽기 + zustand store, 루트 레이아웃이 스택 대신 B-b, TanStack 캐시 `onError`로 거절 표시, `expo-camera`)를 Flutter로 옮긴다. `flutter_secure_storage`는 비동기만 있다.
- 결정:
  - 저장된 키는 `main`에서 `runApp` 전에 한 번 읽어 `storedAccessKeyProvider`로 넣는다. 첫 프레임부터 키 유무가 정해져 로딩 분기가 없다. 상태는 `accessKeyProvider`(`AccessKeyNotifier`: `key`·`rejected`)이고 `lib/core/api/access_key.dart`에 둔다.
  - `apiClientProvider`가 키를 watch한다. 새 키를 저장하면 client가 바뀌어 이것을 쓰는 조회가 모두 새 키로 다시 불린다(RN의 모든 query 무효화).
  - 거절 표시는 `ProviderObserver`(`AuthErrorObserver`)가 모든 Provider 실패에서 `UNAUTHORIZED`를 받아 한다. 실패 알림 중에는 다른 Provider를 바꿀 수 없어 microtask로 미룬다. B-b의 새 키 확인은 Provider 밖(화면 상태)에서 불러 거절 표시에 들어가지 않는다(RN `checksNewKey`).
  - 라우터는 `lib/app/router.dart`의 go_router. 키가 없으면 `redirect`로 B-b(스택의 처음이라 [←] 없음), `rejected`가 되면 라우터 Provider가 지금 화면 위에 B-b를 `push`한다. 저장하면 pop할 수 있으면 pop, 아니면 `/`로 간다. B-b를 떠나면(dispose) 거절 표시를 지운다.
  - QR은 `mobile_scanner` 7.5.0의 화면 안 미리보기(`formats: [qrCode]`, Android MLKit 기본 bundled). 권한은 스캐너가 시작할 때 요청하고, 권한 거부·카메라 없음(`errorBuilder`)이면 닫고 붙여넣기 안내를 보인다. iOS `NSCameraUsageDescription`은 영어 기본 문구만(한국어 InfoPlist.strings는 i18n 항목).
  - 에러 문구 `errorText(l10n, error)`는 `lib/core/api/error_text.dart`.
- 근거: go_router `redirect`만으로 거절 이동까지 하면 스택이 바뀌어 [←]로 돌아갈 곳이 없다. 첫 실행 게이트는 redirect, 거절은 push로 나눠 RN 동작과 같게 했다.
- 영향: 기기 확인(Android 에뮬레이터): 첫 화면 B-b·[←] 없음, 권한 거부 안내, 형식 오류, 서버 거절, 맞는 키 저장 → A, 재실행 때 바로 A. QR을 실제로 읽는 경우는 기기에서 아직 확인하지 않았다. mobile_scanner 때문에 Android SDK Platform 35가 빌드 때 자동 설치됐다.

## FL-019: 표시 설정(언어·등락 색) 저장과 앱 언어
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-073(RN: 동기 `expo-sqlite/kv-store` + zustand persist, 키 `display-settings`)을 옮긴다. FL-008은 `SharedPreferencesAsync`를 골랐지만 비동기만 있어 첫 프레임에 저장 값을 쓸 수 없다.
- 결정:
  - `SharedPreferencesWithCache`(allowList `display-settings`)를 `main`에서 `runApp` 전에 열어 `displaySettingsStoreProvider`로 넣는다. 캐시 읽기가 동기라 첫 프레임부터 저장된 언어·색이다.
  - 값은 JSON `{language: ko|en, upDownStyle: kr|us}`. 없거나 깨졌거나 모르는 필드는 그 필드만 기기 기본값(언어 `ko`면 한국어 아니면 영어, 지역 `KR`이면 한국식 아니면 미국식, D-073).
  - `displaySettingsProvider`(`lib/core/settings/display_settings.dart`)가 상태이고, 바꾸면 화면을 먼저 바꾸고 저장은 뒤에서 한다(실패는 로그만).
  - `MaterialApp.locale`이 표시 설정 언어를 따른다. 언어를 고르는 UI는 B 화면에서 넣는다.
  - 서버 기기 설정은 `deviceSettingsProvider`(`lib/core/settings/device_settings.dart`, `AsyncNotifier`: 조회 + `patch`). D-137 `DeviceSettingsSync`는 `deviceSettingsSyncProvider`로, 키가 있을 때 앱 루트가 watch한다. 설정을 받을 때마다와 앱 언어가 바뀔 때 비교하고 같은 값은 프로세스당 한 번만 보낸다. PATCH의 `UNAUTHORIZED`는 Provider 실패가 아니라 직접 `reportError`로 알린다. 시간대는 FL-023에서 같은 PATCH에 더했다.
- 근거: RN이 동기 저장소를 고른 이유(언어·색 깜빡임, D-030)를 그대로 지킨다. 저장 값이 작아 캐시 비용이 없다.
  - iOS 권한 문구는 `ios/Runner/{ko,en}.lproj/InfoPlist.strings`(기기 언어를 따름, 앱 안 언어와 따로, D-078 보충). Info.plist의 영어 문구는 strings가 없는 언어의 기본이다.
- 영향: 테스트는 `test/helpers/display_store.dart`(메모리 플랫폼 저장소, dev 의존성 `shared_preferences_platform_interface`).

## FL-020: 테마 토큰과 등락 색 팔레트
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-031·D-073(RN `src/theme/tokens.ts`·`upDownColor.ts`)을 옮긴다. Material 위젯은 `ColorScheme`에서 색을 읽는다.
- 결정:
  - 토큰은 `lib/core/theme/tokens.dart`의 `AppColors`·`ChartColors`·`AppSpacing`·`AppFontSize`·`AppRadius`·`AppSize`(값은 RN과 같음). 화면·차트는 숫자·색을 직접 쓰지 않는다.
  - `buildAppTheme()`(`app_theme.dart`)가 토큰을 다크 `ColorScheme`에 넣는다. RN처럼 버튼은 `surfaceSelected` 바탕(primary·secondaryContainer), 배경은 검정(surface), 카드·입력 칸은 `surface`(surfaceContainer*). 입력 칸은 테두리 없이 채움, 버튼 최소 높이 44.
  - 등락 색은 `UpDownPalette.kr`·`.us` const 객체와 `changeColor`·`changePairColor`(반올림해 보이는 값으로 판단, RN 테스트와 같은 경우), 화면은 `upDownPaletteProvider`로 읽는다. 스타일이 같으면 같은 객체다.
- 근거: Material 기본 색(보라 계열 seed)이 섞이지 않게 scheme 전체를 토큰으로 채운다.
- 영향: B-b 화면을 iOS 시뮬레이터에서 확인했다(검정 배경·보라 버튼·회색 입력 칸). `changePctDecimals`는 FL-021에서 `format_number.dart`로 옮겼다.

## FL-021: 숫자·날짜·금액 포맷
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: 시세 숫자·월물·기준 시각·큰 금액은 언어와 상관없이 RN `src/lib/formatNumber.ts`·`formatDateTime.ts`·`formatAmount.ts`와 같은 문자열이어야 한다.
- 결정:
  - `lib/core/util/format_number.dart`(`formatPrice`·`formatChange`·`formatChangePct`·`changePctDecimals`·`formatContractMonth(Short)`), `format_date_time.dart`(`formatLocalDateTime`·`formatTradeDate`), `format_amount.dart`(`compactAmount`, `AmountScheme.eok`·`.si`).
  - intl `NumberFormat`·`DateFormat`은 쓰지 않는다. locale에 따라 결과가 바뀌어 RN과 어긋날 수 있다. 반올림은 `toStringAsFixed`로 JS `toFixed`와 같다(둘 다 double의 정확한 십진 값 기준).
  - 시각은 모델의 `DateTime`을 받아 기기 현지 시각(`toLocal`)으로 쓴다. Dart에는 IANA 시간대 변환이 없어 테스트는 `utcOffset`으로 RN 테스트의 시간대 경우를 재현한다.
  - 테스트는 RN 테스트 경우를 그대로 옮겼다(`test/core/util/format_test.dart`).
- 근거: 직접 만든 RN 규칙을 그대로 옮기는 편이 결과를 맞추기 쉽다.

## FL-022: 공용 조회 UI와 자동 새로고침
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: RN은 TanStack Query(`QueryStateView`·`useAutoRefresh`·`focusManager`·`chartCacheOptions.staleTime`)로 상태 분기·`nextUpdateAt` + 1분 자동 새로고침·앱 복귀 재조회를 한다(D-030, D-048, D-075). Riverpod에는 화면 포커스·앱 복귀 재조회가 없다.
- 결정:
  - 화면: `lib/core/widgets`의 `FooterLine`·`FreshnessLine`(`.asOfOnly`는 ETP 수집 시각)·`FreshnessFooter`, `QueryStateView`(`AsyncValue`를 받는다)·`LoadingView`·`CenterSpinner`·`ErrorView`. 값이 있으면 새로고침 실패여도 값을, 재시도 중(로딩)이면 스켈레톤을 보인다.
  - 조회: freshness가 있는 조회는 `lib/core/query/auto_refresh.dart`의 `AutoRefreshNotifier`(AsyncNotifier)를 상속해 `fetch`·`nextUpdateAtOf`만 쓴다. 조회가 끝날 때마다(성공·실패, 실패면 이전 값) `max(nextUpdateAt + 1분, 조회 + 1분)`에 `invalidateSelf`한다. 앱이 뒤에 있으면 타이머에서 부르지 않는다.
  - 앱 복귀: `appLifecycleProvider`(`AppLifecycleListener`)가 resumed가 되면 조회를 다시 한다. C 차트는 `staleUntilNextUpdate`로 `nextUpdateAt`까지 다시 받지 않는다(RN staleTime).
  - "화면이 보이는 동안"(RN `useFocusEffect`)은 Riverpod의 구독 멈춤으로 맞춘다. 가려진 화면의 Provider가 멈춰 있으면 다시 조회가 보이게 될 때로 미뤄진다.
  - 시각은 `clock` 패키지로 읽어 테스트의 가짜 시간(`tester.pump`)과 맞춘다.
- 근거: 조회마다 타이머·생명주기 처리를 되풀이하지 않고 한 곳에 둔다. Notifier가 자동 새로고침을 맡는다는 레이어 규칙(architecture.md)과도 맞다.
- 영향: 빈 상태는 RN에도 공용 컴포넌트가 없어 화면별로 둔다(A 목록·C-d ETP). 캐시 유지 시간(C 차트 gcTime 1시간)은 C-a 때 정한다.

## FL-023: 시간대 PATCH
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-084(RN `DeviceSettingsSync`)는 설정을 받을 때마다 기기 IANA 시간대를 서버 `timezone`과 비교해 다르면 PATCH하고, 같은 값은 프로세스당 한 번만 보낸다. Dart `DateTime.timeZoneName`은 `KST` 같은 약어라 IANA 이름이 아니다.
- 결정:
  - `flutter_timezone` 5.1.1(`getLocalTimezone().identifier`)로 읽는다. `deviceTimeZoneProvider`(읽기 함수, 테스트에서 덮어쓴다)가 읽지 못하거나 IANA 모양(`Area/Location`, `UTC`)이 아니면 null이고 보내지 않는다. RN은 `Intl.DateTimeFormat`으로 실제 시간대인지까지 보지만 Dart에는 시간대 DB가 없어 모양만 본다(OS가 준 값이라 충분).
  - FL-019의 `deviceSettingsSyncProvider`에 더한다. 언어·시간대가 둘 다 다르면 PATCH 한 번에 보낸다(RN과 같음). 시간대는 비교할 때마다 새로 읽어 앱을 켠 채 이동해도 맞춘다.
  - `deviceSettingsProvider`는 앱이 앞으로 돌아오면 다시 받는다(RN 설정 query의 앱 복귀 재조회, D-030). 그래서 복귀 때 시간대도 다시 비교한다.
- 근거: 플러그인은 iOS·Android 기본 API(`TimeZone.current.identifier`·`ZoneId.systemDefault`)를 읽기만 하고 pub.dev 내려받기가 많다.
- 영향: iOS 시뮬레이터 빌드 확인. Android 에뮬레이터(API 37, 2026-11-19): 기기 시간대를 America/Chicago로 바꿔 실행하면 dev 서버 기기 설정이 America/Chicago, 되돌려 실행하면 Asia/Seoul로 바뀌는 것을 확인했다.

## FL-024: 화면 방향
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: D-076(RN `src/lib/orientation.ts`): 앱은 세로로 잠그고 C-a~C-c [⟲]만 가로로 잠근다. 레이아웃은 잠금이 아니라 창 모양을 따른다. iPad 잠금은 `requireFullScreen`이 조건이다.
- 결정:
  - `lib/core/util/orientation.dart`: `lockPortrait`(위쪽 세로)·`lockLandscape`(양쪽 가로)는 `SystemChrome.setPreferredOrientations`로 잠그고 실패는 무시한다. `isLandscape(context)`는 창 너비 > 높이.
  - `main`이 `runApp` 전에 `lockPortrait`한다. Info.plist 허용 방향은 가로를 남겨 둔다(빼면 가로 잠금이 거부된다). Android 매니페스트는 바꾸지 않는다.
  - iOS Info.plist `UIRequiresFullScreen` true(RN `requireFullScreen`).
  - [⟲] 버튼과 ETP 탭·C 밖에서의 세로 복귀는 C 화면을 만들 때 넣는다.
- 근거: RN과 같은 방식이다. iOS 27은 크기 조절 가능한 앱에서 잠금을 선호값으로만 다뤄, 레이아웃을 창 모양으로 정해야 잠금이 거부돼도 화면이 깨지지 않는다.
- 영향: iOS 시뮬레이터(iPhone Duo)에서 기기를 돌려도 세로로 남는 것을 확인했다. Android 에뮬레이터(API 37)에서도 회전을 가로로 강제해도 `requestedOrientation=PORTRAIT`로 세로에 남는 것을 확인했다(2026-11-19).


## FL-025: C-a 차트 스파이크 결과: `CustomPainter` 직접 구현
- 날짜: 2026-11-19
- 상태: 확정 (실기기 성능·햅틱 촉감·iOS 성능은 기기 설치 때 재확인)
- 맥락: TODO 4단계 첫 항목(D-056·D-087·D-104·D-106 대응). 후보는 `CustomPainter` 직접 구현과 `fl_chart` 1.3.1(2026-11-09). 스파이크 화면은 `lib/features/chart_spike/`(dev 경로 `/dev/chart-spike`, A 자리 임시 화면의 버튼). 데이터는 시드를 고정한 합성 일봉 4,000개이고, 이평선(200일)과 rare-level 밴드 10개를 함께 그린다.
- 선택지: `fl_chart` 시제품은 만들지 않았다. log y축이 없고, RN도 라이브러리 위에서 y 맞춤·축·범위 제한·십자선·선 샘플링·핀치를 모두 직접 만들었다(D-056 보충, D-087, D-106). 라이브러리를 써도 차트 대부분을 손으로 짜야 한다.
- 결정: `lib/core/charts/`에 직접 만든다.
  - `ChartViewport`: 보이는 x 범위를 행렬이 아니라 봉 순번 `start`·`span`(소수)으로 둔다. 축소는 전체까지, 확대는 20봉까지, 이동은 데이터 처음~끝으로 제한한다. 핀치는 손가락 가운데 날짜를 고정하고 손가락을 함께 움직이면 이동한다. 이전 3년을 앞에 붙이면 `start`에 붙인 봉 수만 더한다(D-104, RN `shiftedView` 대응).
  - `LogPriceRange.fit`: 보이는 봉의 위·아래 끝(그날 선 포함, `CandleSeries.envelopeHigh/Low`)으로 log y를 맞춘다. 위·아래 여백은 6%다(RN `fitTransform`).
  - `CandlePainter`: 보이는 봉만 순회한다. 꼬리는 헤어라인으로, 몸통은 굵은 선분으로 그리고 오르는 봉·내리는 봉을 `drawRawPoints` 두 번씩에 모은다. 봉 폭이 2px보다 좁으면 몸통을 뺀다. 선은 `lineSample`(D-106)로 보이는 구간만, 화면 1px에 점 하나 이하로 그린다. 데이터는 열 배열(`Float64List`)이다.
  - `CandleChart`: `RawGestureDetector`에 scale·long press(300ms)·tap 인식기를 둔다. 한 손가락 끌기는 판정 거리를 넘은 뒤에도 누른 자리부터 따라온다. 십자선은 봉에 붙을 때마다 `HapticFeedback.selectionClick`을 주고, 떠 있는 동안 끌면 십자선이 따라오고 누르면 사라진다. `locked`면 인식기를 모두 빼서 진행 중인 제스처도 끊는다(D-108, D-139). 보이는 범위·십자선은 `ValueNotifier`이고, 바뀌면 위젯을 다시 만들지 않고 다시 그리기만 한다. 십자선은 봉과 다른 `RepaintBoundary` 층에 그린다.
- 측정(2026-11-19, Android 에뮬레이터 `Medium_Phone_API_37.0` `-gpu host`(GLES Apple M1 Pro), Impeller OpenGLES, profile 빌드, 60Hz. 값은 엔진 `FrameTiming` 1초 집계, 최악은 build+raster)

  | 조건 | fps | 최악 프레임 |
  |---|---|---|
  | 6M·12M 끌기(756봉) | 48~52 | 8~15ms(한 번 28ms) |
  | 12M 끌기(4,000봉) | 49~54 | 7~9ms |
  | 자동 확대·축소 42봉↔전체(756봉) | 56~63 | 6~21ms |
  | 자동 확대·축소 42봉↔전체(4,000봉) | 57~64 | 20~23ms |

  - 끌기 fps가 50 안팎인 것은 adb `input swipe` 사이 빈틈 때문이다. 이 동안은 그릴 프레임이 없다. 프레임 시간은 16.7ms 안이다.
  - 4,000봉이 모두 보이는 축소에서는 20ms 프레임이 섞이지만 초당 프레임 수는 60을 유지했다. 실기기에서 끊기면 축소 화면의 봉을 묶어 그리는 방법을 검토한다(D-106 위험 항목과 같다).
  - iOS 시뮬레이터는 profile·release 빌드를 돌릴 수 없어 재지 않았다. 실기기를 설치할 때 iPhone에서 다시 잰다.
  - 십자선(길게 누르기 → 끌기 → 종가 라벨)과 이전 3년 이어 받기(756 → 4,000봉, 범위 유지, 받는 동안 차단·햅틱)는 에뮬레이터 화면과 위젯 테스트로 확인했다.
- 근거: 검증 항목(봉 수, 이평선·밴드, 핀치·드래그·십자선, 이어 받기 범위 유지, 60fps)을 모두 직접 구현으로 통과했다. 라이브러리에 맞춰 우회할 일이 없고, RN에서 직접 만든 부분을 거의 그대로 옮길 수 있다.
- 영향: `docs/tech-stack.md` 차트 행. 스파이크 화면(`features/chart_spike`, `/dev/chart-spike`, ARB `devChartSpike*`)은 C-a 본 구현 뒤 지웠다(FL-027). 합성 봉은 `test/helpers/synthetic_bars.dart`로 옮겨 차트 제스처 테스트가 쓴다. `lib/core/charts/`는 C-a·C-c 본 구현이 이어 쓰고, 축·라벨·롤 음영·꼬리표·상세 박스·한글 글자는 그때 더한다.

## FL-026: A 원자재 목록과 공용 title-bar
- 날짜: 2026-11-19
- 상태: 확정
- 맥락: TODO 4단계 A(screens.md A, D-085, D-109, D-124, D-138). RN `CommodityListScreen`·`ScreenHeader`·`HeaderIconButton`·`SettingsHeaderButton`·`AlertBell`·`haptics`·`showFailedAlert`에 대응한다.
- 결정:
  - 조회: `ApiClient.getCommodities` → `CommodityListNotifier`(`AutoRefreshNotifier`, FL-022). 원자재·월물 줄은 서버 순서대로 그리고, 원자재 이름은 ARB `commodityName`(ICU select)으로 쓴다.
  - 당겨서 새로고침: `RefreshIndicator.adaptive`의 `onRefresh`가 `ref.refresh(provider.future)`와 5초 타이머 중 먼저 끝나는 쪽에서 끝난다. 그동안 `AbsorbPointer`로 헤더까지 터치를 막는다. 시간 초과·실패면 `showFailedAlert`를 띄운다. 늦은 응답은 Provider가 받아 목록을 바꾸고, 회차 번호로 지난 회차가 화면 상태를 다시 바꾸지 않게 한다(RN `usePullRefresh`).
  - 공통 실패 Alert(`core/util/failed_alert.dart`)는 `showAdaptiveDialog` + `AlertDialog.adaptive`라 iOS에서는 Cupertino 모양이다. iOS 버튼에 `CupertinoDialogAction`을 쓰려고 `cupertino_ui`를 직접 의존성으로 둔다. 떠 있는 동안 다시 부르면 겹쳐 띄우지 않는다.
  - title-bar는 `ScreenHeader`(아래 1px 흰 구분선, 제목 왼쪽 정렬)다. 아이콘은 Material Community Icons 대신 Flutter Material Icons로 비슷한 모양을 쓴다(패키지 추가 없음). 회전 아이콘(`phone-rotate-*`)은 C 화면에서 정한다.
  - [⚙]은 B 화면이 생길 때까지 `/settings`에 2단계 임시 화면(서버 연결 확인·차트 스파이크 진입)을 띄운다. 그래서 `dev_health`는 B 화면 때 지운다.
  - 행 누르기(햅틱·C-a 이동·미리 조회)는 C 화면과 함께 넣는다.
- 근거: RN 동작과 같은 결과를 Flutter 기본 위젯으로 낸다. 접근 키 화면(B-b)은 아직 `AppBar`라 B 화면을 만들 때 `ScreenHeader`로 맞춘다.
- 영향: B-b 위젯 테스트의 첫 화면 기대값을 A로 바꿨다. `test/helpers/fake_http.dart`에 응답 지연(`delay`)이 생겼다. Android 에뮬레이터(API 37)에서 dev 서버 데이터로 목록·기준 시각 줄·당겨서 새로고침 인디케이터를 확인했다(2026-11-19).

## FL-027: C 원자재 화면과 C-a 이격도차트
- 날짜: 2026-11-19
- 상태: 확정 (핀치·드래그 손동작·햅틱 촉감·실기기 성능은 기기 설치 때 확인)
- 맥락: TODO 4단계 C-a(screens.md C·C-a, D-047, D-076, D-086, D-087, D-102~D-108, D-117, D-121, D-139). FL-025 스파이크의 `lib/core/charts`를 이어 쓴다.
- 결정:
  - 경로: `/commodity/:code`를 A(`/`) 아래 하위 경로로 두고 `StatefulShellRoute.indexedStack` branch 4개(탭)로 나눈다. 그래서 스택은 늘 A → C이고 [←]·Android 뒤로가 A로 간다. 탭은 위치(`/commodity/GC/contracts`)로 바꾸고 `goBranch`는 쓰지 않는다. go_router가 경로 값이 있는 branch에 기본 위치를 요구해 `initialLocation`을 GC로 채워 둔다(쓰이지 않음).
  - C 껍데기(`CommodityShell`): title-bar(`원자재명 (심볼)` 🔔 [⟲] [⚙]), 탭 줄, 지금 탭의 기준 시각 줄. 가로면 title-bar를 낮추고 탭 줄·기준 시각 줄을 숨기며 좌우 safe area만큼 안쪽에 둔다. ETP 탭으로 가거나 C를 떠나면 `lockPortrait`. 차트가 이전 3년을 받는 동안 `chartBusyProvider`로 화면 전체를 `AbsorbPointer`로 막는다. [⟲] 아이콘은 Material `stay_current_landscape`·`stay_current_portrait`다.
  - C-a 조회(`DisparityChartNotifier`, family by 원자재): 기기 설정의 기준값·이평선·윈도·rare 레벨(`selectAsync`라 그 값이 바뀔 때만 다시 받음)로 최근 3년을 받는다. `loadOlder`가 가장 이른 봉 전 3년을 앞에 붙인다. 자동 새로고침·복귀 재조회는 최근 3년만 다시 받고 조건이 같으면 받아 둔 과거 봉을 이어 붙인다(RN infinite query가 모든 페이지를 다시 받는 것과 달리 요청 1번). `nextUpdateAt`까지 복귀 재조회를 하지 않고, 화면을 떠나도 1시간 둔다. A 행을 누르면 라우터가 이 조회를 먼저 시작한다.
  - 기간 선택은 C-a 탭 State에 둔다. indexedStack이 C에 있는 동안 탭을 살려 두므로 D-107(C를 떠나면 잊음)과 같다.
  - 차트 둘레(`chart_decor.dart`·`chart_layout.dart`): y 눈금은 d3 log 스케일 `ticks(6)`과 같은 계산, 특수 라벨은 겹치면 밀고, 기본 눈금 글자는 특수 라벨과 겹치면 숨긴다. x축은 겹치지 않는 가장 촘촘한 월 간격. 고가·저가 꼬리표, 롤 음영, 대표월물 전환일 점선, 마지막·보이는 마지막 봉 종가 점선. 모두 봉과 같은 `CustomPainter`에서 그리고 글자는 `TextPainter`를 캐시한다. 한글은 Flutter가 시스템 글꼴로 대체해 따로 번들하지 않는다(D-087의 Paragraph 대응).
  - 십자선 라벨은 y축 칸 전체 너비 상자와 x축 날짜 상자로 그린다. RN은 십자선 라벨과 겹치는 축 글자를 숨기는데, 여기서는 불투명 상자가 그 글자를 덮는다.
  - 상세 박스(`ChartDetailOverlay`)는 `CustomSingleChildLayout`으로 상자 크기를 레이아웃에서 받아 RN `leastCoveredCorner` 규칙으로 귀퉁이를 고른다.
  - 위 정보 줄 두 개는 차트 위에 반투명(`overlay`)으로 겹치고, 봉·선은 그 높이(글자 크기 배율 반영)만큼 비켜 그린다. 격자는 줄 뒤까지 이어진다(D-117).
  - 이전 3년 받기: 가장 과거 봉이 보이거나 그 자리에서 제스처가 끝나면 받는다. 가벼운 햅틱, 차트 왼쪽 가운데 로딩 표시, 차트 `locked`, C 화면 차단, 5초 시간 초과·실패 Alert. 회차 번호로 늦은 응답이 상태를 다시 바꾸지 않게 하고 데이터는 그대로 붙인다.
  - 첫 기간 맞춤: 보이는 범위를 첫 프레임 전에 기간으로 정해 RN처럼 차트를 감출 동안이 없다. 첫 조회 중에는 `ChartSkeleton`(격자·칩 자리 + 가운데 스피너)이다.
- 근거: RN과 같은 화면 결과를 Flutter 구조에 맞게 낸다. 행렬 대신 봉 순번 범위(FL-025)라 이어 붙이기·상세 배치·축 계산이 단순하다.
- 영향: Android 에뮬레이터(API 37) dev 서버 데이터로 C-a 진입, 기간 칩, 십자선 상세, 이전 3년 연속 받기(2018년까지), 가로 모드를 확인했다(2026-11-19). 위젯 테스트로 기간·[↻]·핀치·끌기·이어 받기·시간 초과·실패·스켈레톤을 고정했다. C-b·C-c는 `lib/core/charts`의 축·상세·스켈레톤을 함께 쓴다.

## FL-028: C-c 월물차트와 차트 코어 일반화
- 날짜: 2026-11-20
- 상태: 확정 (실기기 손동작·성능은 C-a와 함께 기기 설치 때 확인)
- 맥락: TODO 4단계 C-c(screens.md C-c, D-092, D-093, D-104, D-107, D-113, D-117, D-118). FL-027의 `lib/core/charts`는 봉차트 전용(log 축 고정)이었다. RN은 선만 그리는 `LinesChart`를 따로 두고 `useChartViewport`를 함께 쓴다.
- 결정:
  - 차트 코어를 따로 두지 않고 일반화한다. `CandleSeries`·`CandleChart`·`CandlePainter`를 `ChartSeries`·`PriceChart`·`PricePainter`로 바꾸고 봉(`Candles`)을 선택으로 둔다. 선만 시리즈의 envelope는 선 값으로만 정하고, 십자선 가로선은 `crosshairPrices`(봉=종가, 선만=그날 값이 있는 첫 선=만기가 가장 가까운 월물)를 따라간다. 값이 없는 날은 가로선이 없다.
  - y 범위는 `PriceRange`(`LogPriceRange`·`LinearPriceRange`)다. 봉차트는 늘 log, 선만은 전체 값에 0 이하가 있으면 선형이다(D-113, RN `axisOptions`). 눈금도 범위가 낸다(log는 d3 log `ticks`, 선형은 d3 `ticks`).
  - `ChartDecor.labelsIn(first, last)`: C-a는 보이는 마지막 봉 값, C-c는 보이는 범위에서 선마다 마지막 값(D-093)을 선 색으로 준다. 현재가 점선과 고가·저가 꼬리표는 봉이 있을 때만 그린다(`extremeText` 선택).
  - C-a·C-c 탭의 기간·[↻]·이전 3년 받기 흐름은 `features/commodity/chart_tab.dart`의 `ChartTabState` mixin으로 옮겨 함께 쓴다. 기간은 각 탭 State라 C-a와 따로 기억한다(D-107). 차트 캐시 1시간은 `core/query/keep_alive.dart`의 `keepAliveFor`.
  - C-c 조회(`ContractChartNotifier`, family by 원자재): 설정과 상관없이 최근 3년, `loadOlder`로 `before` 이전 3년. 병합은 RN `mergeContractPages`와 같게 월물 목록은 최근 응답을 따르고 이전 응답에 없는 월물은 null로 채운다. 새로고침은 최근 3년만 받고 과거 날짜를 이어 붙인다(C-a와 같은 방식).
  - 범례(선 견본 `LegendLine` + 월물명, 대표월물 `●`은 `textSecondary`)는 차트 위 반투명 줄이다. 좁으면 Wrap으로 여러 줄이 되고, 선은 Wrap과 같은 규칙으로 센 줄 수만큼 비켜 그린다(D-117). 우측 y축 자리는 선마다 글자가 가장 긴 값으로 정해 이동해도 바뀌지 않는다.
  - 상세 박스: 날짜(오늘 잠정이면 `(잠정)`), 그날 값이 있는 월물별 가격(선 색, `DetailRow.mark`로 회색 `●`), 양끝 월물 연환산 롤 수익률(`chartPerYear`, C-b도 쓴다).
- 근거: 제스처·축·상세 배치를 두 벌로 두지 않는다. RN이 `LinesChart`를 따로 둔 이유(victory-native `CartesianChart` 입력 차이)는 `CustomPainter` 구조에 없다.
- 영향: Android 에뮬레이터(API 37) dev 서버 데이터로 NG C-c 진입, 범례·끝값 라벨, 십자선 상세(롤 수익률), 이전 3년 연속 받기를 확인했다(2026-11-20). 위젯·단위 테스트로 범례, 끝값 라벨, 상세, 선형 축, 이어 받기, 병합을 고정했다. FL-025·FL-027의 `CandleChart` 등은 이 이름 변경 전 기록이다.

## FL-029: C-b 월물커브
- 날짜: 2026-11-20
- 상태: 확정 (Android 날짜 선택 방식은 아래처럼 바꿈, 실기기 손동작은 C-a·C-c와 함께 기기 설치 때 확인)
- 맥락: TODO 4단계 C-b(screens.md C-b, D-090, D-091, D-113~D-123). RN은 확대·이동이 없는 `CurveChart`를 Skia 캔버스에 직접 그리고, 기준일 선택은 iOS 바텀 시트(spinner)·Android OS 날짜 다이얼로그(spinner)다.
- 결정:
  - 차트(`core/charts/curve_chart.dart`): `CustomPainter` 하나로 격자·y 눈금(1·2·5 간격, `linearTicks`), 기준일 흰 실선·빈 점, 비교일 회색 점선(`curveDash` 3·2)·찬 점, x축 월 라벨(n개마다, 첫 1월 유지), 변화율 라벨, 십자선을 그린다. y는 값이 모두 양수면 log, 아니면 선형. 좌표는 `CurveGeometry`(크기·정보 줄 높이가 같으면 다시 계산하지 않음).
  - 변화율 라벨 배치(`core/charts/curve_layout.dart`)는 RN `placePctLabels`·`segmentHitsBox`·`labelStride`·`nearestSlot`을 그대로 옮기고 RN 테스트 케이스도 옮겼다(D-122, D-123).
  - 십자선: 십자선이 없으면 길게 누르기(300ms) 인식기, 있으면 끌기 인식기를 둔다. 가장 가까운 월물에 붙을 때마다 선택 햅틱, 누르면 지운다. 상세 박스는 점·선분·변화율 라벨을 marks로 `leastCoveredCorner`.
  - 기준일은 탭 State(null = 서버 기본값 D-1). D-1로 오면 기본 조회와 같은 key를 쓴다. 새 기준일을 받는 동안 이전 커브를 보여 준다(RN `keepPreviousData`). 조회는 기준일마다 family(`curveProvider((code, baseDate))`), 1시간 캐시, `nextUpdateAt`까지 복귀 재조회 없음. 기준 시각 줄은 기본 기준일 조회의 freshness(D 기준)를 쓴다.
  - 기준일 선택은 iOS·Android 모두 바텀 시트 안 `CupertinoDatePicker`(년·월·일 휠, 범위 문구, [취소]·[확인])다. Flutter에는 Android OS spinner 날짜 다이얼로그가 없고(Material `showDatePicker`는 달력·입력 모드), 휠 시트가 D-091이 고른 spinner 조작과 같다. 범위 밖 월·일은 휠에 회색으로 보이고 고르면 범위 끝으로 돌아간다(RN iOS 피커와 같다). 서버가 휴장일을 옮기면 `휴장일이라 10/16(금)로 옮겼습니다`를 3초 띄운다.
  - 위 정보 줄(범례 + 롤 수익률) 높이는 `wrappedInfoHeight`로 Wrap과 같은 규칙으로 계산해 선·점을 비켜 그린다(C-c 범례와 공용).
- 근거: RN 화면 결과와 같게, 확대·이동이 없는 커브는 `PriceChart`를 쓰지 않고 단순한 전용 painter로 둔다.
- 영향: Android 에뮬레이터(API 37) dev 서버 데이터로 NG C-b(10/29 기준) 커브·변화율 라벨·십자선 상세·[−]·[↻]·날짜 시트·휴장일 옮김을 확인했다(2026-11-20). dev DB에 11/03 이후 정산가가 없어 D-1 커브는 빈 안내였다. D-091의 Android OS 다이얼로그와 다르다(원본 문서 반영은 사용자 판단).

## FL-030: C-d ETP 목록과 C-d-a ETP 상세
- 날짜: 2026-11-20
- 상태: 확정 (Android 에뮬레이터 dev 서버 확인은 남김)
- 맥락: TODO 4단계 C-d·C-d-a(screens.md C-d·C-d-a, D-017, D-047). RN은 `EtpListScreen`(FlatList + 머리 필터)·`EtpDetailScreen`(탭 밖 스택), 필터·정렬은 `etpListModel`, 조회는 react-query 기본값(자동 새로고침 없음, 앱 복귀 때 오래된 값 재조회, gcTime 5분)이다.
- 결정:
  - 조회: `etpListProvider(code)`·`etpDetailProvider(id)`는 `AutoRefreshNotifier`에 `nextUpdateAt` 없이 둔다(자동 새로고침 없음, 앱 복귀 재조회). 화면을 떠나도 5분 둔다(RN gcTime 기본값).
  - 필터·정렬(`features/commodity/etp/etp_list_model.dart`)은 RN `etpListModel`을 그대로 옮긴다. 필터 `전체`는 null, 정렬은 `EtpSort`(`byDefault`·`aum`·`tradingValue`). 이름순은 RN `localeCompare`처럼 대소문자를 먼저 무시한다. 배수·총보수 숫자는 정수면 소수점 없이(`plainNumber`, JS 숫자 문자열과 같음).
  - 필터·정렬 선택은 탭 State에만 두어 기억하지 않는다(D-017). 필터는 목록 첫 항목이라 함께 스크롤된다(RN `ListHeaderComponent`).
  - 세그먼트 버튼은 B 설정에서도 쓰므로 `core/widgets/segmented_control.dart`(RN `SegmentedControl`)로 둔다. 같은 값을 다시 누르면 아무것도 하지 않고, 바꾸면 선택 햅틱이다.
  - 수집 시각은 C 껍데기 기준 시각 줄에 `FreshnessLine.asOfOnly`로 쓴다(수집 전 null이면 빈 줄).
  - C-d-a는 A 아래 `commodity/:code/etp/:id` 경로로 C 탭 shell 밖에 둔다. C-d에서 `push`하므로 [←]·Android 뒤로가 C-d로 돌아오고, C-d의 필터 상태도 남는다. 운용사 페이지는 `url_launcher`로 외부 브라우저에서 열고, http·https 주소만 버튼을 보인다(RN `isWebUrl`). 화면은 여는 함수를 받아(router가 `launchUrl`을 넘김) 테스트에서 바꾼다.
- 근거: RN 화면 결과와 같게, 원본에 없는 동작은 넣지 않는다.
- 영향: `url_launcher` 의존성 추가(tech-stack). 빈 C 탭 자리 `TabPlaceholder`는 지웠다.

## FL-031: B 설정·B-a 알림 설정·데이터 출처
- 날짜: 2026-11-20
- 상태: 확정 (실기기 키패드·[완료] 줄 확인은 기기 설치 때, 알림 권한 배너는 5단계 푸시와 함께)
- 맥락: TODO 4단계 B·B-a(screens.md B·B-a, D-081~D-083, D-124). RN은 react-query mutation(scope 직렬, `useMutationState`로 끝나지 않은 변경을 얹어 보임)·`keyboardDidHide` 저장·`KeyboardDoneBar`·EAS Update 앱 번들 줄을 쓴다.
- 결정:
  - 저장(`core/settings/device_settings.dart`): `DeviceSettingsNotifier.patch`가 PATCH를 보낸 순서대로 하나씩 보내고(실패해도 다음은 감), 끝날 때까지 `pendingSettingsPatchesProvider`에 둔다. 화면·[⚙] 점은 서버 값 위에 끝나지 않은 변경을 얹은 `settingsViewProvider`를 읽는다. 서버 값에는 확인한 값만 두므로 실패한 변경은 그냥 빠진다. `save`는 실패를 `reportError`(D-079)로 알리고 에러를 돌려주며, 오류 줄은 화면마다 마지막 저장의 결과로 둔다(RN `useUpdateSettings` 훅마다의 `isError`).
  - A 목록은 서버가 확인한 `alertCommodity`가 바뀌면 다시 받는다(`CommodityListNotifier`가 설정을 listen, D-124). core가 feature를 import하지 않으려고 무효화를 목록 쪽에 둔다.
  - rare-level(`features/settings/rare_levels_input.dart`): 다섯 칸이 모두 포커스를 잃거나 키패드가 내려가면(Android 뒤로 버튼처럼 포커스를 둔 채 내려간 경우 포함) 검증·정렬해 저장한다. 키패드는 목록을 끌거나(`keyboardDismissBehavior.onDrag`) iOS [완료] 줄·Android 완료 키로 닫는다. [완료] 줄은 화면 Stack에서 키패드 높이 위에 그린다. 화면은 키패드만큼 줄이지 않아 맨 아래 줄을 키패드가 덮는다.
  - 맨 아래 줄은 OTA가 없어(D-039 EAS Update 적용 안 함) RN 앱 번들 줄 대신 `앱 버전: fl-1.0.0 (빌드 1) · dev`(설치한 빌드·변형)를 보인다. 버전은 `package_info_plus`(`core/config/app_version.dart`)로 읽고 5단계 `PUT /v1/devices`의 `appVersion`에도 쓴다.
  - B-a 대상 원자재의 '없음'은 RN처럼 따로 값(`NONE`)을 두고, 조회 중에는 어느 칸도 고르지 않는다. 거부 시간 시트는 `showModalBottomSheet` 안 4열 48칸이다. 알림 권한 배너는 권한 조회가 푸시 등록과 묶여 5단계에서 붙인다.
  - B-b title-bar를 공용 `ScreenHeader`로 바꾸고, 처음 온 B-b(스택의 처음)는 [←]를 숨긴다(`context.canPop()`). 2단계 임시 화면 `features/dev_health`와 `devHealth*` 문구를 지웠다(FL-026).
  - 묶음 제목 `SectionHeader`와 저장 실패 줄 `SaveErrorLine`은 B·B-a·데이터 출처가 함께 써서 `core/widgets/section_header.dart`에 둔다.
- 근거: RN 화면 결과와 같게, 플랫폼에 없는 수단(EAS Update)만 바꾼다.
- 영향: `package_info_plus` 의존성 추가(tech-stack). 위젯·단위 테스트로 낙관적 표시·직렬 PATCH·실패 되돌림, rare-level 검증·정렬·같은 값 미전송, [초기화], B-a 대상·거부 시간·시트, 데이터 출처를 고정했다. 에뮬레이터·실기기 확인은 하지 않았다.

## FL-032: Android 푸시 등록·앱 사용 중 표시·알림 탭 이동
- 날짜: 2026-11-20
- 상태: 확정 (에뮬레이터·실기기 수신 확인은 기기 확인 때, iOS는 FL-011)
- 맥락: TODO 5단계(D-037, D-045, D-120, screens.md X). RN은 `expo-notifications` 하나로 채널·권한·네이티브 토큰·앱 사용 중 표시(`setNotificationHandler`)·탭 응답을 다룬다. 서버는 notification 메시지에 `android.notification.channelId`(`alerts`·`ops`)를 넣어 FCM 등록 토큰(`token`)으로 보낸다(`apps/server/src/push/fcmSender.ts`).
- 결정:
  - 패키지: `firebase_core` 5.2.0 + `firebase_messaging` 17.1.0(토큰·탭·앱 사용 중 수신), `flutter_local_notifications` 23.0.3(채널 생성·앱 사용 중 표시. FCM은 앱을 보고 있을 때 표시하지 않는다). Firebase 설정은 Gradle `com.google.gms.google-services` 4.6.0이 `android/app/google-services.json`(RN `apps/mobile`과 같은 파일, dev·prod package가 함께 들어 있음, 커밋 안 함)에서 만든다. `flutterfire configure`·`firebase_options.dart`는 쓰지 않는다(API 키를 커밋하지 않음).
  - `flutter_local_notifications` 23 때문에 Android `compileSdk = 37`(Flutter 기본 36)과 core library desugaring(`desugar_jdk_libs` 2.1.5)을 켠다.
  - firebase_messaging 17은 `getToken`·`onTokenRefresh`를 deprecated로 두고 FID 등록(`register`·`onRegistered`)을 권하지만, 서버가 FCM 등록 토큰을 받으므로 등록 토큰 API를 그대로 쓴다(ignore 주석). 서버가 FID 발송으로 바뀌면 함께 바꾼다.
  - 기기 쪽 경계 `PushService`(`core/push/push_service.dart`): Android는 `FirebasePushService`, 그 밖(Apple 가입 전 iOS)과 테스트 기본값은 `NoPushService`. `main`이 Android에서만 Firebase를 켜고, 실패해도 푸시 없이 뜬다.
  - 등록 `pushRegistrationProvider`(`core/push/push_registration.dart`, RN `PushRegistration`): 키가 있을 때 앱 루트가 watch한다. 앱 언어로 채널 이름을 만들고(언어가 바뀌면 이름만 바꿈), 키마다 한 번 권한을 물은 뒤 `PUT /v1/devices`(`appVersion` `fl-<버전>`)로 등록한다. 빈 토큰은 null로 등록, 토큰 조회 실패는 등록하지 않음, 토큰 변경 이벤트는 마지막 토큰과 다를 때만 다시 등록한다. RN은 키를 지웠다 저장하면 컴포넌트가 다시 마운트되는데, 여기서는 client를 watch해 키가 바뀌면 다시 만들어진다.
  - 탭 이동 `notificationTapsProvider`(`app/notification_taps.dart`): 라우터가 필요해 app 계층에 둔다. 실행한 알림(FCM `getInitialMessage`, 앱 사용 중 띄운 로컬 알림의 launch details)과 앱이 켜져 있을 때 누른 알림을 `notificationCommodity`(RN `notificationHref`)로 C-a 또는 A로 보낸다. C는 A 아래 경로라 [←]가 A로 간다.
  - 앱 사용 중 표시는 서버가 지정한 채널(모르면 `alerts`)로 띄운다. 배지는 쓰지 않는다(채널 `showBadge: false`). 작은 아이콘은 앱 아이콘(`@mipmap/ic_launcher`)이다(RN도 아이콘을 따로 지정하지 않음).
- 근거: RN 동작(등록 시점·토큰 규칙·탭 대상)을 그대로 따르고, 플랫폼 API 차이만 이 저장소에서 메운다.
- 영향: dev debug APK 빌드로 Gradle 설정을 확인했다. 가짜 `PushService`로 등록·채널 이름·토큰 변경·키 변경·탭 이동을 테스트로 고정했다. 실제 FCM 수신·권한 창·알림 표시·탭은 에뮬레이터에서 확인하지 않았다. B-a 알림 권한 배너는 FL-033.

## FL-033: B-a 알림 권한 배너
- 날짜: 2026-11-20
- 상태: 확정 (권한 창·설정 열기·복귀 후 다시 읽기는 Android 푸시 기기 확인 때, iOS는 FL-011)
- 맥락: TODO 5단계(screens.md B-a "권한 배너 버튼"). RN `usePushPermission`은 `expo-notifications`의 `granted`·`canAskAgain`을 읽고, 앱이 다시 활성화될 때마다 새로 읽으며, 다시 물을 수 있으면 권한 창, 아니면 `Linking.openSettings()`다. Flutter의 `firebase_messaging`은 "다시 물을 수 있는지"를 주지 않는다.
- 결정:
  - 패키지 `permission_handler` 13.0.2(2026-09-04 pub.dev)의 `Permission.notification`으로 상태 조회·요청, `openAppSettings()`로 앱 설정 화면을 연다. 시작 때 푸시 등록의 권한 요청도 같은 패키지로 바꿔 요청 결과를 한곳에서 본다.
  - Android는 상태 조회만으로 영구 거부를 알 수 없다(묻지 않은 상태와 같게 보임, `permission_handler_android` `checkPermissionStatus` 주석). 그래서 `FirebasePushService`가 마지막 요청 결과(`permanentlyDenied`)를 앱 프로세스 동안 기억해 `canAskAgain`을 만든다. 시작 때 등록이 한 번 요청하므로 B-a를 열 때는 보통 알고 있다. 사용자가 OS 설정에서 "매번 묻기"로 되돌리면 앱을 다시 켤 때까지 [설정 열기]로 남는다(눌러도 설정 화면이 열릴 뿐이라 감수).
  - `PushService`에 `getPermission`·`requestPermission`(결과 반환)·`openSettings`를 둔다. `NoPushService`(Apple 가입 전 iOS)는 null이라 배너를 숨긴다.
  - 상태는 `pushPermissionProvider`(`core/push/push_permission.dart`, autoDispose)가 갖고, `AppLifecycleListener`로 resumed마다 다시 읽는다. B-a 맨 위 `_PermissionBanner`는 권한이 꺼졌을 때만 보이고 확인 전에는 숨긴다(RN과 같음).
- 근거: RN 동작과 문구를 따르고, Android의 영구 거부 판정 한계만 요청 결과 기억으로 메운다.
- 영향: dev debug APK 빌드로 네이티브 플러그인을 확인했다. 가짜 `PushService`로 숨김·[허용]·영구 거부 뒤 [설정 열기]·복귀 후 다시 읽기를 위젯 테스트로 고정했다. 실제 권한 창은 에뮬레이터에서 확인하지 않았다.
