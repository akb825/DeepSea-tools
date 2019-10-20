#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
REPO="$1"
VERSION="$( cat "$DIR/$REPO.version" )"

rm -rf "$REPO"
git clone "https://github.com/akb825/$REPO.git"
cd "$REPO"
git checkout "v$VERSION"
if [ -e update-submodules.sh ]; then
	./update-submodules.sh
else
	git submodule init
	git submodule update
fi
