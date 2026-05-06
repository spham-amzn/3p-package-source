#!/bin/bash

# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT

# Install the python build artifacts 

set -euo pipefail

SCRIPT_PATH="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
echo "Installing python build artifacts to ${TARGET_INSTALL_ROOT}"

cp -v "$SCRIPT_PATH/python-config-version.cmake" "${TARGET_INSTALL_ROOT}/../python-config-version.cmake"
cp -v "$SCRIPT_PATH/python-config.cmake.linux" "${TARGET_INSTALL_ROOT}/../python-config.cmake"

exit 0
