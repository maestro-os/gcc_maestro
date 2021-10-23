#!/bin/sh

export TARGET=i686-maestro
export SYSROOT="$(pwd)/sysroot"

# Preparing fake system
mkdir -p $SYSROOT/usr/include/
cp -r musl/include/* $SYSROOT/usr/include/

# Building musl
cd musl
./configure --sysroot="$SYSROOT" --prefix="$SYSROOT/usr" --syslibdir="$SYSROOT/lib"
make
make install
cd ..

# Building binutils
mkdir binutils-build
cd binutils-build
../binutils/configure --target="$TARGET" --prefix="$SYSROOT/usr" --with-sysroot="$SYSROOT" --disable-werror
make
make install
cd ..

# Building gcc
mkdir gcc-build
cd gcc-build
../gcc/configure --target="$TARGET" --prefix="$SYSROOT/usr" --with-sysroot="$SYSROOT" --enable-languages=c,c++
make all-gcc all-target-libgcc
make install-gcc install-target-libgcc
cd ..

# Building libstdc++
#cd gcc-build
#make all-target-libstdc++-v3
#make install-target-libstdc++-v3
#cd ..
