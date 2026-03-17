
@echo off
rem Launch build_package.py in this directory with all forwarded arguments
setlocal
set "SCRIPT=%~dp0\Scripts\packaging\package.py"

where python >nul 2>&1
if %ERRORLEVEL%==0 (
  python "%SCRIPT%" %*
  exit /b %ERRORLEVEL%
)
echo Python launcher not found. Install Python or add it to PATH.
exit /b 1
