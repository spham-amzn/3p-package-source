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


# Copy the source folder from the read-only $WORKSPACE/temp/src to $WORKSPACE/src
# since the build process will write/modify the source path
echo "Preparing source folder '$WORKSPACE/src'"
cp -r $WORKSPACE/temp/src $WORKSPACE/ || (echo "Error copying src from $WORKSPACE/temp" && exit 1)

SRC_PATH=$WORKSPACE/src

if [ ! -d ${SRC_PATH} ]
then
    echo "Missing expected source path at ${SRC_PATH}"
    exit 1
fi

BUILD_PATH=$WORKSPACE/build
if [ -d ${BUILD_PATH} ]
then
    rm -rf ${BUILD_PATH}
fi



# Run configure 

pushd ${SRC_PATH}
./configure --enable-debug=no --disable-tcl --enable-shared=no --prefix=$BUILD_PATH --with-pic=yes
if [ $? -ne 0 ]
then
    echo "Unable to configure sqlite" >&2
    exit 1
fi

# Run the make and build
make
if [ $? -ne 0 ]
then
    echo "Unable to build sqlite" >&2
    exit 1
fi

# Install to the build folder
make install
if [ $? -ne 0 ]
then
    echo "Unable to install sqlite (release)" >&2
    exit 1
fi

popd

exit 0
