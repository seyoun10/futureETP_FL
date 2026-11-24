# 운영: 기기 설치·업데이트

서버 운영(주소·접근 키 생성·dev 서버)은 원본 `../futureETP_ReactNative/docs/ops.md`. 이 문서는 Flutter 앱을 개인 기기에 까는 절차만 둔다.

## Android prod 변형 설치 (FL-034, FL-035)

설치는 Mac에서 adb로 직접 한다. 스토어·Firebase App Distribution·OTA는 쓰지 않는다.

### 처음 한 번

1. 서명 키: `~/.config/futureetp/android-release.jks`·`android-release.properties`(RN과 같은 키, D-039). 없으면 release 빌드가 멈춘다
2. FCM 설정: `cp ../futureETP_ReactNative/apps/mobile/google-services.json android/app/`
3. 기기: 설정 > 휴대전화 정보 > 빌드 번호 7번 눌러 개발자 옵션 → USB 디버깅 켜기. USB로 연결하고 기기의 "USB 디버깅 허용"에 동의한다. 케이블 없이 하려면 개발자 옵션 > 무선 디버깅 → `adb pair <IP:페어링 포트>` → `adb connect <IP:포트>`
4. `adb devices`에 기기가 `device`로 보이는지 확인한다

### 빌드·설치 (업데이트도 같다)

```bash
./tool/build_android_release.sh
./tool/install_android_release.sh
```

- 빌드: prod 변형 release APK, versionCode `10000 + 커밋 수`, arm64-v8a만. main 브랜치이고 앱 경로에 커밋 안 한 변경이 없을 때만 빌드한다. 결과 `build/app/outputs/flutter-apk/app-prod-release.apk`와 그 앱 커밋을 적은 `.apk.commit`
- 설치: `adb install -r`. 앱 경로(`lib`·`android`·`assets`·`pubspec.*`·`l10n.yaml`·`build.yaml`)에 커밋 안 한 변경이 있거나, APK를 만든 앱 커밋(`.apk.commit`)이 지금 앱 경로의 마지막 커밋과 다르면 멈춘다. 기기가 여럿이면 `ANDROID_SERIAL=<serial>`
- 이전 FL 빌드 위에 덮어 설치하면 접근 키·installation ID·기기 설정·표시 설정이 그대로 남는다
- 앱을 지우는 일(데이터 삭제)은 스크립트가 하지 않는다. 서명이 다르다(`INSTALL_FAILED_UPDATE_INCOMPATIBLE`, 예: RN debug 빌드가 깔린 기기)거나 versionCode가 낮다(`INSTALL_FAILED_VERSION_DOWNGRADE`)는 실패는 안내를 보고 `adb uninstall io.github.seyoon.futureetp` 뒤 다시 설치한다

### RN 앱과 바꿔 설치

앱 ID가 같아(FL-002) 한 기기에 하나만 깔린다. RN `expo-secure-store`·AsyncStorage와 Flutter `flutter_secure_storage`·`shared_preferences`는 저장 형식이 달라, 어느 쪽으로 바꾸든 앱 안 데이터는 이어지지 않는다.

- RN → FL: RN release(같은 키, versionCode 수백) 위에 바로 설치된다. 처음 켜면 새 기기다
  1. B-b에서 접근 키를 다시 입력한다(QR 또는 붙여넣기)
  2. installation ID가 새로 생겨 서버가 새 기기로 본다. B-a의 rare 레벨 알림·거부 시간을 다시 맞춘다
  3. B의 언어·등락 색을 다시 고른다
  4. 알림 권한 창에 동의한다
- FL → RN: FL versionCode가 더 커서 `adb uninstall io.github.seyoon.futureetp`로 지운 뒤 RN APK를 설치한다. 위 1~4를 RN 앱에서 다시 한다
- 덮어 설치하면 Firebase 설치 정보가 남아 FCM 토큰이 RN 때와 같을 수 있다. 서버 `PUT /v1/devices`는 같은 토큰을 가진 다른 기기 행의 토큰을 먼저 비우므로(`apps/server/src/db/devicesStore.ts`, D-120) 옛 RN 기기 행으로는 보내지 않는다. 그래도 첫 설치 때 알림이 한 번만 오는지 아래 체크리스트에서 본다

### Android 실기기 확인 체크리스트

iOS 실기기(iPhone 14 Pro, 2026-11-23)에서 확인한 항목과, 에뮬레이터로만 본 Android 전용 동작을 한 번에 본다. 모두 prod release(위 빌드·설치)로 한다. 끝나면 TODO 4단계 "기기 확인"의 Android 항목을 `docs/history.md`로 옮기고, 차이가 있으면 `fix:` 커밋으로 고친다.

준비

- [ ] 기기 설정 > 소리 및 진동 > 터치 진동(시스템 햅틱)을 켠다. 꺼져 있으면 `HapticFeedback`이 울리지 않아 햅틱을 판단할 수 없다
- [ ] RN release 위 덮어 설치가 `adb install -r`로 성공한다(서명 키가 같음, FL-034)
- [ ] 처음 켜면 알림 권한 창이 뜬다. 허용한다
- [ ] 첫 화면이 B-b이고 [←]가 없다. QR로 접근 키를 읽어 저장하면 A로 간다(Android 카메라 QR은 아직 기기에서 안 봄, FL-018). 카메라 권한 창 문구를 본다

