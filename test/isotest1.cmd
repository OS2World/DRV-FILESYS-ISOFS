@echo off
set UNIXROOT=C:
set PATH=C:\usr\bin;%PATH%
detach C:\ISOFS\isofsdmn.exe
C:\usr\bin\sleep.exe 3
C:\ISOFS\mapiso.exe X: C:\ISOFS\test.iso 2>&1
dir X:\ /b 2>&1
echo ---- md5 through the new ISOFS
C:\usr\bin\md5sum.exe "X:/scitech-display-doctor-win-7.0.0.340-beta.exe" X:/sdd7.txt 2>&1
echo ---- text file
type X:\sdd7.txt 2>&1
