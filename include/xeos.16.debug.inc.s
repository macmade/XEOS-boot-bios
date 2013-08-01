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
; @file            xeos.16.debug.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Debug procedures
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
;-------------------------------------------------------------------------------
%ifndef __XEOS_16_DEBUG_INC_S__
%define __XEOS_16_DEBUG_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------
%include "xeos.constants.inc.s"     ; General constants
%include "xeos.macros.inc.s"        ; General macros
%include "xeos.ascii.inc.s"         ; ASCII table
%include "xeos.16.video.inc.s"      ; BIOS video services
%include "xeos.16.string.inc.s"     ; String utilities

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Variables definition
;-------------------------------------------------------------------------------

$XEOS.16.debug.register.eax                         dd  0
$XEOS.16.debug.register.ebx                         dd  0
$XEOS.16.debug.register.ecx                         dd  0
$XEOS.16.debug.register.edx                         dd  0
$XEOS.16.debug.register.esi                         dd  0
$XEOS.16.debug.register.edi                         dd  0
$XEOS.16.debug.register.esp                         dd  0
$XEOS.16.debug.register.ebp                         dd  0
$XEOS.16.debug.register.cs                          dw  0
$XEOS.16.debug.register.ds                          dw  0
$XEOS.16.debug.register.es                          dw  0
$XEOS.16.debug.register.fs                          dw  0
$XEOS.16.debug.register.gs                          dw  0
$XEOS.16.debug.register.ss                          dw  0
$XEOS.16.debug.register.eflags                      dd  0
$XEOS.16.debug.char                                 db  " ", @ASCII.NUL
$XEOS.16.debug.str                                  dd  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @ASCII.NUL

;-------------------------------------------------------------------------------
; Strings
;-------------------------------------------------------------------------------

$XEOS.16.debug.nl                               db  @ASCII.NL, @ASCII.NUL
$XEOS.16.debug.space                            db  " ", @ASCII.NUL
$XEOS.16.debug.separator                        db  ":", @ASCII.NUL
$XEOS.16.debug.pipe                             db  " ", 179, " ", @ASCII.NUL
$XEOS.16.debug.pipe.start                       db  179, " ", @ASCII.NUL
$XEOS.16.debug.hr.registers.top                 db  218, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 191, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.middle.top          db  195, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 194, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 194, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 194, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 194, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.middle              db  195, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 197, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 197, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 197, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 197, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.middle.short        db  195, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 197, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 197, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 197, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.middle.bottom       db  195, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 193, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 193, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 193, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.bottom              db  192, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 217, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.segment             db  32,  195, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.flags.top           db  195, 196, 196, 196, 196, 196, 196, 196, 196, 194, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 197, 196, 196, 196, 196, 196, 196, 196, 196, 194, 196, 196, 196, 193, 196, 196, \
                                                    196, 196, 194, 196, 196, 196, 196, 196, 193, 196, 196, 194, 196, 196, 196, 196, 196, \
                                                    196, 196, 193, 194, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.registers.flags.bottom        db  195, 196, 196, 196, 196, 196, 196, 196, 196, 193, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 193, 196, 196, 196, 196, 196, 196, 196, 196, 193, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 193, 196, 196, 196, 196, 196, 196, 196, 196, 193, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 193, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 180, 32, @ASCII.NUL
