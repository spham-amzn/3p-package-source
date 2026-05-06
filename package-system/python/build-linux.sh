#!/bin/bash

#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#

# TEMP_FOLDER and TARGET_INSTALL_ROOT get set from the pull_and_build_from_git.py script

set -euo pipefail

echo "TEMP_FOLDER=${TEMP_FOLDER}"
echo "TARGET_INSTALL_ROOT=${TARGET_INSTALL_ROOT}"

BUILD_FOLDER=${TARGET_INSTALL_ROOT}/python-linux

pushd $TEMP_FOLDER/src

###############################################################################
echo "Configuring CPython for Linux"
###############################################################################
./configure --prefix=${TARGET_INSTALL_ROOT} \
            --enable-optimizations \
            --disable-test-modules \
            --enable-shared LDFLAGS='-Wl,-rpath=\$$ORIGIN:\$$ORIGIN/../lib:\$$ORIGIN/../..'


###############################################################################
echo "Building CPython for Linux"
###############################################################################
make

if [ $? -ne 0 ]
then
    echo "'make' failed for cpython at ${SRC_PATH}"
    exit 1
fi

###############################################################################
echo "Installing CPython for Linux into ${TARGET_INSTALL_ROOT}"
###############################################################################
make install


###############################################################################
echo "Upgrading pip, setuptools, and wheel for the installed Python"
###############################################################################
pushd ${TARGET_INSTALL_ROOT}/bin

PYTHONNOUSERSITE=1 ./python3 -m pip install --upgrade pip --no-warn-script-location

# Update setup tools to resolve https://avd.aquasec.com/nvd/cve-2022-40897
PYTHONNOUSERSITE=1 ./python3 -m pip install setuptools --upgrade setuptools --no-warn-script-location

# Update wheel to resolve https://avd.aquasec.com/nvd/2022/cve-2022-40898/
PYTHONNOUSERSITE=1 ./python3 -m pip install wheel --upgrade wheel --no-warn-script-location

# Fix the shebang line in all installed bin scripts to use the local python
for f in "${TARGET_INSTALL_ROOT}/bin/"*; do
    if [ -f "$f" ] && head -n 1 "$f" | grep -q '^#!'; then
        sed -i '1s+.*+#!/bin/sh+' "$f"
        sed -i '2i\
"exec" "`dirname $0`/python" "$0" "$@"' "$f"
    fi
done

# Rewrite pkgconfig prefix paths to be relative to ${pcfiledir}
for pcfile in "${TARGET_INSTALL_ROOT}/lib/pkgconfig/"*.pc; do
    if [ -f "$pcfile" ]; then
        sed -i 's|^prefix=.*|prefix=${pcfiledir}/../..|' "$pcfile"
    fi
done

echo "Build successful for CPython at ${TARGET_INSTALL_ROOT}"

exit 0