C-a·C-b·C-c 차트 (FL-025, FL-027~FL-029)

- [ ] C-a: 두 손가락 핀치로 확대·축소(손가락 가운데 날짜 고정, 20봉까지 확대·전체까지 축소), 한 손가락 끌기 이동, 손을 뗀 뒤 튀지 않는다
- [ ] C-a: 300ms 길게 누르면 십자선과 상세 박스, 끌면 봉마다 짧은 선택 진동, 누르면 사라진다. 핀치로 시작한 손동작에서는 십자선이 켜지지 않는다
- [ ] C-a: 가장 과거 봉까지 끌면 가벼운 진동·왼쪽 로딩 표시가 나오고, 받는 동안 화면이 막히며, 받은 뒤 보던 범위가 유지된다
- [ ] C-a·C-c: 12M·전체 축소 상태에서 끌기·핀치가 끊기지 않는다(눈으로 본다. 끊기면 `flutter run --profile --flavor prod` + DevTools 성능 탭으로 프레임 시간을 재고 FL-025 표와 비교)
- [ ] C-c: 범례·끝값 라벨, 십자선 상세(월물별 가격·롤 수익률), 이전 3년 받기
- [ ] C-b: 길게 누르기 십자선·월물마다 진동·끌기, 기준일 버튼 → 휠 시트(년·월·일, 범위 밖 회색, [취소]·[확인]), 휴장일 옮김 안내 3초
- [ ] [⟲] 가로 모드: title-bar가 낮아지고 탭·기준 시각 줄이 숨으며, 카메라 구멍·내비게이션 바 쪽 안전 영역만큼 안쪽에 그린다. ETP 탭으로 가거나 A로 돌아가면 세로로 돌아온다
- [ ] Android 뒤로 버튼·제스처: C 어느 탭에서든 A로 간다

B·B-a 설정 (FL-031, FL-033)

- [ ] rare-level 칸을 누르면 숫자 키패드(소수점 있음)가 뜨고, 완료 키로 닫히면 검증·정렬해 저장된다
- [ ] 키패드가 뜬 채 Android 뒤로 버튼으로 닫아도 저장된다(포커스가 남은 경우)
- [ ] 목록을 끌면 키패드가 닫히고 저장된다. 맨 아래 줄은 키패드가 덮는다(화면을 줄이지 않음, RN과 같음)
- [ ] 잘못된 값·서버 실패(비행기 모드)에서 오류 줄이 나오고 값이 되돌아간다
- [ ] B-a 대상 원자재 고르기, 거부 시간 시트(4열 48칸) 열기·고르기·닫기
- [ ] B 맨 아래 `앱 버전: fl-<버전> (빌드 <10000+커밋 수>) · prod`
- [ ] 알림 권한 배너: 기기 설정에서 알림을 끄고 돌아오면 B-a 맨 위에 배너가 보이고, [설정 열기] → 켜고 돌아오면 사라진다

푸시 (FL-032, D-120)

- [ ] 앱을 보고 있을 때 온 알림이 상단에 뜬다(`alerts` 채널, 중요도 높음)
- [ ] 앱이 배경일 때·프로세스를 끈 뒤 온 알림을 누르면 해당 원자재 C-a(대상 없으면 A)로 열리고 [←]로 A
- [ ] RN 덮어 설치 뒤 같은 알림이 한 번만 온다. 두 번 오면 서버 `device` 표에서 같은 토큰을 가진 행이 둘인지 본다
- [ ] 기기 설정 > 앱 > 알림에 채널 두 개(`시세 알림`·`운영 알림`, 영어면 앱 언어 이름)가 보인다

## iOS

Apple Developer 가입 전에는 무료 Apple ID(Personal Team `E8B6A6F4B9`, 프로젝트에 지정됨)로 서명해 실기기에 설치한다. 서명이 7일 뒤 만료되면 다시 설치한다. Push 권한(entitlements)은 아직 없어 iOS 알림은 Apple 가입 뒤 5단계에서 붙인다(FL-011).

- prod Release 설치(RN prod 앱 위에 덮어씀, 기기 이름은 `xcrun devicectl list devices`의 Name, 예: `14P`)
  1. `LANG=en_US.UTF-8 flutter build ios --flavor prod --release` → `build/ios/iphoneos/Runner.app`
  2. `xcrun devicectl device install app --device 14P build/ios/iphoneos/Runner.app`
  3. `xcrun devicectl device process launch --device 14P --terminate-existing io.github.seyoon.futureetp`
- 접근 키는 RN과 저장 위치가 달라 넘어오지 않는다. B-b에서 QR이나 직접 입력으로 다시 넣는다
- FL → RN: futureETP에서 `npm run ios:prod-install -- 14P`로 RN prod를 다시 설치한다
