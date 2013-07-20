;-------------------------------------------------------------------------------
; XEOS - X86 Experimental Operating System
; 
; Copyright (c) 2010-2012, Jean-David Gadina - www.xs-labs.com
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
; @file            xeos.16.mem.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2012, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Memory related procedures
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
;-------------------------------------------------------------------------------
%ifndef __XEOS_16_MEM_INC_S__
%define __XEOS_16_MEM_INC_S__

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------
%include "xeos.constants.inc.s"       ; General constants
%include "xeos.macros.inc.s"          ; General macros
%include "xeos.16.int.inc.s"          ; BIOS interrupts

;-------------------------------------------------------------------------------
; Variables definition
;-------------------------------------------------------------------------------

$XEOS.16.mem.infos.bytes    dd  0

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Detects the available memory
; 
; Input registers:
;       
;       - AX:       The segment where memory infos will be loaded (AX:00)
; 
; Return registers:
;       
;       - EAX:      The number of bytes containing the memory infos
;                   (0 if an error occured)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.mem.getMemoryLayout:
    
    @XEOS.16.proc.start 0
    
    ; Sets the destination for the memory informations
    mov     es,             ax
    xor     eax,            eax
    mov     edi,            eax
    
    ; Gets the first memory entry
    mov     eax,            0x0000E820
    mov     ecx,            0x00000014
    mov     edx,            0x534D4150
    xor     ebx,            ebx
    @XEOS.16.int.misc
    
    ; Checks for an error
    jc      .error
    cmp     eax,            0x534D4150
    jne     .error
    
    ; Resets EAX
    xor     eax,            eax
    
    .loop:
        
        ; 20 bytes written
        add     eax,            0x14
        
        ; Location of the next buffer
        add     di,             0x14
        
        ; Saves registers
        push    eax
        
        ; Gets the next memory entry
        mov     eax,            0x0000E820
        mov     ecx,            0x00000018
        @XEOS.16.int.misc
        
        ; Restores registers
        pop     eax
        
        ; Checks for the end of the list
        jc      .done
        cmp     ebx,            0x00
        je      .done
        
        ; Process next entry
        jmp     .loop
        
    .done:
        
        ; Number of bytes written
        mov DWORD [ $XEOS.16.mem.infos.bytes ], eax
        
        @XEOS.16.proc.end
        
        ; Success - Stores result in EAX
        mov     eax,            DWORD [ $XEOS.16.mem.infos.bytes ]
        ret
    
    .error:
        
        @XEOS.16.proc.end
        
        ; Error - Stores result in EAX
        xor     eax,            eax
        
        ret
    
%endif
