@echo off

REM
REM Copyright (c) Contributors to the Open 3D Engine Project.
REM For complete copyright and license terms please see the LICENSE at the root of this distribution.
REM 
REM SPDX-License-Identifier: Apache-2.0 OR MIT
REM
REM

set SCRIPT_DIR=%~dp0
set TEMP_DIR=%SCRIPT_DIR%temp
set PYTHON_SRC=%TEMP_DIR%\src
set BUILD_DIR=%TEMP_DIR%\python-windows

ECHO Packaging Additional CMake files
COPY %SCRIPT_DIR%python-config.cmake.windows %BUILD_DIR%\python-config.cmake
COPY %SCRIPT_DIR%python-config-version.cmake %BUILD_DIR%\python-config-version.cmake

ECHO Packaging Debug Symbols
set ROBOCOPY_OPTIONS=/NJH /NJS /NP /NDL
robocopy %PYTHON_SRC%\PCbuild\amd64 %BUILD_DIR%\python Python*.pdb %ROBOCOPY_OPTIONS%

ECHO Packaging Additional Files - DONE
exit /b 0
