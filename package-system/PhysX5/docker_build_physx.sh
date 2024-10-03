#!/bin/bash
#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#


# Validate the bld path input

BUILD_FOLDER=${DOCKER_BUILD_PATH}
if [ "${BUILD_FOLDER}" == "" ]
then
    echo "Missing required build target folder environment"
    exit 1
elif [ "${BUILD_FOLDER}" == "temp" ]
then
    echo "Build target folder environment cannot be 'temp'"
    exit 1
fi


cd $WORKSPACE/vcpkg
if [ $? -ne 0 ]
then
    echo "Folder $WORKSPACE/vcpkg is missing"
    exit 1
fi

./vcpkg install physx:x64-linux --no-binarycaching
if [ $? -ne 0 ]
then
    echo "Failed to build static PhysX libraries"
    exit 1
fi

./vcpkg install physx:x64-linux-shared --no-binarycaching
if [ $? -ne 0 ]
then
    echo "Failed to build static PhysX libraries"
    exit 1
fi

mkdir -p $BUILD_FOLDER

cp $(find $WORKSPACE/vcpkg/buildtrees/physx -name LICENSE.md) $BUILD_FOLDER/
if [ $? -ne 0 ]
then
    echo "Failed to find License file LICENSE.md"
    exit 1
fi

cp $(find $WORKSPACE/vcpkg/buildtrees/physx -name README.md | grep -v externals | grep -v kaplademo) $BUILD_FOLDER/
if [ $? -ne 0 ]
then
    echo "Failed to find README.md"
    exit 1
fi

cp -r /data/workspace/vcpkg/packages/physx_x64-linux $BUILD_FOLDER/static
if [ $? -ne 0 ]
then
    echo "Failed copy over the static libraries to $BUILD_FOLDER/static"
    exit 1
fi

cp -r /data/workspace/vcpkg/packages/physx_x64-linux-shared $BUILD_FOLDER/shared
if [ $? -ne 0 ]
then
    echo "Failed copy over the shared libraries to $BUILD_FOLDER/shared"
    exit 1
fi

echo Build created at $BUILD_FOLDER

exit 0
