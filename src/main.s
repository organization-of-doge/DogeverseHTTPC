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
		
    strlen:
        push    {r4, lr}          ; save r4

        mov     r3, #0            ; initialize the length with 0
        b       strlen_loop       ; jump to the start of the loop

    strlen_loop:
        add     r3, r3, #1        ; increment the length by 1
        ldrb    r4, [r0], #1      ; load the byte at r0 (string pointer) into r4 and increment r0
        cmp     r4, #0            ; compare it with null terminator
        bne     strlen_loop       ; if not null terminator, continue the loop
        
        mov     r0, r3            ; move the length to r0 (the return value)
        pop     {r4, lr}          ; restore r4
        bx      lr                ; return
		
	;														  (r0)					   (r1)			 (r2)
	; returns modified char* in r0, func variables are (char* stringToReplaceOn, char* target, char* replacement)
	find_and_replace: ; 0x1ad30
		push    {r11, lr}
		add     r11, sp, #4
		sub     sp, sp, #0x20
		str     r0, [r11, #-0x18]
		str     r1, [r11, #-0x1c]
		str     r2, [r11, #-0x20]
		ldr     r1, [r11, #-0x1c]
		ldr     r0, [r11, #-0x18]
		bl      strstr
		str     r0, [r11, #-8]
		ldr     r3, [r11, #-8]
		cmp     r3, #0
		beq     find_and_replace_lab_1
		ldr     r0, [r11, #-0x1c]
		bl      strlen
		mov     r3, r0
		str     r3, [r11, #-0xc]
		ldr     r0, [r11, #-0x20]
		bl      strlen
		mov     r3, r0
		str     r3, [r11, #-0x10]
		ldr     r3, [r11, #-0xc]
		ldr     r2, [r11, #-8]
		add     r3, r2, r3
		mov     r0, r3
		bl      strlen
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
		bl      memcpy
		ldr     r2, [r11, #-0x10]
		ldr     r1, [r11, #-0x20]
		ldr     r0, [r11, #-8]
		bl      memcpy
		b       find_and_replace_lab_2
		
	find_and_replace_lab_1: ; 0x1addc
		mov     r0, r0
		
	find_and_replace_lab_2: ; 0x1ade0
		sub     sp, r11, #4
		pop     {r11, lr}
		bx      lr
		
	handle_replacements: ; 0x1adec
		push    {r11, lr}
		add     r11, sp, #4
		sub     sp, sp, #0x28
		str     r0, [r11, #-0x28] ; store r0 (our char* we are replacing string stuff on) into stack -0x28
		bl      get_local_account_id ; get the local account id
		cmp     r0, #2 ; check if r0 is 2
		bne     handle_replacements_end ; if it isnt, skip the replacements
		
		; else, run the replacements
		ldr     r3, =target1
		str     r3, [r11, #-0x8] ; store the just loaded target1 into stack -0x8
		ldr     r3, =replacementPretendo 
		str     r3, [r11, #-0xc] ; store the just loaded replacementPretendo into stack -0xc
		ldr     r3, =target2
		str     r3, [r11, #-0x10] ; store the just loaded target2 into stack -0x10
		ldr     r3, =replacementPretendo
		str     r3, [r11, #-0x14] ; store the just loaded (again) replacementPretendo into stack -0x14
		
		ldr     r2, [r11, #-0xc] ; load replacementPretendo into r2
		ldr     r1, [r11, #-0x8] ; load target1 into r1
		ldr     r0, [r11, #-0x28] ; load our char* back into r0
		bl      find_and_replace
		ldr     r2, [r11, #-0x14] ; load replacementPretendo into r2 (again)
		ldr     r1, [r11, #-0x10] ; load target2 into r1
		ldr     r0, [r11, #-0x28] ; load our char* back into r0 (again)
		bl      find_and_replace
		
	handle_replacements_end:
		mov     r0, r0
		mov     r0, r3
		sub     sp, r11, #4
		pop     {r11, lr}
		bx      lr
	
	get_local_account_id:
		push    {r11, lr}
		
		mrc     p15, 0x0, r1, c13, c0, 0x3 ; get our thread local storage and store it in r1
		ldr     r0, =0x000B0000            ; load frd:u GetMyLocalAccountId header into r0
		str     r0, [r1, #0x80]            ; set cmdbuf[0] to our cmdhdr from r0
		bl      get_frd_u_handle
		swi     0x32                       ; send the request
		mrc     p15, 0x0, r1, c13, c0, 0x3 ; get our thread local storage and store it in r1. again.
		ldr     r2, [r1, #0x84]            ; load result into r2
		cmn     r2, #0                     ; check if r2 is negative
		bmi     get_local_account_id_clear ; if it is, go to the clear label to clear r0 and not return anything
		ldr     r0, [r1, #0x88]            ; get our localAccountId from cmdbuf[2] to return and store it in r0
		b       get_local_account_id_end   ; jump to the end
		
	get_local_account_id_clear:
		mov     r0, #0
		
	get_local_account_id_end:
		pop     {r11, lr}
		bx      lr
		
	get_frd_u_handle:
		push    {r1, r11, lr}
		
		mrc     p15, 0x0, r1, c13, c0, 0x3 ; get our thread local storage and store it in r1
		ldr     r0, =0x00050100            ; load ipc handle request address into r0
		str     r0, [r1, #0x80]!           ; set cmdbuf[0] to our cmdhdr from r0
		ldr     r0, =frd_handle            ; load frdu name into r0
		bl      strlen                     ; get length of frd_handle
		str     r0, [r1, #0xc]             ; store frd_handle into cmdbuf[3]
		mov     r0, #0                     ; move 0 into r0
		str     r0, [r1, #0x10]            ; store 0 into cmdbuf[4] to make it non-blocking
		swi     0x32
		
		pop     {r1, r11, lr}
		bx      lr
		
		
		
		
		
; strings
	.pool
	
	srv_handle:
		.ascii "srv:", 0
		
	frd_handle:
		.ascii "frd:u", 0
		
	target1:
		.ascii "nintendowifi.net", 0, 0
	
	replacementPretendo:
		.ascii "pretendo.cc", 0, 0
		
	target2:
		.ascii "nintendo.net", 0, 0
		
; extra data

; srv_handle_store:
; .byte 0, 0, 0, 0

; frd_handle_store:
; .byte 0, 0, 0, 0

.close
