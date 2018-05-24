org 100h
start:  ;Program start.
		mov dx, offset message  ;print message.
		mov ah, 9           
		int 21h  
startAftermessage:       
        mov ah, 1           ;take char input and put it in num1 as hexadeciml number.
	    int 21h
	    cmp al,'0'
	    je  EXIT            ;if the input is zero,Go to EXIT label(Exit the Program).
	    sub al,30h          ;convert the first char(num1) into hexadeciml number.
        mov num1,al
        mov ah,01h          ;take char input and put it in num2 as hexadeciml number.
        int 21h
        cmp al,0Dh          ;if enter is pressed , go to cont (continue) label.
        je  cont      
        sub al,30h          ;convert the second char(num2) into hexadeciml number.
        mov num2,al
        mov ah,00           ;wait for any keypress
        int 16h	     
        mov al,num1
        mul ten             ;multiply the digit that represents tens and add it to units digit.
        add al,num2
        mov num1,al         ;the real hexadecimel number(not just characters),we put it in num1.
cont:
        cmp num1,25         ;if num1 is greater than 25, go to correct label.    
        ja  correct
        cmp num1,0h         ;if num1 is smaller than 0, go to correct label.
        jb  correct    ;       
        mov dx, offset line ;new line.
        mov ah, 09          
        int 21h 
        mov dx, offset message2 ;print message2 to the console.
	    mov ah, 9           
	    int 21h 
	    mov dx, offset line ;new line.
        mov ah, 09          
        int 21h             
	    mov cl,num1         ;getting ready for an input loop by giving the cl the value of num1.
	    mov ch,0            ;assigning 0 to ch, so that cx=num1.                                 
	    
;=============================================================================================
	    xor bx,bx           ;put bx=0, as it will represent the array index increment.  
input:	                    ;here we  input the elements.
	    mov ah, 1           ;take char input and put it in temp1 as hexadeciml number. 
	    int 21h
	    mov temp1,al
	    mov ah, 1           ;take char input and put it in temp2 as hexadeciml number.
	    int 21h    
	    cmp al,0Dh          ;;if enter is pressed , go to correct_element label.
	    jz  correct_element   
	    mov temp2,al 
	    mov ah,00           ;wait for any keypress
        int 16h
cont2:                      
        lea si,arr    ;load the memory location of array's 1st element to source index register.
	    mov ah,temp1        ;move temp1 to ah, the high order byte of ax.
	    mov al,temp2        ;move temp2 to al, the low order byte of ax.
   	    mov [si+bx],ax      ;move ax to the array element that has the index (bx).
	    add bx,2            ;since we defined the array as a word, then the index 
	                        ;difference between any 2 successive elements is 2.
		mov dx, offset line ;new line
        mov ah, 09          
        int 21h
        loop input          ;loop if cx is not equal to zero.
                            ;end of print loop
;=========================================================================================        
        mov dx, offset message3 ;print message3 to the console. 
	    mov ah, 9           
	    int 21h
	    mov dx, offset line ;new line
        mov ah, 09          
        int 21h
	    mov ah, 1           ;input a character that determines the arrangement type. 
	    int 21h               
	    mov dl,al           ;we copy the value of the character, as it will 
	                        ;be overwritten in the next interruption.
	    mov ah,00           ;wait for any keypress
        int 16h 
        mov cl,num1         ;load the num1 to the cl, for a new loop.
        sub cl,1            ;subtract one from it as the bubble sort algorithm 
                            ;requires only (length of the array - 1) in its outer loop.
	    mov ch,0            ;clear ch, we don't want it to affect the loop counter.
	    cmp num1,1          ;if the length of the array is only 1 , then go to oneelement label.
	    je  oneelement
	    cmp dl,'a'          ;if the user inputed 'a' go ascout(ascending outer loop).
	    je  ascout
	    cmp dl,'d'          ;if the user inputed 'd' go descout(descending outer loop).
	    je  descout 
;=================================================================================================	     
bef.pr:                     ;before print label.
	    mov cl,num1         ;a loop to outout the sorted elements.
	    mov ch,0 
	    mov dx, offset line ;new line.
        mov ah, 09          
        int 21h     
	    xor bx,bx
	    lea si,arr 
	    
