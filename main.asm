; =========================================================================
; Student Record System - x86 32-bit Linux NASM Assembly
; Compatible with 32-bit ELF Mode (nasm -f elf / int 0x80)
; Features: Add Student, View All Records, Display Summary & Exit
; =========================================================================

section .data
    menu_msg    db 10, "=== STUDENT RECORD SYSTEM (32-BIT ASSEMBLY) ===", 10
                db "1. Add Student Record", 10
                db "2. View All Student Records", 10
                db "3. Exit System", 10
                db "Enter Choice (1-3): ", 0
    menu_len    equ $ - menu_msg

    prompt_id   db 10, "Enter Student ID (e.g. 101): ", 0
    pid_len     equ $ - prompt_id

    prompt_name db "Enter Student Name: ", 0
    pname_len   equ $ - prompt_name

    prompt_gpa  db "Enter GPA (e.g. 3.8): ", 0
    pgpa_len    equ $ - prompt_gpa

    msg_added   db 10, "[+] Student record added successfully to memory!", 10, 0
    added_len   equ $ - msg_added

    msg_header  db 10, "--- ID --- | --- NAME --- | - GPA -", 10, 0
    hdr_len     equ $ - msg_header

    msg_empty   db 10, "[-] No student records found in memory.", 10, 0
    empty_len   equ $ - msg_empty

    msg_exit    db 10, "[+] Exiting system... Goodbye!", 10, 0
    exit_len    equ $ - msg_exit

    invalid_msg db 10, "[-] Invalid choice! Please select 1, 2, or 3.", 10, 0
    inv_len     equ $ - invalid_msg

    pipe_sep    db " | ", 0
    pipe_len    equ $ - pipe_sep

    MAX_RECORDS equ 5
    REC_SIZE    equ 32          ; 8 bytes ID + 16 bytes Name + 8 bytes GPA = 32 bytes

section .bss
    choice      resb 2
    rec_count   resb 1
    student_db  resb MAX_RECORDS * REC_SIZE
    
    input_id    resb 8
    input_name  resb 16
    input_gpa   resb 8

section .text
    global _start

_start:
    mov byte [rec_count], 0     ; Initialize record count to 0

menu_loop:
    ; Display Menu (sys_write = 4)
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, menu_msg
    mov edx, menu_len
    int 0x80

    ; Read Menu Choice (sys_read = 3)
    mov eax, 3                  ; sys_read
    mov ebx, 0                  ; stdin
    mov ecx, choice
    mov edx, 2                  ; Read char + newline
    int 0x80

    mov al, [choice]
    cmp al, '1'
    je add_student
    cmp al, '2'
    je view_students
    cmp al, '3'
    je exit_app

    ; Handle Invalid Input
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, inv_len
    int 0x80
    jmp menu_loop

; -------------------------------------------------------------------------
; FEATURE 1: ADD STUDENT RECORD
; -------------------------------------------------------------------------
add_student:
    mov al, [rec_count]
    cmp al, MAX_RECORDS
    jae menu_loop

    ; Calculate memory offset: student_db + (rec_count * REC_SIZE)
    movzx eax, byte [rec_count]
    imul eax, REC_SIZE
    mov edi, student_db
    add edi, eax                ; edi points to current record slot

    ; 1. Get ID
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_id
    mov edx, pid_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_id
    mov edx, 8
    int 0x80
    
    ; Copy ID to database buffer
    push edi
    mov esi, input_id
    mov ecx, 8
    rep movsb
    pop edi

    ; 2. Get Name
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_name
    mov edx, pname_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_name
    mov edx, 16
    int 0x80

    ; Copy Name to database buffer
    push edi
    add edi, 8
    mov esi, input_name
    mov ecx, 16
    rep movsb
    pop edi

    ; 3. Get GPA
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_gpa
    mov edx, pgpa_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_gpa
    mov edx, 8
    int 0x80

    ; Copy GPA to database buffer
    push edi
    add edi, 24
    mov esi, input_gpa
    mov ecx, 8
    rep movsb
    pop edi

    ; Increment record count
    inc byte [rec_count]

    ; Print Success Message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_added
    mov edx, added_len
    int 0x80
    jmp menu_loop

; -------------------------------------------------------------------------
; FEATURE 2: VIEW ALL STUDENT RECORDS
; -------------------------------------------------------------------------
view_students:
    mov al, [rec_count]
    cmp al, 0
    je empty_db

    ; Print Table Header
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_header
    mov edx, hdr_len
    int 0x80

    movzx esi, byte [rec_count] ; Loop counter
    mov edi, student_db         ; Pointer to student records

print_loop:
    cmp esi, 0
    je menu_loop

    ; Print ID (8 bytes)
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, 8
    int 0x80

    ; Print Pipe Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe_sep
    mov edx, pipe_len
    int 0x80

    ; Print Name (16 bytes)
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    add ecx, 8
    mov edx, 16
    int 0x80

    ; Print Pipe Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe_sep
    mov edx, pipe_len
    int 0x80

    ; Print GPA (8 bytes)
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    add ecx, 24
    mov edx, 8
    int 0x80

    add edi, REC_SIZE           ; Move pointer to next record
    dec esi                     ; Decrement loop count
    jmp print_loop

empty_db:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_empty
    mov edx, empty_len
    int 0x80
    jmp menu_loop

; -------------------------------------------------------------------------
; EXIT SYSTEM
; -------------------------------------------------------------------------
exit_app:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_exit
    mov edx, exit_len
    int 0x80

    ; Terminate Process (sys_exit = 1)
    mov eax, 1
    xor ebx, ebx
    int 0x80