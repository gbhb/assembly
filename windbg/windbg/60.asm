TITLE Lab of week2              (week2.ASM)

; This program locates the cursor and displays the
; system time. It uses two Win32 API structures.
; Last update: 6/30/2005

INCLUDE Irvine32.inc
INCLUDE Macros.inc
Max = 5000
; Redefine external symbols for convenience
; Redifinition is necessary for using stdcall in .model directive 
; using "start" is because for linking to WinDbg.  added by Huang
 
main          EQU start@0

;Comment @
;Definitions copied from SmallWin.inc:
GetProcessHeap proto
HeapAlloc proto,hHeap:HANDLE,dwFlags:DWORD,dwBytes:DWORD
sort proto,f:dword
tprint proto,r:dword
searchleaf proto,rr:dword,tt:dword,vv:dword,cc:dword
tablesort proto,ff:dword
print proto,p:dword

htree struct
	lab dword 0
	fre dword 0
	left dword 0
	right dword 0
	slink dword 0
htree ends

table struct
	key dword 0
	lab dword 0
	count dword 0
	fre dword 0
	link dword 0
table ends
	
.data
	
	first dword 0
	hHeap HANDLE ?
	btemp dword 0
	temp dword 0
	root dword 0
	map dword 0	;code like 01010101
	output1 byte "Huffman code:",0
	pmap dword 0 ;ptr map = table
	sum dword 0	
	cfre dword 0 ;count frequency
	output2 byte "Minimum weighted external path length: ",0
	output3 byte "Compression ratio: ",0
	output4 byte "Please input the code: ",0
	cnum dword 0 
	inputc2 byte Max+1 dup (?)
	output5 byte "Space: ",0
	output6 byte "Inorder Traversal",0

	inputc byte Max+1 dup (?)
	filename byte Max+1 dup (?)
	fileHandle HANDLE ?
