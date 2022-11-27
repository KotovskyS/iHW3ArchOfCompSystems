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
