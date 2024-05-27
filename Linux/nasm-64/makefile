i-fibo:
	nasm -f elf64 -o i_fibo.o i_fibo.asm && \
	ld -o i_fibo.out i_fibo.o && rm i_fibo.o

r-fibo:
	nasm -f elf64 -o r_fibo.o r_fibo.asm && \
	ld -o r_fibo.out r_fibo.o && rm r_fibo.o

print-args:
	nasm -f elf64 -o print_args.o print_args.asm && \
	ld -o print_args.out print_args.o && rm print_args.o

print-int:
	nasm -f elf64 -o print_int.o print_int.asm && \
	ld -o print_int.out print_int.o && rm print_int.o

hello-user:
	nasm -f elf64 -o hello_user.o hello_user.asm && \
	ld -o hello_user.out hello_user.o && rm hello_user.o

file-handler:
	nasm -f elf64 -o file_handler.o file_handler.asm && \
	ld -o file_handler.out file_handler.o && rm file_handler.o

clean:
	rm *.out