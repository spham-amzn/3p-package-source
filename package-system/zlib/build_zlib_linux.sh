#!/bin/bash

#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
# 
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

WORKSPACE=/data/workspace

SRC_FOLDER=$WORKSPACE/src

BLD_FOLDER=$WORKSPACE/build

echo Copying SRC
cp -r temp/src $SRC_FOLDER

echo Building zlib
cmake -S $SRC_FOLDER \
      -B $BLD_FOLDER \
      -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_FLAGS=-fPIC \
      -DSKIP_INSTALL_FILES=YES || exit 1

cmake --build $BLD_FOLDER --target zlibstatic --parallel || exit 1
