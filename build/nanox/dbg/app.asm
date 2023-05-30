
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
c0de0008:	f000 fd6c 	bl	c0de0ae4 <os_boot>
c0de000c:	466d      	mov	r5, sp

    // Try catch block. Please read the docs for more information on how to use those!
    BEGIN_TRY {
        TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f001 f956 	bl	c0de12c0 <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10d      	bne.n	c0de003a <main+0x3a>
c0de001e:	f000 ff49 	bl	c0de0eb4 <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
  if (apiLevel < get_api_level()) {
c0de0024:	f000 ff0b 	bl	c0de0e3e <get_api_level>
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
c0de0030:	f000 fd4a 	bl	c0de0ac8 <call_app_ethereum>
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
c0de0040:	f000 ff38 	bl	c0de0eb4 <try_context_set>
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
c0de0064:	f000 fd64 	bl	c0de0b30 <mcu_usb_printf>
c0de0068:	e00b      	b.n	c0de0082 <main+0x82>
c0de006a:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de006c:	f000 ff04 	bl	c0de0e78 <os_sched_exit>
                if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de0070:	6820      	ldr	r0, [r4, #0]
c0de0072:	2183      	movs	r1, #131	; 0x83
c0de0074:	0049      	lsls	r1, r1, #1
c0de0076:	31f9      	adds	r1, #249	; 0xf9
c0de0078:	4288      	cmp	r0, r1
c0de007a:	d002      	beq.n	c0de0082 <main+0x82>
                    dispatch_plugin_calls(args[0], (void *) args[1]);
c0de007c:	6861      	ldr	r1, [r4, #4]
c0de007e:	f000 fce9 	bl	c0de0a54 <dispatch_plugin_calls>
        FINALLY {
c0de0082:	f000 ff0f 	bl	c0de0ea4 <try_context_get>
c0de0086:	4669      	mov	r1, sp
c0de0088:	4288      	cmp	r0, r1
c0de008a:	d102      	bne.n	c0de0092 <main+0x92>
c0de008c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de008e:	f000 ff11 	bl	c0de0eb4 <try_context_set>
            os_lib_end();
c0de0092:	f000 fee9 	bl	c0de0e68 <os_lib_end>
c0de0096:	46c0      	nop			; (mov r8, r8)
c0de0098:	00006502 	.word	0x00006502
c0de009c:	0000143f 	.word	0x0000143f

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
c0de0190:	f000 ff52 	bl	c0de1038 <__aeabi_memclr>
    // Copy and right-align the number
    memcpy((uint8_t *) n + INT256_LENGTH - value_len, value, value_len);
c0de0194:	1ba8      	subs	r0, r5, r6
c0de0196:	3020      	adds	r0, #32
c0de0198:	4639      	mov	r1, r7
c0de019a:	4632      	mov	r2, r6
c0de019c:	f000 ff52 	bl	c0de1044 <__aeabi_memcpy>

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
c0de01f6:	f000 fe69 	bl	c0de0ecc <__udivsi3>
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
c0de021a:	f001 f86b 	bl	c0de12f4 <strlcpy>
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
c0de0230:	f000 ff0c 	bl	c0de104c <__aeabi_memmove>
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
c0de0244:	00001244 	.word	0x00001244

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
c0de027a:	f000 fedd 	bl	c0de1038 <__aeabi_memclr>

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
c0de0296:	f001 f853 	bl	c0de1340 <strnlen>
c0de029a:	9001      	str	r0, [sp, #4]
c0de029c:	210b      	movs	r1, #11
    uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de029e:	9803      	ldr	r0, [sp, #12]
c0de02a0:	f001 f84e 	bl	c0de1340 <strnlen>
c0de02a4:	4604      	mov	r4, r0

    memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de02a6:	b2c7      	uxtb	r7, r0
c0de02a8:	42b7      	cmp	r7, r6
c0de02aa:	4632      	mov	r2, r6
c0de02ac:	d800      	bhi.n	c0de02b0 <amountToString+0x4a>
c0de02ae:	463a      	mov	r2, r7
c0de02b0:	4628      	mov	r0, r5
c0de02b2:	9903      	ldr	r1, [sp, #12]
c0de02b4:	f000 fec6 	bl	c0de1044 <__aeabi_memcpy>
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
c0de02ee:	f000 fbff 	bl	c0de0af0 <os_longjmp>
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
c0de031a:	f000 fea3 	bl	c0de1064 <memcmp>
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
c0de034c:	f000 fe8a 	bl	c0de1064 <memcmp>
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
c0de037c:	000011d3 	.word	0x000011d3
c0de0380:	00001384 	.word	0x00001384
c0de0384:	000011f7 	.word	0x000011f7
c0de0388:	00001352 	.word	0x00001352
c0de038c:	00001106 	.word	0x00001106

c0de0390 <printf_hex_array>:
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
}

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
c0de0390:	b570      	push	{r4, r5, r6, lr}
c0de0392:	460c      	mov	r4, r1
    PRINTF(title);
c0de0394:	f000 fbcc 	bl	c0de0b30 <mcu_usb_printf>
c0de0398:	2600      	movs	r6, #0
c0de039a:	4d07      	ldr	r5, [pc, #28]	; (c0de03b8 <printf_hex_array+0x28>)
c0de039c:	447d      	add	r5, pc
    for (size_t i = 0; i < len; ++i) {
c0de039e:	2e14      	cmp	r6, #20
c0de03a0:	d005      	beq.n	c0de03ae <printf_hex_array+0x1e>
        PRINTF("%02x", data[i]);
c0de03a2:	5da1      	ldrb	r1, [r4, r6]
c0de03a4:	4628      	mov	r0, r5
c0de03a6:	f000 fbc3 	bl	c0de0b30 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de03aa:	1c76      	adds	r6, r6, #1
c0de03ac:	e7f7      	b.n	c0de039e <printf_hex_array+0xe>
    };
    PRINTF("\n");
c0de03ae:	4803      	ldr	r0, [pc, #12]	; (c0de03bc <printf_hex_array+0x2c>)
c0de03b0:	4478      	add	r0, pc
c0de03b2:	f000 fbbd 	bl	c0de0b30 <mcu_usb_printf>
c0de03b6:	bd70      	pop	{r4, r5, r6, pc}
c0de03b8:	00001082 	.word	0x00001082
c0de03bc:	00001189 	.word	0x00001189

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
c0de03d2:	481f      	ldr	r0, [pc, #124]	; (c0de0450 <handle_init_contract+0x90>)
c0de03d4:	4478      	add	r0, pc
c0de03d6:	f000 fbab 	bl	c0de0b30 <mcu_usb_printf>
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
c0de03e6:	f000 fe27 	bl	c0de1038 <__aeabi_memclr>
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
c0de0404:	4a13      	ldr	r2, [pc, #76]	; (c0de0454 <handle_init_contract+0x94>)
c0de0406:	447a      	add	r2, pc
    for (selector_t i = 0; i < n; i++) {
c0de0408:	2906      	cmp	r1, #6
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
c0de041a:	2905      	cmp	r1, #5
c0de041c:	d8de      	bhi.n	c0de03dc <handle_init_contract+0x1c>
            *out = i;
c0de041e:	b2c8      	uxtb	r0, r1
    switch (context->selectorIndex) {
c0de0420:	2800      	cmp	r0, #0
c0de0422:	d00b      	beq.n	c0de043c <handle_init_contract+0x7c>
c0de0424:	2804      	cmp	r0, #4
c0de0426:	d007      	beq.n	c0de0438 <handle_init_contract+0x78>
c0de0428:	2802      	cmp	r0, #2
c0de042a:	d005      	beq.n	c0de0438 <handle_init_contract+0x78>
c0de042c:	2803      	cmp	r0, #3
c0de042e:	d001      	beq.n	c0de0434 <handle_init_contract+0x74>
c0de0430:	2801      	cmp	r0, #1
c0de0432:	d107      	bne.n	c0de0444 <handle_init_contract+0x84>
c0de0434:	2002      	movs	r0, #2
c0de0436:	e002      	b.n	c0de043e <handle_init_contract+0x7e>
c0de0438:	2000      	movs	r0, #0
c0de043a:	e000      	b.n	c0de043e <handle_init_contract+0x7e>
c0de043c:	2003      	movs	r0, #3
c0de043e:	7028      	strb	r0, [r5, #0]
c0de0440:	2604      	movs	r6, #4
c0de0442:	e7cb      	b.n	c0de03dc <handle_init_contract+0x1c>
            PRINTF("Missing selectorIndex: %d\n", context->selectorIndex);
c0de0444:	4804      	ldr	r0, [pc, #16]	; (c0de0458 <handle_init_contract+0x98>)
c0de0446:	4478      	add	r0, pc
c0de0448:	f000 fb72 	bl	c0de0b30 <mcu_usb_printf>
c0de044c:	e7c5      	b.n	c0de03da <handle_init_contract+0x1a>
c0de044e:	46c0      	nop			; (mov r8, r8)
c0de0450:	00000f94 	.word	0x00000f94
c0de0454:	00001232 	.word	0x00001232
c0de0458:	0000118b 	.word	0x0000118b

c0de045c <handle_provide_parameter>:
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
c0de045c:	b570      	push	{r4, r5, r6, lr}
c0de045e:	4605      	mov	r5, r0
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0460:	6884      	ldr	r4, [r0, #8]
    printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH, msg->parameter);
c0de0462:	68c2      	ldr	r2, [r0, #12]
c0de0464:	483b      	ldr	r0, [pc, #236]	; (c0de0554 <handle_provide_parameter+0xf8>)
c0de0466:	4478      	add	r0, pc
c0de0468:	2120      	movs	r1, #32
c0de046a:	f000 f881 	bl	c0de0570 <printf_hex_array>
c0de046e:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0470:	7528      	strb	r0, [r5, #20]
c0de0472:	2085      	movs	r0, #133	; 0x85

    switch (context->selectorIndex) {
c0de0474:	5c21      	ldrb	r1, [r4, r0]
c0de0476:	4626      	mov	r6, r4
c0de0478:	3684      	adds	r6, #132	; 0x84
c0de047a:	2904      	cmp	r1, #4
c0de047c:	d015      	beq.n	c0de04aa <handle_provide_parameter+0x4e>
c0de047e:	2901      	cmp	r1, #1
c0de0480:	d00b      	beq.n	c0de049a <handle_provide_parameter+0x3e>
c0de0482:	2902      	cmp	r1, #2
c0de0484:	d022      	beq.n	c0de04cc <handle_provide_parameter+0x70>
c0de0486:	2903      	cmp	r1, #3
c0de0488:	d007      	beq.n	c0de049a <handle_provide_parameter+0x3e>
c0de048a:	2900      	cmp	r1, #0
c0de048c:	d12c      	bne.n	c0de04e8 <handle_provide_parameter+0x8c>
    switch (context->next_param) {
c0de048e:	7831      	ldrb	r1, [r6, #0]
c0de0490:	2905      	cmp	r1, #5
c0de0492:	d043      	beq.n	c0de051c <handle_provide_parameter+0xc0>
            PRINTF("Param not supported: %d\n", context->next_param);
c0de0494:	4830      	ldr	r0, [pc, #192]	; (c0de0558 <handle_provide_parameter+0xfc>)
c0de0496:	4478      	add	r0, pc
c0de0498:	e028      	b.n	c0de04ec <handle_provide_parameter+0x90>
c0de049a:	7830      	ldrb	r0, [r6, #0]
c0de049c:	2805      	cmp	r0, #5
c0de049e:	d03d      	beq.n	c0de051c <handle_provide_parameter+0xc0>
c0de04a0:	2803      	cmp	r0, #3
c0de04a2:	d026      	beq.n	c0de04f2 <handle_provide_parameter+0x96>
c0de04a4:	2802      	cmp	r0, #2
c0de04a6:	d133      	bne.n	c0de0510 <handle_provide_parameter+0xb4>
c0de04a8:	e02b      	b.n	c0de0502 <handle_provide_parameter+0xa6>
    switch (context->next_param) {
c0de04aa:	7830      	ldrb	r0, [r6, #0]
c0de04ac:	2805      	cmp	r0, #5
c0de04ae:	d035      	beq.n	c0de051c <handle_provide_parameter+0xc0>
c0de04b0:	2801      	cmp	r0, #1
c0de04b2:	d034      	beq.n	c0de051e <handle_provide_parameter+0xc2>
c0de04b4:	2802      	cmp	r0, #2
c0de04b6:	d024      	beq.n	c0de0502 <handle_provide_parameter+0xa6>
c0de04b8:	2803      	cmp	r0, #3
c0de04ba:	d01a      	beq.n	c0de04f2 <handle_provide_parameter+0x96>
c0de04bc:	2800      	cmp	r0, #0
c0de04be:	d127      	bne.n	c0de0510 <handle_provide_parameter+0xb4>
            handle_token_sent(msg, context);
c0de04c0:	4628      	mov	r0, r5
c0de04c2:	4621      	mov	r1, r4
c0de04c4:	f000 f86e 	bl	c0de05a4 <handle_token_sent>
c0de04c8:	2001      	movs	r0, #1
c0de04ca:	e041      	b.n	c0de0550 <handle_provide_parameter+0xf4>
    switch (context->next_param) {
c0de04cc:	7830      	ldrb	r0, [r6, #0]
c0de04ce:	2805      	cmp	r0, #5
c0de04d0:	d024      	beq.n	c0de051c <handle_provide_parameter+0xc0>
c0de04d2:	2802      	cmp	r0, #2
c0de04d4:	d015      	beq.n	c0de0502 <handle_provide_parameter+0xa6>
c0de04d6:	2803      	cmp	r0, #3
c0de04d8:	d00b      	beq.n	c0de04f2 <handle_provide_parameter+0x96>
c0de04da:	2800      	cmp	r0, #0
c0de04dc:	d118      	bne.n	c0de0510 <handle_provide_parameter+0xb4>
            handle_token_sent(msg, context);
c0de04de:	4628      	mov	r0, r5
c0de04e0:	4621      	mov	r1, r4
c0de04e2:	f000 f85f 	bl	c0de05a4 <handle_token_sent>
c0de04e6:	e032      	b.n	c0de054e <handle_provide_parameter+0xf2>
        case CURVE_EXCHANGE: {
            handle_curve_exchange(msg, context);
            break;
        }
        default:
            PRINTF("Selector Index %d not supported\n", context->selectorIndex);
c0de04e8:	4820      	ldr	r0, [pc, #128]	; (c0de056c <handle_provide_parameter+0x110>)
c0de04ea:	4478      	add	r0, pc
c0de04ec:	f000 fb20 	bl	c0de0b30 <mcu_usb_printf>
c0de04f0:	e012      	b.n	c0de0518 <handle_provide_parameter+0xbc>
c0de04f2:	68e9      	ldr	r1, [r5, #12]
c0de04f4:	3420      	adds	r4, #32
c0de04f6:	2220      	movs	r2, #32
c0de04f8:	4620      	mov	r0, r4
c0de04fa:	f000 fda3 	bl	c0de1044 <__aeabi_memcpy>
c0de04fe:	2005      	movs	r0, #5
c0de0500:	e026      	b.n	c0de0550 <handle_provide_parameter+0xf4>
c0de0502:	68e9      	ldr	r1, [r5, #12]
c0de0504:	2220      	movs	r2, #32
c0de0506:	4620      	mov	r0, r4
c0de0508:	f000 fd9c 	bl	c0de1044 <__aeabi_memcpy>
c0de050c:	2003      	movs	r0, #3
c0de050e:	e01f      	b.n	c0de0550 <handle_provide_parameter+0xf4>
c0de0510:	4812      	ldr	r0, [pc, #72]	; (c0de055c <handle_provide_parameter+0x100>)
c0de0512:	4478      	add	r0, pc
c0de0514:	f000 fb0c 	bl	c0de0b30 <mcu_usb_printf>
c0de0518:	2000      	movs	r0, #0
c0de051a:	7528      	strb	r0, [r5, #20]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
c0de051c:	bd70      	pop	{r4, r5, r6, pc}
    memset(context->contract_address_received, 0, sizeof(context->contract_address_received));
c0de051e:	3454      	adds	r4, #84	; 0x54
c0de0520:	2114      	movs	r1, #20
c0de0522:	4620      	mov	r0, r4
c0de0524:	f000 fd88 	bl	c0de1038 <__aeabi_memclr>
        if (msg->parameter[PARAMETER_LENGTH-1] != 0) {
c0de0528:	68e8      	ldr	r0, [r5, #12]
c0de052a:	7fc0      	ldrb	r0, [r0, #31]
c0de052c:	2800      	cmp	r0, #0
c0de052e:	d002      	beq.n	c0de0536 <handle_provide_parameter+0xda>
            memcpy(context->contract_address_received,
c0de0530:	490b      	ldr	r1, [pc, #44]	; (c0de0560 <handle_provide_parameter+0x104>)
c0de0532:	4479      	add	r1, pc
c0de0534:	e001      	b.n	c0de053a <handle_provide_parameter+0xde>
            memcpy(context->contract_address_received,
c0de0536:	490b      	ldr	r1, [pc, #44]	; (c0de0564 <handle_provide_parameter+0x108>)
c0de0538:	4479      	add	r1, pc
c0de053a:	2214      	movs	r2, #20
c0de053c:	4620      	mov	r0, r4
c0de053e:	f000 fd81 	bl	c0de1044 <__aeabi_memcpy>
    printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH, context->contract_address_received);
c0de0542:	4809      	ldr	r0, [pc, #36]	; (c0de0568 <handle_provide_parameter+0x10c>)
c0de0544:	4478      	add	r0, pc
c0de0546:	2114      	movs	r1, #20
c0de0548:	4622      	mov	r2, r4
c0de054a:	f000 f811 	bl	c0de0570 <printf_hex_array>
c0de054e:	2002      	movs	r0, #2
c0de0550:	7030      	strb	r0, [r6, #0]
c0de0552:	bd70      	pop	{r4, r5, r6, pc}
c0de0554:	00000f48 	.word	0x00000f48
c0de0558:	00000fe4 	.word	0x00000fe4
c0de055c:	00000ebe 	.word	0x00000ebe
c0de0560:	0000111e 	.word	0x0000111e
c0de0564:	00001160 	.word	0x00001160
c0de0568:	00000ee4 	.word	0x00000ee4
c0de056c:	00001102 	.word	0x00001102

c0de0570 <printf_hex_array>:
                                    const uint8_t *data __attribute__((unused))) {
c0de0570:	b570      	push	{r4, r5, r6, lr}
c0de0572:	4614      	mov	r4, r2
c0de0574:	460d      	mov	r5, r1
    PRINTF(title);
c0de0576:	f000 fadb 	bl	c0de0b30 <mcu_usb_printf>
c0de057a:	4e08      	ldr	r6, [pc, #32]	; (c0de059c <printf_hex_array+0x2c>)
c0de057c:	447e      	add	r6, pc
    for (size_t i = 0; i < len; ++i) {
c0de057e:	2d00      	cmp	r5, #0
c0de0580:	d006      	beq.n	c0de0590 <printf_hex_array+0x20>
        PRINTF("%02x", data[i]);
c0de0582:	7821      	ldrb	r1, [r4, #0]
c0de0584:	4630      	mov	r0, r6
c0de0586:	f000 fad3 	bl	c0de0b30 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de058a:	1c64      	adds	r4, r4, #1
c0de058c:	1e6d      	subs	r5, r5, #1
c0de058e:	e7f6      	b.n	c0de057e <printf_hex_array+0xe>
    PRINTF("\n");
c0de0590:	4803      	ldr	r0, [pc, #12]	; (c0de05a0 <printf_hex_array+0x30>)
c0de0592:	4478      	add	r0, pc
c0de0594:	f000 facc 	bl	c0de0b30 <mcu_usb_printf>
c0de0598:	bd70      	pop	{r4, r5, r6, pc}
c0de059a:	46c0      	nop			; (mov r8, r8)
c0de059c:	00000ea2 	.word	0x00000ea2
c0de05a0:	00000fa7 	.word	0x00000fa7

c0de05a4 <handle_token_sent>:
static void handle_token_sent(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
c0de05a4:	b570      	push	{r4, r5, r6, lr}
c0de05a6:	460e      	mov	r6, r1
c0de05a8:	4605      	mov	r5, r0
    memset(context->contract_address_sent, 0, sizeof(context->contract_address_sent));
c0de05aa:	460c      	mov	r4, r1
c0de05ac:	3440      	adds	r4, #64	; 0x40
c0de05ae:	2114      	movs	r1, #20
c0de05b0:	4620      	mov	r0, r4
c0de05b2:	f000 fd41 	bl	c0de1038 <__aeabi_memclr>
    printf_hex_array("Incoming parameter: ", PARAMETER_LENGTH, msg->parameter);
c0de05b6:	68ea      	ldr	r2, [r5, #12]
c0de05b8:	4815      	ldr	r0, [pc, #84]	; (c0de0610 <handle_token_sent+0x6c>)
c0de05ba:	4478      	add	r0, pc
c0de05bc:	2120      	movs	r1, #32
c0de05be:	f7ff ffd7 	bl	c0de0570 <printf_hex_array>
c0de05c2:	2085      	movs	r0, #133	; 0x85
    if (context->selectorIndex == CURVE_EXCHANGE) {
c0de05c4:	5c30      	ldrb	r0, [r6, r0]
c0de05c6:	68e9      	ldr	r1, [r5, #12]
c0de05c8:	2804      	cmp	r0, #4
c0de05ca:	d108      	bne.n	c0de05de <handle_token_sent+0x3a>
        if (msg->parameter[PARAMETER_LENGTH-1] != 0) {
c0de05cc:	7fc8      	ldrb	r0, [r1, #31]
c0de05ce:	2800      	cmp	r0, #0
c0de05d0:	d009      	beq.n	c0de05e6 <handle_token_sent+0x42>
            printf_hex_array("OETH SELECTED: ",  ADDRESS_LENGTH, OETH_ADDRESS);
c0de05d2:	4810      	ldr	r0, [pc, #64]	; (c0de0614 <handle_token_sent+0x70>)
c0de05d4:	4478      	add	r0, pc
c0de05d6:	2514      	movs	r5, #20
c0de05d8:	4e0f      	ldr	r6, [pc, #60]	; (c0de0618 <handle_token_sent+0x74>)
c0de05da:	447e      	add	r6, pc
c0de05dc:	e008      	b.n	c0de05f0 <handle_token_sent+0x4c>
            &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de05de:	310c      	adds	r1, #12
c0de05e0:	2214      	movs	r2, #20
        memcpy(context->contract_address_sent,
c0de05e2:	4620      	mov	r0, r4
c0de05e4:	e00b      	b.n	c0de05fe <handle_token_sent+0x5a>
            printf_hex_array("ETH SELECTED: ",  ADDRESS_LENGTH, NULL_ETH_ADDRESS);
c0de05e6:	480d      	ldr	r0, [pc, #52]	; (c0de061c <handle_token_sent+0x78>)
c0de05e8:	4478      	add	r0, pc
c0de05ea:	2514      	movs	r5, #20
c0de05ec:	4e0c      	ldr	r6, [pc, #48]	; (c0de0620 <handle_token_sent+0x7c>)
c0de05ee:	447e      	add	r6, pc
c0de05f0:	4629      	mov	r1, r5
c0de05f2:	4632      	mov	r2, r6
c0de05f4:	f7ff ffbc 	bl	c0de0570 <printf_hex_array>
c0de05f8:	4620      	mov	r0, r4
c0de05fa:	4631      	mov	r1, r6
c0de05fc:	462a      	mov	r2, r5
c0de05fe:	f000 fd21 	bl	c0de1044 <__aeabi_memcpy>
    printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
c0de0602:	4808      	ldr	r0, [pc, #32]	; (c0de0624 <handle_token_sent+0x80>)
c0de0604:	4478      	add	r0, pc
c0de0606:	2114      	movs	r1, #20
c0de0608:	4622      	mov	r2, r4
c0de060a:	f7ff ffb1 	bl	c0de0570 <printf_hex_array>
}
c0de060e:	bd70      	pop	{r4, r5, r6, pc}
c0de0610:	00000fa2 	.word	0x00000fa2
c0de0614:	00001053 	.word	0x00001053
c0de0618:	00001076 	.word	0x00001076
c0de061c:	00000ece 	.word	0x00000ece
c0de0620:	000010aa 	.word	0x000010aa
c0de0624:	00000de1 	.word	0x00000de1

c0de0628 <handle_provide_token>:
#include "origin_defi_plugin.h"

// EDIT THIS: Adapt this function to your needs! Remember, the information for tokens are held in
// `msg->token1` and `msg->token2`. If those pointers are `NULL`, this means the ethereum app didn't
// find any info regarding the requested tokens!
void handle_provide_token(void *parameters) {
c0de0628:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de062a:	4604      	mov	r4, r0
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de062c:	6885      	ldr	r5, [r0, #8]
    PRINTF("OETH plugin provide token: 0x%p, 0x%p\n", msg->item1, msg->item2);
c0de062e:	68c1      	ldr	r1, [r0, #12]
c0de0630:	6902      	ldr	r2, [r0, #16]
c0de0632:	483a      	ldr	r0, [pc, #232]	; (c0de071c <handle_provide_token+0xf4>)
c0de0634:	4478      	add	r0, pc
c0de0636:	f000 fa7b 	bl	c0de0b30 <mcu_usb_printf>

    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de063a:	462e      	mov	r6, r5
c0de063c:	3640      	adds	r6, #64	; 0x40
c0de063e:	4938      	ldr	r1, [pc, #224]	; (c0de0720 <handle_provide_token+0xf8>)
c0de0640:	4479      	add	r1, pc
c0de0642:	2214      	movs	r2, #20
c0de0644:	4630      	mov	r0, r6
c0de0646:	f000 fd0d 	bl	c0de1064 <memcmp>
c0de064a:	462f      	mov	r7, r5
c0de064c:	377e      	adds	r7, #126	; 0x7e
c0de064e:	2800      	cmp	r0, #0
c0de0650:	d00b      	beq.n	c0de066a <handle_provide_token+0x42>
        sent_network_token(context);
    } else if (msg->item1 != NULL) {
c0de0652:	68e1      	ldr	r1, [r4, #12]
c0de0654:	2900      	cmp	r1, #0
c0de0656:	d024      	beq.n	c0de06a2 <handle_provide_token+0x7a>
        context->decimals_sent = msg->item1->token.decimals;
c0de0658:	7fc8      	ldrb	r0, [r1, #31]
c0de065a:	7078      	strb	r0, [r7, #1]
        strlcpy(context->ticker_sent,
c0de065c:	4628      	mov	r0, r5
c0de065e:	3068      	adds	r0, #104	; 0x68
        context->decimals_sent = msg->item1->token.decimals;
c0de0660:	3114      	adds	r1, #20
c0de0662:	220b      	movs	r2, #11
        strlcpy(context->ticker_sent,
c0de0664:	f000 fe46 	bl	c0de12f4 <strlcpy>
c0de0668:	e001      	b.n	c0de066e <handle_provide_token+0x46>
c0de066a:	2012      	movs	r0, #18
    context->decimals_sent = WEI_TO_ETHER;
c0de066c:	7078      	strb	r0, [r7, #1]
c0de066e:	7838      	ldrb	r0, [r7, #0]
c0de0670:	2101      	movs	r1, #1
c0de0672:	4301      	orrs	r1, r0
c0de0674:	7039      	strb	r1, [r7, #0]
        strlcpy(context->ticker_sent, DEFAULT_TICKER, sizeof(context->ticker_sent));
        // // We will need an additional screen to display a warning message.
        msg->additionalScreens++;
    }

    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0676:	462e      	mov	r6, r5
c0de0678:	3654      	adds	r6, #84	; 0x54
c0de067a:	492c      	ldr	r1, [pc, #176]	; (c0de072c <handle_provide_token+0x104>)
c0de067c:	4479      	add	r1, pc
c0de067e:	2214      	movs	r2, #20
c0de0680:	4630      	mov	r0, r6
c0de0682:	f000 fcef 	bl	c0de1064 <memcmp>
c0de0686:	2800      	cmp	r0, #0
c0de0688:	d035      	beq.n	c0de06f6 <handle_provide_token+0xce>
        received_network_token(context);
    } else if (msg->item2 != NULL) {
c0de068a:	6921      	ldr	r1, [r4, #16]
c0de068c:	2900      	cmp	r1, #0
c0de068e:	d01d      	beq.n	c0de06cc <handle_provide_token+0xa4>
        context->decimals_received = msg->item2->token.decimals;
c0de0690:	7fc8      	ldrb	r0, [r1, #31]
c0de0692:	70b8      	strb	r0, [r7, #2]
        strlcpy(context->ticker_received,
c0de0694:	3573      	adds	r5, #115	; 0x73
        context->decimals_received = msg->item2->token.decimals;
c0de0696:	3114      	adds	r1, #20
c0de0698:	220b      	movs	r2, #11
        strlcpy(context->ticker_received,
c0de069a:	4628      	mov	r0, r5
c0de069c:	f000 fe2a 	bl	c0de12f4 <strlcpy>
c0de06a0:	e02b      	b.n	c0de06fa <handle_provide_token+0xd2>
    } else if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de06a2:	4920      	ldr	r1, [pc, #128]	; (c0de0724 <handle_provide_token+0xfc>)
c0de06a4:	4479      	add	r1, pc
c0de06a6:	2214      	movs	r2, #20
c0de06a8:	4630      	mov	r0, r6
c0de06aa:	f000 fcdb 	bl	c0de1064 <memcmp>
c0de06ae:	2112      	movs	r1, #18
c0de06b0:	7079      	strb	r1, [r7, #1]
c0de06b2:	2800      	cmp	r0, #0
c0de06b4:	d0db      	beq.n	c0de066e <handle_provide_token+0x46>
        strlcpy(context->ticker_sent, DEFAULT_TICKER, sizeof(context->ticker_sent));
c0de06b6:	4628      	mov	r0, r5
c0de06b8:	3068      	adds	r0, #104	; 0x68
c0de06ba:	491b      	ldr	r1, [pc, #108]	; (c0de0728 <handle_provide_token+0x100>)
c0de06bc:	4479      	add	r1, pc
c0de06be:	220b      	movs	r2, #11
c0de06c0:	f000 fe18 	bl	c0de12f4 <strlcpy>
        msg->additionalScreens++;
c0de06c4:	7d20      	ldrb	r0, [r4, #20]
c0de06c6:	1c40      	adds	r0, r0, #1
c0de06c8:	7520      	strb	r0, [r4, #20]
c0de06ca:	e7d4      	b.n	c0de0676 <handle_provide_token+0x4e>
                (char *) msg->item2->token.ticker,
                sizeof(context->ticker_received));
        context->tokens_found |= TOKEN_RECEIVED_FOUND;
    } else if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de06cc:	4918      	ldr	r1, [pc, #96]	; (c0de0730 <handle_provide_token+0x108>)
c0de06ce:	4479      	add	r1, pc
c0de06d0:	2214      	movs	r2, #20
c0de06d2:	4630      	mov	r0, r6
c0de06d4:	f000 fcc6 	bl	c0de1064 <memcmp>
c0de06d8:	2800      	cmp	r0, #0
c0de06da:	d00c      	beq.n	c0de06f6 <handle_provide_token+0xce>
c0de06dc:	2012      	movs	r0, #18
c0de06de:	70b8      	strb	r0, [r7, #2]
c0de06e0:	3573      	adds	r5, #115	; 0x73
        received_oeth(context);
    } else if (context->selectorIndex == VAULT_REDEEM) {
c0de06e2:	79f8      	ldrb	r0, [r7, #7]
c0de06e4:	2803      	cmp	r0, #3
c0de06e6:	d10f      	bne.n	c0de0708 <handle_provide_token+0xe0>
        context->decimals_received = DEFAULT_DECIMAL;
        strlcpy(context->ticker_received, "UNITS", sizeof(context->ticker_received));
c0de06e8:	4912      	ldr	r1, [pc, #72]	; (c0de0734 <handle_provide_token+0x10c>)
c0de06ea:	4479      	add	r1, pc
c0de06ec:	220b      	movs	r2, #11
c0de06ee:	4628      	mov	r0, r5
c0de06f0:	f000 fe00 	bl	c0de12f4 <strlcpy>
c0de06f4:	e005      	b.n	c0de0702 <handle_provide_token+0xda>
c0de06f6:	2012      	movs	r0, #18
c0de06f8:	70b8      	strb	r0, [r7, #2]
c0de06fa:	7838      	ldrb	r0, [r7, #0]
c0de06fc:	2102      	movs	r1, #2
c0de06fe:	4301      	orrs	r1, r0
c0de0700:	7039      	strb	r1, [r7, #0]
c0de0702:	2004      	movs	r0, #4
        strlcpy(context->ticker_received, DEFAULT_TICKER, sizeof(context->ticker_received));
        // // We will need an additional screen to display a warning message.
        msg->additionalScreens++;
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0704:	7560      	strb	r0, [r4, #21]
c0de0706:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
        strlcpy(context->ticker_received, DEFAULT_TICKER, sizeof(context->ticker_received));
c0de0708:	490b      	ldr	r1, [pc, #44]	; (c0de0738 <handle_provide_token+0x110>)
c0de070a:	4479      	add	r1, pc
c0de070c:	220b      	movs	r2, #11
c0de070e:	4628      	mov	r0, r5
c0de0710:	f000 fdf0 	bl	c0de12f4 <strlcpy>
        msg->additionalScreens++;
c0de0714:	7d20      	ldrb	r0, [r4, #20]
c0de0716:	1c40      	adds	r0, r0, #1
c0de0718:	7520      	strb	r0, [r4, #20]
c0de071a:	e7f2      	b.n	c0de0702 <handle_provide_token+0xda>
c0de071c:	00000dbe 	.word	0x00000dbe
c0de0720:	00001058 	.word	0x00001058
c0de0724:	00000fac 	.word	0x00000fac
c0de0728:	00000ec6 	.word	0x00000ec6
c0de072c:	0000101c 	.word	0x0000101c
c0de0730:	00000f82 	.word	0x00000f82
c0de0734:	00000ed9 	.word	0x00000ed9
c0de0738:	00000e78 	.word	0x00000e78

c0de073c <handle_query_contract_id>:
#include "origin_defi_plugin.h"

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de073c:	b5b0      	push	{r4, r5, r7, lr}
c0de073e:	4604      	mov	r4, r0
    ethQueryContractID_t *msg = (ethQueryContractID_t *) parameters;
    const origin_defi_parameters_t *context = (const origin_defi_parameters_t *) msg->pluginContext;
c0de0740:	6885      	ldr	r5, [r0, #8]
    // msg->name will be the upper sentence displayed on the screen.
    // msg->version will be the lower sentence displayed on the screen.

    // For the first screen, display the plugin name.
    strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de0742:	68c0      	ldr	r0, [r0, #12]
c0de0744:	6922      	ldr	r2, [r4, #16]
c0de0746:	4910      	ldr	r1, [pc, #64]	; (c0de0788 <handle_query_contract_id+0x4c>)
c0de0748:	4479      	add	r1, pc
c0de074a:	f000 fdd3 	bl	c0de12f4 <strlcpy>
c0de074e:	2085      	movs	r0, #133	; 0x85

    switch (context->selectorIndex) {
c0de0750:	5c29      	ldrb	r1, [r5, r0]
c0de0752:	2903      	cmp	r1, #3
c0de0754:	d202      	bcs.n	c0de075c <handle_query_contract_id+0x20>
c0de0756:	490d      	ldr	r1, [pc, #52]	; (c0de078c <handle_query_contract_id+0x50>)
c0de0758:	4479      	add	r1, pc
c0de075a:	e008      	b.n	c0de076e <handle_query_contract_id+0x32>
c0de075c:	2904      	cmp	r1, #4
c0de075e:	d004      	beq.n	c0de076a <handle_query_contract_id+0x2e>
c0de0760:	2903      	cmp	r1, #3
c0de0762:	d10b      	bne.n	c0de077c <handle_query_contract_id+0x40>
c0de0764:	490a      	ldr	r1, [pc, #40]	; (c0de0790 <handle_query_contract_id+0x54>)
c0de0766:	4479      	add	r1, pc
c0de0768:	e001      	b.n	c0de076e <handle_query_contract_id+0x32>
c0de076a:	490b      	ldr	r1, [pc, #44]	; (c0de0798 <handle_query_contract_id+0x5c>)
c0de076c:	4479      	add	r1, pc
c0de076e:	6960      	ldr	r0, [r4, #20]
c0de0770:	69a2      	ldr	r2, [r4, #24]
c0de0772:	f000 fdbf 	bl	c0de12f4 <strlcpy>
c0de0776:	2004      	movs	r0, #4
c0de0778:	7720      	strb	r0, [r4, #28]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de077a:	bdb0      	pop	{r4, r5, r7, pc}
            PRINTF("Selector Index :%d not supported\n", context->selectorIndex);
c0de077c:	4805      	ldr	r0, [pc, #20]	; (c0de0794 <handle_query_contract_id+0x58>)
c0de077e:	4478      	add	r0, pc
c0de0780:	f000 f9d6 	bl	c0de0b30 <mcu_usb_printf>
c0de0784:	2000      	movs	r0, #0
c0de0786:	e7f7      	b.n	c0de0778 <handle_query_contract_id+0x3c>
c0de0788:	00000cf6 	.word	0x00000cf6
c0de078c:	00000cc1 	.word	0x00000cc1
c0de0790:	00000ce4 	.word	0x00000ce4
c0de0794:	00000e05 	.word	0x00000e05
c0de0798:	00000cb7 	.word	0x00000cb7

c0de079c <handle_query_contract_ui>:
            break;
    }
    return ERROR;
}

void handle_query_contract_ui(void *parameters) {
c0de079c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de079e:	b085      	sub	sp, #20
c0de07a0:	4604      	mov	r4, r0
    ethQueryContractUI_t *msg = (ethQueryContractUI_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de07a2:	69c5      	ldr	r5, [r0, #28]
    memset(msg->title, 0, msg->titleLength);
c0de07a4:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de07a6:	6aa1      	ldr	r1, [r4, #40]	; 0x28
c0de07a8:	f000 fc46 	bl	c0de1038 <__aeabi_memclr>
    memset(msg->msg, 0, msg->msgLength);
c0de07ac:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de07ae:	6b21      	ldr	r1, [r4, #48]	; 0x30
c0de07b0:	f000 fc42 	bl	c0de1038 <__aeabi_memclr>
c0de07b4:	4627      	mov	r7, r4
c0de07b6:	3720      	adds	r7, #32
c0de07b8:	2004      	movs	r0, #4
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de07ba:	7538      	strb	r0, [r7, #20]
c0de07bc:	2020      	movs	r0, #32
    uint8_t index = msg->screenIndex;
c0de07be:	5c26      	ldrb	r6, [r4, r0]
c0de07c0:	207e      	movs	r0, #126	; 0x7e
c0de07c2:	9504      	str	r5, [sp, #16]
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de07c4:	5c28      	ldrb	r0, [r5, r0]
c0de07c6:	2103      	movs	r1, #3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de07c8:	4001      	ands	r1, r0
c0de07ca:	2302      	movs	r3, #2
    bool token_received_found = context->tokens_found & TOKEN_RECEIVED_FOUND;
c0de07cc:	4605      	mov	r5, r0
c0de07ce:	401d      	ands	r5, r3
c0de07d0:	2201      	movs	r2, #1
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de07d2:	4002      	ands	r2, r0
    switch (index) {
c0de07d4:	2e01      	cmp	r6, #1
c0de07d6:	d015      	beq.n	c0de0804 <handle_query_contract_ui+0x68>
c0de07d8:	2e00      	cmp	r6, #0
c0de07da:	d124      	bne.n	c0de0826 <handle_query_contract_ui+0x8a>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de07dc:	4248      	negs	r0, r1
c0de07de:	4148      	adcs	r0, r1
    bool both_tokens_found = token_received_found && token_sent_found;
c0de07e0:	1ece      	subs	r6, r1, #3
c0de07e2:	4271      	negs	r1, r6
c0de07e4:	4171      	adcs	r1, r6
            if (both_tokens_found) {
c0de07e6:	4301      	orrs	r1, r0
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de07e8:	1e50      	subs	r0, r2, #1
c0de07ea:	4182      	sbcs	r2, r0
            if (both_tokens_found) {
c0de07ec:	430a      	orrs	r2, r1
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de07ee:	1e70      	subs	r0, r6, #1
c0de07f0:	4186      	sbcs	r6, r0
            if (both_tokens_found) {
c0de07f2:	2900      	cmp	r1, #0
c0de07f4:	d000      	beq.n	c0de07f8 <handle_query_contract_ui+0x5c>
c0de07f6:	0071      	lsls	r1, r6, #1
c0de07f8:	2a00      	cmp	r2, #0
c0de07fa:	d100      	bne.n	c0de07fe <handle_query_contract_ui+0x62>
c0de07fc:	4619      	mov	r1, r3
c0de07fe:	2a00      	cmp	r2, #0
c0de0800:	d00f      	beq.n	c0de0822 <handle_query_contract_ui+0x86>
c0de0802:	e018      	b.n	c0de0836 <handle_query_contract_ui+0x9a>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0804:	424b      	negs	r3, r1
c0de0806:	414b      	adcs	r3, r1
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0808:	1ec8      	subs	r0, r1, #3
c0de080a:	4241      	negs	r1, r0
c0de080c:	4141      	adcs	r1, r0
            if (both_tokens_found) {
c0de080e:	430b      	orrs	r3, r1
c0de0810:	d100      	bne.n	c0de0814 <handle_query_contract_ui+0x78>
c0de0812:	2102      	movs	r1, #2
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0814:	1e50      	subs	r0, r2, #1
c0de0816:	4182      	sbcs	r2, r0
            if (both_tokens_found) {
c0de0818:	4313      	orrs	r3, r2
c0de081a:	d100      	bne.n	c0de081e <handle_query_contract_ui+0x82>
c0de081c:	4619      	mov	r1, r3
c0de081e:	2b00      	cmp	r3, #0
c0de0820:	d109      	bne.n	c0de0836 <handle_query_contract_ui+0x9a>
c0de0822:	2d00      	cmp	r5, #0
c0de0824:	d107      	bne.n	c0de0836 <handle_query_contract_ui+0x9a>
            break;
        case WARN_SCREEN:
            set_warning_ui(msg, context);
            break;
        default:
            PRINTF("Received an invalid screenIndex\n");
c0de0826:	488a      	ldr	r0, [pc, #552]	; (c0de0a50 <handle_query_contract_ui+0x2b4>)
c0de0828:	4478      	add	r0, pc
c0de082a:	f000 f981 	bl	c0de0b30 <mcu_usb_printf>
c0de082e:	2000      	movs	r0, #0
c0de0830:	7538      	strb	r0, [r7, #20]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }
}
c0de0832:	b005      	add	sp, #20
c0de0834:	bdf0      	pop	{r4, r5, r6, r7, pc}
    switch (screen) {
c0de0836:	2902      	cmp	r1, #2
c0de0838:	d067      	beq.n	c0de090a <handle_query_contract_ui+0x16e>
c0de083a:	9d04      	ldr	r5, [sp, #16]
c0de083c:	4628      	mov	r0, r5
c0de083e:	307e      	adds	r0, #126	; 0x7e
c0de0840:	2901      	cmp	r1, #1
c0de0842:	d032      	beq.n	c0de08aa <handle_query_contract_ui+0x10e>
c0de0844:	2900      	cmp	r1, #0
c0de0846:	d1ee      	bne.n	c0de0826 <handle_query_contract_ui+0x8a>
c0de0848:	4605      	mov	r5, r0
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de084a:	9e04      	ldr	r6, [sp, #16]
c0de084c:	3640      	adds	r6, #64	; 0x40
c0de084e:	4968      	ldr	r1, [pc, #416]	; (c0de09f0 <handle_query_contract_ui+0x254>)
c0de0850:	4479      	add	r1, pc
c0de0852:	2214      	movs	r2, #20
c0de0854:	4630      	mov	r0, r6
c0de0856:	f000 fc05 	bl	c0de1064 <memcmp>
c0de085a:	2800      	cmp	r0, #0
c0de085c:	d106      	bne.n	c0de086c <handle_query_contract_ui+0xd0>
        strlcpy(context->ticker_sent, msg->network_ticker, sizeof(context->ticker_sent));
c0de085e:	9804      	ldr	r0, [sp, #16]
c0de0860:	3068      	adds	r0, #104	; 0x68
c0de0862:	4621      	mov	r1, r4
c0de0864:	3110      	adds	r1, #16
c0de0866:	220b      	movs	r2, #11
c0de0868:	f000 fd44 	bl	c0de12f4 <strlcpy>
    if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de086c:	4961      	ldr	r1, [pc, #388]	; (c0de09f4 <handle_query_contract_ui+0x258>)
c0de086e:	4479      	add	r1, pc
c0de0870:	2214      	movs	r2, #20
c0de0872:	4630      	mov	r0, r6
c0de0874:	f000 fbf6 	bl	c0de1064 <memcmp>
c0de0878:	2800      	cmp	r0, #0
c0de087a:	d106      	bne.n	c0de088a <handle_query_contract_ui+0xee>
        strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de087c:	9804      	ldr	r0, [sp, #16]
c0de087e:	3068      	adds	r0, #104	; 0x68
c0de0880:	495d      	ldr	r1, [pc, #372]	; (c0de09f8 <handle_query_contract_ui+0x25c>)
c0de0882:	4479      	add	r1, pc
c0de0884:	220b      	movs	r2, #11
c0de0886:	f000 fd35 	bl	c0de12f4 <strlcpy>
    switch (context->selectorIndex) {
c0de088a:	79e9      	ldrb	r1, [r5, #7]
c0de088c:	2904      	cmp	r1, #4
c0de088e:	d056      	beq.n	c0de093e <handle_query_contract_ui+0x1a2>
c0de0890:	2901      	cmp	r1, #1
c0de0892:	d059      	beq.n	c0de0948 <handle_query_contract_ui+0x1ac>
c0de0894:	2902      	cmp	r1, #2
c0de0896:	d003      	beq.n	c0de08a0 <handle_query_contract_ui+0x104>
c0de0898:	2903      	cmp	r1, #3
c0de089a:	d060      	beq.n	c0de095e <handle_query_contract_ui+0x1c2>
c0de089c:	2900      	cmp	r1, #0
c0de089e:	d149      	bne.n	c0de0934 <handle_query_contract_ui+0x198>
c0de08a0:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de08a2:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de08a4:	4955      	ldr	r1, [pc, #340]	; (c0de09fc <handle_query_contract_ui+0x260>)
c0de08a6:	4479      	add	r1, pc
c0de08a8:	e08f      	b.n	c0de09ca <handle_query_contract_ui+0x22e>
c0de08aa:	9003      	str	r0, [sp, #12]
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de08ac:	462e      	mov	r6, r5
c0de08ae:	3654      	adds	r6, #84	; 0x54
c0de08b0:	495b      	ldr	r1, [pc, #364]	; (c0de0a20 <handle_query_contract_ui+0x284>)
c0de08b2:	4479      	add	r1, pc
c0de08b4:	2214      	movs	r2, #20
c0de08b6:	4630      	mov	r0, r6
c0de08b8:	f000 fbd4 	bl	c0de1064 <memcmp>
c0de08bc:	2800      	cmp	r0, #0
c0de08be:	d106      	bne.n	c0de08ce <handle_query_contract_ui+0x132>
        strlcpy(context->ticker_received, msg->network_ticker, sizeof(context->ticker_received));
c0de08c0:	4628      	mov	r0, r5
c0de08c2:	3073      	adds	r0, #115	; 0x73
c0de08c4:	4621      	mov	r1, r4
c0de08c6:	3110      	adds	r1, #16
c0de08c8:	220b      	movs	r2, #11
c0de08ca:	f000 fd13 	bl	c0de12f4 <strlcpy>
    if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de08ce:	4955      	ldr	r1, [pc, #340]	; (c0de0a24 <handle_query_contract_ui+0x288>)
c0de08d0:	4479      	add	r1, pc
c0de08d2:	2214      	movs	r2, #20
c0de08d4:	4630      	mov	r0, r6
c0de08d6:	f000 fbc5 	bl	c0de1064 <memcmp>
c0de08da:	2800      	cmp	r0, #0
c0de08dc:	d106      	bne.n	c0de08ec <handle_query_contract_ui+0x150>
        strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de08de:	4628      	mov	r0, r5
c0de08e0:	3073      	adds	r0, #115	; 0x73
c0de08e2:	4951      	ldr	r1, [pc, #324]	; (c0de0a28 <handle_query_contract_ui+0x28c>)
c0de08e4:	4479      	add	r1, pc
c0de08e6:	220b      	movs	r2, #11
c0de08e8:	f000 fd04 	bl	c0de12f4 <strlcpy>
c0de08ec:	9e03      	ldr	r6, [sp, #12]
    switch (context->selectorIndex) {
c0de08ee:	79f1      	ldrb	r1, [r6, #7]
c0de08f0:	2903      	cmp	r1, #3
c0de08f2:	d217      	bcs.n	c0de0924 <handle_query_contract_ui+0x188>
            strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de08f4:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de08f6:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de08f8:	494e      	ldr	r1, [pc, #312]	; (c0de0a34 <handle_query_contract_ui+0x298>)
c0de08fa:	4479      	add	r1, pc
c0de08fc:	f000 fcfa 	bl	c0de12f4 <strlcpy>
            strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de0900:	4628      	mov	r0, r5
c0de0902:	3073      	adds	r0, #115	; 0x73
c0de0904:	494c      	ldr	r1, [pc, #304]	; (c0de0a38 <handle_query_contract_ui+0x29c>)
c0de0906:	4479      	add	r1, pc
c0de0908:	e049      	b.n	c0de099e <handle_query_contract_ui+0x202>
    strlcpy(msg->title, "WARNING", msg->titleLength);
c0de090a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de090c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de090e:	494e      	ldr	r1, [pc, #312]	; (c0de0a48 <handle_query_contract_ui+0x2ac>)
c0de0910:	4479      	add	r1, pc
c0de0912:	f000 fcef 	bl	c0de12f4 <strlcpy>
    strlcpy(msg->msg, "Unknown token", msg->msgLength);
c0de0916:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0918:	6b22      	ldr	r2, [r4, #48]	; 0x30
c0de091a:	494c      	ldr	r1, [pc, #304]	; (c0de0a4c <handle_query_contract_ui+0x2b0>)
c0de091c:	4479      	add	r1, pc
c0de091e:	f000 fce9 	bl	c0de12f4 <strlcpy>
c0de0922:	e786      	b.n	c0de0832 <handle_query_contract_ui+0x96>
    switch (context->selectorIndex) {
c0de0924:	d031      	beq.n	c0de098a <handle_query_contract_ui+0x1ee>
c0de0926:	2904      	cmp	r1, #4
c0de0928:	d104      	bne.n	c0de0934 <handle_query_contract_ui+0x198>
            strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de092a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de092c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de092e:	493f      	ldr	r1, [pc, #252]	; (c0de0a2c <handle_query_contract_ui+0x290>)
c0de0930:	4479      	add	r1, pc
c0de0932:	e035      	b.n	c0de09a0 <handle_query_contract_ui+0x204>
c0de0934:	4843      	ldr	r0, [pc, #268]	; (c0de0a44 <handle_query_contract_ui+0x2a8>)
c0de0936:	4478      	add	r0, pc
c0de0938:	f000 f8fa 	bl	c0de0b30 <mcu_usb_printf>
c0de093c:	e777      	b.n	c0de082e <handle_query_contract_ui+0x92>
            strlcpy(msg->title, "Send", msg->titleLength);
c0de093e:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0940:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0942:	4935      	ldr	r1, [pc, #212]	; (c0de0a18 <handle_query_contract_ui+0x27c>)
c0de0944:	4479      	add	r1, pc
c0de0946:	e040      	b.n	c0de09ca <handle_query_contract_ui+0x22e>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de0948:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de094a:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de094c:	492c      	ldr	r1, [pc, #176]	; (c0de0a00 <handle_query_contract_ui+0x264>)
c0de094e:	4479      	add	r1, pc
c0de0950:	f000 fcd0 	bl	c0de12f4 <strlcpy>
            strlcpy(context->ticker_sent, SFRXETH_TICKER, sizeof(context->ticker_sent));
c0de0954:	9804      	ldr	r0, [sp, #16]
c0de0956:	3068      	adds	r0, #104	; 0x68
c0de0958:	492a      	ldr	r1, [pc, #168]	; (c0de0a04 <handle_query_contract_ui+0x268>)
c0de095a:	4479      	add	r1, pc
c0de095c:	e034      	b.n	c0de09c8 <handle_query_contract_ui+0x22c>
            strlcpy(msg->title, "Redeem", msg->titleLength);
c0de095e:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0960:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0962:	4929      	ldr	r1, [pc, #164]	; (c0de0a08 <handle_query_contract_ui+0x26c>)
c0de0964:	4479      	add	r1, pc
c0de0966:	f000 fcc5 	bl	c0de12f4 <strlcpy>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de096a:	6860      	ldr	r0, [r4, #4]
c0de096c:	6801      	ldr	r1, [r0, #0]
c0de096e:	31a5      	adds	r1, #165	; 0xa5
c0de0970:	4826      	ldr	r0, [pc, #152]	; (c0de0a0c <handle_query_contract_ui+0x270>)
c0de0972:	4478      	add	r0, pc
c0de0974:	2214      	movs	r2, #20
c0de0976:	f000 fb75 	bl	c0de1064 <memcmp>
c0de097a:	4601      	mov	r1, r0
c0de097c:	9804      	ldr	r0, [sp, #16]
c0de097e:	3068      	adds	r0, #104	; 0x68
c0de0980:	2900      	cmp	r1, #0
c0de0982:	d01f      	beq.n	c0de09c4 <handle_query_contract_ui+0x228>
                strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de0984:	4923      	ldr	r1, [pc, #140]	; (c0de0a14 <handle_query_contract_ui+0x278>)
c0de0986:	4479      	add	r1, pc
c0de0988:	e01e      	b.n	c0de09c8 <handle_query_contract_ui+0x22c>
            strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de098a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de098c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de098e:	492b      	ldr	r1, [pc, #172]	; (c0de0a3c <handle_query_contract_ui+0x2a0>)
c0de0990:	4479      	add	r1, pc
c0de0992:	f000 fcaf 	bl	c0de12f4 <strlcpy>
            strlcpy(context->ticker_received, ETH_UNITS_TICKER, sizeof(context->ticker_received));
c0de0996:	4628      	mov	r0, r5
c0de0998:	3073      	adds	r0, #115	; 0x73
c0de099a:	4929      	ldr	r1, [pc, #164]	; (c0de0a40 <handle_query_contract_ui+0x2a4>)
c0de099c:	4479      	add	r1, pc
c0de099e:	220b      	movs	r2, #11
c0de09a0:	f000 fca8 	bl	c0de12f4 <strlcpy>
                   context->decimals_received,
c0de09a4:	78b2      	ldrb	r2, [r6, #2]
                   msg->msg,
c0de09a6:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de09a8:	6b21      	ldr	r1, [r4, #48]	; 0x30
    amountToString(context->min_amount_received,
c0de09aa:	9000      	str	r0, [sp, #0]
c0de09ac:	9101      	str	r1, [sp, #4]
c0de09ae:	4628      	mov	r0, r5
c0de09b0:	3020      	adds	r0, #32
                   context->ticker_received,
c0de09b2:	3573      	adds	r5, #115	; 0x73
c0de09b4:	2120      	movs	r1, #32
    amountToString(context->min_amount_received,
c0de09b6:	462b      	mov	r3, r5
c0de09b8:	f7ff fc55 	bl	c0de0266 <amountToString>
    PRINTF("AMOUNT RECEIVED: %s\n", msg->msg);
c0de09bc:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de09be:	481c      	ldr	r0, [pc, #112]	; (c0de0a30 <handle_query_contract_ui+0x294>)
c0de09c0:	4478      	add	r0, pc
c0de09c2:	e012      	b.n	c0de09ea <handle_query_contract_ui+0x24e>
                strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de09c4:	4912      	ldr	r1, [pc, #72]	; (c0de0a10 <handle_query_contract_ui+0x274>)
c0de09c6:	4479      	add	r1, pc
c0de09c8:	220b      	movs	r2, #11
c0de09ca:	f000 fc93 	bl	c0de12f4 <strlcpy>
                   context->decimals_sent,
c0de09ce:	786a      	ldrb	r2, [r5, #1]
                   msg->msg,
c0de09d0:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de09d2:	6b21      	ldr	r1, [r4, #48]	; 0x30
    amountToString(context->amount_sent,
c0de09d4:	9000      	str	r0, [sp, #0]
c0de09d6:	9101      	str	r1, [sp, #4]
c0de09d8:	9804      	ldr	r0, [sp, #16]
                   context->ticker_sent,
c0de09da:	4603      	mov	r3, r0
c0de09dc:	3368      	adds	r3, #104	; 0x68
c0de09de:	2120      	movs	r1, #32
    amountToString(context->amount_sent,
c0de09e0:	f7ff fc41 	bl	c0de0266 <amountToString>
    PRINTF("AMOUNT SENT: %s\n", msg->msg);
c0de09e4:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de09e6:	480d      	ldr	r0, [pc, #52]	; (c0de0a1c <handle_query_contract_ui+0x280>)
c0de09e8:	4478      	add	r0, pc
c0de09ea:	f000 f8a1 	bl	c0de0b30 <mcu_usb_printf>
c0de09ee:	e720      	b.n	c0de0832 <handle_query_contract_ui+0x96>
c0de09f0:	00000e48 	.word	0x00000e48
c0de09f4:	00000de2 	.word	0x00000de2
c0de09f8:	00000d8b 	.word	0x00000d8b
c0de09fc:	00000d23 	.word	0x00000d23
c0de0a00:	00000c7b 	.word	0x00000c7b
c0de0a04:	00000b6b 	.word	0x00000b6b
c0de0a08:	00000ae6 	.word	0x00000ae6
c0de0a0c:	00000cf2 	.word	0x00000cf2
c0de0a10:	00000c47 	.word	0x00000c47
c0de0a14:	00000ab3 	.word	0x00000ab3
c0de0a18:	00000a5d 	.word	0x00000a5d
c0de0a1c:	00000b89 	.word	0x00000b89
c0de0a20:	00000de6 	.word	0x00000de6
c0de0a24:	00000d80 	.word	0x00000d80
c0de0a28:	00000d29 	.word	0x00000d29
c0de0a2c:	00000b63 	.word	0x00000b63
c0de0a30:	00000c52 	.word	0x00000c52
c0de0a34:	00000b99 	.word	0x00000b99
c0de0a38:	00000d07 	.word	0x00000d07
c0de0a3c:	00000b03 	.word	0x00000b03
c0de0a40:	00000c27 	.word	0x00000c27
c0de0a44:	00000c6f 	.word	0x00000c6f
c0de0a48:	00000a96 	.word	0x00000a96
c0de0a4c:	00000bb1 	.word	0x00000bb1
c0de0a50:	00000d13 	.word	0x00000d13

c0de0a54 <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de0a54:	b580      	push	{r7, lr}
c0de0a56:	4602      	mov	r2, r0
c0de0a58:	2083      	movs	r0, #131	; 0x83
c0de0a5a:	0040      	lsls	r0, r0, #1
    switch (message) {
c0de0a5c:	4282      	cmp	r2, r0
c0de0a5e:	d017      	beq.n	c0de0a90 <dispatch_plugin_calls+0x3c>
c0de0a60:	2081      	movs	r0, #129	; 0x81
c0de0a62:	0040      	lsls	r0, r0, #1
c0de0a64:	4282      	cmp	r2, r0
c0de0a66:	d017      	beq.n	c0de0a98 <dispatch_plugin_calls+0x44>
c0de0a68:	20ff      	movs	r0, #255	; 0xff
c0de0a6a:	4603      	mov	r3, r0
c0de0a6c:	3304      	adds	r3, #4
c0de0a6e:	429a      	cmp	r2, r3
c0de0a70:	d016      	beq.n	c0de0aa0 <dispatch_plugin_calls+0x4c>
c0de0a72:	2341      	movs	r3, #65	; 0x41
c0de0a74:	009b      	lsls	r3, r3, #2
c0de0a76:	429a      	cmp	r2, r3
c0de0a78:	d016      	beq.n	c0de0aa8 <dispatch_plugin_calls+0x54>
c0de0a7a:	4603      	mov	r3, r0
c0de0a7c:	3306      	adds	r3, #6
c0de0a7e:	429a      	cmp	r2, r3
c0de0a80:	d016      	beq.n	c0de0ab0 <dispatch_plugin_calls+0x5c>
c0de0a82:	3002      	adds	r0, #2
c0de0a84:	4282      	cmp	r2, r0
c0de0a86:	d117      	bne.n	c0de0ab8 <dispatch_plugin_calls+0x64>
            handle_init_contract(parameters);
c0de0a88:	4608      	mov	r0, r1
c0de0a8a:	f7ff fc99 	bl	c0de03c0 <handle_init_contract>
}
c0de0a8e:	bd80      	pop	{r7, pc}
            handle_query_contract_ui(parameters);
c0de0a90:	4608      	mov	r0, r1
c0de0a92:	f7ff fe83 	bl	c0de079c <handle_query_contract_ui>
}
c0de0a96:	bd80      	pop	{r7, pc}
            handle_provide_parameter(parameters);
c0de0a98:	4608      	mov	r0, r1
c0de0a9a:	f7ff fcdf 	bl	c0de045c <handle_provide_parameter>
}
c0de0a9e:	bd80      	pop	{r7, pc}
            handle_finalize(parameters);
c0de0aa0:	4608      	mov	r0, r1
c0de0aa2:	f7ff fc27 	bl	c0de02f4 <handle_finalize>
}
c0de0aa6:	bd80      	pop	{r7, pc}
            handle_provide_token(parameters);
c0de0aa8:	4608      	mov	r0, r1
c0de0aaa:	f7ff fdbd 	bl	c0de0628 <handle_provide_token>
}
c0de0aae:	bd80      	pop	{r7, pc}
            handle_query_contract_id(parameters);
c0de0ab0:	4608      	mov	r0, r1
c0de0ab2:	f7ff fe43 	bl	c0de073c <handle_query_contract_id>
}
c0de0ab6:	bd80      	pop	{r7, pc}
            PRINTF("Unhandled message %d\n", message);
c0de0ab8:	4802      	ldr	r0, [pc, #8]	; (c0de0ac4 <dispatch_plugin_calls+0x70>)
c0de0aba:	4478      	add	r0, pc
c0de0abc:	4611      	mov	r1, r2
c0de0abe:	f000 f837 	bl	c0de0b30 <mcu_usb_printf>
}
c0de0ac2:	bd80      	pop	{r7, pc}
c0de0ac4:	00000a4f 	.word	0x00000a4f

c0de0ac8 <call_app_ethereum>:
void call_app_ethereum() {
c0de0ac8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    libcall_params[0] = (unsigned int) "Ethereum";
c0de0aca:	4805      	ldr	r0, [pc, #20]	; (c0de0ae0 <call_app_ethereum+0x18>)
c0de0acc:	4478      	add	r0, pc
c0de0ace:	9001      	str	r0, [sp, #4]
c0de0ad0:	2001      	movs	r0, #1
    libcall_params[2] = RUN_APPLICATION;
c0de0ad2:	9003      	str	r0, [sp, #12]
c0de0ad4:	0200      	lsls	r0, r0, #8
    libcall_params[1] = 0x100;
c0de0ad6:	9002      	str	r0, [sp, #8]
c0de0ad8:	a801      	add	r0, sp, #4
    os_lib_call((unsigned int *) &libcall_params);
c0de0ada:	f000 f9b9 	bl	c0de0e50 <os_lib_call>
}
c0de0ade:	bd8f      	pop	{r0, r1, r2, r3, r7, pc}
c0de0ae0:	00000985 	.word	0x00000985

c0de0ae4 <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de0ae4:	b580      	push	{r7, lr}
c0de0ae6:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de0ae8:	f000 f9e4 	bl	c0de0eb4 <try_context_set>
#endif // HAVE_BOLOS
}
c0de0aec:	bd80      	pop	{r7, pc}
c0de0aee:	d4d4      	bmi.n	c0de0a9a <dispatch_plugin_calls+0x46>

c0de0af0 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de0af0:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF  
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de0af2:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de0af4:	4804      	ldr	r0, [pc, #16]	; (c0de0b08 <os_longjmp+0x18>)
c0de0af6:	4478      	add	r0, pc
c0de0af8:	4621      	mov	r1, r4
c0de0afa:	f000 f819 	bl	c0de0b30 <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de0afe:	f000 f9d1 	bl	c0de0ea4 <try_context_get>
c0de0b02:	4621      	mov	r1, r4
c0de0b04:	f000 fbe8 	bl	c0de12d8 <longjmp>
c0de0b08:	000009f3 	.word	0x000009f3

c0de0b0c <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de0b0c:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de0b0e:	460c      	mov	r4, r1
c0de0b10:	4605      	mov	r5, r0
c0de0b12:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de0b14:	7081      	strb	r1, [r0, #2]
c0de0b16:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de0b18:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de0b1a:	0a21      	lsrs	r1, r4, #8
c0de0b1c:	7041      	strb	r1, [r0, #1]
c0de0b1e:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de0b20:	f000 f9b6 	bl	c0de0e90 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de0b24:	b2a1      	uxth	r1, r4
c0de0b26:	4628      	mov	r0, r5
c0de0b28:	f000 f9b2 	bl	c0de0e90 <io_seph_send>
}
c0de0b2c:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
c0de0b2e:	d4d4      	bmi.n	c0de0ada <call_app_ethereum+0x12>

c0de0b30 <mcu_usb_printf>:
#include "usbd_def.h"
#include "usbd_core.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de0b30:	b083      	sub	sp, #12
c0de0b32:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0b34:	b08e      	sub	sp, #56	; 0x38
c0de0b36:	ac13      	add	r4, sp, #76	; 0x4c
c0de0b38:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de0b3a:	2800      	cmp	r0, #0
c0de0b3c:	d100      	bne.n	c0de0b40 <mcu_usb_printf+0x10>
c0de0b3e:	e163      	b.n	c0de0e08 <mcu_usb_printf+0x2d8>
c0de0b40:	4607      	mov	r7, r0
c0de0b42:	a813      	add	r0, sp, #76	; 0x4c
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de0b44:	9008      	str	r0, [sp, #32]
c0de0b46:	2001      	movs	r0, #1
c0de0b48:	9003      	str	r0, [sp, #12]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de0b4a:	7838      	ldrb	r0, [r7, #0]
c0de0b4c:	2800      	cmp	r0, #0
c0de0b4e:	d100      	bne.n	c0de0b52 <mcu_usb_printf+0x22>
c0de0b50:	e15a      	b.n	c0de0e08 <mcu_usb_printf+0x2d8>
c0de0b52:	463c      	mov	r4, r7
c0de0b54:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de0b56:	2800      	cmp	r0, #0
c0de0b58:	d005      	beq.n	c0de0b66 <mcu_usb_printf+0x36>
c0de0b5a:	2825      	cmp	r0, #37	; 0x25
c0de0b5c:	d003      	beq.n	c0de0b66 <mcu_usb_printf+0x36>
c0de0b5e:	1960      	adds	r0, r4, r5
c0de0b60:	7840      	ldrb	r0, [r0, #1]
            ulIdx++)
c0de0b62:	1c6d      	adds	r5, r5, #1
c0de0b64:	e7f7      	b.n	c0de0b56 <mcu_usb_printf+0x26>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de0b66:	4620      	mov	r0, r4
c0de0b68:	4629      	mov	r1, r5
c0de0b6a:	f7ff ffcf 	bl	c0de0b0c <mcu_usb_prints>
c0de0b6e:	1967      	adds	r7, r4, r5
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de0b70:	5d60      	ldrb	r0, [r4, r5]
c0de0b72:	2825      	cmp	r0, #37	; 0x25
c0de0b74:	d1e9      	bne.n	c0de0b4a <mcu_usb_printf+0x1a>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de0b76:	1960      	adds	r0, r4, r5
c0de0b78:	1c47      	adds	r7, r0, #1
c0de0b7a:	2400      	movs	r4, #0
c0de0b7c:	2620      	movs	r6, #32
c0de0b7e:	9407      	str	r4, [sp, #28]
c0de0b80:	4622      	mov	r2, r4
c0de0b82:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de0b84:	7839      	ldrb	r1, [r7, #0]
c0de0b86:	1c7f      	adds	r7, r7, #1
c0de0b88:	2200      	movs	r2, #0
c0de0b8a:	292d      	cmp	r1, #45	; 0x2d
c0de0b8c:	d0f9      	beq.n	c0de0b82 <mcu_usb_printf+0x52>
c0de0b8e:	460a      	mov	r2, r1
c0de0b90:	3a30      	subs	r2, #48	; 0x30
c0de0b92:	2a0a      	cmp	r2, #10
c0de0b94:	d316      	bcc.n	c0de0bc4 <mcu_usb_printf+0x94>
c0de0b96:	2925      	cmp	r1, #37	; 0x25
c0de0b98:	d044      	beq.n	c0de0c24 <mcu_usb_printf+0xf4>
c0de0b9a:	292a      	cmp	r1, #42	; 0x2a
c0de0b9c:	9704      	str	r7, [sp, #16]
c0de0b9e:	d01e      	beq.n	c0de0bde <mcu_usb_printf+0xae>
c0de0ba0:	292e      	cmp	r1, #46	; 0x2e
c0de0ba2:	d127      	bne.n	c0de0bf4 <mcu_usb_printf+0xc4>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de0ba4:	7838      	ldrb	r0, [r7, #0]
c0de0ba6:	282a      	cmp	r0, #42	; 0x2a
c0de0ba8:	d17d      	bne.n	c0de0ca6 <mcu_usb_printf+0x176>
c0de0baa:	9804      	ldr	r0, [sp, #16]
c0de0bac:	7840      	ldrb	r0, [r0, #1]
c0de0bae:	2848      	cmp	r0, #72	; 0x48
c0de0bb0:	d003      	beq.n	c0de0bba <mcu_usb_printf+0x8a>
c0de0bb2:	2873      	cmp	r0, #115	; 0x73
c0de0bb4:	d001      	beq.n	c0de0bba <mcu_usb_printf+0x8a>
c0de0bb6:	2868      	cmp	r0, #104	; 0x68
c0de0bb8:	d175      	bne.n	c0de0ca6 <mcu_usb_printf+0x176>
c0de0bba:	9f04      	ldr	r7, [sp, #16]
c0de0bbc:	1c7f      	adds	r7, r7, #1
c0de0bbe:	2201      	movs	r2, #1

                    // skip '*' char
                    format++;

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0bc0:	9808      	ldr	r0, [sp, #32]
c0de0bc2:	e012      	b.n	c0de0bea <mcu_usb_printf+0xba>
c0de0bc4:	2230      	movs	r2, #48	; 0x30
                    if((format[-1] == '0') && (ulCount == 0))
c0de0bc6:	460b      	mov	r3, r1
c0de0bc8:	4053      	eors	r3, r2
c0de0bca:	4323      	orrs	r3, r4
c0de0bcc:	d000      	beq.n	c0de0bd0 <mcu_usb_printf+0xa0>
c0de0bce:	4632      	mov	r2, r6
c0de0bd0:	230a      	movs	r3, #10
                    ulCount *= 10;
c0de0bd2:	4363      	muls	r3, r4
                    ulCount += format[-1] - '0';
c0de0bd4:	185c      	adds	r4, r3, r1
c0de0bd6:	3c30      	subs	r4, #48	; 0x30
c0de0bd8:	4616      	mov	r6, r2
c0de0bda:	4602      	mov	r2, r0
c0de0bdc:	e7d1      	b.n	c0de0b82 <mcu_usb_printf+0x52>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de0bde:	7838      	ldrb	r0, [r7, #0]
c0de0be0:	2873      	cmp	r0, #115	; 0x73
c0de0be2:	d160      	bne.n	c0de0ca6 <mcu_usb_printf+0x176>
c0de0be4:	2202      	movs	r2, #2

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0be6:	9808      	ldr	r0, [sp, #32]
c0de0be8:	9f04      	ldr	r7, [sp, #16]
c0de0bea:	1d01      	adds	r1, r0, #4
c0de0bec:	9108      	str	r1, [sp, #32]
c0de0bee:	6800      	ldr	r0, [r0, #0]
            switch(*format++)
c0de0bf0:	9007      	str	r0, [sp, #28]
c0de0bf2:	e7c6      	b.n	c0de0b82 <mcu_usb_printf+0x52>
c0de0bf4:	2948      	cmp	r1, #72	; 0x48
c0de0bf6:	d017      	beq.n	c0de0c28 <mcu_usb_printf+0xf8>
c0de0bf8:	2958      	cmp	r1, #88	; 0x58
c0de0bfa:	d01a      	beq.n	c0de0c32 <mcu_usb_printf+0x102>
c0de0bfc:	2963      	cmp	r1, #99	; 0x63
c0de0bfe:	d025      	beq.n	c0de0c4c <mcu_usb_printf+0x11c>
c0de0c00:	2964      	cmp	r1, #100	; 0x64
c0de0c02:	d02d      	beq.n	c0de0c60 <mcu_usb_printf+0x130>
c0de0c04:	4a83      	ldr	r2, [pc, #524]	; (c0de0e14 <mcu_usb_printf+0x2e4>)
c0de0c06:	447a      	add	r2, pc
c0de0c08:	9206      	str	r2, [sp, #24]
c0de0c0a:	2968      	cmp	r1, #104	; 0x68
c0de0c0c:	d037      	beq.n	c0de0c7e <mcu_usb_printf+0x14e>
c0de0c0e:	2970      	cmp	r1, #112	; 0x70
c0de0c10:	d005      	beq.n	c0de0c1e <mcu_usb_printf+0xee>
c0de0c12:	2973      	cmp	r1, #115	; 0x73
c0de0c14:	d036      	beq.n	c0de0c84 <mcu_usb_printf+0x154>
c0de0c16:	2975      	cmp	r1, #117	; 0x75
c0de0c18:	d049      	beq.n	c0de0cae <mcu_usb_printf+0x17e>
c0de0c1a:	2978      	cmp	r1, #120	; 0x78
c0de0c1c:	d143      	bne.n	c0de0ca6 <mcu_usb_printf+0x176>
c0de0c1e:	9601      	str	r6, [sp, #4]
c0de0c20:	2000      	movs	r0, #0
c0de0c22:	e008      	b.n	c0de0c36 <mcu_usb_printf+0x106>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de0c24:	1e78      	subs	r0, r7, #1
c0de0c26:	e017      	b.n	c0de0c58 <mcu_usb_printf+0x128>
c0de0c28:	9405      	str	r4, [sp, #20]
c0de0c2a:	497b      	ldr	r1, [pc, #492]	; (c0de0e18 <mcu_usb_printf+0x2e8>)
c0de0c2c:	4479      	add	r1, pc
c0de0c2e:	9106      	str	r1, [sp, #24]
c0de0c30:	e026      	b.n	c0de0c80 <mcu_usb_printf+0x150>
c0de0c32:	9601      	str	r6, [sp, #4]
c0de0c34:	2001      	movs	r0, #1
c0de0c36:	9000      	str	r0, [sp, #0]
c0de0c38:	9f03      	ldr	r7, [sp, #12]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0c3a:	9808      	ldr	r0, [sp, #32]
c0de0c3c:	1d01      	adds	r1, r0, #4
c0de0c3e:	9108      	str	r1, [sp, #32]
c0de0c40:	6800      	ldr	r0, [r0, #0]
c0de0c42:	9005      	str	r0, [sp, #20]
c0de0c44:	900d      	str	r0, [sp, #52]	; 0x34
c0de0c46:	2010      	movs	r0, #16
c0de0c48:	9006      	str	r0, [sp, #24]
c0de0c4a:	e03c      	b.n	c0de0cc6 <mcu_usb_printf+0x196>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0c4c:	9808      	ldr	r0, [sp, #32]
c0de0c4e:	1d01      	adds	r1, r0, #4
c0de0c50:	9108      	str	r1, [sp, #32]
c0de0c52:	6800      	ldr	r0, [r0, #0]
c0de0c54:	900d      	str	r0, [sp, #52]	; 0x34
c0de0c56:	a80d      	add	r0, sp, #52	; 0x34
c0de0c58:	2101      	movs	r1, #1
c0de0c5a:	f7ff ff57 	bl	c0de0b0c <mcu_usb_prints>
c0de0c5e:	e774      	b.n	c0de0b4a <mcu_usb_printf+0x1a>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0c60:	9808      	ldr	r0, [sp, #32]
c0de0c62:	1d01      	adds	r1, r0, #4
c0de0c64:	9108      	str	r1, [sp, #32]
c0de0c66:	6800      	ldr	r0, [r0, #0]
c0de0c68:	900d      	str	r0, [sp, #52]	; 0x34
c0de0c6a:	210a      	movs	r1, #10
                    if((long)ulValue < 0)
c0de0c6c:	2800      	cmp	r0, #0
c0de0c6e:	9601      	str	r6, [sp, #4]
c0de0c70:	9106      	str	r1, [sp, #24]
c0de0c72:	d500      	bpl.n	c0de0c76 <mcu_usb_printf+0x146>
c0de0c74:	e0b7      	b.n	c0de0de6 <mcu_usb_printf+0x2b6>
c0de0c76:	9005      	str	r0, [sp, #20]
c0de0c78:	2000      	movs	r0, #0
c0de0c7a:	9000      	str	r0, [sp, #0]
c0de0c7c:	e022      	b.n	c0de0cc4 <mcu_usb_printf+0x194>
c0de0c7e:	9405      	str	r4, [sp, #20]
c0de0c80:	9903      	ldr	r1, [sp, #12]
c0de0c82:	e001      	b.n	c0de0c88 <mcu_usb_printf+0x158>
c0de0c84:	9405      	str	r4, [sp, #20]
c0de0c86:	2100      	movs	r1, #0
                    pcStr = va_arg(vaArgP, char *);
c0de0c88:	9a08      	ldr	r2, [sp, #32]
c0de0c8a:	1d13      	adds	r3, r2, #4
c0de0c8c:	9308      	str	r3, [sp, #32]
                    switch(cStrlenSet) {
c0de0c8e:	b2c0      	uxtb	r0, r0
                    pcStr = va_arg(vaArgP, char *);
c0de0c90:	6817      	ldr	r7, [r2, #0]
                    switch(cStrlenSet) {
c0de0c92:	2800      	cmp	r0, #0
c0de0c94:	d074      	beq.n	c0de0d80 <mcu_usb_printf+0x250>
c0de0c96:	2801      	cmp	r0, #1
c0de0c98:	d079      	beq.n	c0de0d8e <mcu_usb_printf+0x25e>
c0de0c9a:	2802      	cmp	r0, #2
c0de0c9c:	d178      	bne.n	c0de0d90 <mcu_usb_printf+0x260>
                        if (pcStr[0] == '\0') {
c0de0c9e:	7838      	ldrb	r0, [r7, #0]
c0de0ca0:	2800      	cmp	r0, #0
c0de0ca2:	d100      	bne.n	c0de0ca6 <mcu_usb_printf+0x176>
c0de0ca4:	e0a6      	b.n	c0de0df4 <mcu_usb_printf+0x2c4>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de0ca6:	4861      	ldr	r0, [pc, #388]	; (c0de0e2c <mcu_usb_printf+0x2fc>)
c0de0ca8:	4478      	add	r0, pc
c0de0caa:	2105      	movs	r1, #5
c0de0cac:	e064      	b.n	c0de0d78 <mcu_usb_printf+0x248>
c0de0cae:	9601      	str	r6, [sp, #4]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0cb0:	9808      	ldr	r0, [sp, #32]
c0de0cb2:	1d01      	adds	r1, r0, #4
c0de0cb4:	9108      	str	r1, [sp, #32]
c0de0cb6:	6800      	ldr	r0, [r0, #0]
c0de0cb8:	9005      	str	r0, [sp, #20]
c0de0cba:	900d      	str	r0, [sp, #52]	; 0x34
c0de0cbc:	2000      	movs	r0, #0
c0de0cbe:	9000      	str	r0, [sp, #0]
c0de0cc0:	200a      	movs	r0, #10
c0de0cc2:	9006      	str	r0, [sp, #24]
c0de0cc4:	9f03      	ldr	r7, [sp, #12]
c0de0cc6:	4639      	mov	r1, r7
c0de0cc8:	4856      	ldr	r0, [pc, #344]	; (c0de0e24 <mcu_usb_printf+0x2f4>)
c0de0cca:	4478      	add	r0, pc
                    for(ulIdx = 1;
c0de0ccc:	9007      	str	r0, [sp, #28]
c0de0cce:	9102      	str	r1, [sp, #8]
c0de0cd0:	19c8      	adds	r0, r1, r7
c0de0cd2:	4038      	ands	r0, r7
c0de0cd4:	1a26      	subs	r6, r4, r0
c0de0cd6:	1e75      	subs	r5, r6, #1
c0de0cd8:	2400      	movs	r4, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de0cda:	9806      	ldr	r0, [sp, #24]
c0de0cdc:	4621      	mov	r1, r4
c0de0cde:	463a      	mov	r2, r7
c0de0ce0:	4623      	mov	r3, r4
c0de0ce2:	f000 f97f 	bl	c0de0fe4 <__aeabi_lmul>
c0de0ce6:	1e4a      	subs	r2, r1, #1
c0de0ce8:	4191      	sbcs	r1, r2
c0de0cea:	9a05      	ldr	r2, [sp, #20]
c0de0cec:	4290      	cmp	r0, r2
c0de0cee:	d805      	bhi.n	c0de0cfc <mcu_usb_printf+0x1cc>
                    for(ulIdx = 1;
c0de0cf0:	2900      	cmp	r1, #0
c0de0cf2:	d103      	bne.n	c0de0cfc <mcu_usb_printf+0x1cc>
c0de0cf4:	1e6d      	subs	r5, r5, #1
c0de0cf6:	1e76      	subs	r6, r6, #1
c0de0cf8:	4607      	mov	r7, r0
c0de0cfa:	e7ed      	b.n	c0de0cd8 <mcu_usb_printf+0x1a8>
                    if(ulNeg && (cFill == '0'))
c0de0cfc:	9802      	ldr	r0, [sp, #8]
c0de0cfe:	2800      	cmp	r0, #0
c0de0d00:	9803      	ldr	r0, [sp, #12]
c0de0d02:	9a01      	ldr	r2, [sp, #4]
c0de0d04:	d109      	bne.n	c0de0d1a <mcu_usb_printf+0x1ea>
c0de0d06:	b2d1      	uxtb	r1, r2
c0de0d08:	2000      	movs	r0, #0
c0de0d0a:	2930      	cmp	r1, #48	; 0x30
c0de0d0c:	4604      	mov	r4, r0
c0de0d0e:	d104      	bne.n	c0de0d1a <mcu_usb_printf+0x1ea>
c0de0d10:	a809      	add	r0, sp, #36	; 0x24
c0de0d12:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0d14:	7001      	strb	r1, [r0, #0]
c0de0d16:	2401      	movs	r4, #1
c0de0d18:	9803      	ldr	r0, [sp, #12]
                    if((ulCount > 1) && (ulCount < 16))
c0de0d1a:	1eb1      	subs	r1, r6, #2
c0de0d1c:	290d      	cmp	r1, #13
c0de0d1e:	d807      	bhi.n	c0de0d30 <mcu_usb_printf+0x200>
c0de0d20:	9e06      	ldr	r6, [sp, #24]
                        for(ulCount--; ulCount; ulCount--)
c0de0d22:	2d00      	cmp	r5, #0
c0de0d24:	d005      	beq.n	c0de0d32 <mcu_usb_printf+0x202>
c0de0d26:	a909      	add	r1, sp, #36	; 0x24
                            pcBuf[ulPos++] = cFill;
c0de0d28:	550a      	strb	r2, [r1, r4]
                        for(ulCount--; ulCount; ulCount--)
c0de0d2a:	1e6d      	subs	r5, r5, #1
                            pcBuf[ulPos++] = cFill;
c0de0d2c:	1c64      	adds	r4, r4, #1
c0de0d2e:	e7f8      	b.n	c0de0d22 <mcu_usb_printf+0x1f2>
c0de0d30:	9e06      	ldr	r6, [sp, #24]
                    if(ulNeg)
c0de0d32:	2800      	cmp	r0, #0
c0de0d34:	9d05      	ldr	r5, [sp, #20]
c0de0d36:	d103      	bne.n	c0de0d40 <mcu_usb_printf+0x210>
c0de0d38:	a809      	add	r0, sp, #36	; 0x24
c0de0d3a:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0d3c:	5501      	strb	r1, [r0, r4]
c0de0d3e:	1c64      	adds	r4, r4, #1
c0de0d40:	9800      	ldr	r0, [sp, #0]
c0de0d42:	2800      	cmp	r0, #0
c0de0d44:	d114      	bne.n	c0de0d70 <mcu_usb_printf+0x240>
c0de0d46:	4838      	ldr	r0, [pc, #224]	; (c0de0e28 <mcu_usb_printf+0x2f8>)
c0de0d48:	4478      	add	r0, pc
c0de0d4a:	9007      	str	r0, [sp, #28]
c0de0d4c:	e010      	b.n	c0de0d70 <mcu_usb_printf+0x240>
c0de0d4e:	4628      	mov	r0, r5
c0de0d50:	4639      	mov	r1, r7
c0de0d52:	f000 f8bb 	bl	c0de0ecc <__udivsi3>
c0de0d56:	4631      	mov	r1, r6
c0de0d58:	f000 f93e 	bl	c0de0fd8 <__aeabi_uidivmod>
c0de0d5c:	9807      	ldr	r0, [sp, #28]
c0de0d5e:	5c40      	ldrb	r0, [r0, r1]
c0de0d60:	a909      	add	r1, sp, #36	; 0x24
                          pcBuf[ulPos++] = g_pcHex[(ulValue / ulIdx) % ulBase];
c0de0d62:	5508      	strb	r0, [r1, r4]
                    for(; ulIdx; ulIdx /= ulBase)
c0de0d64:	4638      	mov	r0, r7
c0de0d66:	4631      	mov	r1, r6
c0de0d68:	f000 f8b0 	bl	c0de0ecc <__udivsi3>
c0de0d6c:	4607      	mov	r7, r0
c0de0d6e:	1c64      	adds	r4, r4, #1
c0de0d70:	2f00      	cmp	r7, #0
c0de0d72:	d1ec      	bne.n	c0de0d4e <mcu_usb_printf+0x21e>
c0de0d74:	a809      	add	r0, sp, #36	; 0x24
                    mcu_usb_prints(pcBuf, ulPos);
c0de0d76:	4621      	mov	r1, r4
c0de0d78:	f7ff fec8 	bl	c0de0b0c <mcu_usb_prints>
c0de0d7c:	9f04      	ldr	r7, [sp, #16]
c0de0d7e:	e6e4      	b.n	c0de0b4a <mcu_usb_printf+0x1a>
c0de0d80:	2000      	movs	r0, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de0d82:	5c3a      	ldrb	r2, [r7, r0]
c0de0d84:	1c40      	adds	r0, r0, #1
c0de0d86:	2a00      	cmp	r2, #0
c0de0d88:	d1fb      	bne.n	c0de0d82 <mcu_usb_printf+0x252>
                    switch(ulBase) {
c0de0d8a:	1e45      	subs	r5, r0, #1
c0de0d8c:	e000      	b.n	c0de0d90 <mcu_usb_printf+0x260>
c0de0d8e:	9d07      	ldr	r5, [sp, #28]
c0de0d90:	2900      	cmp	r1, #0
c0de0d92:	d014      	beq.n	c0de0dbe <mcu_usb_printf+0x28e>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0d94:	2d00      	cmp	r5, #0
c0de0d96:	d0f1      	beq.n	c0de0d7c <mcu_usb_printf+0x24c>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de0d98:	783e      	ldrb	r6, [r7, #0]
c0de0d9a:	0930      	lsrs	r0, r6, #4
c0de0d9c:	9c06      	ldr	r4, [sp, #24]
c0de0d9e:	1820      	adds	r0, r4, r0
c0de0da0:	9507      	str	r5, [sp, #28]
c0de0da2:	2501      	movs	r5, #1
c0de0da4:	4629      	mov	r1, r5
c0de0da6:	f7ff feb1 	bl	c0de0b0c <mcu_usb_prints>
c0de0daa:	200f      	movs	r0, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de0dac:	4030      	ands	r0, r6
c0de0dae:	1820      	adds	r0, r4, r0
c0de0db0:	4629      	mov	r1, r5
c0de0db2:	9d07      	ldr	r5, [sp, #28]
c0de0db4:	f7ff feaa 	bl	c0de0b0c <mcu_usb_prints>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0db8:	1c7f      	adds	r7, r7, #1
c0de0dba:	1e6d      	subs	r5, r5, #1
c0de0dbc:	e7ea      	b.n	c0de0d94 <mcu_usb_printf+0x264>
                        mcu_usb_prints(pcStr, ulIdx);
c0de0dbe:	4638      	mov	r0, r7
c0de0dc0:	4629      	mov	r1, r5
c0de0dc2:	f7ff fea3 	bl	c0de0b0c <mcu_usb_prints>
c0de0dc6:	9f04      	ldr	r7, [sp, #16]
c0de0dc8:	9805      	ldr	r0, [sp, #20]
                    if(ulCount > ulIdx)
c0de0dca:	42a8      	cmp	r0, r5
c0de0dcc:	d800      	bhi.n	c0de0dd0 <mcu_usb_printf+0x2a0>
c0de0dce:	e6bc      	b.n	c0de0b4a <mcu_usb_printf+0x1a>
                        while(ulCount--)
c0de0dd0:	1a2c      	subs	r4, r5, r0
c0de0dd2:	2c00      	cmp	r4, #0
c0de0dd4:	d100      	bne.n	c0de0dd8 <mcu_usb_printf+0x2a8>
c0de0dd6:	e6b8      	b.n	c0de0b4a <mcu_usb_printf+0x1a>
                            mcu_usb_prints(" ", 1);
c0de0dd8:	4811      	ldr	r0, [pc, #68]	; (c0de0e20 <mcu_usb_printf+0x2f0>)
c0de0dda:	4478      	add	r0, pc
c0de0ddc:	2101      	movs	r1, #1
c0de0dde:	f7ff fe95 	bl	c0de0b0c <mcu_usb_prints>
                        while(ulCount--)
c0de0de2:	1c64      	adds	r4, r4, #1
c0de0de4:	e7f5      	b.n	c0de0dd2 <mcu_usb_printf+0x2a2>
                        ulValue = -(long)ulValue;
c0de0de6:	4240      	negs	r0, r0
c0de0de8:	9005      	str	r0, [sp, #20]
c0de0dea:	900d      	str	r0, [sp, #52]	; 0x34
c0de0dec:	2100      	movs	r1, #0
            ulCap = 0;
c0de0dee:	9100      	str	r1, [sp, #0]
c0de0df0:	9f03      	ldr	r7, [sp, #12]
c0de0df2:	e769      	b.n	c0de0cc8 <mcu_usb_printf+0x198>
                          do {
c0de0df4:	9807      	ldr	r0, [sp, #28]
c0de0df6:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de0df8:	4808      	ldr	r0, [pc, #32]	; (c0de0e1c <mcu_usb_printf+0x2ec>)
c0de0dfa:	4478      	add	r0, pc
c0de0dfc:	2101      	movs	r1, #1
c0de0dfe:	f7ff fe85 	bl	c0de0b0c <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de0e02:	1e64      	subs	r4, r4, #1
c0de0e04:	d1f8      	bne.n	c0de0df8 <mcu_usb_printf+0x2c8>
c0de0e06:	e7de      	b.n	c0de0dc6 <mcu_usb_printf+0x296>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de0e08:	b00e      	add	sp, #56	; 0x38
c0de0e0a:	bcf0      	pop	{r4, r5, r6, r7}
c0de0e0c:	bc01      	pop	{r0}
c0de0e0e:	b003      	add	sp, #12
c0de0e10:	4700      	bx	r0
c0de0e12:	46c0      	nop			; (mov r8, r8)
c0de0e14:	00000a72 	.word	0x00000a72
c0de0e18:	00000a5c 	.word	0x00000a5c
c0de0e1c:	000005d4 	.word	0x000005d4
c0de0e20:	000005f4 	.word	0x000005f4
c0de0e24:	000009be 	.word	0x000009be
c0de0e28:	00000930 	.word	0x00000930
c0de0e2c:	0000085b 	.word	0x0000085b

c0de0e30 <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de0e30:	df01      	svc	1
    cmp r1, #0
c0de0e32:	2900      	cmp	r1, #0
    bne exception
c0de0e34:	d100      	bne.n	c0de0e38 <exception>
    bx lr
c0de0e36:	4770      	bx	lr

c0de0e38 <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de0e38:	4608      	mov	r0, r1
    bl os_longjmp
c0de0e3a:	f7ff fe59 	bl	c0de0af0 <os_longjmp>

c0de0e3e <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de0e3e:	b5e0      	push	{r5, r6, r7, lr}
c0de0e40:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de0e42:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de0e44:	9000      	str	r0, [sp, #0]
c0de0e46:	2001      	movs	r0, #1
c0de0e48:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de0e4a:	f7ff fff1 	bl	c0de0e30 <SVC_Call>
c0de0e4e:	bd8c      	pop	{r2, r3, r7, pc}

c0de0e50 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de0e50:	b5e0      	push	{r5, r6, r7, lr}
c0de0e52:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de0e54:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de0e56:	9000      	str	r0, [sp, #0]
c0de0e58:	4802      	ldr	r0, [pc, #8]	; (c0de0e64 <os_lib_call+0x14>)
c0de0e5a:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de0e5c:	f7ff ffe8 	bl	c0de0e30 <SVC_Call>
  return;
}
c0de0e60:	bd8c      	pop	{r2, r3, r7, pc}
c0de0e62:	46c0      	nop			; (mov r8, r8)
c0de0e64:	01000067 	.word	0x01000067

c0de0e68 <os_lib_end>:

void os_lib_end ( void ) {
c0de0e68:	b5e0      	push	{r5, r6, r7, lr}
c0de0e6a:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0e6c:	9001      	str	r0, [sp, #4]
c0de0e6e:	2068      	movs	r0, #104	; 0x68
c0de0e70:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de0e72:	f7ff ffdd 	bl	c0de0e30 <SVC_Call>
  return;
}
c0de0e76:	bd8c      	pop	{r2, r3, r7, pc}

c0de0e78 <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de0e78:	b082      	sub	sp, #8
c0de0e7a:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de0e7c:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de0e7e:	9000      	str	r0, [sp, #0]
c0de0e80:	4802      	ldr	r0, [pc, #8]	; (c0de0e8c <os_sched_exit+0x14>)
c0de0e82:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de0e84:	f7ff ffd4 	bl	c0de0e30 <SVC_Call>

  // The os_sched_exit syscall should never return. Just in case, prevent the
  // device from freezing (because of the following infinite loop) thanks to an
  // undefined instruction.
  asm volatile ("udf #255");
c0de0e88:	deff      	udf	#255	; 0xff

  // remove the warning caused by -Winvalid-noreturn
  while (1) {
c0de0e8a:	e7fe      	b.n	c0de0e8a <os_sched_exit+0x12>
c0de0e8c:	0100009a 	.word	0x0100009a

c0de0e90 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de0e90:	b5e0      	push	{r5, r6, r7, lr}
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de0e92:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de0e94:	9000      	str	r0, [sp, #0]
c0de0e96:	4802      	ldr	r0, [pc, #8]	; (c0de0ea0 <io_seph_send+0x10>)
c0de0e98:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de0e9a:	f7ff ffc9 	bl	c0de0e30 <SVC_Call>
  return;
}
c0de0e9e:	bd8c      	pop	{r2, r3, r7, pc}
c0de0ea0:	02000083 	.word	0x02000083

c0de0ea4 <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de0ea4:	b5e0      	push	{r5, r6, r7, lr}
c0de0ea6:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0ea8:	9001      	str	r0, [sp, #4]
c0de0eaa:	2087      	movs	r0, #135	; 0x87
c0de0eac:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de0eae:	f7ff ffbf 	bl	c0de0e30 <SVC_Call>
c0de0eb2:	bd8c      	pop	{r2, r3, r7, pc}

c0de0eb4 <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de0eb4:	b5e0      	push	{r5, r6, r7, lr}
c0de0eb6:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de0eb8:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de0eba:	9000      	str	r0, [sp, #0]
c0de0ebc:	4802      	ldr	r0, [pc, #8]	; (c0de0ec8 <try_context_set+0x14>)
c0de0ebe:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de0ec0:	f7ff ffb6 	bl	c0de0e30 <SVC_Call>
c0de0ec4:	bd8c      	pop	{r2, r3, r7, pc}
c0de0ec6:	46c0      	nop			; (mov r8, r8)
c0de0ec8:	0100010b 	.word	0x0100010b

c0de0ecc <__udivsi3>:
c0de0ecc:	2200      	movs	r2, #0
c0de0ece:	0843      	lsrs	r3, r0, #1
c0de0ed0:	428b      	cmp	r3, r1
c0de0ed2:	d374      	bcc.n	c0de0fbe <__udivsi3+0xf2>
c0de0ed4:	0903      	lsrs	r3, r0, #4
c0de0ed6:	428b      	cmp	r3, r1
c0de0ed8:	d35f      	bcc.n	c0de0f9a <__udivsi3+0xce>
c0de0eda:	0a03      	lsrs	r3, r0, #8
c0de0edc:	428b      	cmp	r3, r1
c0de0ede:	d344      	bcc.n	c0de0f6a <__udivsi3+0x9e>
c0de0ee0:	0b03      	lsrs	r3, r0, #12
c0de0ee2:	428b      	cmp	r3, r1
c0de0ee4:	d328      	bcc.n	c0de0f38 <__udivsi3+0x6c>
c0de0ee6:	0c03      	lsrs	r3, r0, #16
c0de0ee8:	428b      	cmp	r3, r1
c0de0eea:	d30d      	bcc.n	c0de0f08 <__udivsi3+0x3c>
c0de0eec:	22ff      	movs	r2, #255	; 0xff
c0de0eee:	0209      	lsls	r1, r1, #8
c0de0ef0:	ba12      	rev	r2, r2
c0de0ef2:	0c03      	lsrs	r3, r0, #16
c0de0ef4:	428b      	cmp	r3, r1
c0de0ef6:	d302      	bcc.n	c0de0efe <__udivsi3+0x32>
c0de0ef8:	1212      	asrs	r2, r2, #8
c0de0efa:	0209      	lsls	r1, r1, #8
c0de0efc:	d065      	beq.n	c0de0fca <__udivsi3+0xfe>
c0de0efe:	0b03      	lsrs	r3, r0, #12
c0de0f00:	428b      	cmp	r3, r1
c0de0f02:	d319      	bcc.n	c0de0f38 <__udivsi3+0x6c>
c0de0f04:	e000      	b.n	c0de0f08 <__udivsi3+0x3c>
c0de0f06:	0a09      	lsrs	r1, r1, #8
c0de0f08:	0bc3      	lsrs	r3, r0, #15
c0de0f0a:	428b      	cmp	r3, r1
c0de0f0c:	d301      	bcc.n	c0de0f12 <__udivsi3+0x46>
c0de0f0e:	03cb      	lsls	r3, r1, #15
c0de0f10:	1ac0      	subs	r0, r0, r3
c0de0f12:	4152      	adcs	r2, r2
c0de0f14:	0b83      	lsrs	r3, r0, #14
c0de0f16:	428b      	cmp	r3, r1
c0de0f18:	d301      	bcc.n	c0de0f1e <__udivsi3+0x52>
c0de0f1a:	038b      	lsls	r3, r1, #14
c0de0f1c:	1ac0      	subs	r0, r0, r3
c0de0f1e:	4152      	adcs	r2, r2
c0de0f20:	0b43      	lsrs	r3, r0, #13
c0de0f22:	428b      	cmp	r3, r1
c0de0f24:	d301      	bcc.n	c0de0f2a <__udivsi3+0x5e>
c0de0f26:	034b      	lsls	r3, r1, #13
c0de0f28:	1ac0      	subs	r0, r0, r3
c0de0f2a:	4152      	adcs	r2, r2
c0de0f2c:	0b03      	lsrs	r3, r0, #12
c0de0f2e:	428b      	cmp	r3, r1
c0de0f30:	d301      	bcc.n	c0de0f36 <__udivsi3+0x6a>
c0de0f32:	030b      	lsls	r3, r1, #12
c0de0f34:	1ac0      	subs	r0, r0, r3
c0de0f36:	4152      	adcs	r2, r2
c0de0f38:	0ac3      	lsrs	r3, r0, #11
c0de0f3a:	428b      	cmp	r3, r1
c0de0f3c:	d301      	bcc.n	c0de0f42 <__udivsi3+0x76>
c0de0f3e:	02cb      	lsls	r3, r1, #11
c0de0f40:	1ac0      	subs	r0, r0, r3
c0de0f42:	4152      	adcs	r2, r2
c0de0f44:	0a83      	lsrs	r3, r0, #10
c0de0f46:	428b      	cmp	r3, r1
c0de0f48:	d301      	bcc.n	c0de0f4e <__udivsi3+0x82>
c0de0f4a:	028b      	lsls	r3, r1, #10
c0de0f4c:	1ac0      	subs	r0, r0, r3
c0de0f4e:	4152      	adcs	r2, r2
c0de0f50:	0a43      	lsrs	r3, r0, #9
c0de0f52:	428b      	cmp	r3, r1
c0de0f54:	d301      	bcc.n	c0de0f5a <__udivsi3+0x8e>
c0de0f56:	024b      	lsls	r3, r1, #9
c0de0f58:	1ac0      	subs	r0, r0, r3
c0de0f5a:	4152      	adcs	r2, r2
c0de0f5c:	0a03      	lsrs	r3, r0, #8
c0de0f5e:	428b      	cmp	r3, r1
c0de0f60:	d301      	bcc.n	c0de0f66 <__udivsi3+0x9a>
c0de0f62:	020b      	lsls	r3, r1, #8
c0de0f64:	1ac0      	subs	r0, r0, r3
c0de0f66:	4152      	adcs	r2, r2
c0de0f68:	d2cd      	bcs.n	c0de0f06 <__udivsi3+0x3a>
c0de0f6a:	09c3      	lsrs	r3, r0, #7
c0de0f6c:	428b      	cmp	r3, r1
c0de0f6e:	d301      	bcc.n	c0de0f74 <__udivsi3+0xa8>
c0de0f70:	01cb      	lsls	r3, r1, #7
c0de0f72:	1ac0      	subs	r0, r0, r3
c0de0f74:	4152      	adcs	r2, r2
c0de0f76:	0983      	lsrs	r3, r0, #6
c0de0f78:	428b      	cmp	r3, r1
c0de0f7a:	d301      	bcc.n	c0de0f80 <__udivsi3+0xb4>
c0de0f7c:	018b      	lsls	r3, r1, #6
c0de0f7e:	1ac0      	subs	r0, r0, r3
c0de0f80:	4152      	adcs	r2, r2
c0de0f82:	0943      	lsrs	r3, r0, #5
c0de0f84:	428b      	cmp	r3, r1
c0de0f86:	d301      	bcc.n	c0de0f8c <__udivsi3+0xc0>
c0de0f88:	014b      	lsls	r3, r1, #5
c0de0f8a:	1ac0      	subs	r0, r0, r3
c0de0f8c:	4152      	adcs	r2, r2
c0de0f8e:	0903      	lsrs	r3, r0, #4
c0de0f90:	428b      	cmp	r3, r1
c0de0f92:	d301      	bcc.n	c0de0f98 <__udivsi3+0xcc>
c0de0f94:	010b      	lsls	r3, r1, #4
c0de0f96:	1ac0      	subs	r0, r0, r3
c0de0f98:	4152      	adcs	r2, r2
c0de0f9a:	08c3      	lsrs	r3, r0, #3
c0de0f9c:	428b      	cmp	r3, r1
c0de0f9e:	d301      	bcc.n	c0de0fa4 <__udivsi3+0xd8>
c0de0fa0:	00cb      	lsls	r3, r1, #3
c0de0fa2:	1ac0      	subs	r0, r0, r3
c0de0fa4:	4152      	adcs	r2, r2
c0de0fa6:	0883      	lsrs	r3, r0, #2
c0de0fa8:	428b      	cmp	r3, r1
c0de0faa:	d301      	bcc.n	c0de0fb0 <__udivsi3+0xe4>
c0de0fac:	008b      	lsls	r3, r1, #2
c0de0fae:	1ac0      	subs	r0, r0, r3
c0de0fb0:	4152      	adcs	r2, r2
c0de0fb2:	0843      	lsrs	r3, r0, #1
c0de0fb4:	428b      	cmp	r3, r1
c0de0fb6:	d301      	bcc.n	c0de0fbc <__udivsi3+0xf0>
c0de0fb8:	004b      	lsls	r3, r1, #1
c0de0fba:	1ac0      	subs	r0, r0, r3
c0de0fbc:	4152      	adcs	r2, r2
c0de0fbe:	1a41      	subs	r1, r0, r1
c0de0fc0:	d200      	bcs.n	c0de0fc4 <__udivsi3+0xf8>
c0de0fc2:	4601      	mov	r1, r0
c0de0fc4:	4152      	adcs	r2, r2
c0de0fc6:	4610      	mov	r0, r2
c0de0fc8:	4770      	bx	lr
c0de0fca:	e7ff      	b.n	c0de0fcc <__udivsi3+0x100>
c0de0fcc:	b501      	push	{r0, lr}
c0de0fce:	2000      	movs	r0, #0
c0de0fd0:	f000 f806 	bl	c0de0fe0 <__aeabi_idiv0>
c0de0fd4:	bd02      	pop	{r1, pc}
c0de0fd6:	46c0      	nop			; (mov r8, r8)

c0de0fd8 <__aeabi_uidivmod>:
c0de0fd8:	2900      	cmp	r1, #0
c0de0fda:	d0f7      	beq.n	c0de0fcc <__udivsi3+0x100>
c0de0fdc:	e776      	b.n	c0de0ecc <__udivsi3>
c0de0fde:	4770      	bx	lr

c0de0fe0 <__aeabi_idiv0>:
c0de0fe0:	4770      	bx	lr
c0de0fe2:	46c0      	nop			; (mov r8, r8)

c0de0fe4 <__aeabi_lmul>:
c0de0fe4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0fe6:	46ce      	mov	lr, r9
c0de0fe8:	4647      	mov	r7, r8
c0de0fea:	0415      	lsls	r5, r2, #16
c0de0fec:	0c2d      	lsrs	r5, r5, #16
c0de0fee:	002e      	movs	r6, r5
c0de0ff0:	b580      	push	{r7, lr}
c0de0ff2:	0407      	lsls	r7, r0, #16
c0de0ff4:	0c14      	lsrs	r4, r2, #16
c0de0ff6:	0c3f      	lsrs	r7, r7, #16
c0de0ff8:	4699      	mov	r9, r3
c0de0ffa:	0c03      	lsrs	r3, r0, #16
c0de0ffc:	437e      	muls	r6, r7
c0de0ffe:	435d      	muls	r5, r3
c0de1000:	4367      	muls	r7, r4
c0de1002:	4363      	muls	r3, r4
c0de1004:	197f      	adds	r7, r7, r5
c0de1006:	0c34      	lsrs	r4, r6, #16
c0de1008:	19e4      	adds	r4, r4, r7
c0de100a:	469c      	mov	ip, r3
c0de100c:	42a5      	cmp	r5, r4
c0de100e:	d903      	bls.n	c0de1018 <__aeabi_lmul+0x34>
c0de1010:	2380      	movs	r3, #128	; 0x80
c0de1012:	025b      	lsls	r3, r3, #9
c0de1014:	4698      	mov	r8, r3
c0de1016:	44c4      	add	ip, r8
c0de1018:	464b      	mov	r3, r9
c0de101a:	4343      	muls	r3, r0
c0de101c:	4351      	muls	r1, r2
c0de101e:	0c25      	lsrs	r5, r4, #16
c0de1020:	0436      	lsls	r6, r6, #16
c0de1022:	4465      	add	r5, ip
c0de1024:	0c36      	lsrs	r6, r6, #16
c0de1026:	0424      	lsls	r4, r4, #16
c0de1028:	19a4      	adds	r4, r4, r6
c0de102a:	195b      	adds	r3, r3, r5
c0de102c:	1859      	adds	r1, r3, r1
c0de102e:	0020      	movs	r0, r4
c0de1030:	bc0c      	pop	{r2, r3}
c0de1032:	4690      	mov	r8, r2
c0de1034:	4699      	mov	r9, r3
c0de1036:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de1038 <__aeabi_memclr>:
c0de1038:	b510      	push	{r4, lr}
c0de103a:	2200      	movs	r2, #0
c0de103c:	f000 f80a 	bl	c0de1054 <__aeabi_memset>
c0de1040:	bd10      	pop	{r4, pc}
c0de1042:	46c0      	nop			; (mov r8, r8)

c0de1044 <__aeabi_memcpy>:
c0de1044:	b510      	push	{r4, lr}
c0de1046:	f000 f835 	bl	c0de10b4 <memcpy>
c0de104a:	bd10      	pop	{r4, pc}

c0de104c <__aeabi_memmove>:
c0de104c:	b510      	push	{r4, lr}
c0de104e:	f000 f885 	bl	c0de115c <memmove>
c0de1052:	bd10      	pop	{r4, pc}

c0de1054 <__aeabi_memset>:
c0de1054:	0013      	movs	r3, r2
c0de1056:	b510      	push	{r4, lr}
c0de1058:	000a      	movs	r2, r1
c0de105a:	0019      	movs	r1, r3
c0de105c:	f000 f8dc 	bl	c0de1218 <memset>
c0de1060:	bd10      	pop	{r4, pc}
c0de1062:	46c0      	nop			; (mov r8, r8)

c0de1064 <memcmp>:
c0de1064:	b530      	push	{r4, r5, lr}
c0de1066:	2a03      	cmp	r2, #3
c0de1068:	d90c      	bls.n	c0de1084 <memcmp+0x20>
c0de106a:	0003      	movs	r3, r0
c0de106c:	430b      	orrs	r3, r1
c0de106e:	079b      	lsls	r3, r3, #30
c0de1070:	d11c      	bne.n	c0de10ac <memcmp+0x48>
c0de1072:	6803      	ldr	r3, [r0, #0]
c0de1074:	680c      	ldr	r4, [r1, #0]
c0de1076:	42a3      	cmp	r3, r4
c0de1078:	d118      	bne.n	c0de10ac <memcmp+0x48>
c0de107a:	3a04      	subs	r2, #4
c0de107c:	3004      	adds	r0, #4
c0de107e:	3104      	adds	r1, #4
c0de1080:	2a03      	cmp	r2, #3
c0de1082:	d8f6      	bhi.n	c0de1072 <memcmp+0xe>
c0de1084:	1e55      	subs	r5, r2, #1
c0de1086:	2a00      	cmp	r2, #0
c0de1088:	d00e      	beq.n	c0de10a8 <memcmp+0x44>
c0de108a:	7802      	ldrb	r2, [r0, #0]
c0de108c:	780c      	ldrb	r4, [r1, #0]
c0de108e:	4294      	cmp	r4, r2
c0de1090:	d10e      	bne.n	c0de10b0 <memcmp+0x4c>
c0de1092:	3501      	adds	r5, #1
c0de1094:	2301      	movs	r3, #1
c0de1096:	3901      	subs	r1, #1
c0de1098:	e004      	b.n	c0de10a4 <memcmp+0x40>
c0de109a:	5cc2      	ldrb	r2, [r0, r3]
c0de109c:	3301      	adds	r3, #1
c0de109e:	5ccc      	ldrb	r4, [r1, r3]
c0de10a0:	42a2      	cmp	r2, r4
c0de10a2:	d105      	bne.n	c0de10b0 <memcmp+0x4c>
c0de10a4:	42ab      	cmp	r3, r5
c0de10a6:	d1f8      	bne.n	c0de109a <memcmp+0x36>
c0de10a8:	2000      	movs	r0, #0
c0de10aa:	bd30      	pop	{r4, r5, pc}
c0de10ac:	1e55      	subs	r5, r2, #1
c0de10ae:	e7ec      	b.n	c0de108a <memcmp+0x26>
c0de10b0:	1b10      	subs	r0, r2, r4
c0de10b2:	e7fa      	b.n	c0de10aa <memcmp+0x46>

c0de10b4 <memcpy>:
c0de10b4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de10b6:	46c6      	mov	lr, r8
c0de10b8:	b500      	push	{lr}
c0de10ba:	2a0f      	cmp	r2, #15
c0de10bc:	d943      	bls.n	c0de1146 <memcpy+0x92>
c0de10be:	000b      	movs	r3, r1
c0de10c0:	2603      	movs	r6, #3
c0de10c2:	4303      	orrs	r3, r0
c0de10c4:	401e      	ands	r6, r3
c0de10c6:	000c      	movs	r4, r1
c0de10c8:	0003      	movs	r3, r0
c0de10ca:	2e00      	cmp	r6, #0
c0de10cc:	d140      	bne.n	c0de1150 <memcpy+0x9c>
c0de10ce:	0015      	movs	r5, r2
c0de10d0:	3d10      	subs	r5, #16
c0de10d2:	092d      	lsrs	r5, r5, #4
c0de10d4:	46ac      	mov	ip, r5
c0de10d6:	012d      	lsls	r5, r5, #4
c0de10d8:	46a8      	mov	r8, r5
c0de10da:	4480      	add	r8, r0
c0de10dc:	e000      	b.n	c0de10e0 <memcpy+0x2c>
c0de10de:	003b      	movs	r3, r7
c0de10e0:	6867      	ldr	r7, [r4, #4]
c0de10e2:	6825      	ldr	r5, [r4, #0]
c0de10e4:	605f      	str	r7, [r3, #4]
c0de10e6:	68e7      	ldr	r7, [r4, #12]
c0de10e8:	601d      	str	r5, [r3, #0]
c0de10ea:	60df      	str	r7, [r3, #12]
c0de10ec:	001f      	movs	r7, r3
c0de10ee:	68a5      	ldr	r5, [r4, #8]
c0de10f0:	3710      	adds	r7, #16
c0de10f2:	609d      	str	r5, [r3, #8]
c0de10f4:	3410      	adds	r4, #16
c0de10f6:	4543      	cmp	r3, r8
c0de10f8:	d1f1      	bne.n	c0de10de <memcpy+0x2a>
c0de10fa:	4665      	mov	r5, ip
c0de10fc:	230f      	movs	r3, #15
c0de10fe:	240c      	movs	r4, #12
c0de1100:	3501      	adds	r5, #1
c0de1102:	012d      	lsls	r5, r5, #4
c0de1104:	1949      	adds	r1, r1, r5
c0de1106:	4013      	ands	r3, r2
c0de1108:	1945      	adds	r5, r0, r5
c0de110a:	4214      	tst	r4, r2
c0de110c:	d023      	beq.n	c0de1156 <memcpy+0xa2>
c0de110e:	598c      	ldr	r4, [r1, r6]
c0de1110:	51ac      	str	r4, [r5, r6]
c0de1112:	3604      	adds	r6, #4
c0de1114:	1b9c      	subs	r4, r3, r6
c0de1116:	2c03      	cmp	r4, #3
c0de1118:	d8f9      	bhi.n	c0de110e <memcpy+0x5a>
c0de111a:	2403      	movs	r4, #3
c0de111c:	3b04      	subs	r3, #4
c0de111e:	089b      	lsrs	r3, r3, #2
c0de1120:	3301      	adds	r3, #1
c0de1122:	009b      	lsls	r3, r3, #2
c0de1124:	4022      	ands	r2, r4
c0de1126:	18ed      	adds	r5, r5, r3
c0de1128:	18c9      	adds	r1, r1, r3
c0de112a:	1e56      	subs	r6, r2, #1
c0de112c:	2a00      	cmp	r2, #0
c0de112e:	d007      	beq.n	c0de1140 <memcpy+0x8c>
c0de1130:	2300      	movs	r3, #0
c0de1132:	e000      	b.n	c0de1136 <memcpy+0x82>
c0de1134:	0023      	movs	r3, r4
c0de1136:	5cca      	ldrb	r2, [r1, r3]
c0de1138:	1c5c      	adds	r4, r3, #1
c0de113a:	54ea      	strb	r2, [r5, r3]
c0de113c:	429e      	cmp	r6, r3
c0de113e:	d1f9      	bne.n	c0de1134 <memcpy+0x80>
c0de1140:	bc04      	pop	{r2}
c0de1142:	4690      	mov	r8, r2
c0de1144:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1146:	0005      	movs	r5, r0
c0de1148:	1e56      	subs	r6, r2, #1
c0de114a:	2a00      	cmp	r2, #0
c0de114c:	d1f0      	bne.n	c0de1130 <memcpy+0x7c>
c0de114e:	e7f7      	b.n	c0de1140 <memcpy+0x8c>
c0de1150:	1e56      	subs	r6, r2, #1
c0de1152:	0005      	movs	r5, r0
c0de1154:	e7ec      	b.n	c0de1130 <memcpy+0x7c>
c0de1156:	001a      	movs	r2, r3
c0de1158:	e7f6      	b.n	c0de1148 <memcpy+0x94>
c0de115a:	46c0      	nop			; (mov r8, r8)

c0de115c <memmove>:
c0de115c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de115e:	46c6      	mov	lr, r8
c0de1160:	b500      	push	{lr}
c0de1162:	4288      	cmp	r0, r1
c0de1164:	d90c      	bls.n	c0de1180 <memmove+0x24>
c0de1166:	188b      	adds	r3, r1, r2
c0de1168:	4298      	cmp	r0, r3
c0de116a:	d209      	bcs.n	c0de1180 <memmove+0x24>
c0de116c:	1e53      	subs	r3, r2, #1
c0de116e:	2a00      	cmp	r2, #0
c0de1170:	d003      	beq.n	c0de117a <memmove+0x1e>
c0de1172:	5cca      	ldrb	r2, [r1, r3]
c0de1174:	54c2      	strb	r2, [r0, r3]
c0de1176:	3b01      	subs	r3, #1
c0de1178:	d2fb      	bcs.n	c0de1172 <memmove+0x16>
c0de117a:	bc04      	pop	{r2}
c0de117c:	4690      	mov	r8, r2
c0de117e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1180:	2a0f      	cmp	r2, #15
c0de1182:	d80c      	bhi.n	c0de119e <memmove+0x42>
c0de1184:	0005      	movs	r5, r0
c0de1186:	1e56      	subs	r6, r2, #1
c0de1188:	2a00      	cmp	r2, #0
c0de118a:	d0f6      	beq.n	c0de117a <memmove+0x1e>
c0de118c:	2300      	movs	r3, #0
c0de118e:	e000      	b.n	c0de1192 <memmove+0x36>
c0de1190:	0023      	movs	r3, r4
c0de1192:	5cca      	ldrb	r2, [r1, r3]
c0de1194:	1c5c      	adds	r4, r3, #1
c0de1196:	54ea      	strb	r2, [r5, r3]
c0de1198:	429e      	cmp	r6, r3
c0de119a:	d1f9      	bne.n	c0de1190 <memmove+0x34>
c0de119c:	e7ed      	b.n	c0de117a <memmove+0x1e>
c0de119e:	000b      	movs	r3, r1
c0de11a0:	2603      	movs	r6, #3
c0de11a2:	4303      	orrs	r3, r0
c0de11a4:	401e      	ands	r6, r3
c0de11a6:	000c      	movs	r4, r1
c0de11a8:	0003      	movs	r3, r0
c0de11aa:	2e00      	cmp	r6, #0
c0de11ac:	d12e      	bne.n	c0de120c <memmove+0xb0>
c0de11ae:	0015      	movs	r5, r2
c0de11b0:	3d10      	subs	r5, #16
c0de11b2:	092d      	lsrs	r5, r5, #4
c0de11b4:	46ac      	mov	ip, r5
c0de11b6:	012d      	lsls	r5, r5, #4
c0de11b8:	46a8      	mov	r8, r5
c0de11ba:	4480      	add	r8, r0
c0de11bc:	e000      	b.n	c0de11c0 <memmove+0x64>
c0de11be:	002b      	movs	r3, r5
c0de11c0:	001d      	movs	r5, r3
c0de11c2:	6827      	ldr	r7, [r4, #0]
c0de11c4:	3510      	adds	r5, #16
c0de11c6:	601f      	str	r7, [r3, #0]
c0de11c8:	6867      	ldr	r7, [r4, #4]
c0de11ca:	605f      	str	r7, [r3, #4]
c0de11cc:	68a7      	ldr	r7, [r4, #8]
c0de11ce:	609f      	str	r7, [r3, #8]
c0de11d0:	68e7      	ldr	r7, [r4, #12]
c0de11d2:	3410      	adds	r4, #16
c0de11d4:	60df      	str	r7, [r3, #12]
c0de11d6:	4543      	cmp	r3, r8
c0de11d8:	d1f1      	bne.n	c0de11be <memmove+0x62>
c0de11da:	4665      	mov	r5, ip
c0de11dc:	230f      	movs	r3, #15
c0de11de:	240c      	movs	r4, #12
c0de11e0:	3501      	adds	r5, #1
c0de11e2:	012d      	lsls	r5, r5, #4
c0de11e4:	1949      	adds	r1, r1, r5
c0de11e6:	4013      	ands	r3, r2
c0de11e8:	1945      	adds	r5, r0, r5
c0de11ea:	4214      	tst	r4, r2
c0de11ec:	d011      	beq.n	c0de1212 <memmove+0xb6>
c0de11ee:	598c      	ldr	r4, [r1, r6]
c0de11f0:	51ac      	str	r4, [r5, r6]
c0de11f2:	3604      	adds	r6, #4
c0de11f4:	1b9c      	subs	r4, r3, r6
c0de11f6:	2c03      	cmp	r4, #3
c0de11f8:	d8f9      	bhi.n	c0de11ee <memmove+0x92>
c0de11fa:	2403      	movs	r4, #3
c0de11fc:	3b04      	subs	r3, #4
c0de11fe:	089b      	lsrs	r3, r3, #2
c0de1200:	3301      	adds	r3, #1
c0de1202:	009b      	lsls	r3, r3, #2
c0de1204:	18ed      	adds	r5, r5, r3
c0de1206:	18c9      	adds	r1, r1, r3
c0de1208:	4022      	ands	r2, r4
c0de120a:	e7bc      	b.n	c0de1186 <memmove+0x2a>
c0de120c:	1e56      	subs	r6, r2, #1
c0de120e:	0005      	movs	r5, r0
c0de1210:	e7bc      	b.n	c0de118c <memmove+0x30>
c0de1212:	001a      	movs	r2, r3
c0de1214:	e7b7      	b.n	c0de1186 <memmove+0x2a>
c0de1216:	46c0      	nop			; (mov r8, r8)

c0de1218 <memset>:
c0de1218:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de121a:	0005      	movs	r5, r0
c0de121c:	0783      	lsls	r3, r0, #30
c0de121e:	d04a      	beq.n	c0de12b6 <memset+0x9e>
c0de1220:	1e54      	subs	r4, r2, #1
c0de1222:	2a00      	cmp	r2, #0
c0de1224:	d044      	beq.n	c0de12b0 <memset+0x98>
c0de1226:	b2ce      	uxtb	r6, r1
c0de1228:	0003      	movs	r3, r0
c0de122a:	2203      	movs	r2, #3
c0de122c:	e002      	b.n	c0de1234 <memset+0x1c>
c0de122e:	3501      	adds	r5, #1
c0de1230:	3c01      	subs	r4, #1
c0de1232:	d33d      	bcc.n	c0de12b0 <memset+0x98>
c0de1234:	3301      	adds	r3, #1
c0de1236:	702e      	strb	r6, [r5, #0]
c0de1238:	4213      	tst	r3, r2
c0de123a:	d1f8      	bne.n	c0de122e <memset+0x16>
c0de123c:	2c03      	cmp	r4, #3
c0de123e:	d92f      	bls.n	c0de12a0 <memset+0x88>
c0de1240:	22ff      	movs	r2, #255	; 0xff
c0de1242:	400a      	ands	r2, r1
c0de1244:	0215      	lsls	r5, r2, #8
c0de1246:	4315      	orrs	r5, r2
c0de1248:	042a      	lsls	r2, r5, #16
c0de124a:	4315      	orrs	r5, r2
c0de124c:	2c0f      	cmp	r4, #15
c0de124e:	d935      	bls.n	c0de12bc <memset+0xa4>
c0de1250:	0027      	movs	r7, r4
c0de1252:	3f10      	subs	r7, #16
c0de1254:	093f      	lsrs	r7, r7, #4
c0de1256:	013e      	lsls	r6, r7, #4
c0de1258:	46b4      	mov	ip, r6
c0de125a:	001e      	movs	r6, r3
c0de125c:	001a      	movs	r2, r3
c0de125e:	3610      	adds	r6, #16
c0de1260:	4466      	add	r6, ip
c0de1262:	6015      	str	r5, [r2, #0]
c0de1264:	6055      	str	r5, [r2, #4]
c0de1266:	6095      	str	r5, [r2, #8]
c0de1268:	60d5      	str	r5, [r2, #12]
c0de126a:	3210      	adds	r2, #16
c0de126c:	42b2      	cmp	r2, r6
c0de126e:	d1f8      	bne.n	c0de1262 <memset+0x4a>
c0de1270:	260f      	movs	r6, #15
c0de1272:	220c      	movs	r2, #12
c0de1274:	3701      	adds	r7, #1
c0de1276:	013f      	lsls	r7, r7, #4
c0de1278:	4026      	ands	r6, r4
c0de127a:	19db      	adds	r3, r3, r7
c0de127c:	0037      	movs	r7, r6
c0de127e:	4222      	tst	r2, r4
c0de1280:	d017      	beq.n	c0de12b2 <memset+0x9a>
c0de1282:	1f3e      	subs	r6, r7, #4
c0de1284:	08b6      	lsrs	r6, r6, #2
c0de1286:	00b4      	lsls	r4, r6, #2
c0de1288:	46a4      	mov	ip, r4
c0de128a:	001a      	movs	r2, r3
c0de128c:	1d1c      	adds	r4, r3, #4
c0de128e:	4464      	add	r4, ip
c0de1290:	c220      	stmia	r2!, {r5}
c0de1292:	42a2      	cmp	r2, r4
c0de1294:	d1fc      	bne.n	c0de1290 <memset+0x78>
c0de1296:	2403      	movs	r4, #3
c0de1298:	3601      	adds	r6, #1
c0de129a:	00b6      	lsls	r6, r6, #2
c0de129c:	199b      	adds	r3, r3, r6
c0de129e:	403c      	ands	r4, r7
c0de12a0:	2c00      	cmp	r4, #0
c0de12a2:	d005      	beq.n	c0de12b0 <memset+0x98>
c0de12a4:	b2c9      	uxtb	r1, r1
c0de12a6:	191c      	adds	r4, r3, r4
c0de12a8:	7019      	strb	r1, [r3, #0]
c0de12aa:	3301      	adds	r3, #1
c0de12ac:	429c      	cmp	r4, r3
c0de12ae:	d1fb      	bne.n	c0de12a8 <memset+0x90>
c0de12b0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de12b2:	0034      	movs	r4, r6
c0de12b4:	e7f4      	b.n	c0de12a0 <memset+0x88>
c0de12b6:	0014      	movs	r4, r2
c0de12b8:	0003      	movs	r3, r0
c0de12ba:	e7bf      	b.n	c0de123c <memset+0x24>
c0de12bc:	0027      	movs	r7, r4
c0de12be:	e7e0      	b.n	c0de1282 <memset+0x6a>

c0de12c0 <setjmp>:
c0de12c0:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de12c2:	4641      	mov	r1, r8
c0de12c4:	464a      	mov	r2, r9
c0de12c6:	4653      	mov	r3, sl
c0de12c8:	465c      	mov	r4, fp
c0de12ca:	466d      	mov	r5, sp
c0de12cc:	4676      	mov	r6, lr
c0de12ce:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de12d0:	3828      	subs	r0, #40	; 0x28
c0de12d2:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de12d4:	2000      	movs	r0, #0
c0de12d6:	4770      	bx	lr

c0de12d8 <longjmp>:
c0de12d8:	3010      	adds	r0, #16
c0de12da:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de12dc:	4690      	mov	r8, r2
c0de12de:	4699      	mov	r9, r3
c0de12e0:	46a2      	mov	sl, r4
c0de12e2:	46ab      	mov	fp, r5
c0de12e4:	46b5      	mov	sp, r6
c0de12e6:	c808      	ldmia	r0!, {r3}
c0de12e8:	3828      	subs	r0, #40	; 0x28
c0de12ea:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de12ec:	1c08      	adds	r0, r1, #0
c0de12ee:	d100      	bne.n	c0de12f2 <longjmp+0x1a>
c0de12f0:	2001      	movs	r0, #1
c0de12f2:	4718      	bx	r3

c0de12f4 <strlcpy>:
c0de12f4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de12f6:	2a00      	cmp	r2, #0
c0de12f8:	d013      	beq.n	c0de1322 <strlcpy+0x2e>
c0de12fa:	3a01      	subs	r2, #1
c0de12fc:	2a00      	cmp	r2, #0
c0de12fe:	d019      	beq.n	c0de1334 <strlcpy+0x40>
c0de1300:	2300      	movs	r3, #0
c0de1302:	1c4f      	adds	r7, r1, #1
c0de1304:	1c46      	adds	r6, r0, #1
c0de1306:	e002      	b.n	c0de130e <strlcpy+0x1a>
c0de1308:	3301      	adds	r3, #1
c0de130a:	429a      	cmp	r2, r3
c0de130c:	d016      	beq.n	c0de133c <strlcpy+0x48>
c0de130e:	18f5      	adds	r5, r6, r3
c0de1310:	46ac      	mov	ip, r5
c0de1312:	5ccd      	ldrb	r5, [r1, r3]
c0de1314:	18fc      	adds	r4, r7, r3
c0de1316:	54c5      	strb	r5, [r0, r3]
c0de1318:	2d00      	cmp	r5, #0
c0de131a:	d1f5      	bne.n	c0de1308 <strlcpy+0x14>
c0de131c:	1a60      	subs	r0, r4, r1
c0de131e:	3801      	subs	r0, #1
c0de1320:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1322:	000c      	movs	r4, r1
c0de1324:	0023      	movs	r3, r4
c0de1326:	3301      	adds	r3, #1
c0de1328:	1e5a      	subs	r2, r3, #1
c0de132a:	7812      	ldrb	r2, [r2, #0]
c0de132c:	001c      	movs	r4, r3
c0de132e:	2a00      	cmp	r2, #0
c0de1330:	d1f9      	bne.n	c0de1326 <strlcpy+0x32>
c0de1332:	e7f3      	b.n	c0de131c <strlcpy+0x28>
c0de1334:	000c      	movs	r4, r1
c0de1336:	2300      	movs	r3, #0
c0de1338:	7003      	strb	r3, [r0, #0]
c0de133a:	e7f3      	b.n	c0de1324 <strlcpy+0x30>
c0de133c:	4660      	mov	r0, ip
c0de133e:	e7fa      	b.n	c0de1336 <strlcpy+0x42>

c0de1340 <strnlen>:
c0de1340:	b510      	push	{r4, lr}
c0de1342:	2900      	cmp	r1, #0
c0de1344:	d00b      	beq.n	c0de135e <strnlen+0x1e>
c0de1346:	7803      	ldrb	r3, [r0, #0]
c0de1348:	2b00      	cmp	r3, #0
c0de134a:	d00c      	beq.n	c0de1366 <strnlen+0x26>
c0de134c:	1844      	adds	r4, r0, r1
c0de134e:	0003      	movs	r3, r0
c0de1350:	e002      	b.n	c0de1358 <strnlen+0x18>
c0de1352:	781a      	ldrb	r2, [r3, #0]
c0de1354:	2a00      	cmp	r2, #0
c0de1356:	d004      	beq.n	c0de1362 <strnlen+0x22>
c0de1358:	3301      	adds	r3, #1
c0de135a:	42a3      	cmp	r3, r4
c0de135c:	d1f9      	bne.n	c0de1352 <strnlen+0x12>
c0de135e:	0008      	movs	r0, r1
c0de1360:	bd10      	pop	{r4, pc}
c0de1362:	1a19      	subs	r1, r3, r0
c0de1364:	e7fb      	b.n	c0de135e <strnlen+0x1e>
c0de1366:	2100      	movs	r1, #0
c0de1368:	e7f9      	b.n	c0de135e <strnlen+0x1e>
c0de136a:	46c0      	nop			; (mov r8, r8)
c0de136c:	6c50      	ldr	r0, [r2, #68]	; 0x44
c0de136e:	6775      	str	r5, [r6, #116]	; 0x74
c0de1370:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de1372:	7020      	strb	r0, [r4, #0]
c0de1374:	7261      	strb	r1, [r4, #9]
c0de1376:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de1378:	7465      	strb	r5, [r4, #17]
c0de137a:	7265      	strb	r5, [r4, #9]
c0de137c:	2073      	movs	r0, #115	; 0x73
c0de137e:	7473      	strb	r3, [r6, #17]
c0de1380:	7572      	strb	r2, [r6, #21]
c0de1382:	7463      	strb	r3, [r4, #17]
c0de1384:	7275      	strb	r5, [r6, #9]
c0de1386:	2065      	movs	r0, #101	; 0x65
c0de1388:	7369      	strb	r1, [r5, #13]
c0de138a:	6220      	str	r0, [r4, #32]
c0de138c:	6769      	str	r1, [r5, #116]	; 0x74
c0de138e:	6567      	str	r7, [r4, #84]	; 0x54
c0de1390:	2072      	movs	r0, #114	; 0x72
c0de1392:	6874      	ldr	r4, [r6, #4]
c0de1394:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de1396:	6120      	str	r0, [r4, #16]
c0de1398:	6c6c      	ldr	r4, [r5, #68]	; 0x44
c0de139a:	776f      	strb	r7, [r5, #29]
c0de139c:	6465      	str	r5, [r4, #68]	; 0x44
c0de139e:	7320      	strb	r0, [r4, #12]
c0de13a0:	7a69      	ldrb	r1, [r5, #9]
c0de13a2:	0a65      	lsrs	r5, r4, #9
c0de13a4:	5300      	strh	r0, [r0, r4]
c0de13a6:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de13a8:	0064      	lsls	r4, r4, #1
c0de13aa:	4157      	adcs	r7, r2
c0de13ac:	4e52      	ldr	r6, [pc, #328]	; (c0de14f8 <strnlen+0x1b8>)
c0de13ae:	4e49      	ldr	r6, [pc, #292]	; (c0de14d4 <strnlen+0x194>)
c0de13b0:	0047      	lsls	r7, r0, #1
c0de13b2:	656f      	str	r7, [r5, #84]	; 0x54
c0de13b4:	6874      	ldr	r4, [r6, #4]
c0de13b6:	7020      	strb	r0, [r4, #0]
c0de13b8:	756c      	strb	r4, [r5, #21]
c0de13ba:	6967      	ldr	r7, [r4, #20]
c0de13bc:	206e      	movs	r0, #110	; 0x6e
c0de13be:	7270      	strb	r0, [r6, #9]
c0de13c0:	766f      	strb	r7, [r5, #25]
c0de13c2:	6469      	str	r1, [r5, #68]	; 0x44
c0de13c4:	2065      	movs	r0, #101	; 0x65
c0de13c6:	6170      	str	r0, [r6, #20]
c0de13c8:	6172      	str	r2, [r6, #20]
c0de13ca:	656d      	str	r5, [r5, #84]	; 0x54
c0de13cc:	6574      	str	r4, [r6, #84]	; 0x54
c0de13ce:	3a72      	subs	r2, #114	; 0x72
c0de13d0:	0020      	movs	r0, r4
c0de13d2:	0020      	movs	r0, r4
c0de13d4:	6150      	str	r0, [r2, #20]
c0de13d6:	6172      	str	r2, [r6, #20]
c0de13d8:	206d      	movs	r0, #109	; 0x6d
c0de13da:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de13dc:	2074      	movs	r0, #116	; 0x74
c0de13de:	7573      	strb	r3, [r6, #21]
c0de13e0:	7070      	strb	r0, [r6, #1]
c0de13e2:	726f      	strb	r7, [r5, #9]
c0de13e4:	6574      	str	r4, [r6, #84]	; 0x54
c0de13e6:	0a64      	lsrs	r4, r4, #9
c0de13e8:	5400      	strb	r0, [r0, r0]
c0de13ea:	4b4f      	ldr	r3, [pc, #316]	; (c0de1528 <strnlen+0x1e8>)
c0de13ec:	4e45      	ldr	r6, [pc, #276]	; (c0de1504 <strnlen+0x1c4>)
c0de13ee:	5320      	strh	r0, [r4, r4]
c0de13f0:	4e45      	ldr	r6, [pc, #276]	; (c0de1508 <strnlen+0x1c8>)
c0de13f2:	3a54      	subs	r2, #84	; 0x54
c0de13f4:	0020      	movs	r0, r4
c0de13f6:	454f      	cmp	r7, r9
c0de13f8:	4854      	ldr	r0, [pc, #336]	; (c0de154c <strnlen+0x20c>)
c0de13fa:	7020      	strb	r0, [r4, #0]
c0de13fc:	756c      	strb	r4, [r5, #21]
c0de13fe:	6967      	ldr	r7, [r4, #20]
c0de1400:	206e      	movs	r0, #110	; 0x6e
c0de1402:	7270      	strb	r0, [r6, #9]
c0de1404:	766f      	strb	r7, [r5, #25]
c0de1406:	6469      	str	r1, [r5, #68]	; 0x44
c0de1408:	2065      	movs	r0, #101	; 0x65
c0de140a:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de140c:	656b      	str	r3, [r5, #84]	; 0x54
c0de140e:	3a6e      	subs	r2, #110	; 0x6e
c0de1410:	3020      	adds	r0, #32
c0de1412:	2578      	movs	r5, #120	; 0x78
c0de1414:	2c70      	cmp	r4, #112	; 0x70
c0de1416:	3020      	adds	r0, #32
c0de1418:	2578      	movs	r5, #120	; 0x78
c0de141a:	0a70      	lsrs	r0, r6, #9
c0de141c:	4d00      	ldr	r5, [pc, #0]	; (c0de1420 <strnlen+0xe0>)
c0de141e:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de1420:	0074      	lsls	r4, r6, #1
c0de1422:	3025      	adds	r0, #37	; 0x25
c0de1424:	7832      	ldrb	r2, [r6, #0]
c0de1426:	5300      	strh	r0, [r0, r4]
c0de1428:	6177      	str	r7, [r6, #20]
c0de142a:	0070      	lsls	r0, r6, #1
c0de142c:	4f54      	ldr	r7, [pc, #336]	; (c0de1580 <strnlen+0x240>)
c0de142e:	454b      	cmp	r3, r9
c0de1430:	204e      	movs	r0, #78	; 0x4e
c0de1432:	4552      	cmp	r2, sl
c0de1434:	4543      	cmp	r3, r8
c0de1436:	5649      	ldrsb	r1, [r1, r1]
c0de1438:	4445      	add	r5, r8
c0de143a:	203a      	movs	r0, #58	; 0x3a
c0de143c:	4f00      	ldr	r7, [pc, #0]	; (c0de1440 <strnlen+0x100>)
c0de143e:	5355      	strh	r5, [r2, r5]
c0de1440:	0044      	lsls	r4, r0, #1
c0de1442:	724f      	strb	r7, [r1, #9]
c0de1444:	6769      	str	r1, [r5, #116]	; 0x74
c0de1446:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de1448:	4420      	add	r0, r4
c0de144a:	4665      	mov	r5, ip
c0de144c:	0069      	lsls	r1, r5, #1
c0de144e:	6552      	str	r2, [r2, #84]	; 0x54
c0de1450:	6564      	str	r4, [r4, #84]	; 0x54
c0de1452:	6d65      	ldr	r5, [r4, #84]	; 0x54
c0de1454:	4500      	cmp	r0, r0
c0de1456:	6874      	ldr	r4, [r6, #4]
c0de1458:	7265      	strb	r5, [r4, #9]
c0de145a:	7565      	strb	r5, [r4, #21]
c0de145c:	006d      	lsls	r5, r5, #1
c0de145e:	0030      	movs	r0, r6
c0de1460:	6553      	str	r3, [r2, #84]	; 0x54
c0de1462:	7474      	strb	r4, [r6, #17]
c0de1464:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de1466:	2067      	movs	r0, #103	; 0x67
c0de1468:	6461      	str	r1, [r4, #68]	; 0x44
c0de146a:	7264      	strb	r4, [r4, #9]
c0de146c:	7365      	strb	r5, [r4, #13]
c0de146e:	2073      	movs	r0, #115	; 0x73
c0de1470:	6572      	str	r2, [r6, #84]	; 0x54
c0de1472:	6563      	str	r3, [r4, #84]	; 0x54
c0de1474:	7669      	strb	r1, [r5, #25]
c0de1476:	6465      	str	r5, [r4, #68]	; 0x44
c0de1478:	7420      	strb	r0, [r4, #16]
c0de147a:	3a6f      	subs	r2, #111	; 0x6f
c0de147c:	0020      	movs	r0, r4
c0de147e:	6150      	str	r0, [r2, #20]
c0de1480:	6172      	str	r2, [r6, #20]
c0de1482:	206d      	movs	r0, #109	; 0x6d
c0de1484:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de1486:	2074      	movs	r0, #116	; 0x74
c0de1488:	7573      	strb	r3, [r6, #21]
c0de148a:	7070      	strb	r0, [r6, #1]
c0de148c:	726f      	strb	r7, [r5, #9]
c0de148e:	6574      	str	r4, [r6, #84]	; 0x54
c0de1490:	3a64      	subs	r2, #100	; 0x64
c0de1492:	2520      	movs	r5, #32
c0de1494:	0a64      	lsrs	r4, r4, #9
c0de1496:	5200      	strh	r0, [r0, r0]
c0de1498:	6365      	str	r5, [r4, #52]	; 0x34
c0de149a:	6965      	ldr	r5, [r4, #20]
c0de149c:	6576      	str	r6, [r6, #84]	; 0x54
c0de149e:	4d20      	ldr	r5, [pc, #128]	; (c0de1520 <strnlen+0x1e0>)
c0de14a0:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de14a2:	4500      	cmp	r0, r0
c0de14a4:	6378      	str	r0, [r7, #52]	; 0x34
c0de14a6:	7065      	strb	r5, [r4, #1]
c0de14a8:	6974      	ldr	r4, [r6, #20]
c0de14aa:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de14ac:	3020      	adds	r0, #32
c0de14ae:	2578      	movs	r5, #120	; 0x78
c0de14b0:	2078      	movs	r0, #120	; 0x78
c0de14b2:	6163      	str	r3, [r4, #20]
c0de14b4:	6775      	str	r5, [r6, #116]	; 0x74
c0de14b6:	7468      	strb	r0, [r5, #17]
c0de14b8:	000a      	movs	r2, r1
c0de14ba:	5445      	strb	r5, [r0, r1]
c0de14bc:	2048      	movs	r0, #72	; 0x48
c0de14be:	4553      	cmp	r3, sl
c0de14c0:	454c      	cmp	r4, r9
c0de14c2:	5443      	strb	r3, [r0, r1]
c0de14c4:	4445      	add	r5, r8
c0de14c6:	203a      	movs	r0, #58	; 0x3a
c0de14c8:	7300      	strb	r0, [r0, #12]
c0de14ca:	7266      	strb	r6, [r4, #9]
c0de14cc:	4578      	cmp	r0, pc
c0de14ce:	4854      	ldr	r0, [pc, #336]	; (c0de1620 <strnlen+0x2e0>)
c0de14d0:	5500      	strb	r0, [r0, r4]
c0de14d2:	6b6e      	ldr	r6, [r5, #52]	; 0x34
c0de14d4:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de14d6:	6e77      	ldr	r7, [r6, #100]	; 0x64
c0de14d8:	7420      	strb	r0, [r4, #16]
c0de14da:	6b6f      	ldr	r7, [r5, #52]	; 0x34
c0de14dc:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de14de:	6400      	str	r0, [r0, #64]	; 0x40
c0de14e0:	7365      	strb	r5, [r4, #13]
c0de14e2:	6974      	ldr	r4, [r6, #20]
c0de14e4:	616e      	str	r6, [r5, #20]
c0de14e6:	6974      	ldr	r4, [r6, #20]
c0de14e8:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de14ea:	203a      	movs	r0, #58	; 0x3a
c0de14ec:	6500      	str	r0, [r0, #80]	; 0x50
c0de14ee:	6378      	str	r0, [r7, #52]	; 0x34
c0de14f0:	7065      	strb	r5, [r4, #1]
c0de14f2:	6974      	ldr	r4, [r6, #20]
c0de14f4:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de14f6:	255b      	movs	r5, #91	; 0x5b
c0de14f8:	5d64      	ldrb	r4, [r4, r5]
c0de14fa:	203a      	movs	r0, #58	; 0x3a
c0de14fc:	524c      	strh	r4, [r1, r1]
c0de14fe:	303d      	adds	r0, #61	; 0x3d
c0de1500:	2578      	movs	r5, #120	; 0x78
c0de1502:	3830      	subs	r0, #48	; 0x30
c0de1504:	0a58      	lsrs	r0, r3, #9
c0de1506:	4500      	cmp	r0, r0
c0de1508:	5252      	strh	r2, [r2, r1]
c0de150a:	524f      	strh	r7, [r1, r1]
c0de150c:	5500      	strb	r0, [r0, r4]
c0de150e:	686e      	ldr	r6, [r5, #4]
c0de1510:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de1512:	6c64      	ldr	r4, [r4, #68]	; 0x44
c0de1514:	6465      	str	r5, [r4, #68]	; 0x44
c0de1516:	6d20      	ldr	r0, [r4, #80]	; 0x50
c0de1518:	7365      	strb	r5, [r4, #13]
c0de151a:	6173      	str	r3, [r6, #20]
c0de151c:	6567      	str	r7, [r4, #84]	; 0x54
c0de151e:	2520      	movs	r5, #32
c0de1520:	0a64      	lsrs	r4, r4, #9
c0de1522:	5300      	strh	r0, [r0, r4]
c0de1524:	7465      	strb	r5, [r4, #17]
c0de1526:	6974      	ldr	r4, [r6, #20]
c0de1528:	676e      	str	r6, [r5, #116]	; 0x74
c0de152a:	6120      	str	r0, [r4, #16]
c0de152c:	6464      	str	r4, [r4, #68]	; 0x44
c0de152e:	6572      	str	r2, [r6, #84]	; 0x54
c0de1530:	7373      	strb	r3, [r6, #13]
c0de1532:	7320      	strb	r0, [r4, #12]
c0de1534:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de1536:	2074      	movs	r0, #116	; 0x74
c0de1538:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de153a:	203a      	movs	r0, #58	; 0x3a
c0de153c:	0a00      	lsrs	r0, r0, #8
c0de153e:	5200      	strh	r0, [r0, r0]
c0de1540:	6365      	str	r5, [r4, #52]	; 0x34
c0de1542:	6965      	ldr	r5, [r4, #20]
c0de1544:	6576      	str	r6, [r6, #84]	; 0x54
c0de1546:	2064      	movs	r0, #100	; 0x64
c0de1548:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de154a:	6920      	ldr	r0, [r4, #16]
c0de154c:	766e      	strb	r6, [r5, #25]
c0de154e:	6c61      	ldr	r1, [r4, #68]	; 0x44
c0de1550:	6469      	str	r1, [r5, #68]	; 0x44
c0de1552:	7320      	strb	r0, [r4, #12]
c0de1554:	7263      	strb	r3, [r4, #9]
c0de1556:	6565      	str	r5, [r4, #84]	; 0x54
c0de1558:	496e      	ldr	r1, [pc, #440]	; (c0de1714 <_envram_data+0x14>)
c0de155a:	646e      	str	r6, [r5, #68]	; 0x44
c0de155c:	7865      	ldrb	r5, [r4, #1]
c0de155e:	000a      	movs	r2, r1
c0de1560:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de1562:	6f63      	ldr	r3, [r4, #116]	; 0x74
c0de1564:	696d      	ldr	r5, [r5, #20]
c0de1566:	676e      	str	r6, [r5, #116]	; 0x74
c0de1568:	7020      	strb	r0, [r4, #0]
c0de156a:	7261      	strb	r1, [r4, #9]
c0de156c:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de156e:	7465      	strb	r5, [r4, #17]
c0de1570:	7265      	strb	r5, [r4, #9]
c0de1572:	203a      	movs	r0, #58	; 0x3a
c0de1574:	4100      	asrs	r0, r0
c0de1576:	4f4d      	ldr	r7, [pc, #308]	; (c0de16ac <NULL_ETH_ADDRESS+0x10>)
c0de1578:	4e55      	ldr	r6, [pc, #340]	; (c0de16d0 <_etext+0x20>)
c0de157a:	2054      	movs	r0, #84	; 0x54
c0de157c:	4553      	cmp	r3, sl
c0de157e:	544e      	strb	r6, [r1, r1]
c0de1580:	203a      	movs	r0, #58	; 0x3a
c0de1582:	7325      	strb	r5, [r4, #12]
c0de1584:	000a      	movs	r2, r1
c0de1586:	5300      	strh	r0, [r0, r4]
c0de1588:	6c65      	ldr	r5, [r4, #68]	; 0x44
c0de158a:	6365      	str	r5, [r4, #52]	; 0x34
c0de158c:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de158e:	2072      	movs	r0, #114	; 0x72
c0de1590:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de1592:	6564      	str	r4, [r4, #84]	; 0x54
c0de1594:	2078      	movs	r0, #120	; 0x78
c0de1596:	253a      	movs	r5, #58	; 0x3a
c0de1598:	2064      	movs	r0, #100	; 0x64
c0de159a:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de159c:	2074      	movs	r0, #116	; 0x74
c0de159e:	7573      	strb	r3, [r6, #21]
c0de15a0:	7070      	strb	r0, [r6, #1]
c0de15a2:	726f      	strb	r7, [r5, #9]
c0de15a4:	6574      	str	r4, [r6, #84]	; 0x54
c0de15a6:	0a64      	lsrs	r4, r4, #9
c0de15a8:	5500      	strb	r0, [r0, r4]
c0de15aa:	686e      	ldr	r6, [r5, #4]
c0de15ac:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de15ae:	6c64      	ldr	r4, [r4, #68]	; 0x44
c0de15b0:	6465      	str	r5, [r4, #68]	; 0x44
c0de15b2:	7320      	strb	r0, [r4, #12]
c0de15b4:	6c65      	ldr	r5, [r4, #68]	; 0x44
c0de15b6:	6365      	str	r5, [r4, #52]	; 0x34
c0de15b8:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de15ba:	2072      	movs	r0, #114	; 0x72
c0de15bc:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de15be:	6564      	str	r4, [r4, #84]	; 0x54
c0de15c0:	3a78      	subs	r2, #120	; 0x78
c0de15c2:	2520      	movs	r5, #32
c0de15c4:	0a64      	lsrs	r4, r4, #9
c0de15c6:	5500      	strb	r0, [r0, r4]
c0de15c8:	494e      	ldr	r1, [pc, #312]	; (c0de1704 <_envram_data+0x4>)
c0de15ca:	5354      	strh	r4, [r2, r5]
c0de15cc:	4400      	add	r0, r0
c0de15ce:	7065      	strb	r5, [r4, #1]
c0de15d0:	736f      	strb	r7, [r5, #13]
c0de15d2:	7469      	strb	r1, [r5, #17]
c0de15d4:	4d00      	ldr	r5, [pc, #0]	; (c0de15d8 <strnlen+0x298>)
c0de15d6:	7369      	strb	r1, [r5, #13]
c0de15d8:	6973      	ldr	r3, [r6, #20]
c0de15da:	676e      	str	r6, [r5, #116]	; 0x74
c0de15dc:	7320      	strb	r0, [r4, #12]
c0de15de:	6c65      	ldr	r5, [r4, #68]	; 0x44
c0de15e0:	6365      	str	r5, [r4, #52]	; 0x34
c0de15e2:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de15e4:	4972      	ldr	r1, [pc, #456]	; (c0de17b0 <_envram_data+0xb0>)
c0de15e6:	646e      	str	r6, [r5, #68]	; 0x44
c0de15e8:	7865      	ldrb	r5, [r4, #1]
c0de15ea:	203a      	movs	r0, #58	; 0x3a
c0de15ec:	6425      	str	r5, [r4, #64]	; 0x40
c0de15ee:	000a      	movs	r2, r1
c0de15f0:	6553      	str	r3, [r2, #84]	; 0x54
c0de15f2:	656c      	str	r4, [r5, #84]	; 0x54
c0de15f4:	7463      	strb	r3, [r4, #17]
c0de15f6:	726f      	strb	r7, [r5, #9]
c0de15f8:	4920      	ldr	r1, [pc, #128]	; (c0de167c <g_pcHex>)
c0de15fa:	646e      	str	r6, [r5, #68]	; 0x44
c0de15fc:	7865      	ldrb	r5, [r4, #1]
c0de15fe:	2520      	movs	r5, #32
c0de1600:	2064      	movs	r0, #100	; 0x64
c0de1602:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de1604:	2074      	movs	r0, #116	; 0x74
c0de1606:	7573      	strb	r3, [r6, #21]
c0de1608:	7070      	strb	r0, [r6, #1]
c0de160a:	726f      	strb	r7, [r5, #9]
c0de160c:	6574      	str	r4, [r6, #84]	; 0x54
c0de160e:	0a64      	lsrs	r4, r4, #9
c0de1610:	4f00      	ldr	r7, [pc, #0]	; (c0de1614 <strnlen+0x2d4>)
c0de1612:	5445      	strb	r5, [r0, r1]
c0de1614:	0048      	lsls	r0, r1, #1
c0de1616:	4d41      	ldr	r5, [pc, #260]	; (c0de171c <_envram_data+0x1c>)
c0de1618:	554f      	strb	r7, [r1, r5]
c0de161a:	544e      	strb	r6, [r1, r1]
c0de161c:	5220      	strh	r0, [r4, r0]
c0de161e:	4345      	muls	r5, r0
c0de1620:	4945      	ldr	r1, [pc, #276]	; (c0de1738 <_envram_data+0x38>)
c0de1622:	4556      	cmp	r6, sl
c0de1624:	3a44      	subs	r2, #68	; 0x44
c0de1626:	2520      	movs	r5, #32
c0de1628:	0a73      	lsrs	r3, r6, #9
c0de162a:	4f00      	ldr	r7, [pc, #0]	; (c0de162c <strnlen+0x2ec>)
c0de162c:	5445      	strb	r5, [r0, r1]
c0de162e:	2048      	movs	r0, #72	; 0x48
c0de1630:	4553      	cmp	r3, sl
c0de1632:	454c      	cmp	r4, r9
c0de1634:	5443      	strb	r3, [r0, r1]
c0de1636:	4445      	add	r5, r8
c0de1638:	203a      	movs	r0, #58	; 0x3a
c0de163a:	d400      	bmi.n	c0de163e <ORIGIN_DEFI_SELECTORS+0x2>

c0de163c <ORIGIN_DEFI_SELECTORS>:
c0de163c:	0db0 d0e3 e97d d443 29f6 156e 2373 7cbc     ....}.C..)n.s#.|
c0de164c:	2124 3df0 0000 0000                         $!.=....

c0de1654 <OETH_ADDRESS>:
c0de1654:	6c85 fb4e c176 aed1 e202 eb0c a203 a0a6     .lN.v...........
c0de1664:	0b8b c38d                                   ....

c0de1668 <OETH_VAULT_ADDRESS>:
c0de1668:	2539 3340 5a94 e4a2 9c80 97c2 707e be87     9%@3.Z......~p..
c0de1678:	8be4 abd7                                   ....

c0de167c <g_pcHex>:
c0de167c:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de168c <g_pcHex_cap>:
c0de168c:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de169c <NULL_ETH_ADDRESS>:
	...

c0de16b0 <_etext>:
c0de16b0:	d4d4      	bmi.n	c0de165c <OETH_ADDRESS+0x8>
c0de16b2:	d4d4      	bmi.n	c0de165e <OETH_ADDRESS+0xa>
c0de16b4:	d4d4      	bmi.n	c0de1660 <OETH_ADDRESS+0xc>
c0de16b6:	d4d4      	bmi.n	c0de1662 <OETH_ADDRESS+0xe>
c0de16b8:	d4d4      	bmi.n	c0de1664 <OETH_ADDRESS+0x10>
c0de16ba:	d4d4      	bmi.n	c0de1666 <OETH_ADDRESS+0x12>
c0de16bc:	d4d4      	bmi.n	c0de1668 <OETH_VAULT_ADDRESS>
c0de16be:	d4d4      	bmi.n	c0de166a <OETH_VAULT_ADDRESS+0x2>
c0de16c0:	d4d4      	bmi.n	c0de166c <OETH_VAULT_ADDRESS+0x4>
c0de16c2:	d4d4      	bmi.n	c0de166e <OETH_VAULT_ADDRESS+0x6>
c0de16c4:	d4d4      	bmi.n	c0de1670 <OETH_VAULT_ADDRESS+0x8>
c0de16c6:	d4d4      	bmi.n	c0de1672 <OETH_VAULT_ADDRESS+0xa>
c0de16c8:	d4d4      	bmi.n	c0de1674 <OETH_VAULT_ADDRESS+0xc>
c0de16ca:	d4d4      	bmi.n	c0de1676 <OETH_VAULT_ADDRESS+0xe>
c0de16cc:	d4d4      	bmi.n	c0de1678 <OETH_VAULT_ADDRESS+0x10>
c0de16ce:	d4d4      	bmi.n	c0de167a <OETH_VAULT_ADDRESS+0x12>
c0de16d0:	d4d4      	bmi.n	c0de167c <g_pcHex>
c0de16d2:	d4d4      	bmi.n	c0de167e <g_pcHex+0x2>
c0de16d4:	d4d4      	bmi.n	c0de1680 <g_pcHex+0x4>
c0de16d6:	d4d4      	bmi.n	c0de1682 <g_pcHex+0x6>
c0de16d8:	d4d4      	bmi.n	c0de1684 <g_pcHex+0x8>
c0de16da:	d4d4      	bmi.n	c0de1686 <g_pcHex+0xa>
c0de16dc:	d4d4      	bmi.n	c0de1688 <g_pcHex+0xc>
c0de16de:	d4d4      	bmi.n	c0de168a <g_pcHex+0xe>
c0de16e0:	d4d4      	bmi.n	c0de168c <g_pcHex_cap>
c0de16e2:	d4d4      	bmi.n	c0de168e <g_pcHex_cap+0x2>
c0de16e4:	d4d4      	bmi.n	c0de1690 <g_pcHex_cap+0x4>
c0de16e6:	d4d4      	bmi.n	c0de1692 <g_pcHex_cap+0x6>
c0de16e8:	d4d4      	bmi.n	c0de1694 <g_pcHex_cap+0x8>
c0de16ea:	d4d4      	bmi.n	c0de1696 <g_pcHex_cap+0xa>
c0de16ec:	d4d4      	bmi.n	c0de1698 <g_pcHex_cap+0xc>
c0de16ee:	d4d4      	bmi.n	c0de169a <g_pcHex_cap+0xe>
c0de16f0:	d4d4      	bmi.n	c0de169c <NULL_ETH_ADDRESS>
c0de16f2:	d4d4      	bmi.n	c0de169e <NULL_ETH_ADDRESS+0x2>
c0de16f4:	d4d4      	bmi.n	c0de16a0 <NULL_ETH_ADDRESS+0x4>
c0de16f6:	d4d4      	bmi.n	c0de16a2 <NULL_ETH_ADDRESS+0x6>
c0de16f8:	d4d4      	bmi.n	c0de16a4 <NULL_ETH_ADDRESS+0x8>
c0de16fa:	d4d4      	bmi.n	c0de16a6 <NULL_ETH_ADDRESS+0xa>
c0de16fc:	d4d4      	bmi.n	c0de16a8 <NULL_ETH_ADDRESS+0xc>
c0de16fe:	d4d4      	bmi.n	c0de16aa <NULL_ETH_ADDRESS+0xe>
