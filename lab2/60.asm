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
	Val1	SBYTE	03h
	Val2	SBYTE	02h
	Val3	SBYTE	8fh
	Rval	SDWORD	?

.code
main PROC		
	mov al,Val1	
	add al,Val2
	movsx edx,al
	mov eax,edx
	sal edx,4
	sal eax,1
	sub edx,eax
	movsx ebx,Val3
	sub ebx,edx
	neg ebx
	mov Rval,ebx	
	
	
	exit
main ENDP
END main