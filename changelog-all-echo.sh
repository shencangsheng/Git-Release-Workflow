#!/bin/bash

tags=$(git tag --sort=creatordate)

# 将标签列表分割成数组
IFS=$'\n' read -d '' -ra tag_array <<<"$tags"

array_length=${#tag_array[@]}

function part() {
    name=$1
    pattern=$2
    changes=$(grep -E "^($pattern)" releaseNotes.tmp | sed -E "s/($pattern): //g" | sort | uniq | awk '{print NR". "$0}')
    lines=$(printf "\\$changes\n" | wc -l)
    if [ $lines -gt 0 ]; then
        echo "### $name"
        echo ""
        echo "$changes"
        echo ""
    fi
}

# 遍历数组
for ((i = array_length - 1; i > 0; i--)); do
    element="${tag_array[i]}"

    # 计算下一个元素的索引
    next_index=$((i - 1))
    tag_info=$(git show --quiet --format="%ci" --date=short $element | awk '{print $1}')
    # 检查是否越界
    next_element="${tag_array[next_index]}"
    echo "# $element - $tag_info"
    git log --pretty=format:'%s' "$element...$next_element" | sort -k2n | uniq >./releaseNotes.tmp
    echo ""
    part "Features" "feature|feat"
    part "Bug Fixes" "bugfix|fix"
    part "Enhancements" "enhance"
    part "Tests" "test"
    part "Documents" "docs|doc"
    part "Refactors" "refactor"
    part "Styles" "style"
    part "Others" "other"
    part "Perfs" "perf"
done

rm -f ./releaseNotes.tmp
rm -f ./tags.tmp