$XEOS.16.debug.str.registers.dump.header.left   db  "                   ", 4, @ASCII.NUL
$XEOS.16.debug.str.registers.dump.header        db  " DEBUG - x86 registers ", @ASCII.NUL
$XEOS.16.debug.str.registers.dump.header.right  db  4, "                   ", @ASCII.NUL
$XEOS.16.debug.str.registers.dump.footer        db  "                   Press any key to continue                   ", @ASCII.NUL
$XEOS.16.debug.str.register.eax                 db  "EAX: ", @ASCII.NUL
$XEOS.16.debug.str.register.ax                  db  "AX: ", @ASCII.NUL
$XEOS.16.debug.str.register.ah                  db  "AH: ", @ASCII.NUL
$XEOS.16.debug.str.register.al                  db  "AL: ", @ASCII.NUL
$XEOS.16.debug.str.register.ebx                 db  "EBX: ", @ASCII.NUL
$XEOS.16.debug.str.register.bx                  db  "BX: ", @ASCII.NUL
$XEOS.16.debug.str.register.bh                  db  "BH: ", @ASCII.NUL
$XEOS.16.debug.str.register.bl                  db  "BL: ", @ASCII.NUL
$XEOS.16.debug.str.register.ecx                 db  "ECX: ", @ASCII.NUL
$XEOS.16.debug.str.register.cx                  db  "CX: ", @ASCII.NUL
$XEOS.16.debug.str.register.ch                  db  "CH: ", @ASCII.NUL
$XEOS.16.debug.str.register.cl                  db  "CL: ", @ASCII.NUL
$XEOS.16.debug.str.register.edx                 db  "EDX: ", @ASCII.NUL
$XEOS.16.debug.str.register.dx                  db  "DX: ", @ASCII.NUL
$XEOS.16.debug.str.register.dh                  db  "DH: ", @ASCII.NUL
$XEOS.16.debug.str.register.dl                  db  "DL: ", @ASCII.NUL
$XEOS.16.debug.str.register.esi                 db  "ESI: ", @ASCII.NUL
$XEOS.16.debug.str.register.si                  db  "SI: ", @ASCII.NUL
$XEOS.16.debug.str.register.edi                 db  "EDI: ", @ASCII.NUL
$XEOS.16.debug.str.register.di                  db  "DI: ", @ASCII.NUL
$XEOS.16.debug.str.register.esp                 db  "ESP: ", @ASCII.NUL
$XEOS.16.debug.str.register.sp                  db  "SP: ", @ASCII.NUL
$XEOS.16.debug.str.register.ebp                 db  "EBP: ", @ASCII.NUL
$XEOS.16.debug.str.register.bp                  db  "BP: ", @ASCII.NUL
$XEOS.16.debug.str.register.cs                  db  "CS: ", @ASCII.NUL
$XEOS.16.debug.str.register.ds                  db  "DS: ", @ASCII.NUL
$XEOS.16.debug.str.register.es                  db  "ES: ", @ASCII.NUL
$XEOS.16.debug.str.register.fs                  db  "FS: ", @ASCII.NUL
$XEOS.16.debug.str.register.gs                  db  "GS: ", @ASCII.NUL
$XEOS.16.debug.str.register.ss                  db  "SS: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.cf            db  " CF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.pf            db  " PF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.af            db  " AF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.zf            db  " ZF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.sf            db  " SF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.tf            db  " TF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.if            db  " IF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.df            db  " DF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.of            db  " OF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.io            db  " IO: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.pl            db  " PL: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.nt            db  " NT: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.rf            db  " RF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.vm            db  " VM: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.ac            db  " AC: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.vif           db  "VIF: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.vip           db  "VIP: ", @ASCII.NUL
$XEOS.16.debug.str.register.flags.id            db  " ID: ", @ASCII.NUL
$XEOS.16.debug.str.registers.pad.16             db  177, 177, 177, 177, 177, 177, 177, 177, 177, 177, @ASCII.NUL
$XEOS.16.debug.str.registers.pad.8              db  177, 177, 177, 177, 177, 177, 177, 177, @ASCII.NUL
$XEOS.16.debug.str.registers.pad.flags          db  177, 177, 177, 177, 177, 177, 177, 177, 177, @ASCII.NUL
$XEOS.16.debug.hr.memory.top                    db  218, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 191, 32, @ASCII.NUL
$XEOS.16.debug.hr.memory.middle.top             db  195, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 194, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 194, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 194, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 194, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.memory.middle.bottom          db  195, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 193, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 193, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 193, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 193, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 180, 32, @ASCII.NUL
$XEOS.16.debug.hr.memory.bottom                 db  192, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, \
                                                    196, 217, 32, @ASCII.NUL
$XEOS.16.debug.str.memory.dump.header.left      db  "                     ", 4, @ASCII.NUL
$XEOS.16.debug.str.memory.dump.header           db  " DEBUG - Memory dump ", @ASCII.NUL
$XEOS.16.debug.str.memory.dump.header.right     db  4, "                      ", @ASCII.NUL
$XEOS.16.debug.str.memory.dump.footer           db  "           Press <c> to continue - Any other key to quit          ", @ASCII.NUL

