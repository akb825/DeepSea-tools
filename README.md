# Introduction

DeepSea-tools provides scripts to build the tool dependencies for compiling [DeepSea](https://github.com/akb825/DeepSea). Pre-compiled releases are provided for the following platforms:

* Linux for x86-64 (glibc 2.19 or later)
* macOS
* Windows for x86

This builds the following tools:

* [Cuttlefish](https://github.com/akb825/Cuttlefish): tool to convert images to textures
* [Modular Shader Language](https://github.com/akb825/ModularShaderLanguage): shader compiler

# Dependencies

The following software is required to build DeepSea-tools:

* [cmake](https://cmake.org/) 3.1 or later. This must be in your `PATH`.
* [boost](http://www.boost.org/) This should be in the standard install location so it can be found with CMake.
* [PVRTexTools](https://community.imgtec.com/developers/powervr/tools/pvrtextool/) Optional for PVR support in Cuttlefish. This should be installed in the standard location.

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
