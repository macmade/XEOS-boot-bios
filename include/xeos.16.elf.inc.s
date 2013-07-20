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
; @file            xeos.16.elf.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2012, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Procedures for the ELF format
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
;-------------------------------------------------------------------------------

%ifndef __XEOS_16_ELF_INC_S__
%define __XEOS_16_ELF_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------

%include "xeos.macros.inc.s"          ; General macros
%include "xeos.ascii.inc.s"           ; ASCII table

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Variables definition
;-------------------------------------------------------------------------------

; ELF file signatures
$XEOS.16.elf.32.signature   db  0x7F, 0x45, 0x4C, 0x46
$XEOS.16.elf.64.signature   db  0x7F, 0x45, 0x4C, 0x46

; Entry points
$XEOS.16.elf.32.entry       dd  0
$XEOS.16.elf.64.entry       dd  0

;-------------------------------------------------------------------------------
; Type definitions
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; The ELF-32 header has the following structure:
;       
;       - BYTE  e_ident[ 16 ]   File identification
;       - WORD  e_type          Object file type
;       - WORD  e_machine       Required architecture
;       - DWORD e_version       Object file version
;       - DWORD e_entry         Entry point address
;       - DWORD e_phoff         Program header table's file offset
;       - DWORD e_shoff         Section header table's file offset
;       - DWORD e_flags         Processor-specific flags
;       - WORD  e_ehsize        ELF header's size
;       - WORD  e_phentsize     Size of an entry in the program header table
;                               (all entries are the same size)
;       - WORD  e_phnum         Number of entries in the program header table
;       - WORD  e_shentsize     Section header's size
;       - WORD  e_shnum         Number of entries in the section header table
;       - WORD  e_shstrndx      Section header table index of the entry
;                               associated with the section name string table
;-------------------------------------------------------------------------------
struc XEOS.16.elf.32.header_t

    .e_ident:       resb    16
    .e_type:        resw    1
    .e_machine:     resw    1
    .e_version:     resd    1
    .e_entry:       resd    1
    .e_phoff:       resd    1
    .e_shoff:       resd    1
    .e_flags:       resd    1
    .e_ehsize:      resw    1
    .e_phentsize:   resw    1
    .e_phnum:       resw    1
    .e_shentsize:   resw    1
    .e_shnum:       resw    1
    .e_shstrndx:    resw    1

endstruc

;-------------------------------------------------------------------------------
; The ELF-64 header has the following structure:
;       
;       - BYTE  e_ident[ 16 ]   File identification
;       - WORD  e_type          Object file type
;       - WORD  e_machine       Required architecture
;       - DWORD e_version       Object file version
;       - DWORD e_entry         Entry point address
;       - DWORD e_phoff         Program header table's file offset
;       - DWORD e_shoff         Section header table's file offset
;       - DWORD e_flags         Processor-specific flags
;       - WORD  e_ehsize        ELF header's size
;       - WORD  e_phentsize     Size of an entry in the program header table
;                               (all entries are the same size)
;       - WORD  e_phnum         Number of entries in the program header table
;       - WORD  e_shentsize     Section header's size
;       - WORD  e_shnum         Number of entries in the section header table
;       - WORD  e_shstrndx      Section header table index of the entry
;                               associated with the section name string table
;-------------------------------------------------------------------------------
struc XEOS.16.elf.64.header_t

    .e_ident:       resb    16
    .e_type:        resw    1
    .e_machine:     resw    1
    .e_version:     resd    1
    .e_entry:       resd    1
    .e_phoff:       resd    1
    .e_shoff:       resd    1
    .e_flags:       resd    1
    .e_ehsize:      resw    1
    .e_phentsize:   resw    1
    .e_phnum:       resw    1
    .e_shentsize:   resw    1
    .e_shnum:       resw    1
    .e_shstrndx:    resw    1

