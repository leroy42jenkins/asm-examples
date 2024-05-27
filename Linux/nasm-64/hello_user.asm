%include 'lib_string.asm'
%include 'lib_general.asm'

SECTION .data
prompt_1 db 'Enter your name: ', 0h
response_1 db 'Hello, ', 0h

SECTION .bss
input_1: resb 32

SECTION .text
global _start

_start:
    mov rdi, prompt_1
    call st_print
    ; get user name from console
    mov rdx, 48
    mov rsi, input_1
    call st_read_len
    ; respond to user with name
    mov rdi, response_1
    call st_print
    mov rdi, input_1
    call st_print
    call exit_0