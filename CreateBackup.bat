@echo off
cls
REM call :Start "C:\Users\��⮭\Documents\Coding\����� �����\Notepad++ BACKUP.ini"
:Vars
	cls

	REM ��।������ ��⥬���� �몠 (0419 - ���᪨�)
  for /f "tokens=3 delims= " %%g in ('reg query "hklm\system\controlset001\control\nls\language" /v Installlanguage') do (set "lang=%%g")

	REM ��।������ ������� ��� 䠩�� ��� ��ࠡ�⪨
	set "MainFile=%~f1"
	REM ��।������ ����� 䠩�� ��� ��ࠡ�⪨
	set "MainFileShort=%~nx1"

	REM ��।������ �����
	set "WorkingDir=%~dp1"

	REM ��।�� ⥪�饩 ����஢�� � ��६����� %ProgramEncoding%
	call :CurrentEncoding "ProgramEncoding"

	REM ��।������ ⥪�饩 ����
  set "YYYY=%DATE:~-4%"
	set "MM=%DATE:~3,2%"
	set "DD=%DATE:~0,2%"

	REM �४�饭�� �믮������ �ணࠬ�� �᫨ ��������� ��室�� 䠩�
	if not exist "%MainFile%" goto :Usage

	REM �롮� ࠡ�祩 �����
	cd /d "%WorkingDir%"

	REM ����祭�� ��६����� ����� �� 䠩�� (UTF-8)
	chcp 65001 > nul
  for /f "tokens=1,2,* delims==: " %%a in ('findstr /i /n /r "^Name.*" "%MainFile%"') do (
	chcp %ProgramEncoding% > nul

    set Name=%%~c
	)
	REM ����祭�� ��६����� ��஫� �� 䠩�� (UTF-8)
	chcp 65001 > nul
  for /f "tokens=1,2,* delims==: " %%a in ('findstr /i /n /r "^Password.*" "%MainFile%"') do (
	chcp %ProgramEncoding% > nul

    set Password=%%c
	)
	REM ����祭�� ��६����� ࠡ�祩 ����� �� 䠩�� (UTF-8)
	chcp 65001 > nul
  for /f "tokens=1,2,* delims==: " %%a in ('findstr /i /n /r "^RootDir.*" "%MainFile%"') do (
	chcp %ProgramEncoding% > nul

    call set RootDir=%%~c
	)
	REM ����஫쭠� ᬥ�� ����஢��
	chcp %ProgramEncoding% > nul

	call :CreateBackup

	goto End
exit /b

