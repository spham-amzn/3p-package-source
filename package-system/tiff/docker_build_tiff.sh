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


# Locate the dependent ZLIB package
OPENZLIB_REGEX='(zlib-([A-Za-z0-9\.\-]+)-(linux|linux-aarch64))'
[[ $DOWNLOADED_PACKAGE_FOLDERS =~ $OPENZLIB_REGEX ]]
DEPENDENT_ZLIB=${BASH_REMATCH[1]}

if [ $DEPENDENT_ZLIB == "" ]
then
    echo "Unable to detect dependent zlib package"
    exit 1
fi
DEPENDENT_ZLIB_BASE=$WORKSPACE/temp/${DEPENDENT_ZLIB}/zlib
if [ ! -d ${DEPENDENT_ZLIB_BASE} ]
then
    echo "Unable to detect dependent zlib package at ${DEPENDENT_ZLIB_BASE}"
    exit 1
fi
echo "Detected dependent zlib package at ${DEPENDENT_ZLIB_BASE}"


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

echo "CMake Configure $build_type $lib_type"

cmake -S ${SRC_PATH} -B ${BUILD_PATH} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
      -DCMAKE_C_FLAGS="-fPIC" \
      -DBUILD_SHARED_LIBS=OFF \
      -Djpeg=OFF \
      -Dold-jpeg=OFF \
      -Dpixarlog=OFF \
      -Dlzma=OFF \
      -Dwebp=OFF \
      -Djbig=OFF \
      -Dzstd=OFF \
      -Djpeg12=OFF \
      -Dzlib=ON \
      -Dlibdeflate=OFF \
      -Dcxx=OFF \
      -DCMAKE_MODULE_PATH="$DOWNLOADED_PACKAGE_FOLDERS"
if [ $? -ne 0 ]
then
    echo "Error configuring Tiff project"
    exit 1
fi

cmake --build ${BUILD_PATH} --target tiff --parallel
if [ $? -ne 0 ]
then
    echo "Error building Tiff project"
    exit 1
fi

exit 0
