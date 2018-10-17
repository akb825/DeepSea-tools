#!/bin/sh -e

# Perform build in this directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"

rm -rf install
mkdir install

INSTALL_ARGS=-DCMAKE_INSTALL_PREFIX="$DIR/install"

echo "Building Cuttlefish..."
scripts/build-cuttlefish.sh "$INSTALL_ARGS" $@

echo "Building ModularShaderLanguage..."
scripts/build-msl.sh "$INSTALL_ARGS" $@

OUTPUT="DeepSea-tools.tar.gz"
echo "Creating package \"$OUTPUT\"..."

OUTPUT="$DIR/$OUTPUT"
pushd "$DIR/install" > /dev/null

BIN_FILES=$( ls bin/* )
LIB_FILES=$( ls lib/*.so )
tar -czf "$OUTPUT" $BIN_FILES $LIB_FILES

popd > /dev/null

echo "Cleaning up..."
rm -rf Cuttlefish ModularShaderLanguage install

echo "Done"
