#!/bin/sh

export TARGET=i686-maestro
export SYSROOT="$(pwd)/sysroot"

# Preparing fake system
mkdir -p $SYSROOT/usr/include/



# ------------------------------
#    Stage 1
# ------------------------------

# Building binutils
mkdir binutils-build
cd binutils-build
../binutils/configure --target="$TARGET" --prefix="$SYSROOT/tools" --with-sysroot="$SYSROOT" --disable-nls --disable-werror
make
make install -j1
cd ..

# Building gcc
mkdir gcc-build
cd gcc-build
../gcc/configure --target="$TARGET" --prefix="$SYSROOT/tools" --with-sysroot="$SYSROOT" --enable-languages=c,c++ --with-newlib --without-headers --disable-shared --disable-nls --disable-multilib
make all-gcc
make install-gcc
make all-target-libgcc
make install-target-libgcc
cd ..

# Building musl
cd musl
export PATH="$PATH:$SYSROOT/tools/bin"
./configure --target="$TARGET" --prefix="$SYSROOT/usr" --syslibdir="$SYSROOT/tools/lib"
cp -r include/* $SYSROOT/usr/include/
make
make install
cd ..

# Building libstdc++
mkdir libstdcpp-build
cd libstdcpp-build
../gcc/libstdc++-v3/configure --host="$TARGET" --build="$(gcc -dumpmachine)" --prefix="/usr" --disable-multilib --disable-nls --disable-libstdcxx-pch --with-gxx-include-dir="/tools/$TARGET/include/c++/11.2.0"
make all-target-libstdc++-v3
make install-target-libstdc++-v3
cd ..



# ------------------------------
#    Stage 2
# ------------------------------

# Building binutils
mkdir binutils-build2
cd binutils-build2
../binutils/configure --host="$TARGET" --build="$(gcc -dumpmachine)" --prefix="$SYSROOT/tools" --disable-nls --enable-shared --disable-werror --enable-64-bit-bfd
make
make DESTDIR=$SYSROOT install -j1
install -vm755 libctf/.libs/libctf.so.0.0.0 $SYSROOT/usr/lib
cd ..

# Building gcc
mkdir gcc-build2
cd gcc-build2
../gcc/configure --build="$(gcc -dumpmachine)" --host="$TARGET" --prefix="/usr" CC_FOR_TARGET="${TARGET}-gcc" --with-build-sysroot="$SYSROOT" --enable-initfini-array --enable-languages=c,c++
make all-gcc
make DESTDIR=$SYSROOT install-gcc
make all-target-libgcc
make DESTDIR=$SYSROOT install-target-libgcc
cd ..
