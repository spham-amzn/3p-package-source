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
set BUILD_DIR=%TEMP_DIR%\python-windows

ECHO Quick Python Sanity Test

CALL %BUILD_DIR%\python\Python.exe %SCRIPT_DIR%\quick_validate_python.py
if %ERRORLEVEL% NEQ 0 (
    echo "Python sanity test failed"
    exit /B 1
) ELSE (
    echo "Python sanity test passed"
)
