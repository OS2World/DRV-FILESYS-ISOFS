# ISOFS - mount ISO CD/DVD images as drives on OS/2 and ArcaOS

ISOFS mounts an ISO 9660 image (`*.iso`, with Rock Ridge and Joliet extensions) as a read-only virtual drive, so a CD/DVD image
can be used without burning it. A small ring 0 stub IFS (`isofs.ifs`) passes the file system requests to a ring 3 daemon
(`isofsdmn.exe`); `mapiso.exe` maps an image to a drive letter, `isoinfo.exe` prints image data, `isodrive.exe` is a PM front end.

| | |
|---|---|
| Status | working in a virtual machine: mount, list, read, copy, unmount of an image; MD5 sums identical to the ArcaOS ISOFS; alpha |
| Version | 1.2.1 (update of version 1.1.2) |
| Tested on | ArcaOS 5.1.2 (kernel 14.204 SMP) in a VirtualBox virtual machine. Not tested on real hardware. |
| License | GNU GPL v2 or later, see `LICENSE` |
| Authors | Eelco Dolstra (AEFS), Chris Wohlgemuth (ISOFS 0.2.1), Paul Ratcliffe (ISOFS 1.x), Rich Walsh, OS2World (this update) |
| Original source | https://github.com/OS2World/DRV-FILESYS-ISOFS (tag `upstream-original`, version 1.1.2) |
| Build tools | Open Watcom 2 (the stub IFS), GCC 9 for OS/2 (daemon and tools) |

## Install

1. Back up `CONFIG.SYS` and know how to edit it at boot (Alt+F1): a bad file system driver can stop the boot.
2. Copy `isofs.ifs`, `isofsdmn.exe`, `mapiso.exe`, `isoinfo.exe`, `isodrive.exe` and the `isodrive_*.msg` files to a directory,
   for example `C:\ISOFS`.
3. In `CONFIG.SYS` replace the ArcaOS line `IFS=C:\sys\bin\STUBFSD.IFS ISOFS` (if present) by:

```
IFS=C:\ISOFS\isofs.ifs ISOFS
```

4. Reboot, start the daemon (`detach C:\ISOFS\isofsdmn.exe`) and map an image: `mapiso X: C:\path\image.iso`.
   `mapiso X: -d` removes the drive, `mapiso` alone lists the mapped drives.

## Parameters of isofs.ifs

Quiet at boot (only errors are shown, following the EDM2 driver-arguments suggestion); every line starts with `ISOFS: `.
The first word is the file system name (default `ISOFS`).

| Parameter | Effect |
|---|---|
| `/V` | print the version |
| `/Q` | no messages at all |
| `/W` | wait for a key after the messages |
| `/AA` | beep when the driver loaded |

## Build

On ArcaOS (Open Watcom 2 in `C:\WATCOM`; GCC 9 and `watcom-wlink-hll` from ANPM; OS/2 Toolkit 4.5 for `rc` and `mkmsgf`):

```
compile_wat.cmd         stub IFS                 -> bin\isofs.ifs
compile_gcc.cmd         daemon and utilities     -> bin\isofsdmn.exe mapiso.exe isoinfo.exe isodrive.exe
```

The stub and the daemon must be built from the same `src\driver\fsd.h` (the structures are shared through `stubfsd.h`).
The original Microsoft C / DDK makefiles and the emxdoc/WarpIn packaging are in `doc\original` and `package`.

## Test

`test\isotest1.cmd` and `test\isotest2.cmd` map an image, compare directory lists and MD5 sums with the baseline taken with the
ArcaOS ISOFS (`test\isobaseline.cmd`), copy a large file, map two drives at once, unmap and run `isoinfo`.
`test\install-test.cmd` puts the new stub in the `CONFIG.SYS` of the test VM. They contain the paths of the test machine.

## Known issues

* Alpha: tested only in a virtual machine and with one 11 MB image; the `isodrive` front end was not tried in this version.
* The WarpIn package (`package\`) and the `.inf` documentation (`srceadme*.src`) are not rebuilt yet.
* See `doc\CHANGES.md` and `doc\PROVENANCE.md`.

## See also

* Original ISOFS 0.2.1 by Chris Wohlgemuth (2001), the version this one was rewritten from: https://github.com/OS2World/DRV-FILESYS-ISOFS_CW
* Ancestor of both: AEFS by Eelco Dolstra: https://github.com/OS2World/DRV-FILESYS-AEFS
* https://ecsoft2.org/isofs