;-------------------------------------------------------------------------------
; Definitions & Macros
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Prints text in color
; 
; Parameters:
; 
;       1:          The text to print
;       2:          The foreground color
;       3:          The background color
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.debug.print.color 3
    
    ; Saves registers
    pusha
    
    ; Creates the screen color
    @XEOS.16.video.createScreenColor bl, %2, %3
    
    ; Prints the string
    mov     si,         %1
    call    XEOS.16.debug.print.color
    
    ; Restores registers
    popa
    
%endmacro

;-------------------------------------------------------------------------------
; Prints text
; 
; Parameters:
; 
;       1:          The text to print
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.debug.print 1
    
     @XEOS.16.debug.print.color %1, @XEOS.16.video.color.white, @XEOS.16.video.color.black
    
%endmacro

;-------------------------------------------------------------------------------
; Registers dump: prints a general purpose register (32, 16, 8-8)
; 
; Parameters:
; 
;       1:          The register to print (a,b,c,d)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.debug.print.register.gp8 1
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe.start
    
    ; Prints the 32 bits register
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.e%1x, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.e%1x ]
    mov                         bx,     16
    mov                         cx,     8
    mov                         dx,     1
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    
    ; Prints the 16 bits register
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.%1x, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.e%1x ]
    and                         eax,    0x0000FFFF
    mov                         bx,     16
    mov                         cx,     4
    mov                         dx,     1
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    
    ; Prints the 8 bits register (high)
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.%1h, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.e%1x ]
    and                         eax,    0x0000FFFF
    shr                         eax,    8
    mov                         bx,     16
    mov                         cx,     2
    mov                         dx,     1
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    
    ; Prints the 8 bits register (low)
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.%1l, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.e%1x ]
    and                         eax,    0x000000FF
    mov                         bx,     16
    mov                         cx,     2
    mov                         dx,     1
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    
%endmacro

;-------------------------------------------------------------------------------
; Registers dump: prints a general purpose register (32, 16)
; 
; Parameters:
; 
;       1:          The register to print (si,di,sp,bp)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.debug.print.register.gp16 1
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe.start
    
    ; Prints the 32 bits register
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.e%1, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.e%1 ]
    mov                         bx,     16
    mov                         cx,     8
    mov                         dx,     1
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    
    ; Prints the 16 bits register
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.%1, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.e%1 ]
    and                         eax,    0x0000FFFF
    mov                         bx,     16
    mov                         cx,     4
    mov                         dx,     1
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
%endmacro

;-------------------------------------------------------------------------------
; Registers dump: prints a segment register
; 
; Parameters:
; 
;       1:          The register to print (c,d,e,f,g,s)
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.debug.print.register.segment 1
    
    ; Prints the segment register
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.%1s, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.%1s ]
    and                         eax,    0x0000FFFF
    mov                         bx,     16
    mov                         cx,     4
    mov                         dx,     1
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    
%endmacro

