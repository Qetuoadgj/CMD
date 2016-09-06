@echo off
cls
REM call :Start "C:\Users\Антон\Documents\Coding\Новая папка\Notepad++ BACKUP.ini"
:Vars
	cls

	REM Определение системного языка (0419 - Русский)
  for /f "tokens=3 delims= " %%g in ('reg query "hklm\system\controlset001\control\nls\language" /v Installlanguage') do (set "lang=%%g")

	REM Определение полного пути файла для обработки
	set "MainFile=%~f1"
	REM Определение имени файла для обработки
	set "MainFileShort=%~nx1"

	REM Определение папки
	set "WorkingDir=%~dp1"

	REM Передача текущей кодировки в переменную %ProgramEncoding%
	call :CurrentEncoding "ProgramEncoding"

	REM Определение текущей даты
  set "YYYY=%DATE:~-4%"
	set "MM=%DATE:~3,2%"
	set "DD=%DATE:~0,2%"

	REM Прекращение выполнения программы если отсутствует исходный файл
	if not exist "%MainFile%" goto :Usage

	REM Выбор рабочей папки
	cd /d "%WorkingDir%"

	REM Получение переменной имени из файла (UTF-8)
	chcp 65001 > nul
  for /f "tokens=1,2,* delims==: " %%a in ('findstr /i /n /r "^Name.*" "%MainFile%"') do (
	chcp %ProgramEncoding% > nul

    set Name=%%~c
	)
	REM Получение переменной пароля из файла (UTF-8)
	chcp 65001 > nul
  for /f "tokens=1,2,* delims==: " %%a in ('findstr /i /n /r "^Password.*" "%MainFile%"') do (
	chcp %ProgramEncoding% > nul

    set Password=%%c
	)
	REM Получение переменной рабочей папки из файла (UTF-8)
	chcp 65001 > nul
  for /f "tokens=1,2,* delims==: " %%a in ('findstr /i /n /r "^RootDir.*" "%MainFile%"') do (
	chcp %ProgramEncoding% > nul

    call set RootDir=%%~c
	)
	REM Контрольная смена кодировки
	chcp %ProgramEncoding% > nul

	call :CreateBackup

	goto End
exit /b

