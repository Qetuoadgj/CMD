@echo off
net stop SysMain
REG add "HKLM\SYSTEM\CurrentControlSet\services\SysMain" /v Start /t REG_DWORD /d 4 /f
pause