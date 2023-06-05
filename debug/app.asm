
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
c0de0008:	f001 fa5c 	bl	c0de14c4 <os_boot>
c0de000c:	466d      	mov	r5, sp

    // Try catch block. Please read the docs for more information on how to use those!
    BEGIN_TRY {
        TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f001 ff62 	bl	c0de1ed8 <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10d      	bne.n	c0de003a <main+0x3a>
c0de001e:	f001 fc39 	bl	c0de1894 <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
  if (apiLevel < get_api_level()) {
c0de0024:	f001 fbfb 	bl	c0de181e <get_api_level>
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
c0de0030:	f001 fa3a 	bl	c0de14a8 <call_app_ethereum>
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
c0de0040:	f001 fc28 	bl	c0de1894 <try_context_set>
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
c0de0064:	f001 fa54 	bl	c0de1510 <mcu_usb_printf>
c0de0068:	e00b      	b.n	c0de0082 <main+0x82>
c0de006a:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de006c:	f001 fbf4 	bl	c0de1858 <os_sched_exit>
                if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de0070:	6820      	ldr	r0, [r4, #0]
c0de0072:	2183      	movs	r1, #131	; 0x83
c0de0074:	0049      	lsls	r1, r1, #1
c0de0076:	31f9      	adds	r1, #249	; 0xf9
c0de0078:	4288      	cmp	r0, r1
c0de007a:	d002      	beq.n	c0de0082 <main+0x82>
                    dispatch_plugin_calls(args[0], (void *) args[1]);
c0de007c:	6861      	ldr	r1, [r4, #4]
c0de007e:	f001 f9d9 	bl	c0de1434 <dispatch_plugin_calls>
        FINALLY {
c0de0082:	f001 fbff 	bl	c0de1884 <try_context_get>
c0de0086:	4669      	mov	r1, sp
c0de0088:	4288      	cmp	r0, r1
c0de008a:	d102      	bne.n	c0de0092 <main+0x92>
c0de008c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de008e:	f001 fc01 	bl	c0de1894 <try_context_set>
            os_lib_end();
c0de0092:	f001 fbd9 	bl	c0de1848 <os_lib_end>
c0de0096:	46c0      	nop			; (mov r8, r8)
c0de0098:	00006502 	.word	0x00006502
c0de009c:	0000216d 	.word	0x0000216d

c0de00a0 <cx_hash_get_size>:
CX_TRAMPOLINE _NR_cx_edwards_compress_point_no_throw       cx_edwards_compress_point_no_throw
CX_TRAMPOLINE _NR_cx_edwards_decompress_point_no_throw     cx_edwards_decompress_point_no_throw
CX_TRAMPOLINE _NR_cx_encode_coord                          cx_encode_coord
CX_TRAMPOLINE _NR_cx_hash_final                            cx_hash_final
CX_TRAMPOLINE _NR_cx_hash_get_info                         cx_hash_get_info
CX_TRAMPOLINE _NR_cx_hash_get_size                         cx_hash_get_size
c0de00a0:	b403      	push	{r0, r1}
c0de00a2:	4801      	ldr	r0, [pc, #4]	; (c0de00a8 <cx_hash_get_size+0x8>)
c0de00a4:	e011      	b.n	c0de00ca <cx_trampoline_helper>
c0de00a6:	0000      	.short	0x0000
c0de00a8:	00000044 	.word	0x00000044

c0de00ac <cx_hash_no_throw>:
CX_TRAMPOLINE _NR_cx_hash_init                             cx_hash_init
CX_TRAMPOLINE _NR_cx_hash_init_ex                          cx_hash_init_ex
CX_TRAMPOLINE _NR_cx_hash_no_throw                         cx_hash_no_throw
c0de00ac:	b403      	push	{r0, r1}
c0de00ae:	4801      	ldr	r0, [pc, #4]	; (c0de00b4 <cx_hash_no_throw+0x8>)
c0de00b0:	e00b      	b.n	c0de00ca <cx_trampoline_helper>
c0de00b2:	0000      	.short	0x0000
c0de00b4:	00000047 	.word	0x00000047

c0de00b8 <cx_keccak_init_no_throw>:
CX_TRAMPOLINE _NR_cx_hmac_sha256_init_no_throw             cx_hmac_sha256_init_no_throw
CX_TRAMPOLINE _NR_cx_hmac_sha384_init                      cx_hmac_sha384_init
CX_TRAMPOLINE _NR_cx_hmac_sha512                           cx_hmac_sha512
CX_TRAMPOLINE _NR_cx_hmac_sha512_init_no_throw             cx_hmac_sha512_init_no_throw
CX_TRAMPOLINE _NR_cx_hmac_update                           cx_hmac_update
CX_TRAMPOLINE _NR_cx_keccak_init_no_throw                  cx_keccak_init_no_throw
c0de00b8:	b403      	push	{r0, r1}
c0de00ba:	4801      	ldr	r0, [pc, #4]	; (c0de00c0 <cx_keccak_init_no_throw+0x8>)
c0de00bc:	e005      	b.n	c0de00ca <cx_trampoline_helper>
c0de00be:	0000      	.short	0x0000
c0de00c0:	00000059 	.word	0x00000059

c0de00c4 <cx_x448>:
CX_TRAMPOLINE _NR_cx_swap_buffer32                         cx_swap_buffer32
CX_TRAMPOLINE _NR_cx_swap_buffer64                         cx_swap_buffer64
CX_TRAMPOLINE _NR_cx_swap_uint32                           cx_swap_uint32
CX_TRAMPOLINE _NR_cx_swap_uint64                           cx_swap_uint64
CX_TRAMPOLINE _NR_cx_x25519                                cx_x25519
CX_TRAMPOLINE _NR_cx_x448                                  cx_x448
c0de00c4:	b403      	push	{r0, r1}
c0de00c6:	4802      	ldr	r0, [pc, #8]	; (c0de00d0 <cx_trampoline_helper+0x6>)
c0de00c8:	e7ff      	b.n	c0de00ca <cx_trampoline_helper>

c0de00ca <cx_trampoline_helper>:

.thumb_func
cx_trampoline_helper:
  ldr  r1, =CX_TRAMPOLINE_ADDR // _cx_trampoline address
c0de00ca:	4902      	ldr	r1, [pc, #8]	; (c0de00d4 <cx_trampoline_helper+0xa>)
  bx   r1
c0de00cc:	4708      	bx	r1
c0de00ce:	0000      	.short	0x0000
CX_TRAMPOLINE _NR_cx_x448                                  cx_x448
c0de00d0:	00000086 	.word	0x00000086
  ldr  r1, =CX_TRAMPOLINE_ADDR // _cx_trampoline address
c0de00d4:	00210001 	.word	0x00210001

c0de00d8 <getEthAddressStringFromBinary>:
#include "eth_internals.h"

void getEthAddressStringFromBinary(uint8_t *address,
                                   char *out,
                                   cx_sha3_t *sha3Context,
                                   uint64_t chainId) {
c0de00d8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de00da:	b091      	sub	sp, #68	; 0x44
c0de00dc:	9202      	str	r2, [sp, #8]
c0de00de:	9103      	str	r1, [sp, #12]
c0de00e0:	4605      	mov	r5, r0
c0de00e2:	2601      	movs	r6, #1
c0de00e4:	9816      	ldr	r0, [sp, #88]	; 0x58
    } locals_union;

    uint8_t i;
    bool eip1191 = false;
    uint32_t offset = 0;
    switch (chainId) {
c0de00e6:	4601      	mov	r1, r0
c0de00e8:	43b1      	bics	r1, r6
c0de00ea:	221e      	movs	r2, #30
c0de00ec:	404a      	eors	r2, r1
c0de00ee:	9917      	ldr	r1, [sp, #92]	; 0x5c
c0de00f0:	430a      	orrs	r2, r1
c0de00f2:	2400      	movs	r4, #0
        case 30:
        case 31:
            eip1191 = true;
            break;
    }
    if (eip1191) {
c0de00f4:	2a00      	cmp	r2, #0
c0de00f6:	4622      	mov	r2, r4
c0de00f8:	d116      	bne.n	c0de0128 <getEthAddressStringFromBinary+0x50>
c0de00fa:	aa04      	add	r2, sp, #16
c0de00fc:	9201      	str	r2, [sp, #4]
c0de00fe:	2733      	movs	r7, #51	; 0x33
        u64_to_string(chainId, (char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de0100:	463b      	mov	r3, r7
c0de0102:	f000 f857 	bl	c0de01b4 <u64_to_string>
        offset = strnlen((char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de0106:	9801      	ldr	r0, [sp, #4]
c0de0108:	4639      	mov	r1, r7
c0de010a:	f001 ff8d 	bl	c0de2028 <strnlen>
        strlcat((char *) locals_union.tmp + offset, "0x", sizeof(locals_union.tmp) - offset);
c0de010e:	9901      	ldr	r1, [sp, #4]
c0de0110:	180b      	adds	r3, r1, r0
c0de0112:	1a3a      	subs	r2, r7, r0
c0de0114:	4925      	ldr	r1, [pc, #148]	; (c0de01ac <getEthAddressStringFromBinary+0xd4>)
c0de0116:	4479      	add	r1, pc
c0de0118:	4618      	mov	r0, r3
c0de011a:	f001 fef7 	bl	c0de1f0c <strlcat>
        offset = strnlen((char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de011e:	9801      	ldr	r0, [sp, #4]
c0de0120:	4639      	mov	r1, r7
c0de0122:	f001 ff81 	bl	c0de2028 <strnlen>
c0de0126:	4602      	mov	r2, r0
c0de0128:	a804      	add	r0, sp, #16
c0de012a:	9201      	str	r2, [sp, #4]
    }
    for (i = 0; i < 20; i++) {
c0de012c:	1880      	adds	r0, r0, r2
c0de012e:	4f20      	ldr	r7, [pc, #128]	; (c0de01b0 <getEthAddressStringFromBinary+0xd8>)
c0de0130:	447f      	add	r7, pc
c0de0132:	2c14      	cmp	r4, #20
c0de0134:	d00a      	beq.n	c0de014c <getEthAddressStringFromBinary+0x74>
        uint8_t digit = address[i];
c0de0136:	5d29      	ldrb	r1, [r5, r4]
c0de0138:	220f      	movs	r2, #15
        locals_union.tmp[offset + 2 * i] = HEXDIGITS[(digit >> 4) & 0x0f];
        locals_union.tmp[offset + 2 * i + 1] = HEXDIGITS[digit & 0x0f];
c0de013a:	400a      	ands	r2, r1
c0de013c:	5cba      	ldrb	r2, [r7, r2]
c0de013e:	7042      	strb	r2, [r0, #1]
        locals_union.tmp[offset + 2 * i] = HEXDIGITS[(digit >> 4) & 0x0f];
c0de0140:	0909      	lsrs	r1, r1, #4
c0de0142:	5c79      	ldrb	r1, [r7, r1]
c0de0144:	7001      	strb	r1, [r0, #0]
    for (i = 0; i < 20; i++) {
c0de0146:	1c80      	adds	r0, r0, #2
c0de0148:	1c64      	adds	r4, r4, #1
c0de014a:	e7f2      	b.n	c0de0132 <getEthAddressStringFromBinary+0x5a>
c0de014c:	9c02      	ldr	r4, [sp, #8]
    }
    cx_keccak_init(sha3Context, 256);
c0de014e:	4620      	mov	r0, r4
c0de0150:	f000 f86c 	bl	c0de022c <cx_keccak_init>
c0de0154:	9a01      	ldr	r2, [sp, #4]
    cx_hash((cx_hash_t *) sha3Context,
            CX_LAST,
            locals_union.tmp,
            offset + 40,
c0de0156:	3228      	adds	r2, #40	; 0x28
c0de0158:	a904      	add	r1, sp, #16
    cx_hash((cx_hash_t *) sha3Context,
c0de015a:	4620      	mov	r0, r4
c0de015c:	460b      	mov	r3, r1
c0de015e:	f000 f86f 	bl	c0de0240 <cx_hash>
c0de0162:	2000      	movs	r0, #0
            locals_union.hashChecksum,
            32);
    for (i = 0; i < 40; i++) {
c0de0164:	2828      	cmp	r0, #40	; 0x28
c0de0166:	d01b      	beq.n	c0de01a0 <getEthAddressStringFromBinary+0xc8>
        uint8_t digit = address[i / 2];
        if ((i % 2) == 0) {
c0de0168:	4602      	mov	r2, r0
c0de016a:	4032      	ands	r2, r6
        uint8_t digit = address[i / 2];
c0de016c:	0843      	lsrs	r3, r0, #1
c0de016e:	5ce9      	ldrb	r1, [r5, r3]
        if ((i % 2) == 0) {
c0de0170:	2a00      	cmp	r2, #0
c0de0172:	d002      	beq.n	c0de017a <getEthAddressStringFromBinary+0xa2>
c0de0174:	240f      	movs	r4, #15
c0de0176:	4021      	ands	r1, r4
c0de0178:	e000      	b.n	c0de017c <getEthAddressStringFromBinary+0xa4>
c0de017a:	0909      	lsrs	r1, r1, #4
            digit = (digit >> 4) & 0x0f;
        } else {
            digit = digit & 0x0f;
        }
        if (digit < 10) {
c0de017c:	2909      	cmp	r1, #9
c0de017e:	d801      	bhi.n	c0de0184 <getEthAddressStringFromBinary+0xac>
            out[i] = HEXDIGITS[digit];
c0de0180:	5c79      	ldrb	r1, [r7, r1]
c0de0182:	e009      	b.n	c0de0198 <getEthAddressStringFromBinary+0xc0>
c0de0184:	ac04      	add	r4, sp, #16
        } else {
            int v = (locals_union.hashChecksum[i / 2] >> (4 * (1 - i % 2))) & 0x0f;
c0de0186:	5ce3      	ldrb	r3, [r4, r3]
c0de0188:	0092      	lsls	r2, r2, #2
c0de018a:	2404      	movs	r4, #4
c0de018c:	4054      	eors	r4, r2
            if (v >= 8) {
c0de018e:	40e3      	lsrs	r3, r4
c0de0190:	071a      	lsls	r2, r3, #28
c0de0192:	5c79      	ldrb	r1, [r7, r1]
c0de0194:	d500      	bpl.n	c0de0198 <getEthAddressStringFromBinary+0xc0>
c0de0196:	3920      	subs	r1, #32
c0de0198:	9a03      	ldr	r2, [sp, #12]
c0de019a:	5411      	strb	r1, [r2, r0]
    for (i = 0; i < 40; i++) {
c0de019c:	1c40      	adds	r0, r0, #1
c0de019e:	e7e1      	b.n	c0de0164 <getEthAddressStringFromBinary+0x8c>
c0de01a0:	2028      	movs	r0, #40	; 0x28
c0de01a2:	2100      	movs	r1, #0
            } else {
                out[i] = HEXDIGITS[digit];
            }
        }
    }
    out[40] = '\0';
c0de01a4:	9a03      	ldr	r2, [sp, #12]
c0de01a6:	5411      	strb	r1, [r2, r0]
}
c0de01a8:	b011      	add	sp, #68	; 0x44
c0de01aa:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de01ac:	00002122 	.word	0x00002122
c0de01b0:	000020d7 	.word	0x000020d7

c0de01b4 <u64_to_string>:
    }

    out_buffer[out_buffer_size - 1] = '\0';
}

void u64_to_string(uint64_t src, char *dst, uint8_t dst_size) {
c0de01b4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de01b6:	b087      	sub	sp, #28
c0de01b8:	9302      	str	r3, [sp, #8]
c0de01ba:	460b      	mov	r3, r1
c0de01bc:	4605      	mov	r5, r0
c0de01be:	2400      	movs	r4, #0
c0de01c0:	9201      	str	r2, [sp, #4]
    // Copy the numbers in ASCII format.
    uint8_t i = 0;
    do {
        // Checking `i + 1` to make sure we have enough space for '\0'.
        if (i + 1 >= dst_size) {
c0de01c2:	b2e7      	uxtb	r7, r4
c0de01c4:	1c78      	adds	r0, r7, #1
c0de01c6:	9902      	ldr	r1, [sp, #8]
c0de01c8:	4288      	cmp	r0, r1
c0de01ca:	d229      	bcs.n	c0de0220 <u64_to_string+0x6c>
c0de01cc:	220a      	movs	r2, #10
c0de01ce:	9203      	str	r2, [sp, #12]
c0de01d0:	2600      	movs	r6, #0
            THROW(0x6502);
        }
        dst[i] = src % 10 + '0';
        src /= 10;
c0de01d2:	4628      	mov	r0, r5
c0de01d4:	4619      	mov	r1, r3
c0de01d6:	9306      	str	r3, [sp, #24]
c0de01d8:	4633      	mov	r3, r6
c0de01da:	f001 fbf3 	bl	c0de19c4 <__aeabi_uldivmod>
c0de01de:	9005      	str	r0, [sp, #20]
c0de01e0:	9104      	str	r1, [sp, #16]
c0de01e2:	9a03      	ldr	r2, [sp, #12]
c0de01e4:	4633      	mov	r3, r6
c0de01e6:	f001 fc0d 	bl	c0de1a04 <__aeabi_lmul>
c0de01ea:	1a28      	subs	r0, r5, r0
c0de01ec:	2130      	movs	r1, #48	; 0x30
        dst[i] = src % 10 + '0';
c0de01ee:	4301      	orrs	r1, r0
c0de01f0:	9a01      	ldr	r2, [sp, #4]
c0de01f2:	55d1      	strb	r1, [r2, r7]
        i++;
c0de01f4:	1c64      	adds	r4, r4, #1
c0de01f6:	2009      	movs	r0, #9
    } while (src);
c0de01f8:	1b40      	subs	r0, r0, r5
c0de01fa:	4630      	mov	r0, r6
c0de01fc:	9906      	ldr	r1, [sp, #24]
c0de01fe:	4188      	sbcs	r0, r1
c0de0200:	9d05      	ldr	r5, [sp, #20]
c0de0202:	9b04      	ldr	r3, [sp, #16]
c0de0204:	d3dd      	bcc.n	c0de01c2 <u64_to_string+0xe>

    // Null terminate string
    dst[i] = '\0';
c0de0206:	b2e0      	uxtb	r0, r4
c0de0208:	5416      	strb	r6, [r2, r0]

    // Revert the string
    i--;
    uint8_t j = 0;
    while (j < i) {
c0de020a:	42be      	cmp	r6, r7
c0de020c:	d206      	bcs.n	c0de021c <u64_to_string+0x68>
        char tmp = dst[i];
c0de020e:	5dd0      	ldrb	r0, [r2, r7]
        dst[i] = dst[j];
c0de0210:	5d91      	ldrb	r1, [r2, r6]
c0de0212:	55d1      	strb	r1, [r2, r7]
        dst[j] = tmp;
c0de0214:	5590      	strb	r0, [r2, r6]
        i--;
c0de0216:	1e7f      	subs	r7, r7, #1
        j++;
c0de0218:	1c76      	adds	r6, r6, #1
c0de021a:	e7f6      	b.n	c0de020a <u64_to_string+0x56>
    }
}
c0de021c:	b007      	add	sp, #28
c0de021e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0220:	4801      	ldr	r0, [pc, #4]	; (c0de0228 <u64_to_string+0x74>)
            THROW(0x6502);
c0de0222:	f001 f955 	bl	c0de14d0 <os_longjmp>
c0de0226:	46c0      	nop			; (mov r8, r8)
c0de0228:	00006502 	.word	0x00006502

c0de022c <cx_keccak_init>:
 * @return           KECCAK identifier.
 * 
 * @throws           CX_INVALID_PARAMETER
 */
static inline int cx_keccak_init ( cx_sha3_t * hash, size_t size )
{
c0de022c:	b580      	push	{r7, lr}
c0de022e:	2101      	movs	r1, #1
c0de0230:	0209      	lsls	r1, r1, #8
  CX_THROW(cx_keccak_init_no_throw(hash, size));
c0de0232:	f7ff ff41 	bl	c0de00b8 <cx_keccak_init_no_throw>
c0de0236:	2800      	cmp	r0, #0
c0de0238:	d100      	bne.n	c0de023c <cx_keccak_init+0x10>
  return CX_KECCAK;
c0de023a:	bd80      	pop	{r7, pc}
  CX_THROW(cx_keccak_init_no_throw(hash, size));
c0de023c:	f001 f948 	bl	c0de14d0 <os_longjmp>

c0de0240 <cx_hash>:
 *
 * @throws             INVALID_PARAMETER
 * @throws             CX_INVALID_PARAMETER
 */
static inline size_t cx_hash ( cx_hash_t * hash, uint32_t mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len )
{
c0de0240:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de0242:	4615      	mov	r5, r2
c0de0244:	460a      	mov	r2, r1
c0de0246:	4604      	mov	r4, r0
c0de0248:	2020      	movs	r0, #32
  CX_THROW(cx_hash_no_throw(hash, mode, in, len, out, out_len));
c0de024a:	9300      	str	r3, [sp, #0]
c0de024c:	9001      	str	r0, [sp, #4]
c0de024e:	2101      	movs	r1, #1
c0de0250:	4620      	mov	r0, r4
c0de0252:	462b      	mov	r3, r5
c0de0254:	f7ff ff2a 	bl	c0de00ac <cx_hash_no_throw>
c0de0258:	2800      	cmp	r0, #0
c0de025a:	d103      	bne.n	c0de0264 <cx_hash+0x24>
  return cx_hash_get_size(hash);
c0de025c:	4620      	mov	r0, r4
c0de025e:	f7ff ff1f 	bl	c0de00a0 <cx_hash_get_size>
c0de0262:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
  CX_THROW(cx_hash_no_throw(hash, mode, in, len, out, out_len));
c0de0264:	f001 f934 	bl	c0de14d0 <os_longjmp>

c0de0268 <adjustDecimals>:
                    uint8_t decimals) {
c0de0268:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    if ((srcLength == 1) && (*src == '0')) {
c0de026a:	2901      	cmp	r1, #1
c0de026c:	d10a      	bne.n	c0de0284 <adjustDecimals+0x1c>
c0de026e:	7804      	ldrb	r4, [r0, #0]
c0de0270:	2c30      	cmp	r4, #48	; 0x30
c0de0272:	d107      	bne.n	c0de0284 <adjustDecimals+0x1c>
        if (targetLength < 2) {
c0de0274:	2b02      	cmp	r3, #2
c0de0276:	d31a      	bcc.n	c0de02ae <adjustDecimals+0x46>
c0de0278:	2000      	movs	r0, #0
        target[1] = '\0';
c0de027a:	7050      	strb	r0, [r2, #1]
c0de027c:	2030      	movs	r0, #48	; 0x30
        target[0] = '0';
c0de027e:	7010      	strb	r0, [r2, #0]
c0de0280:	2001      	movs	r0, #1
}
c0de0282:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0284:	9f06      	ldr	r7, [sp, #24]
    if (srcLength <= decimals) {
c0de0286:	428f      	cmp	r7, r1
c0de0288:	d20e      	bcs.n	c0de02a8 <adjustDecimals+0x40>
        if (targetLength < srcLength + 1 + 1) {
c0de028a:	1c8d      	adds	r5, r1, #2
c0de028c:	429d      	cmp	r5, r3
c0de028e:	d80e      	bhi.n	c0de02ae <adjustDecimals+0x46>
c0de0290:	1bcd      	subs	r5, r1, r7
c0de0292:	4613      	mov	r3, r2
c0de0294:	4606      	mov	r6, r0
c0de0296:	9700      	str	r7, [sp, #0]
        while (offset < delta) {
c0de0298:	42b9      	cmp	r1, r7
c0de029a:	d00a      	beq.n	c0de02b2 <adjustDecimals+0x4a>
            target[offset++] = src[sourceOffset++];
c0de029c:	7834      	ldrb	r4, [r6, #0]
c0de029e:	701c      	strb	r4, [r3, #0]
        while (offset < delta) {
c0de02a0:	1c5b      	adds	r3, r3, #1
c0de02a2:	1c76      	adds	r6, r6, #1
c0de02a4:	1c7f      	adds	r7, r7, #1
c0de02a6:	e7f7      	b.n	c0de0298 <adjustDecimals+0x30>
        if (targetLength < srcLength + 1 + 2 + delta) {
c0de02a8:	1cfd      	adds	r5, r7, #3
c0de02aa:	429d      	cmp	r5, r3
c0de02ac:	d912      	bls.n	c0de02d4 <adjustDecimals+0x6c>
c0de02ae:	2000      	movs	r0, #0
}
c0de02b0:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
        if (decimals != 0) {
c0de02b2:	9b00      	ldr	r3, [sp, #0]
c0de02b4:	2b00      	cmp	r3, #0
c0de02b6:	462b      	mov	r3, r5
c0de02b8:	d002      	beq.n	c0de02c0 <adjustDecimals+0x58>
c0de02ba:	232e      	movs	r3, #46	; 0x2e
            target[offset++] = '.';
c0de02bc:	5553      	strb	r3, [r2, r5]
c0de02be:	1c6b      	adds	r3, r5, #1
        while (sourceOffset < srcLength) {
c0de02c0:	1940      	adds	r0, r0, r5
c0de02c2:	18d6      	adds	r6, r2, r3
c0de02c4:	2400      	movs	r4, #0
c0de02c6:	192f      	adds	r7, r5, r4
c0de02c8:	428f      	cmp	r7, r1
c0de02ca:	d211      	bcs.n	c0de02f0 <adjustDecimals+0x88>
            target[offset++] = src[sourceOffset++];
c0de02cc:	5d07      	ldrb	r7, [r0, r4]
c0de02ce:	5537      	strb	r7, [r6, r4]
        while (sourceOffset < srcLength) {
c0de02d0:	1c64      	adds	r4, r4, #1
c0de02d2:	e7f8      	b.n	c0de02c6 <adjustDecimals+0x5e>
c0de02d4:	232e      	movs	r3, #46	; 0x2e
        target[offset++] = '.';
c0de02d6:	7053      	strb	r3, [r2, #1]
c0de02d8:	2530      	movs	r5, #48	; 0x30
        target[offset++] = '0';
c0de02da:	7015      	strb	r5, [r2, #0]
c0de02dc:	463c      	mov	r4, r7
        for (uint32_t i = 0; i < delta; i++) {
c0de02de:	1a7e      	subs	r6, r7, r1
c0de02e0:	1cb3      	adds	r3, r6, #2
c0de02e2:	1c97      	adds	r7, r2, #2
c0de02e4:	2e00      	cmp	r6, #0
c0de02e6:	d005      	beq.n	c0de02f4 <adjustDecimals+0x8c>
            target[offset++] = '0';
c0de02e8:	703d      	strb	r5, [r7, #0]
        for (uint32_t i = 0; i < delta; i++) {
c0de02ea:	1c7f      	adds	r7, r7, #1
c0de02ec:	1e76      	subs	r6, r6, #1
c0de02ee:	e7f9      	b.n	c0de02e4 <adjustDecimals+0x7c>
c0de02f0:	1918      	adds	r0, r3, r4
c0de02f2:	e00a      	b.n	c0de030a <adjustDecimals+0xa2>
        for (uint32_t i = 0; i < srcLength; i++) {
c0de02f4:	1915      	adds	r5, r2, r4
c0de02f6:	2602      	movs	r6, #2
c0de02f8:	1a71      	subs	r1, r6, r1
c0de02fa:	2902      	cmp	r1, #2
c0de02fc:	d004      	beq.n	c0de0308 <adjustDecimals+0xa0>
            target[offset++] = src[i];
c0de02fe:	7806      	ldrb	r6, [r0, #0]
c0de0300:	546e      	strb	r6, [r5, r1]
        for (uint32_t i = 0; i < srcLength; i++) {
c0de0302:	1c40      	adds	r0, r0, #1
c0de0304:	1c49      	adds	r1, r1, #1
c0de0306:	e7f8      	b.n	c0de02fa <adjustDecimals+0x92>
c0de0308:	1860      	adds	r0, r4, r1
c0de030a:	2100      	movs	r1, #0
c0de030c:	5411      	strb	r1, [r2, r0]
    for (uint32_t i = startOffset; i < offset; i++) {
c0de030e:	4283      	cmp	r3, r0
c0de0310:	d20a      	bcs.n	c0de0328 <adjustDecimals+0xc0>
        if (target[i] == '0') {
c0de0312:	2900      	cmp	r1, #0
c0de0314:	461c      	mov	r4, r3
c0de0316:	d000      	beq.n	c0de031a <adjustDecimals+0xb2>
c0de0318:	460c      	mov	r4, r1
c0de031a:	5cd1      	ldrb	r1, [r2, r3]
c0de031c:	2930      	cmp	r1, #48	; 0x30
c0de031e:	d000      	beq.n	c0de0322 <adjustDecimals+0xba>
c0de0320:	2400      	movs	r4, #0
    for (uint32_t i = startOffset; i < offset; i++) {
c0de0322:	1c5b      	adds	r3, r3, #1
c0de0324:	4621      	mov	r1, r4
c0de0326:	e7f2      	b.n	c0de030e <adjustDecimals+0xa6>
c0de0328:	2001      	movs	r0, #1
    if (lastZeroOffset != 0) {
c0de032a:	2900      	cmp	r1, #0
c0de032c:	d006      	beq.n	c0de033c <adjustDecimals+0xd4>
c0de032e:	2300      	movs	r3, #0
        target[lastZeroOffset] = '\0';
c0de0330:	5453      	strb	r3, [r2, r1]
        if (target[lastZeroOffset - 1] == '.') {
c0de0332:	1e49      	subs	r1, r1, #1
c0de0334:	5c54      	ldrb	r4, [r2, r1]
c0de0336:	2c2e      	cmp	r4, #46	; 0x2e
c0de0338:	d100      	bne.n	c0de033c <adjustDecimals+0xd4>
            target[lastZeroOffset - 1] = '\0';
c0de033a:	5453      	strb	r3, [r2, r1]
}
c0de033c:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de033e:	d4d4      	bmi.n	c0de02ea <adjustDecimals+0x82>

c0de0340 <uint256_to_decimal>:
bool uint256_to_decimal(const uint8_t *value, size_t value_len, char *out, size_t out_len) {
c0de0340:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0342:	b08b      	sub	sp, #44	; 0x2c
c0de0344:	9201      	str	r2, [sp, #4]
    if (value_len > INT256_LENGTH) {
c0de0346:	2920      	cmp	r1, #32
c0de0348:	d817      	bhi.n	c0de037a <uint256_to_decimal+0x3a>
c0de034a:	460e      	mov	r6, r1
c0de034c:	4607      	mov	r7, r0
c0de034e:	9300      	str	r3, [sp, #0]
c0de0350:	ad03      	add	r5, sp, #12
c0de0352:	2420      	movs	r4, #32
    uint16_t n[16] = {0};
c0de0354:	4628      	mov	r0, r5
c0de0356:	4621      	mov	r1, r4
c0de0358:	f001 fc7a 	bl	c0de1c50 <__aeabi_memclr>
    memcpy((uint8_t *) n + INT256_LENGTH - value_len, value, value_len);
c0de035c:	1ba8      	subs	r0, r5, r6
c0de035e:	3020      	adds	r0, #32
c0de0360:	4639      	mov	r1, r7
c0de0362:	4632      	mov	r2, r6
c0de0364:	f001 fc7a 	bl	c0de1c5c <__aeabi_memcpy>
    if (allzeroes(n, INT256_LENGTH)) {
c0de0368:	4628      	mov	r0, r5
c0de036a:	4621      	mov	r1, r4
c0de036c:	f000 f850 	bl	c0de0410 <allzeroes>
c0de0370:	2800      	cmp	r0, #0
c0de0372:	d004      	beq.n	c0de037e <uint256_to_decimal+0x3e>
c0de0374:	9a00      	ldr	r2, [sp, #0]
        if (out_len < 2) {
c0de0376:	2a02      	cmp	r2, #2
c0de0378:	d230      	bcs.n	c0de03dc <uint256_to_decimal+0x9c>
c0de037a:	2600      	movs	r6, #0
c0de037c:	e042      	b.n	c0de0404 <uint256_to_decimal+0xc4>
c0de037e:	2000      	movs	r0, #0
c0de0380:	9b00      	ldr	r3, [sp, #0]
    for (int i = 0; i < 16; i++) {
c0de0382:	2820      	cmp	r0, #32
c0de0384:	d005      	beq.n	c0de0392 <uint256_to_decimal+0x52>
c0de0386:	a903      	add	r1, sp, #12
        n[i] = __builtin_bswap16(*p++);
c0de0388:	5a0a      	ldrh	r2, [r1, r0]
c0de038a:	ba52      	rev16	r2, r2
c0de038c:	520a      	strh	r2, [r1, r0]
    for (int i = 0; i < 16; i++) {
c0de038e:	1c80      	adds	r0, r0, #2
c0de0390:	e7f7      	b.n	c0de0382 <uint256_to_decimal+0x42>
c0de0392:	9302      	str	r3, [sp, #8]
c0de0394:	a803      	add	r0, sp, #12
c0de0396:	2120      	movs	r1, #32
    while (!allzeroes(n, sizeof(n))) {
c0de0398:	f000 f83a 	bl	c0de0410 <allzeroes>
c0de039c:	4606      	mov	r6, r0
c0de039e:	2800      	cmp	r0, #0
c0de03a0:	d123      	bne.n	c0de03ea <uint256_to_decimal+0xaa>
        if (pos == 0) {
c0de03a2:	9802      	ldr	r0, [sp, #8]
c0de03a4:	2800      	cmp	r0, #0
c0de03a6:	d02b      	beq.n	c0de0400 <uint256_to_decimal+0xc0>
c0de03a8:	2600      	movs	r6, #0
c0de03aa:	4630      	mov	r0, r6
        for (int i = 0; i < 16; i++) {
c0de03ac:	2e20      	cmp	r6, #32
c0de03ae:	d00d      	beq.n	c0de03cc <uint256_to_decimal+0x8c>
c0de03b0:	af03      	add	r7, sp, #12
            int rem = ((carry << 16) | n[i]) % 10;
c0de03b2:	5bb9      	ldrh	r1, [r7, r6]
c0de03b4:	0400      	lsls	r0, r0, #16
c0de03b6:	1844      	adds	r4, r0, r1
c0de03b8:	250a      	movs	r5, #10
            n[i] = ((carry << 16) | n[i]) / 10;
c0de03ba:	4620      	mov	r0, r4
c0de03bc:	4629      	mov	r1, r5
c0de03be:	f001 fa75 	bl	c0de18ac <__udivsi3>
c0de03c2:	53b8      	strh	r0, [r7, r6]
c0de03c4:	4345      	muls	r5, r0
c0de03c6:	1b60      	subs	r0, r4, r5
        for (int i = 0; i < 16; i++) {
c0de03c8:	1cb6      	adds	r6, r6, #2
c0de03ca:	e7ef      	b.n	c0de03ac <uint256_to_decimal+0x6c>
c0de03cc:	2130      	movs	r1, #48	; 0x30
        out[pos] = '0' + carry;
c0de03ce:	4308      	orrs	r0, r1
c0de03d0:	9a02      	ldr	r2, [sp, #8]
        pos -= 1;
c0de03d2:	1e52      	subs	r2, r2, #1
        out[pos] = '0' + carry;
c0de03d4:	9901      	ldr	r1, [sp, #4]
c0de03d6:	9202      	str	r2, [sp, #8]
c0de03d8:	5488      	strb	r0, [r1, r2]
c0de03da:	e7db      	b.n	c0de0394 <uint256_to_decimal+0x54>
        strlcpy(out, "0", out_len);
c0de03dc:	490b      	ldr	r1, [pc, #44]	; (c0de040c <uint256_to_decimal+0xcc>)
c0de03de:	4479      	add	r1, pc
c0de03e0:	9801      	ldr	r0, [sp, #4]
c0de03e2:	f001 fdc7 	bl	c0de1f74 <strlcpy>
c0de03e6:	2601      	movs	r6, #1
c0de03e8:	e00c      	b.n	c0de0404 <uint256_to_decimal+0xc4>
c0de03ea:	9d01      	ldr	r5, [sp, #4]
c0de03ec:	9a02      	ldr	r2, [sp, #8]
    memmove(out, out + pos, out_len - pos);
c0de03ee:	18a9      	adds	r1, r5, r2
c0de03f0:	9800      	ldr	r0, [sp, #0]
c0de03f2:	1a84      	subs	r4, r0, r2
c0de03f4:	4628      	mov	r0, r5
c0de03f6:	4622      	mov	r2, r4
c0de03f8:	f001 fc34 	bl	c0de1c64 <__aeabi_memmove>
c0de03fc:	2000      	movs	r0, #0
    out[out_len - pos] = 0;
c0de03fe:	5528      	strb	r0, [r5, r4]
    while (!allzeroes(n, sizeof(n))) {
c0de0400:	1e70      	subs	r0, r6, #1
c0de0402:	4186      	sbcs	r6, r0
}
c0de0404:	4630      	mov	r0, r6
c0de0406:	b00b      	add	sp, #44	; 0x2c
c0de0408:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de040a:	46c0      	nop			; (mov r8, r8)
c0de040c:	00001daa 	.word	0x00001daa

c0de0410 <allzeroes>:
typedef union extraInfo_t {
    tokenDefinition_t token;
    nftInfo_t nft;
} extraInfo_t;

static __attribute__((no_instrument_function)) inline int allzeroes(const void *buf, size_t n) {
c0de0410:	b510      	push	{r4, lr}
c0de0412:	2300      	movs	r3, #0
c0de0414:	461a      	mov	r2, r3
    uint8_t *p = (uint8_t *) buf;
    for (size_t i = 0; i < n; ++i) {
c0de0416:	4299      	cmp	r1, r3
c0de0418:	d003      	beq.n	c0de0422 <allzeroes+0x12>
        if (p[i]) {
c0de041a:	5c84      	ldrb	r4, [r0, r2]
    for (size_t i = 0; i < n; ++i) {
c0de041c:	1c53      	adds	r3, r2, #1
        if (p[i]) {
c0de041e:	2c00      	cmp	r4, #0
c0de0420:	d0f8      	beq.n	c0de0414 <allzeroes+0x4>
    for (size_t i = 0; i < n; ++i) {
c0de0422:	428a      	cmp	r2, r1
c0de0424:	d201      	bcs.n	c0de042a <allzeroes+0x1a>
c0de0426:	2000      	movs	r0, #0
            return 0;
        }
    }
    return 1;
}
c0de0428:	bd10      	pop	{r4, pc}
c0de042a:	2001      	movs	r0, #1
c0de042c:	bd10      	pop	{r4, pc}

c0de042e <amountToString>:
                    size_t out_buffer_size) {
c0de042e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0430:	b09d      	sub	sp, #116	; 0x74
c0de0432:	9303      	str	r3, [sp, #12]
c0de0434:	9202      	str	r2, [sp, #8]
c0de0436:	460c      	mov	r4, r1
c0de0438:	4605      	mov	r5, r0
c0de043a:	af04      	add	r7, sp, #16
c0de043c:	2664      	movs	r6, #100	; 0x64
    char tmp_buffer[100] = {0};
c0de043e:	4638      	mov	r0, r7
c0de0440:	4631      	mov	r1, r6
c0de0442:	f001 fc05 	bl	c0de1c50 <__aeabi_memclr>
    if (uint256_to_decimal(amount, amount_size, tmp_buffer, sizeof(tmp_buffer)) == false) {
c0de0446:	4628      	mov	r0, r5
c0de0448:	4621      	mov	r1, r4
c0de044a:	463a      	mov	r2, r7
c0de044c:	4633      	mov	r3, r6
c0de044e:	f7ff ff77 	bl	c0de0340 <uint256_to_decimal>
c0de0452:	2800      	cmp	r0, #0
c0de0454:	d02e      	beq.n	c0de04b4 <amountToString+0x86>
c0de0456:	9e23      	ldr	r6, [sp, #140]	; 0x8c
c0de0458:	9d22      	ldr	r5, [sp, #136]	; 0x88
c0de045a:	a804      	add	r0, sp, #16
c0de045c:	2164      	movs	r1, #100	; 0x64
    uint8_t amount_len = strnlen(tmp_buffer, sizeof(tmp_buffer));
c0de045e:	f001 fde3 	bl	c0de2028 <strnlen>
c0de0462:	9001      	str	r0, [sp, #4]
c0de0464:	210b      	movs	r1, #11
    uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de0466:	9803      	ldr	r0, [sp, #12]
c0de0468:	f001 fdde 	bl	c0de2028 <strnlen>
c0de046c:	4604      	mov	r4, r0
    memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de046e:	b2c7      	uxtb	r7, r0
c0de0470:	42b7      	cmp	r7, r6
c0de0472:	4632      	mov	r2, r6
c0de0474:	d800      	bhi.n	c0de0478 <amountToString+0x4a>
c0de0476:	463a      	mov	r2, r7
c0de0478:	4628      	mov	r0, r5
c0de047a:	9903      	ldr	r1, [sp, #12]
c0de047c:	f001 fbee 	bl	c0de1c5c <__aeabi_memcpy>
    if (ticker_len > 0) {
c0de0480:	2f00      	cmp	r7, #0
c0de0482:	d004      	beq.n	c0de048e <amountToString+0x60>
c0de0484:	2020      	movs	r0, #32
        out_buffer[ticker_len++] = ' ';
c0de0486:	55e8      	strb	r0, [r5, r7]
c0de0488:	1c60      	adds	r0, r4, #1
                       out_buffer + ticker_len,
c0de048a:	b2c0      	uxtb	r0, r0
c0de048c:	e000      	b.n	c0de0490 <amountToString+0x62>
c0de048e:	2000      	movs	r0, #0
c0de0490:	9902      	ldr	r1, [sp, #8]
    if (adjustDecimals(tmp_buffer,
c0de0492:	9100      	str	r1, [sp, #0]
                       out_buffer + ticker_len,
c0de0494:	182a      	adds	r2, r5, r0
                       out_buffer_size - ticker_len - 1,
c0de0496:	43c0      	mvns	r0, r0
c0de0498:	1983      	adds	r3, r0, r6
                       amount_len,
c0de049a:	9801      	ldr	r0, [sp, #4]
c0de049c:	b2c1      	uxtb	r1, r0
c0de049e:	a804      	add	r0, sp, #16
    if (adjustDecimals(tmp_buffer,
c0de04a0:	f7ff fee2 	bl	c0de0268 <adjustDecimals>
c0de04a4:	2800      	cmp	r0, #0
c0de04a6:	d005      	beq.n	c0de04b4 <amountToString+0x86>
    out_buffer[out_buffer_size - 1] = '\0';
c0de04a8:	1970      	adds	r0, r6, r5
c0de04aa:	1e40      	subs	r0, r0, #1
c0de04ac:	2100      	movs	r1, #0
c0de04ae:	7001      	strb	r1, [r0, #0]
}
c0de04b0:	b01d      	add	sp, #116	; 0x74
c0de04b2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de04b4:	2007      	movs	r0, #7
c0de04b6:	f001 f80b 	bl	c0de14d0 <os_longjmp>
c0de04ba:	d4d4      	bmi.n	c0de0466 <amountToString+0x38>

c0de04bc <handle_finalize>:
#include "origin_defi_plugin.h"

void handle_finalize(void *parameters) {
c0de04bc:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de04be:	4604      	mov	r4, r0
c0de04c0:	2202      	movs	r2, #2
    ethPluginFinalize_t *msg = (ethPluginFinalize_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
    msg->numScreens = 2;
c0de04c2:	7742      	strb	r2, [r0, #29]
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de04c4:	6885      	ldr	r5, [r0, #8]
c0de04c6:	209c      	movs	r0, #156	; 0x9c
    if ((context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT || 
c0de04c8:	5c28      	ldrb	r0, [r5, r0]
c0de04ca:	1fc1      	subs	r1, r0, #7
c0de04cc:	2901      	cmp	r1, #1
c0de04ce:	9200      	str	r2, [sp, #0]
c0de04d0:	d809      	bhi.n	c0de04e6 <handle_finalize+0x2a>
        context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT_SINGLE) && 
        memcmp(msg->address, context->beneficiary, ADDRESS_LENGTH) != 0) {
c0de04d2:	69a0      	ldr	r0, [r4, #24]
c0de04d4:	4629      	mov	r1, r5
c0de04d6:	3168      	adds	r1, #104	; 0x68
c0de04d8:	2214      	movs	r2, #20
c0de04da:	f001 fbcf 	bl	c0de1c7c <memcmp>
    if ((context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT || 
c0de04de:	2800      	cmp	r0, #0
c0de04e0:	d00e      	beq.n	c0de0500 <handle_finalize+0x44>
c0de04e2:	2003      	movs	r0, #3
c0de04e4:	e00b      	b.n	c0de04fe <handle_finalize+0x42>
        msg->numScreens += 1;
    }
    if ((context->selectorIndex == WRAP ||
c0de04e6:	380f      	subs	r0, #15
c0de04e8:	2801      	cmp	r0, #1
c0de04ea:	d809      	bhi.n	c0de0500 <handle_finalize+0x44>
        context->selectorIndex == UNWRAP) && 
        memcmp(msg->address, context->beneficiary, ADDRESS_LENGTH) == 0) {
c0de04ec:	69a0      	ldr	r0, [r4, #24]
c0de04ee:	4629      	mov	r1, r5
c0de04f0:	3168      	adds	r1, #104	; 0x68
c0de04f2:	2214      	movs	r2, #20
c0de04f4:	f001 fbc2 	bl	c0de1c7c <memcmp>
    if ((context->selectorIndex == WRAP ||
c0de04f8:	2800      	cmp	r0, #0
c0de04fa:	d101      	bne.n	c0de0500 <handle_finalize+0x44>
c0de04fc:	2001      	movs	r0, #1
c0de04fe:	7760      	strb	r0, [r4, #29]
c0de0500:	462f      	mov	r7, r5
c0de0502:	3792      	adds	r7, #146	; 0x92
        msg->numScreens -= 1;
    }
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0504:	462e      	mov	r6, r5
c0de0506:	3640      	adds	r6, #64	; 0x40
c0de0508:	4918      	ldr	r1, [pc, #96]	; (c0de056c <handle_finalize+0xb0>)
c0de050a:	4479      	add	r1, pc
c0de050c:	2214      	movs	r2, #20
c0de050e:	4630      	mov	r0, r6
c0de0510:	f001 fbb4 	bl	c0de1c7c <memcmp>
c0de0514:	2800      	cmp	r0, #0
c0de0516:	d005      	beq.n	c0de0524 <handle_finalize+0x68>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address sent to: ",
c0de0518:	4815      	ldr	r0, [pc, #84]	; (c0de0570 <handle_finalize+0xb4>)
c0de051a:	4478      	add	r0, pc
c0de051c:	4631      	mov	r1, r6
c0de051e:	f000 f82d 	bl	c0de057c <printf_hex_array>
c0de0522:	e006      	b.n	c0de0532 <handle_finalize+0x76>
c0de0524:	2012      	movs	r0, #18
    }
    return true;
}

static inline void sent_network_token(origin_defi_parameters_t *context) {
    context->decimals_sent = WEI_TO_ETHER;
c0de0526:	7078      	strb	r0, [r7, #1]
    context->tokens_found |= TOKEN_SENT_FOUND;
c0de0528:	7838      	ldrb	r0, [r7, #0]
c0de052a:	2101      	movs	r1, #1
c0de052c:	4301      	orrs	r1, r0
c0de052e:	7039      	strb	r1, [r7, #0]
c0de0530:	2600      	movs	r6, #0
c0de0532:	60e6      	str	r6, [r4, #12]
        msg->tokenLookup1 = context->contract_address_sent;
    } else {
        sent_network_token(context);
        msg->tokenLookup1 = NULL;
    }
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0534:	3554      	adds	r5, #84	; 0x54
c0de0536:	490f      	ldr	r1, [pc, #60]	; (c0de0574 <handle_finalize+0xb8>)
c0de0538:	4479      	add	r1, pc
c0de053a:	2214      	movs	r2, #20
c0de053c:	4628      	mov	r0, r5
c0de053e:	f001 fb9d 	bl	c0de1c7c <memcmp>
c0de0542:	2800      	cmp	r0, #0
c0de0544:	d006      	beq.n	c0de0554 <handle_finalize+0x98>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address received to: ",
c0de0546:	480c      	ldr	r0, [pc, #48]	; (c0de0578 <handle_finalize+0xbc>)
c0de0548:	4478      	add	r0, pc
c0de054a:	4629      	mov	r1, r5
c0de054c:	f000 f816 	bl	c0de057c <printf_hex_array>
c0de0550:	9900      	ldr	r1, [sp, #0]
c0de0552:	e006      	b.n	c0de0562 <handle_finalize+0xa6>
c0de0554:	2012      	movs	r0, #18
}

static inline void received_network_token(origin_defi_parameters_t *context) {
    context->decimals_received = WEI_TO_ETHER;
c0de0556:	70b8      	strb	r0, [r7, #2]
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
c0de0558:	7838      	ldrb	r0, [r7, #0]
c0de055a:	9900      	ldr	r1, [sp, #0]
c0de055c:	4308      	orrs	r0, r1
c0de055e:	7038      	strb	r0, [r7, #0]
c0de0560:	2500      	movs	r5, #0
c0de0562:	2004      	movs	r0, #4
        received_network_token(context);
        msg->tokenLookup2 = NULL;
    }

    msg->uiType = ETH_UI_TYPE_GENERIC;
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0564:	77a0      	strb	r0, [r4, #30]
    msg->uiType = ETH_UI_TYPE_GENERIC;
c0de0566:	7721      	strb	r1, [r4, #28]
c0de0568:	6125      	str	r5, [r4, #16]
c0de056a:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de056c:	00001f76 	.word	0x00001f76
c0de0570:	00001d3d 	.word	0x00001d3d
c0de0574:	00001f48 	.word	0x00001f48
c0de0578:	00001c42 	.word	0x00001c42

c0de057c <printf_hex_array>:
}

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
c0de057c:	b570      	push	{r4, r5, r6, lr}
c0de057e:	460c      	mov	r4, r1
    PRINTF(title);
c0de0580:	f000 ffc6 	bl	c0de1510 <mcu_usb_printf>
c0de0584:	2600      	movs	r6, #0
c0de0586:	4d07      	ldr	r5, [pc, #28]	; (c0de05a4 <printf_hex_array+0x28>)
c0de0588:	447d      	add	r5, pc
    for (size_t i = 0; i < len; ++i) {
c0de058a:	2e14      	cmp	r6, #20
c0de058c:	d005      	beq.n	c0de059a <printf_hex_array+0x1e>
        PRINTF("%02x", data[i]);
c0de058e:	5da1      	ldrb	r1, [r4, r6]
c0de0590:	4628      	mov	r0, r5
c0de0592:	f000 ffbd 	bl	c0de1510 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de0596:	1c76      	adds	r6, r6, #1
c0de0598:	e7f7      	b.n	c0de058a <printf_hex_array+0xe>
    };
    PRINTF("\n");
c0de059a:	4803      	ldr	r0, [pc, #12]	; (c0de05a8 <printf_hex_array+0x2c>)
c0de059c:	4478      	add	r0, pc
c0de059e:	f000 ffb7 	bl	c0de1510 <mcu_usb_printf>
c0de05a2:	bd70      	pop	{r4, r5, r6, pc}
c0de05a4:	00001b82 	.word	0x00001b82
c0de05a8:	00001ce1 	.word	0x00001ce1

c0de05ac <handle_init_contract>:
    }
    return -1;
}

// Called once to init.
void handle_init_contract(void *parameters) {
c0de05ac:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de05ae:	4604      	mov	r4, r0
    // Cast the msg to the type of structure we expect (here, ethPluginInitContract_t).
    ethPluginInitContract_t *msg = (ethPluginInitContract_t *) parameters;

    // Make sure we are running a compatible version.
    if (msg->interfaceVersion != ETH_PLUGIN_INTERFACE_VERSION_LATEST) {
c0de05b0:	7800      	ldrb	r0, [r0, #0]
c0de05b2:	2701      	movs	r7, #1
c0de05b4:	2806      	cmp	r0, #6
c0de05b6:	d107      	bne.n	c0de05c8 <handle_init_contract+0x1c>
        return;
    }

    // Double check that the `context_t` struct is not bigger than the maximum size (defined by
    // `msg->pluginContextLength`).
    if (msg->pluginContextLength < sizeof(origin_defi_parameters_t)) {
c0de05b8:	6920      	ldr	r0, [r4, #16]
c0de05ba:	289d      	cmp	r0, #157	; 0x9d
c0de05bc:	d806      	bhi.n	c0de05cc <handle_init_contract+0x20>
        PRINTF("Plugin parameters structure is bigger than allowed size\n");
c0de05be:	4831      	ldr	r0, [pc, #196]	; (c0de0684 <handle_init_contract+0xd8>)
c0de05c0:	4478      	add	r0, pc
c0de05c2:	f000 ffa5 	bl	c0de1510 <mcu_usb_printf>
c0de05c6:	2700      	movs	r7, #0
c0de05c8:	7067      	strb	r7, [r4, #1]
            return;
    }

    // Return valid status.
    msg->result = ETH_PLUGIN_RESULT_OK;
}
c0de05ca:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de05cc:	68e5      	ldr	r5, [r4, #12]
c0de05ce:	219e      	movs	r1, #158	; 0x9e
    memset(context, 0, sizeof(*context));
c0de05d0:	4628      	mov	r0, r5
c0de05d2:	f001 fb3d 	bl	c0de1c50 <__aeabi_memclr>
    uint32_t selector = U4BE(msg->selector, 0);
c0de05d6:	6960      	ldr	r0, [r4, #20]
#define U4(hi3, hi2, lo1,lo0) ((((hi3)&0xFFu)<<24) | (((hi2)&0xFFu)<<16) | (((lo1)&0xFFu)<<8) | ((lo0)&0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off) {
  return (buf[off] << 8) | buf[off + 1];
}
static inline uint32_t U4BE(const uint8_t *buf, size_t off) {
  return (((uint32_t)buf[off]) << 24) | (buf[off + 1] << 16) | (buf[off + 2] << 8) | buf[off + 3];
c0de05d8:	7801      	ldrb	r1, [r0, #0]
c0de05da:	0609      	lsls	r1, r1, #24
c0de05dc:	7842      	ldrb	r2, [r0, #1]
c0de05de:	0412      	lsls	r2, r2, #16
c0de05e0:	1851      	adds	r1, r2, r1
c0de05e2:	7882      	ldrb	r2, [r0, #2]
c0de05e4:	0212      	lsls	r2, r2, #8
c0de05e6:	1889      	adds	r1, r1, r2
c0de05e8:	78c0      	ldrb	r0, [r0, #3]
c0de05ea:	1808      	adds	r0, r1, r0
c0de05ec:	3595      	adds	r5, #149	; 0x95
c0de05ee:	2600      	movs	r6, #0
c0de05f0:	4925      	ldr	r1, [pc, #148]	; (c0de0688 <handle_init_contract+0xdc>)
c0de05f2:	4479      	add	r1, pc
    for (selector_t i = 0; i < n; i++) {
c0de05f4:	2e11      	cmp	r6, #17
c0de05f6:	d0e7      	beq.n	c0de05c8 <handle_init_contract+0x1c>
        if (selector == selectors[i]) {
c0de05f8:	680a      	ldr	r2, [r1, #0]
c0de05fa:	4282      	cmp	r2, r0
c0de05fc:	d002      	beq.n	c0de0604 <handle_init_contract+0x58>
    for (selector_t i = 0; i < n; i++) {
c0de05fe:	1d09      	adds	r1, r1, #4
c0de0600:	1c76      	adds	r6, r6, #1
c0de0602:	e7f7      	b.n	c0de05f4 <handle_init_contract+0x48>
            *out = i;
c0de0604:	71ee      	strb	r6, [r5, #7]
    if (find_selector(selector, ORIGIN_DEFI_SELECTORS, NUM_SELECTORS, &context->selectorIndex)) {
c0de0606:	2e10      	cmp	r6, #16
c0de0608:	d8de      	bhi.n	c0de05c8 <handle_init_contract+0x1c>
    switch (context->selectorIndex) {
c0de060a:	b2f0      	uxtb	r0, r6
c0de060c:	4601      	mov	r1, r0
c0de060e:	3909      	subs	r1, #9
c0de0610:	2908      	cmp	r1, #8
c0de0612:	d310      	bcc.n	c0de0636 <handle_init_contract+0x8a>
c0de0614:	1f01      	subs	r1, r0, #4
c0de0616:	2902      	cmp	r1, #2
c0de0618:	d311      	bcc.n	c0de063e <handle_init_contract+0x92>
c0de061a:	2800      	cmp	r0, #0
c0de061c:	d029      	beq.n	c0de0672 <handle_init_contract+0xc6>
c0de061e:	2808      	cmp	r0, #8
c0de0620:	d00b      	beq.n	c0de063a <handle_init_contract+0x8e>
c0de0622:	2802      	cmp	r0, #2
c0de0624:	d009      	beq.n	c0de063a <handle_init_contract+0x8e>
c0de0626:	2803      	cmp	r0, #3
c0de0628:	d005      	beq.n	c0de0636 <handle_init_contract+0x8a>
c0de062a:	2806      	cmp	r0, #6
c0de062c:	d005      	beq.n	c0de063a <handle_init_contract+0x8e>
c0de062e:	2807      	cmp	r0, #7
c0de0630:	d021      	beq.n	c0de0676 <handle_init_contract+0xca>
c0de0632:	2801      	cmp	r0, #1
c0de0634:	d117      	bne.n	c0de0666 <handle_init_contract+0xba>
c0de0636:	2703      	movs	r7, #3
c0de0638:	e020      	b.n	c0de067c <handle_init_contract+0xd0>
c0de063a:	2700      	movs	r7, #0
c0de063c:	e01e      	b.n	c0de067c <handle_init_contract+0xd0>
            if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0 || memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de063e:	68a0      	ldr	r0, [r4, #8]
c0de0640:	6801      	ldr	r1, [r0, #0]
c0de0642:	31a5      	adds	r1, #165	; 0xa5
c0de0644:	4811      	ldr	r0, [pc, #68]	; (c0de068c <handle_init_contract+0xe0>)
c0de0646:	4478      	add	r0, pc
c0de0648:	2214      	movs	r2, #20
c0de064a:	9100      	str	r1, [sp, #0]
c0de064c:	f001 fb16 	bl	c0de1c7c <memcmp>
c0de0650:	2700      	movs	r7, #0
c0de0652:	2800      	cmp	r0, #0
c0de0654:	d012      	beq.n	c0de067c <handle_init_contract+0xd0>
c0de0656:	480e      	ldr	r0, [pc, #56]	; (c0de0690 <handle_init_contract+0xe4>)
c0de0658:	4478      	add	r0, pc
c0de065a:	2214      	movs	r2, #20
c0de065c:	9900      	ldr	r1, [sp, #0]
c0de065e:	f001 fb0d 	bl	c0de1c7c <memcmp>
c0de0662:	2800      	cmp	r0, #0
c0de0664:	d00a      	beq.n	c0de067c <handle_init_contract+0xd0>
c0de0666:	480b      	ldr	r0, [pc, #44]	; (c0de0694 <handle_init_contract+0xe8>)
c0de0668:	4478      	add	r0, pc
c0de066a:	4631      	mov	r1, r6
c0de066c:	f000 ff50 	bl	c0de1510 <mcu_usb_printf>
c0de0670:	e7a9      	b.n	c0de05c6 <handle_init_contract+0x1a>
c0de0672:	2708      	movs	r7, #8
c0de0674:	e002      	b.n	c0de067c <handle_init_contract+0xd0>
c0de0676:	2002      	movs	r0, #2
            context->skip += 2;
c0de0678:	7028      	strb	r0, [r5, #0]
c0de067a:	2705      	movs	r7, #5
c0de067c:	70ef      	strb	r7, [r5, #3]
c0de067e:	2704      	movs	r7, #4
c0de0680:	e7a2      	b.n	c0de05c8 <handle_init_contract+0x1c>
c0de0682:	46c0      	nop			; (mov r8, r8)
c0de0684:	00001a94 	.word	0x00001a94
c0de0688:	00001d76 	.word	0x00001d76
c0de068c:	00001df2 	.word	0x00001df2
c0de0690:	00001df4 	.word	0x00001df4
c0de0694:	00001ca9 	.word	0x00001ca9

c0de0698 <handle_provide_parameter>:
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
c0de0698:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de069a:	4605      	mov	r5, r0
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de069c:	6886      	ldr	r6, [r0, #8]
    printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH, msg->parameter);
c0de069e:	68c2      	ldr	r2, [r0, #12]
c0de06a0:	48af      	ldr	r0, [pc, #700]	; (c0de0960 <handle_provide_parameter+0x2c8>)
c0de06a2:	4478      	add	r0, pc
c0de06a4:	2120      	movs	r1, #32
c0de06a6:	f000 f96b 	bl	c0de0980 <printf_hex_array>
c0de06aa:	2704      	movs	r7, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de06ac:	752f      	strb	r7, [r5, #20]
c0de06ae:	2095      	movs	r0, #149	; 0x95

    if (context->skip) {
c0de06b0:	5c30      	ldrb	r0, [r6, r0]
c0de06b2:	4632      	mov	r2, r6
c0de06b4:	3295      	adds	r2, #149	; 0x95
c0de06b6:	2800      	cmp	r0, #0
c0de06b8:	d002      	beq.n	c0de06c0 <handle_provide_parameter+0x28>
        // Skip this step, and don't forget to decrease skipping counter.
        context->skip--;
c0de06ba:	1e40      	subs	r0, r0, #1
c0de06bc:	7010      	strb	r0, [r2, #0]
                PRINTF("Selector Index %d not supported\n", context->selectorIndex);
                msg->result = ETH_PLUGIN_RESULT_ERROR;
                break;
        }
    }
c0de06be:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de06c0:	462b      	mov	r3, r5
c0de06c2:	330c      	adds	r3, #12
c0de06c4:	4634      	mov	r4, r6
c0de06c6:	349a      	adds	r4, #154	; 0x9a
        switch (context->selectorIndex) {
c0de06c8:	78a1      	ldrb	r1, [r4, #2]
c0de06ca:	4608      	mov	r0, r1
c0de06cc:	3809      	subs	r0, #9
c0de06ce:	2806      	cmp	r0, #6
c0de06d0:	d31c      	bcc.n	c0de070c <handle_provide_parameter+0x74>
c0de06d2:	1f08      	subs	r0, r1, #4
c0de06d4:	2802      	cmp	r0, #2
c0de06d6:	d322      	bcc.n	c0de071e <handle_provide_parameter+0x86>
c0de06d8:	4608      	mov	r0, r1
c0de06da:	380f      	subs	r0, #15
c0de06dc:	2802      	cmp	r0, #2
c0de06de:	d32a      	bcc.n	c0de0736 <handle_provide_parameter+0x9e>
c0de06e0:	2908      	cmp	r1, #8
c0de06e2:	d03f      	beq.n	c0de0764 <handle_provide_parameter+0xcc>
c0de06e4:	2901      	cmp	r1, #1
c0de06e6:	d035      	beq.n	c0de0754 <handle_provide_parameter+0xbc>
c0de06e8:	2902      	cmp	r1, #2
c0de06ea:	d048      	beq.n	c0de077e <handle_provide_parameter+0xe6>
c0de06ec:	2903      	cmp	r1, #3
c0de06ee:	d031      	beq.n	c0de0754 <handle_provide_parameter+0xbc>
c0de06f0:	2906      	cmp	r1, #6
c0de06f2:	d065      	beq.n	c0de07c0 <handle_provide_parameter+0x128>
c0de06f4:	2907      	cmp	r1, #7
c0de06f6:	d076      	beq.n	c0de07e6 <handle_provide_parameter+0x14e>
c0de06f8:	2900      	cmp	r1, #0
c0de06fa:	d000      	beq.n	c0de06fe <handle_provide_parameter+0x66>
c0de06fc:	e095      	b.n	c0de082a <handle_provide_parameter+0x192>
    switch (context->next_param) {
c0de06fe:	78d1      	ldrb	r1, [r2, #3]
c0de0700:	2908      	cmp	r1, #8
c0de0702:	d100      	bne.n	c0de0706 <handle_provide_parameter+0x6e>
c0de0704:	e097      	b.n	c0de0836 <handle_provide_parameter+0x19e>
            PRINTF("Param not supported: %d\n", context->next_param);
c0de0706:	4897      	ldr	r0, [pc, #604]	; (c0de0964 <handle_provide_parameter+0x2cc>)
c0de0708:	4478      	add	r0, pc
c0de070a:	e090      	b.n	c0de082e <handle_provide_parameter+0x196>
    switch (context->next_param) {
c0de070c:	78d0      	ldrb	r0, [r2, #3]
c0de070e:	2808      	cmp	r0, #8
c0de0710:	d100      	bne.n	c0de0714 <handle_provide_parameter+0x7c>
c0de0712:	e090      	b.n	c0de0836 <handle_provide_parameter+0x19e>
c0de0714:	2803      	cmp	r0, #3
c0de0716:	d000      	beq.n	c0de071a <handle_provide_parameter+0x82>
c0de0718:	e082      	b.n	c0de0820 <handle_provide_parameter+0x188>
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de071a:	6819      	ldr	r1, [r3, #0]
c0de071c:	e048      	b.n	c0de07b0 <handle_provide_parameter+0x118>
    switch (context->next_param) {
c0de071e:	78d0      	ldrb	r0, [r2, #3]
c0de0720:	2808      	cmp	r0, #8
c0de0722:	d100      	bne.n	c0de0726 <handle_provide_parameter+0x8e>
c0de0724:	e087      	b.n	c0de0836 <handle_provide_parameter+0x19e>
c0de0726:	2801      	cmp	r0, #1
c0de0728:	d100      	bne.n	c0de072c <handle_provide_parameter+0x94>
c0de072a:	e08b      	b.n	c0de0844 <handle_provide_parameter+0x1ac>
c0de072c:	2803      	cmp	r0, #3
c0de072e:	d035      	beq.n	c0de079c <handle_provide_parameter+0x104>
c0de0730:	2804      	cmp	r0, #4
c0de0732:	d14f      	bne.n	c0de07d4 <handle_provide_parameter+0x13c>
c0de0734:	e03a      	b.n	c0de07ac <handle_provide_parameter+0x114>
    switch (context->next_param) {
c0de0736:	78d0      	ldrb	r0, [r2, #3]
c0de0738:	2808      	cmp	r0, #8
c0de073a:	d07c      	beq.n	c0de0836 <handle_provide_parameter+0x19e>
c0de073c:	2805      	cmp	r0, #5
c0de073e:	d07b      	beq.n	c0de0838 <handle_provide_parameter+0x1a0>
c0de0740:	2803      	cmp	r0, #3
c0de0742:	d16d      	bne.n	c0de0820 <handle_provide_parameter+0x188>
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de0744:	6819      	ldr	r1, [r3, #0]
c0de0746:	4614      	mov	r4, r2
c0de0748:	2220      	movs	r2, #32
c0de074a:	4630      	mov	r0, r6
c0de074c:	f001 fa86 	bl	c0de1c5c <__aeabi_memcpy>
c0de0750:	2005      	movs	r0, #5
c0de0752:	e033      	b.n	c0de07bc <handle_provide_parameter+0x124>
c0de0754:	78d0      	ldrb	r0, [r2, #3]
c0de0756:	2808      	cmp	r0, #8
c0de0758:	d06d      	beq.n	c0de0836 <handle_provide_parameter+0x19e>
c0de075a:	2804      	cmp	r0, #4
c0de075c:	d026      	beq.n	c0de07ac <handle_provide_parameter+0x114>
c0de075e:	2803      	cmp	r0, #3
c0de0760:	d15e      	bne.n	c0de0820 <handle_provide_parameter+0x188>
c0de0762:	e01b      	b.n	c0de079c <handle_provide_parameter+0x104>
    switch (context->next_param) {
c0de0764:	78d0      	ldrb	r0, [r2, #3]
c0de0766:	2808      	cmp	r0, #8
c0de0768:	d065      	beq.n	c0de0836 <handle_provide_parameter+0x19e>
c0de076a:	2801      	cmp	r0, #1
c0de076c:	d100      	bne.n	c0de0770 <handle_provide_parameter+0xd8>
c0de076e:	e08e      	b.n	c0de088e <handle_provide_parameter+0x1f6>
c0de0770:	2803      	cmp	r0, #3
c0de0772:	d013      	beq.n	c0de079c <handle_provide_parameter+0x104>
c0de0774:	2804      	cmp	r0, #4
c0de0776:	d019      	beq.n	c0de07ac <handle_provide_parameter+0x114>
c0de0778:	2805      	cmp	r0, #5
c0de077a:	d12b      	bne.n	c0de07d4 <handle_provide_parameter+0x13c>
c0de077c:	e049      	b.n	c0de0812 <handle_provide_parameter+0x17a>
    switch (context->next_param) {
c0de077e:	78d0      	ldrb	r0, [r2, #3]
c0de0780:	2808      	cmp	r0, #8
c0de0782:	d058      	beq.n	c0de0836 <handle_provide_parameter+0x19e>
c0de0784:	2803      	cmp	r0, #3
c0de0786:	d009      	beq.n	c0de079c <handle_provide_parameter+0x104>
c0de0788:	2804      	cmp	r0, #4
c0de078a:	d00f      	beq.n	c0de07ac <handle_provide_parameter+0x114>
c0de078c:	2800      	cmp	r0, #0
c0de078e:	d147      	bne.n	c0de0820 <handle_provide_parameter+0x188>
            handle_token_sent(msg, context);
c0de0790:	4628      	mov	r0, r5
c0de0792:	4631      	mov	r1, r6
c0de0794:	4614      	mov	r4, r2
c0de0796:	f000 f90d 	bl	c0de09b4 <handle_token_sent>
c0de079a:	e058      	b.n	c0de084e <handle_provide_parameter+0x1b6>
c0de079c:	6819      	ldr	r1, [r3, #0]
c0de079e:	4614      	mov	r4, r2
c0de07a0:	2220      	movs	r2, #32
c0de07a2:	4630      	mov	r0, r6
c0de07a4:	f001 fa5a 	bl	c0de1c5c <__aeabi_memcpy>
c0de07a8:	70e7      	strb	r7, [r4, #3]
c0de07aa:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de07ac:	6819      	ldr	r1, [r3, #0]
c0de07ae:	3620      	adds	r6, #32
c0de07b0:	4614      	mov	r4, r2
c0de07b2:	2220      	movs	r2, #32
c0de07b4:	4630      	mov	r0, r6
c0de07b6:	f001 fa51 	bl	c0de1c5c <__aeabi_memcpy>
c0de07ba:	2008      	movs	r0, #8
c0de07bc:	70e0      	strb	r0, [r4, #3]
c0de07be:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    switch (context->next_param) {
c0de07c0:	78d0      	ldrb	r0, [r2, #3]
c0de07c2:	2808      	cmp	r0, #8
c0de07c4:	d037      	beq.n	c0de0836 <handle_provide_parameter+0x19e>
c0de07c6:	461c      	mov	r4, r3
c0de07c8:	2801      	cmp	r0, #1
c0de07ca:	d042      	beq.n	c0de0852 <handle_provide_parameter+0x1ba>
c0de07cc:	2803      	cmp	r0, #3
c0de07ce:	d05a      	beq.n	c0de0886 <handle_provide_parameter+0x1ee>
c0de07d0:	2804      	cmp	r0, #4
c0de07d2:	d05a      	beq.n	c0de088a <handle_provide_parameter+0x1f2>
c0de07d4:	2800      	cmp	r0, #0
c0de07d6:	d123      	bne.n	c0de0820 <handle_provide_parameter+0x188>
c0de07d8:	4628      	mov	r0, r5
c0de07da:	4631      	mov	r1, r6
c0de07dc:	4614      	mov	r4, r2
c0de07de:	f000 f8e9 	bl	c0de09b4 <handle_token_sent>
c0de07e2:	2001      	movs	r0, #1
c0de07e4:	e7ea      	b.n	c0de07bc <handle_provide_parameter+0x124>
    switch (context->next_param) {
c0de07e6:	78d0      	ldrb	r0, [r2, #3]
c0de07e8:	2800      	cmp	r0, #0
c0de07ea:	d05b      	beq.n	c0de08a4 <handle_provide_parameter+0x20c>
c0de07ec:	2801      	cmp	r0, #1
c0de07ee:	d070      	beq.n	c0de08d2 <handle_provide_parameter+0x23a>
c0de07f0:	2802      	cmp	r0, #2
c0de07f2:	d07f      	beq.n	c0de08f4 <handle_provide_parameter+0x25c>
c0de07f4:	9200      	str	r2, [sp, #0]
c0de07f6:	2803      	cmp	r0, #3
c0de07f8:	d100      	bne.n	c0de07fc <handle_provide_parameter+0x164>
c0de07fa:	e088      	b.n	c0de090e <handle_provide_parameter+0x276>
c0de07fc:	2804      	cmp	r0, #4
c0de07fe:	d100      	bne.n	c0de0802 <handle_provide_parameter+0x16a>
c0de0800:	e08d      	b.n	c0de091e <handle_provide_parameter+0x286>
c0de0802:	2808      	cmp	r0, #8
c0de0804:	9a00      	ldr	r2, [sp, #0]
c0de0806:	d016      	beq.n	c0de0836 <handle_provide_parameter+0x19e>
c0de0808:	2806      	cmp	r0, #6
c0de080a:	d100      	bne.n	c0de080e <handle_provide_parameter+0x176>
c0de080c:	e091      	b.n	c0de0932 <handle_provide_parameter+0x29a>
c0de080e:	2805      	cmp	r0, #5
c0de0810:	d106      	bne.n	c0de0820 <handle_provide_parameter+0x188>
c0de0812:	4628      	mov	r0, r5
c0de0814:	4631      	mov	r1, r6
c0de0816:	4614      	mov	r4, r2
c0de0818:	f000 f9a0 	bl	c0de0b5c <handle_beneficiary>
c0de081c:	2003      	movs	r0, #3
c0de081e:	e03c      	b.n	c0de089a <handle_provide_parameter+0x202>
c0de0820:	4851      	ldr	r0, [pc, #324]	; (c0de0968 <handle_provide_parameter+0x2d0>)
c0de0822:	4478      	add	r0, pc
c0de0824:	f000 fe74 	bl	c0de1510 <mcu_usb_printf>
c0de0828:	e003      	b.n	c0de0832 <handle_provide_parameter+0x19a>
                PRINTF("Selector Index %d not supported\n", context->selectorIndex);
c0de082a:	4854      	ldr	r0, [pc, #336]	; (c0de097c <handle_provide_parameter+0x2e4>)
c0de082c:	4478      	add	r0, pc
c0de082e:	f000 fe6f 	bl	c0de1510 <mcu_usb_printf>
c0de0832:	2000      	movs	r0, #0
c0de0834:	7528      	strb	r0, [r5, #20]
c0de0836:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            handle_beneficiary(msg, context);
c0de0838:	4628      	mov	r0, r5
c0de083a:	4631      	mov	r1, r6
c0de083c:	4614      	mov	r4, r2
c0de083e:	f000 f98d 	bl	c0de0b5c <handle_beneficiary>
c0de0842:	e7ba      	b.n	c0de07ba <handle_provide_parameter+0x122>
            handle_token_received(msg, context);
c0de0844:	4628      	mov	r0, r5
c0de0846:	4631      	mov	r1, r6
c0de0848:	4614      	mov	r4, r2
c0de084a:	f000 f91d 	bl	c0de0a88 <handle_token_received>
c0de084e:	2003      	movs	r0, #3
c0de0850:	e7b4      	b.n	c0de07bc <handle_provide_parameter+0x124>
            PRINTF("Counter: %d\n", context->counter);
c0de0852:	7911      	ldrb	r1, [r2, #4]
c0de0854:	4845      	ldr	r0, [pc, #276]	; (c0de096c <handle_provide_parameter+0x2d4>)
c0de0856:	4478      	add	r0, pc
c0de0858:	4617      	mov	r7, r2
c0de085a:	f000 fe59 	bl	c0de1510 <mcu_usb_printf>
            context->counter += 1;
c0de085e:	7938      	ldrb	r0, [r7, #4]
c0de0860:	9000      	str	r0, [sp, #0]
c0de0862:	1c40      	adds	r0, r0, #1
c0de0864:	7138      	strb	r0, [r7, #4]
            if (memcmp(&msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH], NULL_ETH_ADDRESS, ADDRESS_LENGTH) == 0) {
c0de0866:	6820      	ldr	r0, [r4, #0]
c0de0868:	300c      	adds	r0, #12
c0de086a:	4941      	ldr	r1, [pc, #260]	; (c0de0970 <handle_provide_parameter+0x2d8>)
c0de086c:	4479      	add	r1, pc
c0de086e:	2214      	movs	r2, #20
c0de0870:	f001 fa04 	bl	c0de1c7c <memcmp>
c0de0874:	2800      	cmp	r0, #0
c0de0876:	d06a      	beq.n	c0de094e <handle_provide_parameter+0x2b6>
                handle_token_received(msg, context);
c0de0878:	4628      	mov	r0, r5
c0de087a:	4631      	mov	r1, r6
c0de087c:	f000 f904 	bl	c0de0a88 <handle_token_received>
c0de0880:	2001      	movs	r0, #1
                context->next_param = TOKEN_RECEIVED;
c0de0882:	70f8      	strb	r0, [r7, #3]
c0de0884:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de0886:	6821      	ldr	r1, [r4, #0]
c0de0888:	e789      	b.n	c0de079e <handle_provide_parameter+0x106>
    memcpy(context->min_amount_received, msg->parameter, PARAMETER_LENGTH);
c0de088a:	6821      	ldr	r1, [r4, #0]
c0de088c:	e78f      	b.n	c0de07ae <handle_provide_parameter+0x116>
            handle_token_received(msg, context);
c0de088e:	4628      	mov	r0, r5
c0de0890:	4631      	mov	r1, r6
c0de0892:	4614      	mov	r4, r2
c0de0894:	f000 f8f8 	bl	c0de0a88 <handle_token_received>
c0de0898:	2005      	movs	r0, #5
c0de089a:	70e0      	strb	r0, [r4, #3]
c0de089c:	7820      	ldrb	r0, [r4, #0]
c0de089e:	1c40      	adds	r0, r0, #1
c0de08a0:	7020      	strb	r0, [r4, #0]
c0de08a2:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            memcpy(context->contract_address_sent, msg->parameter, ADDRESS_LENGTH);
c0de08a4:	6819      	ldr	r1, [r3, #0]
c0de08a6:	3640      	adds	r6, #64	; 0x40
c0de08a8:	2514      	movs	r5, #20
c0de08aa:	4630      	mov	r0, r6
c0de08ac:	4617      	mov	r7, r2
c0de08ae:	462a      	mov	r2, r5
c0de08b0:	f001 f9d4 	bl	c0de1c5c <__aeabi_memcpy>
            printf_hex_array("TOKEN_SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
c0de08b4:	4830      	ldr	r0, [pc, #192]	; (c0de0978 <handle_provide_parameter+0x2e0>)
c0de08b6:	4478      	add	r0, pc
c0de08b8:	4629      	mov	r1, r5
c0de08ba:	4632      	mov	r2, r6
c0de08bc:	f000 f860 	bl	c0de0980 <printf_hex_array>
c0de08c0:	2001      	movs	r0, #1
            context->next_param = TOKEN_RECEIVED;
c0de08c2:	70f8      	strb	r0, [r7, #3]
            context->skip = (context->offset - ADDRESS_LENGTH) / 32 - 1;
c0de08c4:	8820      	ldrh	r0, [r4, #0]
c0de08c6:	3814      	subs	r0, #20
c0de08c8:	0ec1      	lsrs	r1, r0, #27
c0de08ca:	1840      	adds	r0, r0, r1
c0de08cc:	0940      	lsrs	r0, r0, #5
c0de08ce:	1e40      	subs	r0, r0, #1
c0de08d0:	e043      	b.n	c0de095a <handle_provide_parameter+0x2c2>
            memcpy(&context->contract_address_received[0], &msg->parameter[(context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH], ADDRESS_LENGTH);
c0de08d2:	8820      	ldrh	r0, [r4, #0]
c0de08d4:	3814      	subs	r0, #20
c0de08d6:	0ec1      	lsrs	r1, r0, #27
c0de08d8:	1841      	adds	r1, r0, r1
c0de08da:	4614      	mov	r4, r2
c0de08dc:	221f      	movs	r2, #31
c0de08de:	4391      	bics	r1, r2
c0de08e0:	1a40      	subs	r0, r0, r1
c0de08e2:	6819      	ldr	r1, [r3, #0]
c0de08e4:	1809      	adds	r1, r1, r0
c0de08e6:	3654      	adds	r6, #84	; 0x54
c0de08e8:	2214      	movs	r2, #20
c0de08ea:	4630      	mov	r0, r6
c0de08ec:	f001 f9b6 	bl	c0de1c5c <__aeabi_memcpy>
c0de08f0:	2002      	movs	r0, #2
c0de08f2:	e763      	b.n	c0de07bc <handle_provide_parameter+0x124>
            memcpy(&context->contract_address_received[PARAMETER_LENGTH - (context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH], &msg->parameter[0], (context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH + ADDRESS_LENGTH - PARAMETER_LENGTH);
c0de08f4:	8820      	ldrh	r0, [r4, #0]
c0de08f6:	3814      	subs	r0, #20
c0de08f8:	0ec1      	lsrs	r1, r0, #27
c0de08fa:	1841      	adds	r1, r0, r1
c0de08fc:	4614      	mov	r4, r2
c0de08fe:	221f      	movs	r2, #31
c0de0900:	4391      	bics	r1, r2
c0de0902:	1a42      	subs	r2, r0, r1
c0de0904:	1ab0      	subs	r0, r6, r2
c0de0906:	3a0c      	subs	r2, #12
c0de0908:	3074      	adds	r0, #116	; 0x74
c0de090a:	6819      	ldr	r1, [r3, #0]
c0de090c:	e753      	b.n	c0de07b6 <handle_provide_parameter+0x11e>
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de090e:	6819      	ldr	r1, [r3, #0]
c0de0910:	2220      	movs	r2, #32
c0de0912:	4630      	mov	r0, r6
c0de0914:	f001 f9a2 	bl	c0de1c5c <__aeabi_memcpy>
            context->next_param = MIN_AMOUNT_RECEIVED;
c0de0918:	9800      	ldr	r0, [sp, #0]
c0de091a:	70c7      	strb	r7, [r0, #3]
c0de091c:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    memcpy(context->min_amount_received, msg->parameter, PARAMETER_LENGTH);
c0de091e:	6819      	ldr	r1, [r3, #0]
c0de0920:	3620      	adds	r6, #32
c0de0922:	2220      	movs	r2, #32
c0de0924:	4630      	mov	r0, r6
c0de0926:	f001 f999 	bl	c0de1c5c <__aeabi_memcpy>
c0de092a:	2006      	movs	r0, #6
            context->next_param = PATH_LENGTH;
c0de092c:	9900      	ldr	r1, [sp, #0]
c0de092e:	70c8      	strb	r0, [r1, #3]
c0de0930:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            context->offset = U2BE(msg->parameter, PARAMETER_LENGTH - sizeof(context->offset));
c0de0932:	6818      	ldr	r0, [r3, #0]
  return (buf[off] << 8) | buf[off + 1];
c0de0934:	7fc1      	ldrb	r1, [r0, #31]
c0de0936:	7f80      	ldrb	r0, [r0, #30]
c0de0938:	0200      	lsls	r0, r0, #8
c0de093a:	1840      	adds	r0, r0, r1
c0de093c:	8020      	strh	r0, [r4, #0]
            PRINTF("OFFSET: %d\n", context->offset);
c0de093e:	b281      	uxth	r1, r0
c0de0940:	480c      	ldr	r0, [pc, #48]	; (c0de0974 <handle_provide_parameter+0x2dc>)
c0de0942:	4478      	add	r0, pc
c0de0944:	4614      	mov	r4, r2
c0de0946:	f000 fde3 	bl	c0de1510 <mcu_usb_printf>
c0de094a:	2000      	movs	r0, #0
c0de094c:	e736      	b.n	c0de07bc <handle_provide_parameter+0x124>
c0de094e:	2003      	movs	r0, #3
                context->next_param = AMOUNT_SENT;
c0de0950:	5238      	strh	r0, [r7, r0]
                context->skip += 20 - context->counter;
c0de0952:	7838      	ldrb	r0, [r7, #0]
c0de0954:	9900      	ldr	r1, [sp, #0]
c0de0956:	1a40      	subs	r0, r0, r1
c0de0958:	3013      	adds	r0, #19
c0de095a:	7038      	strb	r0, [r7, #0]
c0de095c:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de095e:	46c0      	nop			; (mov r8, r8)
c0de0960:	000019f8 	.word	0x000019f8
c0de0964:	00001aa0 	.word	0x00001aa0
c0de0968:	0000189a 	.word	0x0000189a
c0de096c:	00001917 	.word	0x00001917
c0de0970:	00001c14 	.word	0x00001c14
c0de0974:	00001811 	.word	0x00001811
c0de0978:	0000192e 	.word	0x0000192e
c0de097c:	00001b00 	.word	0x00001b00

c0de0980 <printf_hex_array>:
                                    const uint8_t *data __attribute__((unused))) {
c0de0980:	b570      	push	{r4, r5, r6, lr}
c0de0982:	4614      	mov	r4, r2
c0de0984:	460d      	mov	r5, r1
    PRINTF(title);
c0de0986:	f000 fdc3 	bl	c0de1510 <mcu_usb_printf>
c0de098a:	4e08      	ldr	r6, [pc, #32]	; (c0de09ac <printf_hex_array+0x2c>)
c0de098c:	447e      	add	r6, pc
    for (size_t i = 0; i < len; ++i) {
c0de098e:	2d00      	cmp	r5, #0
c0de0990:	d006      	beq.n	c0de09a0 <printf_hex_array+0x20>
        PRINTF("%02x", data[i]);
c0de0992:	7821      	ldrb	r1, [r4, #0]
c0de0994:	4630      	mov	r0, r6
c0de0996:	f000 fdbb 	bl	c0de1510 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de099a:	1c64      	adds	r4, r4, #1
c0de099c:	1e6d      	subs	r5, r5, #1
c0de099e:	e7f6      	b.n	c0de098e <printf_hex_array+0xe>
    PRINTF("\n");
c0de09a0:	4803      	ldr	r0, [pc, #12]	; (c0de09b0 <printf_hex_array+0x30>)
c0de09a2:	4478      	add	r0, pc
c0de09a4:	f000 fdb4 	bl	c0de1510 <mcu_usb_printf>
c0de09a8:	bd70      	pop	{r4, r5, r6, pc}
c0de09aa:	46c0      	nop			; (mov r8, r8)
c0de09ac:	0000177e 	.word	0x0000177e
c0de09b0:	000018db 	.word	0x000018db

c0de09b4 <handle_token_sent>:
static void handle_token_sent(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
c0de09b4:	b570      	push	{r4, r5, r6, lr}
c0de09b6:	460e      	mov	r6, r1
c0de09b8:	4605      	mov	r5, r0
    memset(context->contract_address_sent, 0, sizeof(context->contract_address_sent));
c0de09ba:	460c      	mov	r4, r1
c0de09bc:	3440      	adds	r4, #64	; 0x40
c0de09be:	2114      	movs	r1, #20
c0de09c0:	4620      	mov	r0, r4
c0de09c2:	f001 f945 	bl	c0de1c50 <__aeabi_memclr>
c0de09c6:	209c      	movs	r0, #156	; 0x9c
    if (context->selectorIndex == CURVE_POOL_EXCHANGE || context->selectorIndex == CURVE_POOL_EXCHANGE_UNDERLYING) {
c0de09c8:	5c30      	ldrb	r0, [r6, r0]
c0de09ca:	21fe      	movs	r1, #254	; 0xfe
c0de09cc:	4001      	ands	r1, r0
c0de09ce:	2904      	cmp	r1, #4
c0de09d0:	d11f      	bne.n	c0de0a12 <handle_token_sent+0x5e>
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de09d2:	6868      	ldr	r0, [r5, #4]
c0de09d4:	6806      	ldr	r6, [r0, #0]
c0de09d6:	36a5      	adds	r6, #165	; 0xa5
c0de09d8:	4821      	ldr	r0, [pc, #132]	; (c0de0a60 <handle_token_sent+0xac>)
c0de09da:	4478      	add	r0, pc
c0de09dc:	2214      	movs	r2, #20
c0de09de:	4631      	mov	r1, r6
c0de09e0:	f001 f94c 	bl	c0de1c7c <memcmp>
c0de09e4:	2800      	cmp	r0, #0
c0de09e6:	d021      	beq.n	c0de0a2c <handle_token_sent+0x78>
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de09e8:	4820      	ldr	r0, [pc, #128]	; (c0de0a6c <handle_token_sent+0xb8>)
c0de09ea:	4478      	add	r0, pc
c0de09ec:	2214      	movs	r2, #20
c0de09ee:	4631      	mov	r1, r6
c0de09f0:	f001 f944 	bl	c0de1c7c <memcmp>
c0de09f4:	2800      	cmp	r0, #0
c0de09f6:	d112      	bne.n	c0de0a1e <handle_token_sent+0x6a>
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de09f8:	68e8      	ldr	r0, [r5, #12]
c0de09fa:	7fc0      	ldrb	r0, [r0, #31]
c0de09fc:	2803      	cmp	r0, #3
c0de09fe:	d026      	beq.n	c0de0a4e <handle_token_sent+0x9a>
c0de0a00:	2801      	cmp	r0, #1
c0de0a02:	d027      	beq.n	c0de0a54 <handle_token_sent+0xa0>
c0de0a04:	2802      	cmp	r0, #2
c0de0a06:	d028      	beq.n	c0de0a5a <handle_token_sent+0xa6>
c0de0a08:	2800      	cmp	r0, #0
c0de0a0a:	d118      	bne.n	c0de0a3e <handle_token_sent+0x8a>
                    memcpy(context->contract_address_sent, OUSD_ADDRESS, ADDRESS_LENGTH);
c0de0a0c:	4918      	ldr	r1, [pc, #96]	; (c0de0a70 <handle_token_sent+0xbc>)
c0de0a0e:	4479      	add	r1, pc
c0de0a10:	e001      	b.n	c0de0a16 <handle_token_sent+0x62>
            &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de0a12:	68e9      	ldr	r1, [r5, #12]
c0de0a14:	310c      	adds	r1, #12
c0de0a16:	2214      	movs	r2, #20
c0de0a18:	4620      	mov	r0, r4
c0de0a1a:	f001 f91f 	bl	c0de1c5c <__aeabi_memcpy>
    printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
c0de0a1e:	4819      	ldr	r0, [pc, #100]	; (c0de0a84 <handle_token_sent+0xd0>)
c0de0a20:	4478      	add	r0, pc
c0de0a22:	2114      	movs	r1, #20
c0de0a24:	4622      	mov	r2, r4
c0de0a26:	f7ff ffab 	bl	c0de0980 <printf_hex_array>
}
c0de0a2a:	bd70      	pop	{r4, r5, r6, pc}
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de0a2c:	68e8      	ldr	r0, [r5, #12]
c0de0a2e:	7fc0      	ldrb	r0, [r0, #31]
c0de0a30:	2801      	cmp	r0, #1
c0de0a32:	d009      	beq.n	c0de0a48 <handle_token_sent+0x94>
c0de0a34:	2800      	cmp	r0, #0
c0de0a36:	d102      	bne.n	c0de0a3e <handle_token_sent+0x8a>
                    memcpy(context->contract_address_sent,
c0de0a38:	490a      	ldr	r1, [pc, #40]	; (c0de0a64 <handle_token_sent+0xb0>)
c0de0a3a:	4479      	add	r1, pc
c0de0a3c:	e7eb      	b.n	c0de0a16 <handle_token_sent+0x62>
c0de0a3e:	4810      	ldr	r0, [pc, #64]	; (c0de0a80 <handle_token_sent+0xcc>)
c0de0a40:	4478      	add	r0, pc
c0de0a42:	f000 fd65 	bl	c0de1510 <mcu_usb_printf>
c0de0a46:	e7ea      	b.n	c0de0a1e <handle_token_sent+0x6a>
                    memcpy(context->contract_address_sent,
c0de0a48:	4907      	ldr	r1, [pc, #28]	; (c0de0a68 <handle_token_sent+0xb4>)
c0de0a4a:	4479      	add	r1, pc
c0de0a4c:	e7e3      	b.n	c0de0a16 <handle_token_sent+0x62>
                    memcpy(context->contract_address_sent, USDT_ADDRESS, ADDRESS_LENGTH);
c0de0a4e:	490b      	ldr	r1, [pc, #44]	; (c0de0a7c <handle_token_sent+0xc8>)
c0de0a50:	4479      	add	r1, pc
c0de0a52:	e7e0      	b.n	c0de0a16 <handle_token_sent+0x62>
                    memcpy(context->contract_address_sent, DAI_ADDRESS, ADDRESS_LENGTH);
c0de0a54:	4907      	ldr	r1, [pc, #28]	; (c0de0a74 <handle_token_sent+0xc0>)
c0de0a56:	4479      	add	r1, pc
c0de0a58:	e7dd      	b.n	c0de0a16 <handle_token_sent+0x62>
                    memcpy(context->contract_address_sent, USDC_ADDRESS, ADDRESS_LENGTH);
c0de0a5a:	4907      	ldr	r1, [pc, #28]	; (c0de0a78 <handle_token_sent+0xc4>)
c0de0a5c:	4479      	add	r1, pc
c0de0a5e:	e7da      	b.n	c0de0a16 <handle_token_sent+0x62>
c0de0a60:	00001a5e 	.word	0x00001a5e
c0de0a64:	00001a46 	.word	0x00001a46
c0de0a68:	00001962 	.word	0x00001962
c0de0a6c:	00001a62 	.word	0x00001a62
c0de0a70:	000019b2 	.word	0x000019b2
c0de0a74:	0000197e 	.word	0x0000197e
c0de0a78:	0000198c 	.word	0x0000198c
c0de0a7c:	000019ac 	.word	0x000019ac
c0de0a80:	0000167c 	.word	0x0000167c
c0de0a84:	000016b1 	.word	0x000016b1

c0de0a88 <handle_token_received>:
                                  origin_defi_parameters_t *context) {
c0de0a88:	b570      	push	{r4, r5, r6, lr}
c0de0a8a:	460e      	mov	r6, r1
c0de0a8c:	4605      	mov	r5, r0
    memset(context->contract_address_received, 0, sizeof(context->contract_address_received));
c0de0a8e:	460c      	mov	r4, r1
c0de0a90:	3454      	adds	r4, #84	; 0x54
c0de0a92:	2114      	movs	r1, #20
c0de0a94:	4620      	mov	r0, r4
c0de0a96:	f001 f8db 	bl	c0de1c50 <__aeabi_memclr>
c0de0a9a:	209c      	movs	r0, #156	; 0x9c
    if (context->selectorIndex == CURVE_POOL_EXCHANGE || context->selectorIndex == CURVE_POOL_EXCHANGE_UNDERLYING) {
c0de0a9c:	5c30      	ldrb	r0, [r6, r0]
c0de0a9e:	21fe      	movs	r1, #254	; 0xfe
c0de0aa0:	4001      	ands	r1, r0
c0de0aa2:	2904      	cmp	r1, #4
c0de0aa4:	d11f      	bne.n	c0de0ae6 <handle_token_received+0x5e>
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0aa6:	6868      	ldr	r0, [r5, #4]
c0de0aa8:	6806      	ldr	r6, [r0, #0]
c0de0aaa:	36a5      	adds	r6, #165	; 0xa5
c0de0aac:	4821      	ldr	r0, [pc, #132]	; (c0de0b34 <handle_token_received+0xac>)
c0de0aae:	4478      	add	r0, pc
c0de0ab0:	2214      	movs	r2, #20
c0de0ab2:	4631      	mov	r1, r6
c0de0ab4:	f001 f8e2 	bl	c0de1c7c <memcmp>
c0de0ab8:	2800      	cmp	r0, #0
c0de0aba:	d021      	beq.n	c0de0b00 <handle_token_received+0x78>
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0abc:	4820      	ldr	r0, [pc, #128]	; (c0de0b40 <handle_token_received+0xb8>)
c0de0abe:	4478      	add	r0, pc
c0de0ac0:	2214      	movs	r2, #20
c0de0ac2:	4631      	mov	r1, r6
c0de0ac4:	f001 f8da 	bl	c0de1c7c <memcmp>
c0de0ac8:	2800      	cmp	r0, #0
c0de0aca:	d112      	bne.n	c0de0af2 <handle_token_received+0x6a>
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de0acc:	68e8      	ldr	r0, [r5, #12]
c0de0ace:	7fc0      	ldrb	r0, [r0, #31]
c0de0ad0:	2803      	cmp	r0, #3
c0de0ad2:	d026      	beq.n	c0de0b22 <handle_token_received+0x9a>
c0de0ad4:	2801      	cmp	r0, #1
c0de0ad6:	d027      	beq.n	c0de0b28 <handle_token_received+0xa0>
c0de0ad8:	2802      	cmp	r0, #2
c0de0ada:	d028      	beq.n	c0de0b2e <handle_token_received+0xa6>
c0de0adc:	2800      	cmp	r0, #0
c0de0ade:	d118      	bne.n	c0de0b12 <handle_token_received+0x8a>
                    memcpy(context->contract_address_received, OUSD_ADDRESS, ADDRESS_LENGTH);
c0de0ae0:	4918      	ldr	r1, [pc, #96]	; (c0de0b44 <handle_token_received+0xbc>)
c0de0ae2:	4479      	add	r1, pc
c0de0ae4:	e001      	b.n	c0de0aea <handle_token_received+0x62>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de0ae6:	68e9      	ldr	r1, [r5, #12]
c0de0ae8:	310c      	adds	r1, #12
c0de0aea:	2214      	movs	r2, #20
c0de0aec:	4620      	mov	r0, r4
c0de0aee:	f001 f8b5 	bl	c0de1c5c <__aeabi_memcpy>
    printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH, context->contract_address_received);
c0de0af2:	4819      	ldr	r0, [pc, #100]	; (c0de0b58 <handle_token_received+0xd0>)
c0de0af4:	4478      	add	r0, pc
c0de0af6:	2114      	movs	r1, #20
c0de0af8:	4622      	mov	r2, r4
c0de0afa:	f7ff ff41 	bl	c0de0980 <printf_hex_array>
}
c0de0afe:	bd70      	pop	{r4, r5, r6, pc}
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de0b00:	68e8      	ldr	r0, [r5, #12]
c0de0b02:	7fc0      	ldrb	r0, [r0, #31]
c0de0b04:	2801      	cmp	r0, #1
c0de0b06:	d009      	beq.n	c0de0b1c <handle_token_received+0x94>
c0de0b08:	2800      	cmp	r0, #0
c0de0b0a:	d102      	bne.n	c0de0b12 <handle_token_received+0x8a>
                    memcpy(context->contract_address_received, NULL_ETH_ADDRESS, ADDRESS_LENGTH);
c0de0b0c:	490a      	ldr	r1, [pc, #40]	; (c0de0b38 <handle_token_received+0xb0>)
c0de0b0e:	4479      	add	r1, pc
c0de0b10:	e7eb      	b.n	c0de0aea <handle_token_received+0x62>
c0de0b12:	4810      	ldr	r0, [pc, #64]	; (c0de0b54 <handle_token_received+0xcc>)
c0de0b14:	4478      	add	r0, pc
c0de0b16:	f000 fcfb 	bl	c0de1510 <mcu_usb_printf>
c0de0b1a:	e7ea      	b.n	c0de0af2 <handle_token_received+0x6a>
                    memcpy(context->contract_address_received, OETH_ADDRESS, ADDRESS_LENGTH);
c0de0b1c:	4907      	ldr	r1, [pc, #28]	; (c0de0b3c <handle_token_received+0xb4>)
c0de0b1e:	4479      	add	r1, pc
c0de0b20:	e7e3      	b.n	c0de0aea <handle_token_received+0x62>
                    memcpy(context->contract_address_received, USDT_ADDRESS, ADDRESS_LENGTH);
c0de0b22:	490b      	ldr	r1, [pc, #44]	; (c0de0b50 <handle_token_received+0xc8>)
c0de0b24:	4479      	add	r1, pc
c0de0b26:	e7e0      	b.n	c0de0aea <handle_token_received+0x62>
                    memcpy(context->contract_address_received, DAI_ADDRESS, ADDRESS_LENGTH);
c0de0b28:	4907      	ldr	r1, [pc, #28]	; (c0de0b48 <handle_token_received+0xc0>)
c0de0b2a:	4479      	add	r1, pc
c0de0b2c:	e7dd      	b.n	c0de0aea <handle_token_received+0x62>
                    memcpy(context->contract_address_received, USDC_ADDRESS, ADDRESS_LENGTH);
c0de0b2e:	4907      	ldr	r1, [pc, #28]	; (c0de0b4c <handle_token_received+0xc4>)
c0de0b30:	4479      	add	r1, pc
c0de0b32:	e7da      	b.n	c0de0aea <handle_token_received+0x62>
c0de0b34:	0000198a 	.word	0x0000198a
c0de0b38:	00001972 	.word	0x00001972
c0de0b3c:	0000188e 	.word	0x0000188e
c0de0b40:	0000198e 	.word	0x0000198e
c0de0b44:	000018de 	.word	0x000018de
c0de0b48:	000018aa 	.word	0x000018aa
c0de0b4c:	000018b8 	.word	0x000018b8
c0de0b50:	000018d8 	.word	0x000018d8
c0de0b54:	000015a8 	.word	0x000015a8
c0de0b58:	00001628 	.word	0x00001628

c0de0b5c <handle_beneficiary>:
static void handle_beneficiary(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
c0de0b5c:	b570      	push	{r4, r5, r6, lr}
c0de0b5e:	460c      	mov	r4, r1
c0de0b60:	4606      	mov	r6, r0
    memset(context->beneficiary, 0, sizeof(context->beneficiary));
c0de0b62:	3468      	adds	r4, #104	; 0x68
c0de0b64:	2514      	movs	r5, #20
c0de0b66:	4620      	mov	r0, r4
c0de0b68:	4629      	mov	r1, r5
c0de0b6a:	f001 f871 	bl	c0de1c50 <__aeabi_memclr>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de0b6e:	68f1      	ldr	r1, [r6, #12]
c0de0b70:	310c      	adds	r1, #12
    memcpy(context->beneficiary,
c0de0b72:	4620      	mov	r0, r4
c0de0b74:	462a      	mov	r2, r5
c0de0b76:	f001 f871 	bl	c0de1c5c <__aeabi_memcpy>
    printf_hex_array("BENEFICIARY: ", ADDRESS_LENGTH, context->beneficiary);
c0de0b7a:	4803      	ldr	r0, [pc, #12]	; (c0de0b88 <handle_beneficiary+0x2c>)
c0de0b7c:	4478      	add	r0, pc
c0de0b7e:	4629      	mov	r1, r5
c0de0b80:	4622      	mov	r2, r4
c0de0b82:	f7ff fefd 	bl	c0de0980 <printf_hex_array>
}
c0de0b86:	bd70      	pop	{r4, r5, r6, pc}
c0de0b88:	000015fe 	.word	0x000015fe

c0de0b8c <handle_provide_token>:
#include "origin_defi_plugin.h"

// EDIT THIS: Adapt this function to your needs! Remember, the information for tokens are held in
// `msg->token1` and `msg->token2`. If those pointers are `NULL`, this means the ethereum app didn't
// find any info regarding the requested tokens!
void handle_provide_token(void *parameters) {
c0de0b8c:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de0b8e:	4604      	mov	r4, r0
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0b90:	6885      	ldr	r5, [r0, #8]
    PRINTF("OETH plugin provide token: 0x%p, 0x%p\n", msg->item1, msg->item2);
c0de0b92:	68c1      	ldr	r1, [r0, #12]
c0de0b94:	6902      	ldr	r2, [r0, #16]
c0de0b96:	485c      	ldr	r0, [pc, #368]	; (c0de0d08 <handle_provide_token+0x17c>)
c0de0b98:	4478      	add	r0, pc
c0de0b9a:	f000 fcb9 	bl	c0de1510 <mcu_usb_printf>
    if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de0b9e:	462e      	mov	r6, r5
c0de0ba0:	3640      	adds	r6, #64	; 0x40
c0de0ba2:	495a      	ldr	r1, [pc, #360]	; (c0de0d0c <handle_provide_token+0x180>)
c0de0ba4:	4479      	add	r1, pc
c0de0ba6:	2214      	movs	r2, #20
c0de0ba8:	4630      	mov	r0, r6
c0de0baa:	f001 f867 	bl	c0de1c7c <memcmp>
c0de0bae:	462f      	mov	r7, r5
c0de0bb0:	3792      	adds	r7, #146	; 0x92
c0de0bb2:	2800      	cmp	r0, #0
c0de0bb4:	d033      	beq.n	c0de0c1e <handle_provide_token+0x92>
    } else if (ADDRESS_IS_OUSD(context->contract_address_sent)) {
c0de0bb6:	4956      	ldr	r1, [pc, #344]	; (c0de0d10 <handle_provide_token+0x184>)
c0de0bb8:	4479      	add	r1, pc
c0de0bba:	2214      	movs	r2, #20
c0de0bbc:	4630      	mov	r0, r6
c0de0bbe:	f001 f85d 	bl	c0de1c7c <memcmp>
c0de0bc2:	2800      	cmp	r0, #0
c0de0bc4:	d02b      	beq.n	c0de0c1e <handle_provide_token+0x92>
    } else if (ADDRESS_IS_DAI(context->contract_address_sent)) {
c0de0bc6:	4953      	ldr	r1, [pc, #332]	; (c0de0d14 <handle_provide_token+0x188>)
c0de0bc8:	4479      	add	r1, pc
c0de0bca:	2214      	movs	r2, #20
c0de0bcc:	4630      	mov	r0, r6
c0de0bce:	f001 f855 	bl	c0de1c7c <memcmp>
c0de0bd2:	2800      	cmp	r0, #0
c0de0bd4:	d023      	beq.n	c0de0c1e <handle_provide_token+0x92>
    } else if (ADDRESS_IS_USDC(context->contract_address_sent)) {
c0de0bd6:	4950      	ldr	r1, [pc, #320]	; (c0de0d18 <handle_provide_token+0x18c>)
c0de0bd8:	4479      	add	r1, pc
c0de0bda:	2214      	movs	r2, #20
c0de0bdc:	4630      	mov	r0, r6
c0de0bde:	f001 f84d 	bl	c0de1c7c <memcmp>
c0de0be2:	2800      	cmp	r0, #0
c0de0be4:	d068      	beq.n	c0de0cb8 <handle_provide_token+0x12c>
    } else if (ADDRESS_IS_USDT(context->contract_address_sent)) {
c0de0be6:	494d      	ldr	r1, [pc, #308]	; (c0de0d1c <handle_provide_token+0x190>)
c0de0be8:	4479      	add	r1, pc
c0de0bea:	2214      	movs	r2, #20
c0de0bec:	4630      	mov	r0, r6
c0de0bee:	f001 f845 	bl	c0de1c7c <memcmp>
c0de0bf2:	2800      	cmp	r0, #0
c0de0bf4:	d060      	beq.n	c0de0cb8 <handle_provide_token+0x12c>
    if (!check_token_sent(context)) {
        if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0bf6:	494a      	ldr	r1, [pc, #296]	; (c0de0d20 <handle_provide_token+0x194>)
c0de0bf8:	4479      	add	r1, pc
c0de0bfa:	2214      	movs	r2, #20
c0de0bfc:	4630      	mov	r0, r6
c0de0bfe:	f001 f83d 	bl	c0de1c7c <memcmp>
c0de0c02:	2800      	cmp	r0, #0
c0de0c04:	d00b      	beq.n	c0de0c1e <handle_provide_token+0x92>
            sent_network_token(context);
        } else if (msg->item1 != NULL) {
c0de0c06:	68e1      	ldr	r1, [r4, #12]
c0de0c08:	2900      	cmp	r1, #0
c0de0c0a:	d059      	beq.n	c0de0cc0 <handle_provide_token+0x134>
            context->decimals_sent = msg->item1->token.decimals;
c0de0c0c:	7fc8      	ldrb	r0, [r1, #31]
c0de0c0e:	7078      	strb	r0, [r7, #1]
            strlcpy(context->ticker_sent,
c0de0c10:	4628      	mov	r0, r5
c0de0c12:	307c      	adds	r0, #124	; 0x7c
            context->decimals_sent = msg->item1->token.decimals;
c0de0c14:	3114      	adds	r1, #20
c0de0c16:	220b      	movs	r2, #11
            strlcpy(context->ticker_sent,
c0de0c18:	f001 f9ac 	bl	c0de1f74 <strlcpy>
c0de0c1c:	e001      	b.n	c0de0c22 <handle_provide_token+0x96>
c0de0c1e:	2012      	movs	r0, #18
c0de0c20:	7078      	strb	r0, [r7, #1]
c0de0c22:	7838      	ldrb	r0, [r7, #0]
c0de0c24:	2101      	movs	r1, #1
c0de0c26:	4301      	orrs	r1, r0
c0de0c28:	7039      	strb	r1, [r7, #0]
    if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de0c2a:	462e      	mov	r6, r5
c0de0c2c:	3654      	adds	r6, #84	; 0x54
c0de0c2e:	493e      	ldr	r1, [pc, #248]	; (c0de0d28 <handle_provide_token+0x19c>)
c0de0c30:	4479      	add	r1, pc
c0de0c32:	2214      	movs	r2, #20
c0de0c34:	4630      	mov	r0, r6
c0de0c36:	f001 f821 	bl	c0de1c7c <memcmp>
c0de0c3a:	2800      	cmp	r0, #0
c0de0c3c:	d033      	beq.n	c0de0ca6 <handle_provide_token+0x11a>
    } else if (ADDRESS_IS_OUSD(context->contract_address_received)) {
c0de0c3e:	493b      	ldr	r1, [pc, #236]	; (c0de0d2c <handle_provide_token+0x1a0>)
c0de0c40:	4479      	add	r1, pc
c0de0c42:	2214      	movs	r2, #20
c0de0c44:	4630      	mov	r0, r6
c0de0c46:	f001 f819 	bl	c0de1c7c <memcmp>
c0de0c4a:	2800      	cmp	r0, #0
c0de0c4c:	d02b      	beq.n	c0de0ca6 <handle_provide_token+0x11a>
    } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de0c4e:	4938      	ldr	r1, [pc, #224]	; (c0de0d30 <handle_provide_token+0x1a4>)
c0de0c50:	4479      	add	r1, pc
c0de0c52:	2214      	movs	r2, #20
c0de0c54:	4630      	mov	r0, r6
c0de0c56:	f001 f811 	bl	c0de1c7c <memcmp>
c0de0c5a:	2800      	cmp	r0, #0
c0de0c5c:	d023      	beq.n	c0de0ca6 <handle_provide_token+0x11a>
    } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de0c5e:	4935      	ldr	r1, [pc, #212]	; (c0de0d34 <handle_provide_token+0x1a8>)
c0de0c60:	4479      	add	r1, pc
c0de0c62:	2214      	movs	r2, #20
c0de0c64:	4630      	mov	r0, r6
c0de0c66:	f001 f809 	bl	c0de1c7c <memcmp>
c0de0c6a:	2800      	cmp	r0, #0
c0de0c6c:	d026      	beq.n	c0de0cbc <handle_provide_token+0x130>
    } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de0c6e:	4932      	ldr	r1, [pc, #200]	; (c0de0d38 <handle_provide_token+0x1ac>)
c0de0c70:	4479      	add	r1, pc
c0de0c72:	2214      	movs	r2, #20
c0de0c74:	4630      	mov	r0, r6
c0de0c76:	f001 f801 	bl	c0de1c7c <memcmp>
c0de0c7a:	2800      	cmp	r0, #0
c0de0c7c:	d01e      	beq.n	c0de0cbc <handle_provide_token+0x130>
            msg->additionalScreens++;
        }
    }

    if (!check_token_received(context)) {
        if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0c7e:	492f      	ldr	r1, [pc, #188]	; (c0de0d3c <handle_provide_token+0x1b0>)
c0de0c80:	4479      	add	r1, pc
c0de0c82:	2214      	movs	r2, #20
c0de0c84:	4630      	mov	r0, r6
c0de0c86:	f000 fff9 	bl	c0de1c7c <memcmp>
c0de0c8a:	2800      	cmp	r0, #0
c0de0c8c:	d00b      	beq.n	c0de0ca6 <handle_provide_token+0x11a>
            received_network_token(context);
        } else if (msg->item2 != NULL) {
c0de0c8e:	6921      	ldr	r1, [r4, #16]
c0de0c90:	2900      	cmp	r1, #0
c0de0c92:	d022      	beq.n	c0de0cda <handle_provide_token+0x14e>
            context->decimals_received = msg->item2->token.decimals;
c0de0c94:	7fc8      	ldrb	r0, [r1, #31]
c0de0c96:	70b8      	strb	r0, [r7, #2]
            strlcpy(context->ticker_received,
c0de0c98:	3587      	adds	r5, #135	; 0x87
            context->decimals_received = msg->item2->token.decimals;
c0de0c9a:	3114      	adds	r1, #20
c0de0c9c:	220b      	movs	r2, #11
            strlcpy(context->ticker_received,
c0de0c9e:	4628      	mov	r0, r5
c0de0ca0:	f001 f968 	bl	c0de1f74 <strlcpy>
c0de0ca4:	e001      	b.n	c0de0caa <handle_provide_token+0x11e>
c0de0ca6:	2012      	movs	r0, #18
c0de0ca8:	70b8      	strb	r0, [r7, #2]
c0de0caa:	7838      	ldrb	r0, [r7, #0]
c0de0cac:	2102      	movs	r1, #2
c0de0cae:	4301      	orrs	r1, r0
c0de0cb0:	7039      	strb	r1, [r7, #0]
c0de0cb2:	2004      	movs	r0, #4
            // // We will need an additional screen to display a warning message.
            msg->additionalScreens++;
        }
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0cb4:	7560      	strb	r0, [r4, #21]
c0de0cb6:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0cb8:	2006      	movs	r0, #6
c0de0cba:	e7b1      	b.n	c0de0c20 <handle_provide_token+0x94>
c0de0cbc:	2006      	movs	r0, #6
c0de0cbe:	e7f3      	b.n	c0de0ca8 <handle_provide_token+0x11c>
c0de0cc0:	2012      	movs	r0, #18
            context->decimals_sent = DEFAULT_DECIMAL;
c0de0cc2:	7078      	strb	r0, [r7, #1]
            strlcpy(context->ticker_sent, DEFAULT_TICKER, sizeof(context->ticker_sent));
c0de0cc4:	4628      	mov	r0, r5
c0de0cc6:	307c      	adds	r0, #124	; 0x7c
c0de0cc8:	4916      	ldr	r1, [pc, #88]	; (c0de0d24 <handle_provide_token+0x198>)
c0de0cca:	4479      	add	r1, pc
c0de0ccc:	220b      	movs	r2, #11
c0de0cce:	f001 f951 	bl	c0de1f74 <strlcpy>
            msg->additionalScreens++;
c0de0cd2:	7d20      	ldrb	r0, [r4, #20]
c0de0cd4:	1c40      	adds	r0, r0, #1
c0de0cd6:	7520      	strb	r0, [r4, #20]
c0de0cd8:	e7a7      	b.n	c0de0c2a <handle_provide_token+0x9e>
c0de0cda:	2012      	movs	r0, #18
c0de0cdc:	70b8      	strb	r0, [r7, #2]
c0de0cde:	3587      	adds	r5, #135	; 0x87
        } else if (context->selectorIndex == VAULT_REDEEM) {
c0de0ce0:	7ab8      	ldrb	r0, [r7, #10]
c0de0ce2:	2803      	cmp	r0, #3
c0de0ce4:	d106      	bne.n	c0de0cf4 <handle_provide_token+0x168>
            strlcpy(context->ticker_received, "UNITS", sizeof(context->ticker_received));
c0de0ce6:	4916      	ldr	r1, [pc, #88]	; (c0de0d40 <handle_provide_token+0x1b4>)
c0de0ce8:	4479      	add	r1, pc
c0de0cea:	220b      	movs	r2, #11
c0de0cec:	4628      	mov	r0, r5
c0de0cee:	f001 f941 	bl	c0de1f74 <strlcpy>
c0de0cf2:	e7de      	b.n	c0de0cb2 <handle_provide_token+0x126>
            strlcpy(context->ticker_received, DEFAULT_TICKER, sizeof(context->ticker_received));
c0de0cf4:	4913      	ldr	r1, [pc, #76]	; (c0de0d44 <handle_provide_token+0x1b8>)
c0de0cf6:	4479      	add	r1, pc
c0de0cf8:	220b      	movs	r2, #11
c0de0cfa:	4628      	mov	r0, r5
c0de0cfc:	f001 f93a 	bl	c0de1f74 <strlcpy>
            msg->additionalScreens++;
c0de0d00:	7d20      	ldrb	r0, [r4, #20]
c0de0d02:	1c40      	adds	r0, r0, #1
c0de0d04:	7520      	strb	r0, [r4, #20]
c0de0d06:	e7d4      	b.n	c0de0cb2 <handle_provide_token+0x126>
c0de0d08:	00001546 	.word	0x00001546
c0de0d0c:	00001808 	.word	0x00001808
c0de0d10:	00001808 	.word	0x00001808
c0de0d14:	0000180c 	.word	0x0000180c
c0de0d18:	00001810 	.word	0x00001810
c0de0d1c:	00001814 	.word	0x00001814
c0de0d20:	00001888 	.word	0x00001888
c0de0d24:	000015ec 	.word	0x000015ec
c0de0d28:	0000177c 	.word	0x0000177c
c0de0d2c:	00001780 	.word	0x00001780
c0de0d30:	00001784 	.word	0x00001784
c0de0d34:	00001788 	.word	0x00001788
c0de0d38:	0000178c 	.word	0x0000178c
c0de0d3c:	00001800 	.word	0x00001800
c0de0d40:	00001614 	.word	0x00001614
c0de0d44:	000015c0 	.word	0x000015c0

c0de0d48 <handle_query_contract_id>:
#include "origin_defi_plugin.h"

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de0d48:	b5b0      	push	{r4, r5, r7, lr}
c0de0d4a:	4604      	mov	r4, r0
    ethQueryContractID_t *msg = (ethQueryContractID_t *) parameters;
    const origin_defi_parameters_t *context = (const origin_defi_parameters_t *) msg->pluginContext;
c0de0d4c:	6885      	ldr	r5, [r0, #8]
    // msg->name will be the upper sentence displayed on the screen.
    // msg->version will be the lower sentence displayed on the screen.

    // For the first screen, display the plugin name.
    strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de0d4e:	68c0      	ldr	r0, [r0, #12]
c0de0d50:	6922      	ldr	r2, [r4, #16]
c0de0d52:	4916      	ldr	r1, [pc, #88]	; (c0de0dac <handle_query_contract_id+0x64>)
c0de0d54:	4479      	add	r1, pc
c0de0d56:	f001 f90d 	bl	c0de1f74 <strlcpy>
c0de0d5a:	209c      	movs	r0, #156	; 0x9c

    switch (context->selectorIndex) {
c0de0d5c:	5c29      	ldrb	r1, [r5, r0]
c0de0d5e:	1f08      	subs	r0, r1, #4
c0de0d60:	280b      	cmp	r0, #11
c0de0d62:	d202      	bcs.n	c0de0d6a <handle_query_contract_id+0x22>
c0de0d64:	4917      	ldr	r1, [pc, #92]	; (c0de0dc4 <handle_query_contract_id+0x7c>)
c0de0d66:	4479      	add	r1, pc
c0de0d68:	e012      	b.n	c0de0d90 <handle_query_contract_id+0x48>
c0de0d6a:	2903      	cmp	r1, #3
c0de0d6c:	d308      	bcc.n	c0de0d80 <handle_query_contract_id+0x38>
c0de0d6e:	2910      	cmp	r1, #16
c0de0d70:	d009      	beq.n	c0de0d86 <handle_query_contract_id+0x3e>
c0de0d72:	290f      	cmp	r1, #15
c0de0d74:	d00a      	beq.n	c0de0d8c <handle_query_contract_id+0x44>
c0de0d76:	2903      	cmp	r1, #3
c0de0d78:	d111      	bne.n	c0de0d9e <handle_query_contract_id+0x56>
c0de0d7a:	490e      	ldr	r1, [pc, #56]	; (c0de0db4 <handle_query_contract_id+0x6c>)
c0de0d7c:	4479      	add	r1, pc
c0de0d7e:	e007      	b.n	c0de0d90 <handle_query_contract_id+0x48>
c0de0d80:	490b      	ldr	r1, [pc, #44]	; (c0de0db0 <handle_query_contract_id+0x68>)
c0de0d82:	4479      	add	r1, pc
c0de0d84:	e004      	b.n	c0de0d90 <handle_query_contract_id+0x48>
c0de0d86:	490d      	ldr	r1, [pc, #52]	; (c0de0dbc <handle_query_contract_id+0x74>)
c0de0d88:	4479      	add	r1, pc
c0de0d8a:	e001      	b.n	c0de0d90 <handle_query_contract_id+0x48>
c0de0d8c:	490a      	ldr	r1, [pc, #40]	; (c0de0db8 <handle_query_contract_id+0x70>)
c0de0d8e:	4479      	add	r1, pc
c0de0d90:	6960      	ldr	r0, [r4, #20]
c0de0d92:	69a2      	ldr	r2, [r4, #24]
c0de0d94:	f001 f8ee 	bl	c0de1f74 <strlcpy>
c0de0d98:	2004      	movs	r0, #4
c0de0d9a:	7720      	strb	r0, [r4, #28]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0d9c:	bdb0      	pop	{r4, r5, r7, pc}
            PRINTF("Selector Index :%d not supported\n", context->selectorIndex);
c0de0d9e:	4808      	ldr	r0, [pc, #32]	; (c0de0dc0 <handle_query_contract_id+0x78>)
c0de0da0:	4478      	add	r0, pc
c0de0da2:	f000 fbb5 	bl	c0de1510 <mcu_usb_printf>
c0de0da6:	2000      	movs	r0, #0
c0de0da8:	e7f7      	b.n	c0de0d9a <handle_query_contract_id+0x52>
c0de0daa:	46c0      	nop			; (mov r8, r8)
c0de0dac:	000013e4 	.word	0x000013e4
c0de0db0:	00001383 	.word	0x00001383
c0de0db4:	000013c8 	.word	0x000013c8
c0de0db8:	000014f1 	.word	0x000014f1
c0de0dbc:	0000157a 	.word	0x0000157a
c0de0dc0:	00001517 	.word	0x00001517
c0de0dc4:	000013a9 	.word	0x000013a9

c0de0dc8 <handle_query_contract_ui>:
            break;
    }
    return ERROR;
}

void handle_query_contract_ui(void *parameters) {
c0de0dc8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0dca:	b087      	sub	sp, #28
c0de0dcc:	4604      	mov	r4, r0
    ethQueryContractUI_t *msg = (ethQueryContractUI_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0dce:	69c5      	ldr	r5, [r0, #28]
    memset(msg->title, 0, msg->titleLength);
c0de0dd0:	9505      	str	r5, [sp, #20]
c0de0dd2:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de0dd4:	6aa1      	ldr	r1, [r4, #40]	; 0x28
c0de0dd6:	f000 ff3b 	bl	c0de1c50 <__aeabi_memclr>
    memset(msg->msg, 0, msg->msgLength);
c0de0dda:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0ddc:	6b21      	ldr	r1, [r4, #48]	; 0x30
c0de0dde:	f000 ff37 	bl	c0de1c50 <__aeabi_memclr>
c0de0de2:	4621      	mov	r1, r4
c0de0de4:	3120      	adds	r1, #32
c0de0de6:	2604      	movs	r6, #4
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0de8:	750e      	strb	r6, [r1, #20]
c0de0dea:	2020      	movs	r0, #32
c0de0dec:	9003      	str	r0, [sp, #12]
    uint8_t index = msg->screenIndex;
c0de0dee:	5c27      	ldrb	r7, [r4, r0]
c0de0df0:	2092      	movs	r0, #146	; 0x92
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0df2:	5c2a      	ldrb	r2, [r5, r0]
c0de0df4:	2003      	movs	r0, #3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0df6:	4613      	mov	r3, r2
c0de0df8:	4003      	ands	r3, r0
c0de0dfa:	3592      	adds	r5, #146	; 0x92
c0de0dfc:	9504      	str	r5, [sp, #16]
    switch (index) {
c0de0dfe:	2f04      	cmp	r7, #4
c0de0e00:	9106      	str	r1, [sp, #24]
c0de0e02:	d021      	beq.n	c0de0e48 <handle_query_contract_ui+0x80>
c0de0e04:	2502      	movs	r5, #2
c0de0e06:	4611      	mov	r1, r2
c0de0e08:	4029      	ands	r1, r5
c0de0e0a:	2601      	movs	r6, #1
c0de0e0c:	4032      	ands	r2, r6
c0de0e0e:	2f01      	cmp	r7, #1
c0de0e10:	d022      	beq.n	c0de0e58 <handle_query_contract_ui+0x90>
c0de0e12:	2f02      	cmp	r7, #2
c0de0e14:	d044      	beq.n	c0de0ea0 <handle_query_contract_ui+0xd8>
c0de0e16:	2f03      	cmp	r7, #3
c0de0e18:	d047      	beq.n	c0de0eaa <handle_query_contract_ui+0xe2>
c0de0e1a:	2f00      	cmp	r7, #0
c0de0e1c:	d000      	beq.n	c0de0e20 <handle_query_contract_ui+0x58>
c0de0e1e:	e096      	b.n	c0de0f4e <handle_query_contract_ui+0x186>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0e20:	425f      	negs	r7, r3
c0de0e22:	415f      	adcs	r7, r3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0e24:	1ed8      	subs	r0, r3, #3
c0de0e26:	4246      	negs	r6, r0
c0de0e28:	4146      	adcs	r6, r0
            if (both_tokens_found) {
c0de0e2a:	433e      	orrs	r6, r7
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0e2c:	1e53      	subs	r3, r2, #1
c0de0e2e:	419a      	sbcs	r2, r3
            if (both_tokens_found) {
c0de0e30:	4332      	orrs	r2, r6
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0e32:	1e43      	subs	r3, r0, #1
c0de0e34:	4198      	sbcs	r0, r3
            if (both_tokens_found) {
c0de0e36:	2e00      	cmp	r6, #0
c0de0e38:	d000      	beq.n	c0de0e3c <handle_query_contract_ui+0x74>
c0de0e3a:	0046      	lsls	r6, r0, #1
c0de0e3c:	2a00      	cmp	r2, #0
c0de0e3e:	d100      	bne.n	c0de0e42 <handle_query_contract_ui+0x7a>
c0de0e40:	462e      	mov	r6, r5
c0de0e42:	2a00      	cmp	r2, #0
c0de0e44:	d029      	beq.n	c0de0e9a <handle_query_contract_ui+0xd2>
c0de0e46:	e035      	b.n	c0de0eb4 <handle_query_contract_ui+0xec>
            if (both_tokens_found) {
c0de0e48:	2b03      	cmp	r3, #3
c0de0e4a:	d000      	beq.n	c0de0e4e <handle_query_contract_ui+0x86>
c0de0e4c:	2603      	movs	r6, #3
c0de0e4e:	2b03      	cmp	r3, #3
c0de0e50:	d030      	beq.n	c0de0eb4 <handle_query_contract_ui+0xec>
c0de0e52:	2b00      	cmp	r3, #0
c0de0e54:	d02e      	beq.n	c0de0eb4 <handle_query_contract_ui+0xec>
c0de0e56:	e07a      	b.n	c0de0f4e <handle_query_contract_ui+0x186>
c0de0e58:	9402      	str	r4, [sp, #8]
    bool wrap = context->selectorIndex == WRAP || context->selectorIndex == UNWRAP;
c0de0e5a:	9804      	ldr	r0, [sp, #16]
c0de0e5c:	7a87      	ldrb	r7, [r0, #10]
            if (wrap) {
c0de0e5e:	3f0f      	subs	r7, #15
c0de0e60:	2601      	movs	r6, #1
c0de0e62:	2f02      	cmp	r7, #2
c0de0e64:	4630      	mov	r0, r6
c0de0e66:	d300      	bcc.n	c0de0e6a <handle_query_contract_ui+0xa2>
c0de0e68:	2000      	movs	r0, #0
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0e6a:	1edc      	subs	r4, r3, #3
c0de0e6c:	4265      	negs	r5, r4
c0de0e6e:	4165      	adcs	r5, r4
            if (wrap) {
c0de0e70:	4305      	orrs	r5, r0
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0e72:	4258      	negs	r0, r3
c0de0e74:	4158      	adcs	r0, r3
            if (wrap) {
c0de0e76:	2f02      	cmp	r7, #2
c0de0e78:	d200      	bcs.n	c0de0e7c <handle_query_contract_ui+0xb4>
c0de0e7a:	2603      	movs	r6, #3
c0de0e7c:	4328      	orrs	r0, r5
c0de0e7e:	2d00      	cmp	r5, #0
c0de0e80:	9c02      	ldr	r4, [sp, #8]
c0de0e82:	d100      	bne.n	c0de0e86 <handle_query_contract_ui+0xbe>
c0de0e84:	462e      	mov	r6, r5
c0de0e86:	2800      	cmp	r0, #0
c0de0e88:	d100      	bne.n	c0de0e8c <handle_query_contract_ui+0xc4>
c0de0e8a:	2602      	movs	r6, #2
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0e8c:	1e53      	subs	r3, r2, #1
c0de0e8e:	419a      	sbcs	r2, r3
            if (wrap) {
c0de0e90:	4310      	orrs	r0, r2
c0de0e92:	d100      	bne.n	c0de0e96 <handle_query_contract_ui+0xce>
c0de0e94:	4606      	mov	r6, r0
c0de0e96:	2800      	cmp	r0, #0
c0de0e98:	d10c      	bne.n	c0de0eb4 <handle_query_contract_ui+0xec>
c0de0e9a:	2900      	cmp	r1, #0
c0de0e9c:	d057      	beq.n	c0de0f4e <handle_query_contract_ui+0x186>
c0de0e9e:	e009      	b.n	c0de0eb4 <handle_query_contract_ui+0xec>
            if (both_tokens_found) {
c0de0ea0:	2b03      	cmp	r3, #3
c0de0ea2:	d05c      	beq.n	c0de0f5e <handle_query_contract_ui+0x196>
c0de0ea4:	2b00      	cmp	r3, #0
c0de0ea6:	d172      	bne.n	c0de0f8e <handle_query_contract_ui+0x1c6>
c0de0ea8:	e0ad      	b.n	c0de1006 <handle_query_contract_ui+0x23e>
c0de0eaa:	2b00      	cmp	r3, #0
c0de0eac:	d000      	beq.n	c0de0eb0 <handle_query_contract_ui+0xe8>
c0de0eae:	4606      	mov	r6, r0
c0de0eb0:	2b03      	cmp	r3, #3
c0de0eb2:	d04c      	beq.n	c0de0f4e <handle_query_contract_ui+0x186>
    screens_t screen = get_screen(msg, context);
    switch (screen) {
c0de0eb4:	2e03      	cmp	r6, #3
c0de0eb6:	d052      	beq.n	c0de0f5e <handle_query_contract_ui+0x196>
c0de0eb8:	2e01      	cmp	r6, #1
c0de0eba:	d068      	beq.n	c0de0f8e <handle_query_contract_ui+0x1c6>
c0de0ebc:	2e02      	cmp	r6, #2
c0de0ebe:	d100      	bne.n	c0de0ec2 <handle_query_contract_ui+0xfa>
c0de0ec0:	e0a1      	b.n	c0de1006 <handle_query_contract_ui+0x23e>
c0de0ec2:	2e00      	cmp	r6, #0
c0de0ec4:	d143      	bne.n	c0de0f4e <handle_query_contract_ui+0x186>
c0de0ec6:	9d05      	ldr	r5, [sp, #20]
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0ec8:	462e      	mov	r6, r5
c0de0eca:	3640      	adds	r6, #64	; 0x40
c0de0ecc:	49fb      	ldr	r1, [pc, #1004]	; (c0de12bc <handle_query_contract_ui+0x4f4>)
c0de0ece:	4479      	add	r1, pc
c0de0ed0:	2214      	movs	r2, #20
c0de0ed2:	4630      	mov	r0, r6
c0de0ed4:	f000 fed2 	bl	c0de1c7c <memcmp>
c0de0ed8:	2800      	cmp	r0, #0
c0de0eda:	d100      	bne.n	c0de0ede <handle_query_contract_ui+0x116>
c0de0edc:	e0aa      	b.n	c0de1034 <handle_query_contract_ui+0x26c>
    } else if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de0ede:	49f8      	ldr	r1, [pc, #992]	; (c0de12c0 <handle_query_contract_ui+0x4f8>)
c0de0ee0:	4479      	add	r1, pc
c0de0ee2:	2214      	movs	r2, #20
c0de0ee4:	4630      	mov	r0, r6
c0de0ee6:	f000 fec9 	bl	c0de1c7c <memcmp>
c0de0eea:	2800      	cmp	r0, #0
c0de0eec:	d100      	bne.n	c0de0ef0 <handle_query_contract_ui+0x128>
c0de0eee:	e0ab      	b.n	c0de1048 <handle_query_contract_ui+0x280>
    } else if (ADDRESS_IS_OUSD(context->contract_address_sent)) {
c0de0ef0:	49f4      	ldr	r1, [pc, #976]	; (c0de12c4 <handle_query_contract_ui+0x4fc>)
c0de0ef2:	4479      	add	r1, pc
c0de0ef4:	2214      	movs	r2, #20
c0de0ef6:	4630      	mov	r0, r6
c0de0ef8:	f000 fec0 	bl	c0de1c7c <memcmp>
c0de0efc:	2800      	cmp	r0, #0
c0de0efe:	d100      	bne.n	c0de0f02 <handle_query_contract_ui+0x13a>
c0de0f00:	e0ac      	b.n	c0de105c <handle_query_contract_ui+0x294>
    } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de0f02:	462e      	mov	r6, r5
c0de0f04:	3654      	adds	r6, #84	; 0x54
c0de0f06:	49f0      	ldr	r1, [pc, #960]	; (c0de12c8 <handle_query_contract_ui+0x500>)
c0de0f08:	4479      	add	r1, pc
c0de0f0a:	2214      	movs	r2, #20
c0de0f0c:	4630      	mov	r0, r6
c0de0f0e:	f000 feb5 	bl	c0de1c7c <memcmp>
c0de0f12:	2800      	cmp	r0, #0
c0de0f14:	d100      	bne.n	c0de0f18 <handle_query_contract_ui+0x150>
c0de0f16:	e137      	b.n	c0de1188 <handle_query_contract_ui+0x3c0>
    } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de0f18:	49ec      	ldr	r1, [pc, #944]	; (c0de12cc <handle_query_contract_ui+0x504>)
c0de0f1a:	4479      	add	r1, pc
c0de0f1c:	2214      	movs	r2, #20
c0de0f1e:	4630      	mov	r0, r6
c0de0f20:	f000 feac 	bl	c0de1c7c <memcmp>
c0de0f24:	2800      	cmp	r0, #0
c0de0f26:	d100      	bne.n	c0de0f2a <handle_query_contract_ui+0x162>
c0de0f28:	e133      	b.n	c0de1192 <handle_query_contract_ui+0x3ca>
    } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de0f2a:	49e9      	ldr	r1, [pc, #932]	; (c0de12d0 <handle_query_contract_ui+0x508>)
c0de0f2c:	4479      	add	r1, pc
c0de0f2e:	2214      	movs	r2, #20
c0de0f30:	4630      	mov	r0, r6
c0de0f32:	f000 fea3 	bl	c0de1c7c <memcmp>
c0de0f36:	2800      	cmp	r0, #0
c0de0f38:	9e04      	ldr	r6, [sp, #16]
c0de0f3a:	d000      	beq.n	c0de0f3e <handle_query_contract_ui+0x176>
c0de0f3c:	e131      	b.n	c0de11a2 <handle_query_contract_ui+0x3da>
        strlcpy(context->ticker_sent, USDT_TICKER, sizeof(context->ticker_sent));
c0de0f3e:	4628      	mov	r0, r5
c0de0f40:	307c      	adds	r0, #124	; 0x7c
c0de0f42:	49e4      	ldr	r1, [pc, #912]	; (c0de12d4 <handle_query_contract_ui+0x50c>)
c0de0f44:	4479      	add	r1, pc
c0de0f46:	220b      	movs	r2, #11
c0de0f48:	f001 f814 	bl	c0de1f74 <strlcpy>
c0de0f4c:	e129      	b.n	c0de11a2 <handle_query_contract_ui+0x3da>
            break;
        case BENEFICIARY_SCREEN:
            set_beneficiary_ui(msg, context);
            break;
        default:
            PRINTF("Received an invalid screenIndex\n");
c0de0f4e:	48e2      	ldr	r0, [pc, #904]	; (c0de12d8 <handle_query_contract_ui+0x510>)
c0de0f50:	4478      	add	r0, pc
c0de0f52:	f000 fadd 	bl	c0de1510 <mcu_usb_printf>
c0de0f56:	2000      	movs	r0, #0
c0de0f58:	9906      	ldr	r1, [sp, #24]
c0de0f5a:	7508      	strb	r0, [r1, #20]
c0de0f5c:	e20f      	b.n	c0de137e <handle_query_contract_ui+0x5b6>
    strlcpy(msg->title, "Beneficiary", msg->titleLength);
c0de0f5e:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0f60:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0f62:	49de      	ldr	r1, [pc, #888]	; (c0de12dc <handle_query_contract_ui+0x514>)
c0de0f64:	4479      	add	r1, pc
c0de0f66:	f001 f805 	bl	c0de1f74 <strlcpy>
    msg->msg[0] = '0';
c0de0f6a:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0f6c:	2130      	movs	r1, #48	; 0x30
c0de0f6e:	7001      	strb	r1, [r0, #0]
    msg->msg[1] = 'x';
c0de0f70:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0f72:	2178      	movs	r1, #120	; 0x78
c0de0f74:	7041      	strb	r1, [r0, #1]
                                  msg->pluginSharedRW->sha3,
c0de0f76:	6820      	ldr	r0, [r4, #0]
c0de0f78:	6802      	ldr	r2, [r0, #0]
                                  msg->msg + 2,
c0de0f7a:	6ae3      	ldr	r3, [r4, #44]	; 0x2c
c0de0f7c:	2100      	movs	r1, #0
    getEthAddressStringFromBinary((uint8_t *) context->beneficiary,
c0de0f7e:	9100      	str	r1, [sp, #0]
c0de0f80:	9101      	str	r1, [sp, #4]
c0de0f82:	9805      	ldr	r0, [sp, #20]
c0de0f84:	3068      	adds	r0, #104	; 0x68
                                  msg->msg + 2,
c0de0f86:	1c99      	adds	r1, r3, #2
    getEthAddressStringFromBinary((uint8_t *) context->beneficiary,
c0de0f88:	f7ff f8a6 	bl	c0de00d8 <getEthAddressStringFromBinary>
c0de0f8c:	e1f7      	b.n	c0de137e <handle_query_contract_ui+0x5b6>
c0de0f8e:	9d05      	ldr	r5, [sp, #20]
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0f90:	462e      	mov	r6, r5
c0de0f92:	3654      	adds	r6, #84	; 0x54
c0de0f94:	49d2      	ldr	r1, [pc, #840]	; (c0de12e0 <handle_query_contract_ui+0x518>)
c0de0f96:	4479      	add	r1, pc
c0de0f98:	2214      	movs	r2, #20
c0de0f9a:	4630      	mov	r0, r6
c0de0f9c:	f000 fe6e 	bl	c0de1c7c <memcmp>
c0de0fa0:	2800      	cmp	r0, #0
c0de0fa2:	d03d      	beq.n	c0de1020 <handle_query_contract_ui+0x258>
    } else if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de0fa4:	49cf      	ldr	r1, [pc, #828]	; (c0de12e4 <handle_query_contract_ui+0x51c>)
c0de0fa6:	4479      	add	r1, pc
c0de0fa8:	2214      	movs	r2, #20
c0de0faa:	4630      	mov	r0, r6
c0de0fac:	f000 fe66 	bl	c0de1c7c <memcmp>
c0de0fb0:	2800      	cmp	r0, #0
c0de0fb2:	d03a      	beq.n	c0de102a <handle_query_contract_ui+0x262>
    } else if (ADDRESS_IS_OUSD(context->contract_address_received)) {
c0de0fb4:	49cc      	ldr	r1, [pc, #816]	; (c0de12e8 <handle_query_contract_ui+0x520>)
c0de0fb6:	4479      	add	r1, pc
c0de0fb8:	2214      	movs	r2, #20
c0de0fba:	4630      	mov	r0, r6
c0de0fbc:	f000 fe5e 	bl	c0de1c7c <memcmp>
c0de0fc0:	2800      	cmp	r0, #0
c0de0fc2:	d03c      	beq.n	c0de103e <handle_query_contract_ui+0x276>
    } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de0fc4:	49c9      	ldr	r1, [pc, #804]	; (c0de12ec <handle_query_contract_ui+0x524>)
c0de0fc6:	4479      	add	r1, pc
c0de0fc8:	2214      	movs	r2, #20
c0de0fca:	4630      	mov	r0, r6
c0de0fcc:	f000 fe56 	bl	c0de1c7c <memcmp>
c0de0fd0:	2800      	cmp	r0, #0
c0de0fd2:	d03e      	beq.n	c0de1052 <handle_query_contract_ui+0x28a>
    } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de0fd4:	49c6      	ldr	r1, [pc, #792]	; (c0de12f0 <handle_query_contract_ui+0x528>)
c0de0fd6:	4479      	add	r1, pc
c0de0fd8:	2214      	movs	r2, #20
c0de0fda:	4630      	mov	r0, r6
c0de0fdc:	f000 fe4e 	bl	c0de1c7c <memcmp>
c0de0fe0:	2800      	cmp	r0, #0
c0de0fe2:	d040      	beq.n	c0de1066 <handle_query_contract_ui+0x29e>
    } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de0fe4:	49c3      	ldr	r1, [pc, #780]	; (c0de12f4 <handle_query_contract_ui+0x52c>)
c0de0fe6:	4479      	add	r1, pc
c0de0fe8:	2214      	movs	r2, #20
c0de0fea:	4630      	mov	r0, r6
c0de0fec:	f000 fe46 	bl	c0de1c7c <memcmp>
c0de0ff0:	2800      	cmp	r0, #0
c0de0ff2:	9e04      	ldr	r6, [sp, #16]
c0de0ff4:	d13f      	bne.n	c0de1076 <handle_query_contract_ui+0x2ae>
        strlcpy(context->ticker_received, USDT_TICKER, sizeof(context->ticker_received));
c0de0ff6:	4628      	mov	r0, r5
c0de0ff8:	3087      	adds	r0, #135	; 0x87
c0de0ffa:	49e2      	ldr	r1, [pc, #904]	; (c0de1384 <handle_query_contract_ui+0x5bc>)
c0de0ffc:	4479      	add	r1, pc
c0de0ffe:	220b      	movs	r2, #11
c0de1000:	f000 ffb8 	bl	c0de1f74 <strlcpy>
c0de1004:	e037      	b.n	c0de1076 <handle_query_contract_ui+0x2ae>
    strlcpy(msg->title, "WARNING", msg->titleLength);
c0de1006:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1008:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de100a:	49df      	ldr	r1, [pc, #892]	; (c0de1388 <handle_query_contract_ui+0x5c0>)
c0de100c:	4479      	add	r1, pc
c0de100e:	f000 ffb1 	bl	c0de1f74 <strlcpy>
    strlcpy(msg->msg, "Unknown token", msg->msgLength);
c0de1012:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de1014:	6b22      	ldr	r2, [r4, #48]	; 0x30
c0de1016:	49dd      	ldr	r1, [pc, #884]	; (c0de138c <handle_query_contract_ui+0x5c4>)
c0de1018:	4479      	add	r1, pc
c0de101a:	f000 ffab 	bl	c0de1f74 <strlcpy>
c0de101e:	e1ae      	b.n	c0de137e <handle_query_contract_ui+0x5b6>
        strlcpy(context->ticker_received, msg->network_ticker, sizeof(context->ticker_received));
c0de1020:	4628      	mov	r0, r5
c0de1022:	3087      	adds	r0, #135	; 0x87
c0de1024:	4621      	mov	r1, r4
c0de1026:	3110      	adds	r1, #16
c0de1028:	e021      	b.n	c0de106e <handle_query_contract_ui+0x2a6>
        strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de102a:	4628      	mov	r0, r5
c0de102c:	3087      	adds	r0, #135	; 0x87
c0de102e:	49f0      	ldr	r1, [pc, #960]	; (c0de13f0 <handle_query_contract_ui+0x628>)
c0de1030:	4479      	add	r1, pc
c0de1032:	e01c      	b.n	c0de106e <handle_query_contract_ui+0x2a6>
        strlcpy(context->ticker_sent, msg->network_ticker, sizeof(context->ticker_sent));
c0de1034:	4628      	mov	r0, r5
c0de1036:	307c      	adds	r0, #124	; 0x7c
c0de1038:	4621      	mov	r1, r4
c0de103a:	3110      	adds	r1, #16
c0de103c:	e0ad      	b.n	c0de119a <handle_query_contract_ui+0x3d2>
        strlcpy(context->ticker_received, OUSD_TICKER, sizeof(context->ticker_received));
c0de103e:	4628      	mov	r0, r5
c0de1040:	3087      	adds	r0, #135	; 0x87
c0de1042:	49ec      	ldr	r1, [pc, #944]	; (c0de13f4 <handle_query_contract_ui+0x62c>)
c0de1044:	4479      	add	r1, pc
c0de1046:	e012      	b.n	c0de106e <handle_query_contract_ui+0x2a6>
        strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de1048:	4628      	mov	r0, r5
c0de104a:	307c      	adds	r0, #124	; 0x7c
c0de104c:	49d0      	ldr	r1, [pc, #832]	; (c0de1390 <handle_query_contract_ui+0x5c8>)
c0de104e:	4479      	add	r1, pc
c0de1050:	e0a3      	b.n	c0de119a <handle_query_contract_ui+0x3d2>
        strlcpy(context->ticker_received, DAI_TICKER, sizeof(context->ticker_received));
c0de1052:	4628      	mov	r0, r5
c0de1054:	3087      	adds	r0, #135	; 0x87
c0de1056:	49e8      	ldr	r1, [pc, #928]	; (c0de13f8 <handle_query_contract_ui+0x630>)
c0de1058:	4479      	add	r1, pc
c0de105a:	e008      	b.n	c0de106e <handle_query_contract_ui+0x2a6>
        strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de105c:	4628      	mov	r0, r5
c0de105e:	307c      	adds	r0, #124	; 0x7c
c0de1060:	49cc      	ldr	r1, [pc, #816]	; (c0de1394 <handle_query_contract_ui+0x5cc>)
c0de1062:	4479      	add	r1, pc
c0de1064:	e099      	b.n	c0de119a <handle_query_contract_ui+0x3d2>
        strlcpy(context->ticker_received, USDC_TICKER, sizeof(context->ticker_received));
c0de1066:	4628      	mov	r0, r5
c0de1068:	3087      	adds	r0, #135	; 0x87
c0de106a:	49e4      	ldr	r1, [pc, #912]	; (c0de13fc <handle_query_contract_ui+0x634>)
c0de106c:	4479      	add	r1, pc
c0de106e:	220b      	movs	r2, #11
c0de1070:	f000 ff80 	bl	c0de1f74 <strlcpy>
c0de1074:	9e04      	ldr	r6, [sp, #16]
    context->amount_length = INT256_LENGTH;
c0de1076:	9803      	ldr	r0, [sp, #12]
c0de1078:	7170      	strb	r0, [r6, #5]
    strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de107a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de107c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de107e:	49e0      	ldr	r1, [pc, #896]	; (c0de1400 <handle_query_contract_ui+0x638>)
c0de1080:	4479      	add	r1, pc
c0de1082:	f000 ff77 	bl	c0de1f74 <strlcpy>
    switch (context->selectorIndex) {
c0de1086:	7ab1      	ldrb	r1, [r6, #10]
c0de1088:	1f08      	subs	r0, r1, #4
c0de108a:	2805      	cmp	r0, #5
c0de108c:	d200      	bcs.n	c0de1090 <handle_query_contract_ui+0x2c8>
c0de108e:	e14e      	b.n	c0de132e <handle_query_contract_ui+0x566>
c0de1090:	1e48      	subs	r0, r1, #1
c0de1092:	2802      	cmp	r0, #2
c0de1094:	d32e      	bcc.n	c0de10f4 <handle_query_contract_ui+0x32c>
c0de1096:	290e      	cmp	r1, #14
c0de1098:	d03f      	beq.n	c0de111a <handle_query_contract_ui+0x352>
c0de109a:	2903      	cmp	r1, #3
c0de109c:	d048      	beq.n	c0de1130 <handle_query_contract_ui+0x368>
c0de109e:	2909      	cmp	r1, #9
c0de10a0:	d01d      	beq.n	c0de10de <handle_query_contract_ui+0x316>
c0de10a2:	290a      	cmp	r1, #10
c0de10a4:	d055      	beq.n	c0de1152 <handle_query_contract_ui+0x38a>
c0de10a6:	290b      	cmp	r1, #11
c0de10a8:	d019      	beq.n	c0de10de <handle_query_contract_ui+0x316>
c0de10aa:	290c      	cmp	r1, #12
c0de10ac:	d05c      	beq.n	c0de1168 <handle_query_contract_ui+0x3a0>
c0de10ae:	290d      	cmp	r1, #13
c0de10b0:	d015      	beq.n	c0de10de <handle_query_contract_ui+0x316>
c0de10b2:	2900      	cmp	r1, #0
c0de10b4:	d000      	beq.n	c0de10b8 <handle_query_contract_ui+0x2f0>
c0de10b6:	e0b5      	b.n	c0de1224 <handle_query_contract_ui+0x45c>
            memcpy(context->min_amount_received, &msg->pluginSharedRO->txContent->value.value, msg->pluginSharedRO->txContent->value.length);
c0de10b8:	6860      	ldr	r0, [r4, #4]
c0de10ba:	6801      	ldr	r1, [r0, #0]
c0de10bc:	4625      	mov	r5, r4
c0de10be:	2462      	movs	r4, #98	; 0x62
c0de10c0:	5d0a      	ldrb	r2, [r1, r4]
c0de10c2:	9805      	ldr	r0, [sp, #20]
c0de10c4:	3020      	adds	r0, #32
c0de10c6:	3142      	adds	r1, #66	; 0x42
c0de10c8:	f000 fdc8 	bl	c0de1c5c <__aeabi_memcpy>
            context->amount_length = msg->pluginSharedRO->txContent->value.length;
c0de10cc:	6868      	ldr	r0, [r5, #4]
c0de10ce:	6800      	ldr	r0, [r0, #0]
c0de10d0:	5d00      	ldrb	r0, [r0, r4]
c0de10d2:	462c      	mov	r4, r5
c0de10d4:	9d05      	ldr	r5, [sp, #20]
c0de10d6:	7170      	strb	r0, [r6, #5]
            strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de10d8:	4628      	mov	r0, r5
c0de10da:	3087      	adds	r0, #135	; 0x87
c0de10dc:	e01a      	b.n	c0de1114 <handle_query_contract_ui+0x34c>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de10de:	4628      	mov	r0, r5
c0de10e0:	3020      	adds	r0, #32
c0de10e2:	2220      	movs	r2, #32
c0de10e4:	4629      	mov	r1, r5
c0de10e6:	f000 fdb9 	bl	c0de1c5c <__aeabi_memcpy>
            strlcpy(context->ticker_received, OUSD_TICKER, sizeof(context->ticker_received));
c0de10ea:	4628      	mov	r0, r5
c0de10ec:	3087      	adds	r0, #135	; 0x87
c0de10ee:	49cc      	ldr	r1, [pc, #816]	; (c0de1420 <handle_query_contract_ui+0x658>)
c0de10f0:	4479      	add	r1, pc
c0de10f2:	e043      	b.n	c0de117c <handle_query_contract_ui+0x3b4>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de10f4:	6860      	ldr	r0, [r4, #4]
c0de10f6:	6801      	ldr	r1, [r0, #0]
c0de10f8:	31a5      	adds	r1, #165	; 0xa5
c0de10fa:	48c2      	ldr	r0, [pc, #776]	; (c0de1404 <handle_query_contract_ui+0x63c>)
c0de10fc:	4478      	add	r0, pc
c0de10fe:	2214      	movs	r2, #20
c0de1100:	f000 fdbc 	bl	c0de1c7c <memcmp>
c0de1104:	4601      	mov	r1, r0
c0de1106:	4628      	mov	r0, r5
c0de1108:	3087      	adds	r0, #135	; 0x87
c0de110a:	2900      	cmp	r1, #0
c0de110c:	d002      	beq.n	c0de1114 <handle_query_contract_ui+0x34c>
                strlcpy(context->ticker_received, OUSD_TICKER, sizeof(context->ticker_received));
c0de110e:	49c0      	ldr	r1, [pc, #768]	; (c0de1410 <handle_query_contract_ui+0x648>)
c0de1110:	4479      	add	r1, pc
c0de1112:	e109      	b.n	c0de1328 <handle_query_contract_ui+0x560>
c0de1114:	49bc      	ldr	r1, [pc, #752]	; (c0de1408 <handle_query_contract_ui+0x640>)
c0de1116:	4479      	add	r1, pc
c0de1118:	e106      	b.n	c0de1328 <handle_query_contract_ui+0x560>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de111a:	4628      	mov	r0, r5
c0de111c:	3020      	adds	r0, #32
c0de111e:	2220      	movs	r2, #32
c0de1120:	4629      	mov	r1, r5
c0de1122:	f000 fd9b 	bl	c0de1c5c <__aeabi_memcpy>
            strlcpy(context->ticker_received, USDC_TICKER, sizeof(context->ticker_received));
c0de1126:	4628      	mov	r0, r5
c0de1128:	3087      	adds	r0, #135	; 0x87
c0de112a:	49c0      	ldr	r1, [pc, #768]	; (c0de142c <handle_query_contract_ui+0x664>)
c0de112c:	4479      	add	r1, pc
c0de112e:	e025      	b.n	c0de117c <handle_query_contract_ui+0x3b4>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de1130:	6860      	ldr	r0, [r4, #4]
c0de1132:	6801      	ldr	r1, [r0, #0]
c0de1134:	31a5      	adds	r1, #165	; 0xa5
c0de1136:	48b7      	ldr	r0, [pc, #732]	; (c0de1414 <handle_query_contract_ui+0x64c>)
c0de1138:	4478      	add	r0, pc
c0de113a:	2214      	movs	r2, #20
c0de113c:	f000 fd9e 	bl	c0de1c7c <memcmp>
c0de1140:	4601      	mov	r1, r0
c0de1142:	4628      	mov	r0, r5
c0de1144:	3087      	adds	r0, #135	; 0x87
c0de1146:	2900      	cmp	r1, #0
c0de1148:	d100      	bne.n	c0de114c <handle_query_contract_ui+0x384>
c0de114a:	e0eb      	b.n	c0de1324 <handle_query_contract_ui+0x55c>
                strlcpy(context->ticker_received, "USD MIX", sizeof(context->ticker_received));
c0de114c:	49b3      	ldr	r1, [pc, #716]	; (c0de141c <handle_query_contract_ui+0x654>)
c0de114e:	4479      	add	r1, pc
c0de1150:	e0ea      	b.n	c0de1328 <handle_query_contract_ui+0x560>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de1152:	4628      	mov	r0, r5
c0de1154:	3020      	adds	r0, #32
c0de1156:	2220      	movs	r2, #32
c0de1158:	4629      	mov	r1, r5
c0de115a:	f000 fd7f 	bl	c0de1c5c <__aeabi_memcpy>
            strlcpy(context->ticker_received, USDT_TICKER, sizeof(context->ticker_received));
c0de115e:	4628      	mov	r0, r5
c0de1160:	3087      	adds	r0, #135	; 0x87
c0de1162:	49b0      	ldr	r1, [pc, #704]	; (c0de1424 <handle_query_contract_ui+0x65c>)
c0de1164:	4479      	add	r1, pc
c0de1166:	e009      	b.n	c0de117c <handle_query_contract_ui+0x3b4>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de1168:	4628      	mov	r0, r5
c0de116a:	3020      	adds	r0, #32
c0de116c:	2220      	movs	r2, #32
c0de116e:	4629      	mov	r1, r5
c0de1170:	f000 fd74 	bl	c0de1c5c <__aeabi_memcpy>
            strlcpy(context->ticker_received, DAI_TICKER, sizeof(context->ticker_received));
c0de1174:	4628      	mov	r0, r5
c0de1176:	3087      	adds	r0, #135	; 0x87
c0de1178:	49ab      	ldr	r1, [pc, #684]	; (c0de1428 <handle_query_contract_ui+0x660>)
c0de117a:	4479      	add	r1, pc
c0de117c:	220b      	movs	r2, #11
c0de117e:	f000 fef9 	bl	c0de1f74 <strlcpy>
c0de1182:	2012      	movs	r0, #18
c0de1184:	70b0      	strb	r0, [r6, #2]
c0de1186:	e0d2      	b.n	c0de132e <handle_query_contract_ui+0x566>
        strlcpy(context->ticker_sent, DAI_TICKER, sizeof(context->ticker_sent));
c0de1188:	4628      	mov	r0, r5
c0de118a:	307c      	adds	r0, #124	; 0x7c
c0de118c:	4982      	ldr	r1, [pc, #520]	; (c0de1398 <handle_query_contract_ui+0x5d0>)
c0de118e:	4479      	add	r1, pc
c0de1190:	e003      	b.n	c0de119a <handle_query_contract_ui+0x3d2>
        strlcpy(context->ticker_sent, USDC_TICKER, sizeof(context->ticker_sent));
c0de1192:	4628      	mov	r0, r5
c0de1194:	307c      	adds	r0, #124	; 0x7c
c0de1196:	4981      	ldr	r1, [pc, #516]	; (c0de139c <handle_query_contract_ui+0x5d4>)
c0de1198:	4479      	add	r1, pc
c0de119a:	220b      	movs	r2, #11
c0de119c:	f000 feea 	bl	c0de1f74 <strlcpy>
c0de11a0:	9e04      	ldr	r6, [sp, #16]
    context->amount_length = INT256_LENGTH;
c0de11a2:	9803      	ldr	r0, [sp, #12]
c0de11a4:	7170      	strb	r0, [r6, #5]
    strlcpy(msg->title, "Send", msg->titleLength);
c0de11a6:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de11a8:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de11aa:	497d      	ldr	r1, [pc, #500]	; (c0de13a0 <handle_query_contract_ui+0x5d8>)
c0de11ac:	4479      	add	r1, pc
c0de11ae:	f000 fee1 	bl	c0de1f74 <strlcpy>
    switch (context->selectorIndex) {
c0de11b2:	7ab1      	ldrb	r1, [r6, #10]
c0de11b4:	1f08      	subs	r0, r1, #4
c0de11b6:	2805      	cmp	r0, #5
c0de11b8:	d200      	bcs.n	c0de11bc <handle_query_contract_ui+0x3f4>
c0de11ba:	e0d0      	b.n	c0de135e <handle_query_contract_ui+0x596>
c0de11bc:	2910      	cmp	r1, #16
c0de11be:	d036      	beq.n	c0de122e <handle_query_contract_ui+0x466>
c0de11c0:	2901      	cmp	r1, #1
c0de11c2:	d04a      	beq.n	c0de125a <handle_query_contract_ui+0x492>
c0de11c4:	2902      	cmp	r1, #2
c0de11c6:	d053      	beq.n	c0de1270 <handle_query_contract_ui+0x4a8>
c0de11c8:	2903      	cmp	r1, #3
c0de11ca:	d056      	beq.n	c0de127a <handle_query_contract_ui+0x4b2>
c0de11cc:	2909      	cmp	r1, #9
c0de11ce:	d060      	beq.n	c0de1292 <handle_query_contract_ui+0x4ca>
c0de11d0:	290a      	cmp	r1, #10
c0de11d2:	d022      	beq.n	c0de121a <handle_query_contract_ui+0x452>
c0de11d4:	290b      	cmp	r1, #11
c0de11d6:	d061      	beq.n	c0de129c <handle_query_contract_ui+0x4d4>
c0de11d8:	290c      	cmp	r1, #12
c0de11da:	d01e      	beq.n	c0de121a <handle_query_contract_ui+0x452>
c0de11dc:	290d      	cmp	r1, #13
c0de11de:	d062      	beq.n	c0de12a6 <handle_query_contract_ui+0x4de>
c0de11e0:	290e      	cmp	r1, #14
c0de11e2:	d01a      	beq.n	c0de121a <handle_query_contract_ui+0x452>
c0de11e4:	290f      	cmp	r1, #15
c0de11e6:	d100      	bne.n	c0de11ea <handle_query_contract_ui+0x422>
c0de11e8:	e086      	b.n	c0de12f8 <handle_query_contract_ui+0x530>
c0de11ea:	2900      	cmp	r1, #0
c0de11ec:	d11a      	bne.n	c0de1224 <handle_query_contract_ui+0x45c>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de11ee:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de11f0:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de11f2:	496c      	ldr	r1, [pc, #432]	; (c0de13a4 <handle_query_contract_ui+0x5dc>)
c0de11f4:	4479      	add	r1, pc
c0de11f6:	f000 febd 	bl	c0de1f74 <strlcpy>
            memcpy(context->amount_sent, &msg->pluginSharedRO->txContent->value.value, msg->pluginSharedRO->txContent->value.length);
c0de11fa:	6860      	ldr	r0, [r4, #4]
c0de11fc:	6801      	ldr	r1, [r0, #0]
c0de11fe:	4625      	mov	r5, r4
c0de1200:	2462      	movs	r4, #98	; 0x62
c0de1202:	5d0a      	ldrb	r2, [r1, r4]
c0de1204:	3142      	adds	r1, #66	; 0x42
c0de1206:	9805      	ldr	r0, [sp, #20]
c0de1208:	f000 fd28 	bl	c0de1c5c <__aeabi_memcpy>
            context->amount_length = msg->pluginSharedRO->txContent->value.length;
c0de120c:	6868      	ldr	r0, [r5, #4]
c0de120e:	6800      	ldr	r0, [r0, #0]
c0de1210:	5d00      	ldrb	r0, [r0, r4]
c0de1212:	462c      	mov	r4, r5
c0de1214:	9d05      	ldr	r5, [sp, #20]
c0de1216:	7170      	strb	r0, [r6, #5]
c0de1218:	e0a1      	b.n	c0de135e <handle_query_contract_ui+0x596>
            strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de121a:	4628      	mov	r0, r5
c0de121c:	307c      	adds	r0, #124	; 0x7c
c0de121e:	496a      	ldr	r1, [pc, #424]	; (c0de13c8 <handle_query_contract_ui+0x600>)
c0de1220:	4479      	add	r1, pc
c0de1222:	e044      	b.n	c0de12ae <handle_query_contract_ui+0x4e6>
c0de1224:	4882      	ldr	r0, [pc, #520]	; (c0de1430 <handle_query_contract_ui+0x668>)
c0de1226:	4478      	add	r0, pc
c0de1228:	f000 f972 	bl	c0de1510 <mcu_usb_printf>
c0de122c:	e693      	b.n	c0de0f56 <handle_query_contract_ui+0x18e>
            strlcpy(msg->title, "Unwrap", msg->titleLength);
c0de122e:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1230:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de1232:	4969      	ldr	r1, [pc, #420]	; (c0de13d8 <handle_query_contract_ui+0x610>)
c0de1234:	4479      	add	r1, pc
c0de1236:	f000 fe9d 	bl	c0de1f74 <strlcpy>
            if (memcmp(WOETH_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de123a:	6860      	ldr	r0, [r4, #4]
c0de123c:	6801      	ldr	r1, [r0, #0]
c0de123e:	31a5      	adds	r1, #165	; 0xa5
c0de1240:	4866      	ldr	r0, [pc, #408]	; (c0de13dc <handle_query_contract_ui+0x614>)
c0de1242:	4478      	add	r0, pc
c0de1244:	2214      	movs	r2, #20
c0de1246:	f000 fd19 	bl	c0de1c7c <memcmp>
c0de124a:	4601      	mov	r1, r0
c0de124c:	4628      	mov	r0, r5
c0de124e:	307c      	adds	r0, #124	; 0x7c
c0de1250:	2900      	cmp	r1, #0
c0de1252:	d07f      	beq.n	c0de1354 <handle_query_contract_ui+0x58c>
                strlcpy(context->ticker_sent, WOUSD_TICKER, sizeof(context->ticker_sent));
c0de1254:	4963      	ldr	r1, [pc, #396]	; (c0de13e4 <handle_query_contract_ui+0x61c>)
c0de1256:	4479      	add	r1, pc
c0de1258:	e07e      	b.n	c0de1358 <handle_query_contract_ui+0x590>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de125a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de125c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de125e:	4952      	ldr	r1, [pc, #328]	; (c0de13a8 <handle_query_contract_ui+0x5e0>)
c0de1260:	4479      	add	r1, pc
c0de1262:	f000 fe87 	bl	c0de1f74 <strlcpy>
            strlcpy(context->ticker_sent, SFRXETH_TICKER, sizeof(context->ticker_sent));
c0de1266:	4628      	mov	r0, r5
c0de1268:	307c      	adds	r0, #124	; 0x7c
c0de126a:	4950      	ldr	r1, [pc, #320]	; (c0de13ac <handle_query_contract_ui+0x5e4>)
c0de126c:	4479      	add	r1, pc
c0de126e:	e073      	b.n	c0de1358 <handle_query_contract_ui+0x590>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de1270:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1272:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de1274:	495c      	ldr	r1, [pc, #368]	; (c0de13e8 <handle_query_contract_ui+0x620>)
c0de1276:	4479      	add	r1, pc
c0de1278:	e06f      	b.n	c0de135a <handle_query_contract_ui+0x592>
            strlcpy(msg->title, "Redeem", msg->titleLength);
c0de127a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de127c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de127e:	494c      	ldr	r1, [pc, #304]	; (c0de13b0 <handle_query_contract_ui+0x5e8>)
c0de1280:	4479      	add	r1, pc
c0de1282:	f000 fe77 	bl	c0de1f74 <strlcpy>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de1286:	6860      	ldr	r0, [r4, #4]
c0de1288:	6801      	ldr	r1, [r0, #0]
c0de128a:	31a5      	adds	r1, #165	; 0xa5
c0de128c:	4849      	ldr	r0, [pc, #292]	; (c0de13b4 <handle_query_contract_ui+0x5ec>)
c0de128e:	4478      	add	r0, pc
c0de1290:	e03d      	b.n	c0de130e <handle_query_contract_ui+0x546>
            strlcpy(context->ticker_sent, USDT_TICKER, sizeof(context->ticker_sent));
c0de1292:	4628      	mov	r0, r5
c0de1294:	307c      	adds	r0, #124	; 0x7c
c0de1296:	4949      	ldr	r1, [pc, #292]	; (c0de13bc <handle_query_contract_ui+0x5f4>)
c0de1298:	4479      	add	r1, pc
c0de129a:	e008      	b.n	c0de12ae <handle_query_contract_ui+0x4e6>
            strlcpy(context->ticker_sent, DAI_TICKER, sizeof(context->ticker_sent));
c0de129c:	4628      	mov	r0, r5
c0de129e:	307c      	adds	r0, #124	; 0x7c
c0de12a0:	4947      	ldr	r1, [pc, #284]	; (c0de13c0 <handle_query_contract_ui+0x5f8>)
c0de12a2:	4479      	add	r1, pc
c0de12a4:	e003      	b.n	c0de12ae <handle_query_contract_ui+0x4e6>
            strlcpy(context->ticker_sent, USDC_TICKER, sizeof(context->ticker_sent));
c0de12a6:	4628      	mov	r0, r5
c0de12a8:	307c      	adds	r0, #124	; 0x7c
c0de12aa:	4946      	ldr	r1, [pc, #280]	; (c0de13c4 <handle_query_contract_ui+0x5fc>)
c0de12ac:	4479      	add	r1, pc
c0de12ae:	220b      	movs	r2, #11
c0de12b0:	f000 fe60 	bl	c0de1f74 <strlcpy>
c0de12b4:	2012      	movs	r0, #18
c0de12b6:	7070      	strb	r0, [r6, #1]
c0de12b8:	e051      	b.n	c0de135e <handle_query_contract_ui+0x596>
c0de12ba:	46c0      	nop			; (mov r8, r8)
c0de12bc:	000015b2 	.word	0x000015b2
c0de12c0:	000014cc 	.word	0x000014cc
c0de12c4:	000014ce 	.word	0x000014ce
c0de12c8:	000014cc 	.word	0x000014cc
c0de12cc:	000014ce 	.word	0x000014ce
c0de12d0:	000014d0 	.word	0x000014d0
c0de12d4:	00001395 	.word	0x00001395
c0de12d8:	00001334 	.word	0x00001334
c0de12dc:	0000130d 	.word	0x0000130d
c0de12e0:	000014ea 	.word	0x000014ea
c0de12e4:	00001406 	.word	0x00001406
c0de12e8:	0000140a 	.word	0x0000140a
c0de12ec:	0000140e 	.word	0x0000140e
c0de12f0:	00001412 	.word	0x00001412
c0de12f4:	00001416 	.word	0x00001416
            strlcpy(msg->title, "Wrap", msg->titleLength);
c0de12f8:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de12fa:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de12fc:	4933      	ldr	r1, [pc, #204]	; (c0de13cc <handle_query_contract_ui+0x604>)
c0de12fe:	4479      	add	r1, pc
c0de1300:	f000 fe38 	bl	c0de1f74 <strlcpy>
            if (memcmp(WOETH_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de1304:	6860      	ldr	r0, [r4, #4]
c0de1306:	6801      	ldr	r1, [r0, #0]
c0de1308:	31a5      	adds	r1, #165	; 0xa5
c0de130a:	4831      	ldr	r0, [pc, #196]	; (c0de13d0 <handle_query_contract_ui+0x608>)
c0de130c:	4478      	add	r0, pc
c0de130e:	2214      	movs	r2, #20
c0de1310:	f000 fcb4 	bl	c0de1c7c <memcmp>
c0de1314:	4601      	mov	r1, r0
c0de1316:	4628      	mov	r0, r5
c0de1318:	307c      	adds	r0, #124	; 0x7c
c0de131a:	2900      	cmp	r1, #0
c0de131c:	d017      	beq.n	c0de134e <handle_query_contract_ui+0x586>
c0de131e:	492d      	ldr	r1, [pc, #180]	; (c0de13d4 <handle_query_contract_ui+0x60c>)
c0de1320:	4479      	add	r1, pc
c0de1322:	e019      	b.n	c0de1358 <handle_query_contract_ui+0x590>
                strlcpy(context->ticker_received, "LST MIX", sizeof(context->ticker_received));
c0de1324:	493c      	ldr	r1, [pc, #240]	; (c0de1418 <handle_query_contract_ui+0x650>)
c0de1326:	4479      	add	r1, pc
c0de1328:	220b      	movs	r2, #11
c0de132a:	f000 fe23 	bl	c0de1f74 <strlcpy>
                   context->decimals_received,
c0de132e:	78b2      	ldrb	r2, [r6, #2]
                   context->amount_length,
c0de1330:	7971      	ldrb	r1, [r6, #5]
                   msg->msg,
c0de1332:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de1334:	6b23      	ldr	r3, [r4, #48]	; 0x30
    amountToString(context->min_amount_received,
c0de1336:	9000      	str	r0, [sp, #0]
c0de1338:	9301      	str	r3, [sp, #4]
c0de133a:	4628      	mov	r0, r5
c0de133c:	3020      	adds	r0, #32
                   context->ticker_received,
c0de133e:	3587      	adds	r5, #135	; 0x87
    amountToString(context->min_amount_received,
c0de1340:	462b      	mov	r3, r5
c0de1342:	f7ff f874 	bl	c0de042e <amountToString>
    PRINTF("AMOUNT RECEIVED: %s\n", msg->msg);
c0de1346:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de1348:	4830      	ldr	r0, [pc, #192]	; (c0de140c <handle_query_contract_ui+0x644>)
c0de134a:	4478      	add	r0, pc
c0de134c:	e015      	b.n	c0de137a <handle_query_contract_ui+0x5b2>
c0de134e:	491a      	ldr	r1, [pc, #104]	; (c0de13b8 <handle_query_contract_ui+0x5f0>)
c0de1350:	4479      	add	r1, pc
c0de1352:	e001      	b.n	c0de1358 <handle_query_contract_ui+0x590>
                strlcpy(context->ticker_sent, WOETH_TICKER, sizeof(context->ticker_sent));
c0de1354:	4922      	ldr	r1, [pc, #136]	; (c0de13e0 <handle_query_contract_ui+0x618>)
c0de1356:	4479      	add	r1, pc
c0de1358:	220b      	movs	r2, #11
c0de135a:	f000 fe0b 	bl	c0de1f74 <strlcpy>
                   context->decimals_sent,
c0de135e:	7872      	ldrb	r2, [r6, #1]
                   context->amount_length,
c0de1360:	7971      	ldrb	r1, [r6, #5]
                   msg->msg,
c0de1362:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de1364:	6b23      	ldr	r3, [r4, #48]	; 0x30
    amountToString(context->amount_sent,
c0de1366:	9000      	str	r0, [sp, #0]
c0de1368:	9301      	str	r3, [sp, #4]
                   context->ticker_sent,
c0de136a:	462b      	mov	r3, r5
c0de136c:	337c      	adds	r3, #124	; 0x7c
    amountToString(context->amount_sent,
c0de136e:	4628      	mov	r0, r5
c0de1370:	f7ff f85d 	bl	c0de042e <amountToString>
    PRINTF("AMOUNT SENT: %s\n", msg->msg);
c0de1374:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de1376:	481d      	ldr	r0, [pc, #116]	; (c0de13ec <handle_query_contract_ui+0x624>)
c0de1378:	4478      	add	r0, pc
c0de137a:	f000 f8c9 	bl	c0de1510 <mcu_usb_printf>
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }
}
c0de137e:	b007      	add	sp, #28
c0de1380:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1382:	46c0      	nop			; (mov r8, r8)
c0de1384:	000012dd 	.word	0x000012dd
c0de1388:	00001086 	.word	0x00001086
c0de138c:	000011e1 	.word	0x000011e1
c0de1390:	000012ff 	.word	0x000012ff
c0de1394:	000010cb 	.word	0x000010cb
c0de1398:	00000ec2 	.word	0x00000ec2
c0de139c:	00000fc7 	.word	0x00000fc7
c0de13a0:	00000ee1 	.word	0x00000ee1
c0de13a4:	00001115 	.word	0x00001115
c0de13a8:	000010a9 	.word	0x000010a9
c0de13ac:	00000f85 	.word	0x00000f85
c0de13b0:	00000ec4 	.word	0x00000ec4
c0de13b4:	00001182 	.word	0x00001182
c0de13b8:	00000ffd 	.word	0x00000ffd
c0de13bc:	00001041 	.word	0x00001041
c0de13c0:	00000dae 	.word	0x00000dae
c0de13c4:	00000eb3 	.word	0x00000eb3
c0de13c8:	00000f0d 	.word	0x00000f0d
c0de13cc:	00000f81 	.word	0x00000f81
c0de13d0:	00001118 	.word	0x00001118
c0de13d4:	00000e0d 	.word	0x00000e0d
c0de13d8:	000010ce 	.word	0x000010ce
c0de13dc:	000011e2 	.word	0x000011e2
c0de13e0:	00000ddc 	.word	0x00000ddc
c0de13e4:	00000ffb 	.word	0x00000ffb
c0de13e8:	00001093 	.word	0x00001093
c0de13ec:	00000f2d 	.word	0x00000f2d
c0de13f0:	0000131d 	.word	0x0000131d
c0de13f4:	000010e9 	.word	0x000010e9
c0de13f8:	00000ff8 	.word	0x00000ff8
c0de13fc:	000010f3 	.word	0x000010f3
c0de1400:	00001141 	.word	0x00001141
c0de1404:	00001314 	.word	0x00001314
c0de1408:	00001237 	.word	0x00001237
c0de140c:	00001008 	.word	0x00001008
c0de1410:	0000101d 	.word	0x0000101d
c0de1414:	000012d8 	.word	0x000012d8
c0de1418:	00000dee 	.word	0x00000dee
c0de141c:	00000ffd 	.word	0x00000ffd
c0de1420:	0000103d 	.word	0x0000103d
c0de1424:	00001175 	.word	0x00001175
c0de1428:	00000ed6 	.word	0x00000ed6
c0de142c:	00001033 	.word	0x00001033
c0de1430:	000010b8 	.word	0x000010b8

c0de1434 <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de1434:	b580      	push	{r7, lr}
c0de1436:	4602      	mov	r2, r0
c0de1438:	2083      	movs	r0, #131	; 0x83
c0de143a:	0040      	lsls	r0, r0, #1
    switch (message) {
c0de143c:	4282      	cmp	r2, r0
c0de143e:	d017      	beq.n	c0de1470 <dispatch_plugin_calls+0x3c>
c0de1440:	2081      	movs	r0, #129	; 0x81
c0de1442:	0040      	lsls	r0, r0, #1
c0de1444:	4282      	cmp	r2, r0
c0de1446:	d017      	beq.n	c0de1478 <dispatch_plugin_calls+0x44>
c0de1448:	20ff      	movs	r0, #255	; 0xff
c0de144a:	4603      	mov	r3, r0
c0de144c:	3304      	adds	r3, #4
c0de144e:	429a      	cmp	r2, r3
c0de1450:	d016      	beq.n	c0de1480 <dispatch_plugin_calls+0x4c>
c0de1452:	2341      	movs	r3, #65	; 0x41
c0de1454:	009b      	lsls	r3, r3, #2
c0de1456:	429a      	cmp	r2, r3
c0de1458:	d016      	beq.n	c0de1488 <dispatch_plugin_calls+0x54>
c0de145a:	4603      	mov	r3, r0
c0de145c:	3306      	adds	r3, #6
c0de145e:	429a      	cmp	r2, r3
c0de1460:	d016      	beq.n	c0de1490 <dispatch_plugin_calls+0x5c>
c0de1462:	3002      	adds	r0, #2
c0de1464:	4282      	cmp	r2, r0
c0de1466:	d117      	bne.n	c0de1498 <dispatch_plugin_calls+0x64>
            handle_init_contract(parameters);
c0de1468:	4608      	mov	r0, r1
c0de146a:	f7ff f89f 	bl	c0de05ac <handle_init_contract>
}
c0de146e:	bd80      	pop	{r7, pc}
            handle_query_contract_ui(parameters);
c0de1470:	4608      	mov	r0, r1
c0de1472:	f7ff fca9 	bl	c0de0dc8 <handle_query_contract_ui>
}
c0de1476:	bd80      	pop	{r7, pc}
            handle_provide_parameter(parameters);
c0de1478:	4608      	mov	r0, r1
c0de147a:	f7ff f90d 	bl	c0de0698 <handle_provide_parameter>
}
c0de147e:	bd80      	pop	{r7, pc}
            handle_finalize(parameters);
c0de1480:	4608      	mov	r0, r1
c0de1482:	f7ff f81b 	bl	c0de04bc <handle_finalize>
}
c0de1486:	bd80      	pop	{r7, pc}
            handle_provide_token(parameters);
c0de1488:	4608      	mov	r0, r1
c0de148a:	f7ff fb7f 	bl	c0de0b8c <handle_provide_token>
}
c0de148e:	bd80      	pop	{r7, pc}
            handle_query_contract_id(parameters);
c0de1490:	4608      	mov	r0, r1
c0de1492:	f7ff fc59 	bl	c0de0d48 <handle_query_contract_id>
}
c0de1496:	bd80      	pop	{r7, pc}
            PRINTF("Unhandled message %d\n", message);
c0de1498:	4802      	ldr	r0, [pc, #8]	; (c0de14a4 <dispatch_plugin_calls+0x70>)
c0de149a:	4478      	add	r0, pc
c0de149c:	4611      	mov	r1, r2
c0de149e:	f000 f837 	bl	c0de1510 <mcu_usb_printf>
}
c0de14a2:	bd80      	pop	{r7, pc}
c0de14a4:	00000da1 	.word	0x00000da1

c0de14a8 <call_app_ethereum>:
void call_app_ethereum() {
c0de14a8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    libcall_params[0] = (unsigned int) "Ethereum";
c0de14aa:	4805      	ldr	r0, [pc, #20]	; (c0de14c0 <call_app_ethereum+0x18>)
c0de14ac:	4478      	add	r0, pc
c0de14ae:	9001      	str	r0, [sp, #4]
c0de14b0:	2001      	movs	r0, #1
    libcall_params[2] = RUN_APPLICATION;
c0de14b2:	9003      	str	r0, [sp, #12]
c0de14b4:	0200      	lsls	r0, r0, #8
    libcall_params[1] = 0x100;
c0de14b6:	9002      	str	r0, [sp, #8]
c0de14b8:	a801      	add	r0, sp, #4
    os_lib_call((unsigned int *) &libcall_params);
c0de14ba:	f000 f9b9 	bl	c0de1830 <os_lib_call>
}
c0de14be:	bd8f      	pop	{r0, r1, r2, r3, r7, pc}
c0de14c0:	00000cb8 	.word	0x00000cb8

c0de14c4 <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de14c4:	b580      	push	{r7, lr}
c0de14c6:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de14c8:	f000 f9e4 	bl	c0de1894 <try_context_set>
#endif // HAVE_BOLOS
}
c0de14cc:	bd80      	pop	{r7, pc}
c0de14ce:	d4d4      	bmi.n	c0de147a <dispatch_plugin_calls+0x46>

c0de14d0 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de14d0:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF  
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de14d2:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de14d4:	4804      	ldr	r0, [pc, #16]	; (c0de14e8 <os_longjmp+0x18>)
c0de14d6:	4478      	add	r0, pc
c0de14d8:	4621      	mov	r1, r4
c0de14da:	f000 f819 	bl	c0de1510 <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de14de:	f000 f9d1 	bl	c0de1884 <try_context_get>
c0de14e2:	4621      	mov	r1, r4
c0de14e4:	f000 fd04 	bl	c0de1ef0 <longjmp>
c0de14e8:	00000d42 	.word	0x00000d42

c0de14ec <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de14ec:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de14ee:	460c      	mov	r4, r1
c0de14f0:	4605      	mov	r5, r0
c0de14f2:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de14f4:	7081      	strb	r1, [r0, #2]
c0de14f6:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de14f8:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de14fa:	0a21      	lsrs	r1, r4, #8
c0de14fc:	7041      	strb	r1, [r0, #1]
c0de14fe:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de1500:	f000 f9b6 	bl	c0de1870 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de1504:	b2a1      	uxth	r1, r4
c0de1506:	4628      	mov	r0, r5
c0de1508:	f000 f9b2 	bl	c0de1870 <io_seph_send>
}
c0de150c:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
c0de150e:	d4d4      	bmi.n	c0de14ba <call_app_ethereum+0x12>

c0de1510 <mcu_usb_printf>:
#include "usbd_def.h"
#include "usbd_core.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de1510:	b083      	sub	sp, #12
c0de1512:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1514:	b08e      	sub	sp, #56	; 0x38
c0de1516:	ac13      	add	r4, sp, #76	; 0x4c
c0de1518:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de151a:	2800      	cmp	r0, #0
c0de151c:	d100      	bne.n	c0de1520 <mcu_usb_printf+0x10>
c0de151e:	e163      	b.n	c0de17e8 <mcu_usb_printf+0x2d8>
c0de1520:	4607      	mov	r7, r0
c0de1522:	a813      	add	r0, sp, #76	; 0x4c
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de1524:	9008      	str	r0, [sp, #32]
c0de1526:	2001      	movs	r0, #1
c0de1528:	9003      	str	r0, [sp, #12]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de152a:	7838      	ldrb	r0, [r7, #0]
c0de152c:	2800      	cmp	r0, #0
c0de152e:	d100      	bne.n	c0de1532 <mcu_usb_printf+0x22>
c0de1530:	e15a      	b.n	c0de17e8 <mcu_usb_printf+0x2d8>
c0de1532:	463c      	mov	r4, r7
c0de1534:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de1536:	2800      	cmp	r0, #0
c0de1538:	d005      	beq.n	c0de1546 <mcu_usb_printf+0x36>
c0de153a:	2825      	cmp	r0, #37	; 0x25
c0de153c:	d003      	beq.n	c0de1546 <mcu_usb_printf+0x36>
c0de153e:	1960      	adds	r0, r4, r5
c0de1540:	7840      	ldrb	r0, [r0, #1]
            ulIdx++)
c0de1542:	1c6d      	adds	r5, r5, #1
c0de1544:	e7f7      	b.n	c0de1536 <mcu_usb_printf+0x26>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de1546:	4620      	mov	r0, r4
c0de1548:	4629      	mov	r1, r5
c0de154a:	f7ff ffcf 	bl	c0de14ec <mcu_usb_prints>
c0de154e:	1967      	adds	r7, r4, r5
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de1550:	5d60      	ldrb	r0, [r4, r5]
c0de1552:	2825      	cmp	r0, #37	; 0x25
c0de1554:	d1e9      	bne.n	c0de152a <mcu_usb_printf+0x1a>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de1556:	1960      	adds	r0, r4, r5
c0de1558:	1c47      	adds	r7, r0, #1
c0de155a:	2400      	movs	r4, #0
c0de155c:	2620      	movs	r6, #32
c0de155e:	9407      	str	r4, [sp, #28]
c0de1560:	4622      	mov	r2, r4
c0de1562:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de1564:	7839      	ldrb	r1, [r7, #0]
c0de1566:	1c7f      	adds	r7, r7, #1
c0de1568:	2200      	movs	r2, #0
c0de156a:	292d      	cmp	r1, #45	; 0x2d
c0de156c:	d0f9      	beq.n	c0de1562 <mcu_usb_printf+0x52>
c0de156e:	460a      	mov	r2, r1
c0de1570:	3a30      	subs	r2, #48	; 0x30
c0de1572:	2a0a      	cmp	r2, #10
c0de1574:	d316      	bcc.n	c0de15a4 <mcu_usb_printf+0x94>
c0de1576:	2925      	cmp	r1, #37	; 0x25
c0de1578:	d044      	beq.n	c0de1604 <mcu_usb_printf+0xf4>
c0de157a:	292a      	cmp	r1, #42	; 0x2a
c0de157c:	9704      	str	r7, [sp, #16]
c0de157e:	d01e      	beq.n	c0de15be <mcu_usb_printf+0xae>
c0de1580:	292e      	cmp	r1, #46	; 0x2e
c0de1582:	d127      	bne.n	c0de15d4 <mcu_usb_printf+0xc4>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de1584:	7838      	ldrb	r0, [r7, #0]
c0de1586:	282a      	cmp	r0, #42	; 0x2a
c0de1588:	d17d      	bne.n	c0de1686 <mcu_usb_printf+0x176>
c0de158a:	9804      	ldr	r0, [sp, #16]
c0de158c:	7840      	ldrb	r0, [r0, #1]
c0de158e:	2848      	cmp	r0, #72	; 0x48
c0de1590:	d003      	beq.n	c0de159a <mcu_usb_printf+0x8a>
c0de1592:	2873      	cmp	r0, #115	; 0x73
c0de1594:	d001      	beq.n	c0de159a <mcu_usb_printf+0x8a>
c0de1596:	2868      	cmp	r0, #104	; 0x68
c0de1598:	d175      	bne.n	c0de1686 <mcu_usb_printf+0x176>
c0de159a:	9f04      	ldr	r7, [sp, #16]
c0de159c:	1c7f      	adds	r7, r7, #1
c0de159e:	2201      	movs	r2, #1

                    // skip '*' char
                    format++;

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de15a0:	9808      	ldr	r0, [sp, #32]
c0de15a2:	e012      	b.n	c0de15ca <mcu_usb_printf+0xba>
c0de15a4:	2230      	movs	r2, #48	; 0x30
                    if((format[-1] == '0') && (ulCount == 0))
c0de15a6:	460b      	mov	r3, r1
c0de15a8:	4053      	eors	r3, r2
c0de15aa:	4323      	orrs	r3, r4
c0de15ac:	d000      	beq.n	c0de15b0 <mcu_usb_printf+0xa0>
c0de15ae:	4632      	mov	r2, r6
c0de15b0:	230a      	movs	r3, #10
                    ulCount *= 10;
c0de15b2:	4363      	muls	r3, r4
                    ulCount += format[-1] - '0';
c0de15b4:	185c      	adds	r4, r3, r1
c0de15b6:	3c30      	subs	r4, #48	; 0x30
c0de15b8:	4616      	mov	r6, r2
c0de15ba:	4602      	mov	r2, r0
c0de15bc:	e7d1      	b.n	c0de1562 <mcu_usb_printf+0x52>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de15be:	7838      	ldrb	r0, [r7, #0]
c0de15c0:	2873      	cmp	r0, #115	; 0x73
c0de15c2:	d160      	bne.n	c0de1686 <mcu_usb_printf+0x176>
c0de15c4:	2202      	movs	r2, #2

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de15c6:	9808      	ldr	r0, [sp, #32]
c0de15c8:	9f04      	ldr	r7, [sp, #16]
c0de15ca:	1d01      	adds	r1, r0, #4
c0de15cc:	9108      	str	r1, [sp, #32]
c0de15ce:	6800      	ldr	r0, [r0, #0]
            switch(*format++)
c0de15d0:	9007      	str	r0, [sp, #28]
c0de15d2:	e7c6      	b.n	c0de1562 <mcu_usb_printf+0x52>
c0de15d4:	2948      	cmp	r1, #72	; 0x48
c0de15d6:	d017      	beq.n	c0de1608 <mcu_usb_printf+0xf8>
c0de15d8:	2958      	cmp	r1, #88	; 0x58
c0de15da:	d01a      	beq.n	c0de1612 <mcu_usb_printf+0x102>
c0de15dc:	2963      	cmp	r1, #99	; 0x63
c0de15de:	d025      	beq.n	c0de162c <mcu_usb_printf+0x11c>
c0de15e0:	2964      	cmp	r1, #100	; 0x64
c0de15e2:	d02d      	beq.n	c0de1640 <mcu_usb_printf+0x130>
c0de15e4:	4a83      	ldr	r2, [pc, #524]	; (c0de17f4 <mcu_usb_printf+0x2e4>)
c0de15e6:	447a      	add	r2, pc
c0de15e8:	9206      	str	r2, [sp, #24]
c0de15ea:	2968      	cmp	r1, #104	; 0x68
c0de15ec:	d037      	beq.n	c0de165e <mcu_usb_printf+0x14e>
c0de15ee:	2970      	cmp	r1, #112	; 0x70
c0de15f0:	d005      	beq.n	c0de15fe <mcu_usb_printf+0xee>
c0de15f2:	2973      	cmp	r1, #115	; 0x73
c0de15f4:	d036      	beq.n	c0de1664 <mcu_usb_printf+0x154>
c0de15f6:	2975      	cmp	r1, #117	; 0x75
c0de15f8:	d049      	beq.n	c0de168e <mcu_usb_printf+0x17e>
c0de15fa:	2978      	cmp	r1, #120	; 0x78
c0de15fc:	d143      	bne.n	c0de1686 <mcu_usb_printf+0x176>
c0de15fe:	9601      	str	r6, [sp, #4]
c0de1600:	2000      	movs	r0, #0
c0de1602:	e008      	b.n	c0de1616 <mcu_usb_printf+0x106>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de1604:	1e78      	subs	r0, r7, #1
c0de1606:	e017      	b.n	c0de1638 <mcu_usb_printf+0x128>
c0de1608:	9405      	str	r4, [sp, #20]
c0de160a:	497b      	ldr	r1, [pc, #492]	; (c0de17f8 <mcu_usb_printf+0x2e8>)
c0de160c:	4479      	add	r1, pc
c0de160e:	9106      	str	r1, [sp, #24]
c0de1610:	e026      	b.n	c0de1660 <mcu_usb_printf+0x150>
c0de1612:	9601      	str	r6, [sp, #4]
c0de1614:	2001      	movs	r0, #1
c0de1616:	9000      	str	r0, [sp, #0]
c0de1618:	9f03      	ldr	r7, [sp, #12]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de161a:	9808      	ldr	r0, [sp, #32]
c0de161c:	1d01      	adds	r1, r0, #4
c0de161e:	9108      	str	r1, [sp, #32]
c0de1620:	6800      	ldr	r0, [r0, #0]
c0de1622:	9005      	str	r0, [sp, #20]
c0de1624:	900d      	str	r0, [sp, #52]	; 0x34
c0de1626:	2010      	movs	r0, #16
c0de1628:	9006      	str	r0, [sp, #24]
c0de162a:	e03c      	b.n	c0de16a6 <mcu_usb_printf+0x196>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de162c:	9808      	ldr	r0, [sp, #32]
c0de162e:	1d01      	adds	r1, r0, #4
c0de1630:	9108      	str	r1, [sp, #32]
c0de1632:	6800      	ldr	r0, [r0, #0]
c0de1634:	900d      	str	r0, [sp, #52]	; 0x34
c0de1636:	a80d      	add	r0, sp, #52	; 0x34
c0de1638:	2101      	movs	r1, #1
c0de163a:	f7ff ff57 	bl	c0de14ec <mcu_usb_prints>
c0de163e:	e774      	b.n	c0de152a <mcu_usb_printf+0x1a>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1640:	9808      	ldr	r0, [sp, #32]
c0de1642:	1d01      	adds	r1, r0, #4
c0de1644:	9108      	str	r1, [sp, #32]
c0de1646:	6800      	ldr	r0, [r0, #0]
c0de1648:	900d      	str	r0, [sp, #52]	; 0x34
c0de164a:	210a      	movs	r1, #10
                    if((long)ulValue < 0)
c0de164c:	2800      	cmp	r0, #0
c0de164e:	9601      	str	r6, [sp, #4]
c0de1650:	9106      	str	r1, [sp, #24]
c0de1652:	d500      	bpl.n	c0de1656 <mcu_usb_printf+0x146>
c0de1654:	e0b7      	b.n	c0de17c6 <mcu_usb_printf+0x2b6>
c0de1656:	9005      	str	r0, [sp, #20]
c0de1658:	2000      	movs	r0, #0
c0de165a:	9000      	str	r0, [sp, #0]
c0de165c:	e022      	b.n	c0de16a4 <mcu_usb_printf+0x194>
c0de165e:	9405      	str	r4, [sp, #20]
c0de1660:	9903      	ldr	r1, [sp, #12]
c0de1662:	e001      	b.n	c0de1668 <mcu_usb_printf+0x158>
c0de1664:	9405      	str	r4, [sp, #20]
c0de1666:	2100      	movs	r1, #0
                    pcStr = va_arg(vaArgP, char *);
c0de1668:	9a08      	ldr	r2, [sp, #32]
c0de166a:	1d13      	adds	r3, r2, #4
c0de166c:	9308      	str	r3, [sp, #32]
                    switch(cStrlenSet) {
c0de166e:	b2c0      	uxtb	r0, r0
                    pcStr = va_arg(vaArgP, char *);
c0de1670:	6817      	ldr	r7, [r2, #0]
                    switch(cStrlenSet) {
c0de1672:	2800      	cmp	r0, #0
c0de1674:	d074      	beq.n	c0de1760 <mcu_usb_printf+0x250>
c0de1676:	2801      	cmp	r0, #1
c0de1678:	d079      	beq.n	c0de176e <mcu_usb_printf+0x25e>
c0de167a:	2802      	cmp	r0, #2
c0de167c:	d178      	bne.n	c0de1770 <mcu_usb_printf+0x260>
                        if (pcStr[0] == '\0') {
c0de167e:	7838      	ldrb	r0, [r7, #0]
c0de1680:	2800      	cmp	r0, #0
c0de1682:	d100      	bne.n	c0de1686 <mcu_usb_printf+0x176>
c0de1684:	e0a6      	b.n	c0de17d4 <mcu_usb_printf+0x2c4>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de1686:	4861      	ldr	r0, [pc, #388]	; (c0de180c <mcu_usb_printf+0x2fc>)
c0de1688:	4478      	add	r0, pc
c0de168a:	2105      	movs	r1, #5
c0de168c:	e064      	b.n	c0de1758 <mcu_usb_printf+0x248>
c0de168e:	9601      	str	r6, [sp, #4]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1690:	9808      	ldr	r0, [sp, #32]
c0de1692:	1d01      	adds	r1, r0, #4
c0de1694:	9108      	str	r1, [sp, #32]
c0de1696:	6800      	ldr	r0, [r0, #0]
c0de1698:	9005      	str	r0, [sp, #20]
c0de169a:	900d      	str	r0, [sp, #52]	; 0x34
c0de169c:	2000      	movs	r0, #0
c0de169e:	9000      	str	r0, [sp, #0]
c0de16a0:	200a      	movs	r0, #10
c0de16a2:	9006      	str	r0, [sp, #24]
c0de16a4:	9f03      	ldr	r7, [sp, #12]
c0de16a6:	4639      	mov	r1, r7
c0de16a8:	4856      	ldr	r0, [pc, #344]	; (c0de1804 <mcu_usb_printf+0x2f4>)
c0de16aa:	4478      	add	r0, pc
                    for(ulIdx = 1;
c0de16ac:	9007      	str	r0, [sp, #28]
c0de16ae:	9102      	str	r1, [sp, #8]
c0de16b0:	19c8      	adds	r0, r1, r7
c0de16b2:	4038      	ands	r0, r7
c0de16b4:	1a26      	subs	r6, r4, r0
c0de16b6:	1e75      	subs	r5, r6, #1
c0de16b8:	2400      	movs	r4, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de16ba:	9806      	ldr	r0, [sp, #24]
c0de16bc:	4621      	mov	r1, r4
c0de16be:	463a      	mov	r2, r7
c0de16c0:	4623      	mov	r3, r4
c0de16c2:	f000 f99f 	bl	c0de1a04 <__aeabi_lmul>
c0de16c6:	1e4a      	subs	r2, r1, #1
c0de16c8:	4191      	sbcs	r1, r2
c0de16ca:	9a05      	ldr	r2, [sp, #20]
c0de16cc:	4290      	cmp	r0, r2
c0de16ce:	d805      	bhi.n	c0de16dc <mcu_usb_printf+0x1cc>
                    for(ulIdx = 1;
c0de16d0:	2900      	cmp	r1, #0
c0de16d2:	d103      	bne.n	c0de16dc <mcu_usb_printf+0x1cc>
c0de16d4:	1e6d      	subs	r5, r5, #1
c0de16d6:	1e76      	subs	r6, r6, #1
c0de16d8:	4607      	mov	r7, r0
c0de16da:	e7ed      	b.n	c0de16b8 <mcu_usb_printf+0x1a8>
                    if(ulNeg && (cFill == '0'))
c0de16dc:	9802      	ldr	r0, [sp, #8]
c0de16de:	2800      	cmp	r0, #0
c0de16e0:	9803      	ldr	r0, [sp, #12]
c0de16e2:	9a01      	ldr	r2, [sp, #4]
c0de16e4:	d109      	bne.n	c0de16fa <mcu_usb_printf+0x1ea>
c0de16e6:	b2d1      	uxtb	r1, r2
c0de16e8:	2000      	movs	r0, #0
c0de16ea:	2930      	cmp	r1, #48	; 0x30
c0de16ec:	4604      	mov	r4, r0
c0de16ee:	d104      	bne.n	c0de16fa <mcu_usb_printf+0x1ea>
c0de16f0:	a809      	add	r0, sp, #36	; 0x24
c0de16f2:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de16f4:	7001      	strb	r1, [r0, #0]
c0de16f6:	2401      	movs	r4, #1
c0de16f8:	9803      	ldr	r0, [sp, #12]
                    if((ulCount > 1) && (ulCount < 16))
c0de16fa:	1eb1      	subs	r1, r6, #2
c0de16fc:	290d      	cmp	r1, #13
c0de16fe:	d807      	bhi.n	c0de1710 <mcu_usb_printf+0x200>
c0de1700:	9e06      	ldr	r6, [sp, #24]
                        for(ulCount--; ulCount; ulCount--)
c0de1702:	2d00      	cmp	r5, #0
c0de1704:	d005      	beq.n	c0de1712 <mcu_usb_printf+0x202>
c0de1706:	a909      	add	r1, sp, #36	; 0x24
                            pcBuf[ulPos++] = cFill;
c0de1708:	550a      	strb	r2, [r1, r4]
                        for(ulCount--; ulCount; ulCount--)
c0de170a:	1e6d      	subs	r5, r5, #1
                            pcBuf[ulPos++] = cFill;
c0de170c:	1c64      	adds	r4, r4, #1
c0de170e:	e7f8      	b.n	c0de1702 <mcu_usb_printf+0x1f2>
c0de1710:	9e06      	ldr	r6, [sp, #24]
                    if(ulNeg)
c0de1712:	2800      	cmp	r0, #0
c0de1714:	9d05      	ldr	r5, [sp, #20]
c0de1716:	d103      	bne.n	c0de1720 <mcu_usb_printf+0x210>
c0de1718:	a809      	add	r0, sp, #36	; 0x24
c0de171a:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de171c:	5501      	strb	r1, [r0, r4]
c0de171e:	1c64      	adds	r4, r4, #1
c0de1720:	9800      	ldr	r0, [sp, #0]
c0de1722:	2800      	cmp	r0, #0
c0de1724:	d114      	bne.n	c0de1750 <mcu_usb_printf+0x240>
c0de1726:	4838      	ldr	r0, [pc, #224]	; (c0de1808 <mcu_usb_printf+0x2f8>)
c0de1728:	4478      	add	r0, pc
c0de172a:	9007      	str	r0, [sp, #28]
c0de172c:	e010      	b.n	c0de1750 <mcu_usb_printf+0x240>
c0de172e:	4628      	mov	r0, r5
c0de1730:	4639      	mov	r1, r7
c0de1732:	f000 f8bb 	bl	c0de18ac <__udivsi3>
c0de1736:	4631      	mov	r1, r6
c0de1738:	f000 f93e 	bl	c0de19b8 <__aeabi_uidivmod>
c0de173c:	9807      	ldr	r0, [sp, #28]
c0de173e:	5c40      	ldrb	r0, [r0, r1]
c0de1740:	a909      	add	r1, sp, #36	; 0x24
                          pcBuf[ulPos++] = g_pcHex[(ulValue / ulIdx) % ulBase];
c0de1742:	5508      	strb	r0, [r1, r4]
                    for(; ulIdx; ulIdx /= ulBase)
c0de1744:	4638      	mov	r0, r7
c0de1746:	4631      	mov	r1, r6
c0de1748:	f000 f8b0 	bl	c0de18ac <__udivsi3>
c0de174c:	4607      	mov	r7, r0
c0de174e:	1c64      	adds	r4, r4, #1
c0de1750:	2f00      	cmp	r7, #0
c0de1752:	d1ec      	bne.n	c0de172e <mcu_usb_printf+0x21e>
c0de1754:	a809      	add	r0, sp, #36	; 0x24
                    mcu_usb_prints(pcBuf, ulPos);
c0de1756:	4621      	mov	r1, r4
c0de1758:	f7ff fec8 	bl	c0de14ec <mcu_usb_prints>
c0de175c:	9f04      	ldr	r7, [sp, #16]
c0de175e:	e6e4      	b.n	c0de152a <mcu_usb_printf+0x1a>
c0de1760:	2000      	movs	r0, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de1762:	5c3a      	ldrb	r2, [r7, r0]
c0de1764:	1c40      	adds	r0, r0, #1
c0de1766:	2a00      	cmp	r2, #0
c0de1768:	d1fb      	bne.n	c0de1762 <mcu_usb_printf+0x252>
                    switch(ulBase) {
c0de176a:	1e45      	subs	r5, r0, #1
c0de176c:	e000      	b.n	c0de1770 <mcu_usb_printf+0x260>
c0de176e:	9d07      	ldr	r5, [sp, #28]
c0de1770:	2900      	cmp	r1, #0
c0de1772:	d014      	beq.n	c0de179e <mcu_usb_printf+0x28e>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de1774:	2d00      	cmp	r5, #0
c0de1776:	d0f1      	beq.n	c0de175c <mcu_usb_printf+0x24c>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de1778:	783e      	ldrb	r6, [r7, #0]
c0de177a:	0930      	lsrs	r0, r6, #4
c0de177c:	9c06      	ldr	r4, [sp, #24]
c0de177e:	1820      	adds	r0, r4, r0
c0de1780:	9507      	str	r5, [sp, #28]
c0de1782:	2501      	movs	r5, #1
c0de1784:	4629      	mov	r1, r5
c0de1786:	f7ff feb1 	bl	c0de14ec <mcu_usb_prints>
c0de178a:	200f      	movs	r0, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de178c:	4030      	ands	r0, r6
c0de178e:	1820      	adds	r0, r4, r0
c0de1790:	4629      	mov	r1, r5
c0de1792:	9d07      	ldr	r5, [sp, #28]
c0de1794:	f7ff feaa 	bl	c0de14ec <mcu_usb_prints>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de1798:	1c7f      	adds	r7, r7, #1
c0de179a:	1e6d      	subs	r5, r5, #1
c0de179c:	e7ea      	b.n	c0de1774 <mcu_usb_printf+0x264>
                        mcu_usb_prints(pcStr, ulIdx);
c0de179e:	4638      	mov	r0, r7
c0de17a0:	4629      	mov	r1, r5
c0de17a2:	f7ff fea3 	bl	c0de14ec <mcu_usb_prints>
c0de17a6:	9f04      	ldr	r7, [sp, #16]
c0de17a8:	9805      	ldr	r0, [sp, #20]
                    if(ulCount > ulIdx)
c0de17aa:	42a8      	cmp	r0, r5
c0de17ac:	d800      	bhi.n	c0de17b0 <mcu_usb_printf+0x2a0>
c0de17ae:	e6bc      	b.n	c0de152a <mcu_usb_printf+0x1a>
                        while(ulCount--)
c0de17b0:	1a2c      	subs	r4, r5, r0
c0de17b2:	2c00      	cmp	r4, #0
c0de17b4:	d100      	bne.n	c0de17b8 <mcu_usb_printf+0x2a8>
c0de17b6:	e6b8      	b.n	c0de152a <mcu_usb_printf+0x1a>
                            mcu_usb_prints(" ", 1);
c0de17b8:	4811      	ldr	r0, [pc, #68]	; (c0de1800 <mcu_usb_printf+0x2f0>)
c0de17ba:	4478      	add	r0, pc
c0de17bc:	2101      	movs	r1, #1
c0de17be:	f7ff fe95 	bl	c0de14ec <mcu_usb_prints>
                        while(ulCount--)
c0de17c2:	1c64      	adds	r4, r4, #1
c0de17c4:	e7f5      	b.n	c0de17b2 <mcu_usb_printf+0x2a2>
                        ulValue = -(long)ulValue;
c0de17c6:	4240      	negs	r0, r0
c0de17c8:	9005      	str	r0, [sp, #20]
c0de17ca:	900d      	str	r0, [sp, #52]	; 0x34
c0de17cc:	2100      	movs	r1, #0
            ulCap = 0;
c0de17ce:	9100      	str	r1, [sp, #0]
c0de17d0:	9f03      	ldr	r7, [sp, #12]
c0de17d2:	e769      	b.n	c0de16a8 <mcu_usb_printf+0x198>
                          do {
c0de17d4:	9807      	ldr	r0, [sp, #28]
c0de17d6:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de17d8:	4808      	ldr	r0, [pc, #32]	; (c0de17fc <mcu_usb_printf+0x2ec>)
c0de17da:	4478      	add	r0, pc
c0de17dc:	2101      	movs	r1, #1
c0de17de:	f7ff fe85 	bl	c0de14ec <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de17e2:	1e64      	subs	r4, r4, #1
c0de17e4:	d1f8      	bne.n	c0de17d8 <mcu_usb_printf+0x2c8>
c0de17e6:	e7de      	b.n	c0de17a6 <mcu_usb_printf+0x296>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de17e8:	b00e      	add	sp, #56	; 0x38
c0de17ea:	bcf0      	pop	{r4, r5, r6, r7}
c0de17ec:	bc01      	pop	{r0}
c0de17ee:	b003      	add	sp, #12
c0de17f0:	4700      	bx	r0
c0de17f2:	46c0      	nop			; (mov r8, r8)
c0de17f4:	00000e7a 	.word	0x00000e7a
c0de17f8:	00000e64 	.word	0x00000e64
c0de17fc:	000008e0 	.word	0x000008e0
c0de1800:	00000900 	.word	0x00000900
c0de1804:	00000dc6 	.word	0x00000dc6
c0de1808:	00000d38 	.word	0x00000d38
c0de180c:	00000baa 	.word	0x00000baa

c0de1810 <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de1810:	df01      	svc	1
    cmp r1, #0
c0de1812:	2900      	cmp	r1, #0
    bne exception
c0de1814:	d100      	bne.n	c0de1818 <exception>
    bx lr
c0de1816:	4770      	bx	lr

c0de1818 <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de1818:	4608      	mov	r0, r1
    bl os_longjmp
c0de181a:	f7ff fe59 	bl	c0de14d0 <os_longjmp>

c0de181e <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de181e:	b5e0      	push	{r5, r6, r7, lr}
c0de1820:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de1822:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de1824:	9000      	str	r0, [sp, #0]
c0de1826:	2001      	movs	r0, #1
c0de1828:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de182a:	f7ff fff1 	bl	c0de1810 <SVC_Call>
c0de182e:	bd8c      	pop	{r2, r3, r7, pc}

c0de1830 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de1830:	b5e0      	push	{r5, r6, r7, lr}
c0de1832:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de1834:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de1836:	9000      	str	r0, [sp, #0]
c0de1838:	4802      	ldr	r0, [pc, #8]	; (c0de1844 <os_lib_call+0x14>)
c0de183a:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de183c:	f7ff ffe8 	bl	c0de1810 <SVC_Call>
  return;
}
c0de1840:	bd8c      	pop	{r2, r3, r7, pc}
c0de1842:	46c0      	nop			; (mov r8, r8)
c0de1844:	01000067 	.word	0x01000067

c0de1848 <os_lib_end>:

void __attribute__((noreturn)) os_lib_end ( void ) {
c0de1848:	b082      	sub	sp, #8
c0de184a:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de184c:	9001      	str	r0, [sp, #4]
c0de184e:	2068      	movs	r0, #104	; 0x68
c0de1850:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de1852:	f7ff ffdd 	bl	c0de1810 <SVC_Call>

  // The os_lib_end syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de1856:	deff      	udf	#255	; 0xff

c0de1858 <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de1858:	b082      	sub	sp, #8
c0de185a:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de185c:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de185e:	9000      	str	r0, [sp, #0]
c0de1860:	4802      	ldr	r0, [pc, #8]	; (c0de186c <os_sched_exit+0x14>)
c0de1862:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de1864:	f7ff ffd4 	bl	c0de1810 <SVC_Call>

  // The os_sched_exit syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de1868:	deff      	udf	#255	; 0xff
c0de186a:	46c0      	nop			; (mov r8, r8)
c0de186c:	0100009a 	.word	0x0100009a

c0de1870 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de1870:	b5e0      	push	{r5, r6, r7, lr}
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de1872:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de1874:	9000      	str	r0, [sp, #0]
c0de1876:	4802      	ldr	r0, [pc, #8]	; (c0de1880 <io_seph_send+0x10>)
c0de1878:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de187a:	f7ff ffc9 	bl	c0de1810 <SVC_Call>
  return;
}
c0de187e:	bd8c      	pop	{r2, r3, r7, pc}
c0de1880:	02000083 	.word	0x02000083

c0de1884 <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de1884:	b5e0      	push	{r5, r6, r7, lr}
c0de1886:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de1888:	9001      	str	r0, [sp, #4]
c0de188a:	2087      	movs	r0, #135	; 0x87
c0de188c:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de188e:	f7ff ffbf 	bl	c0de1810 <SVC_Call>
c0de1892:	bd8c      	pop	{r2, r3, r7, pc}

c0de1894 <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de1894:	b5e0      	push	{r5, r6, r7, lr}
c0de1896:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de1898:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de189a:	9000      	str	r0, [sp, #0]
c0de189c:	4802      	ldr	r0, [pc, #8]	; (c0de18a8 <try_context_set+0x14>)
c0de189e:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de18a0:	f7ff ffb6 	bl	c0de1810 <SVC_Call>
c0de18a4:	bd8c      	pop	{r2, r3, r7, pc}
c0de18a6:	46c0      	nop			; (mov r8, r8)
c0de18a8:	0100010b 	.word	0x0100010b

c0de18ac <__udivsi3>:
c0de18ac:	2200      	movs	r2, #0
c0de18ae:	0843      	lsrs	r3, r0, #1
c0de18b0:	428b      	cmp	r3, r1
c0de18b2:	d374      	bcc.n	c0de199e <__udivsi3+0xf2>
c0de18b4:	0903      	lsrs	r3, r0, #4
c0de18b6:	428b      	cmp	r3, r1
c0de18b8:	d35f      	bcc.n	c0de197a <__udivsi3+0xce>
c0de18ba:	0a03      	lsrs	r3, r0, #8
c0de18bc:	428b      	cmp	r3, r1
c0de18be:	d344      	bcc.n	c0de194a <__udivsi3+0x9e>
c0de18c0:	0b03      	lsrs	r3, r0, #12
c0de18c2:	428b      	cmp	r3, r1
c0de18c4:	d328      	bcc.n	c0de1918 <__udivsi3+0x6c>
c0de18c6:	0c03      	lsrs	r3, r0, #16
c0de18c8:	428b      	cmp	r3, r1
c0de18ca:	d30d      	bcc.n	c0de18e8 <__udivsi3+0x3c>
c0de18cc:	22ff      	movs	r2, #255	; 0xff
c0de18ce:	0209      	lsls	r1, r1, #8
c0de18d0:	ba12      	rev	r2, r2
c0de18d2:	0c03      	lsrs	r3, r0, #16
c0de18d4:	428b      	cmp	r3, r1
c0de18d6:	d302      	bcc.n	c0de18de <__udivsi3+0x32>
c0de18d8:	1212      	asrs	r2, r2, #8
c0de18da:	0209      	lsls	r1, r1, #8
c0de18dc:	d065      	beq.n	c0de19aa <__udivsi3+0xfe>
c0de18de:	0b03      	lsrs	r3, r0, #12
c0de18e0:	428b      	cmp	r3, r1
c0de18e2:	d319      	bcc.n	c0de1918 <__udivsi3+0x6c>
c0de18e4:	e000      	b.n	c0de18e8 <__udivsi3+0x3c>
c0de18e6:	0a09      	lsrs	r1, r1, #8
c0de18e8:	0bc3      	lsrs	r3, r0, #15
c0de18ea:	428b      	cmp	r3, r1
c0de18ec:	d301      	bcc.n	c0de18f2 <__udivsi3+0x46>
c0de18ee:	03cb      	lsls	r3, r1, #15
c0de18f0:	1ac0      	subs	r0, r0, r3
c0de18f2:	4152      	adcs	r2, r2
c0de18f4:	0b83      	lsrs	r3, r0, #14
c0de18f6:	428b      	cmp	r3, r1
c0de18f8:	d301      	bcc.n	c0de18fe <__udivsi3+0x52>
c0de18fa:	038b      	lsls	r3, r1, #14
c0de18fc:	1ac0      	subs	r0, r0, r3
c0de18fe:	4152      	adcs	r2, r2
c0de1900:	0b43      	lsrs	r3, r0, #13
c0de1902:	428b      	cmp	r3, r1
c0de1904:	d301      	bcc.n	c0de190a <__udivsi3+0x5e>
c0de1906:	034b      	lsls	r3, r1, #13
c0de1908:	1ac0      	subs	r0, r0, r3
c0de190a:	4152      	adcs	r2, r2
c0de190c:	0b03      	lsrs	r3, r0, #12
c0de190e:	428b      	cmp	r3, r1
c0de1910:	d301      	bcc.n	c0de1916 <__udivsi3+0x6a>
c0de1912:	030b      	lsls	r3, r1, #12
c0de1914:	1ac0      	subs	r0, r0, r3
c0de1916:	4152      	adcs	r2, r2
c0de1918:	0ac3      	lsrs	r3, r0, #11
c0de191a:	428b      	cmp	r3, r1
c0de191c:	d301      	bcc.n	c0de1922 <__udivsi3+0x76>
c0de191e:	02cb      	lsls	r3, r1, #11
c0de1920:	1ac0      	subs	r0, r0, r3
c0de1922:	4152      	adcs	r2, r2
c0de1924:	0a83      	lsrs	r3, r0, #10
c0de1926:	428b      	cmp	r3, r1
c0de1928:	d301      	bcc.n	c0de192e <__udivsi3+0x82>
c0de192a:	028b      	lsls	r3, r1, #10
c0de192c:	1ac0      	subs	r0, r0, r3
c0de192e:	4152      	adcs	r2, r2
c0de1930:	0a43      	lsrs	r3, r0, #9
c0de1932:	428b      	cmp	r3, r1
c0de1934:	d301      	bcc.n	c0de193a <__udivsi3+0x8e>
c0de1936:	024b      	lsls	r3, r1, #9
c0de1938:	1ac0      	subs	r0, r0, r3
c0de193a:	4152      	adcs	r2, r2
c0de193c:	0a03      	lsrs	r3, r0, #8
c0de193e:	428b      	cmp	r3, r1
c0de1940:	d301      	bcc.n	c0de1946 <__udivsi3+0x9a>
c0de1942:	020b      	lsls	r3, r1, #8
c0de1944:	1ac0      	subs	r0, r0, r3
c0de1946:	4152      	adcs	r2, r2
c0de1948:	d2cd      	bcs.n	c0de18e6 <__udivsi3+0x3a>
c0de194a:	09c3      	lsrs	r3, r0, #7
c0de194c:	428b      	cmp	r3, r1
c0de194e:	d301      	bcc.n	c0de1954 <__udivsi3+0xa8>
c0de1950:	01cb      	lsls	r3, r1, #7
c0de1952:	1ac0      	subs	r0, r0, r3
c0de1954:	4152      	adcs	r2, r2
c0de1956:	0983      	lsrs	r3, r0, #6
c0de1958:	428b      	cmp	r3, r1
c0de195a:	d301      	bcc.n	c0de1960 <__udivsi3+0xb4>
c0de195c:	018b      	lsls	r3, r1, #6
c0de195e:	1ac0      	subs	r0, r0, r3
c0de1960:	4152      	adcs	r2, r2
c0de1962:	0943      	lsrs	r3, r0, #5
c0de1964:	428b      	cmp	r3, r1
c0de1966:	d301      	bcc.n	c0de196c <__udivsi3+0xc0>
c0de1968:	014b      	lsls	r3, r1, #5
c0de196a:	1ac0      	subs	r0, r0, r3
c0de196c:	4152      	adcs	r2, r2
c0de196e:	0903      	lsrs	r3, r0, #4
c0de1970:	428b      	cmp	r3, r1
c0de1972:	d301      	bcc.n	c0de1978 <__udivsi3+0xcc>
c0de1974:	010b      	lsls	r3, r1, #4
c0de1976:	1ac0      	subs	r0, r0, r3
c0de1978:	4152      	adcs	r2, r2
c0de197a:	08c3      	lsrs	r3, r0, #3
c0de197c:	428b      	cmp	r3, r1
c0de197e:	d301      	bcc.n	c0de1984 <__udivsi3+0xd8>
c0de1980:	00cb      	lsls	r3, r1, #3
c0de1982:	1ac0      	subs	r0, r0, r3
c0de1984:	4152      	adcs	r2, r2
c0de1986:	0883      	lsrs	r3, r0, #2
c0de1988:	428b      	cmp	r3, r1
c0de198a:	d301      	bcc.n	c0de1990 <__udivsi3+0xe4>
c0de198c:	008b      	lsls	r3, r1, #2
c0de198e:	1ac0      	subs	r0, r0, r3
c0de1990:	4152      	adcs	r2, r2
c0de1992:	0843      	lsrs	r3, r0, #1
c0de1994:	428b      	cmp	r3, r1
c0de1996:	d301      	bcc.n	c0de199c <__udivsi3+0xf0>
c0de1998:	004b      	lsls	r3, r1, #1
c0de199a:	1ac0      	subs	r0, r0, r3
c0de199c:	4152      	adcs	r2, r2
c0de199e:	1a41      	subs	r1, r0, r1
c0de19a0:	d200      	bcs.n	c0de19a4 <__udivsi3+0xf8>
c0de19a2:	4601      	mov	r1, r0
c0de19a4:	4152      	adcs	r2, r2
c0de19a6:	4610      	mov	r0, r2
c0de19a8:	4770      	bx	lr
c0de19aa:	e7ff      	b.n	c0de19ac <__udivsi3+0x100>
c0de19ac:	b501      	push	{r0, lr}
c0de19ae:	2000      	movs	r0, #0
c0de19b0:	f000 f806 	bl	c0de19c0 <__aeabi_idiv0>
c0de19b4:	bd02      	pop	{r1, pc}
c0de19b6:	46c0      	nop			; (mov r8, r8)

c0de19b8 <__aeabi_uidivmod>:
c0de19b8:	2900      	cmp	r1, #0
c0de19ba:	d0f7      	beq.n	c0de19ac <__udivsi3+0x100>
c0de19bc:	e776      	b.n	c0de18ac <__udivsi3>
c0de19be:	4770      	bx	lr

c0de19c0 <__aeabi_idiv0>:
c0de19c0:	4770      	bx	lr
c0de19c2:	46c0      	nop			; (mov r8, r8)

c0de19c4 <__aeabi_uldivmod>:
c0de19c4:	2b00      	cmp	r3, #0
c0de19c6:	d111      	bne.n	c0de19ec <__aeabi_uldivmod+0x28>
c0de19c8:	2a00      	cmp	r2, #0
c0de19ca:	d10f      	bne.n	c0de19ec <__aeabi_uldivmod+0x28>
c0de19cc:	2900      	cmp	r1, #0
c0de19ce:	d100      	bne.n	c0de19d2 <__aeabi_uldivmod+0xe>
c0de19d0:	2800      	cmp	r0, #0
c0de19d2:	d002      	beq.n	c0de19da <__aeabi_uldivmod+0x16>
c0de19d4:	2100      	movs	r1, #0
c0de19d6:	43c9      	mvns	r1, r1
c0de19d8:	1c08      	adds	r0, r1, #0
c0de19da:	b407      	push	{r0, r1, r2}
c0de19dc:	4802      	ldr	r0, [pc, #8]	; (c0de19e8 <__aeabi_uldivmod+0x24>)
c0de19de:	a102      	add	r1, pc, #8	; (adr r1, c0de19e8 <__aeabi_uldivmod+0x24>)
c0de19e0:	1840      	adds	r0, r0, r1
c0de19e2:	9002      	str	r0, [sp, #8]
c0de19e4:	bd03      	pop	{r0, r1, pc}
c0de19e6:	46c0      	nop			; (mov r8, r8)
c0de19e8:	ffffffd9 	.word	0xffffffd9
c0de19ec:	b403      	push	{r0, r1}
c0de19ee:	4668      	mov	r0, sp
c0de19f0:	b501      	push	{r0, lr}
c0de19f2:	9802      	ldr	r0, [sp, #8]
c0de19f4:	f000 f830 	bl	c0de1a58 <__udivmoddi4>
c0de19f8:	9b01      	ldr	r3, [sp, #4]
c0de19fa:	469e      	mov	lr, r3
c0de19fc:	b002      	add	sp, #8
c0de19fe:	bc0c      	pop	{r2, r3}
c0de1a00:	4770      	bx	lr
c0de1a02:	46c0      	nop			; (mov r8, r8)

c0de1a04 <__aeabi_lmul>:
c0de1a04:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1a06:	46ce      	mov	lr, r9
c0de1a08:	4647      	mov	r7, r8
c0de1a0a:	0415      	lsls	r5, r2, #16
c0de1a0c:	0c2d      	lsrs	r5, r5, #16
c0de1a0e:	002e      	movs	r6, r5
c0de1a10:	b580      	push	{r7, lr}
c0de1a12:	0407      	lsls	r7, r0, #16
c0de1a14:	0c14      	lsrs	r4, r2, #16
c0de1a16:	0c3f      	lsrs	r7, r7, #16
c0de1a18:	4699      	mov	r9, r3
c0de1a1a:	0c03      	lsrs	r3, r0, #16
c0de1a1c:	437e      	muls	r6, r7
c0de1a1e:	435d      	muls	r5, r3
c0de1a20:	4367      	muls	r7, r4
c0de1a22:	4363      	muls	r3, r4
c0de1a24:	197f      	adds	r7, r7, r5
c0de1a26:	0c34      	lsrs	r4, r6, #16
c0de1a28:	19e4      	adds	r4, r4, r7
c0de1a2a:	469c      	mov	ip, r3
c0de1a2c:	42a5      	cmp	r5, r4
c0de1a2e:	d903      	bls.n	c0de1a38 <__aeabi_lmul+0x34>
c0de1a30:	2380      	movs	r3, #128	; 0x80
c0de1a32:	025b      	lsls	r3, r3, #9
c0de1a34:	4698      	mov	r8, r3
c0de1a36:	44c4      	add	ip, r8
c0de1a38:	464b      	mov	r3, r9
c0de1a3a:	4343      	muls	r3, r0
c0de1a3c:	4351      	muls	r1, r2
c0de1a3e:	0c25      	lsrs	r5, r4, #16
c0de1a40:	0436      	lsls	r6, r6, #16
c0de1a42:	4465      	add	r5, ip
c0de1a44:	0c36      	lsrs	r6, r6, #16
c0de1a46:	0424      	lsls	r4, r4, #16
c0de1a48:	19a4      	adds	r4, r4, r6
c0de1a4a:	195b      	adds	r3, r3, r5
c0de1a4c:	1859      	adds	r1, r3, r1
c0de1a4e:	0020      	movs	r0, r4
c0de1a50:	bc0c      	pop	{r2, r3}
c0de1a52:	4690      	mov	r8, r2
c0de1a54:	4699      	mov	r9, r3
c0de1a56:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de1a58 <__udivmoddi4>:
c0de1a58:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1a5a:	4657      	mov	r7, sl
c0de1a5c:	464e      	mov	r6, r9
c0de1a5e:	4645      	mov	r5, r8
c0de1a60:	46de      	mov	lr, fp
c0de1a62:	b5e0      	push	{r5, r6, r7, lr}
c0de1a64:	0004      	movs	r4, r0
c0de1a66:	b083      	sub	sp, #12
c0de1a68:	000d      	movs	r5, r1
c0de1a6a:	4692      	mov	sl, r2
c0de1a6c:	4699      	mov	r9, r3
c0de1a6e:	428b      	cmp	r3, r1
c0de1a70:	d830      	bhi.n	c0de1ad4 <__udivmoddi4+0x7c>
c0de1a72:	d02d      	beq.n	c0de1ad0 <__udivmoddi4+0x78>
c0de1a74:	4649      	mov	r1, r9
c0de1a76:	4650      	mov	r0, sl
c0de1a78:	f000 f8c0 	bl	c0de1bfc <__clzdi2>
c0de1a7c:	0029      	movs	r1, r5
c0de1a7e:	0006      	movs	r6, r0
c0de1a80:	0020      	movs	r0, r4
c0de1a82:	f000 f8bb 	bl	c0de1bfc <__clzdi2>
c0de1a86:	1a33      	subs	r3, r6, r0
c0de1a88:	4698      	mov	r8, r3
c0de1a8a:	3b20      	subs	r3, #32
c0de1a8c:	469b      	mov	fp, r3
c0de1a8e:	d433      	bmi.n	c0de1af8 <__udivmoddi4+0xa0>
c0de1a90:	465a      	mov	r2, fp
c0de1a92:	4653      	mov	r3, sl
c0de1a94:	4093      	lsls	r3, r2
c0de1a96:	4642      	mov	r2, r8
c0de1a98:	001f      	movs	r7, r3
c0de1a9a:	4653      	mov	r3, sl
c0de1a9c:	4093      	lsls	r3, r2
c0de1a9e:	001e      	movs	r6, r3
c0de1aa0:	42af      	cmp	r7, r5
c0de1aa2:	d83a      	bhi.n	c0de1b1a <__udivmoddi4+0xc2>
c0de1aa4:	42af      	cmp	r7, r5
c0de1aa6:	d100      	bne.n	c0de1aaa <__udivmoddi4+0x52>
c0de1aa8:	e07b      	b.n	c0de1ba2 <__udivmoddi4+0x14a>
c0de1aaa:	465b      	mov	r3, fp
c0de1aac:	1ba4      	subs	r4, r4, r6
c0de1aae:	41bd      	sbcs	r5, r7
c0de1ab0:	2b00      	cmp	r3, #0
c0de1ab2:	da00      	bge.n	c0de1ab6 <__udivmoddi4+0x5e>
c0de1ab4:	e078      	b.n	c0de1ba8 <__udivmoddi4+0x150>
c0de1ab6:	2200      	movs	r2, #0
c0de1ab8:	2300      	movs	r3, #0
c0de1aba:	9200      	str	r2, [sp, #0]
c0de1abc:	9301      	str	r3, [sp, #4]
c0de1abe:	2301      	movs	r3, #1
c0de1ac0:	465a      	mov	r2, fp
c0de1ac2:	4093      	lsls	r3, r2
c0de1ac4:	9301      	str	r3, [sp, #4]
c0de1ac6:	2301      	movs	r3, #1
c0de1ac8:	4642      	mov	r2, r8
c0de1aca:	4093      	lsls	r3, r2
c0de1acc:	9300      	str	r3, [sp, #0]
c0de1ace:	e028      	b.n	c0de1b22 <__udivmoddi4+0xca>
c0de1ad0:	4282      	cmp	r2, r0
c0de1ad2:	d9cf      	bls.n	c0de1a74 <__udivmoddi4+0x1c>
c0de1ad4:	2200      	movs	r2, #0
c0de1ad6:	2300      	movs	r3, #0
c0de1ad8:	9200      	str	r2, [sp, #0]
c0de1ada:	9301      	str	r3, [sp, #4]
c0de1adc:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0de1ade:	2b00      	cmp	r3, #0
c0de1ae0:	d001      	beq.n	c0de1ae6 <__udivmoddi4+0x8e>
c0de1ae2:	601c      	str	r4, [r3, #0]
c0de1ae4:	605d      	str	r5, [r3, #4]
c0de1ae6:	9800      	ldr	r0, [sp, #0]
c0de1ae8:	9901      	ldr	r1, [sp, #4]
c0de1aea:	b003      	add	sp, #12
c0de1aec:	bc3c      	pop	{r2, r3, r4, r5}
c0de1aee:	4690      	mov	r8, r2
c0de1af0:	4699      	mov	r9, r3
c0de1af2:	46a2      	mov	sl, r4
c0de1af4:	46ab      	mov	fp, r5
c0de1af6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1af8:	4642      	mov	r2, r8
c0de1afa:	2320      	movs	r3, #32
c0de1afc:	1a9b      	subs	r3, r3, r2
c0de1afe:	4652      	mov	r2, sl
c0de1b00:	40da      	lsrs	r2, r3
c0de1b02:	4641      	mov	r1, r8
c0de1b04:	0013      	movs	r3, r2
c0de1b06:	464a      	mov	r2, r9
c0de1b08:	408a      	lsls	r2, r1
c0de1b0a:	0017      	movs	r7, r2
c0de1b0c:	4642      	mov	r2, r8
c0de1b0e:	431f      	orrs	r7, r3
c0de1b10:	4653      	mov	r3, sl
c0de1b12:	4093      	lsls	r3, r2
c0de1b14:	001e      	movs	r6, r3
c0de1b16:	42af      	cmp	r7, r5
c0de1b18:	d9c4      	bls.n	c0de1aa4 <__udivmoddi4+0x4c>
c0de1b1a:	2200      	movs	r2, #0
c0de1b1c:	2300      	movs	r3, #0
c0de1b1e:	9200      	str	r2, [sp, #0]
c0de1b20:	9301      	str	r3, [sp, #4]
c0de1b22:	4643      	mov	r3, r8
c0de1b24:	2b00      	cmp	r3, #0
c0de1b26:	d0d9      	beq.n	c0de1adc <__udivmoddi4+0x84>
c0de1b28:	07fb      	lsls	r3, r7, #31
c0de1b2a:	469c      	mov	ip, r3
c0de1b2c:	4661      	mov	r1, ip
c0de1b2e:	0872      	lsrs	r2, r6, #1
c0de1b30:	430a      	orrs	r2, r1
c0de1b32:	087b      	lsrs	r3, r7, #1
c0de1b34:	4646      	mov	r6, r8
c0de1b36:	e00e      	b.n	c0de1b56 <__udivmoddi4+0xfe>
c0de1b38:	42ab      	cmp	r3, r5
c0de1b3a:	d101      	bne.n	c0de1b40 <__udivmoddi4+0xe8>
c0de1b3c:	42a2      	cmp	r2, r4
c0de1b3e:	d80c      	bhi.n	c0de1b5a <__udivmoddi4+0x102>
c0de1b40:	1aa4      	subs	r4, r4, r2
c0de1b42:	419d      	sbcs	r5, r3
c0de1b44:	2001      	movs	r0, #1
c0de1b46:	1924      	adds	r4, r4, r4
c0de1b48:	416d      	adcs	r5, r5
c0de1b4a:	2100      	movs	r1, #0
c0de1b4c:	3e01      	subs	r6, #1
c0de1b4e:	1824      	adds	r4, r4, r0
c0de1b50:	414d      	adcs	r5, r1
c0de1b52:	2e00      	cmp	r6, #0
c0de1b54:	d006      	beq.n	c0de1b64 <__udivmoddi4+0x10c>
c0de1b56:	42ab      	cmp	r3, r5
c0de1b58:	d9ee      	bls.n	c0de1b38 <__udivmoddi4+0xe0>
c0de1b5a:	3e01      	subs	r6, #1
c0de1b5c:	1924      	adds	r4, r4, r4
c0de1b5e:	416d      	adcs	r5, r5
c0de1b60:	2e00      	cmp	r6, #0
c0de1b62:	d1f8      	bne.n	c0de1b56 <__udivmoddi4+0xfe>
c0de1b64:	9800      	ldr	r0, [sp, #0]
c0de1b66:	9901      	ldr	r1, [sp, #4]
c0de1b68:	465b      	mov	r3, fp
c0de1b6a:	1900      	adds	r0, r0, r4
c0de1b6c:	4169      	adcs	r1, r5
c0de1b6e:	2b00      	cmp	r3, #0
c0de1b70:	db25      	blt.n	c0de1bbe <__udivmoddi4+0x166>
c0de1b72:	002b      	movs	r3, r5
c0de1b74:	465a      	mov	r2, fp
c0de1b76:	4644      	mov	r4, r8
c0de1b78:	40d3      	lsrs	r3, r2
c0de1b7a:	002a      	movs	r2, r5
c0de1b7c:	40e2      	lsrs	r2, r4
c0de1b7e:	001c      	movs	r4, r3
c0de1b80:	465b      	mov	r3, fp
c0de1b82:	0015      	movs	r5, r2
c0de1b84:	2b00      	cmp	r3, #0
c0de1b86:	db2b      	blt.n	c0de1be0 <__udivmoddi4+0x188>
c0de1b88:	0026      	movs	r6, r4
c0de1b8a:	465f      	mov	r7, fp
c0de1b8c:	40be      	lsls	r6, r7
c0de1b8e:	0033      	movs	r3, r6
c0de1b90:	0026      	movs	r6, r4
c0de1b92:	4647      	mov	r7, r8
c0de1b94:	40be      	lsls	r6, r7
c0de1b96:	0032      	movs	r2, r6
c0de1b98:	1a80      	subs	r0, r0, r2
c0de1b9a:	4199      	sbcs	r1, r3
c0de1b9c:	9000      	str	r0, [sp, #0]
c0de1b9e:	9101      	str	r1, [sp, #4]
c0de1ba0:	e79c      	b.n	c0de1adc <__udivmoddi4+0x84>
c0de1ba2:	42a3      	cmp	r3, r4
c0de1ba4:	d8b9      	bhi.n	c0de1b1a <__udivmoddi4+0xc2>
c0de1ba6:	e780      	b.n	c0de1aaa <__udivmoddi4+0x52>
c0de1ba8:	4642      	mov	r2, r8
c0de1baa:	2320      	movs	r3, #32
c0de1bac:	2100      	movs	r1, #0
c0de1bae:	1a9b      	subs	r3, r3, r2
c0de1bb0:	2200      	movs	r2, #0
c0de1bb2:	9100      	str	r1, [sp, #0]
c0de1bb4:	9201      	str	r2, [sp, #4]
c0de1bb6:	2201      	movs	r2, #1
c0de1bb8:	40da      	lsrs	r2, r3
c0de1bba:	9201      	str	r2, [sp, #4]
c0de1bbc:	e783      	b.n	c0de1ac6 <__udivmoddi4+0x6e>
c0de1bbe:	4642      	mov	r2, r8
c0de1bc0:	2320      	movs	r3, #32
c0de1bc2:	1a9b      	subs	r3, r3, r2
c0de1bc4:	002a      	movs	r2, r5
c0de1bc6:	4646      	mov	r6, r8
c0de1bc8:	409a      	lsls	r2, r3
c0de1bca:	0023      	movs	r3, r4
c0de1bcc:	40f3      	lsrs	r3, r6
c0de1bce:	4644      	mov	r4, r8
c0de1bd0:	4313      	orrs	r3, r2
c0de1bd2:	002a      	movs	r2, r5
c0de1bd4:	40e2      	lsrs	r2, r4
c0de1bd6:	001c      	movs	r4, r3
c0de1bd8:	465b      	mov	r3, fp
c0de1bda:	0015      	movs	r5, r2
c0de1bdc:	2b00      	cmp	r3, #0
c0de1bde:	dad3      	bge.n	c0de1b88 <__udivmoddi4+0x130>
c0de1be0:	2320      	movs	r3, #32
c0de1be2:	4642      	mov	r2, r8
c0de1be4:	0026      	movs	r6, r4
c0de1be6:	1a9b      	subs	r3, r3, r2
c0de1be8:	40de      	lsrs	r6, r3
c0de1bea:	002f      	movs	r7, r5
c0de1bec:	46b4      	mov	ip, r6
c0de1bee:	4646      	mov	r6, r8
c0de1bf0:	40b7      	lsls	r7, r6
c0de1bf2:	4666      	mov	r6, ip
c0de1bf4:	003b      	movs	r3, r7
c0de1bf6:	4333      	orrs	r3, r6
c0de1bf8:	e7ca      	b.n	c0de1b90 <__udivmoddi4+0x138>
c0de1bfa:	46c0      	nop			; (mov r8, r8)

c0de1bfc <__clzdi2>:
c0de1bfc:	b510      	push	{r4, lr}
c0de1bfe:	2900      	cmp	r1, #0
c0de1c00:	d103      	bne.n	c0de1c0a <__clzdi2+0xe>
c0de1c02:	f000 f807 	bl	c0de1c14 <__clzsi2>
c0de1c06:	3020      	adds	r0, #32
c0de1c08:	e002      	b.n	c0de1c10 <__clzdi2+0x14>
c0de1c0a:	1c08      	adds	r0, r1, #0
c0de1c0c:	f000 f802 	bl	c0de1c14 <__clzsi2>
c0de1c10:	bd10      	pop	{r4, pc}
c0de1c12:	46c0      	nop			; (mov r8, r8)

c0de1c14 <__clzsi2>:
c0de1c14:	211c      	movs	r1, #28
c0de1c16:	2301      	movs	r3, #1
c0de1c18:	041b      	lsls	r3, r3, #16
c0de1c1a:	4298      	cmp	r0, r3
c0de1c1c:	d301      	bcc.n	c0de1c22 <__clzsi2+0xe>
c0de1c1e:	0c00      	lsrs	r0, r0, #16
c0de1c20:	3910      	subs	r1, #16
c0de1c22:	0a1b      	lsrs	r3, r3, #8
c0de1c24:	4298      	cmp	r0, r3
c0de1c26:	d301      	bcc.n	c0de1c2c <__clzsi2+0x18>
c0de1c28:	0a00      	lsrs	r0, r0, #8
c0de1c2a:	3908      	subs	r1, #8
c0de1c2c:	091b      	lsrs	r3, r3, #4
c0de1c2e:	4298      	cmp	r0, r3
c0de1c30:	d301      	bcc.n	c0de1c36 <__clzsi2+0x22>
c0de1c32:	0900      	lsrs	r0, r0, #4
c0de1c34:	3904      	subs	r1, #4
c0de1c36:	a202      	add	r2, pc, #8	; (adr r2, c0de1c40 <__clzsi2+0x2c>)
c0de1c38:	5c10      	ldrb	r0, [r2, r0]
c0de1c3a:	1840      	adds	r0, r0, r1
c0de1c3c:	4770      	bx	lr
c0de1c3e:	46c0      	nop			; (mov r8, r8)
c0de1c40:	02020304 	.word	0x02020304
c0de1c44:	01010101 	.word	0x01010101
	...

c0de1c50 <__aeabi_memclr>:
c0de1c50:	b510      	push	{r4, lr}
c0de1c52:	2200      	movs	r2, #0
c0de1c54:	f000 f80a 	bl	c0de1c6c <__aeabi_memset>
c0de1c58:	bd10      	pop	{r4, pc}
c0de1c5a:	46c0      	nop			; (mov r8, r8)

c0de1c5c <__aeabi_memcpy>:
c0de1c5c:	b510      	push	{r4, lr}
c0de1c5e:	f000 f835 	bl	c0de1ccc <memcpy>
c0de1c62:	bd10      	pop	{r4, pc}

c0de1c64 <__aeabi_memmove>:
c0de1c64:	b510      	push	{r4, lr}
c0de1c66:	f000 f885 	bl	c0de1d74 <memmove>
c0de1c6a:	bd10      	pop	{r4, pc}

c0de1c6c <__aeabi_memset>:
c0de1c6c:	0013      	movs	r3, r2
c0de1c6e:	b510      	push	{r4, lr}
c0de1c70:	000a      	movs	r2, r1
c0de1c72:	0019      	movs	r1, r3
c0de1c74:	f000 f8dc 	bl	c0de1e30 <memset>
c0de1c78:	bd10      	pop	{r4, pc}
c0de1c7a:	46c0      	nop			; (mov r8, r8)

c0de1c7c <memcmp>:
c0de1c7c:	b530      	push	{r4, r5, lr}
c0de1c7e:	2a03      	cmp	r2, #3
c0de1c80:	d90c      	bls.n	c0de1c9c <memcmp+0x20>
c0de1c82:	0003      	movs	r3, r0
c0de1c84:	430b      	orrs	r3, r1
c0de1c86:	079b      	lsls	r3, r3, #30
c0de1c88:	d11c      	bne.n	c0de1cc4 <memcmp+0x48>
c0de1c8a:	6803      	ldr	r3, [r0, #0]
c0de1c8c:	680c      	ldr	r4, [r1, #0]
c0de1c8e:	42a3      	cmp	r3, r4
c0de1c90:	d118      	bne.n	c0de1cc4 <memcmp+0x48>
c0de1c92:	3a04      	subs	r2, #4
c0de1c94:	3004      	adds	r0, #4
c0de1c96:	3104      	adds	r1, #4
c0de1c98:	2a03      	cmp	r2, #3
c0de1c9a:	d8f6      	bhi.n	c0de1c8a <memcmp+0xe>
c0de1c9c:	1e55      	subs	r5, r2, #1
c0de1c9e:	2a00      	cmp	r2, #0
c0de1ca0:	d00e      	beq.n	c0de1cc0 <memcmp+0x44>
c0de1ca2:	7802      	ldrb	r2, [r0, #0]
c0de1ca4:	780c      	ldrb	r4, [r1, #0]
c0de1ca6:	4294      	cmp	r4, r2
c0de1ca8:	d10e      	bne.n	c0de1cc8 <memcmp+0x4c>
c0de1caa:	3501      	adds	r5, #1
c0de1cac:	2301      	movs	r3, #1
c0de1cae:	3901      	subs	r1, #1
c0de1cb0:	e004      	b.n	c0de1cbc <memcmp+0x40>
c0de1cb2:	5cc2      	ldrb	r2, [r0, r3]
c0de1cb4:	3301      	adds	r3, #1
c0de1cb6:	5ccc      	ldrb	r4, [r1, r3]
c0de1cb8:	42a2      	cmp	r2, r4
c0de1cba:	d105      	bne.n	c0de1cc8 <memcmp+0x4c>
c0de1cbc:	42ab      	cmp	r3, r5
c0de1cbe:	d1f8      	bne.n	c0de1cb2 <memcmp+0x36>
c0de1cc0:	2000      	movs	r0, #0
c0de1cc2:	bd30      	pop	{r4, r5, pc}
c0de1cc4:	1e55      	subs	r5, r2, #1
c0de1cc6:	e7ec      	b.n	c0de1ca2 <memcmp+0x26>
c0de1cc8:	1b10      	subs	r0, r2, r4
c0de1cca:	e7fa      	b.n	c0de1cc2 <memcmp+0x46>

c0de1ccc <memcpy>:
c0de1ccc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1cce:	46c6      	mov	lr, r8
c0de1cd0:	b500      	push	{lr}
c0de1cd2:	2a0f      	cmp	r2, #15
c0de1cd4:	d943      	bls.n	c0de1d5e <memcpy+0x92>
c0de1cd6:	000b      	movs	r3, r1
c0de1cd8:	2603      	movs	r6, #3
c0de1cda:	4303      	orrs	r3, r0
c0de1cdc:	401e      	ands	r6, r3
c0de1cde:	000c      	movs	r4, r1
c0de1ce0:	0003      	movs	r3, r0
c0de1ce2:	2e00      	cmp	r6, #0
c0de1ce4:	d140      	bne.n	c0de1d68 <memcpy+0x9c>
c0de1ce6:	0015      	movs	r5, r2
c0de1ce8:	3d10      	subs	r5, #16
c0de1cea:	092d      	lsrs	r5, r5, #4
c0de1cec:	46ac      	mov	ip, r5
c0de1cee:	012d      	lsls	r5, r5, #4
c0de1cf0:	46a8      	mov	r8, r5
c0de1cf2:	4480      	add	r8, r0
c0de1cf4:	e000      	b.n	c0de1cf8 <memcpy+0x2c>
c0de1cf6:	003b      	movs	r3, r7
c0de1cf8:	6867      	ldr	r7, [r4, #4]
c0de1cfa:	6825      	ldr	r5, [r4, #0]
c0de1cfc:	605f      	str	r7, [r3, #4]
c0de1cfe:	68e7      	ldr	r7, [r4, #12]
c0de1d00:	601d      	str	r5, [r3, #0]
c0de1d02:	60df      	str	r7, [r3, #12]
c0de1d04:	001f      	movs	r7, r3
c0de1d06:	68a5      	ldr	r5, [r4, #8]
c0de1d08:	3710      	adds	r7, #16
c0de1d0a:	609d      	str	r5, [r3, #8]
c0de1d0c:	3410      	adds	r4, #16
c0de1d0e:	4543      	cmp	r3, r8
c0de1d10:	d1f1      	bne.n	c0de1cf6 <memcpy+0x2a>
c0de1d12:	4665      	mov	r5, ip
c0de1d14:	230f      	movs	r3, #15
c0de1d16:	240c      	movs	r4, #12
c0de1d18:	3501      	adds	r5, #1
c0de1d1a:	012d      	lsls	r5, r5, #4
c0de1d1c:	1949      	adds	r1, r1, r5
c0de1d1e:	4013      	ands	r3, r2
c0de1d20:	1945      	adds	r5, r0, r5
c0de1d22:	4214      	tst	r4, r2
c0de1d24:	d023      	beq.n	c0de1d6e <memcpy+0xa2>
c0de1d26:	598c      	ldr	r4, [r1, r6]
c0de1d28:	51ac      	str	r4, [r5, r6]
c0de1d2a:	3604      	adds	r6, #4
c0de1d2c:	1b9c      	subs	r4, r3, r6
c0de1d2e:	2c03      	cmp	r4, #3
c0de1d30:	d8f9      	bhi.n	c0de1d26 <memcpy+0x5a>
c0de1d32:	2403      	movs	r4, #3
c0de1d34:	3b04      	subs	r3, #4
c0de1d36:	089b      	lsrs	r3, r3, #2
c0de1d38:	3301      	adds	r3, #1
c0de1d3a:	009b      	lsls	r3, r3, #2
c0de1d3c:	4022      	ands	r2, r4
c0de1d3e:	18ed      	adds	r5, r5, r3
c0de1d40:	18c9      	adds	r1, r1, r3
c0de1d42:	1e56      	subs	r6, r2, #1
c0de1d44:	2a00      	cmp	r2, #0
c0de1d46:	d007      	beq.n	c0de1d58 <memcpy+0x8c>
c0de1d48:	2300      	movs	r3, #0
c0de1d4a:	e000      	b.n	c0de1d4e <memcpy+0x82>
c0de1d4c:	0023      	movs	r3, r4
c0de1d4e:	5cca      	ldrb	r2, [r1, r3]
c0de1d50:	1c5c      	adds	r4, r3, #1
c0de1d52:	54ea      	strb	r2, [r5, r3]
c0de1d54:	429e      	cmp	r6, r3
c0de1d56:	d1f9      	bne.n	c0de1d4c <memcpy+0x80>
c0de1d58:	bc04      	pop	{r2}
c0de1d5a:	4690      	mov	r8, r2
c0de1d5c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1d5e:	0005      	movs	r5, r0
c0de1d60:	1e56      	subs	r6, r2, #1
c0de1d62:	2a00      	cmp	r2, #0
c0de1d64:	d1f0      	bne.n	c0de1d48 <memcpy+0x7c>
c0de1d66:	e7f7      	b.n	c0de1d58 <memcpy+0x8c>
c0de1d68:	1e56      	subs	r6, r2, #1
c0de1d6a:	0005      	movs	r5, r0
c0de1d6c:	e7ec      	b.n	c0de1d48 <memcpy+0x7c>
c0de1d6e:	001a      	movs	r2, r3
c0de1d70:	e7f6      	b.n	c0de1d60 <memcpy+0x94>
c0de1d72:	46c0      	nop			; (mov r8, r8)

c0de1d74 <memmove>:
c0de1d74:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1d76:	46c6      	mov	lr, r8
c0de1d78:	b500      	push	{lr}
c0de1d7a:	4288      	cmp	r0, r1
c0de1d7c:	d90c      	bls.n	c0de1d98 <memmove+0x24>
c0de1d7e:	188b      	adds	r3, r1, r2
c0de1d80:	4298      	cmp	r0, r3
c0de1d82:	d209      	bcs.n	c0de1d98 <memmove+0x24>
c0de1d84:	1e53      	subs	r3, r2, #1
c0de1d86:	2a00      	cmp	r2, #0
c0de1d88:	d003      	beq.n	c0de1d92 <memmove+0x1e>
c0de1d8a:	5cca      	ldrb	r2, [r1, r3]
c0de1d8c:	54c2      	strb	r2, [r0, r3]
c0de1d8e:	3b01      	subs	r3, #1
c0de1d90:	d2fb      	bcs.n	c0de1d8a <memmove+0x16>
c0de1d92:	bc04      	pop	{r2}
c0de1d94:	4690      	mov	r8, r2
c0de1d96:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1d98:	2a0f      	cmp	r2, #15
c0de1d9a:	d80c      	bhi.n	c0de1db6 <memmove+0x42>
c0de1d9c:	0005      	movs	r5, r0
c0de1d9e:	1e56      	subs	r6, r2, #1
c0de1da0:	2a00      	cmp	r2, #0
c0de1da2:	d0f6      	beq.n	c0de1d92 <memmove+0x1e>
c0de1da4:	2300      	movs	r3, #0
c0de1da6:	e000      	b.n	c0de1daa <memmove+0x36>
c0de1da8:	0023      	movs	r3, r4
c0de1daa:	5cca      	ldrb	r2, [r1, r3]
c0de1dac:	1c5c      	adds	r4, r3, #1
c0de1dae:	54ea      	strb	r2, [r5, r3]
c0de1db0:	429e      	cmp	r6, r3
c0de1db2:	d1f9      	bne.n	c0de1da8 <memmove+0x34>
c0de1db4:	e7ed      	b.n	c0de1d92 <memmove+0x1e>
c0de1db6:	000b      	movs	r3, r1
c0de1db8:	2603      	movs	r6, #3
c0de1dba:	4303      	orrs	r3, r0
c0de1dbc:	401e      	ands	r6, r3
c0de1dbe:	000c      	movs	r4, r1
c0de1dc0:	0003      	movs	r3, r0
c0de1dc2:	2e00      	cmp	r6, #0
c0de1dc4:	d12e      	bne.n	c0de1e24 <memmove+0xb0>
c0de1dc6:	0015      	movs	r5, r2
c0de1dc8:	3d10      	subs	r5, #16
c0de1dca:	092d      	lsrs	r5, r5, #4
c0de1dcc:	46ac      	mov	ip, r5
c0de1dce:	012d      	lsls	r5, r5, #4
c0de1dd0:	46a8      	mov	r8, r5
c0de1dd2:	4480      	add	r8, r0
c0de1dd4:	e000      	b.n	c0de1dd8 <memmove+0x64>
c0de1dd6:	002b      	movs	r3, r5
c0de1dd8:	001d      	movs	r5, r3
c0de1dda:	6827      	ldr	r7, [r4, #0]
c0de1ddc:	3510      	adds	r5, #16
c0de1dde:	601f      	str	r7, [r3, #0]
c0de1de0:	6867      	ldr	r7, [r4, #4]
c0de1de2:	605f      	str	r7, [r3, #4]
c0de1de4:	68a7      	ldr	r7, [r4, #8]
c0de1de6:	609f      	str	r7, [r3, #8]
c0de1de8:	68e7      	ldr	r7, [r4, #12]
c0de1dea:	3410      	adds	r4, #16
c0de1dec:	60df      	str	r7, [r3, #12]
c0de1dee:	4543      	cmp	r3, r8
c0de1df0:	d1f1      	bne.n	c0de1dd6 <memmove+0x62>
c0de1df2:	4665      	mov	r5, ip
c0de1df4:	230f      	movs	r3, #15
c0de1df6:	240c      	movs	r4, #12
c0de1df8:	3501      	adds	r5, #1
c0de1dfa:	012d      	lsls	r5, r5, #4
c0de1dfc:	1949      	adds	r1, r1, r5
c0de1dfe:	4013      	ands	r3, r2
c0de1e00:	1945      	adds	r5, r0, r5
c0de1e02:	4214      	tst	r4, r2
c0de1e04:	d011      	beq.n	c0de1e2a <memmove+0xb6>
c0de1e06:	598c      	ldr	r4, [r1, r6]
c0de1e08:	51ac      	str	r4, [r5, r6]
c0de1e0a:	3604      	adds	r6, #4
c0de1e0c:	1b9c      	subs	r4, r3, r6
c0de1e0e:	2c03      	cmp	r4, #3
c0de1e10:	d8f9      	bhi.n	c0de1e06 <memmove+0x92>
c0de1e12:	2403      	movs	r4, #3
c0de1e14:	3b04      	subs	r3, #4
c0de1e16:	089b      	lsrs	r3, r3, #2
c0de1e18:	3301      	adds	r3, #1
c0de1e1a:	009b      	lsls	r3, r3, #2
c0de1e1c:	18ed      	adds	r5, r5, r3
c0de1e1e:	18c9      	adds	r1, r1, r3
c0de1e20:	4022      	ands	r2, r4
c0de1e22:	e7bc      	b.n	c0de1d9e <memmove+0x2a>
c0de1e24:	1e56      	subs	r6, r2, #1
c0de1e26:	0005      	movs	r5, r0
c0de1e28:	e7bc      	b.n	c0de1da4 <memmove+0x30>
c0de1e2a:	001a      	movs	r2, r3
c0de1e2c:	e7b7      	b.n	c0de1d9e <memmove+0x2a>
c0de1e2e:	46c0      	nop			; (mov r8, r8)

c0de1e30 <memset>:
c0de1e30:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1e32:	0005      	movs	r5, r0
c0de1e34:	0783      	lsls	r3, r0, #30
c0de1e36:	d04a      	beq.n	c0de1ece <memset+0x9e>
c0de1e38:	1e54      	subs	r4, r2, #1
c0de1e3a:	2a00      	cmp	r2, #0
c0de1e3c:	d044      	beq.n	c0de1ec8 <memset+0x98>
c0de1e3e:	b2ce      	uxtb	r6, r1
c0de1e40:	0003      	movs	r3, r0
c0de1e42:	2203      	movs	r2, #3
c0de1e44:	e002      	b.n	c0de1e4c <memset+0x1c>
c0de1e46:	3501      	adds	r5, #1
c0de1e48:	3c01      	subs	r4, #1
c0de1e4a:	d33d      	bcc.n	c0de1ec8 <memset+0x98>
c0de1e4c:	3301      	adds	r3, #1
c0de1e4e:	702e      	strb	r6, [r5, #0]
c0de1e50:	4213      	tst	r3, r2
c0de1e52:	d1f8      	bne.n	c0de1e46 <memset+0x16>
c0de1e54:	2c03      	cmp	r4, #3
c0de1e56:	d92f      	bls.n	c0de1eb8 <memset+0x88>
c0de1e58:	22ff      	movs	r2, #255	; 0xff
c0de1e5a:	400a      	ands	r2, r1
c0de1e5c:	0215      	lsls	r5, r2, #8
c0de1e5e:	4315      	orrs	r5, r2
c0de1e60:	042a      	lsls	r2, r5, #16
c0de1e62:	4315      	orrs	r5, r2
c0de1e64:	2c0f      	cmp	r4, #15
c0de1e66:	d935      	bls.n	c0de1ed4 <memset+0xa4>
c0de1e68:	0027      	movs	r7, r4
c0de1e6a:	3f10      	subs	r7, #16
c0de1e6c:	093f      	lsrs	r7, r7, #4
c0de1e6e:	013e      	lsls	r6, r7, #4
c0de1e70:	46b4      	mov	ip, r6
c0de1e72:	001e      	movs	r6, r3
c0de1e74:	001a      	movs	r2, r3
c0de1e76:	3610      	adds	r6, #16
c0de1e78:	4466      	add	r6, ip
c0de1e7a:	6015      	str	r5, [r2, #0]
c0de1e7c:	6055      	str	r5, [r2, #4]
c0de1e7e:	6095      	str	r5, [r2, #8]
c0de1e80:	60d5      	str	r5, [r2, #12]
c0de1e82:	3210      	adds	r2, #16
c0de1e84:	42b2      	cmp	r2, r6
c0de1e86:	d1f8      	bne.n	c0de1e7a <memset+0x4a>
c0de1e88:	260f      	movs	r6, #15
c0de1e8a:	220c      	movs	r2, #12
c0de1e8c:	3701      	adds	r7, #1
c0de1e8e:	013f      	lsls	r7, r7, #4
c0de1e90:	4026      	ands	r6, r4
c0de1e92:	19db      	adds	r3, r3, r7
c0de1e94:	0037      	movs	r7, r6
c0de1e96:	4222      	tst	r2, r4
c0de1e98:	d017      	beq.n	c0de1eca <memset+0x9a>
c0de1e9a:	1f3e      	subs	r6, r7, #4
c0de1e9c:	08b6      	lsrs	r6, r6, #2
c0de1e9e:	00b4      	lsls	r4, r6, #2
c0de1ea0:	46a4      	mov	ip, r4
c0de1ea2:	001a      	movs	r2, r3
c0de1ea4:	1d1c      	adds	r4, r3, #4
c0de1ea6:	4464      	add	r4, ip
c0de1ea8:	c220      	stmia	r2!, {r5}
c0de1eaa:	42a2      	cmp	r2, r4
c0de1eac:	d1fc      	bne.n	c0de1ea8 <memset+0x78>
c0de1eae:	2403      	movs	r4, #3
c0de1eb0:	3601      	adds	r6, #1
c0de1eb2:	00b6      	lsls	r6, r6, #2
c0de1eb4:	199b      	adds	r3, r3, r6
c0de1eb6:	403c      	ands	r4, r7
c0de1eb8:	2c00      	cmp	r4, #0
c0de1eba:	d005      	beq.n	c0de1ec8 <memset+0x98>
c0de1ebc:	b2c9      	uxtb	r1, r1
c0de1ebe:	191c      	adds	r4, r3, r4
c0de1ec0:	7019      	strb	r1, [r3, #0]
c0de1ec2:	3301      	adds	r3, #1
c0de1ec4:	429c      	cmp	r4, r3
c0de1ec6:	d1fb      	bne.n	c0de1ec0 <memset+0x90>
c0de1ec8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1eca:	0034      	movs	r4, r6
c0de1ecc:	e7f4      	b.n	c0de1eb8 <memset+0x88>
c0de1ece:	0014      	movs	r4, r2
c0de1ed0:	0003      	movs	r3, r0
c0de1ed2:	e7bf      	b.n	c0de1e54 <memset+0x24>
c0de1ed4:	0027      	movs	r7, r4
c0de1ed6:	e7e0      	b.n	c0de1e9a <memset+0x6a>

c0de1ed8 <setjmp>:
c0de1ed8:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de1eda:	4641      	mov	r1, r8
c0de1edc:	464a      	mov	r2, r9
c0de1ede:	4653      	mov	r3, sl
c0de1ee0:	465c      	mov	r4, fp
c0de1ee2:	466d      	mov	r5, sp
c0de1ee4:	4676      	mov	r6, lr
c0de1ee6:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de1ee8:	3828      	subs	r0, #40	; 0x28
c0de1eea:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de1eec:	2000      	movs	r0, #0
c0de1eee:	4770      	bx	lr

c0de1ef0 <longjmp>:
c0de1ef0:	3010      	adds	r0, #16
c0de1ef2:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de1ef4:	4690      	mov	r8, r2
c0de1ef6:	4699      	mov	r9, r3
c0de1ef8:	46a2      	mov	sl, r4
c0de1efa:	46ab      	mov	fp, r5
c0de1efc:	46b5      	mov	sp, r6
c0de1efe:	c808      	ldmia	r0!, {r3}
c0de1f00:	3828      	subs	r0, #40	; 0x28
c0de1f02:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de1f04:	1c08      	adds	r0, r1, #0
c0de1f06:	d100      	bne.n	c0de1f0a <longjmp+0x1a>
c0de1f08:	2001      	movs	r0, #1
c0de1f0a:	4718      	bx	r3

c0de1f0c <strlcat>:
c0de1f0c:	b570      	push	{r4, r5, r6, lr}
c0de1f0e:	2a00      	cmp	r2, #0
c0de1f10:	d02a      	beq.n	c0de1f68 <strlcat+0x5c>
c0de1f12:	7803      	ldrb	r3, [r0, #0]
c0de1f14:	2b00      	cmp	r3, #0
c0de1f16:	d029      	beq.n	c0de1f6c <strlcat+0x60>
c0de1f18:	1884      	adds	r4, r0, r2
c0de1f1a:	0003      	movs	r3, r0
c0de1f1c:	e002      	b.n	c0de1f24 <strlcat+0x18>
c0de1f1e:	781d      	ldrb	r5, [r3, #0]
c0de1f20:	2d00      	cmp	r5, #0
c0de1f22:	d018      	beq.n	c0de1f56 <strlcat+0x4a>
c0de1f24:	3301      	adds	r3, #1
c0de1f26:	42a3      	cmp	r3, r4
c0de1f28:	d1f9      	bne.n	c0de1f1e <strlcat+0x12>
c0de1f2a:	1a26      	subs	r6, r4, r0
c0de1f2c:	1b92      	subs	r2, r2, r6
c0de1f2e:	d016      	beq.n	c0de1f5e <strlcat+0x52>
c0de1f30:	780d      	ldrb	r5, [r1, #0]
c0de1f32:	000b      	movs	r3, r1
c0de1f34:	2d00      	cmp	r5, #0
c0de1f36:	d00a      	beq.n	c0de1f4e <strlcat+0x42>
c0de1f38:	2a01      	cmp	r2, #1
c0de1f3a:	d002      	beq.n	c0de1f42 <strlcat+0x36>
c0de1f3c:	7025      	strb	r5, [r4, #0]
c0de1f3e:	3a01      	subs	r2, #1
c0de1f40:	3401      	adds	r4, #1
c0de1f42:	3301      	adds	r3, #1
c0de1f44:	781d      	ldrb	r5, [r3, #0]
c0de1f46:	2d00      	cmp	r5, #0
c0de1f48:	d1f6      	bne.n	c0de1f38 <strlcat+0x2c>
c0de1f4a:	1a5b      	subs	r3, r3, r1
c0de1f4c:	18f6      	adds	r6, r6, r3
c0de1f4e:	2300      	movs	r3, #0
c0de1f50:	7023      	strb	r3, [r4, #0]
c0de1f52:	0030      	movs	r0, r6
c0de1f54:	bd70      	pop	{r4, r5, r6, pc}
c0de1f56:	001c      	movs	r4, r3
c0de1f58:	1a26      	subs	r6, r4, r0
c0de1f5a:	1b92      	subs	r2, r2, r6
c0de1f5c:	d1e8      	bne.n	c0de1f30 <strlcat+0x24>
c0de1f5e:	0008      	movs	r0, r1
c0de1f60:	f000 f82e 	bl	c0de1fc0 <strlen>
c0de1f64:	1836      	adds	r6, r6, r0
c0de1f66:	e7f4      	b.n	c0de1f52 <strlcat+0x46>
c0de1f68:	2600      	movs	r6, #0
c0de1f6a:	e7f8      	b.n	c0de1f5e <strlcat+0x52>
c0de1f6c:	0004      	movs	r4, r0
c0de1f6e:	2600      	movs	r6, #0
c0de1f70:	e7de      	b.n	c0de1f30 <strlcat+0x24>
c0de1f72:	46c0      	nop			; (mov r8, r8)

c0de1f74 <strlcpy>:
c0de1f74:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1f76:	2a00      	cmp	r2, #0
c0de1f78:	d013      	beq.n	c0de1fa2 <strlcpy+0x2e>
c0de1f7a:	3a01      	subs	r2, #1
c0de1f7c:	2a00      	cmp	r2, #0
c0de1f7e:	d019      	beq.n	c0de1fb4 <strlcpy+0x40>
c0de1f80:	2300      	movs	r3, #0
c0de1f82:	1c4f      	adds	r7, r1, #1
c0de1f84:	1c46      	adds	r6, r0, #1
c0de1f86:	e002      	b.n	c0de1f8e <strlcpy+0x1a>
c0de1f88:	3301      	adds	r3, #1
c0de1f8a:	429a      	cmp	r2, r3
c0de1f8c:	d016      	beq.n	c0de1fbc <strlcpy+0x48>
c0de1f8e:	18f5      	adds	r5, r6, r3
c0de1f90:	46ac      	mov	ip, r5
c0de1f92:	5ccd      	ldrb	r5, [r1, r3]
c0de1f94:	18fc      	adds	r4, r7, r3
c0de1f96:	54c5      	strb	r5, [r0, r3]
c0de1f98:	2d00      	cmp	r5, #0
c0de1f9a:	d1f5      	bne.n	c0de1f88 <strlcpy+0x14>
c0de1f9c:	1a60      	subs	r0, r4, r1
c0de1f9e:	3801      	subs	r0, #1
c0de1fa0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1fa2:	000c      	movs	r4, r1
c0de1fa4:	0023      	movs	r3, r4
c0de1fa6:	3301      	adds	r3, #1
c0de1fa8:	1e5a      	subs	r2, r3, #1
c0de1faa:	7812      	ldrb	r2, [r2, #0]
c0de1fac:	001c      	movs	r4, r3
c0de1fae:	2a00      	cmp	r2, #0
c0de1fb0:	d1f9      	bne.n	c0de1fa6 <strlcpy+0x32>
c0de1fb2:	e7f3      	b.n	c0de1f9c <strlcpy+0x28>
c0de1fb4:	000c      	movs	r4, r1
c0de1fb6:	2300      	movs	r3, #0
c0de1fb8:	7003      	strb	r3, [r0, #0]
c0de1fba:	e7f3      	b.n	c0de1fa4 <strlcpy+0x30>
c0de1fbc:	4660      	mov	r0, ip
c0de1fbe:	e7fa      	b.n	c0de1fb6 <strlcpy+0x42>

c0de1fc0 <strlen>:
c0de1fc0:	b510      	push	{r4, lr}
c0de1fc2:	0783      	lsls	r3, r0, #30
c0de1fc4:	d027      	beq.n	c0de2016 <strlen+0x56>
c0de1fc6:	7803      	ldrb	r3, [r0, #0]
c0de1fc8:	2b00      	cmp	r3, #0
c0de1fca:	d026      	beq.n	c0de201a <strlen+0x5a>
c0de1fcc:	0003      	movs	r3, r0
c0de1fce:	2103      	movs	r1, #3
c0de1fd0:	e002      	b.n	c0de1fd8 <strlen+0x18>
c0de1fd2:	781a      	ldrb	r2, [r3, #0]
c0de1fd4:	2a00      	cmp	r2, #0
c0de1fd6:	d01c      	beq.n	c0de2012 <strlen+0x52>
c0de1fd8:	3301      	adds	r3, #1
c0de1fda:	420b      	tst	r3, r1
c0de1fdc:	d1f9      	bne.n	c0de1fd2 <strlen+0x12>
c0de1fde:	6819      	ldr	r1, [r3, #0]
c0de1fe0:	4a0f      	ldr	r2, [pc, #60]	; (c0de2020 <strlen+0x60>)
c0de1fe2:	4c10      	ldr	r4, [pc, #64]	; (c0de2024 <strlen+0x64>)
c0de1fe4:	188a      	adds	r2, r1, r2
c0de1fe6:	438a      	bics	r2, r1
c0de1fe8:	4222      	tst	r2, r4
c0de1fea:	d10f      	bne.n	c0de200c <strlen+0x4c>
c0de1fec:	3304      	adds	r3, #4
c0de1fee:	6819      	ldr	r1, [r3, #0]
c0de1ff0:	4a0b      	ldr	r2, [pc, #44]	; (c0de2020 <strlen+0x60>)
c0de1ff2:	188a      	adds	r2, r1, r2
c0de1ff4:	438a      	bics	r2, r1
c0de1ff6:	4222      	tst	r2, r4
c0de1ff8:	d108      	bne.n	c0de200c <strlen+0x4c>
c0de1ffa:	3304      	adds	r3, #4
c0de1ffc:	6819      	ldr	r1, [r3, #0]
c0de1ffe:	4a08      	ldr	r2, [pc, #32]	; (c0de2020 <strlen+0x60>)
c0de2000:	188a      	adds	r2, r1, r2
c0de2002:	438a      	bics	r2, r1
c0de2004:	4222      	tst	r2, r4
c0de2006:	d0f1      	beq.n	c0de1fec <strlen+0x2c>
c0de2008:	e000      	b.n	c0de200c <strlen+0x4c>
c0de200a:	3301      	adds	r3, #1
c0de200c:	781a      	ldrb	r2, [r3, #0]
c0de200e:	2a00      	cmp	r2, #0
c0de2010:	d1fb      	bne.n	c0de200a <strlen+0x4a>
c0de2012:	1a18      	subs	r0, r3, r0
c0de2014:	bd10      	pop	{r4, pc}
c0de2016:	0003      	movs	r3, r0
c0de2018:	e7e1      	b.n	c0de1fde <strlen+0x1e>
c0de201a:	2000      	movs	r0, #0
c0de201c:	e7fa      	b.n	c0de2014 <strlen+0x54>
c0de201e:	46c0      	nop			; (mov r8, r8)
c0de2020:	fefefeff 	.word	0xfefefeff
c0de2024:	80808080 	.word	0x80808080

c0de2028 <strnlen>:
c0de2028:	b510      	push	{r4, lr}
c0de202a:	2900      	cmp	r1, #0
c0de202c:	d00b      	beq.n	c0de2046 <strnlen+0x1e>
c0de202e:	7803      	ldrb	r3, [r0, #0]
c0de2030:	2b00      	cmp	r3, #0
c0de2032:	d00c      	beq.n	c0de204e <strnlen+0x26>
c0de2034:	1844      	adds	r4, r0, r1
c0de2036:	0003      	movs	r3, r0
c0de2038:	e002      	b.n	c0de2040 <strnlen+0x18>
c0de203a:	781a      	ldrb	r2, [r3, #0]
c0de203c:	2a00      	cmp	r2, #0
c0de203e:	d004      	beq.n	c0de204a <strnlen+0x22>
c0de2040:	3301      	adds	r3, #1
c0de2042:	42a3      	cmp	r3, r4
c0de2044:	d1f9      	bne.n	c0de203a <strnlen+0x12>
c0de2046:	0008      	movs	r0, r1
c0de2048:	bd10      	pop	{r4, pc}
c0de204a:	1a19      	subs	r1, r3, r0
c0de204c:	e7fb      	b.n	c0de2046 <strnlen+0x1e>
c0de204e:	2100      	movs	r1, #0
c0de2050:	e7f9      	b.n	c0de2046 <strnlen+0x1e>
c0de2052:	46c0      	nop			; (mov r8, r8)

c0de2054 <_ecode>:
c0de2054:	4144      	adcs	r4, r0
c0de2056:	0049      	lsls	r1, r1, #1
c0de2058:	6c50      	ldr	r0, [r2, #68]	; 0x44
c0de205a:	6775      	str	r5, [r6, #116]	; 0x74
c0de205c:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de205e:	7020      	strb	r0, [r4, #0]
c0de2060:	7261      	strb	r1, [r4, #9]
c0de2062:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de2064:	7465      	strb	r5, [r4, #17]
c0de2066:	7265      	strb	r5, [r4, #9]
c0de2068:	2073      	movs	r0, #115	; 0x73
c0de206a:	7473      	strb	r3, [r6, #17]
c0de206c:	7572      	strb	r2, [r6, #21]
c0de206e:	7463      	strb	r3, [r4, #17]
c0de2070:	7275      	strb	r5, [r6, #9]
c0de2072:	2065      	movs	r0, #101	; 0x65
c0de2074:	7369      	strb	r1, [r5, #13]
c0de2076:	6220      	str	r0, [r4, #32]
c0de2078:	6769      	str	r1, [r5, #116]	; 0x74
c0de207a:	6567      	str	r7, [r4, #84]	; 0x54
c0de207c:	2072      	movs	r0, #114	; 0x72
c0de207e:	6874      	ldr	r4, [r6, #4]
c0de2080:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de2082:	6120      	str	r0, [r4, #16]
c0de2084:	6c6c      	ldr	r4, [r5, #68]	; 0x44
c0de2086:	776f      	strb	r7, [r5, #29]
c0de2088:	6465      	str	r5, [r4, #68]	; 0x44
c0de208a:	7320      	strb	r0, [r4, #12]
c0de208c:	7a69      	ldrb	r1, [r5, #9]
c0de208e:	0a65      	lsrs	r5, r4, #9
c0de2090:	5300      	strh	r0, [r0, r4]
c0de2092:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de2094:	0064      	lsls	r4, r4, #1
c0de2096:	4157      	adcs	r7, r2
c0de2098:	4e52      	ldr	r6, [pc, #328]	; (c0de21e4 <_ecode+0x190>)
c0de209a:	4e49      	ldr	r6, [pc, #292]	; (c0de21c0 <_ecode+0x16c>)
c0de209c:	0047      	lsls	r7, r0, #1
c0de209e:	656f      	str	r7, [r5, #84]	; 0x54
c0de20a0:	6874      	ldr	r4, [r6, #4]
c0de20a2:	7020      	strb	r0, [r4, #0]
c0de20a4:	756c      	strb	r4, [r5, #21]
c0de20a6:	6967      	ldr	r7, [r4, #20]
c0de20a8:	206e      	movs	r0, #110	; 0x6e
c0de20aa:	7270      	strb	r0, [r6, #9]
c0de20ac:	766f      	strb	r7, [r5, #25]
c0de20ae:	6469      	str	r1, [r5, #68]	; 0x44
c0de20b0:	2065      	movs	r0, #101	; 0x65
c0de20b2:	6170      	str	r0, [r6, #20]
c0de20b4:	6172      	str	r2, [r6, #20]
c0de20b6:	656d      	str	r5, [r5, #84]	; 0x54
c0de20b8:	6574      	str	r4, [r6, #84]	; 0x54
c0de20ba:	3a72      	subs	r2, #114	; 0x72
c0de20bc:	0020      	movs	r0, r4
c0de20be:	0020      	movs	r0, r4
c0de20c0:	6150      	str	r0, [r2, #20]
c0de20c2:	6172      	str	r2, [r6, #20]
c0de20c4:	206d      	movs	r0, #109	; 0x6d
c0de20c6:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de20c8:	2074      	movs	r0, #116	; 0x74
c0de20ca:	7573      	strb	r3, [r6, #21]
c0de20cc:	7070      	strb	r0, [r6, #1]
c0de20ce:	726f      	strb	r7, [r5, #9]
c0de20d0:	6574      	str	r4, [r6, #84]	; 0x54
c0de20d2:	0a64      	lsrs	r4, r4, #9
c0de20d4:	5400      	strb	r0, [r0, r0]
c0de20d6:	4b4f      	ldr	r3, [pc, #316]	; (c0de2214 <HEXDIGITS+0x9>)
c0de20d8:	4e45      	ldr	r6, [pc, #276]	; (c0de21f0 <_ecode+0x19c>)
c0de20da:	5320      	strh	r0, [r4, r4]
c0de20dc:	4e45      	ldr	r6, [pc, #276]	; (c0de21f4 <_ecode+0x1a0>)
c0de20de:	3a54      	subs	r2, #84	; 0x54
c0de20e0:	0020      	movs	r0, r4
c0de20e2:	454f      	cmp	r7, r9
c0de20e4:	4854      	ldr	r0, [pc, #336]	; (c0de2238 <HEXDIGITS+0x2d>)
c0de20e6:	7020      	strb	r0, [r4, #0]
c0de20e8:	756c      	strb	r4, [r5, #21]
c0de20ea:	6967      	ldr	r7, [r4, #20]
c0de20ec:	206e      	movs	r0, #110	; 0x6e
c0de20ee:	7270      	strb	r0, [r6, #9]
c0de20f0:	766f      	strb	r7, [r5, #25]
c0de20f2:	6469      	str	r1, [r5, #68]	; 0x44
c0de20f4:	2065      	movs	r0, #101	; 0x65
c0de20f6:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de20f8:	656b      	str	r3, [r5, #84]	; 0x54
c0de20fa:	3a6e      	subs	r2, #110	; 0x6e
c0de20fc:	3020      	adds	r0, #32
c0de20fe:	2578      	movs	r5, #120	; 0x78
c0de2100:	2c70      	cmp	r4, #112	; 0x70
c0de2102:	3020      	adds	r0, #32
c0de2104:	2578      	movs	r5, #120	; 0x78
c0de2106:	0a70      	lsrs	r0, r6, #9
c0de2108:	4d00      	ldr	r5, [pc, #0]	; (c0de210c <_ecode+0xb8>)
c0de210a:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de210c:	0074      	lsls	r4, r6, #1
c0de210e:	3025      	adds	r0, #37	; 0x25
c0de2110:	7832      	ldrb	r2, [r6, #0]
c0de2112:	5300      	strh	r0, [r0, r4]
c0de2114:	6177      	str	r7, [r6, #20]
c0de2116:	0070      	lsls	r0, r6, #1
c0de2118:	534c      	strh	r4, [r1, r5]
c0de211a:	2054      	movs	r0, #84	; 0x54
c0de211c:	494d      	ldr	r1, [pc, #308]	; (c0de2254 <HEXDIGITS+0x49>)
c0de211e:	0058      	lsls	r0, r3, #1
c0de2120:	4f54      	ldr	r7, [pc, #336]	; (c0de2274 <HEXDIGITS+0x69>)
c0de2122:	454b      	cmp	r3, r9
c0de2124:	204e      	movs	r0, #78	; 0x4e
c0de2126:	4552      	cmp	r2, sl
c0de2128:	4543      	cmp	r3, r8
c0de212a:	5649      	ldrsb	r1, [r1, r1]
c0de212c:	4445      	add	r5, r8
c0de212e:	203a      	movs	r0, #58	; 0x3a
c0de2130:	4f00      	ldr	r7, [pc, #0]	; (c0de2134 <_ecode+0xe0>)
c0de2132:	5355      	strh	r5, [r2, r5]
c0de2134:	0044      	lsls	r4, r0, #1
c0de2136:	4f57      	ldr	r7, [pc, #348]	; (c0de2294 <HEXDIGITS+0x89>)
c0de2138:	5445      	strb	r5, [r0, r1]
c0de213a:	0048      	lsls	r0, r1, #1
c0de213c:	724f      	strb	r7, [r1, #9]
c0de213e:	6769      	str	r1, [r5, #116]	; 0x74
c0de2140:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de2142:	4420      	add	r0, r4
c0de2144:	4665      	mov	r5, ip
c0de2146:	0069      	lsls	r1, r5, #1
c0de2148:	6552      	str	r2, [r2, #84]	; 0x54
c0de214a:	6564      	str	r4, [r4, #84]	; 0x54
c0de214c:	6d65      	ldr	r5, [r4, #84]	; 0x54
c0de214e:	5500      	strb	r0, [r0, r4]
c0de2150:	4453      	add	r3, sl
c0de2152:	4d20      	ldr	r5, [pc, #128]	; (c0de21d4 <_ecode+0x180>)
c0de2154:	5849      	ldr	r1, [r1, r1]
c0de2156:	4f00      	ldr	r7, [pc, #0]	; (c0de2158 <_ecode+0x104>)
c0de2158:	4646      	mov	r6, r8
c0de215a:	4553      	cmp	r3, sl
c0de215c:	3a54      	subs	r2, #84	; 0x54
c0de215e:	2520      	movs	r5, #32
c0de2160:	0a64      	lsrs	r4, r4, #9
c0de2162:	5500      	strb	r0, [r0, r4]
c0de2164:	4453      	add	r3, sl
c0de2166:	0043      	lsls	r3, r0, #1
c0de2168:	7445      	strb	r5, [r0, #17]
c0de216a:	6568      	str	r0, [r5, #84]	; 0x54
c0de216c:	6572      	str	r2, [r6, #84]	; 0x54
c0de216e:	6d75      	ldr	r5, [r6, #84]	; 0x54
c0de2170:	4300      	orrs	r0, r0
c0de2172:	756f      	strb	r7, [r5, #21]
c0de2174:	746e      	strb	r6, [r5, #17]
c0de2176:	7265      	strb	r5, [r4, #9]
c0de2178:	203a      	movs	r0, #58	; 0x3a
c0de217a:	6425      	str	r5, [r4, #64]	; 0x40
c0de217c:	000a      	movs	r2, r1
c0de217e:	4542      	cmp	r2, r8
c0de2180:	454e      	cmp	r6, r9
c0de2182:	4946      	ldr	r1, [pc, #280]	; (c0de229c <HEXDIGITS+0x91>)
c0de2184:	4943      	ldr	r1, [pc, #268]	; (c0de2294 <HEXDIGITS+0x89>)
c0de2186:	5241      	strh	r1, [r0, r1]
c0de2188:	3a59      	subs	r2, #89	; 0x59
c0de218a:	0020      	movs	r0, r4
c0de218c:	0030      	movs	r0, r6
c0de218e:	6553      	str	r3, [r2, #84]	; 0x54
c0de2190:	7474      	strb	r4, [r6, #17]
c0de2192:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de2194:	2067      	movs	r0, #103	; 0x67
c0de2196:	6461      	str	r1, [r4, #68]	; 0x44
c0de2198:	7264      	strb	r4, [r4, #9]
c0de219a:	7365      	strb	r5, [r4, #13]
c0de219c:	2073      	movs	r0, #115	; 0x73
c0de219e:	6572      	str	r2, [r6, #84]	; 0x54
c0de21a0:	6563      	str	r3, [r4, #84]	; 0x54
c0de21a2:	7669      	strb	r1, [r5, #25]
c0de21a4:	6465      	str	r5, [r4, #68]	; 0x44
c0de21a6:	7420      	strb	r0, [r4, #16]
c0de21a8:	3a6f      	subs	r2, #111	; 0x6f
c0de21aa:	0020      	movs	r0, r4
c0de21ac:	6150      	str	r0, [r2, #20]
c0de21ae:	6172      	str	r2, [r6, #20]
c0de21b0:	206d      	movs	r0, #109	; 0x6d
c0de21b2:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de21b4:	2074      	movs	r0, #116	; 0x74
c0de21b6:	7573      	strb	r3, [r6, #21]
c0de21b8:	7070      	strb	r0, [r6, #1]
c0de21ba:	726f      	strb	r7, [r5, #9]
c0de21bc:	6574      	str	r4, [r6, #84]	; 0x54
c0de21be:	3a64      	subs	r2, #100	; 0x64
c0de21c0:	2520      	movs	r5, #32
c0de21c2:	0a64      	lsrs	r4, r4, #9
c0de21c4:	5200      	strh	r0, [r0, r0]
c0de21c6:	6365      	str	r5, [r4, #52]	; 0x34
c0de21c8:	6965      	ldr	r5, [r4, #20]
c0de21ca:	6576      	str	r6, [r6, #84]	; 0x54
c0de21cc:	4d20      	ldr	r5, [pc, #128]	; (c0de2250 <HEXDIGITS+0x45>)
c0de21ce:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de21d0:	4500      	cmp	r0, r0
c0de21d2:	6378      	str	r0, [r7, #52]	; 0x34
c0de21d4:	7065      	strb	r5, [r4, #1]
c0de21d6:	6974      	ldr	r4, [r6, #20]
c0de21d8:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de21da:	3020      	adds	r0, #32
c0de21dc:	2578      	movs	r5, #120	; 0x78
c0de21de:	2078      	movs	r0, #120	; 0x78
c0de21e0:	6163      	str	r3, [r4, #20]
c0de21e2:	6775      	str	r5, [r6, #116]	; 0x74
c0de21e4:	7468      	strb	r0, [r5, #17]
c0de21e6:	000a      	movs	r2, r1
c0de21e8:	4f54      	ldr	r7, [pc, #336]	; (c0de233c <HEXDIGITS+0x131>)
c0de21ea:	454b      	cmp	r3, r9
c0de21ec:	5f4e      	ldrsh	r6, [r1, r5]
c0de21ee:	4553      	cmp	r3, sl
c0de21f0:	544e      	strb	r6, [r1, r1]
c0de21f2:	203a      	movs	r0, #58	; 0x3a
c0de21f4:	7300      	strb	r0, [r0, #12]
c0de21f6:	7266      	strb	r6, [r4, #9]
c0de21f8:	4578      	cmp	r0, pc
c0de21fa:	4854      	ldr	r0, [pc, #336]	; (c0de234c <HEXDIGITS+0x141>)
c0de21fc:	5500      	strb	r0, [r0, r4]
c0de21fe:	6b6e      	ldr	r6, [r5, #52]	; 0x34
c0de2200:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de2202:	6e77      	ldr	r7, [r6, #100]	; 0x64
c0de2204:	7420      	strb	r0, [r4, #16]
c0de2206:	6b6f      	ldr	r7, [r5, #52]	; 0x34
c0de2208:	6e65      	ldr	r5, [r4, #100]	; 0x64
	...

c0de220b <HEXDIGITS>:
c0de220b:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef
c0de221b:	6500 6378 7065 6974 6e6f 255b 5d64 203a     .exception[%d]: 
c0de222b:	524c 303d 2578 3830 0a58 4500 5252 524f     LR=0x%08X..ERROR
c0de223b:	3000 0078 6e55 6168 646e 656c 2064 656d     .0x.Unhandled me
c0de224b:	7373 6761 2065 6425 000a 4f57 5355 0044     ssage %d..WOUSD.
c0de225b:	6553 7474 6e69 2067 6461 7264 7365 2073     Setting address 
c0de226b:	6573 746e 7420 3a6f 0020 6542 656e 6966     sent to: .Benefi
c0de227b:	6963 7261 0079 000a 7257 7061 5200 6365     ciary...Wrap.Rec
c0de228b:	6965 6576 2064 6e61 6920 766e 6c61 6469     eived an invalid
c0de229b:	7320 7263 6565 496e 646e 7865 000a 4d41      screenIndex..AM
c0de22ab:	554f 544e 5320 4e45 3a54 2520 0a73 0000     OUNT SENT: %s...
c0de22bb:	6553 656c 7463 726f 4920 646e 7865 3a20     Selector Index :
c0de22cb:	6425 6e20 746f 7320 7075 6f70 7472 6465     %d not supported
c0de22db:	000a 5355 5444 5500 686e 6e61 6c64 6465     ..USDT.Unhandled
c0de22eb:	7320 6c65 6365 6f74 2072 6e49 6564 3a78      selector Index:
c0de22fb:	2520 0a64 5500 494e 5354 5500 776e 6172      %d..UNITS.Unwra
c0de230b:	0070 6544 6f70 6973 0074 694d 7373 6e69     p.Deposit.Missin
c0de231b:	2067 6573 656c 7463 726f 6e49 6564 3a78     g selectorIndex:
c0de232b:	2520 0a64 5300 6c65 6365 6f74 2072 6e49      %d..Selector In
c0de233b:	6564 2078 6425 6e20 746f 7320 7075 6f70     dex %d not suppo
c0de234b:	7472 6465 000a 454f 4854 4100 4f4d 4e55     rted..OETH.AMOUN
c0de235b:	2054 4552 4543 5649 4445 203a 7325 000a     T RECEIVED: %s..
c0de236b:	                                             .

c0de236c <ORIGIN_DEFI_SELECTORS>:
c0de236c:	0db0 d0e3 e97d d443 29f6 156e 2373 7cbc     ....}.C..)n.s#.|
c0de237c:	2124 3df0 7ed6 a641 a424 353c 8d59 c04b     $!.=.~A.$.<5Y.K.
c0de238c:	f389 414b 0b96 35aa 9053 cb93 c746 5981     ..KA...5S...F..Y
c0de239c:	5a0f 8a09 1ffd bfc1 8169 c6b6 3f65 6e55     .Z......i...e?Un
c0de23ac:	7652 ba08                                   Rv..

c0de23b0 <OETH_ADDRESS>:
c0de23b0:	6c85 fb4e c176 aed1 e202 eb0c a203 a0a6     .lN.v...........
c0de23c0:	0b8b c38d                                   ....

c0de23c4 <OUSD_ADDRESS>:
c0de23c4:	8e2a 671e c26e d838 92a9 7b30 5b49 b345     *..gn.8...0{I[E.
c0de23d4:	aafe 865e                                   ..^.

c0de23d8 <DAI_ADDRESS>:
c0de23d8:	176b 7454 90e8 c494 a94d 958b ed4e c4ea     k.Tt....M...N...
c0de23e8:	2795 0f1d                                   .'..

c0de23ec <USDC_ADDRESS>:
c0de23ec:	b8a0 9169 21c6 368b d1c1 4a9d 9e2e ceb0     ..i..!.6...J....
c0de23fc:	0636 48eb                                   6..H

c0de2400 <USDT_ADDRESS>:
c0de2400:	c1da 957f 2e8d 23e5 20a2 0662 4599 c197     .......#. b..E..
c0de2410:	833d c71e                                   =...

c0de2414 <OETH_VAULT_ADDRESS>:
c0de2414:	2539 3340 5a94 e4a2 9c80 97c2 707e be87     9%@3.Z......~p..
c0de2424:	8be4 abd7                                   ....

c0de2428 <WOETH_ADDRESS>:
c0de2428:	eedc 6570 6142 21af 4cc4 3c09 0e30 bbd3     ..peBa.!.L.<0...
c0de2438:	b797 9281                                   ....

c0de243c <CURVE_OETH_POOL_ADDRESS>:
c0de243c:	b194 7674 3ba9 6232 7bd8 329a 6569 e9d1     ..tv.;2b.{.2ie..
c0de244c:	9c1f e713                                   ....

c0de2450 <CURVE_OUSD_POOL_ADDRESS>:
c0de2450:	6587 7b0d c3bf f1a9 8705 77d7 0682 1767     .e.{.......w..g.
c0de2460:	d919 0d91                                   ....

c0de2464 <g_pcHex>:
c0de2464:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de2474 <g_pcHex_cap>:
c0de2474:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de2484 <NULL_ETH_ADDRESS>:
	...

c0de2498 <_etext>:
c0de2498:	d4d4      	bmi.n	c0de2444 <CURVE_OETH_POOL_ADDRESS+0x8>
c0de249a:	d4d4      	bmi.n	c0de2446 <CURVE_OETH_POOL_ADDRESS+0xa>
c0de249c:	d4d4      	bmi.n	c0de2448 <CURVE_OETH_POOL_ADDRESS+0xc>
c0de249e:	d4d4      	bmi.n	c0de244a <CURVE_OETH_POOL_ADDRESS+0xe>
c0de24a0:	d4d4      	bmi.n	c0de244c <CURVE_OETH_POOL_ADDRESS+0x10>
c0de24a2:	d4d4      	bmi.n	c0de244e <CURVE_OETH_POOL_ADDRESS+0x12>
c0de24a4:	d4d4      	bmi.n	c0de2450 <CURVE_OUSD_POOL_ADDRESS>
c0de24a6:	d4d4      	bmi.n	c0de2452 <CURVE_OUSD_POOL_ADDRESS+0x2>
c0de24a8:	d4d4      	bmi.n	c0de2454 <CURVE_OUSD_POOL_ADDRESS+0x4>
c0de24aa:	d4d4      	bmi.n	c0de2456 <CURVE_OUSD_POOL_ADDRESS+0x6>
c0de24ac:	d4d4      	bmi.n	c0de2458 <CURVE_OUSD_POOL_ADDRESS+0x8>
c0de24ae:	d4d4      	bmi.n	c0de245a <CURVE_OUSD_POOL_ADDRESS+0xa>
c0de24b0:	d4d4      	bmi.n	c0de245c <CURVE_OUSD_POOL_ADDRESS+0xc>
c0de24b2:	d4d4      	bmi.n	c0de245e <CURVE_OUSD_POOL_ADDRESS+0xe>
c0de24b4:	d4d4      	bmi.n	c0de2460 <CURVE_OUSD_POOL_ADDRESS+0x10>
c0de24b6:	d4d4      	bmi.n	c0de2462 <CURVE_OUSD_POOL_ADDRESS+0x12>
c0de24b8:	d4d4      	bmi.n	c0de2464 <g_pcHex>
c0de24ba:	d4d4      	bmi.n	c0de2466 <g_pcHex+0x2>
c0de24bc:	d4d4      	bmi.n	c0de2468 <g_pcHex+0x4>
c0de24be:	d4d4      	bmi.n	c0de246a <g_pcHex+0x6>
c0de24c0:	d4d4      	bmi.n	c0de246c <g_pcHex+0x8>
c0de24c2:	d4d4      	bmi.n	c0de246e <g_pcHex+0xa>
c0de24c4:	d4d4      	bmi.n	c0de2470 <g_pcHex+0xc>
c0de24c6:	d4d4      	bmi.n	c0de2472 <g_pcHex+0xe>
c0de24c8:	d4d4      	bmi.n	c0de2474 <g_pcHex_cap>
c0de24ca:	d4d4      	bmi.n	c0de2476 <g_pcHex_cap+0x2>
c0de24cc:	d4d4      	bmi.n	c0de2478 <g_pcHex_cap+0x4>
c0de24ce:	d4d4      	bmi.n	c0de247a <g_pcHex_cap+0x6>
c0de24d0:	d4d4      	bmi.n	c0de247c <g_pcHex_cap+0x8>
c0de24d2:	d4d4      	bmi.n	c0de247e <g_pcHex_cap+0xa>
c0de24d4:	d4d4      	bmi.n	c0de2480 <g_pcHex_cap+0xc>
c0de24d6:	d4d4      	bmi.n	c0de2482 <g_pcHex_cap+0xe>
c0de24d8:	d4d4      	bmi.n	c0de2484 <NULL_ETH_ADDRESS>
c0de24da:	d4d4      	bmi.n	c0de2486 <NULL_ETH_ADDRESS+0x2>
c0de24dc:	d4d4      	bmi.n	c0de2488 <NULL_ETH_ADDRESS+0x4>
c0de24de:	d4d4      	bmi.n	c0de248a <NULL_ETH_ADDRESS+0x6>
c0de24e0:	d4d4      	bmi.n	c0de248c <NULL_ETH_ADDRESS+0x8>
c0de24e2:	d4d4      	bmi.n	c0de248e <NULL_ETH_ADDRESS+0xa>
c0de24e4:	d4d4      	bmi.n	c0de2490 <NULL_ETH_ADDRESS+0xc>
c0de24e6:	d4d4      	bmi.n	c0de2492 <NULL_ETH_ADDRESS+0xe>
c0de24e8:	d4d4      	bmi.n	c0de2494 <NULL_ETH_ADDRESS+0x10>
c0de24ea:	d4d4      	bmi.n	c0de2496 <NULL_ETH_ADDRESS+0x12>
c0de24ec:	d4d4      	bmi.n	c0de2498 <_etext>
c0de24ee:	d4d4      	bmi.n	c0de249a <_etext+0x2>
c0de24f0:	d4d4      	bmi.n	c0de249c <_etext+0x4>
c0de24f2:	d4d4      	bmi.n	c0de249e <_etext+0x6>
c0de24f4:	d4d4      	bmi.n	c0de24a0 <_etext+0x8>
c0de24f6:	d4d4      	bmi.n	c0de24a2 <_etext+0xa>
c0de24f8:	d4d4      	bmi.n	c0de24a4 <_etext+0xc>
c0de24fa:	d4d4      	bmi.n	c0de24a6 <_etext+0xe>
c0de24fc:	d4d4      	bmi.n	c0de24a8 <_etext+0x10>
c0de24fe:	d4d4      	bmi.n	c0de24aa <_etext+0x12>