;-------------------------------------------------------------------------------
; Registers dump: prints a flag
; 
; Parameters:
; 
;       1:          The flag to print
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
%macro @XEOS.16.debug.print.register.flag 2
    
    ; Prints the flag
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.register.flags.%1, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    mov                         eax,    DWORD [ $XEOS.16.debug.register.eflags ]
    shr                         eax,    %2
    and                         eax,    0x00000001
    mov                         bx,     16
    xor                         cx,     cx
    xor                         dx,     dx
    mov                         di,     $XEOS.16.debug.str
    call                        XEOS.16.string.numberToString
    @XEOS.16.debug.print        $XEOS.16.debug.str
    
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    
%endmacro

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Prints all the x86 registers
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
XEOS.16.debug.registers.dump:
    
    @XEOS.16.proc.start    0
    
    ; Saves all register values
    mov     DWORD [ $XEOS.16.debug.register.eax ],      eax
    mov     DWORD [ $XEOS.16.debug.register.ebx ],      ebx
    mov     DWORD [ $XEOS.16.debug.register.ecx ],      ecx
    mov     DWORD [ $XEOS.16.debug.register.edx ],      edx
    mov     DWORD [ $XEOS.16.debug.register.esi ],      esi
    mov     DWORD [ $XEOS.16.debug.register.edi ],      edi
    mov     DWORD [ $XEOS.16.debug.register.esp ],      esp
    mov     DWORD [ $XEOS.16.debug.register.ebp ],      ebp
    mov      WORD [ $XEOS.16.debug.register.cs  ],      cs
    mov      WORD [ $XEOS.16.debug.register.ds  ],      ds
    mov      WORD [ $XEOS.16.debug.register.es  ],      es
    mov      WORD [ $XEOS.16.debug.register.fs  ],      fs
    mov      WORD [ $XEOS.16.debug.register.gs  ],      gs
    mov      WORD [ $XEOS.16.debug.register.ss  ],      ss
    
    ; Saves EFLAGS register
    pushfd
    pop     eax
    mov     DWORD [ $XEOS.16.debug.register.eflags ],   eax
    
    @XEOS.16.debug.print        $XEOS.16.debug.hr.registers.top
    @XEOS.16.debug.print        $XEOS.16.debug.nl
    @XEOS.16.debug.print        $XEOS.16.debug.pipe.start
    @XEOS.16.debug.print        $XEOS.16.debug.str.registers.dump.header.left
    @XEOS.16.debug.print.color  $XEOS.16.debug.str.registers.dump.header,  @XEOS.16.video.color.brown.light, @XEOS.16.video.color.black
    @XEOS.16.debug.print        $XEOS.16.debug.str.registers.dump.header.right
    @XEOS.16.debug.print        $XEOS.16.debug.pipe
    @XEOS.16.debug.print        $XEOS.16.debug.nl
    @XEOS.16.debug.print        $XEOS.16.debug.hr.registers.middle.top
    @XEOS.16.debug.print        $XEOS.16.debug.nl
    
    @XEOS.16.debug.print.register.gp8       a
    @XEOS.16.debug.print.register.segment   c
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print.register.gp8       b
    @XEOS.16.debug.print.register.segment   d
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print.register.gp8       c
    @XEOS.16.debug.print.register.segment   e
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print.register.gp8       d
    @XEOS.16.debug.print.register.segment   f
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    @XEOS.16.debug.print                    $XEOS.16.debug.hr.registers.middle.short
    @XEOS.16.debug.print.register.segment   g
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    @XEOS.16.debug.print.register.gp16      si
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.register.segment   s
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    @XEOS.16.debug.print.register.gp16      di
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.hr.registers.segment
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print.register.gp16      sp
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.16, @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print.register.gp16      bp
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.8,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.16, @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    @XEOS.16.debug.print                    $XEOS.16.debug.hr.registers.flags.top
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe.start
    @XEOS.16.debug.print.register.flag      cf, 0
    @XEOS.16.debug.print.register.flag      pf, 2
    @XEOS.16.debug.print.register.flag      af, 4
    @XEOS.16.debug.print.register.flag      zf, 6
    @XEOS.16.debug.print.register.flag      sf, 7
    @XEOS.16.debug.print.register.flag      tf, 8
    
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.flags,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe.start
    @XEOS.16.debug.print.register.flag      if, 9
    @XEOS.16.debug.print.register.flag      df, 10
    @XEOS.16.debug.print.register.flag      of, 11
    @XEOS.16.debug.print.register.flag      io, 12
    @XEOS.16.debug.print.register.flag      pl, 13
    @XEOS.16.debug.print.register.flag      nt, 14
    
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.flags,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe.start
    @XEOS.16.debug.print.register.flag      rf,  16
    @XEOS.16.debug.print.register.flag      vm,  17
    @XEOS.16.debug.print.register.flag      ac,  18
    @XEOS.16.debug.print.register.flag      vif, 19
    @XEOS.16.debug.print.register.flag      vip, 20
    @XEOS.16.debug.print.register.flag      id,  21
    
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.pad.flags,  @XEOS.16.video.color.gray, @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print                    $XEOS.16.debug.hr.registers.flags.bottom
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe.start
    @XEOS.16.debug.print.color              $XEOS.16.debug.str.registers.dump.footer,  @XEOS.16.video.color.gray.light,  @XEOS.16.video.color.black
    @XEOS.16.debug.print                    $XEOS.16.debug.pipe
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    @XEOS.16.debug.print                    $XEOS.16.debug.hr.registers.bottom
    @XEOS.16.debug.print                    $XEOS.16.debug.nl
    
    ; Waits for a key press
    xor     ax,         ax
    @XEOS.16.int.keyboard
    
    @XEOS.16.proc.end
    
    ret

