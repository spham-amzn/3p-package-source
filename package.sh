#!/bin/bash
#
# Copyright (c) Contributors to the Open 3D Engine Project. For complete copyright and license terms please see the LICENSE at the root of this distribution.
# 
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#
# Launch package.py in this directory with all forwarded arguments

BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT=$BASE_PATH/package.py

if command -v python &> /dev/null; then
  python "$SCRIPT" "$@"
  exit $?
elif command -v python3 &> /dev/null; then
  python3 "$SCRIPT" "$@"
  exit $?
else
  echo "Python launcher not found. Install Python or add it to PATH."
  exit 1
fi
