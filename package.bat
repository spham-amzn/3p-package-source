@echo off
REM 
REM  Copyright (c) Contributors to the Open 3D Engine Project. For complete copyright and license terms please see the LICENSE at the root of this distribution.
REM 
REM  SPDX-License-Identifier: Apache-2.0 OR MIT
REM 
REM 

setlocal

set BASEPATH=%~dp0
set SCRIPT=%BASEPATH%\package.py

where py >nul 2>&1
if %ERRORLEVEL%==0 (
  py "%SCRIPT%" %*
  exit /b %ERRORLEVEL%
)
where python >nul 2>&1
if %ERRORLEVEL%==0 (
  python "%SCRIPT%" %*
  exit /b %ERRORLEVEL%
)
echo Python launcher not found. Install Python or add it to PATH.
exit /b 1
