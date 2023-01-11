
            global _start

            section     .data
ask_msg:    db          "Enter your operation:",10; Asking message

            section     .text
_start:     mov         rax, 1              ; syscall no for write
            mov         rdi, 1              ; fd no for stdout
            mov         rsi, ask_msg        ;
            mov         rdx, 22             ;
            syscall                         ;
            mov         rax, 60             ;
            xor         rdi, rdi            ;
            syscall                         ;