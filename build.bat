@echo off
setlocal enabledelayedexpansion
set PREV_DIR=%cd%
set DIR=%~dp0
cd "%DIR%"

set INSTALL_ARGS="-DCMAKE_INSTALL_PREFIX=%DIR%install"
set CMAKE_ARGS=
set OUTPUT="%DIR%DeepSea-tools.zip"

:parseArgs
if not "%1"=="" (
	set MATCH=
	if "%1"=="-h" set MATCH=1
	if "%1"=="--help" set MATCH=1
	if "%1"=="/?" set MATCH=1
	if defined MATCH (
		goto :printHelp
	) else (
		if "%1"=="-o" set MATCH=1
		if "%1"=="--output" set MATCH=1
		if defined MATCH (
			set OUTPUT=%2
			shift /1
			if not "!OUTPUT:~2,1!"==":" set OUTPUT="%PREV_DIR%\!OUTPUT!"
		) else set CMAKE_ARGS=!CMAKE_ARGS! "%~1"
	)
	shift /1
	goto :parseArgs
)

rmdir install /S /Q > nul 2>&1
mkdir install

rmdir build /S /Q > nul 2>&1
mkdir build

set GIT_BASH="C:\Program Files\Git\bin\bash.exe"
set REPOS=Cuttlefish ModularShaderLanguage VertexFormatConvert
cd build
for %%R in (%REPOS%) do (
	echo Building %%R...
	set DIR=%~dp0
	set REPO=%%R
	%GIT_BASH% -c "../scripts/checkout.sh !REPO!"
	if !ERRORLEVEL! neq 0 (
		cd %PREV_DIR%
		exit /B !ERRORLEVEL!
	)
	call "!DIR!scripts\compile.bat" %INSTALL_ARGS% !CMAKE_ARGS!
	if !ERRORLEVEL! neq 0 (
		cd %PREV_DIR%
		exit /B !ERRORLEVEL!
	)
)

REM Variables are shared between scripts, so need to get DIR agian.
set DIR=%~dp0

echo Creating package !OUTPUT!...
del !%OUTPUT! > nul 2>&1

cd %DIR%install
7z a -tzip !OUTPUT! bin\*.exe bin\*.dll
cd "%DIR%"

echo Cleaning up...

rmdir install /S /Q > nul 2>&1
rmdir build /S /Q > nul 2>&1

echo Done

cd %PREV_DIR%

exit /B !ERRORLEVEL!

:printHelp
	echo Usage: %~n0` [options] [CMake args...]
	echo.
	echo Options:
	echo -o, --output ^<file^>          The file to output the archive. Note that the
	echo                              archive format will always be .tar.gz regardless of
	echo                              the extension.
	exit /B !ERRORLEVEL!
