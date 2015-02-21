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
; @file            xeos.macros.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; General purpose macros
;-------------------------------------------------------------------------------

%ifndef __XEOS_MACROS_INC_S__
%define __XEOS_MACROS_INC_S__

;-------------------------------------------------------------------------------
; Definitions & Macros
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Start of a standard 32 bits procedure
; 
; Note that the following registers are automatically saved on the stack, and
; restored in @XEOS.16.proc.end:
;       
;       - EAX
;       - EBX
;       - ECX
;       - EDX
;       - ESI
;       - EDI
;       - EFLAGS
;       - DS
;       - ES
;       - FS
;       - GS
; 
; Parameters:
; 
;       1:          The number of stack (local) variables 
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.32.proc.start 1
    
    ; Saves registers and flags
    pushfd
    pushad
    push    ds
    push    es
    push    fs
    push    gs
    
    ; Creates the stack frame
    push    ebp
    mov     ebp,        esp
    
    ; Space for local variables
    sub     esp,        %1 * 4
    
%endmacro

;-------------------------------------------------------------------------------
; Start of a standard 16 bits procedure
; 
; Note that the following registers are automatically saved on the stack, and
; restored in @XEOS.16.proc.end:
;       
;       - EAX
;       - EBX
;       - ECX
;       - EDX
;       - ESI
;       - EDI
;       - EFLAGS
;       - DS
;       - ES
;       - FS
;       - GS
; 
; Parameters:
; 
;       1:          The number of stack (local) variables 
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.proc.start 1
    
    @XEOS.32.proc.start %1
    
%endmacro

;-------------------------------------------------------------------------------
; Start of a standard 64 bits procedure
; 
; Note that the following registers are automatically saved on the stack, and
; restored in @XEOS.16.proc.end:
;       
;       - RAX
;       - RBX
;       - RCX
;       - RDX
;       - RSI
;       - RDI
;       - R8
;       - R9
;       - R10
;       - R11
;       - R12
;       - R13
;       - R14
;       - R15
;       - RFLAGS
; 
; Parameters:
; 
;       1:          The number of stack (local) variables 
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.64.proc.start 1
    
    ; Saves registers and flags
    pushfq
    push    rax
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    
    ; Creates the stack frame
    push    rbp
    mov     rbp,        rsp
    
    ; Space for local variables
    sub     rsp,        %1 * 8
    
%endmacro

;-------------------------------------------------------------------------------
; End of a standard 32 bits procedure
; 
; Parameters:
; 
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.32.proc.end 0
    
    ; Resets the previous stack frame
    mov     esp,        ebp
    pop     ebp
    
    ; Restores registers and flags
    pop     gs
    pop     fs
    pop     es
    pop     ds
    popad
    popfd
    
%endmacro

;-------------------------------------------------------------------------------
; End of a standard 16 bits procedure
; 
; Parameters:
; 
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.proc.end 0
    
    @XEOS.32.proc.end
    
%endmacro

;-------------------------------------------------------------------------------
; End of a standard 64 bits procedure
; 
; Parameters:
; 
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.64.proc.end 0
    
    ; Resets the previous stack frame
    mov     rsp,        rbp
    pop     rbp
    
    ; Restores registers and flags
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rax
    popfq
    
%endmacro

;-------------------------------------------------------------------------------
; Sets a stack (local) variable (32 bits procedure)
; 
; Parameters:
; 
;       1:          The index of the stack (local) variables
;       2:          The value to set
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.32.proc.var.set 2
    
    mov @XEOS.32.proc.var.%1,   DWORD 0
    mov @XEOS.32.proc.var.%1,   %2
    
%endmacro

;-------------------------------------------------------------------------------
; Sets a stack (local) variable (16 bits procedure)
; 
; Parameters:
; 
;       1:          The index of the stack (local) variables
;       2:          The value to set
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.proc.var.set 2
    
    mov @XEOS.16.proc.var.%1,   DWORD 0
    mov @XEOS.16.proc.var.%1,   %2
    
%endmacro

;-------------------------------------------------------------------------------
; Sets a stack (local) variable (64 bits procedure)
; 
; Parameters:
; 
;       1:          The index of the stack (local) variables
;       2:          The value to set
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.64.proc.var.set 2
    
    mov @XEOS.64.proc.var.%1,   QWORD 0
    mov @XEOS.64.proc.var.%1,   %2
    
%endmacro

