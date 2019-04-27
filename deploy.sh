#!/bin/bash

set -eo pipefail

ENVIRONMENT_NAME=$1
if [[ -z "$ENVIRONMENT_NAME" ]]; then
  echo "Environment Name must be passed as the first argument"
  exit 2
fi

./build.sh

(
	cd infrastructure
	terraform workspace select "${ENVIRONMENT_NAME}"
	terraform init -get -get-plugins
	terraform apply -var-file "config/${ENVIRONMENT_NAME}.tfvars.json"
)
