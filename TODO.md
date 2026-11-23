# TODO

목표: Flutter로 RN 앱(`../futureETP/apps/mobile`)과 같은 기능의 앱 만들기(Android·iOS, 개인용, D-011)
지침: 남은 항목만 둔다. 최상위 항목이 하위 항목까지 모두 끝나면 블록째 `docs/history.md`의 같은 절 끝으로 옮긴다. 새 단계·항목은 여기에 추가한다
원본 변경 따라가기: `../futureETP`에서 API·shared 스키마·화면 동작이 바뀌면 그쪽에서 이 파일의 "원본 변경 반영"에 항목을 적는다

## 원본 변경 반영
- [x] 휴장 달력 일정을 기기 로컬로(2026-11-23, futureETP D-144, FL `local_schedule.dart`·FL-037): 예외 일정을 시장 날짜 대신 기기 로컬 날짜 칸에 둔다. 시각 있는 일정은 `at`(시장 현지)을, CLOSED는 정규 개장 시각(CME 전날 17:00 CT, KRX 09:00 KST, NYSE 09:30 ET)을 로컬로 바꾼 날짜. 목록과 날짜 칸 점은 로컬 시각순(휴장은 정규 개장 시각, 같은 시각은 시장 순). 문구 시각은 로컬 `HH:mm`이고 시간대 표기 없음(`calendar.kinds`의 `{{tz}}`·`calendar.timeZones` 삭제). 조회 범위를 앞뒤 하루씩 넓히고 3개월 밖 연도 `missing`은 숨김. 같은 날 같은 시장 점이 둘일 수 있음. futureETP `features/calendar/localSchedule.ts`, screens.md A-a
- [ ] 휴장 달력 화면 A-a(2026-11-21, futureETP D-143): A title-bar [⚙] 왼쪽에 [📅](`calendar-month-outline`) → 이번 달~다다음 달 3개월 세로 달력, 오늘(기기 로컬)·CME/KRX/NYSE 휴장(채운 점)·조기 마감/개장 지연(빈 점)·달별 휴일 이름 목록·미입력 안내. API `GET /v1/calendar?from&to`(계약 `calendar`·`calendarQuery`), 색 `colors.market`·`today`, 문구 `calendar.*`. `../futureETP/docs/wireframes/screens.md` A-a. 캐시: 응답 `missing`이 비어 있으면 12시간, 있으면 5분 stale(화면 재진입·앱 복귀 때 다시 조회, 서버 import 뒤 재시작 없이 반영. futureETP `useMarketCalendar.ts`)
- [ ] rare 레벨 입력 규칙 강화(2026-11-21, futureETP 품질 검증 B2/D1·D3): rare 레벨은 소수 첫째 자리로 반올림한 값으로 중복을 본다(1과 1.00000000001은 중복). C-a `levels` query는 `^d+(.d+)?(,d+(.d+)?)*$`만 받는다(공백·`0x8`·`1e1` 거절, 계약 `disparityQuery`). 앱 입력 검증이 같은 규칙인지, 직렬화가 숫자 기본 문자열(`1`, `2.5`)인지 확인
  - [x] 모델·`getCalendar`·`calendarProvider`(캐시 규칙)
  - [x] 3개월 달력 화면·색 토큰·`calendar.*` 문구(D-144 로컬 날짜·시각 포함, `CalendarScreen`)
  - [ ] A 제목 줄 [📅] 버튼·라우팅

## 3. 공통 기반
- [ ] 접근 키 QR 읽기를 실제 기기에서 확인(키 스크립트 QR, FL-018)

## 4. 화면 수직 슬라이스 (RN 순서)
- [ ] 기기 확인: 화면 구현을 먼저 마치고 나중에 한꺼번에 한다
  - [ ] C-a·C-b·C-c 실기기 확인: 핀치·드래그·십자선 손동작, 햅틱 촉감, 성능, 기준일 휠 시트(FL-025·FL-027~FL-029, 기기 설치 때)
  - [ ] Android 실기기 prod 설치(`docs/ops.md`): RN 앱 위 덮어 설치, 알림이 두 번 오지 않는지(FCM 토큰 중복, FL-035)
  - [ ] B·B-a 기기 확인: rare-level 키패드(iOS [완료] 줄·Android 완료 키·뒤로 버튼·끌어서 닫기), 저장·오류 줄, 거부 시간 시트, 앱 버전 줄(FL-031)

## 5. 푸시
- [ ] iOS APNs 기기 토큰 등록(Apple 가입 뒤)
