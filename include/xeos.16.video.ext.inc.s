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
; @file            xeos.16.video.ext.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Defines, macros and procedures for the BIOS video services
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
;-------------------------------------------------------------------------------

%ifndef __XEOS_16_VIDEO_EXT_INC_S__
%define __XEOS_16_VIDEO_EXT_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------
%include "xeos.macros.inc.s"        ; General macros
%include "xeos.16.int.inc.s"        ; BIOS interrupts
%include "xeos.16.video.inc.s"      ; BIOS video services

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Sets a color palette value
; 
; Parameters:
; 
;       1:          The palette color's number (VGA)
;       2:          The palette color's number (EGA)
;       3:          The red component (0-255)
;       4:          The green component (0-255)
;       5:          The blue component (0-255)
; 
; Killed registers:
;       
;       - BX
;       - DH
;       - CH
;       - CL
;-------------------------------------------------------------------------------
%macro @XEOS.16.video.setPaletteColor 5
    
    ; RGB components (VGA format - 0-63)
    mov     dh,     ( %3 * 63 ) / 255
    mov     ch,     ( %4 * 63 ) / 255
    mov     cl,     ( %5 * 63 ) / 255
    
    ; Color number
    mov     bx,     %1
    
    ; Sets the palette color
    call XEOS.16.video.setPaletteColor
    
    ; Color number
    mov     bx,     %2
    
    ; Sets the palette color
    call XEOS.16.video.setPaletteColor
    
%endmacro

;-------------------------------------------------------------------------------
; Sets a color palette value
; 
; Input registers:
; 
;       - BX:       The palette color's number
;       - DH:       The red component (0-255)
;       - CH:       The green component (0-255)
;       - CL:       The blue component (0-255)
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.video.setPaletteColor:
    
    ; Saves all registers
    pusha
    
    ; BIOS video function to set a palette color
    mov     ah,     0x10
    mov     al,     0x10
    
    ; Calls the BIOS video services
    @XEOS.16.int.video
    
    ; Restores all registers
    popa
    
    ret

%endif
