TITLE asm3_Q3
INCLUDE Irvine32.inc
INCLUDE ams3_Q3_data.inc
; name:roi sela 
; id : 208199679
;name:Or Othnay
;id: 315856674

;about the program:
;esp will be the stack pointer as it should be
; edi and esi will be used to point to strings
;ecx will be used as a loop counter

;eax will be used as temp

;ebx will be a string size holder
;edx will be used as string size holder



;assembly program to check whether a string
; makes an additive sequence or not

.data
 header byte "roi sela , ID:208199679 , and Or Othnay ID:315856674 ",10,13,0
 
 n1 byte "215",0
 n2 byte "56489",0
 
 
.code 
my_main PROC

mov edx , OFFSET header
call writeString			;printing the header


;void addstring(char* resultString,char* ptr2,char* ptr1,int len2,int len1)
;the functions put in resultstring the sum of ptr1 and ptr2 
;for exapmle: ptr1="12" , ptr2="10" then resultstring="22" 

push offset res
push offset n2
push offset n1
push 5
push 2
call AddString



mov edx,offset res
call writeString

call ExitProcess
my_main ENDP


;gets paramaters throght stack 

;first,gets address of string in esi
;and then size in ebx 
; Checks whether num is valid or not, by checking first character and size
;returns 0 in al if not valid and 1 if valid
IsValid PROC
sizeOfString = 8 
addressOfString = sizeOfString+4
push ebp ;save current ebp value 
mov ebp ,esp ;base of stack frame

;we need to save current value of the registers that will be used:

push ecx 
push edx
push esi
push ebx
;-----------------------------------------------------------------
mov esi,[ebp+addressOfString ] ;now esi has the offset of the input string 
mov ebx,[ebp+sizeOfString  ] ;now esi has the offset of the input string

mov ecx,0
cmp ebx,1 ;first we check if ebx(the size) is bigger than one
ja nextStage1

final1:
mov al,1
jmp end1

nextStage1: ;now we check if str[0]=='0'
mov edx , [esi+ecx]
cmp edx,'0'
jnz final1 ;if its not equal we put 1 in al and were done.
mov al,0
jmp end1

end1:
;we need to return the used registers there original value before exiting the function:


pop ebx 
pop esi
pop edx
pop ecx
mov esp,ebp ;give esp its oringal value , before restoring ebp
pop ebp

RET 8
IsValid endp 


; returns int value at pos string in al, if pos is
; out of bound then returns 0 in al
;gets 3 paramaters throgh stack in this order :

;puts index in edx 
;puts address of string in esi 
;puts size in ebx 
Val PROC
sizeOfString = 8 
addressOfString = sizeOfString+4
indexToCheck = addressOfString+4

push ebp ;save current ebp value 
mov ebp ,esp ;base of stack frame

;we need to save current value of the registers that will be used:
push ebx
push edx
push esi
;-----------------------------------------------------------------
mov esi,[ebp+addressOfString ] ;now esi has the offset of the input string 
mov ebx,[ebp+sizeOfString  ] ;puts size in ebx 
mov edx,[ebp+indexToCheck  ] ;puts index in edx 

cmp edx,ebx  ;if index >= size ,then clearly ,the function reutrn 0 (invalid input)
jae badEndofvalfunc 
mov al,[esi+edx] ;if we got here , that means that index is valid and we can put in in al 
sub al,'0' ; we subtract '0' to get the actual numiric value
jmp endofvalfunc ;we finished the function succefully

badEndofvalfunc:
mov al,0
jmp endofvalfunc

endofvalfunc:

pop esi
pop edx
pop ebx 
 
mov esp,ebp ;give esp its oringal value , before restoring ebp
pop ebp 

RET 12
Val endp 



;when calling this function the stack has the following 5 values (and will be sent in that order):
;offset of input string
;input string length
;position (index) inside the string 
;length of string to check from this postion 
;the offset of the target string

subString PROC
targetString = 8
lenToCheckFromPosition = targetString+4
position =lenToCheckFromPosition +4
lengthOfInputString = position+4
inputString = lengthOfInputString+4 ;this is the input string
push ebp ;save current ebp value 
mov ebp ,esp ;base of stack frame

;lets save the current value of the registers(possible wrong..but the rest is fine i think):
push esi
push ebx
push edx
push eax 
push edi 
;-----------------------------------------------

;first we check is position is valid using the val function we built earlier:
mov esi,[ebp+inputString] ;now esi has the offset of the input string 
mov ebx,[ebp+lengthOfInputString] ;now ebx holds the length of the string
mov edx,[ebp+position] ;edx holds the index(position) 

