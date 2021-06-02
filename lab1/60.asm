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
	
.code
main PROC		
	
	mov al, 111010b;組長學號末兩碼的二進位
	mov ah, 73d;組員學號末兩碼的十進位
	mov ax, 2558h;任一人學號末四碼
	mov dx, 0eeeah;讓dx顯示eeea
	sub dx, ax;把dx的值減去ax的值

	exit
main ENDP
END main