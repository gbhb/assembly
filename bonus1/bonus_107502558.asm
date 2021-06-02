INCLUDE Irvine32.inc


main   EQU start@0


Str_nextword PROTO,
	pString:PTR BYTE,
	delimiter:BYTE ; pointer to string delimiter:BYTE ; delimiter to find
.data
testStr BYTE "ABC\DE\FGHIJK\LM",0
.code
main PROC
	call Clrscr
	mov edx, OFFSET testStr; display string
	call WriteString
	call Crlf; Loop through the string, replace each delimiter, and; display the remaining string.
	mov esi, OFFSET testStr
L1:	INVOKE Str_nextword, esi, "\" ; look for delimiter
	jnz Exit_prog;quit if not found
	mov esi,eax; point to next substring
	mov edx,eax
	call WriteString; display remainder of string
	call Crlf
	jmp L1
Exit_prog:
	call WaitMsg
	exit

main ENDP
Str_nextword PROC,
    pString:PTR BYTE,        ; pointer to string
    delimiter:BYTE
    push esi
    mov  al,delimiter
    mov  esi,pString
    cld                      ; clear Direction flag (forward)
    L1:
    lodsb                    ; AL = [esi], inc(esi)
    cmp al,0                 ; end ofstring?
    je  L3                   ; yes:exit with ZF=0
    cmp al,delimiter         ; delimiter found?
    jne L1                   ; no: repeat loop
    L2:
    mov BYTE PTR [esi-1],0   ; yes: insert null byte
    mov eax,esi              ; point EAX to next character
    jmp Exit_proc            ; exit with ZF=1
    L3:or al,1               ; clearZero flag
    Exit_proc:
    pop esi
    ret
    Str_nextword ENDP	
end main