#!/bin/sh

sed -i 's/^	gnu\* |/	gnu* | maestro* |/' binutils/config.sub
sed -i '/^  i\[3-7\]86-\*-solaris2\*)/i \ \ i[3-7]86-*-maestro*)\n    targ_defvec=i386_elf32_vec\n    targ_selvecs=\n    targ64_selvecs=x86_64_elf64_vec\n    ;;' binutils/bfd/config.bfd
