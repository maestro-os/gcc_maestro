#!/bin/sh

export TARGET=i686-maestro
export PREFIX="$SYSROOT/usr"

# Preparing fake system
mkdir -p sysroot/usr/include/
cp -r musl/include/* sysroot/usr/include/

# Building binutils
mkdir binutils-build
cd binutils-build
../binutils/configure --target="$TARGET" --prefix="$PREFIX" --with-sysroot="sysroot/" --disable-werror
make
make install
cd ..

mkdir gcc-build
cd gcc-build
../gcc/configure --target="$TARGET" --prefix="$PREFIX" --with-sysroot="sysroot/" --enable-languages=c,c++
make all-gcc all-target-libgcc
make install-gcc install-target-libgcc
cd ..

# TODO

#cd musl
#make
#make install
#cd ..

#cd gcc-build
#make all-target-libstdc++-v3
#make install-target-libstdc++-v3
#cd ..
