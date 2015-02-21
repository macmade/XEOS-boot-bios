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
; @file            xeos.io.fat12.mbr.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; MBR - Master Boot Record
; 
; This section is used to create a valid floppy disk MBR (FAT-12)
;-------------------------------------------------------------------------------

%ifndef __XEOS_IO_FAT12_MBR_INC_S__
%define __XEOS_IO_FAT12_MBR_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------

%include "xeos.constants.inc.s"        ; General constants

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Type definitions
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; MBR Structure:
; 
; 0x03 (8) - OEM name
;       This value determines in which system disk was formatted
; 
; 0x0B (2) - Bytes per sector
; 
; 0x0D (1) - Sectors per cluster
; 
; 0x0E (2) - Reserved sector count
;       The number of sectors before the first FAT in the file system image.
;       Should be 1 for FAT12/FAT16. Usually 32 for FAT32.
; 
; 0x10 (1) - Number of file allocation tables
; Almost always 2
; 
; 0x11 (2) - Maximum number of root directory entries
;       Only used on FAT12 and FAT16, where the root directory is handled
;       specially.
;       Should be 0 for FAT32. This value should always be such that the root
;       directory ends on a sector boundary (i.e. such that its size becomes a
;       multiple of the sector size).
;       224 is typical for floppy disks
; 
; 0x13 (2) - Total sectors
; 
; 0x15 (1) - Media descriptor
;       Possible values are:
; 
;           - 0xF0	3.5" Double Sided, 80 tracks per side, 18 or 36 sectors per
;                   track (1.44MB or 2.88MB)
;                   5.25" Double Sided, 15 sectors per track (1.2MB)
;           - 0xF8	Fixed disk (i.e. Hard disk)
;           - 0xF9	3.5" Double sided, 80 tracks per side, 9 sectors per track
;                   (720K)
;                   5.25" Double sided, 40 tracks per side, 15 sectors per track
;                   (1.2MB)
;           - 0xFA	5.25" Single sided, 80 tracks per side, 8 sectors per track
;                   (320K)
;           - 0xFB	3.5" Double sided, 80 tracks per side, 8 sectors per track
;                   (640K)
;           - 0xFC	5.25" Single sided, 40 tracks per side, 9 sectors per track
;                   (180K)
;           - 0xFD	5.25" Double sided, 40 tracks per side, 9 sectors per track
;                   (360K)
;           - 0xFE	5.25" Single sided, 40 tracks per side, 8 sectors per track
;                   (160K)
;           - 0xFF	5.25" Double sided, 40 tracks per side, 8 sectors per track
;                   (320K)
; 
; 0x16 (2) - Sectors per File Allocation Table for FAT12/FAT16
; 
; 0x18 (2) - Sectors per track
; 
; 0x1A (2) - Number of heads per cylinder
; 
; 0x1C (4) -  Hidden sectors
; 
; 0x20 (4) - Number of LBA sectors
; 
; 0x24 (1) - Physical drive number
; 
; 0x25 (1) - Reserved ("current head")
;       In Windows NT bit 0 is a dirty flag to request chkdsk at boot time
;       Bit 1 requests surface scan too.
; 
; 0x26 (1) - Extended boot signature
; 
; 0x27 (4) - Volume ID (serial number)
; 
; 0x2B (11) - Volume label
; 
; 0x36 - (8) - FAT file system type
;       This is not meant to be used to determine drive type, however,
;       some utilities
;       use it in this way.
;-------------------------------------------------------------------------------
struc XEOS.io.fat12.mbr_t

    .oemName:               resb    8
    .bytesPerSector:        resw    1
    .sectorsPerCluster:     resb    1
    .reservedSectors:       resw    1
    .numberOfFATs:          resb    1
    .maxRootDirEntries:     resw    1
    .totalSectors:          resw    1
    .mediaDescriptor:       resb    1
    .sectorsPerFAT:         resw    1
    .sectorsPerTrack:       resw    1
    .headsPerCylinder:      resw    1
    .hiddenSectors:         resd    1
    .lbaSectors:            resd    1
    .driveNumber:           resb    1
    .reserved:              resb    1
    .bootSignature:         resb    1
    .volumeID:              resd    1
    .volumeLabel:           resb    11
    .fileSystem:            resb    8

endstruc

;-------------------------------------------------------------------------------
; Variables definitions
;-------------------------------------------------------------------------------

; XEOS MBR
$XEOS.io.fat12.mbr:
    
    istruc XEOS.io.fat12.mbr_t

        db @XEOS.io.fat12.mbr.oemName
        dw @XEOS.io.fat12.mbr.bytesPerSector
        db @XEOS.io.fat12.mbr.sectorsPerCluster
        dw @XEOS.io.fat12.mbr.reservedSectors
        db @XEOS.io.fat12.mbr.numberOfFATs
        dw @XEOS.io.fat12.mbr.maxRootDirEntries
        dw @XEOS.io.fat12.mbr.totalSectors
        db @XEOS.io.fat12.mbr.mediaDescriptor
        dw @XEOS.io.fat12.mbr.sectorsPerFAT
        dw @XEOS.io.fat12.mbr.sectorsPerTrack
        dw @XEOS.io.fat12.mbr.headsPerCylinder
        dd @XEOS.io.fat12.mbr.hiddenSectors
        dd @XEOS.io.fat12.mbr.lbaSectors
        db @XEOS.io.fat12.mbr.driveNumber
        db @XEOS.io.fat12.mbr.reserved
        db @XEOS.io.fat12.mbr.bootSignature
        dd @XEOS.io.fat12.mbr.volumeID
        db @XEOS.io.fat12.mbr.volumeLabel
        db @XEOS.io.fat12.mbr.fileSystem

    iend

%endif
