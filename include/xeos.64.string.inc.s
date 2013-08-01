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
; @file            xeos.64.string.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; String procedures
; 
; Those procedures and macros are intended to be used only in 64 bits long mode.
;-------------------------------------------------------------------------------

%ifndef __XEOS_64_STRING_INC_S__
%define __XEOS_64_STRING_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------

%include "xeos.constants.inc.s"       ; General constants
%include "xeos.macros.inc.s"          ; General macros
%include "xeos.ascii.inc.s"           ; ASCII table

; We are in 32 bits mode
BITS    64

;-------------------------------------------------------------------------------
; Definitions & Macros
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Converts an unsigned binary bumber into a string representation
; 
; Parameters:
; 
;       1:          The unsigned binary number
;       2:          The base in which to convert the number
;       3:          Only for base 16: zero padding
;       4:          Only for base 16: if 1, prefix with 0x, otherwise don't
;       5:          The destination byte buffer for the string   
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.64.string.numberToString 5
    
    ; Saves registrers
    push    rax
    push    rbx
    push    rcx
    push    rdx
    push    rdi
    push    rsi
    
    mov     rax,        %1
    mov     rbx,        %2
    mov     rcx,        %3
    mov     rdx,        %4
    mov     rdi,        %5
    call                XEOS.64.string.numberToString
    
    ; Restores registers
    pop     rsi
    pop     rdi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rax
    
%endmacro

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Checks if a character is printable
; 
; Input registers:
;       
;       - RDX:      The character code
; 
; Return registers:
;       
;       - RAX:      The result code (1 if character is printable, otherwise 0)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.64.string.isPrintable:
    
    @XEOS.64.proc.start 0
    
    ; ASCII control characters
    cmp     rdx,    0x20
    jb      .notPrintable
    
    ; Non-ASCII
    cmp     rdx,    0x7F
    jb      .printable
    
    ;---------------------------------------------------------------------------
    ; Character is not printable
    ;---------------------------------------------------------------------------
    .notPrintable:
        
        @XEOS.64.proc.end
        
        ; Not printable - Stores result code in RAX
        xor     rax,        rax
        
        ret
    
    ;---------------------------------------------------------------------------
    ; Character is printable
    ;---------------------------------------------------------------------------
    .printable:
        
        @XEOS.64.proc.end
        
        ; Printable - Stores result code in RAX
        mov     rax,        0x01
        
        ret
    
;-------------------------------------------------------------------------------
; Converts an unsigned binary bumber into a string representation
; 
; Input registers:
;       
;       - RAX:      The unsigned binary number
;       - RBX:      The base in which to convert the number
;       - RCX:      Only for base 16: zero padding
;       - RDX:      Only for base 16: if 1, prefix with 0x, otherwise don't
;       - RDI:      The destination byte buffer for the string
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.64.string.numberToString:
    
    @XEOS.64.proc.start 0
    
    ; Checks if we are going to print in hexadecimal
    cmp     rbx,        0x10
    je      .prefix.hex
    
    ; Checks if we are going to print in decimal
    cmp     rbx,        0x0A
    je      .start
    
    ; Checks if we are going to print in octal
    cmp     rbx,        0x08
    je      .start
    
    ; Checks if we are going to print in binary
    cmp     rbx,        0x02
    je      .start
    
    @XEOS.64.proc.end
    
    ret
    
    .prefix.hex:
        
        ; Stores the padding
        mov     rsi,        rcx
        
        ; Checks if we need to prefix with 0x
        cmp     rdx,        0x01
        jne     .start
        
        ; Adds the 0x prefix
        mov     [ rdi ],        BYTE 0x30
        mov     [ rdi + 1 ],    BYTE 0x78
        add     rdi,            0x02
    
    .start:
        
        ; Resets RCX (digit counter)
        xor     rcx,        rcx
        
    .divide:
        
        ; Divides by the base
        xor     rdx,        rdx
        div     rbx
        
        ; Saves the reminder
        push    rdx
        
        ; Increments RCX (digit counter)
        inc     rcx
        
        ; Continues dividing till we reach 0
        cmp     rax,         0x00
        jg      .divide
        
        ; Checks if we are going to print in hexadecimal
        cmp     rbx,        0x10
        jne     .dec
    
    ;---------------------------------------------------------------------------
    ; Hexadecimal
    ;---------------------------------------------------------------------------
    .hex:
        
        ; Pushes the counter
        push    rcx
        
        ; Checks if we need to pad with 0
        cmp     rsi,        rcx
        jle     .hex.pad.done
        
        ; Number of zeros for padding
        sub     rsi,    rcx
        mov     rcx,    rsi
        
        .hex.pad:
            
            ; Adds a 0 for padding
            mov     [ rdi ],    BYTE 0x30
            inc     rdi
            
            ; Continues padding
            loop    .hex.pad
            
        .hex.pad.done:
            
            ; Restores the counter
            pop     rcx
            
        .hex.char:
            
            ; Restores the reminder
            pop     rax
            
            ; Checks if we must print a digit or a letter
            cmp     rax,        0x09
            jg      .hex.letter
            
            .hex.number:
                
                ; Number - Adds 48 (ASCII for '0')
                add     al,         0x30
                jmp     .hex.store
                
            .hex.letter:
                
                ; Letter - Adds 65 (ASCII for 'A')
                sub     al,         0x0A
                add     al,         0x41
                
            .hex.store:
                
                ; Stores the character
                mov     [ rdi ],    BYTE al
                inc     rdi
            
            ; Continue till we have digits to print
            loop    .hex.char
            jmp     .end
        
    ;---------------------------------------------------------------------------
    ; Decimal
    ;---------------------------------------------------------------------------    
    .dec:
        
        ; Restores the reminder
        pop     rax
        
        ; Adds 48 (ASCII for '0')
        add     al,         0x30
        
        ; Stores the character
        mov     [ rdi ],    BYTE al
        inc     rdi
        
        ; Continue till we have digits to print
        loop    .dec
    
    ;---------------------------------------------------------------------------
    ; End
    ;---------------------------------------------------------------------------
    .end:
        
        ; Adds the terminating character (ASCII 0)
        mov     [ rdi ],    BYTE 0x00
    
    @XEOS.64.proc.end
    
    ret
    
%endif
