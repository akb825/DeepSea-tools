#!/usr/bin/env bash
set -e

REPO="$1"
shift

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
FLAGS="$( cat "$DIR/$REPO.flags" )"
PROCESSORS="$( $DIR/processors.sh )"

cd "$REPO"
rm -rf build
mkdir build
cd build

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release $FLAGS $@
make -j$PROCESSORS
make install
