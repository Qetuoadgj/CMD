cls
@echo off

if "%~1" == "" goto :EOF
set "SOX=D:\Downloads\Sounds\sox-14.4.2\sox.exe"
REM set INPUT_CHANNELS=2
REM set INPUT_VOLUME=2
set OUTPUT_CHANNELS=1
REM set OUTPUT_FORMAT=mp3

REM set OUTPUT_BITRATE=48k
REM set OUTPUT_SAMPLE_RATE=320

REM set OUTPUT_BITRATE=44.1k
REM set OUTPUT_SAMPLE_RATE=1411

REM rd "%OUTPUT_DIR%" /q /s
REM md "%OUTPUT_DIR%"

:Start
:: Определение системного языка (0419 - Русский)
  for /f "tokens=3 delims= " %%g in ('reg query "hklm\system\controlset001\control\nls\language" /v Installlanguage') do (set "lang=%%g")

:: Определение разрядности системы
  reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" /v "Identifier" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

REM :MainMenu
REM cls
  REM TITLE %Name%
  REM if /i {%lang%}=={0419} (echo.Выбор действия:) else (echo.Action select:)
  REM echo.
  REM if /i {%lang%}=={0419} (echo. ^(1^) - wav) else (echo. ^(1^) - wav)
  REM if /i {%lang%}=={0419} (echo. ^(2^) - mp3) else (echo. ^(2^) - mp3)
  REM echo.
  REM if /i {%lang%}=={0419} (echo. ^(3^) - Выйти) else (echo. ^(3^) - Exit)
  REM echo.
  REM if /i {%lang%}=={0419} (SET /P "ANSWER=Выберите формат: ") else (SET /P "ANSWER=Choose format: ")
  REM if /i {%ANSWER%}=={1} (goto :wav)
  REM if /i {%ANSWER%}=={2} (goto :mp3)
  REM if /i {%ANSWER%}=={3} (exit)
  REM goto :MainMenu

REM :mp3
	REM set OUTPUT_FORMAT=mp3
	REM goto :Convert
REM :wav
	REM set OUTPUT_FORMAT=wav
	REM goto :Convert

set "L_Default=Default"
if /i {%lang%}=={0419} set "L_Default=По умолчанию"

:Set_Input_Channels
	cls
	TITLE %Name%
	if /i {%lang%}=={0419} (echo.Выбор действия:) else (echo.Action select:)
	echo.
	if /i {%lang%}=={0419} (echo. ^(1^) - Моно) else (echo. ^(1^) - Mono)
	if /i {%lang%}=={0419} (echo. ^(2^) - Стерео) else (echo. ^(2^) - Stereo)
	echo.
	if /i {%lang%}=={0419} (echo. ^(3^) - Выйти) else (echo. ^(3^) - Exit)
	echo.
	set "ANSWER="
	if /i {%lang%}=={0419} (SET /P "ANSWER=Укажите исходный формат: ") else (SET /P "ANSWER=Choose input format: ")
	if /i {%ANSWER%}=={} (set INPUT_CHANNELS=%L_Default%) & goto :Set_Input_Volume
	if /i {%ANSWER%}=={1} (set INPUT_CHANNELS=1) & goto :Set_Input_Volume
	if /i {%ANSWER%}=={2} (set INPUT_CHANNELS=2) & goto :Set_Input_Volume
	if /i {%ANSWER%}=={3} (exit)
	goto :Set_Input_Channels

:Set_Input_Volume
	cls
	if /i {%lang%}=={0419} (echo.Кол-во каналов: %INPUT_CHANNELS%) else (echo.Channels: %INPUT_CHANNELS%)
	echo.
	set "ANSWER="
	if /i {%lang%}=={0419} (SET /P "ANSWER=Укажите множитель громкости: ") else (SET /P "ANSWER=Choose volume multiplier format: ")
	if /i {%ANSWER%}=={} (set INPUT_VOLUME=%L_Default%) else (set INPUT_VOLUME=%ANSWER%)
	if /i {%ANSWER%}=={r} goto :Set_Input_Channels
	goto :Set_Output_Bitrate

:Set_Output_Bitrate
	cls
	if /i {%lang%}=={0419} (echo.Кол-во каналов: %INPUT_CHANNELS%) else (echo.Channels: %INPUT_CHANNELS%)
	if /i {%lang%}=={0419} (echo.Громкость: %INPUT_VOLUME%) else (echo.Volume: %INPUT_VOLUME%)
	echo.
	set "ANSWER="
	if /i {%lang%}=={0419} (SET /P "ANSWER=Укажите битрейт результата: ") else (SET /P "ANSWER=Choose output bitrate: ")
	if /i {%ANSWER%}=={} (set OUTPUT_BITRATE=%L_Default%) else (set OUTPUT_BITRATE=%ANSWER%)
	if /i {%ANSWER%}=={r} goto :Set_Input_Volume
	goto :Set_Output_Sample_Rate

