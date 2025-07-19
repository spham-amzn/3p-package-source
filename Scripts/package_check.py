#!/usr/bin/env python3
#
# Copyright (c) Contributors to the Open 3D Engine Project. For complete copyright and license terms please see the LICENSE at the root of this distribution.
# 
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#
import sys

try:
    import certifi
    import boto3
except ModuleNotFoundError as e:
    print(f"Missing python package {e.name}. Make sure to install it through pip.")
    sys.exit(1)

sys.exit(0)
