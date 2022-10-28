#!/bin/bash
echo -e "\033[0;31mThis script is designed for github actions only. Be cautious!\033[0m"
set -e

if [ -z "${RELEASE_VERSION}" ] && [ $# != 1 ]
then
  echo "Usage: perform-release.sh <version>" >&2
  echo "     : RELEASE_VERSION=<version> && perform-release.sh" >&2
  exit 1
fi
[ -z "${RELEASE_VERSION}" ] && RELEASE_VERSION="$1"
PARENT_DIR=$(dirname "$0")/../
GITHUB_DIR="$PARENT_DIR.github"
pushd "$PARENT_DIR" > /dev/null
[ ${RELEASE_MODULE} == ${PWD##*/} ]||[ -z "${RELEASE_MODULE}" ] && POM="./pom.xml"||POM="${RELEASE_MODULE}/pom.xml"
MVN_SETTINGS="$GITHUB_DIR"/maven-settings.xml
mvn -f "$POM" clean versions:set versions:commit -DnewVersion="$RELEASE_VERSION"
mvn -f "$POM" -s "$MVN_SETTINGS" --batch-mode --update-snapshots --activate-profiles ci -DskipTests deploy
if [ -f "ci-cd-config.yaml" ]; then
  bash "$GITHUB_DIR"/docker-release.sh "$RELEASE_VERSION" "$RELEASE_MODULE"
fi
popd > /dev/null
