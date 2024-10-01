#!/bin/bash
#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#


echo "TEMP_FOLDER=${TEMP_FOLDER}"
echo "TARGET_INSTALL_ROOT=${TARGET_INSTALL_ROOT}"

SRC_PACKAGE_BASE=${TEMP_FOLDER}/build

# Copy over the package 
cp -r ${SRC_PACKAGE_BASE}/* $TARGET_INSTALL_ROOT/

echo "Custom Install for PhysX successful"

exit 0
