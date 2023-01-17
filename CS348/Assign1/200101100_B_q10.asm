;-------------------;
; By:   UJWAL KUMAR ;
;       200101100   ;
;-------------------------------------------------------------------;
; Instruction to assemble and run:                                  ;
;   $ nasm -felf64 200101100_B_q10.asm                   (Assemble) ;
;   $ gcc 200101100_B_q10.o -no-pie -o 200101100_B_q10   (Link)     ;
;   $ ./200101100_B_q10                                  (run)      ;
;-------------------------------------------------------------------;

section .data                                               
    ; Declaration of initialized variables
    ; Strings for printf to print
    nk_msg      db      'Enter n and k: ',0
    arr_msg     db      'Enter your array of size %d:',10,0
    
    ; Format specifiers for printf and scanf
    flt_fmt     db      '%f',0
    nk_fmt      db      '%d %d',0
    el_fmt      db      '%f',0
    el_out_fmt  db      '%f ',0
    result_msg  db      'The kth(k = %d) largest element is : %f',10,0


section .bss
    ; Declaration of uninitialized variables
    n           resd    1       ; Size of the array
    k           resd    1       ; Self explanatory
    arr         resq    1       ; Starting address of the array

section .text
    default REL     ; Use relative addressing by default
    extern printf   ; Use printf from the C library 
    extern scanf    ; Use scanf from the C library

    ;--------------------------;
    ; main function for gcc    ;
    ;--------------------------;
    global main
    main:
        push    rbx                         ; Align with 16 byte boundary on 
                                            ; the stack according to linux
                                            ; calling conventions
                                            
        xor     rax, rax                    ; 0 vector arguments for printf
        .ask_nk: ; Ask for n and k
            mov     rdi, nk_msg             ;
            call    printf
        
        .input_nk: ; Input n and k
            mov     rdi, nk_fmt
            mov     rsi, n
            mov     rdx, k 
            call    scanf
        
        .allocate_arr: ; Allocate array of 4*n bytes on the stack
            xor     rdx, rdx                ; Zero the registers to prevent
            xor     rcx, rcx                ; bugs during subtraction from rsp

            push    rbp                     ; Save old rbp on stack
            mov     rbp, rsp                ; Make new rbp point to old rbp

            mov     ecx, [n]                ; Store a copy of n in rcx
            shl     rcx, 2                  ; Shift left by 2 to obtain 4n

            sub     rsp, rcx                ; Move stack pointer down by 4n bytes
                                            ; to allocate n new elements for array
            
            mov     r13, rsp                ; Store value of first index of array in r13

            shr     rsp, 4                  ; Align rsp with 16 byte boundary
            shl     rsp, 4                  ; Otherwise we get a segmentation fault

        .ask_arr: ; Ask for array of size n
            mov     rdi, arr_msg
            mov     rsi, [n]
            call    printf
    

        xor     r12, r12                ; Zero r12 to later use it as counter
        mov     ebx, [n]                ; Move n into rbx
        ; At this point these are the callee saved registers
        ; r12 = counter/index
        ; r13 = start index of arr
        ; rbx = n
        .input_arr:
            mov     rdi, el_fmt             ; arg1 for scanf
            lea     rsi, [r13 + 4*r12]      ; arg2 for scanf
            call    scanf                   ; call scanf to read element
            inc     r12d                    ; increment counter
            cmp     r12d, ebx               ; Check if counter is < n
            jl      .input_arr
            

        xor     r12, r12                ; Zero r12 to later use it as counter
        inc     r12                     ; Start i from 1
        mov     ebx, [n]                ; Move n into rbx
        ; At this point these are the callee saved registers
        ; r12 = counter/index i
        ; r13 = start index of arr
        ; rbx = n
        ; r14 = index j
        ; xmm0 = key
        ; xmm1 = mov register
        .insertion_sort:
            movss   xmm0, [r13 + 4*r12]     ; The key is put in xmm0
            mov     r14, r12                ; 
            dec     r14                     ; Set j = i - 1;
                .while:
                    ucomiss     xmm0, [r13 + 4*r14]
                    jae         .outwhile
                    cmp         r14, 0
                    jl          .outwhile
                    movss       xmm1, [r13 + 4*r14]
                    movss       [r13 + 4*r14 + 4], xmm1
                    dec         r14
                    jmp         .while
                .outwhile:
                
            movss   [r13 + 4*r14 + 4], xmm0 ; arr[j+1] = key
            inc     r12d                    ; increment counter
            cmp     r12d, ebx               ; Check if counter is < n
            jl      .insertion_sort

        xor     r12, r12                ; Zero r12 to later use it as counter
        mov     ebx, [n]                ; Move n into rbx

        ; Debug method to output arr
        ; .output_arr:
        ;     mov     rdi, el_out_fmt         ; arg1 for printf
        ;     movss   xmm0, [r13 + 4*r12]     ; 1st float arg for printf
        ; cvtss2sd    xmm0, xmm0              ; Necessary step to use printf
        ;     call    printf                  ; call scanf to read element
        ;     inc     r12d                    ; increment counter
        ;     cmp     r12d, ebx               ; Check if counter is < n
        ;     jl      .output_arr

        .print_k_el:
            mov     r12d, [n]               ; Move value of n into r12
            sub     r12d, [k]               ; Subtract k from n to get n - k in r12
            movss   xmm0, [r13 + 4*r12]     ; Move value of arr[n-k] to xmm0
        cvtss2sd    xmm0, xmm0              ; Necessary step to use printf
            mov     rdi, result_msg         ; 1st argument for printf
            mov     rsi, [k]                ; 2nd argument for printf    
            call    printf    

        .restore_stack: ; Deallocate array and restore rsp and rbp
            mov     rsp, rbp
            pop     rbp

        pop     rbx                         ; pop the earlier register we pushed to
                                            ; align with the 16-bit boundary
                                            
        ret                                 ; return from main into the c _start code