print: 
       
	   mov dx,[si+bx]       ;move the element with the index (si+bx) into dx.
	   mov temp1,dh         ;temp1 is the high order byte of the element.
	   mov temp2,dl         ;temp1 is the high order byte of the element.
	   cmp dh,0             ;if the H.O.B is equal to zero, escape printing it.
	   je  esc1
	   mov ah, 2
	   mov dl, temp1
	   int 21h
	      
esc1:   
       mov dh,temp2	        
       cmp dh,0             ;if the L.O.B is equal to zero, escape printing it.
       je  esc2
       mov ah, 2
	   mov dl, temp2
	   int 21h
esc2:	          
       cmp cl,1             ;escape printing a comma if it's the last element.
       je  esccomma
       mov ah, 2
	   mov dl, ','    	   
	   int 21h 
esccomma:
       add bx,2
       cmp num1,1
       je start
       loop print           
                            ;end of print loop.
       
       mov dx, offset line  ;new line.
       mov ah, 09          
       int 21h           
       jmp start
;===============================================================================================       
ascout:                     ;Bubble sort algorithm.
       lea si,arr
       mov i,si
         
ascin:
       mov dx,[si]
       cmp dx,[si+2]
       ja  swapasc
contsasc:
       lea bp,arr
       add bp,cx
       add si,2 
       inc i
       cmp bp,i
       ja  ascin
       loop ascout
       jmp  bef.pr
swapasc: 
       mov ax,[si+2] 
       mov dx,[si]
       mov [si],ax
       mov [si+2],dx
       jmp contsasc  
descout: 
       lea si,arr
       mov i,si  
descin:
       mov dx,[si]
       cmp dx,[si+2]
       jb  swapdesc
contsdes:
       lea bp,arr
       add bp,cx
       add si,2
       inc i
       cmp bp,i
       ja  descin
       loop descout
       jmp  bef.pr
swapdesc: 
       mov ax,[si+2] 
       mov dx,[si]
       mov [si],ax
       mov [si+2],dx
       jmp contsdes   
;===============================================================================================          		              
correct:                                ;if num1>25 or num1 < 0, the message1 appears and program
                                        ;restarts, but after the opening message.                                 
       mov dx, offset line ;
       mov ah, 09          
       int 21h
       mov dx, offset message1   ;
	   mov ah, 9           
	   int 21h
	   jmp startAftermessage                ;After the opening message label.
;================================================================================================      
correct_element:                        ;if only one byte was inputted then followed by enter
                                        ;press the High order byte(H.O.B) is set to zero
                                        ;and the L.O.B takes the H.O.B value.
       mov al,temp1
       mov temp2,al
       mov temp1,0
       jmp cont2
;================================================================================================	   
oneelement:                            ;if there is only one element, it takes a special path,
                                       ; as it will cause an infinte loop within the running
                                       ;time when it comes to bubble sort algorithm.
                                       
       mov dx, offset line ;
       mov ah, 09          
       int 21h 
       xor bx,bx
       mov dx,[si+bx] 
	   mov temp1,dh
	   mov temp2,dl
	   cmp dh,0
	   je  esc1
	   mov ah, 2
	   mov dl, temp1
	   int 21h
	   mov dx, offset line ;
       mov ah, 09          
       int 21h 
	   jmp start
;=================================================================================================          
EXIT:    
       mov ah,00       ;  wait for any keypress
       int 16h	
       
ret    
;=================================================================================================  
   ten db 10    ;equals 10 
   num1 db 0    ;the tens digit of the number of elements
   num2 db 0    ;the units digit of the number of elements
   temp1 db 0   ;the tens digit of an element.
   temp2 db 0   ;the units digit of an element.
   i dw 0       ;a counter that will be used
   arr dw 25 DUP(?) ;the array of elements.
   message3 db "Enter a for ascending order or d for descending order: $" 
   message2 db "Please enter elements of the array to be sorted: $"
   message1 db "Please enter suitable number in the range of [1 - 25]: $"
   message db "Please enter the number of elements in the array to be sorted or press 0 to terminate: $"
   line db 13, 10, "$"   ;the new line.
