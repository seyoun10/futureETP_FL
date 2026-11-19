# Tech Stack

> Flutter 앱의 스택. 지금은 후보이고, TODO 1단계에서 하나씩 확정하며 이 표를 고친다.
> 결정 근거는 `decisions.md`(FL-xxx)에 적고 여기에는 결과만 적는다. 버전은 확정할 때 웹 검색으로 최신 안정판을 확인하고 출처 날짜를 함께 적는다.
> 서버·DB·배치는 `../futureETP/docs/tech-stack.md`(공용).

상태: 후보 (2026-11-18 작성)

| 영역 | 후보 / 선택 | 메모 |
|---|---|---|
| SDK / 언어 | Flutter 3.50.0 (stable, 2026-11-09) · Dart 3.14.0 | `~/development/flutter` git clone, `flutter --version` 2026-11-19 확인 |
| iOS 의존성 | Swift Package Manager(기본), 미지원 플러그인만 CocoaPods 대체 | FL-003 |
| Android 빌드 | Zulu JDK 17(`flutter config --jdk-dir`), Android SDK 37, AVD `Pixel_API_36` | RN과 공유 |
| 상태 관리 | Riverpod(`flutter_riverpod`, 코드 생성 여부는 스캐폴딩 때) | RN의 TanStack Query(서버 상태) + Zustand(기기 UI 설정) 역할을 Provider로 나눈다 |
| 내비게이션 | `go_router`(ShellRoute로 C 하단 탭) | Expo Router 구조(A → C 스택, C 안 하단 탭, 탭 밖 C-d-a)와 대응 |
| HTTP | `http` 또는 `dio` | 타임아웃·취소·헤더 주입이 필요. 1단계에서 하나로 정한다 |
| JSON 모델 | `json_serializable` 또는 `freezed` | 봉투·`data` 검증은 디코딩 실패 → `SCHEMA_MISMATCH` |
| 차트 | `CustomPainter` 직접 구현(후보), `fl_chart` 검토 | C-a 봉 756~3,000개 + 핀치·드래그·십자선·과거 이어 받기. 스파이크로 정한다 |
| 보안 저장소 | `flutter_secure_storage` | 접근 키(D-044)·installation ID |
| 기기 설정 저장 | `shared_preferences`(비동기 API) 후보 | 언어·등락 색(D-073) |
| QR | `mobile_scanner` | B-b 접근 키 QR(D-078) |
| i18n | `flutter_localizations` + `intl`(ARB) | ko 기준, en |
| 푸시 | `firebase_messaging`(Android FCM), iOS는 APNs 토큰(Apple 가입 뒤) | 서버는 FCM HTTP v1·APNs 직접(D-037) |
| 햅틱 | `HapticFeedback`(Flutter 기본) | D-109·D-138·D-139 |
| 테스트 / lint | `flutter_test`·`integration_test` / `flutter_lints` 또는 더 엄격한 규칙 묶음 |  |

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
