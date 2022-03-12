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
export CXX=clang++

# Building binutils
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

export CFLAGS="--target=${TARGET} -fuse-ld=lld --rtlib=compiler-rt"
export CXXFLAGS="--target=${TARGET} -fuse-ld=lld --rtlib=compiler-rt"

# Building Musl
#cd musl
#./configure \
#	--target="$TARGET" \
#	--prefix="/usr"
#make -j${JOBS}
#make DESTDIR=$SYSROOT install
#cd ..

unset CFLAGS
unset CXXFLAGS

# Building libc++
#cd llvm
#rm -rf build
#mkdir -p build
#cmake \
#	-G Ninja \
#	-S runtimes \
#	-B build \
#	-DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
#	-DCMAKE_INSTALL_PREFIX="$SYSROOT" \
#	-DCMAKE_C_COMPILER="/bin/clang" \
#	-DCMAKE_CXX_COMPILER="/bin/clang++" \
#	-DCMAKE_C_COMPILER_TARGET="$TARGET" \
#	-DCMAKE_CXX_COMPILER_TARGET="$TARGET" \
#	#-DCMAKE_SYSROOT="$SYSROOT"
#ninja -C build cxx cxxabi unwind
#ninja -C build install-cxx install-cxxabi install-unwind
#cd ..

# Building clang and lld
#mkdir -p clang-build
#cd clang-build
#cmake ../llvm/llvm -G Ninja -DLLVM_ENABLE_PROJECTS="lld;clang" \
#	-DCMAKE_BUILD_TYPE=Release \
#	-DLLVM_PARALLEL_COMPILE_JOBS=$JOBS \
#	-DLLVM_PARALLEL_LINK_JOBS=1 \
#	-DLLVM_TARGETS_TO_BUILD=X86 \
#	-DCMAKE_INSTALL_PREFIX="$SYSROOT"
#ninja -j$JOBS
#ninja -j$JOBS install
#cd ..

# Building libc++
#mkdir -p libc++-build
#cd llvm
#cmake -G Ninja -S runtimes -B ../libc++-build \
#	-DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
#	-DLIBCXX_USE_COMPILER_RT=OFF \
#	-DCMAKE_C_COMPILER="$SYSROOT/bin/clang" \
#	-DCMAKE_CXX_COMPILER="$SYSROOT/bin/clang++" \
#	-DCMAKE_ASM_COMPILER_TARGET="$TARGET" \
#	-DCMAKE_C_COMPILER_TARGET="$TARGET" \
#	-DCMAKE_CXX_COMPILER_TARGET="$TARGET" \
#	-DCMAKE_CXX_FLAGS="-nostdlib++" \
#	-DCMAKE_INSTALL_PREFIX=$SYSROOT
#cd ../libc++-build
#ninja cxx cxxabi unwind
#ninja install-cxx install-cxxabi install-unwind
#cd ..

# Building compiler-rt
mkdir -p compiler-rt-build
cd compiler-rt-build
cmake ../llvm/compiler-rt \
	-G Ninja \
	-DCMAKE_C_COMPILER="$SYSROOT/bin/clang" \
	-DCMAKE_CXX_COMPILER="$SYSROOT/bin/clang++" \
	-DLLVM_CONFIG_PATH="$SYSROOT/bin/llvm-config" \
	-DCMAKE_ASM_COMPILER_TARGET="$TARGET" \
	-DCMAKE_C_COMPILER_TARGET="$TARGET" \
	-DCMAKE_CXX_COMPILER_TARGET="$TARGET" \
	-DCMAKE_ASM_FLAGS="-fuse-ld=lld" \
	-DCMAKE_C_FLAGS="-fuse-ld=lld" \
	-DCMAKE_CXX_FLAGS="-fuse-ld=lld -stdlib=libc++" \
	-DCMAKE_EXE_LINKER_FLAGS="-v" \
	-DCOMPILER_RT_BAREMETAL_BUILD=ON \
	-DCOMPILER_RT_BUILD_BUILTINS=ON \
	-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
	-DCOMPILER_RT_BUILD_MEMPROF=OFF \
	-DCOMPILER_RT_BUILD_PROFILE=OFF \
	-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
	-DCOMPILER_RT_BUILD_XRAY=OFF \
	-DCOMPILER_RT_BUILD_ORC=ON \
	-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
	-DCOMPILER_RT_BUILTINS_ENABLE_PIC=OFF \
	-DCMAKE_INSTALL_PREFIX=$SYSROOT
ninja -j$JOBS
ninja -j$JOBS install
cd ..
