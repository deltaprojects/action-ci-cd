#!/bin/bash
set -e
if [ -z "${RELEASE_VERSION}" ] && [ $# != 1 ]
then
  echo "Usage: docker-release.sh <version>" >&2
  echo "     : RELEASE_VERSION=<version> && docker-release.sh" >&2
  exit 1
fi

[ -z "${RELEASE_VERSION}" ] && RELEASE_VERSION="$1"
[ -z "${RELEASE_MODULE}" ] && RELEASE_MODULE="$2"

PARENT_DIR=$(dirname "$0")/../
pushd "$PARENT_DIR" > /dev/null || exit

numOfImages=$(yq eval '.images|length' ci-cd-config.yaml)
for i in $(seq "$numOfImages")
do
  j="$((i-1))"
  image=$(yq eval ".images[$j]" ci-cd-config.yaml)
  repo=$(echo "$image" | yq eval ".repo" -)
  dockerfile=$(echo "$image" | yq eval ".dockerfile" -)
  build=$(echo "$image" | yq eval ".build" -)
  release_separately=$(echo "$image" | yq eval ".releaseSeparately" -)
  buildpath=${dockerfile%/*}
  tag="$repo:$RELEASE_VERSION"

  if [ ${RELEASE_MODULE} == ${buildpath##*/} ]; then
    [ "$build" == "true" ] && docker build -f "$dockerfile" -t "$tag" "$buildpath"
    docker push "$tag"
  elif [ ${RELEASE_MODULE} == ${PWD##*/} ]; then
    if [[ "$release_separately" != "true" ]]; then
      [ "$build" == "true" ] && docker build -f "$dockerfile" -t "$tag" "$buildpath"
      docker push "$tag"
    fi
  fi

done

popd > /dev/null || exit
