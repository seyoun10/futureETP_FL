#!/usr/bin/env bash
# prod 변형 release APK를 만든다(FL-034). 서명 키는 ~/.config/futureetp/android-release.properties(D-039).
# versionCode는 10000 + 커밋 수: main에서만 빌드해 단조 증가하고, RN 앱(커밋 수, 수백)보다 항상 커서
# 같은 키로 서명된 RN 앱 위에 덮어 설치된다. 결과: build/app/outputs/flutter-apk/app-prod-release.apk
set -euo pipefail
cd "$(dirname "$0")/.."

build_number=$((10000 + $(git rev-list --count HEAD)))
echo "build_android_release: versionCode $build_number"
flutter build apk --flavor prod --release --target-platform android-arm64 \
  --build-number "$build_number" "$@"
