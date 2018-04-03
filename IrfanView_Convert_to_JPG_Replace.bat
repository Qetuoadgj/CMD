cls
@echo off
cd /d "%~dp0"
if "%~1" == "" goto :Exit
set "i_view32=%ProgramFiles%\IrfanView\i_view32.exe"
setLocal EnableDelayedExpansion
set /a "i=0"
for %%F in (%*) do (
	set "parse="
	REM
	if /i "%%~xF" == ".ANI" set "parse=TRUE"
	if /i "%%~xF" == ".CUR" set "parse=TRUE"
	if /i "%%~xF" == ".AWD" set "parse=TRUE"
	if /i "%%~xF" == ".B3D" set "parse=TRUE"
	if /i "%%~xF" == ".BMP" set "parse=TRUE"
	if /i "%%~xF" == ".DIB" set "parse=TRUE"
	if /i "%%~xF" == ".CAM" set "parse=TRUE"
	if /i "%%~xF" == ".CLP" set "parse=TRUE"
	if /i "%%~xF" == ".CPT" set "parse=TRUE"
	if /i "%%~xF" == ".CRW" set "parse=TRUE"
	if /i "%%~xF" == ".CR2" set "parse=TRUE"
	if /i "%%~xF" == ".DCM" set "parse=TRUE"
	if /i "%%~xF" == ".ACR" set "parse=TRUE"
	if /i "%%~xF" == ".IMA" set "parse=TRUE"
	if /i "%%~xF" == ".DCX" set "parse=TRUE"
	if /i "%%~xF" == ".DDS" set "parse=TRUE"
	if /i "%%~xF" == ".DJVU" set "parse=TRUE"
	if /i "%%~xF" == ".IW44" set "parse=TRUE"
	if /i "%%~xF" == ".DXF" set "parse=TRUE"
	if /i "%%~xF" == ".DXF" set "parse=TRUE"
	if /i "%%~xF" == ".DWG" set "parse=TRUE"
	if /i "%%~xF" == ".HPGL" set "parse=TRUE"
	if /i "%%~xF" == ".CGM" set "parse=TRUE"
	if /i "%%~xF" == ".SVG" set "parse=TRUE"
	if /i "%%~xF" == ".ECW" set "parse=TRUE"
	if /i "%%~xF" == ".EMF" set "parse=TRUE"
	if /i "%%~xF" == ".EPS" set "parse=TRUE"
	if /i "%%~xF" == ".PS" set "parse=TRUE"
	if /i "%%~xF" == ".PDF" set "parse=TRUE"
	if /i "%%~xF" == ".AI" set "parse=TRUE"
	if /i "%%~xF" == ".EXR" set "parse=TRUE"
	if /i "%%~xF" == ".FITS" set "parse=TRUE"
	if /i "%%~xF" == ".FPX" set "parse=TRUE"
	if /i "%%~xF" == ".G3" set "parse=TRUE"
	if /i "%%~xF" == ".GIF" set "parse=TRUE"
	if /i "%%~xF" == ".HDR" set "parse=TRUE"
	if /i "%%~xF" == ".HDP" set "parse=TRUE"
	if /i "%%~xF" == ".JXR" set "parse=TRUE"
	if /i "%%~xF" == ".WDP" set "parse=TRUE"
	if /i "%%~xF" == ".ICL" set "parse=TRUE"
	if /i "%%~xF" == ".EXE" set "parse=TRUE"
	if /i "%%~xF" == ".DLL" set "parse=TRUE"
	if /i "%%~xF" == ".ICO" set "parse=TRUE"
	if /i "%%~xF" == ".ICS" set "parse=TRUE"
	if /i "%%~xF" == ".IFF" set "parse=TRUE"
	if /i "%%~xF" == ".LBM" set "parse=TRUE"
	if /i "%%~xF" == ".IMG" set "parse=TRUE"
	if /i "%%~xF" == ".JP2" set "parse=TRUE"
	if /i "%%~xF" == ".JPC" set "parse=TRUE"
	if /i "%%~xF" == ".J2K" set "parse=TRUE"
	if /i "%%~xF" == ".JPG" set "parse=TRUE"
	if /i "%%~xF" == ".JPEG" set "parse=TRUE"
	if /i "%%~xF" == ".JLS" set "parse=TRUE"
	if /i "%%~xF" == ".JPM" set "parse=TRUE"
	if /i "%%~xF" == ".KDC" set "parse=TRUE"
	if /i "%%~xF" == ".PICT" set "parse=TRUE"
	if /i "%%~xF" == ".QTIF" set "parse=TRUE"
	if /i "%%~xF" == ".MNG" set "parse=TRUE"
	if /i "%%~xF" == ".JNG" set "parse=TRUE"
	if /i "%%~xF" == ".MRC" set "parse=TRUE"
	if /i "%%~xF" == ".MrSID" set "parse=TRUE"
	if /i "%%~xF" == ".SID" set "parse=TRUE"
	if /i "%%~xF" == ".DNG" set "parse=TRUE"
	if /i "%%~xF" == ".EEF" set "parse=TRUE"
	if /i "%%~xF" == ".NEF" set "parse=TRUE"
	if /i "%%~xF" == ".MRW" set "parse=TRUE"
	if /i "%%~xF" == ".ORF" set "parse=TRUE"
	if /i "%%~xF" == ".RAF" set "parse=TRUE"
	if /i "%%~xF" == ".DCR" set "parse=TRUE"
	if /i "%%~xF" == ".SRF" set "parse=TRUE"
	if /i "%%~xF" == ".ARW" set "parse=TRUE"
	if /i "%%~xF" == ".PEF" set "parse=TRUE"
	if /i "%%~xF" == ".X3F" set "parse=TRUE"
	if /i "%%~xF" == ".RW2" set "parse=TRUE"
	if /i "%%~xF" == ".NRW" set "parse=TRUE"
	if /i "%%~xF" == ".PBM" set "parse=TRUE"
	if /i "%%~xF" == ".PCD" set "parse=TRUE"
	if /i "%%~xF" == ".PCX" set "parse=TRUE"
	if /i "%%~xF" == ".PDF" set "parse=TRUE"
	if /i "%%~xF" == ".PDN" set "parse=TRUE"
	if /i "%%~xF" == ".PGM" set "parse=TRUE"
	if /i "%%~xF" == ".PNG" set "parse=TRUE"
	if /i "%%~xF" == ".PPM" set "parse=TRUE"
	if /i "%%~xF" == ".PSD" set "parse=TRUE"
	if /i "%%~xF" == ".PSP" set "parse=TRUE"
	if /i "%%~xF" == ".PVR" set "parse=TRUE"
	if /i "%%~xF" == ".RAS" set "parse=TRUE"
	if /i "%%~xF" == ".SUN" set "parse=TRUE"
	if /i "%%~xF" == ".RAW" set "parse=TRUE"
	if /i "%%~xF" == ".YUV" set "parse=TRUE"
	if /i "%%~xF" == ".RLE" set "parse=TRUE"
	if /i "%%~xF" == ".SFF" set "parse=TRUE"
	if /i "%%~xF" == ".SFW" set "parse=TRUE"
	if /i "%%~xF" == ".SGI" set "parse=TRUE"
	if /i "%%~xF" == ".RGB" set "parse=TRUE"
	if /i "%%~xF" == ".SIF" set "parse=TRUE"
	if /i "%%~xF" == ".SWF" set "parse=TRUE"
	if /i "%%~xF" == ".FLV" set "parse=TRUE"
	if /i "%%~xF" == ".TGA" set "parse=TRUE"
	if /i "%%~xF" == ".TIF" set "parse=TRUE"
	if /i "%%~xF" == ".TIFF" set "parse=TRUE"
	if /i "%%~xF" == ".TTF" set "parse=TRUE"
	if /i "%%~xF" == ".TXT" set "parse=TRUE"
	if /i "%%~xF" == ".VTF" set "parse=TRUE"
	if /i "%%~xF" == ".WAD" set "parse=TRUE"
	if /i "%%~xF" == ".WAL" set "parse=TRUE"
	if /i "%%~xF" == ".WBC" set "parse=TRUE"
	if /i "%%~xF" == ".WBZ" set "parse=TRUE"
	if /i "%%~xF" == ".WBMP" set "parse=TRUE"
	if /i "%%~xF" == ".WebP" set "parse=TRUE"
	if /i "%%~xF" == ".WMF" set "parse=TRUE"
	if /i "%%~xF" == ".WSQ" set "parse=TRUE"
	if /i "%%~xF" == ".XBM" set "parse=TRUE"
	if /i "%%~xF" == ".XCF" set "parse=TRUE"
	if /i "%%~xF" == ".XPM" set "parse=TRUE"
	REM
	if /i "!parse!" == "TRUE" (
		set /a "i=!i!+1"
		if !i! equ 1 (
			cd /d "%%~dpF"
			REM set "Out_Dir=!cd!\IrfanView_JPG\"
			set "Out_Dir=!cd!"
			if exist "!Out_Dir!" rd "!Out_Dir!" /q
		)
		echo.!i!. %%~nxF
		set "i_file=%%~nxF"
		set "o_file=!Out_Dir!\%%~nF.jpg"
		if exist "!o_file!" del "!o_file!" /q
		"%i_view32%" "!i_file!" /jpgq=80 /convert="!o_file!" /one
		if exist "!o_file!" del "!i_file!" /q
		REM echo.file !o_file! >> "!cd!\mylist.txt"
	)
)
setLocal DisableDelayedExpansion
pause & goto :Exit
:Exit
exit