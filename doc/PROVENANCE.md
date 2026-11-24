# Provenance of the kernel interface headers

The 1.1.2 tree contained the IBM IFS developer kit (`ifsinf\`: `FSD.H`, `FSH.H`, `FSHELPER.LIB`, `IFS.INF`) and `src\drivershelper.lib`.
Those are IBM material and are not part of this release; they remain only in git history (tag `upstream-original`).

* `src\driver\fsd.h`, `fsh.h`, `devhelp.h`, `ring0types.h` and `dhwrap.asm` are clean-room files written by OS2World from public
  documentation, first for HFS/2, FS-EXFAT and AEFS (which load and run on ArcaOS). Public domain.
* `fshelper.lib` is not needed: the FSH_* / DOS* entry points are imported by ordinal in `Makefile.wat`.
* The daemon, `libunls`, `mapiso`, `isoinfo`, `isodrive` are the authors' GPL code (Dolstra, Wohlgemuth, Ratcliffe, Walsh), unchanged apart from the version string.
