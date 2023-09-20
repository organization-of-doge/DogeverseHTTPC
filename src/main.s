.3ds

.open "code.bin", "build/patched_code.bin", 0x100000

replace_hook_addr equ 0x113868
replace_function_addr equ 0x11AA70

.org replace_hook_addr
	replace_hook:
		bl replace_func_jump ; Load our custom code instead of the normal address (0xE04C)
		
.org replace_function_addr
	; moves the char* from r5 into r0, then jumps to the code that replaces stuff in it
	replace_func_jump: ; 0x1aa70
		mov     r0, r5
		b       handle_replacements
		
	func_1: ; 0x1aa78
		str     r11, [sp, #-4]!
		add     r11, sp, #0
		sub     sp, sp, #0xc
		str     r0, [r11, #-8]
		str     r1, [r11, #-0xc]
		b       func_1_lab_3
		
	func_1_lab_1: ; 0x1aa90
		ldr     r3, [r11, #-8]
		ldrb    r2, [r3]
		ldr     r3, [r11, #-0xc]
		ldrb    r3, [r3]
		cmp     r2, r3
		beq     func_1_lab_2
		mov     r3, #0
		b       func_1_lab_5
		
	func_1_lab_2: ; 0x1aab0
		ldr     r3, [r11, #-8]
		add     r3, r3, #1
		str     r3, [r11, #-8]
		ldr     r3, [r11, #-0xc]
		add     r3, r3, #1
		str     r3, [r11, #-0xc]
		
	func_1_lab_3: ; 0x1aac8
		ldr     r3, [r11, #-8]
		ldrb    r3, [r3]
		cmp     r3, #0
		beq     func_1_lab_4
		ldr     r3, [r11, #-0xc]
		ldrb    r3, [r3]
		cmp     r3, #0
		bne     func_1_lab_1
		
	func_1_lab_4: ; 0x1aae8
		ldr     r3, [r11, #-0xc]
		ldrb    r3, [r3]
		cmp     r3, #0
		moveq   r3, #1
		movne   r3, #0
		and     r3, r3, #0xff
		
	func_1_lab_5: ; 0x1ab00
		mov     r0, r3
		sub     sp, r11, #0
		ldr     r11, [sp], #0x4
		bx      lr
		
	func_2: ; 0x1ab10
		push    {r11, lr}
		add     r11, sp, #4
		sub     sp, sp, #8
		str     r0, [r11, #-8]
		str     r1, [r11, #-0xc]
		b       func_2_lab_3
		
	func_2_lab_1: ; 0x1ab28
		ldr     r3, [r11, #-8]
		ldrb    r2, [r3]
		ldr     r3, [r11, #-0xc]
		ldrb    r3, [r3]
		cmp     r2, r3
		bne     func_2_lab_2
		ldr     r1, [r11, #-0xc]
		ldr     r0, [r11, #-8]
		bl      func_1
		mov     r3, r0
		cmp     r3, #0
		beq     func_2_lab_2
		ldr     r3, [r11, #-8]
		b       func_2_lab_4
		
	func_2_lab_2: ; 0x1ab60
		ldr     r3, [r11, #-8]
		add     r3, r3, #1
		str     r3, [r11, #-8]
		
	func_2_lab_3: ; 0x1ab6c
		ldr     r3, [r11, #-8]
		ldrb    r3, [r3]
		cmp     r3, #0
		bne     func_2_lab_1
		mov     r3, #0
		
	func_2_lab_4: ; 0x1ab80
		mov     r0, r3
		sub     sp, r11, #4
		pop     {r11, lr}
		bx      lr
		
	func_3: ; 0x1ab90
		str     r11, [sp, #-4]!
		add     r11, sp, #0
		sub     sp, sp, #0x24
		str     r0, [r11, #-0x18]
		str     r1, [r11, #-0x1c]
		str     r2, [r11, #-0x20]
		ldr     r3, [r11, #-0x1c]
		str     r3, [r11, #-0xc]
		ldr     r3, [r11, #-0x18]
		str     r3, [r11, #-0x10]
		mov     r3, #0
		str     r3, [r11, #-8]
		b       func_3_lab_2
		
	func_3_lab_1: ; 0x1abc4
		ldr     r3, [r11, #-8]
		ldr     r2, [r11, #-0x10]
		add     r3, r2, r3
		ldr     r2, [r11, #-8]
		ldr     r1, [r11, #-0xc]
		add     r2, r1, r2
		ldrb    r2, [r2]
		strb    r2, [r3]
		ldr     r3, [r11, #-8]
		add     r3, r3, #1
		str     r3, [r11, #-8]
		
	func_3_lab_2: ; 0x1abf0
		ldr     r2, [r11, #-8]
		ldr     r3, [r11, #-0x20]
		cmp     r2, r3
		blt     func_3_lab_1
		mov     r0, r0
		sub     sp, r11, #0
		ldr     r11, [sp], #4
		bx      lr
		
	func_4: ; 0x1ac10
		str     r11, [sp, #-4]!
		add     r11, sp, #0
		sub     sp, sp, #0x24
		str     r0, [r11, #-0x18]
		str     r1, [r11, #-0x1c]
		str     r2, [r11, #-0x20]
		ldr     r3, [r11, #-0x1c]
		str     r3, [r11, #-0x10]
		ldr     r3, [r11, #-0x18]
		str     r3, [r11, #-0x14]
		mov     r3, #0
		str     r3, [r11, #-8]
		b       func_4_lab_2
		
	func_4_lab_1: ; 0x1ac44
		ldr     r3, [r11, #-8]
		add     r3, r3, #0x8000000
		add     r3, r3, #0x1000
		ldr     r2, [r11, #-8]
		ldr     r1, [r11, #-0x10]
		add     r2, r1, r2
		ldrb    r2, [r2]
		strb    r2, [r3]
		ldr     r3, [r11, #-8]
		add     r3, r3, #1
		str     r3, [r11, #-8]
		
	func_4_lab_2: ; 0x1ac70
		ldr     r2, [r11, #-8]
		ldr     r3, [r11, #-0x20]
		cmp     r2, r3
		blt     func_4_lab_1
		mov     r3, #0
		str     r3, [r11, #-0xc]
		b       func_4_lab_4
		
	func_4_lab_3: ; 0x1ac8c
		ldr     r3, [r11, #-0xc]
		ldr     r2, [r11, #-0x14]
		add     r2, r2, r3
		ldr     r3, [r11, #-0xc]
		add     r3, r3, #0x8000000
		add     r3, r3, #0x1000
		ldrb    r3, [r3]
		strb    r3, [r2]
		ldr     r3, [r11, #-0xc]
		add     r3, r3, #1
		str     r3, [r11, #-0xc]
		
	func_4_lab_4: ; 0x1acb8
		ldr     r2, [r11, #-0xc]
		ldr     r3, [r11, #-0x20]
		cmp     r2, r3
		blt     func_4_lab_3
		mov     r0, r0
		sub     sp, r11, #0
		ldr     r11, [sp], #4
		bx      lr
		
	func_5: ; 0x1acd8
		str     r11, [sp, #-4]!
		add     r11, sp, #0
		sub     sp, sp, #0x14
		str     r0, [r11, #-0x10]
		mov     r3, #0
		str     r3, [r11, #-8]
		b       func_5_lab_2
		
	func_5_lab_1: ; 0x1acf4
		ldr     r3, [r11, #-8]
		add     r3, r3, #1
		str     r3, [r11, #-8]
		ldr     r3, [r11, #-0x10]
		add     r3, r3, #1
		str     r3, [r11, #-0x10]
		
	func_5_lab_2: ; 0x1ad0c
		ldr     r3, [r11, #-0x10]
		ldrb    r3, [r3]
		cmp     r3, #0
		bne     func_5_lab_1
		ldr     r3, [r11, #-8]
		mov     r0, r3
		sub     sp, r11, #0
		ldr     r11, [sp], #4
		bx      lr
		
	; takes a char* in r0, things to find in r1, and things to replace the found data with in r2
	find_and_replace: ; 0x1ad30
		push    {r11, lr}
		add     r11, sp, #4
		sub     sp, sp, #0x20
		str     r0, [r11, #-0x18]
		str     r1, [r11, #-0x1c]
		str     r2, [r11, #-0x20]
		ldr     r1, [r11, #-0x1c]
		ldr     r0, [r11, #-0x18]
		bl      func_2
		str     r0, [r11, #-8]
		ldr     r3, [r11, #-8]
		cmp     r3, #0
		beq     find_and_replace_lab_1
		ldr     r0, [r11, #-0x1c]
		bl      func_5
		mov     r3, r0
		str     r3, [r11, #-0xc]
		ldr     r0, [r11, #-0x20]
		bl      func_5
		mov     r3, r0
		str     r3, [r11, #-0x10]
		ldr     r3, [r11, #-0xc]
		ldr     r2, [r11, #-8]
		add     r3, r2, r3
		mov     r0, r3
		bl      func_5
		mov     r3, r0
		str     r3, [r11, #-0x14]
		ldr     r3, [r11, #-0x10]
		ldr     r2, [r11, #-8]
		add     r0, r2, r3
		ldr     r3, [r11, #-0xc]
		ldr     r2, [r11, #-8]
		add     r1, r2, r3
		ldr     r3, [r11, #-0x14]
		add     r3, r3, #1
		mov     r2, r3
		bl      func_4
		ldr     r2, [r11, #-0x10]
		ldr     r1, [r11, #-0x20]
		ldr     r0, [r11, #-8]
		bl      func_3
		b       find_and_replace_lab_2
		
	find_and_replace_lab_1: ; 0x1addc
		mov     r0, r0
		
	find_and_replace_lab_2: ; 0x1ade0
		sub     sp, r11, #4
		ldmia   sp!, {r11, lr}
		bx      lr
		
	handle_replacements: ; 0x1adec
		stmdb   sp!, {r11, lr}
		add     r11, sp, #4
		sub     sp, sp, #0x28
		str     r0, [r11, #-0x28] ; store r0 (our char* we are replacing string stuff on) into stack -0x28
		
		ldr     r3, =target1
		str     r3, [r11, #-0x8] ; store the just loaded target1 into stack -0x8
		ldr     r3, =replacementPretendo 
		str     r3, [r11, #-0xc] ; store the just loaded replacementPretendo into stack -0xc
		ldr     r3, =target2
		str     r3, [r11, #-0x10] ; store the just loaded target2 into stack -0x10
		ldr     r3, =replacementPretendo
		str     r3, [r11, #-0x14] ; store the just loaded (again) replacementPretendo into stack -0x14
		ldr     r3, =target3
		str     r3, [r11, #-0x18] ; store the just loaded target3 into stack -0x18
		ldr     r3, =replacement3
		str     r3, [r11, #-0x1c] ; store the just loaded replacement3 into stack -0x1c
		ldr     r3, =target4
		str     r3, [r11, #-0x20] ; store the just loaded target4 into stack -0x20
		ldr     r3, =replacement4
		str     r3, [r11, #-0x24] ; store the just loaded replacement4 into stack -0x24
		
		ldr     r2, [r11, #-0xc] ; load replacementPretendo into r2
		ldr     r1, [r11, #-0x8] ; load target1 into r1
		ldr     r0, [r11, #-0x28] ; load our char* back into r0
		bl      find_and_replace
		ldr     r2, [r11, #-0x14] ; load replacementPretendo into r2 (again)
		ldr     r1, [r11, #-0x10] ; load target2 into r1
		ldr     r0, [r11, #-0x28] ; load our char* back into r0 (again)
		bl      find_and_replace
		ldr     r2, [r11, #-0x1c] ; load replacement3 into r2
		ldr     r1, [r11, #-0x18] ; load target3 into r1
		ldr     r0, [r11, #-0x28] ; load our char* back into r0 (yet again)
		bl      find_and_replace
		ldr     r2, [r11, #-0x24] ; load replacement4 into r2
		ldr     r1, [r11, #-0x20] ; load target4 into r1
		ldr     r0, [r11, #-0x28] ; load our char* back into r0 (for the last time)
		bl      find_and_replace
		
		mov     r0, r0
		mov     r0, r3
		sub     sp, r11, #4
		pop     {r11, lr}
		bx      lr
		
		
; strings
	.pool
		
	target1:
		.ascii "nintendowifi", 0, 0, 0, 0
	
	replacementPretendo:
		.ascii "pretendo", 0, 0, 0, 0
		
	target2:
		.ascii "nintendo", 0, 0, 0, 0
		
	target3:
		.ascii ".net", 0, 0, 0, 0
		
	replacement3:
		.ascii ".cc", 0
		
	target4:
		.ascii "https", 0, 0, 0
		
	replacement4:
		.ascii "http", 0, 0, 0, 0

.close
