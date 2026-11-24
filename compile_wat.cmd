@echo off
rem compile_wat.cmd - build the ring 0 stub IFS (isofs.ifs) with Open Watcom 2 (run from the project root)
rem   compile_wat.cmd         build, log in compile_wat.log
rem   compile_wat.cmd clean   remove the IFS and the log
rem The 32-bit daemon and utilities are built by compile_gcc.cmd.
set WATCOM=C:\WATCOM
set PATH=%WATCOM%\BINP;%WATCOM%\BINW;%PATH%
set EDPATH=%WATCOM%\EDDAT
if not exist "%WATCOM%\BINP\WMAKE.EXE" goto missing_wmake
if "%1"=="clean" goto clean
if exist bin\isofs.ifs del bin\isofs.ifs < nul
echo Building the stub IFS ...
"%WATCOM%\BINP\WMAKE.EXE" -h -a -f Makefile.wat > compile_wat.log 2>&1 < nul
if not exist bin\isofs.ifs goto build_failed
echo OK: bin\isofs.ifs
dir bin\isofs.ifs
goto end
:clean
if exist bin\isofs.ifs del bin\isofs.ifs < nul
if exist compile_wat.log del compile_wat.log
echo OK: cleaned.
goto end
:missing_wmake
echo FAILED: Open Watcom wmake was not found at %WATCOM%\BINP\WMAKE.EXE.
goto end
:build_failed
type compile_wat.log
echo FAILED: the stub IFS was not built. See compile_wat.log.
:end
