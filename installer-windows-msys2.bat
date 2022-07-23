@echo off


set MSYS2_DOTFILES_TO_INSTALL=msys2
if defined ADDITIONAL_DOTFILES (
	set ADDITIONAL_DOTFILES=%MSYS2_DOTFILES_TO_INSTALL% %ADDITIONAL_DOTFILES%
) else (
	set ADDITIONAL_DOTFILES=%MSYS2_DOTFILES_TO_INSTALL%
)

windows.install-tools.bat

C:\tools\msys64\msys2.exe sh -c "./install-dotfiles %DOTFILES_TO_INSTALL%; sleep 5s"
if %errorLevel% neq 0 (
	echo Dotfile installation failed, exiting.
	popd
	exit /B 1
)

popd
