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
; @file            xeos.crt.controller.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Defines, macros and procedures for the CRT microcontroller
;-------------------------------------------------------------------------------

%ifndef __XEOS_CRT_CONTROLLER_INC_S__
%define __XEOS_CRT_CONTROLLER_INC_S__

;-------------------------------------------------------------------------------
; Definitions & Macros
;-------------------------------------------------------------------------------

; Location of the video memory
%define @XEOS.crt.controller.registers.data                 0x03D4
%define @XEOS.crt.controller.registers.index                0x03D5

; Indices for the index register
%define @XEOS.crt.controller.horizontalTotal                0x0000
%define @XEOS.crt.controller.endHorizontalDisplay           0x0001
%define @XEOS.crt.controller.startHorizontalBlanking        0x0002
%define @XEOS.crt.controller.endHorizontalBlanking          0x0003
%define @XEOS.crt.controller.startHorizontalRetrace         0x0004
%define @XEOS.crt.controller.endHorizontalRetrace           0x0005
%define @XEOS.crt.controller.verticalTotal                  0x0006
%define @XEOS.crt.controller.overflow                       0x0007
%define @XEOS.crt.controller.presetRowScan                  0x0008
%define @XEOS.crt.controller.maximumScanLine                0x0009
%define @XEOS.crt.controller.cursorStart                    0x000A
%define @XEOS.crt.controller.cursorEnd                      0x000B
%define @XEOS.crt.controller.startAddressHigh               0x000C
%define @XEOS.crt.controller.startAddressLow                0x000D
%define @XEOS.crt.controller.cursorLocationHigh             0x000E
%define @XEOS.crt.controller.cursorLocationLow              0x000F
%define @XEOS.crt.controller.verticalRetraceStart           0x0010
%define @XEOS.crt.controller.verticalRetraceEnd             0x0011
%define @XEOS.crt.controller.verticalDisplayEnd             0x0012
%define @XEOS.crt.controller.offset                         0x0013
%define @XEOS.crt.controller.underlineLocation              0x0014
%define @XEOS.crt.controller.startVerticalBlanking          0x0015
%define @XEOS.crt.controller.endVerticalBlanking            0x0016
%define @XEOS.crt.controller.crtcModeControl                0x0017
%define @XEOS.crt.controller.lineCompare                    0x0018

%endif
