.data
 
msg1 db 0DH,0AH,"Please enter the number of elements in the sequence:",0DH,0AH,"$"
msg2 db ", ","$"   
msg3 db 0DH,0AH,"Please enter a suitable number in range [1-25]",0DH,0AH,"$"    
msg4 db 0DH,0AH,"Please enter a numeric charachter!",0DH,0AH,"$"
num1 dw 0                       ;this is a numeric variable
num2 dw  0                      ;this is a numeric variable
input dw  0                     ;this is a numeric variable
fib_num1 DW 1                     ;word numeric value n-1 value
fib_num2 DW 0                     ;word numeric value n-2 value
fibo DW 0                        ;word numeric value
temp    DW 0                    ;word numeric value
saveCount DW 0                  ;counter storage
;======================================================================================================================================= 
 
.code     
 
main proc
    BEGIN:
    mov   ax,@data              ; set up data segment
    mov   ds,ax                 ; clear the screen
    
    mov   ah,9                  ; send message with instructions for user
    mov   dx,offset msg1
    int   21h 
               
    FirstCharacter:
    
    call keyin                  ;gets user input
    cmp al,48                   ;checks if user entered 0, then:
    JE out_of_it                ;terminate.
        
        CHECKINPUTENTER:
        CMP AL,13               ;Checks if second key entered is ENTER key
        JE finish_it            ;If yes, then jump to Step 2 directly 


    SUB AL, 48                  ;changes ASCII value into numeric value for further processing
    MOV AH,0
    MOV num1 , AX               ;saves user input to variable num1
        
        xor cx,cx               ; cx-register is the counter, set it to 0 -- counter initialization
        loop3:                  ; Start loop for checking if entered value is a number from 0 to 9
        cmp cx,ax               ; Compare the value entered by keyboard with the counter value
        JE SecondCharacter      ; something  that checks if CX equals AL  
        inc cx                  ; Increment
        cmp cx,9                ; Compare cx to the limit
        jle loop3               ; Loop while less or equal
        
        JMP WARNING2 

               
    SecondCharacter:
 
    call keyin
       
        CHECKINPUTENTER2:
        CMP AL,13               ; Checks if second key entered is ENTER key
        JE JMPSTP2              ;If yes, then jump to Step 2 directly    
       
    SUB AL, 48                  ;changes ASCII value into numeric value for further processing
    MOV AH,0    
    MOV num2 , AX               ;saves user input to variable num2, so now we have both digits      

        xor cx,cx               ; cx-register is the counter, set to 0
        loop4:                  ; Start loop for checking if entered value is a number from 0 to 9
        cmp cx,ax               ; Compare the value entered by keyboard with the counter value
        JE STEP1                ; CONTINUE TO MAIN CODE!  
        inc cx                  ; Increment
        cmp cx,9                ; Compare cx to the limit
        jle loop4               ; Loop while less or equal
        
        JMP WARNING2
    

    OUT_OF_IT:
    JMP   ENDIT 
    ;=================================================================================================================================
    
    WARNING2:
    mov   ah,9                  ; send message with instructions for user
    mov   dx,offset msg4
    int   21h 
    xor   ax,ax
    JMP FirstCharacter
 
    WARNING:
 
    mov   ah,9                  ; send message with instructions for user
    mov   dx,offset msg3
    int   21h     
    xor   ax,ax
    JMP   FirstCharacter
    
    JMPSTP2:
    mov   es,num1
    mov   num2,es
    mov   num1,48
    mov   input,es              ;used es to swap num1 with num2 if sec char was enter
    
    JMP STEP25
          
    ;====================================================================================================================================
                                ;this part converts num1 and num2 into a value that the proccessor could understand!
    STEP1:                      
    CMP num1,2
    JA WARNING
    CMP num1,2
    JL STEP15
    
    
    SECONDCOMP:                 ;jump if num1 = 2
    CMP num2,5
    JLE STEP15
    JMP WARNING                 ;jump if second digit is more than 5, so number entered is more than 25 
    
   
    STEP15:
    MOV  CX,10
    
    repeat1:                    ; loop 10 times
    MOV AX, NUM1                ;copies value of num1 to AX
    ADD input, AX               ;adds value from AX
    loop repeat1
    
    ;DEC CX                     ;decrements the counter
    ;JNZ repeat1                ;loops until counter = 0;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! mlahash lazma
 
    MOV AX, num2                ;adding the value from num2 so if user entered 83, so it was num1=8 num2=3, then we multiplied 8x10=80, so we add 80+3 and we get 83
    
    STEP2:
    ADD input, AX
   
            
        
    STEP25:
    call newLine
    call newline
    call displayFib 
 
    ;mov   ax,4C00h
    ;int   21h                  ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
    
    
 
