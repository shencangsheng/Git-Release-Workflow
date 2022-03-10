#!/bin/bash

changelog-echo >CHANGELOG.txt

sed s/$/"\\\n"/ CHANGELOG.txt | tr -d '\n' >release-notes.txt

description=$(cat release-notes.txt)

curl --request POST "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/releases" \
    --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" \
    --header "Content-Type: application/json" \
    -d "
{
   \"tag_name\": \"$CI_COMMIT_TAG\",
   \"description\": \"${description}\"
}
"
