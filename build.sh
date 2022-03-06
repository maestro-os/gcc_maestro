#!/bin/bash

# Exit on fail
set -e

export HOST=$(gcc -dumpmachine)
#export TARGET=i386-unknown-maestro
export TARGET=i686-unknown-linux-musl
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

# Building Musl
cd musl
./configure \
	CROSS_COMPILE=${TARGET}- \
	--target="$TARGET" \
	--prefix="/usr"
make -j${JOBS}
make DESTDIR=$SYSROOT install
cd ..
#$SYSROOT/tools/libexec/gcc/$TARGET/11.2.0/install-tools/mkheaders
