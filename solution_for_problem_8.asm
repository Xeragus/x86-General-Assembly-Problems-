; multi-segment executable file template.

data segment
    ; add your data here!
    array dw 323, 4, 284, 199, 45, 800, 67, 523, 79, 9
    remember_offset dw ?  
    stack_counter dw ?
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
    lea bx, array
    mov cx, 10d
    
    ; search through the array in order to find the first occurence
    ; of a number bigger than 500
    search_through_array:
        ; the 2B element of the array is in dx 
        mov dx, [bx]
        ; we add 2 in the array pointer because we work with dw elements (2B)
        add bx, 2d
        cmp dx, 500d
        jae push_preparation        
        loop search_through_array
          
    push_preparation:   
        ; remember how many elements we searched through
        mov remember_offset, cx
        ; initializing the stack counter as (number of elements - cx (the above loop counter))
        mov stack_counter, 10d
        sub stack_counter, cx
        ; place the stack counter in cx
        mov cx, stack_counter
    
    ; in order to revert the order of the elements
    push_on_stack:  
        mov ax, dx
        push ax  
        mov dx, [bx]
        add bx, 2
        loop push_on_stack:
    
    ; pop the elements from stack and insert them in the array
    pop_and_insert_preparation:            
        ; we stopped here before we jump to push_preparation  
        lea bx, array
        mov ax, remember_offset
        mov cx, 2d
        mul cx
        ; rebasing bx 
        mov bx, ax
        ; bx is rebased, the number of elements to be inserted is in stack_counter
        mov cx, stack_counter 
    
    ; refill the array    
    pop_and_insert:
        pop ax
        mov [bx], ax
        add bx, 2d
        loop pop_and_insert:
        
    ; check the values in the registers
    ; testing code   
    lea bx, array
    mov cx, 10d
    loop_through_array:
        mov dx, [bx]
        add bx, 2d
        loop loop_through_array
    ; end of testing code
        
            
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
