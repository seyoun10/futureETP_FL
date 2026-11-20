# TODO

목표: Flutter로 RN 앱(`../futureETP/apps/mobile`)과 같은 기능의 앱 만들기(Android·iOS, 개인용, D-011)
지침: 남은 항목만 둔다. 최상위 항목이 하위 항목까지 모두 끝나면 블록째 `docs/history.md`의 같은 절 끝으로 옮긴다. 새 단계·항목은 여기에 추가한다
원본 변경 따라가기: `../futureETP`에서 API·shared 스키마·화면 동작이 바뀌면 그쪽에서 이 파일의 "원본 변경 반영"에 항목을 적는다

## 원본 변경 반영

## 3. 공통 기반
- [ ] 2단계 임시 화면 `lib/features/dev_health`·관련 ARB 키(`devHealth*`)를 지운다(지금 [⚙] `/settings` 자리, B 화면이 생기면, FL-026)
- [ ] 접근 키 QR 읽기를 실제 기기에서 확인(키 스크립트 QR, FL-018)

## 4. 화면 수직 슬라이스 (RN 순서)
- [ ] C-a·C-c 실기기 확인: 핀치·드래그 손동작, 햅틱 촉감, 성능(FL-025·FL-027·FL-028, 기기 설치 때)
- [ ] C-b 월물커브: `GET /v1/commodities/:code/curve?baseDate`, 기준일 OS 날짜 피커, 이전·다음 기준일, 변화율 라벨 배치, 롤 수익률 (D-090, D-091, D-114~D-123)
- [ ] C-d ETP 목록(필터·정렬은 앱에서)·C-d-a 상세 (D-017)
- [ ] B 설정·B-a 알림 설정: 낙관적 PATCH, rare-level 입력 검증, 알림 대상 없음 빨간 점 (D-081~D-083, D-124). B-b title-bar도 `ScreenHeader`로 맞춘다(FL-026)
- [ ] 화면별 세부 동작은 `../futureETP/docs/wireframes/screens.md`와 하나씩 대조

## 5. 푸시
- [ ] Android FCM 토큰 등록·알림 권한·채널(RN과 같은 채널 ID)
- [ ] iOS APNs 기기 토큰 등록(Apple 가입 뒤)
- [ ] `PUT /v1/devices`(토큰·플랫폼·`appVersion` `fl-<버전>`), 알림 탭으로 해당 C 화면 이동, 앱 사용 중 알림 표시 (D-037, D-120)

## 6. 기기 설치·운영
- [ ] prod 변형 release 빌드를 개인 기기에 설치하는 절차를 `docs/ops.md`(새로 만든다)에 기록
- [ ] RN 앱과 같은 앱 ID라 바꿔 설치할 때 할 일(기존 앱 삭제, 접근 키 다시 입력, 기기 설정 다시 맞춤) 기록
- [ ] 업데이트 배포 방식(OTA 없음, 재설치) 결정
- [ ] Android release 서명(RN과 같은 키 `~/.config/futureetp/android-release.properties`면 RN 앱 위에 덮어 설치 가능, D-039)·`versionCode`(RN은 커밋 수)·arm64-v8a만 넣기