REM =================================================================================================================
REM 																		������� �������� ������� ��������� �����
REM =================================================================================================================
:CreateBackup
	cls

  REM �஢�ઠ ������ ��娢��஢
	call :CheckArchivers

  REM ��।������ �������� 䠩�� १�ࢭ�� ����� "�������� (���.�����.����)"
  set "Archive=%Name% (%YYYY%.%MM%.%DD%)"

	REM ��।������ 䠩���-ᯨ᪮� ��� ��ࠡ�⪨ ��娢��ࠬ�
	set "IncludeList=IncludeList.txt"
	set "ExcludeList=ExcludeList.txt"

	REM ��������� ���� �ਫ������
  TITLE Create Backup: %Name%

	REM set "ANSWER=2"

	:BackupMenu
		REM goto :StartBackup
		cls

		REM �뢮� 䠩�� �� �࠭
		echo.%MainFile%
		echo.%Archive%

		if /i {%lang%}=={0419} (echo.�롮� ᦠ��:) else (echo.Compression select:)
		echo.
		echo. (1) - 7-Zip
		echo. (2) - WinRar
		echo. (3) - 7-Zip, WinRar
		echo.
		REM if /i {%lang%}=={0419} (echo. ^(4^) - �������� � ������� ����) else (echo. ^(4^) - Go back to the main menu)
		if /i {%lang%}=={0419} (echo. ^(4^) - ��室) else (echo. ^(4^) - Exit)
		echo.
		if /i {%lang%}=={0419} (SET /P ANSWER="�롥�� �ଠ� ᦠ��: ") else (SET /P ANSWER="Choose compression format: ")
		echo.
		if /i {%ANSWER%}=={1} (goto :StartBackup)
		if /i {%ANSWER%}=={2} (goto :StartBackup)
		if /i {%ANSWER%}=={3} (goto :StartBackup)
		REM if /i {%ANSWER%}=={4} (exit /b)
		if /i {%ANSWER%}=={4} (exit)
		goto :BackupMenu

  :StartBackup
		REM �������� 䠩���-ᯨ᪮�
		call :FileSplit "%MainFile%", "%IncludeList%", "[IncludeList]", "[ExcludeList]"
		call :FileSplit "%MainFile%", "%ExcludeList%", "[ExcludeList]"

    if /i {%ANSWER%}=={1} (goto :7-Zip)
    if /i {%ANSWER%}=={2} (goto :WinRar)

	:7-Zip
		if exist %SevenZip% (

			REM ����� ����஢�� 䠩��
			REM call :EncodeFile "%IncludeList%", "65001"
			REM call :EncodeFile "%ExcludeList%", "65001"

			REM ��।������ �६����� ��६�����, ����� ����� ���� ������
			setLocal
			REM ��।������ ��६�����
			REM ��� ��娢�
			set "Type=7z"
			REM ��஫� �� ��娢
			set "Password=-p%Password%"
			REM ��⮤ ᦠ��
			set "Compression=-m0=LZMA2 -mx9"
			REM ����-ᯨ᮪ ����砥��� � ��ࠡ��� ��ꥪ⮢ (UTF-8)
			REM set Include=-i@"%IncludeList%"
			set Include=-i@"%WorkingDir%\%IncludeList%"
			REM ����-ᯨ᮪ �᪫�砥��� �� ��ࠡ�⪨ ��ꥪ⮢ (UTF-8)
			REM set Exclude=-x@"%ExcludeList%"
			set Exclude=-x@"%WorkingDir%\%ExcludeList%"
			REM ��⮤� १�ࢭ��� ����஢����:
			REM ����஭����� 䠩���
			set "Synchronize=p0q0r2x1y2z1w2"
			REM ���ਬ���� ��娢
			set "Incrimental=p1q1r0x1y2z1w2"
			REM ������� �� �믮������ ��娢�樨
			REM set Command="%SevenZip%" u -u%Synchronize% %Compression% -r0 -slp -t%Type% %Password% "%Archive%.%Type%" %Exclude% %Include% "%MainFileShort%" -spf2
			set Command="%SevenZip%" u -u%Synchronize% %Compression% -r0 -slp -t%Type% %Password% "%WorkingDir%\%Archive%.%Type%" %Exclude% %Include% "%MainFileShort%" -spf2

			TITLE %Archive%.%Type%

			if "%RootDir%" EQU "" (
				REM �뢮� ������� �� �࠭ � �� �믮������
				echo.%Command% & call %Command%
			) else (
				REM ����� ࠡ�祩 �����
				cd /d "%RootDir%"
				REM �६����� ����஢���� 䠩��-ᯨ᪠ � ࠡ���� �����
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( copy /y "%MainFile%" "%MainFileShort%" )
				REM �뢮� ������� �� �࠭ � �� �믮������
				echo.%Command% & call %Command%
				REM �������� �६������ 䠩��-ᯨ᪠
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( del "%MainFileShort%" )
				REM ������ ࠡ�祩 �����
				cd /d "%WorkingDir%"
			)

			REM ���࠭�� ��।������� ࠭�� �६����� ��६�����
			endLocal

			if /i {%ANSWER%}=={3} (goto :WinRar)
		)
		goto :End
	:WinRaR
		if exist %WinRar% (

			REM ����� ����஢�� 䠩��
			call :EncodeFile "%IncludeList%", "1251"
			call :EncodeFile "%ExcludeList%", "1251"

			REM ��।������ �६����� ��६�����, ����� ����� ���� ������
			setLocal
			REM ��� ��娢�
			set "Type=rar"
			REM ��஫� �� ��娢
			set "Password=-p%Password%"
			REM ��⮤ ᦠ��
			set "Compression=-m5 -rr5p"
			REM ����-ᯨ᮪ ����砥��� � ��ࠡ��� ��ꥪ⮢ (ANSI)
			REM set Include="%MainFileShort%" -@n"%IncludeList%"
			set Include="%MainFileShort%" @"%WorkingDir%\%IncludeList%"
			REM �������� ��譨� ����� (\\) �� ��� 䠩��
			set "Include=%Include:\\=\%"
			REM ����-ᯨ᮪ �᪫�砥��� �� ��ࠡ�⪨ ��ꥪ⮢ (ANSI)
			set Exclude=-x@"%WorkingDir%\%ExcludeList%"
			REM �������� ��譨� ����� (\\) �� ��� 䠩��
			set "Exclude=%Exclude:\\=\%"
			REM ��⮤� १�ࢭ��� ����஢����:
			REM ����஭����� 䠩���
			set "Synchronize= -as"
			REM ���ਬ���� ��娢
			REM set "Incrimental=p1q1r0x1y2z1w2"

			REM ������� �� �믮������ ��娢�樨
			set Command="%WinRar%" u -u%Synchronize% %Compression% -r0 %Password% "%WorkingDir%\%Archive%.%Type%" %Include% %Exclude%

			TITLE %Archive%.%Type%

			if "%RootDir%" EQU "" (
				REM �뢮� ������� �� �࠭ � �� �믮������
				echo.%Command% & call %Command%
			) else (
				REM ����� ࠡ�祩 �����
				cd /d "%RootDir%"
				REM �६����� ����஢���� 䠩��-ᯨ᪠ � ࠡ���� �����
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( copy /y "%MainFile%" "%MainFileShort%" )
				REM �뢮� ������� �� �࠭ � �� �믮������
				echo.%Command% & call %Command%
				REM �������� �६������ 䠩��-ᯨ᪠
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( del "%MainFileShort%" )
				REM ������ ࠡ�祩 �����
				cd /d "%WorkingDir%"
			)

			REM ���࠭�� ��।������� ࠭�� �६����� ��६�����
			endLocal
		)

		goto :End
  pause
