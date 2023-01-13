
section .data

    op_msg      db      '(+ : 1)',10
                db      '(- : 2)',10
                db      '(* : 3)',10
                db      '(/ : 4)',10
                db      'Enter an operation: ',0
    float_msg   db      'Enter the two floats a and b: ',0
    result_msg  db      'The result of your operation is: %d',0
    
    flt_fmt     db      '%f %f',0
    op_fmt      db      '%d',0


section .bss
    f1          resd    1
    f2          resd    1
    result      resd    1
    op          resd    1

section .text

    ; --------------------------------------;
    ;   Function to calucalte the result of ;
    ;   two floating point numbers          ;
    ;                                       ;
    ;   arg1 : num1 xmm0                    ;
    ;   arg2 : num2 xmm1                    ;
    ;   arg3 : op (1,2,3,4) rdi            ;
    ; --------------------------------------;
    global calculate
    calculate:

        switch: ; A switch statement analog to check the op (rdi)
        .add: ; CASE 1
            cmp     rdi, 1
            jne     .sub
            addss   xmm0, xmm1      ; xmm0 = xmm0 + xmm1
            jmp     .break
            
        .sub: ; CASE 2
            cmp     rdi, 2
            jne     .mul
            subss   xmm0, xmm1      ; xmm0 = xmm0 - xmm1
            jmp     .break
            
        .mul: ; CASE 3
            cmp     rdi, 3
            jne     .div
            mulss   xmm0, xmm1      ; xmm0 = xmm0 * xmm1
            jmp    .break
            
        .div: ; CASE 4
            cmp     rdi, 4
            jne     .break
            divss   xmm0, xmm1      ; xmm0 = xmm0 / xmm1
            jmp     .break
            
        .break: ; BREAK
            ret                     ; Return from the function


    ;--------------------------;
    ; main function for gcc    ;
    ;--------------------------;
    global main
    default REL
    extern printf
    extern scanf
    
    main:

        ask_op:  ; Ask for user operation
            push    rbx                     ; Align with 16 bit boundary on 
                                            ; the stack according to linux
                                            ; calling conventions
            mov     rax, 0                  ; Number of vector arguments for printf
            mov     rdi, op_msg             ; arg1 for printf
            call    printf

        input_op: ; Input user operation
            mov     rdi, op_fmt             ; arg1
            mov     rsi, op                 ; arg2
            call    scanf

        ask_floats: ; Ask for user floats
            mov     rdi, float_msg          ;
            call    printf                  ;

        input_floats: ; Input user floats
            mov     rdi, flt_fmt            ; arg1
            mov     rsi, f1                 ; arg2
            mov     rdx, f2                 ; arg3
            call    scanf
            pop     rbx                     ; pop the earlier register

        call_calculate: ; Calls function calculate with the obtained values
            movss   xmm0, dword [f1]        ; move argument f1 into xmm0
            movss   xmm1, dword [f2]        ; move argument f2 into xmm1
            mov     rdi, [op]               ; move argument op into rdi
            call    calculate               ; call function calculate
            movss   dword [result], xmm0            ; move xmm0 (result) to result

        show_result: ; Show the results of call calculate
            mov     rdi, result_msg         ; arg1
            mov     rsi, result             ; arg2
        ret
