#!/bin/bash

# Exit on fail
set -e

export HOST=$(gcc -dumpmachine)
export TARGET=i386-linux-musl
export SYSROOT="$(pwd)/toolchain"

# The numbers of jobs to run simultaneously
export JOBS=$(($(getconf _NPROCESSORS_ONLN) * 2))

mkdir -p $SYSROOT/tools
mkdir -p $SYSROOT/usr/include

export PATH="$SYSROOT/tools/bin:/bin:/usr/bin"
export CONFIG_SITE=$SYSROOT/usr/share/config.site
export LC_ALL=POSIX
set +h
umask 022

# ------------------------------
#    Stage 1
# ------------------------------

# Building binutils
mkdir -p binutils-build
cd binutils-build
../binutils/configure \
	--prefix="$SYSROOT/tools" \
	--with-sysroot="$SYSROOT" \
	--target="$TARGET" \
	--disable-nls \
	--disable-werror
make -j${JOBS}
make install -j1
cd ..

export CC=clang
export CFLAGS="--target=${TARGET}"

# Building Musl
cd musl
./configure \
	--target="$TARGET" \
	--prefix="/usr"
make -j${JOBS}
make DESTDIR=$SYSROOT install
cd ..

# Building libstdc++
mkdir -p libstdc++-build
cd libstdc++-build
../gcc/libstdc++-v3/configure \
    --host="$TARGET" \
    --build="$HOST" \
    --prefix="/usr" \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=/tools/${TARGET}/include/c++/11.2.0
make
make DESTDIR=$SYSROOT install
cd ..
