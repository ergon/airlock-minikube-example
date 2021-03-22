#!/bin/bash
set -euox pipefail

rm -rf .github/build
mkdir -p .github/build
cp -r .github/test/* .github/build/

if [ "$(uname -s)" == "Linux" ]; then
  docker run --rm --add-host=host.docker.internal:host-gateway -v $PWD/.github/build:/e2e -w /e2e cypress/included:6.0.1
else
  docker run --rm -v $PWD/.github/build:/e2e -w /e2e cypress/included:6.0.1
fi
