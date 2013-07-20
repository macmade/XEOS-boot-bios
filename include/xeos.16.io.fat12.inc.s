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
; @file            xeos.16.io.fat12.inc.s
; @author          Jean-David Gadina
; @copyright       (c) 2010-2012, Jean-David Gadina - www.xs-labs.com
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; IO procedures
; 
; Those procedures and macros are intended to be used only in 16 bits real mode.
;-------------------------------------------------------------------------------
%ifndef __XEOS_16_IO_FAT12_INC_S__
%define __XEOS_16_IO_FAT12_INC_S__

;-------------------------------------------------------------------------------
; Includes
;-------------------------------------------------------------------------------
%include "xeos.constants.inc.s"       ; General constants
%include "xeos.macros.inc.s"          ; General macros
%include "xeos.16.int.inc.s"          ; BIOS interrupts
%include "xeos.ascii.inc.s"           ; ASCII table

; We are in 16 bits mode
BITS    16

;-------------------------------------------------------------------------------
; Procedures
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Loads the FAT-12 root directory into memory
; 
; Description:
;       
;       The structure of the FAT-12 root directory is:
;           
;           - 0x00 - 0x07:  File name
;           - 0x08 - 0x0A:  File extension
;           - 0x0B - 0x0B:  File attributes
;           - 0x0C - 0x0C:  Reserved
;           - 0x0D - 0x0D:  Create time - fine resolution
;           - 0x0E - 0x0F:  Create time - hours, minutes and seconds
;           - 0x10 - 0x11:  Create date
;           - 0x12 - 0x13:  Last access date
;           - 0x14 - 0x15:  EA-Index (used by OS/2 and NT)
;           - 0x16 - 0x17:  Last modified time
;           - 0x18 - 0x19:  Last modified date
;           - 0x1A - 0x1B:  First cluster of the file
;           - 0x1C - 0x20:  File size in bytes
;
;       After calling this procedure, the start of the root directory can be
;       accessed in $XEOS.16.io.fat12.rootDirectoryStart (WORD).
; 
; Input registers:
;       
;       - DI:       The offset at which the root directory will be loaded
;                   (ES:BX)
; 
; Return registers:
;       
;       - AX:       The result code (0 if no error)
;       - DX:       The starting sector for the data
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.io.fat12.loadRootDirectory:    
    
    ; Saves registers
    pusha
    
    ; Resets registers
    xor     cx,         cx
    xor     dx,         dx
    
    ; An entry of the root directory is 32 bits
    mov     ax,         32
    
    ; Saves a few bytes of code if we can access the MBR variables directly
    %ifndef __XEOS_IO_FAT12_MBR_INC_S__
        
        ; Multiplies by the maximum number of entries to get the root directory size
        mov     bx,         @XEOS.io.fat12.mbr.maxRootDirEntries
        mul     bx
        
    %else
        
        ; Multiplies by the maximum number of entries to get the root directory size
        mul     WORD [ $XEOS.io.fat12.mbr + XEOS.io.fat12.mbr_t.maxRootDirEntries ]
        
    %endif
    
    ; Saves a few bytes of code if we can access the MBR variables directly
    %ifndef __XEOS_IO_FAT12_MBR_INC_S__
        
        ; Number of sectors used by the root directory
        mov     bx,         @XEOS.io.fat12.mbr.bytesPerSector
        div     bx
        
    %else
        
        ; Number of sectors used by the root directory
        div     WORD [ $XEOS.io.fat12.mbr + XEOS.io.fat12.mbr_t.bytesPerSector ]
        
    %endif
    
    ; Stores the size of the root directory in CX
    xchg    ax,         cx
    
    ; Number of file allocation tables
    mov     al,         @XEOS.io.fat12.mbr.numberOfFATs
    
    ; Saves a few bytes of code if we can access the MBR variables directly
    %ifndef __XEOS_IO_FAT12_MBR_INC_S__
        
        ; Multiplies by the number of sectors that a FAT uses
        mov     bx,         @XEOS.io.fat12.mbr.sectorsPerFAT
        mul     bx
        
    %else
        
        ; Multiplies by the maximum number of entries to get the root directory size
        mul     WORD [ $XEOS.io.fat12.mbr + XEOS.io.fat12.mbr_t.sectorsPerFAT ]
        
    %endif
    
    ; Adds the number of reserved sectors, so we now have the starting
    ; sector of the root directory
    add     ax,         @XEOS.io.fat12.mbr.reservedSectors
    
    ; Now we can guess and store the starting sector for the data
    mov     WORD [ $XEOS.16.io.fat12._dataSector ], ax
    add     WORD [ $XEOS.16.io.fat12._dataSector ], cx
    
    ; Read sectors at ES:DI
    mov     bx,         di
    call    XEOS.16.io.fat12.readSectors
    
    ; Checks for an error code
    cmp     ax,         0
    je      .success
    
    .error
        
        ; Restores registers
        popa
        
        ; Error - Stores result code in AX
        mov     ax,         1
        
        ret
        
    .success
        
        ; Restores registers
        popa
        
        ; Success - Stores result code in AX
        xor     ax,         ax
        
        ; Stores data sector in DX
        mov     dx,         WORD [ $XEOS.16.io.fat12._dataSector ]
        
        ret

