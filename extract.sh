#!/bin/sh

tar xf binutils.tar.gz
tar xf gcc.tar.gz
tar xf llvm.tar.gz
tar xf musl.tar.gz

mv binutils-2.38 binutils
mv gcc-12.2.0 gcc
mv llvm-project-llvmorg-13.0.1 llvm
mv musl-1.2.2 musl
