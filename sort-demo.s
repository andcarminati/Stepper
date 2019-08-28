	.file	"sort-demo.c"
	.text
.Ltext0:
	.globl	mergesort
	.type	mergesort, @function
mergesort:
.LFB6:
	.file 1 "sort-demo.c"
	.loc 1 25 68
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
1:	call	mcount
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movl	%ecx, -40(%rbp)
	.loc 1 27 5
	movl	-36(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jge	.L13
.LBB2:
	.loc 1 28 23
	movl	-36(%rbp), %edx
	movl	-40(%rbp), %eax
	addl	%edx, %eax
	.loc 1 28 8
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -16(%rbp)
	.loc 1 30 4
	movl	-16(%rbp), %ecx
	movl	-36(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	mergesort
	.loc 1 31 4
	movl	-16(%rbp), %eax
	leal	1(%rax), %edi
	movl	-40(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	mergesort
	.loc 1 33 8
	movl	-36(%rbp), %eax
	movl	%eax, -4(%rbp)
	.loc 1 34 8
	movl	-16(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -8(%rbp)
	.loc 1 35 8
	movl	-36(%rbp), %eax
	movl	%eax, -12(%rbp)
	.loc 1 38 9
	jmp	.L3
.L6:
	.loc 1 39 13
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	.loc 1 39 31
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	.loc 1 39 7
	cmpl	%eax, %edx
	jge	.L4
	.loc 1 40 49
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4(%rbp)
	cltq
	.loc 1 40 40
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	.loc 1 40 29
	movl	-12(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -12(%rbp)
	cltq
	.loc 1 40 15
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 40 40
	movl	(%rcx), %eax
	.loc 1 40 33
	movl	%eax, (%rdx)
	jmp	.L3
.L4:
	.loc 1 42 48
	movl	-8(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -8(%rbp)
	cltq
	.loc 1 42 40
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	.loc 1 42 29
	movl	-12(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -12(%rbp)
	cltq
	.loc 1 42 15
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 42 40
	movl	(%rcx), %eax
	.loc 1 42 33
	movl	%eax, (%rdx)
.L3:
	.loc 1 38 9
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jg	.L7
	.loc 1 38 29 discriminator 1
	movl	-8(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jle	.L6
	.loc 1 45 9
	jmp	.L7
.L8:
	.loc 1 46 47
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4(%rbp)
	cltq
	.loc 1 46 38
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	.loc 1 46 27
	movl	-12(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -12(%rbp)
	cltq
	.loc 1 46 13
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 46 38
	movl	(%rcx), %eax
	.loc 1 46 31
	movl	%eax, (%rdx)
.L7:
	.loc 1 45 9
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jle	.L8
	.loc 1 48 9
	jmp	.L9
.L10:
	.loc 1 49 46
	movl	-8(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -8(%rbp)
	cltq
	.loc 1 49 38
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	.loc 1 49 27
	movl	-12(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -12(%rbp)
	cltq
	.loc 1 49 13
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 49 38
	movl	(%rcx), %eax
	.loc 1 49 31
	movl	%eax, (%rdx)
.L9:
	.loc 1 48 9
	movl	-8(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jle	.L10
	.loc 1 52 9
	jmp	.L11
.L12:
	.loc 1 53 30
	movl	-36(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 53 10
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	.loc 1 53 30
	movl	(%rax), %eax
	.loc 1 53 20
	movl	%eax, (%rdx)
	.loc 1 54 12
	addl	$1, -36(%rbp)
.L11:
	.loc 1 52 9
	movl	-36(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jle	.L12
.L13:
.LBE2:
	.loc 1 57 1
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	mergesort, .-mergesort
	.section	.rodata
.LC0:
	.string	"%d, "
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.loc 1 60 32
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
1:	call	mcount
	movl	%edi, -132(%rbp)
	movq	%rsi, -144(%rbp)
	.loc 1 63 6
	movl	$12, -64(%rbp)
	movl	$2, -60(%rbp)
	movl	$10, -56(%rbp)
	movl	$7, -52(%rbp)
	movl	$5, -48(%rbp)
	movl	$9, -44(%rbp)
	movl	$6, -40(%rbp)
	movl	$15, -36(%rbp)
	movl	$4, -32(%rbp)
	movl	$3, -28(%rbp)
	movl	$2, -24(%rbp)
	movl	$1, -20(%rbp)
	movl	$21, -16(%rbp)
	movl	$3, -12(%rbp)
	.loc 1 66 2
	leaq	-128(%rbp), %rsi
	leaq	-64(%rbp), %rax
	movl	$13, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	mergesort
	.loc 1 68 9
	movl	$10, %edi
	call	putchar
	.loc 1 69 8
	movl	$0, -4(%rbp)
	.loc 1 69 2
	jmp	.L15
.L16:
	.loc 1 70 3 discriminator 3
	movl	-4(%rbp), %eax
	cltq
	movl	-64(%rbp,%rax,4), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	.loc 1 69 22 discriminator 3
	addl	$1, -4(%rbp)
.L15:
	.loc 1 69 2 discriminator 1
	cmpl	$13, -4(%rbp)
	jle	.L16
	.loc 1 72 2
	movl	$10, %edi
	call	putchar
	.loc 1 73 9
	movl	$0, %eax
	.loc 1 74 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-redhat-linux/9/include/stddef.h"
	.file 3 "/usr/include/bits/types.h"
	.file 4 "/usr/include/bits/types/struct_FILE.h"
	.file 5 "/usr/include/bits/types/FILE.h"
	.file 6 "/usr/include/stdio.h"
	.file 7 "/usr/include/bits/sys_errlist.h"
	.file 8 "/usr/include/unistd.h"
	.file 9 "/usr/include/bits/getopt_core.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x45f
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF67
	.byte	0xc
	.long	.LASF68
	.long	.LASF69
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF7
	.byte	0x2
	.byte	0xd1
	.byte	0x17
	.long	0x39
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF0
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF1
	.uleb128 0x4
	.byte	0x8
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF2
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x5
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x2
	.long	.LASF8
	.byte	0x3
	.byte	0x98
	.byte	0x19
	.long	0x6c
	.uleb128 0x2
	.long	.LASF9
	.byte	0x3
	.byte	0x99
	.byte	0x1b
	.long	0x6c
	.uleb128 0x6
	.byte	0x8
	.long	0x91
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF10
	.uleb128 0x7
	.long	0x91
	.uleb128 0x8
	.long	.LASF70
	.byte	0xd8
	.byte	0x4
	.byte	0x31
	.byte	0x8
	.long	0x224
	.uleb128 0x9
	.long	.LASF11
	.byte	0x4
	.byte	0x33
	.byte	0x7
	.long	0x65
	.byte	0
	.uleb128 0x9
	.long	.LASF12
	.byte	0x4
	.byte	0x36
	.byte	0x9
	.long	0x8b
	.byte	0x8
	.uleb128 0x9
	.long	.LASF13
	.byte	0x4
	.byte	0x37
	.byte	0x9
	.long	0x8b
	.byte	0x10
	.uleb128 0x9
	.long	.LASF14
	.byte	0x4
	.byte	0x38
	.byte	0x9
	.long	0x8b
	.byte	0x18
	.uleb128 0x9
	.long	.LASF15
	.byte	0x4
	.byte	0x39
	.byte	0x9
	.long	0x8b
	.byte	0x20
	.uleb128 0x9
	.long	.LASF16
	.byte	0x4
	.byte	0x3a
	.byte	0x9
	.long	0x8b
	.byte	0x28
	.uleb128 0x9
	.long	.LASF17
	.byte	0x4
	.byte	0x3b
	.byte	0x9
	.long	0x8b
	.byte	0x30
	.uleb128 0x9
	.long	.LASF18
	.byte	0x4
	.byte	0x3c
	.byte	0x9
	.long	0x8b
	.byte	0x38
	.uleb128 0x9
	.long	.LASF19
	.byte	0x4
	.byte	0x3d
	.byte	0x9
	.long	0x8b
	.byte	0x40
	.uleb128 0x9
	.long	.LASF20
	.byte	0x4
	.byte	0x40
	.byte	0x9
	.long	0x8b
	.byte	0x48
	.uleb128 0x9
	.long	.LASF21
	.byte	0x4
	.byte	0x41
	.byte	0x9
	.long	0x8b
	.byte	0x50
	.uleb128 0x9
	.long	.LASF22
	.byte	0x4
	.byte	0x42
	.byte	0x9
	.long	0x8b
	.byte	0x58
	.uleb128 0x9
	.long	.LASF23
	.byte	0x4
	.byte	0x44
	.byte	0x16
	.long	0x23d
	.byte	0x60
	.uleb128 0x9
	.long	.LASF24
	.byte	0x4
	.byte	0x46
	.byte	0x14
	.long	0x243
	.byte	0x68
	.uleb128 0x9
	.long	.LASF25
	.byte	0x4
	.byte	0x48
	.byte	0x7
	.long	0x65
	.byte	0x70
	.uleb128 0x9
	.long	.LASF26
	.byte	0x4
	.byte	0x49
	.byte	0x7
	.long	0x65
	.byte	0x74
	.uleb128 0x9
	.long	.LASF27
	.byte	0x4
	.byte	0x4a
	.byte	0xb
	.long	0x73
	.byte	0x78
	.uleb128 0x9
	.long	.LASF28
	.byte	0x4
	.byte	0x4d
	.byte	0x12
	.long	0x50
	.byte	0x80
	.uleb128 0x9
	.long	.LASF29
	.byte	0x4
	.byte	0x4e
	.byte	0xf
	.long	0x57
	.byte	0x82
	.uleb128 0x9
	.long	.LASF30
	.byte	0x4
	.byte	0x4f
	.byte	0x8
	.long	0x249
	.byte	0x83
	.uleb128 0x9
	.long	.LASF31
	.byte	0x4
	.byte	0x51
	.byte	0xf
	.long	0x259
	.byte	0x88
	.uleb128 0x9
	.long	.LASF32
	.byte	0x4
	.byte	0x59
	.byte	0xd
	.long	0x7f
	.byte	0x90
	.uleb128 0x9
	.long	.LASF33
	.byte	0x4
	.byte	0x5b
	.byte	0x17
	.long	0x264
	.byte	0x98
	.uleb128 0x9
	.long	.LASF34
	.byte	0x4
	.byte	0x5c
	.byte	0x19
	.long	0x26f
	.byte	0xa0
	.uleb128 0x9
	.long	.LASF35
	.byte	0x4
	.byte	0x5d
	.byte	0x14
	.long	0x243
	.byte	0xa8
	.uleb128 0x9
	.long	.LASF36
	.byte	0x4
	.byte	0x5e
	.byte	0x9
	.long	0x47
	.byte	0xb0
	.uleb128 0x9
	.long	.LASF37
	.byte	0x4
	.byte	0x5f
	.byte	0xa
	.long	0x2d
	.byte	0xb8
	.uleb128 0x9
	.long	.LASF38
	.byte	0x4
	.byte	0x60
	.byte	0x7
	.long	0x65
	.byte	0xc0
	.uleb128 0x9
	.long	.LASF39
	.byte	0x4
	.byte	0x62
	.byte	0x8
	.long	0x275
	.byte	0xc4
	.byte	0
	.uleb128 0x2
	.long	.LASF40
	.byte	0x5
	.byte	0x7
	.byte	0x19
	.long	0x9d
	.uleb128 0xa
	.long	.LASF71
	.byte	0x4
	.byte	0x2b
	.byte	0xe
	.uleb128 0xb
	.long	.LASF41
	.uleb128 0x6
	.byte	0x8
	.long	0x238
	.uleb128 0x6
	.byte	0x8
	.long	0x9d
	.uleb128 0xc
	.long	0x91
	.long	0x259
	.uleb128 0xd
	.long	0x39
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x230
	.uleb128 0xb
	.long	.LASF42
	.uleb128 0x6
	.byte	0x8
	.long	0x25f
	.uleb128 0xb
	.long	.LASF43
	.uleb128 0x6
	.byte	0x8
	.long	0x26a
	.uleb128 0xc
	.long	0x91
	.long	0x285
	.uleb128 0xd
	.long	0x39
	.byte	0x13
	.byte	0
	.uleb128 0xe
	.long	.LASF44
	.byte	0x6
	.byte	0x89
	.byte	0xe
	.long	0x291
	.uleb128 0x6
	.byte	0x8
	.long	0x224
	.uleb128 0xe
	.long	.LASF45
	.byte	0x6
	.byte	0x8a
	.byte	0xe
	.long	0x291
	.uleb128 0xe
	.long	.LASF46
	.byte	0x6
	.byte	0x8b
	.byte	0xe
	.long	0x291
	.uleb128 0xe
	.long	.LASF47
	.byte	0x7
	.byte	0x1a
	.byte	0xc
	.long	0x65
	.uleb128 0xc
	.long	0x2d1
	.long	0x2c6
	.uleb128 0xf
	.byte	0
	.uleb128 0x7
	.long	0x2bb
	.uleb128 0x6
	.byte	0x8
	.long	0x98
	.uleb128 0x7
	.long	0x2cb
	.uleb128 0xe
	.long	.LASF48
	.byte	0x7
	.byte	0x1b
	.byte	0x1a
	.long	0x2c6
	.uleb128 0x10
	.long	.LASF49
	.byte	0x8
	.value	0x21f
	.byte	0xf
	.long	0x2ef
	.uleb128 0x6
	.byte	0x8
	.long	0x8b
	.uleb128 0xe
	.long	.LASF50
	.byte	0x9
	.byte	0x24
	.byte	0xe
	.long	0x8b
	.uleb128 0xe
	.long	.LASF51
	.byte	0x9
	.byte	0x32
	.byte	0xc
	.long	0x65
	.uleb128 0xe
	.long	.LASF52
	.byte	0x9
	.byte	0x37
	.byte	0xc
	.long	0x65
	.uleb128 0xe
	.long	.LASF53
	.byte	0x9
	.byte	0x3b
	.byte	0xc
	.long	0x65
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF54
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF55
	.uleb128 0x11
	.long	.LASF72
	.byte	0x1
	.byte	0x3c
	.byte	0x5
	.long	0x65
	.quad	.LFB7
	.quad	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x3a3
	.uleb128 0x12
	.long	.LASF56
	.byte	0x1
	.byte	0x3c
	.byte	0xe
	.long	0x65
	.uleb128 0x3
	.byte	0x91
	.sleb128 -148
	.uleb128 0x12
	.long	.LASF57
	.byte	0x1
	.byte	0x3c
	.byte	0x1b
	.long	0x2ef
	.uleb128 0x3
	.byte	0x91
	.sleb128 -160
	.uleb128 0x13
	.string	"i"
	.byte	0x1
	.byte	0x3e
	.byte	0x6
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x14
	.long	.LASF58
	.byte	0x1
	.byte	0x3f
	.byte	0x6
	.long	0x3a3
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x13
	.string	"tmp"
	.byte	0x1
	.byte	0x40
	.byte	0x6
	.long	0x3a3
	.uleb128 0x3
	.byte	0x91
	.sleb128 -144
	.byte	0
	.uleb128 0xc
	.long	0x65
	.long	0x3b3
	.uleb128 0xd
	.long	0x39
	.byte	0xd
	.byte	0
	.uleb128 0x15
	.long	.LASF73
	.byte	0x1
	.byte	0x19
	.byte	0x6
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x45c
	.uleb128 0x12
	.long	.LASF59
	.byte	0x1
	.byte	0x19
	.byte	0x14
	.long	0x45c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x12
	.long	.LASF60
	.byte	0x1
	.byte	0x19
	.byte	0x21
	.long	0x45c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x12
	.long	.LASF61
	.byte	0x1
	.byte	0x19
	.byte	0x31
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.uleb128 0x12
	.long	.LASF62
	.byte	0x1
	.byte	0x19
	.byte	0x3e
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x16
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.uleb128 0x14
	.long	.LASF63
	.byte	0x1
	.byte	0x1c
	.byte	0x8
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x14
	.long	.LASF64
	.byte	0x1
	.byte	0x21
	.byte	0x8
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x14
	.long	.LASF65
	.byte	0x1
	.byte	0x22
	.byte	0x8
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x14
	.long	.LASF66
	.byte	0x1
	.byte	0x23
	.byte	0x8
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x65
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x21
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF51:
	.string	"optind"
.LASF50:
	.string	"optarg"
.LASF70:
	.string	"_IO_FILE"
.LASF47:
	.string	"sys_nerr"
.LASF22:
	.string	"_IO_save_end"
.LASF5:
	.string	"short int"
.LASF7:
	.string	"size_t"
.LASF32:
	.string	"_offset"
.LASF67:
	.string	"GNU C17 9.1.1 20190503 (Red Hat 9.1.1-1) -mtune=generic -march=x86-64 -g -p"
.LASF11:
	.string	"_flags"
.LASF18:
	.string	"_IO_buf_base"
.LASF49:
	.string	"__environ"
.LASF23:
	.string	"_markers"
.LASF13:
	.string	"_IO_read_end"
.LASF36:
	.string	"_freeres_buf"
.LASF69:
	.string	"/home/andreu/NetBeansProjects/Stepper"
.LASF46:
	.string	"stderr"
.LASF54:
	.string	"long long int"
.LASF31:
	.string	"_lock"
.LASF6:
	.string	"long int"
.LASF61:
	.string	"inicial"
.LASF28:
	.string	"_cur_column"
.LASF57:
	.string	"argv"
.LASF16:
	.string	"_IO_write_ptr"
.LASF27:
	.string	"_old_offset"
.LASF2:
	.string	"unsigned char"
.LASF56:
	.string	"argc"
.LASF4:
	.string	"signed char"
.LASF33:
	.string	"_codecvt"
.LASF55:
	.string	"long long unsigned int"
.LASF1:
	.string	"unsigned int"
.LASF41:
	.string	"_IO_marker"
.LASF30:
	.string	"_shortbuf"
.LASF15:
	.string	"_IO_write_base"
.LASF39:
	.string	"_unused2"
.LASF52:
	.string	"opterr"
.LASF64:
	.string	"esquerda"
.LASF19:
	.string	"_IO_buf_end"
.LASF62:
	.string	"final"
.LASF10:
	.string	"char"
.LASF72:
	.string	"main"
.LASF73:
	.string	"mergesort"
.LASF34:
	.string	"_wide_data"
.LASF35:
	.string	"_freeres_list"
.LASF60:
	.string	"auxiliar"
.LASF37:
	.string	"__pad5"
.LASF58:
	.string	"numeros"
.LASF63:
	.string	"meio"
.LASF3:
	.string	"short unsigned int"
.LASF0:
	.string	"long unsigned int"
.LASF17:
	.string	"_IO_write_end"
.LASF59:
	.string	"vetor"
.LASF9:
	.string	"__off64_t"
.LASF25:
	.string	"_fileno"
.LASF24:
	.string	"_chain"
.LASF43:
	.string	"_IO_wide_data"
.LASF68:
	.string	"sort-demo.c"
.LASF38:
	.string	"_mode"
.LASF8:
	.string	"__off_t"
.LASF21:
	.string	"_IO_backup_base"
.LASF44:
	.string	"stdin"
.LASF26:
	.string	"_flags2"
.LASF42:
	.string	"_IO_codecvt"
.LASF14:
	.string	"_IO_read_base"
.LASF29:
	.string	"_vtable_offset"
.LASF65:
	.string	"direita"
.LASF20:
	.string	"_IO_save_base"
.LASF48:
	.string	"sys_errlist"
.LASF53:
	.string	"optopt"
.LASF66:
	.string	"posicao_final"
.LASF40:
	.string	"FILE"
.LASF12:
	.string	"_IO_read_ptr"
.LASF45:
	.string	"stdout"
.LASF71:
	.string	"_IO_lock_t"
	.ident	"GCC: (GNU) 9.1.1 20190503 (Red Hat 9.1.1-1)"
	.section	.note.GNU-stack,"",@progbits