exit /b

REM =================================================================================================================
REM 																	������� ��������� ������� ��������� ���������
REM
REM ���ᠭ��	-	��ᢠ����� 㪠������ ��㬥��� ���祭�� ⥪�饩 ����஢�� "chcp"
REM ���⠪��	-	call :CurrentEncoding "��६�����-१����"
REM =================================================================================================================
:CurrentEncoding
	for /f "usebackq tokens=2 delims=:" %%a in (`chcp`) do (set "CurrentEncoding=%%a")
	set "%~1=%CurrentEncoding: =%"
exit /b

REM =================================================================================================================
REM 																	     ������� ����� ��������� �����
REM
REM ���ᠭ��	-	�����뢠�� 䠩� � 㪠������ ����஢��
REM ���⠪��	-	call :EncodeFile "��室�� 䠩�", "����஢��", "����-�������"
REM =================================================================================================================
:EncodeFile
	REM ��।������ ��६�����
	set "SourceFile=%~1"
	set "SourceFileShort=%~nx1"
	set "Encoding=%~2"
	set "OutputFile=%~3"

	REM �������� ���⮣� 䠩�� / ���࠭�� 㦥 �������饣�
	if exist "%OutputFile%" del "%OutputFile%"

	REM �஢�ઠ ������ ��ࠬ��� "����-�������" � ��।������ ��� �᫨ �� �� �����
	if "%~3" EQU "" ( set "OutputFile=%~dpn1-%Encoding%%~x1" )

	REM ������ ��४���஢����� ��ப � 䠩�-१����
	chcp 65001 > nul
	for /f "usebackq tokens=*" %%a in ("%SourceFile%") do (
		chcp %ProgramEncoding% > nul

		REM �맮� �㭪樨 ��� ᬥ�� ����஢�� ⥪�襩 ��ப�
		call :EncodeString %%a, "%Encoding%", "%OutputFile%"
	)

	REM ��२��������� �६������ 䠩�� � 䠩�-१����
	if "%~3" EQU "" (
		if exist "%OutputFile%" (
			del "%SourceFile%"
			ren "%OutputFile%" "%SourceFileShort%"
		) else (
			echo.Error: OutputFile not exist!
			pause
			exit
		)
	)

exit /b

REM =================================================================================================================
REM 										   ������� ������ � ����-��������� ������� ������ � ������ ����������
REM
REM ���ᠭ��	-	�����뢠�� ��ப� � 㪠������ ����஢�� � 䠩�-१����
REM ���⠪��	-	call :EncodeFile "��室��� ��ப�", "����஢��", "����-�������"
REM =================================================================================================================
:EncodeString
	REM ����� ����஢�� �� ��������
	chcp %~2 > nul
	REM ������ ��ப� � 䠩�-१����
	echo.%1>>"%~3"
	REM ������� � �ணࠬ���� ����஢��
	chcp %ProgramEncoding% > nul
exit /b

