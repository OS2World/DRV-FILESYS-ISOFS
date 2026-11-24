# Open Watcom 2.0 Makefile for the ISOFS ring 0 stub IFS (isofs.ifs)
# Run from the project root (compile_wat.cmd does this).
#
# An IFS is a 16-bit NE library module: compile with the 16-bit compiler and link
# with "system os2 dll". The FSHELPER entry points are imported by ordinal.

WATCOM = C:\WATCOM
CC = $(WATCOM)\binp\wcc.exe
ASM = $(WATCOM)\binp\wasm.exe
LINK = $(WATCOM)\binp\wlink.exe

SRC_DIR = src\driver
BIN_DIR = bin
OBJ = $(BIN_DIR)\stubfsd.obj $(BIN_DIR)\bootmsg.obj $(BIN_DIR)\dhwrap.obj
IFS = $(BIN_DIR)\isofs.ifs
EXPORTS = $(SRC_DIR)\stubfsd_exports.lnk

# -ml large model  -zu SS != DS  -zdp -zff -zgf DS pegged, FS/GS floating
# -zl no default library records  -s no stack checks  -wx all warnings
CFLAGS = -i=$(WATCOM)\h -i=$(WATCOM)\h\os21x -i=$(SRC_DIR) -bt=os2 -ml -s -zdp -zff -zgf -zu -zl -zq -wx -3 -oi

all: $(IFS)

$(IFS): $(OBJ) $(EXPORTS)
	$(LINK) @<<
name $(IFS)
system os2 dll
option protmode
option stack=0
option quiet
option map=$(BIN_DIR)\isofs.map
option description '@#OS2World:1.2.0#@ISOFS stub IFS (Open Watcom)'
library os2
import DOSREAD DOSCALLS.137
import DOSWRITE DOSCALLS.138
import DOSBEEP DOSCALLS.50
import FSH_INTERR FSHELPER.5
import FSH_SEMREQUEST FSHELPER.6
import FSH_SEMCLEAR FSHELPER.7
import FSH_PROBEBUF FSHELPER.8
import FSH_GETVOLPARM FSHELPER.14
import FSH_SEMSET FSHELPER.24
import FSH_SEMWAIT FSHELPER.26
import FSH_QSYSINFO FSHELPER.44
file $(BIN_DIR)\stubfsd.obj
file $(BIN_DIR)\bootmsg.obj
file $(BIN_DIR)\dhwrap.obj
segment type CODE PRELOAD EXECUTEREAD NONSHARED
segment type DATA PRELOAD NONSHARED
@$(EXPORTS)
<<

$(BIN_DIR)\stubfsd.obj: $(SRC_DIR)\stubfsd.c $(SRC_DIR)\stubfsd.h $(SRC_DIR)\fsd.h $(SRC_DIR)\fsh.h $(SRC_DIR)\devhelp.h $(SRC_DIR)\bootmsg.h
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
	$(CC) $(CFLAGS) -fo=$@ $(SRC_DIR)\stubfsd.c

$(BIN_DIR)\bootmsg.obj: $(SRC_DIR)\bootmsg.c $(SRC_DIR)\bootmsg.h $(SRC_DIR)\version.h
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
	$(CC) $(CFLAGS) -fo=$@ $(SRC_DIR)\bootmsg.c

$(BIN_DIR)\dhwrap.obj: $(SRC_DIR)\dhwrap.asm
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
	$(ASM) -q -fo=$@ $(SRC_DIR)\dhwrap.asm

clean: .SYMBOLIC
	@if exist $(BIN_DIR)\isofs.ifs del $(BIN_DIR)\isofs.ifs
