#!/bin/sh

# Patching binutils

sed -i 's/^	gnu\* |/	gnu* | maestro* |/' binutils/config.sub
sed -i '/^  i\[3-7\]86-\*-solaris2\*)/i \ \ i[3-7]86-*-maestro*)\n    targ_defvec=i386_elf32_vec\n    targ_selvecs=\n    targ64_selvecs=x86_64_elf64_vec\n    ;;' binutils/bfd/config.bfd
sed -i '/^  i386-\*-elf\*)/a \ \ i386-*-maestro*)			fmt=elf em=gnu ;;' binutils/gas/configure.tgt
sed -i '/^i\[3-7\]86-\*-solaris2\*)/i i[3-7]86-*-maestro*)\n			targ_emul=elf_i386_maestro\n			targ_extra_emuls=elf_i386\n			targ64_extra_emuls="elf_x86_64_maestro elf_x86_64"\n			;;' binutils/ld/configure.tgt

echo '. ${srcdir}/emulparams/elf_i386.sh
GENERATE_SHLIB_SCRIPT=yes
GENERATE_PIE_SCRIPT=yes' >binutils/ld/emulparams/elf_i386_maestro.sh

sed -i '/^	eelf_i386_ldso/a \	eelf_i386_maestro.c \\' binutils/ld/Makefile.am

echo '
eelf_i386_maestro.c: $(srcdir)/emulparams/elf_i386_maestro.sh \
  $(ELF_DEPS) $(srcdir)/scripttempl/elf.sc ${GEN_DEPENDS}
       ${GENSCRIPTS} elf_i386_maestro "$(tdir_elf_i386_maestro)"' >>binutils/ld/Makefile.am

pushd binutils/ld/
autoreconf
automake
popd

# Patching gcc

sed -i 's/^	gnu\* |/	gnu* | maestro* |/' gcc/config.sub
sed -i '/^\*-\*-netbsd\*)/i *-*-maestro*)\n  gas=yes\n  gnu_ld=yes\n  default_use_cxa_atexit=yes\n  use_gcc_stdin=wrap\n  ;;' gcc/gcc/config.gcc
sed -i '/^i\[34567\]86-\*-netbsdelf\*)/i i[34567]86-*-maestro*)\n	tm_file="${tm_file} i386/unix.h i386/att.h dbxelf.h elfos.h glibc-stdint.h i386/i386elf.h maestro.h"\n	;;' gcc/gcc/config.gcc

echo '#undef TARGET_MAESTRO
#define TARGET_MAESTRO 1
 
#undef LIB_SPEC
#define LIB_SPEC "-lc"
 
#undef STARTFILE_SPEC
#define STARTFILE_SPEC "crt0.o%s crti.o%s crtbegin.o%s"
 
#undef ENDFILE_SPEC
#define ENDFILE_SPEC "crtend.o%s crtn.o%s"
 
#undef TARGET_OS_CPP_BUILTINS
#define TARGET_OS_CPP_BUILTINS()      \
  do {                                \
    builtin_define ("__maestro__");      \
    builtin_define ("__unix__");      \
    builtin_assert ("system=maestro");   \
    builtin_assert ("system=unix");   \
    builtin_assert ("system=posix");   \
  } while(0);' >gcc/gcc/config/maestro.h

sed -i '/^  \*-mingw32\*)/i \ \ \*-maestro\*)\n    GLIBCXX_CHECK_COMPILER_FEATURES\n    GLIBCXX_CHECK_LINKER_FEATURES\n    GLIBCXX_CHECK_MATH_SUPPORT\n    GLIBCXX_CHECK_STDLIB_SUPPORT\n    ;;' gcc/libstdc++-v3/crossconfig.m4
sed -i '/^i\[34567\]86-\*-netbsdelf\*)/i i[34567]86-*-maestro*)\n    extra_parts="$extra_parts crti.o crtbegin.o crtend.o crtn.o"\n    tmake_file="$tmake_file i386/t-crtstuff t-crtstuff-pic t-libgcc-pic"\n    ;;' gcc/libgcc/config.host
sed -i '/^case \$machine in/a \ \ \ \ \*-maestro\* | \\' gcc/fixincludes/mkfixinc.sh
