@echo off
ie4uinit.exe -ClearIconCache
taskkill /IM explorer.exe /F
DEL "%localappdata%\IconCache.db" /A
DEL "%localappdata%\Microsoft\Windows\Explorer\iconcache*" /A
explorer
pause