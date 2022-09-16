#!/bin/bash

curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file ${1} "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/release/${CI_COMMIT_TAG}/${2}"
