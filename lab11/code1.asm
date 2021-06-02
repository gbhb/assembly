INCLUDE Irvine32.inc
main	EQU start@0
BoxWidth = 3
BoxHeight = 3
 
.data
boxTop    BYTE 0DAh, (BoxWidth - 2) DUP(0C4h),0BFh
boxBody   BYTE 0B3h, (BoxWidth - 2) DUP(' '),0B3h
boxBottom BYTE 0C0h, (BoxWidth - 2) DUP(0C4h),0D9h
 
outputHandle DWORD 0
bytesWritten DWORD 0
count DWORD 0
xyPosition COORD <10,5>
 
cellsWritten DWORD ?
attributes0 WORD BoxWidth DUP(0Ch)
attributes1 WORD (BoxWidth-1) DUP(0Eh),0Ah
attributes2 WORD BoxWidth DUP(0Bh)
          
 
.code
main PROC
 
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE ; Get the console ouput handle
    mov outputHandle, eax ; save console handle
    call Clrscr
    ; 畫出box的第一行
 
    INVOKE WriteConsoleOutputAttribute,
      outputHandle,
      offset attributes0,
      lengthof attributes0,
      xyPosition,
      offset cellsWritten
 
    INVOKE WriteConsoleOutputCharacter,
       outputHandle,   ; console output handle
       offset boxTop,   ; pointer to the top box line
       lengthof boxTop,   ; size of box line
       xyPosition,   ; coordinates of first char
       offset Count    ; output count
 
    inc xyPosition.y   ; 座標換到下一行位置
 
    mov ecx, BoxWidth-2    ; number of lines in body
 
   
 
L1: push ecx  ; save counter 避免invoke 有使用到這個暫存器
    INVOKE WriteConsoleOutputAttribute,
      outputHandle,
      offset attributes1,
      lengthof attributes1,
      xyPosition,
      offset cellsWritten
 
    INVOKE WriteConsoleOutputCharacter,
       outputHandle,   ; console output handle
       offset boxBody,   ; pointer to the top box line
       lengthof boxBody,   ; size of box line
       xyPosition,   ; coordinates of first char
       offset Count 
 
 
    inc xyPosition.y   ; next line
    pop ecx   ; restore counter
    loop L1
 
   INVOKE WriteConsoleOutputAttribute,
      outputHandle,
      offset attributes2,
      lengthof attributes2,
      xyPosition,
      offset cellsWritten
 
    INVOKE WriteConsoleOutputCharacter,
       outputHandle,   ; console output handle
       offset boxBottom,   ; pointer to the top box line
       lengthof boxBottom,   ; size of box line
       xyPosition,   ; coordinates of first char
       offset Count 
 
    call WaitMsg
    call Clrscr
    exit
main ENDP
END main
