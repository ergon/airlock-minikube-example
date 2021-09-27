#!/bin/bash
set -euox pipefail

KUBEVAL_VERSION="0.15.0"
SCHEMA_LOCATION="https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/"

# install kubeval
curl --silent --show-error --fail --location --output /tmp/kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/download/"${KUBEVAL_VERSION}"/kubeval-linux-amd64.tar.gz
tar -xf /tmp/kubeval.tar.gz kubeval

# validate yaml files
./kubeval --strict --ignore-missing-schemas  --ignored-filename-patterns "kustomization.yaml,set_image_pull_secrets.yaml" --kubernetes-version "${KUBERNETES_VERSION#v}" --schema-location "${SCHEMA_LOCATION}" --directories "apps/argo-cd,apps/artillery,apps/echoserver,apps/iam"
