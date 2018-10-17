#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/cuttlefish.version" )"
PROCESSORS="$( $DIR/processors.sh )"
CHECKOUT=Cuttlefish
echo $DIR

rm -rf $CHECKOUT
git clone https://github.com/akb825/$CHECKOUT.git
cd $CHECKOUT
git checkout "v$VERSION"
git submodule init
git submodule update

rm -rf build
mkdir build
cd build

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCUTTLEFISH_BUILD_TESTS=OFF \
	-DCUTTLEFISH_BUILD_DOCS=OFF -DCUTTLEFISH_SHARED=OFF -DCUTTLEFISH_FORCE_INTERNAL_FREEIMAGE=ON $@
make -j$(PROCESSORS)
make install
