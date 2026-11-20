# build_android_release.sh·install_android_release.sh가 함께 쓰는 값(FL-034, FL-035). source로 읽는다.

APK=build/app/outputs/flutter-apk/app-prod-release.apk
# APK를 만든 앱 커밋(빌드가 쓰고 설치가 비교한다)
APK_COMMIT_FILE="$APK.commit"
APP_ID=io.github.seyoon.futureetp
# APK에 들어가는 경로. 이 경로의 마지막 커밋이 설치본을 정한다
APP_PATHS=(lib android assets pubspec.yaml pubspec.lock l10n.yaml build.yaml)

# 앱 경로의 마지막 커밋 해시
last_app_commit() {
  git log -1 --format=%H -- "${APP_PATHS[@]}"
}

# 앱 경로에 커밋 안 한 변경(추적 안 하는 파일 포함)이 없는지
app_paths_clean() {
  [[ -z "$(git status --porcelain -- "${APP_PATHS[@]}")" ]]
}
