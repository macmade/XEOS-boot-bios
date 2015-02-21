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
; @file            xeos.16.string.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; String procedures
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
;-------------------------------------------------------------------------------

%ifndef __XEOS_16_STRING_INC_S__
%define __XEOS_16_STRING_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------

%include "xeos.constants.inc.s"       ; General constants
%include "xeos.macros.inc.s"          ; General macros
%include "xeos.ascii.inc.s"           ; ASCII table

; We are in 16 bits mode
BITS    16

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
%macro @XEOS.16.string.numberToString 5
    
    ; Saves registrers
    pusha
    
    mov     ax,         %1
    mov     bx,         %2
    mov     cx,         %3
    mov     dx,         %4
    mov     di,         %5
    call                XEOS.16.string.numberToString
    
    ; Restores registers
    popa
    
%endmacro

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Checks if a character is printable
; 
; Input registers:
;       
;       - DX:       The character code
; 
; Return registers:
;       
;       - AX:       The result code (1 if character is printable, otherwise 0)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.string.isPrintable:
    
    @XEOS.16.proc.start 0
    
    ; ASCII control characters
    cmp     dx,     0x20
    jb      .notPrintable
    
    ; Non-ASCII
    cmp     dx,     0x7F
    jb      .printable
    
    ;---------------------------------------------------------------------------
    ; Character is not printable
    ;---------------------------------------------------------------------------
    .notPrintable:
        
        @XEOS.16.proc.end
        
        ; Not printable - Stores result code in AX
        xor     ax,         ax
        
        ret
    
    ;---------------------------------------------------------------------------
    ; Character is printable
    ;---------------------------------------------------------------------------
    .printable:
        
        @XEOS.16.proc.end
        
        ; Printable - Stores result code in AX
        mov     ax,         0x01
        
        ret
    
;-------------------------------------------------------------------------------
; Converts an unsigned binary bumber into a string representation
; 
; Input registers:
;       
;       - AX:       The unsigned binary number
;       - BX:       The base in which to convert the number
;       - CX:       Only for base 16: zero padding
;       - DX:       Only for base 16: if 1, prefix with 0x, otherwise don't
;       - DI:       The destination byte buffer for the string
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.string.numberToString:
    
    @XEOS.16.proc.start 0
    
    ; Checks if we are going to print in hexadecimal
    cmp     ebx,        0x10
    je      .prefix.hex
    
    ; Checks if we are going to print in decimal
    cmp     ebx,        0x0A
    je      .start
    
    ; Checks if we are going to print in octal
    cmp     ebx,        0x08
    je      .start
    
    ; Checks if we are going to print in binary
    cmp     ebx,        0x02
    je      .start
    
    @XEOS.16.proc.end
    
    ret
    
    .prefix.hex:
        
        ; Stores the padding
        mov     si,         cx
        
        ; Checks if we need to prefix with 0x
        cmp     dx,         0x01
        jne     .start
        
        ; Adds the 0x prefix
        mov     [ di ],     BYTE 0x30
        mov     [ di + 1 ], BYTE 0x78
        add     di,         0x02
    
    .start:
        
        ; Resets ECX (digit counter)
        xor     ecx,        ecx
        
    .divide:
        
        ; Divides by the base
        xor     edx,        edx
        div     ebx
        
        ; Saves the reminder
        push    edx
        
        ; Increments ECX (digit counter)
        inc     ecx
        
        ; Continues dividing till we reach 0
        cmp     eax,         0x00
        jg      .divide
        
        ; Checks if we are going to print in hexadecimal
        cmp     ebx,        0x10
        jne     .dec
    
    ;---------------------------------------------------------------------------
    ; Hexadecimal
    ;---------------------------------------------------------------------------
    .hex:
        
        ; Pushes the counter
        push    cx
        
        ; Checks if we need to pad with 0
        cmp     si,         cx
        jle     .hex.pad.done
        
        ; Number of zeros for padding
        sub     si,     cx
        mov     cx,     si
        
        .hex.pad:
            
            ; Adds a 0 for padding
            mov     [ di ],     BYTE 0x30
            inc     di
            
            ; Continues padding
            loop    .hex.pad
            
        .hex.pad.done:
            
            ; Restores the counter
            pop     cx
            
        .hex.char:
            
            ; Restores the reminder
            pop     eax
            
            ; Checks if we must print a digit or a letter
            cmp     eax,        0x09
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
                mov     [ di ],     BYTE al
                inc     di
            
            ; Continue till we have digits to print
            loop    .hex.char
            jmp     .end
        
    ;---------------------------------------------------------------------------
    ; Decimal
    ;---------------------------------------------------------------------------    
    .dec:
        
        ; Restores the reminder
        pop     eax
        
        ; Adds 48 (ASCII for '0')
        add     al,         0x30
        
        ; Stores the character
        mov     [ di ],     BYTE al
        inc     di
        
        ; Continue till we have digits to print
        loop    .dec
    
    ;---------------------------------------------------------------------------
    ; End
    ;---------------------------------------------------------------------------
    .end:
        
        ; Adds the terminating character (ASCII 0)
        mov     [ di ],     BYTE 0x00
    
    @XEOS.16.proc.end
    
    ret
    
%endif