REM =================================================================================================================
REM 																		������� ���������� ����� �� �����
REM
REM ���ᠭ��	-	���࠭�� 㪠����� ��� ⥪�⮢��� 䠩�� � ���� 䠩���-१���⮢
REM ���⠪��	-	call :FileSplit "������� ����", "����-�������", "��砫쭠� ��ப�" [, "����筠� ��ப�"]
REM =================================================================================================================
:FileSplit

	REM ��।�� ⥪�饩 ����஢�� � ��६����� %CurrentEncoding%
	REM call :CurrentEncoding "CurrentEncoding"

	REM ��।������ ��६�����
	set "SourceFile=%~1"
	set "OutputFile=%~2"
	set "StartString=%~3"
	set "EndString=%~4"

	set "Sepatator=-----------------------------------------------------"

	REM ��।������ �६������ 䠩�� ��� ��ࠡ�⪨ ������
	set "TmpFile=FileSplit.txt"

	REM �뢮� ��६����� �� �࠭
	echo.SourceFile	%SourceFile%
	echo.OutputFile	%OutputFile%
	echo.StartString	%StartString%

	REM �஢�ઠ ��ࠬ��� "����筠� ��ப�"
	if "%EndString%" EQU "" (
		REM ��ࠬ��� �� �����
		echo.EndString	Not defined
	) else (
		REM ��ࠬ��� �����
		echo.EndString	%EndString%
	)

	REM �஢�ઠ ������ ��६����� ��ࠡ��뢠����� 䠩��
	if not exist "%SourceFile%" (
		echo.Source file not exist.
		echo.%SourceFile%
		pause
		exit /b
	)

	echo.

	setLocal EnableDelayedExpansion
	REM �������� ���⮣� 䠩�� / ���࠭�� 㦥 �������饣�
	if exist "%TmpFile%" del "%TmpFile%"
	REM type nul > "%TmpFile%"

	REM �ய�� ��������஢����� ��ப � �ନ஢���� ���ଠ�஢������ �६������ 䠩�� ��� ��ࠡ�⪨ ������
	for /f "usebackq delims= eol=;" %%a in ("%SourceFile%") do (
		REM echo.%%a
		echo.%%a>>"%TmpFile%"
	)

	REM ��।������ ���浪����� ����� "��砫쭮� ��ப�" � ���ଠ�஢����� �६����� 䠩��
	for /f "tokens=1 delims=:" %%a in ('findstr /i /x /n /c:"%StartString%" "%TmpFile%"') do (
		REM ��।������ ��६�����
		set "StartLine=%%a"
	)
	REM �뢮� ��६����� �� �࠭
	REM echo.StartLine		%StartLine%

	REM ��।������ ������ ��ࠬ��� � ���浪����� ����� "����筮� ��ப�" � ���ଠ�஢����� �६����� 䠩��
	if "%EndString%" EQU "" (
		REM ��ࠬ��� �� �����
		REM echo.EndLine		End of the file
	) else (
		REM ��ࠬ��� �����
		for /f "tokens=1 delims=:" %%a in ('findstr /i /x /n /c:"%EndString%" "%TmpFile%"') do (
			REM ��।������ ��६�����
			set "EndLine=%%a"
		)
		REM �뢮� ��६����� �� �࠭
		REM echo.EndLine		!EndLine!
	)

	echo.	%OutputFile% & echo.%Sepatator%

	REM �������� ���⮣� 䠩�� / ���࠭�� 㦥 �������饣�
	if exist "%OutputFile%" del "%OutputFile%"
	REM type nul > "%OutputFile%"

	REM ��ନ஢���� 䠩��-१���� �� ��ப ����� "��砫쭮�" � "����筮�" ��ப��� (��� UTF-8)
	chcp 65001 > nul
	for /f "skip=%StartLine% tokens=1,* delims=:" %%a in ('findstr /i /n /r ".*" "%TmpFile%"') do (
	chcp %ProgramEncoding% > nul

	REM ��।������ ��६�����
		set "CurrentLine=%%a"
		set "CurrentString=%%b"
		REM ��।������ ������ ��ࠬ��� � ���浪����� ����� "����筮� ��ப�"
		if "%EndString%" EQU "" (
			REM ��ࠬ��� �� �����
			REM ������� "call" ���⠢��� ��ࠡ��稪 ����୮ ��ࠡ���� ��६���� � ��ப� (�㦭� ��� ��ࠡ�⪨ ��६����� �।�, ��⠭��� �� 䠩��)
			call echo.!CurrentString!
			call echo.!CurrentString!>>"%OutputFile%"
		) else (
			REM ��ࠬ��� �����
			REM �ࠢ����� ���浪���� ����஢ "����饩" � "����筮�" ��ப
			if !CurrentLine! LSS !EndLine! (
				REM ������� "call" ���⠢��� ��ࠡ��稪 ����୮ ��ࠡ���� ��६���� � ��ப� (�㦭� ��� ��ࠡ�⪨ ��६����� �।�, ��⠭��� �� 䠩��)
				call echo.!CurrentString!
				call echo.!CurrentString!>>"%OutputFile%"
			)
		)
	)
	echo.%Sepatator%
	setLocal DisableDelayedExpansion

	REM �������� �६������ 䠩��
	del "%TmpFile%"

	echo.
