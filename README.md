# Introduction

DeepSea-tools provides scripts to build the tool dependencies for compiling [DeepSea](https://github.com/akb825/DeepSea). Pre-compiled releases are provided for the following platforms:

* Linux for x86-64 (glibc 2.27 or later, e.g. Ubuntu 18.04)
* macOS for x86-64 (10.13 or later)
* Windows for x86

> **Note:** macOS binaries for arm64 aren't currently built. There are two limitations for this:
>
> 1. arm64 VMs aren't currently available through Azure DevOps, meaning that dependencies like boost would need to be built from scratch.
> 2. PVRTexTool library doesn't provide arm64 binaries for arm64, meaning PVRTC can't be supported.

This builds the following tools:

* [Cuttlefish](https://github.com/akb825/Cuttlefish): tool to convert images to textures
* [Modular Shader Language](https://github.com/akb825/ModularShaderLanguage): shader compiler
* [Vertex Format Convert](https://github.com/akb825/VertexFormatConvert): tool to convert between vertex formats

# Dependencies

The following software is required to build DeepSea-tools:

* [cmake](https://cmake.org/) 3.1 or later. This must be in your `PATH`.
* [Python](https://www.python.org/) 3 or later. This must be in your `PATH`.
* [boost](https://www.boost.org/) This should be in the standard install location so it can be found with CMake.
* [7zip](https://www.7-zip.org/) is required on Windows.

[![Build Status](https://dev.azure.com/akb825/DeepSea/_apis/build/status/akb825.DeepSea-tools?branchName=master)](https://dev.azure.com/akb825/DeepSea/_build/latest?definitionId=3&branchName=master)

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

> **Note:** Boost provides [prebuilt Windows binaries](https://sourceforge.net/projects/boost/files/boost-binaries/) that can be installed. However, you may find that the download never finishes after reaching 100%, and even if you manage to get the download completed, any file operations on the installer simply don't work. This is because Windows Defender attempts to inspect the package, which contains hundreds of thousands of files, and I haven't been patient enough to measure just how long it will take. (but it's likely on the order of hours) If you choose to install these packages, you will most likely need to disable Windows Defender live protection temporarily, though keep in mind there is some risk in doing so if you don't trust the packages.

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

In order to find Boost and compile the proper platform by default, you may need to have a `build-custom.bat` file to set the proper parameters. An example is:

	@echo off
	.\build.bat "-DBOOST_LIBRARYDIR^=C:\local\boost_1_68_0\lib32-msvc-14.0" -A Win32 -o DeepSea-tools-win32.zip

> **Note:** Both the quotes surrounding the -DBOOST_LIBRARYDIR argument and the '^' escape character for '=' are required for the command line arguments to be properly forwarded.

