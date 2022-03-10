#!/bin/bash

echo "# $GITHUB_REF_NAME - "$(date "+%Y-%m-%d")""

git tag >tags.tmp
before_tag=$(cat tags.tmp | grep -B 1 $GITHUB_REF_NAME | head -n 1)

range_tag=""

if [ ! $before_tag = ${GITHUB_REF_NAME} ]; then
    range_tag="$1...${GITHUB_REF_NAME}"
fi

git log --pretty=format:'%s' $range_tag | sort -k2n | uniq >./releaseNotes.tmp

echo ""

function part() {
    name=$1
    pattern=$2
    changes=$(grep -E "$pattern" releaseNotes.tmp | sed -E "s/($pattern): //g" | sort | uniq | awk '{print NR". "$0}')
    lines=$(printf "\\$changes\n" | wc -l)
    if [ $lines -gt 0 ]; then
        echo "### $name"
        echo ""
        echo "$changes"
        echo ""
    fi
}

part "Features" "feature|feat"
part "Bug Fixes" "bugfix|fix"
part "Enhancements" "enhance"
part "Tests" "test"
part "Documents" "docs|doc"
part "Refactors" "refactor"
part "Styles" "style"
part "Others" "other"
part "Perfs" "perf"

rm -f ./releaseNotes.tmp
rm -f ./tags.tmp