exit /b

REM =================================================================================================================
REM 																		������� �������� ������� �����������
REM
REM ���ᠭ��	-	�஢���� ����稥 �ᯮ��塞�� 䠩��� ��娢��஢ (��⥬��� � ���짮��⥫�᪨�)
REM =================================================================================================================
:CheckArchivers
	REM �ᯮ��塞� 䠩�� ��娢��஢, ���⠢�塞� ����� � �ணࠬ���
	set "WinRar=Manager\bin\Rar.exe"
	set "SevenZip=Manager\bin\7z.exe"

	REM �ᯮ��塞� 䠩�� ��娢��஢, ��⠭�������� �� �������� ���짮��⥫�
	if not exist "%WinRar%" (set "WinRar=%ProgramFiles%\WinRAR\Rar.exe")
	if not exist "%SevenZip%" (set "SevenZip=%ProgramFiles%\7-Zip\7z.exe")

	REM �஢�ઠ ������ ��娢��஢
	if not exist "%SevenZip%" (
		if not exist "%WinRar%" (goto NoArchiver)
	)
	if not exist "%WinRar%" (
		if not exist "%SevenZip%" (goto NoArchiver)
	)
exit /b

REM �뢮� ᮮ�饭�� �� �訡��
:NoArchiver
	cls
  if /i {%lang%}=={0419} (echo.������: �ᯮ��塞� 䠩�� 7-Zip � WinRar �� �������.) else (echo.ERROR: 7-Zip & WinRar executables are not found.)
  goto :End

REM =================================================================================================================
REM 																						����� ���������� �� �������������
REM
REM ���ᠭ��	-	�뢮��� �������� �� �ᯮ�짮����� �ணࠬ�� / ᮧ���� ���⮩ 䠩� ��� ��ࠡ�⪨
REM =================================================================================================================
:Usage
	cls
	set "EmptyFile=%~dp0new BACKUP.ini"

	if /i {%lang%}=={0419} (echo.��� ᮧ����� १�ࢭ�� ����� ����室�� 䠩� ����:) else (echo.To create a backup file list is required:)
	echo.
	echo.[Description]
	echo.Name=
	echo.Password=
	echo.RootDir=
	echo.[IncludeList]
	echo.[ExcludeList]

	echo.

	if /i {%lang%}=={0419} (echo.�롮� ����⢨�:) else (echo.Choose action:)
	REM echo.
	if /i {%lang%}=={0419} (echo. ^(1^) - ������� ���⮩ %EmptyFile%) else (echo. ^(1^) - Create empty %EmptyFile%)
	if /i {%lang%}=={0419} (echo. ^(2^) - ��室) else (echo. ^(2^) - Exit)
	echo.
	if /i {%lang%}=={0419} (SET /P ANSWER="�롥�� ����⢨�: ") else (SET /P ANSWER="Choose action: ")
	if /i {%ANSWER%}=={1} (goto :CreateEmptyFile)
	if /i {%ANSWER%}=={2} (exit)
	goto :Usage

	:CreateEmptyFile
		 >"%EmptyFile%" echo.[Description]
		REM >>"%EmptyFile%" echo.; �������� ��娢�
		>>"%EmptyFile%" echo.Name=
		REM >>"%EmptyFile%" echo.; ��஫�
		>>"%EmptyFile%" echo.Password=
		REM >>"%EmptyFile%" echo.; ��୥��� ��⠫��
		>>"%EmptyFile%" echo.RootDir=
		>>"%EmptyFile%" echo.
		REM >>"%EmptyFile%" echo.; ᯨ᮪ ����祭��
		>>"%EmptyFile%" echo.[IncludeList]
		>>"%EmptyFile%" echo.
		REM >>"%EmptyFile%" echo.; ᯨ᮪ �᪫�祭��
		>>"%EmptyFile%" echo.[ExcludeList]

		REM ����� ����஢�� 䠩��
		REM call :EncodeFile "%EmptyFile%", "65001"

exit /b

REM =================================================================================================================
REM 																							���������� ���������
REM
REM ���ᠭ��	-	�������� �६����� 䠩���, �����襭�� ࠡ��� �ணࠬ�� / ������ ������� � ����
REM =================================================================================================================
:End
  echo.
	del "%IncludeList%"
	del "%ExcludeList%"
  pause
  goto :CreateBackup
