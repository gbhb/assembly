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
size_ID = ($ - offset myID)		         ;size_ID表示myID的長度
myID2 byte "107502573"	     ;組員的學號
size_ID2 = lengthof myID2    ;size_ID2表示myID2的長度

.code
Convert PROC USES eax;Convert會改變myID的內容0-A  1-B  以此類推
	L1:
		mov al, [esi]
		add al,17
		mov [esi],al
		inc esi 
		loop L1
	ret
Convert ENDP

Convert2 PROC USES eax		;Convert2功能和Convert一樣
L1:
		mov al, [esi]
		add al,17
		mov [esi],al
		inc esi 
		loop L1
	ret
Convert2 ENDP

main PROC
	mov eax, 9999h         ;eax結果的值不能被改變
	mov ebx, 9999h         ;ebx結果的值不能被改變
	mov edx, 9999h         ;edx結果的值不能被改變
	mov esi, OFFSET myID	
	mov ecx, size_ID
	call Convert
	mov esi, OFFSET myID2
	mov ecx, size_ID2
	call Convert2
	
	exit
main ENDP
END main
