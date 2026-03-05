; below are external references
; we tell nasm that these are external functions 
; that we are going to link in later using gcc
extern printf
extern exit

; TODO: use read syscall (eax=3) or scanf to ask for input

section .data
	; CHANGE THE LIST HERE
    list      DB 5,8,3,7,1,2,9,4,0 ; 0 is the null terminator
    fmt_sweep DB "Sweep %d: ",0
    fmt_num   DB "%d ",0
    fmt_nl    DB 10,0 ; newline

section .bss
    length   RESD 1 ; list length
    sweep_cnt RESD 1 ; curr sweep number

section .text
global main

main:
    MOV esi, list
    
    MOV ecx,0 ; index for counting list length

count_loop:
    MOV al, byte [esi+ecx]
    CMP al,0
    JZ count_done
    INC ecx
    JMP count_loop

count_done:
    MOV [length],ecx
    MOV dword [sweep_cnt], 1

outer_loop:
    MOV eax,[sweep_cnt]
    CMP eax,[length]
    JG all_done ; it ran n times

    MOV edi, 0 ; index for sorting, reset afer each sweep
    CALL sorting_loop

    PUSH dword [sweep_cnt]
    PUSH fmt_sweep
    CALL printf
    ADD esp,8 ; clean stack (sweep_cnt, fmt_sweep)

    MOV ebx,0 ; index for printing
    CALL print_loop

    PUSH fmt_nl
    CALL printf
    ADD esp,4 ; clean stack (fmt_nl)

    INC dword [sweep_cnt]
    JMP outer_loop

all_done:
    PUSH 0
    CALL exit ; exit(0)

sorting_loop:
    MOV cl, byte [esi+edi]
    MOV dl, byte [esi+edi+1]
    CMP dl,0
    JE sorting_done
    CMP cl, dl
    JBE no_swap
    CALL swap
    INC edi
    JMP sorting_loop

no_swap:
    INC edi
    JMP sorting_loop

swap:
    MOV ah, byte [esi+edi+1]
    MOV bh, byte [esi+edi]
    MOV byte [esi+edi], ah
    MOV byte [esi+edi+1], bh
    RET

sorting_done:
    RET

print_loop:
    MOVZX eax, byte [esi+ebx]
    CMP al,0
    JZ print_done
    PUSH eax
    PUSH fmt_num
    CALL printf
    ADD esp,8 ; clean stack (eax, fmt_num)
    INC ebx
    JMP print_loop

print_done:
    RET
