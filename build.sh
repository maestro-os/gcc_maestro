#!/bin/sh

# Exit on fail
set -e

export HOST=$(gcc -dumpmachine)
export TARGET=i686-maestro
export SYSROOT="$(pwd)/toolchain"

# The numbers of jobs to run simultaneously
export JOBS=4

mkdir -p $SYSROOT/tools
mkdir -p $SYSROOT/usr/include

export PATH="$PATH:$SYSROOT/tools/bin"



# ------------------------------
#    Stage 1
# ------------------------------

# Building binutils
#mkdir -p binutils-build
#cd binutils-build
#../binutils/configure \
#	--prefix="$SYSROOT/tools" \
#	--target="$TARGET" \
#	--with-sysroot="$SYSROOT/tools" \
#	--disable-nls \
#	--disable-multilib \
#	--disable-werror \
#	--enable-deterministic-archives \
#	--disable-compressed-debug-sections
#make configure-host -j${JOBS}
#make -j${JOBS}
#make install -j1
#cd ..

# Building gcc
#mkdir -p gcc-build
#cd gcc-build
#../gcc/configure \
#	--prefix="$SYSROOT/tools" \
#	--build="$HOST" \
#	--host="$HOST" \
#	--target="$TARGET" \
#	--with-sysroot="$SYSROOT/tools" \
#	--disable-nls \
#	--with-newlib \
#	--disable-libitm \
#	--disable-libvtv \
#	--disable-libssp \
#	--disable-shared \
#	--disable-libgomp \
#	--without-headers \
#	--disable-threads \
#	--disable-multilib \
#	--disable-libatomic \
#	--disable-libstdcxx \
#	--enable-languages=c \
#	--disable-libquadmath \
#	--disable-libsanitizer \
#	--disable-decimal-float \
#	--enable-clocale=generic
#make all-gcc -j${JOBS}
#make all-target-libgcc -j${JOBS}
#make install-gcc
#make install-target-libgcc
#cd ..

# Building Musl
cd musl
./configure \
	CROSS_COMPILE=${TARGET}- \
	--prefix=/usr \
	--target=$TARGET
make -j${JOBS}
make DESTDIR=$SYSROOT install
cd ..



# ------------------------------
#    Stage 2
# ------------------------------

mkdir -p gcc-build2
export CFLAGS="-I/usr/include"
cd gcc-build2
../gcc/configure \
	--prefix="$SYSROOT/usr" \
	--build="$HOST" \
	--host="$HOST" \
	--target="$TARGET" \
	--with-sysroot="$SYSROOT" \
	--disable-multilib \
	--disable-nls \
	--enable-shared \
	--enable-languages=c,c++ \
	--enable-threads=posix \
	--enable-clocale=generic \
	--enable-libstdcxx-time \
	--enable-fully-dynamic-string \
	--disable-symvers \
	--disable-libsanitizer \
	--disable-lto-plugin \
	--disable-libssp
make -j${JOBS}
make install
cd ..

# TODO Build libstdc++?
