@ECHO off
CLS
	IF "`%~1" == "" EXIT /b
	CD /d "%~dp1"
	SET "Compiler_Dir=%SystemDrive%\Program Files\AutoHotkey\Compiler"
	SET "Script_Name=%~n1"

	CALL :Compile "%Compiler_Dir%", "%Script_Name%", "", "32"
	CALL :Compile "%Compiler_Dir%", "%Script_Name%", "", "64"

	SET "Updater_Name=Update %Script_Name%"
	CALL :Compile "%Compiler_Dir%", "%Updater_Name%", "", ""
PAUSE
EXIT /b

:Compile Compiler_Dir, Script_Name, Icon, Bits
	SET "Compiler_Dir=%~1"
	SET "Script_Name=%~2"
	SET "Script_Icon=%~3"
	SET "Bits=%~4"
	REM
	ECHO.Compiler_Dir: %Compiler_Dir%
	ECHO.Script_Name: %Script_Name%
	ECHO.Script_Icon: %Script_Icon%
	ECHO.Bits: %Bits%
	REM PAUSE
	REM
	IF NOT EXIST "%Script_Name%.ahk" EXIT /b
	REM
	SET Compile_Params=/in "%Script_Name%.ahk"
	REM
	IF /i "%Bits%" == "" (
		REM ECHO."%Bits%" == ""
		IF EXIST "%Script_Name%.exe" (
			TASKKILL /F /IM "%Script_Name%.exe"
			ERASE %Script_Name%.exe
		)
		SET Compile_Params=%Compile_Params% /out "%Script_Name%.exe"
	)
	IF /i "%Bits%" == "32" (
		REM ECHO."%Bits%" == "32"
		IF EXIST "%Script_Name%_x32.exe" (
			TASKKILL /F /IM "%Script_Name%_x32.exe"
			ERASE %Script_Name%_x32.exe
		)
		SET Compile_Params=%Compile_Params% /bin "%Compiler_Dir%\Unicode 32-bit.bin" /out "%Script_Name%_x32.exe"
	)
	IF /i "%Bits%" == "64" (
		REM ECHO."%Bits%" == "64"
		IF EXIST "%Script_Name%_x64.exe" (
			TASKKILL /F /IM "%Script_Name%_x64.exe"
			ERASE %Script_Name%_x64.exe
		)
		SET Compile_Params=%Compile_Params% /bin "%Compiler_Dir%\Unicode 64-bit.bin" /out "%Script_Name%_x64.exe"
	)
	IF /i NOT "%Script_Icon%" == "" (
		REM HKEY_CURRENT_USER\Software\AutoHotkey\Ahk2Exe\LastIcon && LastIconDir
		IF EXIST "%Script_Name%.ico" (
			SET Compile_Params=%Compile_Params% /icon "%Script_Name%.ico"
		)
	)
	REM
	SET Compile_Params=%Compile_Params% /mpress 1
	REM
	ECHO.Ahk2Exe.exe %Compile_Params%
	REM PAUSE
	"%Compiler_Dir%\Ahk2Exe.exe" %Compile_Params%
	ECHO.OK
	ECHO.
EXIT /b
