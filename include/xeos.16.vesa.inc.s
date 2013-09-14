;-------------------------------------------------------------------------------
; XEOS - X86 Experimental Operating System
; 
; Copyright (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
; All rights reserved.
; 
; XEOS Software License - Version 1.0 - December 21, 2012
; 
; Permission is hereby granted, free of charge, to any person or organisation
; obtaining a copy of the software and accompanying documentation covered by
; this license (the "Software") to deal in the Software, with or without
; modification, without restriction, including without limitation the rights
; to use, execute, display, copy, reproduce, transmit, publish, distribute,
; modify, merge, prepare derivative works of the Software, and to permit
; third-parties to whom the Software is furnished to do so, all subject to the
; following conditions:
; 
;       1.  Redistributions of source code, in whole or in part, must retain the
;           above copyright notice and this entire statement, including the
;           above license grant, this restriction and the following disclaimer.
; 
;       2.  Redistributions in binary form must reproduce the above copyright
;           notice and this entire statement, including the above license grant,
;           this restriction and the following disclaimer in the documentation
;           and/or other materials provided with the distribution, unless the
;           Software is distributed by the copyright owner as a library.
;           A "library" means a collection of software functions and/or data
;           prepared so as to be conveniently linked with application programs
;           (which use some of those functions and data) to form executables.
; 
;       3.  The Software, or any substancial portion of the Software shall not
;           be combined, included, derived, or linked (statically or
;           dynamically) with software or libraries licensed under the terms
;           of any GNU software license, including, but not limited to, the GNU
;           General Public License (GNU/GPL) or the GNU Lesser General Public
;           License (GNU/LGPL).
; 
;       4.  All advertising materials mentioning features or use of this
;           software must display an acknowledgement stating that the product
;           includes software developed by the copyright owner.
; 
;       5.  Neither the name of the copyright owner nor the names of its
;           contributors may be used to endorse or promote products derived from
;           this software without specific prior written permission.
; 
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT OWNER AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
; THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
; PURPOSE, TITLE AND NON-INFRINGEMENT ARE DISCLAIMED.
; 
; IN NO EVENT SHALL THE COPYRIGHT OWNER, CONTRIBUTORS OR ANYONE DISTRIBUTING
; THE SOFTWARE BE LIABLE FOR ANY CLAIM, DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
; EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
; PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
; WHETHER IN ACTION OF CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF OR IN CONNECTION WITH
; THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE, EVEN IF ADVISED
; OF THE POSSIBILITY OF SUCH DAMAGE.
;-------------------------------------------------------------------------------

; $Id$

;-------------------------------------------------------------------------------
; @file            xeos.16.vesa.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

%ifndef __XEOS_16_VESA_INC_S__
%define __XEOS_16_VESA_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------

%include "xeos.macros.inc.s"          ; General macros

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Type definitions
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; The VESA info block has the following structure:
;       
;       - BYTE  .vbeSignature[ 4 ]      VBE Signature
;       - WORD  .vbeVersion             VBE Version
;       - DWORD .oemStringPtr           Pointer to OEM String
;       - BYTE  .capabilities[ 4 ]      Capabilities of graphics controller
;       - DWORD .videoModePtr           Pointer to VideoModeList
;       - WORD  .totalMemory            Number of 64kb memory blocks
;       - WORD  .oemSoftwareRev         VBE implementation Software revision
;       - DWORD .oemVendorNamePtr       Pointer to Vendor Name String
;       - DWORD .oemProductNamePtr      Pointer to Product Name String
;       - DWORD .oemProductRevPtr       Pointer to Product Revision String
;       - BYTE  .reserved[ 222 ]        Reserved for VBE implementation scratch area
;       - BYTE  .oemData[ 256 ]         Data Area for OEM Strings
;-------------------------------------------------------------------------------
struc XEOS.16.vesa.info_t

    .vbeSignature:          resb    4
    .vbeVersion:            resw    1
    .oemStringPtr:          resd    1
    .capabilities:          resb    4
    .videoModePtr:          resd    1
    .totalMemory:           resw    1
    .oemSoftwareRev:        resw    1
    .oemVendorNamePtr:      resd    1
    .oemProductNamePtr:     resd    1
    .oemProductRevPtr:      resd    1
    .reserved:              resb    222
    .oemData:               resb    256

endstruc

;-------------------------------------------------------------------------------
; The VESA mode info block has the following structure:
;       
;       - WORD  .modeAttributes         Mode attributes
;       - BYTE  .winAAttributes         Window A attributes
;       - BYTE  .winBAttributes         Window B attributes
;       - WORD  .winGranularity         Window granularity
;       - WORD  .winSize                Window size
;       - WORD  .winASegment            Window A start segment
;       - WORD  .winBSegment            Window B start segment
;       - DWORD .winFuncPtr             Pointer to window function
;       - WORD  .bytesPerScanLine       Bytes per scan line
;       - WORD  .xResolution            Horizontal resolution in pixels or characters
;       - WORD  .yResolution            Vertical resolution in pixels or characters
;       - BYTE  .xCharSize              Character cell width in pixels
;       - BYTE  .yCharSize              Character cell height in pixels
;       - BYTE  .numberOfPlanes         Number of memory planes
;       - BYTE  .bitsPerPixel           Bits per pixel
;       - BYTE  .numberOfBanks          Number of banks
;       - BYTE  .memoryModel            Memory model type
;       - BYTE  .bankSize               Bank size in KB
;       - BYTE  .numberOfImagePages     Number of images
;       - BYTE  .reserved_1             Reserved for page function
;       - BYTE  .redMaskSize            Size of direct color red mask in bits
;       - BYTE  .redFieldPosition       Bit position of lsb of red mask
;       - BYTE  .greenMaskSize          Size of direct color green mask in bits
;       - BYTE  .greenFieldPosition     Bit position of lsb of green mask
;       - BYTE  .blueMaskSize           Size of direct color blue mask in bits
;       - BYTE  .blueFieldPosition      Bit position of lsb of blue mask
;       - BYTE  .rsvdMaskSize           Size of direct color reserved mask in bits
;       - BYTE  .rsvdFieldPosition      Bit position of lsb of reserved mask
;       - BYTE  .directColorModeInfo    Direct color mode attributes
;       - DWORD .physBasePtr            Physical address for flat memory frame buffer
;       - DWORD .offScreenMemOffset     Pointer to start of off screen memory
;       - WORD  .offScreenMemSize       Amount of off screen memory in 1k units
;       - BYTE  .reserved_2             Remainder of ModeInfoBlock
;-------------------------------------------------------------------------------
struc XEOS.16.vesa.modeinfo_t

    .modeAttributes:		resw	1
    .winAAttributes:		resb	1
    .winBAttributes:		resb	1
    .winGranularity:		resw	1
    .winSize:               resw	1
    .winASegment:           resw	1
    .winBSegment:           resw	1
    .winFuncPtr:            resd	1
    .bytesPerScanLine:      resw	1
    .xResolution:           resw	1
    .yResolution:           resw	1
    .xCharSize:             resb	1
    .yCharSize:             resb	1
    .numberOfPlanes:		resb	1
    .bitsPerPixel:          resb	1
    .numberOfBanks:         resb	1
    .memoryModel:           resb	1
    .bankSize:              resb	1
    .numberOfImagePages:    resb	1
    .reserved_1:            resb	1
    .redMaskSize:           resb	1
    .redFieldPosition:      resb	1
    .greenMaskSize:         resb	1
    .greenFieldPosition:    resb	1
    .blueMaskSize:          resb	1
    .blueFieldPosition:     resb	1
    .rsvdMaskSize:          resb	1
    .rsvdFieldPosition:     resb	1
    .directColorModeInfo:   resb	1
    .physBasePtr:           resd	1
    .offScreenMemOffset:    resd	1
    .offScreenMemSize:      resw	1
    .reserved_2:            resb	206

endstruc

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Converts an unsigned binary bumber into a string representation
; 
; Input registers:
;       
;       - AX:       The desired horizontal resolution
;       - BX:       The desired vertical resolution
;       - CX:       The desired bits per pixel
;       - DX:       Whether LFB is required (1 or 0)
;       - DI:       The destination byte buffer for VBE info block
;       - SI:       The destination byte buffer for VBE mode info block
; 
; Return registers:
;       
;       - AX:       The number for the video mode, or zero if not found
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.vesa.findVESAMode:
    
    @XEOS.16.proc.start     6
    
    ; Saves arguments in the stack
    @XEOS.16.proc.var.set   1,  ax
    @XEOS.16.proc.var.set   2,  bx
    @XEOS.16.proc.var.set   3,  cx
    @XEOS.16.proc.var.set   4,  dx
    @XEOS.16.proc.var.set   5,  di
    @XEOS.16.proc.var.set   6,  si
    
    ; Default return code
    mov     WORD [ $XEOS.16.vesa.mode ],    0
    
    ; Saves ES, as it may be altered
    push    es
    
    ; Gets the VBE information block
    mov     di,     @XEOS.16.proc.var.5
    mov     ax,     0x4F00
    @XEOS.16.int.video
    
    ; Restores ES
    pop     es
    
    ; Checks if the function is supported
    cmp     ax,     0x004F
    jne     .ret
    
    ; Pointer to the available video modes
    mov     si,     [ di + 0x0E ]
    
    .loop:
        
        ; Saves ES, as it may be altered
        push    es
        
        ; Gets the segment for the video modes pointer
        mov     di,     @XEOS.16.proc.var.5
        mov     ax,     [ di + 0x10 ]
        mov     es,     ax
        
        ; Gets the video mode number
        mov     dx,     WORD [ es:si ]
        
        ; Restores ES
        pop     es
        
        ; 0xFFFF means we've reached the last video mode
        cmp     dx,     0xFFFF
        je      .ret
        
        ; Gets the full informations about the current video mode
        mov     cx,     dx
        mov     di,     @XEOS.16.proc.var.6
        mov     ax,     0x4F01
        @XEOS.16.int.video
       
        ; Checks if the function is supported
        cmp     al,     0x004F
        jne     .ret
        cmp     ah,     0x00
        jne     .loop
        
        ; Prepares for the next video mode by advancing SI
        add     si,     2
        
        ; Gets the mode attributes in AX
        mov     di,     @XEOS.16.proc.var.6
        mov     ax,     WORD [ di ]
        
        ; Checks if the mode is supported
        bt      ax,     0
        jnc     .loop
        
        ; We only want graphic modes
        bt      ax,     4
        jnc     .loop
        
        ; Checks if we wants the mode to support LFB
        mov     bx,     @XEOS.16.proc.var.4
        test    bx,     bx
        jz      .check_res
        
        ; Yes - test the mode for LFB support
        bt      ax,     7
        jnc     .loop
    
    ; At this point, we have a valid graphic video mode with or without
    ; LFB support, depending on the call parameters
    .check_res:
        
        ; Compares the horizontal resolution of the mode with the
        ; requested one
        mov     ax,     WORD [ di + 0x12 ]
        cmp     ax,     WORD @XEOS.16.proc.var.1
        jne     .loop
        
        ; Compares the vertical resolution of the mode with the
        ; requested one
        mov     ax,     WORD [ di + 0x14 ]
        cmp     ax,     WORD @XEOS.16.proc.var.2
        jne     .loop
        
        ; Compares the number of bits per pixel of the mode with the
        ; requested one
        xor     ax,     ax
        mov     al,     BYTE [ di + 0x19 ]
        cmp     ax,     WORD @XEOS.16.proc.var.3
        jne     .loop
        
        ; Valid video mode - Stores it
        mov     WORD [ $XEOS.16.vesa.mode ],    dx
        
    .ret:
        
        @XEOS.16.proc.end
        
        ; Result - Gets the found video mode
        mov     ax,         WORD [ $XEOS.16.vesa.mode ]
        
        ret

;-------------------------------------------------------------------------------
; Variables definition
;-------------------------------------------------------------------------------

$XEOS.16.vesa.mode      dw  0
    
%endif
