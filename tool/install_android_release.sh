#!/usr/bin/env bash
# prod release APK를 USB(또는 무선 디버깅)로 연결한 Android 기기에 adb로 설치한다(FL-035).
# 먼저: ./tool/build_android_release.sh. 기기가 여럿이면 ANDROID_SERIAL=<serial>로 고른다.
# 같은 키·더 큰 versionCode라 RN 앱이나 이전 빌드 위에 덮어 설치된다(이전 FL 빌드면 접근 키가 남고, RN 앱 위면 남지 않는다).
# 앱을 지우는 일(데이터 삭제)은 스크립트가 하지 않는다. 실패 메시지의 안내를 보고 직접 한다.
set -euo pipefail
cd "$(dirname "$0")/.."

APK=build/app/outputs/flutter-apk/app-prod-release.apk
APP_ID=io.github.seyoon.futureetp
# APK에 들어가는 경로. 이것보다 오래된 APK는 그 커밋이 빠진 빌드다
APP_PATHS=(lib android assets pubspec.yaml pubspec.lock)

fail() {
  echo "install_android_release: $*" >&2
  exit 1
}

# 설치본 = 커밋 하나. 커밋 안 한 변경으로 만든 APK는 versionCode가 같아도 내용이 다르다
[[ -z "$(git status --porcelain -- "${APP_PATHS[@]}")" ]] ||
  fail "앱 경로에 커밋되지 않은 변경이 있습니다. 커밋하고 다시 빌드하세요"
[[ -f "$APK" ]] || fail "APK가 없습니다: $APK (./tool/build_android_release.sh)"

last_app_commit_time=$(git log -1 --format=%ct -- "${APP_PATHS[@]}")
apk_time=$(stat -f %m "$APK")
((apk_time >= last_app_commit_time)) ||
  fail "APK가 마지막 앱 커밋($(git log -1 --format=%h -- "${APP_PATHS[@]}"))보다 오래됐습니다. 다시 빌드하세요"

adb get-state >/dev/null 2>&1 ||
  fail "연결된 기기가 없거나 여럿입니다(adb devices). 여럿이면 ANDROID_SERIAL=<serial>"

echo "install_android_release: $(git log -1 --format='%h %s' -- "${APP_PATHS[@]}")"
if ! out=$(adb install -r "$APK" 2>&1); then
  echo "$out" >&2
  case "$out" in
    *INSTALL_FAILED_UPDATE_INCOMPATIBLE*)
      fail "설치된 $APP_ID 가 다른 키로 서명됐습니다(debug 빌드 등). 'adb uninstall $APP_ID'로 지운 뒤 다시 설치하고 접근 키를 다시 입력하세요" ;;
    *INSTALL_FAILED_VERSION_DOWNGRADE*)
      fail "설치된 앱의 versionCode가 더 큽니다. 지운 뒤 설치하거나 더 새 커밋으로 빌드하세요" ;;
    *) fail "adb install 실패" ;;
  esac
fi
echo "$out" | tail -1