endstruc

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Checks the ELF-32 header to ensure it's a valid ELF-32 binary file
; 
; Input registers:
;       
;       - SI:       The memory address at which the file is loaded
; 
; Return registers:
;       
;       - AX:       The result code (0 if no error)
;       - EDI:      The ELF entry point address
; 
; Killed registers:
;       
;       None   
;-------------------------------------------------------------------------------
XEOS.16.elf.32.checkHeader:
    
    @XEOS.16.proc.start 0
    
    ; Saves registers
    push    ds
    
    ; Sets DS:SI to the ELF file location
    mov     ax,         si
    mov     ds,         si
    xor     ax,         ax
    mov     si,         ax
    
    ;---------------------------------------------------------------------------
    ; Checks e_ident
    ;---------------------------------------------------------------------------
    .e_ident:
        
        .e_ident.magic:
            
            ; Compares with the ELF-32 signature
            mov     di,         $XEOS.16.elf.32.signature
            mov     cx,         0x04
            rep     cmpsb
            je      .e_ident.class
            
            ; Restores registers
            pop     ds
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x01
            
            ret
            
        .e_ident.class:
            
            ; Resets SI
            xor     si,         si
            
            ; Checks the ELF class (0x01 for 32 bits)
            xor     eax,        eax
            mov     al,         BYTE [ si + 4 ]
            cmp     al,         0x01
            je      .e_ident.encoding
            
            ; Restores registers
            pop     ds
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x02
            
            ret
            
        .e_ident.encoding:
            
            ; Checks the ELF encoding (0x01 for LSB)
            xor     eax,        eax
            mov     al,         BYTE [ si + 5 ]
            cmp     al,         0x01
            je      .e_ident.version
            
            ; Restores registers
            pop     ds
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x03
            
            ret
            
        .e_ident.version:
            
            ; Checks the ELF version (0x01)
            xor     eax,        eax
            mov     al,         BYTE [ si + 5 ]
            cmp     al,         0x01
            je      .e_type
            
            ; Restores registers
            pop     ds
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x04
            
            ret
            
    ;---------------------------------------------------------------------------
    ; Checks e_type
    ;---------------------------------------------------------------------------
    .e_type:
        
        ; Checks the ELF version (0x02 for executables)
        xor     eax,        eax
        mov     ax,         WORD [ si + XEOS.16.elf.32.header_t.e_type ]
        cmp     ax,         0x02
        je      .e_machine
        
        ; Restores registers
        pop     ds
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        mov     ax,         0x05
        
        ret
        
    ;---------------------------------------------------------------------------
    ; Checks e_machine
    ;---------------------------------------------------------------------------
    .e_machine:
        
        ; Checks the ELF version (0x03 for Intel 80386)
        xor     eax,        eax
        mov     ax,         WORD [ si + XEOS.16.elf.32.header_t.e_machine ]
        cmp     ax,         0x03
        je      .e_version
        
        ; Restores registers
        pop     ds
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        mov     ax,         0x06
        
        ret
        
    ;---------------------------------------------------------------------------
    ; Checks e_machine
    ;---------------------------------------------------------------------------
    .e_version:
        
        ; Checks the ELF version (0x01)
        xor     eax,        eax
        mov     ax,         WORD [ si + XEOS.16.elf.32.header_t.e_version ]
        cmp     ax,         0x01
        je      .success
        
        ; Restores registers
        pop     ds
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        mov     ax,         0x07
        
        ret
        
    ;---------------------------------------------------------------------------
    ; Valid ELF file
    ;---------------------------------------------------------------------------
    .success:
        
        ; Gets the entry point address
        mov     eax,        DWORD [ si + XEOS.16.elf.32.header_t.e_entry ]
        
        ; Restores registers
        pop     ds
        
        ; Stores the entry point address
        mov     DWORD [ $XEOS.16.elf.32.entry ],    eax
        
        @XEOS.16.proc.end
        
        ; Stores the entry point address in EDI
        mov     edi,        DWORD [ $XEOS.16.elf.32.entry ]
        
        ; Success - Stores result code in AX
        xor     ax,         ax
        
        ret
    