;-------------------------------------------------------------------------------
; Prints memory
; 
; Input registers:
;       
;       - SI:       The memory address to print
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.debug.memory.dump:
    
    @XEOS.16.proc.start    0
    
    ; Resets BX (offset counter)
    xor     bx,         bx
    
    ; Prints 15 lines
    jmp     .continue
    
    .line:
        
        ; Prints a line of memory dump
        call                    XEOS.16.debug.memory.dump._line
        @XEOS.16.debug.print    $XEOS.16.debug.nl
        
        ; Sets the new offset, as we dumped 12 bytes
        add     bx,         0x0C
        
        ; Continues printing
        loop    .line
        
        @XEOS.16.debug.print    $XEOS.16.debug.hr.memory.middle.bottom
        @XEOS.16.debug.print    $XEOS.16.debug.nl
        @XEOS.16.debug.print    $XEOS.16.debug.pipe.start
        @XEOS.16.debug.print    $XEOS.16.debug.str.memory.dump.footer
        @XEOS.16.debug.print    $XEOS.16.debug.pipe
        @XEOS.16.debug.print    $XEOS.16.debug.nl
        @XEOS.16.debug.print    $XEOS.16.debug.hr.memory.bottom
        @XEOS.16.debug.print    $XEOS.16.debug.nl
        
    ; Waits for a key press
    xor     ax,         ax
    @XEOS.16.int.keyboard
    
    ; Checks if another dump must be printed ('c' key pressed)
    cmp     al,         0x63
    jne     .quit
    
    .continue:
        
        @XEOS.16.debug.print        $XEOS.16.debug.hr.memory.top
        @XEOS.16.debug.print        $XEOS.16.debug.nl
        @XEOS.16.debug.print        $XEOS.16.debug.pipe.start
        @XEOS.16.debug.print        $XEOS.16.debug.str.memory.dump.header.left
        @XEOS.16.debug.print.color  $XEOS.16.debug.str.memory.dump.header,  @XEOS.16.video.color.brown.light, @XEOS.16.video.color.black
        @XEOS.16.debug.print        $XEOS.16.debug.str.memory.dump.header.right
        @XEOS.16.debug.print        $XEOS.16.debug.pipe
        @XEOS.16.debug.print        $XEOS.16.debug.nl
        @XEOS.16.debug.print        $XEOS.16.debug.hr.memory.middle.top
        @XEOS.16.debug.print        $XEOS.16.debug.nl
        
        ; Prints 15 next lines
        mov     cx,         15
        jmp     .line
    
    .quit:
        
        @XEOS.16.proc.end
        
        ret

;-------------------------------------------------------------------------------
; Prints memory (single line)
; 
; Internal procedure used by XEOS.16.debug.memory.dump.
; 
; Input registers:
;       
;       - SI:       The memory address to print
;       - BX:       The offset to print
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------

