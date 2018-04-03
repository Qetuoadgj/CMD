@echo off
	for /F "tokens=1,2*" %%V in ('bcdedit') do set adminTest=%%V
	if (%adminTest%)==(Access) goto noAdmin
	for /F "tokens=*" %%G in ('wevtutil.exe el') do (call :do_clear "%%G")
	echo.
	echo Event Logs have been cleared!
goto theEnd
:do_clear
	echo clearing %1
	wevtutil.exe cl %1
goto :eof
:noAdmin
	echo You must run this script as an Administrator!
	echo.
:theEnd
exit