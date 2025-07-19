#!/bin/bash

# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#

# Resolve the script's directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$( readlink "$SOURCE" )"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
ROOT_PATH="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Get the package name from the first argument
PACKAGE_NAME=$1
if [ -z "$PACKAGE_NAME" ]; then
	echo "Error: Package name is required."
	exit 1
fi

# Make sure the submodule was cloned as well
if [ ! -d "$ROOT_PATH/Scripts/core" ]; then
    echo "Error: The Scripts submodule is not present. Please run 'git submodule update --init --recursive'."
    exit 1
fi

# Check if Python is installed
python_version=$(python3 --version 2>/dev/null)
if [ $? -ne 0 ]; then
	echo "Error: Python3 is not installed on this system."
	exit 1
else
	echo "Using Python version: $python_version"
fi

# Run the package check script
python3 "$ROOT_PATH/Scripts/package_check.py"
if [ $? -ne 0 ]; then
	echo "Error: Package check failed."
	exit 1
fi

# Run the build package script
python3 "$ROOT_PATH/Scripts/core/o3de_package_scripts/build_package.py" --search_path "$ROOT_PATH" "$PACKAGE_NAME"
if [ $? -ne 0 ]; then
	echo "Error: Failed to build package $PACKAGE_NAME."
	exit 1
fi

echo "Package $PACKAGE_NAME built successfully."
exit 0
