/*
 * devhelp.h - the DevHlp kernel services used by the file system driver
 *
 * Copyright (c) 2026 OS2World.
 * Released under the GNU Lesser General Public License, version 2.1 or later,
 * so that it can be used in GPL projects such as ISOFS (GPL version 2 or later).
 *
 * Clean-room replacement: written from the "Physical Device Driver Reference" (the C
 * calling sequences, the register interface, the function numbers and the flag
 * descriptions of each service), see doc/PROVENANCE.md of the ISOFS project. Only the services the driver
 * uses are declared. They are implemented in ifs/dhwrap.asm, which calls the kernel
 * through the DevHlp entry point that FS_INIT saves in Device_Help.
 *
 * All routines are far pascal (arguments pushed left to right, callee pops) and return
 * 0 for success or an OS/2 error code, like the C interface described in the reference.
 * DS must be the driver's data segment (every FS_xxx entry point loads it).
 */

#ifndef ISOFS_DEVHELP_H_INCLUDED
#define ISOFS_DEVHELP_H_INCLUDED

typedef unsigned long LIN;                  /* linear (flat) address   */
typedef LIN far *PLIN;
typedef void far * far *PPVOID;             /* pointer to a far pointer */

/* ProcBlock results (this header and dhwrap.asm define the values) */
#define WAIT_NORMAL        0       /* woken by ProcRun            */
#define WAIT_TIMED_OUT     1       /* the time limit expired      */
#define WAIT_INTERRUPTED   2       /* the thread was signalled    */

typedef struct _PAGELIST                    /* one physically contiguous region */
{
   unsigned long pl_PhysAddr;               /* physical address of the first byte */
   unsigned long pl_cb;                     /* number of contiguous bytes         */
} PAGELIST, far *PPAGELIST;

/* GetDOSVar variable numbers */
#define DHGETDOSV_SYSINFOSEG        1
#define DHGETDOSV_LOCINFOSEG        2
#define DHGETDOSV_VECTORSDF         4
#define DHGETDOSV_VECTORREBOOT      5
#define DHGETDOSV_VECTORMSATS       6
#define DHGETDOSV_YIELDFLAG         7
#define DHGETDOSV_TCYIELDFLAG       8
#define DHGETDOSV_DOSCODEPAGE       11
#define DHGETDOSV_INTERRUPTLEV      13
#define DHGETDOSV_DEVICECLASSTABLE  14
#define DHGETDOSV_DMQSSELECTOR      15
#define DHGETDOSV_APMINFO           16

/* VerifyAccess access type */
#define VERIFY_READONLY             0
#define VERIFY_READWRITE            1

/* VMAlloc flags */
#define VMDHA_16M                   0x0001UL    /* below the 16 MB line           */
#define VMDHA_16MB                  0x0001UL
#define VMDHA_FIXED                 0x0002UL    /* fixed in memory                */
#define VMDHA_SWAP                  0x0004UL    /* swappable                      */
#define VMDHA_CONTIG                0x0008UL    /* physically contiguous          */
#define VMDHA_PHYS                  0x0010UL    /* map the given physical address */
#define VMDHA_PROCESS               0x0020UL    /* process address range          */
#define VMDHA_SGSCONT               0x0040UL    /* screen group switch control    */
#define VMDHA_RESERVE               0x0100UL    /* reserve only, do not commit    */
#define VMDHA_USEHIGHMEM            0x0800UL    /* above 16 MB (INIT time only)   */

/* VMLock flags */
#define VMDHL_NOBLOCK               0x0001UL    /* return if the pages are not available */
#define VMDHL_CONTIGUOUS            0x0002UL    /* physically contiguous          */
#define VMDHL_16M                   0x0004UL    /* below the 16 MB line           */
#define VMDHL_WRITE                 0x0008UL    /* the driver will write the region */
#define VMDHL_LONG                  0x0010UL    /* long-term lock                 */
#define VMDHL_VERIFY                0x0020UL    /* verify-only lock               */

/* VMProcessToGlobal flags */
#define VMDHPG_READONLY             0x0000UL
#define VMDHPG_WRITE                0x0001UL

unsigned short far pascal DevHelp_ProcRun(unsigned long EventId, unsigned short far *AwakeCount);
unsigned short far pascal DevHelp_ProcBlock(unsigned long EventId, unsigned long WaitTime,
                                            unsigned short IntWaitFlag);
unsigned short far pascal DevHelp_Yield(void);
unsigned short far pascal DevHelp_GetDOSVar(unsigned short VarNumber, unsigned short VarMember,
                                            void far * far *KernelVar);
unsigned short far pascal DevHelp_VerifyAccess(unsigned short MemSelector, unsigned short Length,
                                               unsigned short MemOffset, unsigned char AccessFlag);
unsigned short far pascal DevHelp_InternalError(char far *MsgText, unsigned short MsgLength);
unsigned short far pascal DevHelp_RAS(unsigned short Major, unsigned short Minor,
                                      unsigned short Size, unsigned char far *Data);
unsigned short far pascal DevHelp_AllocGDTSelector(unsigned short far *Selectors, unsigned short Count);
unsigned short far pascal DevHelp_FreeGDTSelector(unsigned short Selector);
unsigned short far pascal DevHelp_PhysToGDTSelector(unsigned long PhysAddr, unsigned short Count,
                                                    unsigned short Selector);
unsigned short far pascal DevHelp_LinToGDTSelector(unsigned short Selector, LIN LinearAddr,
                                                   unsigned long Size);
unsigned short far pascal DevHelp_VirtToLin(unsigned short Selector, unsigned long Offset,
                                            PLIN LinearAddr);
unsigned short far pascal DevHelp_VMAlloc(unsigned long Flags, unsigned long Size,
                                          unsigned long PhysAddr, PLIN LinearAddr,
                                          void far * far *Unused);
unsigned short far pascal DevHelp_VMLock(unsigned long Flags, LIN LinearAddr, unsigned long Length,
                                         LIN PageList, LIN LockHandle,
                                         unsigned long far *PageListCount);
unsigned short far pascal DevHelp_VMUnLock(LIN LockHandle);
unsigned short far pascal DevHelp_VMProcessToGlobal(unsigned long Flags, LIN LinearAddr,
                                                    unsigned long Length, PLIN GlobalLinearAddr);

#endif /* ISOFS_DEVHELP_H_INCLUDED */