; Shortcuts for stack (local) variables (32 bits procedure)
%define @XEOS.32.proc.var.1     [ ebp -  4 ]
%define @XEOS.32.proc.var.2     [ ebp -  8 ]
%define @XEOS.32.proc.var.3     [ ebp - 12 ]
%define @XEOS.32.proc.var.4     [ ebp - 16 ]
%define @XEOS.32.proc.var.5     [ ebp - 20 ]
%define @XEOS.32.proc.var.6     [ ebp - 24 ]
%define @XEOS.32.proc.var.7     [ ebp - 28 ]
%define @XEOS.32.proc.var.8     [ ebp - 32 ]
%define @XEOS.32.proc.var.9     [ ebp - 36 ]
%define @XEOS.32.proc.var.10    [ ebp - 40 ]
%define @XEOS.32.proc.var.11    [ ebp - 44 ]
%define @XEOS.32.proc.var.12    [ ebp - 48 ]
%define @XEOS.32.proc.var.13    [ ebp - 52 ]
%define @XEOS.32.proc.var.14    [ ebp - 56 ]
%define @XEOS.32.proc.var.15    [ ebp - 60 ]
%define @XEOS.32.proc.var.16    [ ebp - 64 ]
%define @XEOS.32.proc.var.18    [ ebp - 68 ]
%define @XEOS.32.proc.var.19    [ ebp - 72 ]
%define @XEOS.32.proc.var.20    [ ebp - 76 ]

; Shortcuts for stack (local) variables (16 bits procedure)
%define @XEOS.16.proc.var.1     @XEOS.32.proc.var.1
%define @XEOS.16.proc.var.2     @XEOS.32.proc.var.2
%define @XEOS.16.proc.var.3     @XEOS.32.proc.var.3
%define @XEOS.16.proc.var.4     @XEOS.32.proc.var.4
%define @XEOS.16.proc.var.5     @XEOS.32.proc.var.5
%define @XEOS.16.proc.var.6     @XEOS.32.proc.var.6
%define @XEOS.16.proc.var.7     @XEOS.32.proc.var.7
%define @XEOS.16.proc.var.8     @XEOS.32.proc.var.8
%define @XEOS.16.proc.var.9     @XEOS.32.proc.var.9
%define @XEOS.16.proc.var.10    @XEOS.32.proc.var.10
%define @XEOS.16.proc.var.11    @XEOS.32.proc.var.11
%define @XEOS.16.proc.var.12    @XEOS.32.proc.var.12
%define @XEOS.16.proc.var.13    @XEOS.32.proc.var.13
%define @XEOS.16.proc.var.14    @XEOS.32.proc.var.14
%define @XEOS.16.proc.var.15    @XEOS.32.proc.var.15
%define @XEOS.16.proc.var.16    @XEOS.32.proc.var.16
%define @XEOS.16.proc.var.17    @XEOS.32.proc.var.17
%define @XEOS.16.proc.var.18    @XEOS.32.proc.var.18
%define @XEOS.16.proc.var.19    @XEOS.32.proc.var.19
%define @XEOS.16.proc.var.20    @XEOS.32.proc.var.20

; Shortcuts for stack (local) variables (64 bits procedure)
%define @XEOS.64.proc.var.1     [ rbp -    8 ]
%define @XEOS.64.proc.var.2     [ rbp -   16 ]
%define @XEOS.64.proc.var.3     [ rbp -   24 ]
%define @XEOS.64.proc.var.4     [ rbp -   32 ]
%define @XEOS.64.proc.var.5     [ rbp -   40 ]
%define @XEOS.64.proc.var.6     [ rbp -   48 ]
%define @XEOS.64.proc.var.7     [ rbp -   56 ]
%define @XEOS.64.proc.var.8     [ rbp -   64 ]
%define @XEOS.64.proc.var.9     [ rbp -   72 ]
%define @XEOS.64.proc.var.10    [ rbp -   80 ]
%define @XEOS.64.proc.var.11    [ rbp -   88 ]
%define @XEOS.64.proc.var.12    [ rbp -   96 ]
%define @XEOS.64.proc.var.13    [ rbp -  104 ]
%define @XEOS.64.proc.var.14    [ rbp -  112 ]
%define @XEOS.64.proc.var.15    [ rbp -  120 ]
%define @XEOS.64.proc.var.16    [ rbp -  128 ]
%define @XEOS.64.proc.var.17    [ rbp -  136 ]
%define @XEOS.64.proc.var.18    [ rbp -  144 ]
%define @XEOS.64.proc.var.19    [ rbp -  152 ]
%define @XEOS.64.proc.var.20    [ rbp -  160 ]

%endif
