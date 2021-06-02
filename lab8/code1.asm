INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword ;宣告 proto type
DifferentInputs proto, v1:dword, v2:dword, v3:dword ;宣告 proto type
main     EQU start@0
.data
.code
main proc
    
    invoke DifferentInputs,2,2,3
    invoke DifferentInputs,2,3,2
    invoke DifferentInputs,3,5,5
    invoke DifferentInputs,2,2,2
    invoke DifferentInputs,104522064,107502558,107502573 ; 填上組員學號
 
    call WaitMsg
    invoke ExitProcess,0
main endp

DifferentInputs proc,
    v1:dword, v2:dword, v3:dword
    mov eax,v1     ; 取出 v1
    cmp v2,eax      ; 與v2比較       
    je  Label_Equal ; 若相等則跳到Label_Equal,回傳0
    cmp   v3,eax         ; 與v3做比較
    je   Label_Equal ; 若相等則跳到Label_Equal,回傳0
    mov eax,v2      ; 取出 v2
    cmp   v3, eax        ; 與v3做比較
    je   Label_Equal ; 若相等則跳到Label_Equal,回傳0
    mov   eax,1         ; 回傳1
    jmp   exit_label  ; return true

Label_Equal: 
    mov  eax,0      ; return false
 
exit_label:
    call DumpRegs
    ret
DifferentInputs endp

end main