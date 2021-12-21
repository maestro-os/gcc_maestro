#!/bin/bash

export HOST=$(gcc -dumpmachine)
export TARGET=i386-unknown-maestro
export SYSROOT="$(pwd)/toolchain"

tar xf ncurses.tar.gz
cd ncurses-6.2/
sed -i s/mawk// configure

mkdir build
cd build
../configure
make -C include
make -C progs tic
cd ..

./configure --prefix=/usr \
	--host=$TARGET \
	--build=$HOST \
	--mandir=/usr/share/man \
	--with-manpage-format=normal \
	--with-shared \
	--without-debug \
	--without-ada \
	--without-normal \
	--enable-widec
make
make DESTDIR=$SYSROOT TIC_PATH="$(pwd)/build/progs/tic" install
echo "INPUT(-lncursesw)" >$SYSROOT/usr/lib/libncurses.so
cd ..
