#!/bin/sh

# Exit on fail
set -e

export HOST=$(gcc -dumpmachine)
export TARGET=i386-unknown-maestro
export SYSROOT="$(pwd)/toolchain"

# The numbers of jobs to run simultaneously
export JOBS=$(getconf _NPROCESSORS_ONLN)

mkdir -p $SYSROOT/tools
mkdir -p $SYSROOT/usr/include

export PATH="$PATH:$SYSROOT/tools/bin"



# ------------------------------
#    Stage 1
# ------------------------------

## Building binutils
#mkdir -p binutils-build
#cd binutils-build
#../binutils/configure \
#	--prefix="$SYSROOT/tools" \
#	--with-sysroot="$SYSROOT" \
#	--target="$TARGET" \
#	--disable-nls \
#	--disable-werror
#make configure-host -j${JOBS}
#make -j${JOBS}
#make install
#cd ..
#
## Building gcc
#mkdir -p gcc-build
#cd gcc-build
#../gcc/configure \
#	--prefix="$SYSROOT/tools" \
#	--target="$TARGET" \
#	--with-sysroot="$SYSROOT" \
#	--with-newlib \
#	--without-headers \
#	--enable-initfini-array \
#	--disable-nls \
#	--disable-shared \
#	--disable-multilib \
#	--disable-decimal-float \
#	--disable-threads \
#	--disable-libatomic \
#	--disable-libgomp \
#	--disable-libquadmath \
#	--disable-libssp \
#	--disable-libvtv \
#	--disable-libstdcxx \
#	--enable-languages=c,c++
#make
#make install
#cd ..

# Building Musl
cd musl
./configure \
	CROSS_COMPILE=${TARGET}- \
	--target=$TARGET \
	--prefix="/usr" \
	--disable-shared
make -j${JOBS}
make DESTDIR=$SYSROOT install
cd ..



# ------------------------------
#    Stage 2
# ------------------------------

## Building binutils
#mkdir -p binutils-build2
#cd binutils-build2
#../binutils/configure \
#	--prefix="/usr" \
#	--build="$HOST" \
#	--host="$TARGET" \
#	--disable-nls \
#	--enable-shared \
#	--disable-werror \
#	--enable-64-bit-bfd
#make -j${JOBS}
#make DESTDIR=$SYSROOT install -j1
#cd ..
#
#mkdir -p gcc-build2
#cd gcc-build2
#../gcc/configure \
#	--prefix="$SYSROOT" \
#	--build="$HOST" \
#	--host="$HOST" \
#	--target="$TARGET" \
#	--with-build-sysroot="$SYSROOT" \
#	--enable-initfini-array \
#    --disable-nls \
#    --disable-multilib \
#    --disable-decimal-float \
#    --disable-libatomic \
#    --disable-libgomp \
#    --disable-libquadmath \
#    --disable-libssp \
#    --disable-libvtv \
#    --disable-libstdcxx \
#    --enable-languages=c,c++
##make AS_FOR_TARGET="${TARGET}-as" LD_FOR_TARGET="${TARGET}-ld" -j${JOBS} all-gcc
##make AS_FOR_TARGET="${TARGET}-as" LD_FOR_TARGET="${TARGET}-ld" -j${JOBS} all-target-libgcc
##make install-gcc
##make install-target-libgcc
#make -j${JOBS}
#make DESTDIR=$SYSROOT install
#cd ..

# TODO Build libstdc++?