.code
main PROC
	mov edx,offset filename
	mov ecx,Max
	call ReadString
	mov edx,offset filename
	mov ecx,sizeof filename
	call OpenInputFile
	mov fileHandle,eax
	mov edx,offset inputc
	mov ecx,max
	call ReadFromFile

	mov esi,offset inputc
	.while byte ptr [esi]!=0
	;排除除了英文跟空格的字
		.if byte ptr [esi]==' ' || (byte ptr [esi]>='A' && byte ptr [esi]<='Z') || (byte ptr [esi]>='a' && byte ptr [esi]<='z')
			;創建初始連結使其成為struct
			.if first==0
				invoke GetProcessHeap
				mov hHeap,eax
				invoke HeapAlloc,hHeap,HEAP_ZERO_MEMORY,type htree	;first=(ptree)malloc(sizeof(*first));
				mov first,eax
				mov eax,0
				mov edi,first
				mov (htree ptr [edi]).slink,eax					;first->slink=NULL;
				mov (htree ptr [edi]).left,eax					;first->left=NULL;
                mov (htree ptr [edi]).right,eax					;first->right=NULL;
                mov eax,1
				mov (htree ptr [edi]).fre,eax						;first->fre=1;
                movzx eax,byte ptr [esi]
				mov (htree ptr [edi]).lab,eax						;first->lab=(int)c;
            ;
			.else
                mov eax,first										;ptree btemp=first;
				mov btemp,eax
				
                .while btemp!=0
					mov edi,btemp
					mov al,byte ptr (htree ptr [edi]).lab
                    .if al== byte ptr [esi]
                        inc (htree ptr [edi]).fre					;btemp->fre++;
                        .break										;break
                    .else
						mov edi,btemp
						mov eax,(htree ptr [edi]).slink			;btemp=btemp->slink;
						mov btemp,eax
                    .endif
                .endw
                .if	btemp==0
					mov eax,first									;btemp=first;
					mov btemp,eax
					mov edi,btemp
                    mov eax,(htree ptr [edi]).slink
                    .while eax!=0								;btemp->slink!=NULL
						mov edi,btemp
						mov eax,(htree ptr [edi]).slink			;btemp=btemp->slink;
						mov btemp,eax
						mov edi,btemp
						mov eax,(htree ptr [edi]).slink
                    .endw
					mov eax,0										;ptree temp=NULL;
					mov temp,eax
					invoke GetProcessHeap
					mov hHeap,eax									;temp=(ptree)malloc(sizeof(*temp));
					invoke HeapAlloc,hHeap,HEAP_ZERO_MEMORY,type htree
                    mov temp,eax
					mov edi,temp
					mov eax,0
					mov (htree ptr [edi]).slink,eax				;temp->slink=NULL;
                    mov (htree ptr [edi]).left,eax					;temp->left=NULL;
                    mov (htree ptr [edi]).right,eax				;temp->right=NULL;
                    mov eax,1
					mov (htree ptr [edi]).fre,eax					;temp->fre=1;
                    movzx eax,byte ptr [esi]
					mov (htree ptr [edi]).lab,eax					;temp->lab=(int)c;
                    mov eax,temp
					mov edi,btemp
					mov (htree ptr [edi]).slink,eax				;btemp->slink=temp;
                    
                .endif
            .endif
		.endif
		inc esi
	.endw
	
	;mov eax,first	;temp=first;
	;mov temp,eax
	;.while	temp!=0
		;output
	;	mov edi,temp
	;	mov al,byte ptr (htree ptr [edi]).lab
	;	call WriteChar
	;	mov al,' '
	;	call WriteChar
	;	mov eax,(htree ptr [edi]).fre
	;	call WriteDec
	;	call Crlf
	;	mov eax,(htree ptr [edi]).slink			;temp=temp->slink;
	;	mov temp,eax
	;.endw
	
	invoke sort,addr first
	;call Crlf
	;mov eax,first	;temp=first;
	;mov temp,eax
	;.while	temp!=0
		;output
	;	mov edi,temp
	;	mov al,byte ptr (htree ptr [edi]).lab
	;	call WriteChar
	;	mov al,' '
	;	call WriteChar
	;	mov eax,(htree ptr [edi]).fre
	;	call WriteDec
	;	call Crlf
	;	mov eax,(htree ptr [edi]).slink			;temp=temp->slink;
	;	mov temp,eax
	;.endw

	;建樹時同時進行排序 加入一次就排一次
	mov eax,0
	mov root,eax								;ptree root=NULL;
    .while 1
        invoke GetProcessHeap
		mov hHeap,eax
		invoke HeapAlloc,hHeap,HEAP_ZERO_MEMORY,type htree
		mov temp,eax							;temp=(ptree)malloc(sizeof(*temp));
		
        mov eax,first
		mov edi,temp
		mov (htree ptr [edi]).left,eax			;temp->left=first;
        
		mov edi,first
		mov eax,(htree ptr [edi]).slink
		mov edi,temp
		mov (htree ptr [edi]).right,eax			;temp->right=first->slink;
		
        mov edi,first
		mov esi,(htree ptr [edi]).slink
		mov eax,(htree ptr [esi]).fre
		add eax,(htree ptr [edi]).fre
		mov edi,temp
		mov (htree ptr [edi]).fre,eax			;temp->fre=first->slink->fre+first->fre;
		
        mov edi,first
		mov eax,(htree ptr [edi]).lab
		mov edi,temp
		mov (htree ptr [edi]).lab,eax			;temp->lab=(int)first->lab;
		
        mov edi,first
		mov esi,(htree ptr [edi]).slink
		mov eax,(htree ptr [esi]).slink
		mov first,eax							;first=first->slink->slink;
		
        .if first==0
			mov eax,temp
			mov root,eax						;root=temp;
            .break								;break;
        .endif
		mov eax,first
		mov edi,temp
		mov (htree ptr [edi]).slink,eax			;temp->slink=first;
        
		mov eax,temp
		mov first,eax        					;first=temp;
		
		invoke sort,addr first					;sort(&first);
		
    .endw

	call Crlf
	mov edx,offset output6
	call WriteString
	call Crlf
	invoke tprint,root
	
	mov eax,0
	mov map,eax									;ptable map=NULL;
    invoke searchleaf,root,addr	map,0,0			;searchleaf(root,&map,0,0);
	
	;output
	;call Crlf
	;mov eax,map	;temp=map;
	;mov temp,eax
	;.while	temp!=0
		;output
	;	mov edi,temp
	;	mov al,byte ptr (table ptr [edi]).lab
	;	call WriteChar
	;	mov al,' '
	;	call WriteChar
	;	mov eax,(table ptr [edi]).key
	;	call WriteDec
	;	call Crlf
	;	mov eax,(table ptr [edi]).link			;temp=temp->link;
	;	mov temp,eax
	;.endw
	;output
	
	invoke tablesort,addr map
	
	call Crlf
	mov edx,offset output1
	call WriteString							;printf("Huffman code:\n");
	call Crlf
	
	invoke print,map
	
	mov eax,map
	mov pmap,eax								;ptable pmap=map;
    mov eax,0
	mov sum,eax
	mov cfre,eax								;int sum=0,cfre=0;
	;算頻率總數去算壓縮率 與 總長
    .while pmap!=0
        mov eax,cfre
		mov edi,pmap
		add eax,(table ptr [edi]).fre
		mov cfre,eax							;cfre=cfre+pmap->fre;
		
		mov edi,pmap
		mov eax,(table ptr [edi]).fre
		mul (table ptr [edi]).count
		mov ebx,sum
		add ebx,eax
		mov sum,ebx								;sum=sum+pmap->fre*pmap->count;
        
		mov edi,pmap
		mov eax,(table ptr [edi]).link
		mov pmap,eax							;pmap=pmap->link;
        
    .endw
	
	mov edx,offset output2
	call WriteString
	mov eax,sum
	call WriteDec
	call Crlf
    ;printf("Minimum weighted external path length: %d\n",sum);
    mov edx,offset output3
	call WriteString
	mov eax,cfre
	mov ebx,8
	mul ebx
	sub eax,sum
	call WriteDec
	mov al,'/'
	call WriteChar
	mov eax,cfre
	mov ebx,8
	mul ebx
	call WriteDec
	call Crlf
	call Crlf
	mov edx,offset output4
	call WriteString
	;printf("Compression ratio: %d/%d\n\nPlease input the code: ",cfre*8-sum,cfre*8);
	
	mov eax,0
	mov sum,eax				;sum=0;
    mov cnum,eax			;int cnum=0;

    mov edx,offset inputc2
	mov ecx,Max
	call ReadString
	;輸入需decode的table like 010101010101110101
	mov esi,offset inputc2

	.while byte ptr [esi]!=0
        movzx eax,byte ptr[esi]
		sub eax,'0'
		mov ebx,sum
		add ebx,sum
		add ebx,eax
		mov sum,ebx
		;sum=sum*2+c-'0';
        inc cnum
		;cnum++;
		mov eax,map
		mov pmap,eax
        ;pmap=map;
		
        .while pmap!=0
			mov edi,pmap
			mov eax,(table ptr [edi]).key
			mov ebx,(table ptr [edi]).count
			.if (sum==eax && cnum==ebx)
				mov edi,pmap
				mov al,byte ptr (table ptr [edi]).lab
                call WriteChar
				;printf("%c",pmap->label);
				mov eax,0
				mov sum,eax
                ;sum=0;
                mov cnum,eax
				;cnum=0;
				
                .break
            .endif
			mov edi,pmap
			mov eax,(table ptr [edi]).link
			mov pmap,eax
            ;pmap=pmap->link;
        .endw
		inc esi
    .endw
	call Crlf		;printf("\n");
	call WaitMsg
	exit
