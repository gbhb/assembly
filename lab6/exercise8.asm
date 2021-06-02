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

divide macro dividend, divisor, quotient, remainder
mov dx,0
mov ax,dividend
mov bx,divisor
div bx
mov quotient,ax
mov remainder,dx
endm

.data
dividend WORD 2558;組長的學號末四碼(十進位)
divisor WORD 100
quotient WORD 1 DUP(?)
remainder WORD 1 DUP(?)

.code
main PROC
	movsx eax, dividend
	call WriteDec
	call Crlf
	
	divide dividend, divisor, quotient, remainder
	
	movsx eax, quotient
	call WriteDec
	call Crlf
	
	movsx eax, remainder
	call WriteDec
	call Crlf
	call WaitMsg
main ENDP
END main