;-------------------------------------------------------------------------------
; Checks the ELF-64 header to ensure it's a valid ELF-64 binary file
; 
; Input registers:
;       
;       - SI:       The memory address at which the file is loaded
; 
; Return registers:
;       
;       - AX:       The result code (0 if no error)
;       - EDI:      The ELF entry point address
; 
; Killed registers:
;       
;       None   
;-------------------------------------------------------------------------------
XEOS.16.elf.64.checkHeader:
    
    @XEOS.16.proc.start 0
    
    ; Sets DS:SI to the ELF file location
    mov     ax,         si
    mov     ds,         si
    xor     ax,         ax
    mov     si,         ax
    
    ;---------------------------------------------------------------------------
    ; Checks e_ident
    ;---------------------------------------------------------------------------
    .e_ident:
        
        .e_ident.magic:
            
            ; Compares with the ELF-64 signature
            mov     di,         $XEOS.16.elf.64.signature
            mov     cx,         0x04
            rep     cmpsb
            je      .e_ident.class
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x01
            
            ret
            
        .e_ident.class:
            
            ; Resets SI
            xor     si,         si
            
            ; Checks the ELF class (0x02 for 64 bits)
            xor     eax,        eax
            mov     al,         BYTE [ si + 4 ]
            cmp     al,         0x02
            je      .e_ident.encoding
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x02
            
            ret
            
        .e_ident.encoding:
            
            ; Checks the ELF encoding (0x01 for LSB)
            xor     eax,        eax
            mov     al,         BYTE [ si + 5 ]
            cmp     al,         0x01
            je      .e_ident.version
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x03
            
            ret
            
        .e_ident.version:
            
            ; Checks the ELF version (0x01)
            xor     eax,        eax
            mov     al,         BYTE [ si + 5 ]
            cmp     al,         0x01
            je      .e_type
            
            @XEOS.16.proc.end
            
            ; Error - Stores result code in AX
            mov     ax,         0x04
            
            ret
            
    ;---------------------------------------------------------------------------
    ; Checks e_type
    ;---------------------------------------------------------------------------
    .e_type:
        
        ; Checks the ELF version (0x02 for executables)
        xor     eax,        eax
        mov     ax,         WORD [ si + XEOS.16.elf.64.header_t.e_type ]
        cmp     ax,         0x02
        je      .e_machine
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        mov     ax,         0x05
        
        ret
        
    ;---------------------------------------------------------------------------
    ; Checks e_machine
    ;---------------------------------------------------------------------------
    .e_machine:
        
        ; Checks the ELF version (0x3E for AMD64)
        xor     eax,        eax
        mov     ax,         WORD [ si + XEOS.16.elf.64.header_t.e_machine ]
        cmp     ax,         0x3E
        
        je      .e_version
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        mov     ax,         0x06
        
        ret
        
    ;---------------------------------------------------------------------------
    ; Checks e_machine
    ;---------------------------------------------------------------------------
    .e_version:
        
        ; Checks the ELF version (0x01)
        xor     eax,        eax
        mov     ax,         WORD [ si + XEOS.16.elf.64.header_t.e_version ]
        cmp     ax,         0x01
        je      .success
        
        @XEOS.16.proc.end
        
        ; Error - Stores result code in AX
        mov     ax,         0x07
        
        ret
        
    ;---------------------------------------------------------------------------
    ; Valid ELF file
    ;---------------------------------------------------------------------------
    .success:
        
        ; Gets the entry point address
        mov     eax,        DWORD [ si + XEOS.16.elf.64.header_t.e_entry ]
        
        ; Restores registers
        pop     ds
        
        ; Stores the entry point address
        mov     DWORD [ $XEOS.16.elf.64.entry ],    eax
        
        @XEOS.16.proc.end
        
        ; Stores the entry point address in EDI
        mov     edi,        DWORD [ $XEOS.16.elf.64.entry ]
        
        ; Success - Stores result code in AX
        xor     ax,         ax
        
        ret

%endif
