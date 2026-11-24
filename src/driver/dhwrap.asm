; dhwrap.asm - DevHlp services for the file system driver (16-bit, large model, Open Watcom wasm)
;
; Copyright (c) 2026 OS2World.
; Released under the GNU Lesser General Public License, version 2.1 or later,
; so that it can be used in GPL projects such as ISOFS (GPL version 2 or later).
;
; Clean-room: register interfaces and function numbers from the "Physical Device
; Driver Reference", see doc/PROVENANCE.md of the ISOFS project. The AllocGDTSelector, LinToGDTSelector,
; VMAlloc, VMLock and VMUnLock routines are the ones verified in the HFS/2 port
; (OS2World, 2026).
;
; Every service: function number in DL, far call through Device_Help (the entry point
; FS_INIT saved), carry set = error code in AX/EAX. All routines are "far pascal"
; (arguments pushed left to right, callee pops). Offsets below are from BP after
; "push bp / mov bp,sp": +2 return offset, +4 return segment, +6 the last argument.
; SI, DI, BP and DS are preserved; AX, BX, CX, DX and ES may change.

                .386

DGROUP          group   _DATA
_DATA           segment word public use16 'DATA'
                extrn   _Device_Help:dword
_DATA           ends

_TEXT           segment word public use16 'CODE'
                assume  cs:_TEXT, ds:DGROUP

; unsigned short far pascal DevHelp_ProcRun(unsigned long EventId, unsigned short far *AwakeCount)
                public  DEVHELP_PROCRUN
DEVHELP_PROCRUN proc    far
                push    bp
                mov     bp, sp
                mov     bx, [bp+10]             ; event id, low word
                mov     ax, [bp+12]             ; event id, high word
                mov     dl, 5
                call    dword ptr _Device_Help
                les     bx, [bp+6]              ; AwakeCount
                mov     es:[bx], ax
                xor     ax, ax
                pop     bp
                ret     8
DEVHELP_PROCRUN endp

; unsigned short far pascal DevHelp_ProcBlock(unsigned long EventId, unsigned long WaitTime,
;                  unsigned short IntWaitFlag)
                public  DEVHELP_PROCBLOCK
DEVHELP_PROCBLOCK proc  far
                push    bp
                mov     bp, sp
                push    di
                mov     bx, [bp+12]             ; event id, low word
                mov     ax, [bp+14]             ; event id, high word
                mov     cx, [bp+8]              ; time limit, low word
                mov     di, [bp+10]             ; time limit, high word
                mov     dh, [bp+6]              ; 0 interruptible, 1 not interruptible
                mov     dl, 4
                call    dword ptr _Device_Help
                jc      short pb_unusual
                xor     ax, ax
                jmp     short pb_done
pb_unusual:     mov     ax, 1                   ; WAIT_TIMED_OUT: Z set means the time limit expired
                jz      short pb_done
                mov     ax, 2                   ; WAIT_INTERRUPTED: Z clear means the thread was signalled
pb_done:        pop     di
                pop     bp
                ret     10
DEVHELP_PROCBLOCK endp

; unsigned short far pascal DevHelp_Yield(void)
                public  DEVHELP_YIELD
DEVHELP_YIELD   proc    far
                mov     dl, 2
                call    dword ptr _Device_Help
                xor     ax, ax
                ret
DEVHELP_YIELD   endp

; unsigned short far pascal DevHelp_GetDOSVar(unsigned short VarNumber, unsigned short VarMember,
;                  void far * far *KernelVar)
                public  DEVHELP_GETDOSVAR
DEVHELP_GETDOSVAR proc  far
                push    bp
                mov     bp, sp
                push    di
                mov     al, [bp+12]             ; variable number
                mov     cx, [bp+10]             ; member (index 14 and 16 only)
                mov     dl, 24h
                call    dword ptr _Device_Help
                jc      short gdv_err
                les     di, [bp+6]              ; AX:BX is the pointer
                mov     es:[di], bx
                mov     es:[di+2], ax
                xor     ax, ax
                jmp     short gdv_done
gdv_err:        mov     ax, 1
gdv_done:       pop     di
                pop     bp
                ret     8
DEVHELP_GETDOSVAR endp

; unsigned short far pascal DevHelp_VerifyAccess(unsigned short MemSelector, unsigned short Length,
;                  unsigned short MemOffset, unsigned char AccessFlag)
                public  DEVHELP_VERIFYACCESS
