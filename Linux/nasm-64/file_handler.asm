%include 'lib_string.asm'
%include 'lib_file.asm'
%include 'lib_general.asm'

SECTION .data
file_1 db 'test.txt', 0h
content_1 db 'Hello File World!', 0h

SECTION .bss
file_content_1: resb 64

SECTION .text
global _start

_start:
    ; allocate stack space
    sub rsp, 16
    ; get content length
    mov rdi, content_1
    call st_len
    ; save content length in stack
    mov [rsp + 8], rax

    ; file creation
    ; -------------
    ; use 666 mode
    mov rsi, 0666o
    mov rdi, file_1
    call f_create
    ; save file descriptor in stack
    mov [rsp], rax
    ; close file
    mov rdi, [rsp]
    call f_close

    ; file write
    ; ----------
    mov rdx, 2
    mov rsi, 2
    mov rdi, file_1
    call f_open
    ; save file descriptor in stack
    mov [rsp], rax
    ; use file descriptor to write message
    mov rdx, [rsp + 8]
    mov rsi, content_1
    mov rdi, [rsp]
    call f_write
    ; close file
    mov rdi, [rsp]
    call f_close

    ; file read
    ; ---------
    mov rdx, 2
    mov rsi, 2
    mov rdi, file_1
    call f_open
    ; save file descriptor in stack
    mov [rsp], rax
    ; read file content
    mov rdx, [rsp + 8]
    mov rsi, file_content_1
    mov rdi, [rsp]
    call f_read
    ; print file content
    mov rdx, [rsp + 8]
    mov rsi, file_content_1
    call st_print_len
    call st_print_new_line
    ; close file
    mov rdi, [rsp]
    call f_close
    
    ; file deletion
    ; -------------
    mov rdi, file_1
    call f_delete

    ; release stack space
    add rsp, 16
    ; exit
    call exit_0