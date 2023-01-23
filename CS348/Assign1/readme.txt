Assignment 1 Readme

By Ujwal Kumar
Roll no: 200101100

Instruction to assemble, link and run:
    $ nasm -felf64 file.asm             (Assemble)
    $ gcc file.o -no-pie -o file        (Link)     
    $ ./file                            (run) 

File specific instruction given in the file as comments.
Code is well commented(very) so nothing much to explain here.

Important stuff:
    1.  The assignment is done in 64-bit architecture using x84_64 system call numbers
        and 64 bit registers.
    2.  Floats in the assignment have been assumed as 4 byte (word) and not 8 byte doubles (qword)
    3.  Error handling wasn't asked and has not been done. So dont enter invalid inputs(please).
        But that said, there are no bugs and it works fine for all valid inputs (as per the assignment specifications).
    4.  ONLY printf and scanf has been used from the gcc library. Make sure to use the gcc linker (as shown above) using
        the 'no-pie' option(this is important).
    5.  Whenever asked for input, enter them normally side by side just seperated by spaces.

            Eg1. (Output of A1A)
            
                (+ : 1)
                (- : 2)
                (* : 3)
                (/ : 4)
                Enter an operation: 1
                Enter the two floats a and b: 5.77 6.22
                The result of your operation is: 11.990000

            Eg2. (Output for A1B)

                Enter n and k: 10 4
                Enter your array of size 10:
                1.2 5.6 7.8 9.0 5.666 7.678 12.543 0.08 23.5789 1.0001
                The kth(k = 4) largest element is : 7.800000

    6.  That's it. Bye.
