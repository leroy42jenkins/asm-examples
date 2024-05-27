; string conversion routines
; --------------------------

; rsi: string destination
; rdi: int
st_itoa:
    ; use 0 for non-negative
    mov r8, 0
    ; set counter to 0
    mov r9, 0
    ; determine sign
    cmp rdi, 0
    jge .sign_is_checked
    ; incomplete ...
    imul rdi, rdi, -1
    ; use -1 for negative
    mov r8, -1
    .sign_is_checked:
    ; put target number in rax
    mov rax, rdi

    .convert:
    ; set rdx:rax to int
    cqo
    ; set divisor
    mov r10, 10
    idiv r10
    ; add 48 to remainder for ASCII
    add rdx, 48
    ; push onto stack
    push rdx
    inc r9
    cmp rax, 0
    jg .convert

    ; character counter
    xor rax, rax

    ; account for sign
    cmp r8, 0
    jz .copy_digits
    xor r10, r10
    mov r10b, '-'
    mov [rsi], r10b
    inc rax

    .copy_digits:
    xor r10, r10
    mov r10b, [rsp]
    mov [rsi + rax], r10b
    inc rax
    pop r10
    dec r9
    cmp r9, 0
    jg .copy_digits

    ; finish with null terminator
    xor r10, r10
    mov r10b, 0h
    mov [rsi + rax], r10b
    inc rax

    ; return number of characters in rax
    ret

; rdi: string source
st_atoi:
    ; allocate stack space
    sub rsp, 16
    ; assume sign is positive
    xor r9, r9
    mov [rsp], r9

    ; start with 0 in r11 as index
    xor r11, r11
    ; determine sign
    mov r9b, [rdi]
    cmp r9, '-'
    jnz .sign_is_checked
    ; skip sign
    inc r11
    mov [rsp], r11
    .sign_is_checked:

    ; use string length as counter
    call st_len
    ; store length in r9
    mov r9, rax
    
    ; start with 0 in rax
    xor rax, rax
    
    .convert:
    cmp r11, r9
    jge .end
    xor r10, r10
    mov r10b, [rdi + r11]
    ; subtract 48 to get corresponding int
    sub r10b, 48
    imul rax, rax, 10
    add rax, r10
    inc r11
    jmp .convert

    .end:
    mov r9, [rsp]
    ; if necessary, perform sign conversion
    cmp r9, 0
    jz .sign_is_correct
    imul rax, rax, -1
    .sign_is_correct:
    ; release stack space
    add rsp, 16
    ; return number in rax
    ret


; string printing routines
; ------------------------

; string constants
st_new_line_char db 0Ah
st_dash_char db '-'

st_print_new_line:
    mov rdx, 1
    mov rsi, st_new_line_char
    call st_print_len
    ret

; rdi: string source
st_print_line:
    call st_print
    mov rdx, 1
    mov rsi, st_new_line_char
    call st_print_len
    ret

; rdi: string source
st_print:
    ; allocate space in the stack frame
    sub rsp, 16
    ; save rdi in stack frame
    mov [rsp], rdi
    call st_len
    mov rdx, rax
    ; get rsi from stack frame
    mov rsi, [rsp]
    call st_print_len
    ; release space in the stack frame
    add rsp, 16
    ret

; rdi: int
st_print_int:
    ; determine sign
    cmp rdi, 0
    jge .sign_is_correct
    mov r10, rdi
    mov rdx, 1
    mov rsi, st_dash_char
    call st_print_len
    mov rdi, r10
    imul rdi, rdi, -1
    .sign_is_correct:

    ; set counter to 0
    mov r9, 0
    ; put target number in rax
    mov rax, rdi

    .divide:
    ; set rdx:rax to int
    cqo
    ; set divisor
    mov r8, 10
    idiv r8
    ; add 48 to remainder for ASCII
    add rdx, 48
    ; push onto stack
    push rdx
    inc r9
    cmp rax, 0
    jnz .divide

    .print:
    cmp r9, 0
    jz .end
    dec r9
    mov rdx, 1
    mov rsi, rsp
    call st_print_len
    pop rsi
    jmp .print

    .end:
    ret

; rdi: string source
st_len:
    mov rax, rdi
    .next_byte:
    cmp byte [rax], 0
    jz .finished
    inc rax
    jmp .next_byte
    .finished:
    sub rax, rdi
    ret

; rdx: string length
; rsi: string source
st_print_len:
    ; write to STDOUT
    mov rdi, 1
    ; invoke SYS_WRITE
    mov rax, 1
    syscall
    ret


; string reading routines
; -----------------------

; rdx: string length
; rsi: string destination
st_read_len:
    ; read from STDIN
    mov rdi, 0
    ; invoke SYS_READ
    mov rax, 0
    syscall
    ret
