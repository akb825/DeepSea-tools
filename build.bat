@echo off
setlocal enabledelayedexpansion
set PREV_DIR=%cd%
set DIR=%~dp0
cd "%DIR%"

rmdir install /S /Q
mkdir install

set INSTALL_ARGS="-DCMAKE_INSTALL_PREFIX=%DIR%install"

set GIT_BASH="C:\Program Files\Git\bin\bash.exe"
set REPOS="Cuttlefish" "ModularShaderLanguage"
for %%R in (%REPOS%) do (
	echo "Building %%R..."
	%GIT_BASH% -c "scripts/checkout.sh %%R"
	if !ERRORLEVEL! neq 0 (
		cd %PREV_DIR%
		exit /B !ERRORLEVEL!
	)
	call scripts\compile.bat %%R %INSTALL_ARGS% %*
	if !ERRORLEVEL! neq 0 (
		cd %PREV_DIR%
		exit /B !ERRORLEVEL!
	)
)

REM Variables are shared between scripts, so need to get DIR agian.
set DIR=%~dp0

set OUTPUT="DeepSea-tools.zip"
echo "Creating package %OUTPUT%..."
del "%OUTPUT%" >nul 2>&1

cd install
7z a -tzip "%DIR%%OUTPUT%" bin\*.exe bin\*.dll
cd "%DIR%"

echo "Cleaning up..."

for %%R in (%REPOS%) do (
	rmdir "%%R" /S /Q
)
rmdir install /S /Q

echo "Done"

cd %PREV_DIR%
