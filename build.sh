#!/bin/sh

export TARGET=i686-maestro
export PREFIX='/usr'

# Preparing fake system
mkdir -p sysroot/usr/include/
cp -r musl/include/* sysroot/usr/include/

# Building binutils
mkdir binutils-build
pushd binutils-build
../binutils/configure --target="$TARGET" --prefix="$PREFIX" --with-sysroot="sysroot/" --disable-werror
make
make install
popd

mkdir gcc-build
pushd gcc-build
../gcc/configure --target="$TARGET" --prefix="$PREFIX" --with-sysroot="sysroot/" --enable-languages=c,c++
make all-gcc all-target-libgcc
make install-gcc install-target-libgcc
popd

# TODO

#pushd musl
#make
#make install
#popd

#pushd gcc-build
#make all-target-libstdc++-v3
#make install-target-libstdc++-v3
#popd
