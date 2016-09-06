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
  
REM :: Обработка
for /r "%~n1" %%1 in (*) do (
  REM if not exist "%~dpn1_renamed" (
    REM md "%~dpn1_renamed"
  REM )
ren "%%1" "%~n1-%%~nx1"
)
  
:: Завершение обработки
echo.
:exit
pause