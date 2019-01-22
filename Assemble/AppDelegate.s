	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 12, 1
	.p2align	2               ; -- Begin function -[AppDelegate application:didFinishLaunchingWithOptions:]
"-[AppDelegate application:didFinishLaunchingWithOptions:]": ; @"\01-[AppDelegate application:didFinishLaunchingWithOptions:]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	orr	w8, wzr, #0x1
	str	x0, [sp, #24]
	str	x1, [sp, #16]
	str	x2, [sp, #8]
	str	x3, [sp]
	and	w0, w8, #0x1
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2               ; -- Begin function -[AppDelegate applicationWillResignActive:]
"-[AppDelegate applicationWillResignActive:]": ; @"\01-[AppDelegate applicationWillResignActive:]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #24]
	str	x1, [sp, #16]
	str	x2, [sp, #8]
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2               ; -- Begin function -[AppDelegate applicationDidEnterBackground:]
"-[AppDelegate applicationDidEnterBackground:]": ; @"\01-[AppDelegate applicationDidEnterBackground:]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #24]
	str	x1, [sp, #16]
	str	x2, [sp, #8]
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2               ; -- Begin function -[AppDelegate applicationWillEnterForeground:]
"-[AppDelegate applicationWillEnterForeground:]": ; @"\01-[AppDelegate applicationWillEnterForeground:]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #24]
	str	x1, [sp, #16]
	str	x2, [sp, #8]
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2               ; -- Begin function -[AppDelegate applicationDidBecomeActive:]
"-[AppDelegate applicationDidBecomeActive:]": ; @"\01-[AppDelegate applicationDidBecomeActive:]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #24]
	str	x1, [sp, #16]
	str	x2, [sp, #8]
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2               ; -- Begin function -[AppDelegate applicationWillTerminate:]
"-[AppDelegate applicationWillTerminate:]": ; @"\01-[AppDelegate applicationWillTerminate:]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #24]
	str	x1, [sp, #16]
	str	x2, [sp, #8]
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2               ; -- Begin function -[AppDelegate window]
"-[AppDelegate window]":                ; @"\01-[AppDelegate window]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	adrp	x8, _OBJC_IVAR_$_AppDelegate._window@PAGE
	add	x8, x8, _OBJC_IVAR_$_AppDelegate._window@PAGEOFF
	str	x0, [sp, #8]
	str	x1, [sp]
	ldr	x0, [sp, #8]
	ldrsw	x8, [x8]
	add	x8, x0, x8
	ldr	x0, [x8]
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2               ; -- Begin function -[AppDelegate setWindow:]
"-[AppDelegate setWindow:]":            ; @"\01-[AppDelegate setWindow:]"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 8-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, _OBJC_IVAR_$_AppDelegate._window@PAGE
	add	x8, x8, _OBJC_IVAR_$_AppDelegate._window@PAGEOFF
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	str	x2, [sp, #8]
	ldr	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	ldrsw	x3, [x8]
	ldr	x8, [sp, #8]
	mov	x2, x8
	bl	_objc_setProperty_nonatomic
	ldp	x29, x30, [sp, #32]     ; 8-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	_OBJC_IVAR_$_AppDelegate._window ; @"OBJC_IVAR_$_AppDelegate._window"
	.section	__DATA,__objc_ivar
	.globl	_OBJC_IVAR_$_AppDelegate._window
	.p2align	2
_OBJC_IVAR_$_AppDelegate._window:
	.long	8                       ; 0x8

	.section	__TEXT,__objc_classname,cstring_literals
l_OBJC_CLASS_NAME_:                     ; @OBJC_CLASS_NAME_
	.asciz	"AppDelegate"

l_OBJC_CLASS_NAME_.1:                   ; @OBJC_CLASS_NAME_.1
	.asciz	"UIApplicationDelegate"

l_OBJC_CLASS_NAME_.2:                   ; @OBJC_CLASS_NAME_.2
	.asciz	"NSObject"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_:                  ; @OBJC_METH_VAR_NAME_
	.asciz	"isEqual:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_:                  ; @OBJC_METH_VAR_TYPE_
	.asciz	"B24@0:8@16"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.3:                ; @OBJC_METH_VAR_NAME_.3
	.asciz	"class"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.4:                ; @OBJC_METH_VAR_TYPE_.4
	.asciz	"#16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.5:                ; @OBJC_METH_VAR_NAME_.5
	.asciz	"self"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.6:                ; @OBJC_METH_VAR_TYPE_.6
	.asciz	"@16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.7:                ; @OBJC_METH_VAR_NAME_.7
	.asciz	"performSelector:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.8:                ; @OBJC_METH_VAR_TYPE_.8
	.asciz	"@24@0:8:16"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.9:                ; @OBJC_METH_VAR_NAME_.9
	.asciz	"performSelector:withObject:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.10:               ; @OBJC_METH_VAR_TYPE_.10
	.asciz	"@32@0:8:16@24"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.11:               ; @OBJC_METH_VAR_NAME_.11
	.asciz	"performSelector:withObject:withObject:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.12:               ; @OBJC_METH_VAR_TYPE_.12
	.asciz	"@40@0:8:16@24@32"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.13:               ; @OBJC_METH_VAR_NAME_.13
	.asciz	"isProxy"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.14:               ; @OBJC_METH_VAR_TYPE_.14
	.asciz	"B16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.15:               ; @OBJC_METH_VAR_NAME_.15
	.asciz	"isKindOfClass:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.16:               ; @OBJC_METH_VAR_TYPE_.16
	.asciz	"B24@0:8#16"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.17:               ; @OBJC_METH_VAR_NAME_.17
	.asciz	"isMemberOfClass:"

l_OBJC_METH_VAR_NAME_.18:               ; @OBJC_METH_VAR_NAME_.18
	.asciz	"conformsToProtocol:"

l_OBJC_METH_VAR_NAME_.19:               ; @OBJC_METH_VAR_NAME_.19
	.asciz	"respondsToSelector:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.20:               ; @OBJC_METH_VAR_TYPE_.20
	.asciz	"B24@0:8:16"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.21:               ; @OBJC_METH_VAR_NAME_.21
	.asciz	"retain"

l_OBJC_METH_VAR_NAME_.22:               ; @OBJC_METH_VAR_NAME_.22
	.asciz	"release"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.23:               ; @OBJC_METH_VAR_TYPE_.23
	.asciz	"Vv16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.24:               ; @OBJC_METH_VAR_NAME_.24
	.asciz	"autorelease"

l_OBJC_METH_VAR_NAME_.25:               ; @OBJC_METH_VAR_NAME_.25
	.asciz	"retainCount"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.26:               ; @OBJC_METH_VAR_TYPE_.26
	.asciz	"Q16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.27:               ; @OBJC_METH_VAR_NAME_.27
	.asciz	"zone"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.28:               ; @OBJC_METH_VAR_TYPE_.28
	.asciz	"^{_NSZone=}16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.29:               ; @OBJC_METH_VAR_NAME_.29
	.asciz	"hash"

l_OBJC_METH_VAR_NAME_.30:               ; @OBJC_METH_VAR_NAME_.30
	.asciz	"superclass"

l_OBJC_METH_VAR_NAME_.31:               ; @OBJC_METH_VAR_NAME_.31
	.asciz	"description"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROTOCOL_INSTANCE_METHODS_NSObject"
l_OBJC_$_PROTOCOL_INSTANCE_METHODS_NSObject:
	.long	24                      ; 0x18
	.long	19                      ; 0x13
	.quad	l_OBJC_METH_VAR_NAME_
	.quad	l_OBJC_METH_VAR_TYPE_
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.3
	.quad	l_OBJC_METH_VAR_TYPE_.4
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.5
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.7
	.quad	l_OBJC_METH_VAR_TYPE_.8
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.9
	.quad	l_OBJC_METH_VAR_TYPE_.10
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.11
	.quad	l_OBJC_METH_VAR_TYPE_.12
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.13
	.quad	l_OBJC_METH_VAR_TYPE_.14
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.15
	.quad	l_OBJC_METH_VAR_TYPE_.16
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.17
	.quad	l_OBJC_METH_VAR_TYPE_.16
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.18
	.quad	l_OBJC_METH_VAR_TYPE_
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.19
	.quad	l_OBJC_METH_VAR_TYPE_.20
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.21
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.22
	.quad	l_OBJC_METH_VAR_TYPE_.23
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.24
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.25
	.quad	l_OBJC_METH_VAR_TYPE_.26
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.27
	.quad	l_OBJC_METH_VAR_TYPE_.28
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.29
	.quad	l_OBJC_METH_VAR_TYPE_.26
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.30
	.quad	l_OBJC_METH_VAR_TYPE_.4
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.31
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	0

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.32:               ; @OBJC_METH_VAR_NAME_.32
	.asciz	"debugDescription"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROTOCOL_INSTANCE_METHODS_OPT_NSObject"
l_OBJC_$_PROTOCOL_INSTANCE_METHODS_OPT_NSObject:
	.long	24                      ; 0x18
	.long	1                       ; 0x1
	.quad	l_OBJC_METH_VAR_NAME_.32
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	0

	.section	__TEXT,__cstring,cstring_literals
l_OBJC_PROP_NAME_ATTR_:                 ; @OBJC_PROP_NAME_ATTR_
	.asciz	"hash"

l_OBJC_PROP_NAME_ATTR_.33:              ; @OBJC_PROP_NAME_ATTR_.33
	.asciz	"TQ,R"

l_OBJC_PROP_NAME_ATTR_.34:              ; @OBJC_PROP_NAME_ATTR_.34
	.asciz	"superclass"

l_OBJC_PROP_NAME_ATTR_.35:              ; @OBJC_PROP_NAME_ATTR_.35
	.asciz	"T#,R"

l_OBJC_PROP_NAME_ATTR_.36:              ; @OBJC_PROP_NAME_ATTR_.36
	.asciz	"description"

l_OBJC_PROP_NAME_ATTR_.37:              ; @OBJC_PROP_NAME_ATTR_.37
	.asciz	"T@\"NSString\",R,C"

l_OBJC_PROP_NAME_ATTR_.38:              ; @OBJC_PROP_NAME_ATTR_.38
	.asciz	"debugDescription"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROP_LIST_NSObject"
l_OBJC_$_PROP_LIST_NSObject:
	.long	16                      ; 0x10
	.long	4                       ; 0x4
	.quad	l_OBJC_PROP_NAME_ATTR_
	.quad	l_OBJC_PROP_NAME_ATTR_.33
	.quad	l_OBJC_PROP_NAME_ATTR_.34
	.quad	l_OBJC_PROP_NAME_ATTR_.35
	.quad	l_OBJC_PROP_NAME_ATTR_.36
	.quad	l_OBJC_PROP_NAME_ATTR_.37
	.quad	l_OBJC_PROP_NAME_ATTR_.38
	.quad	l_OBJC_PROP_NAME_ATTR_.37

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.39:               ; @OBJC_METH_VAR_TYPE_.39
	.asciz	"B24@0:8@\"Protocol\"16"

l_OBJC_METH_VAR_TYPE_.40:               ; @OBJC_METH_VAR_TYPE_.40
	.asciz	"@\"NSString\"16@0:8"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROTOCOL_METHOD_TYPES_NSObject"
l_OBJC_$_PROTOCOL_METHOD_TYPES_NSObject:
	.quad	l_OBJC_METH_VAR_TYPE_
	.quad	l_OBJC_METH_VAR_TYPE_.4
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	l_OBJC_METH_VAR_TYPE_.8
	.quad	l_OBJC_METH_VAR_TYPE_.10
	.quad	l_OBJC_METH_VAR_TYPE_.12
	.quad	l_OBJC_METH_VAR_TYPE_.14
	.quad	l_OBJC_METH_VAR_TYPE_.16
	.quad	l_OBJC_METH_VAR_TYPE_.16
	.quad	l_OBJC_METH_VAR_TYPE_.39
	.quad	l_OBJC_METH_VAR_TYPE_.20
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	l_OBJC_METH_VAR_TYPE_.23
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	l_OBJC_METH_VAR_TYPE_.26
	.quad	l_OBJC_METH_VAR_TYPE_.28
	.quad	l_OBJC_METH_VAR_TYPE_.26
	.quad	l_OBJC_METH_VAR_TYPE_.4
	.quad	l_OBJC_METH_VAR_TYPE_.40
	.quad	l_OBJC_METH_VAR_TYPE_.40

	.private_extern	l_OBJC_PROTOCOL_$_NSObject ; @"\01l_OBJC_PROTOCOL_$_NSObject"
	.section	__DATA,__data
	.globl	l_OBJC_PROTOCOL_$_NSObject
	.weak_definition	l_OBJC_PROTOCOL_$_NSObject
	.p2align	3
l_OBJC_PROTOCOL_$_NSObject:
	.quad	0
	.quad	l_OBJC_CLASS_NAME_.2
	.quad	0
	.quad	l_OBJC_$_PROTOCOL_INSTANCE_METHODS_NSObject
	.quad	0
	.quad	l_OBJC_$_PROTOCOL_INSTANCE_METHODS_OPT_NSObject
	.quad	0
	.quad	l_OBJC_$_PROP_LIST_NSObject
	.long	96                      ; 0x60
	.long	0                       ; 0x0
	.quad	l_OBJC_$_PROTOCOL_METHOD_TYPES_NSObject
	.quad	0
	.quad	0

	.private_extern	l_OBJC_LABEL_PROTOCOL_$_NSObject ; @"\01l_OBJC_LABEL_PROTOCOL_$_NSObject"
	.section	__DATA,__objc_protolist,coalesced,no_dead_strip
	.globl	l_OBJC_LABEL_PROTOCOL_$_NSObject
	.weak_definition	l_OBJC_LABEL_PROTOCOL_$_NSObject
	.p2align	3
l_OBJC_LABEL_PROTOCOL_$_NSObject:
	.quad	l_OBJC_PROTOCOL_$_NSObject

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROTOCOL_REFS_UIApplicationDelegate"
l_OBJC_$_PROTOCOL_REFS_UIApplicationDelegate:
	.quad	1                       ; 0x1
	.quad	l_OBJC_PROTOCOL_$_NSObject
	.quad	0

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.41:               ; @OBJC_METH_VAR_NAME_.41
	.asciz	"applicationDidFinishLaunching:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.42:               ; @OBJC_METH_VAR_TYPE_.42
	.asciz	"v24@0:8@16"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.43:               ; @OBJC_METH_VAR_NAME_.43
	.asciz	"application:willFinishLaunchingWithOptions:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.44:               ; @OBJC_METH_VAR_TYPE_.44
	.asciz	"B32@0:8@16@24"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.45:               ; @OBJC_METH_VAR_NAME_.45
	.asciz	"application:didFinishLaunchingWithOptions:"

l_OBJC_METH_VAR_NAME_.46:               ; @OBJC_METH_VAR_NAME_.46
	.asciz	"applicationDidBecomeActive:"

l_OBJC_METH_VAR_NAME_.47:               ; @OBJC_METH_VAR_NAME_.47
	.asciz	"applicationWillResignActive:"

l_OBJC_METH_VAR_NAME_.48:               ; @OBJC_METH_VAR_NAME_.48
	.asciz	"application:handleOpenURL:"

l_OBJC_METH_VAR_NAME_.49:               ; @OBJC_METH_VAR_NAME_.49
	.asciz	"application:openURL:sourceApplication:annotation:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.50:               ; @OBJC_METH_VAR_TYPE_.50
	.asciz	"B48@0:8@16@24@32@40"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.51:               ; @OBJC_METH_VAR_NAME_.51
	.asciz	"application:openURL:options:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.52:               ; @OBJC_METH_VAR_TYPE_.52
	.asciz	"B40@0:8@16@24@32"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.53:               ; @OBJC_METH_VAR_NAME_.53
	.asciz	"applicationDidReceiveMemoryWarning:"

l_OBJC_METH_VAR_NAME_.54:               ; @OBJC_METH_VAR_NAME_.54
	.asciz	"applicationWillTerminate:"

l_OBJC_METH_VAR_NAME_.55:               ; @OBJC_METH_VAR_NAME_.55
	.asciz	"applicationSignificantTimeChange:"

l_OBJC_METH_VAR_NAME_.56:               ; @OBJC_METH_VAR_NAME_.56
	.asciz	"application:willChangeStatusBarOrientation:duration:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.57:               ; @OBJC_METH_VAR_TYPE_.57
	.asciz	"v40@0:8@16q24d32"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.58:               ; @OBJC_METH_VAR_NAME_.58
	.asciz	"application:didChangeStatusBarOrientation:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.59:               ; @OBJC_METH_VAR_TYPE_.59
	.asciz	"v32@0:8@16q24"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.60:               ; @OBJC_METH_VAR_NAME_.60
	.asciz	"application:willChangeStatusBarFrame:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.61:               ; @OBJC_METH_VAR_TYPE_.61
	.asciz	"v56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.62:               ; @OBJC_METH_VAR_NAME_.62
	.asciz	"application:didChangeStatusBarFrame:"

l_OBJC_METH_VAR_NAME_.63:               ; @OBJC_METH_VAR_NAME_.63
	.asciz	"application:didRegisterUserNotificationSettings:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.64:               ; @OBJC_METH_VAR_TYPE_.64
	.asciz	"v32@0:8@16@24"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.65:               ; @OBJC_METH_VAR_NAME_.65
	.asciz	"application:didRegisterForRemoteNotificationsWithDeviceToken:"

l_OBJC_METH_VAR_NAME_.66:               ; @OBJC_METH_VAR_NAME_.66
	.asciz	"application:didFailToRegisterForRemoteNotificationsWithError:"

l_OBJC_METH_VAR_NAME_.67:               ; @OBJC_METH_VAR_NAME_.67
	.asciz	"application:didReceiveRemoteNotification:"

l_OBJC_METH_VAR_NAME_.68:               ; @OBJC_METH_VAR_NAME_.68
	.asciz	"application:didReceiveLocalNotification:"

l_OBJC_METH_VAR_NAME_.69:               ; @OBJC_METH_VAR_NAME_.69
	.asciz	"application:handleActionWithIdentifier:forLocalNotification:completionHandler:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.70:               ; @OBJC_METH_VAR_TYPE_.70
	.asciz	"v48@0:8@16@24@32@?40"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.71:               ; @OBJC_METH_VAR_NAME_.71
	.asciz	"application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.72:               ; @OBJC_METH_VAR_TYPE_.72
	.asciz	"v56@0:8@16@24@32@40@?48"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.73:               ; @OBJC_METH_VAR_NAME_.73
	.asciz	"application:handleActionWithIdentifier:forRemoteNotification:completionHandler:"

l_OBJC_METH_VAR_NAME_.74:               ; @OBJC_METH_VAR_NAME_.74
	.asciz	"application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:"

l_OBJC_METH_VAR_NAME_.75:               ; @OBJC_METH_VAR_NAME_.75
	.asciz	"application:didReceiveRemoteNotification:fetchCompletionHandler:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.76:               ; @OBJC_METH_VAR_TYPE_.76
	.asciz	"v40@0:8@16@24@?32"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.77:               ; @OBJC_METH_VAR_NAME_.77
	.asciz	"application:performFetchWithCompletionHandler:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.78:               ; @OBJC_METH_VAR_TYPE_.78
	.asciz	"v32@0:8@16@?24"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.79:               ; @OBJC_METH_VAR_NAME_.79
	.asciz	"application:performActionForShortcutItem:completionHandler:"

l_OBJC_METH_VAR_NAME_.80:               ; @OBJC_METH_VAR_NAME_.80
	.asciz	"application:handleEventsForBackgroundURLSession:completionHandler:"

l_OBJC_METH_VAR_NAME_.81:               ; @OBJC_METH_VAR_NAME_.81
	.asciz	"application:handleWatchKitExtensionRequest:reply:"

l_OBJC_METH_VAR_NAME_.82:               ; @OBJC_METH_VAR_NAME_.82
	.asciz	"applicationShouldRequestHealthAuthorization:"

l_OBJC_METH_VAR_NAME_.83:               ; @OBJC_METH_VAR_NAME_.83
	.asciz	"application:handleIntent:completionHandler:"

l_OBJC_METH_VAR_NAME_.84:               ; @OBJC_METH_VAR_NAME_.84
	.asciz	"applicationDidEnterBackground:"

l_OBJC_METH_VAR_NAME_.85:               ; @OBJC_METH_VAR_NAME_.85
	.asciz	"applicationWillEnterForeground:"

l_OBJC_METH_VAR_NAME_.86:               ; @OBJC_METH_VAR_NAME_.86
	.asciz	"applicationProtectedDataWillBecomeUnavailable:"

l_OBJC_METH_VAR_NAME_.87:               ; @OBJC_METH_VAR_NAME_.87
	.asciz	"applicationProtectedDataDidBecomeAvailable:"

l_OBJC_METH_VAR_NAME_.88:               ; @OBJC_METH_VAR_NAME_.88
	.asciz	"application:supportedInterfaceOrientationsForWindow:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.89:               ; @OBJC_METH_VAR_TYPE_.89
	.asciz	"Q32@0:8@16@24"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.90:               ; @OBJC_METH_VAR_NAME_.90
	.asciz	"application:shouldAllowExtensionPointIdentifier:"

l_OBJC_METH_VAR_NAME_.91:               ; @OBJC_METH_VAR_NAME_.91
	.asciz	"application:viewControllerWithRestorationIdentifierPath:coder:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.92:               ; @OBJC_METH_VAR_TYPE_.92
	.asciz	"@40@0:8@16@24@32"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.93:               ; @OBJC_METH_VAR_NAME_.93
	.asciz	"application:shouldSaveApplicationState:"

l_OBJC_METH_VAR_NAME_.94:               ; @OBJC_METH_VAR_NAME_.94
	.asciz	"application:shouldRestoreApplicationState:"

l_OBJC_METH_VAR_NAME_.95:               ; @OBJC_METH_VAR_NAME_.95
	.asciz	"application:willEncodeRestorableStateWithCoder:"

l_OBJC_METH_VAR_NAME_.96:               ; @OBJC_METH_VAR_NAME_.96
	.asciz	"application:didDecodeRestorableStateWithCoder:"

l_OBJC_METH_VAR_NAME_.97:               ; @OBJC_METH_VAR_NAME_.97
	.asciz	"application:willContinueUserActivityWithType:"

l_OBJC_METH_VAR_NAME_.98:               ; @OBJC_METH_VAR_NAME_.98
	.asciz	"application:continueUserActivity:restorationHandler:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.99:               ; @OBJC_METH_VAR_TYPE_.99
	.asciz	"B40@0:8@16@24@?32"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.100:              ; @OBJC_METH_VAR_NAME_.100
	.asciz	"application:didFailToContinueUserActivityWithType:error:"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.101:              ; @OBJC_METH_VAR_TYPE_.101
	.asciz	"v40@0:8@16@24@32"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.102:              ; @OBJC_METH_VAR_NAME_.102
	.asciz	"application:didUpdateUserActivity:"

l_OBJC_METH_VAR_NAME_.103:              ; @OBJC_METH_VAR_NAME_.103
	.asciz	"application:userDidAcceptCloudKitShareWithMetadata:"

l_OBJC_METH_VAR_NAME_.104:              ; @OBJC_METH_VAR_NAME_.104
	.asciz	"window"

l_OBJC_METH_VAR_NAME_.105:              ; @OBJC_METH_VAR_NAME_.105
	.asciz	"setWindow:"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROTOCOL_INSTANCE_METHODS_OPT_UIApplicationDelegate"
l_OBJC_$_PROTOCOL_INSTANCE_METHODS_OPT_UIApplicationDelegate:
	.long	24                      ; 0x18
	.long	49                      ; 0x31
	.quad	l_OBJC_METH_VAR_NAME_.41
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.43
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.45
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.46
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.47
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.48
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.49
	.quad	l_OBJC_METH_VAR_TYPE_.50
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.51
	.quad	l_OBJC_METH_VAR_TYPE_.52
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.53
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.54
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.55
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.56
	.quad	l_OBJC_METH_VAR_TYPE_.57
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.58
	.quad	l_OBJC_METH_VAR_TYPE_.59
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.60
	.quad	l_OBJC_METH_VAR_TYPE_.61
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.62
	.quad	l_OBJC_METH_VAR_TYPE_.61
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.63
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.65
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.66
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.67
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.68
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.69
	.quad	l_OBJC_METH_VAR_TYPE_.70
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.71
	.quad	l_OBJC_METH_VAR_TYPE_.72
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.73
	.quad	l_OBJC_METH_VAR_TYPE_.70
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.74
	.quad	l_OBJC_METH_VAR_TYPE_.72
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.75
	.quad	l_OBJC_METH_VAR_TYPE_.76
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.77
	.quad	l_OBJC_METH_VAR_TYPE_.78
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.79
	.quad	l_OBJC_METH_VAR_TYPE_.76
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.80
	.quad	l_OBJC_METH_VAR_TYPE_.76
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.81
	.quad	l_OBJC_METH_VAR_TYPE_.76
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.82
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.83
	.quad	l_OBJC_METH_VAR_TYPE_.76
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.84
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.85
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.86
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.87
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.88
	.quad	l_OBJC_METH_VAR_TYPE_.89
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.90
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.91
	.quad	l_OBJC_METH_VAR_TYPE_.92
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.93
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.94
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.95
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.96
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.97
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.98
	.quad	l_OBJC_METH_VAR_TYPE_.99
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.100
	.quad	l_OBJC_METH_VAR_TYPE_.101
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.102
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.103
	.quad	l_OBJC_METH_VAR_TYPE_.64
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.104
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	0
	.quad	l_OBJC_METH_VAR_NAME_.105
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	0

	.section	__TEXT,__cstring,cstring_literals
l_OBJC_PROP_NAME_ATTR_.106:             ; @OBJC_PROP_NAME_ATTR_.106
	.asciz	"window"

l_OBJC_PROP_NAME_ATTR_.107:             ; @OBJC_PROP_NAME_ATTR_.107
	.asciz	"T@\"UIWindow\",&,N"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROP_LIST_UIApplicationDelegate"
l_OBJC_$_PROP_LIST_UIApplicationDelegate:
	.long	16                      ; 0x10
	.long	1                       ; 0x1
	.quad	l_OBJC_PROP_NAME_ATTR_.106
	.quad	l_OBJC_PROP_NAME_ATTR_.107

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.108:              ; @OBJC_METH_VAR_TYPE_.108
	.asciz	"v24@0:8@\"UIApplication\"16"

l_OBJC_METH_VAR_TYPE_.109:              ; @OBJC_METH_VAR_TYPE_.109
	.asciz	"B32@0:8@\"UIApplication\"16@\"NSDictionary\"24"

l_OBJC_METH_VAR_TYPE_.110:              ; @OBJC_METH_VAR_TYPE_.110
	.asciz	"B32@0:8@\"UIApplication\"16@\"NSURL\"24"

l_OBJC_METH_VAR_TYPE_.111:              ; @OBJC_METH_VAR_TYPE_.111
	.asciz	"B48@0:8@\"UIApplication\"16@\"NSURL\"24@\"NSString\"32@40"

l_OBJC_METH_VAR_TYPE_.112:              ; @OBJC_METH_VAR_TYPE_.112
	.asciz	"B40@0:8@\"UIApplication\"16@\"NSURL\"24@\"NSDictionary\"32"

l_OBJC_METH_VAR_TYPE_.113:              ; @OBJC_METH_VAR_TYPE_.113
	.asciz	"v40@0:8@\"UIApplication\"16q24d32"

l_OBJC_METH_VAR_TYPE_.114:              ; @OBJC_METH_VAR_TYPE_.114
	.asciz	"v32@0:8@\"UIApplication\"16q24"

l_OBJC_METH_VAR_TYPE_.115:              ; @OBJC_METH_VAR_TYPE_.115
	.asciz	"v56@0:8@\"UIApplication\"16{CGRect={CGPoint=dd}{CGSize=dd}}24"

l_OBJC_METH_VAR_TYPE_.116:              ; @OBJC_METH_VAR_TYPE_.116
	.asciz	"v32@0:8@\"UIApplication\"16@\"UIUserNotificationSettings\"24"

l_OBJC_METH_VAR_TYPE_.117:              ; @OBJC_METH_VAR_TYPE_.117
	.asciz	"v32@0:8@\"UIApplication\"16@\"NSData\"24"

l_OBJC_METH_VAR_TYPE_.118:              ; @OBJC_METH_VAR_TYPE_.118
	.asciz	"v32@0:8@\"UIApplication\"16@\"NSError\"24"

l_OBJC_METH_VAR_TYPE_.119:              ; @OBJC_METH_VAR_TYPE_.119
	.asciz	"v32@0:8@\"UIApplication\"16@\"NSDictionary\"24"

l_OBJC_METH_VAR_TYPE_.120:              ; @OBJC_METH_VAR_TYPE_.120
	.asciz	"v32@0:8@\"UIApplication\"16@\"UILocalNotification\"24"

l_OBJC_METH_VAR_TYPE_.121:              ; @OBJC_METH_VAR_TYPE_.121
	.asciz	"v48@0:8@\"UIApplication\"16@\"NSString\"24@\"UILocalNotification\"32@?<v@?>40"

l_OBJC_METH_VAR_TYPE_.122:              ; @OBJC_METH_VAR_TYPE_.122
	.asciz	"v56@0:8@\"UIApplication\"16@\"NSString\"24@\"NSDictionary\"32@\"NSDictionary\"40@?<v@?>48"

l_OBJC_METH_VAR_TYPE_.123:              ; @OBJC_METH_VAR_TYPE_.123
	.asciz	"v48@0:8@\"UIApplication\"16@\"NSString\"24@\"NSDictionary\"32@?<v@?>40"

l_OBJC_METH_VAR_TYPE_.124:              ; @OBJC_METH_VAR_TYPE_.124
	.asciz	"v56@0:8@\"UIApplication\"16@\"NSString\"24@\"UILocalNotification\"32@\"NSDictionary\"40@?<v@?>48"

l_OBJC_METH_VAR_TYPE_.125:              ; @OBJC_METH_VAR_TYPE_.125
	.asciz	"v40@0:8@\"UIApplication\"16@\"NSDictionary\"24@?<v@?Q>32"

l_OBJC_METH_VAR_TYPE_.126:              ; @OBJC_METH_VAR_TYPE_.126
	.asciz	"v32@0:8@\"UIApplication\"16@?<v@?Q>24"

l_OBJC_METH_VAR_TYPE_.127:              ; @OBJC_METH_VAR_TYPE_.127
	.asciz	"v40@0:8@\"UIApplication\"16@\"UIApplicationShortcutItem\"24@?<v@?B>32"

l_OBJC_METH_VAR_TYPE_.128:              ; @OBJC_METH_VAR_TYPE_.128
	.asciz	"v40@0:8@\"UIApplication\"16@\"NSString\"24@?<v@?>32"

l_OBJC_METH_VAR_TYPE_.129:              ; @OBJC_METH_VAR_TYPE_.129
	.asciz	"v40@0:8@\"UIApplication\"16@\"NSDictionary\"24@?<v@?@\"NSDictionary\">32"

l_OBJC_METH_VAR_TYPE_.130:              ; @OBJC_METH_VAR_TYPE_.130
	.asciz	"v40@0:8@\"UIApplication\"16@\"INIntent\"24@?<v@?@\"INIntentResponse\">32"

l_OBJC_METH_VAR_TYPE_.131:              ; @OBJC_METH_VAR_TYPE_.131
	.asciz	"Q32@0:8@\"UIApplication\"16@\"UIWindow\"24"

l_OBJC_METH_VAR_TYPE_.132:              ; @OBJC_METH_VAR_TYPE_.132
	.asciz	"B32@0:8@\"UIApplication\"16@\"NSString\"24"

l_OBJC_METH_VAR_TYPE_.133:              ; @OBJC_METH_VAR_TYPE_.133
	.asciz	"@\"UIViewController\"40@0:8@\"UIApplication\"16@\"NSArray\"24@\"NSCoder\"32"

l_OBJC_METH_VAR_TYPE_.134:              ; @OBJC_METH_VAR_TYPE_.134
	.asciz	"B32@0:8@\"UIApplication\"16@\"NSCoder\"24"

l_OBJC_METH_VAR_TYPE_.135:              ; @OBJC_METH_VAR_TYPE_.135
	.asciz	"v32@0:8@\"UIApplication\"16@\"NSCoder\"24"

l_OBJC_METH_VAR_TYPE_.136:              ; @OBJC_METH_VAR_TYPE_.136
	.asciz	"B40@0:8@\"UIApplication\"16@\"NSUserActivity\"24@?<v@?@\"NSArray\">32"

l_OBJC_METH_VAR_TYPE_.137:              ; @OBJC_METH_VAR_TYPE_.137
	.asciz	"v40@0:8@\"UIApplication\"16@\"NSString\"24@\"NSError\"32"

l_OBJC_METH_VAR_TYPE_.138:              ; @OBJC_METH_VAR_TYPE_.138
	.asciz	"v32@0:8@\"UIApplication\"16@\"NSUserActivity\"24"

l_OBJC_METH_VAR_TYPE_.139:              ; @OBJC_METH_VAR_TYPE_.139
	.asciz	"v32@0:8@\"UIApplication\"16@\"CKShareMetadata\"24"

l_OBJC_METH_VAR_TYPE_.140:              ; @OBJC_METH_VAR_TYPE_.140
	.asciz	"@\"UIWindow\"16@0:8"

l_OBJC_METH_VAR_TYPE_.141:              ; @OBJC_METH_VAR_TYPE_.141
	.asciz	"v24@0:8@\"UIWindow\"16"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROTOCOL_METHOD_TYPES_UIApplicationDelegate"
l_OBJC_$_PROTOCOL_METHOD_TYPES_UIApplicationDelegate:
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.109
	.quad	l_OBJC_METH_VAR_TYPE_.109
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.110
	.quad	l_OBJC_METH_VAR_TYPE_.111
	.quad	l_OBJC_METH_VAR_TYPE_.112
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.113
	.quad	l_OBJC_METH_VAR_TYPE_.114
	.quad	l_OBJC_METH_VAR_TYPE_.115
	.quad	l_OBJC_METH_VAR_TYPE_.115
	.quad	l_OBJC_METH_VAR_TYPE_.116
	.quad	l_OBJC_METH_VAR_TYPE_.117
	.quad	l_OBJC_METH_VAR_TYPE_.118
	.quad	l_OBJC_METH_VAR_TYPE_.119
	.quad	l_OBJC_METH_VAR_TYPE_.120
	.quad	l_OBJC_METH_VAR_TYPE_.121
	.quad	l_OBJC_METH_VAR_TYPE_.122
	.quad	l_OBJC_METH_VAR_TYPE_.123
	.quad	l_OBJC_METH_VAR_TYPE_.124
	.quad	l_OBJC_METH_VAR_TYPE_.125
	.quad	l_OBJC_METH_VAR_TYPE_.126
	.quad	l_OBJC_METH_VAR_TYPE_.127
	.quad	l_OBJC_METH_VAR_TYPE_.128
	.quad	l_OBJC_METH_VAR_TYPE_.129
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.130
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.108
	.quad	l_OBJC_METH_VAR_TYPE_.131
	.quad	l_OBJC_METH_VAR_TYPE_.132
	.quad	l_OBJC_METH_VAR_TYPE_.133
	.quad	l_OBJC_METH_VAR_TYPE_.134
	.quad	l_OBJC_METH_VAR_TYPE_.134
	.quad	l_OBJC_METH_VAR_TYPE_.135
	.quad	l_OBJC_METH_VAR_TYPE_.135
	.quad	l_OBJC_METH_VAR_TYPE_.132
	.quad	l_OBJC_METH_VAR_TYPE_.136
	.quad	l_OBJC_METH_VAR_TYPE_.137
	.quad	l_OBJC_METH_VAR_TYPE_.138
	.quad	l_OBJC_METH_VAR_TYPE_.139
	.quad	l_OBJC_METH_VAR_TYPE_.140
	.quad	l_OBJC_METH_VAR_TYPE_.141

	.private_extern	l_OBJC_PROTOCOL_$_UIApplicationDelegate ; @"\01l_OBJC_PROTOCOL_$_UIApplicationDelegate"
	.section	__DATA,__data
	.globl	l_OBJC_PROTOCOL_$_UIApplicationDelegate
	.weak_definition	l_OBJC_PROTOCOL_$_UIApplicationDelegate
	.p2align	3
l_OBJC_PROTOCOL_$_UIApplicationDelegate:
	.quad	0
	.quad	l_OBJC_CLASS_NAME_.1
	.quad	l_OBJC_$_PROTOCOL_REFS_UIApplicationDelegate
	.quad	0
	.quad	0
	.quad	l_OBJC_$_PROTOCOL_INSTANCE_METHODS_OPT_UIApplicationDelegate
	.quad	0
	.quad	l_OBJC_$_PROP_LIST_UIApplicationDelegate
	.long	96                      ; 0x60
	.long	0                       ; 0x0
	.quad	l_OBJC_$_PROTOCOL_METHOD_TYPES_UIApplicationDelegate
	.quad	0
	.quad	0

	.private_extern	l_OBJC_LABEL_PROTOCOL_$_UIApplicationDelegate ; @"\01l_OBJC_LABEL_PROTOCOL_$_UIApplicationDelegate"
	.section	__DATA,__objc_protolist,coalesced,no_dead_strip
	.globl	l_OBJC_LABEL_PROTOCOL_$_UIApplicationDelegate
	.weak_definition	l_OBJC_LABEL_PROTOCOL_$_UIApplicationDelegate
	.p2align	3
l_OBJC_LABEL_PROTOCOL_$_UIApplicationDelegate:
	.quad	l_OBJC_PROTOCOL_$_UIApplicationDelegate

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_CLASS_PROTOCOLS_$_AppDelegate"
l_OBJC_CLASS_PROTOCOLS_$_AppDelegate:
	.quad	1                       ; 0x1
	.quad	l_OBJC_PROTOCOL_$_UIApplicationDelegate
	.quad	0

	.p2align	3               ; @"\01l_OBJC_METACLASS_RO_$_AppDelegate"
l_OBJC_METACLASS_RO_$_AppDelegate:
	.long	1                       ; 0x1
	.long	40                      ; 0x28
	.long	40                      ; 0x28
	.space	4
	.quad	0
	.quad	l_OBJC_CLASS_NAME_
	.quad	0
	.quad	l_OBJC_CLASS_PROTOCOLS_$_AppDelegate
	.quad	0
	.quad	0
	.quad	0

	.section	__DATA,__objc_data
	.globl	_OBJC_METACLASS_$_AppDelegate ; @"OBJC_METACLASS_$_AppDelegate"
	.p2align	3
_OBJC_METACLASS_$_AppDelegate:
	.quad	_OBJC_METACLASS_$_NSObject
	.quad	_OBJC_METACLASS_$_UIResponder
	.quad	__objc_empty_cache
	.quad	0
	.quad	l_OBJC_METACLASS_RO_$_AppDelegate

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_INSTANCE_METHODS_AppDelegate"
l_OBJC_$_INSTANCE_METHODS_AppDelegate:
	.long	24                      ; 0x18
	.long	8                       ; 0x8
	.quad	l_OBJC_METH_VAR_NAME_.45
	.quad	l_OBJC_METH_VAR_TYPE_.44
	.quad	"-[AppDelegate application:didFinishLaunchingWithOptions:]"
	.quad	l_OBJC_METH_VAR_NAME_.47
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	"-[AppDelegate applicationWillResignActive:]"
	.quad	l_OBJC_METH_VAR_NAME_.84
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	"-[AppDelegate applicationDidEnterBackground:]"
	.quad	l_OBJC_METH_VAR_NAME_.85
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	"-[AppDelegate applicationWillEnterForeground:]"
	.quad	l_OBJC_METH_VAR_NAME_.46
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	"-[AppDelegate applicationDidBecomeActive:]"
	.quad	l_OBJC_METH_VAR_NAME_.54
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	"-[AppDelegate applicationWillTerminate:]"
	.quad	l_OBJC_METH_VAR_NAME_.104
	.quad	l_OBJC_METH_VAR_TYPE_.6
	.quad	"-[AppDelegate window]"
	.quad	l_OBJC_METH_VAR_NAME_.105
	.quad	l_OBJC_METH_VAR_TYPE_.42
	.quad	"-[AppDelegate setWindow:]"

	.section	__TEXT,__objc_methname,cstring_literals
l_OBJC_METH_VAR_NAME_.142:              ; @OBJC_METH_VAR_NAME_.142
	.asciz	"_window"

	.section	__TEXT,__objc_methtype,cstring_literals
l_OBJC_METH_VAR_TYPE_.143:              ; @OBJC_METH_VAR_TYPE_.143
	.asciz	"@\"UIWindow\""

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_INSTANCE_VARIABLES_AppDelegate"
l_OBJC_$_INSTANCE_VARIABLES_AppDelegate:
	.long	32                      ; 0x20
	.long	1                       ; 0x1
	.quad	_OBJC_IVAR_$_AppDelegate._window
	.quad	l_OBJC_METH_VAR_NAME_.142
	.quad	l_OBJC_METH_VAR_TYPE_.143
	.long	3                       ; 0x3
	.long	8                       ; 0x8

	.section	__TEXT,__cstring,cstring_literals
l_OBJC_PROP_NAME_ATTR_.144:             ; @OBJC_PROP_NAME_ATTR_.144
	.asciz	"T@\"UIWindow\",&,N,V_window"

	.section	__DATA,__objc_const
	.p2align	3               ; @"\01l_OBJC_$_PROP_LIST_AppDelegate"
l_OBJC_$_PROP_LIST_AppDelegate:
	.long	16                      ; 0x10
	.long	5                       ; 0x5
	.quad	l_OBJC_PROP_NAME_ATTR_.106
	.quad	l_OBJC_PROP_NAME_ATTR_.144
	.quad	l_OBJC_PROP_NAME_ATTR_
	.quad	l_OBJC_PROP_NAME_ATTR_.33
	.quad	l_OBJC_PROP_NAME_ATTR_.34
	.quad	l_OBJC_PROP_NAME_ATTR_.35
	.quad	l_OBJC_PROP_NAME_ATTR_.36
	.quad	l_OBJC_PROP_NAME_ATTR_.37
	.quad	l_OBJC_PROP_NAME_ATTR_.38
	.quad	l_OBJC_PROP_NAME_ATTR_.37

	.p2align	3               ; @"\01l_OBJC_CLASS_RO_$_AppDelegate"
l_OBJC_CLASS_RO_$_AppDelegate:
	.long	0                       ; 0x0
	.long	8                       ; 0x8
	.long	16                      ; 0x10
	.space	4
	.quad	0
	.quad	l_OBJC_CLASS_NAME_
	.quad	l_OBJC_$_INSTANCE_METHODS_AppDelegate
	.quad	l_OBJC_CLASS_PROTOCOLS_$_AppDelegate
	.quad	l_OBJC_$_INSTANCE_VARIABLES_AppDelegate
	.quad	0
	.quad	l_OBJC_$_PROP_LIST_AppDelegate

	.section	__DATA,__objc_data
	.globl	_OBJC_CLASS_$_AppDelegate ; @"OBJC_CLASS_$_AppDelegate"
	.p2align	3
_OBJC_CLASS_$_AppDelegate:
	.quad	_OBJC_METACLASS_$_AppDelegate
	.quad	_OBJC_CLASS_$_UIResponder
	.quad	__objc_empty_cache
	.quad	0
	.quad	l_OBJC_CLASS_RO_$_AppDelegate

	.section	__DATA,__objc_classlist,regular,no_dead_strip
	.p2align	3               ; @"OBJC_LABEL_CLASS_$"
l_OBJC_LABEL_CLASS_$:
	.quad	_OBJC_CLASS_$_AppDelegate

	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	64


.subsections_via_symbols
