; multi-segment executable file template.

data segment
    ; add your data here!
    ; declaring and initializing the matrix
    ; the elements are dw because they can be
    ; a number up to 999 
    matrix dw 5, 144, 423, 23, 9, 18, 22, 557, 95
    i db ? ; index of rows
    j db ? ; index of columns
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
    
    lea bx, matrix
    
    input_keys:
        ; enter the first key
        mov ah, 1h
        int 21h
        cmp al, 035d ; if the key is #
        je end
        mov ch, al 
        ; getting the real number
        ; minus 1 because of the matrix
        ; representation [0,2]
        sub ch, 49d
        ; enter the second key
        mov ah, 1h
        int 21h
        cmp al, 035d ; if the key is #
        je end 
        mov cl, al
        ; getting the real number
        ; minus 1 because of the matrix
        ; representation [0,2]
        sub cl, 49d
        
    matrix_analysis:
        mov dl, cl ; column number in dl
        mov cl, ch ; 16-bit to 16-bit
        mov ch, 0d  ; 16-bit to 16-bit
        mov ax, cx ; the row number
        mov dh, 3d
        mul dh ; now in ax we have row_index*row_size
        mov cl, dl ; column number in cl
        mov ch, 0d
        add ax, cx ; now in ax we have row_index*row_size + column_index
        mov dl, 2d
        mul dl
        add bx, ax
        ; now we have the index of the element in bx
        mov cx, matrix[bx]
        cmp cx, 100d
        jae three_digits
        cmp cx, 10d
        jae two_digits
        mov matrix[bx], 1
        jmp input_keys
    
    ; if the number is a three digit number    
    three_digits:
        mov matrix[bx], 3
        jmp input_keys
    
    ; if the number is a two digit number
    two_digits:
        mov matrix[bx], 2
        jmp input_keys
        
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
