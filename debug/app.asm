
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
c0de0008:	f000 fc84 	bl	c0de0914 <os_boot>
c0de000c:	466d      	mov	r5, sp

    // Try catch block. Please read the docs for more information on how to use those!
    BEGIN_TRY {
        TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f001 f86e 	bl	c0de10f0 <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10d      	bne.n	c0de003a <main+0x3a>
c0de001e:	f000 fe61 	bl	c0de0ce4 <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
  if (apiLevel < get_api_level()) {
c0de0024:	f000 fe23 	bl	c0de0c6e <get_api_level>
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
c0de0030:	f000 fc62 	bl	c0de08f8 <call_app_ethereum>
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
c0de0040:	f000 fe50 	bl	c0de0ce4 <try_context_set>
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
c0de0064:	f000 fc7c 	bl	c0de0960 <mcu_usb_printf>
c0de0068:	e00b      	b.n	c0de0082 <main+0x82>
c0de006a:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de006c:	f000 fe1c 	bl	c0de0ca8 <os_sched_exit>
                if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de0070:	6820      	ldr	r0, [r4, #0]
c0de0072:	2183      	movs	r1, #131	; 0x83
c0de0074:	0049      	lsls	r1, r1, #1
c0de0076:	31f9      	adds	r1, #249	; 0xf9
c0de0078:	4288      	cmp	r0, r1
c0de007a:	d002      	beq.n	c0de0082 <main+0x82>
                    dispatch_plugin_calls(args[0], (void *) args[1]);
c0de007c:	6861      	ldr	r1, [r4, #4]
c0de007e:	f000 fc01 	bl	c0de0884 <dispatch_plugin_calls>
        FINALLY {
c0de0082:	f000 fe27 	bl	c0de0cd4 <try_context_get>
c0de0086:	4669      	mov	r1, sp
c0de0088:	4288      	cmp	r0, r1
c0de008a:	d102      	bne.n	c0de0092 <main+0x92>
c0de008c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de008e:	f000 fe29 	bl	c0de0ce4 <try_context_set>
            os_lib_end();
c0de0092:	f000 fe01 	bl	c0de0c98 <os_lib_end>
c0de0096:	46c0      	nop			; (mov r8, r8)
c0de0098:	00006502 	.word	0x00006502
c0de009c:	0000126a 	.word	0x0000126a

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
c0de0190:	f000 fe6a 	bl	c0de0e68 <__aeabi_memclr>
    // Copy and right-align the number
    memcpy((uint8_t *) n + INT256_LENGTH - value_len, value, value_len);
c0de0194:	1ba8      	subs	r0, r5, r6
c0de0196:	3020      	adds	r0, #32
c0de0198:	4639      	mov	r1, r7
c0de019a:	4632      	mov	r2, r6
c0de019c:	f000 fe6a 	bl	c0de0e74 <__aeabi_memcpy>

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
c0de01f6:	f000 fd81 	bl	c0de0cfc <__udivsi3>
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
c0de021a:	f000 ff83 	bl	c0de1124 <strlcpy>
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
c0de0230:	f000 fe24 	bl	c0de0e7c <__aeabi_memmove>
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
c0de0244:	0000106f 	.word	0x0000106f

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
c0de027a:	f000 fdf5 	bl	c0de0e68 <__aeabi_memclr>

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
c0de0296:	f000 ff6b 	bl	c0de1170 <strnlen>
c0de029a:	9001      	str	r0, [sp, #4]
c0de029c:	210b      	movs	r1, #11
    uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de029e:	9803      	ldr	r0, [sp, #12]
c0de02a0:	f000 ff66 	bl	c0de1170 <strnlen>
c0de02a4:	4604      	mov	r4, r0

    memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de02a6:	b2c7      	uxtb	r7, r0
c0de02a8:	42b7      	cmp	r7, r6
c0de02aa:	4632      	mov	r2, r6
c0de02ac:	d800      	bhi.n	c0de02b0 <amountToString+0x4a>
c0de02ae:	463a      	mov	r2, r7
c0de02b0:	4628      	mov	r0, r5
c0de02b2:	9903      	ldr	r1, [sp, #12]
c0de02b4:	f000 fdde 	bl	c0de0e74 <__aeabi_memcpy>
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
c0de02ee:	f000 fb17 	bl	c0de0920 <os_longjmp>
c0de02f2:	d4d4      	bmi.n	c0de029e <amountToString+0x38>

c0de02f4 <handle_finalize>:
#include "origin_ether_plugin.h"

void handle_finalize(void *parameters) {
c0de02f4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de02f6:	4604      	mov	r4, r0
c0de02f8:	2002      	movs	r0, #2
c0de02fa:	9000      	str	r0, [sp, #0]
    ethPluginFinalize_t *msg = (ethPluginFinalize_t *) parameters;
    origin_ether_parameters_t *context = (origin_ether_parameters_t *) msg->pluginContext;
    msg->numScreens = 2;
c0de02fc:	7760      	strb	r0, [r4, #29]
    origin_ether_parameters_t *context = (origin_ether_parameters_t *) msg->pluginContext;
c0de02fe:	68a5      	ldr	r5, [r4, #8]
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0300:	462e      	mov	r6, r5
c0de0302:	3640      	adds	r6, #64	; 0x40
c0de0304:	4919      	ldr	r1, [pc, #100]	; (c0de036c <handle_finalize+0x78>)
c0de0306:	4479      	add	r1, pc
c0de0308:	2214      	movs	r2, #20
c0de030a:	4630      	mov	r0, r6
c0de030c:	f000 fdc2 	bl	c0de0e94 <memcmp>
c0de0310:	462f      	mov	r7, r5
c0de0312:	377e      	adds	r7, #126	; 0x7e
c0de0314:	2800      	cmp	r0, #0
c0de0316:	d005      	beq.n	c0de0324 <handle_finalize+0x30>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address sent to: ",
c0de0318:	4815      	ldr	r0, [pc, #84]	; (c0de0370 <handle_finalize+0x7c>)
c0de031a:	4478      	add	r0, pc
c0de031c:	4631      	mov	r1, r6
c0de031e:	f000 f82d 	bl	c0de037c <printf_hex_array>
c0de0322:	e006      	b.n	c0de0332 <handle_finalize+0x3e>
c0de0324:	2012      	movs	r0, #18
void handle_finalize(void *parameters);
void handle_provide_token(void *parameters);
void handle_query_contract_id(void *parameters);

static inline void sent_network_token(origin_ether_parameters_t *context) {
    context->decimals_sent = WEI_TO_ETHER;
c0de0326:	7078      	strb	r0, [r7, #1]
    context->tokens_found |= TOKEN_SENT_FOUND;
c0de0328:	7838      	ldrb	r0, [r7, #0]
c0de032a:	2101      	movs	r1, #1
c0de032c:	4301      	orrs	r1, r0
c0de032e:	7039      	strb	r1, [r7, #0]
c0de0330:	2600      	movs	r6, #0
c0de0332:	60e6      	str	r6, [r4, #12]
        msg->tokenLookup1 = context->contract_address_sent;
    } else {
        sent_network_token(context);
        msg->tokenLookup1 = NULL;
    }
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0334:	3554      	adds	r5, #84	; 0x54
c0de0336:	490f      	ldr	r1, [pc, #60]	; (c0de0374 <handle_finalize+0x80>)
c0de0338:	4479      	add	r1, pc
c0de033a:	2214      	movs	r2, #20
c0de033c:	4628      	mov	r0, r5
c0de033e:	f000 fda9 	bl	c0de0e94 <memcmp>
c0de0342:	2800      	cmp	r0, #0
c0de0344:	d006      	beq.n	c0de0354 <handle_finalize+0x60>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address received to: ",
c0de0346:	480c      	ldr	r0, [pc, #48]	; (c0de0378 <handle_finalize+0x84>)
c0de0348:	4478      	add	r0, pc
c0de034a:	4629      	mov	r1, r5
c0de034c:	f000 f816 	bl	c0de037c <printf_hex_array>
c0de0350:	9900      	ldr	r1, [sp, #0]
c0de0352:	e006      	b.n	c0de0362 <handle_finalize+0x6e>
c0de0354:	2012      	movs	r0, #18
}

static inline void received_network_token(origin_ether_parameters_t *context) {
    context->decimals_received = WEI_TO_ETHER;
c0de0356:	70b8      	strb	r0, [r7, #2]
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
c0de0358:	7838      	ldrb	r0, [r7, #0]
c0de035a:	9900      	ldr	r1, [sp, #0]
c0de035c:	4308      	orrs	r0, r1
c0de035e:	7038      	strb	r0, [r7, #0]
c0de0360:	2500      	movs	r5, #0
c0de0362:	2004      	movs	r0, #4
        received_network_token(context);
        msg->tokenLookup2 = NULL;
    }

    msg->uiType = ETH_UI_TYPE_GENERIC;
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0364:	77a0      	strb	r0, [r4, #30]
    msg->uiType = ETH_UI_TYPE_GENERIC;
c0de0366:	7721      	strb	r1, [r4, #28]
c0de0368:	6125      	str	r5, [r4, #16]
c0de036a:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de036c:	00001142 	.word	0x00001142
c0de0370:	0000100b 	.word	0x0000100b
c0de0374:	00001110 	.word	0x00001110
c0de0378:	00000f3f 	.word	0x00000f3f

c0de037c <printf_hex_array>:
}

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
c0de037c:	b570      	push	{r4, r5, r6, lr}
c0de037e:	460c      	mov	r4, r1
    PRINTF(title);
c0de0380:	f000 faee 	bl	c0de0960 <mcu_usb_printf>
c0de0384:	2600      	movs	r6, #0
c0de0386:	4d07      	ldr	r5, [pc, #28]	; (c0de03a4 <printf_hex_array+0x28>)
c0de0388:	447d      	add	r5, pc
    for (size_t i = 0; i < len; ++i) {
c0de038a:	2e14      	cmp	r6, #20
c0de038c:	d005      	beq.n	c0de039a <printf_hex_array+0x1e>
        PRINTF("%02x", data[i]);
c0de038e:	5da1      	ldrb	r1, [r4, r6]
c0de0390:	4628      	mov	r0, r5
c0de0392:	f000 fae5 	bl	c0de0960 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de0396:	1c76      	adds	r6, r6, #1
c0de0398:	e7f7      	b.n	c0de038a <printf_hex_array+0xe>
    };
    PRINTF("\n");
c0de039a:	4803      	ldr	r0, [pc, #12]	; (c0de03a8 <printf_hex_array+0x2c>)
c0de039c:	4478      	add	r0, pc
c0de039e:	f000 fadf 	bl	c0de0960 <mcu_usb_printf>
c0de03a2:	bd70      	pop	{r4, r5, r6, pc}
c0de03a4:	00000ed2 	.word	0x00000ed2
c0de03a8:	00000fa3 	.word	0x00000fa3

c0de03ac <handle_init_contract>:
    }
    return -1;
}

// Called once to init.
void handle_init_contract(void *parameters) {
c0de03ac:	b570      	push	{r4, r5, r6, lr}
c0de03ae:	4604      	mov	r4, r0
    // Cast the msg to the type of structure we expect (here, ethPluginInitContract_t).
    ethPluginInitContract_t *msg = (ethPluginInitContract_t *) parameters;

    // Make sure we are running a compatible version.
    if (msg->interfaceVersion != ETH_PLUGIN_INTERFACE_VERSION_LATEST) {
c0de03b0:	7800      	ldrb	r0, [r0, #0]
c0de03b2:	2601      	movs	r6, #1
c0de03b4:	2806      	cmp	r0, #6
c0de03b6:	d107      	bne.n	c0de03c8 <handle_init_contract+0x1c>
        return;
    }

    // Double check that the `context_t` struct is not bigger than the maximum size (defined by
    // `msg->pluginContextLength`).
    if (msg->pluginContextLength < sizeof(origin_ether_parameters_t)) {
c0de03b8:	6920      	ldr	r0, [r4, #16]
c0de03ba:	2885      	cmp	r0, #133	; 0x85
c0de03bc:	d806      	bhi.n	c0de03cc <handle_init_contract+0x20>
        PRINTF("Plugin parameters structure is bigger than allowed size\n");
c0de03be:	481f      	ldr	r0, [pc, #124]	; (c0de043c <handle_init_contract+0x90>)
c0de03c0:	4478      	add	r0, pc
c0de03c2:	f000 facd 	bl	c0de0960 <mcu_usb_printf>
c0de03c6:	2600      	movs	r6, #0
c0de03c8:	7066      	strb	r6, [r4, #1]
            return;
    }

    // Return valid status.
    msg->result = ETH_PLUGIN_RESULT_OK;
}
c0de03ca:	bd70      	pop	{r4, r5, r6, pc}
    origin_ether_parameters_t *context = (origin_ether_parameters_t *) msg->pluginContext;
c0de03cc:	68e5      	ldr	r5, [r4, #12]
c0de03ce:	2186      	movs	r1, #134	; 0x86
    memset(context, 0, sizeof(*context));
c0de03d0:	4628      	mov	r0, r5
c0de03d2:	f000 fd49 	bl	c0de0e68 <__aeabi_memclr>
    uint32_t selector = U4BE(msg->selector, 0);
c0de03d6:	6960      	ldr	r0, [r4, #20]
#define U4(hi3, hi2, lo1,lo0) ((((hi3)&0xFFu)<<24) | (((hi2)&0xFFu)<<16) | (((lo1)&0xFFu)<<8) | ((lo0)&0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off) {
  return (buf[off] << 8) | buf[off + 1];
}
static inline uint32_t U4BE(const uint8_t *buf, size_t off) {
  return (((uint32_t)buf[off]) << 24) | (buf[off + 1] << 16) | (buf[off + 2] << 8) | buf[off + 3];
c0de03d8:	7801      	ldrb	r1, [r0, #0]
c0de03da:	0609      	lsls	r1, r1, #24
c0de03dc:	7842      	ldrb	r2, [r0, #1]
c0de03de:	0412      	lsls	r2, r2, #16
c0de03e0:	1851      	adds	r1, r2, r1
c0de03e2:	7882      	ldrb	r2, [r0, #2]
c0de03e4:	0212      	lsls	r2, r2, #8
c0de03e6:	1889      	adds	r1, r1, r2
c0de03e8:	78c0      	ldrb	r0, [r0, #3]
c0de03ea:	1808      	adds	r0, r1, r0
c0de03ec:	3584      	adds	r5, #132	; 0x84
c0de03ee:	2100      	movs	r1, #0
c0de03f0:	4a13      	ldr	r2, [pc, #76]	; (c0de0440 <handle_init_contract+0x94>)
c0de03f2:	447a      	add	r2, pc
    for (selector_t i = 0; i < n; i++) {
c0de03f4:	2906      	cmp	r1, #6
c0de03f6:	d0e7      	beq.n	c0de03c8 <handle_init_contract+0x1c>
        if (selector == selectors[i]) {
c0de03f8:	6813      	ldr	r3, [r2, #0]
c0de03fa:	4283      	cmp	r3, r0
c0de03fc:	d002      	beq.n	c0de0404 <handle_init_contract+0x58>
    for (selector_t i = 0; i < n; i++) {
c0de03fe:	1d12      	adds	r2, r2, #4
c0de0400:	1c49      	adds	r1, r1, #1
c0de0402:	e7f7      	b.n	c0de03f4 <handle_init_contract+0x48>
            *out = i;
c0de0404:	7069      	strb	r1, [r5, #1]
    if (find_selector(selector, ORIGIN_ETHER_SELECTORS, NUM_SELECTORS, &context->selectorIndex)) {
c0de0406:	2905      	cmp	r1, #5
c0de0408:	d8de      	bhi.n	c0de03c8 <handle_init_contract+0x1c>
            *out = i;
c0de040a:	b2c8      	uxtb	r0, r1
    switch (context->selectorIndex) {
c0de040c:	2800      	cmp	r0, #0
c0de040e:	d00b      	beq.n	c0de0428 <handle_init_contract+0x7c>
c0de0410:	2804      	cmp	r0, #4
c0de0412:	d007      	beq.n	c0de0424 <handle_init_contract+0x78>
c0de0414:	2802      	cmp	r0, #2
c0de0416:	d005      	beq.n	c0de0424 <handle_init_contract+0x78>
c0de0418:	2803      	cmp	r0, #3
c0de041a:	d001      	beq.n	c0de0420 <handle_init_contract+0x74>
c0de041c:	2801      	cmp	r0, #1
c0de041e:	d107      	bne.n	c0de0430 <handle_init_contract+0x84>
c0de0420:	2002      	movs	r0, #2
c0de0422:	e002      	b.n	c0de042a <handle_init_contract+0x7e>
c0de0424:	2001      	movs	r0, #1
c0de0426:	e000      	b.n	c0de042a <handle_init_contract+0x7e>
c0de0428:	2003      	movs	r0, #3
c0de042a:	7028      	strb	r0, [r5, #0]
c0de042c:	2604      	movs	r6, #4
c0de042e:	e7cb      	b.n	c0de03c8 <handle_init_contract+0x1c>
            PRINTF("Missing selectorIndex: %d\n", context->selectorIndex);
c0de0430:	4804      	ldr	r0, [pc, #16]	; (c0de0444 <handle_init_contract+0x98>)
c0de0432:	4478      	add	r0, pc
c0de0434:	f000 fa94 	bl	c0de0960 <mcu_usb_printf>
c0de0438:	e7c5      	b.n	c0de03c6 <handle_init_contract+0x1a>
c0de043a:	46c0      	nop			; (mov r8, r8)
c0de043c:	00000dd8 	.word	0x00000dd8
c0de0440:	0000101e 	.word	0x0000101e
c0de0444:	00000f8a 	.word	0x00000f8a

c0de0448 <handle_provide_parameter>:
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
c0de0448:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de044a:	4604      	mov	r4, r0
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    origin_ether_parameters_t *context = (origin_ether_parameters_t *) msg->pluginContext;
c0de044c:	6885      	ldr	r5, [r0, #8]
    printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH, msg->parameter);
c0de044e:	68c2      	ldr	r2, [r0, #12]
c0de0450:	4833      	ldr	r0, [pc, #204]	; (c0de0520 <handle_provide_parameter+0xd8>)
c0de0452:	4478      	add	r0, pc
c0de0454:	2120      	movs	r1, #32
c0de0456:	f000 f86d 	bl	c0de0534 <printf_hex_array>
c0de045a:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de045c:	7520      	strb	r0, [r4, #20]
c0de045e:	2085      	movs	r0, #133	; 0x85

    switch (context->selectorIndex) {
c0de0460:	5c29      	ldrb	r1, [r5, r0]
c0de0462:	462f      	mov	r7, r5
c0de0464:	3784      	adds	r7, #132	; 0x84
c0de0466:	2904      	cmp	r1, #4
c0de0468:	d015      	beq.n	c0de0496 <handle_provide_parameter+0x4e>
c0de046a:	2901      	cmp	r1, #1
c0de046c:	d00b      	beq.n	c0de0486 <handle_provide_parameter+0x3e>
c0de046e:	2902      	cmp	r1, #2
c0de0470:	d02a      	beq.n	c0de04c8 <handle_provide_parameter+0x80>
c0de0472:	2903      	cmp	r1, #3
c0de0474:	d007      	beq.n	c0de0486 <handle_provide_parameter+0x3e>
c0de0476:	2900      	cmp	r1, #0
c0de0478:	d135      	bne.n	c0de04e6 <handle_provide_parameter+0x9e>
    switch (context->next_param) {
c0de047a:	7839      	ldrb	r1, [r7, #0]
c0de047c:	2905      	cmp	r1, #5
c0de047e:	d04d      	beq.n	c0de051c <handle_provide_parameter+0xd4>
            PRINTF("Param not supported: %d\n", context->next_param);
c0de0480:	4828      	ldr	r0, [pc, #160]	; (c0de0524 <handle_provide_parameter+0xdc>)
c0de0482:	4478      	add	r0, pc
c0de0484:	e031      	b.n	c0de04ea <handle_provide_parameter+0xa2>
c0de0486:	7838      	ldrb	r0, [r7, #0]
c0de0488:	2805      	cmp	r0, #5
c0de048a:	d047      	beq.n	c0de051c <handle_provide_parameter+0xd4>
c0de048c:	2803      	cmp	r0, #3
c0de048e:	d02f      	beq.n	c0de04f0 <handle_provide_parameter+0xa8>
c0de0490:	2802      	cmp	r0, #2
c0de0492:	d13d      	bne.n	c0de0510 <handle_provide_parameter+0xc8>
c0de0494:	e034      	b.n	c0de0500 <handle_provide_parameter+0xb8>
    switch (context->next_param) {
c0de0496:	7838      	ldrb	r0, [r7, #0]
c0de0498:	2805      	cmp	r0, #5
c0de049a:	d03f      	beq.n	c0de051c <handle_provide_parameter+0xd4>
c0de049c:	2801      	cmp	r0, #1
c0de049e:	d116      	bne.n	c0de04ce <handle_provide_parameter+0x86>
    memset(context->contract_address_received, 0, sizeof(context->contract_address_received));
c0de04a0:	3554      	adds	r5, #84	; 0x54
c0de04a2:	2614      	movs	r6, #20
c0de04a4:	4628      	mov	r0, r5
c0de04a6:	4631      	mov	r1, r6
c0de04a8:	f000 fcde 	bl	c0de0e68 <__aeabi_memclr>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de04ac:	68e1      	ldr	r1, [r4, #12]
c0de04ae:	310c      	adds	r1, #12
    memcpy(context->contract_address_received,
c0de04b0:	4628      	mov	r0, r5
c0de04b2:	4632      	mov	r2, r6
c0de04b4:	f000 fcde 	bl	c0de0e74 <__aeabi_memcpy>
    printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH, context->contract_address_received);
c0de04b8:	481c      	ldr	r0, [pc, #112]	; (c0de052c <handle_provide_parameter+0xe4>)
c0de04ba:	4478      	add	r0, pc
c0de04bc:	4631      	mov	r1, r6
c0de04be:	462a      	mov	r2, r5
c0de04c0:	f000 f838 	bl	c0de0534 <printf_hex_array>
c0de04c4:	2002      	movs	r0, #2
c0de04c6:	e021      	b.n	c0de050c <handle_provide_parameter+0xc4>
    switch (context->next_param) {
c0de04c8:	7838      	ldrb	r0, [r7, #0]
c0de04ca:	2805      	cmp	r0, #5
c0de04cc:	d026      	beq.n	c0de051c <handle_provide_parameter+0xd4>
c0de04ce:	2802      	cmp	r0, #2
c0de04d0:	d016      	beq.n	c0de0500 <handle_provide_parameter+0xb8>
c0de04d2:	2803      	cmp	r0, #3
c0de04d4:	d00c      	beq.n	c0de04f0 <handle_provide_parameter+0xa8>
c0de04d6:	2800      	cmp	r0, #0
c0de04d8:	d11a      	bne.n	c0de0510 <handle_provide_parameter+0xc8>
c0de04da:	4620      	mov	r0, r4
c0de04dc:	4629      	mov	r1, r5
c0de04de:	f000 f843 	bl	c0de0568 <handle_token_sent>
c0de04e2:	2001      	movs	r0, #1
c0de04e4:	e012      	b.n	c0de050c <handle_provide_parameter+0xc4>
        case CURVE_EXCHANGE: {
            handle_curve_exchange(msg, context);
            break;
        }
        default:
            PRINTF("Selector Index %d not supported\n", context->selectorIndex);
c0de04e6:	4812      	ldr	r0, [pc, #72]	; (c0de0530 <handle_provide_parameter+0xe8>)
c0de04e8:	4478      	add	r0, pc
c0de04ea:	f000 fa39 	bl	c0de0960 <mcu_usb_printf>
c0de04ee:	e013      	b.n	c0de0518 <handle_provide_parameter+0xd0>
c0de04f0:	68e1      	ldr	r1, [r4, #12]
c0de04f2:	3520      	adds	r5, #32
c0de04f4:	2220      	movs	r2, #32
c0de04f6:	4628      	mov	r0, r5
c0de04f8:	f000 fcbc 	bl	c0de0e74 <__aeabi_memcpy>
c0de04fc:	2005      	movs	r0, #5
c0de04fe:	e005      	b.n	c0de050c <handle_provide_parameter+0xc4>
c0de0500:	68e1      	ldr	r1, [r4, #12]
c0de0502:	2220      	movs	r2, #32
c0de0504:	4628      	mov	r0, r5
c0de0506:	f000 fcb5 	bl	c0de0e74 <__aeabi_memcpy>
c0de050a:	2003      	movs	r0, #3
c0de050c:	7038      	strb	r0, [r7, #0]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
c0de050e:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0510:	4805      	ldr	r0, [pc, #20]	; (c0de0528 <handle_provide_parameter+0xe0>)
c0de0512:	4478      	add	r0, pc
c0de0514:	f000 fa24 	bl	c0de0960 <mcu_usb_printf>
c0de0518:	2000      	movs	r0, #0
c0de051a:	7520      	strb	r0, [r4, #20]
c0de051c:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de051e:	46c0      	nop			; (mov r8, r8)
c0de0520:	00000d98 	.word	0x00000d98
c0de0524:	00000e23 	.word	0x00000e23
c0de0528:	00000cfa 	.word	0x00000cfa
c0de052c:	00000daa 	.word	0x00000daa
c0de0530:	00000eef 	.word	0x00000eef

c0de0534 <printf_hex_array>:
                                    const uint8_t *data __attribute__((unused))) {
c0de0534:	b570      	push	{r4, r5, r6, lr}
c0de0536:	4614      	mov	r4, r2
c0de0538:	460d      	mov	r5, r1
    PRINTF(title);
c0de053a:	f000 fa11 	bl	c0de0960 <mcu_usb_printf>
c0de053e:	4e08      	ldr	r6, [pc, #32]	; (c0de0560 <printf_hex_array+0x2c>)
c0de0540:	447e      	add	r6, pc
    for (size_t i = 0; i < len; ++i) {
c0de0542:	2d00      	cmp	r5, #0
c0de0544:	d006      	beq.n	c0de0554 <printf_hex_array+0x20>
        PRINTF("%02x", data[i]);
c0de0546:	7821      	ldrb	r1, [r4, #0]
c0de0548:	4630      	mov	r0, r6
c0de054a:	f000 fa09 	bl	c0de0960 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de054e:	1c64      	adds	r4, r4, #1
c0de0550:	1e6d      	subs	r5, r5, #1
c0de0552:	e7f6      	b.n	c0de0542 <printf_hex_array+0xe>
    PRINTF("\n");
c0de0554:	4803      	ldr	r0, [pc, #12]	; (c0de0564 <printf_hex_array+0x30>)
c0de0556:	4478      	add	r0, pc
c0de0558:	f000 fa02 	bl	c0de0960 <mcu_usb_printf>
c0de055c:	bd70      	pop	{r4, r5, r6, pc}
c0de055e:	46c0      	nop			; (mov r8, r8)
c0de0560:	00000d1a 	.word	0x00000d1a
c0de0564:	00000de9 	.word	0x00000de9

c0de0568 <handle_token_sent>:
static void handle_token_sent(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
c0de0568:	b570      	push	{r4, r5, r6, lr}
c0de056a:	460c      	mov	r4, r1
c0de056c:	4606      	mov	r6, r0
    memset(context->contract_address_sent, 0, sizeof(context->contract_address_sent));
c0de056e:	3440      	adds	r4, #64	; 0x40
c0de0570:	2514      	movs	r5, #20
c0de0572:	4620      	mov	r0, r4
c0de0574:	4629      	mov	r1, r5
c0de0576:	f000 fc77 	bl	c0de0e68 <__aeabi_memclr>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de057a:	68f1      	ldr	r1, [r6, #12]
c0de057c:	310c      	adds	r1, #12
    memcpy(context->contract_address_sent,
c0de057e:	4620      	mov	r0, r4
c0de0580:	462a      	mov	r2, r5
c0de0582:	f000 fc77 	bl	c0de0e74 <__aeabi_memcpy>
    printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
c0de0586:	4803      	ldr	r0, [pc, #12]	; (c0de0594 <handle_token_sent+0x2c>)
c0de0588:	4478      	add	r0, pc
c0de058a:	4629      	mov	r1, r5
c0de058c:	4622      	mov	r2, r4
c0de058e:	f7ff ffd1 	bl	c0de0534 <printf_hex_array>
}
c0de0592:	bd70      	pop	{r4, r5, r6, pc}
c0de0594:	00000c99 	.word	0x00000c99

c0de0598 <handle_provide_token>:
#include "origin_ether_plugin.h"

// EDIT THIS: Adapt this function to your needs! Remember, the information for tokens are held in
// `msg->token1` and `msg->token2`. If those pointers are `NULL`, this means the ethereum app didn't
// find any info regarding the requested tokens!
void handle_provide_token(void *parameters) {
c0de0598:	b570      	push	{r4, r5, r6, lr}
c0de059a:	4604      	mov	r4, r0
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    origin_ether_parameters_t *context = (origin_ether_parameters_t *) msg->pluginContext;
c0de059c:	6885      	ldr	r5, [r0, #8]
    PRINTF("OETH plugin provide token: 0x%p, 0x%p\n", msg->item1, msg->item2);
c0de059e:	68c1      	ldr	r1, [r0, #12]
c0de05a0:	6902      	ldr	r2, [r0, #16]
c0de05a2:	482c      	ldr	r0, [pc, #176]	; (c0de0654 <handle_provide_token+0xbc>)
c0de05a4:	4478      	add	r0, pc
c0de05a6:	f000 f9db 	bl	c0de0960 <mcu_usb_printf>

    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de05aa:	4628      	mov	r0, r5
c0de05ac:	3040      	adds	r0, #64	; 0x40
c0de05ae:	492a      	ldr	r1, [pc, #168]	; (c0de0658 <handle_provide_token+0xc0>)
c0de05b0:	4479      	add	r1, pc
c0de05b2:	2214      	movs	r2, #20
c0de05b4:	f000 fc6e 	bl	c0de0e94 <memcmp>
c0de05b8:	462e      	mov	r6, r5
c0de05ba:	367e      	adds	r6, #126	; 0x7e
c0de05bc:	2800      	cmp	r0, #0
c0de05be:	d00b      	beq.n	c0de05d8 <handle_provide_token+0x40>
        sent_network_token(context);
    } else if (msg->item1 != NULL) {
c0de05c0:	68e1      	ldr	r1, [r4, #12]
c0de05c2:	2900      	cmp	r1, #0
c0de05c4:	d00f      	beq.n	c0de05e6 <handle_provide_token+0x4e>
        context->decimals_sent = msg->item1->token.decimals;
c0de05c6:	7fc8      	ldrb	r0, [r1, #31]
c0de05c8:	7070      	strb	r0, [r6, #1]
        strlcpy(context->ticker_sent,
c0de05ca:	4628      	mov	r0, r5
c0de05cc:	3068      	adds	r0, #104	; 0x68
        context->decimals_sent = msg->item1->token.decimals;
c0de05ce:	3114      	adds	r1, #20
c0de05d0:	220b      	movs	r2, #11
        strlcpy(context->ticker_sent,
c0de05d2:	f000 fda7 	bl	c0de1124 <strlcpy>
c0de05d6:	e001      	b.n	c0de05dc <handle_provide_token+0x44>
c0de05d8:	2012      	movs	r0, #18
    context->decimals_sent = WEI_TO_ETHER;
c0de05da:	7070      	strb	r0, [r6, #1]
c0de05dc:	7830      	ldrb	r0, [r6, #0]
c0de05de:	2101      	movs	r1, #1
c0de05e0:	4301      	orrs	r1, r0
c0de05e2:	7031      	strb	r1, [r6, #0]
c0de05e4:	e00b      	b.n	c0de05fe <handle_provide_token+0x66>
c0de05e6:	2012      	movs	r0, #18
                (char *) msg->item1->token.ticker,
                sizeof(context->ticker_sent));
        context->tokens_found |= TOKEN_SENT_FOUND;
    } else {
        // CAL did not find the token and token is not ETH.
        context->decimals_sent = DEFAULT_DECIMAL;
c0de05e8:	7070      	strb	r0, [r6, #1]
        strlcpy(context->ticker_sent, DEFAULT_TICKER, sizeof(context->ticker_sent));
c0de05ea:	4628      	mov	r0, r5
c0de05ec:	3068      	adds	r0, #104	; 0x68
c0de05ee:	491b      	ldr	r1, [pc, #108]	; (c0de065c <handle_provide_token+0xc4>)
c0de05f0:	4479      	add	r1, pc
c0de05f2:	220b      	movs	r2, #11
c0de05f4:	f000 fd96 	bl	c0de1124 <strlcpy>
        // // We will need an additional screen to display a warning message.
        msg->additionalScreens++;
c0de05f8:	7d20      	ldrb	r0, [r4, #20]
c0de05fa:	1c40      	adds	r0, r0, #1
c0de05fc:	7520      	strb	r0, [r4, #20]
    }

    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de05fe:	4628      	mov	r0, r5
c0de0600:	3054      	adds	r0, #84	; 0x54
c0de0602:	4917      	ldr	r1, [pc, #92]	; (c0de0660 <handle_provide_token+0xc8>)
c0de0604:	4479      	add	r1, pc
c0de0606:	2214      	movs	r2, #20
c0de0608:	f000 fc44 	bl	c0de0e94 <memcmp>
c0de060c:	2800      	cmp	r0, #0
c0de060e:	d00b      	beq.n	c0de0628 <handle_provide_token+0x90>
        received_network_token(context);
    } else if (msg->item2 != NULL) {
c0de0610:	6921      	ldr	r1, [r4, #16]
c0de0612:	2900      	cmp	r1, #0
c0de0614:	d00f      	beq.n	c0de0636 <handle_provide_token+0x9e>
        context->decimals_received = msg->item2->token.decimals;
c0de0616:	7fc8      	ldrb	r0, [r1, #31]
c0de0618:	70b0      	strb	r0, [r6, #2]
        strlcpy(context->ticker_received,
c0de061a:	3573      	adds	r5, #115	; 0x73
        context->decimals_received = msg->item2->token.decimals;
c0de061c:	3114      	adds	r1, #20
c0de061e:	220b      	movs	r2, #11
        strlcpy(context->ticker_received,
c0de0620:	4628      	mov	r0, r5
c0de0622:	f000 fd7f 	bl	c0de1124 <strlcpy>
c0de0626:	e001      	b.n	c0de062c <handle_provide_token+0x94>
c0de0628:	2012      	movs	r0, #18
    context->decimals_received = WEI_TO_ETHER;
c0de062a:	70b0      	strb	r0, [r6, #2]
c0de062c:	7830      	ldrb	r0, [r6, #0]
c0de062e:	2102      	movs	r1, #2
c0de0630:	4301      	orrs	r1, r0
c0de0632:	7031      	strb	r1, [r6, #0]
c0de0634:	e00b      	b.n	c0de064e <handle_provide_token+0xb6>
c0de0636:	2012      	movs	r0, #18
                (char *) msg->item2->token.ticker,
                sizeof(context->ticker_received));
        context->tokens_found |= TOKEN_RECEIVED_FOUND;
    } else {
        // CAL did not find the token and token is not ETH.
        context->decimals_received = DEFAULT_DECIMAL;
c0de0638:	70b0      	strb	r0, [r6, #2]
        strlcpy(context->ticker_received, DEFAULT_TICKER, sizeof(context->ticker_sent));
c0de063a:	3573      	adds	r5, #115	; 0x73
c0de063c:	4909      	ldr	r1, [pc, #36]	; (c0de0664 <handle_provide_token+0xcc>)
c0de063e:	4479      	add	r1, pc
c0de0640:	220b      	movs	r2, #11
c0de0642:	4628      	mov	r0, r5
c0de0644:	f000 fd6e 	bl	c0de1124 <strlcpy>
        // // We will need an additional screen to display a warning message.
        msg->additionalScreens++;
c0de0648:	7d20      	ldrb	r0, [r4, #20]
c0de064a:	1c40      	adds	r0, r0, #1
c0de064c:	7520      	strb	r0, [r4, #20]
c0de064e:	2004      	movs	r0, #4
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0650:	7560      	strb	r0, [r4, #21]
c0de0652:	bd70      	pop	{r4, r5, r6, pc}
c0de0654:	00000c8a 	.word	0x00000c8a
c0de0658:	00000e98 	.word	0x00000e98
c0de065c:	00000d83 	.word	0x00000d83
c0de0660:	00000e44 	.word	0x00000e44
c0de0664:	00000d35 	.word	0x00000d35

c0de0668 <handle_query_contract_id>:
#include "origin_ether_plugin.h"

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de0668:	b5b0      	push	{r4, r5, r7, lr}
c0de066a:	4604      	mov	r4, r0
    ethQueryContractID_t *msg = (ethQueryContractID_t *) parameters;
    const origin_ether_parameters_t *context = (const origin_ether_parameters_t *) msg->pluginContext;
c0de066c:	6885      	ldr	r5, [r0, #8]
    // msg->name will be the upper sentence displayed on the screen.
    // msg->version will be the lower sentence displayed on the screen.

    // For the first screen, display the plugin name.
    strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de066e:	68c0      	ldr	r0, [r0, #12]
c0de0670:	6922      	ldr	r2, [r4, #16]
c0de0672:	4910      	ldr	r1, [pc, #64]	; (c0de06b4 <handle_query_contract_id+0x4c>)
c0de0674:	4479      	add	r1, pc
c0de0676:	f000 fd55 	bl	c0de1124 <strlcpy>
c0de067a:	2085      	movs	r0, #133	; 0x85

    switch (context->selectorIndex) {
c0de067c:	5c29      	ldrb	r1, [r5, r0]
c0de067e:	2903      	cmp	r1, #3
c0de0680:	d202      	bcs.n	c0de0688 <handle_query_contract_id+0x20>
c0de0682:	490d      	ldr	r1, [pc, #52]	; (c0de06b8 <handle_query_contract_id+0x50>)
c0de0684:	4479      	add	r1, pc
c0de0686:	e008      	b.n	c0de069a <handle_query_contract_id+0x32>
c0de0688:	2904      	cmp	r1, #4
c0de068a:	d004      	beq.n	c0de0696 <handle_query_contract_id+0x2e>
c0de068c:	2903      	cmp	r1, #3
c0de068e:	d10b      	bne.n	c0de06a8 <handle_query_contract_id+0x40>
c0de0690:	490a      	ldr	r1, [pc, #40]	; (c0de06bc <handle_query_contract_id+0x54>)
c0de0692:	4479      	add	r1, pc
c0de0694:	e001      	b.n	c0de069a <handle_query_contract_id+0x32>
c0de0696:	490b      	ldr	r1, [pc, #44]	; (c0de06c4 <handle_query_contract_id+0x5c>)
c0de0698:	4479      	add	r1, pc
c0de069a:	6960      	ldr	r0, [r4, #20]
c0de069c:	69a2      	ldr	r2, [r4, #24]
c0de069e:	f000 fd41 	bl	c0de1124 <strlcpy>
c0de06a2:	2004      	movs	r0, #4
c0de06a4:	7720      	strb	r0, [r4, #28]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de06a6:	bdb0      	pop	{r4, r5, r7, pc}
            PRINTF("Selector Index :%d not supported\n", context->selectorIndex);
c0de06a8:	4805      	ldr	r0, [pc, #20]	; (c0de06c0 <handle_query_contract_id+0x58>)
c0de06aa:	4478      	add	r0, pc
c0de06ac:	f000 f958 	bl	c0de0960 <mcu_usb_printf>
c0de06b0:	2000      	movs	r0, #0
c0de06b2:	e7f7      	b.n	c0de06a4 <handle_query_contract_id+0x3c>
c0de06b4:	00000b5d 	.word	0x00000b5d
c0de06b8:	00000bd1 	.word	0x00000bd1
c0de06bc:	00000be3 	.word	0x00000be3
c0de06c0:	00000cca 	.word	0x00000cca
c0de06c4:	00000bc7 	.word	0x00000bc7

c0de06c8 <handle_query_contract_ui>:
            break;
    }
    return ERROR;
}

void handle_query_contract_ui(void *parameters) {
c0de06c8:	b5fe      	push	{r1, r2, r3, r4, r5, r6, r7, lr}
c0de06ca:	4604      	mov	r4, r0
    ethQueryContractUI_t *msg = (ethQueryContractUI_t *) parameters;
    origin_ether_parameters_t *context = (origin_ether_parameters_t *) msg->pluginContext;
c0de06cc:	69c5      	ldr	r5, [r0, #28]
    memset(msg->title, 0, msg->titleLength);
c0de06ce:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de06d0:	6aa1      	ldr	r1, [r4, #40]	; 0x28
c0de06d2:	f000 fbc9 	bl	c0de0e68 <__aeabi_memclr>
    memset(msg->msg, 0, msg->msgLength);
c0de06d6:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de06d8:	6b21      	ldr	r1, [r4, #48]	; 0x30
c0de06da:	f000 fbc5 	bl	c0de0e68 <__aeabi_memclr>
c0de06de:	4626      	mov	r6, r4
c0de06e0:	3620      	adds	r6, #32
c0de06e2:	2004      	movs	r0, #4
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de06e4:	7530      	strb	r0, [r6, #20]
c0de06e6:	2020      	movs	r0, #32
    uint8_t index = msg->screenIndex;
c0de06e8:	5c27      	ldrb	r7, [r4, r0]
c0de06ea:	207e      	movs	r0, #126	; 0x7e
c0de06ec:	9502      	str	r5, [sp, #8]
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de06ee:	5c28      	ldrb	r0, [r5, r0]
c0de06f0:	2103      	movs	r1, #3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de06f2:	4001      	ands	r1, r0
c0de06f4:	2302      	movs	r3, #2
    bool token_received_found = context->tokens_found & TOKEN_RECEIVED_FOUND;
c0de06f6:	4605      	mov	r5, r0
c0de06f8:	401d      	ands	r5, r3
c0de06fa:	2201      	movs	r2, #1
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de06fc:	4002      	ands	r2, r0
    switch (index) {
c0de06fe:	2f01      	cmp	r7, #1
c0de0700:	d015      	beq.n	c0de072e <handle_query_contract_ui+0x66>
c0de0702:	2f00      	cmp	r7, #0
c0de0704:	d134      	bne.n	c0de0770 <handle_query_contract_ui+0xa8>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0706:	4248      	negs	r0, r1
c0de0708:	4148      	adcs	r0, r1
    bool both_tokens_found = token_received_found && token_sent_found;
c0de070a:	1ecf      	subs	r7, r1, #3
c0de070c:	4279      	negs	r1, r7
c0de070e:	4179      	adcs	r1, r7
            if (both_tokens_found) {
c0de0710:	4301      	orrs	r1, r0
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0712:	1e50      	subs	r0, r2, #1
c0de0714:	4182      	sbcs	r2, r0
            if (both_tokens_found) {
c0de0716:	430a      	orrs	r2, r1
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0718:	1e78      	subs	r0, r7, #1
c0de071a:	4187      	sbcs	r7, r0
            if (both_tokens_found) {
c0de071c:	2900      	cmp	r1, #0
c0de071e:	d000      	beq.n	c0de0722 <handle_query_contract_ui+0x5a>
c0de0720:	0079      	lsls	r1, r7, #1
c0de0722:	2a00      	cmp	r2, #0
c0de0724:	d100      	bne.n	c0de0728 <handle_query_contract_ui+0x60>
c0de0726:	4619      	mov	r1, r3
c0de0728:	2a00      	cmp	r2, #0
c0de072a:	d00f      	beq.n	c0de074c <handle_query_contract_ui+0x84>
c0de072c:	e010      	b.n	c0de0750 <handle_query_contract_ui+0x88>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de072e:	424b      	negs	r3, r1
c0de0730:	414b      	adcs	r3, r1
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0732:	1ec8      	subs	r0, r1, #3
c0de0734:	4241      	negs	r1, r0
c0de0736:	4141      	adcs	r1, r0
            if (both_tokens_found) {
c0de0738:	430b      	orrs	r3, r1
c0de073a:	d100      	bne.n	c0de073e <handle_query_contract_ui+0x76>
c0de073c:	2102      	movs	r1, #2
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de073e:	1e50      	subs	r0, r2, #1
c0de0740:	4182      	sbcs	r2, r0
            if (both_tokens_found) {
c0de0742:	4313      	orrs	r3, r2
c0de0744:	d100      	bne.n	c0de0748 <handle_query_contract_ui+0x80>
c0de0746:	4619      	mov	r1, r3
c0de0748:	2b00      	cmp	r3, #0
c0de074a:	d101      	bne.n	c0de0750 <handle_query_contract_ui+0x88>
c0de074c:	2d00      	cmp	r5, #0
c0de074e:	d00f      	beq.n	c0de0770 <handle_query_contract_ui+0xa8>

    screens_t screen = get_screen(msg, context);
    switch (screen) {
c0de0750:	2902      	cmp	r1, #2
c0de0752:	d014      	beq.n	c0de077e <handle_query_contract_ui+0xb6>
c0de0754:	9d02      	ldr	r5, [sp, #8]
c0de0756:	462f      	mov	r7, r5
c0de0758:	377e      	adds	r7, #126	; 0x7e
c0de075a:	2901      	cmp	r1, #1
c0de075c:	d01c      	beq.n	c0de0798 <handle_query_contract_ui+0xd0>
c0de075e:	2900      	cmp	r1, #0
c0de0760:	d106      	bne.n	c0de0770 <handle_query_contract_ui+0xa8>
    switch (context->selectorIndex) {
c0de0762:	79f9      	ldrb	r1, [r7, #7]
c0de0764:	2903      	cmp	r1, #3
c0de0766:	d240      	bcs.n	c0de07ea <handle_query_contract_ui+0x122>
c0de0768:	493a      	ldr	r1, [pc, #232]	; (c0de0854 <handle_query_contract_ui+0x18c>)
c0de076a:	4479      	add	r1, pc
c0de076c:	9d02      	ldr	r5, [sp, #8]
c0de076e:	e04b      	b.n	c0de0808 <handle_query_contract_ui+0x140>
            break;
        case WARN_SCREEN:
            set_warning_ui(msg, context);
            break;
        default:
            PRINTF("Received an invalid screenIndex\n");
c0de0770:	4842      	ldr	r0, [pc, #264]	; (c0de087c <handle_query_contract_ui+0x1b4>)
c0de0772:	4478      	add	r0, pc
c0de0774:	f000 f8f4 	bl	c0de0960 <mcu_usb_printf>
c0de0778:	2000      	movs	r0, #0
c0de077a:	7530      	strb	r0, [r6, #20]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }
}
c0de077c:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
    strlcpy(msg->title, "WARNING", msg->titleLength);
c0de077e:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0780:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0782:	493c      	ldr	r1, [pc, #240]	; (c0de0874 <handle_query_contract_ui+0x1ac>)
c0de0784:	4479      	add	r1, pc
c0de0786:	f000 fccd 	bl	c0de1124 <strlcpy>
    strlcpy(msg->msg, "Unknown token", msg->msgLength);
c0de078a:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de078c:	6b22      	ldr	r2, [r4, #48]	; 0x30
c0de078e:	493a      	ldr	r1, [pc, #232]	; (c0de0878 <handle_query_contract_ui+0x1b0>)
c0de0790:	4479      	add	r1, pc
c0de0792:	f000 fcc7 	bl	c0de1124 <strlcpy>
}
c0de0796:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
    switch (context->selectorIndex) {
c0de0798:	79f9      	ldrb	r1, [r7, #7]
c0de079a:	2904      	cmp	r1, #4
c0de079c:	d82d      	bhi.n	c0de07fa <handle_query_contract_ui+0x132>
            strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de079e:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de07a0:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de07a2:	4931      	ldr	r1, [pc, #196]	; (c0de0868 <handle_query_contract_ui+0x1a0>)
c0de07a4:	4479      	add	r1, pc
c0de07a6:	f000 fcbd 	bl	c0de1124 <strlcpy>
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de07aa:	4628      	mov	r0, r5
c0de07ac:	3054      	adds	r0, #84	; 0x54
c0de07ae:	492f      	ldr	r1, [pc, #188]	; (c0de086c <handle_query_contract_ui+0x1a4>)
c0de07b0:	4479      	add	r1, pc
c0de07b2:	2214      	movs	r2, #20
c0de07b4:	f000 fb6e 	bl	c0de0e94 <memcmp>
c0de07b8:	2800      	cmp	r0, #0
c0de07ba:	d106      	bne.n	c0de07ca <handle_query_contract_ui+0x102>
        strlcpy(context->ticker_received, msg->network_ticker, sizeof(context->ticker_received));
c0de07bc:	4628      	mov	r0, r5
c0de07be:	3073      	adds	r0, #115	; 0x73
c0de07c0:	4621      	mov	r1, r4
c0de07c2:	3110      	adds	r1, #16
c0de07c4:	220b      	movs	r2, #11
c0de07c6:	f000 fcad 	bl	c0de1124 <strlcpy>
                   context->decimals_received,
c0de07ca:	78ba      	ldrb	r2, [r7, #2]
                   msg->msg,
c0de07cc:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de07ce:	6b21      	ldr	r1, [r4, #48]	; 0x30
    amountToString(context->min_amount_received,
c0de07d0:	9000      	str	r0, [sp, #0]
c0de07d2:	9101      	str	r1, [sp, #4]
c0de07d4:	4628      	mov	r0, r5
c0de07d6:	3020      	adds	r0, #32
                   context->ticker_received,
c0de07d8:	3573      	adds	r5, #115	; 0x73
c0de07da:	2120      	movs	r1, #32
    amountToString(context->min_amount_received,
c0de07dc:	462b      	mov	r3, r5
c0de07de:	f7ff fd42 	bl	c0de0266 <amountToString>
    PRINTF("AMOUNT RECEIVED: %s\n", msg->msg);
c0de07e2:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de07e4:	4822      	ldr	r0, [pc, #136]	; (c0de0870 <handle_query_contract_ui+0x1a8>)
c0de07e6:	4478      	add	r0, pc
c0de07e8:	e030      	b.n	c0de084c <handle_query_contract_ui+0x184>
    switch (context->selectorIndex) {
c0de07ea:	2904      	cmp	r1, #4
c0de07ec:	9d02      	ldr	r5, [sp, #8]
c0de07ee:	d009      	beq.n	c0de0804 <handle_query_contract_ui+0x13c>
c0de07f0:	2903      	cmp	r1, #3
c0de07f2:	d102      	bne.n	c0de07fa <handle_query_contract_ui+0x132>
c0de07f4:	4918      	ldr	r1, [pc, #96]	; (c0de0858 <handle_query_contract_ui+0x190>)
c0de07f6:	4479      	add	r1, pc
c0de07f8:	e006      	b.n	c0de0808 <handle_query_contract_ui+0x140>
c0de07fa:	4821      	ldr	r0, [pc, #132]	; (c0de0880 <handle_query_contract_ui+0x1b8>)
c0de07fc:	4478      	add	r0, pc
c0de07fe:	f000 f8af 	bl	c0de0960 <mcu_usb_printf>
c0de0802:	e7b9      	b.n	c0de0778 <handle_query_contract_ui+0xb0>
c0de0804:	4915      	ldr	r1, [pc, #84]	; (c0de085c <handle_query_contract_ui+0x194>)
c0de0806:	4479      	add	r1, pc
c0de0808:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de080a:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de080c:	f000 fc8a 	bl	c0de1124 <strlcpy>
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0810:	4628      	mov	r0, r5
c0de0812:	3040      	adds	r0, #64	; 0x40
c0de0814:	4912      	ldr	r1, [pc, #72]	; (c0de0860 <handle_query_contract_ui+0x198>)
c0de0816:	4479      	add	r1, pc
c0de0818:	2214      	movs	r2, #20
c0de081a:	f000 fb3b 	bl	c0de0e94 <memcmp>
c0de081e:	2800      	cmp	r0, #0
c0de0820:	d106      	bne.n	c0de0830 <handle_query_contract_ui+0x168>
        strlcpy(context->ticker_sent, msg->network_ticker, sizeof(context->ticker_sent));
c0de0822:	4628      	mov	r0, r5
c0de0824:	3068      	adds	r0, #104	; 0x68
c0de0826:	4621      	mov	r1, r4
c0de0828:	3110      	adds	r1, #16
c0de082a:	220b      	movs	r2, #11
c0de082c:	f000 fc7a 	bl	c0de1124 <strlcpy>
                   context->decimals_sent,
c0de0830:	787a      	ldrb	r2, [r7, #1]
                   msg->msg,
c0de0832:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de0834:	6b21      	ldr	r1, [r4, #48]	; 0x30
    amountToString(context->amount_sent,
c0de0836:	9000      	str	r0, [sp, #0]
c0de0838:	9101      	str	r1, [sp, #4]
                   context->ticker_sent,
c0de083a:	462b      	mov	r3, r5
c0de083c:	3368      	adds	r3, #104	; 0x68
c0de083e:	2120      	movs	r1, #32
    amountToString(context->amount_sent,
c0de0840:	4628      	mov	r0, r5
c0de0842:	f7ff fd10 	bl	c0de0266 <amountToString>
    PRINTF("AMOUNT SENT: %s\n", msg->msg);
c0de0846:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de0848:	4806      	ldr	r0, [pc, #24]	; (c0de0864 <handle_query_contract_ui+0x19c>)
c0de084a:	4478      	add	r0, pc
c0de084c:	f000 f888 	bl	c0de0960 <mcu_usb_printf>
}
c0de0850:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
c0de0852:	46c0      	nop			; (mov r8, r8)
c0de0854:	00000c4a 	.word	0x00000c4a
c0de0858:	00000a7f 	.word	0x00000a7f
c0de085c:	000009d7 	.word	0x000009d7
c0de0860:	00000c32 	.word	0x00000c32
c0de0864:	00000b18 	.word	0x00000b18
c0de0868:	00000b1a 	.word	0x00000b1a
c0de086c:	00000c98 	.word	0x00000c98
c0de0870:	00000c12 	.word	0x00000c12
c0de0874:	00000a5e 	.word	0x00000a5e
c0de0878:	00000b51 	.word	0x00000b51
c0de087c:	00000bcf 	.word	0x00000bcf
c0de0880:	00000b9a 	.word	0x00000b9a

c0de0884 <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de0884:	b580      	push	{r7, lr}
c0de0886:	4602      	mov	r2, r0
c0de0888:	2083      	movs	r0, #131	; 0x83
c0de088a:	0040      	lsls	r0, r0, #1
    switch (message) {
c0de088c:	4282      	cmp	r2, r0
c0de088e:	d017      	beq.n	c0de08c0 <dispatch_plugin_calls+0x3c>
c0de0890:	2081      	movs	r0, #129	; 0x81
c0de0892:	0040      	lsls	r0, r0, #1
c0de0894:	4282      	cmp	r2, r0
c0de0896:	d017      	beq.n	c0de08c8 <dispatch_plugin_calls+0x44>
c0de0898:	20ff      	movs	r0, #255	; 0xff
c0de089a:	4603      	mov	r3, r0
c0de089c:	3304      	adds	r3, #4
c0de089e:	429a      	cmp	r2, r3
c0de08a0:	d016      	beq.n	c0de08d0 <dispatch_plugin_calls+0x4c>
c0de08a2:	2341      	movs	r3, #65	; 0x41
c0de08a4:	009b      	lsls	r3, r3, #2
c0de08a6:	429a      	cmp	r2, r3
c0de08a8:	d016      	beq.n	c0de08d8 <dispatch_plugin_calls+0x54>
c0de08aa:	4603      	mov	r3, r0
c0de08ac:	3306      	adds	r3, #6
c0de08ae:	429a      	cmp	r2, r3
c0de08b0:	d016      	beq.n	c0de08e0 <dispatch_plugin_calls+0x5c>
c0de08b2:	3002      	adds	r0, #2
c0de08b4:	4282      	cmp	r2, r0
c0de08b6:	d117      	bne.n	c0de08e8 <dispatch_plugin_calls+0x64>
            handle_init_contract(parameters);
c0de08b8:	4608      	mov	r0, r1
c0de08ba:	f7ff fd77 	bl	c0de03ac <handle_init_contract>
}
c0de08be:	bd80      	pop	{r7, pc}
            handle_query_contract_ui(parameters);
c0de08c0:	4608      	mov	r0, r1
c0de08c2:	f7ff ff01 	bl	c0de06c8 <handle_query_contract_ui>
}
c0de08c6:	bd80      	pop	{r7, pc}
            handle_provide_parameter(parameters);
c0de08c8:	4608      	mov	r0, r1
c0de08ca:	f7ff fdbd 	bl	c0de0448 <handle_provide_parameter>
}
c0de08ce:	bd80      	pop	{r7, pc}
            handle_finalize(parameters);
c0de08d0:	4608      	mov	r0, r1
c0de08d2:	f7ff fd0f 	bl	c0de02f4 <handle_finalize>
}
c0de08d6:	bd80      	pop	{r7, pc}
            handle_provide_token(parameters);
c0de08d8:	4608      	mov	r0, r1
c0de08da:	f7ff fe5d 	bl	c0de0598 <handle_provide_token>
}
c0de08de:	bd80      	pop	{r7, pc}
            handle_query_contract_id(parameters);
c0de08e0:	4608      	mov	r0, r1
c0de08e2:	f7ff fec1 	bl	c0de0668 <handle_query_contract_id>
}
c0de08e6:	bd80      	pop	{r7, pc}
            PRINTF("Unhandled message %d\n", message);
c0de08e8:	4802      	ldr	r0, [pc, #8]	; (c0de08f4 <dispatch_plugin_calls+0x70>)
c0de08ea:	4478      	add	r0, pc
c0de08ec:	4611      	mov	r1, r2
c0de08ee:	f000 f837 	bl	c0de0960 <mcu_usb_printf>
}
c0de08f2:	bd80      	pop	{r7, pc}
c0de08f4:	00000a25 	.word	0x00000a25

c0de08f8 <call_app_ethereum>:
void call_app_ethereum() {
c0de08f8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    libcall_params[0] = (unsigned int) "Ethereum";
c0de08fa:	4805      	ldr	r0, [pc, #20]	; (c0de0910 <call_app_ethereum+0x18>)
c0de08fc:	4478      	add	r0, pc
c0de08fe:	9001      	str	r0, [sp, #4]
c0de0900:	2001      	movs	r0, #1
    libcall_params[2] = RUN_APPLICATION;
c0de0902:	9003      	str	r0, [sp, #12]
c0de0904:	0200      	lsls	r0, r0, #8
    libcall_params[1] = 0x100;
c0de0906:	9002      	str	r0, [sp, #8]
c0de0908:	a801      	add	r0, sp, #4
    os_lib_call((unsigned int *) &libcall_params);
c0de090a:	f000 f9b9 	bl	c0de0c80 <os_lib_call>
}
c0de090e:	bd8f      	pop	{r0, r1, r2, r3, r7, pc}
c0de0910:	00000980 	.word	0x00000980

c0de0914 <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de0914:	b580      	push	{r7, lr}
c0de0916:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de0918:	f000 f9e4 	bl	c0de0ce4 <try_context_set>
#endif // HAVE_BOLOS
}
c0de091c:	bd80      	pop	{r7, pc}
c0de091e:	d4d4      	bmi.n	c0de08ca <dispatch_plugin_calls+0x46>

c0de0920 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de0920:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF  
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de0922:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de0924:	4804      	ldr	r0, [pc, #16]	; (c0de0938 <os_longjmp+0x18>)
c0de0926:	4478      	add	r0, pc
c0de0928:	4621      	mov	r1, r4
c0de092a:	f000 f819 	bl	c0de0960 <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de092e:	f000 f9d1 	bl	c0de0cd4 <try_context_get>
c0de0932:	4621      	mov	r1, r4
c0de0934:	f000 fbe8 	bl	c0de1108 <longjmp>
c0de0938:	000009c9 	.word	0x000009c9

c0de093c <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de093c:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de093e:	460c      	mov	r4, r1
c0de0940:	4605      	mov	r5, r0
c0de0942:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de0944:	7081      	strb	r1, [r0, #2]
c0de0946:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de0948:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de094a:	0a21      	lsrs	r1, r4, #8
c0de094c:	7041      	strb	r1, [r0, #1]
c0de094e:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de0950:	f000 f9b6 	bl	c0de0cc0 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de0954:	b2a1      	uxth	r1, r4
c0de0956:	4628      	mov	r0, r5
c0de0958:	f000 f9b2 	bl	c0de0cc0 <io_seph_send>
}
c0de095c:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
c0de095e:	d4d4      	bmi.n	c0de090a <call_app_ethereum+0x12>

c0de0960 <mcu_usb_printf>:
#include "usbd_def.h"
#include "usbd_core.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de0960:	b083      	sub	sp, #12
c0de0962:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0964:	b08e      	sub	sp, #56	; 0x38
c0de0966:	ac13      	add	r4, sp, #76	; 0x4c
c0de0968:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de096a:	2800      	cmp	r0, #0
c0de096c:	d100      	bne.n	c0de0970 <mcu_usb_printf+0x10>
c0de096e:	e163      	b.n	c0de0c38 <mcu_usb_printf+0x2d8>
c0de0970:	4607      	mov	r7, r0
c0de0972:	a813      	add	r0, sp, #76	; 0x4c
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de0974:	9008      	str	r0, [sp, #32]
c0de0976:	2001      	movs	r0, #1
c0de0978:	9003      	str	r0, [sp, #12]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de097a:	7838      	ldrb	r0, [r7, #0]
c0de097c:	2800      	cmp	r0, #0
c0de097e:	d100      	bne.n	c0de0982 <mcu_usb_printf+0x22>
c0de0980:	e15a      	b.n	c0de0c38 <mcu_usb_printf+0x2d8>
c0de0982:	463c      	mov	r4, r7
c0de0984:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de0986:	2800      	cmp	r0, #0
c0de0988:	d005      	beq.n	c0de0996 <mcu_usb_printf+0x36>
c0de098a:	2825      	cmp	r0, #37	; 0x25
c0de098c:	d003      	beq.n	c0de0996 <mcu_usb_printf+0x36>
c0de098e:	1960      	adds	r0, r4, r5
c0de0990:	7840      	ldrb	r0, [r0, #1]
            ulIdx++)
c0de0992:	1c6d      	adds	r5, r5, #1
c0de0994:	e7f7      	b.n	c0de0986 <mcu_usb_printf+0x26>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de0996:	4620      	mov	r0, r4
c0de0998:	4629      	mov	r1, r5
c0de099a:	f7ff ffcf 	bl	c0de093c <mcu_usb_prints>
c0de099e:	1967      	adds	r7, r4, r5
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de09a0:	5d60      	ldrb	r0, [r4, r5]
c0de09a2:	2825      	cmp	r0, #37	; 0x25
c0de09a4:	d1e9      	bne.n	c0de097a <mcu_usb_printf+0x1a>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de09a6:	1960      	adds	r0, r4, r5
c0de09a8:	1c47      	adds	r7, r0, #1
c0de09aa:	2400      	movs	r4, #0
c0de09ac:	2620      	movs	r6, #32
c0de09ae:	9407      	str	r4, [sp, #28]
c0de09b0:	4622      	mov	r2, r4
c0de09b2:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de09b4:	7839      	ldrb	r1, [r7, #0]
c0de09b6:	1c7f      	adds	r7, r7, #1
c0de09b8:	2200      	movs	r2, #0
c0de09ba:	292d      	cmp	r1, #45	; 0x2d
c0de09bc:	d0f9      	beq.n	c0de09b2 <mcu_usb_printf+0x52>
c0de09be:	460a      	mov	r2, r1
c0de09c0:	3a30      	subs	r2, #48	; 0x30
c0de09c2:	2a0a      	cmp	r2, #10
c0de09c4:	d316      	bcc.n	c0de09f4 <mcu_usb_printf+0x94>
c0de09c6:	2925      	cmp	r1, #37	; 0x25
c0de09c8:	d044      	beq.n	c0de0a54 <mcu_usb_printf+0xf4>
c0de09ca:	292a      	cmp	r1, #42	; 0x2a
c0de09cc:	9704      	str	r7, [sp, #16]
c0de09ce:	d01e      	beq.n	c0de0a0e <mcu_usb_printf+0xae>
c0de09d0:	292e      	cmp	r1, #46	; 0x2e
c0de09d2:	d127      	bne.n	c0de0a24 <mcu_usb_printf+0xc4>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de09d4:	7838      	ldrb	r0, [r7, #0]
c0de09d6:	282a      	cmp	r0, #42	; 0x2a
c0de09d8:	d17d      	bne.n	c0de0ad6 <mcu_usb_printf+0x176>
c0de09da:	9804      	ldr	r0, [sp, #16]
c0de09dc:	7840      	ldrb	r0, [r0, #1]
c0de09de:	2848      	cmp	r0, #72	; 0x48
c0de09e0:	d003      	beq.n	c0de09ea <mcu_usb_printf+0x8a>
c0de09e2:	2873      	cmp	r0, #115	; 0x73
c0de09e4:	d001      	beq.n	c0de09ea <mcu_usb_printf+0x8a>
c0de09e6:	2868      	cmp	r0, #104	; 0x68
c0de09e8:	d175      	bne.n	c0de0ad6 <mcu_usb_printf+0x176>
c0de09ea:	9f04      	ldr	r7, [sp, #16]
c0de09ec:	1c7f      	adds	r7, r7, #1
c0de09ee:	2201      	movs	r2, #1

                    // skip '*' char
                    format++;

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de09f0:	9808      	ldr	r0, [sp, #32]
c0de09f2:	e012      	b.n	c0de0a1a <mcu_usb_printf+0xba>
c0de09f4:	2230      	movs	r2, #48	; 0x30
                    if((format[-1] == '0') && (ulCount == 0))
c0de09f6:	460b      	mov	r3, r1
c0de09f8:	4053      	eors	r3, r2
c0de09fa:	4323      	orrs	r3, r4
c0de09fc:	d000      	beq.n	c0de0a00 <mcu_usb_printf+0xa0>
c0de09fe:	4632      	mov	r2, r6
c0de0a00:	230a      	movs	r3, #10
                    ulCount *= 10;
c0de0a02:	4363      	muls	r3, r4
                    ulCount += format[-1] - '0';
c0de0a04:	185c      	adds	r4, r3, r1
c0de0a06:	3c30      	subs	r4, #48	; 0x30
c0de0a08:	4616      	mov	r6, r2
c0de0a0a:	4602      	mov	r2, r0
c0de0a0c:	e7d1      	b.n	c0de09b2 <mcu_usb_printf+0x52>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de0a0e:	7838      	ldrb	r0, [r7, #0]
c0de0a10:	2873      	cmp	r0, #115	; 0x73
c0de0a12:	d160      	bne.n	c0de0ad6 <mcu_usb_printf+0x176>
c0de0a14:	2202      	movs	r2, #2

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0a16:	9808      	ldr	r0, [sp, #32]
c0de0a18:	9f04      	ldr	r7, [sp, #16]
c0de0a1a:	1d01      	adds	r1, r0, #4
c0de0a1c:	9108      	str	r1, [sp, #32]
c0de0a1e:	6800      	ldr	r0, [r0, #0]
            switch(*format++)
c0de0a20:	9007      	str	r0, [sp, #28]
c0de0a22:	e7c6      	b.n	c0de09b2 <mcu_usb_printf+0x52>
c0de0a24:	2948      	cmp	r1, #72	; 0x48
c0de0a26:	d017      	beq.n	c0de0a58 <mcu_usb_printf+0xf8>
c0de0a28:	2958      	cmp	r1, #88	; 0x58
c0de0a2a:	d01a      	beq.n	c0de0a62 <mcu_usb_printf+0x102>
c0de0a2c:	2963      	cmp	r1, #99	; 0x63
c0de0a2e:	d025      	beq.n	c0de0a7c <mcu_usb_printf+0x11c>
c0de0a30:	2964      	cmp	r1, #100	; 0x64
c0de0a32:	d02d      	beq.n	c0de0a90 <mcu_usb_printf+0x130>
c0de0a34:	4a83      	ldr	r2, [pc, #524]	; (c0de0c44 <mcu_usb_printf+0x2e4>)
c0de0a36:	447a      	add	r2, pc
c0de0a38:	9206      	str	r2, [sp, #24]
c0de0a3a:	2968      	cmp	r1, #104	; 0x68
c0de0a3c:	d037      	beq.n	c0de0aae <mcu_usb_printf+0x14e>
c0de0a3e:	2970      	cmp	r1, #112	; 0x70
c0de0a40:	d005      	beq.n	c0de0a4e <mcu_usb_printf+0xee>
c0de0a42:	2973      	cmp	r1, #115	; 0x73
c0de0a44:	d036      	beq.n	c0de0ab4 <mcu_usb_printf+0x154>
c0de0a46:	2975      	cmp	r1, #117	; 0x75
c0de0a48:	d049      	beq.n	c0de0ade <mcu_usb_printf+0x17e>
c0de0a4a:	2978      	cmp	r1, #120	; 0x78
c0de0a4c:	d143      	bne.n	c0de0ad6 <mcu_usb_printf+0x176>
c0de0a4e:	9601      	str	r6, [sp, #4]
c0de0a50:	2000      	movs	r0, #0
c0de0a52:	e008      	b.n	c0de0a66 <mcu_usb_printf+0x106>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de0a54:	1e78      	subs	r0, r7, #1
c0de0a56:	e017      	b.n	c0de0a88 <mcu_usb_printf+0x128>
c0de0a58:	9405      	str	r4, [sp, #20]
c0de0a5a:	497b      	ldr	r1, [pc, #492]	; (c0de0c48 <mcu_usb_printf+0x2e8>)
c0de0a5c:	4479      	add	r1, pc
c0de0a5e:	9106      	str	r1, [sp, #24]
c0de0a60:	e026      	b.n	c0de0ab0 <mcu_usb_printf+0x150>
c0de0a62:	9601      	str	r6, [sp, #4]
c0de0a64:	2001      	movs	r0, #1
c0de0a66:	9000      	str	r0, [sp, #0]
c0de0a68:	9f03      	ldr	r7, [sp, #12]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0a6a:	9808      	ldr	r0, [sp, #32]
c0de0a6c:	1d01      	adds	r1, r0, #4
c0de0a6e:	9108      	str	r1, [sp, #32]
c0de0a70:	6800      	ldr	r0, [r0, #0]
c0de0a72:	9005      	str	r0, [sp, #20]
c0de0a74:	900d      	str	r0, [sp, #52]	; 0x34
c0de0a76:	2010      	movs	r0, #16
c0de0a78:	9006      	str	r0, [sp, #24]
c0de0a7a:	e03c      	b.n	c0de0af6 <mcu_usb_printf+0x196>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0a7c:	9808      	ldr	r0, [sp, #32]
c0de0a7e:	1d01      	adds	r1, r0, #4
c0de0a80:	9108      	str	r1, [sp, #32]
c0de0a82:	6800      	ldr	r0, [r0, #0]
c0de0a84:	900d      	str	r0, [sp, #52]	; 0x34
c0de0a86:	a80d      	add	r0, sp, #52	; 0x34
c0de0a88:	2101      	movs	r1, #1
c0de0a8a:	f7ff ff57 	bl	c0de093c <mcu_usb_prints>
c0de0a8e:	e774      	b.n	c0de097a <mcu_usb_printf+0x1a>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0a90:	9808      	ldr	r0, [sp, #32]
c0de0a92:	1d01      	adds	r1, r0, #4
c0de0a94:	9108      	str	r1, [sp, #32]
c0de0a96:	6800      	ldr	r0, [r0, #0]
c0de0a98:	900d      	str	r0, [sp, #52]	; 0x34
c0de0a9a:	210a      	movs	r1, #10
                    if((long)ulValue < 0)
c0de0a9c:	2800      	cmp	r0, #0
c0de0a9e:	9601      	str	r6, [sp, #4]
c0de0aa0:	9106      	str	r1, [sp, #24]
c0de0aa2:	d500      	bpl.n	c0de0aa6 <mcu_usb_printf+0x146>
c0de0aa4:	e0b7      	b.n	c0de0c16 <mcu_usb_printf+0x2b6>
c0de0aa6:	9005      	str	r0, [sp, #20]
c0de0aa8:	2000      	movs	r0, #0
c0de0aaa:	9000      	str	r0, [sp, #0]
c0de0aac:	e022      	b.n	c0de0af4 <mcu_usb_printf+0x194>
c0de0aae:	9405      	str	r4, [sp, #20]
c0de0ab0:	9903      	ldr	r1, [sp, #12]
c0de0ab2:	e001      	b.n	c0de0ab8 <mcu_usb_printf+0x158>
c0de0ab4:	9405      	str	r4, [sp, #20]
c0de0ab6:	2100      	movs	r1, #0
                    pcStr = va_arg(vaArgP, char *);
c0de0ab8:	9a08      	ldr	r2, [sp, #32]
c0de0aba:	1d13      	adds	r3, r2, #4
c0de0abc:	9308      	str	r3, [sp, #32]
                    switch(cStrlenSet) {
c0de0abe:	b2c0      	uxtb	r0, r0
                    pcStr = va_arg(vaArgP, char *);
c0de0ac0:	6817      	ldr	r7, [r2, #0]
                    switch(cStrlenSet) {
c0de0ac2:	2800      	cmp	r0, #0
c0de0ac4:	d074      	beq.n	c0de0bb0 <mcu_usb_printf+0x250>
c0de0ac6:	2801      	cmp	r0, #1
c0de0ac8:	d079      	beq.n	c0de0bbe <mcu_usb_printf+0x25e>
c0de0aca:	2802      	cmp	r0, #2
c0de0acc:	d178      	bne.n	c0de0bc0 <mcu_usb_printf+0x260>
                        if (pcStr[0] == '\0') {
c0de0ace:	7838      	ldrb	r0, [r7, #0]
c0de0ad0:	2800      	cmp	r0, #0
c0de0ad2:	d100      	bne.n	c0de0ad6 <mcu_usb_printf+0x176>
c0de0ad4:	e0a6      	b.n	c0de0c24 <mcu_usb_printf+0x2c4>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de0ad6:	4861      	ldr	r0, [pc, #388]	; (c0de0c5c <mcu_usb_printf+0x2fc>)
c0de0ad8:	4478      	add	r0, pc
c0de0ada:	2105      	movs	r1, #5
c0de0adc:	e064      	b.n	c0de0ba8 <mcu_usb_printf+0x248>
c0de0ade:	9601      	str	r6, [sp, #4]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0ae0:	9808      	ldr	r0, [sp, #32]
c0de0ae2:	1d01      	adds	r1, r0, #4
c0de0ae4:	9108      	str	r1, [sp, #32]
c0de0ae6:	6800      	ldr	r0, [r0, #0]
c0de0ae8:	9005      	str	r0, [sp, #20]
c0de0aea:	900d      	str	r0, [sp, #52]	; 0x34
c0de0aec:	2000      	movs	r0, #0
c0de0aee:	9000      	str	r0, [sp, #0]
c0de0af0:	200a      	movs	r0, #10
c0de0af2:	9006      	str	r0, [sp, #24]
c0de0af4:	9f03      	ldr	r7, [sp, #12]
c0de0af6:	4639      	mov	r1, r7
c0de0af8:	4856      	ldr	r0, [pc, #344]	; (c0de0c54 <mcu_usb_printf+0x2f4>)
c0de0afa:	4478      	add	r0, pc
                    for(ulIdx = 1;
c0de0afc:	9007      	str	r0, [sp, #28]
c0de0afe:	9102      	str	r1, [sp, #8]
c0de0b00:	19c8      	adds	r0, r1, r7
c0de0b02:	4038      	ands	r0, r7
c0de0b04:	1a26      	subs	r6, r4, r0
c0de0b06:	1e75      	subs	r5, r6, #1
c0de0b08:	2400      	movs	r4, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de0b0a:	9806      	ldr	r0, [sp, #24]
c0de0b0c:	4621      	mov	r1, r4
c0de0b0e:	463a      	mov	r2, r7
c0de0b10:	4623      	mov	r3, r4
c0de0b12:	f000 f97f 	bl	c0de0e14 <__aeabi_lmul>
c0de0b16:	1e4a      	subs	r2, r1, #1
c0de0b18:	4191      	sbcs	r1, r2
c0de0b1a:	9a05      	ldr	r2, [sp, #20]
c0de0b1c:	4290      	cmp	r0, r2
c0de0b1e:	d805      	bhi.n	c0de0b2c <mcu_usb_printf+0x1cc>
                    for(ulIdx = 1;
c0de0b20:	2900      	cmp	r1, #0
c0de0b22:	d103      	bne.n	c0de0b2c <mcu_usb_printf+0x1cc>
c0de0b24:	1e6d      	subs	r5, r5, #1
c0de0b26:	1e76      	subs	r6, r6, #1
c0de0b28:	4607      	mov	r7, r0
c0de0b2a:	e7ed      	b.n	c0de0b08 <mcu_usb_printf+0x1a8>
                    if(ulNeg && (cFill == '0'))
c0de0b2c:	9802      	ldr	r0, [sp, #8]
c0de0b2e:	2800      	cmp	r0, #0
c0de0b30:	9803      	ldr	r0, [sp, #12]
c0de0b32:	9a01      	ldr	r2, [sp, #4]
c0de0b34:	d109      	bne.n	c0de0b4a <mcu_usb_printf+0x1ea>
c0de0b36:	b2d1      	uxtb	r1, r2
c0de0b38:	2000      	movs	r0, #0
c0de0b3a:	2930      	cmp	r1, #48	; 0x30
c0de0b3c:	4604      	mov	r4, r0
c0de0b3e:	d104      	bne.n	c0de0b4a <mcu_usb_printf+0x1ea>
c0de0b40:	a809      	add	r0, sp, #36	; 0x24
c0de0b42:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0b44:	7001      	strb	r1, [r0, #0]
c0de0b46:	2401      	movs	r4, #1
c0de0b48:	9803      	ldr	r0, [sp, #12]
                    if((ulCount > 1) && (ulCount < 16))
c0de0b4a:	1eb1      	subs	r1, r6, #2
c0de0b4c:	290d      	cmp	r1, #13
c0de0b4e:	d807      	bhi.n	c0de0b60 <mcu_usb_printf+0x200>
c0de0b50:	9e06      	ldr	r6, [sp, #24]
                        for(ulCount--; ulCount; ulCount--)
c0de0b52:	2d00      	cmp	r5, #0
c0de0b54:	d005      	beq.n	c0de0b62 <mcu_usb_printf+0x202>
c0de0b56:	a909      	add	r1, sp, #36	; 0x24
                            pcBuf[ulPos++] = cFill;
c0de0b58:	550a      	strb	r2, [r1, r4]
                        for(ulCount--; ulCount; ulCount--)
c0de0b5a:	1e6d      	subs	r5, r5, #1
                            pcBuf[ulPos++] = cFill;
c0de0b5c:	1c64      	adds	r4, r4, #1
c0de0b5e:	e7f8      	b.n	c0de0b52 <mcu_usb_printf+0x1f2>
c0de0b60:	9e06      	ldr	r6, [sp, #24]
                    if(ulNeg)
c0de0b62:	2800      	cmp	r0, #0
c0de0b64:	9d05      	ldr	r5, [sp, #20]
c0de0b66:	d103      	bne.n	c0de0b70 <mcu_usb_printf+0x210>
c0de0b68:	a809      	add	r0, sp, #36	; 0x24
c0de0b6a:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0b6c:	5501      	strb	r1, [r0, r4]
c0de0b6e:	1c64      	adds	r4, r4, #1
c0de0b70:	9800      	ldr	r0, [sp, #0]
c0de0b72:	2800      	cmp	r0, #0
c0de0b74:	d114      	bne.n	c0de0ba0 <mcu_usb_printf+0x240>
c0de0b76:	4838      	ldr	r0, [pc, #224]	; (c0de0c58 <mcu_usb_printf+0x2f8>)
c0de0b78:	4478      	add	r0, pc
c0de0b7a:	9007      	str	r0, [sp, #28]
c0de0b7c:	e010      	b.n	c0de0ba0 <mcu_usb_printf+0x240>
c0de0b7e:	4628      	mov	r0, r5
c0de0b80:	4639      	mov	r1, r7
c0de0b82:	f000 f8bb 	bl	c0de0cfc <__udivsi3>
c0de0b86:	4631      	mov	r1, r6
c0de0b88:	f000 f93e 	bl	c0de0e08 <__aeabi_uidivmod>
c0de0b8c:	9807      	ldr	r0, [sp, #28]
c0de0b8e:	5c40      	ldrb	r0, [r0, r1]
c0de0b90:	a909      	add	r1, sp, #36	; 0x24
                          pcBuf[ulPos++] = g_pcHex[(ulValue / ulIdx) % ulBase];
c0de0b92:	5508      	strb	r0, [r1, r4]
                    for(; ulIdx; ulIdx /= ulBase)
c0de0b94:	4638      	mov	r0, r7
c0de0b96:	4631      	mov	r1, r6
c0de0b98:	f000 f8b0 	bl	c0de0cfc <__udivsi3>
c0de0b9c:	4607      	mov	r7, r0
c0de0b9e:	1c64      	adds	r4, r4, #1
c0de0ba0:	2f00      	cmp	r7, #0
c0de0ba2:	d1ec      	bne.n	c0de0b7e <mcu_usb_printf+0x21e>
c0de0ba4:	a809      	add	r0, sp, #36	; 0x24
                    mcu_usb_prints(pcBuf, ulPos);
c0de0ba6:	4621      	mov	r1, r4
c0de0ba8:	f7ff fec8 	bl	c0de093c <mcu_usb_prints>
c0de0bac:	9f04      	ldr	r7, [sp, #16]
c0de0bae:	e6e4      	b.n	c0de097a <mcu_usb_printf+0x1a>
c0de0bb0:	2000      	movs	r0, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de0bb2:	5c3a      	ldrb	r2, [r7, r0]
c0de0bb4:	1c40      	adds	r0, r0, #1
c0de0bb6:	2a00      	cmp	r2, #0
c0de0bb8:	d1fb      	bne.n	c0de0bb2 <mcu_usb_printf+0x252>
                    switch(ulBase) {
c0de0bba:	1e45      	subs	r5, r0, #1
c0de0bbc:	e000      	b.n	c0de0bc0 <mcu_usb_printf+0x260>
c0de0bbe:	9d07      	ldr	r5, [sp, #28]
c0de0bc0:	2900      	cmp	r1, #0
c0de0bc2:	d014      	beq.n	c0de0bee <mcu_usb_printf+0x28e>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0bc4:	2d00      	cmp	r5, #0
c0de0bc6:	d0f1      	beq.n	c0de0bac <mcu_usb_printf+0x24c>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de0bc8:	783e      	ldrb	r6, [r7, #0]
c0de0bca:	0930      	lsrs	r0, r6, #4
c0de0bcc:	9c06      	ldr	r4, [sp, #24]
c0de0bce:	1820      	adds	r0, r4, r0
c0de0bd0:	9507      	str	r5, [sp, #28]
c0de0bd2:	2501      	movs	r5, #1
c0de0bd4:	4629      	mov	r1, r5
c0de0bd6:	f7ff feb1 	bl	c0de093c <mcu_usb_prints>
c0de0bda:	200f      	movs	r0, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de0bdc:	4030      	ands	r0, r6
c0de0bde:	1820      	adds	r0, r4, r0
c0de0be0:	4629      	mov	r1, r5
c0de0be2:	9d07      	ldr	r5, [sp, #28]
c0de0be4:	f7ff feaa 	bl	c0de093c <mcu_usb_prints>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0be8:	1c7f      	adds	r7, r7, #1
c0de0bea:	1e6d      	subs	r5, r5, #1
c0de0bec:	e7ea      	b.n	c0de0bc4 <mcu_usb_printf+0x264>
                        mcu_usb_prints(pcStr, ulIdx);
c0de0bee:	4638      	mov	r0, r7
c0de0bf0:	4629      	mov	r1, r5
c0de0bf2:	f7ff fea3 	bl	c0de093c <mcu_usb_prints>
c0de0bf6:	9f04      	ldr	r7, [sp, #16]
c0de0bf8:	9805      	ldr	r0, [sp, #20]
                    if(ulCount > ulIdx)
c0de0bfa:	42a8      	cmp	r0, r5
c0de0bfc:	d800      	bhi.n	c0de0c00 <mcu_usb_printf+0x2a0>
c0de0bfe:	e6bc      	b.n	c0de097a <mcu_usb_printf+0x1a>
                        while(ulCount--)
c0de0c00:	1a2c      	subs	r4, r5, r0
c0de0c02:	2c00      	cmp	r4, #0
c0de0c04:	d100      	bne.n	c0de0c08 <mcu_usb_printf+0x2a8>
c0de0c06:	e6b8      	b.n	c0de097a <mcu_usb_printf+0x1a>
                            mcu_usb_prints(" ", 1);
c0de0c08:	4811      	ldr	r0, [pc, #68]	; (c0de0c50 <mcu_usb_printf+0x2f0>)
c0de0c0a:	4478      	add	r0, pc
c0de0c0c:	2101      	movs	r1, #1
c0de0c0e:	f7ff fe95 	bl	c0de093c <mcu_usb_prints>
                        while(ulCount--)
c0de0c12:	1c64      	adds	r4, r4, #1
c0de0c14:	e7f5      	b.n	c0de0c02 <mcu_usb_printf+0x2a2>
                        ulValue = -(long)ulValue;
c0de0c16:	4240      	negs	r0, r0
c0de0c18:	9005      	str	r0, [sp, #20]
c0de0c1a:	900d      	str	r0, [sp, #52]	; 0x34
c0de0c1c:	2100      	movs	r1, #0
            ulCap = 0;
c0de0c1e:	9100      	str	r1, [sp, #0]
c0de0c20:	9f03      	ldr	r7, [sp, #12]
c0de0c22:	e769      	b.n	c0de0af8 <mcu_usb_printf+0x198>
                          do {
c0de0c24:	9807      	ldr	r0, [sp, #28]
c0de0c26:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de0c28:	4808      	ldr	r0, [pc, #32]	; (c0de0c4c <mcu_usb_printf+0x2ec>)
c0de0c2a:	4478      	add	r0, pc
c0de0c2c:	2101      	movs	r1, #1
c0de0c2e:	f7ff fe85 	bl	c0de093c <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de0c32:	1e64      	subs	r4, r4, #1
c0de0c34:	d1f8      	bne.n	c0de0c28 <mcu_usb_printf+0x2c8>
c0de0c36:	e7de      	b.n	c0de0bf6 <mcu_usb_printf+0x296>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de0c38:	b00e      	add	sp, #56	; 0x38
c0de0c3a:	bcf0      	pop	{r4, r5, r6, r7}
c0de0c3c:	bc01      	pop	{r0}
c0de0c3e:	b003      	add	sp, #12
c0de0c40:	4700      	bx	r0
c0de0c42:	46c0      	nop			; (mov r8, r8)
c0de0c44:	000009f2 	.word	0x000009f2
c0de0c48:	000009dc 	.word	0x000009dc
c0de0c4c:	000005e0 	.word	0x000005e0
c0de0c50:	00000600 	.word	0x00000600
c0de0c54:	0000093e 	.word	0x0000093e
c0de0c58:	000008b0 	.word	0x000008b0
c0de0c5c:	00000831 	.word	0x00000831

c0de0c60 <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de0c60:	df01      	svc	1
    cmp r1, #0
c0de0c62:	2900      	cmp	r1, #0
    bne exception
c0de0c64:	d100      	bne.n	c0de0c68 <exception>
    bx lr
c0de0c66:	4770      	bx	lr

c0de0c68 <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de0c68:	4608      	mov	r0, r1
    bl os_longjmp
c0de0c6a:	f7ff fe59 	bl	c0de0920 <os_longjmp>

c0de0c6e <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de0c6e:	b5e0      	push	{r5, r6, r7, lr}
c0de0c70:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de0c72:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de0c74:	9000      	str	r0, [sp, #0]
c0de0c76:	2001      	movs	r0, #1
c0de0c78:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de0c7a:	f7ff fff1 	bl	c0de0c60 <SVC_Call>
c0de0c7e:	bd8c      	pop	{r2, r3, r7, pc}

c0de0c80 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de0c80:	b5e0      	push	{r5, r6, r7, lr}
c0de0c82:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de0c84:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de0c86:	9000      	str	r0, [sp, #0]
c0de0c88:	4802      	ldr	r0, [pc, #8]	; (c0de0c94 <os_lib_call+0x14>)
c0de0c8a:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de0c8c:	f7ff ffe8 	bl	c0de0c60 <SVC_Call>
  return;
}
c0de0c90:	bd8c      	pop	{r2, r3, r7, pc}
c0de0c92:	46c0      	nop			; (mov r8, r8)
c0de0c94:	01000067 	.word	0x01000067

c0de0c98 <os_lib_end>:

void os_lib_end ( void ) {
c0de0c98:	b5e0      	push	{r5, r6, r7, lr}
c0de0c9a:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0c9c:	9001      	str	r0, [sp, #4]
c0de0c9e:	2068      	movs	r0, #104	; 0x68
c0de0ca0:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de0ca2:	f7ff ffdd 	bl	c0de0c60 <SVC_Call>
  return;
}
c0de0ca6:	bd8c      	pop	{r2, r3, r7, pc}

c0de0ca8 <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de0ca8:	b082      	sub	sp, #8
c0de0caa:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de0cac:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de0cae:	9000      	str	r0, [sp, #0]
c0de0cb0:	4802      	ldr	r0, [pc, #8]	; (c0de0cbc <os_sched_exit+0x14>)
c0de0cb2:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de0cb4:	f7ff ffd4 	bl	c0de0c60 <SVC_Call>

  // The os_sched_exit syscall should never return. Just in case, prevent the
  // device from freezing (because of the following infinite loop) thanks to an
  // undefined instruction.
  asm volatile ("udf #255");
c0de0cb8:	deff      	udf	#255	; 0xff

  // remove the warning caused by -Winvalid-noreturn
  while (1) {
c0de0cba:	e7fe      	b.n	c0de0cba <os_sched_exit+0x12>
c0de0cbc:	0100009a 	.word	0x0100009a

c0de0cc0 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de0cc0:	b5e0      	push	{r5, r6, r7, lr}
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de0cc2:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de0cc4:	9000      	str	r0, [sp, #0]
c0de0cc6:	4802      	ldr	r0, [pc, #8]	; (c0de0cd0 <io_seph_send+0x10>)
c0de0cc8:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de0cca:	f7ff ffc9 	bl	c0de0c60 <SVC_Call>
  return;
}
c0de0cce:	bd8c      	pop	{r2, r3, r7, pc}
c0de0cd0:	02000083 	.word	0x02000083

c0de0cd4 <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de0cd4:	b5e0      	push	{r5, r6, r7, lr}
c0de0cd6:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0cd8:	9001      	str	r0, [sp, #4]
c0de0cda:	2087      	movs	r0, #135	; 0x87
c0de0cdc:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de0cde:	f7ff ffbf 	bl	c0de0c60 <SVC_Call>
c0de0ce2:	bd8c      	pop	{r2, r3, r7, pc}

c0de0ce4 <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de0ce4:	b5e0      	push	{r5, r6, r7, lr}
c0de0ce6:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de0ce8:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de0cea:	9000      	str	r0, [sp, #0]
c0de0cec:	4802      	ldr	r0, [pc, #8]	; (c0de0cf8 <try_context_set+0x14>)
c0de0cee:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de0cf0:	f7ff ffb6 	bl	c0de0c60 <SVC_Call>
c0de0cf4:	bd8c      	pop	{r2, r3, r7, pc}
c0de0cf6:	46c0      	nop			; (mov r8, r8)
c0de0cf8:	0100010b 	.word	0x0100010b

c0de0cfc <__udivsi3>:
c0de0cfc:	2200      	movs	r2, #0
c0de0cfe:	0843      	lsrs	r3, r0, #1
c0de0d00:	428b      	cmp	r3, r1
c0de0d02:	d374      	bcc.n	c0de0dee <__udivsi3+0xf2>
c0de0d04:	0903      	lsrs	r3, r0, #4
c0de0d06:	428b      	cmp	r3, r1
c0de0d08:	d35f      	bcc.n	c0de0dca <__udivsi3+0xce>
c0de0d0a:	0a03      	lsrs	r3, r0, #8
c0de0d0c:	428b      	cmp	r3, r1
c0de0d0e:	d344      	bcc.n	c0de0d9a <__udivsi3+0x9e>
c0de0d10:	0b03      	lsrs	r3, r0, #12
c0de0d12:	428b      	cmp	r3, r1
c0de0d14:	d328      	bcc.n	c0de0d68 <__udivsi3+0x6c>
c0de0d16:	0c03      	lsrs	r3, r0, #16
c0de0d18:	428b      	cmp	r3, r1
c0de0d1a:	d30d      	bcc.n	c0de0d38 <__udivsi3+0x3c>
c0de0d1c:	22ff      	movs	r2, #255	; 0xff
c0de0d1e:	0209      	lsls	r1, r1, #8
c0de0d20:	ba12      	rev	r2, r2
c0de0d22:	0c03      	lsrs	r3, r0, #16
c0de0d24:	428b      	cmp	r3, r1
c0de0d26:	d302      	bcc.n	c0de0d2e <__udivsi3+0x32>
c0de0d28:	1212      	asrs	r2, r2, #8
c0de0d2a:	0209      	lsls	r1, r1, #8
c0de0d2c:	d065      	beq.n	c0de0dfa <__udivsi3+0xfe>
c0de0d2e:	0b03      	lsrs	r3, r0, #12
c0de0d30:	428b      	cmp	r3, r1
c0de0d32:	d319      	bcc.n	c0de0d68 <__udivsi3+0x6c>
c0de0d34:	e000      	b.n	c0de0d38 <__udivsi3+0x3c>
c0de0d36:	0a09      	lsrs	r1, r1, #8
c0de0d38:	0bc3      	lsrs	r3, r0, #15
c0de0d3a:	428b      	cmp	r3, r1
c0de0d3c:	d301      	bcc.n	c0de0d42 <__udivsi3+0x46>
c0de0d3e:	03cb      	lsls	r3, r1, #15
c0de0d40:	1ac0      	subs	r0, r0, r3
c0de0d42:	4152      	adcs	r2, r2
c0de0d44:	0b83      	lsrs	r3, r0, #14
c0de0d46:	428b      	cmp	r3, r1
c0de0d48:	d301      	bcc.n	c0de0d4e <__udivsi3+0x52>
c0de0d4a:	038b      	lsls	r3, r1, #14
c0de0d4c:	1ac0      	subs	r0, r0, r3
c0de0d4e:	4152      	adcs	r2, r2
c0de0d50:	0b43      	lsrs	r3, r0, #13
c0de0d52:	428b      	cmp	r3, r1
c0de0d54:	d301      	bcc.n	c0de0d5a <__udivsi3+0x5e>
c0de0d56:	034b      	lsls	r3, r1, #13
c0de0d58:	1ac0      	subs	r0, r0, r3
c0de0d5a:	4152      	adcs	r2, r2
c0de0d5c:	0b03      	lsrs	r3, r0, #12
c0de0d5e:	428b      	cmp	r3, r1
c0de0d60:	d301      	bcc.n	c0de0d66 <__udivsi3+0x6a>
c0de0d62:	030b      	lsls	r3, r1, #12
c0de0d64:	1ac0      	subs	r0, r0, r3
c0de0d66:	4152      	adcs	r2, r2
c0de0d68:	0ac3      	lsrs	r3, r0, #11
c0de0d6a:	428b      	cmp	r3, r1
c0de0d6c:	d301      	bcc.n	c0de0d72 <__udivsi3+0x76>
c0de0d6e:	02cb      	lsls	r3, r1, #11
c0de0d70:	1ac0      	subs	r0, r0, r3
c0de0d72:	4152      	adcs	r2, r2
c0de0d74:	0a83      	lsrs	r3, r0, #10
c0de0d76:	428b      	cmp	r3, r1
c0de0d78:	d301      	bcc.n	c0de0d7e <__udivsi3+0x82>
c0de0d7a:	028b      	lsls	r3, r1, #10
c0de0d7c:	1ac0      	subs	r0, r0, r3
c0de0d7e:	4152      	adcs	r2, r2
c0de0d80:	0a43      	lsrs	r3, r0, #9
c0de0d82:	428b      	cmp	r3, r1
c0de0d84:	d301      	bcc.n	c0de0d8a <__udivsi3+0x8e>
c0de0d86:	024b      	lsls	r3, r1, #9
c0de0d88:	1ac0      	subs	r0, r0, r3
c0de0d8a:	4152      	adcs	r2, r2
c0de0d8c:	0a03      	lsrs	r3, r0, #8
c0de0d8e:	428b      	cmp	r3, r1
c0de0d90:	d301      	bcc.n	c0de0d96 <__udivsi3+0x9a>
c0de0d92:	020b      	lsls	r3, r1, #8
c0de0d94:	1ac0      	subs	r0, r0, r3
c0de0d96:	4152      	adcs	r2, r2
c0de0d98:	d2cd      	bcs.n	c0de0d36 <__udivsi3+0x3a>
c0de0d9a:	09c3      	lsrs	r3, r0, #7
c0de0d9c:	428b      	cmp	r3, r1
c0de0d9e:	d301      	bcc.n	c0de0da4 <__udivsi3+0xa8>
c0de0da0:	01cb      	lsls	r3, r1, #7
c0de0da2:	1ac0      	subs	r0, r0, r3
c0de0da4:	4152      	adcs	r2, r2
c0de0da6:	0983      	lsrs	r3, r0, #6
c0de0da8:	428b      	cmp	r3, r1
c0de0daa:	d301      	bcc.n	c0de0db0 <__udivsi3+0xb4>
c0de0dac:	018b      	lsls	r3, r1, #6
c0de0dae:	1ac0      	subs	r0, r0, r3
c0de0db0:	4152      	adcs	r2, r2
c0de0db2:	0943      	lsrs	r3, r0, #5
c0de0db4:	428b      	cmp	r3, r1
c0de0db6:	d301      	bcc.n	c0de0dbc <__udivsi3+0xc0>
c0de0db8:	014b      	lsls	r3, r1, #5
c0de0dba:	1ac0      	subs	r0, r0, r3
c0de0dbc:	4152      	adcs	r2, r2
c0de0dbe:	0903      	lsrs	r3, r0, #4
c0de0dc0:	428b      	cmp	r3, r1
c0de0dc2:	d301      	bcc.n	c0de0dc8 <__udivsi3+0xcc>
c0de0dc4:	010b      	lsls	r3, r1, #4
c0de0dc6:	1ac0      	subs	r0, r0, r3
c0de0dc8:	4152      	adcs	r2, r2
c0de0dca:	08c3      	lsrs	r3, r0, #3
c0de0dcc:	428b      	cmp	r3, r1
c0de0dce:	d301      	bcc.n	c0de0dd4 <__udivsi3+0xd8>
c0de0dd0:	00cb      	lsls	r3, r1, #3
c0de0dd2:	1ac0      	subs	r0, r0, r3
c0de0dd4:	4152      	adcs	r2, r2
c0de0dd6:	0883      	lsrs	r3, r0, #2
c0de0dd8:	428b      	cmp	r3, r1
c0de0dda:	d301      	bcc.n	c0de0de0 <__udivsi3+0xe4>
c0de0ddc:	008b      	lsls	r3, r1, #2
c0de0dde:	1ac0      	subs	r0, r0, r3
c0de0de0:	4152      	adcs	r2, r2
c0de0de2:	0843      	lsrs	r3, r0, #1
c0de0de4:	428b      	cmp	r3, r1
c0de0de6:	d301      	bcc.n	c0de0dec <__udivsi3+0xf0>
c0de0de8:	004b      	lsls	r3, r1, #1
c0de0dea:	1ac0      	subs	r0, r0, r3
c0de0dec:	4152      	adcs	r2, r2
c0de0dee:	1a41      	subs	r1, r0, r1
c0de0df0:	d200      	bcs.n	c0de0df4 <__udivsi3+0xf8>
c0de0df2:	4601      	mov	r1, r0
c0de0df4:	4152      	adcs	r2, r2
c0de0df6:	4610      	mov	r0, r2
c0de0df8:	4770      	bx	lr
c0de0dfa:	e7ff      	b.n	c0de0dfc <__udivsi3+0x100>
c0de0dfc:	b501      	push	{r0, lr}
c0de0dfe:	2000      	movs	r0, #0
c0de0e00:	f000 f806 	bl	c0de0e10 <__aeabi_idiv0>
c0de0e04:	bd02      	pop	{r1, pc}
c0de0e06:	46c0      	nop			; (mov r8, r8)

c0de0e08 <__aeabi_uidivmod>:
c0de0e08:	2900      	cmp	r1, #0
c0de0e0a:	d0f7      	beq.n	c0de0dfc <__udivsi3+0x100>
c0de0e0c:	e776      	b.n	c0de0cfc <__udivsi3>
c0de0e0e:	4770      	bx	lr

c0de0e10 <__aeabi_idiv0>:
c0de0e10:	4770      	bx	lr
c0de0e12:	46c0      	nop			; (mov r8, r8)

c0de0e14 <__aeabi_lmul>:
c0de0e14:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0e16:	46ce      	mov	lr, r9
c0de0e18:	4647      	mov	r7, r8
c0de0e1a:	0415      	lsls	r5, r2, #16
c0de0e1c:	0c2d      	lsrs	r5, r5, #16
c0de0e1e:	002e      	movs	r6, r5
c0de0e20:	b580      	push	{r7, lr}
c0de0e22:	0407      	lsls	r7, r0, #16
c0de0e24:	0c14      	lsrs	r4, r2, #16
c0de0e26:	0c3f      	lsrs	r7, r7, #16
c0de0e28:	4699      	mov	r9, r3
c0de0e2a:	0c03      	lsrs	r3, r0, #16
c0de0e2c:	437e      	muls	r6, r7
c0de0e2e:	435d      	muls	r5, r3
c0de0e30:	4367      	muls	r7, r4
c0de0e32:	4363      	muls	r3, r4
c0de0e34:	197f      	adds	r7, r7, r5
c0de0e36:	0c34      	lsrs	r4, r6, #16
c0de0e38:	19e4      	adds	r4, r4, r7
c0de0e3a:	469c      	mov	ip, r3
c0de0e3c:	42a5      	cmp	r5, r4
c0de0e3e:	d903      	bls.n	c0de0e48 <__aeabi_lmul+0x34>
c0de0e40:	2380      	movs	r3, #128	; 0x80
c0de0e42:	025b      	lsls	r3, r3, #9
c0de0e44:	4698      	mov	r8, r3
c0de0e46:	44c4      	add	ip, r8
c0de0e48:	464b      	mov	r3, r9
c0de0e4a:	4343      	muls	r3, r0
c0de0e4c:	4351      	muls	r1, r2
c0de0e4e:	0c25      	lsrs	r5, r4, #16
c0de0e50:	0436      	lsls	r6, r6, #16
c0de0e52:	4465      	add	r5, ip
c0de0e54:	0c36      	lsrs	r6, r6, #16
c0de0e56:	0424      	lsls	r4, r4, #16
c0de0e58:	19a4      	adds	r4, r4, r6
c0de0e5a:	195b      	adds	r3, r3, r5
c0de0e5c:	1859      	adds	r1, r3, r1
c0de0e5e:	0020      	movs	r0, r4
c0de0e60:	bc0c      	pop	{r2, r3}
c0de0e62:	4690      	mov	r8, r2
c0de0e64:	4699      	mov	r9, r3
c0de0e66:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de0e68 <__aeabi_memclr>:
c0de0e68:	b510      	push	{r4, lr}
c0de0e6a:	2200      	movs	r2, #0
c0de0e6c:	f000 f80a 	bl	c0de0e84 <__aeabi_memset>
c0de0e70:	bd10      	pop	{r4, pc}
c0de0e72:	46c0      	nop			; (mov r8, r8)

c0de0e74 <__aeabi_memcpy>:
c0de0e74:	b510      	push	{r4, lr}
c0de0e76:	f000 f835 	bl	c0de0ee4 <memcpy>
c0de0e7a:	bd10      	pop	{r4, pc}

c0de0e7c <__aeabi_memmove>:
c0de0e7c:	b510      	push	{r4, lr}
c0de0e7e:	f000 f885 	bl	c0de0f8c <memmove>
c0de0e82:	bd10      	pop	{r4, pc}

c0de0e84 <__aeabi_memset>:
c0de0e84:	0013      	movs	r3, r2
c0de0e86:	b510      	push	{r4, lr}
c0de0e88:	000a      	movs	r2, r1
c0de0e8a:	0019      	movs	r1, r3
c0de0e8c:	f000 f8dc 	bl	c0de1048 <memset>
c0de0e90:	bd10      	pop	{r4, pc}
c0de0e92:	46c0      	nop			; (mov r8, r8)

c0de0e94 <memcmp>:
c0de0e94:	b530      	push	{r4, r5, lr}
c0de0e96:	2a03      	cmp	r2, #3
c0de0e98:	d90c      	bls.n	c0de0eb4 <memcmp+0x20>
c0de0e9a:	0003      	movs	r3, r0
c0de0e9c:	430b      	orrs	r3, r1
c0de0e9e:	079b      	lsls	r3, r3, #30
c0de0ea0:	d11c      	bne.n	c0de0edc <memcmp+0x48>
c0de0ea2:	6803      	ldr	r3, [r0, #0]
c0de0ea4:	680c      	ldr	r4, [r1, #0]
c0de0ea6:	42a3      	cmp	r3, r4
c0de0ea8:	d118      	bne.n	c0de0edc <memcmp+0x48>
c0de0eaa:	3a04      	subs	r2, #4
c0de0eac:	3004      	adds	r0, #4
c0de0eae:	3104      	adds	r1, #4
c0de0eb0:	2a03      	cmp	r2, #3
c0de0eb2:	d8f6      	bhi.n	c0de0ea2 <memcmp+0xe>
c0de0eb4:	1e55      	subs	r5, r2, #1
c0de0eb6:	2a00      	cmp	r2, #0
c0de0eb8:	d00e      	beq.n	c0de0ed8 <memcmp+0x44>
c0de0eba:	7802      	ldrb	r2, [r0, #0]
c0de0ebc:	780c      	ldrb	r4, [r1, #0]
c0de0ebe:	4294      	cmp	r4, r2
c0de0ec0:	d10e      	bne.n	c0de0ee0 <memcmp+0x4c>
c0de0ec2:	3501      	adds	r5, #1
c0de0ec4:	2301      	movs	r3, #1
c0de0ec6:	3901      	subs	r1, #1
c0de0ec8:	e004      	b.n	c0de0ed4 <memcmp+0x40>
c0de0eca:	5cc2      	ldrb	r2, [r0, r3]
c0de0ecc:	3301      	adds	r3, #1
c0de0ece:	5ccc      	ldrb	r4, [r1, r3]
c0de0ed0:	42a2      	cmp	r2, r4
c0de0ed2:	d105      	bne.n	c0de0ee0 <memcmp+0x4c>
c0de0ed4:	42ab      	cmp	r3, r5
c0de0ed6:	d1f8      	bne.n	c0de0eca <memcmp+0x36>
c0de0ed8:	2000      	movs	r0, #0
c0de0eda:	bd30      	pop	{r4, r5, pc}
c0de0edc:	1e55      	subs	r5, r2, #1
c0de0ede:	e7ec      	b.n	c0de0eba <memcmp+0x26>
c0de0ee0:	1b10      	subs	r0, r2, r4
c0de0ee2:	e7fa      	b.n	c0de0eda <memcmp+0x46>

c0de0ee4 <memcpy>:
c0de0ee4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0ee6:	46c6      	mov	lr, r8
c0de0ee8:	b500      	push	{lr}
c0de0eea:	2a0f      	cmp	r2, #15
c0de0eec:	d943      	bls.n	c0de0f76 <memcpy+0x92>
c0de0eee:	000b      	movs	r3, r1
c0de0ef0:	2603      	movs	r6, #3
c0de0ef2:	4303      	orrs	r3, r0
c0de0ef4:	401e      	ands	r6, r3
c0de0ef6:	000c      	movs	r4, r1
c0de0ef8:	0003      	movs	r3, r0
c0de0efa:	2e00      	cmp	r6, #0
c0de0efc:	d140      	bne.n	c0de0f80 <memcpy+0x9c>
c0de0efe:	0015      	movs	r5, r2
c0de0f00:	3d10      	subs	r5, #16
c0de0f02:	092d      	lsrs	r5, r5, #4
c0de0f04:	46ac      	mov	ip, r5
c0de0f06:	012d      	lsls	r5, r5, #4
c0de0f08:	46a8      	mov	r8, r5
c0de0f0a:	4480      	add	r8, r0
c0de0f0c:	e000      	b.n	c0de0f10 <memcpy+0x2c>
c0de0f0e:	003b      	movs	r3, r7
c0de0f10:	6867      	ldr	r7, [r4, #4]
c0de0f12:	6825      	ldr	r5, [r4, #0]
c0de0f14:	605f      	str	r7, [r3, #4]
c0de0f16:	68e7      	ldr	r7, [r4, #12]
c0de0f18:	601d      	str	r5, [r3, #0]
c0de0f1a:	60df      	str	r7, [r3, #12]
c0de0f1c:	001f      	movs	r7, r3
c0de0f1e:	68a5      	ldr	r5, [r4, #8]
c0de0f20:	3710      	adds	r7, #16
c0de0f22:	609d      	str	r5, [r3, #8]
c0de0f24:	3410      	adds	r4, #16
c0de0f26:	4543      	cmp	r3, r8
c0de0f28:	d1f1      	bne.n	c0de0f0e <memcpy+0x2a>
c0de0f2a:	4665      	mov	r5, ip
c0de0f2c:	230f      	movs	r3, #15
c0de0f2e:	240c      	movs	r4, #12
c0de0f30:	3501      	adds	r5, #1
c0de0f32:	012d      	lsls	r5, r5, #4
c0de0f34:	1949      	adds	r1, r1, r5
c0de0f36:	4013      	ands	r3, r2
c0de0f38:	1945      	adds	r5, r0, r5
c0de0f3a:	4214      	tst	r4, r2
c0de0f3c:	d023      	beq.n	c0de0f86 <memcpy+0xa2>
c0de0f3e:	598c      	ldr	r4, [r1, r6]
c0de0f40:	51ac      	str	r4, [r5, r6]
c0de0f42:	3604      	adds	r6, #4
c0de0f44:	1b9c      	subs	r4, r3, r6
c0de0f46:	2c03      	cmp	r4, #3
c0de0f48:	d8f9      	bhi.n	c0de0f3e <memcpy+0x5a>
c0de0f4a:	2403      	movs	r4, #3
c0de0f4c:	3b04      	subs	r3, #4
c0de0f4e:	089b      	lsrs	r3, r3, #2
c0de0f50:	3301      	adds	r3, #1
c0de0f52:	009b      	lsls	r3, r3, #2
c0de0f54:	4022      	ands	r2, r4
c0de0f56:	18ed      	adds	r5, r5, r3
c0de0f58:	18c9      	adds	r1, r1, r3
c0de0f5a:	1e56      	subs	r6, r2, #1
c0de0f5c:	2a00      	cmp	r2, #0
c0de0f5e:	d007      	beq.n	c0de0f70 <memcpy+0x8c>
c0de0f60:	2300      	movs	r3, #0
c0de0f62:	e000      	b.n	c0de0f66 <memcpy+0x82>
c0de0f64:	0023      	movs	r3, r4
c0de0f66:	5cca      	ldrb	r2, [r1, r3]
c0de0f68:	1c5c      	adds	r4, r3, #1
c0de0f6a:	54ea      	strb	r2, [r5, r3]
c0de0f6c:	429e      	cmp	r6, r3
c0de0f6e:	d1f9      	bne.n	c0de0f64 <memcpy+0x80>
c0de0f70:	bc04      	pop	{r2}
c0de0f72:	4690      	mov	r8, r2
c0de0f74:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0f76:	0005      	movs	r5, r0
c0de0f78:	1e56      	subs	r6, r2, #1
c0de0f7a:	2a00      	cmp	r2, #0
c0de0f7c:	d1f0      	bne.n	c0de0f60 <memcpy+0x7c>
c0de0f7e:	e7f7      	b.n	c0de0f70 <memcpy+0x8c>
c0de0f80:	1e56      	subs	r6, r2, #1
c0de0f82:	0005      	movs	r5, r0
c0de0f84:	e7ec      	b.n	c0de0f60 <memcpy+0x7c>
c0de0f86:	001a      	movs	r2, r3
c0de0f88:	e7f6      	b.n	c0de0f78 <memcpy+0x94>
c0de0f8a:	46c0      	nop			; (mov r8, r8)

c0de0f8c <memmove>:
c0de0f8c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0f8e:	46c6      	mov	lr, r8
c0de0f90:	b500      	push	{lr}
c0de0f92:	4288      	cmp	r0, r1
c0de0f94:	d90c      	bls.n	c0de0fb0 <memmove+0x24>
c0de0f96:	188b      	adds	r3, r1, r2
c0de0f98:	4298      	cmp	r0, r3
c0de0f9a:	d209      	bcs.n	c0de0fb0 <memmove+0x24>
c0de0f9c:	1e53      	subs	r3, r2, #1
c0de0f9e:	2a00      	cmp	r2, #0
c0de0fa0:	d003      	beq.n	c0de0faa <memmove+0x1e>
c0de0fa2:	5cca      	ldrb	r2, [r1, r3]
c0de0fa4:	54c2      	strb	r2, [r0, r3]
c0de0fa6:	3b01      	subs	r3, #1
c0de0fa8:	d2fb      	bcs.n	c0de0fa2 <memmove+0x16>
c0de0faa:	bc04      	pop	{r2}
c0de0fac:	4690      	mov	r8, r2
c0de0fae:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0fb0:	2a0f      	cmp	r2, #15
c0de0fb2:	d80c      	bhi.n	c0de0fce <memmove+0x42>
c0de0fb4:	0005      	movs	r5, r0
c0de0fb6:	1e56      	subs	r6, r2, #1
c0de0fb8:	2a00      	cmp	r2, #0
c0de0fba:	d0f6      	beq.n	c0de0faa <memmove+0x1e>
c0de0fbc:	2300      	movs	r3, #0
c0de0fbe:	e000      	b.n	c0de0fc2 <memmove+0x36>
c0de0fc0:	0023      	movs	r3, r4
c0de0fc2:	5cca      	ldrb	r2, [r1, r3]
c0de0fc4:	1c5c      	adds	r4, r3, #1
c0de0fc6:	54ea      	strb	r2, [r5, r3]
c0de0fc8:	429e      	cmp	r6, r3
c0de0fca:	d1f9      	bne.n	c0de0fc0 <memmove+0x34>
c0de0fcc:	e7ed      	b.n	c0de0faa <memmove+0x1e>
c0de0fce:	000b      	movs	r3, r1
c0de0fd0:	2603      	movs	r6, #3
c0de0fd2:	4303      	orrs	r3, r0
c0de0fd4:	401e      	ands	r6, r3
c0de0fd6:	000c      	movs	r4, r1
c0de0fd8:	0003      	movs	r3, r0
c0de0fda:	2e00      	cmp	r6, #0
c0de0fdc:	d12e      	bne.n	c0de103c <memmove+0xb0>
c0de0fde:	0015      	movs	r5, r2
c0de0fe0:	3d10      	subs	r5, #16
c0de0fe2:	092d      	lsrs	r5, r5, #4
c0de0fe4:	46ac      	mov	ip, r5
c0de0fe6:	012d      	lsls	r5, r5, #4
c0de0fe8:	46a8      	mov	r8, r5
c0de0fea:	4480      	add	r8, r0
c0de0fec:	e000      	b.n	c0de0ff0 <memmove+0x64>
c0de0fee:	002b      	movs	r3, r5
c0de0ff0:	001d      	movs	r5, r3
c0de0ff2:	6827      	ldr	r7, [r4, #0]
c0de0ff4:	3510      	adds	r5, #16
c0de0ff6:	601f      	str	r7, [r3, #0]
c0de0ff8:	6867      	ldr	r7, [r4, #4]
c0de0ffa:	605f      	str	r7, [r3, #4]
c0de0ffc:	68a7      	ldr	r7, [r4, #8]
c0de0ffe:	609f      	str	r7, [r3, #8]
c0de1000:	68e7      	ldr	r7, [r4, #12]
c0de1002:	3410      	adds	r4, #16
c0de1004:	60df      	str	r7, [r3, #12]
c0de1006:	4543      	cmp	r3, r8
c0de1008:	d1f1      	bne.n	c0de0fee <memmove+0x62>
c0de100a:	4665      	mov	r5, ip
c0de100c:	230f      	movs	r3, #15
c0de100e:	240c      	movs	r4, #12
c0de1010:	3501      	adds	r5, #1
c0de1012:	012d      	lsls	r5, r5, #4
c0de1014:	1949      	adds	r1, r1, r5
c0de1016:	4013      	ands	r3, r2
c0de1018:	1945      	adds	r5, r0, r5
c0de101a:	4214      	tst	r4, r2
c0de101c:	d011      	beq.n	c0de1042 <memmove+0xb6>
c0de101e:	598c      	ldr	r4, [r1, r6]
c0de1020:	51ac      	str	r4, [r5, r6]
c0de1022:	3604      	adds	r6, #4
c0de1024:	1b9c      	subs	r4, r3, r6
c0de1026:	2c03      	cmp	r4, #3
c0de1028:	d8f9      	bhi.n	c0de101e <memmove+0x92>
c0de102a:	2403      	movs	r4, #3
c0de102c:	3b04      	subs	r3, #4
c0de102e:	089b      	lsrs	r3, r3, #2
c0de1030:	3301      	adds	r3, #1
c0de1032:	009b      	lsls	r3, r3, #2
c0de1034:	18ed      	adds	r5, r5, r3
c0de1036:	18c9      	adds	r1, r1, r3
c0de1038:	4022      	ands	r2, r4
c0de103a:	e7bc      	b.n	c0de0fb6 <memmove+0x2a>
c0de103c:	1e56      	subs	r6, r2, #1
c0de103e:	0005      	movs	r5, r0
c0de1040:	e7bc      	b.n	c0de0fbc <memmove+0x30>
c0de1042:	001a      	movs	r2, r3
c0de1044:	e7b7      	b.n	c0de0fb6 <memmove+0x2a>
c0de1046:	46c0      	nop			; (mov r8, r8)

c0de1048 <memset>:
c0de1048:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de104a:	0005      	movs	r5, r0
c0de104c:	0783      	lsls	r3, r0, #30
c0de104e:	d04a      	beq.n	c0de10e6 <memset+0x9e>
c0de1050:	1e54      	subs	r4, r2, #1
c0de1052:	2a00      	cmp	r2, #0
c0de1054:	d044      	beq.n	c0de10e0 <memset+0x98>
c0de1056:	b2ce      	uxtb	r6, r1
c0de1058:	0003      	movs	r3, r0
c0de105a:	2203      	movs	r2, #3
c0de105c:	e002      	b.n	c0de1064 <memset+0x1c>
c0de105e:	3501      	adds	r5, #1
c0de1060:	3c01      	subs	r4, #1
c0de1062:	d33d      	bcc.n	c0de10e0 <memset+0x98>
c0de1064:	3301      	adds	r3, #1
c0de1066:	702e      	strb	r6, [r5, #0]
c0de1068:	4213      	tst	r3, r2
c0de106a:	d1f8      	bne.n	c0de105e <memset+0x16>
c0de106c:	2c03      	cmp	r4, #3
c0de106e:	d92f      	bls.n	c0de10d0 <memset+0x88>
c0de1070:	22ff      	movs	r2, #255	; 0xff
c0de1072:	400a      	ands	r2, r1
c0de1074:	0215      	lsls	r5, r2, #8
c0de1076:	4315      	orrs	r5, r2
c0de1078:	042a      	lsls	r2, r5, #16
c0de107a:	4315      	orrs	r5, r2
c0de107c:	2c0f      	cmp	r4, #15
c0de107e:	d935      	bls.n	c0de10ec <memset+0xa4>
c0de1080:	0027      	movs	r7, r4
c0de1082:	3f10      	subs	r7, #16
c0de1084:	093f      	lsrs	r7, r7, #4
c0de1086:	013e      	lsls	r6, r7, #4
c0de1088:	46b4      	mov	ip, r6
c0de108a:	001e      	movs	r6, r3
c0de108c:	001a      	movs	r2, r3
c0de108e:	3610      	adds	r6, #16
c0de1090:	4466      	add	r6, ip
c0de1092:	6015      	str	r5, [r2, #0]
c0de1094:	6055      	str	r5, [r2, #4]
c0de1096:	6095      	str	r5, [r2, #8]
c0de1098:	60d5      	str	r5, [r2, #12]
c0de109a:	3210      	adds	r2, #16
c0de109c:	42b2      	cmp	r2, r6
c0de109e:	d1f8      	bne.n	c0de1092 <memset+0x4a>
c0de10a0:	260f      	movs	r6, #15
c0de10a2:	220c      	movs	r2, #12
c0de10a4:	3701      	adds	r7, #1
c0de10a6:	013f      	lsls	r7, r7, #4
c0de10a8:	4026      	ands	r6, r4
c0de10aa:	19db      	adds	r3, r3, r7
c0de10ac:	0037      	movs	r7, r6
c0de10ae:	4222      	tst	r2, r4
c0de10b0:	d017      	beq.n	c0de10e2 <memset+0x9a>
c0de10b2:	1f3e      	subs	r6, r7, #4
c0de10b4:	08b6      	lsrs	r6, r6, #2
c0de10b6:	00b4      	lsls	r4, r6, #2
c0de10b8:	46a4      	mov	ip, r4
c0de10ba:	001a      	movs	r2, r3
c0de10bc:	1d1c      	adds	r4, r3, #4
c0de10be:	4464      	add	r4, ip
c0de10c0:	c220      	stmia	r2!, {r5}
c0de10c2:	42a2      	cmp	r2, r4
c0de10c4:	d1fc      	bne.n	c0de10c0 <memset+0x78>
c0de10c6:	2403      	movs	r4, #3
c0de10c8:	3601      	adds	r6, #1
c0de10ca:	00b6      	lsls	r6, r6, #2
c0de10cc:	199b      	adds	r3, r3, r6
c0de10ce:	403c      	ands	r4, r7
c0de10d0:	2c00      	cmp	r4, #0
c0de10d2:	d005      	beq.n	c0de10e0 <memset+0x98>
c0de10d4:	b2c9      	uxtb	r1, r1
c0de10d6:	191c      	adds	r4, r3, r4
c0de10d8:	7019      	strb	r1, [r3, #0]
c0de10da:	3301      	adds	r3, #1
c0de10dc:	429c      	cmp	r4, r3
c0de10de:	d1fb      	bne.n	c0de10d8 <memset+0x90>
c0de10e0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de10e2:	0034      	movs	r4, r6
c0de10e4:	e7f4      	b.n	c0de10d0 <memset+0x88>
c0de10e6:	0014      	movs	r4, r2
c0de10e8:	0003      	movs	r3, r0
c0de10ea:	e7bf      	b.n	c0de106c <memset+0x24>
c0de10ec:	0027      	movs	r7, r4
c0de10ee:	e7e0      	b.n	c0de10b2 <memset+0x6a>

c0de10f0 <setjmp>:
c0de10f0:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de10f2:	4641      	mov	r1, r8
c0de10f4:	464a      	mov	r2, r9
c0de10f6:	4653      	mov	r3, sl
c0de10f8:	465c      	mov	r4, fp
c0de10fa:	466d      	mov	r5, sp
c0de10fc:	4676      	mov	r6, lr
c0de10fe:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de1100:	3828      	subs	r0, #40	; 0x28
c0de1102:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de1104:	2000      	movs	r0, #0
c0de1106:	4770      	bx	lr

c0de1108 <longjmp>:
c0de1108:	3010      	adds	r0, #16
c0de110a:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de110c:	4690      	mov	r8, r2
c0de110e:	4699      	mov	r9, r3
c0de1110:	46a2      	mov	sl, r4
c0de1112:	46ab      	mov	fp, r5
c0de1114:	46b5      	mov	sp, r6
c0de1116:	c808      	ldmia	r0!, {r3}
c0de1118:	3828      	subs	r0, #40	; 0x28
c0de111a:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de111c:	1c08      	adds	r0, r1, #0
c0de111e:	d100      	bne.n	c0de1122 <longjmp+0x1a>
c0de1120:	2001      	movs	r0, #1
c0de1122:	4718      	bx	r3

c0de1124 <strlcpy>:
c0de1124:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1126:	2a00      	cmp	r2, #0
c0de1128:	d013      	beq.n	c0de1152 <strlcpy+0x2e>
c0de112a:	3a01      	subs	r2, #1
c0de112c:	2a00      	cmp	r2, #0
c0de112e:	d019      	beq.n	c0de1164 <strlcpy+0x40>
c0de1130:	2300      	movs	r3, #0
c0de1132:	1c4f      	adds	r7, r1, #1
c0de1134:	1c46      	adds	r6, r0, #1
c0de1136:	e002      	b.n	c0de113e <strlcpy+0x1a>
c0de1138:	3301      	adds	r3, #1
c0de113a:	429a      	cmp	r2, r3
c0de113c:	d016      	beq.n	c0de116c <strlcpy+0x48>
c0de113e:	18f5      	adds	r5, r6, r3
c0de1140:	46ac      	mov	ip, r5
c0de1142:	5ccd      	ldrb	r5, [r1, r3]
c0de1144:	18fc      	adds	r4, r7, r3
c0de1146:	54c5      	strb	r5, [r0, r3]
c0de1148:	2d00      	cmp	r5, #0
c0de114a:	d1f5      	bne.n	c0de1138 <strlcpy+0x14>
c0de114c:	1a60      	subs	r0, r4, r1
c0de114e:	3801      	subs	r0, #1
c0de1150:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1152:	000c      	movs	r4, r1
c0de1154:	0023      	movs	r3, r4
c0de1156:	3301      	adds	r3, #1
c0de1158:	1e5a      	subs	r2, r3, #1
c0de115a:	7812      	ldrb	r2, [r2, #0]
c0de115c:	001c      	movs	r4, r3
c0de115e:	2a00      	cmp	r2, #0
c0de1160:	d1f9      	bne.n	c0de1156 <strlcpy+0x32>
c0de1162:	e7f3      	b.n	c0de114c <strlcpy+0x28>
c0de1164:	000c      	movs	r4, r1
c0de1166:	2300      	movs	r3, #0
c0de1168:	7003      	strb	r3, [r0, #0]
c0de116a:	e7f3      	b.n	c0de1154 <strlcpy+0x30>
c0de116c:	4660      	mov	r0, ip
c0de116e:	e7fa      	b.n	c0de1166 <strlcpy+0x42>

c0de1170 <strnlen>:
c0de1170:	b510      	push	{r4, lr}
c0de1172:	2900      	cmp	r1, #0
c0de1174:	d00b      	beq.n	c0de118e <strnlen+0x1e>
c0de1176:	7803      	ldrb	r3, [r0, #0]
c0de1178:	2b00      	cmp	r3, #0
c0de117a:	d00c      	beq.n	c0de1196 <strnlen+0x26>
c0de117c:	1844      	adds	r4, r0, r1
c0de117e:	0003      	movs	r3, r0
c0de1180:	e002      	b.n	c0de1188 <strnlen+0x18>
c0de1182:	781a      	ldrb	r2, [r3, #0]
c0de1184:	2a00      	cmp	r2, #0
c0de1186:	d004      	beq.n	c0de1192 <strnlen+0x22>
c0de1188:	3301      	adds	r3, #1
c0de118a:	42a3      	cmp	r3, r4
c0de118c:	d1f9      	bne.n	c0de1182 <strnlen+0x12>
c0de118e:	0008      	movs	r0, r1
c0de1190:	bd10      	pop	{r4, pc}
c0de1192:	1a19      	subs	r1, r3, r0
c0de1194:	e7fb      	b.n	c0de118e <strnlen+0x1e>
c0de1196:	2100      	movs	r1, #0
c0de1198:	e7f9      	b.n	c0de118e <strnlen+0x1e>
c0de119a:	46c0      	nop			; (mov r8, r8)
c0de119c:	6c50      	ldr	r0, [r2, #68]	; 0x44
c0de119e:	6775      	str	r5, [r6, #116]	; 0x74
c0de11a0:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de11a2:	7020      	strb	r0, [r4, #0]
c0de11a4:	7261      	strb	r1, [r4, #9]
c0de11a6:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de11a8:	7465      	strb	r5, [r4, #17]
c0de11aa:	7265      	strb	r5, [r4, #9]
c0de11ac:	2073      	movs	r0, #115	; 0x73
c0de11ae:	7473      	strb	r3, [r6, #17]
c0de11b0:	7572      	strb	r2, [r6, #21]
c0de11b2:	7463      	strb	r3, [r4, #17]
c0de11b4:	7275      	strb	r5, [r6, #9]
c0de11b6:	2065      	movs	r0, #101	; 0x65
c0de11b8:	7369      	strb	r1, [r5, #13]
c0de11ba:	6220      	str	r0, [r4, #32]
c0de11bc:	6769      	str	r1, [r5, #116]	; 0x74
c0de11be:	6567      	str	r7, [r4, #84]	; 0x54
c0de11c0:	2072      	movs	r0, #114	; 0x72
c0de11c2:	6874      	ldr	r4, [r6, #4]
c0de11c4:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de11c6:	6120      	str	r0, [r4, #16]
c0de11c8:	6c6c      	ldr	r4, [r5, #68]	; 0x44
c0de11ca:	776f      	strb	r7, [r5, #29]
c0de11cc:	6465      	str	r5, [r4, #68]	; 0x44
c0de11ce:	7320      	strb	r0, [r4, #12]
c0de11d0:	7a69      	ldrb	r1, [r5, #9]
c0de11d2:	0a65      	lsrs	r5, r4, #9
c0de11d4:	6f00      	ldr	r0, [r0, #112]	; 0x70
c0de11d6:	6972      	ldr	r2, [r6, #20]
c0de11d8:	6967      	ldr	r7, [r4, #20]
c0de11da:	656e      	str	r6, [r5, #84]	; 0x54
c0de11dc:	6874      	ldr	r4, [r6, #4]
c0de11de:	7265      	strb	r5, [r4, #9]
c0de11e0:	5300      	strh	r0, [r0, r4]
c0de11e2:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de11e4:	0064      	lsls	r4, r4, #1
c0de11e6:	4157      	adcs	r7, r2
c0de11e8:	4e52      	ldr	r6, [pc, #328]	; (c0de1334 <strnlen+0x1c4>)
c0de11ea:	4e49      	ldr	r6, [pc, #292]	; (c0de1310 <strnlen+0x1a0>)
c0de11ec:	0047      	lsls	r7, r0, #1
c0de11ee:	656f      	str	r7, [r5, #84]	; 0x54
c0de11f0:	6874      	ldr	r4, [r6, #4]
c0de11f2:	7020      	strb	r0, [r4, #0]
c0de11f4:	756c      	strb	r4, [r5, #21]
c0de11f6:	6967      	ldr	r7, [r4, #20]
c0de11f8:	206e      	movs	r0, #110	; 0x6e
c0de11fa:	7270      	strb	r0, [r6, #9]
c0de11fc:	766f      	strb	r7, [r5, #25]
c0de11fe:	6469      	str	r1, [r5, #68]	; 0x44
c0de1200:	2065      	movs	r0, #101	; 0x65
c0de1202:	6170      	str	r0, [r6, #20]
c0de1204:	6172      	str	r2, [r6, #20]
c0de1206:	656d      	str	r5, [r5, #84]	; 0x54
c0de1208:	6574      	str	r4, [r6, #84]	; 0x54
c0de120a:	3a72      	subs	r2, #114	; 0x72
c0de120c:	0020      	movs	r0, r4
c0de120e:	0020      	movs	r0, r4
c0de1210:	6150      	str	r0, [r2, #20]
c0de1212:	6172      	str	r2, [r6, #20]
c0de1214:	206d      	movs	r0, #109	; 0x6d
c0de1216:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de1218:	2074      	movs	r0, #116	; 0x74
c0de121a:	7573      	strb	r3, [r6, #21]
c0de121c:	7070      	strb	r0, [r6, #1]
c0de121e:	726f      	strb	r7, [r5, #9]
c0de1220:	6574      	str	r4, [r6, #84]	; 0x54
c0de1222:	0a64      	lsrs	r4, r4, #9
c0de1224:	5400      	strb	r0, [r0, r0]
c0de1226:	4b4f      	ldr	r3, [pc, #316]	; (c0de1364 <strnlen+0x1f4>)
c0de1228:	4e45      	ldr	r6, [pc, #276]	; (c0de1340 <strnlen+0x1d0>)
c0de122a:	5320      	strh	r0, [r4, r4]
c0de122c:	4e45      	ldr	r6, [pc, #276]	; (c0de1344 <strnlen+0x1d4>)
c0de122e:	3a54      	subs	r2, #84	; 0x54
c0de1230:	0020      	movs	r0, r4
c0de1232:	454f      	cmp	r7, r9
c0de1234:	4854      	ldr	r0, [pc, #336]	; (c0de1388 <strnlen+0x218>)
c0de1236:	7020      	strb	r0, [r4, #0]
c0de1238:	756c      	strb	r4, [r5, #21]
c0de123a:	6967      	ldr	r7, [r4, #20]
c0de123c:	206e      	movs	r0, #110	; 0x6e
c0de123e:	7270      	strb	r0, [r6, #9]
c0de1240:	766f      	strb	r7, [r5, #25]
c0de1242:	6469      	str	r1, [r5, #68]	; 0x44
c0de1244:	2065      	movs	r0, #101	; 0x65
c0de1246:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de1248:	656b      	str	r3, [r5, #84]	; 0x54
c0de124a:	3a6e      	subs	r2, #110	; 0x6e
c0de124c:	3020      	adds	r0, #32
c0de124e:	2578      	movs	r5, #120	; 0x78
c0de1250:	2c70      	cmp	r4, #112	; 0x70
c0de1252:	3020      	adds	r0, #32
c0de1254:	2578      	movs	r5, #120	; 0x78
c0de1256:	0a70      	lsrs	r0, r6, #9
c0de1258:	4d00      	ldr	r5, [pc, #0]	; (c0de125c <strnlen+0xec>)
c0de125a:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de125c:	0074      	lsls	r4, r6, #1
c0de125e:	3025      	adds	r0, #37	; 0x25
c0de1260:	7832      	ldrb	r2, [r6, #0]
c0de1262:	5300      	strh	r0, [r0, r4]
c0de1264:	6177      	str	r7, [r6, #20]
c0de1266:	0070      	lsls	r0, r6, #1
c0de1268:	4f54      	ldr	r7, [pc, #336]	; (c0de13bc <strnlen+0x24c>)
c0de126a:	454b      	cmp	r3, r9
c0de126c:	204e      	movs	r0, #78	; 0x4e
c0de126e:	4552      	cmp	r2, sl
c0de1270:	4543      	cmp	r3, r8
c0de1272:	5649      	ldrsb	r1, [r1, r1]
c0de1274:	4445      	add	r5, r8
c0de1276:	203a      	movs	r0, #58	; 0x3a
c0de1278:	5200      	strh	r0, [r0, r0]
c0de127a:	6465      	str	r5, [r4, #68]	; 0x44
c0de127c:	6565      	str	r5, [r4, #84]	; 0x54
c0de127e:	006d      	lsls	r5, r5, #1
c0de1280:	7445      	strb	r5, [r0, #17]
c0de1282:	6568      	str	r0, [r5, #84]	; 0x54
c0de1284:	6572      	str	r2, [r6, #84]	; 0x54
c0de1286:	6d75      	ldr	r5, [r6, #84]	; 0x54
c0de1288:	3000      	adds	r0, #0
c0de128a:	5300      	strh	r0, [r0, r4]
c0de128c:	7465      	strb	r5, [r4, #17]
c0de128e:	6974      	ldr	r4, [r6, #20]
c0de1290:	676e      	str	r6, [r5, #116]	; 0x74
c0de1292:	6120      	str	r0, [r4, #16]
c0de1294:	6464      	str	r4, [r4, #68]	; 0x44
c0de1296:	6572      	str	r2, [r6, #84]	; 0x54
c0de1298:	7373      	strb	r3, [r6, #13]
c0de129a:	7220      	strb	r0, [r4, #8]
c0de129c:	6365      	str	r5, [r4, #52]	; 0x34
c0de129e:	6965      	ldr	r5, [r4, #20]
c0de12a0:	6576      	str	r6, [r6, #84]	; 0x54
c0de12a2:	2064      	movs	r0, #100	; 0x64
c0de12a4:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de12a6:	203a      	movs	r0, #58	; 0x3a
c0de12a8:	5000      	str	r0, [r0, r0]
c0de12aa:	7261      	strb	r1, [r4, #9]
c0de12ac:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de12ae:	6e20      	ldr	r0, [r4, #96]	; 0x60
c0de12b0:	746f      	strb	r7, [r5, #17]
c0de12b2:	7320      	strb	r0, [r4, #12]
c0de12b4:	7075      	strb	r5, [r6, #1]
c0de12b6:	6f70      	ldr	r0, [r6, #116]	; 0x74
c0de12b8:	7472      	strb	r2, [r6, #17]
c0de12ba:	6465      	str	r5, [r4, #68]	; 0x44
c0de12bc:	203a      	movs	r0, #58	; 0x3a
c0de12be:	6425      	str	r5, [r4, #64]	; 0x40
c0de12c0:	000a      	movs	r2, r1
c0de12c2:	6552      	str	r2, [r2, #84]	; 0x54
c0de12c4:	6563      	str	r3, [r4, #84]	; 0x54
c0de12c6:	7669      	strb	r1, [r5, #25]
c0de12c8:	2065      	movs	r0, #101	; 0x65
c0de12ca:	694d      	ldr	r5, [r1, #20]
c0de12cc:	006e      	lsls	r6, r5, #1
c0de12ce:	7845      	ldrb	r5, [r0, #1]
c0de12d0:	6563      	str	r3, [r4, #84]	; 0x54
c0de12d2:	7470      	strb	r0, [r6, #17]
c0de12d4:	6f69      	ldr	r1, [r5, #116]	; 0x74
c0de12d6:	206e      	movs	r0, #110	; 0x6e
c0de12d8:	7830      	ldrb	r0, [r6, #0]
c0de12da:	7825      	ldrb	r5, [r4, #0]
c0de12dc:	6320      	str	r0, [r4, #48]	; 0x30
c0de12de:	7561      	strb	r1, [r4, #21]
c0de12e0:	6867      	ldr	r7, [r4, #4]
c0de12e2:	0a74      	lsrs	r4, r6, #9
c0de12e4:	5500      	strb	r0, [r0, r4]
c0de12e6:	6b6e      	ldr	r6, [r5, #52]	; 0x34
c0de12e8:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de12ea:	6e77      	ldr	r7, [r6, #100]	; 0x64
c0de12ec:	7420      	strb	r0, [r4, #16]
c0de12ee:	6b6f      	ldr	r7, [r5, #52]	; 0x34
c0de12f0:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de12f2:	6500      	str	r0, [r0, #80]	; 0x50
c0de12f4:	6378      	str	r0, [r7, #52]	; 0x34
c0de12f6:	7065      	strb	r5, [r4, #1]
c0de12f8:	6974      	ldr	r4, [r6, #20]
c0de12fa:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de12fc:	255b      	movs	r5, #91	; 0x5b
c0de12fe:	5d64      	ldrb	r4, [r4, r5]
c0de1300:	203a      	movs	r0, #58	; 0x3a
c0de1302:	524c      	strh	r4, [r1, r1]
c0de1304:	303d      	adds	r0, #61	; 0x3d
c0de1306:	2578      	movs	r5, #120	; 0x78
c0de1308:	3830      	subs	r0, #48	; 0x30
c0de130a:	0a58      	lsrs	r0, r3, #9
c0de130c:	4500      	cmp	r0, r0
c0de130e:	5252      	strh	r2, [r2, r1]
c0de1310:	524f      	strh	r7, [r1, r1]
c0de1312:	5500      	strb	r0, [r0, r4]
c0de1314:	686e      	ldr	r6, [r5, #4]
c0de1316:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de1318:	6c64      	ldr	r4, [r4, #68]	; 0x44
c0de131a:	6465      	str	r5, [r4, #68]	; 0x44
c0de131c:	6d20      	ldr	r0, [r4, #80]	; 0x50
c0de131e:	7365      	strb	r5, [r4, #13]
c0de1320:	6173      	str	r3, [r6, #20]
c0de1322:	6567      	str	r7, [r4, #84]	; 0x54
c0de1324:	2520      	movs	r5, #32
c0de1326:	0a64      	lsrs	r4, r4, #9
c0de1328:	5300      	strh	r0, [r0, r4]
c0de132a:	7465      	strb	r5, [r4, #17]
c0de132c:	6974      	ldr	r4, [r6, #20]
c0de132e:	676e      	str	r6, [r5, #116]	; 0x74
c0de1330:	6120      	str	r0, [r4, #16]
c0de1332:	6464      	str	r4, [r4, #68]	; 0x44
c0de1334:	6572      	str	r2, [r6, #84]	; 0x54
c0de1336:	7373      	strb	r3, [r6, #13]
c0de1338:	7320      	strb	r0, [r4, #12]
c0de133a:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de133c:	2074      	movs	r0, #116	; 0x74
c0de133e:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de1340:	203a      	movs	r0, #58	; 0x3a
c0de1342:	0a00      	lsrs	r0, r0, #8
c0de1344:	5200      	strh	r0, [r0, r0]
c0de1346:	6365      	str	r5, [r4, #52]	; 0x34
c0de1348:	6965      	ldr	r5, [r4, #20]
c0de134a:	6576      	str	r6, [r6, #84]	; 0x54
c0de134c:	2064      	movs	r0, #100	; 0x64
c0de134e:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de1350:	6920      	ldr	r0, [r4, #16]
c0de1352:	766e      	strb	r6, [r5, #25]
c0de1354:	6c61      	ldr	r1, [r4, #68]	; 0x44
c0de1356:	6469      	str	r1, [r5, #68]	; 0x44
c0de1358:	7320      	strb	r0, [r4, #12]
c0de135a:	7263      	strb	r3, [r4, #9]
c0de135c:	6565      	str	r5, [r4, #84]	; 0x54
c0de135e:	496e      	ldr	r1, [pc, #440]	; (c0de1518 <_envram_data+0x18>)
c0de1360:	646e      	str	r6, [r5, #68]	; 0x44
c0de1362:	7865      	ldrb	r5, [r4, #1]
c0de1364:	000a      	movs	r2, r1
c0de1366:	4d41      	ldr	r5, [pc, #260]	; (c0de146c <_etext+0xc>)
c0de1368:	554f      	strb	r7, [r1, r5]
c0de136a:	544e      	strb	r6, [r1, r1]
c0de136c:	5320      	strh	r0, [r4, r4]
c0de136e:	4e45      	ldr	r6, [pc, #276]	; (c0de1484 <_etext+0x24>)
c0de1370:	3a54      	subs	r2, #84	; 0x54
c0de1372:	2520      	movs	r5, #32
c0de1374:	0a73      	lsrs	r3, r6, #9
c0de1376:	0000      	movs	r0, r0
c0de1378:	6553      	str	r3, [r2, #84]	; 0x54
c0de137a:	656c      	str	r4, [r5, #84]	; 0x54
c0de137c:	7463      	strb	r3, [r4, #17]
c0de137e:	726f      	strb	r7, [r5, #9]
c0de1380:	4920      	ldr	r1, [pc, #128]	; (c0de1404 <strnlen+0x294>)
c0de1382:	646e      	str	r6, [r5, #68]	; 0x44
c0de1384:	7865      	ldrb	r5, [r4, #1]
c0de1386:	3a20      	subs	r2, #32
c0de1388:	6425      	str	r5, [r4, #64]	; 0x40
c0de138a:	6e20      	ldr	r0, [r4, #96]	; 0x60
c0de138c:	746f      	strb	r7, [r5, #17]
c0de138e:	7320      	strb	r0, [r4, #12]
c0de1390:	7075      	strb	r5, [r6, #1]
c0de1392:	6f70      	ldr	r0, [r6, #116]	; 0x74
c0de1394:	7472      	strb	r2, [r6, #17]
c0de1396:	6465      	str	r5, [r4, #68]	; 0x44
c0de1398:	000a      	movs	r2, r1
c0de139a:	6e55      	ldr	r5, [r2, #100]	; 0x64
c0de139c:	6168      	str	r0, [r5, #20]
c0de139e:	646e      	str	r6, [r5, #68]	; 0x44
c0de13a0:	656c      	str	r4, [r5, #84]	; 0x54
c0de13a2:	2064      	movs	r0, #100	; 0x64
c0de13a4:	6573      	str	r3, [r6, #84]	; 0x54
c0de13a6:	656c      	str	r4, [r5, #84]	; 0x54
c0de13a8:	7463      	strb	r3, [r4, #17]
c0de13aa:	726f      	strb	r7, [r5, #9]
c0de13ac:	4920      	ldr	r1, [pc, #128]	; (c0de1430 <g_pcHex+0x4>)
c0de13ae:	646e      	str	r6, [r5, #68]	; 0x44
c0de13b0:	7865      	ldrb	r5, [r4, #1]
c0de13b2:	203a      	movs	r0, #58	; 0x3a
c0de13b4:	6425      	str	r5, [r4, #64]	; 0x40
c0de13b6:	000a      	movs	r2, r1
c0de13b8:	6544      	str	r4, [r0, #84]	; 0x54
c0de13ba:	6f70      	ldr	r0, [r6, #116]	; 0x74
c0de13bc:	6973      	ldr	r3, [r6, #20]
c0de13be:	0074      	lsls	r4, r6, #1
c0de13c0:	694d      	ldr	r5, [r1, #20]
c0de13c2:	7373      	strb	r3, [r6, #13]
c0de13c4:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de13c6:	2067      	movs	r0, #103	; 0x67
c0de13c8:	6573      	str	r3, [r6, #84]	; 0x54
c0de13ca:	656c      	str	r4, [r5, #84]	; 0x54
c0de13cc:	7463      	strb	r3, [r4, #17]
c0de13ce:	726f      	strb	r7, [r5, #9]
c0de13d0:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de13d2:	6564      	str	r4, [r4, #84]	; 0x54
c0de13d4:	3a78      	subs	r2, #120	; 0x78
c0de13d6:	2520      	movs	r5, #32
c0de13d8:	0a64      	lsrs	r4, r4, #9
c0de13da:	5300      	strh	r0, [r0, r4]
c0de13dc:	6c65      	ldr	r5, [r4, #68]	; 0x44
c0de13de:	6365      	str	r5, [r4, #52]	; 0x34
c0de13e0:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de13e2:	2072      	movs	r0, #114	; 0x72
c0de13e4:	6e49      	ldr	r1, [r1, #100]	; 0x64
c0de13e6:	6564      	str	r4, [r4, #84]	; 0x54
c0de13e8:	2078      	movs	r0, #120	; 0x78
c0de13ea:	6425      	str	r5, [r4, #64]	; 0x40
c0de13ec:	6e20      	ldr	r0, [r4, #96]	; 0x60
c0de13ee:	746f      	strb	r7, [r5, #17]
c0de13f0:	7320      	strb	r0, [r4, #12]
c0de13f2:	7075      	strb	r5, [r6, #1]
c0de13f4:	6f70      	ldr	r0, [r6, #116]	; 0x74
c0de13f6:	7472      	strb	r2, [r6, #17]
c0de13f8:	6465      	str	r5, [r4, #68]	; 0x44
c0de13fa:	000a      	movs	r2, r1
c0de13fc:	4d41      	ldr	r5, [pc, #260]	; (c0de1504 <_envram_data+0x4>)
c0de13fe:	554f      	strb	r7, [r1, r5]
c0de1400:	544e      	strb	r6, [r1, r1]
c0de1402:	5220      	strh	r0, [r4, r0]
c0de1404:	4345      	muls	r5, r0
c0de1406:	4945      	ldr	r1, [pc, #276]	; (c0de151c <_envram_data+0x1c>)
c0de1408:	4556      	cmp	r6, sl
c0de140a:	3a44      	subs	r2, #68	; 0x44
c0de140c:	2520      	movs	r5, #32
c0de140e:	0a73      	lsrs	r3, r6, #9
c0de1410:	d400      	bmi.n	c0de1414 <ORIGIN_ETHER_SELECTORS>
c0de1412:	d4d4      	bmi.n	c0de13be <strnlen+0x24e>

c0de1414 <ORIGIN_ETHER_SELECTORS>:
c0de1414:	0db0 d0e3 e97d d443 29f6 156e 2373 7cbc     ....}.C..)n.s#.|
c0de1424:	2124 3df0 0000 0000                         $!.=....

c0de142c <g_pcHex>:
c0de142c:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de143c <g_pcHex_cap>:
c0de143c:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de144c <NULL_ETH_ADDRESS>:
	...

c0de1460 <_etext>:
c0de1460:	d4d4      	bmi.n	c0de140c <strnlen+0x29c>
c0de1462:	d4d4      	bmi.n	c0de140e <strnlen+0x29e>
c0de1464:	d4d4      	bmi.n	c0de1410 <strnlen+0x2a0>
c0de1466:	d4d4      	bmi.n	c0de1412 <strnlen+0x2a2>
c0de1468:	d4d4      	bmi.n	c0de1414 <ORIGIN_ETHER_SELECTORS>
c0de146a:	d4d4      	bmi.n	c0de1416 <ORIGIN_ETHER_SELECTORS+0x2>
c0de146c:	d4d4      	bmi.n	c0de1418 <ORIGIN_ETHER_SELECTORS+0x4>
c0de146e:	d4d4      	bmi.n	c0de141a <ORIGIN_ETHER_SELECTORS+0x6>
c0de1470:	d4d4      	bmi.n	c0de141c <ORIGIN_ETHER_SELECTORS+0x8>
c0de1472:	d4d4      	bmi.n	c0de141e <ORIGIN_ETHER_SELECTORS+0xa>
c0de1474:	d4d4      	bmi.n	c0de1420 <ORIGIN_ETHER_SELECTORS+0xc>
c0de1476:	d4d4      	bmi.n	c0de1422 <ORIGIN_ETHER_SELECTORS+0xe>
c0de1478:	d4d4      	bmi.n	c0de1424 <ORIGIN_ETHER_SELECTORS+0x10>
c0de147a:	d4d4      	bmi.n	c0de1426 <ORIGIN_ETHER_SELECTORS+0x12>
c0de147c:	d4d4      	bmi.n	c0de1428 <ORIGIN_ETHER_SELECTORS+0x14>
c0de147e:	d4d4      	bmi.n	c0de142a <ORIGIN_ETHER_SELECTORS+0x16>
c0de1480:	d4d4      	bmi.n	c0de142c <g_pcHex>
c0de1482:	d4d4      	bmi.n	c0de142e <g_pcHex+0x2>
c0de1484:	d4d4      	bmi.n	c0de1430 <g_pcHex+0x4>
c0de1486:	d4d4      	bmi.n	c0de1432 <g_pcHex+0x6>
c0de1488:	d4d4      	bmi.n	c0de1434 <g_pcHex+0x8>
c0de148a:	d4d4      	bmi.n	c0de1436 <g_pcHex+0xa>
c0de148c:	d4d4      	bmi.n	c0de1438 <g_pcHex+0xc>
c0de148e:	d4d4      	bmi.n	c0de143a <g_pcHex+0xe>
c0de1490:	d4d4      	bmi.n	c0de143c <g_pcHex_cap>
c0de1492:	d4d4      	bmi.n	c0de143e <g_pcHex_cap+0x2>
c0de1494:	d4d4      	bmi.n	c0de1440 <g_pcHex_cap+0x4>
c0de1496:	d4d4      	bmi.n	c0de1442 <g_pcHex_cap+0x6>
c0de1498:	d4d4      	bmi.n	c0de1444 <g_pcHex_cap+0x8>
c0de149a:	d4d4      	bmi.n	c0de1446 <g_pcHex_cap+0xa>
c0de149c:	d4d4      	bmi.n	c0de1448 <g_pcHex_cap+0xc>
c0de149e:	d4d4      	bmi.n	c0de144a <g_pcHex_cap+0xe>
c0de14a0:	d4d4      	bmi.n	c0de144c <NULL_ETH_ADDRESS>
c0de14a2:	d4d4      	bmi.n	c0de144e <NULL_ETH_ADDRESS+0x2>
c0de14a4:	d4d4      	bmi.n	c0de1450 <NULL_ETH_ADDRESS+0x4>
c0de14a6:	d4d4      	bmi.n	c0de1452 <NULL_ETH_ADDRESS+0x6>
c0de14a8:	d4d4      	bmi.n	c0de1454 <NULL_ETH_ADDRESS+0x8>
c0de14aa:	d4d4      	bmi.n	c0de1456 <NULL_ETH_ADDRESS+0xa>
c0de14ac:	d4d4      	bmi.n	c0de1458 <NULL_ETH_ADDRESS+0xc>
c0de14ae:	d4d4      	bmi.n	c0de145a <NULL_ETH_ADDRESS+0xe>
c0de14b0:	d4d4      	bmi.n	c0de145c <NULL_ETH_ADDRESS+0x10>
c0de14b2:	d4d4      	bmi.n	c0de145e <NULL_ETH_ADDRESS+0x12>
c0de14b4:	d4d4      	bmi.n	c0de1460 <_etext>
c0de14b6:	d4d4      	bmi.n	c0de1462 <_etext+0x2>
c0de14b8:	d4d4      	bmi.n	c0de1464 <_etext+0x4>
c0de14ba:	d4d4      	bmi.n	c0de1466 <_etext+0x6>
c0de14bc:	d4d4      	bmi.n	c0de1468 <_etext+0x8>
c0de14be:	d4d4      	bmi.n	c0de146a <_etext+0xa>
c0de14c0:	d4d4      	bmi.n	c0de146c <_etext+0xc>
c0de14c2:	d4d4      	bmi.n	c0de146e <_etext+0xe>
c0de14c4:	d4d4      	bmi.n	c0de1470 <_etext+0x10>
c0de14c6:	d4d4      	bmi.n	c0de1472 <_etext+0x12>
c0de14c8:	d4d4      	bmi.n	c0de1474 <_etext+0x14>
c0de14ca:	d4d4      	bmi.n	c0de1476 <_etext+0x16>
c0de14cc:	d4d4      	bmi.n	c0de1478 <_etext+0x18>
c0de14ce:	d4d4      	bmi.n	c0de147a <_etext+0x1a>
c0de14d0:	d4d4      	bmi.n	c0de147c <_etext+0x1c>
c0de14d2:	d4d4      	bmi.n	c0de147e <_etext+0x1e>
c0de14d4:	d4d4      	bmi.n	c0de1480 <_etext+0x20>
c0de14d6:	d4d4      	bmi.n	c0de1482 <_etext+0x22>
c0de14d8:	d4d4      	bmi.n	c0de1484 <_etext+0x24>
c0de14da:	d4d4      	bmi.n	c0de1486 <_etext+0x26>
c0de14dc:	d4d4      	bmi.n	c0de1488 <_etext+0x28>
c0de14de:	d4d4      	bmi.n	c0de148a <_etext+0x2a>
c0de14e0:	d4d4      	bmi.n	c0de148c <_etext+0x2c>
c0de14e2:	d4d4      	bmi.n	c0de148e <_etext+0x2e>
c0de14e4:	d4d4      	bmi.n	c0de1490 <_etext+0x30>
c0de14e6:	d4d4      	bmi.n	c0de1492 <_etext+0x32>
c0de14e8:	d4d4      	bmi.n	c0de1494 <_etext+0x34>
c0de14ea:	d4d4      	bmi.n	c0de1496 <_etext+0x36>
c0de14ec:	d4d4      	bmi.n	c0de1498 <_etext+0x38>
c0de14ee:	d4d4      	bmi.n	c0de149a <_etext+0x3a>
c0de14f0:	d4d4      	bmi.n	c0de149c <_etext+0x3c>
c0de14f2:	d4d4      	bmi.n	c0de149e <_etext+0x3e>
c0de14f4:	d4d4      	bmi.n	c0de14a0 <_etext+0x40>
c0de14f6:	d4d4      	bmi.n	c0de14a2 <_etext+0x42>
c0de14f8:	d4d4      	bmi.n	c0de14a4 <_etext+0x44>
c0de14fa:	d4d4      	bmi.n	c0de14a6 <_etext+0x46>
c0de14fc:	d4d4      	bmi.n	c0de14a8 <_etext+0x48>
c0de14fe:	d4d4      	bmi.n	c0de14aa <_etext+0x4a>
