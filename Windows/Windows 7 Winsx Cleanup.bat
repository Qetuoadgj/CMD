@echo off
cd /d "%WINDIR%\system32"
DISM /online /Cleanup-Image /SpSuperseded
pause
