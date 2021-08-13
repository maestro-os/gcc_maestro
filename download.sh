#!/bin/sh

wget https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz
wget https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.xz

tar xvf binutils-2.36.tar.xz
tar xvf gcc-10.2.0.tar.xz

mv binutils-2.36 binutils
mv gcc-10.2.0 gcc
