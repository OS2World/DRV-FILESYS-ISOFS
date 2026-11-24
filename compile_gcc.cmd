@echo off
rem compile_gcc.cmd - build the ISOFS daemon and utilities (isofsdmn, mapiso, isoinfo, isodrive) with GCC 9 / kLIBC
rem   compile_gcc.cmd         build, log in compile_gcc.log, output in bin\
rem   compile_gcc.cmd clean   remove bin\ and the log
rem Needs GCC 9 (ANPM), watcom-wlink-hll (wl.exe), Open Watcom at C:\WATCOM and the OS/2 Toolkit 4.5 (rc, mkmsgf).
rem The file list is written out file by file because the OS/2 CMD.EXE has no CALL :label.
set WATCOM=C:\WATCOM
set PATH=C:\usr\bin;%WATCOM%\BINP;%WATCOM%\BINW;C:\os2tk45\bin;%PATH%
set UNIXROOT=C:
set C_INCLUDE_PATH=C:/usr/include;C:/os2tk45/h
set LIBRARY_PATH=C:/usr/lib
set EMXOMFLD_TYPE=WLINK
set EMXOMFLD_LINKER=wl.exe
set EMXOMFLD_PRELINK=0
if "%1"=="clean" goto clean
if not exist bin md bin
if exist bin\*.exe del bin\*.exe < nul
if not exist bin\obj md bin\obj
if exist bin\obj\*.obj del bin\obj\*.obj < nul
set INCS=-Isrc/include -Isrc/driver -Isrc/system -Isrc/system/os2 -Isrc/daemon
echo ==== compile > compile_gcc.log
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_base.obj src/libunls/nls_base.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp437.obj src/libunls/nls_cp437.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp737.obj src/libunls/nls_cp737.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp775.obj src/libunls/nls_cp775.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp850.obj src/libunls/nls_cp850.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp852.obj src/libunls/nls_cp852.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp855.obj src/libunls/nls_cp855.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp857.obj src/libunls/nls_cp857.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp860.obj src/libunls/nls_cp860.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp861.obj src/libunls/nls_cp861.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp862.obj src/libunls/nls_cp862.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp863.obj src/libunls/nls_cp863.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp864.obj src/libunls/nls_cp864.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp865.obj src/libunls/nls_cp865.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp866.obj src/libunls/nls_cp866.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp869.obj src/libunls/nls_cp869.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_cp874.obj src/libunls/nls_cp874.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-1.obj src/libunls/nls_iso8859-1.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-14.obj src/libunls/nls_iso8859-14.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-15.obj src/libunls/nls_iso8859-15.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-2.obj src/libunls/nls_iso8859-2.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-3.obj src/libunls/nls_iso8859-3.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-4.obj src/libunls/nls_iso8859-4.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-5.obj src/libunls/nls_iso8859-5.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-6.obj src/libunls/nls_iso8859-6.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-7.obj src/libunls/nls_iso8859-7.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-8.obj src/libunls/nls_iso8859-8.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_iso8859-9.obj src/libunls/nls_iso8859-9.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_koi8-r.obj src/libunls/nls_koi8-r.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\nls_mac-roman.obj src/libunls/nls_mac-roman.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\os2.obj src/system/os2/os2.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\isofsdmn.obj src/daemon/isofsdmn.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\isoacces.obj src/daemon/isoacces.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\attach.obj src/daemon/attach.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\find.obj src/daemon/find.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\misc.obj src/daemon/misc.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\dir.obj src/daemon/dir.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\openclos.obj src/daemon/openclos.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\fileio.obj src/daemon/fileio.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\fileinfo.obj src/daemon/fileinfo.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\fileop.obj src/daemon/fileop.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\ea.obj src/daemon/ea.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\utils.obj src/daemon/utils.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\mapiso.obj src/daemon/mapiso.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\isoinfo.obj src/daemon/isoinfo.c >> compile_gcc.log 2>&1
gcc -Zomf -O2 -Wall -Wno-parentheses -std=gnu99 -DSYSTEM=os2 -Dlint %INCS% -c -o bin\obj\isodrive.obj src/daemon/isodrive.c >> compile_gcc.log 2>&1
echo ==== resources and messages >> compile_gcc.log
rc -r src\daemon\isodrive.rc bin\isodrive.res >> compile_gcc.log 2>&1
mkmsgf src\daemon\isodrive_de.nls bin\isodrive_de.msg >> compile_gcc.log 2>&1
mkmsgf src\daemon\isodrive_en.nls bin\isodrive_en.msg >> compile_gcc.log 2>&1
mkmsgf src\daemon\isodrive_es.nls bin\isodrive_es.msg >> compile_gcc.log 2>&1
echo ==== link >> compile_gcc.log
set LIBS=bin\obj\nls_base.obj bin\obj\nls_cp437.obj bin\obj\nls_cp737.obj bin\obj\nls_cp775.obj bin\obj\nls_cp850.obj bin\obj\nls_cp852.obj bin\obj\nls_cp855.obj bin\obj\nls_cp857.obj bin\obj\nls_cp860.obj bin\obj\nls_cp861.obj bin\obj\nls_cp862.obj bin\obj\nls_cp863.obj bin\obj\nls_cp864.obj bin\obj\nls_cp865.obj bin\obj\nls_cp866.obj bin\obj\nls_cp869.obj bin\obj\nls_cp874.obj bin\obj\nls_iso8859-1.obj bin\obj\nls_iso8859-14.obj bin\obj\nls_iso8859-15.obj bin\obj\nls_iso8859-2.obj bin\obj\nls_iso8859-3.obj bin\obj\nls_iso8859-4.obj bin\obj\nls_iso8859-5.obj bin\obj\nls_iso8859-6.obj bin\obj\nls_iso8859-7.obj bin\obj\nls_iso8859-8.obj bin\obj\nls_iso8859-9.obj bin\obj\nls_koi8-r.obj bin\obj\nls_mac-roman.obj bin\obj\os2.obj
gcc -Zomf -o bin\isofsdmn.exe bin\obj\isofsdmn.obj bin\obj\isoacces.obj bin\obj\attach.obj bin\obj\find.obj bin\obj\misc.obj bin\obj\dir.obj bin\obj\openclos.obj bin\obj\fileio.obj bin\obj\fileinfo.obj bin\obj\fileop.obj bin\obj\ea.obj bin\obj\utils.obj %LIBS% >> compile_gcc.log 2>&1
gcc -Zomf -o bin\mapiso.exe bin\obj\mapiso.obj %LIBS% >> compile_gcc.log 2>&1
gcc -Zomf -o bin\isoinfo.exe bin\obj\isoinfo.obj %LIBS% >> compile_gcc.log 2>&1
gcc -Zomf -o bin\isodrive.exe bin\obj\isodrive.obj %LIBS% src/daemon/isodrive.def >> compile_gcc.log 2>&1
if exist bin\isodrive.exe rc -x2 -n bin\isodrive.res bin\isodrive.exe >> compile_gcc.log 2>&1
set FAIL=0
if not exist bin\isofsdmn.exe set FAIL=1
if not exist bin\mapiso.exe set FAIL=1
if not exist bin\isoinfo.exe set FAIL=1
if not exist bin\isodrive.exe set FAIL=1
if "%FAIL%"=="1" goto failed
echo OK: bin\isofsdmn.exe bin\mapiso.exe bin\isoinfo.exe bin\isodrive.exe
echo OK >> compile_gcc.log
goto end
:failed
echo FAILED, see compile_gcc.log
echo FAILED >> compile_gcc.log
goto end
:clean
if exist bin rmdir /s /q bin
if exist compile_gcc.log del compile_gcc.log
:end
