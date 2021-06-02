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
 
 
.code 
my_main PROC

mov edx , OFFSET header
call writeString			;printing the header



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
mov edx , esi[ecx]
cmp edx,'0'
jnz final1 ;if its not equal we put 1 in al and were done.
mov al,0
jmp end1

end1:
;we need to return the used registers there original value before exiting the function:
mov esp,ebp ;give esp its oringal value , before restoring ebp

pop ebx 
pop esi
pop edx
pop ecx
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
mov al,esi[edx] ;if we got here , that means that index is valid and we can put in in al 
sub al,'0' ; we subtract '0' to get the actual numiric value
jmp endofvalfunc ;we finished the function succefully

badEndofvalfunc:
mov al,0
jmp endofvalfunc

endofvalfunc:
mov esp,ebp ;give esp its oringal value , before restoring ebp
pop edx 
pop ebx 
pop esi
pop ebp 

RET 8
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
push ebp
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
sub  edx ,eax ;now edx=position again
ja subStringInvalid ;the jump above command is requested here , because if sum is greater than len , then its invalid 

;now after we checked those conditions we can start putting in the target string the requested sub string from input
mov edi , [ebp+targetString] ;now edi is pointing to the target string , lets refer to it as "res" from now on.
mov edi[eax],0 ;we put zero at the end of res , (can be done outside the function also )
mov eax,0  
mov edi[eax],esi[edx] ; we put: res[0]=inputString[pos]
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
dec ebp ; length of input string -= 1
;pos stays the same 

;now we need to push the elements in a very specific order, and that order is:
;offset of input string
;input string length
;position (index) inside the string 
;length of string to check from this postion 
;the offset of the target string

push esi
push ebp
push edx
push eax 
push edi 

;now that we have the updated values for the next itatation, we can safely use recurtion to do the rest for us:
;--------------------------------------------------------------------------------------------------------------
call subString
;--------------------------------------------------------------------------------------------------------------

jmp subStringFine 

subStringInvalid:
mov esp,ebp
pop edi
pop eax 
pop edx
pop ebp 
pop esi 
pop ebp

mov al,0
ret 20
subStringFine:
mov esp,ebp
pop edi
pop eax 
pop edx
pop ebp 
pop esi 
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


end my_main


