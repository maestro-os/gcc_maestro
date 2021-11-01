#!/bin/sh

export TARGET=i686-maestro
export SYSROOT="$(pwd)/sysroot"

# Preparing fake system
mkdir -p $SYSROOT/usr/include/

# Building binutils
mkdir binutils-build
cd binutils-build
../binutils/configure --target="$TARGET" --prefix="$SYSROOT/usr" --with-sysroot="$SYSROOT" --disable-nls --disable-werror
make
make install -j1
cd ..

# Building gcc
mkdir gcc-build
cd gcc-build
../gcc/configure --target="$TARGET" --prefix="$SYSROOT/usr" --with-sysroot="$SYSROOT" --enable-languages=c,c++ --with-newlib --without-headers --disable-shared --disable-nls --disable-multilib
make all-gcc
make install-gcc
make all-target-libgcc
make install-target-libgcc
cd ..

# Building musl
cd musl
export PATH="$PATH:$SYSROOT/usr/bin"
./configure --target="$TARGET" --prefix="$SYSROOT/usr" --syslibdir="$SYSROOT/lib"
cp -r include/* $SYSROOT/usr/include/
make
make install
cd ..

# Building libstdc++
#cd gcc-build
#make all-target-libstdc++-v3
#make install-target-libstdc++-v3
#cd ..
