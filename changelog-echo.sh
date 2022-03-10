#!/bin/bash

last=$(git describe --tags --abbrev=0 2>/dev/null)

if [ "$last" = "" ]; then
    git log --pretty=format:'%s' | sort -k2n | uniq >./releaseNotes.tmp
    echo '# '"$(git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')" "- $(date "+%Y-%m-%d")"
else
    git log --pretty=format:'%s' $last..HEAD | sort -k2n | uniq >./releaseNotes.tmp
    echo "# $last - "$(date "+%Y-%m-%d")""
fi

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

# rm -f ./releaseNotes.tmp
