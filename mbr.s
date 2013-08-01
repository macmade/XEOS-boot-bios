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
; @file            mbr.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; XEOS first stage bootloader
; 
; The binary form of this file must not be larger than 512 bytes (one sector).
; The last two bytes have to be the standard PC boot signature (0xAA55).
; 
; Note about compiling:
;
; This file has to be compiled as a flat-form binary file.
; 
; The following compilers have been successfully tested:
; 
;       - NASM - The Netwide Assembler
;       - YASM - The Yasm Modular Assembler
; 
; Other compilers have not been tested.
; 
; Examples:
; 
;       - nasm -f bin -o [boot.flp] [boot.s]
;       - yasm -f bin -o [boot.flp] [boot.s]
; 
; It can then be copied to a floppy disk image (as it contains a valid MBR):
; 
;       - dd -conv=notrunc if=[bin] of=[floppy]
;-------------------------------------------------------------------------------

; We are in 16 bits mode
BITS    16

; Segment registers will be set manually
ORG     0

; Jumps to the entry point
start: jmp main

; Includes the FAT-12 MBR, so the beginning of the binary will be a valid
; FAT-12 floppy drive
%include "xeos.io.fat12.mbr.inc.s"

;---------------------------------------------------------------------------
; Includes
;---------------------------------------------------------------------------

%include "xeos.constants.inc.s"     ; General constants
%include "xeos.ascii.inc.s"         ; ASCII table
%include "xeos.16.video.inc.s"      ; BIOS video services
%include "xeos.16.io.fat12.inc.s"   ; FAT-12 IO procedures

;-------------------------------------------------------------------------------
; Variables definition
;-------------------------------------------------------------------------------

; Start of the data sector
$XEOS.boot.stage1.dataSector    dw  0

; Name of the second stage bootloader (FAT-12 format)
$XEOS.files.stage2              db  "BOOT    BIN"

;-------------------------------------------------------------------------------
; Strings
;-------------------------------------------------------------------------------

$XEOS.boot.stage1.msg.boot      db  "XS: ", @ASCII.NUL
$XEOS.boot.stage1.msg.error     db  "FAIL",   @ASCII.NL, @ASCII.NUL
$XEOS.boot.stage1.msg.ok        db  "BOOT",   @ASCII.NL, @ASCII.NUL

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; First stage bootloader
; 
; This section is the bootloader's code that will be runned by the BIOS.
; The BIOS will load this file at 7C00:0000.
; 
; At that time, the memory layout should be the following:
; 
;       0x00000000 - 0x000003FF:      1'024 bytes       ISR vectors addresses
;       0x00000400 - 0x000004FF:        256 bytes       BIOS data
;       0x00000500 - 0x00007BFF:     30'464 bytes       Free
;       0x00007C00 - 0x00007DFF:        512 bytes       1st stage boot loader
;       0x00007E00 - 0x0007FFFF:    492'032 bytes       Free
;       0x00080000 - 0x0009FBFF:    130'048 bytes       Free
;       0x0009FC00 - 0x0009FFFF:      1'024 bytes       EBDA (Extended BIOS Data Area)
;       0x000A0000 - 0x000BFFFF:    131'072 bytes       BIOS video sub-system
;       0x000C0000 - 0x000EFFFF:    196'608 bytes       BIOS ROM
;       0x000F0000 - 0x000FFFFF:     65'536 bytes       System ROM
; 
; Stuff will be loaded at the following locations:
; 
;       0x00000500 - 0x00007BFF:     30'464 bytes       2nd stage boot loader
;       0x00007C00 - 0x00007DFF:        512 bytes       1st stage boot loader
;       0x00007E00 - 0x000099FF:      7'168 bytes 	    FAT-12 Root Directory
;       0x00009A00 - 0x0000FFFF:     18'432 bytes       FATs
;-------------------------------------------------------------------------------
main:
    
    ; Clears the interrupts as we are setting-up the segments and stack space
    cli
    
    ; Sets the data and extra segments to where we were loaded by the BIOS
    ; (0x07C0), so we don't have to add 0x07C0 to all our data.
    ; We are not setting FS and GS, as we won't use them, and is it will save
    ; a few bytes of code
    mov     ax,         0x07C0
    mov     ds,         ax
    mov     es,         ax
    
    ; Sets up the of stack space
    xor     ax,         ax
    mov     ss,         ax
    mov     sp,         0xFFFF
    
    ; Restores the interrupts
    sti
    
    ; Prints the welcome message
    mov     si,         $XEOS.boot.stage1.msg.boot
    call    XEOS.16.video.print
    
    ; Loads the FAT-12 root directory at ES:0200
    ; (07C0:0200 -> 0x007E00 -> just after this bootloader)
    mov     di,         0x0200
    call    XEOS.16.io.fat12.loadRootDirectory
    
    ; Checks for an error code
    cmp     ax,         0x00
    jne      .failure
    
    ; Stores the location of the first data sector
    mov     WORD [ $XEOS.boot.stage1.dataSector ],  dx
    
    ; Name of the second stage bootloader
    mov     si,         $XEOS.files.stage2
    
    ; Finds the second stage bootloader
    ; We have not altered DI, so it still contains the location of the FAT-12
    ; root directory
    call    XEOS.16.io.fat12.findFile
    
    ; Checks for an error code
    cmp     ax,         0x00
    jne     .failure
    
    ; Loads the file at 0050:0000 (first area of free/unused memory)
    mov     ax,         0x0050
    
    ; Loads the FAT at ES:1E00
    ; (07C0:1E00 -> 0x009A00 -> just after this FAT-12 root directory)
    mov     bx,         0x1E00
    
    ; Data sector location
    mov     cx,         WORD [ $XEOS.boot.stage1.dataSector ]
    
    ; Loads the second stage bootloader into memory
    call    XEOS.16.io.fat12.loadFile
    
    ; Checks for an error code
    cmp     ax,         0x00
    jne     .failure
    
    ;---------------------------------------------------------------------------
    ; Boot successfull
    ;---------------------------------------------------------------------------
    .success:
        
        ; Prints the sucess message
        mov     si,         $XEOS.boot.stage1.msg.ok
        call    XEOS.16.video.print
        
        ; Pass control to the second stage bootloader, now loacated at 0050:0000
        push    WORD 0x0050
        push    WORD 0x0000
        
        retf
        
    ;---------------------------------------------------------------------------
    ; Boot failed
    ;---------------------------------------------------------------------------
    .failure:
        
        ; Prints the error message
        mov     si,         $XEOS.boot.stage1.msg.error
        call    XEOS.16.video.print
        
        ; Waits for a key press
        xor     ax,         ax
        @XEOS.16.int.keyboard
        
        ; Reboot the computer
        @XEOS.16.int.reboot
        
        ; Halts the system
        cli
        hlt
    
;-------------------------------------------------------------------------------
; Ends of the boot sector
;-------------------------------------------------------------------------------

; Pads the remainder of the boot sector with '0', so we'll be able to write the
; boot signature
times   0x1FE - ( $ - $$ ) db  @ASCII.NUL

; 0x1FE (2) - Boot sector signature
dw      @XEOS.io.boot.signature 
