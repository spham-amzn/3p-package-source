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
set PYTHON_SRC_PCBUILD=%PYTHON_SRC%\PCbuild
set BUILD_DIR=%TEMP_DIR%\python-windows

ECHO Building python from source

cd "%PYTHON_SRC_PCBUILD%"

REM ###############################################################################
ECHO Cleaning previous build artifacts...
REM ###############################################################################
CALL clean.bat
if %ERRORLEVEL% NEQ 0 (
    echo "Clean failed"
    exit /B 1
)


REM ###############################################################################
ECHO Building Python (Release) from source...
REM ###############################################################################
CALL build.bat -p x64 -c Release
if %ERRORLEVEL% NEQ 0 (
    echo "Python (release) build failed"
    exit /B 1
)

REM ###############################################################################
ECHO Building Python (Debug) from source...
REM ###############################################################################
CALL build.bat -p x64 -c Debug
if %ERRORLEVEL% NEQ 0 (
    echo "Python (debug) build failed"
    exit /B 1
)

REM ###############################################################################
ECHO Creating Installation Layout (Debug) ...
REM ###############################################################################
cd /d %PYTHON_SRC%
CALL %PYTHON_SRC_PCBUILD%\amd64\python.exe .\PC\layout\main.py --copy %BUILD_DIR%\python -v -d --include-stable --include-pip --include-tcltk --include-idle --include-tools --include-venv --include-dev --include-launchers
if %ERRORLEVEL% NEQ 0 (
  echo "Failed to call python's layout script (debug)"
  exit /B 1
)

REM ###############################################################################
ECHO Creating Installation Layout (Release) ...
REM ###############################################################################
CALL %PYTHON_SRC_PCBUILD%\amd64\python.exe .\PC\layout\main.py --copy %BUILD_DIR%\python -v --include-stable --include-pip --include-tcltk --include-idle --include-tools --include-venv --include-dev --include-launchers
if %ERRORLEVEL% NEQ 0 (
  echo "Failed to call python's layout script (release)"
  exit /B 1
)

REM ###############################################################################
ECHO Installing / Upgrading PIP
REM ###############################################################################
CALL %BUILD_DIR%\python\Python.exe  -m ensurepip --root %BUILD_DIR%\python --upgrade
if %ERRORLEVEL% NEQ 0 (
  echo Failed to ensure pip is present.
  exit /B 1
)
CALL %BUILD_DIR%\python\Python.exe -m pip install --target %BUILD_DIR%\python\Lib\site-packages --upgrade pip
if %ERRORLEVEL% NEQ 0 (
  echo Pip install failed
  exit /B 1
)

echo BUILD SUCCESSFUL to %BUILD_DIR%\python

exit /B 0
