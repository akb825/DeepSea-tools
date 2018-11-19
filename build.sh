#!/usr/bin/env bash
set -e

# Perform build in this directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD="$( pwd )"
cd "$DIR"

INSTALL_ARGS=-DCMAKE_INSTALL_PREFIX="$DIR/install"
OUTPUT="$DIR/DeepSea-tools.tar.gz"

function printHelp {
	echo "Usage: `basename "$0"` [options] [CMake args...]"
	echo
	echo "Options:"
	echo "-o, --output <file>          The file to output the archive. Note that the"
	echo "                             archive format will always be .tar.gz regardless of"
	echo "                             the extension."
}

while [ $# -gt 0 ]
do
	case "$1" in
		-h|--help)
			printHelp
			exit 0
			;;
		-o|--output)
			shift
			OUTPUT="$1"
			if [ "${OUTPUT:0:1}" != "/" ]; then
				OUTPUT="$CWD/$OUTPUT"
			fi
			;;
		*)
			CMAKE_ARGS="$CMAKE_ARGS $1"
			;;
	esac
	shift
done

rm -rf install
mkdir install

rm -rf build
mkdir build

pushd "$DIR/build" > /dev/null

REPOS=("Cuttlefish" "ModularShaderLanguage")
for REPO in "${REPOS[@]}"
do
	echo "Building $REPO..."
	"$DIR/scripts/checkout.sh" "$REPO"
	"$DIR/scripts/compile.sh" "$REPO" "$INSTALL_ARGS" $CMAKE_ARGS
done

echo "Creating package \"$OUTPUT\"..."

cd "$DIR/install"

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
rm -rf "$DIR/build"
rm -rf "$DIR/install"

echo "Done"
