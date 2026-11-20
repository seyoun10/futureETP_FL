# 운영: 기기 설치·업데이트

서버 운영(주소·접근 키 생성·dev 서버)은 원본 `../futureETP/docs/ops.md`. 이 문서는 Flutter 앱을 개인 기기에 까는 절차만 둔다.

## Android prod 변형 설치 (FL-034, FL-035)

설치는 Mac에서 adb로 직접 한다. 스토어·Firebase App Distribution·OTA는 쓰지 않는다.

### 처음 한 번

1. 서명 키: `~/.config/futureetp/android-release.jks`·`android-release.properties`(RN과 같은 키, D-039). 없으면 release 빌드가 멈춘다
2. FCM 설정: `cp ../futureETP/apps/mobile/google-services.json android/app/`
3. 기기: 설정 > 휴대전화 정보 > 빌드 번호 7번 눌러 개발자 옵션 → USB 디버깅 켜기. USB로 연결하고 기기의 "USB 디버깅 허용"에 동의한다. 케이블 없이 하려면 개발자 옵션 > 무선 디버깅 → `adb pair <IP:페어링 포트>` → `adb connect <IP:포트>`
4. `adb devices`에 기기가 `device`로 보이는지 확인한다

### 빌드·설치 (업데이트도 같다)

```bash
./tool/build_android_release.sh
./tool/install_android_release.sh
```

- 빌드: prod 변형 release APK, versionCode `10000 + 커밋 수`, arm64-v8a만. 결과 `build/app/outputs/flutter-apk/app-prod-release.apk`
- 설치: `adb install -r`. 앱 경로(`lib`·`android`·`assets`·`pubspec.*`)에 커밋 안 한 변경이 있거나 APK가 마지막 앱 커밋보다 오래됐으면 멈춘다. 기기가 여럿이면 `ANDROID_SERIAL=<serial>`
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
- 주의(확인 전): 덮어 설치하면 Firebase 설치 정보가 남아 FCM 토큰이 RN 때와 같을 수 있다. 그러면 서버에 옛 RN 기기와 새 FL 기기가 같은 토큰으로 남아 알림이 두 번 올 수 있다. 첫 설치 때 rare 알림이 두 번 오는지 본다

## iOS

Apple Developer 가입 전이라 시뮬레이터로만 확인한다(FL-011). 실기기 설치 방식은 가입 뒤에 정한다.
