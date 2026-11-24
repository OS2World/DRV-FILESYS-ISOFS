# Changes from the original ISOFS 1.1.2

The original state is tagged `upstream-original`.

## Layout
* Sources moved to `src\{daemon,driver,libunls,include,misc,system}`; `COPYING` renamed `LICENSE`; the packaging files are in `package\`;
  the Microsoft C / DDK makefiles are in `doc\original\`.
* Removed: the IBM IFS kit `ifsinf\` (FSD.H, FSH.H, FSHELPER.LIB, IFS.INF, addenda), `src\driver\fshelper.lib`, and logs (`wpi.log`, `my.log`).

## Build
* `compile_wat.cmd`, `Makefile.wat` (new): stub IFS with Open Watcom 2, output `bin\isofs.ifs` (renamed so it does not clash with `STUBFSD.IFS` of ArcaOS).
* `compile_gcc.cmd` (new): daemon, `mapiso`, `isoinfo`, `isodrive` with GCC 9 / kLIBC.

## Stub IFS
* Clean-room `fsd.h`, `fsh.h`, `devhelp.h`, `ring0types.h`, `dhwrap.asm` (shared with AEFS, see `PROVENANCE.md`); the exported entry points are in `stubfsd_exports.lnk`.
* Boot messages: quiet by default, `/V /Q /W /AA`, prefix `ISOFS: `, default file system name `ISOFS`.
* Bug fix: `daemonStarted` returned whatever the last call left in AX; it now returns `NO_ERROR` explicitly.

## Version
* 1.2.0 (stub, daemon and tools report the same version; they said 1.0.4 before).

## Tests (ArcaOS 5.1.2 VM, kernel 14.204 SMP, 2026-11-24)
* Boot silent, with `/V` one `ISOFS:` line. Map an image, list, `type`, MD5 sums of an 11 MB file and a text file identical to the ArcaOS ISOFS; copy of the big file; two drives with one image; unmap; remount; `isoinfo -d -i`.
* Not tested: `isodrive` GUI, Rock Ridge / Joliet images, multi-session, real hardware, SMP load.
