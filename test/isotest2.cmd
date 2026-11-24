@echo off
set UNIXROOT=C:
set PATH=C:\usr\bin;%PATH%
echo ---- second drive Y: with the same image
C:\ISOFS\mapiso.exe Y: C:\ISOFS\test.iso 2>&1
C:\usr\bin\md5sum.exe Y:/sdd7.txt 2>&1
echo ---- list mounts
C:\ISOFS\mapiso.exe 2>&1
echo ---- unmap X: and Y:
C:\ISOFS\mapiso.exe X: -d 2>&1
C:\ISOFS\mapiso.exe Y: -d 2>&1
dir X: 2>&1 | head -2
echo ---- remount and copy the big file
C:\ISOFS\mapiso.exe X: C:\ISOFS\test.iso 2>&1
copy "X:\scitech-display-doctor-win-7.0.0.340-beta.exe" C:\ISOFS\copy.exe 2>&1
C:\usr\bin\md5sum.exe C:/ISOFS/copy.exe 2>&1
del C:\ISOFS\copy.exe > nul 2>&1
echo ---- open file keeps the volume busy: unmap without -f
C:\ISOFS\mapiso.exe X: -d 2>&1
echo ---- isoinfo on the image
C:\ISOFS\isoinfo.exe -d -i C:\ISOFS\test.iso 2>&1 | head -6
echo ---- ISODrive starts and exits
C:\usr\bin\sleep.exe 1
