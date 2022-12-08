SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
SYS_OPEN equ 5
SYS_CLOSE equ 6
SYS_CREATE equ 8

STDIN equ 2
STDOUT equ 1

%macro open_file 3
    mov eax,SYS_OPEN
    mov ebx, %1
    mov ecx, %2
    int 0x80
    mov [%3],eax
%endmacro

%macro close_file 1
    mov eax,SYS_CLOSE
    mov ebx,[%1]
    int 0x80
%endmacro

%macro read_file 3
    mov eax,SYS_READ
    mov ebx,[%1]
    mov ecx,%2
    mov edx,%3
    int 0x80
%endmacro

%macro print_char 1
    mov eax,SYS_WRITE
    mov ebx,STDOUT
    mov ecx,%1
    mov edx,14
    int 0x80
%endmacro

%macro print_string 2
    mov eax,SYS_WRITE
    mov ebx,STDOUT
    mov ecx,%1
    mov edx,%2
    int 0x80
%endmacro

%macro print_int 1
    PUSHA
    MOV eax, %1
    MOV ebx, 10
    CALL print
    POPA
%endmacro

%macro valid 4
    MOV [%2], byte 1

    MOV eax, %3
    parcours_lettre:
        MOV ebx, %1
        ADD ebx, eax
        MOV dh, byte [ebx]
        MOV [current], dh

        MOV ecx, eax
        INC ecx
        detect_duplique:
            MOV ebx, %1
            ADD ebx, ecx
            MOV dh, byte [ebx]

            CMP dh, [current]
            JNE continue
            MOV [%2], byte 0
            JMP end_loop
            continue:
            INC ecx
            MOV edx, %3
            ADD edx, %4
            CMP ecx, edx
            JL detect_duplique

        INC eax
        MOV edx, %3
        ADD edx, %4
        SUB edx, 1
        CMP eax, edx
        JL parcours_lettre
    end_loop:
%endmacro

%macro add_imm 2
    PUSHA
    MOV eax, [%1]
    ADD eax, %2
    MOV [%1], eax 
    POPA
%endmacro

section	.text
   global _start   
	
_start:	            
    open_file filename, 0, fd

    read_file fd, chars, 4096

    MOV [count], word 0

    main_loop:
        valid chars, comp, [count],14
        MOV bh, 0
        CMP bh, [comp]
        JNE result

        MOV ecx, [count]
        INC ecx
        MOV [count], ecx

        JMP main_loop
        
    result:
    close_file fd

    add_imm count, 14
    print_int [count]
    

end:	
    MOV	eax,1   ; System calls sys_exit
    MOV ebx,0   ; sys_exit error code
    INT	0x80

print:
mov ecx, esp
sub esp, 36   ; reserve space for the number string, for base-2 it takes 33 bytes with new line, aligned by 4 bytes it takes 36 bytes.

mov edi, 1
dec ecx
mov [ecx], byte 10

print_loop:

xor edx, edx
div ebx
cmp dl, 9     ; if reminder>9 go to use_letter
jg use_letter

add dl, '0'
jmp after_use_letter

use_letter:
add dl, 'W'   ; letters from 'a' to ... in ascii code

after_use_letter:
dec ecx
inc edi
mov [ecx],dl
test eax, eax
jnz print_loop

; system call to print, ecx is a pointer on the string
mov eax, 4    ; system call number (sys_write)
mov ebx, 1    ; file descriptor (stdout)
mov edx, edi  ; length of the string
int 0x80

add esp, 36   ; release space for the number string

ret


section .bss
    fd RESD 1
    chars RESB 4096
    current RESB 1
    comp RESB 1
    res RESW 1
    count RESW 1
    carry RESB 1

section	.data
    msg DB '', 10, 0
    len equ $ - msg
    filename DB 'input.txt'