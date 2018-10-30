@echo off
set BUILD_DIR=%cd%
set DIR=%~dp0

set /P FLAGS=<"%DIR%\%REPO%.flags"

cd "%REPO%"
rmdir build /S /Q > nul 2>&1
mkdir build
cd build

cmake .. -G "Visual Studio 15 2017" -Tv140 %FLAGS% %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release --target install
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
