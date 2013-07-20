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
; @file            xeos.gdt.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2012, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Procedures and definitions for the GDT (Global Descriptor Table)
;-------------------------------------------------------------------------------

%ifndef __XEOS_16_GDT_INC_S__
%define __XEOS_16_GDT_INC_S__

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Installation of the GDT (32 bits)
; 
; Input registers:
;       
;       None
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.gdt.install.32:
    
    @XEOS.16.proc.start 0
    
    ; Clears the interrupts
    cli
    
    lgdt    [ $XEOS.gdt._pointer.32 ]
    
    ; Restores the interrupts
    sti
    
    @XEOS.16.proc.end
    
    ret
    
;-------------------------------------------------------------------------------
; Installation of the GDT (64 bits)
; 
; Input registers:
;       
;       None
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.gdt.install.64:
    
    @XEOS.16.proc.start 0
    
    ; Clears the interrupts
    cli
    
    lgdt    [ $XEOS.gdt._pointer.64 ]
    
    ; Restores the interrupts
    sti
    
    @XEOS.16.proc.end
    
    ret

;-------------------------------------------------------------------------------
; Definitions & Macros
;-------------------------------------------------------------------------------

; 32 bits descriptors
%define @XEOS.gdt.descriptors.32.null       0x00
%define @XEOS.gdt.descriptors.32.code       0x08
%define @XEOS.gdt.descriptors.32.data       0x10

; 64 bits descriptors
%define @XEOS.gdt.descriptors.64.null       0x00
%define @XEOS.gdt.descriptors.64.code       0x08
%define @XEOS.gdt.descriptors.64.data       0x18

;-------------------------------------------------------------------------------
; Type definitions
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; GDT Descriptor (32 bits)
; 
; A descriptor is 8 bytes long, and has the following structure:
;       
;       - Bits  0 - 15: Segment limit (0-15)
;       - Bits 16 - 31: Base address (0-15)
;       - Bits 31 - 39: Base address (16-23)
;       - Bit  40:      Access bit (only for virtual memory)
;       - Bits 41 - 43: Descriptor type
;                           Bit 41: Readable and writeable
;                                       0:  Read only (data segment)
;                                           Execute only (code segment)
;                                       1:  Read and write (data segment)
;                                       1:  Read and execute (code segment)
;                           Bit 42: Expansion direction (for data segment)
;                                   or conforming (code segment)
;                           Bit 43: Executable segment
;                                       0:  Data segment
;                                       1:  Code segment
;       - Bit  44:      Descriptor bit
;                           0:      System descriptor
;                           1:      Code or data descriptor
;       - Bits 45 - 46: Descriptor privilege level (rings 0 to 3)
;       - Bit  47:      Segment is in memory (only for virtual memory)
;       - Bits 48 - 51: Segment limit (16-19)
;       - Bit  52:      Reserved (for OS)
;       - Bit  53:      Reserved
;       - Bit  54:      Segment type
;                           0:      16 bits
;                           1:      32 bits
;       - Bit  55:      Granularity
;                           0:      None
;                           1:      Limit is multiplied by 4K
;       - Bits 56 - 63: Base address (24-31)
;-------------------------------------------------------------------------------
struc XEOS.gdt.descriptor_32_t

    .segment1       resw    1
    .base1          resw    1
    .base2          resb    1
    .info           resb    1
    .segment        resb    1
    .base3          resb    1

endstruc

;-------------------------------------------------------------------------------
; GDT Descriptor (64 bits)
; 
; A descriptor is 8 bytes long, and has the following structure:
;       
;       - Bits  0 - 15: Segment limit (0-15)
;       - Bits 16 - 31: Base address (0-15)
;       - Bits 31 - 39: Base address (16-23)
;       - Bit  40:      Access bit (only for virtual memory)
;       - Bits 41 - 43: Descriptor type
;                           Bit 41: Readable and writeable
;                                       0:  Read only (data segment)
;                                           Execute only (code segment)
;                                       1:  Read and write (data segment)
;                                       1:  Read and execute (code segment)
;                           Bit 42: Expansion direction (for data segment)
;                                   or conforming (code segment)
;                           Bit 43: Executable segment
;                                       0:  Data segment
;                                       1:  Code segment
;       - Bit  44:      Descriptor bit
;                           0:      System descriptor
;                           1:      Code or data descriptor
;       - Bits 45 - 46: Descriptor privilege level (rings 0 to 3)
;       - Bit  47:      Segment is in memory (only for virtual memory)
;       - Bits 48 - 51: Segment limit (16-19)
;       - Bit  52:      Reserved (for OS)
;       - Bit  53:      Reserved
;       - Bit  54:      Segment type
;                           0:      16 bits
;                           1:      32 bits
;       - Bit  55:      Granularity
;                           0:      None
;                           1:      Limit is multiplied by 4K
;       - Bits 56 - 63: Base address (24-31)
;-------------------------------------------------------------------------------
struc XEOS.gdt.descriptor_64_t

    .segment1       resw    1
    .base1          resw    1
    .base2          resb    1
    .info           resb    1
    .segment        resb    1
    .base3          resb    1