REM =================================================================================================================
REM 																		ФУНКЦИЯ СОЗДАНИЯ АРХИВОВ РЕЗЕРВНЫХ КОПИЙ
REM =================================================================================================================
:CreateBackup
	cls

  REM Проверка наличия архиваторов
	call :CheckArchivers

  REM Определение названия файла резервной копии "Название (Год.Месяц.День)"
  set "Archive=%Name% (%YYYY%.%MM%.%DD%)"

	REM Определение файлов-списков для обработки архиваторами
	set "IncludeList=IncludeList.txt"
	set "ExcludeList=ExcludeList.txt"

	REM Заголовок окна приложения
  TITLE Create Backup: %Name%

	REM set "ANSWER=2"

	:BackupMenu
		REM goto :StartBackup
		cls

		REM Вывод файла на экран
		echo.%MainFile%
		echo.%Archive%

		if /i {%lang%}=={0419} (echo.Выбор сжатия:) else (echo.Compression select:)
		echo.
		echo. (1) - 7-Zip
		echo. (2) - WinRar
		echo. (3) - 7-Zip, WinRar
		echo.
		REM if /i {%lang%}=={0419} (echo. ^(4^) - Вернуться в главное меню) else (echo. ^(4^) - Go back to the main menu)
		if /i {%lang%}=={0419} (echo. ^(4^) - Выход) else (echo. ^(4^) - Exit)
		echo.
		if /i {%lang%}=={0419} (SET /P ANSWER="Выберите формат сжатия: ") else (SET /P ANSWER="Choose compression format: ")
		echo.
		if /i {%ANSWER%}=={1} (goto :StartBackup)
		if /i {%ANSWER%}=={2} (goto :StartBackup)
		if /i {%ANSWER%}=={3} (goto :StartBackup)
		REM if /i {%ANSWER%}=={4} (exit /b)
		if /i {%ANSWER%}=={4} (exit)
		goto :BackupMenu

  :StartBackup
		REM Создание файлов-списков
		call :FileSplit "%MainFile%", "%IncludeList%", "[IncludeList]", "[ExcludeList]"
		call :FileSplit "%MainFile%", "%ExcludeList%", "[ExcludeList]"

    if /i {%ANSWER%}=={1} (goto :7-Zip)
    if /i {%ANSWER%}=={2} (goto :WinRar)

	:7-Zip
		if exist %SevenZip% (

			REM Смена кодировки файла
			REM call :EncodeFile "%IncludeList%", "65001"
			REM call :EncodeFile "%ExcludeList%", "65001"

			REM Определение временных переменных, которые позже будут стёрты
			setLocal
			REM Определение переменных
			REM Тип архива
			set "Type=7z"
			REM Пароль на архив
			set "Password=-p%Password%"
			REM Метод сжатия
			set "Compression=-m0=LZMA2 -mx9"
			REM Файл-список включаемых в обработку объектов (UTF-8)
			REM set Include=-i@"%IncludeList%"
			set Include=-i@"%WorkingDir%\%IncludeList%"
			REM Файл-список исключаемых из обработки объектов (UTF-8)
			REM set Exclude=-x@"%ExcludeList%"
			set Exclude=-x@"%WorkingDir%\%ExcludeList%"
			REM Методы резервного копирования:
			REM Синхронизация файлов
			set "Synchronize=p0q0r2x1y2z1w2"
			REM Инкриментный архив
			set "Incrimental=p1q1r0x1y2z1w2"
			REM Команда на выполнение архивации
			REM set Command="%SevenZip%" u -u%Synchronize% %Compression% -r0 -slp -t%Type% %Password% "%Archive%.%Type%" %Exclude% %Include% "%MainFileShort%" -spf2
			set Command="%SevenZip%" u -u%Synchronize% %Compression% -r0 -slp -t%Type% %Password% "%WorkingDir%\%Archive%.%Type%" %Exclude% %Include% "%MainFileShort%" -spf2

			TITLE %Archive%.%Type%

			if "%RootDir%" EQU "" (
				REM Вывод команды на экран и её выполнение
				echo.%Command% & call %Command%
			) else (
				REM Смена рабочей папки
				cd /d "%RootDir%"
				REM Временное копирование файла-списка в рабочую папку
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( copy /y "%MainFile%" "%MainFileShort%" )
				REM Вывод команды на экран и её выполнение
				echo.%Command% & call %Command%
				REM Удаление временного файла-списка
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( del "%MainFileShort%" )
				REM Возврат рабочей папки
				cd /d "%WorkingDir%"
			)

			REM Вытирание определенных ранее временных переменных
			endLocal

			if /i {%ANSWER%}=={3} (goto :WinRar)
		)
		goto :End
	:WinRaR
		if exist %WinRar% (

			REM Смена кодировки файла
			call :EncodeFile "%IncludeList%", "1251"
			call :EncodeFile "%ExcludeList%", "1251"

			REM Определение временных переменных, которые позже будут стёрты
			setLocal
			REM Тип архива
			set "Type=rar"
			REM Пароль на архив
			set "Password=-p%Password%"
			REM Метод сжатия
			set "Compression=-m5 -rr5p"
			REM Файл-список включаемых в обработку объектов (ANSI)
			REM set Include="%MainFileShort%" -@n"%IncludeList%"
			set Include="%MainFileShort%" @"%WorkingDir%\%IncludeList%"
			REM Удаление лишних косых (\\) из пути файла
			set "Include=%Include:\\=\%"
			REM Файл-список исключаемых из обработки объектов (ANSI)
			set Exclude=-x@"%WorkingDir%\%ExcludeList%"
			REM Удаление лишних косых (\\) из пути файла
			set "Exclude=%Exclude:\\=\%"
			REM Методы резервного копирования:
			REM Синхронизация файлов
			set "Synchronize= -as"
			REM Инкриментный архив
			REM set "Incrimental=p1q1r0x1y2z1w2"

			REM Команда на выполнение архивации
			set Command="%WinRar%" u -u%Synchronize% %Compression% -r0 %Password% "%WorkingDir%\%Archive%.%Type%" %Include% %Exclude%

			TITLE %Archive%.%Type%

			if "%RootDir%" EQU "" (
				REM Вывод команды на экран и её выполнение
				echo.%Command% & call %Command%
			) else (
				REM Смена рабочей папки
				cd /d "%RootDir%"
				REM Временное копирование файла-списка в рабочую папку
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( copy /y "%MainFile%" "%MainFileShort%" )
				REM Вывод команды на экран и её выполнение
				echo.%Command% & call %Command%
				REM Удаление временного файла-списка
				if not "%RootDir%\%MainFileShort%" EQU "%MainFile%" ( del "%MainFileShort%" )
				REM Возврат рабочей папки
				cd /d "%WorkingDir%"
			)

			REM Вытирание определенных ранее временных переменных
			endLocal
		)

		goto :End
  pause
