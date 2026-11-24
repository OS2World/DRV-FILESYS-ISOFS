@echo off
set UNIXROOT=C:
set PATH=C:\usr\bin;%PATH%
C:\usr\bin\md5sum.exe "X:/scitech-display-doctor-win-7.0.0.340-beta.exe" X:/sdd7.txt > C:\ISOFS\base_md5.txt 2>&1
type C:\ISOFS\base_md5.txt > C:\ISOFS\base3.log
C:\sys\bin\mapiso.exe X: -d >> C:\ISOFS\base3.log 2>&1
dir X: >> C:\ISOFS\base3.log 2>&1
