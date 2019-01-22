	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 12, 1
	.p2align	2               ; -- Begin function -[ViewController viewDidLoad]
"-[ViewController viewDidLoad]":        ; @"\01-[ViewController viewDidLoad]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 8-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, sp
	adrp	x9, l_OBJC_SELECTOR_REFERENCES_@PAGE
	add	x9, x9, l_OBJC_SELECTOR_REFERENCES_@PAGEOFF
	adrp	x10, l_OBJC_CLASSLIST_SUP_REFS_$_@PAGE
	add	x10, x10, l_OBJC_CLASSLIST_SUP_REFS_$_@PAGEOFF
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp]
	ldr	x10, [x10]
	str	x10, [sp, #8]
	ldr	x1, [x9]
	mov	x0, x8
	bl	_objc_msgSendSuper2
	ldp	x29, x30, [sp, #32]     ; 8-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__objc_data
	.globl	_OBJC_CLASS_$_ViewController ; @"OBJC_CLASS_$_ViewController"
	.p2align	3
_OBJC_CLASS_$_ViewController:
	.quad	_OBJC_METACLASS_$_ViewController
	.quad	_OBJC_CLASS_$_UIViewController
	.quad	__objc_empty_cache
	.quad	0
	.quad	l_OBJC_CLASS_RO_$_ViewController

	.section	__DATA,__objc_superrefs,regular,no_dead_strip
	.p2align	3               ; @"OBJC_CLASSLIST_SUP_REFS_$_"
l_OBJC_CLASSLIST_SUP_REFS_$_:
	.quad	_OBJC_CLASS_$_ViewController

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_:                  ; @OBJC_METH_VAR_NAME_
	.asciz	"viewDidLoad"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ; @OBJC_SELECTOR_REFERENCES_
l_OBJC_SELECTOR_REFERENCES_:
	.quad	l_OBJC_METH_VAR_NAME_

	.section	__TEXT,__objc_classname,cstring_literals
l_OBJC_CLASS_NAME_:                     ; @OBJC_CLASS_NAME_
	.asciz	"ViewController"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_METACLASS_RO_$_ViewController"
l_OBJC_METACLASS_RO_$_ViewController:
	.long	1                       ; 0x1
	.long	40                      ; 0x28
	.long	40                      ; 0x28
	.space	4
	.quad	0
	.quad	l_OBJC_CLASS_NAME_
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0

	.section	__DATA,__objc_data
	.globl	_OBJC_METACLASS_$_ViewController ; @"OBJC_METACLASS_$_ViewController"
	.p2align	3
_OBJC_METACLASS_$_ViewController:
	.quad	_OBJC_METACLASS_$_NSObject
	.quad	_OBJC_METACLASS_$_UIViewController
	.quad	__objc_empty_cache
	.quad	0
	.quad	l_OBJC_METACLASS_RO_$_ViewController

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_:                  ; @OBJC_METH_VAR_TYPE_
	.asciz	"v16@0:8"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_INSTANCE_METHODS_ViewController"
l_OBJC_$_INSTANCE_METHODS_ViewController:
	.long	24                      ; 0x18
	.long	1                       ; 0x1
	.quad	l_OBJC_METH_VAR_NAME_
	.quad	l_OBJC_METH_VAR_TYPE_
	.quad	"-[ViewController viewDidLoad]"

	.p2align	3               ; @"\01l_OBJC_CLASS_RO_$_ViewController"
l_OBJC_CLASS_RO_$_ViewController:
	.long	0                       ; 0x0
	.long	8                       ; 0x8
	.long	8                       ; 0x8
	.space	4
	.quad	0
	.quad	l_OBJC_CLASS_NAME_
	.quad	l_OBJC_$_INSTANCE_METHODS_ViewController
	.quad	0
	.quad	0
	.quad	0
	.quad	0

	.section	__DATA,__objc_classlist,regular,no_dead_strip
	.p2align	3               ; @"OBJC_LABEL_CLASS_$"
l_OBJC_LABEL_CLASS_$:
	.quad	_OBJC_CLASS_$_ViewController

	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	64


.subsections_via_symbols