exit /b

REM =================================================================================================================
REM 																	ФУНКЦИЯ ПОЛУЧЕНИЯ ТЕКУЩЕЙ КОДИРОВКИ ПРОГРАММЫ
REM
REM Описание	-	Присваивает указаному аргументу значение текущей кодировки "chcp"
REM Синтаксис	-	call :CurrentEncoding "Переменная-результат"
REM =================================================================================================================
:CurrentEncoding
	for /f "usebackq tokens=2 delims=:" %%a in (`chcp`) do (set "CurrentEncoding=%%a")
	set "%~1=%CurrentEncoding: =%"
exit /b

REM =================================================================================================================
REM 																	     ФУНКЦИЯ СМЕНЫ КОДИРОВКИ ФАЙЛА
REM
REM Описание	-	Записывает файл в указанной кодировке
REM Синтаксис	-	call :EncodeFile "Исходный файл", "Кодировка", "Файл-Результат"
REM =================================================================================================================
:EncodeFile
	REM Определение переменных
	set "SourceFile=%~1"
	set "SourceFileShort=%~nx1"
	set "Encoding=%~2"
	set "OutputFile=%~3"

	REM Создание пустого файла / вытирание уже существующего
	if exist "%OutputFile%" del "%OutputFile%"

	REM Проверка наличия параметра "Файл-Результат" и определение его если он не задан
	if "%~3" EQU "" ( set "OutputFile=%~dpn1-%Encoding%%~x1" )

	REM Запись перекодированных строк в файл-результат
	chcp 65001 > nul
	for /f "usebackq tokens=*" %%a in ("%SourceFile%") do (
		chcp %ProgramEncoding% > nul

		REM Вызов функции для смены кодировки текушей строки
		call :EncodeString %%a, "%Encoding%", "%OutputFile%"
	)

	REM Переименование временного файла в файл-результат
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
REM 										   ФУНКЦИЯ ЗАПИСИ В ФАЙЛ-РЕЗУЛЬТАТ ТЕКУШЕЙ СТРОКИ С НУЖНОЙ КОДИРОВКОЙ
REM
REM Описание	-	Записывает строку в указанной кодировке в файл-результат
REM Синтаксис	-	call :EncodeFile "Исходная строка", "Кодировка", "Файл-Результат"
REM =================================================================================================================
:EncodeString
	REM Смена кодировки на желаемую
	chcp %~2 > nul
	REM Запись строки в файл-результат
	echo.%1>>"%~3"
	REM Возварат к программной кодировке
	chcp %ProgramEncoding% > nul
exit /b

