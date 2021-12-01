#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o verbose

DATE=$(date "+%d")
DAY=${1:-$DATE}

cp -pr template ${DAY}
pushd ${DAY}
find . | grep .go | xargs sed -i "s/template/${DAY}/g"
mv template.go day${DAY}.go
mv template_test.go day${DAY}_test.go
popd