XEOS.16.debug.memory.dump._line:
    
    @XEOS.16.proc.start     3
    @XEOS.16.proc.var.set   1,  si
    @XEOS.16.proc.var.set   2,  bx
    @XEOS.16.proc.var.set   3,  bx
    
    @XEOS.16.debug.print    $XEOS.16.debug.pipe.start
    
    ; Resets registers
    xor     eax,        eax
    xor     ebx,        ebx
    xor     ecx,        ecx
    xor     edx,        edx
    
    ; Prints the address segment
    @XEOS.16.string.numberToString  @XEOS.16.proc.var.1, 16, 4, 0, XEOS.16.debug.str
    @XEOS.16.debug.print.color      XEOS.16.debug.str, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    @XEOS.16.debug.print            $XEOS.16.debug.separator
    
    ; Prints the address offset
    @XEOS.16.string.numberToString  @XEOS.16.proc.var.2, 16, 4, 0, XEOS.16.debug.str
    @XEOS.16.debug.print.color      $XEOS.16.debug.str, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
    @XEOS.16.debug.print            $XEOS.16.debug.pipe
    
    ; We are going to print 3 groups of 4 bytes
    mov     cx,         3
    
    ;---------------------------------------------------------------------------
    ; Hexadecimal representation
    ;---------------------------------------------------------------------------
    .group:
        
        ; Restores registers
        mov     si,         WORD @XEOS.16.proc.var.1
        mov     bx,         WORD @XEOS.16.proc.var.3
        
        ; Saves registers
        push    cx
        
        ; We are going to print 4 bytes
        mov     cx,         4
        
        .word:
            
            ; Saves registers
            push    bx
            push    cx
            push    si
            push    ds
            
            ; Gets the byte from the memory location
            mov     ax,         si
            mov     ds,         si
            xor     ax,         ax
            mov     si,         ax
            add     si,         bx
            mov     al,         BYTE [ si ]
            
            ; Restores registers
            pop     ds
            
            ; Prints the byte
            @XEOS.16.string.numberToString  ax, 16, 2, 0, XEOS.16.debug.str
            @XEOS.16.debug.print            $XEOS.16.debug.str
            @XEOS.16.debug.print            $XEOS.16.debug.space
            
            ; Restores registers
            pop     si
            pop     cx
            pop     bx
            
            ; Prints next byte
            inc     bx
            loop    .word
        
        @XEOS.16.debug.print    $XEOS.16.debug.pipe.start
        
        ; Restores registers
        pop     cx
        
        ; Prints next group of bytes
        add     @XEOS.16.proc.var.3,   DWORD 4
        loop    .group
    
    ; Restores registers
    mov     si,         WORD @XEOS.16.proc.var.1
    mov     bx,         WORD @XEOS.16.proc.var.2
    
    ;---------------------------------------------------------------------------
    ; ASCII representation
    ;---------------------------------------------------------------------------
    .ascii:
        
        ; We are going to print 12 characters
        mov     cx,         12
        
        .char:
            
            ; Saves registers
            push    cx
            push    bx
            push    si
            push    ds
            
            ; Gets the byte from the memory location
            mov     ax,         si
            mov     ds,         si
            xor     ax,         ax
            mov     si,         ax
            add     si,         bx
            mov     al,         BYTE [ si ]
            
            ; Restores registers
            pop     ds
            pop     si
            
            ; Saves registers
            push    ax
            push    dx
            
            ; Checks if the character is printable
            mov     dx,         ax
            call    XEOS.16.string.isPrintable
            cmp     ax,         1
            jne     .notPrintable
            
            .printable:
                
                ; Restores registers
                pop     dx
                pop     ax
                
                ; Prints character
                mov                         BYTE [ $XEOS.16.debug.char ],  al
                @XEOS.16.debug.print.color  $XEOS.16.debug.char, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
                
                jmp     .nextChar
                
            .notPrintable:
                
                ; Restores registers
                pop     dx
                pop     ax
                
                ; Prints a gray pattern
                mov                         BYTE [ $XEOS.16.debug.char ],  0xB1
                @XEOS.16.debug.print.color  $XEOS.16.debug.char, @XEOS.16.video.color.gray.light, @XEOS.16.video.color.black
                
            .nextChar:
                
                ; Restores registers
                pop     bx
                pop     cx
                
                ; Prints next character 
                inc     bx
                loop    .char
        
        @XEOS.16.debug.print    $XEOS.16.debug.space
        @XEOS.16.debug.print    $XEOS.16.debug.pipe.start
    
    @XEOS.16.proc.end
    
    ret

;-------------------------------------------------------------------------------
; Prints text in color
; 
; Input registers:
;       
;       - SI:       The text to print
;       - BL:       The BIOS color
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.debug.print.color:
    
    @XEOS.16.proc.start 0
    
    ; Saves registers
    push    si
    
    ; Resets CS
    xor     cx,         cx
    
    ; Process a byte from the string
    .repeat:
        
        ; Gets a byte from the string placed in SI (will be placed in AL)
        lodsb
        
        ; Checks for the end of the string (ASCII 0)
        cmp     al,         @ASCII.NUL
        
        ; End of the string detected
        je      .done
        
        ; Increments CX (string length)
        inc     cx
        
        ; Process the next byte from the string
        jmp     .repeat
    
    ; End of the string
    .done:
        
        ; Sets the color attributes
        mov     ah,         0x09
        mov     al,         32
        mov     bh,         0
        @XEOS.16.int.video
        
        ; Restores registers
        pop     si
        
        ; Prints the string
        call XEOS.16.video.print
    
    @XEOS.16.proc.end
    
    ret
    
%endif
