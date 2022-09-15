#!/bin/bash

set -e

name=
file_path=
url=
link_type="other"

while getopts "n:p:u:t:h" opt; do
    case $opt in
    n)
        name=$OPTARG
        ;;
    p)
        file_path=$OPTARG
        ;;
    u)
        url=$OPTARG
        ;;
    t)
        link_type=$OPTARG
        ;;
    h)
        echo "Examples:"
        echo "bash post-gitlab-release-links-14.sh -n dist -p './dist' -u 'https://example.com' -t 'package'"
        echo ""
        exit 0
        ;;
    *)
        echo "there is unrecognized parameter."
        ;;
    esac
done

set -u

curl --request POST "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/releases/${CI_COMMIT_TAG}/assets/links" \
    --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" \
    --data name="${name}" \
    --data filepath="${file_path}" \
    --data url="${url}" \
    --data type="${type}"
