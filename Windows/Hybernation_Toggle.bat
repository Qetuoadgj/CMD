@echo off
if exist "%SystemDrive%\hiberfil.sys" (
	powercfg -h off
	echo.Hybernation: Disabled
) else (
	powercfg -h on
	echo.Hybernation: Enabled
)
pause
