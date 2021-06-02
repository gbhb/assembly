INCLUDE Irvine32.inc


main   EQU start@0

.data
 array1 sdword 2,  4, -3, -9, 7, 1, 8
 array2 sdword 2, -3,  6,  0, 7, 8, 5
 count  sdword 0
 string byte " matches",0
.code
main proc

    mov ecx,lengthof array1    
    mov esi,offset array1   
	mov edi,offset array2    
L:	
    mov eax,[esi]
    mov ebx,[edi]
    cmp eax,ebx
    jnz L1
    add count,1
L1: 
    add esi,4
    add edi,4
    loop L
    mov eax,count
    call WriteInt
    mov edx,offset string
    call WriteString
    call Crlf
    call WaitMsg
    exit
main ENDP
END main
