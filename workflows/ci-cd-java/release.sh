#!/bin/bash
set -e
parent="$(dirname "$0")/../"
pushd "$parent" > /dev/null
if [[ ! -z "$1" ]];then
  [[ -f "$1/pom.xml" ]] && prefix=$1 || ( echo "Cannot release this" & exit 1 )
else
  prefix=${PWD##*/}
fi
[[ -n $(git status -s) ]] && echo "working tree is not clean" && exit 1

current=$(git tag -l "$prefix-[0-9]*.[0-9]*.[0-9]*"|sort -rV|head -n1|grep -oE '[0-9]+\.[0-9]+\.[0-9]+') || current="0.0.0"
IFS='.' read -r major minor micro <<< "$current"
next="$major.$minor.$((micro + 1))"

read -p "What is the release version for $prefix? $next: : " -r input
[[ "" != "$input" ]] && next="$input"
[[ ! $next =~ ^[0-9]+.[0-9]+.[0-9]+$ ]] && echo "$next doesn't match regex '^[0-9]+.[0-9]+.[0-9]+$'" && exit 1

branch=$(git branch --show-current -q)
echo -e "Performing a new release. Branch: \033[0;32m$branch\033[0m, version: \033[0;32m$next\033[0m"
git push origin "$branch"
tag="$prefix-$next"
git tag -a "$tag" -m "tag: $tag, branch: $branch"
git push origin "$tag"

popd > /dev/null