REM =================================================================================================================
REM 																		ФУНКЦИЯ РАЗДЕЛЕНИЯ ФАЙЛА НА ЧАСТИ
REM
REM Описание	-	Сохраняет указанные части текстового файла в виде файлов-результатов
REM Синтаксис	-	call :FileSplit "Целевой Файл", "Файл-Результат", "Начальная строка" [, "Конечная строка"]
REM =================================================================================================================
:FileSplit

	REM Передача текущей кодировки в переменную %CurrentEncoding%
	REM call :CurrentEncoding "CurrentEncoding"

	REM Определение переменных
	set "SourceFile=%~1"
	set "OutputFile=%~2"
	set "StartString=%~3"
	set "EndString=%~4"

	set "Sepatator=-----------------------------------------------------"

	REM Определение временного файла для обработки данных
	set "TmpFile=FileSplit.txt"

	REM Вывод переменных на экран
	echo.SourceFile	%SourceFile%
	echo.OutputFile	%OutputFile%
	echo.StartString	%StartString%

	REM Проверка параметра "Конечная строка"
	if "%EndString%" EQU "" (
		REM Параметр не задан
		echo.EndString	Not defined
	) else (
		REM Параметр задан
		echo.EndString	%EndString%
	)

	REM Проверка наличия переменной обрабатываемого файла
	if not exist "%SourceFile%" (
		echo.Source file not exist.
		echo.%SourceFile%
		pause
		exit /b
	)

	echo.

	setLocal EnableDelayedExpansion
	REM Создание пустого файла / вытирание уже существующего
	if exist "%TmpFile%" del "%TmpFile%"
	REM type nul > "%TmpFile%"

	REM Пропуск закоментированных строк и формирование отформатированного временного файла для обработки данных
	for /f "usebackq delims= eol=;" %%a in ("%SourceFile%") do (
		REM echo.%%a
		echo.%%a>>"%TmpFile%"
	)

	REM Определение порядкового номера "Начальной строки" в отформатированном временном файле
	for /f "tokens=1 delims=:" %%a in ('findstr /i /x /n /c:"%StartString%" "%TmpFile%"') do (
		REM Определение переменной
		set "StartLine=%%a"
	)
	REM Вывод переменной на экран
	REM echo.StartLine		%StartLine%

	REM Определение наличия параметра и порядкового номера "Конечной строки" в отформатированном временном файле
	if "%EndString%" EQU "" (
		REM Параметр не задан
		REM echo.EndLine		End of the file
	) else (
		REM Параметр задан
		for /f "tokens=1 delims=:" %%a in ('findstr /i /x /n /c:"%EndString%" "%TmpFile%"') do (
			REM Определение переменной
			set "EndLine=%%a"
		)
		REM Вывод переменной на экран
		REM echo.EndLine		!EndLine!
	)

	echo.	%OutputFile% & echo.%Sepatator%

	REM Создание пустого файла / вытирание уже существующего
	if exist "%OutputFile%" del "%OutputFile%"
	REM type nul > "%OutputFile%"

	REM Формирование файла-результата из строк между "Начальной" и "Конечной" строками (форат UTF-8)
	chcp 65001 > nul
	for /f "skip=%StartLine% tokens=1,* delims=:" %%a in ('findstr /i /n /r ".*" "%TmpFile%"') do (
	chcp %ProgramEncoding% > nul

	REM Определение переменных
		set "CurrentLine=%%a"
		set "CurrentString=%%b"
		REM Определение наличия параметра и порядкового номера "Конечной строки"
		if "%EndString%" EQU "" (
			REM Параметр не задан
			REM Команда "call" заставляет обработчик повторно обработать переменные в строке (нужно для обработки переменных среды, считанных из файла)
			call echo.!CurrentString!
			call echo.!CurrentString!>>"%OutputFile%"
		) else (
			REM Параметр задан
			REM Сравнение порядковых номеров "Текущей" и "Конечной" строк
			if !CurrentLine! LSS !EndLine! (
				REM Команда "call" заставляет обработчик повторно обработать переменные в строке (нужно для обработки переменных среды, считанных из файла)
				call echo.!CurrentString!
				call echo.!CurrentString!>>"%OutputFile%"
			)
		)
	)
	echo.%Sepatator%
	setLocal DisableDelayedExpansion

	REM Удаление временного файла
	del "%TmpFile%"

	echo.
