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
myID byte "107502558"	         ;組長的學號
size_ID = lengthof myID2         ;size_ID表示myID的長度
myID2 byte "107502573"	     ;組員的學號
result byte 9 DUP(?)  
.code
main PROC
	mov eax, OFFSET myID
	mov ecx, size_ID
	mov edi, OFFSET myID2
	mov esi, OFFSET result
L1:	
	mov bl,[eax]
	mov	dl,[edi]
	cmp bl,dl
	je A
	ja B
	mov bl,'C'
	mov [esi],bl
	jmp L2
A:	
	mov bl,'A'
	mov [esi],bl
	jmp L2
B:	
	mov bl,'B'
	mov [esi],bl

L2:	
	inc esi
	inc edi
	inc eax
	loop L1
	exit
main ENDP
END main
