; multi-segment executable file template.

data segment
    ; add your data here!
    even_message db "The digit is even!$"
    odd_message db "The digit is odd!$"
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    
    ; enter the first digit
    mov ah, 1
    int 21h    
    ; move the first digit to ch 
    sub al, 30h
    mov ch, al                  
    
    ; enter the second digit 
    mov ah, 1
    int 21h 
    sub al, 30h
    ; move the second digit to cl
    mov cl, al
    
    ; getting the real two digit number
    ; multiple the first digit with 10
    mov al, 10d
    mul ch
    ; the real two digit number is in cl now
    add cl, al
    
    ; the sum is in cl
    add cl, 16d
    
    ; division in order to get the first digit
    mov al, cl
    mov dl, 10d
    div dl
    ; the result is in al
    ; the remainder is in ah
    ; we need to check the parity of the result so:
    mov dl, 2d
    mov ah, 0d
    div dl
    
    ; now if ah is zero, then we print out "The digit is even"
    cmp ah, 0d
    je print_even
    ; if it is not even we print out "The digit is odd!"
    lea dx, odd_message
    mov ah, 9
    int 21h
    
    print_even:
    lea dx, even_message
    mov ah, 9
    int 21h                          
    
            
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
