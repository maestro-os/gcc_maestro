#!/bin/bash

export HOST=$(gcc -dumpmachine)
export TARGET=i386-unknown-maestro
export SYSROOT="$(pwd)/toolchain"

tar xf bash.tar.gz
cd bash-5.1.8/
./configure --prefix=/usr \
	--host=$TARGET \
	--build=$HOST \
	--without-bash-malloc
make
make DESTDIR=$SYSROOT install
ln -sv bash $SYSROOT/bin/sh
cd ..
