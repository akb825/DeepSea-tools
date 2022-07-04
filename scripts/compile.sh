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

cmake .. -DCMAKE_BUILD_TYPE=Release $FLAGS $@
cmake --build . --config Release -j$PROCESSORS
cmake --build . --config Release --target install
