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
; @file            xeos.constants.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants
;-------------------------------------------------------------------------------

%ifndef __XEOS_CONSTANTS_INC_S__
%define __XEOS_CONSTANTS_INC_S__

;-------------------------------------------------------------------------------
; Definitions & Macros
;-------------------------------------------------------------------------------

; Standard PC boot signature
%define @XEOS.io.boot.signature                 0xAA55

; Master boot record values
%define @XEOS.io.fat12.mbr.oemName              "XEOS",  0x20, 0x20, 0x20, 0x20
%define @XEOS.io.fat12.mbr.volumeLabel          "XEOS",  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
%define @XEOS.io.fat12.mbr.fileSystem           "FAT12", 0x20, 0x20, 0x20
%define @XEOS.io.fat12.mbr.bytesPerSector       512
%define @XEOS.io.fat12.mbr.sectorsPerCluster    1
%define @XEOS.io.fat12.mbr.reservedSectors      1
%define @XEOS.io.fat12.mbr.numberOfFATs         2
%define @XEOS.io.fat12.mbr.maxRootDirEntries    224
%define @XEOS.io.fat12.mbr.totalSectors         2880
%define @XEOS.io.fat12.mbr.mediaDescriptor      0xF0
%define @XEOS.io.fat12.mbr.sectorsPerFAT        9
%define @XEOS.io.fat12.mbr.sectorsPerTrack      18
%define @XEOS.io.fat12.mbr.headsPerCylinder     2
%define @XEOS.io.fat12.mbr.hiddenSectors        0
%define @XEOS.io.fat12.mbr.lbaSectors           0
%define @XEOS.io.fat12.mbr.driveNumber          0
%define @XEOS.io.fat12.mbr.reserved             0
%define @XEOS.io.fat12.mbr.bootSignature        41
%define @XEOS.io.fat12.mbr.volumeID             0

%endif
