;
; Brainf*** Library for Linux
;
   
GLOBAL bf_exit
GLOBAL bf_print
GLOBAL bf_read

[SECTION .text]
   
bf_exit:
   call  bf_print_ln
   xor   eax, eax
   inc   eax
   xor   ebx, ebx
   int   0x80
   
bf_print:
   mov   eax, 4
   xor   ebx, ebx
   inc   ebx
   xor   edx, edx
   inc   edx
   mov   ecx, ebp
   int   0x80
   ret
   
bf_print_ln:
   mov   ebp, .new_line
   call  bf_print
   ret
.new_line:
   db    10

bf_print_str:
   xor   edx, edx
.L0:
   cmp   byte [esi+edx], 0
   je    .L1
   inc   edx
   jmp   .L0
.L1:
   dec   ecx
   mov   eax, 4
   xor   ebx, ebx
   inc   ebx
   mov   ecx, esi
   int   0x80
   ret
     
bf_read:
   push  ebp

;   mov   esi, .read_str
;   call  bf_print_str
   
   mov   eax, 3
   xor   ebx, ebx
   xor   edx, edx
   inc   edx
   pop   ebp
   mov   ecx, ebp
   push  ebp
   int   0x80
   
   ;call  bf_print_ln

   pop ebp
   ret
   
.read_str:
   db    "READ: "
