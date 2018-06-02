@echo OFF
REM color 1f
cd /d "%~dp0"
if "%~1" == "" goto :Exit
cls
:Start
	REM :: ��������� ࠧ��� ���� ��������� ��ப� (�� 㬮�砭��: 80�25), �������� ࠧ��� ���� 9999.
		mode con: cols=100 lines=25
		REM call :conSize 100 25 100 9999

	REM :: ��।������ ��⥬���� �몠 (0419 - ���᪨�)
		for /f "tokens=3 delims= " %%g in ('reg query "hklm\system\controlset001\control\nls\language" /v Installlanguage') do (set "lang=%%g")

	REM :: ��।������ ࠧ�來��� ��⥬�
		reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" /v "Identifier" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

	REM set "SevenZip=%ProgramFiles%\7-Zip\7z.exe"

	REM ::==================== ��।������ ��६����� =====================
	REM :: ����砥� ����� �� ����� 䠩�� "���_����� [�����].BAT"
		for /f "tokens=2 delims=[]" %%a in ("%~n0") do set "Prefix=%%a"

	REM :: ��।��塞 ��६����
		REM set "Name=World of Warcraft"
		set "YYYY=%DATE:~-4%"
		set "MM=%DATE:~3,2%"
		set "DD=%DATE:~0,2%"
		REM set "Name=%Prefix%%Name%"
		set "Password=7120563"
	REM :: ===============================================================

REM :: ��������� ���� �ਫ������
	TITLE %Name% [%locale%] - Create Backup

:CreateBackupMenu
	cls
	if /i {%lang%}=={0419} (echo.�롮� ᦠ��:) else (echo.Compression select:)
	echo.
	echo. (1) - 7-Zip
	echo. (2) - WinRar
	echo.
	if /i {%lang%}=={0419} ( echo. ^(3^) - ��室 ) else ( echo. ^(3^) - Exit )
	echo.
	if /i {%lang%}=={0419} ( SET /P ANSWER="�롥�� �ଠ� ᦠ��: ") else ( SET /P ANSWER="Choose compression format: ")
	if /i {%ANSWER%}=={1} ( set "Archiver=7zip" & goto :AddPassword )
	if /i {%ANSWER%}=={2} ( set "Archiver=WinRar" & goto :AddPassword )
	if /i {%ANSWER%}=={3} ( exit )
	goto :CreateBackupMenu
exit /b

:AddPassword
	cls
	if /i {%lang%}=={0419} (echo.�롮� ����⢨�:) else (echo.Option select:)
	echo.
	echo. (1) - %Password%
	if /i {%lang%}=={0419} ( echo. ^(2^) - ��� ��஫� ) else ( echo. ^(2^) - No password )
	echo.
	if /i {%lang%}=={0419} ( echo. ^(3^) - ��室 ) else ( echo. ^(3^) - Exit )
	echo.
	if /i {%lang%}=={0419} ( SET /P ANSWER="��⠭����� ��஫�? ") else ( SET /P ANSWER="Set password? ")
	if /i {%ANSWER%}=={1} ( set "SetPassword=Yes" & goto :StartBackup )
	if /i {%ANSWER%}=={2} ( set "SetPassword=No" & goto :StartBackup )
	if /i {%ANSWER%}=={3} ( exit )
	goto :AddPassword
exit /b

:StartBackup
	REM :: �஢�ઠ ������ ��娢��஢
	call :CheckArchivers
	REM
	REM echo.Archiver = "%Archiver%"
	REM pause
	setLocal EnableDelayedExpansion
	set /a "i=0"
	for %%F in (%*) do (
		set /a "i=!i!+1"
		if !i! equ 1 (
			cd /d "%%~dpF"
		)
		REM
		REM set "TargetPath=%%~F"
		set "TargetPath=%%~nxF"
		set "ArchiveName=%Prefix%%%~nxF"
		set "ArchivePath=!ArchiveName!"
		REM
		TITLE %ArchiveName%
		REM
		echo.!i!. %%~nxF
		echo.
		if /i "%Archiver%" == "7zip" (
			if /i "%SetPassword%" == "Yes" (
				set ArchivePass=-p%Password%
			)
			set Exclude=-x!""
			set "Exclude="
			"%SevenZip%" U -up1q0r2x1y2z1w2 -r0 -spf2 -slp -mx -myx -ms=on -scrcBLAKE2sp !Exclude! -mhe=on !ArchivePass! "!ArchivePath!.7z" "!TargetPath!"
		)
		if /i "%Archiver%" == "WinRar" (
			if /i "%SetPassword%" == "Yes" (
				set ArchivePass1=-hp%Password%
				set ArchivePass2=-p%Password%
			)
			set Exclude=-x""
			set "Exclude="
			"%WinRar%" A -u -as -s -r1 -m5 -ma5 -md4m -mc63:128t+ -mc4a+ -mcc+ -htb !Exclude! !ArchivePass1! "!ArchivePath!.rar" "!TargetPath!"
			"%WinRar%" rr5p !ArchivePass2! "!ArchivePath!"
		)
	)
	setLocal DisableDelayedExpansion
	goto :End
exit /b
REM :: ===============================================================
:CheckArchivers
	REM :: �ᯮ��塞� 䠩�� ��娢��஢
		REM :: WinRar
			set "WinRar=%ProgramFiles%\WinRAR\Rar.exe"
		REM :: 7-Zip
			set "SevenZip=%ProgramFiles%\7-Zip\7z.exe"
			if /i %OS%==64BIT set "SevenZip=%ProgramFiles%\7-Zip\7z.exe"
	REM :: �஢�ઠ ������ ��娢��஢
		if not exist "%SevenZip%" (
			if not exist "%WinRar%" (goto NoArchiver)
		)
		if not exist "%WinRar%" (
			if not exist "%SevenZip%" (goto NoArchiver)
		)
exit /b
:: ===============================================================
:NoArchiver
cls
	if /i {%lang%}=={0419} (echo.������: �ᯮ��塞� 䠩�� 7-Zip � WinRar �� �������.) else (echo.ERROR: 7-Zip & WinRar executables are not found.)
	goto :End
exit /b
REM :: ===============================================================
:conSize winWidth winHeight bufWidth bufHeight
	REM http://stackoverflow.com/a/13351373
	mode con: cols=%1 lines=%2
	powershell -command "& {$H=get-host; $W=$H.ui.rawui; $B=$W.buffersize; $B.width=%3; $B.height=%4; $W.buffersize=$B;}"
exit /b
REM :: ===============================================================
:End
	echo.
	pause
	REM goto :MainMenu
exit /b