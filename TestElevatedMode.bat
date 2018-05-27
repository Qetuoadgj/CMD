@echo off

call :isAdmin
if %ErrorLevel% == 0 (
	color 02
	echo.Running with admin rights.
	echo.
) else (
	color 04
	echo.Error: You must run this script as an Administrator!
	echo.
	pause
	goto :theEnd
)

:theEnd
TIMEOUT 30
exit /b

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b