//
// Brainf*** Library for Linux
//
   
.globl bf_init
.globl bf_exit
.globl bf_print
.globl bf_read

.text
   
bf_init:
	pushl	%ebp
	mov	%esp, %ebp
	
	leave
	ret
	
bf_exit:
   call  bf_print_ln
   xorl  %eax, %eax
   incl  %eax
   xorl  %ebx,%ebx
   int   $0x80
   
bf_print:
	push	%ebp
	movl	%esp, %ebp
	
   movl  $4, %eax
   xorl  %ebx, %ebx
   incl  %ebx
   xorl  %edx, %edx
   incl  %edx
   movl  %ebp, %ecx
	addl	$8, %ecx
   int   $0x80
   
	leave
	ret
   
bf_print_ln:
	push	%ebp
	movl	%esp, %ebp
	
   push  $10
   call  bf_print
   
	leave
	ret

     
bf_read:
   push  %ebp
	movl	%esp, %ebp

   movl  $3, %eax
   xorl  %ebx, %ebx
   xorl  %edx, %edx
   incl  %edx
   movl  8(%ebp), %ecx
   pushl %ebp
   int   $0x80
   
   leave
   ret
   
