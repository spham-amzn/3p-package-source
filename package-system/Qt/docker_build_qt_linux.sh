#!/bin/bash

#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#

# TEMP_FOLDER and TARGET_INSTALL_ROOT get set from the pull_and_build_from_git.py script

# Arg 1: The tiff package name
QCB_TYPE=$1

# Read the dependent 3P library paths from the arguments
TIFF_PACKAGE_DIR=/data/workspace/o3de_tiff
ZLIB_PACKAGE_DIR=/data/workspace/o3de_zlib
OPENSSL_PACKAGE_DIR=/data/workspace/o3de_openssl

set -euo pipefail

MAKE_FLAGS=-j32

echo "Building Qt5 from source with dependencies on"
echo "    " $TIFF_PACKAGE_DIR
echo "    " $ZLIB_PACKAGE_DIR
echo "    " $OPENSSL_PACKAGE_DIR


# Base the Tiff of the dependent tiff O3DE package (static)
TIFF_PREFIX=$TIFF_PACKAGE_DIR/tiff
TIFF_INCDIR=$TIFF_PREFIX/include
TIFF_LIBDIR=$TIFF_PREFIX/lib

# Bring in the zlib dependency since Tiff is a static lib dependency
ZLIB_PREFIX=$ZLIB_PACKAGE_DIR/zlib
ZLIB_INCDIR=$ZLIB_PREFIX/include
ZLIB_LIBDIR=$ZLIB_PREFIX/lib

# Bring in the openssl dependency based 
OPENSSL_PREFIX=$OPENSSL_PACKAGE_DIR/OpenSSL
OPENSSL_INCDIR=$OPENSSL_PREFIX/include
OPENSSL_LIBDIR=$OPENSSL_PREFIX/lib

BUILD_PATH=/data/workspace/build
INSTALL_PATH=/data/workspace/qt

[[ -d $BUILD_PATH ]] || mkdir $BUILD_PATH
cd $BUILD_PATH

if [ $QCB_TYPE == "xcb" ]
then
    echo "Configuring Qt for xcb..."
    ../src/configure -prefix ${INSTALL_PATH} \
                     -opensource \
                     -nomake examples \
                     -nomake tests \
                     -confirm-license \
                     -no-icu \
                     -dbus \
                     -no-separate-debug-info \
                     -release \
                     -force-debug-info \
                     -qt-libpng \
                     -qt-libjpeg \
                     -no-feature-vnc \
                     -no-feature-linuxfb \
                     --tiff=system \
                     -qt-zlib \
                     -v \
                     -no-cups \
                     -no-glib \
                     -no-feature-renameat2 \
                     -no-feature-getentropy \
                     -no-feature-statx \
                     -no-egl \
                     -qpa xcb \
                     -xcb-xlib \
                     -openssl \
                     -I $TIFF_INCDIR \
                     -I $ZLIB_INCDIR \
                     -I $OPENSSL_INCDIR \
                     -L $TIFF_LIBDIR \
                     -L $ZLIB_LIBDIR \
                     -L $OPENSSL_LIBDIR \
                     -c++std c++1z \
                     -fontconfig

elif [ $QCB_TYPE == "wayland" ]
then
    echo "Configuring Qt for wayland..."
    ../src/configure -prefix ${INSTALL_PATH} \
                     -opensource \
                     -nomake examples \
                     -nomake tests \
                     -confirm-license \
                     -no-icu \
                     -dbus \
                     -no-separate-debug-info \
                     -release \
                     -force-debug-info \
                     -qt-libpng \
                     -qt-libjpeg \
                     -no-feature-vnc \
                     -no-feature-linuxfb \
                     --tiff=system \
                     -qt-zlib \
                     -v \
                     -no-cups \
                     -no-glib \
                     -no-feature-renameat2 \
                     -no-feature-getentropy \
                     -no-feature-statx \
                     -no-egl \
                     -feature-wayland-server \
                     -qpa wayland \
                     -I $TIFF_INCDIR \
                     -I $ZLIB_INCDIR \
                     -I $OPENSSL_INCDIR \
                     -L $TIFF_LIBDIR \
                     -L $ZLIB_LIBDIR \
                     -L $OPENSSL_LIBDIR \
                     -c++std c++1z \
                     -fontconfig
else
    echo "Missing 'xcb' or 'wayland' argument"
    exit 1
fi


if [ $? -ne 0 ]
then
    echo "Failed to configure Qt"
    exit 1
fi


echo Qt configured, building modules...
qtarray=(qtbase qtgraphicaleffects qtimageformats qtsvg qttools qtx11extras)

for qtlib in "${qtarray[@]}"; do
    echo Building $qtlib...
    make module-$qtlib $MAKE_FLAGS

    if [ $? -ne 0 ]
    then
        echo "Failed building Qt module $qtlib"
        exit 1
    fi

    echo Built $qtlib.
done

echo Finished building modules, installing...
for qtlib in "${qtarray[@]}"; do
    echo Installing $qtlib...
    make module-$qtlib-install_subtargets
    
    if [ $? -ne 0 ]
    then
        echo "Failed installing Qt module $qtlib"
        exit 1
    fi

    echo $qtlib installed.
done

echo Qt installed successfully!
