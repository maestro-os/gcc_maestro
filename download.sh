#!/bin/sh

wget -O binutils.tar.xz http://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz
wget -O gcc.tar.xz http://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz
wget -O musl.tar.gz https://musl.libc.org/releases/musl-1.2.2.tar.gz

tar xvf binutils.tar.xz
tar xvf gcc.tar.xz
tar xvf musl.tar.gz

mv binutils-2.37 binutils
mv gcc-11.2.0 gcc
mv musl-1.2.2 musl
