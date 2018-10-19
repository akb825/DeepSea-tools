#!/usr/bin/env bash
set -e

# Perform build in this directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"

rm -rf install
mkdir install

INSTALL_ARGS=-DCMAKE_INSTALL_PREFIX="$DIR/install"

REPOS=("Cuttlefish" "ModularShaderLanguage")
for REPO in "${REPOS[@]}"
do
	echo "Building $REPO..."
	scripts/checkout.sh "$REPO"
	scripts/compile.sh "$REPO" "$INSTALL_ARGS" $@
done

OUTPUT="DeepSea-tools.tar.gz"
echo "Creating package \"$OUTPUT\"..."

OUTPUT="$DIR/$OUTPUT"
pushd "$DIR/install" > /dev/null

if [ "$(uname)" = "Darwin" ]; then
	LIB_EXT="dylib"
else
	LIB_EXT="so"
fi

BIN_FILES=$( ls bin/* )
if ls lib/*.$LIB_EXT 2>&1 > /dev/null; then
	LIB_FILES=$( ls lib/*.$LIB_EXT )
else
	LIB_FILES=
fi
tar czf "$OUTPUT" $BIN_FILES $LIB_FILES

popd > /dev/null

echo "Cleaning up..."
for REPO in "${REPOS[@]}"
do
	rm -rf "$REPO"
done
rm -rf install

echo "Done"
