; multi-segment executable file template.

data segment
    ; add your data here!
    s dw ? ; declaring a variable s (sum)
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
    mov s, 0d
    input_loop:
    mov ah, 1d
    int 21h
    cmp al, 35d
    je end_of_input ; if it is # then go to the end
    sub al, 48d
    mov ah, 0d
    mov cx, ax
    mov dl, 2d 
    div dl
    cmp ah, 0d
    jne input_loop ; it is not an even digit
    add s, cx
    jmp input_loop
                                             
    
    end_of_input:
    mov dx, s ; the sum in dx
    cmp dx, 100d
    jae three_digits
    cmp dx, 10d
    jae two_digits
    jmp one_digit
    
    three_digits: 
    mov ax, dx
    mov dl, 100d
    div dl
    mov cl, ah ; the remainder in ch
    mov dl, al ; the divided number
    add dl, 48d ; ascii conversion
    mov ah, 2d
    int 21h
    ; two digits remaining
    mov ch, 0d
    mov ax, cx
    mov dl, 10d
    div dl
    mov cl, ah ; the remainder again in ch
    mov dl, al ; the divided number
    add dl, 48d ; ascii conversion
    mov ah, 2d
    int 21h
    ; one digit remaining
    mov dl, cl ; the above remainder (the last digit) in dl for printing
    add dl, 48d ; ascii conversion
    mov ah, 2d
    int 21h
    jmp end
    
    two_digits:
    mov ax, dx
    mov dl, 10d
    div dl
    mov ch, ah ; the remainder
    mov dl, al ; the divided number
    add dl, 48d ; ascii conversion
    mov ah, 2d ; printing
    int 21h
    mov dl, ch ; printing the remainder
    add dl, 48d  ; ascii conversion
    mov ah, 2d
    int 21h
    jmp end
    
    one_digit:
    add dl, 48d
    mov ah, 2d
    int 21h

    end:                                      
            
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
