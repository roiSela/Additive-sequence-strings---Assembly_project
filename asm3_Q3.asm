TITLE asm3_Q3
INCLUDE Irvine32.inc
INCLUDE asm3_Q3_data.inc
; name:roi sela 
; id : 208199679


.data
 header byte "roi sela , ID:208199679 ",10,13,0
arr dword -20,4
.code 
my_main PROC

push  [arr]
push  [arr+4]
call addtwo

mov edx , offset header
call writestring

call ExitProcess
my_main ENDP

;this function recives two sign numbers throgh the stack and returns the sum of both of them in eax 
addtwo proc USES edx ebx esi
X = 12+8 
Y = X + 4

push ebp 
mov ebp,esp

mov eax , [ebp+x]
add eax , [ebp+y]

call writeint


pop ebp
ret 8 
addtwo endp


end my_main


