TITLE Example of ASM              (helloword.ASM)

; This program locates the cursor and displays the
; system time. It uses two Win32 API structures.
; Last update: 6/30/2005

INCLUDE Irvine32.inc

; Redefine external symbols for convenience
; Redifinition is necessary for using stdcall in .model directive 
; using "start" is because for linking to WinDbg.  added by Huang
 
main          EQU start@0

;Comment @
;Definitions copied from SmallWin.inc:

.data
	MyID   DWORD ?
	Digit0 BYTE 2h
	Digit1 BYTE 5h
	Digit2 BYTE 5h
	Digit3 BYTE 8h

.code
main PROC		
	mov al, Digit0
	shl eax, 8
	mov al, Digit1
	shl eax, 8
	mov al, Digit2
	shl eax, 8
	mov al, Digit3
	mov MyID,eax
	
	
	
	
	exit
main ENDP
END main