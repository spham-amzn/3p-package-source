@ECHO OFF

REM
REM Copyright (c) Contributors to the Open 3D Engine Project.
REM For complete copyright and license terms please see the LICENSE at the root of this distribution.
REM 
REM SPDX-License-Identifier: Apache-2.0 OR MIT
REM
REM

setlocal

SET PACKAGE_NAME=%1

IF "%PACKAGE_NAME%" == "" GOTO PARAM_ERROR

REM Check python 3 is in the installation path
call python --version > nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO "Python 3 is not installed or is not in the installation path."
    exit /b 1
)

REM Check the required packages
call python Scripts\package_check.py
IF %ERRORLEVEL% NEQ 0 (
    exit /b 1
)

SET ROOT_PATH=%~dp0

ECHO Building Package %PACKAGE_NAME%

REM Call the package build script
call python %ROOT_PATH%\Scripts\core\o3de_package_scripts\build_package.py --search_path %ROOT_PATH% %PACKAGE_NAME%
IF %ERRORLEVEL% NEQ 0 (
    ECHO Error building package %PACKAGE_NAME%
    exit /b 1
) ELSE (
    exit /b 0
)

:PARAM_ERROR
ECHO Missing required package name argument
exit /b 1
