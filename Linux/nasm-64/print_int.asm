%include 'lib_string.asm'
%include 'lib_general.asm'

SECTION .data
string_source_1 db '12345', 0h
string_source_2 db '-12345', 0h
string_source_3 db '987654321', 0h
string_source_4 db '-987654321', 0h

SECTION .bss
string_destination_1: resb 64
string_destination_2: resb 64
string_destination_3: resb 64
string_destination_4: resb 64

SECTION .text
global _start

_start:
    mov rsi, string_destination_1
    mov rdi, string_source_1
    call print_int
    mov rsi, string_destination_2
    mov rdi, string_source_2
    call print_int
    mov rsi, string_destination_3
    mov rdi, string_source_3
    call print_int
    mov rsi, string_destination_4
    mov rdi, string_source_4
    call print_int
    
    call exit_0

; rsi: string destination
; rdi: string source
print_int:
    sub rsp, 16
    mov [rsp], rdi
    mov [rsp + 8], rsi

    mov rdi, [rsp]
    call st_atoi
    mov rdi, rax
    mov rsi, [rsp + 8]
    call st_itoa
    mov rdi, [rsp + 8]
    call st_print
    call st_print_new_line

    mov rdi, [rsp]
    mov rsi, [rsp + 8]
    add rsp, 16
    ret

