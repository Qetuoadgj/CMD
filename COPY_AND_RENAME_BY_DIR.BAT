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
for %%1 in (%1\*.*) do (
  if not exist "%~dpn1_renamed" (
    md "%~dpn1_renamed"
  )
copy "%%~1" "%~dp1\%~n1_renamed\%~n1-%%~nx1"
)
  
:: Завершение обработки
echo.
:exit
REM pause