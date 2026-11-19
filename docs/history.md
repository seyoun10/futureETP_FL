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

## 2. 스캐폴딩
- [x] 프로젝트 생성, 앱 ID `io.github.seyoon.futureetp`·dev `.dev` 두 변형, 앱 이름·아이콘(RN `apps/mobile/assets` 재사용)
- [x] lint·format·test 설정과 검사 명령 하나(`check`), CLAUDE.md Commands를 실제 명령으로 갱신
  - import 방향 규칙(architecture.md "규칙")을 검사에 넣는다. 후보: dart 검사 스크립트(테스트로 `lib/` import 경로 검사) 또는 lint 플러그인
- [x] dev 변형이 로컬 dev 서버 `GET /v1/health`를 부르는 최소 화면으로 연결 확인
  - 결과(2026-11-19): flavor는 FL-012, lint·import 방향 검사는 FL-010, material_ui는 FL-013. dev 변형이 iOS 시뮬레이터·Android 에뮬레이터에서 로컬 dev 서버 health 응답을 보였다