endstruc

;-------------------------------------------------------------------------------
; GDT - Global Descriptor Table (32 bits)
; 
; Definition of the global memory map for the 32bits protected mode.
; 
; The GDT is composed of three descriptors:
;       
;       - Null descriptor - All zeros
;       - Code descriptor - Memory area that can be executed
;       - Data descriptor - Memory area that contains data
;-------------------------------------------------------------------------------
struc XEOS.gdt_32_t

    .null           resb    XEOS.gdt.descriptor_32_t_size
    .code           resb    XEOS.gdt.descriptor_32_t_size
    .data           resb    XEOS.gdt.descriptor_32_t_size

endstruc

;-------------------------------------------------------------------------------
; GDT - Global Descriptor Table (64 bits)
; 
; Definition of the global memory map for the 32bits protected mode.
; 
; The GDT is composed of three descriptors:
;       
;       - Null descriptor - All zeros
;       - Code descriptor - Memory area that can be executed
;       - Data descriptor - Memory area that contains data
;-------------------------------------------------------------------------------
struc XEOS.gdt_64_t

    .null           resb    XEOS.gdt.descriptor_64_t_size
    .code           resb    XEOS.gdt.descriptor_64_t_size
    .data           resb    XEOS.gdt.descriptor_64_t_size

endstruc

;-------------------------------------------------------------------------------
; Variables definitions
;-------------------------------------------------------------------------------

; XEOS GDT (32 bits)
$XEOS.gdt.32
    
    istruc XEOS.gdt_32_t
        
        ;-----------------------------------------------------------------------
        ; Null descriptor
        ;-----------------------------------------------------------------------
        
        db 00000000b    ; Limit / Low
        db 00000000b    ; Limit / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Middle
        db 00000000b    ; Access
        db 00000000b    ; Granularity
        db 00000000b    ; Base / High
        
        ;-----------------------------------------------------------------------
        ; Kernel space code descriptor
        ;-----------------------------------------------------------------------
        
        db 11111111b    ; Limit / Low
        db 11111111b    ; Limit / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Middle
        db 10011010b    ; Access
        db 11001111b    ; Granularity
        db 00000000b    ; Base / High
        
        ;-----------------------------------------------------------------------
        ; Kernel space data descriptor
        ;-----------------------------------------------------------------------
        
        db 11111111b    ; Limit / Low
        db 11111111b    ; Limit / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Middle
        db 10010010b    ; Access
        db 11001111b    ; Granularity
        db 00000000b    ; Base / High
        
    iend

; XEOS GDT (64 bits)
$XEOS.gdt.64
    
    istruc XEOS.gdt_64_t
    
        ;-----------------------------------------------------------------------
        ; Null descriptor
        ;-----------------------------------------------------------------------
        
        db 00000000b    ; Limit / Low
        db 00000000b    ; Limit / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Middle
        db 00000000b    ; Access
        db 00000000b    ; Granularity
        db 00000000b    ; Base / High
        
        ;-----------------------------------------------------------------------
        ; Kernel space code descriptor
        ;-----------------------------------------------------------------------
        
        db 00000000b    ; Limit / Low
        db 00000000b    ; Limit / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Middle
        db 10011000b    ; Access
        db 00100000b    ; Granularity
        db 00000000b    ; Base / High
        
        ;-----------------------------------------------------------------------
        ; Kernel space data descriptor
        ;-----------------------------------------------------------------------
        
        db 00000000b    ; Limit / Low
        db 00000000b    ; Limit / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Low
        db 00000000b    ; Base / Middle
        db 10010000b    ; Access
        db 00000000b    ; Granularity
        db 00000000b    ; Base / High
        
    iend

; Pointer to the GDT (32 bits)
$XEOS.gdt._pointer.32:
    
    dw  XEOS.gdt_32_t_size - 1
    dd  $XEOS.gdt.32

; Pointer to the GDT (64 bits)
$XEOS.gdt._pointer.64:
    
    dw  XEOS.gdt_64_t_size - 1
    dd  $XEOS.gdt.64
    
%endif

