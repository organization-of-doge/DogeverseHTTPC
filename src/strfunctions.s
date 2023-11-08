strcmp: ; 0x1aa78
	str     r11, [sp, #-4]!
	add     r11, sp, #0
	sub     sp, sp, #0xc
	str     r0, [r11, #-8]
	str     r1, [r11, #-0xc]
	b       strcmp_lab_3
	
strcmp_lab_1: ; 0x1aa90
	ldr     r3, [r11, #-8]
	ldrb    r2, [r3]
	ldr     r3, [r11, #-0xc]
	ldrb    r3, [r3]
	cmp     r2, r3
	beq     strcmp_lab_2
	mov     r3, #0
	b       strcmp_lab_5
	
strcmp_lab_2: ; 0x1aab0
	ldr     r3, [r11, #-8]
	add     r3, r3, #1
	str     r3, [r11, #-8]
	ldr     r3, [r11, #-0xc]
	add     r3, r3, #1
	str     r3, [r11, #-0xc]
	
strcmp_lab_3: ; 0x1aac8
	ldr     r3, [r11, #-8]
	ldrb    r3, [r3]
	cmp     r3, #0
	beq     strcmp_lab_4
	ldr     r3, [r11, #-0xc]
	ldrb    r3, [r3]
	cmp     r3, #0
	bne     strcmp_lab_1
	
strcmp_lab_4: ; 0x1aae8
	ldr     r3, [r11, #-0xc]
	ldrb    r3, [r3]
	cmp     r3, #0
	moveq   r3, #1
	movne   r3, #0
	and     r3, r3, #0xff
	
strcmp_lab_5: ; 0x1ab00
	mov     r0, r3
	sub     sp, r11, #0
	ldr     r11, [sp], #0x4
	bx      lr
	
strstr: ; 0x1ab10
	push    {r11, lr}
	add     r11, sp, #4
	sub     sp, sp, #8
	str     r0, [r11, #-8]
	str     r1, [r11, #-0xc]
	b       strstr_lab_3
	
strstr_lab_1: ; 0x1ab28
	ldr     r3, [r11, #-8]
	ldrb    r2, [r3]
	ldr     r3, [r11, #-0xc]
	ldrb    r3, [r3]
	cmp     r2, r3
	bne     strstr_lab_2
	ldr     r1, [r11, #-0xc]
	ldr     r0, [r11, #-8]
	bl      strcmp
	mov     r3, r0
	cmp     r3, #0
	beq     strstr_lab_2
	ldr     r3, [r11, #-8]
	b       strstr_lab_4
	
strstr_lab_2: ; 0x1ab60
	ldr     r3, [r11, #-8]
	add     r3, r3, #1
	str     r3, [r11, #-8]
	
strstr_lab_3: ; 0x1ab6c
	ldr     r3, [r11, #-8]
	ldrb    r3, [r3]
	cmp     r3, #0
	bne     strstr_lab_1
	mov     r3, #0
	
strstr_lab_4: ; 0x1ab80
	mov     r0, r3
	sub     sp, r11, #4
	pop     {r11, lr}
	bx      lr
	
memcpy: ; 0x1ab90
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
	b       memcpy_lab_2
	
memcpy_lab_1: ; 0x1abc4
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
	
memcpy_lab_2: ; 0x1abf0
	ldr     r2, [r11, #-8]
	ldr     r3, [r11, #-0x20]
	cmp     r2, r3
	blt     memcpy_lab_1
	mov     r0, r0
	sub     sp, r11, #0
	ldr     r11, [sp], #4
	bx      lr

strlen: ; 0x1ac10
	push    {r4, lr}          ; save r4

	mov     r3, #0            ; initialize the length with 0
	b       strlen_loop       ; jump to the start of the loop

strlen_loop: ; 0x1ac1c
	ldrb    r4, [r0], #1      ; load the byte at r0 (string pointer) into r4 and increment r0
	cmp     r4, #0            ; compare it with null terminator
	addne   r3, r3, #1        ; increment the length by 1
	bne     strlen_loop       ; if not null terminator, continue the loop

	mov     r0, r3            ; move the length to r0 (the return value)
	pop     {r4, lr}          ; restore r4
	bx      lr                ; return