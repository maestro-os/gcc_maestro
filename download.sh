#!/bin/sh

wget -O binutils.tar.xz http://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz
wget -O gcc.tar.xz http://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz

tar xvf binutils.tar.xz
tar xvf gcc.tar.xz

mv binutils-2.37 binutils
mv gcc-11.2.0 gcc
