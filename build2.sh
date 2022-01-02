#!/bin/sh

# Exit on fail
set -e

export HOST=$(gcc -dumpmachine)
export TARGET=$(gcc -dumpmachine | sed 's/-/-cross-/')
export SYSROOT="$(pwd)/toolchain"

# The numbers of jobs to run simultaneously
export JOBS=$(getconf _NPROCESSORS_ONLN)

# ------------------------------
#    Stage 2
# ------------------------------

# Building binutils
mkdir -p binutils-build2
cd binutils-build2
../binutils/configure \
	--prefix=/usr \
	--build=$HOST \
	--host=$TARGET \
	--disable-nls \
	--enable-shared \
	--disable-werror \
	--enable-64-bit-bfd
make -j${JOBS}
make DESTDIR=$SYSROOT install -j1
install -vm755 libctf/.libs/libctf.so.0.0.0 $SYSROOT/usr/lib
cd ..

mkdir -p gcc-build2
cd gcc-build2
mkdir -p $SYSROOT/libgcc
ln -s ../gcc/libgcc/gthr-posix.h $SYSROOT/libgcc/gthr-default.h
../gcc/configure \
	--prefix=/usr \
	--build=$HOST \
	--host=$TARGET \
	--target=$TARGET \
	--with-build-sysroot=$SYSROOT \
	CC_FOR_TARGET=${TARGET}-gcc \
	--enable-initfini-array \
    --disable-nls \
    --disable-multilib \
    --disable-decimal-float \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --enable-languages=c,c++
make -j${JOBS}
make DESTDIR=$SYSROOT install
ln -sv gcc $SYSROOT/usr/bin/cc
cd ..

# TODO Build libstdc++?
