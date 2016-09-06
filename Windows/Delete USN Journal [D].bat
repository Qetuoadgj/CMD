@echo off

REM Использование: fsutil usn deletejournal <флаги> <путь к тому>
REM <Флаги>
  REM /D : Удалить
  REM /N : Уведомить
  REM Пример: usn deletejournal /D C:
  
REM Использование: fsutil usn createjournal m=<макс. знач.> a=<разница> <путь>
   REM Пример: fsutil usn createjournal m=1000 a=100 C:
   
fsutil usn deletejournal /d D:

pause

fsutil usn createjournal m=0 a=0 D:

pause