DEVHELP_VERIFYACCESS proc far
                push    bp
                mov     bp, sp
                push    di
                mov     ax, [bp+12]             ; selector
                mov     cx, [bp+10]             ; length (0 = 64 KB)
                mov     di, [bp+8]              ; offset
                mov     dh, [bp+6]              ; 0 read, 1 read/write
                mov     dl, 27h
                call    dword ptr _Device_Help
                jc      short va_err
                xor     ax, ax
                jmp     short va_done
va_err:         mov     ax, 5                   ; access denied
va_done:        pop     di
                pop     bp
                ret     8
DEVHELP_VERIFYACCESS endp

; unsigned short far pascal DevHelp_InternalError(char far *MsgText, unsigned short MsgLength)
; does not return
                public  DEVHELP_INTERNALERROR
DEVHELP_INTERNALERROR proc far
                push    bp
                mov     bp, sp
                mov     di, [bp+6]              ; message length
                lds     si, [bp+8]              ; message text
                mov     dl, 2Bh
                call    dword ptr _Device_Help
                pop     bp
                ret     6
DEVHELP_INTERNALERROR endp

; unsigned short far pascal DevHelp_RAS(unsigned short Major, unsigned short Minor,
;                  unsigned short Size, unsigned char far *Data)
                public  DEVHELP_RAS
DEVHELP_RAS     proc    far
                push    bp
                mov     bp, sp
                push    si
                push    ds
                mov     ax, [bp+14]             ; major trace event code
                mov     cx, [bp+12]             ; minor trace event code
                mov     bx, [bp+10]             ; length of the data
                lds     si, [bp+6]              ; the data
                mov     dl, 28h
                call    dword ptr _Device_Help
                jc      short ras_err
                xor     ax, ax
                jmp     short ras_done
ras_err:        mov     ax, 1
ras_done:       pop     ds
                pop     si
                pop     bp
                ret     10
DEVHELP_RAS     endp

; unsigned short far pascal DevHelp_AllocGDTSelector(unsigned short far *Selectors,
;                  unsigned short Count)
                public  DEVHELP_ALLOCGDTSELECTOR
DEVHELP_ALLOCGDTSELECTOR proc far
                push    bp
                mov     bp, sp
                push    di
                mov     cx, [bp+6]              ; count
                les     di, [bp+8]              ; selector array
                mov     dl, 2Dh
                call    dword ptr _Device_Help
                jc      short agd_err
                xor     ax, ax
agd_err:        pop     di
                pop     bp
                ret     6
DEVHELP_ALLOCGDTSELECTOR endp

; unsigned short far pascal DevHelp_FreeGDTSelector(unsigned short Selector)
                public  DEVHELP_FREEGDTSELECTOR
DEVHELP_FREEGDTSELECTOR proc far
                push    bp
                mov     bp, sp
                mov     ax, [bp+6]
                mov     dl, 53h
                call    dword ptr _Device_Help
                jc      short fgd_err
                xor     ax, ax
fgd_err:        pop     bp
                ret     2
DEVHELP_FREEGDTSELECTOR endp

; unsigned short far pascal DevHelp_PhysToGDTSelector(unsigned long PhysAddr,
;                  unsigned short Count, unsigned short Selector)
                public  DEVHELP_PHYSTOGDTSELECTOR
DEVHELP_PHYSTOGDTSELECTOR proc far
                push    bp
                mov     bp, sp
                push    si
                mov     ax, [bp+12]             ; physical address, high word
                mov     bx, [bp+10]             ; physical address, low word
                mov     cx, [bp+8]              ; length of the segment
                mov     si, [bp+6]              ; selector
                mov     dl, 2Eh
                call    dword ptr _Device_Help
                jc      short p2g_err
                xor     ax, ax
p2g_err:        pop     si
                pop     bp
                ret     8
DEVHELP_PHYSTOGDTSELECTOR endp

; unsigned short far pascal DevHelp_LinToGDTSelector(unsigned short Selector, LIN LinearAddr,
;                  unsigned long Size)
                public  DEVHELP_LINTOGDTSELECTOR
