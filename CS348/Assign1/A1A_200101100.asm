;-------------------;
; By:   UJWAL KUMAR ;
;       200101100   ;
;-------------------------------------------------------------------;
; Instruction to assemble and run:                                  ;
;   $ nasm -felf64 A1A_200101100.asm                    (Assemble)  ;
;   $ gcc A1A_200101100.o -no-pie -o A1A_200101100      (Link)      ;
;   $ ./A1A_200101100                                   (run)       ;
;-------------------------------------------------------------------;

section .data                                               
    ; Declaration of initialized variables
    ; Strings for printf to print
    op_msg      db      '(+ : 1)',10
                db      '(- : 2)',10
                db      '(* : 3)',10
                db      '(/ : 4)',10
                db      'Enter an operation: ',0
    float_msg   db      'Enter the two floats a and b: ',0
    result_msg  db      'The result of your operation is: %f',10,0
    
    ; Format specifiers for scanf
    flt_fmt     db      '%f %f',0
    op_fmt      db      '%d',0


section .bss
    ; Declaration of uninitialized variables
    f1          resd    1
    f2          resd    1
    res         resd    1
    op          resd    1

section .text

    ; --------------------------------------;
    ;   Function to calulate the result of  ;
    ;   two floating point numbers          ;
    ;                                       ;
    ;   arg0 : num1 in xmm0                 ;
    ;   arg1 : num2 in xmm1                 ;
    ;   arg2 : op (1,2,3,4) in rdi          ;
    ; --------------------------------------;
    global calculate
    calculate:

        switch: ; A switch statement analog to check the op (rdi)
        .add: ; CASE 1
            cmp     rdi, 1
            jne     .sub            ; Jump to next case if not true
            addss   xmm0, xmm1      ; xmm0 = xmm0 + xmm1
            jmp     .break
            
        .sub: ; CASE 2
            cmp     rdi, 2
            jne     .mul            ; Jump to next case if not true
            subss   xmm0, xmm1      ; xmm0 = xmm0 - xmm1
            jmp     .break
            
        .mul: ; CASE 3
            cmp     rdi, 3
            jne     .div            ; Jump to next case if not true
            mulss   xmm0, xmm1      ; xmm0 = xmm0 * xmm1
            jmp    .break
            
        .div: ; CASE 4
            cmp     rdi, 4
            jne     .break          ; Jump to break if not true
            divss   xmm0, xmm1      ; xmm0 = xmm0 / xmm1
            jmp     .break
            
        .break: ; BREAK
            ret                     ; Return from the function
     
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
        
        .ask_op:  ; Ask for user operation
            mov     rdi, op_msg             ; arg1 for printf
            call    printf                  ; call printf

        .input_op: ; Input user operation
            mov     rdi, op_fmt             ; arg0 for scanf
            mov     rsi, op                 ; arg1 for scanf
            call    scanf                   ; call scanf

        .ask_floats: ; Ask for user floats
            mov     rdi, float_msg          ; arg0 for printf
            call    printf                  ; call printf to display float_msg

        .input_floats: ; Input user floats
            mov     rdi, flt_fmt            ; arg0 for scanf
            mov     rsi, f1                 ; arg1 for scanf
            mov     rdx, f2                 ; arg2 for scanf
            call    scanf                   ; call scanf to input f1, f2

        .call_calculate: ; Calls function calculate with the obtained values
            movss   xmm0, dword [f1]        ; move argument f1 into xmm0 (arg0)
            movss   xmm1, dword [f2]        ; move argument f2 into xmm1 (arg1)
            mov     rdi, [op]               ; move argument op into rdi (arg2)
            call    calculate               ; call function calculate defined above

        .show_result: ; Print the results of calculate
            mov     rdi, result_msg         ; arg0 for printf
        cvtss2sd    xmm0, xmm0              ; convert xmm0 to double for printf to work
            call    printf                  ; print result_msg with xmm0 as arg0

        pop     rbx                         ; pop the earlier register we pushed to
                                            ; align with the 16-bit boundary

        ret                                 ; return from main into the c _start code
