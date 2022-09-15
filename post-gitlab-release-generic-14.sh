#!/bin/bash

curl --request POST "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/release/${CI_COMMIT_TAG}/${1}" \
    --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
    --upload-file ${2}
