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
;       - BYTE  signature[ 4 ]      Signature bytes (VESA)
;       - WORD  version             VESA version number
;       - DWORD oem_string          OEM string pointer
;       - BYTE  capabilities[ 4 ]   Video capabilities
;       - DWORD video_mode_ptr      SVGA modes pointer
;       - WORD  total_memory        Available chunks of 64Kb on board
;       - BYTE  reserved[ 236 ]     Reserved bytes
;-------------------------------------------------------------------------------
struc XEOS.16.vesa.info_t

    .signature:         resb    4
    .version:           resw    1
    .oem_string:        resd    1
    .capabilities:      resd    1
    .video_mode_ptr:    resd    1
    .total_memory:      resw    1
    .reserved:          resb    236

endstruc

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Checks if a specific VESA mode is available
; 
; Input registers:
;       
;       - BX:       The video mode to check for
;       - SI:       The address of the VESA info buffer
; 
; Return registers:
;       
;       - AX:       1 if the mode is available, otherwise 0
; 
; Killed registers:
;       
;       None   
;-------------------------------------------------------------------------------
XEOS.16.vesa.checkModeAvailability:
    
    ; Modes pointer is located at 0x0E offset
    add     si,     0x0E
    
    ; Loop through video modes
    .check:
        
        ; Current mode
        mov     ax,     [ si ]
        
        ; 0xFFFF is the last mode
        cmp     ax,     0xFFFF
        je      .notfound
        
        ; Compares the current mode with the specified one
        cmp     bx,     ax
        je      .found
        
        ; Next mode
        add     si,     1
        jmp     .check
    
    .found:
        
        mov     ax,     1
        jmp     .ret
    
    .notfound:
        
        xor     ax,     ax
    
    .ret:
        
        ret
    
%endif
