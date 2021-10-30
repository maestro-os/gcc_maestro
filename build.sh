#!/bin/sh

export TARGET=i686-maestro
export SYSROOT="$(pwd)/sysroot"

# Preparing fake system
mkdir -p $SYSROOT/usr/include/

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
../gcc/configure --target="$TARGET" --prefix="$SYSROOT/usr" --with-sysroot="$SYSROOT" --enable-languages=c,c++ --enable-shared
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
cd ..

# Building musl
cd musl
export PATH="$PATH:$SYSROOT/usr/bin"
./configure --target="$TARGET" --prefix="$SYSROOT/usr" --syslibdir="$SYSROOT/lib"
cp -r include/* $SYSROOT/usr/include/
cp -r arch/i386/* $SYSROOT/usr/include/ # TODO Adapt to other arch
make
make install
cd ..

# Building libstdc++
#cd gcc-build
#make all-target-libstdc++-v3
#make install-target-libstdc++-v3
#cd ..
