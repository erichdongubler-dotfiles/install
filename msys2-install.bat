@echo off

set CHOCO_PACKAGES_TO_INSTALL=windows-chocolatey/base.config
if defined ADDITIONAL_CHOCO_PACKAGES (
	set CHOCO_PACKAGES_TO_INSTALL=%CHOCO_PACKAGES_TO_INSTALL% %ADDITIONAL_CHOCO_PACKAGES%
)

set DOTFILES_TO_INSTALL=msys2 vim tmux rust
if defined ADDITIONAL_DOTFILES (
	set DOTFILES_TO_INSTALL=%DOTFILES_TO_INSTALL% %ADDITIONAL_DOTFILES%
)

rem Get script directory: https://stackoverflow.com/questions/3827567/how-to-get-the-path-of-the-batch-script-in-windows
set script_dir=%~dp0
set script_dir=%script_dir:~0,-1%
echo %script_dir%

rem Check for admin: https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
echo Administrative permissions required. Detecting permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
	echo Success: Administrative permissions confirmed.
) else (
	echo Failure: Current permissions inadequate.
	exit /B 1
)

where choco >nul 2>nul
if %errorLevel% == 0 (
	echo `choco` already installed.
) else (
	echo `choco` not found in PATH, installing...
	rem Install Chocolatey from `cmd`: https://chocolatey.org/install#install-with-cmdexe
	@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
	if %errorLevel% neq 0 (
		echo Unable to install `choco`, exiting.
		exit /B 1
	)
)

rem Use packages.config to install dependencies: https://chocolatey.org/docs/commandsinstall#packagesconfig
pushd %script_dir%

choco install %CHOCO_PACKAGES_TO_INSTALL% -y
if %errorLevel% neq 0 (
	echo `choco` package.config install failed, exiting.
	popd
	exit /B 1
)

C:\tools\msys64\msys2.exe sh -c "./install-dotfiles %DOTFILES_TO_INSTALL%; sleep 5s"
if %errorLevel% neq 0 (
	echo Dotfile installation failed, exiting.
	popd
	exit /B 1
)

popd
