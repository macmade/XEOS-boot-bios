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
; @file            xeos.16.cpu.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; CPU information procedures
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
; 
; Extended registers are used for CPUID, but this is allowed in real mode, with
; the help of the "Operand Size Override Prefix" (0x66), handled by
; the assembler.
;-------------------------------------------------------------------------------

%ifndef __XEOS_16_CPU_INC_S__
%define __XEOS_16_CPU_INC_S__

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Checks if the processor supports the CPUID instruction
; 
; Input registers:
;       
;       None
; 
; Return registers:
;       
;       - AX:       The result code (1 if CPUID is supportd, otherwise 0)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.cpu.hasCPUID:
    
    @XEOS.16.proc.start 1
    
    ; Gets EFLAGS into EAX
    pushfd
    pop     eax
    
    ; Saves EFLAGS into ECX
    mov     ecx,        eax 
    
    ; Sets EFLAGS
    xor     eax,        0x200000
    push    eax
    popfd
    
    ; Gets EFLAGS into EAX
    pushfd
    pop     eax
    
    ; Masks changed bits
    xor     eax,        ecx
    
    ; Test ID flag
    shr     eax,        0x15
    and     eax,        0x0000000000000001
    
    cmp     eax,        0x01
    jmp     .cpuid.available
    
    .cpuid.unavailable:
        
        ; Restore flags
        push    ecx
        popfd
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        xor     ax,         ax
        
        ret
        
    .cpuid.available:
        
        ; Restore flags
        push    ecx
        popfd
        
        @XEOS.16.proc.end
        
        ; Success - Stores result code in AX
        mov     ax,         0x01
        
        ret

;-------------------------------------------------------------------------------
; Gets the CPU vendor
; 
; Input registers:
;       
;       - DI:       The location of a buffer for the vendor string.
;                   Needs to be at least 12 characters long.
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.cpu.vendor:
    
    @XEOS.16.proc.start 0
    
    ; Get CPU vendor strings (EBX, EDX, ECX - 4 chars each)
    mov     eax,        0x00
    cpuid
    
    ; Copies the strings to DI
    mov     [ di + 0 ], ebx
    mov     [ di + 4 ], edx
    mov     [ di + 8 ], ecx
    
    @XEOS.16.proc.end
    
    ret

;-------------------------------------------------------------------------------
; Checks if the CPU is 64 bits capable
; 
; Input registers:
;       
;       None
; 
; Return registers:
;       
;       - AX:       The result code (1 if 64 bits capable, otherwise 0)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.cpu.64:
    
    @XEOS.16.proc.start 0
    
    ; Indentifies CPU
    mov     eax,        0x80000000
    cpuid
    
    ; Checks for 64 bits capabilities
    cmp     eax,        0x80000001
    jb      .error
        
    .success
        
        @XEOS.16.proc.end
        
        ; Success - Stores result code in AX
        mov     ax,         0x01
        
        ret
        
    .error:
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        xor     ax,         ax
        
        ret

;-------------------------------------------------------------------------------
; Checks if the CPU supports PAE (Physical Address Extension)
; 
; Input registers:
;       
;       None
; 
; Return registers:
;       
;       - AX:       The result code (1 if PAE is available, otherwise 0)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.cpu.pae:
    
    @XEOS.16.proc.start 0
    
    ; Indentifies CPU
    mov     eax,        0x01
    cpuid
    
    ; PAE is bit 6 of EDX
    and     edx,        0x40
    cmp     edx,        0
    je      .error
        
    .success
        
        @XEOS.16.proc.end
        
        ; Success - Stores result code in AX
        mov     ax,         0x01
        
        ret
        
    .error:
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        xor     ax,         ax
        
        ret

%endif
