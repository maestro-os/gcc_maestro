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

export CC=clang
export CXXC=clang++

## Building binutils
#mkdir -p binutils-build
#cd binutils-build
#../binutils/configure \
#	--prefix="$SYSROOT/tools" \
#	--with-sysroot="$SYSROOT" \
#	--target="$TARGET" \
#	--disable-nls \
#	--disable-werror
#make -j${JOBS}
#make install -j1
#cd ..
#
#export CFLAGS="--target=${TARGET} -fuse-ld=lld --rtlib=compiler-rt"
#export CXXFLAGS="--target=${TARGET} -fuse-ld=lld --rtlib=compiler-rt"
#
## TODO Add support for shared libc (need compiler_rt)
## Building Musl
#cd musl
#./configure \
#	CROSS_COMPILE=${TARGET}- \
#	--target="$TARGET" \
#	--prefix="/usr" \
#	--disable-shared
#make -j${JOBS}
#make DESTDIR=$SYSROOT install
#cd ..

cd llvm
mkdir -p build
cmake -G Ninja -S runtimes -B build \
	-DLLVM_ENABLE_PROJECTS="clang" \
	-DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
	-DCMAKE_INSTALL_PREFIX=$SYSROOT \
	-DLLVM_RUNTIME_TARGETS="$TARGET"
ninja -C build runtimes
ninja -C build check-runtimes
ninja -C build install-runtimes
cd ..
