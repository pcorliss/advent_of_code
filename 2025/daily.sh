#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <day_number>"
  exit 1
fi

DAY_NUM=$(printf "%02d" "$1")

LIB_DIR="./lib/day$DAY_NUM"
TEST_DIR="./test/day$DAY_NUM"

mkdir -p "$LIB_DIR"
mkdir -p "$TEST_DIR"

cp "./template/dayXX_test.exs" "$TEST_DIR/day${DAY_NUM}_test.exs"
cp "./template/dayXX.ex" "$LIB_DIR/day${DAY_NUM}.ex"

touch "$LIB_DIR/input.txt"

gsed -i "s/DayXX/Day$DAY_NUM/g" "$LIB_DIR/day${DAY_NUM}.ex"
gsed -i "s/dayXX/day$DAY_NUM/g" "$LIB_DIR/day${DAY_NUM}.ex"

gsed -i "s/DayXX/Day$DAY_NUM/g" "$TEST_DIR/day${DAY_NUM}_test.exs"
gsed -i "s/dayXX/day$DAY_NUM/g" "$TEST_DIR/day${DAY_NUM}_test.exs"

echo "Setup for day $DAY_NUM complete!"