;-------------------------------------------------------------------------------
; Finds a file name in the FAT-12 root directory
; 
; Note that the root directory must be loaded in memory before calling this
; procedure (see XEOS.16.io.fat12.loadRootDirectory).
; 
; Input registers:
; 
;       - DI:       The location of the root directory in memory (ES:DI)
;       - SI:       The address of the filename to find
; 
; Return registers:
;       
;       - AX:       The result code (0 if no error)
;       - DI:       The first cluster of the file
; 
; Killed registers:
;       
;       - CX
;-------------------------------------------------------------------------------
XEOS.16.io.fat12.findFile:
    
    .start
        
        ; Process each entry of the FAT-12 root directory
        mov     cx,         @XEOS.io.fat12.mbr.maxRootDirEntries
    
    .loop:
        
        ; Saves registers
        pusha
        
        ; A FAT-12 filename is eleven characters long
        mov     cx,         11
        
        ; Compare the strings
        rep     cmpsb
        
        ; Restores registers
        popa
        
        ; Checks for a match
        je      .success
        
        ; Process next entry (32 bytes)
        add     di,         32
        loop    .loop
        
    .failure
        
        ; Error - Stores result code in AX
        mov     ax,         1
        
        ret
        
    .success
        
        ; Success - Stores result code in AX
        xor     ax,         ax
        
        ; Start cluster from the root directory entry (byte 26)
        add     di,         26
        
        ret

