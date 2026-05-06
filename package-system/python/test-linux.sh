#!/bin/bash

# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
set -euo pipefail

SCRIPT_PATH="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
TEMP_DIR=$SCRIPT_PATH/temp
BUILD_DIR=$TEMP_DIR/python-linux

echo Quick Python Sanity Test

pushd $BUILD_DIR/python/bin

# Version check to ensure python is working and the expected version
./python3 --version

# Validate basic imports
./python3 $SCRIPT_PATH/quick_validate_python.py

echo "Python sanity test passed successfully"

exit 0