DEVHELP_LINTOGDTSELECTOR proc far
                push    bp
                mov     bp, sp
                push    ebx
                mov     ax, [bp+14]             ; selector
                mov     ebx, [bp+10]            ; linear address
                mov     ecx, [bp+6]             ; size
                mov     dl, 5Ch
                call    dword ptr _Device_Help
                jc      short l2g_err
                xor     ax, ax
l2g_err:        pop     ebx
                pop     bp
                ret     10
DEVHELP_LINTOGDTSELECTOR endp

; unsigned short far pascal DevHelp_VirtToLin(unsigned short Selector, unsigned long Offset,
;                  PLIN LinearAddr)
                public  DEVHELP_VIRTTOLIN
DEVHELP_VIRTTOLIN proc  far
                push    bp
                mov     bp, sp
                push    esi
                mov     ax, [bp+14]             ; selector
                mov     esi, [bp+10]            ; offset
                mov     dl, 5Bh
                call    dword ptr _Device_Help
                jc      short v2l_err
                les     bx, [bp+6]              ; LinearAddr
                mov     es:[bx], eax
                xor     ax, ax
v2l_err:        pop     esi
                pop     bp
                ret     10
DEVHELP_VIRTTOLIN endp

; unsigned short far pascal DevHelp_VMAlloc(unsigned long Flags, unsigned long Size,
;                  unsigned long PhysAddr, PLIN LinearAddr, void far * far *Unused)
                public  DEVHELP_VMALLOC
DEVHELP_VMALLOC proc    far
                push    bp
                mov     bp, sp
                push    esi
                push    edi
                mov     eax, [bp+22]            ; flags
                mov     ecx, [bp+18]            ; size
                mov     edi, [bp+14]            ; physical address (-1: none)
                mov     dl, 57h
                call    dword ptr _Device_Help
                jc      short vma_err
                les     bx, [bp+10]             ; linear address out
                mov     es:[bx], eax
                xor     ax, ax
vma_err:        pop     edi
                pop     esi
                pop     bp
                ret     20
DEVHELP_VMALLOC endp

; unsigned short far pascal DevHelp_VMLock(unsigned long Flags, LIN LinearAddr,
;                  unsigned long Length, LIN PageList, LIN LockHandle,
;                  unsigned long far *PageListCount)
                public  DEVHELP_VMLOCK
DEVHELP_VMLOCK  proc    far
                push    bp
                mov     bp, sp
                push    esi
                push    edi
                push    ebx
                mov     eax, [bp+26]            ; flags
                mov     ebx, [bp+22]            ; linear address
                mov     ecx, [bp+18]            ; length
                mov     edi, [bp+14]            ; page list (-1: none)
                mov     esi, [bp+10]            ; lock handle (linear)
                mov     dl, 55h
                call    dword ptr _Device_Help
                jc      short vml_err
                les     bx, [bp+6]              ; page list count out
                mov     es:[bx], eax
                xor     ax, ax
vml_err:        pop     ebx
                pop     edi
                pop     esi
                pop     bp
                ret     24
DEVHELP_VMLOCK  endp

; unsigned short far pascal DevHelp_VMUnLock(LIN LockHandle)
                public  DEVHELP_VMUNLOCK
DEVHELP_VMUNLOCK proc   far
                push    bp
                mov     bp, sp
                push    esi
                mov     esi, [bp+6]
                mov     dl, 56h
                call    dword ptr _Device_Help
                jc      short vmu_err
                xor     ax, ax
vmu_err:        pop     esi
                pop     bp
                ret     4
DEVHELP_VMUNLOCK endp

; unsigned short far pascal DevHelp_VMProcessToGlobal(unsigned long Flags, LIN LinearAddr,
;                  unsigned long Length, PLIN GlobalLinearAddr)
                public  DEVHELP_VMPROCESSTOGLOBAL
DEVHELP_VMPROCESSTOGLOBAL proc far
                push    bp
                mov     bp, sp
                push    ebx
                mov     eax, [bp+18]            ; flags
                mov     ebx, [bp+14]            ; linear address in the process
                mov     ecx, [bp+10]            ; length
                mov     dl, 59h
                call    dword ptr _Device_Help
                jc      short vpg_err
                les     bx, [bp+6]              ; global linear address out
                mov     es:[bx], eax
                xor     ax, ax
vpg_err:        pop     ebx
                pop     bp
                ret     16
DEVHELP_VMPROCESSTOGLOBAL endp

_TEXT           ends
                end
