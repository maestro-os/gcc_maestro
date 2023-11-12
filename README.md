# maestro toolchain

This repository contains scripts allowing to download sources for binutils, gcc and musl, patch them and compile them to allow cross-compilling for for the Maestro kernel.

The scripts do the following:
- `download.sh`: Downloads sources
- `extract.sh`: Extracts the sources from the downloaded archives
- `patch.sh`: Patches the sources
- `build.sh`: Builds everything
- `clean.sh`: Removes building directories and the resulting installed binaries

> **Note**: this repository is meant to be deprecated in the near future. It is here as a placeholder until a cleaner solution replaces it.

The only supported target is `i686-unknown-linux-musl`



## Build toolchain

Type the following command in order to build the toolchain:

```sh
./download.sh
./extract.sh
./build.sh
```

> **Warning**: Since the script builds an entire LLVM toolchain, this process is resource intensive and pretty long (often lasting for several hours, depending on the system's specifications).

The resulting toolchain will be located in the `toolchain/` directory.