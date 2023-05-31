
build/nanox/bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0de0000 <main>:
    libcall_params[2] = RUN_APPLICATION;
    os_lib_call((unsigned int *) &libcall_params);
}

// Weird low-level black magic. No need to edit this.
__attribute__((section(".boot"))) int main(int arg0) {
c0de0000:	b570      	push	{r4, r5, r6, lr}
c0de0002:	b08c      	sub	sp, #48	; 0x30
c0de0004:	4604      	mov	r4, r0
    // Exit critical section
    __asm volatile("cpsie i");
c0de0006:	b662      	cpsie	i

    // Ensure exception will work as planned
    os_boot();
c0de0008:	f000 fe64 	bl	c0de0cd4 <os_boot>
c0de000c:	466d      	mov	r5, sp

    // Try catch block. Please read the docs for more information on how to use those!
    BEGIN_TRY {
        TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f001 fa4e 	bl	c0de14b0 <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10d      	bne.n	c0de003a <main+0x3a>
c0de001e:	f001 f841 	bl	c0de10a4 <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
  if (apiLevel < get_api_level()) {
c0de0024:	f001 f803 	bl	c0de102e <get_api_level>
c0de0028:	280d      	cmp	r0, #13
c0de002a:	d21e      	bcs.n	c0de006a <main+0x6a>
            // Low-level black magic.
            check_api_level(CX_COMPAT_APILEVEL);

            // Check if we are called from the dashboard.
            if (!arg0) {
c0de002c:	2c00      	cmp	r4, #0
c0de002e:	d11f      	bne.n	c0de0070 <main+0x70>
                // Called from dashboard, launch Ethereum app
                call_app_ethereum();
c0de0030:	f000 fe42 	bl	c0de0cb8 <call_app_ethereum>
c0de0034:	2000      	movs	r0, #0
    }
    END_TRY;

    // Will not get reached.
    return 0;
}
c0de0036:	b00c      	add	sp, #48	; 0x30
c0de0038:	bd70      	pop	{r4, r5, r6, pc}
c0de003a:	2600      	movs	r6, #0
        CATCH_OTHER(e) {
c0de003c:	8586      	strh	r6, [r0, #44]	; 0x2c
c0de003e:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de0040:	f001 f830 	bl	c0de10a4 <try_context_set>
c0de0044:	4814      	ldr	r0, [pc, #80]	; (c0de0098 <main+0x98>)
            switch (e) {
c0de0046:	4285      	cmp	r5, r0
c0de0048:	d001      	beq.n	c0de004e <main+0x4e>
c0de004a:	2d07      	cmp	r5, #7
c0de004c:	d107      	bne.n	c0de005e <main+0x5e>
c0de004e:	2083      	movs	r0, #131	; 0x83
c0de0050:	0040      	lsls	r0, r0, #1
    switch (args[0]) {
c0de0052:	6821      	ldr	r1, [r4, #0]
c0de0054:	4281      	cmp	r1, r0
c0de0056:	d102      	bne.n	c0de005e <main+0x5e>
            ((ethQueryContractUI_t *) args[1])->result = ETH_PLUGIN_RESULT_ERROR;
c0de0058:	6860      	ldr	r0, [r4, #4]
c0de005a:	2134      	movs	r1, #52	; 0x34
c0de005c:	5446      	strb	r6, [r0, r1]
            PRINTF("Exception 0x%x caught\n", e);
c0de005e:	480f      	ldr	r0, [pc, #60]	; (c0de009c <main+0x9c>)
c0de0060:	4478      	add	r0, pc
c0de0062:	4629      	mov	r1, r5
c0de0064:	f000 fe5c 	bl	c0de0d20 <mcu_usb_printf>
c0de0068:	e00b      	b.n	c0de0082 <main+0x82>
c0de006a:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de006c:	f000 fffc 	bl	c0de1068 <os_sched_exit>
                if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de0070:	6820      	ldr	r0, [r4, #0]
c0de0072:	2183      	movs	r1, #131	; 0x83
c0de0074:	0049      	lsls	r1, r1, #1
c0de0076:	31f9      	adds	r1, #249	; 0xf9
c0de0078:	4288      	cmp	r0, r1
c0de007a:	d002      	beq.n	c0de0082 <main+0x82>
                    dispatch_plugin_calls(args[0], (void *) args[1]);
c0de007c:	6861      	ldr	r1, [r4, #4]
c0de007e:	f000 fde1 	bl	c0de0c44 <dispatch_plugin_calls>
        FINALLY {
c0de0082:	f001 f807 	bl	c0de1094 <try_context_get>
c0de0086:	4669      	mov	r1, sp
c0de0088:	4288      	cmp	r0, r1
c0de008a:	d102      	bne.n	c0de0092 <main+0x92>
c0de008c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de008e:	f001 f809 	bl	c0de10a4 <try_context_set>
            os_lib_end();
c0de0092:	f000 ffe1 	bl	c0de1058 <os_lib_end>
c0de0096:	46c0      	nop			; (mov r8, r8)
c0de0098:	00006502 	.word	0x00006502
c0de009c:	00001638 	.word	0x00001638

c0de00a0 <adjustDecimals>:

bool adjustDecimals(const char *src,
                    size_t srcLength,
                    char *target,
                    size_t targetLength,
                    uint8_t decimals) {
c0de00a0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    uint32_t startOffset;
    uint32_t lastZeroOffset = 0;
    uint32_t offset = 0;
    if ((srcLength == 1) && (*src == '0')) {
c0de00a2:	2901      	cmp	r1, #1
c0de00a4:	d10a      	bne.n	c0de00bc <adjustDecimals+0x1c>
c0de00a6:	7804      	ldrb	r4, [r0, #0]
c0de00a8:	2c30      	cmp	r4, #48	; 0x30
c0de00aa:	d107      	bne.n	c0de00bc <adjustDecimals+0x1c>
        if (targetLength < 2) {
c0de00ac:	2b02      	cmp	r3, #2
c0de00ae:	d31a      	bcc.n	c0de00e6 <adjustDecimals+0x46>
c0de00b0:	2000      	movs	r0, #0
            return false;
        }
        target[0] = '0';
        target[1] = '\0';
c0de00b2:	7050      	strb	r0, [r2, #1]
c0de00b4:	2030      	movs	r0, #48	; 0x30
        target[0] = '0';
c0de00b6:	7010      	strb	r0, [r2, #0]
c0de00b8:	2001      	movs	r0, #1
        if (target[lastZeroOffset - 1] == '.') {
            target[lastZeroOffset - 1] = '\0';
        }
    }
    return true;
}
c0de00ba:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de00bc:	9f06      	ldr	r7, [sp, #24]
    if (srcLength <= decimals) {
c0de00be:	428f      	cmp	r7, r1
c0de00c0:	d20e      	bcs.n	c0de00e0 <adjustDecimals+0x40>
        if (targetLength < srcLength + 1 + 1) {
c0de00c2:	1c8d      	adds	r5, r1, #2
c0de00c4:	429d      	cmp	r5, r3
c0de00c6:	d80e      	bhi.n	c0de00e6 <adjustDecimals+0x46>
c0de00c8:	1bcd      	subs	r5, r1, r7
c0de00ca:	4613      	mov	r3, r2
c0de00cc:	4606      	mov	r6, r0
c0de00ce:	9700      	str	r7, [sp, #0]
        while (offset < delta) {
c0de00d0:	42b9      	cmp	r1, r7
c0de00d2:	d00a      	beq.n	c0de00ea <adjustDecimals+0x4a>
            target[offset++] = src[sourceOffset++];
c0de00d4:	7834      	ldrb	r4, [r6, #0]
c0de00d6:	701c      	strb	r4, [r3, #0]
        while (offset < delta) {
c0de00d8:	1c5b      	adds	r3, r3, #1
c0de00da:	1c76      	adds	r6, r6, #1
c0de00dc:	1c7f      	adds	r7, r7, #1
c0de00de:	e7f7      	b.n	c0de00d0 <adjustDecimals+0x30>
        if (targetLength < srcLength + 1 + 2 + delta) {
c0de00e0:	1cfd      	adds	r5, r7, #3
c0de00e2:	429d      	cmp	r5, r3
c0de00e4:	d912      	bls.n	c0de010c <adjustDecimals+0x6c>
c0de00e6:	2000      	movs	r0, #0
}
c0de00e8:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
        if (decimals != 0) {
c0de00ea:	9b00      	ldr	r3, [sp, #0]
c0de00ec:	2b00      	cmp	r3, #0
c0de00ee:	462b      	mov	r3, r5
c0de00f0:	d002      	beq.n	c0de00f8 <adjustDecimals+0x58>
c0de00f2:	232e      	movs	r3, #46	; 0x2e
            target[offset++] = '.';
c0de00f4:	5553      	strb	r3, [r2, r5]
c0de00f6:	1c6b      	adds	r3, r5, #1
        while (sourceOffset < srcLength) {
c0de00f8:	1940      	adds	r0, r0, r5
c0de00fa:	18d6      	adds	r6, r2, r3
c0de00fc:	2400      	movs	r4, #0
c0de00fe:	192f      	adds	r7, r5, r4
c0de0100:	428f      	cmp	r7, r1
c0de0102:	d211      	bcs.n	c0de0128 <adjustDecimals+0x88>
            target[offset++] = src[sourceOffset++];
c0de0104:	5d07      	ldrb	r7, [r0, r4]
c0de0106:	5537      	strb	r7, [r6, r4]
        while (sourceOffset < srcLength) {
c0de0108:	1c64      	adds	r4, r4, #1
c0de010a:	e7f8      	b.n	c0de00fe <adjustDecimals+0x5e>
c0de010c:	232e      	movs	r3, #46	; 0x2e
        target[offset++] = '.';
c0de010e:	7053      	strb	r3, [r2, #1]
c0de0110:	2530      	movs	r5, #48	; 0x30
        target[offset++] = '0';
c0de0112:	7015      	strb	r5, [r2, #0]
c0de0114:	463c      	mov	r4, r7
        for (uint32_t i = 0; i < delta; i++) {
c0de0116:	1a7e      	subs	r6, r7, r1
c0de0118:	1cb3      	adds	r3, r6, #2
c0de011a:	1c97      	adds	r7, r2, #2
c0de011c:	2e00      	cmp	r6, #0
c0de011e:	d005      	beq.n	c0de012c <adjustDecimals+0x8c>
            target[offset++] = '0';
c0de0120:	703d      	strb	r5, [r7, #0]
        for (uint32_t i = 0; i < delta; i++) {
c0de0122:	1c7f      	adds	r7, r7, #1
c0de0124:	1e76      	subs	r6, r6, #1
c0de0126:	e7f9      	b.n	c0de011c <adjustDecimals+0x7c>
c0de0128:	1918      	adds	r0, r3, r4
c0de012a:	e00a      	b.n	c0de0142 <adjustDecimals+0xa2>
        for (uint32_t i = 0; i < srcLength; i++) {
c0de012c:	1915      	adds	r5, r2, r4
c0de012e:	2602      	movs	r6, #2
c0de0130:	1a71      	subs	r1, r6, r1
c0de0132:	2902      	cmp	r1, #2
c0de0134:	d004      	beq.n	c0de0140 <adjustDecimals+0xa0>
            target[offset++] = src[i];
c0de0136:	7806      	ldrb	r6, [r0, #0]
c0de0138:	546e      	strb	r6, [r5, r1]
        for (uint32_t i = 0; i < srcLength; i++) {
c0de013a:	1c40      	adds	r0, r0, #1
c0de013c:	1c49      	adds	r1, r1, #1
c0de013e:	e7f8      	b.n	c0de0132 <adjustDecimals+0x92>
c0de0140:	1860      	adds	r0, r4, r1
c0de0142:	2100      	movs	r1, #0
c0de0144:	5411      	strb	r1, [r2, r0]
    for (uint32_t i = startOffset; i < offset; i++) {
c0de0146:	4283      	cmp	r3, r0
c0de0148:	d20a      	bcs.n	c0de0160 <adjustDecimals+0xc0>
        if (target[i] == '0') {
c0de014a:	2900      	cmp	r1, #0
c0de014c:	461c      	mov	r4, r3
c0de014e:	d000      	beq.n	c0de0152 <adjustDecimals+0xb2>
c0de0150:	460c      	mov	r4, r1
c0de0152:	5cd1      	ldrb	r1, [r2, r3]
c0de0154:	2930      	cmp	r1, #48	; 0x30
c0de0156:	d000      	beq.n	c0de015a <adjustDecimals+0xba>
c0de0158:	2400      	movs	r4, #0
    for (uint32_t i = startOffset; i < offset; i++) {
c0de015a:	1c5b      	adds	r3, r3, #1
c0de015c:	4621      	mov	r1, r4
c0de015e:	e7f2      	b.n	c0de0146 <adjustDecimals+0xa6>
c0de0160:	2001      	movs	r0, #1
    if (lastZeroOffset != 0) {
c0de0162:	2900      	cmp	r1, #0
c0de0164:	d006      	beq.n	c0de0174 <adjustDecimals+0xd4>
c0de0166:	2300      	movs	r3, #0
        target[lastZeroOffset] = '\0';
c0de0168:	5453      	strb	r3, [r2, r1]
        if (target[lastZeroOffset - 1] == '.') {
c0de016a:	1e49      	subs	r1, r1, #1
c0de016c:	5c54      	ldrb	r4, [r2, r1]
c0de016e:	2c2e      	cmp	r4, #46	; 0x2e
c0de0170:	d100      	bne.n	c0de0174 <adjustDecimals+0xd4>
            target[lastZeroOffset - 1] = '\0';
c0de0172:	5453      	strb	r3, [r2, r1]
}
c0de0174:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0176:	d4d4      	bmi.n	c0de0122 <adjustDecimals+0x82>

c0de0178 <uint256_to_decimal>:

bool uint256_to_decimal(const uint8_t *value, size_t value_len, char *out, size_t out_len) {
c0de0178:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de017a:	b08b      	sub	sp, #44	; 0x2c
c0de017c:	9201      	str	r2, [sp, #4]
    if (value_len > INT256_LENGTH) {
c0de017e:	2920      	cmp	r1, #32
c0de0180:	d817      	bhi.n	c0de01b2 <uint256_to_decimal+0x3a>
c0de0182:	460e      	mov	r6, r1
c0de0184:	4607      	mov	r7, r0
c0de0186:	9300      	str	r3, [sp, #0]
c0de0188:	ad03      	add	r5, sp, #12
c0de018a:	2420      	movs	r4, #32
        // value len is bigger than INT256_LENGTH ?!
        return false;
    }

    uint16_t n[16] = {0};
c0de018c:	4628      	mov	r0, r5
c0de018e:	4621      	mov	r1, r4
c0de0190:	f001 f84a 	bl	c0de1228 <__aeabi_memclr>
    // Copy and right-align the number
    memcpy((uint8_t *) n + INT256_LENGTH - value_len, value, value_len);
c0de0194:	1ba8      	subs	r0, r5, r6
c0de0196:	3020      	adds	r0, #32
c0de0198:	4639      	mov	r1, r7
c0de019a:	4632      	mov	r2, r6
c0de019c:	f001 f84a 	bl	c0de1234 <__aeabi_memcpy>

    // Special case when value is 0
    if (allzeroes(n, INT256_LENGTH)) {
c0de01a0:	4628      	mov	r0, r5
c0de01a2:	4621      	mov	r1, r4
c0de01a4:	f000 f850 	bl	c0de0248 <allzeroes>
c0de01a8:	2800      	cmp	r0, #0
c0de01aa:	d004      	beq.n	c0de01b6 <uint256_to_decimal+0x3e>
c0de01ac:	9a00      	ldr	r2, [sp, #0]
        if (out_len < 2) {
c0de01ae:	2a02      	cmp	r2, #2
c0de01b0:	d230      	bcs.n	c0de0214 <uint256_to_decimal+0x9c>
c0de01b2:	2600      	movs	r6, #0
c0de01b4:	e042      	b.n	c0de023c <uint256_to_decimal+0xc4>
c0de01b6:	2000      	movs	r0, #0
c0de01b8:	9b00      	ldr	r3, [sp, #0]
        strlcpy(out, "0", out_len);
        return true;
    }

    uint16_t *p = n;
    for (int i = 0; i < 16; i++) {
c0de01ba:	2820      	cmp	r0, #32
c0de01bc:	d005      	beq.n	c0de01ca <uint256_to_decimal+0x52>
c0de01be:	a903      	add	r1, sp, #12
        n[i] = __builtin_bswap16(*p++);
c0de01c0:	5a0a      	ldrh	r2, [r1, r0]
c0de01c2:	ba52      	rev16	r2, r2
c0de01c4:	520a      	strh	r2, [r1, r0]
    for (int i = 0; i < 16; i++) {
c0de01c6:	1c80      	adds	r0, r0, #2
c0de01c8:	e7f7      	b.n	c0de01ba <uint256_to_decimal+0x42>
c0de01ca:	9302      	str	r3, [sp, #8]
c0de01cc:	a803      	add	r0, sp, #12
c0de01ce:	2120      	movs	r1, #32
    }
    int pos = out_len;
    while (!allzeroes(n, sizeof(n))) {
c0de01d0:	f000 f83a 	bl	c0de0248 <allzeroes>
c0de01d4:	4606      	mov	r6, r0
c0de01d6:	2800      	cmp	r0, #0
c0de01d8:	d123      	bne.n	c0de0222 <uint256_to_decimal+0xaa>
        if (pos == 0) {
c0de01da:	9802      	ldr	r0, [sp, #8]
c0de01dc:	2800      	cmp	r0, #0
c0de01de:	d02b      	beq.n	c0de0238 <uint256_to_decimal+0xc0>
c0de01e0:	2600      	movs	r6, #0
c0de01e2:	4630      	mov	r0, r6
            return false;
        }
        pos -= 1;
        unsigned int carry = 0;
        for (int i = 0; i < 16; i++) {
c0de01e4:	2e20      	cmp	r6, #32
c0de01e6:	d00d      	beq.n	c0de0204 <uint256_to_decimal+0x8c>
c0de01e8:	af03      	add	r7, sp, #12
            int rem = ((carry << 16) | n[i]) % 10;
c0de01ea:	5bb9      	ldrh	r1, [r7, r6]
c0de01ec:	0400      	lsls	r0, r0, #16
c0de01ee:	1844      	adds	r4, r0, r1
c0de01f0:	250a      	movs	r5, #10
            n[i] = ((carry << 16) | n[i]) / 10;
c0de01f2:	4620      	mov	r0, r4
c0de01f4:	4629      	mov	r1, r5
c0de01f6:	f000 ff61 	bl	c0de10bc <__udivsi3>
c0de01fa:	53b8      	strh	r0, [r7, r6]
c0de01fc:	4345      	muls	r5, r0
c0de01fe:	1b60      	subs	r0, r4, r5
        for (int i = 0; i < 16; i++) {
c0de0200:	1cb6      	adds	r6, r6, #2
c0de0202:	e7ef      	b.n	c0de01e4 <uint256_to_decimal+0x6c>
c0de0204:	2130      	movs	r1, #48	; 0x30
            carry = rem;
        }
        out[pos] = '0' + carry;
c0de0206:	4308      	orrs	r0, r1
c0de0208:	9a02      	ldr	r2, [sp, #8]
        pos -= 1;
c0de020a:	1e52      	subs	r2, r2, #1
        out[pos] = '0' + carry;
c0de020c:	9901      	ldr	r1, [sp, #4]
c0de020e:	9202      	str	r2, [sp, #8]
c0de0210:	5488      	strb	r0, [r1, r2]
c0de0212:	e7db      	b.n	c0de01cc <uint256_to_decimal+0x54>
        strlcpy(out, "0", out_len);
c0de0214:	490b      	ldr	r1, [pc, #44]	; (c0de0244 <uint256_to_decimal+0xcc>)
c0de0216:	4479      	add	r1, pc
c0de0218:	9801      	ldr	r0, [sp, #4]
c0de021a:	f001 f963 	bl	c0de14e4 <strlcpy>
c0de021e:	2601      	movs	r6, #1
c0de0220:	e00c      	b.n	c0de023c <uint256_to_decimal+0xc4>
c0de0222:	9d01      	ldr	r5, [sp, #4]
c0de0224:	9a02      	ldr	r2, [sp, #8]
    }
    memmove(out, out + pos, out_len - pos);
c0de0226:	18a9      	adds	r1, r5, r2
c0de0228:	9800      	ldr	r0, [sp, #0]
c0de022a:	1a84      	subs	r4, r0, r2
c0de022c:	4628      	mov	r0, r5
c0de022e:	4622      	mov	r2, r4
c0de0230:	f001 f804 	bl	c0de123c <__aeabi_memmove>
c0de0234:	2000      	movs	r0, #0
    out[out_len - pos] = 0;
c0de0236:	5528      	strb	r0, [r5, r4]
    while (!allzeroes(n, sizeof(n))) {
c0de0238:	1e70      	subs	r0, r6, #1
c0de023a:	4186      	sbcs	r6, r0
    return true;
}
c0de023c:	4630      	mov	r0, r6
c0de023e:	b00b      	add	sp, #44	; 0x2c
c0de0240:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0242:	46c0      	nop			; (mov r8, r8)
c0de0244:	0000143d 	.word	0x0000143d

c0de0248 <allzeroes>:
typedef union extraInfo_t {
    tokenDefinition_t token;
    nftInfo_t nft;
} extraInfo_t;

static __attribute__((no_instrument_function)) inline int allzeroes(const void *buf, size_t n) {
c0de0248:	b510      	push	{r4, lr}
c0de024a:	2300      	movs	r3, #0
c0de024c:	461a      	mov	r2, r3
    uint8_t *p = (uint8_t *) buf;
    for (size_t i = 0; i < n; ++i) {
c0de024e:	4299      	cmp	r1, r3
c0de0250:	d003      	beq.n	c0de025a <allzeroes+0x12>
        if (p[i]) {
c0de0252:	5c84      	ldrb	r4, [r0, r2]
    for (size_t i = 0; i < n; ++i) {
c0de0254:	1c53      	adds	r3, r2, #1
        if (p[i]) {
c0de0256:	2c00      	cmp	r4, #0
c0de0258:	d0f8      	beq.n	c0de024c <allzeroes+0x4>
    for (size_t i = 0; i < n; ++i) {
c0de025a:	428a      	cmp	r2, r1
c0de025c:	d201      	bcs.n	c0de0262 <allzeroes+0x1a>
c0de025e:	2000      	movs	r0, #0
            return 0;
        }
    }
    return 1;
}
c0de0260:	bd10      	pop	{r4, pc}
c0de0262:	2001      	movs	r0, #1
c0de0264:	bd10      	pop	{r4, pc}

c0de0266 <amountToString>:
void amountToString(const uint8_t *amount,
                    uint8_t amount_size,
                    uint8_t decimals,
                    const char *ticker,
                    char *out_buffer,
                    size_t out_buffer_size) {
c0de0266:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0268:	b09d      	sub	sp, #116	; 0x74
c0de026a:	9303      	str	r3, [sp, #12]
c0de026c:	9202      	str	r2, [sp, #8]
c0de026e:	460c      	mov	r4, r1
c0de0270:	4605      	mov	r5, r0
c0de0272:	af04      	add	r7, sp, #16
c0de0274:	2664      	movs	r6, #100	; 0x64
    char tmp_buffer[100] = {0};
c0de0276:	4638      	mov	r0, r7
c0de0278:	4631      	mov	r1, r6
c0de027a:	f000 ffd5 	bl	c0de1228 <__aeabi_memclr>

    if (uint256_to_decimal(amount, amount_size, tmp_buffer, sizeof(tmp_buffer)) == false) {
c0de027e:	4628      	mov	r0, r5
c0de0280:	4621      	mov	r1, r4
c0de0282:	463a      	mov	r2, r7
c0de0284:	4633      	mov	r3, r6
c0de0286:	f7ff ff77 	bl	c0de0178 <uint256_to_decimal>
c0de028a:	2800      	cmp	r0, #0
c0de028c:	d02e      	beq.n	c0de02ec <amountToString+0x86>
c0de028e:	9e23      	ldr	r6, [sp, #140]	; 0x8c
c0de0290:	9d22      	ldr	r5, [sp, #136]	; 0x88
c0de0292:	a804      	add	r0, sp, #16
c0de0294:	2164      	movs	r1, #100	; 0x64
        THROW(EXCEPTION_OVERFLOW);
    }

    uint8_t amount_len = strnlen(tmp_buffer, sizeof(tmp_buffer));
c0de0296:	f001 f94b 	bl	c0de1530 <strnlen>
c0de029a:	9001      	str	r0, [sp, #4]
c0de029c:	210b      	movs	r1, #11
    uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de029e:	9803      	ldr	r0, [sp, #12]
c0de02a0:	f001 f946 	bl	c0de1530 <strnlen>
c0de02a4:	4604      	mov	r4, r0

    memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de02a6:	b2c7      	uxtb	r7, r0
c0de02a8:	42b7      	cmp	r7, r6
c0de02aa:	4632      	mov	r2, r6
c0de02ac:	d800      	bhi.n	c0de02b0 <amountToString+0x4a>
c0de02ae:	463a      	mov	r2, r7
c0de02b0:	4628      	mov	r0, r5
c0de02b2:	9903      	ldr	r1, [sp, #12]
c0de02b4:	f000 ffbe 	bl	c0de1234 <__aeabi_memcpy>
    if (ticker_len > 0) {
c0de02b8:	2f00      	cmp	r7, #0
c0de02ba:	d004      	beq.n	c0de02c6 <amountToString+0x60>
c0de02bc:	2020      	movs	r0, #32
        out_buffer[ticker_len++] = ' ';
c0de02be:	55e8      	strb	r0, [r5, r7]
c0de02c0:	1c60      	adds	r0, r4, #1
    }

    if (adjustDecimals(tmp_buffer,
                       amount_len,
                       out_buffer + ticker_len,
c0de02c2:	b2c0      	uxtb	r0, r0
c0de02c4:	e000      	b.n	c0de02c8 <amountToString+0x62>
c0de02c6:	2000      	movs	r0, #0
c0de02c8:	9902      	ldr	r1, [sp, #8]
    if (adjustDecimals(tmp_buffer,
c0de02ca:	9100      	str	r1, [sp, #0]
                       out_buffer + ticker_len,
c0de02cc:	182a      	adds	r2, r5, r0
                       out_buffer_size - ticker_len - 1,
c0de02ce:	43c0      	mvns	r0, r0
c0de02d0:	1983      	adds	r3, r0, r6
                       amount_len,
c0de02d2:	9801      	ldr	r0, [sp, #4]
c0de02d4:	b2c1      	uxtb	r1, r0
c0de02d6:	a804      	add	r0, sp, #16
    if (adjustDecimals(tmp_buffer,
c0de02d8:	f7ff fee2 	bl	c0de00a0 <adjustDecimals>
c0de02dc:	2800      	cmp	r0, #0
c0de02de:	d005      	beq.n	c0de02ec <amountToString+0x86>
                       decimals) == false) {
        THROW(EXCEPTION_OVERFLOW);
    }

    out_buffer[out_buffer_size - 1] = '\0';
c0de02e0:	1970      	adds	r0, r6, r5
c0de02e2:	1e40      	subs	r0, r0, #1
c0de02e4:	2100      	movs	r1, #0
c0de02e6:	7001      	strb	r1, [r0, #0]
}
c0de02e8:	b01d      	add	sp, #116	; 0x74
c0de02ea:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de02ec:	2007      	movs	r0, #7
c0de02ee:	f000 fcf7 	bl	c0de0ce0 <os_longjmp>
c0de02f2:	d4d4      	bmi.n	c0de029e <amountToString+0x38>

c0de02f4 <handle_finalize>:
#include "origin_defi_plugin.h"

void handle_finalize(void *parameters) {
c0de02f4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de02f6:	4604      	mov	r4, r0
c0de02f8:	2002      	movs	r0, #2
c0de02fa:	9000      	str	r0, [sp, #0]
    ethPluginFinalize_t *msg = (ethPluginFinalize_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
    msg->numScreens = 2;
c0de02fc:	7760      	strb	r0, [r4, #29]
    printf_hex_array("destination: ", ADDRESS_LENGTH, msg->pluginSharedRO->txContent->destination);
c0de02fe:	6860      	ldr	r0, [r4, #4]
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0300:	68a5      	ldr	r5, [r4, #8]
    printf_hex_array("destination: ", ADDRESS_LENGTH, msg->pluginSharedRO->txContent->destination);
c0de0302:	6801      	ldr	r1, [r0, #0]
c0de0304:	31a5      	adds	r1, #165	; 0xa5
c0de0306:	481d      	ldr	r0, [pc, #116]	; (c0de037c <handle_finalize+0x88>)
c0de0308:	4478      	add	r0, pc
c0de030a:	f000 f841 	bl	c0de0390 <printf_hex_array>
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de030e:	462e      	mov	r6, r5
c0de0310:	3640      	adds	r6, #64	; 0x40
c0de0312:	491b      	ldr	r1, [pc, #108]	; (c0de0380 <handle_finalize+0x8c>)
c0de0314:	4479      	add	r1, pc
c0de0316:	2214      	movs	r2, #20
c0de0318:	4630      	mov	r0, r6
c0de031a:	f000 ff9b 	bl	c0de1254 <memcmp>
c0de031e:	462f      	mov	r7, r5
c0de0320:	377e      	adds	r7, #126	; 0x7e
c0de0322:	2800      	cmp	r0, #0
c0de0324:	d005      	beq.n	c0de0332 <handle_finalize+0x3e>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address sent to: ",
c0de0326:	4817      	ldr	r0, [pc, #92]	; (c0de0384 <handle_finalize+0x90>)
c0de0328:	4478      	add	r0, pc
c0de032a:	4631      	mov	r1, r6
c0de032c:	f000 f830 	bl	c0de0390 <printf_hex_array>
c0de0330:	e006      	b.n	c0de0340 <handle_finalize+0x4c>
c0de0332:	2012      	movs	r0, #18
void handle_finalize(void *parameters);
void handle_provide_token(void *parameters);
void handle_query_contract_id(void *parameters);

static inline void sent_network_token(origin_defi_parameters_t *context) {
    context->decimals_sent = WEI_TO_ETHER;
c0de0334:	7078      	strb	r0, [r7, #1]
    context->tokens_found |= TOKEN_SENT_FOUND;
c0de0336:	7838      	ldrb	r0, [r7, #0]
c0de0338:	2101      	movs	r1, #1
c0de033a:	4301      	orrs	r1, r0
c0de033c:	7039      	strb	r1, [r7, #0]
c0de033e:	2600      	movs	r6, #0
c0de0340:	60e6      	str	r6, [r4, #12]
        msg->tokenLookup1 = context->contract_address_sent;
    } else {
        sent_network_token(context);
        msg->tokenLookup1 = NULL;
    }
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0342:	3554      	adds	r5, #84	; 0x54
c0de0344:	4910      	ldr	r1, [pc, #64]	; (c0de0388 <handle_finalize+0x94>)
c0de0346:	4479      	add	r1, pc
c0de0348:	2214      	movs	r2, #20
c0de034a:	4628      	mov	r0, r5
c0de034c:	f000 ff82 	bl	c0de1254 <memcmp>
c0de0350:	2800      	cmp	r0, #0
c0de0352:	d006      	beq.n	c0de0362 <handle_finalize+0x6e>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address received to: ",
c0de0354:	480d      	ldr	r0, [pc, #52]	; (c0de038c <handle_finalize+0x98>)
c0de0356:	4478      	add	r0, pc
c0de0358:	4629      	mov	r1, r5
c0de035a:	f000 f819 	bl	c0de0390 <printf_hex_array>
c0de035e:	9900      	ldr	r1, [sp, #0]
c0de0360:	e006      	b.n	c0de0370 <handle_finalize+0x7c>
c0de0362:	2012      	movs	r0, #18
}

static inline void received_network_token(origin_defi_parameters_t *context) {
    context->decimals_received = WEI_TO_ETHER;
c0de0364:	70b8      	strb	r0, [r7, #2]
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
c0de0366:	7838      	ldrb	r0, [r7, #0]
c0de0368:	9900      	ldr	r1, [sp, #0]
c0de036a:	4308      	orrs	r0, r1
c0de036c:	7038      	strb	r0, [r7, #0]
c0de036e:	2500      	movs	r5, #0
c0de0370:	2004      	movs	r0, #4
        received_network_token(context);
        msg->tokenLookup2 = NULL;
    }

    msg->uiType = ETH_UI_TYPE_GENERIC;
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0372:	77a0      	strb	r0, [r4, #30]
    msg->uiType = ETH_UI_TYPE_GENERIC;
c0de0374:	7721      	strb	r1, [r4, #28]
c0de0376:	6125      	str	r5, [r4, #16]
c0de0378:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de037a:	46c0      	nop			; (mov r8, r8)
c0de037c:	000013bd 	.word	0x000013bd
c0de0380:	000015ec 	.word	0x000015ec
c0de0384:	000013e1 	.word	0x000013e1
c0de0388:	000015ba 	.word	0x000015ba
c0de038c:	000012ff 	.word	0x000012ff

c0de0390 <printf_hex_array>:
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
}

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
c0de0390:	b570      	push	{r4, r5, r6, lr}
c0de0392:	460c      	mov	r4, r1
    PRINTF(title);
c0de0394:	f000 fcc4 	bl	c0de0d20 <mcu_usb_printf>
c0de0398:	2600      	movs	r6, #0
c0de039a:	4d07      	ldr	r5, [pc, #28]	; (c0de03b8 <printf_hex_array+0x28>)
c0de039c:	447d      	add	r5, pc
    for (size_t i = 0; i < len; ++i) {
c0de039e:	2e14      	cmp	r6, #20
c0de03a0:	d005      	beq.n	c0de03ae <printf_hex_array+0x1e>
        PRINTF("%02x", data[i]);
c0de03a2:	5da1      	ldrb	r1, [r4, r6]
c0de03a4:	4628      	mov	r0, r5
c0de03a6:	f000 fcbb 	bl	c0de0d20 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de03aa:	1c76      	adds	r6, r6, #1
c0de03ac:	e7f7      	b.n	c0de039e <printf_hex_array+0xe>
    };
    PRINTF("\n");
c0de03ae:	4803      	ldr	r0, [pc, #12]	; (c0de03bc <printf_hex_array+0x2c>)
c0de03b0:	4478      	add	r0, pc
c0de03b2:	f000 fcb5 	bl	c0de0d20 <mcu_usb_printf>
c0de03b6:	bd70      	pop	{r4, r5, r6, pc}
c0de03b8:	00001276 	.word	0x00001276
c0de03bc:	00001373 	.word	0x00001373

c0de03c0 <handle_init_contract>:
    }
    return -1;
}

// Called once to init.
void handle_init_contract(void *parameters) {
c0de03c0:	b570      	push	{r4, r5, r6, lr}
c0de03c2:	4604      	mov	r4, r0
    // Cast the msg to the type of structure we expect (here, ethPluginInitContract_t).
    ethPluginInitContract_t *msg = (ethPluginInitContract_t *) parameters;

    // Make sure we are running a compatible version.
    if (msg->interfaceVersion != ETH_PLUGIN_INTERFACE_VERSION_LATEST) {
c0de03c4:	7800      	ldrb	r0, [r0, #0]
c0de03c6:	2601      	movs	r6, #1
c0de03c8:	2806      	cmp	r0, #6
c0de03ca:	d107      	bne.n	c0de03dc <handle_init_contract+0x1c>
        return;
    }

    // Double check that the `context_t` struct is not bigger than the maximum size (defined by
    // `msg->pluginContextLength`).
    if (msg->pluginContextLength < sizeof(origin_defi_parameters_t)) {
c0de03cc:	6920      	ldr	r0, [r4, #16]
c0de03ce:	2885      	cmp	r0, #133	; 0x85
c0de03d0:	d806      	bhi.n	c0de03e0 <handle_init_contract+0x20>
        PRINTF("Plugin parameters structure is bigger than allowed size\n");
c0de03d2:	4824      	ldr	r0, [pc, #144]	; (c0de0464 <handle_init_contract+0xa4>)
c0de03d4:	4478      	add	r0, pc
c0de03d6:	f000 fca3 	bl	c0de0d20 <mcu_usb_printf>
c0de03da:	2600      	movs	r6, #0
c0de03dc:	7066      	strb	r6, [r4, #1]
            return;
    }

    // Return valid status.
    msg->result = ETH_PLUGIN_RESULT_OK;
}
c0de03de:	bd70      	pop	{r4, r5, r6, pc}
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de03e0:	68e5      	ldr	r5, [r4, #12]
c0de03e2:	2186      	movs	r1, #134	; 0x86
    memset(context, 0, sizeof(*context));
c0de03e4:	4628      	mov	r0, r5
c0de03e6:	f000 ff1f 	bl	c0de1228 <__aeabi_memclr>
    uint32_t selector = U4BE(msg->selector, 0);
c0de03ea:	6960      	ldr	r0, [r4, #20]
#define U4(hi3, hi2, lo1,lo0) ((((hi3)&0xFFu)<<24) | (((hi2)&0xFFu)<<16) | (((lo1)&0xFFu)<<8) | ((lo0)&0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off) {
  return (buf[off] << 8) | buf[off + 1];
}
static inline uint32_t U4BE(const uint8_t *buf, size_t off) {
  return (((uint32_t)buf[off]) << 24) | (buf[off + 1] << 16) | (buf[off + 2] << 8) | buf[off + 3];
c0de03ec:	7801      	ldrb	r1, [r0, #0]
c0de03ee:	0609      	lsls	r1, r1, #24
c0de03f0:	7842      	ldrb	r2, [r0, #1]
c0de03f2:	0412      	lsls	r2, r2, #16
c0de03f4:	1851      	adds	r1, r2, r1
c0de03f6:	7882      	ldrb	r2, [r0, #2]
c0de03f8:	0212      	lsls	r2, r2, #8
c0de03fa:	1889      	adds	r1, r1, r2
c0de03fc:	78c0      	ldrb	r0, [r0, #3]
c0de03fe:	1808      	adds	r0, r1, r0
c0de0400:	3584      	adds	r5, #132	; 0x84
c0de0402:	2100      	movs	r1, #0
c0de0404:	4a18      	ldr	r2, [pc, #96]	; (c0de0468 <handle_init_contract+0xa8>)
c0de0406:	447a      	add	r2, pc
    for (selector_t i = 0; i < n; i++) {
c0de0408:	290f      	cmp	r1, #15
c0de040a:	d0e7      	beq.n	c0de03dc <handle_init_contract+0x1c>
        if (selector == selectors[i]) {
c0de040c:	6813      	ldr	r3, [r2, #0]
c0de040e:	4283      	cmp	r3, r0
c0de0410:	d002      	beq.n	c0de0418 <handle_init_contract+0x58>
    for (selector_t i = 0; i < n; i++) {
c0de0412:	1d12      	adds	r2, r2, #4
c0de0414:	1c49      	adds	r1, r1, #1
c0de0416:	e7f7      	b.n	c0de0408 <handle_init_contract+0x48>
            *out = i;
c0de0418:	7069      	strb	r1, [r5, #1]
    if (find_selector(selector, ORIGIN_DEFI_SELECTORS, NUM_SELECTORS, &context->selectorIndex)) {
c0de041a:	290e      	cmp	r1, #14
c0de041c:	d8de      	bhi.n	c0de03dc <handle_init_contract+0x1c>
            *out = i;
c0de041e:	b2c8      	uxtb	r0, r1
    switch (context->selectorIndex) {
c0de0420:	280e      	cmp	r0, #14
c0de0422:	d80c      	bhi.n	c0de043e <handle_init_contract+0x7e>
c0de0424:	2201      	movs	r2, #1
c0de0426:	4082      	lsls	r2, r0
c0de0428:	0453      	lsls	r3, r2, #17
c0de042a:	0e9b      	lsrs	r3, r3, #26
c0de042c:	d001      	beq.n	c0de0432 <handle_init_contract+0x72>
c0de042e:	2002      	movs	r0, #2
c0de0430:	e013      	b.n	c0de045a <handle_init_contract+0x9a>
c0de0432:	05d3      	lsls	r3, r2, #23
c0de0434:	0f5b      	lsrs	r3, r3, #29
c0de0436:	d10f      	bne.n	c0de0458 <handle_init_contract+0x98>
c0de0438:	0692      	lsls	r2, r2, #26
c0de043a:	0f92      	lsrs	r2, r2, #30
c0de043c:	d10c      	bne.n	c0de0458 <handle_init_contract+0x98>
c0de043e:	2800      	cmp	r0, #0
c0de0440:	d00e      	beq.n	c0de0460 <handle_init_contract+0xa0>
c0de0442:	2803      	cmp	r0, #3
c0de0444:	d0f3      	beq.n	c0de042e <handle_init_contract+0x6e>
c0de0446:	2802      	cmp	r0, #2
c0de0448:	d006      	beq.n	c0de0458 <handle_init_contract+0x98>
c0de044a:	2801      	cmp	r0, #1
c0de044c:	d0ef      	beq.n	c0de042e <handle_init_contract+0x6e>
            PRINTF("Missing selectorIndex: %d\n", context->selectorIndex);
c0de044e:	4807      	ldr	r0, [pc, #28]	; (c0de046c <handle_init_contract+0xac>)
c0de0450:	4478      	add	r0, pc
c0de0452:	f000 fc65 	bl	c0de0d20 <mcu_usb_printf>
c0de0456:	e7c0      	b.n	c0de03da <handle_init_contract+0x1a>
c0de0458:	2000      	movs	r0, #0
c0de045a:	7028      	strb	r0, [r5, #0]
c0de045c:	2604      	movs	r6, #4
c0de045e:	e7bd      	b.n	c0de03dc <handle_init_contract+0x1c>
c0de0460:	2003      	movs	r0, #3
c0de0462:	e7fa      	b.n	c0de045a <handle_init_contract+0x9a>
c0de0464:	00001188 	.word	0x00001188
c0de0468:	00001412 	.word	0x00001412
c0de046c:	00001370 	.word	0x00001370

c0de0470 <handle_provide_parameter>:
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
c0de0470:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de0472:	4605      	mov	r5, r0
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0474:	6884      	ldr	r4, [r0, #8]
    printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH, msg->parameter);
c0de0476:	68c2      	ldr	r2, [r0, #12]
c0de0478:	4861      	ldr	r0, [pc, #388]	; (c0de0600 <handle_provide_parameter+0x190>)
c0de047a:	4478      	add	r0, pc
c0de047c:	2120      	movs	r1, #32
c0de047e:	f000 f8d9 	bl	c0de0634 <printf_hex_array>
c0de0482:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0484:	7528      	strb	r0, [r5, #20]
c0de0486:	2085      	movs	r0, #133	; 0x85

    switch (context->selectorIndex) {
c0de0488:	5c26      	ldrb	r6, [r4, r0]
c0de048a:	4622      	mov	r2, r4
c0de048c:	3284      	adds	r2, #132	; 0x84
c0de048e:	2e0e      	cmp	r6, #14
c0de0490:	d825      	bhi.n	c0de04de <handle_provide_parameter+0x6e>
c0de0492:	2701      	movs	r7, #1
c0de0494:	4638      	mov	r0, r7
c0de0496:	40b0      	lsls	r0, r6
c0de0498:	0441      	lsls	r1, r0, #17
c0de049a:	0e89      	lsrs	r1, r1, #26
c0de049c:	d006      	beq.n	c0de04ac <handle_provide_parameter+0x3c>
    switch (context->next_param) {
c0de049e:	7810      	ldrb	r0, [r2, #0]
c0de04a0:	2805      	cmp	r0, #5
c0de04a2:	d006      	beq.n	c0de04b2 <handle_provide_parameter+0x42>
c0de04a4:	2802      	cmp	r0, #2
c0de04a6:	d141      	bne.n	c0de052c <handle_provide_parameter+0xbc>
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de04a8:	68e9      	ldr	r1, [r5, #12]
c0de04aa:	e046      	b.n	c0de053a <handle_provide_parameter+0xca>
c0de04ac:	05c1      	lsls	r1, r0, #23
c0de04ae:	0f49      	lsrs	r1, r1, #29
c0de04b0:	d000      	beq.n	c0de04b4 <handle_provide_parameter+0x44>
        default:
            PRINTF("Selector Index %d not supported\n", context->selectorIndex);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
c0de04b2:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de04b4:	0680      	lsls	r0, r0, #26
c0de04b6:	0f80      	lsrs	r0, r0, #30
c0de04b8:	d011      	beq.n	c0de04de <handle_provide_parameter+0x6e>
    switch (context->next_param) {
c0de04ba:	7810      	ldrb	r0, [r2, #0]
c0de04bc:	2805      	cmp	r0, #5
c0de04be:	d0f8      	beq.n	c0de04b2 <handle_provide_parameter+0x42>
c0de04c0:	2801      	cmp	r0, #1
c0de04c2:	d052      	beq.n	c0de056a <handle_provide_parameter+0xfa>
c0de04c4:	2802      	cmp	r0, #2
c0de04c6:	d03f      	beq.n	c0de0548 <handle_provide_parameter+0xd8>
c0de04c8:	2803      	cmp	r0, #3
c0de04ca:	d034      	beq.n	c0de0536 <handle_provide_parameter+0xc6>
c0de04cc:	2800      	cmp	r0, #0
c0de04ce:	d12d      	bne.n	c0de052c <handle_provide_parameter+0xbc>
            handle_token_sent(msg, context);
c0de04d0:	4628      	mov	r0, r5
c0de04d2:	4621      	mov	r1, r4
c0de04d4:	4614      	mov	r4, r2
c0de04d6:	f000 f8c7 	bl	c0de0668 <handle_token_sent>
            context->next_param = TOKEN_RECEIVED;
c0de04da:	7027      	strb	r7, [r4, #0]
c0de04dc:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    switch (context->selectorIndex) {
c0de04de:	2e03      	cmp	r6, #3
c0de04e0:	d00b      	beq.n	c0de04fa <handle_provide_parameter+0x8a>
c0de04e2:	2e01      	cmp	r6, #1
c0de04e4:	d009      	beq.n	c0de04fa <handle_provide_parameter+0x8a>
c0de04e6:	2e02      	cmp	r6, #2
c0de04e8:	d00f      	beq.n	c0de050a <handle_provide_parameter+0x9a>
c0de04ea:	2e00      	cmp	r6, #0
c0de04ec:	d135      	bne.n	c0de055a <handle_provide_parameter+0xea>
    switch (context->next_param) {
c0de04ee:	7811      	ldrb	r1, [r2, #0]
c0de04f0:	2905      	cmp	r1, #5
c0de04f2:	d0de      	beq.n	c0de04b2 <handle_provide_parameter+0x42>
            PRINTF("Param not supported: %d\n", context->next_param);
c0de04f4:	4843      	ldr	r0, [pc, #268]	; (c0de0604 <handle_provide_parameter+0x194>)
c0de04f6:	4478      	add	r0, pc
c0de04f8:	e032      	b.n	c0de0560 <handle_provide_parameter+0xf0>
c0de04fa:	7810      	ldrb	r0, [r2, #0]
c0de04fc:	2805      	cmp	r0, #5
c0de04fe:	d0d8      	beq.n	c0de04b2 <handle_provide_parameter+0x42>
c0de0500:	2803      	cmp	r0, #3
c0de0502:	d018      	beq.n	c0de0536 <handle_provide_parameter+0xc6>
c0de0504:	2802      	cmp	r0, #2
c0de0506:	d111      	bne.n	c0de052c <handle_provide_parameter+0xbc>
c0de0508:	e01e      	b.n	c0de0548 <handle_provide_parameter+0xd8>
    switch (context->next_param) {
c0de050a:	7810      	ldrb	r0, [r2, #0]
c0de050c:	2805      	cmp	r0, #5
c0de050e:	d0d0      	beq.n	c0de04b2 <handle_provide_parameter+0x42>
c0de0510:	2802      	cmp	r0, #2
c0de0512:	d019      	beq.n	c0de0548 <handle_provide_parameter+0xd8>
c0de0514:	2803      	cmp	r0, #3
c0de0516:	d00e      	beq.n	c0de0536 <handle_provide_parameter+0xc6>
c0de0518:	2800      	cmp	r0, #0
c0de051a:	d107      	bne.n	c0de052c <handle_provide_parameter+0xbc>
            handle_token_sent(msg, context);
c0de051c:	4628      	mov	r0, r5
c0de051e:	4621      	mov	r1, r4
c0de0520:	4614      	mov	r4, r2
c0de0522:	f000 f8a1 	bl	c0de0668 <handle_token_sent>
c0de0526:	2002      	movs	r0, #2
            context->next_param = AMOUNT_SENT;
c0de0528:	7020      	strb	r0, [r4, #0]
c0de052a:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de052c:	4836      	ldr	r0, [pc, #216]	; (c0de0608 <handle_provide_parameter+0x198>)
c0de052e:	4478      	add	r0, pc
c0de0530:	f000 fbf6 	bl	c0de0d20 <mcu_usb_printf>
c0de0534:	e016      	b.n	c0de0564 <handle_provide_parameter+0xf4>
c0de0536:	68e9      	ldr	r1, [r5, #12]
c0de0538:	3420      	adds	r4, #32
c0de053a:	4615      	mov	r5, r2
c0de053c:	2220      	movs	r2, #32
c0de053e:	4620      	mov	r0, r4
c0de0540:	f000 fe78 	bl	c0de1234 <__aeabi_memcpy>
c0de0544:	2005      	movs	r0, #5
c0de0546:	e006      	b.n	c0de0556 <handle_provide_parameter+0xe6>
c0de0548:	68e9      	ldr	r1, [r5, #12]
c0de054a:	4615      	mov	r5, r2
c0de054c:	2220      	movs	r2, #32
c0de054e:	4620      	mov	r0, r4
c0de0550:	f000 fe70 	bl	c0de1234 <__aeabi_memcpy>
c0de0554:	2003      	movs	r0, #3
c0de0556:	7028      	strb	r0, [r5, #0]
c0de0558:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            PRINTF("Selector Index %d not supported\n", context->selectorIndex);
c0de055a:	4835      	ldr	r0, [pc, #212]	; (c0de0630 <handle_provide_parameter+0x1c0>)
c0de055c:	4478      	add	r0, pc
c0de055e:	4631      	mov	r1, r6
c0de0560:	f000 fbde 	bl	c0de0d20 <mcu_usb_printf>
c0de0564:	2000      	movs	r0, #0
c0de0566:	7528      	strb	r0, [r5, #20]
c0de0568:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de056a:	4617      	mov	r7, r2
    memset(context->contract_address_received, 0, sizeof(context->contract_address_received));
c0de056c:	3454      	adds	r4, #84	; 0x54
c0de056e:	2114      	movs	r1, #20
c0de0570:	4620      	mov	r0, r4
c0de0572:	f000 fe59 	bl	c0de1228 <__aeabi_memclr>
    if (context->selectorIndex == CURVE_POOL_EXCHANGE) {
c0de0576:	2e04      	cmp	r6, #4
c0de0578:	d11c      	bne.n	c0de05b4 <handle_provide_parameter+0x144>
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de057a:	6868      	ldr	r0, [r5, #4]
c0de057c:	6806      	ldr	r6, [r0, #0]
c0de057e:	36a5      	adds	r6, #165	; 0xa5
c0de0580:	4822      	ldr	r0, [pc, #136]	; (c0de060c <handle_provide_parameter+0x19c>)
c0de0582:	4478      	add	r0, pc
c0de0584:	2214      	movs	r2, #20
c0de0586:	4631      	mov	r1, r6
c0de0588:	f000 fe64 	bl	c0de1254 <memcmp>
c0de058c:	2800      	cmp	r0, #0
c0de058e:	d020      	beq.n	c0de05d2 <handle_provide_parameter+0x162>
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0590:	4821      	ldr	r0, [pc, #132]	; (c0de0618 <handle_provide_parameter+0x1a8>)
c0de0592:	4478      	add	r0, pc
c0de0594:	2214      	movs	r2, #20
c0de0596:	4631      	mov	r1, r6
c0de0598:	f000 fe5c 	bl	c0de1254 <memcmp>
c0de059c:	2800      	cmp	r0, #0
c0de059e:	d10f      	bne.n	c0de05c0 <handle_provide_parameter+0x150>
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de05a0:	68e8      	ldr	r0, [r5, #12]
c0de05a2:	7fc0      	ldrb	r0, [r0, #31]
c0de05a4:	2802      	cmp	r0, #2
c0de05a6:	d325      	bcc.n	c0de05f4 <handle_provide_parameter+0x184>
c0de05a8:	d027      	beq.n	c0de05fa <handle_provide_parameter+0x18a>
c0de05aa:	2803      	cmp	r0, #3
c0de05ac:	d11a      	bne.n	c0de05e4 <handle_provide_parameter+0x174>
                    memcpy(context->contract_address_received,
c0de05ae:	491b      	ldr	r1, [pc, #108]	; (c0de061c <handle_provide_parameter+0x1ac>)
c0de05b0:	4479      	add	r1, pc
c0de05b2:	e001      	b.n	c0de05b8 <handle_provide_parameter+0x148>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de05b4:	68e9      	ldr	r1, [r5, #12]
c0de05b6:	310c      	adds	r1, #12
c0de05b8:	2214      	movs	r2, #20
c0de05ba:	4620      	mov	r0, r4
c0de05bc:	f000 fe3a 	bl	c0de1234 <__aeabi_memcpy>
    printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH, context->contract_address_received);
c0de05c0:	481a      	ldr	r0, [pc, #104]	; (c0de062c <handle_provide_parameter+0x1bc>)
c0de05c2:	4478      	add	r0, pc
c0de05c4:	2114      	movs	r1, #20
c0de05c6:	4622      	mov	r2, r4
c0de05c8:	f000 f834 	bl	c0de0634 <printf_hex_array>
c0de05cc:	2002      	movs	r0, #2
            context->next_param = AMOUNT_SENT;
c0de05ce:	7038      	strb	r0, [r7, #0]
c0de05d0:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de05d2:	68e8      	ldr	r0, [r5, #12]
c0de05d4:	7fc0      	ldrb	r0, [r0, #31]
c0de05d6:	2801      	cmp	r0, #1
c0de05d8:	d009      	beq.n	c0de05ee <handle_provide_parameter+0x17e>
c0de05da:	2800      	cmp	r0, #0
c0de05dc:	d102      	bne.n	c0de05e4 <handle_provide_parameter+0x174>
                    memcpy(context->contract_address_received,
c0de05de:	490c      	ldr	r1, [pc, #48]	; (c0de0610 <handle_provide_parameter+0x1a0>)
c0de05e0:	4479      	add	r1, pc
c0de05e2:	e7e9      	b.n	c0de05b8 <handle_provide_parameter+0x148>
c0de05e4:	4810      	ldr	r0, [pc, #64]	; (c0de0628 <handle_provide_parameter+0x1b8>)
c0de05e6:	4478      	add	r0, pc
c0de05e8:	f000 fb9a 	bl	c0de0d20 <mcu_usb_printf>
c0de05ec:	e7e8      	b.n	c0de05c0 <handle_provide_parameter+0x150>
                    memcpy(context->contract_address_received,
c0de05ee:	4909      	ldr	r1, [pc, #36]	; (c0de0614 <handle_provide_parameter+0x1a4>)
c0de05f0:	4479      	add	r1, pc
c0de05f2:	e7e1      	b.n	c0de05b8 <handle_provide_parameter+0x148>
                    memcpy(context->contract_address_received,
c0de05f4:	490a      	ldr	r1, [pc, #40]	; (c0de0620 <handle_provide_parameter+0x1b0>)
c0de05f6:	4479      	add	r1, pc
c0de05f8:	e7de      	b.n	c0de05b8 <handle_provide_parameter+0x148>
                    memcpy(context->contract_address_received,
c0de05fa:	490a      	ldr	r1, [pc, #40]	; (c0de0624 <handle_provide_parameter+0x1b4>)
c0de05fc:	4479      	add	r1, pc
c0de05fe:	e7db      	b.n	c0de05b8 <handle_provide_parameter+0x148>
c0de0600:	00001128 	.word	0x00001128
c0de0604:	0000117d 	.word	0x0000117d
c0de0608:	00001096 	.word	0x00001096
c0de060c:	00001336 	.word	0x00001336
c0de0610:	00001320 	.word	0x00001320
c0de0614:	00001264 	.word	0x00001264
c0de0618:	0000133a 	.word	0x0000133a
c0de061c:	000012e0 	.word	0x000012e0
c0de0620:	00001272 	.word	0x00001272
c0de0624:	00001280 	.word	0x00001280
c0de0628:	00000fde 	.word	0x00000fde
c0de062c:	0000105a 	.word	0x0000105a
c0de0630:	0000127f 	.word	0x0000127f

c0de0634 <printf_hex_array>:
                                    const uint8_t *data __attribute__((unused))) {
c0de0634:	b570      	push	{r4, r5, r6, lr}
c0de0636:	4614      	mov	r4, r2
c0de0638:	460d      	mov	r5, r1
    PRINTF(title);
c0de063a:	f000 fb71 	bl	c0de0d20 <mcu_usb_printf>
c0de063e:	4e08      	ldr	r6, [pc, #32]	; (c0de0660 <printf_hex_array+0x2c>)
c0de0640:	447e      	add	r6, pc
    for (size_t i = 0; i < len; ++i) {
c0de0642:	2d00      	cmp	r5, #0
c0de0644:	d006      	beq.n	c0de0654 <printf_hex_array+0x20>
        PRINTF("%02x", data[i]);
c0de0646:	7821      	ldrb	r1, [r4, #0]
c0de0648:	4630      	mov	r0, r6
c0de064a:	f000 fb69 	bl	c0de0d20 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de064e:	1c64      	adds	r4, r4, #1
c0de0650:	1e6d      	subs	r5, r5, #1
c0de0652:	e7f6      	b.n	c0de0642 <printf_hex_array+0xe>
    PRINTF("\n");
c0de0654:	4803      	ldr	r0, [pc, #12]	; (c0de0664 <printf_hex_array+0x30>)
c0de0656:	4478      	add	r0, pc
c0de0658:	f000 fb62 	bl	c0de0d20 <mcu_usb_printf>
c0de065c:	bd70      	pop	{r4, r5, r6, pc}
c0de065e:	46c0      	nop			; (mov r8, r8)
c0de0660:	00000fd2 	.word	0x00000fd2
c0de0664:	000010cd 	.word	0x000010cd

c0de0668 <handle_token_sent>:
static void handle_token_sent(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
c0de0668:	b570      	push	{r4, r5, r6, lr}
c0de066a:	460e      	mov	r6, r1
c0de066c:	4605      	mov	r5, r0
    memset(context->contract_address_sent, 0, sizeof(context->contract_address_sent));
c0de066e:	460c      	mov	r4, r1
c0de0670:	3440      	adds	r4, #64	; 0x40
c0de0672:	2114      	movs	r1, #20
c0de0674:	4620      	mov	r0, r4
c0de0676:	f000 fdd7 	bl	c0de1228 <__aeabi_memclr>
    printf_hex_array("Incoming parameter: ", PARAMETER_LENGTH, msg->parameter);
c0de067a:	68ea      	ldr	r2, [r5, #12]
c0de067c:	4824      	ldr	r0, [pc, #144]	; (c0de0710 <handle_token_sent+0xa8>)
c0de067e:	4478      	add	r0, pc
c0de0680:	2120      	movs	r1, #32
c0de0682:	f7ff ffd7 	bl	c0de0634 <printf_hex_array>
c0de0686:	2085      	movs	r0, #133	; 0x85
    if (context->selectorIndex == CURVE_POOL_EXCHANGE) {
c0de0688:	5c30      	ldrb	r0, [r6, r0]
c0de068a:	2804      	cmp	r0, #4
c0de068c:	d11c      	bne.n	c0de06c8 <handle_token_sent+0x60>
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de068e:	6868      	ldr	r0, [r5, #4]
c0de0690:	6806      	ldr	r6, [r0, #0]
c0de0692:	36a5      	adds	r6, #165	; 0xa5
c0de0694:	481f      	ldr	r0, [pc, #124]	; (c0de0714 <handle_token_sent+0xac>)
c0de0696:	4478      	add	r0, pc
c0de0698:	2214      	movs	r2, #20
c0de069a:	4631      	mov	r1, r6
c0de069c:	f000 fdda 	bl	c0de1254 <memcmp>
c0de06a0:	2800      	cmp	r0, #0
c0de06a2:	d01e      	beq.n	c0de06e2 <handle_token_sent+0x7a>
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de06a4:	481e      	ldr	r0, [pc, #120]	; (c0de0720 <handle_token_sent+0xb8>)
c0de06a6:	4478      	add	r0, pc
c0de06a8:	2214      	movs	r2, #20
c0de06aa:	4631      	mov	r1, r6
c0de06ac:	f000 fdd2 	bl	c0de1254 <memcmp>
c0de06b0:	2800      	cmp	r0, #0
c0de06b2:	d10f      	bne.n	c0de06d4 <handle_token_sent+0x6c>
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de06b4:	68e8      	ldr	r0, [r5, #12]
c0de06b6:	7fc0      	ldrb	r0, [r0, #31]
c0de06b8:	2802      	cmp	r0, #2
c0de06ba:	d323      	bcc.n	c0de0704 <handle_token_sent+0x9c>
c0de06bc:	d025      	beq.n	c0de070a <handle_token_sent+0xa2>
c0de06be:	2803      	cmp	r0, #3
c0de06c0:	d118      	bne.n	c0de06f4 <handle_token_sent+0x8c>
                    memcpy(context->contract_address_sent,
c0de06c2:	4918      	ldr	r1, [pc, #96]	; (c0de0724 <handle_token_sent+0xbc>)
c0de06c4:	4479      	add	r1, pc
c0de06c6:	e001      	b.n	c0de06cc <handle_token_sent+0x64>
            &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de06c8:	68e9      	ldr	r1, [r5, #12]
c0de06ca:	310c      	adds	r1, #12
c0de06cc:	2214      	movs	r2, #20
c0de06ce:	4620      	mov	r0, r4
c0de06d0:	f000 fdb0 	bl	c0de1234 <__aeabi_memcpy>
    printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
c0de06d4:	4817      	ldr	r0, [pc, #92]	; (c0de0734 <handle_token_sent+0xcc>)
c0de06d6:	4478      	add	r0, pc
c0de06d8:	2114      	movs	r1, #20
c0de06da:	4622      	mov	r2, r4
c0de06dc:	f7ff ffaa 	bl	c0de0634 <printf_hex_array>
}
c0de06e0:	bd70      	pop	{r4, r5, r6, pc}
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de06e2:	68e8      	ldr	r0, [r5, #12]
c0de06e4:	7fc0      	ldrb	r0, [r0, #31]
c0de06e6:	2801      	cmp	r0, #1
c0de06e8:	d009      	beq.n	c0de06fe <handle_token_sent+0x96>
c0de06ea:	2800      	cmp	r0, #0
c0de06ec:	d102      	bne.n	c0de06f4 <handle_token_sent+0x8c>
                    memcpy(context->contract_address_sent,
c0de06ee:	490a      	ldr	r1, [pc, #40]	; (c0de0718 <handle_token_sent+0xb0>)
c0de06f0:	4479      	add	r1, pc
c0de06f2:	e7eb      	b.n	c0de06cc <handle_token_sent+0x64>
c0de06f4:	480e      	ldr	r0, [pc, #56]	; (c0de0730 <handle_token_sent+0xc8>)
c0de06f6:	4478      	add	r0, pc
c0de06f8:	f000 fb12 	bl	c0de0d20 <mcu_usb_printf>
c0de06fc:	e7ea      	b.n	c0de06d4 <handle_token_sent+0x6c>
                    memcpy(context->contract_address_sent,
c0de06fe:	4907      	ldr	r1, [pc, #28]	; (c0de071c <handle_token_sent+0xb4>)
c0de0700:	4479      	add	r1, pc
c0de0702:	e7e3      	b.n	c0de06cc <handle_token_sent+0x64>
                    memcpy(context->contract_address_sent,
c0de0704:	4908      	ldr	r1, [pc, #32]	; (c0de0728 <handle_token_sent+0xc0>)
c0de0706:	4479      	add	r1, pc
c0de0708:	e7e0      	b.n	c0de06cc <handle_token_sent+0x64>
                    memcpy(context->contract_address_sent,
c0de070a:	4908      	ldr	r1, [pc, #32]	; (c0de072c <handle_token_sent+0xc4>)
c0de070c:	4479      	add	r1, pc
c0de070e:	e7dd      	b.n	c0de06cc <handle_token_sent+0x64>
c0de0710:	000010c8 	.word	0x000010c8
c0de0714:	00001222 	.word	0x00001222
c0de0718:	00001210 	.word	0x00001210
c0de071c:	00001154 	.word	0x00001154
c0de0720:	00001226 	.word	0x00001226
c0de0724:	000011cc 	.word	0x000011cc
c0de0728:	00001162 	.word	0x00001162
c0de072c:	00001170 	.word	0x00001170
c0de0730:	00000ece 	.word	0x00000ece
c0de0734:	00000f03 	.word	0x00000f03

c0de0738 <handle_provide_token>:
#include "origin_defi_plugin.h"

// EDIT THIS: Adapt this function to your needs! Remember, the information for tokens are held in
// `msg->token1` and `msg->token2`. If those pointers are `NULL`, this means the ethereum app didn't
// find any info regarding the requested tokens!
void handle_provide_token(void *parameters) {
c0de0738:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de073a:	4604      	mov	r4, r0
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de073c:	6885      	ldr	r5, [r0, #8]
    PRINTF("OETH plugin provide token: 0x%p, 0x%p\n", msg->item1, msg->item2);
c0de073e:	68c1      	ldr	r1, [r0, #12]
c0de0740:	6902      	ldr	r2, [r0, #16]
c0de0742:	483a      	ldr	r0, [pc, #232]	; (c0de082c <handle_provide_token+0xf4>)
c0de0744:	4478      	add	r0, pc
c0de0746:	f000 faeb 	bl	c0de0d20 <mcu_usb_printf>

    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de074a:	462e      	mov	r6, r5
c0de074c:	3640      	adds	r6, #64	; 0x40
c0de074e:	4938      	ldr	r1, [pc, #224]	; (c0de0830 <handle_provide_token+0xf8>)
c0de0750:	4479      	add	r1, pc
c0de0752:	2214      	movs	r2, #20
c0de0754:	4630      	mov	r0, r6
c0de0756:	f000 fd7d 	bl	c0de1254 <memcmp>
c0de075a:	462f      	mov	r7, r5
c0de075c:	377e      	adds	r7, #126	; 0x7e
c0de075e:	2800      	cmp	r0, #0
c0de0760:	d00b      	beq.n	c0de077a <handle_provide_token+0x42>
        sent_network_token(context);
    } else if (msg->item1 != NULL) {
c0de0762:	68e1      	ldr	r1, [r4, #12]
c0de0764:	2900      	cmp	r1, #0
c0de0766:	d024      	beq.n	c0de07b2 <handle_provide_token+0x7a>
        context->decimals_sent = msg->item1->token.decimals;
c0de0768:	7fc8      	ldrb	r0, [r1, #31]
c0de076a:	7078      	strb	r0, [r7, #1]
        strlcpy(context->ticker_sent,
c0de076c:	4628      	mov	r0, r5
c0de076e:	3068      	adds	r0, #104	; 0x68
        context->decimals_sent = msg->item1->token.decimals;
c0de0770:	3114      	adds	r1, #20
c0de0772:	220b      	movs	r2, #11
        strlcpy(context->ticker_sent,
c0de0774:	f000 feb6 	bl	c0de14e4 <strlcpy>
c0de0778:	e001      	b.n	c0de077e <handle_provide_token+0x46>
c0de077a:	2012      	movs	r0, #18
    context->decimals_sent = WEI_TO_ETHER;
c0de077c:	7078      	strb	r0, [r7, #1]
c0de077e:	7838      	ldrb	r0, [r7, #0]
c0de0780:	2101      	movs	r1, #1
c0de0782:	4301      	orrs	r1, r0
c0de0784:	7039      	strb	r1, [r7, #0]
        strlcpy(context->ticker_sent, DEFAULT_TICKER, sizeof(context->ticker_sent));
        // // We will need an additional screen to display a warning message.
        msg->additionalScreens++;
    }

    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0786:	462e      	mov	r6, r5
c0de0788:	3654      	adds	r6, #84	; 0x54
c0de078a:	492c      	ldr	r1, [pc, #176]	; (c0de083c <handle_provide_token+0x104>)
c0de078c:	4479      	add	r1, pc
c0de078e:	2214      	movs	r2, #20
c0de0790:	4630      	mov	r0, r6
c0de0792:	f000 fd5f 	bl	c0de1254 <memcmp>
c0de0796:	2800      	cmp	r0, #0
c0de0798:	d035      	beq.n	c0de0806 <handle_provide_token+0xce>
        received_network_token(context);
    } else if (msg->item2 != NULL) {
c0de079a:	6921      	ldr	r1, [r4, #16]
c0de079c:	2900      	cmp	r1, #0
c0de079e:	d01d      	beq.n	c0de07dc <handle_provide_token+0xa4>
        context->decimals_received = msg->item2->token.decimals;
c0de07a0:	7fc8      	ldrb	r0, [r1, #31]
c0de07a2:	70b8      	strb	r0, [r7, #2]
        strlcpy(context->ticker_received,
c0de07a4:	3573      	adds	r5, #115	; 0x73
        context->decimals_received = msg->item2->token.decimals;
c0de07a6:	3114      	adds	r1, #20
c0de07a8:	220b      	movs	r2, #11
        strlcpy(context->ticker_received,
c0de07aa:	4628      	mov	r0, r5
c0de07ac:	f000 fe9a 	bl	c0de14e4 <strlcpy>
c0de07b0:	e02b      	b.n	c0de080a <handle_provide_token+0xd2>
    } else if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de07b2:	4920      	ldr	r1, [pc, #128]	; (c0de0834 <handle_provide_token+0xfc>)
c0de07b4:	4479      	add	r1, pc
c0de07b6:	2214      	movs	r2, #20
c0de07b8:	4630      	mov	r0, r6
c0de07ba:	f000 fd4b 	bl	c0de1254 <memcmp>
c0de07be:	2112      	movs	r1, #18
c0de07c0:	7079      	strb	r1, [r7, #1]
c0de07c2:	2800      	cmp	r0, #0
c0de07c4:	d0db      	beq.n	c0de077e <handle_provide_token+0x46>
        strlcpy(context->ticker_sent, DEFAULT_TICKER, sizeof(context->ticker_sent));
c0de07c6:	4628      	mov	r0, r5
c0de07c8:	3068      	adds	r0, #104	; 0x68
c0de07ca:	491b      	ldr	r1, [pc, #108]	; (c0de0838 <handle_provide_token+0x100>)
c0de07cc:	4479      	add	r1, pc
c0de07ce:	220b      	movs	r2, #11
c0de07d0:	f000 fe88 	bl	c0de14e4 <strlcpy>
        msg->additionalScreens++;
c0de07d4:	7d20      	ldrb	r0, [r4, #20]
c0de07d6:	1c40      	adds	r0, r0, #1
c0de07d8:	7520      	strb	r0, [r4, #20]
c0de07da:	e7d4      	b.n	c0de0786 <handle_provide_token+0x4e>
                (char *) msg->item2->token.ticker,
                sizeof(context->ticker_received));
        context->tokens_found |= TOKEN_RECEIVED_FOUND;
    } else if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de07dc:	4918      	ldr	r1, [pc, #96]	; (c0de0840 <handle_provide_token+0x108>)
c0de07de:	4479      	add	r1, pc
c0de07e0:	2214      	movs	r2, #20
c0de07e2:	4630      	mov	r0, r6
c0de07e4:	f000 fd36 	bl	c0de1254 <memcmp>
c0de07e8:	2800      	cmp	r0, #0
c0de07ea:	d00c      	beq.n	c0de0806 <handle_provide_token+0xce>
c0de07ec:	2012      	movs	r0, #18
c0de07ee:	70b8      	strb	r0, [r7, #2]
c0de07f0:	3573      	adds	r5, #115	; 0x73
        received_oeth(context);
    } else if (context->selectorIndex == VAULT_REDEEM) {
c0de07f2:	79f8      	ldrb	r0, [r7, #7]
c0de07f4:	2803      	cmp	r0, #3
c0de07f6:	d10f      	bne.n	c0de0818 <handle_provide_token+0xe0>
        context->decimals_received = DEFAULT_DECIMAL;
        strlcpy(context->ticker_received, "UNITS", sizeof(context->ticker_received));
c0de07f8:	4912      	ldr	r1, [pc, #72]	; (c0de0844 <handle_provide_token+0x10c>)
c0de07fa:	4479      	add	r1, pc
c0de07fc:	220b      	movs	r2, #11
c0de07fe:	4628      	mov	r0, r5
c0de0800:	f000 fe70 	bl	c0de14e4 <strlcpy>
c0de0804:	e005      	b.n	c0de0812 <handle_provide_token+0xda>
c0de0806:	2012      	movs	r0, #18
c0de0808:	70b8      	strb	r0, [r7, #2]
c0de080a:	7838      	ldrb	r0, [r7, #0]
c0de080c:	2102      	movs	r1, #2
c0de080e:	4301      	orrs	r1, r0
c0de0810:	7039      	strb	r1, [r7, #0]
c0de0812:	2004      	movs	r0, #4
        strlcpy(context->ticker_received, DEFAULT_TICKER, sizeof(context->ticker_received));
        // // We will need an additional screen to display a warning message.
        msg->additionalScreens++;
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0814:	7560      	strb	r0, [r4, #21]
c0de0816:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
        strlcpy(context->ticker_received, DEFAULT_TICKER, sizeof(context->ticker_received));
c0de0818:	490b      	ldr	r1, [pc, #44]	; (c0de0848 <handle_provide_token+0x110>)
c0de081a:	4479      	add	r1, pc
c0de081c:	220b      	movs	r2, #11
c0de081e:	4628      	mov	r0, r5
c0de0820:	f000 fe60 	bl	c0de14e4 <strlcpy>
        msg->additionalScreens++;
c0de0824:	7d20      	ldrb	r0, [r4, #20]
c0de0826:	1c40      	adds	r0, r0, #1
c0de0828:	7520      	strb	r0, [r4, #20]
c0de082a:	e7f2      	b.n	c0de0812 <handle_provide_token+0xda>
c0de082c:	00000ea2 	.word	0x00000ea2
c0de0830:	000011b0 	.word	0x000011b0
c0de0834:	000010a0 	.word	0x000010a0
c0de0838:	00000fa0 	.word	0x00000fa0
c0de083c:	00001174 	.word	0x00001174
c0de0840:	00001076 	.word	0x00001076
c0de0844:	00000fb8 	.word	0x00000fb8
c0de0848:	00000f52 	.word	0x00000f52

c0de084c <handle_query_contract_id>:
#include "origin_defi_plugin.h"

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de084c:	b5b0      	push	{r4, r5, r7, lr}
c0de084e:	4604      	mov	r4, r0
    ethQueryContractID_t *msg = (ethQueryContractID_t *) parameters;
    const origin_defi_parameters_t *context = (const origin_defi_parameters_t *) msg->pluginContext;
c0de0850:	6885      	ldr	r5, [r0, #8]
    // msg->name will be the upper sentence displayed on the screen.
    // msg->version will be the lower sentence displayed on the screen.

    // For the first screen, display the plugin name.
    strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de0852:	68c0      	ldr	r0, [r0, #12]
c0de0854:	6922      	ldr	r2, [r4, #16]
c0de0856:	4910      	ldr	r1, [pc, #64]	; (c0de0898 <handle_query_contract_id+0x4c>)
c0de0858:	4479      	add	r1, pc
c0de085a:	f000 fe43 	bl	c0de14e4 <strlcpy>
c0de085e:	2085      	movs	r0, #133	; 0x85

    switch (context->selectorIndex) {
c0de0860:	5c29      	ldrb	r1, [r5, r0]
c0de0862:	1f08      	subs	r0, r1, #4
c0de0864:	280b      	cmp	r0, #11
c0de0866:	d202      	bcs.n	c0de086e <handle_query_contract_id+0x22>
c0de0868:	490f      	ldr	r1, [pc, #60]	; (c0de08a8 <handle_query_contract_id+0x5c>)
c0de086a:	4479      	add	r1, pc
c0de086c:	e007      	b.n	c0de087e <handle_query_contract_id+0x32>
c0de086e:	2903      	cmp	r1, #3
c0de0870:	d202      	bcs.n	c0de0878 <handle_query_contract_id+0x2c>
c0de0872:	490a      	ldr	r1, [pc, #40]	; (c0de089c <handle_query_contract_id+0x50>)
c0de0874:	4479      	add	r1, pc
c0de0876:	e002      	b.n	c0de087e <handle_query_contract_id+0x32>
c0de0878:	d108      	bne.n	c0de088c <handle_query_contract_id+0x40>
c0de087a:	4909      	ldr	r1, [pc, #36]	; (c0de08a0 <handle_query_contract_id+0x54>)
c0de087c:	4479      	add	r1, pc
c0de087e:	6960      	ldr	r0, [r4, #20]
c0de0880:	69a2      	ldr	r2, [r4, #24]
c0de0882:	f000 fe2f 	bl	c0de14e4 <strlcpy>
c0de0886:	2004      	movs	r0, #4
c0de0888:	7720      	strb	r0, [r4, #28]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de088a:	bdb0      	pop	{r4, r5, r7, pc}
            PRINTF("Selector Index :%d not supported\n", context->selectorIndex);
c0de088c:	4805      	ldr	r0, [pc, #20]	; (c0de08a4 <handle_query_contract_id+0x58>)
c0de088e:	4478      	add	r0, pc
c0de0890:	f000 fa46 	bl	c0de0d20 <mcu_usb_printf>
c0de0894:	2000      	movs	r0, #0
c0de0896:	e7f7      	b.n	c0de0888 <handle_query_contract_id+0x3c>
c0de0898:	00000dda 	.word	0x00000dda
c0de089c:	00000d99 	.word	0x00000d99
c0de08a0:	00000dc2 	.word	0x00000dc2
c0de08a4:	00000edf 	.word	0x00000edf
c0de08a8:	00000dad 	.word	0x00000dad

c0de08ac <handle_query_contract_ui>:
            break;
    }
    return ERROR;
}

void handle_query_contract_ui(void *parameters) {
c0de08ac:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de08ae:	b085      	sub	sp, #20
c0de08b0:	4604      	mov	r4, r0
    ethQueryContractUI_t *msg = (ethQueryContractUI_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de08b2:	69c5      	ldr	r5, [r0, #28]
    memset(msg->title, 0, msg->titleLength);
c0de08b4:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de08b6:	6aa1      	ldr	r1, [r4, #40]	; 0x28
c0de08b8:	f000 fcb6 	bl	c0de1228 <__aeabi_memclr>
    memset(msg->msg, 0, msg->msgLength);
c0de08bc:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de08be:	6b21      	ldr	r1, [r4, #48]	; 0x30
c0de08c0:	f000 fcb2 	bl	c0de1228 <__aeabi_memclr>
c0de08c4:	4627      	mov	r7, r4
c0de08c6:	3720      	adds	r7, #32
c0de08c8:	2004      	movs	r0, #4
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de08ca:	7538      	strb	r0, [r7, #20]
c0de08cc:	2020      	movs	r0, #32
    uint8_t index = msg->screenIndex;
c0de08ce:	5c26      	ldrb	r6, [r4, r0]
c0de08d0:	207e      	movs	r0, #126	; 0x7e
c0de08d2:	9504      	str	r5, [sp, #16]
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de08d4:	5c28      	ldrb	r0, [r5, r0]
c0de08d6:	2103      	movs	r1, #3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de08d8:	4001      	ands	r1, r0
c0de08da:	2302      	movs	r3, #2
    bool token_received_found = context->tokens_found & TOKEN_RECEIVED_FOUND;
c0de08dc:	4605      	mov	r5, r0
c0de08de:	401d      	ands	r5, r3
c0de08e0:	2201      	movs	r2, #1
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de08e2:	4002      	ands	r2, r0
    switch (index) {
c0de08e4:	2e01      	cmp	r6, #1
c0de08e6:	d015      	beq.n	c0de0914 <handle_query_contract_ui+0x68>
c0de08e8:	2e00      	cmp	r6, #0
c0de08ea:	d178      	bne.n	c0de09de <handle_query_contract_ui+0x132>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de08ec:	4248      	negs	r0, r1
c0de08ee:	4148      	adcs	r0, r1
    bool both_tokens_found = token_received_found && token_sent_found;
c0de08f0:	1ece      	subs	r6, r1, #3
c0de08f2:	4271      	negs	r1, r6
c0de08f4:	4171      	adcs	r1, r6
            if (both_tokens_found) {
c0de08f6:	4301      	orrs	r1, r0
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de08f8:	1e50      	subs	r0, r2, #1
c0de08fa:	4182      	sbcs	r2, r0
            if (both_tokens_found) {
c0de08fc:	430a      	orrs	r2, r1
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de08fe:	1e70      	subs	r0, r6, #1
c0de0900:	4186      	sbcs	r6, r0
            if (both_tokens_found) {
c0de0902:	2900      	cmp	r1, #0
c0de0904:	d000      	beq.n	c0de0908 <handle_query_contract_ui+0x5c>
c0de0906:	0071      	lsls	r1, r6, #1
c0de0908:	2a00      	cmp	r2, #0
c0de090a:	d100      	bne.n	c0de090e <handle_query_contract_ui+0x62>
c0de090c:	4619      	mov	r1, r3
c0de090e:	2a00      	cmp	r2, #0
c0de0910:	d00f      	beq.n	c0de0932 <handle_query_contract_ui+0x86>
c0de0912:	e010      	b.n	c0de0936 <handle_query_contract_ui+0x8a>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0914:	424b      	negs	r3, r1
c0de0916:	414b      	adcs	r3, r1
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0918:	1ec8      	subs	r0, r1, #3
c0de091a:	4241      	negs	r1, r0
c0de091c:	4141      	adcs	r1, r0
            if (both_tokens_found) {
c0de091e:	430b      	orrs	r3, r1
c0de0920:	d100      	bne.n	c0de0924 <handle_query_contract_ui+0x78>
c0de0922:	2102      	movs	r1, #2
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0924:	1e50      	subs	r0, r2, #1
c0de0926:	4182      	sbcs	r2, r0
            if (both_tokens_found) {
c0de0928:	4313      	orrs	r3, r2
c0de092a:	d100      	bne.n	c0de092e <handle_query_contract_ui+0x82>
c0de092c:	4619      	mov	r1, r3
c0de092e:	2b00      	cmp	r3, #0
c0de0930:	d101      	bne.n	c0de0936 <handle_query_contract_ui+0x8a>
c0de0932:	2d00      	cmp	r5, #0
c0de0934:	d053      	beq.n	c0de09de <handle_query_contract_ui+0x132>
    screens_t screen = get_screen(msg, context);
    switch (screen) {
c0de0936:	2902      	cmp	r1, #2
c0de0938:	d059      	beq.n	c0de09ee <handle_query_contract_ui+0x142>
c0de093a:	9d04      	ldr	r5, [sp, #16]
c0de093c:	4628      	mov	r0, r5
c0de093e:	307e      	adds	r0, #126	; 0x7e
c0de0940:	2901      	cmp	r1, #1
c0de0942:	d061      	beq.n	c0de0a08 <handle_query_contract_ui+0x15c>
c0de0944:	2900      	cmp	r1, #0
c0de0946:	d14a      	bne.n	c0de09de <handle_query_contract_ui+0x132>
c0de0948:	4605      	mov	r5, r0
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de094a:	9e04      	ldr	r6, [sp, #16]
c0de094c:	3640      	adds	r6, #64	; 0x40
c0de094e:	499e      	ldr	r1, [pc, #632]	; (c0de0bc8 <handle_query_contract_ui+0x31c>)
c0de0950:	4479      	add	r1, pc
c0de0952:	2214      	movs	r2, #20
c0de0954:	4630      	mov	r0, r6
c0de0956:	f000 fc7d 	bl	c0de1254 <memcmp>
c0de095a:	2800      	cmp	r0, #0
c0de095c:	d106      	bne.n	c0de096c <handle_query_contract_ui+0xc0>
        strlcpy(context->ticker_sent, msg->network_ticker, sizeof(context->ticker_sent));
c0de095e:	9804      	ldr	r0, [sp, #16]
c0de0960:	3068      	adds	r0, #104	; 0x68
c0de0962:	4621      	mov	r1, r4
c0de0964:	3110      	adds	r1, #16
c0de0966:	220b      	movs	r2, #11
c0de0968:	f000 fdbc 	bl	c0de14e4 <strlcpy>
    if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de096c:	4997      	ldr	r1, [pc, #604]	; (c0de0bcc <handle_query_contract_ui+0x320>)
c0de096e:	4479      	add	r1, pc
c0de0970:	2214      	movs	r2, #20
c0de0972:	4630      	mov	r0, r6
c0de0974:	f000 fc6e 	bl	c0de1254 <memcmp>
c0de0978:	2800      	cmp	r0, #0
c0de097a:	d106      	bne.n	c0de098a <handle_query_contract_ui+0xde>
        strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de097c:	9804      	ldr	r0, [sp, #16]
c0de097e:	3068      	adds	r0, #104	; 0x68
c0de0980:	4993      	ldr	r1, [pc, #588]	; (c0de0bd0 <handle_query_contract_ui+0x324>)
c0de0982:	4479      	add	r1, pc
c0de0984:	220b      	movs	r2, #11
c0de0986:	f000 fdad 	bl	c0de14e4 <strlcpy>
    strlcpy(msg->title, "Send", msg->titleLength);
c0de098a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de098c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de098e:	4991      	ldr	r1, [pc, #580]	; (c0de0bd4 <handle_query_contract_ui+0x328>)
c0de0990:	4479      	add	r1, pc
c0de0992:	f000 fda7 	bl	c0de14e4 <strlcpy>
    switch (context->selectorIndex) {
c0de0996:	79e9      	ldrb	r1, [r5, #7]
c0de0998:	1f08      	subs	r0, r1, #4
c0de099a:	2805      	cmp	r0, #5
c0de099c:	d200      	bcs.n	c0de09a0 <handle_query_contract_ui+0xf4>
c0de099e:	e102      	b.n	c0de0ba6 <handle_query_contract_ui+0x2fa>
c0de09a0:	290e      	cmp	r1, #14
c0de09a2:	d100      	bne.n	c0de09a6 <handle_query_contract_ui+0xfa>
c0de09a4:	e080      	b.n	c0de0aa8 <handle_query_contract_ui+0x1fc>
c0de09a6:	2901      	cmp	r1, #1
c0de09a8:	d100      	bne.n	c0de09ac <handle_query_contract_ui+0x100>
c0de09aa:	e082      	b.n	c0de0ab2 <handle_query_contract_ui+0x206>
c0de09ac:	2902      	cmp	r1, #2
c0de09ae:	d011      	beq.n	c0de09d4 <handle_query_contract_ui+0x128>
c0de09b0:	2903      	cmp	r1, #3
c0de09b2:	d100      	bne.n	c0de09b6 <handle_query_contract_ui+0x10a>
c0de09b4:	e088      	b.n	c0de0ac8 <handle_query_contract_ui+0x21c>
c0de09b6:	2909      	cmp	r1, #9
c0de09b8:	d100      	bne.n	c0de09bc <handle_query_contract_ui+0x110>
c0de09ba:	e09b      	b.n	c0de0af4 <handle_query_contract_ui+0x248>
c0de09bc:	290a      	cmp	r1, #10
c0de09be:	d073      	beq.n	c0de0aa8 <handle_query_contract_ui+0x1fc>
c0de09c0:	290b      	cmp	r1, #11
c0de09c2:	d100      	bne.n	c0de09c6 <handle_query_contract_ui+0x11a>
c0de09c4:	e09b      	b.n	c0de0afe <handle_query_contract_ui+0x252>
c0de09c6:	290c      	cmp	r1, #12
c0de09c8:	d06e      	beq.n	c0de0aa8 <handle_query_contract_ui+0x1fc>
c0de09ca:	290d      	cmp	r1, #13
c0de09cc:	d100      	bne.n	c0de09d0 <handle_query_contract_ui+0x124>
c0de09ce:	e0a0      	b.n	c0de0b12 <handle_query_contract_ui+0x266>
c0de09d0:	2900      	cmp	r1, #0
c0de09d2:	d155      	bne.n	c0de0a80 <handle_query_contract_ui+0x1d4>
c0de09d4:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de09d6:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de09d8:	497f      	ldr	r1, [pc, #508]	; (c0de0bd8 <handle_query_contract_ui+0x32c>)
c0de09da:	4479      	add	r1, pc
c0de09dc:	e0e1      	b.n	c0de0ba2 <handle_query_contract_ui+0x2f6>
            break;
        case WARN_SCREEN:
            set_warning_ui(msg, context);
            break;
        default:
            PRINTF("Received an invalid screenIndex\n");
c0de09de:	4898      	ldr	r0, [pc, #608]	; (c0de0c40 <handle_query_contract_ui+0x394>)
c0de09e0:	4478      	add	r0, pc
c0de09e2:	f000 f99d 	bl	c0de0d20 <mcu_usb_printf>
c0de09e6:	2000      	movs	r0, #0
c0de09e8:	7538      	strb	r0, [r7, #20]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }
}
c0de09ea:	b005      	add	sp, #20
c0de09ec:	bdf0      	pop	{r4, r5, r6, r7, pc}
    strlcpy(msg->title, "WARNING", msg->titleLength);
c0de09ee:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de09f0:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de09f2:	4991      	ldr	r1, [pc, #580]	; (c0de0c38 <handle_query_contract_ui+0x38c>)
c0de09f4:	4479      	add	r1, pc
c0de09f6:	f000 fd75 	bl	c0de14e4 <strlcpy>
    strlcpy(msg->msg, "Unknown token", msg->msgLength);
c0de09fa:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de09fc:	6b22      	ldr	r2, [r4, #48]	; 0x30
c0de09fe:	498f      	ldr	r1, [pc, #572]	; (c0de0c3c <handle_query_contract_ui+0x390>)
c0de0a00:	4479      	add	r1, pc
c0de0a02:	f000 fd6f 	bl	c0de14e4 <strlcpy>
c0de0a06:	e7f0      	b.n	c0de09ea <handle_query_contract_ui+0x13e>
c0de0a08:	9003      	str	r0, [sp, #12]
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0a0a:	462e      	mov	r6, r5
c0de0a0c:	3654      	adds	r6, #84	; 0x54
c0de0a0e:	497e      	ldr	r1, [pc, #504]	; (c0de0c08 <handle_query_contract_ui+0x35c>)
c0de0a10:	4479      	add	r1, pc
c0de0a12:	2214      	movs	r2, #20
c0de0a14:	4630      	mov	r0, r6
c0de0a16:	f000 fc1d 	bl	c0de1254 <memcmp>
c0de0a1a:	2800      	cmp	r0, #0
c0de0a1c:	d106      	bne.n	c0de0a2c <handle_query_contract_ui+0x180>
        strlcpy(context->ticker_received, msg->network_ticker, sizeof(context->ticker_received));
c0de0a1e:	4628      	mov	r0, r5
c0de0a20:	3073      	adds	r0, #115	; 0x73
c0de0a22:	4621      	mov	r1, r4
c0de0a24:	3110      	adds	r1, #16
c0de0a26:	220b      	movs	r2, #11
c0de0a28:	f000 fd5c 	bl	c0de14e4 <strlcpy>
    if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de0a2c:	4977      	ldr	r1, [pc, #476]	; (c0de0c0c <handle_query_contract_ui+0x360>)
c0de0a2e:	4479      	add	r1, pc
c0de0a30:	2214      	movs	r2, #20
c0de0a32:	4630      	mov	r0, r6
c0de0a34:	f000 fc0e 	bl	c0de1254 <memcmp>
c0de0a38:	2800      	cmp	r0, #0
c0de0a3a:	d106      	bne.n	c0de0a4a <handle_query_contract_ui+0x19e>
        strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de0a3c:	4628      	mov	r0, r5
c0de0a3e:	3073      	adds	r0, #115	; 0x73
c0de0a40:	4973      	ldr	r1, [pc, #460]	; (c0de0c10 <handle_query_contract_ui+0x364>)
c0de0a42:	4479      	add	r1, pc
c0de0a44:	220b      	movs	r2, #11
c0de0a46:	f000 fd4d 	bl	c0de14e4 <strlcpy>
    strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de0a4a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0a4c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0a4e:	4971      	ldr	r1, [pc, #452]	; (c0de0c14 <handle_query_contract_ui+0x368>)
c0de0a50:	4479      	add	r1, pc
c0de0a52:	f000 fd47 	bl	c0de14e4 <strlcpy>
c0de0a56:	9e03      	ldr	r6, [sp, #12]
    switch (context->selectorIndex) {
c0de0a58:	79f1      	ldrb	r1, [r6, #7]
c0de0a5a:	1f08      	subs	r0, r1, #4
c0de0a5c:	2805      	cmp	r0, #5
c0de0a5e:	d200      	bcs.n	c0de0a62 <handle_query_contract_ui+0x1b6>
c0de0a60:	e08c      	b.n	c0de0b7c <handle_query_contract_ui+0x2d0>
c0de0a62:	2903      	cmp	r1, #3
c0de0a64:	d311      	bcc.n	c0de0a8a <handle_query_contract_ui+0x1de>
c0de0a66:	d05f      	beq.n	c0de0b28 <handle_query_contract_ui+0x27c>
c0de0a68:	2909      	cmp	r1, #9
c0de0a6a:	d013      	beq.n	c0de0a94 <handle_query_contract_ui+0x1e8>
c0de0a6c:	290a      	cmp	r1, #10
c0de0a6e:	d061      	beq.n	c0de0b34 <handle_query_contract_ui+0x288>
c0de0a70:	290b      	cmp	r1, #11
c0de0a72:	d00f      	beq.n	c0de0a94 <handle_query_contract_ui+0x1e8>
c0de0a74:	290c      	cmp	r1, #12
c0de0a76:	d069      	beq.n	c0de0b4c <handle_query_contract_ui+0x2a0>
c0de0a78:	290d      	cmp	r1, #13
c0de0a7a:	d00b      	beq.n	c0de0a94 <handle_query_contract_ui+0x1e8>
c0de0a7c:	290e      	cmp	r1, #14
c0de0a7e:	d071      	beq.n	c0de0b64 <handle_query_contract_ui+0x2b8>
c0de0a80:	4865      	ldr	r0, [pc, #404]	; (c0de0c18 <handle_query_contract_ui+0x36c>)
c0de0a82:	4478      	add	r0, pc
c0de0a84:	f000 f94c 	bl	c0de0d20 <mcu_usb_printf>
c0de0a88:	e7ad      	b.n	c0de09e6 <handle_query_contract_ui+0x13a>
            strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de0a8a:	4628      	mov	r0, r5
c0de0a8c:	3073      	adds	r0, #115	; 0x73
c0de0a8e:	4963      	ldr	r1, [pc, #396]	; (c0de0c1c <handle_query_contract_ui+0x370>)
c0de0a90:	4479      	add	r1, pc
c0de0a92:	e04d      	b.n	c0de0b30 <handle_query_contract_ui+0x284>
            strlcpy(context->ticker_received, OUSD_TICKER, sizeof(context->ticker_received));
c0de0a94:	4628      	mov	r0, r5
c0de0a96:	3073      	adds	r0, #115	; 0x73
c0de0a98:	4962      	ldr	r1, [pc, #392]	; (c0de0c24 <handle_query_contract_ui+0x378>)
c0de0a9a:	4479      	add	r1, pc
c0de0a9c:	220b      	movs	r2, #11
c0de0a9e:	f000 fd21 	bl	c0de14e4 <strlcpy>
            strlcpy(context->decimals_received, OUSD_DECIMALS, sizeof(context->decimals_received));
c0de0aa2:	78b0      	ldrb	r0, [r6, #2]
c0de0aa4:	2112      	movs	r1, #18
c0de0aa6:	e066      	b.n	c0de0b76 <handle_query_contract_ui+0x2ca>
            strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de0aa8:	9804      	ldr	r0, [sp, #16]
c0de0aaa:	3068      	adds	r0, #104	; 0x68
c0de0aac:	4955      	ldr	r1, [pc, #340]	; (c0de0c04 <handle_query_contract_ui+0x358>)
c0de0aae:	4479      	add	r1, pc
c0de0ab0:	e029      	b.n	c0de0b06 <handle_query_contract_ui+0x25a>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de0ab2:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0ab4:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0ab6:	494a      	ldr	r1, [pc, #296]	; (c0de0be0 <handle_query_contract_ui+0x334>)
c0de0ab8:	4479      	add	r1, pc
c0de0aba:	f000 fd13 	bl	c0de14e4 <strlcpy>
            strlcpy(context->ticker_sent, SFRXETH_TICKER, sizeof(context->ticker_sent));
c0de0abe:	9804      	ldr	r0, [sp, #16]
c0de0ac0:	3068      	adds	r0, #104	; 0x68
c0de0ac2:	4948      	ldr	r1, [pc, #288]	; (c0de0be4 <handle_query_contract_ui+0x338>)
c0de0ac4:	4479      	add	r1, pc
c0de0ac6:	e06b      	b.n	c0de0ba0 <handle_query_contract_ui+0x2f4>
            strlcpy(msg->title, "Redeem", msg->titleLength);
c0de0ac8:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0aca:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0acc:	4946      	ldr	r1, [pc, #280]	; (c0de0be8 <handle_query_contract_ui+0x33c>)
c0de0ace:	4479      	add	r1, pc
c0de0ad0:	f000 fd08 	bl	c0de14e4 <strlcpy>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0ad4:	6860      	ldr	r0, [r4, #4]
c0de0ad6:	6801      	ldr	r1, [r0, #0]
c0de0ad8:	31a5      	adds	r1, #165	; 0xa5
c0de0ada:	4844      	ldr	r0, [pc, #272]	; (c0de0bec <handle_query_contract_ui+0x340>)
c0de0adc:	4478      	add	r0, pc
c0de0ade:	2214      	movs	r2, #20
c0de0ae0:	f000 fbb8 	bl	c0de1254 <memcmp>
c0de0ae4:	4601      	mov	r1, r0
c0de0ae6:	9804      	ldr	r0, [sp, #16]
c0de0ae8:	3068      	adds	r0, #104	; 0x68
c0de0aea:	2900      	cmp	r1, #0
c0de0aec:	d056      	beq.n	c0de0b9c <handle_query_contract_ui+0x2f0>
                strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de0aee:	4941      	ldr	r1, [pc, #260]	; (c0de0bf4 <handle_query_contract_ui+0x348>)
c0de0af0:	4479      	add	r1, pc
c0de0af2:	e055      	b.n	c0de0ba0 <handle_query_contract_ui+0x2f4>
            strlcpy(context->ticker_sent, USDT_TICKER, sizeof(context->ticker_sent));
c0de0af4:	9804      	ldr	r0, [sp, #16]
c0de0af6:	3068      	adds	r0, #104	; 0x68
c0de0af8:	493f      	ldr	r1, [pc, #252]	; (c0de0bf8 <handle_query_contract_ui+0x34c>)
c0de0afa:	4479      	add	r1, pc
c0de0afc:	e00d      	b.n	c0de0b1a <handle_query_contract_ui+0x26e>
            strlcpy(context->ticker_sent, DAI_TICKER, sizeof(context->ticker_sent));
c0de0afe:	9804      	ldr	r0, [sp, #16]
c0de0b00:	3068      	adds	r0, #104	; 0x68
c0de0b02:	493e      	ldr	r1, [pc, #248]	; (c0de0bfc <handle_query_contract_ui+0x350>)
c0de0b04:	4479      	add	r1, pc
c0de0b06:	220b      	movs	r2, #11
c0de0b08:	f000 fcec 	bl	c0de14e4 <strlcpy>
c0de0b0c:	7868      	ldrb	r0, [r5, #1]
c0de0b0e:	2112      	movs	r1, #18
c0de0b10:	e008      	b.n	c0de0b24 <handle_query_contract_ui+0x278>
            strlcpy(context->ticker_sent, USDC_TICKER, sizeof(context->ticker_sent));
c0de0b12:	9804      	ldr	r0, [sp, #16]
c0de0b14:	3068      	adds	r0, #104	; 0x68
c0de0b16:	493a      	ldr	r1, [pc, #232]	; (c0de0c00 <handle_query_contract_ui+0x354>)
c0de0b18:	4479      	add	r1, pc
c0de0b1a:	220b      	movs	r2, #11
c0de0b1c:	f000 fce2 	bl	c0de14e4 <strlcpy>
c0de0b20:	7868      	ldrb	r0, [r5, #1]
c0de0b22:	2106      	movs	r1, #6
c0de0b24:	2201      	movs	r2, #1
c0de0b26:	e03c      	b.n	c0de0ba2 <handle_query_contract_ui+0x2f6>
            strlcpy(context->ticker_received, ETH_UNITS_TICKER, sizeof(context->ticker_received));
c0de0b28:	4628      	mov	r0, r5
c0de0b2a:	3073      	adds	r0, #115	; 0x73
c0de0b2c:	493c      	ldr	r1, [pc, #240]	; (c0de0c20 <handle_query_contract_ui+0x374>)
c0de0b2e:	4479      	add	r1, pc
c0de0b30:	220b      	movs	r2, #11
c0de0b32:	e021      	b.n	c0de0b78 <handle_query_contract_ui+0x2cc>
            strlcpy(context->ticker_received, USDT_TICKER, sizeof(context->ticker_received));
c0de0b34:	4628      	mov	r0, r5
c0de0b36:	3073      	adds	r0, #115	; 0x73
c0de0b38:	493c      	ldr	r1, [pc, #240]	; (c0de0c2c <handle_query_contract_ui+0x380>)
c0de0b3a:	4479      	add	r1, pc
c0de0b3c:	220b      	movs	r2, #11
c0de0b3e:	f000 fcd1 	bl	c0de14e4 <strlcpy>
            strlcpy(context->decimals_received, USDT_DECIMALS, sizeof(context->decimals_received));
c0de0b42:	78b0      	ldrb	r0, [r6, #2]
c0de0b44:	2106      	movs	r1, #6
c0de0b46:	2201      	movs	r2, #1
c0de0b48:	f000 fccc 	bl	c0de14e4 <strlcpy>
            strlcpy(context->ticker_received, DAI_TICKER, sizeof(context->ticker_received));
c0de0b4c:	4628      	mov	r0, r5
c0de0b4e:	3073      	adds	r0, #115	; 0x73
c0de0b50:	4937      	ldr	r1, [pc, #220]	; (c0de0c30 <handle_query_contract_ui+0x384>)
c0de0b52:	4479      	add	r1, pc
c0de0b54:	220b      	movs	r2, #11
c0de0b56:	f000 fcc5 	bl	c0de14e4 <strlcpy>
            strlcpy(context->decimals_received, DAI_DECIMALS, sizeof(context->decimals_received));
c0de0b5a:	78b0      	ldrb	r0, [r6, #2]
c0de0b5c:	2112      	movs	r1, #18
c0de0b5e:	2201      	movs	r2, #1
c0de0b60:	f000 fcc0 	bl	c0de14e4 <strlcpy>
            strlcpy(context->ticker_received, USDC_TICKER, sizeof(context->ticker_received));
c0de0b64:	4628      	mov	r0, r5
c0de0b66:	3073      	adds	r0, #115	; 0x73
c0de0b68:	4932      	ldr	r1, [pc, #200]	; (c0de0c34 <handle_query_contract_ui+0x388>)
c0de0b6a:	4479      	add	r1, pc
c0de0b6c:	220b      	movs	r2, #11
c0de0b6e:	f000 fcb9 	bl	c0de14e4 <strlcpy>
            strlcpy(context->decimals_received, USDC_DECIMALS, sizeof(context->decimals_received));
c0de0b72:	78b0      	ldrb	r0, [r6, #2]
c0de0b74:	2106      	movs	r1, #6
c0de0b76:	2201      	movs	r2, #1
c0de0b78:	f000 fcb4 	bl	c0de14e4 <strlcpy>
                   context->decimals_received,
c0de0b7c:	78b2      	ldrb	r2, [r6, #2]
                   msg->msg,
c0de0b7e:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de0b80:	6b21      	ldr	r1, [r4, #48]	; 0x30
    amountToString(context->min_amount_received,
c0de0b82:	9000      	str	r0, [sp, #0]
c0de0b84:	9101      	str	r1, [sp, #4]
c0de0b86:	4628      	mov	r0, r5
c0de0b88:	3020      	adds	r0, #32
                   context->ticker_received,
c0de0b8a:	3573      	adds	r5, #115	; 0x73
c0de0b8c:	2120      	movs	r1, #32
    amountToString(context->min_amount_received,
c0de0b8e:	462b      	mov	r3, r5
c0de0b90:	f7ff fb69 	bl	c0de0266 <amountToString>
    PRINTF("AMOUNT RECEIVED: %s\n", msg->msg);
c0de0b94:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de0b96:	4824      	ldr	r0, [pc, #144]	; (c0de0c28 <handle_query_contract_ui+0x37c>)
c0de0b98:	4478      	add	r0, pc
c0de0b9a:	e012      	b.n	c0de0bc2 <handle_query_contract_ui+0x316>
                strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de0b9c:	4914      	ldr	r1, [pc, #80]	; (c0de0bf0 <handle_query_contract_ui+0x344>)
c0de0b9e:	4479      	add	r1, pc
c0de0ba0:	220b      	movs	r2, #11
c0de0ba2:	f000 fc9f 	bl	c0de14e4 <strlcpy>
                   context->decimals_sent,
c0de0ba6:	786a      	ldrb	r2, [r5, #1]
                   msg->msg,
c0de0ba8:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de0baa:	6b21      	ldr	r1, [r4, #48]	; 0x30
    amountToString(context->amount_sent,
c0de0bac:	9000      	str	r0, [sp, #0]
c0de0bae:	9101      	str	r1, [sp, #4]
c0de0bb0:	9804      	ldr	r0, [sp, #16]
                   context->ticker_sent,
c0de0bb2:	4603      	mov	r3, r0
c0de0bb4:	3368      	adds	r3, #104	; 0x68
c0de0bb6:	2120      	movs	r1, #32
    amountToString(context->amount_sent,
c0de0bb8:	f7ff fb55 	bl	c0de0266 <amountToString>
    PRINTF("AMOUNT SENT: %s\n", msg->msg);
c0de0bbc:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de0bbe:	4807      	ldr	r0, [pc, #28]	; (c0de0bdc <handle_query_contract_ui+0x330>)
c0de0bc0:	4478      	add	r0, pc
c0de0bc2:	f000 f8ad 	bl	c0de0d20 <mcu_usb_printf>
c0de0bc6:	e710      	b.n	c0de09ea <handle_query_contract_ui+0x13e>
c0de0bc8:	00000fb0 	.word	0x00000fb0
c0de0bcc:	00000ee6 	.word	0x00000ee6
c0de0bd0:	00000e7a 	.word	0x00000e7a
c0de0bd4:	00000c05 	.word	0x00000c05
c0de0bd8:	00000dde 	.word	0x00000dde
c0de0bdc:	00000b9b 	.word	0x00000b9b
c0de0be0:	00000d00 	.word	0x00000d00
c0de0be4:	00000beb 	.word	0x00000beb
c0de0be8:	00000b70 	.word	0x00000b70
c0de0bec:	00000dc8 	.word	0x00000dc8
c0de0bf0:	00000c5e 	.word	0x00000c5e
c0de0bf4:	00000b3d 	.word	0x00000b3d
c0de0bf8:	00000c95 	.word	0x00000c95
c0de0bfc:	00000a54 	.word	0x00000a54
c0de0c00:	00000b2d 	.word	0x00000b2d
c0de0c04:	00000b7f 	.word	0x00000b7f
c0de0c08:	00000ef0 	.word	0x00000ef0
c0de0c0c:	00000e26 	.word	0x00000e26
c0de0c10:	00000dba 	.word	0x00000dba
c0de0c14:	00000c3c 	.word	0x00000c3c
c0de0c18:	00000d12 	.word	0x00000d12
c0de0c1c:	00000d6c 	.word	0x00000d6c
c0de0c20:	00000c84 	.word	0x00000c84
c0de0c24:	00000b93 	.word	0x00000b93
c0de0c28:	00000c69 	.word	0x00000c69
c0de0c2c:	00000c55 	.word	0x00000c55
c0de0c30:	00000a06 	.word	0x00000a06
c0de0c34:	00000adb 	.word	0x00000adb
c0de0c38:	00000ba6 	.word	0x00000ba6
c0de0c3c:	00000cb7 	.word	0x00000cb7
c0de0c40:	00000d45 	.word	0x00000d45

c0de0c44 <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de0c44:	b580      	push	{r7, lr}
c0de0c46:	4602      	mov	r2, r0
c0de0c48:	2083      	movs	r0, #131	; 0x83
c0de0c4a:	0040      	lsls	r0, r0, #1
    switch (message) {
c0de0c4c:	4282      	cmp	r2, r0
c0de0c4e:	d017      	beq.n	c0de0c80 <dispatch_plugin_calls+0x3c>
c0de0c50:	2081      	movs	r0, #129	; 0x81
c0de0c52:	0040      	lsls	r0, r0, #1
c0de0c54:	4282      	cmp	r2, r0
c0de0c56:	d017      	beq.n	c0de0c88 <dispatch_plugin_calls+0x44>
c0de0c58:	20ff      	movs	r0, #255	; 0xff
c0de0c5a:	4603      	mov	r3, r0
c0de0c5c:	3304      	adds	r3, #4
c0de0c5e:	429a      	cmp	r2, r3
c0de0c60:	d016      	beq.n	c0de0c90 <dispatch_plugin_calls+0x4c>
c0de0c62:	2341      	movs	r3, #65	; 0x41
c0de0c64:	009b      	lsls	r3, r3, #2
c0de0c66:	429a      	cmp	r2, r3
c0de0c68:	d016      	beq.n	c0de0c98 <dispatch_plugin_calls+0x54>
c0de0c6a:	4603      	mov	r3, r0
c0de0c6c:	3306      	adds	r3, #6
c0de0c6e:	429a      	cmp	r2, r3
c0de0c70:	d016      	beq.n	c0de0ca0 <dispatch_plugin_calls+0x5c>
c0de0c72:	3002      	adds	r0, #2
c0de0c74:	4282      	cmp	r2, r0
c0de0c76:	d117      	bne.n	c0de0ca8 <dispatch_plugin_calls+0x64>
            handle_init_contract(parameters);
c0de0c78:	4608      	mov	r0, r1
c0de0c7a:	f7ff fba1 	bl	c0de03c0 <handle_init_contract>
}
c0de0c7e:	bd80      	pop	{r7, pc}
            handle_query_contract_ui(parameters);
c0de0c80:	4608      	mov	r0, r1
c0de0c82:	f7ff fe13 	bl	c0de08ac <handle_query_contract_ui>
}
c0de0c86:	bd80      	pop	{r7, pc}
            handle_provide_parameter(parameters);
c0de0c88:	4608      	mov	r0, r1
c0de0c8a:	f7ff fbf1 	bl	c0de0470 <handle_provide_parameter>
}
c0de0c8e:	bd80      	pop	{r7, pc}
            handle_finalize(parameters);
c0de0c90:	4608      	mov	r0, r1
c0de0c92:	f7ff fb2f 	bl	c0de02f4 <handle_finalize>
}
c0de0c96:	bd80      	pop	{r7, pc}
            handle_provide_token(parameters);
c0de0c98:	4608      	mov	r0, r1
c0de0c9a:	f7ff fd4d 	bl	c0de0738 <handle_provide_token>
}
c0de0c9e:	bd80      	pop	{r7, pc}
            handle_query_contract_id(parameters);
c0de0ca0:	4608      	mov	r0, r1
c0de0ca2:	f7ff fdd3 	bl	c0de084c <handle_query_contract_id>
}
c0de0ca6:	bd80      	pop	{r7, pc}
            PRINTF("Unhandled message %d\n", message);
c0de0ca8:	4802      	ldr	r0, [pc, #8]	; (c0de0cb4 <dispatch_plugin_calls+0x70>)
c0de0caa:	4478      	add	r0, pc
c0de0cac:	4611      	mov	r1, r2
c0de0cae:	f000 f837 	bl	c0de0d20 <mcu_usb_printf>
}
c0de0cb2:	bd80      	pop	{r7, pc}
c0de0cb4:	00000a49 	.word	0x00000a49

c0de0cb8 <call_app_ethereum>:
void call_app_ethereum() {
c0de0cb8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    libcall_params[0] = (unsigned int) "Ethereum";
c0de0cba:	4805      	ldr	r0, [pc, #20]	; (c0de0cd0 <call_app_ethereum+0x18>)
c0de0cbc:	4478      	add	r0, pc
c0de0cbe:	9001      	str	r0, [sp, #4]
c0de0cc0:	2001      	movs	r0, #1
    libcall_params[2] = RUN_APPLICATION;
c0de0cc2:	9003      	str	r0, [sp, #12]
c0de0cc4:	0200      	lsls	r0, r0, #8
    libcall_params[1] = 0x100;
c0de0cc6:	9002      	str	r0, [sp, #8]
c0de0cc8:	a801      	add	r0, sp, #4
    os_lib_call((unsigned int *) &libcall_params);
c0de0cca:	f000 f9b9 	bl	c0de1040 <os_lib_call>
}
c0de0cce:	bd8f      	pop	{r0, r1, r2, r3, r7, pc}
c0de0cd0:	0000098e 	.word	0x0000098e

c0de0cd4 <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de0cd4:	b580      	push	{r7, lr}
c0de0cd6:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de0cd8:	f000 f9e4 	bl	c0de10a4 <try_context_set>
#endif // HAVE_BOLOS
}
c0de0cdc:	bd80      	pop	{r7, pc}
c0de0cde:	d4d4      	bmi.n	c0de0c8a <dispatch_plugin_calls+0x46>

c0de0ce0 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de0ce0:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF  
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de0ce2:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de0ce4:	4804      	ldr	r0, [pc, #16]	; (c0de0cf8 <os_longjmp+0x18>)
c0de0ce6:	4478      	add	r0, pc
c0de0ce8:	4621      	mov	r1, r4
c0de0cea:	f000 f819 	bl	c0de0d20 <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de0cee:	f000 f9d1 	bl	c0de1094 <try_context_get>
c0de0cf2:	4621      	mov	r1, r4
c0de0cf4:	f000 fbe8 	bl	c0de14c8 <longjmp>
c0de0cf8:	000009ed 	.word	0x000009ed

c0de0cfc <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de0cfc:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de0cfe:	460c      	mov	r4, r1
c0de0d00:	4605      	mov	r5, r0
c0de0d02:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de0d04:	7081      	strb	r1, [r0, #2]
c0de0d06:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de0d08:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de0d0a:	0a21      	lsrs	r1, r4, #8
c0de0d0c:	7041      	strb	r1, [r0, #1]
c0de0d0e:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de0d10:	f000 f9b6 	bl	c0de1080 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de0d14:	b2a1      	uxth	r1, r4
c0de0d16:	4628      	mov	r0, r5
c0de0d18:	f000 f9b2 	bl	c0de1080 <io_seph_send>
}
c0de0d1c:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
c0de0d1e:	d4d4      	bmi.n	c0de0cca <call_app_ethereum+0x12>

c0de0d20 <mcu_usb_printf>:
#include "usbd_def.h"
#include "usbd_core.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de0d20:	b083      	sub	sp, #12
c0de0d22:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0d24:	b08e      	sub	sp, #56	; 0x38
c0de0d26:	ac13      	add	r4, sp, #76	; 0x4c
c0de0d28:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de0d2a:	2800      	cmp	r0, #0
c0de0d2c:	d100      	bne.n	c0de0d30 <mcu_usb_printf+0x10>
c0de0d2e:	e163      	b.n	c0de0ff8 <mcu_usb_printf+0x2d8>
c0de0d30:	4607      	mov	r7, r0
c0de0d32:	a813      	add	r0, sp, #76	; 0x4c
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de0d34:	9008      	str	r0, [sp, #32]
c0de0d36:	2001      	movs	r0, #1
c0de0d38:	9003      	str	r0, [sp, #12]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de0d3a:	7838      	ldrb	r0, [r7, #0]
c0de0d3c:	2800      	cmp	r0, #0
c0de0d3e:	d100      	bne.n	c0de0d42 <mcu_usb_printf+0x22>
c0de0d40:	e15a      	b.n	c0de0ff8 <mcu_usb_printf+0x2d8>
c0de0d42:	463c      	mov	r4, r7
c0de0d44:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de0d46:	2800      	cmp	r0, #0
c0de0d48:	d005      	beq.n	c0de0d56 <mcu_usb_printf+0x36>
c0de0d4a:	2825      	cmp	r0, #37	; 0x25
c0de0d4c:	d003      	beq.n	c0de0d56 <mcu_usb_printf+0x36>
c0de0d4e:	1960      	adds	r0, r4, r5
c0de0d50:	7840      	ldrb	r0, [r0, #1]
            ulIdx++)
c0de0d52:	1c6d      	adds	r5, r5, #1
c0de0d54:	e7f7      	b.n	c0de0d46 <mcu_usb_printf+0x26>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de0d56:	4620      	mov	r0, r4
c0de0d58:	4629      	mov	r1, r5
c0de0d5a:	f7ff ffcf 	bl	c0de0cfc <mcu_usb_prints>
c0de0d5e:	1967      	adds	r7, r4, r5
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de0d60:	5d60      	ldrb	r0, [r4, r5]
c0de0d62:	2825      	cmp	r0, #37	; 0x25
c0de0d64:	d1e9      	bne.n	c0de0d3a <mcu_usb_printf+0x1a>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de0d66:	1960      	adds	r0, r4, r5
c0de0d68:	1c47      	adds	r7, r0, #1
c0de0d6a:	2400      	movs	r4, #0
c0de0d6c:	2620      	movs	r6, #32
c0de0d6e:	9407      	str	r4, [sp, #28]
c0de0d70:	4622      	mov	r2, r4
c0de0d72:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de0d74:	7839      	ldrb	r1, [r7, #0]
c0de0d76:	1c7f      	adds	r7, r7, #1
c0de0d78:	2200      	movs	r2, #0
c0de0d7a:	292d      	cmp	r1, #45	; 0x2d
c0de0d7c:	d0f9      	beq.n	c0de0d72 <mcu_usb_printf+0x52>
c0de0d7e:	460a      	mov	r2, r1
c0de0d80:	3a30      	subs	r2, #48	; 0x30
c0de0d82:	2a0a      	cmp	r2, #10
c0de0d84:	d316      	bcc.n	c0de0db4 <mcu_usb_printf+0x94>
c0de0d86:	2925      	cmp	r1, #37	; 0x25
c0de0d88:	d044      	beq.n	c0de0e14 <mcu_usb_printf+0xf4>
c0de0d8a:	292a      	cmp	r1, #42	; 0x2a
c0de0d8c:	9704      	str	r7, [sp, #16]
c0de0d8e:	d01e      	beq.n	c0de0dce <mcu_usb_printf+0xae>
c0de0d90:	292e      	cmp	r1, #46	; 0x2e
c0de0d92:	d127      	bne.n	c0de0de4 <mcu_usb_printf+0xc4>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de0d94:	7838      	ldrb	r0, [r7, #0]
c0de0d96:	282a      	cmp	r0, #42	; 0x2a
c0de0d98:	d17d      	bne.n	c0de0e96 <mcu_usb_printf+0x176>
c0de0d9a:	9804      	ldr	r0, [sp, #16]
c0de0d9c:	7840      	ldrb	r0, [r0, #1]
c0de0d9e:	2848      	cmp	r0, #72	; 0x48
c0de0da0:	d003      	beq.n	c0de0daa <mcu_usb_printf+0x8a>
c0de0da2:	2873      	cmp	r0, #115	; 0x73
c0de0da4:	d001      	beq.n	c0de0daa <mcu_usb_printf+0x8a>
c0de0da6:	2868      	cmp	r0, #104	; 0x68
c0de0da8:	d175      	bne.n	c0de0e96 <mcu_usb_printf+0x176>
c0de0daa:	9f04      	ldr	r7, [sp, #16]
c0de0dac:	1c7f      	adds	r7, r7, #1
c0de0dae:	2201      	movs	r2, #1

                    // skip '*' char
                    format++;

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0db0:	9808      	ldr	r0, [sp, #32]
c0de0db2:	e012      	b.n	c0de0dda <mcu_usb_printf+0xba>
c0de0db4:	2230      	movs	r2, #48	; 0x30
                    if((format[-1] == '0') && (ulCount == 0))
c0de0db6:	460b      	mov	r3, r1
c0de0db8:	4053      	eors	r3, r2
c0de0dba:	4323      	orrs	r3, r4
c0de0dbc:	d000      	beq.n	c0de0dc0 <mcu_usb_printf+0xa0>
c0de0dbe:	4632      	mov	r2, r6
c0de0dc0:	230a      	movs	r3, #10
                    ulCount *= 10;
c0de0dc2:	4363      	muls	r3, r4
                    ulCount += format[-1] - '0';
c0de0dc4:	185c      	adds	r4, r3, r1
c0de0dc6:	3c30      	subs	r4, #48	; 0x30
c0de0dc8:	4616      	mov	r6, r2
c0de0dca:	4602      	mov	r2, r0
c0de0dcc:	e7d1      	b.n	c0de0d72 <mcu_usb_printf+0x52>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de0dce:	7838      	ldrb	r0, [r7, #0]
c0de0dd0:	2873      	cmp	r0, #115	; 0x73
c0de0dd2:	d160      	bne.n	c0de0e96 <mcu_usb_printf+0x176>
c0de0dd4:	2202      	movs	r2, #2

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0dd6:	9808      	ldr	r0, [sp, #32]
c0de0dd8:	9f04      	ldr	r7, [sp, #16]
c0de0dda:	1d01      	adds	r1, r0, #4
c0de0ddc:	9108      	str	r1, [sp, #32]
c0de0dde:	6800      	ldr	r0, [r0, #0]
            switch(*format++)
c0de0de0:	9007      	str	r0, [sp, #28]
c0de0de2:	e7c6      	b.n	c0de0d72 <mcu_usb_printf+0x52>
c0de0de4:	2948      	cmp	r1, #72	; 0x48
c0de0de6:	d017      	beq.n	c0de0e18 <mcu_usb_printf+0xf8>
c0de0de8:	2958      	cmp	r1, #88	; 0x58
c0de0dea:	d01a      	beq.n	c0de0e22 <mcu_usb_printf+0x102>
c0de0dec:	2963      	cmp	r1, #99	; 0x63
c0de0dee:	d025      	beq.n	c0de0e3c <mcu_usb_printf+0x11c>
c0de0df0:	2964      	cmp	r1, #100	; 0x64
c0de0df2:	d02d      	beq.n	c0de0e50 <mcu_usb_printf+0x130>
c0de0df4:	4a83      	ldr	r2, [pc, #524]	; (c0de1004 <mcu_usb_printf+0x2e4>)
c0de0df6:	447a      	add	r2, pc
c0de0df8:	9206      	str	r2, [sp, #24]
c0de0dfa:	2968      	cmp	r1, #104	; 0x68
c0de0dfc:	d037      	beq.n	c0de0e6e <mcu_usb_printf+0x14e>
c0de0dfe:	2970      	cmp	r1, #112	; 0x70
c0de0e00:	d005      	beq.n	c0de0e0e <mcu_usb_printf+0xee>
c0de0e02:	2973      	cmp	r1, #115	; 0x73
c0de0e04:	d036      	beq.n	c0de0e74 <mcu_usb_printf+0x154>
c0de0e06:	2975      	cmp	r1, #117	; 0x75
c0de0e08:	d049      	beq.n	c0de0e9e <mcu_usb_printf+0x17e>
c0de0e0a:	2978      	cmp	r1, #120	; 0x78
c0de0e0c:	d143      	bne.n	c0de0e96 <mcu_usb_printf+0x176>
c0de0e0e:	9601      	str	r6, [sp, #4]
c0de0e10:	2000      	movs	r0, #0
c0de0e12:	e008      	b.n	c0de0e26 <mcu_usb_printf+0x106>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de0e14:	1e78      	subs	r0, r7, #1
c0de0e16:	e017      	b.n	c0de0e48 <mcu_usb_printf+0x128>
c0de0e18:	9405      	str	r4, [sp, #20]
c0de0e1a:	497b      	ldr	r1, [pc, #492]	; (c0de1008 <mcu_usb_printf+0x2e8>)
c0de0e1c:	4479      	add	r1, pc
c0de0e1e:	9106      	str	r1, [sp, #24]
c0de0e20:	e026      	b.n	c0de0e70 <mcu_usb_printf+0x150>
c0de0e22:	9601      	str	r6, [sp, #4]
c0de0e24:	2001      	movs	r0, #1
c0de0e26:	9000      	str	r0, [sp, #0]
c0de0e28:	9f03      	ldr	r7, [sp, #12]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0e2a:	9808      	ldr	r0, [sp, #32]
c0de0e2c:	1d01      	adds	r1, r0, #4
c0de0e2e:	9108      	str	r1, [sp, #32]
c0de0e30:	6800      	ldr	r0, [r0, #0]
c0de0e32:	9005      	str	r0, [sp, #20]
c0de0e34:	900d      	str	r0, [sp, #52]	; 0x34
c0de0e36:	2010      	movs	r0, #16
c0de0e38:	9006      	str	r0, [sp, #24]
c0de0e3a:	e03c      	b.n	c0de0eb6 <mcu_usb_printf+0x196>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0e3c:	9808      	ldr	r0, [sp, #32]
c0de0e3e:	1d01      	adds	r1, r0, #4
c0de0e40:	9108      	str	r1, [sp, #32]
c0de0e42:	6800      	ldr	r0, [r0, #0]
c0de0e44:	900d      	str	r0, [sp, #52]	; 0x34
c0de0e46:	a80d      	add	r0, sp, #52	; 0x34
c0de0e48:	2101      	movs	r1, #1
c0de0e4a:	f7ff ff57 	bl	c0de0cfc <mcu_usb_prints>
c0de0e4e:	e774      	b.n	c0de0d3a <mcu_usb_printf+0x1a>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0e50:	9808      	ldr	r0, [sp, #32]
c0de0e52:	1d01      	adds	r1, r0, #4
c0de0e54:	9108      	str	r1, [sp, #32]
c0de0e56:	6800      	ldr	r0, [r0, #0]
c0de0e58:	900d      	str	r0, [sp, #52]	; 0x34
c0de0e5a:	210a      	movs	r1, #10
                    if((long)ulValue < 0)
c0de0e5c:	2800      	cmp	r0, #0
c0de0e5e:	9601      	str	r6, [sp, #4]
c0de0e60:	9106      	str	r1, [sp, #24]
c0de0e62:	d500      	bpl.n	c0de0e66 <mcu_usb_printf+0x146>
c0de0e64:	e0b7      	b.n	c0de0fd6 <mcu_usb_printf+0x2b6>
c0de0e66:	9005      	str	r0, [sp, #20]
c0de0e68:	2000      	movs	r0, #0
c0de0e6a:	9000      	str	r0, [sp, #0]
c0de0e6c:	e022      	b.n	c0de0eb4 <mcu_usb_printf+0x194>
c0de0e6e:	9405      	str	r4, [sp, #20]
c0de0e70:	9903      	ldr	r1, [sp, #12]
c0de0e72:	e001      	b.n	c0de0e78 <mcu_usb_printf+0x158>
c0de0e74:	9405      	str	r4, [sp, #20]
c0de0e76:	2100      	movs	r1, #0
                    pcStr = va_arg(vaArgP, char *);
c0de0e78:	9a08      	ldr	r2, [sp, #32]
c0de0e7a:	1d13      	adds	r3, r2, #4
c0de0e7c:	9308      	str	r3, [sp, #32]
                    switch(cStrlenSet) {
c0de0e7e:	b2c0      	uxtb	r0, r0
                    pcStr = va_arg(vaArgP, char *);
c0de0e80:	6817      	ldr	r7, [r2, #0]
                    switch(cStrlenSet) {
c0de0e82:	2800      	cmp	r0, #0
c0de0e84:	d074      	beq.n	c0de0f70 <mcu_usb_printf+0x250>
c0de0e86:	2801      	cmp	r0, #1
c0de0e88:	d079      	beq.n	c0de0f7e <mcu_usb_printf+0x25e>
c0de0e8a:	2802      	cmp	r0, #2
c0de0e8c:	d178      	bne.n	c0de0f80 <mcu_usb_printf+0x260>
                        if (pcStr[0] == '\0') {
c0de0e8e:	7838      	ldrb	r0, [r7, #0]
c0de0e90:	2800      	cmp	r0, #0
c0de0e92:	d100      	bne.n	c0de0e96 <mcu_usb_printf+0x176>
c0de0e94:	e0a6      	b.n	c0de0fe4 <mcu_usb_printf+0x2c4>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de0e96:	4861      	ldr	r0, [pc, #388]	; (c0de101c <mcu_usb_printf+0x2fc>)
c0de0e98:	4478      	add	r0, pc
c0de0e9a:	2105      	movs	r1, #5
c0de0e9c:	e064      	b.n	c0de0f68 <mcu_usb_printf+0x248>
c0de0e9e:	9601      	str	r6, [sp, #4]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0ea0:	9808      	ldr	r0, [sp, #32]
c0de0ea2:	1d01      	adds	r1, r0, #4
c0de0ea4:	9108      	str	r1, [sp, #32]
c0de0ea6:	6800      	ldr	r0, [r0, #0]
c0de0ea8:	9005      	str	r0, [sp, #20]
c0de0eaa:	900d      	str	r0, [sp, #52]	; 0x34
c0de0eac:	2000      	movs	r0, #0
c0de0eae:	9000      	str	r0, [sp, #0]
c0de0eb0:	200a      	movs	r0, #10
c0de0eb2:	9006      	str	r0, [sp, #24]
c0de0eb4:	9f03      	ldr	r7, [sp, #12]
c0de0eb6:	4639      	mov	r1, r7
c0de0eb8:	4856      	ldr	r0, [pc, #344]	; (c0de1014 <mcu_usb_printf+0x2f4>)
c0de0eba:	4478      	add	r0, pc
                    for(ulIdx = 1;
c0de0ebc:	9007      	str	r0, [sp, #28]
c0de0ebe:	9102      	str	r1, [sp, #8]
c0de0ec0:	19c8      	adds	r0, r1, r7
c0de0ec2:	4038      	ands	r0, r7
c0de0ec4:	1a26      	subs	r6, r4, r0
c0de0ec6:	1e75      	subs	r5, r6, #1
c0de0ec8:	2400      	movs	r4, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de0eca:	9806      	ldr	r0, [sp, #24]
c0de0ecc:	4621      	mov	r1, r4
c0de0ece:	463a      	mov	r2, r7
c0de0ed0:	4623      	mov	r3, r4
c0de0ed2:	f000 f97f 	bl	c0de11d4 <__aeabi_lmul>
c0de0ed6:	1e4a      	subs	r2, r1, #1
c0de0ed8:	4191      	sbcs	r1, r2
c0de0eda:	9a05      	ldr	r2, [sp, #20]
c0de0edc:	4290      	cmp	r0, r2
c0de0ede:	d805      	bhi.n	c0de0eec <mcu_usb_printf+0x1cc>
                    for(ulIdx = 1;
c0de0ee0:	2900      	cmp	r1, #0
c0de0ee2:	d103      	bne.n	c0de0eec <mcu_usb_printf+0x1cc>
c0de0ee4:	1e6d      	subs	r5, r5, #1
c0de0ee6:	1e76      	subs	r6, r6, #1
c0de0ee8:	4607      	mov	r7, r0
c0de0eea:	e7ed      	b.n	c0de0ec8 <mcu_usb_printf+0x1a8>
                    if(ulNeg && (cFill == '0'))
c0de0eec:	9802      	ldr	r0, [sp, #8]
c0de0eee:	2800      	cmp	r0, #0
c0de0ef0:	9803      	ldr	r0, [sp, #12]
c0de0ef2:	9a01      	ldr	r2, [sp, #4]
c0de0ef4:	d109      	bne.n	c0de0f0a <mcu_usb_printf+0x1ea>
c0de0ef6:	b2d1      	uxtb	r1, r2
c0de0ef8:	2000      	movs	r0, #0
c0de0efa:	2930      	cmp	r1, #48	; 0x30
c0de0efc:	4604      	mov	r4, r0
c0de0efe:	d104      	bne.n	c0de0f0a <mcu_usb_printf+0x1ea>
c0de0f00:	a809      	add	r0, sp, #36	; 0x24
c0de0f02:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0f04:	7001      	strb	r1, [r0, #0]
c0de0f06:	2401      	movs	r4, #1
c0de0f08:	9803      	ldr	r0, [sp, #12]
                    if((ulCount > 1) && (ulCount < 16))
c0de0f0a:	1eb1      	subs	r1, r6, #2
c0de0f0c:	290d      	cmp	r1, #13
c0de0f0e:	d807      	bhi.n	c0de0f20 <mcu_usb_printf+0x200>
c0de0f10:	9e06      	ldr	r6, [sp, #24]
                        for(ulCount--; ulCount; ulCount--)
c0de0f12:	2d00      	cmp	r5, #0
c0de0f14:	d005      	beq.n	c0de0f22 <mcu_usb_printf+0x202>
c0de0f16:	a909      	add	r1, sp, #36	; 0x24
                            pcBuf[ulPos++] = cFill;
c0de0f18:	550a      	strb	r2, [r1, r4]
                        for(ulCount--; ulCount; ulCount--)
c0de0f1a:	1e6d      	subs	r5, r5, #1
                            pcBuf[ulPos++] = cFill;
c0de0f1c:	1c64      	adds	r4, r4, #1
c0de0f1e:	e7f8      	b.n	c0de0f12 <mcu_usb_printf+0x1f2>
c0de0f20:	9e06      	ldr	r6, [sp, #24]
                    if(ulNeg)
c0de0f22:	2800      	cmp	r0, #0
c0de0f24:	9d05      	ldr	r5, [sp, #20]
c0de0f26:	d103      	bne.n	c0de0f30 <mcu_usb_printf+0x210>
c0de0f28:	a809      	add	r0, sp, #36	; 0x24
c0de0f2a:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0f2c:	5501      	strb	r1, [r0, r4]
c0de0f2e:	1c64      	adds	r4, r4, #1
c0de0f30:	9800      	ldr	r0, [sp, #0]
c0de0f32:	2800      	cmp	r0, #0
c0de0f34:	d114      	bne.n	c0de0f60 <mcu_usb_printf+0x240>
c0de0f36:	4838      	ldr	r0, [pc, #224]	; (c0de1018 <mcu_usb_printf+0x2f8>)
c0de0f38:	4478      	add	r0, pc
c0de0f3a:	9007      	str	r0, [sp, #28]
c0de0f3c:	e010      	b.n	c0de0f60 <mcu_usb_printf+0x240>
c0de0f3e:	4628      	mov	r0, r5
c0de0f40:	4639      	mov	r1, r7
c0de0f42:	f000 f8bb 	bl	c0de10bc <__udivsi3>
c0de0f46:	4631      	mov	r1, r6
c0de0f48:	f000 f93e 	bl	c0de11c8 <__aeabi_uidivmod>
c0de0f4c:	9807      	ldr	r0, [sp, #28]
c0de0f4e:	5c40      	ldrb	r0, [r0, r1]
c0de0f50:	a909      	add	r1, sp, #36	; 0x24
                          pcBuf[ulPos++] = g_pcHex[(ulValue / ulIdx) % ulBase];
c0de0f52:	5508      	strb	r0, [r1, r4]
                    for(; ulIdx; ulIdx /= ulBase)
c0de0f54:	4638      	mov	r0, r7
c0de0f56:	4631      	mov	r1, r6
c0de0f58:	f000 f8b0 	bl	c0de10bc <__udivsi3>
c0de0f5c:	4607      	mov	r7, r0
c0de0f5e:	1c64      	adds	r4, r4, #1
c0de0f60:	2f00      	cmp	r7, #0
c0de0f62:	d1ec      	bne.n	c0de0f3e <mcu_usb_printf+0x21e>
c0de0f64:	a809      	add	r0, sp, #36	; 0x24
                    mcu_usb_prints(pcBuf, ulPos);
c0de0f66:	4621      	mov	r1, r4
c0de0f68:	f7ff fec8 	bl	c0de0cfc <mcu_usb_prints>
c0de0f6c:	9f04      	ldr	r7, [sp, #16]
c0de0f6e:	e6e4      	b.n	c0de0d3a <mcu_usb_printf+0x1a>
c0de0f70:	2000      	movs	r0, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de0f72:	5c3a      	ldrb	r2, [r7, r0]
c0de0f74:	1c40      	adds	r0, r0, #1
c0de0f76:	2a00      	cmp	r2, #0
c0de0f78:	d1fb      	bne.n	c0de0f72 <mcu_usb_printf+0x252>
                    switch(ulBase) {
c0de0f7a:	1e45      	subs	r5, r0, #1
c0de0f7c:	e000      	b.n	c0de0f80 <mcu_usb_printf+0x260>
c0de0f7e:	9d07      	ldr	r5, [sp, #28]
c0de0f80:	2900      	cmp	r1, #0
c0de0f82:	d014      	beq.n	c0de0fae <mcu_usb_printf+0x28e>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0f84:	2d00      	cmp	r5, #0
c0de0f86:	d0f1      	beq.n	c0de0f6c <mcu_usb_printf+0x24c>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de0f88:	783e      	ldrb	r6, [r7, #0]
c0de0f8a:	0930      	lsrs	r0, r6, #4
c0de0f8c:	9c06      	ldr	r4, [sp, #24]
c0de0f8e:	1820      	adds	r0, r4, r0
c0de0f90:	9507      	str	r5, [sp, #28]
c0de0f92:	2501      	movs	r5, #1
c0de0f94:	4629      	mov	r1, r5
c0de0f96:	f7ff feb1 	bl	c0de0cfc <mcu_usb_prints>
c0de0f9a:	200f      	movs	r0, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de0f9c:	4030      	ands	r0, r6
c0de0f9e:	1820      	adds	r0, r4, r0
c0de0fa0:	4629      	mov	r1, r5
c0de0fa2:	9d07      	ldr	r5, [sp, #28]
c0de0fa4:	f7ff feaa 	bl	c0de0cfc <mcu_usb_prints>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0fa8:	1c7f      	adds	r7, r7, #1
c0de0faa:	1e6d      	subs	r5, r5, #1
c0de0fac:	e7ea      	b.n	c0de0f84 <mcu_usb_printf+0x264>
                        mcu_usb_prints(pcStr, ulIdx);
c0de0fae:	4638      	mov	r0, r7
c0de0fb0:	4629      	mov	r1, r5
c0de0fb2:	f7ff fea3 	bl	c0de0cfc <mcu_usb_prints>
c0de0fb6:	9f04      	ldr	r7, [sp, #16]
c0de0fb8:	9805      	ldr	r0, [sp, #20]
                    if(ulCount > ulIdx)
c0de0fba:	42a8      	cmp	r0, r5
c0de0fbc:	d800      	bhi.n	c0de0fc0 <mcu_usb_printf+0x2a0>
c0de0fbe:	e6bc      	b.n	c0de0d3a <mcu_usb_printf+0x1a>
                        while(ulCount--)
c0de0fc0:	1a2c      	subs	r4, r5, r0
c0de0fc2:	2c00      	cmp	r4, #0
c0de0fc4:	d100      	bne.n	c0de0fc8 <mcu_usb_printf+0x2a8>
c0de0fc6:	e6b8      	b.n	c0de0d3a <mcu_usb_printf+0x1a>
                            mcu_usb_prints(" ", 1);
c0de0fc8:	4811      	ldr	r0, [pc, #68]	; (c0de1010 <mcu_usb_printf+0x2f0>)
c0de0fca:	4478      	add	r0, pc
c0de0fcc:	2101      	movs	r1, #1
c0de0fce:	f7ff fe95 	bl	c0de0cfc <mcu_usb_prints>
                        while(ulCount--)
c0de0fd2:	1c64      	adds	r4, r4, #1
c0de0fd4:	e7f5      	b.n	c0de0fc2 <mcu_usb_printf+0x2a2>
                        ulValue = -(long)ulValue;
c0de0fd6:	4240      	negs	r0, r0
c0de0fd8:	9005      	str	r0, [sp, #20]
c0de0fda:	900d      	str	r0, [sp, #52]	; 0x34
c0de0fdc:	2100      	movs	r1, #0
            ulCap = 0;
c0de0fde:	9100      	str	r1, [sp, #0]
c0de0fe0:	9f03      	ldr	r7, [sp, #12]
c0de0fe2:	e769      	b.n	c0de0eb8 <mcu_usb_printf+0x198>
                          do {
c0de0fe4:	9807      	ldr	r0, [sp, #28]
c0de0fe6:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de0fe8:	4808      	ldr	r0, [pc, #32]	; (c0de100c <mcu_usb_printf+0x2ec>)
c0de0fea:	4478      	add	r0, pc
c0de0fec:	2101      	movs	r1, #1
c0de0fee:	f7ff fe85 	bl	c0de0cfc <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de0ff2:	1e64      	subs	r4, r4, #1
c0de0ff4:	d1f8      	bne.n	c0de0fe8 <mcu_usb_printf+0x2c8>
c0de0ff6:	e7de      	b.n	c0de0fb6 <mcu_usb_printf+0x296>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de0ff8:	b00e      	add	sp, #56	; 0x38
c0de0ffa:	bcf0      	pop	{r4, r5, r6, r7}
c0de0ffc:	bc01      	pop	{r0}
c0de0ffe:	b003      	add	sp, #12
c0de1000:	4700      	bx	r0
c0de1002:	46c0      	nop			; (mov r8, r8)
c0de1004:	00000aea 	.word	0x00000aea
c0de1008:	00000ad4 	.word	0x00000ad4
c0de100c:	000005d8 	.word	0x000005d8
c0de1010:	000005f8 	.word	0x000005f8
c0de1014:	00000a36 	.word	0x00000a36
c0de1018:	000009a8 	.word	0x000009a8
c0de101c:	00000855 	.word	0x00000855

c0de1020 <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de1020:	df01      	svc	1
    cmp r1, #0
c0de1022:	2900      	cmp	r1, #0
    bne exception
c0de1024:	d100      	bne.n	c0de1028 <exception>
    bx lr
c0de1026:	4770      	bx	lr

c0de1028 <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de1028:	4608      	mov	r0, r1
    bl os_longjmp
c0de102a:	f7ff fe59 	bl	c0de0ce0 <os_longjmp>

c0de102e <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de102e:	b5e0      	push	{r5, r6, r7, lr}
c0de1030:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de1032:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de1034:	9000      	str	r0, [sp, #0]
c0de1036:	2001      	movs	r0, #1
c0de1038:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de103a:	f7ff fff1 	bl	c0de1020 <SVC_Call>
c0de103e:	bd8c      	pop	{r2, r3, r7, pc}

c0de1040 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de1040:	b5e0      	push	{r5, r6, r7, lr}
c0de1042:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de1044:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de1046:	9000      	str	r0, [sp, #0]
c0de1048:	4802      	ldr	r0, [pc, #8]	; (c0de1054 <os_lib_call+0x14>)
c0de104a:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de104c:	f7ff ffe8 	bl	c0de1020 <SVC_Call>
  return;
}
c0de1050:	bd8c      	pop	{r2, r3, r7, pc}
c0de1052:	46c0      	nop			; (mov r8, r8)
c0de1054:	01000067 	.word	0x01000067

c0de1058 <os_lib_end>:

void __attribute__((noreturn)) os_lib_end ( void ) {
c0de1058:	b082      	sub	sp, #8
c0de105a:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de105c:	9001      	str	r0, [sp, #4]
c0de105e:	2068      	movs	r0, #104	; 0x68
c0de1060:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de1062:	f7ff ffdd 	bl	c0de1020 <SVC_Call>

  // The os_lib_end syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de1066:	deff      	udf	#255	; 0xff

c0de1068 <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de1068:	b082      	sub	sp, #8
c0de106a:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de106c:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de106e:	9000      	str	r0, [sp, #0]
c0de1070:	4802      	ldr	r0, [pc, #8]	; (c0de107c <os_sched_exit+0x14>)
c0de1072:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de1074:	f7ff ffd4 	bl	c0de1020 <SVC_Call>

  // The os_sched_exit syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de1078:	deff      	udf	#255	; 0xff
c0de107a:	46c0      	nop			; (mov r8, r8)
c0de107c:	0100009a 	.word	0x0100009a

c0de1080 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de1080:	b5e0      	push	{r5, r6, r7, lr}
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de1082:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de1084:	9000      	str	r0, [sp, #0]
c0de1086:	4802      	ldr	r0, [pc, #8]	; (c0de1090 <io_seph_send+0x10>)
c0de1088:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de108a:	f7ff ffc9 	bl	c0de1020 <SVC_Call>
  return;
}
c0de108e:	bd8c      	pop	{r2, r3, r7, pc}
c0de1090:	02000083 	.word	0x02000083

c0de1094 <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de1094:	b5e0      	push	{r5, r6, r7, lr}
c0de1096:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de1098:	9001      	str	r0, [sp, #4]
c0de109a:	2087      	movs	r0, #135	; 0x87
c0de109c:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de109e:	f7ff ffbf 	bl	c0de1020 <SVC_Call>
c0de10a2:	bd8c      	pop	{r2, r3, r7, pc}

c0de10a4 <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de10a4:	b5e0      	push	{r5, r6, r7, lr}
c0de10a6:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de10a8:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de10aa:	9000      	str	r0, [sp, #0]
c0de10ac:	4802      	ldr	r0, [pc, #8]	; (c0de10b8 <try_context_set+0x14>)
c0de10ae:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de10b0:	f7ff ffb6 	bl	c0de1020 <SVC_Call>
c0de10b4:	bd8c      	pop	{r2, r3, r7, pc}
c0de10b6:	46c0      	nop			; (mov r8, r8)
c0de10b8:	0100010b 	.word	0x0100010b

c0de10bc <__udivsi3>:
c0de10bc:	2200      	movs	r2, #0
c0de10be:	0843      	lsrs	r3, r0, #1
c0de10c0:	428b      	cmp	r3, r1
c0de10c2:	d374      	bcc.n	c0de11ae <__udivsi3+0xf2>
c0de10c4:	0903      	lsrs	r3, r0, #4
c0de10c6:	428b      	cmp	r3, r1
c0de10c8:	d35f      	bcc.n	c0de118a <__udivsi3+0xce>
c0de10ca:	0a03      	lsrs	r3, r0, #8
c0de10cc:	428b      	cmp	r3, r1
c0de10ce:	d344      	bcc.n	c0de115a <__udivsi3+0x9e>
c0de10d0:	0b03      	lsrs	r3, r0, #12
c0de10d2:	428b      	cmp	r3, r1
c0de10d4:	d328      	bcc.n	c0de1128 <__udivsi3+0x6c>
c0de10d6:	0c03      	lsrs	r3, r0, #16
c0de10d8:	428b      	cmp	r3, r1
c0de10da:	d30d      	bcc.n	c0de10f8 <__udivsi3+0x3c>
c0de10dc:	22ff      	movs	r2, #255	; 0xff
c0de10de:	0209      	lsls	r1, r1, #8
c0de10e0:	ba12      	rev	r2, r2
c0de10e2:	0c03      	lsrs	r3, r0, #16
c0de10e4:	428b      	cmp	r3, r1
c0de10e6:	d302      	bcc.n	c0de10ee <__udivsi3+0x32>
c0de10e8:	1212      	asrs	r2, r2, #8
c0de10ea:	0209      	lsls	r1, r1, #8
c0de10ec:	d065      	beq.n	c0de11ba <__udivsi3+0xfe>
c0de10ee:	0b03      	lsrs	r3, r0, #12
c0de10f0:	428b      	cmp	r3, r1
c0de10f2:	d319      	bcc.n	c0de1128 <__udivsi3+0x6c>
c0de10f4:	e000      	b.n	c0de10f8 <__udivsi3+0x3c>
c0de10f6:	0a09      	lsrs	r1, r1, #8
c0de10f8:	0bc3      	lsrs	r3, r0, #15
c0de10fa:	428b      	cmp	r3, r1
c0de10fc:	d301      	bcc.n	c0de1102 <__udivsi3+0x46>
c0de10fe:	03cb      	lsls	r3, r1, #15
c0de1100:	1ac0      	subs	r0, r0, r3
c0de1102:	4152      	adcs	r2, r2
c0de1104:	0b83      	lsrs	r3, r0, #14
c0de1106:	428b      	cmp	r3, r1
c0de1108:	d301      	bcc.n	c0de110e <__udivsi3+0x52>
c0de110a:	038b      	lsls	r3, r1, #14
c0de110c:	1ac0      	subs	r0, r0, r3
c0de110e:	4152      	adcs	r2, r2
c0de1110:	0b43      	lsrs	r3, r0, #13
c0de1112:	428b      	cmp	r3, r1
c0de1114:	d301      	bcc.n	c0de111a <__udivsi3+0x5e>
c0de1116:	034b      	lsls	r3, r1, #13
c0de1118:	1ac0      	subs	r0, r0, r3
c0de111a:	4152      	adcs	r2, r2
c0de111c:	0b03      	lsrs	r3, r0, #12
c0de111e:	428b      	cmp	r3, r1
c0de1120:	d301      	bcc.n	c0de1126 <__udivsi3+0x6a>
c0de1122:	030b      	lsls	r3, r1, #12
c0de1124:	1ac0      	subs	r0, r0, r3
c0de1126:	4152      	adcs	r2, r2
c0de1128:	0ac3      	lsrs	r3, r0, #11
c0de112a:	428b      	cmp	r3, r1
c0de112c:	d301      	bcc.n	c0de1132 <__udivsi3+0x76>
c0de112e:	02cb      	lsls	r3, r1, #11
c0de1130:	1ac0      	subs	r0, r0, r3
c0de1132:	4152      	adcs	r2, r2
c0de1134:	0a83      	lsrs	r3, r0, #10
c0de1136:	428b      	cmp	r3, r1
c0de1138:	d301      	bcc.n	c0de113e <__udivsi3+0x82>
c0de113a:	028b      	lsls	r3, r1, #10
c0de113c:	1ac0      	subs	r0, r0, r3
c0de113e:	4152      	adcs	r2, r2
c0de1140:	0a43      	lsrs	r3, r0, #9
c0de1142:	428b      	cmp	r3, r1
c0de1144:	d301      	bcc.n	c0de114a <__udivsi3+0x8e>
c0de1146:	024b      	lsls	r3, r1, #9
c0de1148:	1ac0      	subs	r0, r0, r3
c0de114a:	4152      	adcs	r2, r2
c0de114c:	0a03      	lsrs	r3, r0, #8
c0de114e:	428b      	cmp	r3, r1
c0de1150:	d301      	bcc.n	c0de1156 <__udivsi3+0x9a>
c0de1152:	020b      	lsls	r3, r1, #8
c0de1154:	1ac0      	subs	r0, r0, r3
c0de1156:	4152      	adcs	r2, r2
c0de1158:	d2cd      	bcs.n	c0de10f6 <__udivsi3+0x3a>
c0de115a:	09c3      	lsrs	r3, r0, #7
c0de115c:	428b      	cmp	r3, r1
c0de115e:	d301      	bcc.n	c0de1164 <__udivsi3+0xa8>
c0de1160:	01cb      	lsls	r3, r1, #7
c0de1162:	1ac0      	subs	r0, r0, r3
c0de1164:	4152      	adcs	r2, r2
c0de1166:	0983      	lsrs	r3, r0, #6
c0de1168:	428b      	cmp	r3, r1
c0de116a:	d301      	bcc.n	c0de1170 <__udivsi3+0xb4>
c0de116c:	018b      	lsls	r3, r1, #6
c0de116e:	1ac0      	subs	r0, r0, r3
c0de1170:	4152      	adcs	r2, r2
c0de1172:	0943      	lsrs	r3, r0, #5
c0de1174:	428b      	cmp	r3, r1
c0de1176:	d301      	bcc.n	c0de117c <__udivsi3+0xc0>
c0de1178:	014b      	lsls	r3, r1, #5
c0de117a:	1ac0      	subs	r0, r0, r3
c0de117c:	4152      	adcs	r2, r2
c0de117e:	0903      	lsrs	r3, r0, #4
c0de1180:	428b      	cmp	r3, r1
c0de1182:	d301      	bcc.n	c0de1188 <__udivsi3+0xcc>
c0de1184:	010b      	lsls	r3, r1, #4
c0de1186:	1ac0      	subs	r0, r0, r3
c0de1188:	4152      	adcs	r2, r2
c0de118a:	08c3      	lsrs	r3, r0, #3
c0de118c:	428b      	cmp	r3, r1
c0de118e:	d301      	bcc.n	c0de1194 <__udivsi3+0xd8>
c0de1190:	00cb      	lsls	r3, r1, #3
c0de1192:	1ac0      	subs	r0, r0, r3
c0de1194:	4152      	adcs	r2, r2
c0de1196:	0883      	lsrs	r3, r0, #2
c0de1198:	428b      	cmp	r3, r1
c0de119a:	d301      	bcc.n	c0de11a0 <__udivsi3+0xe4>
c0de119c:	008b      	lsls	r3, r1, #2
c0de119e:	1ac0      	subs	r0, r0, r3
c0de11a0:	4152      	adcs	r2, r2
c0de11a2:	0843      	lsrs	r3, r0, #1
c0de11a4:	428b      	cmp	r3, r1
c0de11a6:	d301      	bcc.n	c0de11ac <__udivsi3+0xf0>
c0de11a8:	004b      	lsls	r3, r1, #1
c0de11aa:	1ac0      	subs	r0, r0, r3
c0de11ac:	4152      	adcs	r2, r2
c0de11ae:	1a41      	subs	r1, r0, r1
c0de11b0:	d200      	bcs.n	c0de11b4 <__udivsi3+0xf8>
c0de11b2:	4601      	mov	r1, r0
c0de11b4:	4152      	adcs	r2, r2
c0de11b6:	4610      	mov	r0, r2
c0de11b8:	4770      	bx	lr
c0de11ba:	e7ff      	b.n	c0de11bc <__udivsi3+0x100>
c0de11bc:	b501      	push	{r0, lr}
c0de11be:	2000      	movs	r0, #0
c0de11c0:	f000 f806 	bl	c0de11d0 <__aeabi_idiv0>
c0de11c4:	bd02      	pop	{r1, pc}
c0de11c6:	46c0      	nop			; (mov r8, r8)

c0de11c8 <__aeabi_uidivmod>:
c0de11c8:	2900      	cmp	r1, #0
c0de11ca:	d0f7      	beq.n	c0de11bc <__udivsi3+0x100>
c0de11cc:	e776      	b.n	c0de10bc <__udivsi3>
c0de11ce:	4770      	bx	lr

c0de11d0 <__aeabi_idiv0>:
c0de11d0:	4770      	bx	lr
c0de11d2:	46c0      	nop			; (mov r8, r8)

c0de11d4 <__aeabi_lmul>:
c0de11d4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de11d6:	46ce      	mov	lr, r9
c0de11d8:	4647      	mov	r7, r8
c0de11da:	0415      	lsls	r5, r2, #16
c0de11dc:	0c2d      	lsrs	r5, r5, #16
c0de11de:	002e      	movs	r6, r5
c0de11e0:	b580      	push	{r7, lr}
c0de11e2:	0407      	lsls	r7, r0, #16
c0de11e4:	0c14      	lsrs	r4, r2, #16
c0de11e6:	0c3f      	lsrs	r7, r7, #16
c0de11e8:	4699      	mov	r9, r3
c0de11ea:	0c03      	lsrs	r3, r0, #16
c0de11ec:	437e      	muls	r6, r7
c0de11ee:	435d      	muls	r5, r3
c0de11f0:	4367      	muls	r7, r4
c0de11f2:	4363      	muls	r3, r4
c0de11f4:	197f      	adds	r7, r7, r5
c0de11f6:	0c34      	lsrs	r4, r6, #16
c0de11f8:	19e4      	adds	r4, r4, r7
c0de11fa:	469c      	mov	ip, r3
c0de11fc:	42a5      	cmp	r5, r4
c0de11fe:	d903      	bls.n	c0de1208 <__aeabi_lmul+0x34>
c0de1200:	2380      	movs	r3, #128	; 0x80
c0de1202:	025b      	lsls	r3, r3, #9
c0de1204:	4698      	mov	r8, r3
c0de1206:	44c4      	add	ip, r8
c0de1208:	464b      	mov	r3, r9
c0de120a:	4343      	muls	r3, r0
c0de120c:	4351      	muls	r1, r2
c0de120e:	0c25      	lsrs	r5, r4, #16
c0de1210:	0436      	lsls	r6, r6, #16
c0de1212:	4465      	add	r5, ip
c0de1214:	0c36      	lsrs	r6, r6, #16
c0de1216:	0424      	lsls	r4, r4, #16
c0de1218:	19a4      	adds	r4, r4, r6
c0de121a:	195b      	adds	r3, r3, r5
c0de121c:	1859      	adds	r1, r3, r1
c0de121e:	0020      	movs	r0, r4
c0de1220:	bc0c      	pop	{r2, r3}
c0de1222:	4690      	mov	r8, r2
c0de1224:	4699      	mov	r9, r3
c0de1226:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de1228 <__aeabi_memclr>:
c0de1228:	b510      	push	{r4, lr}
c0de122a:	2200      	movs	r2, #0
c0de122c:	f000 f80a 	bl	c0de1244 <__aeabi_memset>
c0de1230:	bd10      	pop	{r4, pc}
c0de1232:	46c0      	nop			; (mov r8, r8)

c0de1234 <__aeabi_memcpy>:
c0de1234:	b510      	push	{r4, lr}
c0de1236:	f000 f835 	bl	c0de12a4 <memcpy>
c0de123a:	bd10      	pop	{r4, pc}

c0de123c <__aeabi_memmove>:
c0de123c:	b510      	push	{r4, lr}
c0de123e:	f000 f885 	bl	c0de134c <memmove>
c0de1242:	bd10      	pop	{r4, pc}

c0de1244 <__aeabi_memset>:
c0de1244:	0013      	movs	r3, r2
c0de1246:	b510      	push	{r4, lr}
c0de1248:	000a      	movs	r2, r1
c0de124a:	0019      	movs	r1, r3
c0de124c:	f000 f8dc 	bl	c0de1408 <memset>
c0de1250:	bd10      	pop	{r4, pc}
c0de1252:	46c0      	nop			; (mov r8, r8)

c0de1254 <memcmp>:
c0de1254:	b530      	push	{r4, r5, lr}
c0de1256:	2a03      	cmp	r2, #3
c0de1258:	d90c      	bls.n	c0de1274 <memcmp+0x20>
c0de125a:	0003      	movs	r3, r0
c0de125c:	430b      	orrs	r3, r1
c0de125e:	079b      	lsls	r3, r3, #30
c0de1260:	d11c      	bne.n	c0de129c <memcmp+0x48>
c0de1262:	6803      	ldr	r3, [r0, #0]
c0de1264:	680c      	ldr	r4, [r1, #0]
c0de1266:	42a3      	cmp	r3, r4
c0de1268:	d118      	bne.n	c0de129c <memcmp+0x48>
c0de126a:	3a04      	subs	r2, #4
c0de126c:	3004      	adds	r0, #4
c0de126e:	3104      	adds	r1, #4
c0de1270:	2a03      	cmp	r2, #3
c0de1272:	d8f6      	bhi.n	c0de1262 <memcmp+0xe>
c0de1274:	1e55      	subs	r5, r2, #1
c0de1276:	2a00      	cmp	r2, #0
c0de1278:	d00e      	beq.n	c0de1298 <memcmp+0x44>
c0de127a:	7802      	ldrb	r2, [r0, #0]
c0de127c:	780c      	ldrb	r4, [r1, #0]
c0de127e:	4294      	cmp	r4, r2
c0de1280:	d10e      	bne.n	c0de12a0 <memcmp+0x4c>
c0de1282:	3501      	adds	r5, #1
c0de1284:	2301      	movs	r3, #1
c0de1286:	3901      	subs	r1, #1
c0de1288:	e004      	b.n	c0de1294 <memcmp+0x40>
c0de128a:	5cc2      	ldrb	r2, [r0, r3]
c0de128c:	3301      	adds	r3, #1
c0de128e:	5ccc      	ldrb	r4, [r1, r3]
c0de1290:	42a2      	cmp	r2, r4
c0de1292:	d105      	bne.n	c0de12a0 <memcmp+0x4c>
c0de1294:	42ab      	cmp	r3, r5
c0de1296:	d1f8      	bne.n	c0de128a <memcmp+0x36>
c0de1298:	2000      	movs	r0, #0
c0de129a:	bd30      	pop	{r4, r5, pc}
c0de129c:	1e55      	subs	r5, r2, #1
c0de129e:	e7ec      	b.n	c0de127a <memcmp+0x26>
c0de12a0:	1b10      	subs	r0, r2, r4
c0de12a2:	e7fa      	b.n	c0de129a <memcmp+0x46>

c0de12a4 <memcpy>:
c0de12a4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de12a6:	46c6      	mov	lr, r8
c0de12a8:	b500      	push	{lr}
c0de12aa:	2a0f      	cmp	r2, #15
c0de12ac:	d943      	bls.n	c0de1336 <memcpy+0x92>
c0de12ae:	000b      	movs	r3, r1
c0de12b0:	2603      	movs	r6, #3
c0de12b2:	4303      	orrs	r3, r0
c0de12b4:	401e      	ands	r6, r3
c0de12b6:	000c      	movs	r4, r1
c0de12b8:	0003      	movs	r3, r0
c0de12ba:	2e00      	cmp	r6, #0
c0de12bc:	d140      	bne.n	c0de1340 <memcpy+0x9c>
c0de12be:	0015      	movs	r5, r2
c0de12c0:	3d10      	subs	r5, #16
c0de12c2:	092d      	lsrs	r5, r5, #4
c0de12c4:	46ac      	mov	ip, r5
c0de12c6:	012d      	lsls	r5, r5, #4
c0de12c8:	46a8      	mov	r8, r5
c0de12ca:	4480      	add	r8, r0
c0de12cc:	e000      	b.n	c0de12d0 <memcpy+0x2c>
c0de12ce:	003b      	movs	r3, r7
c0de12d0:	6867      	ldr	r7, [r4, #4]
c0de12d2:	6825      	ldr	r5, [r4, #0]
c0de12d4:	605f      	str	r7, [r3, #4]
c0de12d6:	68e7      	ldr	r7, [r4, #12]
c0de12d8:	601d      	str	r5, [r3, #0]
c0de12da:	60df      	str	r7, [r3, #12]
c0de12dc:	001f      	movs	r7, r3
c0de12de:	68a5      	ldr	r5, [r4, #8]
c0de12e0:	3710      	adds	r7, #16
c0de12e2:	609d      	str	r5, [r3, #8]
c0de12e4:	3410      	adds	r4, #16
c0de12e6:	4543      	cmp	r3, r8
c0de12e8:	d1f1      	bne.n	c0de12ce <memcpy+0x2a>
c0de12ea:	4665      	mov	r5, ip
c0de12ec:	230f      	movs	r3, #15
c0de12ee:	240c      	movs	r4, #12
c0de12f0:	3501      	adds	r5, #1
c0de12f2:	012d      	lsls	r5, r5, #4
c0de12f4:	1949      	adds	r1, r1, r5
c0de12f6:	4013      	ands	r3, r2
c0de12f8:	1945      	adds	r5, r0, r5
c0de12fa:	4214      	tst	r4, r2
c0de12fc:	d023      	beq.n	c0de1346 <memcpy+0xa2>
c0de12fe:	598c      	ldr	r4, [r1, r6]
c0de1300:	51ac      	str	r4, [r5, r6]
c0de1302:	3604      	adds	r6, #4
c0de1304:	1b9c      	subs	r4, r3, r6
c0de1306:	2c03      	cmp	r4, #3
c0de1308:	d8f9      	bhi.n	c0de12fe <memcpy+0x5a>
c0de130a:	2403      	movs	r4, #3
c0de130c:	3b04      	subs	r3, #4
c0de130e:	089b      	lsrs	r3, r3, #2
c0de1310:	3301      	adds	r3, #1
c0de1312:	009b      	lsls	r3, r3, #2
c0de1314:	4022      	ands	r2, r4
c0de1316:	18ed      	adds	r5, r5, r3
c0de1318:	18c9      	adds	r1, r1, r3
c0de131a:	1e56      	subs	r6, r2, #1
c0de131c:	2a00      	cmp	r2, #0
c0de131e:	d007      	beq.n	c0de1330 <memcpy+0x8c>
c0de1320:	2300      	movs	r3, #0
c0de1322:	e000      	b.n	c0de1326 <memcpy+0x82>
c0de1324:	0023      	movs	r3, r4
c0de1326:	5cca      	ldrb	r2, [r1, r3]
c0de1328:	1c5c      	adds	r4, r3, #1
c0de132a:	54ea      	strb	r2, [r5, r3]
c0de132c:	429e      	cmp	r6, r3
c0de132e:	d1f9      	bne.n	c0de1324 <memcpy+0x80>
c0de1330:	bc04      	pop	{r2}
c0de1332:	4690      	mov	r8, r2
c0de1334:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1336:	0005      	movs	r5, r0
c0de1338:	1e56      	subs	r6, r2, #1
c0de133a:	2a00      	cmp	r2, #0
c0de133c:	d1f0      	bne.n	c0de1320 <memcpy+0x7c>
c0de133e:	e7f7      	b.n	c0de1330 <memcpy+0x8c>
c0de1340:	1e56      	subs	r6, r2, #1
c0de1342:	0005      	movs	r5, r0
c0de1344:	e7ec      	b.n	c0de1320 <memcpy+0x7c>
c0de1346:	001a      	movs	r2, r3
c0de1348:	e7f6      	b.n	c0de1338 <memcpy+0x94>
c0de134a:	46c0      	nop			; (mov r8, r8)

c0de134c <memmove>:
c0de134c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de134e:	46c6      	mov	lr, r8
c0de1350:	b500      	push	{lr}
c0de1352:	4288      	cmp	r0, r1
c0de1354:	d90c      	bls.n	c0de1370 <memmove+0x24>
c0de1356:	188b      	adds	r3, r1, r2
c0de1358:	4298      	cmp	r0, r3
c0de135a:	d209      	bcs.n	c0de1370 <memmove+0x24>
c0de135c:	1e53      	subs	r3, r2, #1
c0de135e:	2a00      	cmp	r2, #0
c0de1360:	d003      	beq.n	c0de136a <memmove+0x1e>
c0de1362:	5cca      	ldrb	r2, [r1, r3]
c0de1364:	54c2      	strb	r2, [r0, r3]
c0de1366:	3b01      	subs	r3, #1
c0de1368:	d2fb      	bcs.n	c0de1362 <memmove+0x16>
c0de136a:	bc04      	pop	{r2}
c0de136c:	4690      	mov	r8, r2
c0de136e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1370:	2a0f      	cmp	r2, #15
c0de1372:	d80c      	bhi.n	c0de138e <memmove+0x42>
c0de1374:	0005      	movs	r5, r0
c0de1376:	1e56      	subs	r6, r2, #1
c0de1378:	2a00      	cmp	r2, #0
c0de137a:	d0f6      	beq.n	c0de136a <memmove+0x1e>
c0de137c:	2300      	movs	r3, #0
c0de137e:	e000      	b.n	c0de1382 <memmove+0x36>
c0de1380:	0023      	movs	r3, r4
c0de1382:	5cca      	ldrb	r2, [r1, r3]
c0de1384:	1c5c      	adds	r4, r3, #1
c0de1386:	54ea      	strb	r2, [r5, r3]
c0de1388:	429e      	cmp	r6, r3
c0de138a:	d1f9      	bne.n	c0de1380 <memmove+0x34>
c0de138c:	e7ed      	b.n	c0de136a <memmove+0x1e>
c0de138e:	000b      	movs	r3, r1
c0de1390:	2603      	movs	r6, #3
c0de1392:	4303      	orrs	r3, r0
c0de1394:	401e      	ands	r6, r3
c0de1396:	000c      	movs	r4, r1
c0de1398:	0003      	movs	r3, r0
c0de139a:	2e00      	cmp	r6, #0
c0de139c:	d12e      	bne.n	c0de13fc <memmove+0xb0>
c0de139e:	0015      	movs	r5, r2
c0de13a0:	3d10      	subs	r5, #16
c0de13a2:	092d      	lsrs	r5, r5, #4
c0de13a4:	46ac      	mov	ip, r5
c0de13a6:	012d      	lsls	r5, r5, #4
c0de13a8:	46a8      	mov	r8, r5
c0de13aa:	4480      	add	r8, r0
c0de13ac:	e000      	b.n	c0de13b0 <memmove+0x64>
c0de13ae:	002b      	movs	r3, r5
c0de13b0:	001d      	movs	r5, r3
c0de13b2:	6827      	ldr	r7, [r4, #0]
c0de13b4:	3510      	adds	r5, #16
c0de13b6:	601f      	str	r7, [r3, #0]
c0de13b8:	6867      	ldr	r7, [r4, #4]
c0de13ba:	605f      	str	r7, [r3, #4]
c0de13bc:	68a7      	ldr	r7, [r4, #8]
c0de13be:	609f      	str	r7, [r3, #8]
c0de13c0:	68e7      	ldr	r7, [r4, #12]
c0de13c2:	3410      	adds	r4, #16
c0de13c4:	60df      	str	r7, [r3, #12]
c0de13c6:	4543      	cmp	r3, r8
c0de13c8:	d1f1      	bne.n	c0de13ae <memmove+0x62>
c0de13ca:	4665      	mov	r5, ip
c0de13cc:	230f      	movs	r3, #15
c0de13ce:	240c      	movs	r4, #12
c0de13d0:	3501      	adds	r5, #1
c0de13d2:	012d      	lsls	r5, r5, #4
c0de13d4:	1949      	adds	r1, r1, r5
c0de13d6:	4013      	ands	r3, r2
c0de13d8:	1945      	adds	r5, r0, r5
c0de13da:	4214      	tst	r4, r2
c0de13dc:	d011      	beq.n	c0de1402 <memmove+0xb6>
c0de13de:	598c      	ldr	r4, [r1, r6]
c0de13e0:	51ac      	str	r4, [r5, r6]
c0de13e2:	3604      	adds	r6, #4
c0de13e4:	1b9c      	subs	r4, r3, r6
c0de13e6:	2c03      	cmp	r4, #3
c0de13e8:	d8f9      	bhi.n	c0de13de <memmove+0x92>
c0de13ea:	2403      	movs	r4, #3
c0de13ec:	3b04      	subs	r3, #4
c0de13ee:	089b      	lsrs	r3, r3, #2
c0de13f0:	3301      	adds	r3, #1
c0de13f2:	009b      	lsls	r3, r3, #2
c0de13f4:	18ed      	adds	r5, r5, r3
c0de13f6:	18c9      	adds	r1, r1, r3
c0de13f8:	4022      	ands	r2, r4
c0de13fa:	e7bc      	b.n	c0de1376 <memmove+0x2a>
c0de13fc:	1e56      	subs	r6, r2, #1
c0de13fe:	0005      	movs	r5, r0
c0de1400:	e7bc      	b.n	c0de137c <memmove+0x30>
c0de1402:	001a      	movs	r2, r3
c0de1404:	e7b7      	b.n	c0de1376 <memmove+0x2a>
c0de1406:	46c0      	nop			; (mov r8, r8)

c0de1408 <memset>:
c0de1408:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de140a:	0005      	movs	r5, r0
c0de140c:	0783      	lsls	r3, r0, #30
c0de140e:	d04a      	beq.n	c0de14a6 <memset+0x9e>
c0de1410:	1e54      	subs	r4, r2, #1
c0de1412:	2a00      	cmp	r2, #0
c0de1414:	d044      	beq.n	c0de14a0 <memset+0x98>
c0de1416:	b2ce      	uxtb	r6, r1
c0de1418:	0003      	movs	r3, r0
c0de141a:	2203      	movs	r2, #3
c0de141c:	e002      	b.n	c0de1424 <memset+0x1c>
c0de141e:	3501      	adds	r5, #1
c0de1420:	3c01      	subs	r4, #1
c0de1422:	d33d      	bcc.n	c0de14a0 <memset+0x98>
c0de1424:	3301      	adds	r3, #1
c0de1426:	702e      	strb	r6, [r5, #0]
c0de1428:	4213      	tst	r3, r2
c0de142a:	d1f8      	bne.n	c0de141e <memset+0x16>
c0de142c:	2c03      	cmp	r4, #3
c0de142e:	d92f      	bls.n	c0de1490 <memset+0x88>
c0de1430:	22ff      	movs	r2, #255	; 0xff
c0de1432:	400a      	ands	r2, r1
c0de1434:	0215      	lsls	r5, r2, #8
c0de1436:	4315      	orrs	r5, r2
c0de1438:	042a      	lsls	r2, r5, #16
c0de143a:	4315      	orrs	r5, r2
c0de143c:	2c0f      	cmp	r4, #15
c0de143e:	d935      	bls.n	c0de14ac <memset+0xa4>
c0de1440:	0027      	movs	r7, r4
c0de1442:	3f10      	subs	r7, #16
c0de1444:	093f      	lsrs	r7, r7, #4
c0de1446:	013e      	lsls	r6, r7, #4
c0de1448:	46b4      	mov	ip, r6
c0de144a:	001e      	movs	r6, r3
c0de144c:	001a      	movs	r2, r3
c0de144e:	3610      	adds	r6, #16
c0de1450:	4466      	add	r6, ip
c0de1452:	6015      	str	r5, [r2, #0]
c0de1454:	6055      	str	r5, [r2, #4]
c0de1456:	6095      	str	r5, [r2, #8]
c0de1458:	60d5      	str	r5, [r2, #12]
c0de145a:	3210      	adds	r2, #16
c0de145c:	42b2      	cmp	r2, r6
c0de145e:	d1f8      	bne.n	c0de1452 <memset+0x4a>
c0de1460:	260f      	movs	r6, #15
c0de1462:	220c      	movs	r2, #12
c0de1464:	3701      	adds	r7, #1
c0de1466:	013f      	lsls	r7, r7, #4
c0de1468:	4026      	ands	r6, r4
c0de146a:	19db      	adds	r3, r3, r7
c0de146c:	0037      	movs	r7, r6
c0de146e:	4222      	tst	r2, r4
c0de1470:	d017      	beq.n	c0de14a2 <memset+0x9a>
c0de1472:	1f3e      	subs	r6, r7, #4
c0de1474:	08b6      	lsrs	r6, r6, #2
c0de1476:	00b4      	lsls	r4, r6, #2
c0de1478:	46a4      	mov	ip, r4
c0de147a:	001a      	movs	r2, r3
c0de147c:	1d1c      	adds	r4, r3, #4
c0de147e:	4464      	add	r4, ip
c0de1480:	c220      	stmia	r2!, {r5}
c0de1482:	42a2      	cmp	r2, r4
c0de1484:	d1fc      	bne.n	c0de1480 <memset+0x78>
c0de1486:	2403      	movs	r4, #3
c0de1488:	3601      	adds	r6, #1
c0de148a:	00b6      	lsls	r6, r6, #2
c0de148c:	199b      	adds	r3, r3, r6
c0de148e:	403c      	ands	r4, r7
c0de1490:	2c00      	cmp	r4, #0
c0de1492:	d005      	beq.n	c0de14a0 <memset+0x98>
c0de1494:	b2c9      	uxtb	r1, r1
c0de1496:	191c      	adds	r4, r3, r4
c0de1498:	7019      	strb	r1, [r3, #0]
c0de149a:	3301      	adds	r3, #1
c0de149c:	429c      	cmp	r4, r3
c0de149e:	d1fb      	bne.n	c0de1498 <memset+0x90>
c0de14a0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de14a2:	0034      	movs	r4, r6
c0de14a4:	e7f4      	b.n	c0de1490 <memset+0x88>
c0de14a6:	0014      	movs	r4, r2
c0de14a8:	0003      	movs	r3, r0
c0de14aa:	e7bf      	b.n	c0de142c <memset+0x24>
c0de14ac:	0027      	movs	r7, r4
c0de14ae:	e7e0      	b.n	c0de1472 <memset+0x6a>

c0de14b0 <setjmp>:
c0de14b0:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de14b2:	4641      	mov	r1, r8
c0de14b4:	464a      	mov	r2, r9
c0de14b6:	4653      	mov	r3, sl
c0de14b8:	465c      	mov	r4, fp
c0de14ba:	466d      	mov	r5, sp
c0de14bc:	4676      	mov	r6, lr
c0de14be:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de14c0:	3828      	subs	r0, #40	; 0x28
c0de14c2:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de14c4:	2000      	movs	r0, #0
c0de14c6:	4770      	bx	lr

c0de14c8 <longjmp>:
c0de14c8:	3010      	adds	r0, #16
c0de14ca:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de14cc:	4690      	mov	r8, r2
c0de14ce:	4699      	mov	r9, r3
c0de14d0:	46a2      	mov	sl, r4
c0de14d2:	46ab      	mov	fp, r5
c0de14d4:	46b5      	mov	sp, r6
c0de14d6:	c808      	ldmia	r0!, {r3}
c0de14d8:	3828      	subs	r0, #40	; 0x28
c0de14da:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de14dc:	1c08      	adds	r0, r1, #0
c0de14de:	d100      	bne.n	c0de14e2 <longjmp+0x1a>
c0de14e0:	2001      	movs	r0, #1
c0de14e2:	4718      	bx	r3

c0de14e4 <strlcpy>:
c0de14e4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de14e6:	2a00      	cmp	r2, #0
c0de14e8:	d013      	beq.n	c0de1512 <strlcpy+0x2e>
c0de14ea:	3a01      	subs	r2, #1
c0de14ec:	2a00      	cmp	r2, #0
c0de14ee:	d019      	beq.n	c0de1524 <strlcpy+0x40>
c0de14f0:	2300      	movs	r3, #0
c0de14f2:	1c4f      	adds	r7, r1, #1
c0de14f4:	1c46      	adds	r6, r0, #1
c0de14f6:	e002      	b.n	c0de14fe <strlcpy+0x1a>
c0de14f8:	3301      	adds	r3, #1
c0de14fa:	429a      	cmp	r2, r3
c0de14fc:	d016      	beq.n	c0de152c <strlcpy+0x48>
c0de14fe:	18f5      	adds	r5, r6, r3
c0de1500:	46ac      	mov	ip, r5
c0de1502:	5ccd      	ldrb	r5, [r1, r3]
c0de1504:	18fc      	adds	r4, r7, r3
c0de1506:	54c5      	strb	r5, [r0, r3]
c0de1508:	2d00      	cmp	r5, #0
c0de150a:	d1f5      	bne.n	c0de14f8 <strlcpy+0x14>
c0de150c:	1a60      	subs	r0, r4, r1
c0de150e:	3801      	subs	r0, #1
c0de1510:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1512:	000c      	movs	r4, r1
c0de1514:	0023      	movs	r3, r4
c0de1516:	3301      	adds	r3, #1
c0de1518:	1e5a      	subs	r2, r3, #1
c0de151a:	7812      	ldrb	r2, [r2, #0]
c0de151c:	001c      	movs	r4, r3
c0de151e:	2a00      	cmp	r2, #0
c0de1520:	d1f9      	bne.n	c0de1516 <strlcpy+0x32>
c0de1522:	e7f3      	b.n	c0de150c <strlcpy+0x28>
c0de1524:	000c      	movs	r4, r1
c0de1526:	2300      	movs	r3, #0
c0de1528:	7003      	strb	r3, [r0, #0]
c0de152a:	e7f3      	b.n	c0de1514 <strlcpy+0x30>
c0de152c:	4660      	mov	r0, ip
c0de152e:	e7fa      	b.n	c0de1526 <strlcpy+0x42>

c0de1530 <strnlen>:
c0de1530:	b510      	push	{r4, lr}
c0de1532:	2900      	cmp	r1, #0
c0de1534:	d00b      	beq.n	c0de154e <strnlen+0x1e>
c0de1536:	7803      	ldrb	r3, [r0, #0]
c0de1538:	2b00      	cmp	r3, #0
c0de153a:	d00c      	beq.n	c0de1556 <strnlen+0x26>
c0de153c:	1844      	adds	r4, r0, r1
c0de153e:	0003      	movs	r3, r0
c0de1540:	e002      	b.n	c0de1548 <strnlen+0x18>
c0de1542:	781a      	ldrb	r2, [r3, #0]
c0de1544:	2a00      	cmp	r2, #0
c0de1546:	d004      	beq.n	c0de1552 <strnlen+0x22>
c0de1548:	3301      	adds	r3, #1
c0de154a:	42a3      	cmp	r3, r4
c0de154c:	d1f9      	bne.n	c0de1542 <strnlen+0x12>
c0de154e:	0008      	movs	r0, r1
c0de1550:	bd10      	pop	{r4, pc}
c0de1552:	1a19      	subs	r1, r3, r0
c0de1554:	e7fb      	b.n	c0de154e <strnlen+0x1e>
c0de1556:	2100      	movs	r1, #0
c0de1558:	e7f9      	b.n	c0de154e <strnlen+0x1e>
c0de155a:	46c0      	nop			; (mov r8, r8)

c0de155c <_ecode>:
c0de155c:	4144      	adcs	r4, r0
c0de155e:	0049      	lsls	r1, r1, #1
c0de1560:	6c50      	ldr	r0, [r2, #68]	; 0x44
c0de1562:	6775      	str	r5, [r6, #116]	; 0x74
c0de1564:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de1566:	7020      	strb	r0, [r4, #0]
c0de1568:	7261      	strb	r1, [r4, #9]
c0de156a:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de156c:	7465      	strb	r5, [r4, #17]
c0de156e:	7265      	strb	r5, [r4, #9]
c0de1570:	2073      	movs	r0, #115	; 0x73
c0de1572:	7473      	strb	r3, [r6, #17]
c0de1574:	7572      	strb	r2, [r6, #21]
c0de1576:	7463      	strb	r3, [r4, #17]
c0de1578:	7275      	strb	r5, [r6, #9]
c0de157a:	2065      	movs	r0, #101	; 0x65
c0de157c:	7369      	strb	r1, [r5, #13]
c0de157e:	6220      	str	r0, [r4, #32]
c0de1580:	6769      	str	r1, [r5, #116]	; 0x74
c0de1582:	6567      	str	r7, [r4, #84]	; 0x54
c0de1584:	2072      	movs	r0, #114	; 0x72
c0de1586:	6874      	ldr	r4, [r6, #4]
c0de1588:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de158a:	6120      	str	r0, [r4, #16]
c0de158c:	6c6c      	ldr	r4, [r5, #68]	; 0x44
c0de158e:	776f      	strb	r7, [r5, #29]
c0de1590:	6465      	str	r5, [r4, #68]	; 0x44
c0de1592:	7320      	strb	r0, [r4, #12]
c0de1594:	7a69      	ldrb	r1, [r5, #9]
c0de1596:	0a65      	lsrs	r5, r4, #9
c0de1598:	5300      	strh	r0, [r0, r4]
c0de159a:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de159c:	0064      	lsls	r4, r4, #1
c0de159e:	4157      	adcs	r7, r2
c0de15a0:	4e52      	ldr	r6, [pc, #328]	; (c0de16ec <_ecode+0x190>)
c0de15a2:	4e49      	ldr	r6, [pc, #292]	; (c0de16c8 <_ecode+0x16c>)
c0de15a4:	0047      	lsls	r7, r0, #1
c0de15a6:	656f      	str	r7, [r5, #84]	; 0x54
c0de15a8:	6874      	ldr	r4, [r6, #4]
c0de15aa:	7020      	strb	r0, [r4, #0]
c0de15ac:	756c      	strb	r4, [r5, #21]
c0de15ae:	6967      	ldr	r7, [r4, #20]
c0de15b0:	206e      	movs	r0, #110	; 0x6e
c0de15b2:	7270      	strb	r0, [r6, #9]
c0de15b4:	766f      	strb	r7, [r5, #25]
c0de15b6:	6469      	str	r1, [r5, #68]	; 0x44
c0de15b8:	2065      	movs	r0, #101	; 0x65
c0de15ba:	6170      	str	r0, [r6, #20]
c0de15bc:	6172      	str	r2, [r6, #20]
c0de15be:	656d      	str	r5, [r5, #84]	; 0x54
c0de15c0:	6574      	str	r4, [r6, #84]	; 0x54
c0de15c2:	3a72      	subs	r2, #114	; 0x72
c0de15c4:	0020      	movs	r0, r4
c0de15c6:	0020      	movs	r0, r4
c0de15c8:	6150      	str	r0, [r2, #20]
c0de15ca:	6172      	str	r2, [r6, #20]
c0de15cc:	206d      	movs	r0, #109	; 0x6d
c0de15ce:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de15d0:	2074      	movs	r0, #116	; 0x74
c0de15d2:	7573      	strb	r3, [r6, #21]
c0de15d4:	7070      	strb	r0, [r6, #1]
c0de15d6:	726f      	strb	r7, [r5, #9]
c0de15d8:	6574      	str	r4, [r6, #84]	; 0x54
c0de15da:	0a64      	lsrs	r4, r4, #9
c0de15dc:	5400      	strb	r0, [r0, r0]
c0de15de:	4b4f      	ldr	r3, [pc, #316]	; (c0de171c <_ecode+0x1c0>)
c0de15e0:	4e45      	ldr	r6, [pc, #276]	; (c0de16f8 <_ecode+0x19c>)
c0de15e2:	5320      	strh	r0, [r4, r4]
c0de15e4:	4e45      	ldr	r6, [pc, #276]	; (c0de16fc <_ecode+0x1a0>)
c0de15e6:	3a54      	subs	r2, #84	; 0x54
c0de15e8:	0020      	movs	r0, r4
c0de15ea:	454f      	cmp	r7, r9
c0de15ec:	4854      	ldr	r0, [pc, #336]	; (c0de1740 <_ecode+0x1e4>)
c0de15ee:	7020      	strb	r0, [r4, #0]
c0de15f0:	756c      	strb	r4, [r5, #21]
c0de15f2:	6967      	ldr	r7, [r4, #20]
c0de15f4:	206e      	movs	r0, #110	; 0x6e
c0de15f6:	7270      	strb	r0, [r6, #9]
c0de15f8:	766f      	strb	r7, [r5, #25]
c0de15fa:	6469      	str	r1, [r5, #68]	; 0x44
c0de15fc:	2065      	movs	r0, #101	; 0x65
c0de15fe:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de1600:	656b      	str	r3, [r5, #84]	; 0x54
c0de1602:	3a6e      	subs	r2, #110	; 0x6e
c0de1604:	3020      	adds	r0, #32
c0de1606:	2578      	movs	r5, #120	; 0x78
c0de1608:	2c70      	cmp	r4, #112	; 0x70
c0de160a:	3020      	adds	r0, #32
c0de160c:	2578      	movs	r5, #120	; 0x78
c0de160e:	0a70      	lsrs	r0, r6, #9
c0de1610:	4d00      	ldr	r5, [pc, #0]	; (c0de1614 <_ecode+0xb8>)
c0de1612:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de1614:	0074      	lsls	r4, r6, #1
c0de1616:	3025      	adds	r0, #37	; 0x25
c0de1618:	7832      	ldrb	r2, [r6, #0]
c0de161a:	5300      	strh	r0, [r0, r4]
c0de161c:	6177      	str	r7, [r6, #20]
c0de161e:	0070      	lsls	r0, r6, #1
c0de1620:	4f54      	ldr	r7, [pc, #336]	; (c0de1774 <_ecode+0x218>)
c0de1622:	454b      	cmp	r3, r9
c0de1624:	204e      	movs	r0, #78	; 0x4e
c0de1626:	4552      	cmp	r2, sl
c0de1628:	4543      	cmp	r3, r8
c0de162a:	5649      	ldrsb	r1, [r1, r1]
c0de162c:	4445      	add	r5, r8
c0de162e:	203a      	movs	r0, #58	; 0x3a
c0de1630:	4f00      	ldr	r7, [pc, #0]	; (c0de1634 <_ecode+0xd8>)
c0de1632:	5355      	strh	r5, [r2, r5]
c0de1634:	0044      	lsls	r4, r0, #1
c0de1636:	724f      	strb	r7, [r1, #9]
c0de1638:	6769      	str	r1, [r5, #116]	; 0x74
c0de163a:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de163c:	4420      	add	r0, r4
c0de163e:	4665      	mov	r5, ip
c0de1640:	0069      	lsls	r1, r5, #1
c0de1642:	6552      	str	r2, [r2, #84]	; 0x54
c0de1644:	6564      	str	r4, [r4, #84]	; 0x54
c0de1646:	6d65      	ldr	r5, [r4, #84]	; 0x54
c0de1648:	5500      	strb	r0, [r0, r4]
c0de164a:	4453      	add	r3, sl
c0de164c:	0043      	lsls	r3, r0, #1
c0de164e:	7445      	strb	r5, [r0, #17]
c0de1650:	6568      	str	r0, [r5, #84]	; 0x54
c0de1652:	6572      	str	r2, [r6, #84]	; 0x54
c0de1654:	6d75      	ldr	r5, [r6, #84]	; 0x54
c0de1656:	3000      	adds	r0, #0
c0de1658:	5300      	strh	r0, [r0, r4]
c0de165a:	7465      	strb	r5, [r4, #17]
c0de165c:	6974      	ldr	r4, [r6, #20]
c0de165e:	676e      	str	r6, [r5, #116]	; 0x74
c0de1660:	6120      	str	r0, [r4, #16]
c0de1662:	6464      	str	r4, [r4, #68]	; 0x44
c0de1664:	6572      	str	r2, [r6, #84]	; 0x54
c0de1666:	7373      	strb	r3, [r6, #13]
c0de1668:	7220      	strb	r0, [r4, #8]
c0de166a:	6365      	str	r5, [r4, #52]	; 0x34
c0de166c:	6965      	ldr	r5, [r4, #20]
c0de166e:	6576      	str	r6, [r6, #84]	; 0x54
c0de1670:	2064      	movs	r0, #100	; 0x64
c0de1672:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de1674:	203a      	movs	r0, #58	; 0x3a
c0de1676:	5000      	str	r0, [r0, r0]
c0de1678:	7261      	strb	r1, [r4, #9]
c0de167a:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de167c:	6e20      	ldr	r0, [r4, #96]	; 0x60
c0de167e:	746f      	strb	r7, [r5, #17]
c0de1680:	7320      	strb	r0, [r4, #12]
c0de1682:	7075      	strb	r5, [r6, #1]
c0de1684:	6f70      	ldr	r0, [r6, #116]	; 0x74
c0de1686:	7472      	strb	r2, [r6, #17]
c0de1688:	6465      	str	r5, [r4, #68]	; 0x44
c0de168a:	203a      	movs	r0, #58	; 0x3a
c0de168c:	6425      	str	r5, [r4, #64]	; 0x40
c0de168e:	000a      	movs	r2, r1
c0de1690:	6552      	str	r2, [r2, #84]	; 0x54
c0de1692:	6563      	str	r3, [r4, #84]	; 0x54
c0de1694:	7669      	strb	r1, [r5, #25]
c0de1696:	2065      	movs	r0, #101	; 0x65
c0de1698:	694d      	ldr	r5, [r1, #20]
c0de169a:	006e      	lsls	r6, r5, #1
c0de169c:	7845      	ldrb	r5, [r0, #1]
c0de169e:	6563      	str	r3, [r4, #84]	; 0x54
c0de16a0:	7470      	strb	r0, [r6, #17]
c0de16a2:	6f69      	ldr	r1, [r5, #116]	; 0x74
c0de16a4:	206e      	movs	r0, #110	; 0x6e
c0de16a6:	7830      	ldrb	r0, [r6, #0]
c0de16a8:	7825      	ldrb	r5, [r4, #0]
c0de16aa:	6320      	str	r0, [r4, #48]	; 0x30
c0de16ac:	7561      	strb	r1, [r4, #21]
c0de16ae:	6867      	ldr	r7, [r4, #4]
c0de16b0:	0a74      	lsrs	r4, r6, #9
c0de16b2:	7300      	strb	r0, [r0, #12]
c0de16b4:	7266      	strb	r6, [r4, #9]
c0de16b6:	4578      	cmp	r0, pc
c0de16b8:	4854      	ldr	r0, [pc, #336]	; (c0de180c <_ecode+0x2b0>)
c0de16ba:	5500      	strb	r0, [r0, r4]
c0de16bc:	6b6e      	ldr	r6, [r5, #52]	; 0x34
c0de16be:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de16c0:	6e77      	ldr	r7, [r6, #100]	; 0x64
c0de16c2:	7420      	strb	r0, [r4, #16]
c0de16c4:	6b6f      	ldr	r7, [r5, #52]	; 0x34
c0de16c6:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de16c8:	6400      	str	r0, [r0, #64]	; 0x40
c0de16ca:	7365      	strb	r5, [r4, #13]
c0de16cc:	6974      	ldr	r4, [r6, #20]
c0de16ce:	616e      	str	r6, [r5, #20]
c0de16d0:	6974      	ldr	r4, [r6, #20]
c0de16d2:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de16d4:	203a      	movs	r0, #58	; 0x3a
c0de16d6:	6500      	str	r0, [r0, #80]	; 0x50
c0de16d8:	6378      	str	r0, [r7, #52]	; 0x34
c0de16da:	7065      	strb	r5, [r4, #1]
c0de16dc:	6974      	ldr	r4, [r6, #20]
c0de16de:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de16e0:	255b      	movs	r5, #91	; 0x5b
c0de16e2:	5d64      	ldrb	r4, [r4, r5]
c0de16e4:	203a      	movs	r0, #58	; 0x3a
c0de16e6:	524c      	strh	r4, [r1, r1]
c0de16e8:	303d      	adds	r0, #61	; 0x3d
c0de16ea:	2578      	movs	r5, #120	; 0x78
c0de16ec:	3830      	subs	r0, #48	; 0x30
c0de16ee:	0a58      	lsrs	r0, r3, #9
c0de16f0:	4500      	cmp	r0, r0
c0de16f2:	5252      	strh	r2, [r2, r1]
c0de16f4:	524f      	strh	r7, [r1, r1]
c0de16f6:	5500      	strb	r0, [r0, r4]
c0de16f8:	686e      	ldr	r6, [r5, #4]
c0de16fa:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de16fc:	6c64      	ldr	r4, [r4, #68]	; 0x44
c0de16fe:	6465      	str	r5, [r4, #68]	; 0x44
c0de1700:	6d20      	ldr	r0, [r4, #80]	; 0x50
c0de1702:	7365      	strb	r5, [r4, #13]
c0de1704:	6173      	str	r3, [r6, #20]
c0de1706:	6567      	str	r7, [r4, #84]	; 0x54
c0de1708:	2520      	movs	r5, #32
c0de170a:	0a64      	lsrs	r4, r4, #9
c0de170c:	5300      	strh	r0, [r0, r4]
c0de170e:	7465      	strb	r5, [r4, #17]
c0de1710:	6974      	ldr	r4, [r6, #20]
c0de1712:	676e      	str	r6, [r5, #116]	; 0x74
c0de1714:	6120      	str	r0, [r4, #16]
c0de1716:	6464      	str	r4, [r4, #68]	; 0x44
c0de1718:	6572      	str	r2, [r6, #84]	; 0x54
c0de171a:	7373      	strb	r3, [r6, #13]
c0de171c:	7320      	strb	r0, [r4, #12]
c0de171e:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de1720:	2074      	movs	r0, #116	; 0x74
c0de1722:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de1724:	203a      	movs	r0, #58	; 0x3a
c0de1726:	0a00      	lsrs	r0, r0, #8
c0de1728:	5200      	strh	r0, [r0, r0]
c0de172a:	6365      	str	r5, [r4, #52]	; 0x34
c0de172c:	6965      	ldr	r5, [r4, #20]
c0de172e:	6576      	str	r6, [r6, #84]	; 0x54
c0de1730:	2064      	movs	r0, #100	; 0x64
c0de1732:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de1734:	6920      	ldr	r0, [r4, #16]
c0de1736:	766e      	strb	r6, [r5, #25]
c0de1738:	6c61      	ldr	r1, [r4, #68]	; 0x44
c0de173a:	6469      	str	r1, [r5, #68]	; 0x44
c0de173c:	7320      	strb	r0, [r4, #12]
c0de173e:	7263      	strb	r3, [r4, #9]
c0de1740:	6565      	str	r5, [r4, #84]	; 0x54
c0de1742:	496e      	ldr	r1, [pc, #440]	; (c0de18fc <g_pcHex_cap+0x8>)
c0de1744:	646e      	str	r6, [r5, #68]	; 0x44
c0de1746:	7865      	ldrb	r5, [r4, #1]
c0de1748:	000a      	movs	r2, r1
c0de174a:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de174c:	6f63      	ldr	r3, [r4, #116]	; 0x74
c0de174e:	696d      	ldr	r5, [r5, #20]
c0de1750:	676e      	str	r6, [r5, #116]	; 0x74
c0de1752:	7020      	strb	r0, [r4, #0]
c0de1754:	7261      	strb	r1, [r4, #9]
c0de1756:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de1758:	7465      	strb	r5, [r4, #17]
c0de175a:	7265      	strb	r5, [r4, #9]
c0de175c:	203a      	movs	r0, #58	; 0x3a
c0de175e:	4100      	asrs	r0, r0
c0de1760:	4f4d      	ldr	r7, [pc, #308]	; (c0de1898 <USDT_ADDRESS+0x4>)
c0de1762:	4e55      	ldr	r6, [pc, #340]	; (c0de18b8 <OETH_VAULT_ADDRESS+0x10>)
c0de1764:	2054      	movs	r0, #84	; 0x54
c0de1766:	4553      	cmp	r3, sl
c0de1768:	544e      	strb	r6, [r1, r1]
c0de176a:	203a      	movs	r0, #58	; 0x3a
c0de176c:	7325      	strb	r5, [r4, #12]
c0de176e:	000a      	movs	r2, r1
c0de1770:	5300      	strh	r0, [r0, r4]
c0de1772:	6c65      	ldr	r5, [r4, #68]	; 0x44
c0de1774:	6365      	str	r5, [r4, #52]	; 0x34
c0de1776:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de1778:	2072      	movs	r0, #114	; 0x72
c0de177a:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de177c:	6564      	str	r4, [r4, #84]	; 0x54
c0de177e:	2078      	movs	r0, #120	; 0x78
c0de1780:	253a      	movs	r5, #58	; 0x3a
c0de1782:	2064      	movs	r0, #100	; 0x64
c0de1784:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de1786:	2074      	movs	r0, #116	; 0x74
c0de1788:	7573      	strb	r3, [r6, #21]
c0de178a:	7070      	strb	r0, [r6, #1]
c0de178c:	726f      	strb	r7, [r5, #9]
c0de178e:	6574      	str	r4, [r6, #84]	; 0x54
c0de1790:	0a64      	lsrs	r4, r4, #9
c0de1792:	5500      	strb	r0, [r0, r4]
c0de1794:	4453      	add	r3, sl
c0de1796:	0054      	lsls	r4, r2, #1
c0de1798:	6e55      	ldr	r5, [r2, #100]	; 0x64
c0de179a:	6168      	str	r0, [r5, #20]
c0de179c:	646e      	str	r6, [r5, #68]	; 0x44
c0de179e:	656c      	str	r4, [r5, #84]	; 0x54
c0de17a0:	2064      	movs	r0, #100	; 0x64
c0de17a2:	6573      	str	r3, [r6, #84]	; 0x54
c0de17a4:	656c      	str	r4, [r5, #84]	; 0x54
c0de17a6:	7463      	strb	r3, [r4, #17]
c0de17a8:	726f      	strb	r7, [r5, #9]
c0de17aa:	4920      	ldr	r1, [pc, #128]	; (c0de182c <ORIGIN_DEFI_SELECTORS+0x10>)
c0de17ac:	646e      	str	r6, [r5, #68]	; 0x44
c0de17ae:	7865      	ldrb	r5, [r4, #1]
c0de17b0:	203a      	movs	r0, #58	; 0x3a
c0de17b2:	6425      	str	r5, [r4, #64]	; 0x40
c0de17b4:	000a      	movs	r2, r1
c0de17b6:	4e55      	ldr	r6, [pc, #340]	; (c0de190c <NULL_ETH_ADDRESS+0x8>)
c0de17b8:	5449      	strb	r1, [r1, r1]
c0de17ba:	0053      	lsls	r3, r2, #1
c0de17bc:	6544      	str	r4, [r0, #84]	; 0x54
c0de17be:	6f70      	ldr	r0, [r6, #116]	; 0x74
c0de17c0:	6973      	ldr	r3, [r6, #20]
c0de17c2:	0074      	lsls	r4, r6, #1
c0de17c4:	694d      	ldr	r5, [r1, #20]
c0de17c6:	7373      	strb	r3, [r6, #13]
c0de17c8:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de17ca:	2067      	movs	r0, #103	; 0x67
c0de17cc:	6573      	str	r3, [r6, #84]	; 0x54
c0de17ce:	656c      	str	r4, [r5, #84]	; 0x54
c0de17d0:	7463      	strb	r3, [r4, #17]
c0de17d2:	726f      	strb	r7, [r5, #9]
c0de17d4:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de17d6:	6564      	str	r4, [r4, #84]	; 0x54
c0de17d8:	3a78      	subs	r2, #120	; 0x78
c0de17da:	2520      	movs	r5, #32
c0de17dc:	0a64      	lsrs	r4, r4, #9
c0de17de:	5300      	strh	r0, [r0, r4]
c0de17e0:	6c65      	ldr	r5, [r4, #68]	; 0x44
c0de17e2:	6365      	str	r5, [r4, #52]	; 0x34
c0de17e4:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de17e6:	2072      	movs	r0, #114	; 0x72
c0de17e8:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de17ea:	6564      	str	r4, [r4, #84]	; 0x54
c0de17ec:	2078      	movs	r0, #120	; 0x78
c0de17ee:	6425      	str	r5, [r4, #64]	; 0x40
c0de17f0:	6e20      	ldr	r0, [r4, #96]	; 0x60
c0de17f2:	746f      	strb	r7, [r5, #17]
c0de17f4:	7320      	strb	r0, [r4, #12]
c0de17f6:	7075      	strb	r5, [r6, #1]
c0de17f8:	6f70      	ldr	r0, [r6, #116]	; 0x74
c0de17fa:	7472      	strb	r2, [r6, #17]
c0de17fc:	6465      	str	r5, [r4, #68]	; 0x44
c0de17fe:	000a      	movs	r2, r1
c0de1800:	454f      	cmp	r7, r9
c0de1802:	4854      	ldr	r0, [pc, #336]	; (c0de1954 <_etext+0x3c>)
c0de1804:	4100      	asrs	r0, r0
c0de1806:	4f4d      	ldr	r7, [pc, #308]	; (c0de193c <_etext+0x24>)
c0de1808:	4e55      	ldr	r6, [pc, #340]	; (c0de1960 <_etext+0x48>)
c0de180a:	2054      	movs	r0, #84	; 0x54
c0de180c:	4552      	cmp	r2, sl
c0de180e:	4543      	cmp	r3, r8
c0de1810:	5649      	ldrsb	r1, [r1, r1]
c0de1812:	4445      	add	r5, r8
c0de1814:	203a      	movs	r0, #58	; 0x3a
c0de1816:	7325      	strb	r5, [r4, #12]
c0de1818:	000a      	movs	r2, r1
c0de181a:	d4d4      	bmi.n	c0de17c6 <_ecode+0x26a>

c0de181c <ORIGIN_DEFI_SELECTORS>:
c0de181c:	0db0 d0e3 e97d d443 29f6 156e 2373 7cbc     ....}.C..)n.s#.|
c0de182c:	2124 3df0 7ed6 a641 a424 353c 8d59 c04b     $!.=.~A.$.<5Y.K.
c0de183c:	f389 414b 0b96 35aa 9053 cb93 c746 5981     ..KA...5S...F..Y
c0de184c:	5a0f 8a09 1ffd bfc1 8169 c6b6               .Z......i...

c0de1858 <OETH_ADDRESS>:
c0de1858:	6c85 fb4e c176 aed1 e202 eb0c a203 a0a6     .lN.v...........
c0de1868:	0b8b c38d                                   ....

c0de186c <DAI_ADDRESS>:
	...

c0de1880 <USDC_ADDRESS>:
	...

c0de1894 <USDT_ADDRESS>:
	...

c0de18a8 <OETH_VAULT_ADDRESS>:
c0de18a8:	2539 3340 5a94 e4a2 9c80 97c2 707e be87     9%@3.Z......~p..
c0de18b8:	8be4 abd7                                   ....

c0de18bc <CURVE_OETH_POOL_ADDRESS>:
	...

c0de18d0 <CURVE_OUSD_POOL_ADDRESS>:
	...

c0de18e4 <g_pcHex>:
c0de18e4:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de18f4 <g_pcHex_cap>:
c0de18f4:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de1904 <NULL_ETH_ADDRESS>:
	...

c0de1918 <_etext>:
c0de1918:	d4d4      	bmi.n	c0de18c4 <CURVE_OETH_POOL_ADDRESS+0x8>
c0de191a:	d4d4      	bmi.n	c0de18c6 <CURVE_OETH_POOL_ADDRESS+0xa>
c0de191c:	d4d4      	bmi.n	c0de18c8 <CURVE_OETH_POOL_ADDRESS+0xc>
c0de191e:	d4d4      	bmi.n	c0de18ca <CURVE_OETH_POOL_ADDRESS+0xe>
c0de1920:	d4d4      	bmi.n	c0de18cc <CURVE_OETH_POOL_ADDRESS+0x10>
c0de1922:	d4d4      	bmi.n	c0de18ce <CURVE_OETH_POOL_ADDRESS+0x12>
c0de1924:	d4d4      	bmi.n	c0de18d0 <CURVE_OUSD_POOL_ADDRESS>
c0de1926:	d4d4      	bmi.n	c0de18d2 <CURVE_OUSD_POOL_ADDRESS+0x2>
c0de1928:	d4d4      	bmi.n	c0de18d4 <CURVE_OUSD_POOL_ADDRESS+0x4>
c0de192a:	d4d4      	bmi.n	c0de18d6 <CURVE_OUSD_POOL_ADDRESS+0x6>
c0de192c:	d4d4      	bmi.n	c0de18d8 <CURVE_OUSD_POOL_ADDRESS+0x8>
c0de192e:	d4d4      	bmi.n	c0de18da <CURVE_OUSD_POOL_ADDRESS+0xa>
c0de1930:	d4d4      	bmi.n	c0de18dc <CURVE_OUSD_POOL_ADDRESS+0xc>
c0de1932:	d4d4      	bmi.n	c0de18de <CURVE_OUSD_POOL_ADDRESS+0xe>
c0de1934:	d4d4      	bmi.n	c0de18e0 <CURVE_OUSD_POOL_ADDRESS+0x10>
c0de1936:	d4d4      	bmi.n	c0de18e2 <CURVE_OUSD_POOL_ADDRESS+0x12>
c0de1938:	d4d4      	bmi.n	c0de18e4 <g_pcHex>
c0de193a:	d4d4      	bmi.n	c0de18e6 <g_pcHex+0x2>
c0de193c:	d4d4      	bmi.n	c0de18e8 <g_pcHex+0x4>
c0de193e:	d4d4      	bmi.n	c0de18ea <g_pcHex+0x6>
c0de1940:	d4d4      	bmi.n	c0de18ec <g_pcHex+0x8>
c0de1942:	d4d4      	bmi.n	c0de18ee <g_pcHex+0xa>
c0de1944:	d4d4      	bmi.n	c0de18f0 <g_pcHex+0xc>
c0de1946:	d4d4      	bmi.n	c0de18f2 <g_pcHex+0xe>
c0de1948:	d4d4      	bmi.n	c0de18f4 <g_pcHex_cap>
c0de194a:	d4d4      	bmi.n	c0de18f6 <g_pcHex_cap+0x2>
c0de194c:	d4d4      	bmi.n	c0de18f8 <g_pcHex_cap+0x4>
c0de194e:	d4d4      	bmi.n	c0de18fa <g_pcHex_cap+0x6>
c0de1950:	d4d4      	bmi.n	c0de18fc <g_pcHex_cap+0x8>
c0de1952:	d4d4      	bmi.n	c0de18fe <g_pcHex_cap+0xa>
c0de1954:	d4d4      	bmi.n	c0de1900 <g_pcHex_cap+0xc>
c0de1956:	d4d4      	bmi.n	c0de1902 <g_pcHex_cap+0xe>
c0de1958:	d4d4      	bmi.n	c0de1904 <NULL_ETH_ADDRESS>
c0de195a:	d4d4      	bmi.n	c0de1906 <NULL_ETH_ADDRESS+0x2>
c0de195c:	d4d4      	bmi.n	c0de1908 <NULL_ETH_ADDRESS+0x4>
c0de195e:	d4d4      	bmi.n	c0de190a <NULL_ETH_ADDRESS+0x6>
c0de1960:	d4d4      	bmi.n	c0de190c <NULL_ETH_ADDRESS+0x8>
c0de1962:	d4d4      	bmi.n	c0de190e <NULL_ETH_ADDRESS+0xa>
c0de1964:	d4d4      	bmi.n	c0de1910 <NULL_ETH_ADDRESS+0xc>
c0de1966:	d4d4      	bmi.n	c0de1912 <NULL_ETH_ADDRESS+0xe>
c0de1968:	d4d4      	bmi.n	c0de1914 <NULL_ETH_ADDRESS+0x10>
c0de196a:	d4d4      	bmi.n	c0de1916 <NULL_ETH_ADDRESS+0x12>
c0de196c:	d4d4      	bmi.n	c0de1918 <_etext>
c0de196e:	d4d4      	bmi.n	c0de191a <_etext+0x2>
c0de1970:	d4d4      	bmi.n	c0de191c <_etext+0x4>
c0de1972:	d4d4      	bmi.n	c0de191e <_etext+0x6>
c0de1974:	d4d4      	bmi.n	c0de1920 <_etext+0x8>
c0de1976:	d4d4      	bmi.n	c0de1922 <_etext+0xa>
c0de1978:	d4d4      	bmi.n	c0de1924 <_etext+0xc>
c0de197a:	d4d4      	bmi.n	c0de1926 <_etext+0xe>
c0de197c:	d4d4      	bmi.n	c0de1928 <_etext+0x10>
c0de197e:	d4d4      	bmi.n	c0de192a <_etext+0x12>
c0de1980:	d4d4      	bmi.n	c0de192c <_etext+0x14>
c0de1982:	d4d4      	bmi.n	c0de192e <_etext+0x16>
c0de1984:	d4d4      	bmi.n	c0de1930 <_etext+0x18>
c0de1986:	d4d4      	bmi.n	c0de1932 <_etext+0x1a>
c0de1988:	d4d4      	bmi.n	c0de1934 <_etext+0x1c>
c0de198a:	d4d4      	bmi.n	c0de1936 <_etext+0x1e>
c0de198c:	d4d4      	bmi.n	c0de1938 <_etext+0x20>
c0de198e:	d4d4      	bmi.n	c0de193a <_etext+0x22>
c0de1990:	d4d4      	bmi.n	c0de193c <_etext+0x24>
c0de1992:	d4d4      	bmi.n	c0de193e <_etext+0x26>
c0de1994:	d4d4      	bmi.n	c0de1940 <_etext+0x28>
c0de1996:	d4d4      	bmi.n	c0de1942 <_etext+0x2a>
c0de1998:	d4d4      	bmi.n	c0de1944 <_etext+0x2c>
c0de199a:	d4d4      	bmi.n	c0de1946 <_etext+0x2e>
c0de199c:	d4d4      	bmi.n	c0de1948 <_etext+0x30>
c0de199e:	d4d4      	bmi.n	c0de194a <_etext+0x32>
c0de19a0:	d4d4      	bmi.n	c0de194c <_etext+0x34>
c0de19a2:	d4d4      	bmi.n	c0de194e <_etext+0x36>
c0de19a4:	d4d4      	bmi.n	c0de1950 <_etext+0x38>
c0de19a6:	d4d4      	bmi.n	c0de1952 <_etext+0x3a>
c0de19a8:	d4d4      	bmi.n	c0de1954 <_etext+0x3c>
c0de19aa:	d4d4      	bmi.n	c0de1956 <_etext+0x3e>
c0de19ac:	d4d4      	bmi.n	c0de1958 <_etext+0x40>
c0de19ae:	d4d4      	bmi.n	c0de195a <_etext+0x42>
c0de19b0:	d4d4      	bmi.n	c0de195c <_etext+0x44>
c0de19b2:	d4d4      	bmi.n	c0de195e <_etext+0x46>
c0de19b4:	d4d4      	bmi.n	c0de1960 <_etext+0x48>
c0de19b6:	d4d4      	bmi.n	c0de1962 <_etext+0x4a>
c0de19b8:	d4d4      	bmi.n	c0de1964 <_etext+0x4c>
c0de19ba:	d4d4      	bmi.n	c0de1966 <_etext+0x4e>
c0de19bc:	d4d4      	bmi.n	c0de1968 <_etext+0x50>
c0de19be:	d4d4      	bmi.n	c0de196a <_etext+0x52>
c0de19c0:	d4d4      	bmi.n	c0de196c <_etext+0x54>
c0de19c2:	d4d4      	bmi.n	c0de196e <_etext+0x56>
c0de19c4:	d4d4      	bmi.n	c0de1970 <_etext+0x58>
c0de19c6:	d4d4      	bmi.n	c0de1972 <_etext+0x5a>
c0de19c8:	d4d4      	bmi.n	c0de1974 <_etext+0x5c>
c0de19ca:	d4d4      	bmi.n	c0de1976 <_etext+0x5e>
c0de19cc:	d4d4      	bmi.n	c0de1978 <_etext+0x60>
c0de19ce:	d4d4      	bmi.n	c0de197a <_etext+0x62>
c0de19d0:	d4d4      	bmi.n	c0de197c <_etext+0x64>
c0de19d2:	d4d4      	bmi.n	c0de197e <_etext+0x66>
c0de19d4:	d4d4      	bmi.n	c0de1980 <_etext+0x68>
c0de19d6:	d4d4      	bmi.n	c0de1982 <_etext+0x6a>
c0de19d8:	d4d4      	bmi.n	c0de1984 <_etext+0x6c>
c0de19da:	d4d4      	bmi.n	c0de1986 <_etext+0x6e>
c0de19dc:	d4d4      	bmi.n	c0de1988 <_etext+0x70>
c0de19de:	d4d4      	bmi.n	c0de198a <_etext+0x72>
c0de19e0:	d4d4      	bmi.n	c0de198c <_etext+0x74>
c0de19e2:	d4d4      	bmi.n	c0de198e <_etext+0x76>
c0de19e4:	d4d4      	bmi.n	c0de1990 <_etext+0x78>
c0de19e6:	d4d4      	bmi.n	c0de1992 <_etext+0x7a>
c0de19e8:	d4d4      	bmi.n	c0de1994 <_etext+0x7c>
c0de19ea:	d4d4      	bmi.n	c0de1996 <_etext+0x7e>
c0de19ec:	d4d4      	bmi.n	c0de1998 <_etext+0x80>
c0de19ee:	d4d4      	bmi.n	c0de199a <_etext+0x82>
c0de19f0:	d4d4      	bmi.n	c0de199c <_etext+0x84>
c0de19f2:	d4d4      	bmi.n	c0de199e <_etext+0x86>
c0de19f4:	d4d4      	bmi.n	c0de19a0 <_etext+0x88>
c0de19f6:	d4d4      	bmi.n	c0de19a2 <_etext+0x8a>
c0de19f8:	d4d4      	bmi.n	c0de19a4 <_etext+0x8c>
c0de19fa:	d4d4      	bmi.n	c0de19a6 <_etext+0x8e>
c0de19fc:	d4d4      	bmi.n	c0de19a8 <_etext+0x90>
c0de19fe:	d4d4      	bmi.n	c0de19aa <_etext+0x92>
