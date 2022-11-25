	.file	"8.c"
	.text
	.globl	f
	.type	f, @function
f:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, -8(%rbp)		#a 
	movsd	%xmm1, -16(%rbp)	#b 
	movsd	%xmm2, -24(%rbp)	#x
	movsd	-16(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0
	addsd	-8(%rbp), %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	f, .-f
	.globl	S
	.type	S, @function
S:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movsd	%xmm0, -40(%rbp)	#a
	movsd	%xmm1, -48(%rbp)	#b
	movl	%edi, -52(%rbp)		#A
	movl	%esi, -56(%rbp)		#B
	movl	$100000000, -20(%rbp)	# n 
	movl	-56(%rbp), %eax		
	subl	-52(%rbp), %eax		#(B - A)
	cvtsi2ss	%eax, %xmm0
	cvtsi2ss	-20(%rbp), %xmm1
	divss	%xmm1, %xmm0		#(B - A) / n
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, -8(%rbp)		#save h
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)	#sum
	movl	$0, -24(%rbp)		#int i = 0
	jmp	.L4
.L5:
	cvtsi2sd	-52(%rbp), %xmm1 #A 
	cvtsi2sd	-24(%rbp), %xmm0 # h
	mulsd	-8(%rbp), %xmm0		# i * h
	addsd	%xmm1, %xmm0		#A + i * h
	movsd	-48(%rbp), %xmm1	#A + i *h to f
	movq	-40(%rbp), %rax		#a to f
	movapd	%xmm0, %xmm2
	movq	%rax, -64(%rbp)		#b to f
	movsd	-64(%rbp), %xmm0
	call	f
	movapd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	addl	$1, -24(%rbp)
.L4:
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L5
	movsd	-8(%rbp), %xmm0
	mulsd	-16(%rbp), %xmm0	#return h * sum
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	S, .-S
	.section	.rodata
	.align 8
.LC1:
	.string	"Некорректный ввод!"
.LC2:
	.string	"-r"
.LC3:
	.string	"w"
.LC4:
	.string	"Некорректный или несуществующий файл!"
	.align 8
.LC5:
	.string	"random numbers: a = %lf, b = %lf, A = %d, B = %d\n"
.LC7:
	.string	"root: %lf\ntime: %.6lf\n"
.LC8:
	.string	"-h"
.LC9:
	.string	"\n-h вывести справку"
	.align 8
.LC10:
	.string	"-r Создать случайные коэффициенты и границы (a, b, A, B)"
	.align 8
.LC11:
	.string	"-f считать данные из input.txt и записать результат в output.txt"
	.align 8
.LC12:
	.string	"-s Считать данные из терминала и записать в файл."
.LC13:
	.string	"-f"
.LC14:
	.string	"r"
.LC15:
	.string	"%lf"
.LC16:
	.string	"%d"
.LC17:
	.string	"integral = %lf\ntime: %.6lf\n"
