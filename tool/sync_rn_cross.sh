#!/usr/bin/env bash
# RN 순수 함수(숫자 포맷·차트 눈금·라벨 배치)로 교차 테스트 기준값을 다시 만든다(FL-036).
# CI에는 RN 저장소가 없어 결과를 test/cross/fixtures/rn_outputs.json으로 커밋한다.
# RN 원본이 바뀌어 test/cross/rn_cross_test.dart의 원본 비교가 실패하면 이걸 돌리고, 그다음 Flutter 쪽을 맞춘다.
set -euo pipefail
cd "$(dirname "$0")/.."
root=$(pwd)
rn=$(cd ../futureETP/apps/mobile && pwd)
out=test/cross/fixtures/rn_outputs.json
mkdir -p "$(dirname "$out")"
# RN 앱 폴더에서 돌려야 RN의 tsx·tsconfig·d3-scale을 쓴다
(cd "$rn" && ../../node_modules/.bin/tsx "$root/tool/rn_cross/generate.mts" "$rn" "$root/$out")
echo "wrote $out ($(wc -c <"$out" | tr -d ' ') bytes)"
