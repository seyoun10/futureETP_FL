# Tech Stack

> Flutter 앱의 스택. 버전은 2026-11-19 pub.dev API 기준 최신 안정판이고, Flutter 3.50.0 임시 프로젝트에서 함께 해결되는 것을 확인했다.
> 결정 근거는 `decisions.md`(FL-xxx)에 적고 여기에는 결과만 적는다. 버전은 확정할 때 웹 검색으로 최신 안정판을 확인하고 출처 날짜를 함께 적는다.
> 서버·DB·배치는 `../futureETP/docs/tech-stack.md`(공용).

상태: 확정 (2026-11-19). 차트만 4단계 스파이크 뒤 확정, iOS 푸시는 5단계

| 영역 | 후보 / 선택 | 메모 |
|---|---|---|
| SDK / 언어 | Flutter 3.50.0 (stable, 2026-11-09) · Dart 3.14.0 | `~/development/flutter` git clone, `flutter --version` 2026-11-19 확인 |
| iOS 의존성 | Swift Package Manager(기본), 미지원 플러그인만 CocoaPods 대체 | FL-003 |
| Android 빌드 | Zulu JDK 17(`flutter config --jdk-dir`), Android SDK 37, AVD `Pixel_API_36` | RN과 공유 |
| 상태 관리 | `flutter_riverpod` 3.5.0, 코드 생성 없음 | FL-004. `Notifier`·`AsyncNotifier`·family만 |
| 내비게이션 | `go_router` 18.1.4 | FL-005. C 하단 탭은 `StatefulShellRoute.indexedStack` |
| HTTP | `dio` 5.11.1 | FL-006. 재시도는 D-072대로 직접 구현 |
| JSON 모델 | `freezed` 4.0.3·`freezed_annotation` 3.1.0·`json_serializable` 6.15.2·`json_annotation` 4.12.0·`build_runner` 2.17.1 | FL-007. 계약 테스트 `json_schema` 5.2.2(draft 2020-12) |
| 차트 | 미정: `CustomPainter` 직접 구현(후보), `fl_chart` 1.3.1 검토 | 4단계 C-a 스파이크로 정한다 |
| 보안 저장소 | `flutter_secure_storage` 11.2.0 | FL-008. 접근 키(D-044)·installation ID, Android minSdk 24 |
| 기기 설정 저장 | `shared_preferences` 2.5.6(`SharedPreferencesWithCache`) | FL-008, FL-019. 언어·등락 색(D-073) |
| 시각 | `clock` 1.1.3 | FL-022. 자동 새로고침 시각을 테스트의 가짜 시간과 맞춘다 |
| 기기 시간대 | `flutter_timezone` 5.1.1 | FL-023. IANA 이름(D-084) |
| QR | `mobile_scanner` 7.5.0 | FL-009. B-b 접근 키 QR(D-078) |
| i18n | `flutter_localizations` + `intl` 0.20.3(SDK 고정) + gen-l10n | FL-009. ko 기준, en |
| 푸시 | Android `firebase_messaging` 17.1.0 + `firebase_core` 5.2.0, iOS APNs 토큰 방식은 5단계 | FL-011(검토중) |
| 햅틱 | `HapticFeedback`(Flutter 기본) | D-109·D-138·D-139 |
| CI | GitHub Actions `check.yml`(ubuntu, `subosito/flutter-action` v2, Flutter 3.50.0) | FL-014. 검사만, 앱 빌드 없음 |
| 테스트 / lint | `flutter_test`·`integration_test` / `very_good_analysis` 11.0.0 | FL-010. import 방향 검사는 2단계 |

## RN 스택과의 대응

| RN(`../futureETP`) | 이 앱 |
|---|---|
| TanStack Query(서버 상태·캐시·자동 새로고침) | 상태 계층 + repository 캐시 |
| Zustand persist(언어·등락 색) | 기기 설정 저장 |
| Victory Native XL + Skia | 위 "차트" |
| expo-secure-store | 위 "보안 저장소" |
| expo-camera | 위 "QR" |
| i18next | 위 "i18n" |
| EAS Update(OTA) | 없음(재설치) |
