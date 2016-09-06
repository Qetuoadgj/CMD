@echo off
REG add "HKLM\SYSTEM\CurrentControlSet\services\SysMain" /v Start /t REG_DWORD /d 2 /f
services.msc
pause