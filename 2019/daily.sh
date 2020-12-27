#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o verbose

NAME=$1
DATE=$(date "+%d")
DAY=${2:-$DATE}
NAME=${NAME^}
FNAME=$(echo ${NAME} | tr '[:upper:]' '[:lower:]')

cp -pr blank ${DAY}
pushd ${DAY}
find . | grep rb | xargs sed -i "s/blank/${FNAME}/g"
find . | grep rb | xargs sed -i "s/Blank/${NAME}/g"
mv blank.rb ${FNAME}.rb
mv spec/blank_spec.rb spec/${FNAME}_spec.rb
popd