main endp
  ;==========================================================================================================================================
 
newLine proc                    ;procedure displays new line
 
    mov dx,0Dh                  ;CARRIAGE RETURN, reset position to the beginning of a line of text    
    mov ah,2
    int 21h  
    mov dx,0Ah                  ;LINE FEED, goes into a new line         
    mov ah,2
    int 21h
    ret
 
newLine endp
 
 
keyin proc                      ; getting a key from the keyboard
 
    mov ah, 1                   ;input code  
    int 21h           
    ret
 
keyin endp 
;===========================================================================================================================================
 
displayFib proc
 
    ;display zero
    MOV DX, 30h                 ; move value 30 hexadecimal to DX, which represents 0
    call display
    MOV AX, input   
    CMP AX, 1                   ;if the input is 1 in hexadecimal ASCII value then jump to finish
    JE finish_it
 
    mov   ah,9                  
    mov   dx,offset msg2        ; coma
    int   21h       
 
    ;display the 1st term
    MOV DX, 31h                 ; move value 31 hexadecimal to DX, which represents 1
    call display
    CMP input, 2                ;if the input is 2 in hexadecimal ASCII value then jump to finish
    JE finish_it
 
    MOV CX, input               ;intializing counter, knowing that first 2 terms were displayed already
    SUB CX, 2

;=========================================================================================================================================
 
    repeat:
 
        mov   ah,9              
        mov   dx,offset msg2    ; coma
        int   21h       
 
        MOV AX, fib_num2        ; calculating the n'th term of a sequence    n = (n-1) + (n-2) 
        ADD AX, fib_num1
        MOV fibo, AX
        MOV DX, fibo
 
        PUSH CX                 ;saving the state of the counter as it will be modified in the displayNum
        call displayNum         ;display the n'th term (current term)
 
        POP CX                  ;restoring state of the counter
        MOV AX, fib_num1        ; n-1 in the next round of a loop will be n-2
        MOV fib_num2, AX
        MOV AX, fibo            ;n'th term in the next round will be n-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        MOV fib_num1, AX
        DEC  CX                 ;decrementing counter
 
        JNZ repeat              ; loop until counter = 0
 
 ;======================================================================================================================================
 
    finish_it:
 
 
    xor cx,cx
    xor ax,ax
    xor dx,dx
    xor ah,ah ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    xor al,al ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    xor bl,bl
    mov num1,0
    mov num2,0
    mov input,0
    mov fib_num1,1
    mov fib_num2,0
    mov fibo,0
    mov temp,0
    mov savecount,0
    JMP BEGIN
    
displayFib endp
;====================================================================================================================================
 
 
displayNum proc                 ;display numbers including these with more than one digit
 
    MOV AX, fibo                ;copying fibo to temp
    MOV temp, AX
    MOV CX,0                    ;initializing counter to 0
 
    loop1:                      ;dividng fib by 10 and pushing reminder on the stock
        
        INC CX                  ;incrementing counter
        MOV ax, temp
        MOV bx, 10
        SUB dx, dx              ;set dx to zero
        DIV bx                  ;BX will contain integer division result and DX remainder
        PUSH DX
        MOV temp, AX            ;temp will hold value of integer devided by 10
        TEST AX,AX              ;if AX !=zero, continue the loop
        JNZ loop1
 
    loop2:
 
        POP DX
        ADD DX, 30h
        call display
        DEC CX 
        JNZ loop2               ;loop until all digits on stack are popped and counter =0
    ret
   
displayNum endp 

;=================================================================================================================================
 
 
display proc                    ; display of a single character
 
    mov ah, 6;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! WHY 6 NOT 2!
    int 21h
    ret
 
display endp
 
ENDIT: 
end  main