;-------------------------------------------------------------------------------
; Loads a file from a FAT-12 drive
; 
; Input registers:
; 
;       - AX:       The segment where the file will be loaded (AX:00)
;       - BX:       The offset of where to load the FAT (ES:BX)
;       - CX:       The location of the first data sector
;       - DI:       The first cluster of the file
; 
; Return registers:
;       
;       - AX:       The result code (0 if no error)
;       - CX:       The number of sectors read
; 
; Killed registers:
;       
;       - AX
;       - BX
;       - DX
;-------------------------------------------------------------------------------
XEOS.16.io.fat12.loadFile:
    
    .loadFAT:
        
        ; Saves register
        push    es
        
        ; Saves the location of the first data cluster
        mov     WORD [ $XEOS.16.io.fat12._fatOffset ],      bx
        
        
        ; Saves the location of the first data cluster
        mov     cx,         WORD [ $XEOS.16.io.fat12._dataSector ]
        
        ; Saves registers
        push    ax
        push    bx
        
        ; Saves the start cluster of the file
        mov     dx,                                         WORD [ di ]
        mov     WORD [ $XEOS.16.io.fat12._currentCluster ], dx
        
        ; Resets AX
        xor     ax,         ax
        
        ; Number of FATs
        mov     al,         @XEOS.io.fat12.mbr.numberOfFATs
        
        ; Saves a few bytes of code if we can access the MBR variables directly
        %ifndef __XEOS_IO_FAT12_MBR_INC_S__
            
            ; Multiplies by the number of sectors per FAT
            mov     bx,         @XEOS.io.fat12.mbr.sectorsPerFAT
            mul     bx
            
        %else
            
            ; Multiplies by the number of sectors per FAT
            mul     WORD [ $XEOS.io.fat12.mbr + XEOS.io.fat12.mbr_t.sectorsPerFAT ]
            
        %endif
        
        ; Stores the FAT size in CX
        mov     cx,         ax
        
        ; Starting sector (bypass the reserved sectors)
        mov     ax,         @XEOS.io.fat12.mbr.reservedSectors
        
        ; Loads the FAT at ES:BX
        pop     bx
        call    XEOS.16.io.fat12.readSectors
        
        ; Checks for an error code
        cmp     ax,         0
        je      .fatLoaded
        
        ; Restores registers
        pop     es
        
        ret
    
    .fatLoaded
        
        ; Segment of the file
        pop     es
        xor     bx,         bx
        
        ; Resets CX (sector count)
        xor     cx,         cx
        
        ; Saves registers
        push    cx
        push    bx
        
    .loadFile:
        
        ; Current cluster
        mov     ax,         WORD [ $XEOS.16.io.fat12._currentCluster ]
        
        ; Data sector location
        mov     bx,         WORD [ $XEOS.16.io.fat12._dataSector ]
        
        ; Converts cluster to LBA
        call    XEOS.16.io.fat12._clusterToLBA
        
        ; Read buffer
        pop     bx
        
        ; Resets CX
        xor     cx,         cx
        
        ; Number of sectors to read
        mov     cl, @XEOS.io.fat12.mbr.sectorsPerCluster
        
        ; Read sectors
        call    XEOS.16.io.fat12.readSectors
        
        ; Checks if we are inside the first stage bootloader or not
        %ifndef __XEOS_IO_FAT12_MBR_INC_S__
            
            ; Saves registers
            pusha
            
            ; Adjusts ES, as the buffer location is limited to 65'535 bytes,
            ; including the original offset, as it uses a 16 bits register.
            ; Note: this is done only for the second stage bootloader, as the
            ; first one has a 512 bytes of code limit.
            ; This shouldn't be a problem, unless the second stage bootloader
            ; is greater than 65'535 bytes - the offset at which it is loaded.
            mov     ax,         bx
            mov     bx,         0x10
            div     bx
            mov     cx,         es
            add     cx,         ax
            mov     es,         cx
            
            ; Restores registers
            popa
            
            ; New offset
            xor     bx,         bx
        
        %endif
        
        ; Checks for an error code
        cmp     ax,         0
        je      .success
        
        ; Restores registers
        pop     es
        
        ret
        
    .success:
        
        ; Restores registers
        pop     cx
        
        ; Number of sectors read
        add     cx,         @XEOS.io.fat12.mbr.sectorsPerCluster
        
        ; Restores registers
        push    cx
        push    bx
        
        ; Stores current cluster
        mov     ax,         WORD [ $XEOS.16.io.fat12._currentCluster ]
        mov     cx,         ax
        mov     dx,         ax
        
        ; Divides by two (so we can find if it's even or odd)
        shr     dx,         1
        add     cx,         dx
        
        ; Location of FAT in memory
        mov     bx,         WORD [ $XEOS.16.io.fat12._fatOffset ]
        
        ; Index in FAT
        add     bx,         cx
        
        ; Get two bytes from the FAT
        mov     dx,       WORD [ bx ]
          
        ; Checks if we are reading an odd or even cluster
        test    ax,         1
        jnz     .odd
          
        .even:
            
            ; Keep low twelve bytes
            and     dx,         0000111111111111b
            jmp     .end
            
        .odd:
            
            ; Keep high twelve bytes
            shr     dx,         4
              
        .end:
            
            ; Stores the start of the new cluster
            mov     WORD [ $XEOS.16.io.fat12._currentCluster ],    dx
            
            ; Test for EOF
            cmp     dx,         0x0FF0
            
            ; Continues reading
            jb      .loadFile
        
    ; Success - Stores result code in AX
    xor     ax,             ax
    
    ; Restores registers
    pop bx
    pop cx
    pop es
    
    ret
        
;-------------------------------------------------------------------------------
; Reads sectors from a drive
; 
; Input registers:
;       
;       - AX:       The starting sector
;       - BX:       The read buffer location (ES:BX)
;       - CX:       The number of sectors to read
; 
; Return registers:
;       
;       - AX:       The result code (0 if no error)
;       - BX:       The read buffer end location (ES:BX), so multiple calls can
;                   be chained whithout adjusting the read buffer
; 
; Killed registers:
;       
;       - CX
;       - DX
;-------------------------------------------------------------------------------
XEOS.16.io.fat12.readSectors:
    
    ; Saves registers
    push di
    
    .start:
        
        ; Allows five read attempts before returning an error, as we may need
        ; to reset the floppy disk before successfully reading
        mov     di,         5
        
        ; Checks if we are inside the first stage bootloader or not
        %ifndef __XEOS_IO_FAT12_MBR_INC_S__
            
            ; Prints the loading symbol
            ; External procedure, as we are using short jumps here, so
            ; the amount of code is limited
            call    XEOS.16.io.fat12._printLoadSymbol
            
        %endif
        
    .loop
        
        ; Saves registers
        pusha
        
        ; Converts the logical block address to cluster, head and cylinder
        ; (needed for int 0x13)
        call    XEOS.16.io.fat12._lbaToCHS
        
        ; AX argument for int 0x13
        ; AL = 1
        ; AH = 2
        ; AX = 0000 0010 0000 0001 = 0x201
        mov     ax,         0x201
        
        ; Checks if we are inside the first stage bootloader or not
        %ifdef __XEOS_IO_FAT12_MBR_INC_S__
            
            ; Cylinder and sector arguments for int 0x13
            ; Wrong formula, but this should work for the first stage bootloader
            mov     ch,         BYTE [ $XEOS.16.io.fat12._cylinder ]
            mov     cl,         BYTE [ $XEOS.16.io.fat12._sector ]
        
        %else
            
            ; Cylinder and sector arguments for int 0x13
            ; CX = ( ( cylinder and 255 ) shl 8 ) or ( ( cylinder and 768 ) shr 2 ) or sector;
            xor     cx,         cx
            mov     cl,         BYTE [ $XEOS.16.io.fat12._cylinder ]
            and     cx,         255
            shl     cx,         8
            xor     dx,         dx
            mov     dl,         BYTE [ $XEOS.16.io.fat12._cylinder ]
            and     dx,         768
            shr     dx,         2
            or      cx,         dx
            xor     dx,         dx
            mov     dl,         BYTE [ $XEOS.16.io.fat12._sector ]
            or      cx,         dx
            
        %endif
        
        ; Track, sector and head parameters
        mov     dh,         BYTE [ $XEOS.16.io.fat12._head ]
        
        ; Drive number parameter
        mov     dl,         @XEOS.io.fat12.mbr.driveNumber
        
        ; Calls the BIOS LLDS
        @XEOS.16.int.llds
        
        ; Checks the return value
        jnc     .success
        
    .error:
    
        ; Resets the floppy disk
        xor     ax,         ax
        @XEOS.16.int.llds
        
        ; Restores registers
        popa
        
        ; Decrements the error counter
        dec     di

        ; Attempts to read again
        jnz     .loop
        
        ; Restores registers
        pop     di
        
        ; Error - Stores result code in AX
        mov     ax,         1
        
        ret
        
    .success
        
        ; Restores registers
        popa
        
        ; Memory area in which the next sector will be read
        add     bx,         @XEOS.io.fat12.mbr.bytesPerSector
        
        ; Reads the next sector
        inc     ax
        loop    .start
    
    .end:
    
        ; Restores registers
        pop     di
        
        ; Success - Stores result code in AX
        xor     eax,        eax
        
        ret

;-------------------------------------------------------------------------------
; Converts a cluster number to LBA (Logical Block Addressing)
; 
; Description:
;   
;       Formula is: LBA = (cluster - 2 ) * sectors per cluster
; 
; Input registers:
;       
;       - AX:       The cluster number to convert
;       - BX:       The start of the FAT-12 root directory
; 
; Return registers:
;       
;       - AX:       The LBA value
; 
; Killed registers:
;       
;       None
;-------------------------------------------------------------------------------
XEOS.16.io.fat12._clusterToLBA:
    
    ; Saves registers
    push cx
    
    ; Substracts 2 to the cluster number
    sub     ax,         2
    
    ; Saves a few bytes of code if we can access the MBR variables directly
    %ifndef __XEOS_IO_FAT12_MBR_INC_S__
        
        ; Multiplies by the number of sectors per cluster
        mov     cx,         @XEOS.io.fat12.mbr.sectorsPerCluster
        mul     cx
        
    %else
        
        ; Multiplies by the number of sectors per cluster
        mul     BYTE [ $XEOS.io.fat12.mbr + XEOS.io.fat12.mbr_t.sectorsPerCluster ]
        
    %endif
    
    ; Adds result value to the start of the FAT-12 root directory
    add     ax,         bx
    
    ; Restores registers
    pop     cx
    
    ret

;-------------------------------------------------------------------------------
; Converts LBA (Logical Block Addressing) to CHS (Cylinder Head Sector)
; 
; Description:
; 
;       Sector      = ( logical sector / sectors per track ) + 1
;       Head        = ( logical sector / sectors per track ) % number of heads
;       Cylinder    =   logical sector / ( sectors per track * number of heads )
;       
;       After calling this procedure, converted values can be accessed in:
;           
;           - $XEOS.16.io.fat12._cylinder
;           - $XEOS.16.io.fat12._head
;           - $XEOS.16.io.fat12._sector
; 
; Input registers:
;       
;       - AX:       The LBA address to convert
; 
; Return registers:
;       
;       None
; 
; Killed registers:
;       
;       - AX
;       - CX
;       - DX
;-------------------------------------------------------------------------------
XEOS.16.io.fat12._lbaToCHS:
    
    ; Clears DX
    xor     dx,         dx
    
    ; Saves a few bytes of code if we can access the MBR variables directly
    %ifndef __XEOS_IO_FAT12_MBR_INC_S__
        
        ; Divides by the number of sectors per track
        mov     cx,         @XEOS.io.fat12.mbr.sectorsPerTrack
        div     cx
        
    %else
        
        ; Divides by the number of sectors per track
        div     WORD [ $XEOS.io.fat12.mbr + XEOS.io.fat12.mbr_t.sectorsPerTrack ]
        
    %endif
    
    ; Adds one
    inc     dl
    
    ; Stores the sector
    mov     BYTE [ $XEOS.16.io.fat12._sector ],    dl
    
    ; Clears DX
    xor     dx,         dx
    
    ; Saves a few bytes of code if we can access the MBR variables directly
    %ifndef __XEOS_IO_FAT12_MBR_INC_S__
        
        ; Mod by the number of heads
        mov     cx,         @XEOS.io.fat12.mbr.headsPerCylinder
        div     cx
        
    %else
        
        ; Divides by the number of sectors per track
        div     WORD [ $XEOS.io.fat12.mbr + XEOS.io.fat12.mbr_t.headsPerCylinder ]
        
    %endif
    
    ; Stores the head and cylinder
    mov     BYTE [ $XEOS.16.io.fat12._head ],       dl
    mov     BYTE [ $XEOS.16.io.fat12._cylinder ],   al
    
    ret


;-------------------------------------------------------------------------------
; Specific procedures for the second stage bootloader
;-------------------------------------------------------------------------------
%ifndef __XEOS_IO_FAT12_MBR_INC_S__

; Specific includes
%include "xeos.16.video.inc.s"

;-------------------------------------------------------------------------------
; Prints the loading symbol at the cursor position
; 
; Note that this procedure is not available when on the first stage bootloader,
; as the code size is limited.
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
XEOS.16.io.fat12._printLoadSymbol:
    
    @XEOS.16.proc.start 0
    
    ; We've got 4 different symbols, so divide the counter
    ; by 4 and checks the reminder
    mov     eax,        DWORD [ $XEOS.16.io.fat12._loadCount ]
    xor     edx,        edx
    mov     ebx,        0x04
    div     ebx
    cmp     edx,        0x00
    je      .char.1
    cmp     edx,        0x01
    je      .char.2
    cmp     edx,        0x02
    je      .char.3
    cmp     edx,        0x03
    je      .char.4
    
    .char.1:
        
        ; Prints '|'
        mov     al,         0x7C
        jmp     .print
        
    .char.2:
        
        ; Prints '/'
        mov     al,         0x2F
        jmp     .print
        
    .char.3:
        
        ; Prints '-'
        mov     al,         0x2D
        jmp     .print
        
    .char.4:
        
        ; Prints '\'
        mov     al,         0x5C
        
    .print:
        
        ; Outputs a single character (BIOS video services function)
        mov     ah,         0x0A
        
        ; Number of characters to print
        mov     cx,         1
        
        ; Calls the BIOS video services
        @XEOS.16.int.video
    
    ; Increments the counter
    mov eax,    DWORD [ $XEOS.16.io.fat12._loadCount ]
    inc eax
    mov DWORD [ $XEOS.16.io.fat12._loadCount ], eax
    
    @XEOS.16.proc.end
    
    ret

%endif

;-------------------------------------------------------------------------------
; Variables definition
;-------------------------------------------------------------------------------

$XEOS.16.io.fat12._dataSector           dw  0
$XEOS.16.io.fat12._cylinder             db  0
$XEOS.16.io.fat12._head                 db  0
$XEOS.16.io.fat12._sector               db  0
$XEOS.16.io.fat12._currentCluster       dw  0
$XEOS.16.io.fat12._fatOffset            dw  0

%ifndef __XEOS_IO_FAT12_MBR_INC_S__
    
    $XEOS.16.io.fat12._loadCount        dd  0
    
%endif

%endif
