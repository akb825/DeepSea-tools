#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/msl.version" )"
PROCESSORS="$( $DIR/processors.sh )"
CHECKOUT=ModularShaderLanguage

rm -rf $CHECKOUT
git clone https://github.com/akb825/$CHECKOUT.git
cd $CHECKOUT
git checkout "v$VERSION"
git submodule init
git submodule update

rm -rf build
mkdir build
cd build

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DMSL_BUILD_TESTS=OFF \
	-DMSL_BUILD_DOCS=OFF -DMSL_SHARED=OFF -DBoost_USE_STATIC_LIBS=ON $@
make -j$(PROCESSORS)
make install
