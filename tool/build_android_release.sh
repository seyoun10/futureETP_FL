#!/usr/bin/env bash
# prod 변형 release APK를 만든다(FL-034). 서명 키는 ~/.config/futureetp/android-release.properties(D-039).
# versionCode는 10000 + 커밋 수: main에서만 빌드해 단조 증가하고, RN 앱(커밋 수, 수백)보다 항상 커서
# 같은 키로 서명된 RN 앱 위에 덮어 설치된다. 다른 브랜치에서 빌드해 깔면 뒤의 main 빌드가 더 작아져
# 지우고 다시 깔아야 하므로(접근 키가 사라진다) main·커밋된 상태에서만 빌드한다.
# 결과: build/app/outputs/flutter-apk/app-prod-release.apk 와 그 앱 커밋을 적은 .commit 파일
set -euo pipefail
cd "$(dirname "$0")/.."
source tool/android_release_common.sh

fail() {
  echo "build_android_release: $*" >&2
  exit 1
}

branch=$(git rev-parse --abbrev-ref HEAD)
[[ "$branch" == main ]] ||
  fail "main 브랜치에서만 빌드합니다(지금 $branch). versionCode가 커밋 수라 다른 브랜치 빌드는 뒤의 main 빌드보다 클 수 있습니다"
app_paths_clean ||
  fail "앱 경로에 커밋되지 않은 변경이 있습니다. 커밋하고 다시 빌드하세요"

app_commit=$(last_app_commit)
build_number=$((10000 + $(git rev-list --count HEAD)))
echo "build_android_release: versionCode $build_number, app commit ${app_commit:0:7}"
# 빌드가 실패하면 이전 기록이 남지 않게 먼저 지운다
rm -f "$APK_COMMIT_FILE"
flutter build apk --flavor prod --release --target-platform android-arm64 \
  --build-number "$build_number" "$@"
echo "$app_commit" >"$APK_COMMIT_FILE"