main ENDP
;顯示table
print proc,p:dword
	local nn:dword,ii:sdword
	.while p!=0
		mov edi,p
		mov eax,(table ptr [edi]).lab
        .if eax==' '
			mov edx,offset output5
			call WriteString
            ;printf("Space: ");
        .else
			mov edi,p
			mov al,byte ptr (table ptr [edi]).lab
			call WriteChar
			mov al,':'
			call WriteChar
			mov al,' '
			call WriteChar
            ;printf("%c: ",p->label);
        .endif
		
		mov edi,p
		mov eax,(table ptr [edi]).key
		mov nn,eax
        ;int n=p->key;
        
		;int i;
		mov edi,p
		mov eax,(table ptr [edi]).count
		dec eax
		mov ii,eax
        ;i=p->count-1
		.while ii>=0
			
			mov eax,nn
			mov cl,byte ptr ii
			shr eax,cl
			call WriteDec
            ;printf("%d",n/(int)pow(2,i));
			mov ebx,1
			mov cl,byte ptr ii
			shl ebx,cl
			mov edx,0
			mov eax,nn
			div ebx
			mov nn,edx
            ;n=n%(int)pow(2,i);
			dec ii
		.endw
		call Crlf
        ;printf("\n");
        mov edi,p
		mov eax,(table ptr [edi]).link
		mov p,eax
		;p=p->link;
    .endw
	ret
