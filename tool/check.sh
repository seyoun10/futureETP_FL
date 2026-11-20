#!/usr/bin/env bash
# 커밋 전 검사: 생성 코드 최신 → 정적 분석 → 포맷 → 테스트(import 방향 검사 포함). 하나라도 실패하면 멈춘다.
set -euo pipefail
cd "$(dirname "$0")/.."

# lib 안 build_runner 생성 파일(freezed·json_serializable)의 경로와 해시
generated_hashes() {
  find lib -type f \( -name '*.g.dart' -o -name '*.freezed.dart' \) -print0 |
    sort -z | xargs -0 shasum
}

echo "== build_runner (생성 코드가 소스와 맞는지)"
# 다시 만들기 전후를 비교한다. git diff가 아니라서 커밋 안 한 모델 변경도 함께 생성했으면 통과한다
before=$(generated_hashes)
dart run build_runner build --delete-conflicting-outputs >/dev/null
after=$(generated_hashes)
if [[ "$before" != "$after" ]]; then
  diff <(echo "$before") <(echo "$after") >&2 || true
  echo "생성 코드가 소스와 달라 다시 만들었습니다. 바뀐 파일을 확인하고 함께 커밋하세요(dart run build_runner build)" >&2
  exit 1
fi
echo "== flutter analyze"
flutter analyze --fatal-infos
echo "== dart format"
dart format --output=none --set-exit-if-changed lib test
echo "== flutter test"
flutter test