exit /b

REM =================================================================================================================
REM 																		ФУНКЦИЯ ПРОВЕРКИ НАЛИЧИЯ АРХИВАТОРОВ
REM
REM Описание	-	Проверяет наличие исполняемых файлов архиваторов (системных и пользовательских)
REM =================================================================================================================
:CheckArchivers
	REM Исполняемые файлы архиваторов, поставляемые вместе с программой
	set "WinRar=Manager\bin\Rar.exe"
	set "SevenZip=Manager\bin\7z.exe"

	REM Исполняемые файлы архиваторов, установленных на компьютере пользователя
	if not exist "%WinRar%" (set "WinRar=%ProgramFiles%\WinRAR\Rar.exe")
	if not exist "%SevenZip%" (set "SevenZip=%ProgramFiles%\7-Zip\7z.exe")

	REM Проверка наличия архиваторов
	if not exist "%SevenZip%" (
		if not exist "%WinRar%" (goto NoArchiver)
	)
	if not exist "%WinRar%" (
		if not exist "%SevenZip%" (goto NoArchiver)
	)
exit /b

REM Вывод сообщения об ошибке
:NoArchiver
	cls
  if /i {%lang%}=={0419} (echo.ОШИБКА: Исполняемые файлы 7-Zip и WinRar не найдены.) else (echo.ERROR: 7-Zip & WinRar executables are not found.)
  goto :End

REM =================================================================================================================
REM 																						ВЫВОД ИНСТРУКЦИИ ПО ИСПОЛЬЗОВАНИЮ
REM
REM Описание	-	Выводин инструкцию по использованию программы / создает пустой файл для обработки
REM =================================================================================================================
:Usage
	cls
	set "EmptyFile=%~dp0new BACKUP.ini"

	if /i {%lang%}=={0419} (echo.Для создания резервной копии необходим файл вида:) else (echo.To create a backup file list is required:)
	echo.
	echo.[Description]
	echo.Name=
	echo.Password=
	echo.RootDir=
	echo.[IncludeList]
	echo.[ExcludeList]

	echo.

	if /i {%lang%}=={0419} (echo.Выбор действия:) else (echo.Choose action:)
	REM echo.
	if /i {%lang%}=={0419} (echo. ^(1^) - Создать пустой %EmptyFile%) else (echo. ^(1^) - Create empty %EmptyFile%)
	if /i {%lang%}=={0419} (echo. ^(2^) - Выход) else (echo. ^(2^) - Exit)
	echo.
	if /i {%lang%}=={0419} (SET /P ANSWER="Выберите действие: ") else (SET /P ANSWER="Choose action: ")
	if /i {%ANSWER%}=={1} (goto :CreateEmptyFile)
	if /i {%ANSWER%}=={2} (exit)
	goto :Usage

	:CreateEmptyFile
		 >"%EmptyFile%" echo.[Description]
		REM >>"%EmptyFile%" echo.; название архива
		>>"%EmptyFile%" echo.Name=
		REM >>"%EmptyFile%" echo.; пароль
		>>"%EmptyFile%" echo.Password=
		REM >>"%EmptyFile%" echo.; корневой каталог
		>>"%EmptyFile%" echo.RootDir=
		>>"%EmptyFile%" echo.
		REM >>"%EmptyFile%" echo.; список включений
		>>"%EmptyFile%" echo.[IncludeList]
		>>"%EmptyFile%" echo.
		REM >>"%EmptyFile%" echo.; список исключений
		>>"%EmptyFile%" echo.[ExcludeList]

		REM Смена кодировки файла
		REM call :EncodeFile "%EmptyFile%", "65001"

exit /b

REM =================================================================================================================
REM 																							ЗАВЕРШЕНИЕ ПРОГРАММЫ
REM
REM Описание	-	Удаление временных файлов, завершение работы программы / возврат главное в меню
REM =================================================================================================================
:End
  echo.
	del "%IncludeList%"
	del "%ExcludeList%"
  pause
  goto :CreateBackup
