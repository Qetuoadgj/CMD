@echo off

REM �������������: fsutil usn deletejournal <�����> <���� � ����>
REM <�����>
  REM /D : �������
  REM /N : ���������
  REM ������: usn deletejournal /D C:
  
REM �������������: fsutil usn createjournal m=<����. ����.> a=<�������> <����>
   REM ������: fsutil usn createjournal m=1000 a=100 C:
   
fsutil usn deletejournal /d D:

pause

fsutil usn createjournal m=0 a=0 D:

pause