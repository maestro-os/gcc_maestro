# gcc maestro

This repository contains scripts allowing to download sources for binutils, gcc and musl, patch them and compile them to allow cross-compilling for for the Maestro kernel.

The scripts do the following:
- `download.sh`: Downloads sources
- `extract.sh`: Extracts the sources from the downloaded archives
- `patch.sh`: Patches the sources
- `build.sh`: Builds everything
- `clean.sh`: Removes building directories and the resulting installed binaries