:Set_Output_Sample_Rate
	cls
	if /i {%lang%}=={0419} (echo.Кол-во каналов: %INPUT_CHANNELS%) else (echo.Channels: %INPUT_CHANNELS%)
	if /i {%lang%}=={0419} (echo.Громкость: %INPUT_VOLUME%) else (echo.Volume: %INPUT_VOLUME%)
	if /i {%lang%}=={0419} (echo.Битрейт: %OUTPUT_BITRATE%) else (echo.BitRate: %OUTPUT_BITRATE%)
	echo.
	set "ANSWER="
	if /i {%lang%}=={0419} (SET /P "ANSWER=Укажите сэмпл-рейт результата: ") else (SET /P "ANSWER=Choose output sample rate: ")
	if /i {%ANSWER%}=={} (set OUTPUT_SAMPLE_RATE=%L_Default%) else (set OUTPUT_SAMPLE_RATE=%ANSWER%)
	if /i {%ANSWER%}=={r} goto :Set_Output_Bitrate
	goto :Set_Output_Format

:Set_Output_Format
	cls
	if /i {%lang%}=={0419} (echo.Кол-во каналов: %INPUT_CHANNELS%) else (echo.Channels: %INPUT_CHANNELS%)
	if /i {%lang%}=={0419} (echo.Громкость: %INPUT_VOLUME%) else (echo.Volume: %INPUT_VOLUME%)
	if /i {%lang%}=={0419} (echo.Битрейт: %OUTPUT_BITRATE%) else (echo.BitRate: %OUTPUT_BITRATE%)
	if /i {%lang%}=={0419} (echo.Качество: %OUTPUT_SAMPLE_RATE%) else (echo.Sample rate: %OUTPUT_SAMPLE_RATE%)
	echo.
	if /i {%lang%}=={0419} (echo.Выбор действия:) else (echo.Action select:)
	echo.
	if /i {%lang%}=={0419} (echo. ^(1^) - wav) else (echo. ^(1^) - wav)
	if /i {%lang%}=={0419} (echo. ^(2^) - mp3) else (echo. ^(2^) - mp3)
	echo.
	if /i {%lang%}=={0419} (echo. ^(3^) - Выйти) else (echo. ^(3^) - Exit)
	echo.
	set "ANSWER="
	if /i {%lang%}=={0419} (SET /P "ANSWER=Выберите формат: ") else (SET /P "ANSWER=Choose format: ")
	if /i {%ANSWER%}=={} (set OUTPUT_FORMAT=%L_Default%) & goto :Convert
	if /i {%ANSWER%}=={1} (set OUTPUT_FORMAT=wav) & goto :Convert
	if /i {%ANSWER%}=={2} (set OUTPUT_FORMAT=mp3) & goto :Convert
	if /i {%ANSWER%}=={3} (exit)
	if /i {%ANSWER%}=={r} goto :Set_Output_Sample_Rate
	goto :Set_Output_Format

:Convert
	setLocal EnableDelayedExpansion
	for %%F in (%1) do (
		cd /d "%%~dpF"
		set "OUTPUT_DIR=mono"
		if exist "!OUTPUT_DIR!\nul" rd "!OUTPUT_DIR!" /q /s
		md "!OUTPUT_DIR!"
	)
	for %%F in (%*) do (
		set name=%%~nF
		set ext=%%~xF
		set ext=!ext:~1!
		REM "%SOX%" -c%INPUT_CHANNELS% -v%INPUT_VOLUME% "%%~nxF" -c%OUTPUT_CHANNELS% -t%OUTPUT_FORMAT% -r%OUTPUT_BITRATE% -C%OUTPUT_SAMPLE_RATE% "!OUTPUT_DIR!\%%~nF.%OUTPUT_FORMAT%"
		if "%OUTPUT_FORMAT%" == "%L_Default%" (set OUTPUT_FORMAT=!ext!) else (set OUTPUT_FORMAT=%OUTPUT_FORMAT%)
		set "command="
		if not "%INPUT_CHANNELS%" == "%L_Default%" set command=!command! -c%INPUT_CHANNELS%
		if not "%INPUT_VOLUME%" == "%L_Default%" set command=!command! -v%INPUT_VOLUME%
		if not "%%~nxF" == "" set command=!command! "%%~nxF"
		if not "%OUTPUT_CHANNELS%" == "%L_Default%" set command=!command! -c%OUTPUT_CHANNELS%
		if not "%OUTPUT_FORMAT%" == "%L_Default%" set command=!command! -t!OUTPUT_FORMAT!
		if not "%OUTPUT_BITRATE%" == "%L_Default%" set command=!command! -r%OUTPUT_BITRATE%
		if not "%OUTPUT_SAMPLE_RATE%" == "%L_Default%" set command=!command! -C%OUTPUT_SAMPLE_RATE%
		set command=!command! "!OUTPUT_DIR!\%%~nF.!OUTPUT_FORMAT!"
		"%SOX%" !command!
		echo.%%~nF.%OUTPUT_FORMAT%
	)
	setlocal DisableDelayedExpansion

:EOF
	pause
	exit
