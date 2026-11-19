# History

> `TODO.md`에서 끝난 블록을 같은 절 이름 아래로 옮겨 둔다. 최신이 아래.

## 원본 변경 반영
- [x] API 계약 JSON Schema 생성(2026-11-19, futureETP D-142): `../futureETP/packages/shared/contract/`. 3단계 응답 모델은 이 파일을 기준으로 한다(TODO 3단계 응답 모델 항목에 반영됨, 2026-11-19 확인)
- [x] 레이어 import 방향 lint 강제(2026-11-19, futureETP D-041 변경): feature 간 import 금지, 공용 계층 → features·라우트 금지. `docs/architecture.md` "규칙"과 TODO 2단계에 반영됨 (2026-11-19 확인)

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
- [x] 응답 모델: `../futureETP/packages/shared/contract/schemas/*.json`과 맞춘 모델(손으로 또는 생성 도구) + 계약 테스트(실제 dev 서버 응답을 저장한 예시를 모델로 디코딩하고, 같은 예시가 JSON Schema를 통과하는지) (D-142, FL-017)
- [x] 접근 키 B-b: 붙여넣기·QR(`futureetp-key:v1:` 접두사), `GET /v1/settings`로 확인 뒤 저장, 키 없으면 첫 화면이 B-b, `UNAUTHORIZED`면 어느 화면에서든 B-b + 거절 줄 (D-044, D-077~D-079) (FL-018)
- [x] i18n ko/en, 앱 안 언어 설정을 서버 기기 설정과 맞춤 (D-033, D-073, D-137). iOS 카메라 권한 문구 한국어(InfoPlist.strings, D-078 보충) (FL-019)
- [x] 테마 토큰(다크 전용)·등락 색 설정 저장 (D-031, D-073) (FL-019, FL-020)
- [x] 숫자·날짜 포맷(RN `formatNumber`·`formatDateTime`과 같은 결과) 단위 테스트 (FL-021, `formatAmount`도 함께)
- [x] 공용 조회 UI: 기준 시각 줄(freshness)·로딩/오류/빈 상태 분기·`nextUpdateAt` + 1분 자동 새로고침·앱 복귀 재조회 (D-048, D-075) (FL-022)
- [x] 앱 실행 때 시간대 PATCH (D-084), 세로 잠금·[⟲] 가로 전환 (D-076) (FL-023, FL-024. [⟲] 버튼은 C-a와 함께)
- [x] 실행 화면(splash) 검정 배경·아이콘(RN `splash-icon.png` 76pt, `flutter_native_splash`. Android 첫 프레임 전 바탕도 검정. iOS 시뮬레이터·Android 에뮬레이터 API 37에서 확인)

## 4. 화면 수직 슬라이스
- [x] C-a 차트 스파이크: 봉 756개 + 이평선·rare-level 밴드, 핀치·드래그·십자선, 가장 과거 봉이 보이면 이전 3년 이어 받기에서 범위 유지, 60fps 이상 (D-056, D-087, D-104, D-106) → 차트 방식 결정 (2026-11-19, FL-025. Android 에뮬레이터 API 37 `-gpu host` profile 빌드로 측정, iOS·실기기는 설치 때)