push edx
push esi
push ebx
call Val ;now if al is 1 the position is valid and 0 else
cmp al,0
jz subStringInvalid
;now we need to check if the sum pos+len is Exceeds the arrays limit
;we will compare the sum with the size of the string if (sum<=size of string) ,then were good ,else we will return 0 in al
mov eax,[ebp+lenToCheckFromPosition] ;eax = lenToCheckFromPosition
add edx ,eax ;now edx=lenToCheckFromPosition+position
cmp edx,ebx ;now we check the condition mantioned earlier
ja subStringInvalid ;the jump above command is requested here , because if sum is greater than len , then its invalid 
sub  edx ,eax ;now edx=position again


;now after we checked those conditions we can start putting in the target string the requested sub string from input
mov edi , [ebp+targetString] ;now edi is pointing to the target string , lets refer to it as "res" from now on.
mov byte ptr [edi+eax],0 ;we put zero at the end of res , (can be done outside the function also )
mov eax,0  
push ecx 
mov cl, [esi+edx]
mov  [edi+eax],cl ; we put: res[0]=inputString[pos]
pop ecx 
mov eax,[ebp+lenToCheckFromPosition] ;eax = lenToCheckFromPosition

;the rest will be done in a recursive manner , we need to preapare the variables for the next itaration
;right now the registes have the following information in them:
;eax = lenToCheckFromPosition  
;edx = pos 
;edi = res
;esi = inputstring
;ebp = length of input string

dec eax ;len=len-1
inc edi ;now edi = &(res+1)
inc esi ;now esi = &(input string+1)
dec ebx ; length of input string -= 1
;pos stays the same 

;lets check if len=0;
cmp eax,0
jz subStringInvalid

;now we need to push the elements in a very specific order, and that order is:
;offset of input string
;input string length
;position (index) inside the string 
;length of string to check from this postion 
;the offset of the target string

push esi
push ebx
push edx
push eax 
push edi 

;now that we have the updated values for the next itatation, we can safely use recurtion to do the rest for us:
;--------------------------------------------------------------------------------------------------------------
call subString
;--------------------------------------------------------------------------------------------------------------

jmp subStringFine 

subStringInvalid:
pop edi
pop eax 
pop edx
pop ebx 
pop esi 
mov esp,ebp
pop ebp

mov al,0
ret 20
subStringFine:
pop edi
pop eax 
pop edx
pop ebx 
pop esi 
mov esp,ebp
pop ebp
mov al,1 
ret 20

subString endp 


;example of use,given the string hello byte "!olleh",0:
;mov ecx,lengthof hello-1 
;mov esi,offset hello
;call reverse_string
;--------------------------------------
;the procedure reverse the string using two loops and 
;stack input arguments
;ecx-length of string 
;esi - pointer to the string 

reverse_string PROC USES ECX ESI EBX EDX 
mov edx,ecx ;save ecx for the second loop 
push_loop:
;we can push to the stack either word or dword only 
;so we copy the byte and extend it to a word 
movzx bx,byte ptr[esi] ; move a byte , and extend to word
push bx 
inc esi 
loop push_loop 
mov ecx,edx ;restore the counter 
sub esi,ecx ;restore esi 
pop_loop:
pop bx 
mov [esi],bl
inc esi
loop pop_loop

RET
reverse_string endp 


; Str2D (unsigned int *d, char *StrPtr)
;   Input parameters:
; 	  Str -  offset of the string to convert
;   Output parameters:
; 	  D - Points to empty DWORD
Str2D PROC
    D = 8
    StrPtr = D + 4
    push ebp        ;Standard prologue
    mov ebp,esp
    push eax        ;Saving registers we use
    push ebx
    push esi
    
    mov esi,StrPtr[ebp]     ; esi points to first digit
    mov eax,0       ;Initialize to Zero
    mov ebx,0       ;pad with zeros
    push 10         ;needed for MUL
NextDigit:
    cmp BYTE PTR[esi],0		;end of the string?
    jz AfterLoop
    mul DWORD PTR [esp]  ;eax <-- eax * 10
    mov bl,[esi]
    sub bl,'0'      ;Note: we don't check that ascii is digit
    add eax,ebx
    inc esi         ;next digit
    jmp NextDigit
AfterLoop:
    mov ebx,D[ebp]  ;the address of the result
    mov [ebx],eax   ;move eax to that location
    add esp,4       ;due to the 10 we pushed before
    pop esi         ;Restore registers
    pop ebx
    pop eax
    pop ebp
    ret 8
Str2D ENDP

; D2Str10(unsigned int d, char *StrPtr)
; Input parameters:
; 	D -  DWORD to convert
; Output parameters:
; 	StrPtr - Points to empty place
D2str10 PROC
	D = 8
	StrPtr = D + 4
	push ebp        ;Standard prologue
	mov ebp,esp
	push ecx        ;Saving registers we use
	push edx
	
	mov ecx,0 	    ;Count for number of digits
	mov eax,D[ebp]  ;Get the DWORD