print endp
;遞迴指派0 1
searchleaf proc,rr:dword,tt:dword,vv:dword,cc:dword
    local localtemp:dword,localtemp2:dword
	mov edi,rr
	mov eax,(htree ptr [edi]).left
	mov ebx,(htree ptr [edi]).right
	.if(eax==0 && ebx==0)
											;ptable temp;
		invoke GetProcessHeap
		mov hHeap,eax
		invoke HeapAlloc,hHeap,HEAP_ZERO_MEMORY,type htree
		mov localtemp,eax						;temp=(ptable)malloc(sizeof(struct table));
        
		mov eax,vv
		mov edi,localtemp
		mov (table ptr [edi]).key,eax			;temp->key=v;
		
        mov eax,cc
		mov edi,localtemp
		mov (table ptr [edi]).count,eax 		;temp->count=c;
        
		mov edi,rr
		mov eax,(htree ptr [edi]).fre
		mov edi,localtemp
		mov (table ptr [edi]).fre,eax		;temp->fre=r->fre;
        
		mov edi,rr
		mov eax,(htree ptr [edi]).lab
		mov edi,localtemp
		mov (table ptr [edi]).lab,eax		;temp->label=r->lab;
        
		mov edi,tt
		mov esi,dword ptr [edi]
        .if esi==0
			mov eax,localtemp
			mov edi,tt
			mov dword ptr [edi],eax			;*t=temp;
        .else
			mov edi,tt
			mov eax,dword ptr [edi]
			mov localtemp2,eax				;ptable temp2=*t;
            
			mov edi,localtemp2
			mov eax,(table ptr [edi]).link
            .while eax!=0
				mov edi,localtemp2
				mov eax,(table ptr [edi]).link
				mov localtemp2,eax 			;temp2=temp2->link;
               
				mov edi,localtemp2
				mov eax,(table ptr [edi]).link
			.endw
			mov eax,localtemp
			mov edi,localtemp2
			mov (table ptr [edi]).link,eax	;temp2->link=temp;
            
        .endif
        ret 			;return;
    .endif
	
	mov edi,rr
	mov eax,(htree ptr [edi]).left
	mov ebx,vv
	add ebx,vv
	mov ecx,cc
	add ecx,1
    invoke searchleaf,eax,tt,ebx,ecx;searchleaf(r->left,t,v*2+0,c+1);

	mov edi,rr
	mov eax,(htree ptr [edi]).right
	mov ebx,vv
	add ebx,vv
	add ebx,1
	mov ecx,cc
	add ecx,1
    invoke searchleaf,eax,tt,ebx,ecx;searchleaf(r->right,t,v*2+1,c+1);
	ret
searchleaf endp
;中序走訪並輸出
tprint proc,r:dword
	.if r!=0
		mov edi,r
		mov eax,(htree ptr [edi]).left
		invoke tprint,eax
		
		mov edi,r
		mov al,byte ptr (htree ptr [edi]).lab
		call WriteChar
		mov al,' '
		call WriteChar
		mov eax,(htree ptr [edi]).fre
		call WriteDec
		call Crlf
		
		mov edi,r
		mov eax,(htree ptr [edi]).right
		invoke tprint,eax
	.endif
	ret
tprint endp
;bubble sort
sort proc,f:dword
	local count:dword,p:dword,i:dword,j:dword,after:dword,temp1:dword,temp2:dword
	mov eax,0
	mov count,eax					;int count=0;
	mov edi,f
	mov eax,dword ptr [edi]
	mov p,eax						;ptree p=*f;
									
    .while p!=0
		inc count					;count++;
        mov edi,p
		mov eax,(htree ptr [edi]).slink
		mov p,eax					;p=p->slink;
    .endw

	mov eax,1
	mov i,eax		;i=1
	mov eax,count
    .while i<=eax
	
		mov edi,f
		mov eax,dword ptr [edi]
		mov p,eax						;p=*f;
        
        mov eax,1			;j=1
		mov j,eax
		mov eax,count
		sub eax,i
        .while j<=eax
			mov edi,p
			mov eax,(htree ptr [edi]).fre
			mov ecx,(htree ptr [edi]).lab
			mov esi,(htree ptr [edi]).slink
			mov ebx,(htree ptr [esi]).fre
			mov edx,(htree ptr [esi]).lab
			
            .if  (eax > ebx) || ((eax==ebx) && (ecx > edx));(p->fre > p->slink->fre) || ((p->fre==p->slink->fre) && (p->lab > p->slink->lab))
                mov edi,p
				mov esi,(htree ptr [edi]).slink
				mov after,esi			;ptree after=p->slink;
				
                mov edi,p
				mov eax,(htree ptr [edi]).fre
				mov temp1,eax			;temp1=p->fre;
                
				mov edi,after
				mov eax,(htree ptr [edi]).fre
				mov edi,p
				mov (htree ptr [edi]).fre,eax;p->fre=after->fre;
                
				mov eax,temp1
				mov edi,after
				mov (htree ptr [edi]).fre,eax;after->fre=temp1;
                
				mov edi,p
				mov eax,(htree ptr [edi]).lab
				mov temp1,eax				;temp1=p->lab;
                
				mov edi,after
				mov eax,(htree ptr [edi]).lab
				mov edi,p
				mov (htree ptr [edi]).lab,eax;p->lab=after->lab;
                
				mov eax,temp1
				mov edi,after
				mov (htree ptr [edi]).lab,eax;after->lab=temp1;
				
                mov edi,p
				mov eax,(htree ptr [edi]).left
                mov temp2,eax				;temp2=p->left;
				
				mov edi,after
				mov eax,(htree ptr [edi]).left
				mov edi,p
				mov (htree ptr [edi]).left,eax;p->left=after->left;
                
				mov eax,temp2
				mov edi,after
				mov (htree ptr [edi]).left,eax;after->left=temp2;
				
                mov edi,p
				mov eax,(htree ptr [edi]).right
				mov temp2,eax					;temp2=p->right;
				
                mov edi,after
				mov eax,(htree ptr [edi]).right
				mov edi,p
				mov (htree ptr [edi]).right,eax;p->right=after->right;
				
                mov eax,temp2
				mov edi,after
				mov (htree ptr [edi]).right,eax;after->right=temp2;
            .endif
				mov edi,p
				mov esi,(htree ptr [edi]).slink
				mov p,esi						;p=p->slink;
                
			inc j			;++j	
			mov eax,count
			sub eax,i
        .endw
		inc i				;++i
		mov eax,count
    .endw
	ret
