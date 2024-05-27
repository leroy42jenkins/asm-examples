; file CRUD routines
; ------------------

; rsi: int mode (example: 0777o)
; rdi: string file name
f_create:
    ; invoke SYS_CREAT
    mov rax, 85
    syscall
    ret

; rdx: int mode (0: read, 1: write, 2: read | write)
; rsi: int flags
; rdi: string file name
f_open:
    ; invoke SYS_OPEN
    mov rax, 2
    syscall
    ret

; rdi: int file descriptor
f_close:
    ; invoke SYS_WRITE
    mov rax, 3
    syscall
    ret

; rdx: int count
; rsi: string destination
; rdi: int file descriptor
f_read:
    ; invoke SYS_READ
    mov rax, 0
    syscall
    ret

; rdx: int count
; rsi: string source
; rdi: int file descriptor
f_write:
    ; invoke SYS_WRITE
    mov rax, 1
    syscall
    ret

; rdi: string pointer
f_delete:
    ; invoke SYS_UNLINK
    mov rax, 87
    syscall
    ret