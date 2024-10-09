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

if [ "${BUILD_ARCHITECTURE}" == "amd64" ]
then
    echo "Building for amd64"
    PRESET=linux
    BIN_FOLDER=linux.clang
else
    echo "Building for aarch64"
    PRESET=linux-aarch64
    BIN_FOLDER=linux.aarch64
fi


cd $WORKSPACE/src
if [ $? -ne 0 ]
then
    echo "Folder $WORKSPACE/src is missing"
    exit 1
fi

# Initialize packman
pushd physx/buildtools/packman
./packman update -y
if [ $? -ne 0 ]
then
    echo "Packman bootstrap failed"
    popd
    exit 1
fi
popd

# Generate the project
pushd physx
./generate_projects.sh $PRESET
if [ $? -ne 0 ]
then
    echo "Generate project failed"
    popd
    exit 1
fi
popd


# Build static libraries
echo "Building static libraries"


cmake --build $WORKSPACE/src/physx/compiler/linux-release --target install
if [ $? -ne 0 ]
then
    echo "Build release failed"
    exit 1
fi


cmake --build $WORKSPACE/src/physx/compiler/linux-profile
if [ $? -ne 0 ]
then
    echo "Build profile failed"
    exit 1
fi

cmake --build $WORKSPACE/src/physx/compiler/linux-checked
if [ $? -ne 0 ]
then
    echo "Build checked failed"
    exit 1
fi

cmake --build $WORKSPACE/src/physx/compiler/linux-debug
if [ $? -ne 0 ]
then
    echo "Build debug failed"
    exit 1
fi

# Prepare the build folder

mkdir -p $WORKSPACE/build
mkdir -p $WORKSPACE/build/bin
cp -r $WORKSPACE/src/physx/bin/${BIN_FOLDER} $WORKSPACE/build/bin/static
cp -r $WORKSPACE/src/physx/install/${PRESET}/PhysX/include $WORKSPACE/build/include

mkdir -p $WORKSPACE/build/source/source/fastxml
cp -r $WORKSPACE/src/physx/source/fastxml/include $WORKSPACE/build/source/fastxml/
cp $WORKSPACE/src/physx/README.md $WORKSPACE/build/
cp $WORKSPACE/src/physx/version.txt $WORKSPACE/build/

echo Build created at $BUILD_FOLDER

exit 0
