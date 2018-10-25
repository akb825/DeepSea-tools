# Introduction

DeepSea-tools provides scripts to build the tool dependencies for compiling [DeepSea](https://github.com/akb825/DeepSea). Pre-compiled releases are provided for the following platforms:

* Linux for x86-64 (glibc 2.19 or later)
* macOS (10.11 or later)
* Windows for x86

This builds the following tools:

* [Cuttlefish](https://github.com/akb825/Cuttlefish): tool to convert images to textures
* [Modular Shader Language](https://github.com/akb825/ModularShaderLanguage): shader compiler

# Dependencies

The following software is required to build DeepSea-tools:

* [cmake](https://cmake.org/) 3.1 or later. This must be in your `PATH`.
* [boost](http://www.boost.org/) This should be in the standard install location so it can be found with CMake.
* [PVRTexTools](https://community.imgtec.com/developers/powervr/tools/pvrtextool/) Optional for PVR support in Cuttlefish. This should be installed in the standard location.
* [7zip](https://www.7-zip.org/) is required on Windows.

# Compiling

Scripts are provided to perform the compilation on various platforms.

## Linux and macOS

Make sure the development tools and dependencies are installed.

For example, on Ubuntu the following packages should be installed:

* cmake
* build-essential
* libboost-all-dev

For macOS using [Homebrew](https://brew.sh/), the following packages should be installed:

* cmake
* boost

To perform the build, simply run the `build.sh` script. Additional CMake options can be passed in as command line options, such as for cross-compiling for other systems. Once finished, the `DeepSea-tools.tar.gz` package will contain the tools.

> **Note:** If you want to keep a script around for custom arguments without checking it into source control, create a script named `build-custom.sh`. This is in `.gitignore` so it won't show as a locally modified file.

## Windows

The default setup for Windows is to build with Visual Studio 2017 using the v140 toolset. (i.e. Visual Studio 2015 toolset, but from the Visual Studio 2017 installer) It's assumed that [Git for Windows](https://git-scm.com/) is installed in `C:\\Program Files\\Git`, which is the default if you install for the same architecture as your Windows install. (i.e. use the 64-bit installer when using 64-bit Windows)

If Boost is installed such that it's visible from CMake (typically by putting the library folder on `PATH`), the `build.bat` script can be used directly. Otherwise a custom `build-custom.bat` script can be used to specify the path with the `BOOST_LIBRARYDIR` CMake variable. Note that the 32-bit tools are built by default, so the 32-bit version of Boost should be used unless it's overridden.

# Example custom build scripts

Custom build scripts can be used to control the version of the compiler used. For example, to use a newer compiler or support older systems.

## Linux

On Linux, it's recommended to build on as old of a system as possible (such as within a virtual machine) to support older versions of `glibc`. However, if you want to use the PVRTexTool library to have PVR texture support, you will need GCC 4.9 or higher.

For example, if you use Ubuntu 14.04 to compile the tools, you can use the [test toolchain PPA](https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test) to obtain GCC 4.9. From there, you can use the following `build-custom.sh` script:

	#!/bin/sh
	set -e
	./build.sh -DCMAKE_C_COMPILER=gcc-4.9 -DCMAKE_CXX_COMPILER=g++-4.9 -o DeepSea-tools-linux.tar.gz

## macOS

In order to support earlier than the current version of macOS (such as back in the ye olde days when it was still called Mac OS X), you need to download an older version of XCode. You can download rather old versions of XCode from Apple's developer website, though it's quite limited how far back will actually run on a modern system. When running macOS 10.14, the furthest back I could go is XCode 7.3.1. This would allow building against the Mac OS X 10.11 SDK.

In order to use an older version of XCode, download it, rename `XCode.app` to a different name (e.g. `XCode-7.3.1.app`), and move it to `/Applicatons`. You should also run it in order to make sure the command line tools are installed.

Once an older version is installed, a `build-custom.sh` such as the following can be used:

	#!/bin/sh
	set -e
	export DEVELOPER_DIR=/Applications/Xcode-7.3.1.app/Contents/Developer
	./build.sh -DCMAKE_OSX_SYSROOT=$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -o DeepSea-tools-mac.tar.gz
	
## Windows

Windows is configured to create the 32-bit build by default. If your system is set up to find the 64-bit boost by default, you may need to have build `build-custom.bat` file to set the path for the 32-bit libraries. An example is:

	@echo off
	.\build.bat "-DBOOST_LIBRARYDIR=C:\local\boost_1_68_0\lib32-msvc-14.0"
