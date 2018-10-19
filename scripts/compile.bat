@echo off
set PREV_DIR=%cd%
set DIR=%~dp0

set REPO=%1
shift

set /P FLAGS=<"%DIR%\%REPO%.flags"

cd "%REPO%"
rmdir build /S /Q
mkdir build
cd build

set ARGS=
:parse
if "%~1" neq "" (
	set ARGS=%ARGS% %1
	shift
	goto :parse
)

cmake .. -G "Visual Studio 15 2017" -Tv140 %FLAGS% %ARGS%
cmake --build . --config Release
cmake --build . --config Release --target install

cd %PREV_DIR%
