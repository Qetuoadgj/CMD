@echo off

:: Проверка наличия обрабатываемого файла.
if not exist %1 ( goto NoFile ) else ( goto Start )
:NoFile
	:: Файла нет
	echo.
	echo N O   F I L E   ! ! !
	echo.
	goto exit

:: Обработка файла
:Start
set FULL_PATH=%~dp1
set FULL_PATH=%FULL_PATH:~1,-1%
for %%i in ("%FULL_PATH%") do set "PARENT_FOLDER=%%~ni"
echo %PARENT_FOLDER%

for %%a in (%*) do (
  echo.%%~fa
  ren "%%~a" "%PARENT_FOLDER%-%%~nxa"
)
  
:: Завершение обработки
echo.
:exit
REM pause