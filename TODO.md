# TODO

목표: Flutter로 RN 앱(`../futureETP/apps/mobile`)과 같은 기능의 앱 만들기(Android·iOS, 개인용, D-011)
지침: 남은 항목만 둔다. 최상위 항목이 하위 항목까지 모두 끝나면 블록째 `docs/history.md`의 같은 절 끝으로 옮긴다. 새 단계·항목은 여기에 추가한다
원본 변경 따라가기: `../futureETP`에서 API·shared 스키마·화면 동작이 바뀌면 그쪽에서 이 파일의 "원본 변경 반영"에 항목을 적는다

## 원본 변경 반영

## 3. 공통 기반
- [ ] 접근 키 QR 읽기를 실제 기기에서 확인(키 스크립트 QR, FL-018)

## 4. 화면 수직 슬라이스 (RN 순서)
- [ ] 기기 확인: 화면 구현을 먼저 마치고 나중에 한꺼번에 한다
  - [ ] C-d·C-d-a Android 에뮬레이터 dev 서버 확인: 필터·정렬·수집 시각 줄·상세·운용사 페이지 열기(`url_launcher` 네이티브 빌드 포함, FL-030)
  - [ ] C-a·C-b·C-c 실기기 확인: 핀치·드래그·십자선 손동작, 햅틱 촉감, 성능, 기준일 휠 시트(FL-025·FL-027~FL-029, 기기 설치 때)
  - [ ] B·B-a 기기 확인: rare-level 키패드(iOS [완료] 줄·Android 완료 키·뒤로 버튼·끌어서 닫기), 저장·오류 줄, 거부 시간 시트, 앱 버전 줄(FL-031)

## 5. 푸시
- [ ] Android FCM 토큰 등록·알림 권한·채널(RN과 같은 채널 ID)
- [ ] B-a 알림 권한 배너: 권한이 꺼져 있을 때만, 다시 물을 수 있으면 [허용] 아니면 [설정 열기] (screens.md B-a, FL-031)
- [ ] iOS APNs 기기 토큰 등록(Apple 가입 뒤)
- [ ] `PUT /v1/devices`(토큰·플랫폼·`appVersion` `fl-<버전>`), 알림 탭으로 해당 C 화면 이동, 앱 사용 중 알림 표시 (D-037, D-120)

## 6. 기기 설치·운영
- [ ] prod 변형 release 빌드를 개인 기기에 설치하는 절차를 `docs/ops.md`(새로 만든다)에 기록
- [ ] RN 앱과 같은 앱 ID라 바꿔 설치할 때 할 일(기존 앱 삭제, 접근 키 다시 입력, 기기 설정 다시 맞춤) 기록
- [ ] 업데이트 배포 방식(OTA 없음, 재설치) 결정
- [ ] Android release 서명(RN과 같은 키 `~/.config/futureetp/android-release.properties`면 RN 앱 위에 덮어 설치 가능, D-039)·`versionCode`(RN은 커밋 수)·arm64-v8a만 넣기
