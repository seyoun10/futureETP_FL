# TODO

목표: Flutter로 RN 앱(`../futureETP/apps/mobile`)과 같은 기능의 앱 만들기(Android·iOS, 개인용, D-011)
지침: 남은 항목만 둔다. 최상위 항목이 하위 항목까지 모두 끝나면 블록째 `docs/history.md`의 같은 절 끝으로 옮긴다. 새 단계·항목은 여기에 추가한다
원본 변경 따라가기: `../futureETP`에서 API·shared 스키마·화면 동작이 바뀌면 그쪽에서 이 파일의 "원본 변경 반영"에 항목을 적는다

## 원본 변경 반영
마지막 대조: futureETP `ecf4dd1`(2026-11-23). 적힌 항목 밖에 빠진 것이 있는지는 `git -C ../futureETP log --oneline ecf4dd1..HEAD -- apps/mobile packages/shared`로 그 뒤 커밋만 Flutter 커밋과 맞춰 본다. 다 보면 이 줄의 커밋을 그 HEAD로 바꾼다
- [ ] 핀치 중 십자선 막기(2026-11-23, futureETP D-087 보충): 두 손가락으로 핀치하다 멈추면 길게 누르기 십자선이 켜지던 것. 핀치를 시작한 터치에서는 손가락을 댄 채 멈춰도 십자선·봉 스냅 햅틱·상세 박스를 띄우지 않고, 손을 모두 떼고 다시 길게 눌러야 나타난다(C-a·C-c 공통, futureETP `charts/useChartViewport.ts` `pinchedInTouch`). screens.md C-a 길게 누르기

## 3. 공통 기반
- [ ] 접근 키 QR 읽기를 실제 기기에서 확인(키 스크립트 QR, FL-018)

## 4. 화면 수직 슬라이스 (RN 순서)
- [ ] 기기 확인: 화면 구현을 먼저 마치고 나중에 한꺼번에 한다
  - [ ] C-a·C-b·C-c 실기기 확인: 핀치·드래그·십자선 손동작, 햅틱 촉감, 성능, 기준일 휠 시트(FL-025·FL-027~FL-029, 기기 설치 때)
  - [ ] Android 실기기 prod 설치(`docs/ops.md`): RN 앱 위 덮어 설치, 알림이 두 번 오지 않는지(FCM 토큰 중복, FL-035)
  - [ ] B·B-a 기기 확인: rare-level 키패드(iOS [완료] 줄·Android 완료 키·뒤로 버튼·끌어서 닫기), 저장·오류 줄, 거부 시간 시트, 앱 버전 줄(FL-031)

## 5. 푸시
- [ ] iOS APNs 기기 토큰 등록(Apple 가입 뒤)
