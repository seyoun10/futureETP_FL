# TODO

목표: Flutter로 RN 앱(`../futureETP/apps/mobile`)과 같은 기능의 앱 만들기(Android·iOS, 개인용, D-011)
지침: 남은 항목만 둔다. 최상위 항목이 하위 항목까지 모두 끝나면 블록째 `docs/history.md`의 같은 절 끝으로 옮긴다. 새 단계·항목은 여기에 추가한다
원본 변경 따라가기: `../futureETP`에서 API·shared 스키마·화면 동작이 바뀌면 그쪽에서 이 파일의 "원본 변경 반영"에 항목을 적는다

## 원본 변경 반영
(없음)

## 1. 스택 확정
- [ ] 차트 방식은 2단계 뒤 C-a 스파이크(아래 4단계 첫 항목)로 정한다

## 3. 공통 기반
- [ ] API client: 헤더(Bearer·`X-Device-Id`), 타임아웃 15초, 봉투 디코딩, `AppError`, 재시도 규칙 (D-042, D-072)
- [ ] 응답 모델: `../futureETP/packages/shared/contract/schemas/*.json`과 맞춘 모델(손으로 또는 생성 도구) + 계약 테스트(실제 dev 서버 응답을 저장한 예시를 모델로 디코딩하고, 같은 예시가 JSON Schema를 통과하는지) (D-142)
- [ ] 접근 키 B-b: 붙여넣기·QR(`futureetp-key:v1:` 접두사), `GET /v1/settings`로 확인 뒤 저장, 키 없으면 첫 화면이 B-b, `UNAUTHORIZED`면 어느 화면에서든 B-b + 거절 줄 (D-044, D-077~D-079)
- [ ] i18n ko/en, 앱 안 언어 설정을 서버 기기 설정과 맞춤 (D-033, D-073, D-137)
- [ ] 테마 토큰(다크 전용)·등락 색 설정 저장 (D-031, D-073)
- [ ] 공용 조회 UI: 기준 시각 줄(freshness)·로딩/오류/빈 상태 분기·`nextUpdateAt` + 1분 자동 새로고침·앱 복귀 재조회 (D-048, D-075)
- [ ] 앱 실행 때 시간대 PATCH (D-084), 세로 잠금·[⟲] 가로 전환 (D-076)
- [ ] 라우터(go_router)·첫 화면 분기를 넣고 2단계 임시 화면 `lib/features/dev_health`·관련 ARB 키(`devHealth*`)를 지운다
- [ ] 실행 화면(splash) 검정 배경·아이콘(RN `splash-icon.png`, 지금은 Flutter 기본 흰 화면)과 iPad 전체 화면(`UIRequiresFullScreen`, RN `requireFullScreen`)
- [ ] 숫자·날짜 포맷(RN `formatNumber`·`formatDateTime`과 같은 결과) 단위 테스트

## 4. 화면 수직 슬라이스 (RN 순서)
- [ ] C-a 차트 스파이크: 봉 756개 + 이평선·rare-level 밴드, 핀치·드래그·십자선, 가장 과거 봉이 보이면 이전 3년 이어 받기에서 범위 유지, 60fps 이상 (D-056, D-087, D-104, D-106) → 차트 방식 결정
- [ ] A 원자재 목록: `GET /v1/commodities`, 대표월물 ●·알림 🔔·거래 없음, 당겨서 새로고침(햅틱·터치 차단·5초 시간 초과 Alert, D-138), C-a 이동·미리 조회 (D-085)
- [ ] C-a 이격도차트: `GET /v1/commodities/:code/disparity`, 기간 버튼 6개(D-102), 롤 음영, 십자선 상세, 가로 모드, 이전 3년 받기 중 화면 터치 차단·5초 시간 초과·실패 Alert (D-086, D-103, D-108, D-139)
- [ ] C-c 월물차트: `GET /v1/commodities/:code/contracts`, log y축, 끝값 라벨 (D-092, D-093, D-113, D-118)
- [ ] C-b 월물커브: `GET /v1/commodities/:code/curve?baseDate`, 기준일 OS 날짜 피커, 이전·다음 기준일, 변화율 라벨 배치, 롤 수익률 (D-090, D-091, D-114~D-123)
- [ ] C-d ETP 목록(필터·정렬은 앱에서)·C-d-a 상세 (D-017)
- [ ] B 설정·B-a 알림 설정: 낙관적 PATCH, rare-level 입력 검증, 알림 대상 없음 빨간 점 (D-081~D-083, D-124)
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
