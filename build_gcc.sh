#!/bin/bash

# Exit on fail
set -e

export HOST=$(gcc -dumpmachine)
export TARGET=i686-unknown-linux-musl

export SYSROOT="$(pwd)/toolchain"

# The numbers of jobs to run simultaneously
export JOBS=$(($(getconf _NPROCESSORS_ONLN) * 2))

export 

mkdir gcc-build
cd gcc-build
../gcc/configure     \
	--prefix=/usr    \
	--build=$HOST    \
	--host=$HOST     \
	--target=$TARGET \
	--disable-nls    \
	--disable-werror
make -j${JOBS}
make DESTDIR=$SYSROOT install
cd ..
