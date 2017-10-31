; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    array db 10 dup (?)
    stack_counter db 0
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:                  
    ; initialize the loop counter with the number of elements (10)
    mov cx, 10d 
    ; base the bx at the start of the array
    lea bx, array     

; Input keys and storing the character in the array declared above
initialize_array_method:
    ; preparation for scanning element from the keyboard
    mov ah, 1h
    ; scanning interrupt
    int 21h 
    ; place the element in the array   
    mov [bx], al
    ; increment the 'array pointer'
    inc bx                         
    ; loop 'cx' number of times (10)
    loop initialize_array_method
    
; testing the element by it's ascii value if it is a digit or a letter
digit_or_letter_tester:
    ; reseting the loop counter to 10 - it is 0 because of the array initialization loop
    mov cx, 10d 
    ; moving back the 'array pointer' to it's initial location - the first element in the array
    lea bx, array      
    ; we place the first element of the array in al
    mov al, [bx]
    ; increment bx - we are taking the next element
    inc bx     
    ; testing the character by it's ascii value
    ; if it is bigger than 'Z'
    cmp al, 90d
    ; if it is then just take the next element
    jg next_element
    ; checking if it is big letter 
    cmp al, 65d
    jge first_letter
    ; checking if it is smaller than 1 
    cmp al, 48d
    jl next_element
    ; checking if it is larger than 1 
    cmp al, 57d
    jg next_element
    ; it is a digit
    jmp digit
; taking the next element and decreasing the loop counter - one iteration is completed                                                                                                                                                      
next_element:    
    dec cx                              

; testing for digits
digit_tester:
    mov al, [bx] 
    cmp al, 48d  
    jl local_end_increment  
    cmp al, 57d 
    jg local_end_increment  
    jmp digit
    
local_end_increment:
        inc bx
        loop digit_tester

; after the analyzing loops    
jmp stack_manipulation  

; if the first element is uppercase letter
first_letter:
    inc stack_counter 
    mov ah, 0d
    push ax          
    inc bx           
    jmp next_element 

; uppercase letter handler
uppercase_letter:
    inc stack_counter  
    mov ah, 0d
    push ax          
    dec cx           
    inc bx           
    jmp digit_tester   

; if it is a digit                           
digit:    
    dec cx     
    inc bx                     
    mov al, [bx] 
    ; testing for 'Z'
    cmp al, 90d
    jg digit_tester
    ; testing for 'A'
    cmp al, 65d
    jl digit_tester      
    ; it is an uppercase letter
    jmp uppercase_letter                                      
    
stack_manipulation:
; rebase the bx at the beginning of the array     
lea bx, array 
; it will take 10 loops to initialize the array 
mov cx, 10d 
mov al, 0d

; null array initializator, we will need it for the valid elements currently on stack   
initialize_null:  
    mov [bx], al
    inc bx
    loop initialize_null
    
    ; manipulation with ah and al in order to get one 16-bit register     
    mov ah, 0d
    mov al, stack_counter
    ; cx will be the number of elements previously put on stack
    mov cx, ax
    ; rebasing bx to the first element of the array, needed by stack_to_array_loop
    lea bx, array

; take the element from stack and insert them to the array
; the stategy is to double push them on stack so we can get the array in the initial order
stack_to_array_loop:  ;Od stek gi vadi site elementi i gi stava vo nizata
    pop ax
    mov [bx], al
    inc bx
    loop stack_to_array_loop
                                    
; rebasing bx again                               
lea bx, array
mov al, stack_counter
mov ah, 0d
mov cx, ax

; again the same   
second_push_on_stack:
    mov al, [bx]
    mov ah, 0d
    push ax
    inc bx    
    loop second_push_on_stack

mov ah, 0d    
mov al, stack_counter
; setting the loop counter to the number of elements put on stack
mov cx, ax 
; rebasing for bx needed by second_stack_to_array_loop
lea bx, array
             
; popping the elements second time in order to put the array in the initial order             
second_stack_to_array_loop:
    pop ax
    mov [bx], ax
    inc bx   
    loop second_stack_to_array_loop                               
    
    ;Your code here
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
