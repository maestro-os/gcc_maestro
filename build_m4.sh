#!/bin/bash

export HOST=$(gcc -dumpmachine)
export TARGET=i386-unknown-maestro
export SYSROOT="$(pwd)/toolchain"

tar xf m4.tar.xz
cd m4-1.4.19/
./configure --prefix=/usr \
	--host=$TARGET \
	--build=$HOST
make
make DESTDIR=$SYSROOT install
cd ..
