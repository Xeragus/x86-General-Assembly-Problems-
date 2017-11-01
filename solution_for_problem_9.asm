; multi-segment executable file template.

data segment
    ; add your data here!
    number dw ?
    difference dw ?
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment 
    
    save_sequence proc
        mov bx, 30h
        mov cx, 15d
        mov dx, 1d
        mov difference, 0d
        
        push_on_stack:      
            add dx, difference 
            inc difference
            mov ax, dx
            push ax
            loop push_on_stack
        
        ; reset cx
        mov cx, 15d   
        reverse_loop:
            pop ax
            mov [bx], ax
            add bx, 2d
            loop reverse_loop
            
        ret
    save_sequence endp
    
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    call save_sequence
            
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