.LC18:
	.string	"-s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movl	%edi, -132(%rbp)	#argc
	movq	%rsi, -144(%rbp)	#argv
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$2, -132(%rbp)
	je	.L8
	cmpl	$4, -132(%rbp)
	je	.L8
	cmpl	$3, -132(%rbp)
	je	.L8
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L8:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT		#check correct input
	testl	%eax, %eax
	jne	.L10
	cmpl	$3, -132(%rbp)
	je	.L11
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L11:
	movl	$0, %edi
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	movq	-144(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L12
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L12:
	call	rand@PLT
	movl	%eax, %ecx		#a
	movl	$1717986919, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	$2, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	cvtsi2sd	%edx, %xmm0
	movsd	%xmm0, -32(%rbp)
	call	rand@PLT
	movl	%eax, %ecx		#b
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	leal	(%rdx,%rcx), %eax
	sarl	$3, %eax
	movl	%eax, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$4, %eax
	subl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	cvtsi2sd	%edx, %xmm0
	movsd	%xmm0, -24(%rbp)
	call	rand@PLT
	movl	%eax, %ecx		#A
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	leal	(%rdx,%rcx), %eax
	sarl	$3, %eax
	movl	%eax, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	sall	$4, %edx
	subl	%eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	subl	$10, %eax
	movl	%eax, -120(%rbp)
	call	rand@PLT
	movl	%eax, %ecx		#B
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	leal	(%rdx,%rcx), %eax
	sarl	$3, %eax
	movl	%eax, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -116(%rbp)
	movl	-116(%rbp), %edx
	movl	%edx, %eax
	sall	$4, %eax
	subl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, -116(%rbp)
	movl	-116(%rbp), %ecx
	movl	-120(%rbp), %edx
	movsd	-24(%rbp), %xmm0
	movq	-32(%rbp), %rsi
	movq	-40(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rsi, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT		#printf result of rand
	call	clock@PLT
	movq	%rax, -88(%rbp)		# s
	movl	-116(%rbp), %ecx	#a to S
	movl	-120(%rbp), %edx	#b to S
	movsd	-24(%rbp), %xmm0	#A to S
	movq	-32(%rbp), %rax		#B to S
	movl	%ecx, %esi
	movl	%edx, %edi
	movapd	%xmm0, %xmm1
	movq	%rax, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	call	S
	movq	%xmm0, %rax		#save result func S in s
	movq	%rax, -16(%rbp)
	call	clock@PLT
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	subq	-88(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	jmp	.L13
.L10:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC8(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L14
	leaq	.LC9(%rip), %rdi
	call	puts@PLT
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
	leaq	.LC11(%rip), %rdi
	call	puts@PLT
	leaq	.LC12(%rip), %rdi
	call	puts@PLT
	jmp	.L13
.L14:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC13(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L15
	cmpl	$4, -132(%rbp)
	je	.L16
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L16:
	movq	-144(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC14(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -64(%rbp)
	movq	-144(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -56(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L18
	cmpq	$0, -56(%rbp)
	jne	.L19
.L18:
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L19:
	leaq	-112(%rbp), %rdx
	movq	-64(%rbp), %rax
	leaq	.LC15(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	leaq	-104(%rbp), %rdx	#a
	movq	-64(%rbp), %rax
	leaq	.LC15(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	leaq	-128(%rbp), %rdx	#b
	movq	-64(%rbp), %rax
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	leaq	-124(%rbp), %rdx	#A
	movq	-64(%rbp), %rax
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	call	clock@PLT
	movq	%rax, -88(%rbp)		#B
	movl	-124(%rbp), %ecx	#a to S
	movl	-128(%rbp), %edx	#b to S
	movsd	-104(%rbp), %xmm0	#A to S
	movq	-112(%rbp), %rax	#B to S
	movl	%ecx, %esi
	movl	%edx, %edi
	movapd	%xmm0, %xmm1
	movq	%rax, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	call	S
	movq	%xmm0, %rax		#s from S
	movq	%rax, -48(%rbp)
	call	clock@PLT
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	subq	-88(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-48(%rbp), %rdx
	movq	-56(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC17(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	jmp	.L13
.L15:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC18(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L13
	cmpl	$3, -132(%rbp)
	je	.L20
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L20:
	movq	-144(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -96(%rbp)
	cmpq	$0, -96(%rbp)
	jne	.L22
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L22:
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC15(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-104(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC15(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-128(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC16(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-124(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC16(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	call	clock@PLT
	movq	%rax, -88(%rbp)
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	movsd	-104(%rbp), %xmm0
	movq	-112(%rbp), %rax
	movl	%ecx, %esi
	movl	%edx, %edi
	movapd	%xmm0, %xmm1
	movq	%rax, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	call	S
	movq	%xmm0, %rax
	movq	%rax, -80(%rbp)
	call	clock@PLT
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	subq	-88(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-80(%rbp), %rdx
	movq	-96(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC17(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
.L13:
	movl	$0, %eax
.L9:
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC6:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
