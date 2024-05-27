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
    call i_fibo
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
i_fibo:
    xor r8, r8
    mov rax, 0
    mov r9, 1

    .do:
    cmp r8, rdi
    jge .end
    inc r8
    xadd rax, r9
    jmp .do

    .end:
    ret

