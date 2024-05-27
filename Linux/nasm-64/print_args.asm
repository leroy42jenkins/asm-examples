%include 'lib_string.asm'
%include 'lib_general.asm'

SECTION .data
mes_1 db 'arguments:', 0h

SECTION .text
global _start

_start:
    ; stack [0]: number of arguments
    pop r9
    ; stack [1]: name of program
    pop rdi
    ; opening message
    mov rdi, mes_1
    call st_print_line
.args_next:
    cmp r9, 1
    jle .args_finished
    dec r9
    ; stack [i]: argument
    pop rdi
    call st_print_line
    jmp .args_next
.args_finished:
    call exit_0