NextDigit:
	mov edx,0       ;Prepare to DIV
	push 10         ;Temporary 10
	div DWORD PTR [esp] ;Divide by 10
	add esp,4       ;Delete the temporary.
	                ;It is better either to define it
	                ;or in the entry to the procedure
	add edx,'0'     ;Convert the digit to ASCII
	push dx         ;And save it on stack. (We get t
	inc ecx         ;Update digits counter
	cmp eax,0       ;Have we finished?
	jne NextDigit   ;No. Continue to next digit
	                ;Yes.
	mov eax,StrPtr[ebp] ;Get the string pointer
NextPop:
	pop dx ;Pop digit
	mov [eax],dl ;Store digit into string
	inc eax ;Point to next place
	loop NextPop ;Do this for all digits

   ; mov WORD PTR [eax],0A0Dh ; CR-LF to end the line
    ;add eax,2
	mov BYTE PTR [eax],0;Add the terminating null
	pop edx ;Restore registers
	pop ecx
	pop ebp
	ret 8
D2str10 ENDP



;void addstring(char* resultString,char* ptr2,char* ptr1,int len2,int len1)
;the functions put in resultstring the sum of ptr1 and ptr2 
;for exapmle: ptr1="12" , ptr2="10" then resultstring="22" 
AddString PROC
len1 = 8
len2 = len1+4
ptrToStr1=len2+4
ptrToStr2=ptrToStr1+4
resultString=ptrToStr2+4
push ebp        ;Standard prologue
mov ebp,esp

;Saving registers we use
push esi 
push edi 
push eax
push ebx
push ecx       
push edx

mov esi,[ebp+ptrToStr1] ;now esi=ptr1
mov edi,[ebp+ptrToStr2] ;edi = ptr2
mov eax,[ebp+len1] 
mov ebx,[ebp+len2] 

;first we must compute the decimal value of string 1 and string 2
;we will do that using the str2D function
push esi 
lea ecx,[ebp+len1] ;we will put the numiric value of str1 in the stack instead of len1
push ecx ;ecx will store the decimal value of string1
call Str2D
mov ecx,[ebp+len1]

push edi
lea edx,[ebp+len2] 
push  edx ;edx will store the decimal value of string1
call Str2D
mov edx,[ebp+len2]

add edx,ecx ;now edx = sum of both strings , and ecx is no longer needed
mov esi,[ebp+resultString] ;now esi=res 
;now we will put edx in esi using the D2str function
PUSH esi 
push edx 
call D2str10


pop edx
pop ecx
pop ebx 
pop eax 
pop edi 
pop esi
mov esp,ebp
pop ebp        ;Standard prologue



RET 20
AddString endp 

;receives two zero terminated string offsets in edi and esi and returns 1 in al if they are equal, ecx used as temp storage
CmpStr proc uses edi esi ecx

lop:
movzx eax, byte ptr [edi]
movzx ecx, byte ptr [esi]
cmp eax, ecx
jnz	fals
cmp eax, 0
jz tru
inc edi
inc esi
jmp lop

fals:
mov al,0
jmp done

tru:
mov al,1

done:
ret
CmpStr endp

;receives two zero terminated string offsets, a and b in edi and esi and appends b to the end of a.
; a = [edi], b = [esi]
PushBack proc uses edi esi eax

;find the end of string a.
lop:
movzx eax, byte ptr [edi]
cmp	eax,0
jz endofa
inc edi
jmp lop

;append b to the end of a.
endofa:
movzx eax, byte ptr [esi]
mov [edi],eax
cmp eax,0
jz finish
inc edi
inc esi
jmp endofa

finish:
ret
PushBack endp

;receives two zero terminated string offsets, a and b in edi and esi and appends b to the beginning of a.
; a = [edi], b = [esi]
PushFront proc uses esi edi eax ebx

;find length of b
push esi
mov ebx,0
lop:
movzx eax, byte ptr [esi]
cmp	eax,0
jz next
inc esi
inc ebx;ebx will be the length of b.
jmp lop

next:
pop esi
;swap edi and esi, now a=esi,b=edi
push esi
mov esi,edi
pop edi
call PushBack ; edi = b = b+a

push edi
push esi
copyloop:
movzx eax, byte ptr [edi]
mov [esi],eax
cmp eax,0
jz finish
inc edi
inc esi
jmp copyloop


finish:
pop esi
pop edi

lea eax,[edi+ebx]
mov ebx,0
mov [eax],ebx;fixing b to be the original string.

ret
PushFront endp



end my_main


