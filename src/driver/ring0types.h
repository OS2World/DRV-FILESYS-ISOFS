/*
 * ring0types.h - the few 32-bit OS/2 toolkit types the ring 0 stub needs when it is
 * compiled with the 16-bit OS/2 1.x headers of Open Watcom (h\os21x).
 *
 * Copyright (c) 2026 OS2World. Released under the GNU General Public License,
 * version 2 or later, like the rest of AEFS. Written for this project.
 */
#ifndef ISOFS_RING0TYPES_H_INCLUDED
#define ISOFS_RING0TYPES_H_INCLUDED

#ifdef __WATCOMC__
#ifndef ISOFS_APIRET_DEFINED
#define ISOFS_APIRET_DEFINED
typedef unsigned long APIRET;            /* return code of the 32-bit API */
typedef struct _ISOFS_LONGLONG {          /* 64-bit integer, low word first */
   unsigned long ulLo;
   long          lHi;
} LONGLONG;
typedef LONGLONG far *PLONGLONG;
#ifndef FIL_QUERYEASFROMLIST
#define FIL_QUERYEASFROMLIST 3   /* path/file information level */
#endif
#endif
#endif

#endif /* ISOFS_RING0TYPES_H_INCLUDED */