sort endp
;為了讓輸出table照字母順序
tablesort proc,ff:dword
	local count:dword,p:dword,i:dword,j:dword,after:dword,temp1:dword,temp2:dword
	mov eax,0
	mov count,eax					;int count=0;
	mov edi,ff
	mov eax,dword ptr [edi]
	mov p,eax						;ptree p=*f;
									
    .while p!=0
		inc count					;count++;
        mov edi,p
		mov eax,(table ptr [edi]).link
		mov p,eax					;p=p->slink;
    .endw

	mov eax,1
	mov i,eax		;i=1
	mov eax,count
    .while i<=eax
	
		mov edi,ff
		mov eax,dword ptr [edi]
		mov p,eax						;p=*f;
        
        mov eax,1			;j=1
		mov j,eax
		mov eax,count
		sub eax,i
        .while j<=eax
			
			mov edi,p
			mov eax,(table ptr [edi]).lab
			mov esi,(table ptr [edi]).link
			mov ebx,(table ptr [esi]).lab
            .if  eax>ebx;(p->label > p->link->label)
                mov edi,p
				mov esi,(table ptr [edi]).link
				mov after,esi			;ptree after=p->link;
				
                mov edi,p
				mov eax,(table ptr [edi]).fre
				mov temp1,eax			;temp1=p->fre;
                
				mov edi,after
				mov eax,(table ptr [edi]).fre
				mov edi,p
				mov (table ptr [edi]).fre,eax;p->fre=after->fre;
                
				mov eax,temp1
				mov edi,after
				mov (table ptr [edi]).fre,eax;after->fre=temp1;
                
				mov edi,p
				mov eax,(table ptr [edi]).lab
				mov temp1,eax				;temp1=p->lab;
                
				mov edi,after
				mov eax,(table ptr [edi]).lab
				mov edi,p
				mov (table ptr [edi]).lab,eax;p->lab=after->lab;
                
				mov eax,temp1
				mov edi,after
				mov (table ptr [edi]).lab,eax;after->lab=temp1;
				
                mov edi,p
				mov eax,(table ptr [edi]).key
                mov temp2,eax				;temp2=p->key;
				
				mov edi,after
				mov eax,(table ptr [edi]).key
				mov edi,p
				mov (table ptr [edi]).key,eax;p->key=after->key;
                
				mov eax,temp2
				mov edi,after
				mov (table ptr [edi]).key,eax;after->key=temp2;
				
                mov edi,p
				mov eax,(table ptr [edi]).count
				mov temp2,eax					;temp2=p->count;
				
                mov edi,after
				mov eax,(table ptr [edi]).count
				mov edi,p
				mov (table ptr [edi]).count,eax;p->count=after->count;
				
                mov eax,temp2
				mov edi,after
				mov (table ptr [edi]).count,eax;after->count=temp2;
            .endif
				mov edi,p
				mov esi,(table ptr [edi]).link
				mov p,esi						;p=p->slink;
                
			inc j			;++j	
			mov eax,count
			sub eax,i
        .endw
		inc i				;++i
		mov eax,count
    .endw
	ret
tablesort endp
END main