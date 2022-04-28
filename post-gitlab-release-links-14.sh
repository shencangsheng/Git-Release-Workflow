#!/bin/bash

set -e

name=$1
url=$2
file_path=$3

curl --request POST "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/releases/${CI_COMMIT_TAG}/assets/links" \
    --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" \
    --data name="${name}" \
    --data url="${url}" \
    --data filepath="${file_path}"
