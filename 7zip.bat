@echo OFF
cd /d "%~dp0"
if "%~1" == "" goto :Exit

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" /v "Identifier" | find /i "x86" > nul && set OS=32BIT || set OS=64BIT

REM set "ffmpeg=%cd%\x32\bin\ffmpeg.exe"
REM if /i %OS%==64BIT set "ffmpeg=%cd%\x64\bin\ffmpeg.exe"

set "SevenZip=%ProgramFiles%\7-Zip\7z.exe"

setLocal EnableDelayedExpansion
set /a "i=0"
for %%F in (%*) do (
	set /a "i=!i!+1"
	if !i! equ 1 (
		cd /d "%%~dpF"
	)
	echo.!i!. %%~nxF
	"%SevenZip%" a -up1q0r2x1y2z1w2 -mx -r0 "%%~nxF.7z" "%%~F"
)
setLocal DisableDelayedExpansion
exit /b
