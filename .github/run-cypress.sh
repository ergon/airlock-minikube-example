#!/bin/bash
set -euox pipefail

rm -rf .github/build
mkdir -p .github/build
cp -r .github/test/* .github/build/

docker run -it -v $PWD/.github/build:/e2e -w /e2e cypress/included:6.0.1
