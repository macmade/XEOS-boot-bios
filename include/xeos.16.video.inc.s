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
; @file            xeos.16.video.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Defines, macros and procedures for the BIOS video services
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
;-------------------------------------------------------------------------------

%ifndef __XEOS_16_VIDEO_INC_S__
%define __XEOS_16_VIDEO_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------
%include "xeos.macros.inc.s"          ; General macros
%include "xeos.16.int.inc.s"          ; BIOS interrupts

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Definitions
;-------------------------------------------------------------------------------

; BIOS screen dimensions
%define @XEOS.16.video.screen.cols          80
%define @XEOS.16.video.screen.rows          25

; BIOS colors
%define @XEOS.16.video.color.black          0x00
%define @XEOS.16.video.color.blue           0x01
%define @XEOS.16.video.color.green          0x02
%define @XEOS.16.video.color.cyan           0x03
%define @XEOS.16.video.color.red            0x04
%define @XEOS.16.video.color.magenta        0x05
%define @XEOS.16.video.color.brown          0x06
%define @XEOS.16.video.color.gray.light     0x07
%define @XEOS.16.video.color.gray           0x08
%define @XEOS.16.video.color.blue.light     0x09
%define @XEOS.16.video.color.green.light    0x0A
%define @XEOS.16.video.color.cyan.light     0x0B
%define @XEOS.16.video.color.red.light      0x0C
%define @XEOS.16.video.color.magenta.light  0x0D
%define @XEOS.16.video.color.brown.light    0x0E
%define @XEOS.16.video.color.white          0x0F

;-------------------------------------------------------------------------------
; Sets a color palette value
; 
; Parameters:
; 
;       1:          The palette color's number
;       2:          The red component (0-255)
;       3:          The green component (0-255)
;       4:          The blue component (0-255)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.video.setPaletteColor 4
    
    ; Saves all registers
    pusha
    
    ; RGB components (VGA format - 0-63)
    mov     dh,     ( %2 * 63 ) / 255
    mov     ch,     ( %3 * 63 ) / 255
    mov     cl,     ( %4 * 63 ) / 255
    
    ; Color number
    mov     bx,     %1
    
    ; BIOS video function to set a palette color
    mov     ah,     0x10
    mov     al,     0x10
    
    ; Calls the BIOS video services
    @XEOS.16.int.video
    
    ; Restores all registers
    popa
    
%endmacro

;-------------------------------------------------------------------------------
; Computes the value of a BIOS screen color into a register
; 
; Parameters:
; 
;       1:          The register in which to place the color value
;       2:          The foreground color
;       3:          The background color
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.video.createScreenColor 3
    
    ; Stores the background color
    mov     %1,     %3
    shl     %1,     4
    
    ; Stores the foreground color
    or      %1,     %2
    
%endmacro

;-------------------------------------------------------------------------------
; BIOS - Moves the cursor
; 
; Parameters:
; 
;       1:          The X position
;       2:          The Y position
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.video.setCursor 2
    
    ; Saves registers
    pusha
    
    ; Position cursor (BIOS video services function)
    mov     ah,     2
    
    ; Page number
    xor     bh,     bh
    
    ; XY coordinates
    mov     dh,     %1
    mov     dl,     %2
    
    ; Calls the BIOS video services
    @XEOS.16.int.video
    
    ; Restores registers
    popa
    
%endmacro

;-------------------------------------------------------------------------------
; BIOS - Clears the screen
; 
; Parameters:
; 
;       1:          The foreground color
;       2:          The background color
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.video.clearScreen 2
    
    ; Saves registers
    pusha
    
    ; Clear or scroll up (BIOS video services function)
    mov     ah,     6
    
    ; Number of lines to scroll (0 means clear)
    xor     al,     al
    
    ; Sets the screen color
    @XEOS.16.video.createScreenColor bh, %1, %2
    
    ; XY coordinates
    xor     cx,     cx
    
    ; Width and height
    mov     dl,     @XEOS.16.video.screen.cols - 1
    mov     dh,     @XEOS.16.video.screen.rows - 1
    
    ; Calls the BIOS video services
    @XEOS.16.int.video
    
    ; Repositions the cursor to the top-left corner
    @XEOS.16.video.setCursor 0, 0
    
    ; Restores registers
    popa
    
%endmacro

;-------------------------------------------------------------------------------
; Prints a string
; 
; Parameters:
; 
;       1:          The address of the string to print
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.video.print  1
    
    ; Saves registers
    pusha
    
    ; Prints the string
    mov     si,     %1
    call    XEOS.16.video.print
    
    ; Restores registers
    popa
    
%endmacro

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Prints a string
; 
; Input registers:
; 
;       - SI:       The address of the string to print (DS:SI)
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       - AX
;       - SI
;-------------------------------------------------------------------------------
XEOS.16.video.print:
    
    ; Outputs a single character (BIOS video services function)
    mov     ah,         0x0E
    
    ; Process a byte from the string
    .repeat:
        
        ; Gets a byte from the string placed in SI (will be placed in AL)
        lodsb
        
        ; Checks for the end of the string (ASCII 0)
        cmp     al,         0
        
        ; End of the string detected
        je      .done
        
        ; Calls the BIOS video services
        @XEOS.16.int.video
        
        ; Process the next byte from the string
        jmp     .repeat
            
    ; End of the string
    .done:
        
        ret

%endif
