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
	ChStrs BYTE "********"
		   BYTE "*      *"
		   BYTE "*      *"
		   BYTE "********"
		   BYTE "********"
		   BYTE "*      *"
		   BYTE "*      *"
		   BYTE "********"
	
	temp   BYTE "        "
.code
change PROC uses ecx edi
	mov ecx,8
L:
	mov bl,[esi]
	mov	dl,[edi]
	cmp bl,dl
	jnz NZ
	mov al,'0'
	call WriteChar
	jmp L2
NZ:	mov al,'1'
	call WriteChar 
L2:	
	inc esi
	inc edi
	loop L
	
	RET
change ENDP

main PROC
	MOV ECX,8
	mov esi, OFFSET ChStrs
	mov edi, offset temp
L1: 
	CALL change
	call Crlf
	LOOP L1
	
call WaitMsg
main ENDP
end main