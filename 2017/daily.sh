#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o verbose

NAME=$1
DATE=$(date "+%d")
DAY=${2:-$DATE}
NAME="$(tr '[:lower:]' '[:upper:]' <<< ${NAME:0:1})${NAME:1}"
FNAME=$(echo ${NAME} | tr '[:upper:]' '[:lower:]')

cp -pr blank ${DAY}
pushd ${DAY}
find . | grep rb | xargs gsed -i "s/blank/${FNAME}/g"
find . | grep rb | xargs gsed -i "s/Blank/${NAME}/g"
mv blank.rb ${FNAME}.rb
mv spec/blank_spec.rb spec/${FNAME}_spec.rb
touch input.txt
popd
