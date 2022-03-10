#!/bin/bash

bash changelog-echo.sh >CHANGELOG.md

sed s/$/"\\\n"/ CHANGELOG.txt | tr -d '\n' >release-notes.txt

description=$(cat release-notes.txt)

curl --request POST "${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/releases" \
    --header 'authorization: Bearer ${{ secrets.GITHUB_TOKEN }}' \
    --header "Accept: application/vnd.github.v3+json" \
    -d "
{
   \"tag_name\": \"${GITHUB_REF_NAME}\",
   \"body\": \"${description}\"
}
"
