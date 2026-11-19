#!/usr/bin/env bash
# 원본 계약(../futureETP/packages/shared/contract)을 test/contract/schemas로 복사한다(FL-017).
# CI에는 원본 저장소가 없어 복사본으로 계약 테스트를 돌린다. 원본이 바뀌면 이걸 돌리고 모델·fixture를 고친다.
set -euo pipefail
cd "$(dirname "$0")/.."
src=../futureETP/packages/shared/contract
rm -rf test/contract/schemas
mkdir -p test/contract/schemas
cp "$src/api.json" test/contract/schemas/
cp "$src"/schemas/*.json test/contract/schemas/
echo "copied $(ls test/contract/schemas | wc -l | tr -d ' ') files"
