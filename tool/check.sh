#!/usr/bin/env bash
# 커밋 전 검사: 정적 분석 → 포맷 → 테스트(import 방향 검사 포함). 하나라도 실패하면 멈춘다.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== flutter analyze"
flutter analyze --fatal-infos
echo "== dart format"
dart format --output=none --set-exit-if-changed lib test
echo "== flutter test"
flutter test
