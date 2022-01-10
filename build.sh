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

# Building gcc
mkdir -p gcc-build
cd gcc-build
../gcc/configure \
	--target="$TARGET" \
	--prefix="$SYSROOT/tools" \
	--with-sysroot="$SYSROOT" \
	--with-newlib \
	--without-headers \
	--enable-initfini-array \
	--disable-nls \
	--disable-multilib \
	--disable-decimal-float \
	--disable-threads \
	--disable-libatomic \
	--disable-libgomp \
	--disable-libquadmath \
	--disable-libssp \
	--disable-libvtv \
	--disable-libstdcxx \
	--enable-languages=c,c++
make -j${JOBS}
make install
cd ..
cat gcc/gcc/limitx.h gcc/gcc/glimits.h gcc/gcc/limity.h >`dirname $($TARGET-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

# Building Musl
cd musl
./configure \
	CROSS_COMPILE=${TARGET}- \
	--target="$TARGET" \
	--prefix="/usr" \
	--disable-shared
make -j${JOBS}
make DESTDIR=$SYSROOT install
cd ..
$SYSROOT/tools/libexec/gcc/$TARGET/11.2.0/install-tools/mkheaders

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
