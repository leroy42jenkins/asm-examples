%include 'lib_string.asm'
%include 'lib_general.asm'

SECTION .data
statement_1 db 'Fibonacci (', 0h
statement_2 db ') = ', 0h
error_1 db 'one and only one positive integer argument must be present', 0h

SECTION .bss
index_1: resb 32

SECTION .text
global _start

_start:
    ; stack [0]: number of arguments
    pop r9
    cmp r9, 2
    jz .get_index_argument
    mov rdi, error_1
    call st_print_line
    jmp .end

    .get_index_argument:
    ; stack [1]: discard name of program
    pop rdi
    ; stack [2]: Fibonacci index string
    mov rdi, [rsp]
    ; test for validity of index
    call is_positive_int
    cmp rax, 0
    jz .valid_arguments
    mov rdi, error_1
    call st_print_line
    jmp .end

    .valid_arguments:
    ; opening message
    mov rdi, statement_1
    call st_print
    mov rdi, [rsp]
    call st_print
    mov rdi, statement_2
    call st_print
    ; convert Fibonacci index string to int
    pop rdi
    call st_atoi
    mov rdi, rax
    call r_fibo
    mov rdi, rax
    call st_print_int
    call st_print_new_line

    .end:
    call exit_0

; rdi: string source
is_positive_int:
    mov rax, 0
    mov r9, 0
    xor r10, r10

    .do:
    mov r10b, [rdi + r9]
    cmp r10b, 0
    jz .end
    cmp r10b, 48
    jl .low
    cmp r10b, 58
    jge .high
    inc r9
    jmp .do

    .low:
    mov rax, -1
    .high:
    mov rax, 1

    .end:
    ret
    
; rdi: Fibonacci index
r_fibo:
    ; allocate stack space
    sub rsp, 16

    ; check for 0 and for negatives
    cmp rdi, 0
    jg .check_for_1
    mov rax, 0
    jmp .end

    .check_for_1:
    cmp rdi, 1
    jg .body
    mov rax, 1
    jmp .end

    .body:
    ; Fibonacci for n - 1
    mov [rsp], rdi
    sub rdi, 1
    call r_fibo
    mov [rsp + 8], rax
    ; Fibonacci for n - 2
    mov rdi, [rsp]
    sub rdi, 2
    call r_fibo
    add rax, [rsp + 8]

    .end:
    ; release stack space
    add rsp, 16
    ret

