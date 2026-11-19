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
- 영향: iOS 시뮬레이터 빌드 확인. Android 빌드는 다음 Android 실행 때 확인한다.

