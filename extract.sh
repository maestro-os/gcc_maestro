#!/bin/sh

tar xf binutils.tar.xz
tar xf llvm.tar.xz
tar xf musl.tar.gz

mv binutils-2.38 binutils
mv llvm-13.0.1.src llvm
mv musl-1.2.2 musl
