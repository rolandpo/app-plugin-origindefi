
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
c0de0008:	f001 f9e8 	bl	c0de13dc <os_boot>
c0de000c:	466d      	mov	r5, sp

    // Try catch block. Please read the docs for more information on how to use those!
    BEGIN_TRY {
        TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f001 feee 	bl	c0de1df0 <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10d      	bne.n	c0de003a <main+0x3a>
c0de001e:	f001 fbc5 	bl	c0de17ac <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
  if (apiLevel < get_api_level()) {
c0de0024:	f001 fb87 	bl	c0de1736 <get_api_level>
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
c0de0030:	f001 f9c6 	bl	c0de13c0 <call_app_ethereum>
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
c0de0040:	f001 fbb4 	bl	c0de17ac <try_context_set>
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
c0de0064:	f001 f9e0 	bl	c0de1428 <mcu_usb_printf>
c0de0068:	e00b      	b.n	c0de0082 <main+0x82>
c0de006a:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de006c:	f001 fb80 	bl	c0de1770 <os_sched_exit>
                if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de0070:	6820      	ldr	r0, [r4, #0]
c0de0072:	2183      	movs	r1, #131	; 0x83
c0de0074:	0049      	lsls	r1, r1, #1
c0de0076:	31f9      	adds	r1, #249	; 0xf9
c0de0078:	4288      	cmp	r0, r1
c0de007a:	d002      	beq.n	c0de0082 <main+0x82>
                    dispatch_plugin_calls(args[0], (void *) args[1]);
c0de007c:	6861      	ldr	r1, [r4, #4]
c0de007e:	f001 f965 	bl	c0de134c <dispatch_plugin_calls>
        FINALLY {
c0de0082:	f001 fb8b 	bl	c0de179c <try_context_get>
c0de0086:	4669      	mov	r1, sp
c0de0088:	4288      	cmp	r0, r1
c0de008a:	d102      	bne.n	c0de0092 <main+0x92>
c0de008c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de008e:	f001 fb8d 	bl	c0de17ac <try_context_set>
            os_lib_end();
c0de0092:	f001 fb65 	bl	c0de1760 <os_lib_end>
c0de0096:	46c0      	nop			; (mov r8, r8)
c0de0098:	00006502 	.word	0x00006502
c0de009c:	0000207f 	.word	0x0000207f

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
c0de010a:	f001 ff19 	bl	c0de1f40 <strnlen>
        strlcat((char *) locals_union.tmp + offset, "0x", sizeof(locals_union.tmp) - offset);
c0de010e:	9901      	ldr	r1, [sp, #4]
c0de0110:	180b      	adds	r3, r1, r0
c0de0112:	1a3a      	subs	r2, r7, r0
c0de0114:	4925      	ldr	r1, [pc, #148]	; (c0de01ac <getEthAddressStringFromBinary+0xd4>)
c0de0116:	4479      	add	r1, pc
c0de0118:	4618      	mov	r0, r3
c0de011a:	f001 fe83 	bl	c0de1e24 <strlcat>
        offset = strnlen((char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de011e:	9801      	ldr	r0, [sp, #4]
c0de0120:	4639      	mov	r1, r7
c0de0122:	f001 ff0d 	bl	c0de1f40 <strnlen>
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
c0de01ac:	00002034 	.word	0x00002034
c0de01b0:	00001fe9 	.word	0x00001fe9

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
c0de01da:	f001 fb7f 	bl	c0de18dc <__aeabi_uldivmod>
c0de01de:	9005      	str	r0, [sp, #20]
c0de01e0:	9104      	str	r1, [sp, #16]
c0de01e2:	9a03      	ldr	r2, [sp, #12]
c0de01e4:	4633      	mov	r3, r6
c0de01e6:	f001 fb99 	bl	c0de191c <__aeabi_lmul>
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
c0de0222:	f001 f8e1 	bl	c0de13e8 <os_longjmp>
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
c0de023c:	f001 f8d4 	bl	c0de13e8 <os_longjmp>

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
c0de0264:	f001 f8c0 	bl	c0de13e8 <os_longjmp>

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
c0de0358:	f001 fc06 	bl	c0de1b68 <__aeabi_memclr>
    memcpy((uint8_t *) n + INT256_LENGTH - value_len, value, value_len);
c0de035c:	1ba8      	subs	r0, r5, r6
c0de035e:	3020      	adds	r0, #32
c0de0360:	4639      	mov	r1, r7
c0de0362:	4632      	mov	r2, r6
c0de0364:	f001 fc06 	bl	c0de1b74 <__aeabi_memcpy>
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
c0de03be:	f001 fa01 	bl	c0de17c4 <__udivsi3>
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
c0de03e2:	f001 fd53 	bl	c0de1e8c <strlcpy>
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
c0de03f8:	f001 fbc0 	bl	c0de1b7c <__aeabi_memmove>
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
c0de040c:	00001cbc 	.word	0x00001cbc

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
c0de0442:	f001 fb91 	bl	c0de1b68 <__aeabi_memclr>
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
c0de045e:	f001 fd6f 	bl	c0de1f40 <strnlen>
c0de0462:	9001      	str	r0, [sp, #4]
c0de0464:	210b      	movs	r1, #11
    uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de0466:	9803      	ldr	r0, [sp, #12]
c0de0468:	f001 fd6a 	bl	c0de1f40 <strnlen>
c0de046c:	4604      	mov	r4, r0
    memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de046e:	b2c7      	uxtb	r7, r0
c0de0470:	42b7      	cmp	r7, r6
c0de0472:	4632      	mov	r2, r6
c0de0474:	d800      	bhi.n	c0de0478 <amountToString+0x4a>
c0de0476:	463a      	mov	r2, r7
c0de0478:	4628      	mov	r0, r5
c0de047a:	9903      	ldr	r1, [sp, #12]
c0de047c:	f001 fb7a 	bl	c0de1b74 <__aeabi_memcpy>
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
c0de04b6:	f000 ff97 	bl	c0de13e8 <os_longjmp>
c0de04ba:	d4d4      	bmi.n	c0de0466 <amountToString+0x38>

c0de04bc <handle_finalize>:
#include "origin_defi_plugin.h"

void handle_finalize(void *parameters) {
c0de04bc:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de04be:	4604      	mov	r4, r0
c0de04c0:	2002      	movs	r0, #2
c0de04c2:	9000      	str	r0, [sp, #0]
    ethPluginFinalize_t *msg = (ethPluginFinalize_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
    msg->numScreens = 2;
c0de04c4:	7760      	strb	r0, [r4, #29]
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de04c6:	68a5      	ldr	r5, [r4, #8]
c0de04c8:	209c      	movs	r0, #156	; 0x9c
    if ((context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT || context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT_SINGLE) && memcmp(msg->address, context->beneficiary, ADDRESS_LENGTH) != 0) {
c0de04ca:	5c28      	ldrb	r0, [r5, r0]
c0de04cc:	1fc0      	subs	r0, r0, #7
c0de04ce:	2801      	cmp	r0, #1
c0de04d0:	d809      	bhi.n	c0de04e6 <handle_finalize+0x2a>
c0de04d2:	69a0      	ldr	r0, [r4, #24]
c0de04d4:	4629      	mov	r1, r5
c0de04d6:	3168      	adds	r1, #104	; 0x68
c0de04d8:	2214      	movs	r2, #20
c0de04da:	f001 fb5b 	bl	c0de1b94 <memcmp>
c0de04de:	2800      	cmp	r0, #0
c0de04e0:	d001      	beq.n	c0de04e6 <handle_finalize+0x2a>
c0de04e2:	2003      	movs	r0, #3
        msg->numScreens += 1;
c0de04e4:	7760      	strb	r0, [r4, #29]
c0de04e6:	462f      	mov	r7, r5
c0de04e8:	3792      	adds	r7, #146	; 0x92
    }
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de04ea:	462e      	mov	r6, r5
c0de04ec:	3640      	adds	r6, #64	; 0x40
c0de04ee:	4919      	ldr	r1, [pc, #100]	; (c0de0554 <handle_finalize+0x98>)
c0de04f0:	4479      	add	r1, pc
c0de04f2:	2214      	movs	r2, #20
c0de04f4:	4630      	mov	r0, r6
c0de04f6:	f001 fb4d 	bl	c0de1b94 <memcmp>
c0de04fa:	2800      	cmp	r0, #0
c0de04fc:	d005      	beq.n	c0de050a <handle_finalize+0x4e>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address sent to: ",
c0de04fe:	4816      	ldr	r0, [pc, #88]	; (c0de0558 <handle_finalize+0x9c>)
c0de0500:	4478      	add	r0, pc
c0de0502:	4631      	mov	r1, r6
c0de0504:	f000 f82e 	bl	c0de0564 <printf_hex_array>
c0de0508:	e006      	b.n	c0de0518 <handle_finalize+0x5c>
c0de050a:	2012      	movs	r0, #18
    }
    return true;
}

static inline void sent_network_token(origin_defi_parameters_t *context) {
    context->decimals_sent = WEI_TO_ETHER;
c0de050c:	7078      	strb	r0, [r7, #1]
    context->tokens_found |= TOKEN_SENT_FOUND;
c0de050e:	7838      	ldrb	r0, [r7, #0]
c0de0510:	2101      	movs	r1, #1
c0de0512:	4301      	orrs	r1, r0
c0de0514:	7039      	strb	r1, [r7, #0]
c0de0516:	2600      	movs	r6, #0
c0de0518:	60e6      	str	r6, [r4, #12]
        msg->tokenLookup1 = context->contract_address_sent;
    } else {
        sent_network_token(context);
        msg->tokenLookup1 = NULL;
    }
    if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de051a:	3554      	adds	r5, #84	; 0x54
c0de051c:	490f      	ldr	r1, [pc, #60]	; (c0de055c <handle_finalize+0xa0>)
c0de051e:	4479      	add	r1, pc
c0de0520:	2214      	movs	r2, #20
c0de0522:	4628      	mov	r0, r5
c0de0524:	f001 fb36 	bl	c0de1b94 <memcmp>
c0de0528:	2800      	cmp	r0, #0
c0de052a:	d006      	beq.n	c0de053a <handle_finalize+0x7e>
        // Address is not network token (0xeee...) so we will need to look up the token in the
        // CAL.
        printf_hex_array("Setting address received to: ",
c0de052c:	480c      	ldr	r0, [pc, #48]	; (c0de0560 <handle_finalize+0xa4>)
c0de052e:	4478      	add	r0, pc
c0de0530:	4629      	mov	r1, r5
c0de0532:	f000 f817 	bl	c0de0564 <printf_hex_array>
c0de0536:	9900      	ldr	r1, [sp, #0]
c0de0538:	e006      	b.n	c0de0548 <handle_finalize+0x8c>
c0de053a:	2012      	movs	r0, #18
}

static inline void received_network_token(origin_defi_parameters_t *context) {
    context->decimals_received = WEI_TO_ETHER;
c0de053c:	70b8      	strb	r0, [r7, #2]
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
c0de053e:	7838      	ldrb	r0, [r7, #0]
c0de0540:	9900      	ldr	r1, [sp, #0]
c0de0542:	4308      	orrs	r0, r1
c0de0544:	7038      	strb	r0, [r7, #0]
c0de0546:	2500      	movs	r5, #0
c0de0548:	2004      	movs	r0, #4
        received_network_token(context);
        msg->tokenLookup2 = NULL;
    }

    msg->uiType = ETH_UI_TYPE_GENERIC;
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de054a:	77a0      	strb	r0, [r4, #30]
    msg->uiType = ETH_UI_TYPE_GENERIC;
c0de054c:	7721      	strb	r1, [r4, #28]
c0de054e:	6125      	str	r5, [r4, #16]
c0de0550:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0552:	46c0      	nop			; (mov r8, r8)
c0de0554:	00001e74 	.word	0x00001e74
c0de0558:	00001c63 	.word	0x00001c63
c0de055c:	00001e46 	.word	0x00001e46
c0de0560:	00001b6e 	.word	0x00001b6e

c0de0564 <printf_hex_array>:
}

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
c0de0564:	b570      	push	{r4, r5, r6, lr}
c0de0566:	460c      	mov	r4, r1
    PRINTF(title);
c0de0568:	f000 ff5e 	bl	c0de1428 <mcu_usb_printf>
c0de056c:	2600      	movs	r6, #0
c0de056e:	4d07      	ldr	r5, [pc, #28]	; (c0de058c <printf_hex_array+0x28>)
c0de0570:	447d      	add	r5, pc
    for (size_t i = 0; i < len; ++i) {
c0de0572:	2e14      	cmp	r6, #20
c0de0574:	d005      	beq.n	c0de0582 <printf_hex_array+0x1e>
        PRINTF("%02x", data[i]);
c0de0576:	5da1      	ldrb	r1, [r4, r6]
c0de0578:	4628      	mov	r0, r5
c0de057a:	f000 ff55 	bl	c0de1428 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de057e:	1c76      	adds	r6, r6, #1
c0de0580:	e7f7      	b.n	c0de0572 <printf_hex_array+0xe>
    };
    PRINTF("\n");
c0de0582:	4803      	ldr	r0, [pc, #12]	; (c0de0590 <printf_hex_array+0x2c>)
c0de0584:	4478      	add	r0, pc
c0de0586:	f000 ff4f 	bl	c0de1428 <mcu_usb_printf>
c0de058a:	bd70      	pop	{r4, r5, r6, pc}
c0de058c:	00001ab2 	.word	0x00001ab2
c0de0590:	00001c05 	.word	0x00001c05

c0de0594 <handle_init_contract>:
    }
    return -1;
}

// Called once to init.
void handle_init_contract(void *parameters) {
c0de0594:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de0596:	4604      	mov	r4, r0
    // Cast the msg to the type of structure we expect (here, ethPluginInitContract_t).
    ethPluginInitContract_t *msg = (ethPluginInitContract_t *) parameters;

    // Make sure we are running a compatible version.
    if (msg->interfaceVersion != ETH_PLUGIN_INTERFACE_VERSION_LATEST) {
c0de0598:	7800      	ldrb	r0, [r0, #0]
c0de059a:	2701      	movs	r7, #1
c0de059c:	2806      	cmp	r0, #6
c0de059e:	d107      	bne.n	c0de05b0 <handle_init_contract+0x1c>
        return;
    }

    // Double check that the `context_t` struct is not bigger than the maximum size (defined by
    // `msg->pluginContextLength`).
    if (msg->pluginContextLength < sizeof(origin_defi_parameters_t)) {
c0de05a0:	6920      	ldr	r0, [r4, #16]
c0de05a2:	289d      	cmp	r0, #157	; 0x9d
c0de05a4:	d806      	bhi.n	c0de05b4 <handle_init_contract+0x20>
        PRINTF("Plugin parameters structure is bigger than allowed size\n");
c0de05a6:	4831      	ldr	r0, [pc, #196]	; (c0de066c <handle_init_contract+0xd8>)
c0de05a8:	4478      	add	r0, pc
c0de05aa:	f000 ff3d 	bl	c0de1428 <mcu_usb_printf>
c0de05ae:	2700      	movs	r7, #0
c0de05b0:	7067      	strb	r7, [r4, #1]
            return;
    }

    // Return valid status.
    msg->result = ETH_PLUGIN_RESULT_OK;
}
c0de05b2:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de05b4:	68e5      	ldr	r5, [r4, #12]
c0de05b6:	219e      	movs	r1, #158	; 0x9e
    memset(context, 0, sizeof(*context));
c0de05b8:	4628      	mov	r0, r5
c0de05ba:	f001 fad5 	bl	c0de1b68 <__aeabi_memclr>
    uint32_t selector = U4BE(msg->selector, 0);
c0de05be:	6960      	ldr	r0, [r4, #20]
#define U4(hi3, hi2, lo1,lo0) ((((hi3)&0xFFu)<<24) | (((hi2)&0xFFu)<<16) | (((lo1)&0xFFu)<<8) | ((lo0)&0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off) {
  return (buf[off] << 8) | buf[off + 1];
}
static inline uint32_t U4BE(const uint8_t *buf, size_t off) {
  return (((uint32_t)buf[off]) << 24) | (buf[off + 1] << 16) | (buf[off + 2] << 8) | buf[off + 3];
c0de05c0:	7801      	ldrb	r1, [r0, #0]
c0de05c2:	0609      	lsls	r1, r1, #24
c0de05c4:	7842      	ldrb	r2, [r0, #1]
c0de05c6:	0412      	lsls	r2, r2, #16
c0de05c8:	1851      	adds	r1, r2, r1
c0de05ca:	7882      	ldrb	r2, [r0, #2]
c0de05cc:	0212      	lsls	r2, r2, #8
c0de05ce:	1889      	adds	r1, r1, r2
c0de05d0:	78c0      	ldrb	r0, [r0, #3]
c0de05d2:	1808      	adds	r0, r1, r0
c0de05d4:	3595      	adds	r5, #149	; 0x95
c0de05d6:	2600      	movs	r6, #0
c0de05d8:	4925      	ldr	r1, [pc, #148]	; (c0de0670 <handle_init_contract+0xdc>)
c0de05da:	4479      	add	r1, pc
    for (selector_t i = 0; i < n; i++) {
c0de05dc:	2e0f      	cmp	r6, #15
c0de05de:	d0e7      	beq.n	c0de05b0 <handle_init_contract+0x1c>
        if (selector == selectors[i]) {
c0de05e0:	680a      	ldr	r2, [r1, #0]
c0de05e2:	4282      	cmp	r2, r0
c0de05e4:	d002      	beq.n	c0de05ec <handle_init_contract+0x58>
    for (selector_t i = 0; i < n; i++) {
c0de05e6:	1d09      	adds	r1, r1, #4
c0de05e8:	1c76      	adds	r6, r6, #1
c0de05ea:	e7f7      	b.n	c0de05dc <handle_init_contract+0x48>
            *out = i;
c0de05ec:	71ee      	strb	r6, [r5, #7]
    if (find_selector(selector, ORIGIN_DEFI_SELECTORS, NUM_SELECTORS, &context->selectorIndex)) {
c0de05ee:	2e0e      	cmp	r6, #14
c0de05f0:	d8de      	bhi.n	c0de05b0 <handle_init_contract+0x1c>
    switch (context->selectorIndex) {
c0de05f2:	b2f0      	uxtb	r0, r6
c0de05f4:	4601      	mov	r1, r0
c0de05f6:	3909      	subs	r1, #9
c0de05f8:	2906      	cmp	r1, #6
c0de05fa:	d310      	bcc.n	c0de061e <handle_init_contract+0x8a>
c0de05fc:	1f01      	subs	r1, r0, #4
c0de05fe:	2902      	cmp	r1, #2
c0de0600:	d311      	bcc.n	c0de0626 <handle_init_contract+0x92>
c0de0602:	2800      	cmp	r0, #0
c0de0604:	d029      	beq.n	c0de065a <handle_init_contract+0xc6>
c0de0606:	2808      	cmp	r0, #8
c0de0608:	d00b      	beq.n	c0de0622 <handle_init_contract+0x8e>
c0de060a:	2802      	cmp	r0, #2
c0de060c:	d009      	beq.n	c0de0622 <handle_init_contract+0x8e>
c0de060e:	2803      	cmp	r0, #3
c0de0610:	d005      	beq.n	c0de061e <handle_init_contract+0x8a>
c0de0612:	2806      	cmp	r0, #6
c0de0614:	d005      	beq.n	c0de0622 <handle_init_contract+0x8e>
c0de0616:	2807      	cmp	r0, #7
c0de0618:	d021      	beq.n	c0de065e <handle_init_contract+0xca>
c0de061a:	2801      	cmp	r0, #1
c0de061c:	d117      	bne.n	c0de064e <handle_init_contract+0xba>
c0de061e:	2703      	movs	r7, #3
c0de0620:	e020      	b.n	c0de0664 <handle_init_contract+0xd0>
c0de0622:	2700      	movs	r7, #0
c0de0624:	e01e      	b.n	c0de0664 <handle_init_contract+0xd0>
            if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0 || memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0626:	68a0      	ldr	r0, [r4, #8]
c0de0628:	6801      	ldr	r1, [r0, #0]
c0de062a:	31a5      	adds	r1, #165	; 0xa5
c0de062c:	4811      	ldr	r0, [pc, #68]	; (c0de0674 <handle_init_contract+0xe0>)
c0de062e:	4478      	add	r0, pc
c0de0630:	2214      	movs	r2, #20
c0de0632:	9100      	str	r1, [sp, #0]
c0de0634:	f001 faae 	bl	c0de1b94 <memcmp>
c0de0638:	2700      	movs	r7, #0
c0de063a:	2800      	cmp	r0, #0
c0de063c:	d012      	beq.n	c0de0664 <handle_init_contract+0xd0>
c0de063e:	480e      	ldr	r0, [pc, #56]	; (c0de0678 <handle_init_contract+0xe4>)
c0de0640:	4478      	add	r0, pc
c0de0642:	2214      	movs	r2, #20
c0de0644:	9900      	ldr	r1, [sp, #0]
c0de0646:	f001 faa5 	bl	c0de1b94 <memcmp>
c0de064a:	2800      	cmp	r0, #0
c0de064c:	d00a      	beq.n	c0de0664 <handle_init_contract+0xd0>
c0de064e:	480b      	ldr	r0, [pc, #44]	; (c0de067c <handle_init_contract+0xe8>)
c0de0650:	4478      	add	r0, pc
c0de0652:	4631      	mov	r1, r6
c0de0654:	f000 fee8 	bl	c0de1428 <mcu_usb_printf>
c0de0658:	e7a9      	b.n	c0de05ae <handle_init_contract+0x1a>
c0de065a:	2708      	movs	r7, #8
c0de065c:	e002      	b.n	c0de0664 <handle_init_contract+0xd0>
c0de065e:	2002      	movs	r0, #2
            context->skip += 2;
c0de0660:	7028      	strb	r0, [r5, #0]
c0de0662:	2705      	movs	r7, #5
c0de0664:	70ef      	strb	r7, [r5, #3]
c0de0666:	2704      	movs	r7, #4
c0de0668:	e7a2      	b.n	c0de05b0 <handle_init_contract+0x1c>
c0de066a:	46c0      	nop			; (mov r8, r8)
c0de066c:	000019c4 	.word	0x000019c4
c0de0670:	00001c8e 	.word	0x00001c8e
c0de0674:	00001cee 	.word	0x00001cee
c0de0678:	00001cf0 	.word	0x00001cf0
c0de067c:	00001bc1 	.word	0x00001bc1

c0de0680 <handle_provide_parameter>:
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
c0de0680:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de0682:	4605      	mov	r5, r0
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0684:	6886      	ldr	r6, [r0, #8]
    printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH, msg->parameter);
c0de0686:	68c2      	ldr	r2, [r0, #12]
c0de0688:	48a0      	ldr	r0, [pc, #640]	; (c0de090c <handle_provide_parameter+0x28c>)
c0de068a:	4478      	add	r0, pc
c0de068c:	2120      	movs	r1, #32
c0de068e:	f000 f94d 	bl	c0de092c <printf_hex_array>
c0de0692:	2704      	movs	r7, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0694:	752f      	strb	r7, [r5, #20]
c0de0696:	2095      	movs	r0, #149	; 0x95

    if (context->skip) {
c0de0698:	5c30      	ldrb	r0, [r6, r0]
c0de069a:	4632      	mov	r2, r6
c0de069c:	3295      	adds	r2, #149	; 0x95
c0de069e:	2800      	cmp	r0, #0
c0de06a0:	d002      	beq.n	c0de06a8 <handle_provide_parameter+0x28>
        // Skip this step, and don't forget to decrease skipping counter.
        context->skip--;
c0de06a2:	1e40      	subs	r0, r0, #1
c0de06a4:	7010      	strb	r0, [r2, #0]
                PRINTF("Selector Index %d not supported\n", context->selectorIndex);
                msg->result = ETH_PLUGIN_RESULT_ERROR;
                break;
        }
    }
c0de06a6:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de06a8:	462b      	mov	r3, r5
c0de06aa:	330c      	adds	r3, #12
c0de06ac:	4634      	mov	r4, r6
c0de06ae:	349a      	adds	r4, #154	; 0x9a
        switch (context->selectorIndex) {
c0de06b0:	78a1      	ldrb	r1, [r4, #2]
c0de06b2:	4608      	mov	r0, r1
c0de06b4:	3809      	subs	r0, #9
c0de06b6:	2806      	cmp	r0, #6
c0de06b8:	d318      	bcc.n	c0de06ec <handle_provide_parameter+0x6c>
c0de06ba:	1f08      	subs	r0, r1, #4
c0de06bc:	2802      	cmp	r0, #2
c0de06be:	d31c      	bcc.n	c0de06fa <handle_provide_parameter+0x7a>
c0de06c0:	2908      	cmp	r1, #8
c0de06c2:	d02c      	beq.n	c0de071e <handle_provide_parameter+0x9e>
c0de06c4:	2901      	cmp	r1, #1
c0de06c6:	d022      	beq.n	c0de070e <handle_provide_parameter+0x8e>
c0de06c8:	2902      	cmp	r1, #2
c0de06ca:	d035      	beq.n	c0de0738 <handle_provide_parameter+0xb8>
c0de06cc:	2903      	cmp	r1, #3
c0de06ce:	d01e      	beq.n	c0de070e <handle_provide_parameter+0x8e>
c0de06d0:	2906      	cmp	r1, #6
c0de06d2:	d052      	beq.n	c0de077a <handle_provide_parameter+0xfa>
c0de06d4:	2907      	cmp	r1, #7
c0de06d6:	d063      	beq.n	c0de07a0 <handle_provide_parameter+0x120>
c0de06d8:	2900      	cmp	r1, #0
c0de06da:	d000      	beq.n	c0de06de <handle_provide_parameter+0x5e>
c0de06dc:	e082      	b.n	c0de07e4 <handle_provide_parameter+0x164>
    switch (context->next_param) {
c0de06de:	78d1      	ldrb	r1, [r2, #3]
c0de06e0:	2908      	cmp	r1, #8
c0de06e2:	d100      	bne.n	c0de06e6 <handle_provide_parameter+0x66>
c0de06e4:	e084      	b.n	c0de07f0 <handle_provide_parameter+0x170>
            PRINTF("Param not supported: %d\n", context->next_param);
c0de06e6:	488a      	ldr	r0, [pc, #552]	; (c0de0910 <handle_provide_parameter+0x290>)
c0de06e8:	4478      	add	r0, pc
c0de06ea:	e07d      	b.n	c0de07e8 <handle_provide_parameter+0x168>
    switch (context->next_param) {
c0de06ec:	78d0      	ldrb	r0, [r2, #3]
c0de06ee:	2808      	cmp	r0, #8
c0de06f0:	d07e      	beq.n	c0de07f0 <handle_provide_parameter+0x170>
c0de06f2:	2803      	cmp	r0, #3
c0de06f4:	d171      	bne.n	c0de07da <handle_provide_parameter+0x15a>
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de06f6:	6819      	ldr	r1, [r3, #0]
c0de06f8:	e037      	b.n	c0de076a <handle_provide_parameter+0xea>
    switch (context->next_param) {
c0de06fa:	78d0      	ldrb	r0, [r2, #3]
c0de06fc:	2808      	cmp	r0, #8
c0de06fe:	d077      	beq.n	c0de07f0 <handle_provide_parameter+0x170>
c0de0700:	2801      	cmp	r0, #1
c0de0702:	d076      	beq.n	c0de07f2 <handle_provide_parameter+0x172>
c0de0704:	2803      	cmp	r0, #3
c0de0706:	d026      	beq.n	c0de0756 <handle_provide_parameter+0xd6>
c0de0708:	2804      	cmp	r0, #4
c0de070a:	d140      	bne.n	c0de078e <handle_provide_parameter+0x10e>
c0de070c:	e02b      	b.n	c0de0766 <handle_provide_parameter+0xe6>
c0de070e:	78d0      	ldrb	r0, [r2, #3]
c0de0710:	2808      	cmp	r0, #8
c0de0712:	d06d      	beq.n	c0de07f0 <handle_provide_parameter+0x170>
c0de0714:	2804      	cmp	r0, #4
c0de0716:	d026      	beq.n	c0de0766 <handle_provide_parameter+0xe6>
c0de0718:	2803      	cmp	r0, #3
c0de071a:	d15e      	bne.n	c0de07da <handle_provide_parameter+0x15a>
c0de071c:	e01b      	b.n	c0de0756 <handle_provide_parameter+0xd6>
    switch (context->next_param) {
c0de071e:	78d0      	ldrb	r0, [r2, #3]
c0de0720:	2808      	cmp	r0, #8
c0de0722:	d065      	beq.n	c0de07f0 <handle_provide_parameter+0x170>
c0de0724:	2801      	cmp	r0, #1
c0de0726:	d100      	bne.n	c0de072a <handle_provide_parameter+0xaa>
c0de0728:	e088      	b.n	c0de083c <handle_provide_parameter+0x1bc>
c0de072a:	2803      	cmp	r0, #3
c0de072c:	d013      	beq.n	c0de0756 <handle_provide_parameter+0xd6>
c0de072e:	2804      	cmp	r0, #4
c0de0730:	d019      	beq.n	c0de0766 <handle_provide_parameter+0xe6>
c0de0732:	2805      	cmp	r0, #5
c0de0734:	d12b      	bne.n	c0de078e <handle_provide_parameter+0x10e>
c0de0736:	e049      	b.n	c0de07cc <handle_provide_parameter+0x14c>
    switch (context->next_param) {
c0de0738:	78d0      	ldrb	r0, [r2, #3]
c0de073a:	2808      	cmp	r0, #8
c0de073c:	d058      	beq.n	c0de07f0 <handle_provide_parameter+0x170>
c0de073e:	2803      	cmp	r0, #3
c0de0740:	d009      	beq.n	c0de0756 <handle_provide_parameter+0xd6>
c0de0742:	2804      	cmp	r0, #4
c0de0744:	d00f      	beq.n	c0de0766 <handle_provide_parameter+0xe6>
c0de0746:	2800      	cmp	r0, #0
c0de0748:	d147      	bne.n	c0de07da <handle_provide_parameter+0x15a>
            handle_token_sent(msg, context);
c0de074a:	4628      	mov	r0, r5
c0de074c:	4631      	mov	r1, r6
c0de074e:	4614      	mov	r4, r2
c0de0750:	f000 f906 	bl	c0de0960 <handle_token_sent>
c0de0754:	e052      	b.n	c0de07fc <handle_provide_parameter+0x17c>
c0de0756:	6819      	ldr	r1, [r3, #0]
c0de0758:	4614      	mov	r4, r2
c0de075a:	2220      	movs	r2, #32
c0de075c:	4630      	mov	r0, r6
c0de075e:	f001 fa09 	bl	c0de1b74 <__aeabi_memcpy>
c0de0762:	70e7      	strb	r7, [r4, #3]
c0de0764:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0766:	6819      	ldr	r1, [r3, #0]
c0de0768:	3620      	adds	r6, #32
c0de076a:	4614      	mov	r4, r2
c0de076c:	2220      	movs	r2, #32
c0de076e:	4630      	mov	r0, r6
c0de0770:	f001 fa00 	bl	c0de1b74 <__aeabi_memcpy>
c0de0774:	2008      	movs	r0, #8
c0de0776:	70e0      	strb	r0, [r4, #3]
c0de0778:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    switch (context->next_param) {
c0de077a:	78d0      	ldrb	r0, [r2, #3]
c0de077c:	2808      	cmp	r0, #8
c0de077e:	d037      	beq.n	c0de07f0 <handle_provide_parameter+0x170>
c0de0780:	461c      	mov	r4, r3
c0de0782:	2801      	cmp	r0, #1
c0de0784:	d03c      	beq.n	c0de0800 <handle_provide_parameter+0x180>
c0de0786:	2803      	cmp	r0, #3
c0de0788:	d054      	beq.n	c0de0834 <handle_provide_parameter+0x1b4>
c0de078a:	2804      	cmp	r0, #4
c0de078c:	d054      	beq.n	c0de0838 <handle_provide_parameter+0x1b8>
c0de078e:	2800      	cmp	r0, #0
c0de0790:	d123      	bne.n	c0de07da <handle_provide_parameter+0x15a>
c0de0792:	4628      	mov	r0, r5
c0de0794:	4631      	mov	r1, r6
c0de0796:	4614      	mov	r4, r2
c0de0798:	f000 f8e2 	bl	c0de0960 <handle_token_sent>
c0de079c:	2001      	movs	r0, #1
c0de079e:	e7ea      	b.n	c0de0776 <handle_provide_parameter+0xf6>
    switch (context->next_param) {
c0de07a0:	78d0      	ldrb	r0, [r2, #3]
c0de07a2:	2800      	cmp	r0, #0
c0de07a4:	d055      	beq.n	c0de0852 <handle_provide_parameter+0x1d2>
c0de07a6:	2801      	cmp	r0, #1
c0de07a8:	d06a      	beq.n	c0de0880 <handle_provide_parameter+0x200>
c0de07aa:	2802      	cmp	r0, #2
c0de07ac:	d079      	beq.n	c0de08a2 <handle_provide_parameter+0x222>
c0de07ae:	9200      	str	r2, [sp, #0]
c0de07b0:	2803      	cmp	r0, #3
c0de07b2:	d100      	bne.n	c0de07b6 <handle_provide_parameter+0x136>
c0de07b4:	e082      	b.n	c0de08bc <handle_provide_parameter+0x23c>
c0de07b6:	2804      	cmp	r0, #4
c0de07b8:	d100      	bne.n	c0de07bc <handle_provide_parameter+0x13c>
c0de07ba:	e087      	b.n	c0de08cc <handle_provide_parameter+0x24c>
c0de07bc:	2808      	cmp	r0, #8
c0de07be:	9a00      	ldr	r2, [sp, #0]
c0de07c0:	d016      	beq.n	c0de07f0 <handle_provide_parameter+0x170>
c0de07c2:	2806      	cmp	r0, #6
c0de07c4:	d100      	bne.n	c0de07c8 <handle_provide_parameter+0x148>
c0de07c6:	e08b      	b.n	c0de08e0 <handle_provide_parameter+0x260>
c0de07c8:	2805      	cmp	r0, #5
c0de07ca:	d106      	bne.n	c0de07da <handle_provide_parameter+0x15a>
c0de07cc:	4628      	mov	r0, r5
c0de07ce:	4631      	mov	r1, r6
c0de07d0:	4614      	mov	r4, r2
c0de07d2:	f000 f999 	bl	c0de0b08 <handle_beneficiary>
c0de07d6:	2003      	movs	r0, #3
c0de07d8:	e036      	b.n	c0de0848 <handle_provide_parameter+0x1c8>
c0de07da:	484e      	ldr	r0, [pc, #312]	; (c0de0914 <handle_provide_parameter+0x294>)
c0de07dc:	4478      	add	r0, pc
c0de07de:	f000 fe23 	bl	c0de1428 <mcu_usb_printf>
c0de07e2:	e003      	b.n	c0de07ec <handle_provide_parameter+0x16c>
                PRINTF("Selector Index %d not supported\n", context->selectorIndex);
c0de07e4:	4850      	ldr	r0, [pc, #320]	; (c0de0928 <handle_provide_parameter+0x2a8>)
c0de07e6:	4478      	add	r0, pc
c0de07e8:	f000 fe1e 	bl	c0de1428 <mcu_usb_printf>
c0de07ec:	2000      	movs	r0, #0
c0de07ee:	7528      	strb	r0, [r5, #20]
c0de07f0:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            handle_token_received(msg, context);
c0de07f2:	4628      	mov	r0, r5
c0de07f4:	4631      	mov	r1, r6
c0de07f6:	4614      	mov	r4, r2
c0de07f8:	f000 f91c 	bl	c0de0a34 <handle_token_received>
c0de07fc:	2003      	movs	r0, #3
c0de07fe:	e7ba      	b.n	c0de0776 <handle_provide_parameter+0xf6>
            PRINTF("Counter: %d\n", context->counter);
c0de0800:	7911      	ldrb	r1, [r2, #4]
c0de0802:	4845      	ldr	r0, [pc, #276]	; (c0de0918 <handle_provide_parameter+0x298>)
c0de0804:	4478      	add	r0, pc
c0de0806:	4617      	mov	r7, r2
c0de0808:	f000 fe0e 	bl	c0de1428 <mcu_usb_printf>
            context->counter += 1;
c0de080c:	7938      	ldrb	r0, [r7, #4]
c0de080e:	9000      	str	r0, [sp, #0]
c0de0810:	1c40      	adds	r0, r0, #1
c0de0812:	7138      	strb	r0, [r7, #4]
            if (memcmp(&msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH], NULL_ETH_ADDRESS, ADDRESS_LENGTH) == 0) {
c0de0814:	6820      	ldr	r0, [r4, #0]
c0de0816:	300c      	adds	r0, #12
c0de0818:	4940      	ldr	r1, [pc, #256]	; (c0de091c <handle_provide_parameter+0x29c>)
c0de081a:	4479      	add	r1, pc
c0de081c:	2214      	movs	r2, #20
c0de081e:	f001 f9b9 	bl	c0de1b94 <memcmp>
c0de0822:	2800      	cmp	r0, #0
c0de0824:	d06a      	beq.n	c0de08fc <handle_provide_parameter+0x27c>
                handle_token_received(msg, context);
c0de0826:	4628      	mov	r0, r5
c0de0828:	4631      	mov	r1, r6
c0de082a:	f000 f903 	bl	c0de0a34 <handle_token_received>
c0de082e:	2001      	movs	r0, #1
                context->next_param = TOKEN_RECEIVED;
c0de0830:	70f8      	strb	r0, [r7, #3]
c0de0832:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de0834:	6821      	ldr	r1, [r4, #0]
c0de0836:	e78f      	b.n	c0de0758 <handle_provide_parameter+0xd8>
    memcpy(context->min_amount_received, msg->parameter, PARAMETER_LENGTH);
c0de0838:	6821      	ldr	r1, [r4, #0]
c0de083a:	e795      	b.n	c0de0768 <handle_provide_parameter+0xe8>
            handle_token_received(msg, context);
c0de083c:	4628      	mov	r0, r5
c0de083e:	4631      	mov	r1, r6
c0de0840:	4614      	mov	r4, r2
c0de0842:	f000 f8f7 	bl	c0de0a34 <handle_token_received>
c0de0846:	2005      	movs	r0, #5
c0de0848:	70e0      	strb	r0, [r4, #3]
c0de084a:	7820      	ldrb	r0, [r4, #0]
c0de084c:	1c40      	adds	r0, r0, #1
c0de084e:	7020      	strb	r0, [r4, #0]
c0de0850:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            memcpy(context->contract_address_sent, msg->parameter, ADDRESS_LENGTH);
c0de0852:	6819      	ldr	r1, [r3, #0]
c0de0854:	3640      	adds	r6, #64	; 0x40
c0de0856:	2514      	movs	r5, #20
c0de0858:	4630      	mov	r0, r6
c0de085a:	4617      	mov	r7, r2
c0de085c:	462a      	mov	r2, r5
c0de085e:	f001 f989 	bl	c0de1b74 <__aeabi_memcpy>
            printf_hex_array("TOKEN_SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
c0de0862:	4830      	ldr	r0, [pc, #192]	; (c0de0924 <handle_provide_parameter+0x2a4>)
c0de0864:	4478      	add	r0, pc
c0de0866:	4629      	mov	r1, r5
c0de0868:	4632      	mov	r2, r6
c0de086a:	f000 f85f 	bl	c0de092c <printf_hex_array>
c0de086e:	2001      	movs	r0, #1
            context->next_param = TOKEN_RECEIVED;
c0de0870:	70f8      	strb	r0, [r7, #3]
            context->skip = (context->offset - ADDRESS_LENGTH) / 32 - 1;
c0de0872:	8820      	ldrh	r0, [r4, #0]
c0de0874:	3814      	subs	r0, #20
c0de0876:	0ec1      	lsrs	r1, r0, #27
c0de0878:	1840      	adds	r0, r0, r1
c0de087a:	0940      	lsrs	r0, r0, #5
c0de087c:	1e40      	subs	r0, r0, #1
c0de087e:	e043      	b.n	c0de0908 <handle_provide_parameter+0x288>
            memcpy(context->contract_address_received, &msg->parameter[(context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH], ADDRESS_LENGTH);
c0de0880:	8820      	ldrh	r0, [r4, #0]
c0de0882:	3814      	subs	r0, #20
c0de0884:	0ec1      	lsrs	r1, r0, #27
c0de0886:	1841      	adds	r1, r0, r1
c0de0888:	4614      	mov	r4, r2
c0de088a:	221f      	movs	r2, #31
c0de088c:	4391      	bics	r1, r2
c0de088e:	1a40      	subs	r0, r0, r1
c0de0890:	6819      	ldr	r1, [r3, #0]
c0de0892:	1809      	adds	r1, r1, r0
c0de0894:	3654      	adds	r6, #84	; 0x54
c0de0896:	2214      	movs	r2, #20
c0de0898:	4630      	mov	r0, r6
c0de089a:	f001 f96b 	bl	c0de1b74 <__aeabi_memcpy>
c0de089e:	2002      	movs	r0, #2
c0de08a0:	e769      	b.n	c0de0776 <handle_provide_parameter+0xf6>
            memcpy(&context->contract_address_received[PARAMETER_LENGTH - (context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH], &msg->parameter[0], (context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH + ADDRESS_LENGTH - PARAMETER_LENGTH);
c0de08a2:	8820      	ldrh	r0, [r4, #0]
c0de08a4:	3814      	subs	r0, #20
c0de08a6:	0ec1      	lsrs	r1, r0, #27
c0de08a8:	1841      	adds	r1, r0, r1
c0de08aa:	4614      	mov	r4, r2
c0de08ac:	221f      	movs	r2, #31
c0de08ae:	4391      	bics	r1, r2
c0de08b0:	1a42      	subs	r2, r0, r1
c0de08b2:	1ab0      	subs	r0, r6, r2
c0de08b4:	3a0c      	subs	r2, #12
c0de08b6:	3074      	adds	r0, #116	; 0x74
c0de08b8:	6819      	ldr	r1, [r3, #0]
c0de08ba:	e759      	b.n	c0de0770 <handle_provide_parameter+0xf0>
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de08bc:	6819      	ldr	r1, [r3, #0]
c0de08be:	2220      	movs	r2, #32
c0de08c0:	4630      	mov	r0, r6
c0de08c2:	f001 f957 	bl	c0de1b74 <__aeabi_memcpy>
            context->next_param = MIN_AMOUNT_RECEIVED;
c0de08c6:	9800      	ldr	r0, [sp, #0]
c0de08c8:	70c7      	strb	r7, [r0, #3]
c0de08ca:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
    memcpy(context->min_amount_received, msg->parameter, PARAMETER_LENGTH);
c0de08cc:	6819      	ldr	r1, [r3, #0]
c0de08ce:	3620      	adds	r6, #32
c0de08d0:	2220      	movs	r2, #32
c0de08d2:	4630      	mov	r0, r6
c0de08d4:	f001 f94e 	bl	c0de1b74 <__aeabi_memcpy>
c0de08d8:	2006      	movs	r0, #6
            context->next_param = PATH_LENGTH;
c0de08da:	9900      	ldr	r1, [sp, #0]
c0de08dc:	70c8      	strb	r0, [r1, #3]
c0de08de:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            context->offset = U2BE(msg->parameter, PARAMETER_LENGTH - sizeof(context->offset));
c0de08e0:	6818      	ldr	r0, [r3, #0]
  return (buf[off] << 8) | buf[off + 1];
c0de08e2:	7fc1      	ldrb	r1, [r0, #31]
c0de08e4:	7f80      	ldrb	r0, [r0, #30]
c0de08e6:	0200      	lsls	r0, r0, #8
c0de08e8:	1840      	adds	r0, r0, r1
c0de08ea:	8020      	strh	r0, [r4, #0]
            PRINTF("OFFSET: %d\n", context->offset);
c0de08ec:	b281      	uxth	r1, r0
c0de08ee:	480c      	ldr	r0, [pc, #48]	; (c0de0920 <handle_provide_parameter+0x2a0>)
c0de08f0:	4478      	add	r0, pc
c0de08f2:	4614      	mov	r4, r2
c0de08f4:	f000 fd98 	bl	c0de1428 <mcu_usb_printf>
c0de08f8:	2000      	movs	r0, #0
c0de08fa:	e73c      	b.n	c0de0776 <handle_provide_parameter+0xf6>
c0de08fc:	2003      	movs	r0, #3
                context->next_param = AMOUNT_SENT;
c0de08fe:	5238      	strh	r0, [r7, r0]
                context->skip += 20 - context->counter;
c0de0900:	7838      	ldrb	r0, [r7, #0]
c0de0902:	9900      	ldr	r1, [sp, #0]
c0de0904:	1a40      	subs	r0, r0, r1
c0de0906:	3013      	adds	r0, #19
c0de0908:	7038      	strb	r0, [r7, #0]
c0de090a:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de090c:	00001928 	.word	0x00001928
c0de0910:	000019d2 	.word	0x000019d2
c0de0914:	000017f8 	.word	0x000017f8
c0de0918:	0000187b 	.word	0x0000187b
c0de091c:	00001b4a 	.word	0x00001b4a
c0de0920:	00001775 	.word	0x00001775
c0de0924:	00001892 	.word	0x00001892
c0de0928:	00001a46 	.word	0x00001a46

c0de092c <printf_hex_array>:
                                    const uint8_t *data __attribute__((unused))) {
c0de092c:	b570      	push	{r4, r5, r6, lr}
c0de092e:	4614      	mov	r4, r2
c0de0930:	460d      	mov	r5, r1
    PRINTF(title);
c0de0932:	f000 fd79 	bl	c0de1428 <mcu_usb_printf>
c0de0936:	4e08      	ldr	r6, [pc, #32]	; (c0de0958 <printf_hex_array+0x2c>)
c0de0938:	447e      	add	r6, pc
    for (size_t i = 0; i < len; ++i) {
c0de093a:	2d00      	cmp	r5, #0
c0de093c:	d006      	beq.n	c0de094c <printf_hex_array+0x20>
        PRINTF("%02x", data[i]);
c0de093e:	7821      	ldrb	r1, [r4, #0]
c0de0940:	4630      	mov	r0, r6
c0de0942:	f000 fd71 	bl	c0de1428 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de0946:	1c64      	adds	r4, r4, #1
c0de0948:	1e6d      	subs	r5, r5, #1
c0de094a:	e7f6      	b.n	c0de093a <printf_hex_array+0xe>
    PRINTF("\n");
c0de094c:	4803      	ldr	r0, [pc, #12]	; (c0de095c <printf_hex_array+0x30>)
c0de094e:	4478      	add	r0, pc
c0de0950:	f000 fd6a 	bl	c0de1428 <mcu_usb_printf>
c0de0954:	bd70      	pop	{r4, r5, r6, pc}
c0de0956:	46c0      	nop			; (mov r8, r8)
c0de0958:	000016ea 	.word	0x000016ea
c0de095c:	0000183b 	.word	0x0000183b

c0de0960 <handle_token_sent>:
static void handle_token_sent(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
c0de0960:	b570      	push	{r4, r5, r6, lr}
c0de0962:	460e      	mov	r6, r1
c0de0964:	4605      	mov	r5, r0
    memset(context->contract_address_sent, 0, sizeof(context->contract_address_sent));
c0de0966:	460c      	mov	r4, r1
c0de0968:	3440      	adds	r4, #64	; 0x40
c0de096a:	2114      	movs	r1, #20
c0de096c:	4620      	mov	r0, r4
c0de096e:	f001 f8fb 	bl	c0de1b68 <__aeabi_memclr>
c0de0972:	209c      	movs	r0, #156	; 0x9c
    if (context->selectorIndex == CURVE_POOL_EXCHANGE || context->selectorIndex == CURVE_POOL_EXCHANGE_UNDERLYING) {
c0de0974:	5c30      	ldrb	r0, [r6, r0]
c0de0976:	21fe      	movs	r1, #254	; 0xfe
c0de0978:	4001      	ands	r1, r0
c0de097a:	2904      	cmp	r1, #4
c0de097c:	d11f      	bne.n	c0de09be <handle_token_sent+0x5e>
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de097e:	6868      	ldr	r0, [r5, #4]
c0de0980:	6806      	ldr	r6, [r0, #0]
c0de0982:	36a5      	adds	r6, #165	; 0xa5
c0de0984:	4821      	ldr	r0, [pc, #132]	; (c0de0a0c <handle_token_sent+0xac>)
c0de0986:	4478      	add	r0, pc
c0de0988:	2214      	movs	r2, #20
c0de098a:	4631      	mov	r1, r6
c0de098c:	f001 f902 	bl	c0de1b94 <memcmp>
c0de0990:	2800      	cmp	r0, #0
c0de0992:	d021      	beq.n	c0de09d8 <handle_token_sent+0x78>
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0994:	4820      	ldr	r0, [pc, #128]	; (c0de0a18 <handle_token_sent+0xb8>)
c0de0996:	4478      	add	r0, pc
c0de0998:	2214      	movs	r2, #20
c0de099a:	4631      	mov	r1, r6
c0de099c:	f001 f8fa 	bl	c0de1b94 <memcmp>
c0de09a0:	2800      	cmp	r0, #0
c0de09a2:	d112      	bne.n	c0de09ca <handle_token_sent+0x6a>
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de09a4:	68e8      	ldr	r0, [r5, #12]
c0de09a6:	7fc0      	ldrb	r0, [r0, #31]
c0de09a8:	2803      	cmp	r0, #3
c0de09aa:	d026      	beq.n	c0de09fa <handle_token_sent+0x9a>
c0de09ac:	2801      	cmp	r0, #1
c0de09ae:	d027      	beq.n	c0de0a00 <handle_token_sent+0xa0>
c0de09b0:	2802      	cmp	r0, #2
c0de09b2:	d028      	beq.n	c0de0a06 <handle_token_sent+0xa6>
c0de09b4:	2800      	cmp	r0, #0
c0de09b6:	d118      	bne.n	c0de09ea <handle_token_sent+0x8a>
                    memcpy(context->contract_address_sent, OUSD_ADDRESS, ADDRESS_LENGTH);
c0de09b8:	4918      	ldr	r1, [pc, #96]	; (c0de0a1c <handle_token_sent+0xbc>)
c0de09ba:	4479      	add	r1, pc
c0de09bc:	e001      	b.n	c0de09c2 <handle_token_sent+0x62>
            &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de09be:	68e9      	ldr	r1, [r5, #12]
c0de09c0:	310c      	adds	r1, #12
c0de09c2:	2214      	movs	r2, #20
c0de09c4:	4620      	mov	r0, r4
c0de09c6:	f001 f8d5 	bl	c0de1b74 <__aeabi_memcpy>
    printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
c0de09ca:	4819      	ldr	r0, [pc, #100]	; (c0de0a30 <handle_token_sent+0xd0>)
c0de09cc:	4478      	add	r0, pc
c0de09ce:	2114      	movs	r1, #20
c0de09d0:	4622      	mov	r2, r4
c0de09d2:	f7ff ffab 	bl	c0de092c <printf_hex_array>
}
c0de09d6:	bd70      	pop	{r4, r5, r6, pc}
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de09d8:	68e8      	ldr	r0, [r5, #12]
c0de09da:	7fc0      	ldrb	r0, [r0, #31]
c0de09dc:	2801      	cmp	r0, #1
c0de09de:	d009      	beq.n	c0de09f4 <handle_token_sent+0x94>
c0de09e0:	2800      	cmp	r0, #0
c0de09e2:	d102      	bne.n	c0de09ea <handle_token_sent+0x8a>
                    memcpy(context->contract_address_sent,
c0de09e4:	490a      	ldr	r1, [pc, #40]	; (c0de0a10 <handle_token_sent+0xb0>)
c0de09e6:	4479      	add	r1, pc
c0de09e8:	e7eb      	b.n	c0de09c2 <handle_token_sent+0x62>
c0de09ea:	4810      	ldr	r0, [pc, #64]	; (c0de0a2c <handle_token_sent+0xcc>)
c0de09ec:	4478      	add	r0, pc
c0de09ee:	f000 fd1b 	bl	c0de1428 <mcu_usb_printf>
c0de09f2:	e7ea      	b.n	c0de09ca <handle_token_sent+0x6a>
                    memcpy(context->contract_address_sent,
c0de09f4:	4907      	ldr	r1, [pc, #28]	; (c0de0a14 <handle_token_sent+0xb4>)
c0de09f6:	4479      	add	r1, pc
c0de09f8:	e7e3      	b.n	c0de09c2 <handle_token_sent+0x62>
                    memcpy(context->contract_address_sent, USDT_ADDRESS, ADDRESS_LENGTH);
c0de09fa:	490b      	ldr	r1, [pc, #44]	; (c0de0a28 <handle_token_sent+0xc8>)
c0de09fc:	4479      	add	r1, pc
c0de09fe:	e7e0      	b.n	c0de09c2 <handle_token_sent+0x62>
                    memcpy(context->contract_address_sent, DAI_ADDRESS, ADDRESS_LENGTH);
c0de0a00:	4907      	ldr	r1, [pc, #28]	; (c0de0a20 <handle_token_sent+0xc0>)
c0de0a02:	4479      	add	r1, pc
c0de0a04:	e7dd      	b.n	c0de09c2 <handle_token_sent+0x62>
                    memcpy(context->contract_address_sent, USDC_ADDRESS, ADDRESS_LENGTH);
c0de0a06:	4907      	ldr	r1, [pc, #28]	; (c0de0a24 <handle_token_sent+0xc4>)
c0de0a08:	4479      	add	r1, pc
c0de0a0a:	e7da      	b.n	c0de09c2 <handle_token_sent+0x62>
c0de0a0c:	00001996 	.word	0x00001996
c0de0a10:	0000197e 	.word	0x0000197e
c0de0a14:	000018ae 	.word	0x000018ae
c0de0a18:	0000199a 	.word	0x0000199a
c0de0a1c:	000018fe 	.word	0x000018fe
c0de0a20:	000018ca 	.word	0x000018ca
c0de0a24:	000018d8 	.word	0x000018d8
c0de0a28:	000018f8 	.word	0x000018f8
c0de0a2c:	000015e8 	.word	0x000015e8
c0de0a30:	0000161d 	.word	0x0000161d

c0de0a34 <handle_token_received>:
                                  origin_defi_parameters_t *context) {
c0de0a34:	b570      	push	{r4, r5, r6, lr}
c0de0a36:	460e      	mov	r6, r1
c0de0a38:	4605      	mov	r5, r0
    memset(context->contract_address_received, 0, sizeof(context->contract_address_received));
c0de0a3a:	460c      	mov	r4, r1
c0de0a3c:	3454      	adds	r4, #84	; 0x54
c0de0a3e:	2114      	movs	r1, #20
c0de0a40:	4620      	mov	r0, r4
c0de0a42:	f001 f891 	bl	c0de1b68 <__aeabi_memclr>
c0de0a46:	209c      	movs	r0, #156	; 0x9c
    if (context->selectorIndex == CURVE_POOL_EXCHANGE || context->selectorIndex == CURVE_POOL_EXCHANGE_UNDERLYING) {
c0de0a48:	5c30      	ldrb	r0, [r6, r0]
c0de0a4a:	21fe      	movs	r1, #254	; 0xfe
c0de0a4c:	4001      	ands	r1, r0
c0de0a4e:	2904      	cmp	r1, #4
c0de0a50:	d11f      	bne.n	c0de0a92 <handle_token_received+0x5e>
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0a52:	6868      	ldr	r0, [r5, #4]
c0de0a54:	6806      	ldr	r6, [r0, #0]
c0de0a56:	36a5      	adds	r6, #165	; 0xa5
c0de0a58:	4821      	ldr	r0, [pc, #132]	; (c0de0ae0 <handle_token_received+0xac>)
c0de0a5a:	4478      	add	r0, pc
c0de0a5c:	2214      	movs	r2, #20
c0de0a5e:	4631      	mov	r1, r6
c0de0a60:	f001 f898 	bl	c0de1b94 <memcmp>
c0de0a64:	2800      	cmp	r0, #0
c0de0a66:	d021      	beq.n	c0de0aac <handle_token_received+0x78>
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de0a68:	4820      	ldr	r0, [pc, #128]	; (c0de0aec <handle_token_received+0xb8>)
c0de0a6a:	4478      	add	r0, pc
c0de0a6c:	2214      	movs	r2, #20
c0de0a6e:	4631      	mov	r1, r6
c0de0a70:	f001 f890 	bl	c0de1b94 <memcmp>
c0de0a74:	2800      	cmp	r0, #0
c0de0a76:	d112      	bne.n	c0de0a9e <handle_token_received+0x6a>
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de0a78:	68e8      	ldr	r0, [r5, #12]
c0de0a7a:	7fc0      	ldrb	r0, [r0, #31]
c0de0a7c:	2803      	cmp	r0, #3
c0de0a7e:	d026      	beq.n	c0de0ace <handle_token_received+0x9a>
c0de0a80:	2801      	cmp	r0, #1
c0de0a82:	d027      	beq.n	c0de0ad4 <handle_token_received+0xa0>
c0de0a84:	2802      	cmp	r0, #2
c0de0a86:	d028      	beq.n	c0de0ada <handle_token_received+0xa6>
c0de0a88:	2800      	cmp	r0, #0
c0de0a8a:	d118      	bne.n	c0de0abe <handle_token_received+0x8a>
                    memcpy(context->contract_address_received, OUSD_ADDRESS, ADDRESS_LENGTH);
c0de0a8c:	4918      	ldr	r1, [pc, #96]	; (c0de0af0 <handle_token_received+0xbc>)
c0de0a8e:	4479      	add	r1, pc
c0de0a90:	e001      	b.n	c0de0a96 <handle_token_received+0x62>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de0a92:	68e9      	ldr	r1, [r5, #12]
c0de0a94:	310c      	adds	r1, #12
c0de0a96:	2214      	movs	r2, #20
c0de0a98:	4620      	mov	r0, r4
c0de0a9a:	f001 f86b 	bl	c0de1b74 <__aeabi_memcpy>
    printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH, context->contract_address_received);
c0de0a9e:	4819      	ldr	r0, [pc, #100]	; (c0de0b04 <handle_token_received+0xd0>)
c0de0aa0:	4478      	add	r0, pc
c0de0aa2:	2114      	movs	r1, #20
c0de0aa4:	4622      	mov	r2, r4
c0de0aa6:	f7ff ff41 	bl	c0de092c <printf_hex_array>
}
c0de0aaa:	bd70      	pop	{r4, r5, r6, pc}
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
c0de0aac:	68e8      	ldr	r0, [r5, #12]
c0de0aae:	7fc0      	ldrb	r0, [r0, #31]
c0de0ab0:	2801      	cmp	r0, #1
c0de0ab2:	d009      	beq.n	c0de0ac8 <handle_token_received+0x94>
c0de0ab4:	2800      	cmp	r0, #0
c0de0ab6:	d102      	bne.n	c0de0abe <handle_token_received+0x8a>
                    memcpy(context->contract_address_received, NULL_ETH_ADDRESS, ADDRESS_LENGTH);
c0de0ab8:	490a      	ldr	r1, [pc, #40]	; (c0de0ae4 <handle_token_received+0xb0>)
c0de0aba:	4479      	add	r1, pc
c0de0abc:	e7eb      	b.n	c0de0a96 <handle_token_received+0x62>
c0de0abe:	4810      	ldr	r0, [pc, #64]	; (c0de0b00 <handle_token_received+0xcc>)
c0de0ac0:	4478      	add	r0, pc
c0de0ac2:	f000 fcb1 	bl	c0de1428 <mcu_usb_printf>
c0de0ac6:	e7ea      	b.n	c0de0a9e <handle_token_received+0x6a>
                    memcpy(context->contract_address_received, OETH_ADDRESS, ADDRESS_LENGTH);
c0de0ac8:	4907      	ldr	r1, [pc, #28]	; (c0de0ae8 <handle_token_received+0xb4>)
c0de0aca:	4479      	add	r1, pc
c0de0acc:	e7e3      	b.n	c0de0a96 <handle_token_received+0x62>
                    memcpy(context->contract_address_received, USDT_ADDRESS, ADDRESS_LENGTH);
c0de0ace:	490b      	ldr	r1, [pc, #44]	; (c0de0afc <handle_token_received+0xc8>)
c0de0ad0:	4479      	add	r1, pc
c0de0ad2:	e7e0      	b.n	c0de0a96 <handle_token_received+0x62>
                    memcpy(context->contract_address_received, DAI_ADDRESS, ADDRESS_LENGTH);
c0de0ad4:	4907      	ldr	r1, [pc, #28]	; (c0de0af4 <handle_token_received+0xc0>)
c0de0ad6:	4479      	add	r1, pc
c0de0ad8:	e7dd      	b.n	c0de0a96 <handle_token_received+0x62>
                    memcpy(context->contract_address_received, USDC_ADDRESS, ADDRESS_LENGTH);
c0de0ada:	4907      	ldr	r1, [pc, #28]	; (c0de0af8 <handle_token_received+0xc4>)
c0de0adc:	4479      	add	r1, pc
c0de0ade:	e7da      	b.n	c0de0a96 <handle_token_received+0x62>
c0de0ae0:	000018c2 	.word	0x000018c2
c0de0ae4:	000018aa 	.word	0x000018aa
c0de0ae8:	000017da 	.word	0x000017da
c0de0aec:	000018c6 	.word	0x000018c6
c0de0af0:	0000182a 	.word	0x0000182a
c0de0af4:	000017f6 	.word	0x000017f6
c0de0af8:	00001804 	.word	0x00001804
c0de0afc:	00001824 	.word	0x00001824
c0de0b00:	00001514 	.word	0x00001514
c0de0b04:	00001594 	.word	0x00001594

c0de0b08 <handle_beneficiary>:
static void handle_beneficiary(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
c0de0b08:	b570      	push	{r4, r5, r6, lr}
c0de0b0a:	460c      	mov	r4, r1
c0de0b0c:	4606      	mov	r6, r0
    memset(context->beneficiary, 0, sizeof(context->beneficiary));
c0de0b0e:	3468      	adds	r4, #104	; 0x68
c0de0b10:	2514      	movs	r5, #20
c0de0b12:	4620      	mov	r0, r4
c0de0b14:	4629      	mov	r1, r5
c0de0b16:	f001 f827 	bl	c0de1b68 <__aeabi_memclr>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de0b1a:	68f1      	ldr	r1, [r6, #12]
c0de0b1c:	310c      	adds	r1, #12
    memcpy(context->beneficiary,
c0de0b1e:	4620      	mov	r0, r4
c0de0b20:	462a      	mov	r2, r5
c0de0b22:	f001 f827 	bl	c0de1b74 <__aeabi_memcpy>
    printf_hex_array("BENEFICIARY: ", ADDRESS_LENGTH, context->beneficiary);
c0de0b26:	4803      	ldr	r0, [pc, #12]	; (c0de0b34 <handle_beneficiary+0x2c>)
c0de0b28:	4478      	add	r0, pc
c0de0b2a:	4629      	mov	r1, r5
c0de0b2c:	4622      	mov	r2, r4
c0de0b2e:	f7ff fefd 	bl	c0de092c <printf_hex_array>
}
c0de0b32:	bd70      	pop	{r4, r5, r6, pc}
c0de0b34:	00001564 	.word	0x00001564

c0de0b38 <handle_provide_token>:
#include "origin_defi_plugin.h"

// EDIT THIS: Adapt this function to your needs! Remember, the information for tokens are held in
// `msg->token1` and `msg->token2`. If those pointers are `NULL`, this means the ethereum app didn't
// find any info regarding the requested tokens!
void handle_provide_token(void *parameters) {
c0de0b38:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de0b3a:	4604      	mov	r4, r0
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0b3c:	6885      	ldr	r5, [r0, #8]
    PRINTF("OETH plugin provide token: 0x%p, 0x%p\n", msg->item1, msg->item2);
c0de0b3e:	68c1      	ldr	r1, [r0, #12]
c0de0b40:	6902      	ldr	r2, [r0, #16]
c0de0b42:	485c      	ldr	r0, [pc, #368]	; (c0de0cb4 <handle_provide_token+0x17c>)
c0de0b44:	4478      	add	r0, pc
c0de0b46:	f000 fc6f 	bl	c0de1428 <mcu_usb_printf>
    if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de0b4a:	462e      	mov	r6, r5
c0de0b4c:	3640      	adds	r6, #64	; 0x40
c0de0b4e:	495a      	ldr	r1, [pc, #360]	; (c0de0cb8 <handle_provide_token+0x180>)
c0de0b50:	4479      	add	r1, pc
c0de0b52:	2214      	movs	r2, #20
c0de0b54:	4630      	mov	r0, r6
c0de0b56:	f001 f81d 	bl	c0de1b94 <memcmp>
c0de0b5a:	462f      	mov	r7, r5
c0de0b5c:	3792      	adds	r7, #146	; 0x92
c0de0b5e:	2800      	cmp	r0, #0
c0de0b60:	d033      	beq.n	c0de0bca <handle_provide_token+0x92>
    } else if (ADDRESS_IS_OUSD(context->contract_address_sent)) {
c0de0b62:	4956      	ldr	r1, [pc, #344]	; (c0de0cbc <handle_provide_token+0x184>)
c0de0b64:	4479      	add	r1, pc
c0de0b66:	2214      	movs	r2, #20
c0de0b68:	4630      	mov	r0, r6
c0de0b6a:	f001 f813 	bl	c0de1b94 <memcmp>
c0de0b6e:	2800      	cmp	r0, #0
c0de0b70:	d02b      	beq.n	c0de0bca <handle_provide_token+0x92>
    } else if (ADDRESS_IS_DAI(context->contract_address_sent)) {
c0de0b72:	4953      	ldr	r1, [pc, #332]	; (c0de0cc0 <handle_provide_token+0x188>)
c0de0b74:	4479      	add	r1, pc
c0de0b76:	2214      	movs	r2, #20
c0de0b78:	4630      	mov	r0, r6
c0de0b7a:	f001 f80b 	bl	c0de1b94 <memcmp>
c0de0b7e:	2800      	cmp	r0, #0
c0de0b80:	d023      	beq.n	c0de0bca <handle_provide_token+0x92>
    } else if (ADDRESS_IS_USDC(context->contract_address_sent)) {
c0de0b82:	4950      	ldr	r1, [pc, #320]	; (c0de0cc4 <handle_provide_token+0x18c>)
c0de0b84:	4479      	add	r1, pc
c0de0b86:	2214      	movs	r2, #20
c0de0b88:	4630      	mov	r0, r6
c0de0b8a:	f001 f803 	bl	c0de1b94 <memcmp>
c0de0b8e:	2800      	cmp	r0, #0
c0de0b90:	d068      	beq.n	c0de0c64 <handle_provide_token+0x12c>
    } else if (ADDRESS_IS_USDT(context->contract_address_sent)) {
c0de0b92:	494d      	ldr	r1, [pc, #308]	; (c0de0cc8 <handle_provide_token+0x190>)
c0de0b94:	4479      	add	r1, pc
c0de0b96:	2214      	movs	r2, #20
c0de0b98:	4630      	mov	r0, r6
c0de0b9a:	f000 fffb 	bl	c0de1b94 <memcmp>
c0de0b9e:	2800      	cmp	r0, #0
c0de0ba0:	d060      	beq.n	c0de0c64 <handle_provide_token+0x12c>
    if (!check_token_sent(context)) {
        if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0ba2:	494a      	ldr	r1, [pc, #296]	; (c0de0ccc <handle_provide_token+0x194>)
c0de0ba4:	4479      	add	r1, pc
c0de0ba6:	2214      	movs	r2, #20
c0de0ba8:	4630      	mov	r0, r6
c0de0baa:	f000 fff3 	bl	c0de1b94 <memcmp>
c0de0bae:	2800      	cmp	r0, #0
c0de0bb0:	d00b      	beq.n	c0de0bca <handle_provide_token+0x92>
            sent_network_token(context);
        } else if (msg->item1 != NULL) {
c0de0bb2:	68e1      	ldr	r1, [r4, #12]
c0de0bb4:	2900      	cmp	r1, #0
c0de0bb6:	d059      	beq.n	c0de0c6c <handle_provide_token+0x134>
            context->decimals_sent = msg->item1->token.decimals;
c0de0bb8:	7fc8      	ldrb	r0, [r1, #31]
c0de0bba:	7078      	strb	r0, [r7, #1]
            strlcpy(context->ticker_sent,
c0de0bbc:	4628      	mov	r0, r5
c0de0bbe:	307c      	adds	r0, #124	; 0x7c
            context->decimals_sent = msg->item1->token.decimals;
c0de0bc0:	3114      	adds	r1, #20
c0de0bc2:	220b      	movs	r2, #11
            strlcpy(context->ticker_sent,
c0de0bc4:	f001 f962 	bl	c0de1e8c <strlcpy>
c0de0bc8:	e001      	b.n	c0de0bce <handle_provide_token+0x96>
c0de0bca:	2012      	movs	r0, #18
c0de0bcc:	7078      	strb	r0, [r7, #1]
c0de0bce:	7838      	ldrb	r0, [r7, #0]
c0de0bd0:	2101      	movs	r1, #1
c0de0bd2:	4301      	orrs	r1, r0
c0de0bd4:	7039      	strb	r1, [r7, #0]
    if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de0bd6:	462e      	mov	r6, r5
c0de0bd8:	3654      	adds	r6, #84	; 0x54
c0de0bda:	493e      	ldr	r1, [pc, #248]	; (c0de0cd4 <handle_provide_token+0x19c>)
c0de0bdc:	4479      	add	r1, pc
c0de0bde:	2214      	movs	r2, #20
c0de0be0:	4630      	mov	r0, r6
c0de0be2:	f000 ffd7 	bl	c0de1b94 <memcmp>
c0de0be6:	2800      	cmp	r0, #0
c0de0be8:	d033      	beq.n	c0de0c52 <handle_provide_token+0x11a>
    } else if (ADDRESS_IS_OUSD(context->contract_address_received)) {
c0de0bea:	493b      	ldr	r1, [pc, #236]	; (c0de0cd8 <handle_provide_token+0x1a0>)
c0de0bec:	4479      	add	r1, pc
c0de0bee:	2214      	movs	r2, #20
c0de0bf0:	4630      	mov	r0, r6
c0de0bf2:	f000 ffcf 	bl	c0de1b94 <memcmp>
c0de0bf6:	2800      	cmp	r0, #0
c0de0bf8:	d02b      	beq.n	c0de0c52 <handle_provide_token+0x11a>
    } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de0bfa:	4938      	ldr	r1, [pc, #224]	; (c0de0cdc <handle_provide_token+0x1a4>)
c0de0bfc:	4479      	add	r1, pc
c0de0bfe:	2214      	movs	r2, #20
c0de0c00:	4630      	mov	r0, r6
c0de0c02:	f000 ffc7 	bl	c0de1b94 <memcmp>
c0de0c06:	2800      	cmp	r0, #0
c0de0c08:	d023      	beq.n	c0de0c52 <handle_provide_token+0x11a>
    } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de0c0a:	4935      	ldr	r1, [pc, #212]	; (c0de0ce0 <handle_provide_token+0x1a8>)
c0de0c0c:	4479      	add	r1, pc
c0de0c0e:	2214      	movs	r2, #20
c0de0c10:	4630      	mov	r0, r6
c0de0c12:	f000 ffbf 	bl	c0de1b94 <memcmp>
c0de0c16:	2800      	cmp	r0, #0
c0de0c18:	d026      	beq.n	c0de0c68 <handle_provide_token+0x130>
    } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de0c1a:	4932      	ldr	r1, [pc, #200]	; (c0de0ce4 <handle_provide_token+0x1ac>)
c0de0c1c:	4479      	add	r1, pc
c0de0c1e:	2214      	movs	r2, #20
c0de0c20:	4630      	mov	r0, r6
c0de0c22:	f000 ffb7 	bl	c0de1b94 <memcmp>
c0de0c26:	2800      	cmp	r0, #0
c0de0c28:	d01e      	beq.n	c0de0c68 <handle_provide_token+0x130>
            msg->additionalScreens++;
        }
    }

    if (!check_token_received(context)) {
        if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0c2a:	492f      	ldr	r1, [pc, #188]	; (c0de0ce8 <handle_provide_token+0x1b0>)
c0de0c2c:	4479      	add	r1, pc
c0de0c2e:	2214      	movs	r2, #20
c0de0c30:	4630      	mov	r0, r6
c0de0c32:	f000 ffaf 	bl	c0de1b94 <memcmp>
c0de0c36:	2800      	cmp	r0, #0
c0de0c38:	d00b      	beq.n	c0de0c52 <handle_provide_token+0x11a>
            received_network_token(context);
        } else if (msg->item2 != NULL) {
c0de0c3a:	6921      	ldr	r1, [r4, #16]
c0de0c3c:	2900      	cmp	r1, #0
c0de0c3e:	d022      	beq.n	c0de0c86 <handle_provide_token+0x14e>
            context->decimals_received = msg->item2->token.decimals;
c0de0c40:	7fc8      	ldrb	r0, [r1, #31]
c0de0c42:	70b8      	strb	r0, [r7, #2]
            strlcpy(context->ticker_received,
c0de0c44:	3587      	adds	r5, #135	; 0x87
            context->decimals_received = msg->item2->token.decimals;
c0de0c46:	3114      	adds	r1, #20
c0de0c48:	220b      	movs	r2, #11
            strlcpy(context->ticker_received,
c0de0c4a:	4628      	mov	r0, r5
c0de0c4c:	f001 f91e 	bl	c0de1e8c <strlcpy>
c0de0c50:	e001      	b.n	c0de0c56 <handle_provide_token+0x11e>
c0de0c52:	2012      	movs	r0, #18
c0de0c54:	70b8      	strb	r0, [r7, #2]
c0de0c56:	7838      	ldrb	r0, [r7, #0]
c0de0c58:	2102      	movs	r1, #2
c0de0c5a:	4301      	orrs	r1, r0
c0de0c5c:	7039      	strb	r1, [r7, #0]
c0de0c5e:	2004      	movs	r0, #4
            // // We will need an additional screen to display a warning message.
            msg->additionalScreens++;
        }
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0c60:	7560      	strb	r0, [r4, #21]
c0de0c62:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0c64:	2006      	movs	r0, #6
c0de0c66:	e7b1      	b.n	c0de0bcc <handle_provide_token+0x94>
c0de0c68:	2006      	movs	r0, #6
c0de0c6a:	e7f3      	b.n	c0de0c54 <handle_provide_token+0x11c>
c0de0c6c:	2012      	movs	r0, #18
            context->decimals_sent = DEFAULT_DECIMAL;
c0de0c6e:	7078      	strb	r0, [r7, #1]
            strlcpy(context->ticker_sent, DEFAULT_TICKER, sizeof(context->ticker_sent));
c0de0c70:	4628      	mov	r0, r5
c0de0c72:	307c      	adds	r0, #124	; 0x7c
c0de0c74:	4916      	ldr	r1, [pc, #88]	; (c0de0cd0 <handle_provide_token+0x198>)
c0de0c76:	4479      	add	r1, pc
c0de0c78:	220b      	movs	r2, #11
c0de0c7a:	f001 f907 	bl	c0de1e8c <strlcpy>
            msg->additionalScreens++;
c0de0c7e:	7d20      	ldrb	r0, [r4, #20]
c0de0c80:	1c40      	adds	r0, r0, #1
c0de0c82:	7520      	strb	r0, [r4, #20]
c0de0c84:	e7a7      	b.n	c0de0bd6 <handle_provide_token+0x9e>
c0de0c86:	2012      	movs	r0, #18
c0de0c88:	70b8      	strb	r0, [r7, #2]
c0de0c8a:	3587      	adds	r5, #135	; 0x87
        } else if (context->selectorIndex == VAULT_REDEEM) {
c0de0c8c:	7ab8      	ldrb	r0, [r7, #10]
c0de0c8e:	2803      	cmp	r0, #3
c0de0c90:	d106      	bne.n	c0de0ca0 <handle_provide_token+0x168>
            strlcpy(context->ticker_received, "UNITS", sizeof(context->ticker_received));
c0de0c92:	4916      	ldr	r1, [pc, #88]	; (c0de0cec <handle_provide_token+0x1b4>)
c0de0c94:	4479      	add	r1, pc
c0de0c96:	220b      	movs	r2, #11
c0de0c98:	4628      	mov	r0, r5
c0de0c9a:	f001 f8f7 	bl	c0de1e8c <strlcpy>
c0de0c9e:	e7de      	b.n	c0de0c5e <handle_provide_token+0x126>
            strlcpy(context->ticker_received, DEFAULT_TICKER, sizeof(context->ticker_received));
c0de0ca0:	4913      	ldr	r1, [pc, #76]	; (c0de0cf0 <handle_provide_token+0x1b8>)
c0de0ca2:	4479      	add	r1, pc
c0de0ca4:	220b      	movs	r2, #11
c0de0ca6:	4628      	mov	r0, r5
c0de0ca8:	f001 f8f0 	bl	c0de1e8c <strlcpy>
            msg->additionalScreens++;
c0de0cac:	7d20      	ldrb	r0, [r4, #20]
c0de0cae:	1c40      	adds	r0, r0, #1
c0de0cb0:	7520      	strb	r0, [r4, #20]
c0de0cb2:	e7d4      	b.n	c0de0c5e <handle_provide_token+0x126>
c0de0cb4:	000014b2 	.word	0x000014b2
c0de0cb8:	00001754 	.word	0x00001754
c0de0cbc:	00001754 	.word	0x00001754
c0de0cc0:	00001758 	.word	0x00001758
c0de0cc4:	0000175c 	.word	0x0000175c
c0de0cc8:	00001760 	.word	0x00001760
c0de0ccc:	000017c0 	.word	0x000017c0
c0de0cd0:	00001547 	.word	0x00001547
c0de0cd4:	000016c8 	.word	0x000016c8
c0de0cd8:	000016cc 	.word	0x000016cc
c0de0cdc:	000016d0 	.word	0x000016d0
c0de0ce0:	000016d4 	.word	0x000016d4
c0de0ce4:	000016d8 	.word	0x000016d8
c0de0ce8:	00001738 	.word	0x00001738
c0de0cec:	0000156f 	.word	0x0000156f
c0de0cf0:	0000151b 	.word	0x0000151b

c0de0cf4 <handle_query_contract_id>:
#include "origin_defi_plugin.h"

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de0cf4:	b5b0      	push	{r4, r5, r7, lr}
c0de0cf6:	4604      	mov	r4, r0
    ethQueryContractID_t *msg = (ethQueryContractID_t *) parameters;
    const origin_defi_parameters_t *context = (const origin_defi_parameters_t *) msg->pluginContext;
c0de0cf8:	6885      	ldr	r5, [r0, #8]
    // msg->name will be the upper sentence displayed on the screen.
    // msg->version will be the lower sentence displayed on the screen.

    // For the first screen, display the plugin name.
    strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de0cfa:	68c0      	ldr	r0, [r0, #12]
c0de0cfc:	6922      	ldr	r2, [r4, #16]
c0de0cfe:	4910      	ldr	r1, [pc, #64]	; (c0de0d40 <handle_query_contract_id+0x4c>)
c0de0d00:	4479      	add	r1, pc
c0de0d02:	f001 f8c3 	bl	c0de1e8c <strlcpy>
c0de0d06:	209c      	movs	r0, #156	; 0x9c

    switch (context->selectorIndex) {
c0de0d08:	5c29      	ldrb	r1, [r5, r0]
c0de0d0a:	1f08      	subs	r0, r1, #4
c0de0d0c:	280b      	cmp	r0, #11
c0de0d0e:	d202      	bcs.n	c0de0d16 <handle_query_contract_id+0x22>
c0de0d10:	490f      	ldr	r1, [pc, #60]	; (c0de0d50 <handle_query_contract_id+0x5c>)
c0de0d12:	4479      	add	r1, pc
c0de0d14:	e007      	b.n	c0de0d26 <handle_query_contract_id+0x32>
c0de0d16:	2903      	cmp	r1, #3
c0de0d18:	d202      	bcs.n	c0de0d20 <handle_query_contract_id+0x2c>
c0de0d1a:	490a      	ldr	r1, [pc, #40]	; (c0de0d44 <handle_query_contract_id+0x50>)
c0de0d1c:	4479      	add	r1, pc
c0de0d1e:	e002      	b.n	c0de0d26 <handle_query_contract_id+0x32>
c0de0d20:	d108      	bne.n	c0de0d34 <handle_query_contract_id+0x40>
c0de0d22:	4909      	ldr	r1, [pc, #36]	; (c0de0d48 <handle_query_contract_id+0x54>)
c0de0d24:	4479      	add	r1, pc
c0de0d26:	6960      	ldr	r0, [r4, #20]
c0de0d28:	69a2      	ldr	r2, [r4, #24]
c0de0d2a:	f001 f8af 	bl	c0de1e8c <strlcpy>
c0de0d2e:	2004      	movs	r0, #4
c0de0d30:	7720      	strb	r0, [r4, #28]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0d32:	bdb0      	pop	{r4, r5, r7, pc}
            PRINTF("Selector Index :%d not supported\n", context->selectorIndex);
c0de0d34:	4805      	ldr	r0, [pc, #20]	; (c0de0d4c <handle_query_contract_id+0x58>)
c0de0d36:	4478      	add	r0, pc
c0de0d38:	f000 fb76 	bl	c0de1428 <mcu_usb_printf>
c0de0d3c:	2000      	movs	r0, #0
c0de0d3e:	e7f7      	b.n	c0de0d30 <handle_query_contract_id+0x3c>
c0de0d40:	0000134a 	.word	0x0000134a
c0de0d44:	00001301 	.word	0x00001301
c0de0d48:	00001332 	.word	0x00001332
c0de0d4c:	00001488 	.word	0x00001488
c0de0d50:	00001315 	.word	0x00001315

c0de0d54 <handle_query_contract_ui>:
            break;
    }
    return ERROR;
}

void handle_query_contract_ui(void *parameters) {
c0de0d54:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0d56:	b087      	sub	sp, #28
c0de0d58:	4604      	mov	r4, r0
    ethQueryContractUI_t *msg = (ethQueryContractUI_t *) parameters;
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
c0de0d5a:	69c6      	ldr	r6, [r0, #28]
    memset(msg->title, 0, msg->titleLength);
c0de0d5c:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de0d5e:	6aa1      	ldr	r1, [r4, #40]	; 0x28
c0de0d60:	f000 ff02 	bl	c0de1b68 <__aeabi_memclr>
    memset(msg->msg, 0, msg->msgLength);
c0de0d64:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0d66:	6b21      	ldr	r1, [r4, #48]	; 0x30
c0de0d68:	f000 fefe 	bl	c0de1b68 <__aeabi_memclr>
c0de0d6c:	4621      	mov	r1, r4
c0de0d6e:	3120      	adds	r1, #32
c0de0d70:	2004      	movs	r0, #4
c0de0d72:	9106      	str	r1, [sp, #24]
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0d74:	7508      	strb	r0, [r1, #20]
c0de0d76:	2120      	movs	r1, #32
c0de0d78:	9103      	str	r1, [sp, #12]
    uint8_t index = msg->screenIndex;
c0de0d7a:	5c67      	ldrb	r7, [r4, r1]
c0de0d7c:	2192      	movs	r1, #146	; 0x92
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0d7e:	5c72      	ldrb	r2, [r6, r1]
c0de0d80:	2503      	movs	r5, #3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0d82:	4613      	mov	r3, r2
c0de0d84:	402b      	ands	r3, r5
c0de0d86:	4631      	mov	r1, r6
c0de0d88:	3192      	adds	r1, #146	; 0x92
c0de0d8a:	9104      	str	r1, [sp, #16]
    switch (index) {
c0de0d8c:	2f04      	cmp	r7, #4
c0de0d8e:	9605      	str	r6, [sp, #20]
c0de0d90:	d021      	beq.n	c0de0dd6 <handle_query_contract_ui+0x82>
c0de0d92:	2602      	movs	r6, #2
c0de0d94:	4611      	mov	r1, r2
c0de0d96:	4031      	ands	r1, r6
c0de0d98:	2001      	movs	r0, #1
c0de0d9a:	4002      	ands	r2, r0
c0de0d9c:	2f01      	cmp	r7, #1
c0de0d9e:	d022      	beq.n	c0de0de6 <handle_query_contract_ui+0x92>
c0de0da0:	2f02      	cmp	r7, #2
c0de0da2:	d032      	beq.n	c0de0e0a <handle_query_contract_ui+0xb6>
c0de0da4:	2f03      	cmp	r7, #3
c0de0da6:	d035      	beq.n	c0de0e14 <handle_query_contract_ui+0xc0>
c0de0da8:	2f00      	cmp	r7, #0
c0de0daa:	d000      	beq.n	c0de0dae <handle_query_contract_ui+0x5a>
c0de0dac:	e087      	b.n	c0de0ebe <handle_query_contract_ui+0x16a>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0dae:	425d      	negs	r5, r3
c0de0db0:	415d      	adcs	r5, r3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0db2:	1edb      	subs	r3, r3, #3
c0de0db4:	4258      	negs	r0, r3
c0de0db6:	4158      	adcs	r0, r3
            if (both_tokens_found) {
c0de0db8:	4328      	orrs	r0, r5
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0dba:	1e55      	subs	r5, r2, #1
c0de0dbc:	41aa      	sbcs	r2, r5
            if (both_tokens_found) {
c0de0dbe:	4302      	orrs	r2, r0
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0dc0:	1e5d      	subs	r5, r3, #1
c0de0dc2:	41ab      	sbcs	r3, r5
            if (both_tokens_found) {
c0de0dc4:	2800      	cmp	r0, #0
c0de0dc6:	d000      	beq.n	c0de0dca <handle_query_contract_ui+0x76>
c0de0dc8:	0058      	lsls	r0, r3, #1
c0de0dca:	2a00      	cmp	r2, #0
c0de0dcc:	d100      	bne.n	c0de0dd0 <handle_query_contract_ui+0x7c>
c0de0dce:	4630      	mov	r0, r6
c0de0dd0:	2a00      	cmp	r2, #0
c0de0dd2:	d017      	beq.n	c0de0e04 <handle_query_contract_ui+0xb0>
c0de0dd4:	e023      	b.n	c0de0e1e <handle_query_contract_ui+0xca>
            if (both_tokens_found) {
c0de0dd6:	2b03      	cmp	r3, #3
c0de0dd8:	d000      	beq.n	c0de0ddc <handle_query_contract_ui+0x88>
c0de0dda:	2003      	movs	r0, #3
c0de0ddc:	2b03      	cmp	r3, #3
c0de0dde:	d01e      	beq.n	c0de0e1e <handle_query_contract_ui+0xca>
c0de0de0:	2b00      	cmp	r3, #0
c0de0de2:	d01c      	beq.n	c0de0e1e <handle_query_contract_ui+0xca>
c0de0de4:	e06b      	b.n	c0de0ebe <handle_query_contract_ui+0x16a>
    bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de0de6:	425d      	negs	r5, r3
c0de0de8:	415d      	adcs	r5, r3
    bool both_tokens_found = token_received_found && token_sent_found;
c0de0dea:	1edb      	subs	r3, r3, #3
c0de0dec:	4258      	negs	r0, r3
c0de0dee:	4158      	adcs	r0, r3
            if (both_tokens_found) {
c0de0df0:	4305      	orrs	r5, r0
c0de0df2:	d100      	bne.n	c0de0df6 <handle_query_contract_ui+0xa2>
c0de0df4:	2002      	movs	r0, #2
    bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de0df6:	1e53      	subs	r3, r2, #1
c0de0df8:	419a      	sbcs	r2, r3
            if (both_tokens_found) {
c0de0dfa:	4315      	orrs	r5, r2
c0de0dfc:	d100      	bne.n	c0de0e00 <handle_query_contract_ui+0xac>
c0de0dfe:	4628      	mov	r0, r5
c0de0e00:	2d00      	cmp	r5, #0
c0de0e02:	d10c      	bne.n	c0de0e1e <handle_query_contract_ui+0xca>
c0de0e04:	2900      	cmp	r1, #0
c0de0e06:	d05a      	beq.n	c0de0ebe <handle_query_contract_ui+0x16a>
c0de0e08:	e009      	b.n	c0de0e1e <handle_query_contract_ui+0xca>
            if (both_tokens_found) {
c0de0e0a:	2b03      	cmp	r3, #3
c0de0e0c:	d05f      	beq.n	c0de0ece <handle_query_contract_ui+0x17a>
c0de0e0e:	2b00      	cmp	r3, #0
c0de0e10:	d175      	bne.n	c0de0efe <handle_query_contract_ui+0x1aa>
c0de0e12:	e0b1      	b.n	c0de0f78 <handle_query_contract_ui+0x224>
c0de0e14:	2b00      	cmp	r3, #0
c0de0e16:	d000      	beq.n	c0de0e1a <handle_query_contract_ui+0xc6>
c0de0e18:	4628      	mov	r0, r5
c0de0e1a:	2b03      	cmp	r3, #3
c0de0e1c:	d04f      	beq.n	c0de0ebe <handle_query_contract_ui+0x16a>
    screens_t screen = get_screen(msg, context);
    switch (screen) {
c0de0e1e:	2803      	cmp	r0, #3
c0de0e20:	d055      	beq.n	c0de0ece <handle_query_contract_ui+0x17a>
c0de0e22:	2801      	cmp	r0, #1
c0de0e24:	d06b      	beq.n	c0de0efe <handle_query_contract_ui+0x1aa>
c0de0e26:	2802      	cmp	r0, #2
c0de0e28:	d100      	bne.n	c0de0e2c <handle_query_contract_ui+0xd8>
c0de0e2a:	e0a5      	b.n	c0de0f78 <handle_query_contract_ui+0x224>
c0de0e2c:	2800      	cmp	r0, #0
c0de0e2e:	d146      	bne.n	c0de0ebe <handle_query_contract_ui+0x16a>
c0de0e30:	9d05      	ldr	r5, [sp, #20]
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0e32:	462e      	mov	r6, r5
c0de0e34:	3640      	adds	r6, #64	; 0x40
c0de0e36:	49fa      	ldr	r1, [pc, #1000]	; (c0de1220 <handle_query_contract_ui+0x4cc>)
c0de0e38:	4479      	add	r1, pc
c0de0e3a:	2214      	movs	r2, #20
c0de0e3c:	4630      	mov	r0, r6
c0de0e3e:	f000 fea9 	bl	c0de1b94 <memcmp>
c0de0e42:	2800      	cmp	r0, #0
c0de0e44:	d100      	bne.n	c0de0e48 <handle_query_contract_ui+0xf4>
c0de0e46:	e0b3      	b.n	c0de0fb0 <handle_query_contract_ui+0x25c>
c0de0e48:	462f      	mov	r7, r5
    } else if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de0e4a:	49f6      	ldr	r1, [pc, #984]	; (c0de1224 <handle_query_contract_ui+0x4d0>)
c0de0e4c:	4479      	add	r1, pc
c0de0e4e:	2214      	movs	r2, #20
c0de0e50:	4630      	mov	r0, r6
c0de0e52:	f000 fe9f 	bl	c0de1b94 <memcmp>
c0de0e56:	2800      	cmp	r0, #0
c0de0e58:	d100      	bne.n	c0de0e5c <handle_query_contract_ui+0x108>
c0de0e5a:	e0b8      	b.n	c0de0fce <handle_query_contract_ui+0x27a>
    } else if (ADDRESS_IS_OUSD(context->contract_address_sent)) {
c0de0e5c:	49f2      	ldr	r1, [pc, #968]	; (c0de1228 <handle_query_contract_ui+0x4d4>)
c0de0e5e:	4479      	add	r1, pc
c0de0e60:	2214      	movs	r2, #20
c0de0e62:	4630      	mov	r0, r6
c0de0e64:	f000 fe96 	bl	c0de1b94 <memcmp>
c0de0e68:	2800      	cmp	r0, #0
c0de0e6a:	d100      	bne.n	c0de0e6e <handle_query_contract_ui+0x11a>
c0de0e6c:	e0bb      	b.n	c0de0fe6 <handle_query_contract_ui+0x292>
c0de0e6e:	463d      	mov	r5, r7
    } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de0e70:	463e      	mov	r6, r7
c0de0e72:	3654      	adds	r6, #84	; 0x54
c0de0e74:	49ed      	ldr	r1, [pc, #948]	; (c0de122c <handle_query_contract_ui+0x4d8>)
c0de0e76:	4479      	add	r1, pc
c0de0e78:	2214      	movs	r2, #20
c0de0e7a:	4630      	mov	r0, r6
c0de0e7c:	f000 fe8a 	bl	c0de1b94 <memcmp>
c0de0e80:	2800      	cmp	r0, #0
c0de0e82:	d100      	bne.n	c0de0e86 <handle_query_contract_ui+0x132>
c0de0e84:	e145      	b.n	c0de1112 <handle_query_contract_ui+0x3be>
    } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de0e86:	49ea      	ldr	r1, [pc, #936]	; (c0de1230 <handle_query_contract_ui+0x4dc>)
c0de0e88:	4479      	add	r1, pc
c0de0e8a:	2214      	movs	r2, #20
c0de0e8c:	4630      	mov	r0, r6
c0de0e8e:	f000 fe81 	bl	c0de1b94 <memcmp>
c0de0e92:	2800      	cmp	r0, #0
c0de0e94:	d100      	bne.n	c0de0e98 <handle_query_contract_ui+0x144>
c0de0e96:	e141      	b.n	c0de111c <handle_query_contract_ui+0x3c8>
    } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de0e98:	49fc      	ldr	r1, [pc, #1008]	; (c0de128c <handle_query_contract_ui+0x538>)
c0de0e9a:	4479      	add	r1, pc
c0de0e9c:	2214      	movs	r2, #20
c0de0e9e:	4630      	mov	r0, r6
c0de0ea0:	f000 fe78 	bl	c0de1b94 <memcmp>
c0de0ea4:	2800      	cmp	r0, #0
c0de0ea6:	463e      	mov	r6, r7
c0de0ea8:	9d04      	ldr	r5, [sp, #16]
c0de0eaa:	d000      	beq.n	c0de0eae <handle_query_contract_ui+0x15a>
c0de0eac:	e13f      	b.n	c0de112e <handle_query_contract_ui+0x3da>
        strlcpy(context->ticker_sent, USDT_TICKER, sizeof(context->ticker_sent));
c0de0eae:	4630      	mov	r0, r6
c0de0eb0:	307c      	adds	r0, #124	; 0x7c
c0de0eb2:	49f8      	ldr	r1, [pc, #992]	; (c0de1294 <handle_query_contract_ui+0x540>)
c0de0eb4:	4479      	add	r1, pc
c0de0eb6:	220b      	movs	r2, #11
c0de0eb8:	f000 ffe8 	bl	c0de1e8c <strlcpy>
c0de0ebc:	e137      	b.n	c0de112e <handle_query_contract_ui+0x3da>
            break;
        case BENEFICIARY_SCREEN:
            set_beneficiary_ui(msg, context);
            break;
        default:
            PRINTF("Received an invalid screenIndex\n");
c0de0ebe:	48f6      	ldr	r0, [pc, #984]	; (c0de1298 <handle_query_contract_ui+0x544>)
c0de0ec0:	4478      	add	r0, pc
c0de0ec2:	f000 fab1 	bl	c0de1428 <mcu_usb_printf>
c0de0ec6:	2000      	movs	r0, #0
c0de0ec8:	9906      	ldr	r1, [sp, #24]
c0de0eca:	7508      	strb	r0, [r1, #20]
c0de0ecc:	e1dc      	b.n	c0de1288 <handle_query_contract_ui+0x534>
    strlcpy(msg->title, "Beneficiary", msg->titleLength);
c0de0ece:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0ed0:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0ed2:	49ef      	ldr	r1, [pc, #956]	; (c0de1290 <handle_query_contract_ui+0x53c>)
c0de0ed4:	4479      	add	r1, pc
c0de0ed6:	f000 ffd9 	bl	c0de1e8c <strlcpy>
    msg->msg[0] = '0';
c0de0eda:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0edc:	2130      	movs	r1, #48	; 0x30
c0de0ede:	7001      	strb	r1, [r0, #0]
    msg->msg[1] = 'x';
c0de0ee0:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0ee2:	2178      	movs	r1, #120	; 0x78
c0de0ee4:	7041      	strb	r1, [r0, #1]
                                  msg->pluginSharedRW->sha3,
c0de0ee6:	6820      	ldr	r0, [r4, #0]
c0de0ee8:	6802      	ldr	r2, [r0, #0]
                                  msg->msg + 2,
c0de0eea:	6ae3      	ldr	r3, [r4, #44]	; 0x2c
c0de0eec:	2100      	movs	r1, #0
    getEthAddressStringFromBinary((uint8_t *) context->beneficiary,
c0de0eee:	9100      	str	r1, [sp, #0]
c0de0ef0:	9101      	str	r1, [sp, #4]
c0de0ef2:	9805      	ldr	r0, [sp, #20]
c0de0ef4:	3068      	adds	r0, #104	; 0x68
                                  msg->msg + 2,
c0de0ef6:	1c99      	adds	r1, r3, #2
    getEthAddressStringFromBinary((uint8_t *) context->beneficiary,
c0de0ef8:	f7ff f8ee 	bl	c0de00d8 <getEthAddressStringFromBinary>
c0de0efc:	e1c4      	b.n	c0de1288 <handle_query_contract_ui+0x534>
c0de0efe:	9d05      	ldr	r5, [sp, #20]
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0f00:	462e      	mov	r6, r5
c0de0f02:	3654      	adds	r6, #84	; 0x54
c0de0f04:	49f9      	ldr	r1, [pc, #996]	; (c0de12ec <handle_query_contract_ui+0x598>)
c0de0f06:	4479      	add	r1, pc
c0de0f08:	2214      	movs	r2, #20
c0de0f0a:	4630      	mov	r0, r6
c0de0f0c:	f000 fe42 	bl	c0de1b94 <memcmp>
c0de0f10:	2800      	cmp	r0, #0
c0de0f12:	d03e      	beq.n	c0de0f92 <handle_query_contract_ui+0x23e>
    } else if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de0f14:	49f6      	ldr	r1, [pc, #984]	; (c0de12f0 <handle_query_contract_ui+0x59c>)
c0de0f16:	4479      	add	r1, pc
c0de0f18:	2214      	movs	r2, #20
c0de0f1a:	4630      	mov	r0, r6
c0de0f1c:	f000 fe3a 	bl	c0de1b94 <memcmp>
c0de0f20:	2800      	cmp	r0, #0
c0de0f22:	d03f      	beq.n	c0de0fa4 <handle_query_contract_ui+0x250>
    } else if (ADDRESS_IS_OUSD(context->contract_address_received)) {
c0de0f24:	49f4      	ldr	r1, [pc, #976]	; (c0de12f8 <handle_query_contract_ui+0x5a4>)
c0de0f26:	4479      	add	r1, pc
c0de0f28:	2214      	movs	r2, #20
c0de0f2a:	4630      	mov	r0, r6
c0de0f2c:	f000 fe32 	bl	c0de1b94 <memcmp>
c0de0f30:	2800      	cmp	r0, #0
c0de0f32:	d046      	beq.n	c0de0fc2 <handle_query_contract_ui+0x26e>
    } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de0f34:	49f2      	ldr	r1, [pc, #968]	; (c0de1300 <handle_query_contract_ui+0x5ac>)
c0de0f36:	4479      	add	r1, pc
c0de0f38:	2214      	movs	r2, #20
c0de0f3a:	4630      	mov	r0, r6
c0de0f3c:	f000 fe2a 	bl	c0de1b94 <memcmp>
c0de0f40:	2800      	cmp	r0, #0
c0de0f42:	d04a      	beq.n	c0de0fda <handle_query_contract_ui+0x286>
    } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de0f44:	49f0      	ldr	r1, [pc, #960]	; (c0de1308 <handle_query_contract_ui+0x5b4>)
c0de0f46:	4479      	add	r1, pc
c0de0f48:	2214      	movs	r2, #20
c0de0f4a:	4630      	mov	r0, r6
c0de0f4c:	f000 fe22 	bl	c0de1b94 <memcmp>
c0de0f50:	2800      	cmp	r0, #0
c0de0f52:	d04e      	beq.n	c0de0ff2 <handle_query_contract_ui+0x29e>
    } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de0f54:	49ee      	ldr	r1, [pc, #952]	; (c0de1310 <handle_query_contract_ui+0x5bc>)
c0de0f56:	4479      	add	r1, pc
c0de0f58:	2214      	movs	r2, #20
c0de0f5a:	4630      	mov	r0, r6
c0de0f5c:	f000 fe1a 	bl	c0de1b94 <memcmp>
c0de0f60:	2800      	cmp	r0, #0
c0de0f62:	462e      	mov	r6, r5
c0de0f64:	9d04      	ldr	r5, [sp, #16]
c0de0f66:	d14d      	bne.n	c0de1004 <handle_query_contract_ui+0x2b0>
        strlcpy(context->ticker_received, USDT_TICKER, sizeof(context->ticker_received));
c0de0f68:	4630      	mov	r0, r6
c0de0f6a:	3087      	adds	r0, #135	; 0x87
c0de0f6c:	49e9      	ldr	r1, [pc, #932]	; (c0de1314 <handle_query_contract_ui+0x5c0>)
c0de0f6e:	4479      	add	r1, pc
c0de0f70:	220b      	movs	r2, #11
c0de0f72:	f000 ff8b 	bl	c0de1e8c <strlcpy>
c0de0f76:	e045      	b.n	c0de1004 <handle_query_contract_ui+0x2b0>
    strlcpy(msg->title, "WARNING", msg->titleLength);
c0de0f78:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de0f7a:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0f7c:	49c7      	ldr	r1, [pc, #796]	; (c0de129c <handle_query_contract_ui+0x548>)
c0de0f7e:	4479      	add	r1, pc
c0de0f80:	f000 ff84 	bl	c0de1e8c <strlcpy>
    strlcpy(msg->msg, "Unknown token", msg->msgLength);
c0de0f84:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de0f86:	6b22      	ldr	r2, [r4, #48]	; 0x30
c0de0f88:	49c5      	ldr	r1, [pc, #788]	; (c0de12a0 <handle_query_contract_ui+0x54c>)
c0de0f8a:	4479      	add	r1, pc
c0de0f8c:	f000 ff7e 	bl	c0de1e8c <strlcpy>
c0de0f90:	e17a      	b.n	c0de1288 <handle_query_contract_ui+0x534>
        strlcpy(context->ticker_received, msg->network_ticker, sizeof(context->ticker_received));
c0de0f92:	4628      	mov	r0, r5
c0de0f94:	3087      	adds	r0, #135	; 0x87
c0de0f96:	4621      	mov	r1, r4
c0de0f98:	3110      	adds	r1, #16
c0de0f9a:	220b      	movs	r2, #11
c0de0f9c:	f000 ff76 	bl	c0de1e8c <strlcpy>
c0de0fa0:	462e      	mov	r6, r5
c0de0fa2:	e02e      	b.n	c0de1002 <handle_query_contract_ui+0x2ae>
c0de0fa4:	462e      	mov	r6, r5
        strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de0fa6:	4628      	mov	r0, r5
c0de0fa8:	3087      	adds	r0, #135	; 0x87
c0de0faa:	49d2      	ldr	r1, [pc, #840]	; (c0de12f4 <handle_query_contract_ui+0x5a0>)
c0de0fac:	4479      	add	r1, pc
c0de0fae:	e025      	b.n	c0de0ffc <handle_query_contract_ui+0x2a8>
        strlcpy(context->ticker_sent, msg->network_ticker, sizeof(context->ticker_sent));
c0de0fb0:	4628      	mov	r0, r5
c0de0fb2:	307c      	adds	r0, #124	; 0x7c
c0de0fb4:	4621      	mov	r1, r4
c0de0fb6:	3110      	adds	r1, #16
c0de0fb8:	220b      	movs	r2, #11
c0de0fba:	f000 ff67 	bl	c0de1e8c <strlcpy>
c0de0fbe:	462e      	mov	r6, r5
c0de0fc0:	e0b4      	b.n	c0de112c <handle_query_contract_ui+0x3d8>
c0de0fc2:	462e      	mov	r6, r5
        strlcpy(context->ticker_received, OUSD_TICKER, sizeof(context->ticker_received));
c0de0fc4:	4628      	mov	r0, r5
c0de0fc6:	3087      	adds	r0, #135	; 0x87
c0de0fc8:	49cc      	ldr	r1, [pc, #816]	; (c0de12fc <handle_query_contract_ui+0x5a8>)
c0de0fca:	4479      	add	r1, pc
c0de0fcc:	e016      	b.n	c0de0ffc <handle_query_contract_ui+0x2a8>
c0de0fce:	463e      	mov	r6, r7
        strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de0fd0:	4638      	mov	r0, r7
c0de0fd2:	307c      	adds	r0, #124	; 0x7c
c0de0fd4:	49b3      	ldr	r1, [pc, #716]	; (c0de12a4 <handle_query_contract_ui+0x550>)
c0de0fd6:	4479      	add	r1, pc
c0de0fd8:	e0a5      	b.n	c0de1126 <handle_query_contract_ui+0x3d2>
c0de0fda:	462e      	mov	r6, r5
        strlcpy(context->ticker_received, DAI_TICKER, sizeof(context->ticker_received));
c0de0fdc:	4628      	mov	r0, r5
c0de0fde:	3087      	adds	r0, #135	; 0x87
c0de0fe0:	49c8      	ldr	r1, [pc, #800]	; (c0de1304 <handle_query_contract_ui+0x5b0>)
c0de0fe2:	4479      	add	r1, pc
c0de0fe4:	e00a      	b.n	c0de0ffc <handle_query_contract_ui+0x2a8>
c0de0fe6:	463e      	mov	r6, r7
        strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de0fe8:	4638      	mov	r0, r7
c0de0fea:	307c      	adds	r0, #124	; 0x7c
c0de0fec:	49ae      	ldr	r1, [pc, #696]	; (c0de12a8 <handle_query_contract_ui+0x554>)
c0de0fee:	4479      	add	r1, pc
c0de0ff0:	e099      	b.n	c0de1126 <handle_query_contract_ui+0x3d2>
c0de0ff2:	462e      	mov	r6, r5
        strlcpy(context->ticker_received, USDC_TICKER, sizeof(context->ticker_received));
c0de0ff4:	4628      	mov	r0, r5
c0de0ff6:	3087      	adds	r0, #135	; 0x87
c0de0ff8:	49c4      	ldr	r1, [pc, #784]	; (c0de130c <handle_query_contract_ui+0x5b8>)
c0de0ffa:	4479      	add	r1, pc
c0de0ffc:	220b      	movs	r2, #11
c0de0ffe:	f000 ff45 	bl	c0de1e8c <strlcpy>
c0de1002:	9d04      	ldr	r5, [sp, #16]
    context->amount_length = INT256_LENGTH;
c0de1004:	9803      	ldr	r0, [sp, #12]
c0de1006:	7168      	strb	r0, [r5, #5]
    strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de1008:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de100a:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de100c:	49c2      	ldr	r1, [pc, #776]	; (c0de1318 <handle_query_contract_ui+0x5c4>)
c0de100e:	4479      	add	r1, pc
c0de1010:	f000 ff3c 	bl	c0de1e8c <strlcpy>
    switch (context->selectorIndex) {
c0de1014:	7aa9      	ldrb	r1, [r5, #10]
c0de1016:	1f08      	subs	r0, r1, #4
c0de1018:	2805      	cmp	r0, #5
c0de101a:	d200      	bcs.n	c0de101e <handle_query_contract_ui+0x2ca>
c0de101c:	e10f      	b.n	c0de123e <handle_query_contract_ui+0x4ea>
c0de101e:	1e48      	subs	r0, r1, #1
c0de1020:	2802      	cmp	r0, #2
c0de1022:	d32c      	bcc.n	c0de107e <handle_query_contract_ui+0x32a>
c0de1024:	290e      	cmp	r1, #14
c0de1026:	d03d      	beq.n	c0de10a4 <handle_query_contract_ui+0x350>
c0de1028:	2903      	cmp	r1, #3
c0de102a:	d046      	beq.n	c0de10ba <handle_query_contract_ui+0x366>
c0de102c:	2909      	cmp	r1, #9
c0de102e:	d01b      	beq.n	c0de1068 <handle_query_contract_ui+0x314>
c0de1030:	290a      	cmp	r1, #10
c0de1032:	d053      	beq.n	c0de10dc <handle_query_contract_ui+0x388>
c0de1034:	290b      	cmp	r1, #11
c0de1036:	d017      	beq.n	c0de1068 <handle_query_contract_ui+0x314>
c0de1038:	290c      	cmp	r1, #12
c0de103a:	d05a      	beq.n	c0de10f2 <handle_query_contract_ui+0x39e>
c0de103c:	290d      	cmp	r1, #13
c0de103e:	d013      	beq.n	c0de1068 <handle_query_contract_ui+0x314>
c0de1040:	2900      	cmp	r1, #0
c0de1042:	d000      	beq.n	c0de1046 <handle_query_contract_ui+0x2f2>
c0de1044:	e0ad      	b.n	c0de11a2 <handle_query_contract_ui+0x44e>
            memcpy(context->min_amount_received, &msg->pluginSharedRO->txContent->value.value, msg->pluginSharedRO->txContent->value.length);
c0de1046:	6860      	ldr	r0, [r4, #4]
c0de1048:	6801      	ldr	r1, [r0, #0]
c0de104a:	2562      	movs	r5, #98	; 0x62
c0de104c:	5d4a      	ldrb	r2, [r1, r5]
c0de104e:	4630      	mov	r0, r6
c0de1050:	3020      	adds	r0, #32
c0de1052:	3142      	adds	r1, #66	; 0x42
c0de1054:	f000 fd8e 	bl	c0de1b74 <__aeabi_memcpy>
            context->amount_length = msg->pluginSharedRO->txContent->value.length;
c0de1058:	6860      	ldr	r0, [r4, #4]
c0de105a:	6800      	ldr	r0, [r0, #0]
c0de105c:	5d40      	ldrb	r0, [r0, r5]
c0de105e:	9d04      	ldr	r5, [sp, #16]
c0de1060:	7168      	strb	r0, [r5, #5]
            strlcpy(context->ticker_received, OETH_TICKER, sizeof(context->ticker_received));
c0de1062:	4630      	mov	r0, r6
c0de1064:	3087      	adds	r0, #135	; 0x87
c0de1066:	e01a      	b.n	c0de109e <handle_query_contract_ui+0x34a>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de1068:	4630      	mov	r0, r6
c0de106a:	3020      	adds	r0, #32
c0de106c:	2220      	movs	r2, #32
c0de106e:	4631      	mov	r1, r6
c0de1070:	f000 fd80 	bl	c0de1b74 <__aeabi_memcpy>
            strlcpy(context->ticker_received, OUSD_TICKER, sizeof(context->ticker_received));
c0de1074:	4630      	mov	r0, r6
c0de1076:	3087      	adds	r0, #135	; 0x87
c0de1078:	49af      	ldr	r1, [pc, #700]	; (c0de1338 <handle_query_contract_ui+0x5e4>)
c0de107a:	4479      	add	r1, pc
c0de107c:	e043      	b.n	c0de1106 <handle_query_contract_ui+0x3b2>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de107e:	6860      	ldr	r0, [r4, #4]
c0de1080:	6801      	ldr	r1, [r0, #0]
c0de1082:	31a5      	adds	r1, #165	; 0xa5
c0de1084:	48a5      	ldr	r0, [pc, #660]	; (c0de131c <handle_query_contract_ui+0x5c8>)
c0de1086:	4478      	add	r0, pc
c0de1088:	2214      	movs	r2, #20
c0de108a:	f000 fd83 	bl	c0de1b94 <memcmp>
c0de108e:	4601      	mov	r1, r0
c0de1090:	4630      	mov	r0, r6
c0de1092:	3087      	adds	r0, #135	; 0x87
c0de1094:	2900      	cmp	r1, #0
c0de1096:	d002      	beq.n	c0de109e <handle_query_contract_ui+0x34a>
                strlcpy(context->ticker_received, OUSD_TICKER, sizeof(context->ticker_received));
c0de1098:	49a3      	ldr	r1, [pc, #652]	; (c0de1328 <handle_query_contract_ui+0x5d4>)
c0de109a:	4479      	add	r1, pc
c0de109c:	e0cc      	b.n	c0de1238 <handle_query_contract_ui+0x4e4>
c0de109e:	49a0      	ldr	r1, [pc, #640]	; (c0de1320 <handle_query_contract_ui+0x5cc>)
c0de10a0:	4479      	add	r1, pc
c0de10a2:	e0c9      	b.n	c0de1238 <handle_query_contract_ui+0x4e4>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de10a4:	4630      	mov	r0, r6
c0de10a6:	3020      	adds	r0, #32
c0de10a8:	2220      	movs	r2, #32
c0de10aa:	4631      	mov	r1, r6
c0de10ac:	f000 fd62 	bl	c0de1b74 <__aeabi_memcpy>
            strlcpy(context->ticker_received, USDC_TICKER, sizeof(context->ticker_received));
c0de10b0:	4630      	mov	r0, r6
c0de10b2:	3087      	adds	r0, #135	; 0x87
c0de10b4:	49a3      	ldr	r1, [pc, #652]	; (c0de1344 <handle_query_contract_ui+0x5f0>)
c0de10b6:	4479      	add	r1, pc
c0de10b8:	e025      	b.n	c0de1106 <handle_query_contract_ui+0x3b2>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de10ba:	6860      	ldr	r0, [r4, #4]
c0de10bc:	6801      	ldr	r1, [r0, #0]
c0de10be:	31a5      	adds	r1, #165	; 0xa5
c0de10c0:	489a      	ldr	r0, [pc, #616]	; (c0de132c <handle_query_contract_ui+0x5d8>)
c0de10c2:	4478      	add	r0, pc
c0de10c4:	2214      	movs	r2, #20
c0de10c6:	f000 fd65 	bl	c0de1b94 <memcmp>
c0de10ca:	4601      	mov	r1, r0
c0de10cc:	4630      	mov	r0, r6
c0de10ce:	3087      	adds	r0, #135	; 0x87
c0de10d0:	2900      	cmp	r1, #0
c0de10d2:	d100      	bne.n	c0de10d6 <handle_query_contract_ui+0x382>
c0de10d4:	e0ae      	b.n	c0de1234 <handle_query_contract_ui+0x4e0>
                strlcpy(context->ticker_received, "USD MIX", sizeof(context->ticker_received));
c0de10d6:	4997      	ldr	r1, [pc, #604]	; (c0de1334 <handle_query_contract_ui+0x5e0>)
c0de10d8:	4479      	add	r1, pc
c0de10da:	e0ad      	b.n	c0de1238 <handle_query_contract_ui+0x4e4>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de10dc:	4630      	mov	r0, r6
c0de10de:	3020      	adds	r0, #32
c0de10e0:	2220      	movs	r2, #32
c0de10e2:	4631      	mov	r1, r6
c0de10e4:	f000 fd46 	bl	c0de1b74 <__aeabi_memcpy>
            strlcpy(context->ticker_received, USDT_TICKER, sizeof(context->ticker_received));
c0de10e8:	4630      	mov	r0, r6
c0de10ea:	3087      	adds	r0, #135	; 0x87
c0de10ec:	4993      	ldr	r1, [pc, #588]	; (c0de133c <handle_query_contract_ui+0x5e8>)
c0de10ee:	4479      	add	r1, pc
c0de10f0:	e009      	b.n	c0de1106 <handle_query_contract_ui+0x3b2>
            memcpy(context->min_amount_received, context->amount_sent, sizeof(context->amount_sent));
c0de10f2:	4630      	mov	r0, r6
c0de10f4:	3020      	adds	r0, #32
c0de10f6:	2220      	movs	r2, #32
c0de10f8:	4631      	mov	r1, r6
c0de10fa:	f000 fd3b 	bl	c0de1b74 <__aeabi_memcpy>
            strlcpy(context->ticker_received, DAI_TICKER, sizeof(context->ticker_received));
c0de10fe:	4630      	mov	r0, r6
c0de1100:	3087      	adds	r0, #135	; 0x87
c0de1102:	498f      	ldr	r1, [pc, #572]	; (c0de1340 <handle_query_contract_ui+0x5ec>)
c0de1104:	4479      	add	r1, pc
c0de1106:	220b      	movs	r2, #11
c0de1108:	f000 fec0 	bl	c0de1e8c <strlcpy>
c0de110c:	2012      	movs	r0, #18
c0de110e:	70a8      	strb	r0, [r5, #2]
c0de1110:	e095      	b.n	c0de123e <handle_query_contract_ui+0x4ea>
        strlcpy(context->ticker_sent, DAI_TICKER, sizeof(context->ticker_sent));
c0de1112:	4628      	mov	r0, r5
c0de1114:	307c      	adds	r0, #124	; 0x7c
c0de1116:	4965      	ldr	r1, [pc, #404]	; (c0de12ac <handle_query_contract_ui+0x558>)
c0de1118:	4479      	add	r1, pc
c0de111a:	e74d      	b.n	c0de0fb8 <handle_query_contract_ui+0x264>
c0de111c:	463e      	mov	r6, r7
        strlcpy(context->ticker_sent, USDC_TICKER, sizeof(context->ticker_sent));
c0de111e:	4638      	mov	r0, r7
c0de1120:	307c      	adds	r0, #124	; 0x7c
c0de1122:	4963      	ldr	r1, [pc, #396]	; (c0de12b0 <handle_query_contract_ui+0x55c>)
c0de1124:	4479      	add	r1, pc
c0de1126:	220b      	movs	r2, #11
c0de1128:	f000 feb0 	bl	c0de1e8c <strlcpy>
c0de112c:	9d04      	ldr	r5, [sp, #16]
    context->amount_length = INT256_LENGTH;
c0de112e:	9803      	ldr	r0, [sp, #12]
c0de1130:	7168      	strb	r0, [r5, #5]
    strlcpy(msg->title, "Send", msg->titleLength);
c0de1132:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1134:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de1136:	495f      	ldr	r1, [pc, #380]	; (c0de12b4 <handle_query_contract_ui+0x560>)
c0de1138:	4479      	add	r1, pc
c0de113a:	f000 fea7 	bl	c0de1e8c <strlcpy>
    switch (context->selectorIndex) {
c0de113e:	7aa9      	ldrb	r1, [r5, #10]
c0de1140:	1f08      	subs	r0, r1, #4
c0de1142:	2805      	cmp	r0, #5
c0de1144:	d200      	bcs.n	c0de1148 <handle_query_contract_ui+0x3f4>
c0de1146:	e08f      	b.n	c0de1268 <handle_query_contract_ui+0x514>
c0de1148:	290e      	cmp	r1, #14
c0de114a:	d025      	beq.n	c0de1198 <handle_query_contract_ui+0x444>
c0de114c:	2901      	cmp	r1, #1
c0de114e:	d02d      	beq.n	c0de11ac <handle_query_contract_ui+0x458>
c0de1150:	2902      	cmp	r1, #2
c0de1152:	d036      	beq.n	c0de11c2 <handle_query_contract_ui+0x46e>
c0de1154:	2903      	cmp	r1, #3
c0de1156:	d039      	beq.n	c0de11cc <handle_query_contract_ui+0x478>
c0de1158:	2909      	cmp	r1, #9
c0de115a:	d04d      	beq.n	c0de11f8 <handle_query_contract_ui+0x4a4>
c0de115c:	290a      	cmp	r1, #10
c0de115e:	d01b      	beq.n	c0de1198 <handle_query_contract_ui+0x444>
c0de1160:	290b      	cmp	r1, #11
c0de1162:	d04e      	beq.n	c0de1202 <handle_query_contract_ui+0x4ae>
c0de1164:	290c      	cmp	r1, #12
c0de1166:	d017      	beq.n	c0de1198 <handle_query_contract_ui+0x444>
c0de1168:	290d      	cmp	r1, #13
c0de116a:	d04f      	beq.n	c0de120c <handle_query_contract_ui+0x4b8>
c0de116c:	2900      	cmp	r1, #0
c0de116e:	d118      	bne.n	c0de11a2 <handle_query_contract_ui+0x44e>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de1170:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1172:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de1174:	4950      	ldr	r1, [pc, #320]	; (c0de12b8 <handle_query_contract_ui+0x564>)
c0de1176:	4479      	add	r1, pc
c0de1178:	f000 fe88 	bl	c0de1e8c <strlcpy>
            memcpy(context->amount_sent, &msg->pluginSharedRO->txContent->value.value, msg->pluginSharedRO->txContent->value.length);
c0de117c:	6860      	ldr	r0, [r4, #4]
c0de117e:	6801      	ldr	r1, [r0, #0]
c0de1180:	2562      	movs	r5, #98	; 0x62
c0de1182:	5d4a      	ldrb	r2, [r1, r5]
c0de1184:	3142      	adds	r1, #66	; 0x42
c0de1186:	4630      	mov	r0, r6
c0de1188:	f000 fcf4 	bl	c0de1b74 <__aeabi_memcpy>
            context->amount_length = msg->pluginSharedRO->txContent->value.length;
c0de118c:	6860      	ldr	r0, [r4, #4]
c0de118e:	6800      	ldr	r0, [r0, #0]
c0de1190:	5d40      	ldrb	r0, [r0, r5]
c0de1192:	9d04      	ldr	r5, [sp, #16]
c0de1194:	7168      	strb	r0, [r5, #5]
c0de1196:	e067      	b.n	c0de1268 <handle_query_contract_ui+0x514>
            strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de1198:	4630      	mov	r0, r6
c0de119a:	307c      	adds	r0, #124	; 0x7c
c0de119c:	4950      	ldr	r1, [pc, #320]	; (c0de12e0 <handle_query_contract_ui+0x58c>)
c0de119e:	4479      	add	r1, pc
c0de11a0:	e038      	b.n	c0de1214 <handle_query_contract_ui+0x4c0>
c0de11a2:	4869      	ldr	r0, [pc, #420]	; (c0de1348 <handle_query_contract_ui+0x5f4>)
c0de11a4:	4478      	add	r0, pc
c0de11a6:	f000 f93f 	bl	c0de1428 <mcu_usb_printf>
c0de11aa:	e68c      	b.n	c0de0ec6 <handle_query_contract_ui+0x172>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de11ac:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de11ae:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de11b0:	4942      	ldr	r1, [pc, #264]	; (c0de12bc <handle_query_contract_ui+0x568>)
c0de11b2:	4479      	add	r1, pc
c0de11b4:	f000 fe6a 	bl	c0de1e8c <strlcpy>
            strlcpy(context->ticker_sent, SFRXETH_TICKER, sizeof(context->ticker_sent));
c0de11b8:	4630      	mov	r0, r6
c0de11ba:	307c      	adds	r0, #124	; 0x7c
c0de11bc:	4940      	ldr	r1, [pc, #256]	; (c0de12c0 <handle_query_contract_ui+0x56c>)
c0de11be:	4479      	add	r1, pc
c0de11c0:	e04f      	b.n	c0de1262 <handle_query_contract_ui+0x50e>
            strlcpy(msg->title, "Deposit", msg->titleLength);
c0de11c2:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de11c4:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de11c6:	4947      	ldr	r1, [pc, #284]	; (c0de12e4 <handle_query_contract_ui+0x590>)
c0de11c8:	4479      	add	r1, pc
c0de11ca:	e04b      	b.n	c0de1264 <handle_query_contract_ui+0x510>
            strlcpy(msg->title, "Redeem", msg->titleLength);
c0de11cc:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de11ce:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de11d0:	493c      	ldr	r1, [pc, #240]	; (c0de12c4 <handle_query_contract_ui+0x570>)
c0de11d2:	4479      	add	r1, pc
c0de11d4:	f000 fe5a 	bl	c0de1e8c <strlcpy>
            if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
c0de11d8:	6860      	ldr	r0, [r4, #4]
c0de11da:	6801      	ldr	r1, [r0, #0]
c0de11dc:	31a5      	adds	r1, #165	; 0xa5
c0de11de:	483a      	ldr	r0, [pc, #232]	; (c0de12c8 <handle_query_contract_ui+0x574>)
c0de11e0:	4478      	add	r0, pc
c0de11e2:	2214      	movs	r2, #20
c0de11e4:	f000 fcd6 	bl	c0de1b94 <memcmp>
c0de11e8:	4601      	mov	r1, r0
c0de11ea:	4630      	mov	r0, r6
c0de11ec:	307c      	adds	r0, #124	; 0x7c
c0de11ee:	2900      	cmp	r1, #0
c0de11f0:	d035      	beq.n	c0de125e <handle_query_contract_ui+0x50a>
                strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de11f2:	4937      	ldr	r1, [pc, #220]	; (c0de12d0 <handle_query_contract_ui+0x57c>)
c0de11f4:	4479      	add	r1, pc
c0de11f6:	e034      	b.n	c0de1262 <handle_query_contract_ui+0x50e>
            strlcpy(context->ticker_sent, USDT_TICKER, sizeof(context->ticker_sent));
c0de11f8:	4630      	mov	r0, r6
c0de11fa:	307c      	adds	r0, #124	; 0x7c
c0de11fc:	4935      	ldr	r1, [pc, #212]	; (c0de12d4 <handle_query_contract_ui+0x580>)
c0de11fe:	4479      	add	r1, pc
c0de1200:	e008      	b.n	c0de1214 <handle_query_contract_ui+0x4c0>
            strlcpy(context->ticker_sent, DAI_TICKER, sizeof(context->ticker_sent));
c0de1202:	4630      	mov	r0, r6
c0de1204:	307c      	adds	r0, #124	; 0x7c
c0de1206:	4934      	ldr	r1, [pc, #208]	; (c0de12d8 <handle_query_contract_ui+0x584>)
c0de1208:	4479      	add	r1, pc
c0de120a:	e003      	b.n	c0de1214 <handle_query_contract_ui+0x4c0>
            strlcpy(context->ticker_sent, USDC_TICKER, sizeof(context->ticker_sent));
c0de120c:	4630      	mov	r0, r6
c0de120e:	307c      	adds	r0, #124	; 0x7c
c0de1210:	4932      	ldr	r1, [pc, #200]	; (c0de12dc <handle_query_contract_ui+0x588>)
c0de1212:	4479      	add	r1, pc
c0de1214:	220b      	movs	r2, #11
c0de1216:	f000 fe39 	bl	c0de1e8c <strlcpy>
c0de121a:	2012      	movs	r0, #18
c0de121c:	7068      	strb	r0, [r5, #1]
c0de121e:	e023      	b.n	c0de1268 <handle_query_contract_ui+0x514>
c0de1220:	0000152c 	.word	0x0000152c
c0de1224:	00001458 	.word	0x00001458
c0de1228:	0000145a 	.word	0x0000145a
c0de122c:	00001456 	.word	0x00001456
c0de1230:	00001458 	.word	0x00001458
                strlcpy(context->ticker_received, "LST MIX", sizeof(context->ticker_received));
c0de1234:	493e      	ldr	r1, [pc, #248]	; (c0de1330 <handle_query_contract_ui+0x5dc>)
c0de1236:	4479      	add	r1, pc
c0de1238:	220b      	movs	r2, #11
c0de123a:	f000 fe27 	bl	c0de1e8c <strlcpy>
                   context->decimals_received,
c0de123e:	78aa      	ldrb	r2, [r5, #2]
                   context->amount_length,
c0de1240:	7969      	ldrb	r1, [r5, #5]
                   msg->msg,
c0de1242:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de1244:	6b23      	ldr	r3, [r4, #48]	; 0x30
    amountToString(context->min_amount_received,
c0de1246:	9000      	str	r0, [sp, #0]
c0de1248:	9301      	str	r3, [sp, #4]
c0de124a:	4630      	mov	r0, r6
c0de124c:	3020      	adds	r0, #32
                   context->ticker_received,
c0de124e:	3687      	adds	r6, #135	; 0x87
    amountToString(context->min_amount_received,
c0de1250:	4633      	mov	r3, r6
c0de1252:	f7ff f8ec 	bl	c0de042e <amountToString>
    PRINTF("AMOUNT RECEIVED: %s\n", msg->msg);
c0de1256:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de1258:	4832      	ldr	r0, [pc, #200]	; (c0de1324 <handle_query_contract_ui+0x5d0>)
c0de125a:	4478      	add	r0, pc
c0de125c:	e012      	b.n	c0de1284 <handle_query_contract_ui+0x530>
                strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de125e:	491b      	ldr	r1, [pc, #108]	; (c0de12cc <handle_query_contract_ui+0x578>)
c0de1260:	4479      	add	r1, pc
c0de1262:	220b      	movs	r2, #11
c0de1264:	f000 fe12 	bl	c0de1e8c <strlcpy>
                   context->decimals_sent,
c0de1268:	786a      	ldrb	r2, [r5, #1]
                   context->amount_length,
c0de126a:	7969      	ldrb	r1, [r5, #5]
                   msg->msg,
c0de126c:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de126e:	6b23      	ldr	r3, [r4, #48]	; 0x30
    amountToString(context->amount_sent,
c0de1270:	9000      	str	r0, [sp, #0]
c0de1272:	9301      	str	r3, [sp, #4]
                   context->ticker_sent,
c0de1274:	4633      	mov	r3, r6
c0de1276:	337c      	adds	r3, #124	; 0x7c
    amountToString(context->amount_sent,
c0de1278:	4630      	mov	r0, r6
c0de127a:	f7ff f8d8 	bl	c0de042e <amountToString>
    PRINTF("AMOUNT SENT: %s\n", msg->msg);
c0de127e:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de1280:	4819      	ldr	r0, [pc, #100]	; (c0de12e8 <handle_query_contract_ui+0x594>)
c0de1282:	4478      	add	r0, pc
c0de1284:	f000 f8d0 	bl	c0de1428 <mcu_usb_printf>
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }
}
c0de1288:	b007      	add	sp, #28
c0de128a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de128c:	0000145a 	.word	0x0000145a
c0de1290:	000012a9 	.word	0x000012a9
c0de1294:	0000132c 	.word	0x0000132c
c0de1298:	000012cb 	.word	0x000012cb
c0de129c:	0000102c 	.word	0x0000102c
c0de12a0:	00001181 	.word	0x00001181
c0de12a4:	00001277 	.word	0x00001277
c0de12a8:	00001057 	.word	0x00001057
c0de12ac:	00000e50 	.word	0x00000e50
c0de12b0:	00000f4d 	.word	0x00000f4d
c0de12b4:	00000e6d 	.word	0x00000e6d
c0de12b8:	00001093 	.word	0x00001093
c0de12bc:	00001057 	.word	0x00001057
c0de12c0:	00000f45 	.word	0x00000f45
c0de12c4:	00000e84 	.word	0x00000e84
c0de12c8:	00001128 	.word	0x00001128
c0de12cc:	00000fed 	.word	0x00000fed
c0de12d0:	00000e51 	.word	0x00000e51
c0de12d4:	00000fe2 	.word	0x00000fe2
c0de12d8:	00000d60 	.word	0x00000d60
c0de12dc:	00000e5f 	.word	0x00000e5f
c0de12e0:	00000ea7 	.word	0x00000ea7
c0de12e4:	00001041 	.word	0x00001041
c0de12e8:	00000f2a 	.word	0x00000f2a
c0de12ec:	0000145e 	.word	0x0000145e
c0de12f0:	0000138e 	.word	0x0000138e
c0de12f4:	000012a1 	.word	0x000012a1
c0de12f8:	00001392 	.word	0x00001392
c0de12fc:	0000107b 	.word	0x0000107b
c0de1300:	00001396 	.word	0x00001396
c0de1304:	00000f86 	.word	0x00000f86
c0de1308:	0000139a 	.word	0x0000139a
c0de130c:	00001077 	.word	0x00001077
c0de1310:	0000139e 	.word	0x0000139e
c0de1314:	00001272 	.word	0x00001272
c0de1318:	000010c5 	.word	0x000010c5
c0de131c:	00001282 	.word	0x00001282
c0de1320:	000011ad 	.word	0x000011ad
c0de1324:	00000ff8 	.word	0x00000ff8
c0de1328:	00000fab 	.word	0x00000fab
c0de132c:	00001246 	.word	0x00001246
c0de1330:	00000df6 	.word	0x00000df6
c0de1334:	00000f85 	.word	0x00000f85
c0de1338:	00000fcb 	.word	0x00000fcb
c0de133c:	000010f2 	.word	0x000010f2
c0de1340:	00000e64 	.word	0x00000e64
c0de1344:	00000fbb 	.word	0x00000fbb
c0de1348:	00001041 	.word	0x00001041

c0de134c <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de134c:	b580      	push	{r7, lr}
c0de134e:	4602      	mov	r2, r0
c0de1350:	2083      	movs	r0, #131	; 0x83
c0de1352:	0040      	lsls	r0, r0, #1
    switch (message) {
c0de1354:	4282      	cmp	r2, r0
c0de1356:	d017      	beq.n	c0de1388 <dispatch_plugin_calls+0x3c>
c0de1358:	2081      	movs	r0, #129	; 0x81
c0de135a:	0040      	lsls	r0, r0, #1
c0de135c:	4282      	cmp	r2, r0
c0de135e:	d017      	beq.n	c0de1390 <dispatch_plugin_calls+0x44>
c0de1360:	20ff      	movs	r0, #255	; 0xff
c0de1362:	4603      	mov	r3, r0
c0de1364:	3304      	adds	r3, #4
c0de1366:	429a      	cmp	r2, r3
c0de1368:	d016      	beq.n	c0de1398 <dispatch_plugin_calls+0x4c>
c0de136a:	2341      	movs	r3, #65	; 0x41
c0de136c:	009b      	lsls	r3, r3, #2
c0de136e:	429a      	cmp	r2, r3
c0de1370:	d016      	beq.n	c0de13a0 <dispatch_plugin_calls+0x54>
c0de1372:	4603      	mov	r3, r0
c0de1374:	3306      	adds	r3, #6
c0de1376:	429a      	cmp	r2, r3
c0de1378:	d016      	beq.n	c0de13a8 <dispatch_plugin_calls+0x5c>
c0de137a:	3002      	adds	r0, #2
c0de137c:	4282      	cmp	r2, r0
c0de137e:	d117      	bne.n	c0de13b0 <dispatch_plugin_calls+0x64>
            handle_init_contract(parameters);
c0de1380:	4608      	mov	r0, r1
c0de1382:	f7ff f907 	bl	c0de0594 <handle_init_contract>
}
c0de1386:	bd80      	pop	{r7, pc}
            handle_query_contract_ui(parameters);
c0de1388:	4608      	mov	r0, r1
c0de138a:	f7ff fce3 	bl	c0de0d54 <handle_query_contract_ui>
}
c0de138e:	bd80      	pop	{r7, pc}
            handle_provide_parameter(parameters);
c0de1390:	4608      	mov	r0, r1
c0de1392:	f7ff f975 	bl	c0de0680 <handle_provide_parameter>
}
c0de1396:	bd80      	pop	{r7, pc}
            handle_finalize(parameters);
c0de1398:	4608      	mov	r0, r1
c0de139a:	f7ff f88f 	bl	c0de04bc <handle_finalize>
}
c0de139e:	bd80      	pop	{r7, pc}
            handle_provide_token(parameters);
c0de13a0:	4608      	mov	r0, r1
c0de13a2:	f7ff fbc9 	bl	c0de0b38 <handle_provide_token>
}
c0de13a6:	bd80      	pop	{r7, pc}
            handle_query_contract_id(parameters);
c0de13a8:	4608      	mov	r0, r1
c0de13aa:	f7ff fca3 	bl	c0de0cf4 <handle_query_contract_id>
}
c0de13ae:	bd80      	pop	{r7, pc}
            PRINTF("Unhandled message %d\n", message);
c0de13b0:	4802      	ldr	r0, [pc, #8]	; (c0de13bc <dispatch_plugin_calls+0x70>)
c0de13b2:	4478      	add	r0, pc
c0de13b4:	4611      	mov	r1, r2
c0de13b6:	f000 f837 	bl	c0de1428 <mcu_usb_printf>
}
c0de13ba:	bd80      	pop	{r7, pc}
c0de13bc:	00000d9b 	.word	0x00000d9b

c0de13c0 <call_app_ethereum>:
void call_app_ethereum() {
c0de13c0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    libcall_params[0] = (unsigned int) "Ethereum";
c0de13c2:	4805      	ldr	r0, [pc, #20]	; (c0de13d8 <call_app_ethereum+0x18>)
c0de13c4:	4478      	add	r0, pc
c0de13c6:	9001      	str	r0, [sp, #4]
c0de13c8:	2001      	movs	r0, #1
    libcall_params[2] = RUN_APPLICATION;
c0de13ca:	9003      	str	r0, [sp, #12]
c0de13cc:	0200      	lsls	r0, r0, #8
    libcall_params[1] = 0x100;
c0de13ce:	9002      	str	r0, [sp, #8]
c0de13d0:	a801      	add	r0, sp, #4
    os_lib_call((unsigned int *) &libcall_params);
c0de13d2:	f000 f9b9 	bl	c0de1748 <os_lib_call>
}
c0de13d6:	bd8f      	pop	{r0, r1, r2, r3, r7, pc}
c0de13d8:	00000cb2 	.word	0x00000cb2

c0de13dc <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de13dc:	b580      	push	{r7, lr}
c0de13de:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de13e0:	f000 f9e4 	bl	c0de17ac <try_context_set>
#endif // HAVE_BOLOS
}
c0de13e4:	bd80      	pop	{r7, pc}
c0de13e6:	d4d4      	bmi.n	c0de1392 <dispatch_plugin_calls+0x46>

c0de13e8 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de13e8:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF  
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de13ea:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de13ec:	4804      	ldr	r0, [pc, #16]	; (c0de1400 <os_longjmp+0x18>)
c0de13ee:	4478      	add	r0, pc
c0de13f0:	4621      	mov	r1, r4
c0de13f2:	f000 f819 	bl	c0de1428 <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de13f6:	f000 f9d1 	bl	c0de179c <try_context_get>
c0de13fa:	4621      	mov	r1, r4
c0de13fc:	f000 fd04 	bl	c0de1e08 <longjmp>
c0de1400:	00000d3c 	.word	0x00000d3c

c0de1404 <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de1404:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de1406:	460c      	mov	r4, r1
c0de1408:	4605      	mov	r5, r0
c0de140a:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de140c:	7081      	strb	r1, [r0, #2]
c0de140e:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de1410:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de1412:	0a21      	lsrs	r1, r4, #8
c0de1414:	7041      	strb	r1, [r0, #1]
c0de1416:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de1418:	f000 f9b6 	bl	c0de1788 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de141c:	b2a1      	uxth	r1, r4
c0de141e:	4628      	mov	r0, r5
c0de1420:	f000 f9b2 	bl	c0de1788 <io_seph_send>
}
c0de1424:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
c0de1426:	d4d4      	bmi.n	c0de13d2 <call_app_ethereum+0x12>

c0de1428 <mcu_usb_printf>:
#include "usbd_def.h"
#include "usbd_core.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de1428:	b083      	sub	sp, #12
c0de142a:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de142c:	b08e      	sub	sp, #56	; 0x38
c0de142e:	ac13      	add	r4, sp, #76	; 0x4c
c0de1430:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de1432:	2800      	cmp	r0, #0
c0de1434:	d100      	bne.n	c0de1438 <mcu_usb_printf+0x10>
c0de1436:	e163      	b.n	c0de1700 <mcu_usb_printf+0x2d8>
c0de1438:	4607      	mov	r7, r0
c0de143a:	a813      	add	r0, sp, #76	; 0x4c
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de143c:	9008      	str	r0, [sp, #32]
c0de143e:	2001      	movs	r0, #1
c0de1440:	9003      	str	r0, [sp, #12]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de1442:	7838      	ldrb	r0, [r7, #0]
c0de1444:	2800      	cmp	r0, #0
c0de1446:	d100      	bne.n	c0de144a <mcu_usb_printf+0x22>
c0de1448:	e15a      	b.n	c0de1700 <mcu_usb_printf+0x2d8>
c0de144a:	463c      	mov	r4, r7
c0de144c:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de144e:	2800      	cmp	r0, #0
c0de1450:	d005      	beq.n	c0de145e <mcu_usb_printf+0x36>
c0de1452:	2825      	cmp	r0, #37	; 0x25
c0de1454:	d003      	beq.n	c0de145e <mcu_usb_printf+0x36>
c0de1456:	1960      	adds	r0, r4, r5
c0de1458:	7840      	ldrb	r0, [r0, #1]
            ulIdx++)
c0de145a:	1c6d      	adds	r5, r5, #1
c0de145c:	e7f7      	b.n	c0de144e <mcu_usb_printf+0x26>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de145e:	4620      	mov	r0, r4
c0de1460:	4629      	mov	r1, r5
c0de1462:	f7ff ffcf 	bl	c0de1404 <mcu_usb_prints>
c0de1466:	1967      	adds	r7, r4, r5
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de1468:	5d60      	ldrb	r0, [r4, r5]
c0de146a:	2825      	cmp	r0, #37	; 0x25
c0de146c:	d1e9      	bne.n	c0de1442 <mcu_usb_printf+0x1a>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de146e:	1960      	adds	r0, r4, r5
c0de1470:	1c47      	adds	r7, r0, #1
c0de1472:	2400      	movs	r4, #0
c0de1474:	2620      	movs	r6, #32
c0de1476:	9407      	str	r4, [sp, #28]
c0de1478:	4622      	mov	r2, r4
c0de147a:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de147c:	7839      	ldrb	r1, [r7, #0]
c0de147e:	1c7f      	adds	r7, r7, #1
c0de1480:	2200      	movs	r2, #0
c0de1482:	292d      	cmp	r1, #45	; 0x2d
c0de1484:	d0f9      	beq.n	c0de147a <mcu_usb_printf+0x52>
c0de1486:	460a      	mov	r2, r1
c0de1488:	3a30      	subs	r2, #48	; 0x30
c0de148a:	2a0a      	cmp	r2, #10
c0de148c:	d316      	bcc.n	c0de14bc <mcu_usb_printf+0x94>
c0de148e:	2925      	cmp	r1, #37	; 0x25
c0de1490:	d044      	beq.n	c0de151c <mcu_usb_printf+0xf4>
c0de1492:	292a      	cmp	r1, #42	; 0x2a
c0de1494:	9704      	str	r7, [sp, #16]
c0de1496:	d01e      	beq.n	c0de14d6 <mcu_usb_printf+0xae>
c0de1498:	292e      	cmp	r1, #46	; 0x2e
c0de149a:	d127      	bne.n	c0de14ec <mcu_usb_printf+0xc4>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de149c:	7838      	ldrb	r0, [r7, #0]
c0de149e:	282a      	cmp	r0, #42	; 0x2a
c0de14a0:	d17d      	bne.n	c0de159e <mcu_usb_printf+0x176>
c0de14a2:	9804      	ldr	r0, [sp, #16]
c0de14a4:	7840      	ldrb	r0, [r0, #1]
c0de14a6:	2848      	cmp	r0, #72	; 0x48
c0de14a8:	d003      	beq.n	c0de14b2 <mcu_usb_printf+0x8a>
c0de14aa:	2873      	cmp	r0, #115	; 0x73
c0de14ac:	d001      	beq.n	c0de14b2 <mcu_usb_printf+0x8a>
c0de14ae:	2868      	cmp	r0, #104	; 0x68
c0de14b0:	d175      	bne.n	c0de159e <mcu_usb_printf+0x176>
c0de14b2:	9f04      	ldr	r7, [sp, #16]
c0de14b4:	1c7f      	adds	r7, r7, #1
c0de14b6:	2201      	movs	r2, #1

                    // skip '*' char
                    format++;

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de14b8:	9808      	ldr	r0, [sp, #32]
c0de14ba:	e012      	b.n	c0de14e2 <mcu_usb_printf+0xba>
c0de14bc:	2230      	movs	r2, #48	; 0x30
                    if((format[-1] == '0') && (ulCount == 0))
c0de14be:	460b      	mov	r3, r1
c0de14c0:	4053      	eors	r3, r2
c0de14c2:	4323      	orrs	r3, r4
c0de14c4:	d000      	beq.n	c0de14c8 <mcu_usb_printf+0xa0>
c0de14c6:	4632      	mov	r2, r6
c0de14c8:	230a      	movs	r3, #10
                    ulCount *= 10;
c0de14ca:	4363      	muls	r3, r4
                    ulCount += format[-1] - '0';
c0de14cc:	185c      	adds	r4, r3, r1
c0de14ce:	3c30      	subs	r4, #48	; 0x30
c0de14d0:	4616      	mov	r6, r2
c0de14d2:	4602      	mov	r2, r0
c0de14d4:	e7d1      	b.n	c0de147a <mcu_usb_printf+0x52>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de14d6:	7838      	ldrb	r0, [r7, #0]
c0de14d8:	2873      	cmp	r0, #115	; 0x73
c0de14da:	d160      	bne.n	c0de159e <mcu_usb_printf+0x176>
c0de14dc:	2202      	movs	r2, #2

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de14de:	9808      	ldr	r0, [sp, #32]
c0de14e0:	9f04      	ldr	r7, [sp, #16]
c0de14e2:	1d01      	adds	r1, r0, #4
c0de14e4:	9108      	str	r1, [sp, #32]
c0de14e6:	6800      	ldr	r0, [r0, #0]
            switch(*format++)
c0de14e8:	9007      	str	r0, [sp, #28]
c0de14ea:	e7c6      	b.n	c0de147a <mcu_usb_printf+0x52>
c0de14ec:	2948      	cmp	r1, #72	; 0x48
c0de14ee:	d017      	beq.n	c0de1520 <mcu_usb_printf+0xf8>
c0de14f0:	2958      	cmp	r1, #88	; 0x58
c0de14f2:	d01a      	beq.n	c0de152a <mcu_usb_printf+0x102>
c0de14f4:	2963      	cmp	r1, #99	; 0x63
c0de14f6:	d025      	beq.n	c0de1544 <mcu_usb_printf+0x11c>
c0de14f8:	2964      	cmp	r1, #100	; 0x64
c0de14fa:	d02d      	beq.n	c0de1558 <mcu_usb_printf+0x130>
c0de14fc:	4a83      	ldr	r2, [pc, #524]	; (c0de170c <mcu_usb_printf+0x2e4>)
c0de14fe:	447a      	add	r2, pc
c0de1500:	9206      	str	r2, [sp, #24]
c0de1502:	2968      	cmp	r1, #104	; 0x68
c0de1504:	d037      	beq.n	c0de1576 <mcu_usb_printf+0x14e>
c0de1506:	2970      	cmp	r1, #112	; 0x70
c0de1508:	d005      	beq.n	c0de1516 <mcu_usb_printf+0xee>
c0de150a:	2973      	cmp	r1, #115	; 0x73
c0de150c:	d036      	beq.n	c0de157c <mcu_usb_printf+0x154>
c0de150e:	2975      	cmp	r1, #117	; 0x75
c0de1510:	d049      	beq.n	c0de15a6 <mcu_usb_printf+0x17e>
c0de1512:	2978      	cmp	r1, #120	; 0x78
c0de1514:	d143      	bne.n	c0de159e <mcu_usb_printf+0x176>
c0de1516:	9601      	str	r6, [sp, #4]
c0de1518:	2000      	movs	r0, #0
c0de151a:	e008      	b.n	c0de152e <mcu_usb_printf+0x106>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de151c:	1e78      	subs	r0, r7, #1
c0de151e:	e017      	b.n	c0de1550 <mcu_usb_printf+0x128>
c0de1520:	9405      	str	r4, [sp, #20]
c0de1522:	497b      	ldr	r1, [pc, #492]	; (c0de1710 <mcu_usb_printf+0x2e8>)
c0de1524:	4479      	add	r1, pc
c0de1526:	9106      	str	r1, [sp, #24]
c0de1528:	e026      	b.n	c0de1578 <mcu_usb_printf+0x150>
c0de152a:	9601      	str	r6, [sp, #4]
c0de152c:	2001      	movs	r0, #1
c0de152e:	9000      	str	r0, [sp, #0]
c0de1530:	9f03      	ldr	r7, [sp, #12]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1532:	9808      	ldr	r0, [sp, #32]
c0de1534:	1d01      	adds	r1, r0, #4
c0de1536:	9108      	str	r1, [sp, #32]
c0de1538:	6800      	ldr	r0, [r0, #0]
c0de153a:	9005      	str	r0, [sp, #20]
c0de153c:	900d      	str	r0, [sp, #52]	; 0x34
c0de153e:	2010      	movs	r0, #16
c0de1540:	9006      	str	r0, [sp, #24]
c0de1542:	e03c      	b.n	c0de15be <mcu_usb_printf+0x196>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1544:	9808      	ldr	r0, [sp, #32]
c0de1546:	1d01      	adds	r1, r0, #4
c0de1548:	9108      	str	r1, [sp, #32]
c0de154a:	6800      	ldr	r0, [r0, #0]
c0de154c:	900d      	str	r0, [sp, #52]	; 0x34
c0de154e:	a80d      	add	r0, sp, #52	; 0x34
c0de1550:	2101      	movs	r1, #1
c0de1552:	f7ff ff57 	bl	c0de1404 <mcu_usb_prints>
c0de1556:	e774      	b.n	c0de1442 <mcu_usb_printf+0x1a>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1558:	9808      	ldr	r0, [sp, #32]
c0de155a:	1d01      	adds	r1, r0, #4
c0de155c:	9108      	str	r1, [sp, #32]
c0de155e:	6800      	ldr	r0, [r0, #0]
c0de1560:	900d      	str	r0, [sp, #52]	; 0x34
c0de1562:	210a      	movs	r1, #10
                    if((long)ulValue < 0)
c0de1564:	2800      	cmp	r0, #0
c0de1566:	9601      	str	r6, [sp, #4]
c0de1568:	9106      	str	r1, [sp, #24]
c0de156a:	d500      	bpl.n	c0de156e <mcu_usb_printf+0x146>
c0de156c:	e0b7      	b.n	c0de16de <mcu_usb_printf+0x2b6>
c0de156e:	9005      	str	r0, [sp, #20]
c0de1570:	2000      	movs	r0, #0
c0de1572:	9000      	str	r0, [sp, #0]
c0de1574:	e022      	b.n	c0de15bc <mcu_usb_printf+0x194>
c0de1576:	9405      	str	r4, [sp, #20]
c0de1578:	9903      	ldr	r1, [sp, #12]
c0de157a:	e001      	b.n	c0de1580 <mcu_usb_printf+0x158>
c0de157c:	9405      	str	r4, [sp, #20]
c0de157e:	2100      	movs	r1, #0
                    pcStr = va_arg(vaArgP, char *);
c0de1580:	9a08      	ldr	r2, [sp, #32]
c0de1582:	1d13      	adds	r3, r2, #4
c0de1584:	9308      	str	r3, [sp, #32]
                    switch(cStrlenSet) {
c0de1586:	b2c0      	uxtb	r0, r0
                    pcStr = va_arg(vaArgP, char *);
c0de1588:	6817      	ldr	r7, [r2, #0]
                    switch(cStrlenSet) {
c0de158a:	2800      	cmp	r0, #0
c0de158c:	d074      	beq.n	c0de1678 <mcu_usb_printf+0x250>
c0de158e:	2801      	cmp	r0, #1
c0de1590:	d079      	beq.n	c0de1686 <mcu_usb_printf+0x25e>
c0de1592:	2802      	cmp	r0, #2
c0de1594:	d178      	bne.n	c0de1688 <mcu_usb_printf+0x260>
                        if (pcStr[0] == '\0') {
c0de1596:	7838      	ldrb	r0, [r7, #0]
c0de1598:	2800      	cmp	r0, #0
c0de159a:	d100      	bne.n	c0de159e <mcu_usb_printf+0x176>
c0de159c:	e0a6      	b.n	c0de16ec <mcu_usb_printf+0x2c4>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de159e:	4861      	ldr	r0, [pc, #388]	; (c0de1724 <mcu_usb_printf+0x2fc>)
c0de15a0:	4478      	add	r0, pc
c0de15a2:	2105      	movs	r1, #5
c0de15a4:	e064      	b.n	c0de1670 <mcu_usb_printf+0x248>
c0de15a6:	9601      	str	r6, [sp, #4]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de15a8:	9808      	ldr	r0, [sp, #32]
c0de15aa:	1d01      	adds	r1, r0, #4
c0de15ac:	9108      	str	r1, [sp, #32]
c0de15ae:	6800      	ldr	r0, [r0, #0]
c0de15b0:	9005      	str	r0, [sp, #20]
c0de15b2:	900d      	str	r0, [sp, #52]	; 0x34
c0de15b4:	2000      	movs	r0, #0
c0de15b6:	9000      	str	r0, [sp, #0]
c0de15b8:	200a      	movs	r0, #10
c0de15ba:	9006      	str	r0, [sp, #24]
c0de15bc:	9f03      	ldr	r7, [sp, #12]
c0de15be:	4639      	mov	r1, r7
c0de15c0:	4856      	ldr	r0, [pc, #344]	; (c0de171c <mcu_usb_printf+0x2f4>)
c0de15c2:	4478      	add	r0, pc
                    for(ulIdx = 1;
c0de15c4:	9007      	str	r0, [sp, #28]
c0de15c6:	9102      	str	r1, [sp, #8]
c0de15c8:	19c8      	adds	r0, r1, r7
c0de15ca:	4038      	ands	r0, r7
c0de15cc:	1a26      	subs	r6, r4, r0
c0de15ce:	1e75      	subs	r5, r6, #1
c0de15d0:	2400      	movs	r4, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de15d2:	9806      	ldr	r0, [sp, #24]
c0de15d4:	4621      	mov	r1, r4
c0de15d6:	463a      	mov	r2, r7
c0de15d8:	4623      	mov	r3, r4
c0de15da:	f000 f99f 	bl	c0de191c <__aeabi_lmul>
c0de15de:	1e4a      	subs	r2, r1, #1
c0de15e0:	4191      	sbcs	r1, r2
c0de15e2:	9a05      	ldr	r2, [sp, #20]
c0de15e4:	4290      	cmp	r0, r2
c0de15e6:	d805      	bhi.n	c0de15f4 <mcu_usb_printf+0x1cc>
                    for(ulIdx = 1;
c0de15e8:	2900      	cmp	r1, #0
c0de15ea:	d103      	bne.n	c0de15f4 <mcu_usb_printf+0x1cc>
c0de15ec:	1e6d      	subs	r5, r5, #1
c0de15ee:	1e76      	subs	r6, r6, #1
c0de15f0:	4607      	mov	r7, r0
c0de15f2:	e7ed      	b.n	c0de15d0 <mcu_usb_printf+0x1a8>
                    if(ulNeg && (cFill == '0'))
c0de15f4:	9802      	ldr	r0, [sp, #8]
c0de15f6:	2800      	cmp	r0, #0
c0de15f8:	9803      	ldr	r0, [sp, #12]
c0de15fa:	9a01      	ldr	r2, [sp, #4]
c0de15fc:	d109      	bne.n	c0de1612 <mcu_usb_printf+0x1ea>
c0de15fe:	b2d1      	uxtb	r1, r2
c0de1600:	2000      	movs	r0, #0
c0de1602:	2930      	cmp	r1, #48	; 0x30
c0de1604:	4604      	mov	r4, r0
c0de1606:	d104      	bne.n	c0de1612 <mcu_usb_printf+0x1ea>
c0de1608:	a809      	add	r0, sp, #36	; 0x24
c0de160a:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de160c:	7001      	strb	r1, [r0, #0]
c0de160e:	2401      	movs	r4, #1
c0de1610:	9803      	ldr	r0, [sp, #12]
                    if((ulCount > 1) && (ulCount < 16))
c0de1612:	1eb1      	subs	r1, r6, #2
c0de1614:	290d      	cmp	r1, #13
c0de1616:	d807      	bhi.n	c0de1628 <mcu_usb_printf+0x200>
c0de1618:	9e06      	ldr	r6, [sp, #24]
                        for(ulCount--; ulCount; ulCount--)
c0de161a:	2d00      	cmp	r5, #0
c0de161c:	d005      	beq.n	c0de162a <mcu_usb_printf+0x202>
c0de161e:	a909      	add	r1, sp, #36	; 0x24
                            pcBuf[ulPos++] = cFill;
c0de1620:	550a      	strb	r2, [r1, r4]
                        for(ulCount--; ulCount; ulCount--)
c0de1622:	1e6d      	subs	r5, r5, #1
                            pcBuf[ulPos++] = cFill;
c0de1624:	1c64      	adds	r4, r4, #1
c0de1626:	e7f8      	b.n	c0de161a <mcu_usb_printf+0x1f2>
c0de1628:	9e06      	ldr	r6, [sp, #24]
                    if(ulNeg)
c0de162a:	2800      	cmp	r0, #0
c0de162c:	9d05      	ldr	r5, [sp, #20]
c0de162e:	d103      	bne.n	c0de1638 <mcu_usb_printf+0x210>
c0de1630:	a809      	add	r0, sp, #36	; 0x24
c0de1632:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de1634:	5501      	strb	r1, [r0, r4]
c0de1636:	1c64      	adds	r4, r4, #1
c0de1638:	9800      	ldr	r0, [sp, #0]
c0de163a:	2800      	cmp	r0, #0
c0de163c:	d114      	bne.n	c0de1668 <mcu_usb_printf+0x240>
c0de163e:	4838      	ldr	r0, [pc, #224]	; (c0de1720 <mcu_usb_printf+0x2f8>)
c0de1640:	4478      	add	r0, pc
c0de1642:	9007      	str	r0, [sp, #28]
c0de1644:	e010      	b.n	c0de1668 <mcu_usb_printf+0x240>
c0de1646:	4628      	mov	r0, r5
c0de1648:	4639      	mov	r1, r7
c0de164a:	f000 f8bb 	bl	c0de17c4 <__udivsi3>
c0de164e:	4631      	mov	r1, r6
c0de1650:	f000 f93e 	bl	c0de18d0 <__aeabi_uidivmod>
c0de1654:	9807      	ldr	r0, [sp, #28]
c0de1656:	5c40      	ldrb	r0, [r0, r1]
c0de1658:	a909      	add	r1, sp, #36	; 0x24
                          pcBuf[ulPos++] = g_pcHex[(ulValue / ulIdx) % ulBase];
c0de165a:	5508      	strb	r0, [r1, r4]
                    for(; ulIdx; ulIdx /= ulBase)
c0de165c:	4638      	mov	r0, r7
c0de165e:	4631      	mov	r1, r6
c0de1660:	f000 f8b0 	bl	c0de17c4 <__udivsi3>
c0de1664:	4607      	mov	r7, r0
c0de1666:	1c64      	adds	r4, r4, #1
c0de1668:	2f00      	cmp	r7, #0
c0de166a:	d1ec      	bne.n	c0de1646 <mcu_usb_printf+0x21e>
c0de166c:	a809      	add	r0, sp, #36	; 0x24
                    mcu_usb_prints(pcBuf, ulPos);
c0de166e:	4621      	mov	r1, r4
c0de1670:	f7ff fec8 	bl	c0de1404 <mcu_usb_prints>
c0de1674:	9f04      	ldr	r7, [sp, #16]
c0de1676:	e6e4      	b.n	c0de1442 <mcu_usb_printf+0x1a>
c0de1678:	2000      	movs	r0, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de167a:	5c3a      	ldrb	r2, [r7, r0]
c0de167c:	1c40      	adds	r0, r0, #1
c0de167e:	2a00      	cmp	r2, #0
c0de1680:	d1fb      	bne.n	c0de167a <mcu_usb_printf+0x252>
                    switch(ulBase) {
c0de1682:	1e45      	subs	r5, r0, #1
c0de1684:	e000      	b.n	c0de1688 <mcu_usb_printf+0x260>
c0de1686:	9d07      	ldr	r5, [sp, #28]
c0de1688:	2900      	cmp	r1, #0
c0de168a:	d014      	beq.n	c0de16b6 <mcu_usb_printf+0x28e>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de168c:	2d00      	cmp	r5, #0
c0de168e:	d0f1      	beq.n	c0de1674 <mcu_usb_printf+0x24c>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de1690:	783e      	ldrb	r6, [r7, #0]
c0de1692:	0930      	lsrs	r0, r6, #4
c0de1694:	9c06      	ldr	r4, [sp, #24]
c0de1696:	1820      	adds	r0, r4, r0
c0de1698:	9507      	str	r5, [sp, #28]
c0de169a:	2501      	movs	r5, #1
c0de169c:	4629      	mov	r1, r5
c0de169e:	f7ff feb1 	bl	c0de1404 <mcu_usb_prints>
c0de16a2:	200f      	movs	r0, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de16a4:	4030      	ands	r0, r6
c0de16a6:	1820      	adds	r0, r4, r0
c0de16a8:	4629      	mov	r1, r5
c0de16aa:	9d07      	ldr	r5, [sp, #28]
c0de16ac:	f7ff feaa 	bl	c0de1404 <mcu_usb_prints>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de16b0:	1c7f      	adds	r7, r7, #1
c0de16b2:	1e6d      	subs	r5, r5, #1
c0de16b4:	e7ea      	b.n	c0de168c <mcu_usb_printf+0x264>
                        mcu_usb_prints(pcStr, ulIdx);
c0de16b6:	4638      	mov	r0, r7
c0de16b8:	4629      	mov	r1, r5
c0de16ba:	f7ff fea3 	bl	c0de1404 <mcu_usb_prints>
c0de16be:	9f04      	ldr	r7, [sp, #16]
c0de16c0:	9805      	ldr	r0, [sp, #20]
                    if(ulCount > ulIdx)
c0de16c2:	42a8      	cmp	r0, r5
c0de16c4:	d800      	bhi.n	c0de16c8 <mcu_usb_printf+0x2a0>
c0de16c6:	e6bc      	b.n	c0de1442 <mcu_usb_printf+0x1a>
                        while(ulCount--)
c0de16c8:	1a2c      	subs	r4, r5, r0
c0de16ca:	2c00      	cmp	r4, #0
c0de16cc:	d100      	bne.n	c0de16d0 <mcu_usb_printf+0x2a8>
c0de16ce:	e6b8      	b.n	c0de1442 <mcu_usb_printf+0x1a>
                            mcu_usb_prints(" ", 1);
c0de16d0:	4811      	ldr	r0, [pc, #68]	; (c0de1718 <mcu_usb_printf+0x2f0>)
c0de16d2:	4478      	add	r0, pc
c0de16d4:	2101      	movs	r1, #1
c0de16d6:	f7ff fe95 	bl	c0de1404 <mcu_usb_prints>
                        while(ulCount--)
c0de16da:	1c64      	adds	r4, r4, #1
c0de16dc:	e7f5      	b.n	c0de16ca <mcu_usb_printf+0x2a2>
                        ulValue = -(long)ulValue;
c0de16de:	4240      	negs	r0, r0
c0de16e0:	9005      	str	r0, [sp, #20]
c0de16e2:	900d      	str	r0, [sp, #52]	; 0x34
c0de16e4:	2100      	movs	r1, #0
            ulCap = 0;
c0de16e6:	9100      	str	r1, [sp, #0]
c0de16e8:	9f03      	ldr	r7, [sp, #12]
c0de16ea:	e769      	b.n	c0de15c0 <mcu_usb_printf+0x198>
                          do {
c0de16ec:	9807      	ldr	r0, [sp, #28]
c0de16ee:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de16f0:	4808      	ldr	r0, [pc, #32]	; (c0de1714 <mcu_usb_printf+0x2ec>)
c0de16f2:	4478      	add	r0, pc
c0de16f4:	2101      	movs	r1, #1
c0de16f6:	f7ff fe85 	bl	c0de1404 <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de16fa:	1e64      	subs	r4, r4, #1
c0de16fc:	d1f8      	bne.n	c0de16f0 <mcu_usb_printf+0x2c8>
c0de16fe:	e7de      	b.n	c0de16be <mcu_usb_printf+0x296>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de1700:	b00e      	add	sp, #56	; 0x38
c0de1702:	bcf0      	pop	{r4, r5, r6, r7}
c0de1704:	bc01      	pop	{r0}
c0de1706:	b003      	add	sp, #12
c0de1708:	4700      	bx	r0
c0de170a:	46c0      	nop			; (mov r8, r8)
c0de170c:	00000e46 	.word	0x00000e46
c0de1710:	00000e30 	.word	0x00000e30
c0de1714:	000008e0 	.word	0x000008e0
c0de1718:	00000900 	.word	0x00000900
c0de171c:	00000d92 	.word	0x00000d92
c0de1720:	00000d04 	.word	0x00000d04
c0de1724:	00000ba4 	.word	0x00000ba4

c0de1728 <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de1728:	df01      	svc	1
    cmp r1, #0
c0de172a:	2900      	cmp	r1, #0
    bne exception
c0de172c:	d100      	bne.n	c0de1730 <exception>
    bx lr
c0de172e:	4770      	bx	lr

c0de1730 <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de1730:	4608      	mov	r0, r1
    bl os_longjmp
c0de1732:	f7ff fe59 	bl	c0de13e8 <os_longjmp>

c0de1736 <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de1736:	b5e0      	push	{r5, r6, r7, lr}
c0de1738:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de173a:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de173c:	9000      	str	r0, [sp, #0]
c0de173e:	2001      	movs	r0, #1
c0de1740:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de1742:	f7ff fff1 	bl	c0de1728 <SVC_Call>
c0de1746:	bd8c      	pop	{r2, r3, r7, pc}

c0de1748 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de1748:	b5e0      	push	{r5, r6, r7, lr}
c0de174a:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de174c:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de174e:	9000      	str	r0, [sp, #0]
c0de1750:	4802      	ldr	r0, [pc, #8]	; (c0de175c <os_lib_call+0x14>)
c0de1752:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de1754:	f7ff ffe8 	bl	c0de1728 <SVC_Call>
  return;
}
c0de1758:	bd8c      	pop	{r2, r3, r7, pc}
c0de175a:	46c0      	nop			; (mov r8, r8)
c0de175c:	01000067 	.word	0x01000067

c0de1760 <os_lib_end>:

void __attribute__((noreturn)) os_lib_end ( void ) {
c0de1760:	b082      	sub	sp, #8
c0de1762:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de1764:	9001      	str	r0, [sp, #4]
c0de1766:	2068      	movs	r0, #104	; 0x68
c0de1768:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de176a:	f7ff ffdd 	bl	c0de1728 <SVC_Call>

  // The os_lib_end syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de176e:	deff      	udf	#255	; 0xff

c0de1770 <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de1770:	b082      	sub	sp, #8
c0de1772:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de1774:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de1776:	9000      	str	r0, [sp, #0]
c0de1778:	4802      	ldr	r0, [pc, #8]	; (c0de1784 <os_sched_exit+0x14>)
c0de177a:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de177c:	f7ff ffd4 	bl	c0de1728 <SVC_Call>

  // The os_sched_exit syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de1780:	deff      	udf	#255	; 0xff
c0de1782:	46c0      	nop			; (mov r8, r8)
c0de1784:	0100009a 	.word	0x0100009a

c0de1788 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de1788:	b5e0      	push	{r5, r6, r7, lr}
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de178a:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de178c:	9000      	str	r0, [sp, #0]
c0de178e:	4802      	ldr	r0, [pc, #8]	; (c0de1798 <io_seph_send+0x10>)
c0de1790:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de1792:	f7ff ffc9 	bl	c0de1728 <SVC_Call>
  return;
}
c0de1796:	bd8c      	pop	{r2, r3, r7, pc}
c0de1798:	02000083 	.word	0x02000083

c0de179c <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de179c:	b5e0      	push	{r5, r6, r7, lr}
c0de179e:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de17a0:	9001      	str	r0, [sp, #4]
c0de17a2:	2087      	movs	r0, #135	; 0x87
c0de17a4:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de17a6:	f7ff ffbf 	bl	c0de1728 <SVC_Call>
c0de17aa:	bd8c      	pop	{r2, r3, r7, pc}

c0de17ac <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de17ac:	b5e0      	push	{r5, r6, r7, lr}
c0de17ae:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de17b0:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de17b2:	9000      	str	r0, [sp, #0]
c0de17b4:	4802      	ldr	r0, [pc, #8]	; (c0de17c0 <try_context_set+0x14>)
c0de17b6:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de17b8:	f7ff ffb6 	bl	c0de1728 <SVC_Call>
c0de17bc:	bd8c      	pop	{r2, r3, r7, pc}
c0de17be:	46c0      	nop			; (mov r8, r8)
c0de17c0:	0100010b 	.word	0x0100010b

c0de17c4 <__udivsi3>:
c0de17c4:	2200      	movs	r2, #0
c0de17c6:	0843      	lsrs	r3, r0, #1
c0de17c8:	428b      	cmp	r3, r1
c0de17ca:	d374      	bcc.n	c0de18b6 <__udivsi3+0xf2>
c0de17cc:	0903      	lsrs	r3, r0, #4
c0de17ce:	428b      	cmp	r3, r1
c0de17d0:	d35f      	bcc.n	c0de1892 <__udivsi3+0xce>
c0de17d2:	0a03      	lsrs	r3, r0, #8
c0de17d4:	428b      	cmp	r3, r1
c0de17d6:	d344      	bcc.n	c0de1862 <__udivsi3+0x9e>
c0de17d8:	0b03      	lsrs	r3, r0, #12
c0de17da:	428b      	cmp	r3, r1
c0de17dc:	d328      	bcc.n	c0de1830 <__udivsi3+0x6c>
c0de17de:	0c03      	lsrs	r3, r0, #16
c0de17e0:	428b      	cmp	r3, r1
c0de17e2:	d30d      	bcc.n	c0de1800 <__udivsi3+0x3c>
c0de17e4:	22ff      	movs	r2, #255	; 0xff
c0de17e6:	0209      	lsls	r1, r1, #8
c0de17e8:	ba12      	rev	r2, r2
c0de17ea:	0c03      	lsrs	r3, r0, #16
c0de17ec:	428b      	cmp	r3, r1
c0de17ee:	d302      	bcc.n	c0de17f6 <__udivsi3+0x32>
c0de17f0:	1212      	asrs	r2, r2, #8
c0de17f2:	0209      	lsls	r1, r1, #8
c0de17f4:	d065      	beq.n	c0de18c2 <__udivsi3+0xfe>
c0de17f6:	0b03      	lsrs	r3, r0, #12
c0de17f8:	428b      	cmp	r3, r1
c0de17fa:	d319      	bcc.n	c0de1830 <__udivsi3+0x6c>
c0de17fc:	e000      	b.n	c0de1800 <__udivsi3+0x3c>
c0de17fe:	0a09      	lsrs	r1, r1, #8
c0de1800:	0bc3      	lsrs	r3, r0, #15
c0de1802:	428b      	cmp	r3, r1
c0de1804:	d301      	bcc.n	c0de180a <__udivsi3+0x46>
c0de1806:	03cb      	lsls	r3, r1, #15
c0de1808:	1ac0      	subs	r0, r0, r3
c0de180a:	4152      	adcs	r2, r2
c0de180c:	0b83      	lsrs	r3, r0, #14
c0de180e:	428b      	cmp	r3, r1
c0de1810:	d301      	bcc.n	c0de1816 <__udivsi3+0x52>
c0de1812:	038b      	lsls	r3, r1, #14
c0de1814:	1ac0      	subs	r0, r0, r3
c0de1816:	4152      	adcs	r2, r2
c0de1818:	0b43      	lsrs	r3, r0, #13
c0de181a:	428b      	cmp	r3, r1
c0de181c:	d301      	bcc.n	c0de1822 <__udivsi3+0x5e>
c0de181e:	034b      	lsls	r3, r1, #13
c0de1820:	1ac0      	subs	r0, r0, r3
c0de1822:	4152      	adcs	r2, r2
c0de1824:	0b03      	lsrs	r3, r0, #12
c0de1826:	428b      	cmp	r3, r1
c0de1828:	d301      	bcc.n	c0de182e <__udivsi3+0x6a>
c0de182a:	030b      	lsls	r3, r1, #12
c0de182c:	1ac0      	subs	r0, r0, r3
c0de182e:	4152      	adcs	r2, r2
c0de1830:	0ac3      	lsrs	r3, r0, #11
c0de1832:	428b      	cmp	r3, r1
c0de1834:	d301      	bcc.n	c0de183a <__udivsi3+0x76>
c0de1836:	02cb      	lsls	r3, r1, #11
c0de1838:	1ac0      	subs	r0, r0, r3
c0de183a:	4152      	adcs	r2, r2
c0de183c:	0a83      	lsrs	r3, r0, #10
c0de183e:	428b      	cmp	r3, r1
c0de1840:	d301      	bcc.n	c0de1846 <__udivsi3+0x82>
c0de1842:	028b      	lsls	r3, r1, #10
c0de1844:	1ac0      	subs	r0, r0, r3
c0de1846:	4152      	adcs	r2, r2
c0de1848:	0a43      	lsrs	r3, r0, #9
c0de184a:	428b      	cmp	r3, r1
c0de184c:	d301      	bcc.n	c0de1852 <__udivsi3+0x8e>
c0de184e:	024b      	lsls	r3, r1, #9
c0de1850:	1ac0      	subs	r0, r0, r3
c0de1852:	4152      	adcs	r2, r2
c0de1854:	0a03      	lsrs	r3, r0, #8
c0de1856:	428b      	cmp	r3, r1
c0de1858:	d301      	bcc.n	c0de185e <__udivsi3+0x9a>
c0de185a:	020b      	lsls	r3, r1, #8
c0de185c:	1ac0      	subs	r0, r0, r3
c0de185e:	4152      	adcs	r2, r2
c0de1860:	d2cd      	bcs.n	c0de17fe <__udivsi3+0x3a>
c0de1862:	09c3      	lsrs	r3, r0, #7
c0de1864:	428b      	cmp	r3, r1
c0de1866:	d301      	bcc.n	c0de186c <__udivsi3+0xa8>
c0de1868:	01cb      	lsls	r3, r1, #7
c0de186a:	1ac0      	subs	r0, r0, r3
c0de186c:	4152      	adcs	r2, r2
c0de186e:	0983      	lsrs	r3, r0, #6
c0de1870:	428b      	cmp	r3, r1
c0de1872:	d301      	bcc.n	c0de1878 <__udivsi3+0xb4>
c0de1874:	018b      	lsls	r3, r1, #6
c0de1876:	1ac0      	subs	r0, r0, r3
c0de1878:	4152      	adcs	r2, r2
c0de187a:	0943      	lsrs	r3, r0, #5
c0de187c:	428b      	cmp	r3, r1
c0de187e:	d301      	bcc.n	c0de1884 <__udivsi3+0xc0>
c0de1880:	014b      	lsls	r3, r1, #5
c0de1882:	1ac0      	subs	r0, r0, r3
c0de1884:	4152      	adcs	r2, r2
c0de1886:	0903      	lsrs	r3, r0, #4
c0de1888:	428b      	cmp	r3, r1
c0de188a:	d301      	bcc.n	c0de1890 <__udivsi3+0xcc>
c0de188c:	010b      	lsls	r3, r1, #4
c0de188e:	1ac0      	subs	r0, r0, r3
c0de1890:	4152      	adcs	r2, r2
c0de1892:	08c3      	lsrs	r3, r0, #3
c0de1894:	428b      	cmp	r3, r1
c0de1896:	d301      	bcc.n	c0de189c <__udivsi3+0xd8>
c0de1898:	00cb      	lsls	r3, r1, #3
c0de189a:	1ac0      	subs	r0, r0, r3
c0de189c:	4152      	adcs	r2, r2
c0de189e:	0883      	lsrs	r3, r0, #2
c0de18a0:	428b      	cmp	r3, r1
c0de18a2:	d301      	bcc.n	c0de18a8 <__udivsi3+0xe4>
c0de18a4:	008b      	lsls	r3, r1, #2
c0de18a6:	1ac0      	subs	r0, r0, r3
c0de18a8:	4152      	adcs	r2, r2
c0de18aa:	0843      	lsrs	r3, r0, #1
c0de18ac:	428b      	cmp	r3, r1
c0de18ae:	d301      	bcc.n	c0de18b4 <__udivsi3+0xf0>
c0de18b0:	004b      	lsls	r3, r1, #1
c0de18b2:	1ac0      	subs	r0, r0, r3
c0de18b4:	4152      	adcs	r2, r2
c0de18b6:	1a41      	subs	r1, r0, r1
c0de18b8:	d200      	bcs.n	c0de18bc <__udivsi3+0xf8>
c0de18ba:	4601      	mov	r1, r0
c0de18bc:	4152      	adcs	r2, r2
c0de18be:	4610      	mov	r0, r2
c0de18c0:	4770      	bx	lr
c0de18c2:	e7ff      	b.n	c0de18c4 <__udivsi3+0x100>
c0de18c4:	b501      	push	{r0, lr}
c0de18c6:	2000      	movs	r0, #0
c0de18c8:	f000 f806 	bl	c0de18d8 <__aeabi_idiv0>
c0de18cc:	bd02      	pop	{r1, pc}
c0de18ce:	46c0      	nop			; (mov r8, r8)

c0de18d0 <__aeabi_uidivmod>:
c0de18d0:	2900      	cmp	r1, #0
c0de18d2:	d0f7      	beq.n	c0de18c4 <__udivsi3+0x100>
c0de18d4:	e776      	b.n	c0de17c4 <__udivsi3>
c0de18d6:	4770      	bx	lr

c0de18d8 <__aeabi_idiv0>:
c0de18d8:	4770      	bx	lr
c0de18da:	46c0      	nop			; (mov r8, r8)

c0de18dc <__aeabi_uldivmod>:
c0de18dc:	2b00      	cmp	r3, #0
c0de18de:	d111      	bne.n	c0de1904 <__aeabi_uldivmod+0x28>
c0de18e0:	2a00      	cmp	r2, #0
c0de18e2:	d10f      	bne.n	c0de1904 <__aeabi_uldivmod+0x28>
c0de18e4:	2900      	cmp	r1, #0
c0de18e6:	d100      	bne.n	c0de18ea <__aeabi_uldivmod+0xe>
c0de18e8:	2800      	cmp	r0, #0
c0de18ea:	d002      	beq.n	c0de18f2 <__aeabi_uldivmod+0x16>
c0de18ec:	2100      	movs	r1, #0
c0de18ee:	43c9      	mvns	r1, r1
c0de18f0:	1c08      	adds	r0, r1, #0
c0de18f2:	b407      	push	{r0, r1, r2}
c0de18f4:	4802      	ldr	r0, [pc, #8]	; (c0de1900 <__aeabi_uldivmod+0x24>)
c0de18f6:	a102      	add	r1, pc, #8	; (adr r1, c0de1900 <__aeabi_uldivmod+0x24>)
c0de18f8:	1840      	adds	r0, r0, r1
c0de18fa:	9002      	str	r0, [sp, #8]
c0de18fc:	bd03      	pop	{r0, r1, pc}
c0de18fe:	46c0      	nop			; (mov r8, r8)
c0de1900:	ffffffd9 	.word	0xffffffd9
c0de1904:	b403      	push	{r0, r1}
c0de1906:	4668      	mov	r0, sp
c0de1908:	b501      	push	{r0, lr}
c0de190a:	9802      	ldr	r0, [sp, #8]
c0de190c:	f000 f830 	bl	c0de1970 <__udivmoddi4>
c0de1910:	9b01      	ldr	r3, [sp, #4]
c0de1912:	469e      	mov	lr, r3
c0de1914:	b002      	add	sp, #8
c0de1916:	bc0c      	pop	{r2, r3}
c0de1918:	4770      	bx	lr
c0de191a:	46c0      	nop			; (mov r8, r8)

c0de191c <__aeabi_lmul>:
c0de191c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de191e:	46ce      	mov	lr, r9
c0de1920:	4647      	mov	r7, r8
c0de1922:	0415      	lsls	r5, r2, #16
c0de1924:	0c2d      	lsrs	r5, r5, #16
c0de1926:	002e      	movs	r6, r5
c0de1928:	b580      	push	{r7, lr}
c0de192a:	0407      	lsls	r7, r0, #16
c0de192c:	0c14      	lsrs	r4, r2, #16
c0de192e:	0c3f      	lsrs	r7, r7, #16
c0de1930:	4699      	mov	r9, r3
c0de1932:	0c03      	lsrs	r3, r0, #16
c0de1934:	437e      	muls	r6, r7
c0de1936:	435d      	muls	r5, r3
c0de1938:	4367      	muls	r7, r4
c0de193a:	4363      	muls	r3, r4
c0de193c:	197f      	adds	r7, r7, r5
c0de193e:	0c34      	lsrs	r4, r6, #16
c0de1940:	19e4      	adds	r4, r4, r7
c0de1942:	469c      	mov	ip, r3
c0de1944:	42a5      	cmp	r5, r4
c0de1946:	d903      	bls.n	c0de1950 <__aeabi_lmul+0x34>
c0de1948:	2380      	movs	r3, #128	; 0x80
c0de194a:	025b      	lsls	r3, r3, #9
c0de194c:	4698      	mov	r8, r3
c0de194e:	44c4      	add	ip, r8
c0de1950:	464b      	mov	r3, r9
c0de1952:	4343      	muls	r3, r0
c0de1954:	4351      	muls	r1, r2
c0de1956:	0c25      	lsrs	r5, r4, #16
c0de1958:	0436      	lsls	r6, r6, #16
c0de195a:	4465      	add	r5, ip
c0de195c:	0c36      	lsrs	r6, r6, #16
c0de195e:	0424      	lsls	r4, r4, #16
c0de1960:	19a4      	adds	r4, r4, r6
c0de1962:	195b      	adds	r3, r3, r5
c0de1964:	1859      	adds	r1, r3, r1
c0de1966:	0020      	movs	r0, r4
c0de1968:	bc0c      	pop	{r2, r3}
c0de196a:	4690      	mov	r8, r2
c0de196c:	4699      	mov	r9, r3
c0de196e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de1970 <__udivmoddi4>:
c0de1970:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1972:	4657      	mov	r7, sl
c0de1974:	464e      	mov	r6, r9
c0de1976:	4645      	mov	r5, r8
c0de1978:	46de      	mov	lr, fp
c0de197a:	b5e0      	push	{r5, r6, r7, lr}
c0de197c:	0004      	movs	r4, r0
c0de197e:	b083      	sub	sp, #12
c0de1980:	000d      	movs	r5, r1
c0de1982:	4692      	mov	sl, r2
c0de1984:	4699      	mov	r9, r3
c0de1986:	428b      	cmp	r3, r1
c0de1988:	d830      	bhi.n	c0de19ec <__udivmoddi4+0x7c>
c0de198a:	d02d      	beq.n	c0de19e8 <__udivmoddi4+0x78>
c0de198c:	4649      	mov	r1, r9
c0de198e:	4650      	mov	r0, sl
c0de1990:	f000 f8c0 	bl	c0de1b14 <__clzdi2>
c0de1994:	0029      	movs	r1, r5
c0de1996:	0006      	movs	r6, r0
c0de1998:	0020      	movs	r0, r4
c0de199a:	f000 f8bb 	bl	c0de1b14 <__clzdi2>
c0de199e:	1a33      	subs	r3, r6, r0
c0de19a0:	4698      	mov	r8, r3
c0de19a2:	3b20      	subs	r3, #32
c0de19a4:	469b      	mov	fp, r3
c0de19a6:	d433      	bmi.n	c0de1a10 <__udivmoddi4+0xa0>
c0de19a8:	465a      	mov	r2, fp
c0de19aa:	4653      	mov	r3, sl
c0de19ac:	4093      	lsls	r3, r2
c0de19ae:	4642      	mov	r2, r8
c0de19b0:	001f      	movs	r7, r3
c0de19b2:	4653      	mov	r3, sl
c0de19b4:	4093      	lsls	r3, r2
c0de19b6:	001e      	movs	r6, r3
c0de19b8:	42af      	cmp	r7, r5
c0de19ba:	d83a      	bhi.n	c0de1a32 <__udivmoddi4+0xc2>
c0de19bc:	42af      	cmp	r7, r5
c0de19be:	d100      	bne.n	c0de19c2 <__udivmoddi4+0x52>
c0de19c0:	e07b      	b.n	c0de1aba <__udivmoddi4+0x14a>
c0de19c2:	465b      	mov	r3, fp
c0de19c4:	1ba4      	subs	r4, r4, r6
c0de19c6:	41bd      	sbcs	r5, r7
c0de19c8:	2b00      	cmp	r3, #0
c0de19ca:	da00      	bge.n	c0de19ce <__udivmoddi4+0x5e>
c0de19cc:	e078      	b.n	c0de1ac0 <__udivmoddi4+0x150>
c0de19ce:	2200      	movs	r2, #0
c0de19d0:	2300      	movs	r3, #0
c0de19d2:	9200      	str	r2, [sp, #0]
c0de19d4:	9301      	str	r3, [sp, #4]
c0de19d6:	2301      	movs	r3, #1
c0de19d8:	465a      	mov	r2, fp
c0de19da:	4093      	lsls	r3, r2
c0de19dc:	9301      	str	r3, [sp, #4]
c0de19de:	2301      	movs	r3, #1
c0de19e0:	4642      	mov	r2, r8
c0de19e2:	4093      	lsls	r3, r2
c0de19e4:	9300      	str	r3, [sp, #0]
c0de19e6:	e028      	b.n	c0de1a3a <__udivmoddi4+0xca>
c0de19e8:	4282      	cmp	r2, r0
c0de19ea:	d9cf      	bls.n	c0de198c <__udivmoddi4+0x1c>
c0de19ec:	2200      	movs	r2, #0
c0de19ee:	2300      	movs	r3, #0
c0de19f0:	9200      	str	r2, [sp, #0]
c0de19f2:	9301      	str	r3, [sp, #4]
c0de19f4:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0de19f6:	2b00      	cmp	r3, #0
c0de19f8:	d001      	beq.n	c0de19fe <__udivmoddi4+0x8e>
c0de19fa:	601c      	str	r4, [r3, #0]
c0de19fc:	605d      	str	r5, [r3, #4]
c0de19fe:	9800      	ldr	r0, [sp, #0]
c0de1a00:	9901      	ldr	r1, [sp, #4]
c0de1a02:	b003      	add	sp, #12
c0de1a04:	bc3c      	pop	{r2, r3, r4, r5}
c0de1a06:	4690      	mov	r8, r2
c0de1a08:	4699      	mov	r9, r3
c0de1a0a:	46a2      	mov	sl, r4
c0de1a0c:	46ab      	mov	fp, r5
c0de1a0e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1a10:	4642      	mov	r2, r8
c0de1a12:	2320      	movs	r3, #32
c0de1a14:	1a9b      	subs	r3, r3, r2
c0de1a16:	4652      	mov	r2, sl
c0de1a18:	40da      	lsrs	r2, r3
c0de1a1a:	4641      	mov	r1, r8
c0de1a1c:	0013      	movs	r3, r2
c0de1a1e:	464a      	mov	r2, r9
c0de1a20:	408a      	lsls	r2, r1
c0de1a22:	0017      	movs	r7, r2
c0de1a24:	4642      	mov	r2, r8
c0de1a26:	431f      	orrs	r7, r3
c0de1a28:	4653      	mov	r3, sl
c0de1a2a:	4093      	lsls	r3, r2
c0de1a2c:	001e      	movs	r6, r3
c0de1a2e:	42af      	cmp	r7, r5
c0de1a30:	d9c4      	bls.n	c0de19bc <__udivmoddi4+0x4c>
c0de1a32:	2200      	movs	r2, #0
c0de1a34:	2300      	movs	r3, #0
c0de1a36:	9200      	str	r2, [sp, #0]
c0de1a38:	9301      	str	r3, [sp, #4]
c0de1a3a:	4643      	mov	r3, r8
c0de1a3c:	2b00      	cmp	r3, #0
c0de1a3e:	d0d9      	beq.n	c0de19f4 <__udivmoddi4+0x84>
c0de1a40:	07fb      	lsls	r3, r7, #31
c0de1a42:	469c      	mov	ip, r3
c0de1a44:	4661      	mov	r1, ip
c0de1a46:	0872      	lsrs	r2, r6, #1
c0de1a48:	430a      	orrs	r2, r1
c0de1a4a:	087b      	lsrs	r3, r7, #1
c0de1a4c:	4646      	mov	r6, r8
c0de1a4e:	e00e      	b.n	c0de1a6e <__udivmoddi4+0xfe>
c0de1a50:	42ab      	cmp	r3, r5
c0de1a52:	d101      	bne.n	c0de1a58 <__udivmoddi4+0xe8>
c0de1a54:	42a2      	cmp	r2, r4
c0de1a56:	d80c      	bhi.n	c0de1a72 <__udivmoddi4+0x102>
c0de1a58:	1aa4      	subs	r4, r4, r2
c0de1a5a:	419d      	sbcs	r5, r3
c0de1a5c:	2001      	movs	r0, #1
c0de1a5e:	1924      	adds	r4, r4, r4
c0de1a60:	416d      	adcs	r5, r5
c0de1a62:	2100      	movs	r1, #0
c0de1a64:	3e01      	subs	r6, #1
c0de1a66:	1824      	adds	r4, r4, r0
c0de1a68:	414d      	adcs	r5, r1
c0de1a6a:	2e00      	cmp	r6, #0
c0de1a6c:	d006      	beq.n	c0de1a7c <__udivmoddi4+0x10c>
c0de1a6e:	42ab      	cmp	r3, r5
c0de1a70:	d9ee      	bls.n	c0de1a50 <__udivmoddi4+0xe0>
c0de1a72:	3e01      	subs	r6, #1
c0de1a74:	1924      	adds	r4, r4, r4
c0de1a76:	416d      	adcs	r5, r5
c0de1a78:	2e00      	cmp	r6, #0
c0de1a7a:	d1f8      	bne.n	c0de1a6e <__udivmoddi4+0xfe>
c0de1a7c:	9800      	ldr	r0, [sp, #0]
c0de1a7e:	9901      	ldr	r1, [sp, #4]
c0de1a80:	465b      	mov	r3, fp
c0de1a82:	1900      	adds	r0, r0, r4
c0de1a84:	4169      	adcs	r1, r5
c0de1a86:	2b00      	cmp	r3, #0
c0de1a88:	db25      	blt.n	c0de1ad6 <__udivmoddi4+0x166>
c0de1a8a:	002b      	movs	r3, r5
c0de1a8c:	465a      	mov	r2, fp
c0de1a8e:	4644      	mov	r4, r8
c0de1a90:	40d3      	lsrs	r3, r2
c0de1a92:	002a      	movs	r2, r5
c0de1a94:	40e2      	lsrs	r2, r4
c0de1a96:	001c      	movs	r4, r3
c0de1a98:	465b      	mov	r3, fp
c0de1a9a:	0015      	movs	r5, r2
c0de1a9c:	2b00      	cmp	r3, #0
c0de1a9e:	db2b      	blt.n	c0de1af8 <__udivmoddi4+0x188>
c0de1aa0:	0026      	movs	r6, r4
c0de1aa2:	465f      	mov	r7, fp
c0de1aa4:	40be      	lsls	r6, r7
c0de1aa6:	0033      	movs	r3, r6
c0de1aa8:	0026      	movs	r6, r4
c0de1aaa:	4647      	mov	r7, r8
c0de1aac:	40be      	lsls	r6, r7
c0de1aae:	0032      	movs	r2, r6
c0de1ab0:	1a80      	subs	r0, r0, r2
c0de1ab2:	4199      	sbcs	r1, r3
c0de1ab4:	9000      	str	r0, [sp, #0]
c0de1ab6:	9101      	str	r1, [sp, #4]
c0de1ab8:	e79c      	b.n	c0de19f4 <__udivmoddi4+0x84>
c0de1aba:	42a3      	cmp	r3, r4
c0de1abc:	d8b9      	bhi.n	c0de1a32 <__udivmoddi4+0xc2>
c0de1abe:	e780      	b.n	c0de19c2 <__udivmoddi4+0x52>
c0de1ac0:	4642      	mov	r2, r8
c0de1ac2:	2320      	movs	r3, #32
c0de1ac4:	2100      	movs	r1, #0
c0de1ac6:	1a9b      	subs	r3, r3, r2
c0de1ac8:	2200      	movs	r2, #0
c0de1aca:	9100      	str	r1, [sp, #0]
c0de1acc:	9201      	str	r2, [sp, #4]
c0de1ace:	2201      	movs	r2, #1
c0de1ad0:	40da      	lsrs	r2, r3
c0de1ad2:	9201      	str	r2, [sp, #4]
c0de1ad4:	e783      	b.n	c0de19de <__udivmoddi4+0x6e>
c0de1ad6:	4642      	mov	r2, r8
c0de1ad8:	2320      	movs	r3, #32
c0de1ada:	1a9b      	subs	r3, r3, r2
c0de1adc:	002a      	movs	r2, r5
c0de1ade:	4646      	mov	r6, r8
c0de1ae0:	409a      	lsls	r2, r3
c0de1ae2:	0023      	movs	r3, r4
c0de1ae4:	40f3      	lsrs	r3, r6
c0de1ae6:	4644      	mov	r4, r8
c0de1ae8:	4313      	orrs	r3, r2
c0de1aea:	002a      	movs	r2, r5
c0de1aec:	40e2      	lsrs	r2, r4
c0de1aee:	001c      	movs	r4, r3
c0de1af0:	465b      	mov	r3, fp
c0de1af2:	0015      	movs	r5, r2
c0de1af4:	2b00      	cmp	r3, #0
c0de1af6:	dad3      	bge.n	c0de1aa0 <__udivmoddi4+0x130>
c0de1af8:	2320      	movs	r3, #32
c0de1afa:	4642      	mov	r2, r8
c0de1afc:	0026      	movs	r6, r4
c0de1afe:	1a9b      	subs	r3, r3, r2
c0de1b00:	40de      	lsrs	r6, r3
c0de1b02:	002f      	movs	r7, r5
c0de1b04:	46b4      	mov	ip, r6
c0de1b06:	4646      	mov	r6, r8
c0de1b08:	40b7      	lsls	r7, r6
c0de1b0a:	4666      	mov	r6, ip
c0de1b0c:	003b      	movs	r3, r7
c0de1b0e:	4333      	orrs	r3, r6
c0de1b10:	e7ca      	b.n	c0de1aa8 <__udivmoddi4+0x138>
c0de1b12:	46c0      	nop			; (mov r8, r8)

c0de1b14 <__clzdi2>:
c0de1b14:	b510      	push	{r4, lr}
c0de1b16:	2900      	cmp	r1, #0
c0de1b18:	d103      	bne.n	c0de1b22 <__clzdi2+0xe>
c0de1b1a:	f000 f807 	bl	c0de1b2c <__clzsi2>
c0de1b1e:	3020      	adds	r0, #32
c0de1b20:	e002      	b.n	c0de1b28 <__clzdi2+0x14>
c0de1b22:	1c08      	adds	r0, r1, #0
c0de1b24:	f000 f802 	bl	c0de1b2c <__clzsi2>
c0de1b28:	bd10      	pop	{r4, pc}
c0de1b2a:	46c0      	nop			; (mov r8, r8)

c0de1b2c <__clzsi2>:
c0de1b2c:	211c      	movs	r1, #28
c0de1b2e:	2301      	movs	r3, #1
c0de1b30:	041b      	lsls	r3, r3, #16
c0de1b32:	4298      	cmp	r0, r3
c0de1b34:	d301      	bcc.n	c0de1b3a <__clzsi2+0xe>
c0de1b36:	0c00      	lsrs	r0, r0, #16
c0de1b38:	3910      	subs	r1, #16
c0de1b3a:	0a1b      	lsrs	r3, r3, #8
c0de1b3c:	4298      	cmp	r0, r3
c0de1b3e:	d301      	bcc.n	c0de1b44 <__clzsi2+0x18>
c0de1b40:	0a00      	lsrs	r0, r0, #8
c0de1b42:	3908      	subs	r1, #8
c0de1b44:	091b      	lsrs	r3, r3, #4
c0de1b46:	4298      	cmp	r0, r3
c0de1b48:	d301      	bcc.n	c0de1b4e <__clzsi2+0x22>
c0de1b4a:	0900      	lsrs	r0, r0, #4
c0de1b4c:	3904      	subs	r1, #4
c0de1b4e:	a202      	add	r2, pc, #8	; (adr r2, c0de1b58 <__clzsi2+0x2c>)
c0de1b50:	5c10      	ldrb	r0, [r2, r0]
c0de1b52:	1840      	adds	r0, r0, r1
c0de1b54:	4770      	bx	lr
c0de1b56:	46c0      	nop			; (mov r8, r8)
c0de1b58:	02020304 	.word	0x02020304
c0de1b5c:	01010101 	.word	0x01010101
	...

c0de1b68 <__aeabi_memclr>:
c0de1b68:	b510      	push	{r4, lr}
c0de1b6a:	2200      	movs	r2, #0
c0de1b6c:	f000 f80a 	bl	c0de1b84 <__aeabi_memset>
c0de1b70:	bd10      	pop	{r4, pc}
c0de1b72:	46c0      	nop			; (mov r8, r8)

c0de1b74 <__aeabi_memcpy>:
c0de1b74:	b510      	push	{r4, lr}
c0de1b76:	f000 f835 	bl	c0de1be4 <memcpy>
c0de1b7a:	bd10      	pop	{r4, pc}

c0de1b7c <__aeabi_memmove>:
c0de1b7c:	b510      	push	{r4, lr}
c0de1b7e:	f000 f885 	bl	c0de1c8c <memmove>
c0de1b82:	bd10      	pop	{r4, pc}

c0de1b84 <__aeabi_memset>:
c0de1b84:	0013      	movs	r3, r2
c0de1b86:	b510      	push	{r4, lr}
c0de1b88:	000a      	movs	r2, r1
c0de1b8a:	0019      	movs	r1, r3
c0de1b8c:	f000 f8dc 	bl	c0de1d48 <memset>
c0de1b90:	bd10      	pop	{r4, pc}
c0de1b92:	46c0      	nop			; (mov r8, r8)

c0de1b94 <memcmp>:
c0de1b94:	b530      	push	{r4, r5, lr}
c0de1b96:	2a03      	cmp	r2, #3
c0de1b98:	d90c      	bls.n	c0de1bb4 <memcmp+0x20>
c0de1b9a:	0003      	movs	r3, r0
c0de1b9c:	430b      	orrs	r3, r1
c0de1b9e:	079b      	lsls	r3, r3, #30
c0de1ba0:	d11c      	bne.n	c0de1bdc <memcmp+0x48>
c0de1ba2:	6803      	ldr	r3, [r0, #0]
c0de1ba4:	680c      	ldr	r4, [r1, #0]
c0de1ba6:	42a3      	cmp	r3, r4
c0de1ba8:	d118      	bne.n	c0de1bdc <memcmp+0x48>
c0de1baa:	3a04      	subs	r2, #4
c0de1bac:	3004      	adds	r0, #4
c0de1bae:	3104      	adds	r1, #4
c0de1bb0:	2a03      	cmp	r2, #3
c0de1bb2:	d8f6      	bhi.n	c0de1ba2 <memcmp+0xe>
c0de1bb4:	1e55      	subs	r5, r2, #1
c0de1bb6:	2a00      	cmp	r2, #0
c0de1bb8:	d00e      	beq.n	c0de1bd8 <memcmp+0x44>
c0de1bba:	7802      	ldrb	r2, [r0, #0]
c0de1bbc:	780c      	ldrb	r4, [r1, #0]
c0de1bbe:	4294      	cmp	r4, r2
c0de1bc0:	d10e      	bne.n	c0de1be0 <memcmp+0x4c>
c0de1bc2:	3501      	adds	r5, #1
c0de1bc4:	2301      	movs	r3, #1
c0de1bc6:	3901      	subs	r1, #1
c0de1bc8:	e004      	b.n	c0de1bd4 <memcmp+0x40>
c0de1bca:	5cc2      	ldrb	r2, [r0, r3]
c0de1bcc:	3301      	adds	r3, #1
c0de1bce:	5ccc      	ldrb	r4, [r1, r3]
c0de1bd0:	42a2      	cmp	r2, r4
c0de1bd2:	d105      	bne.n	c0de1be0 <memcmp+0x4c>
c0de1bd4:	42ab      	cmp	r3, r5
c0de1bd6:	d1f8      	bne.n	c0de1bca <memcmp+0x36>
c0de1bd8:	2000      	movs	r0, #0
c0de1bda:	bd30      	pop	{r4, r5, pc}
c0de1bdc:	1e55      	subs	r5, r2, #1
c0de1bde:	e7ec      	b.n	c0de1bba <memcmp+0x26>
c0de1be0:	1b10      	subs	r0, r2, r4
c0de1be2:	e7fa      	b.n	c0de1bda <memcmp+0x46>

c0de1be4 <memcpy>:
c0de1be4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1be6:	46c6      	mov	lr, r8
c0de1be8:	b500      	push	{lr}
c0de1bea:	2a0f      	cmp	r2, #15
c0de1bec:	d943      	bls.n	c0de1c76 <memcpy+0x92>
c0de1bee:	000b      	movs	r3, r1
c0de1bf0:	2603      	movs	r6, #3
c0de1bf2:	4303      	orrs	r3, r0
c0de1bf4:	401e      	ands	r6, r3
c0de1bf6:	000c      	movs	r4, r1
c0de1bf8:	0003      	movs	r3, r0
c0de1bfa:	2e00      	cmp	r6, #0
c0de1bfc:	d140      	bne.n	c0de1c80 <memcpy+0x9c>
c0de1bfe:	0015      	movs	r5, r2
c0de1c00:	3d10      	subs	r5, #16
c0de1c02:	092d      	lsrs	r5, r5, #4
c0de1c04:	46ac      	mov	ip, r5
c0de1c06:	012d      	lsls	r5, r5, #4
c0de1c08:	46a8      	mov	r8, r5
c0de1c0a:	4480      	add	r8, r0
c0de1c0c:	e000      	b.n	c0de1c10 <memcpy+0x2c>
c0de1c0e:	003b      	movs	r3, r7
c0de1c10:	6867      	ldr	r7, [r4, #4]
c0de1c12:	6825      	ldr	r5, [r4, #0]
c0de1c14:	605f      	str	r7, [r3, #4]
c0de1c16:	68e7      	ldr	r7, [r4, #12]
c0de1c18:	601d      	str	r5, [r3, #0]
c0de1c1a:	60df      	str	r7, [r3, #12]
c0de1c1c:	001f      	movs	r7, r3
c0de1c1e:	68a5      	ldr	r5, [r4, #8]
c0de1c20:	3710      	adds	r7, #16
c0de1c22:	609d      	str	r5, [r3, #8]
c0de1c24:	3410      	adds	r4, #16
c0de1c26:	4543      	cmp	r3, r8
c0de1c28:	d1f1      	bne.n	c0de1c0e <memcpy+0x2a>
c0de1c2a:	4665      	mov	r5, ip
c0de1c2c:	230f      	movs	r3, #15
c0de1c2e:	240c      	movs	r4, #12
c0de1c30:	3501      	adds	r5, #1
c0de1c32:	012d      	lsls	r5, r5, #4
c0de1c34:	1949      	adds	r1, r1, r5
c0de1c36:	4013      	ands	r3, r2
c0de1c38:	1945      	adds	r5, r0, r5
c0de1c3a:	4214      	tst	r4, r2
c0de1c3c:	d023      	beq.n	c0de1c86 <memcpy+0xa2>
c0de1c3e:	598c      	ldr	r4, [r1, r6]
c0de1c40:	51ac      	str	r4, [r5, r6]
c0de1c42:	3604      	adds	r6, #4
c0de1c44:	1b9c      	subs	r4, r3, r6
c0de1c46:	2c03      	cmp	r4, #3
c0de1c48:	d8f9      	bhi.n	c0de1c3e <memcpy+0x5a>
c0de1c4a:	2403      	movs	r4, #3
c0de1c4c:	3b04      	subs	r3, #4
c0de1c4e:	089b      	lsrs	r3, r3, #2
c0de1c50:	3301      	adds	r3, #1
c0de1c52:	009b      	lsls	r3, r3, #2
c0de1c54:	4022      	ands	r2, r4
c0de1c56:	18ed      	adds	r5, r5, r3
c0de1c58:	18c9      	adds	r1, r1, r3
c0de1c5a:	1e56      	subs	r6, r2, #1
c0de1c5c:	2a00      	cmp	r2, #0
c0de1c5e:	d007      	beq.n	c0de1c70 <memcpy+0x8c>
c0de1c60:	2300      	movs	r3, #0
c0de1c62:	e000      	b.n	c0de1c66 <memcpy+0x82>
c0de1c64:	0023      	movs	r3, r4
c0de1c66:	5cca      	ldrb	r2, [r1, r3]
c0de1c68:	1c5c      	adds	r4, r3, #1
c0de1c6a:	54ea      	strb	r2, [r5, r3]
c0de1c6c:	429e      	cmp	r6, r3
c0de1c6e:	d1f9      	bne.n	c0de1c64 <memcpy+0x80>
c0de1c70:	bc04      	pop	{r2}
c0de1c72:	4690      	mov	r8, r2
c0de1c74:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1c76:	0005      	movs	r5, r0
c0de1c78:	1e56      	subs	r6, r2, #1
c0de1c7a:	2a00      	cmp	r2, #0
c0de1c7c:	d1f0      	bne.n	c0de1c60 <memcpy+0x7c>
c0de1c7e:	e7f7      	b.n	c0de1c70 <memcpy+0x8c>
c0de1c80:	1e56      	subs	r6, r2, #1
c0de1c82:	0005      	movs	r5, r0
c0de1c84:	e7ec      	b.n	c0de1c60 <memcpy+0x7c>
c0de1c86:	001a      	movs	r2, r3
c0de1c88:	e7f6      	b.n	c0de1c78 <memcpy+0x94>
c0de1c8a:	46c0      	nop			; (mov r8, r8)

c0de1c8c <memmove>:
c0de1c8c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1c8e:	46c6      	mov	lr, r8
c0de1c90:	b500      	push	{lr}
c0de1c92:	4288      	cmp	r0, r1
c0de1c94:	d90c      	bls.n	c0de1cb0 <memmove+0x24>
c0de1c96:	188b      	adds	r3, r1, r2
c0de1c98:	4298      	cmp	r0, r3
c0de1c9a:	d209      	bcs.n	c0de1cb0 <memmove+0x24>
c0de1c9c:	1e53      	subs	r3, r2, #1
c0de1c9e:	2a00      	cmp	r2, #0
c0de1ca0:	d003      	beq.n	c0de1caa <memmove+0x1e>
c0de1ca2:	5cca      	ldrb	r2, [r1, r3]
c0de1ca4:	54c2      	strb	r2, [r0, r3]
c0de1ca6:	3b01      	subs	r3, #1
c0de1ca8:	d2fb      	bcs.n	c0de1ca2 <memmove+0x16>
c0de1caa:	bc04      	pop	{r2}
c0de1cac:	4690      	mov	r8, r2
c0de1cae:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1cb0:	2a0f      	cmp	r2, #15
c0de1cb2:	d80c      	bhi.n	c0de1cce <memmove+0x42>
c0de1cb4:	0005      	movs	r5, r0
c0de1cb6:	1e56      	subs	r6, r2, #1
c0de1cb8:	2a00      	cmp	r2, #0
c0de1cba:	d0f6      	beq.n	c0de1caa <memmove+0x1e>
c0de1cbc:	2300      	movs	r3, #0
c0de1cbe:	e000      	b.n	c0de1cc2 <memmove+0x36>
c0de1cc0:	0023      	movs	r3, r4
c0de1cc2:	5cca      	ldrb	r2, [r1, r3]
c0de1cc4:	1c5c      	adds	r4, r3, #1
c0de1cc6:	54ea      	strb	r2, [r5, r3]
c0de1cc8:	429e      	cmp	r6, r3
c0de1cca:	d1f9      	bne.n	c0de1cc0 <memmove+0x34>
c0de1ccc:	e7ed      	b.n	c0de1caa <memmove+0x1e>
c0de1cce:	000b      	movs	r3, r1
c0de1cd0:	2603      	movs	r6, #3
c0de1cd2:	4303      	orrs	r3, r0
c0de1cd4:	401e      	ands	r6, r3
c0de1cd6:	000c      	movs	r4, r1
c0de1cd8:	0003      	movs	r3, r0
c0de1cda:	2e00      	cmp	r6, #0
c0de1cdc:	d12e      	bne.n	c0de1d3c <memmove+0xb0>
c0de1cde:	0015      	movs	r5, r2
c0de1ce0:	3d10      	subs	r5, #16
c0de1ce2:	092d      	lsrs	r5, r5, #4
c0de1ce4:	46ac      	mov	ip, r5
c0de1ce6:	012d      	lsls	r5, r5, #4
c0de1ce8:	46a8      	mov	r8, r5
c0de1cea:	4480      	add	r8, r0
c0de1cec:	e000      	b.n	c0de1cf0 <memmove+0x64>
c0de1cee:	002b      	movs	r3, r5
c0de1cf0:	001d      	movs	r5, r3
c0de1cf2:	6827      	ldr	r7, [r4, #0]
c0de1cf4:	3510      	adds	r5, #16
c0de1cf6:	601f      	str	r7, [r3, #0]
c0de1cf8:	6867      	ldr	r7, [r4, #4]
c0de1cfa:	605f      	str	r7, [r3, #4]
c0de1cfc:	68a7      	ldr	r7, [r4, #8]
c0de1cfe:	609f      	str	r7, [r3, #8]
c0de1d00:	68e7      	ldr	r7, [r4, #12]
c0de1d02:	3410      	adds	r4, #16
c0de1d04:	60df      	str	r7, [r3, #12]
c0de1d06:	4543      	cmp	r3, r8
c0de1d08:	d1f1      	bne.n	c0de1cee <memmove+0x62>
c0de1d0a:	4665      	mov	r5, ip
c0de1d0c:	230f      	movs	r3, #15
c0de1d0e:	240c      	movs	r4, #12
c0de1d10:	3501      	adds	r5, #1
c0de1d12:	012d      	lsls	r5, r5, #4
c0de1d14:	1949      	adds	r1, r1, r5
c0de1d16:	4013      	ands	r3, r2
c0de1d18:	1945      	adds	r5, r0, r5
c0de1d1a:	4214      	tst	r4, r2
c0de1d1c:	d011      	beq.n	c0de1d42 <memmove+0xb6>
c0de1d1e:	598c      	ldr	r4, [r1, r6]
c0de1d20:	51ac      	str	r4, [r5, r6]
c0de1d22:	3604      	adds	r6, #4
c0de1d24:	1b9c      	subs	r4, r3, r6
c0de1d26:	2c03      	cmp	r4, #3
c0de1d28:	d8f9      	bhi.n	c0de1d1e <memmove+0x92>
c0de1d2a:	2403      	movs	r4, #3
c0de1d2c:	3b04      	subs	r3, #4
c0de1d2e:	089b      	lsrs	r3, r3, #2
c0de1d30:	3301      	adds	r3, #1
c0de1d32:	009b      	lsls	r3, r3, #2
c0de1d34:	18ed      	adds	r5, r5, r3
c0de1d36:	18c9      	adds	r1, r1, r3
c0de1d38:	4022      	ands	r2, r4
c0de1d3a:	e7bc      	b.n	c0de1cb6 <memmove+0x2a>
c0de1d3c:	1e56      	subs	r6, r2, #1
c0de1d3e:	0005      	movs	r5, r0
c0de1d40:	e7bc      	b.n	c0de1cbc <memmove+0x30>
c0de1d42:	001a      	movs	r2, r3
c0de1d44:	e7b7      	b.n	c0de1cb6 <memmove+0x2a>
c0de1d46:	46c0      	nop			; (mov r8, r8)

c0de1d48 <memset>:
c0de1d48:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1d4a:	0005      	movs	r5, r0
c0de1d4c:	0783      	lsls	r3, r0, #30
c0de1d4e:	d04a      	beq.n	c0de1de6 <memset+0x9e>
c0de1d50:	1e54      	subs	r4, r2, #1
c0de1d52:	2a00      	cmp	r2, #0
c0de1d54:	d044      	beq.n	c0de1de0 <memset+0x98>
c0de1d56:	b2ce      	uxtb	r6, r1
c0de1d58:	0003      	movs	r3, r0
c0de1d5a:	2203      	movs	r2, #3
c0de1d5c:	e002      	b.n	c0de1d64 <memset+0x1c>
c0de1d5e:	3501      	adds	r5, #1
c0de1d60:	3c01      	subs	r4, #1
c0de1d62:	d33d      	bcc.n	c0de1de0 <memset+0x98>
c0de1d64:	3301      	adds	r3, #1
c0de1d66:	702e      	strb	r6, [r5, #0]
c0de1d68:	4213      	tst	r3, r2
c0de1d6a:	d1f8      	bne.n	c0de1d5e <memset+0x16>
c0de1d6c:	2c03      	cmp	r4, #3
c0de1d6e:	d92f      	bls.n	c0de1dd0 <memset+0x88>
c0de1d70:	22ff      	movs	r2, #255	; 0xff
c0de1d72:	400a      	ands	r2, r1
c0de1d74:	0215      	lsls	r5, r2, #8
c0de1d76:	4315      	orrs	r5, r2
c0de1d78:	042a      	lsls	r2, r5, #16
c0de1d7a:	4315      	orrs	r5, r2
c0de1d7c:	2c0f      	cmp	r4, #15
c0de1d7e:	d935      	bls.n	c0de1dec <memset+0xa4>
c0de1d80:	0027      	movs	r7, r4
c0de1d82:	3f10      	subs	r7, #16
c0de1d84:	093f      	lsrs	r7, r7, #4
c0de1d86:	013e      	lsls	r6, r7, #4
c0de1d88:	46b4      	mov	ip, r6
c0de1d8a:	001e      	movs	r6, r3
c0de1d8c:	001a      	movs	r2, r3
c0de1d8e:	3610      	adds	r6, #16
c0de1d90:	4466      	add	r6, ip
c0de1d92:	6015      	str	r5, [r2, #0]
c0de1d94:	6055      	str	r5, [r2, #4]
c0de1d96:	6095      	str	r5, [r2, #8]
c0de1d98:	60d5      	str	r5, [r2, #12]
c0de1d9a:	3210      	adds	r2, #16
c0de1d9c:	42b2      	cmp	r2, r6
c0de1d9e:	d1f8      	bne.n	c0de1d92 <memset+0x4a>
c0de1da0:	260f      	movs	r6, #15
c0de1da2:	220c      	movs	r2, #12
c0de1da4:	3701      	adds	r7, #1
c0de1da6:	013f      	lsls	r7, r7, #4
c0de1da8:	4026      	ands	r6, r4
c0de1daa:	19db      	adds	r3, r3, r7
c0de1dac:	0037      	movs	r7, r6
c0de1dae:	4222      	tst	r2, r4
c0de1db0:	d017      	beq.n	c0de1de2 <memset+0x9a>
c0de1db2:	1f3e      	subs	r6, r7, #4
c0de1db4:	08b6      	lsrs	r6, r6, #2
c0de1db6:	00b4      	lsls	r4, r6, #2
c0de1db8:	46a4      	mov	ip, r4
c0de1dba:	001a      	movs	r2, r3
c0de1dbc:	1d1c      	adds	r4, r3, #4
c0de1dbe:	4464      	add	r4, ip
c0de1dc0:	c220      	stmia	r2!, {r5}
c0de1dc2:	42a2      	cmp	r2, r4
c0de1dc4:	d1fc      	bne.n	c0de1dc0 <memset+0x78>
c0de1dc6:	2403      	movs	r4, #3
c0de1dc8:	3601      	adds	r6, #1
c0de1dca:	00b6      	lsls	r6, r6, #2
c0de1dcc:	199b      	adds	r3, r3, r6
c0de1dce:	403c      	ands	r4, r7
c0de1dd0:	2c00      	cmp	r4, #0
c0de1dd2:	d005      	beq.n	c0de1de0 <memset+0x98>
c0de1dd4:	b2c9      	uxtb	r1, r1
c0de1dd6:	191c      	adds	r4, r3, r4
c0de1dd8:	7019      	strb	r1, [r3, #0]
c0de1dda:	3301      	adds	r3, #1
c0de1ddc:	429c      	cmp	r4, r3
c0de1dde:	d1fb      	bne.n	c0de1dd8 <memset+0x90>
c0de1de0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1de2:	0034      	movs	r4, r6
c0de1de4:	e7f4      	b.n	c0de1dd0 <memset+0x88>
c0de1de6:	0014      	movs	r4, r2
c0de1de8:	0003      	movs	r3, r0
c0de1dea:	e7bf      	b.n	c0de1d6c <memset+0x24>
c0de1dec:	0027      	movs	r7, r4
c0de1dee:	e7e0      	b.n	c0de1db2 <memset+0x6a>

c0de1df0 <setjmp>:
c0de1df0:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de1df2:	4641      	mov	r1, r8
c0de1df4:	464a      	mov	r2, r9
c0de1df6:	4653      	mov	r3, sl
c0de1df8:	465c      	mov	r4, fp
c0de1dfa:	466d      	mov	r5, sp
c0de1dfc:	4676      	mov	r6, lr
c0de1dfe:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de1e00:	3828      	subs	r0, #40	; 0x28
c0de1e02:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de1e04:	2000      	movs	r0, #0
c0de1e06:	4770      	bx	lr

c0de1e08 <longjmp>:
c0de1e08:	3010      	adds	r0, #16
c0de1e0a:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de1e0c:	4690      	mov	r8, r2
c0de1e0e:	4699      	mov	r9, r3
c0de1e10:	46a2      	mov	sl, r4
c0de1e12:	46ab      	mov	fp, r5
c0de1e14:	46b5      	mov	sp, r6
c0de1e16:	c808      	ldmia	r0!, {r3}
c0de1e18:	3828      	subs	r0, #40	; 0x28
c0de1e1a:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de1e1c:	1c08      	adds	r0, r1, #0
c0de1e1e:	d100      	bne.n	c0de1e22 <longjmp+0x1a>
c0de1e20:	2001      	movs	r0, #1
c0de1e22:	4718      	bx	r3

c0de1e24 <strlcat>:
c0de1e24:	b570      	push	{r4, r5, r6, lr}
c0de1e26:	2a00      	cmp	r2, #0
c0de1e28:	d02a      	beq.n	c0de1e80 <strlcat+0x5c>
c0de1e2a:	7803      	ldrb	r3, [r0, #0]
c0de1e2c:	2b00      	cmp	r3, #0
c0de1e2e:	d029      	beq.n	c0de1e84 <strlcat+0x60>
c0de1e30:	1884      	adds	r4, r0, r2
c0de1e32:	0003      	movs	r3, r0
c0de1e34:	e002      	b.n	c0de1e3c <strlcat+0x18>
c0de1e36:	781d      	ldrb	r5, [r3, #0]
c0de1e38:	2d00      	cmp	r5, #0
c0de1e3a:	d018      	beq.n	c0de1e6e <strlcat+0x4a>
c0de1e3c:	3301      	adds	r3, #1
c0de1e3e:	42a3      	cmp	r3, r4
c0de1e40:	d1f9      	bne.n	c0de1e36 <strlcat+0x12>
c0de1e42:	1a26      	subs	r6, r4, r0
c0de1e44:	1b92      	subs	r2, r2, r6
c0de1e46:	d016      	beq.n	c0de1e76 <strlcat+0x52>
c0de1e48:	780d      	ldrb	r5, [r1, #0]
c0de1e4a:	000b      	movs	r3, r1
c0de1e4c:	2d00      	cmp	r5, #0
c0de1e4e:	d00a      	beq.n	c0de1e66 <strlcat+0x42>
c0de1e50:	2a01      	cmp	r2, #1
c0de1e52:	d002      	beq.n	c0de1e5a <strlcat+0x36>
c0de1e54:	7025      	strb	r5, [r4, #0]
c0de1e56:	3a01      	subs	r2, #1
c0de1e58:	3401      	adds	r4, #1
c0de1e5a:	3301      	adds	r3, #1
c0de1e5c:	781d      	ldrb	r5, [r3, #0]
c0de1e5e:	2d00      	cmp	r5, #0
c0de1e60:	d1f6      	bne.n	c0de1e50 <strlcat+0x2c>
c0de1e62:	1a5b      	subs	r3, r3, r1
c0de1e64:	18f6      	adds	r6, r6, r3
c0de1e66:	2300      	movs	r3, #0
c0de1e68:	7023      	strb	r3, [r4, #0]
c0de1e6a:	0030      	movs	r0, r6
c0de1e6c:	bd70      	pop	{r4, r5, r6, pc}
c0de1e6e:	001c      	movs	r4, r3
c0de1e70:	1a26      	subs	r6, r4, r0
c0de1e72:	1b92      	subs	r2, r2, r6
c0de1e74:	d1e8      	bne.n	c0de1e48 <strlcat+0x24>
c0de1e76:	0008      	movs	r0, r1
c0de1e78:	f000 f82e 	bl	c0de1ed8 <strlen>
c0de1e7c:	1836      	adds	r6, r6, r0
c0de1e7e:	e7f4      	b.n	c0de1e6a <strlcat+0x46>
c0de1e80:	2600      	movs	r6, #0
c0de1e82:	e7f8      	b.n	c0de1e76 <strlcat+0x52>
c0de1e84:	0004      	movs	r4, r0
c0de1e86:	2600      	movs	r6, #0
c0de1e88:	e7de      	b.n	c0de1e48 <strlcat+0x24>
c0de1e8a:	46c0      	nop			; (mov r8, r8)

c0de1e8c <strlcpy>:
c0de1e8c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1e8e:	2a00      	cmp	r2, #0
c0de1e90:	d013      	beq.n	c0de1eba <strlcpy+0x2e>
c0de1e92:	3a01      	subs	r2, #1
c0de1e94:	2a00      	cmp	r2, #0
c0de1e96:	d019      	beq.n	c0de1ecc <strlcpy+0x40>
c0de1e98:	2300      	movs	r3, #0
c0de1e9a:	1c4f      	adds	r7, r1, #1
c0de1e9c:	1c46      	adds	r6, r0, #1
c0de1e9e:	e002      	b.n	c0de1ea6 <strlcpy+0x1a>
c0de1ea0:	3301      	adds	r3, #1
c0de1ea2:	429a      	cmp	r2, r3
c0de1ea4:	d016      	beq.n	c0de1ed4 <strlcpy+0x48>
c0de1ea6:	18f5      	adds	r5, r6, r3
c0de1ea8:	46ac      	mov	ip, r5
c0de1eaa:	5ccd      	ldrb	r5, [r1, r3]
c0de1eac:	18fc      	adds	r4, r7, r3
c0de1eae:	54c5      	strb	r5, [r0, r3]
c0de1eb0:	2d00      	cmp	r5, #0
c0de1eb2:	d1f5      	bne.n	c0de1ea0 <strlcpy+0x14>
c0de1eb4:	1a60      	subs	r0, r4, r1
c0de1eb6:	3801      	subs	r0, #1
c0de1eb8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1eba:	000c      	movs	r4, r1
c0de1ebc:	0023      	movs	r3, r4
c0de1ebe:	3301      	adds	r3, #1
c0de1ec0:	1e5a      	subs	r2, r3, #1
c0de1ec2:	7812      	ldrb	r2, [r2, #0]
c0de1ec4:	001c      	movs	r4, r3
c0de1ec6:	2a00      	cmp	r2, #0
c0de1ec8:	d1f9      	bne.n	c0de1ebe <strlcpy+0x32>
c0de1eca:	e7f3      	b.n	c0de1eb4 <strlcpy+0x28>
c0de1ecc:	000c      	movs	r4, r1
c0de1ece:	2300      	movs	r3, #0
c0de1ed0:	7003      	strb	r3, [r0, #0]
c0de1ed2:	e7f3      	b.n	c0de1ebc <strlcpy+0x30>
c0de1ed4:	4660      	mov	r0, ip
c0de1ed6:	e7fa      	b.n	c0de1ece <strlcpy+0x42>

c0de1ed8 <strlen>:
c0de1ed8:	b510      	push	{r4, lr}
c0de1eda:	0783      	lsls	r3, r0, #30
c0de1edc:	d027      	beq.n	c0de1f2e <strlen+0x56>
c0de1ede:	7803      	ldrb	r3, [r0, #0]
c0de1ee0:	2b00      	cmp	r3, #0
c0de1ee2:	d026      	beq.n	c0de1f32 <strlen+0x5a>
c0de1ee4:	0003      	movs	r3, r0
c0de1ee6:	2103      	movs	r1, #3
c0de1ee8:	e002      	b.n	c0de1ef0 <strlen+0x18>
c0de1eea:	781a      	ldrb	r2, [r3, #0]
c0de1eec:	2a00      	cmp	r2, #0
c0de1eee:	d01c      	beq.n	c0de1f2a <strlen+0x52>
c0de1ef0:	3301      	adds	r3, #1
c0de1ef2:	420b      	tst	r3, r1
c0de1ef4:	d1f9      	bne.n	c0de1eea <strlen+0x12>
c0de1ef6:	6819      	ldr	r1, [r3, #0]
c0de1ef8:	4a0f      	ldr	r2, [pc, #60]	; (c0de1f38 <strlen+0x60>)
c0de1efa:	4c10      	ldr	r4, [pc, #64]	; (c0de1f3c <strlen+0x64>)
c0de1efc:	188a      	adds	r2, r1, r2
c0de1efe:	438a      	bics	r2, r1
c0de1f00:	4222      	tst	r2, r4
c0de1f02:	d10f      	bne.n	c0de1f24 <strlen+0x4c>
c0de1f04:	3304      	adds	r3, #4
c0de1f06:	6819      	ldr	r1, [r3, #0]
c0de1f08:	4a0b      	ldr	r2, [pc, #44]	; (c0de1f38 <strlen+0x60>)
c0de1f0a:	188a      	adds	r2, r1, r2
c0de1f0c:	438a      	bics	r2, r1
c0de1f0e:	4222      	tst	r2, r4
c0de1f10:	d108      	bne.n	c0de1f24 <strlen+0x4c>
c0de1f12:	3304      	adds	r3, #4
c0de1f14:	6819      	ldr	r1, [r3, #0]
c0de1f16:	4a08      	ldr	r2, [pc, #32]	; (c0de1f38 <strlen+0x60>)
c0de1f18:	188a      	adds	r2, r1, r2
c0de1f1a:	438a      	bics	r2, r1
c0de1f1c:	4222      	tst	r2, r4
c0de1f1e:	d0f1      	beq.n	c0de1f04 <strlen+0x2c>
c0de1f20:	e000      	b.n	c0de1f24 <strlen+0x4c>
c0de1f22:	3301      	adds	r3, #1
c0de1f24:	781a      	ldrb	r2, [r3, #0]
c0de1f26:	2a00      	cmp	r2, #0
c0de1f28:	d1fb      	bne.n	c0de1f22 <strlen+0x4a>
c0de1f2a:	1a18      	subs	r0, r3, r0
c0de1f2c:	bd10      	pop	{r4, pc}
c0de1f2e:	0003      	movs	r3, r0
c0de1f30:	e7e1      	b.n	c0de1ef6 <strlen+0x1e>
c0de1f32:	2000      	movs	r0, #0
c0de1f34:	e7fa      	b.n	c0de1f2c <strlen+0x54>
c0de1f36:	46c0      	nop			; (mov r8, r8)
c0de1f38:	fefefeff 	.word	0xfefefeff
c0de1f3c:	80808080 	.word	0x80808080

c0de1f40 <strnlen>:
c0de1f40:	b510      	push	{r4, lr}
c0de1f42:	2900      	cmp	r1, #0
c0de1f44:	d00b      	beq.n	c0de1f5e <strnlen+0x1e>
c0de1f46:	7803      	ldrb	r3, [r0, #0]
c0de1f48:	2b00      	cmp	r3, #0
c0de1f4a:	d00c      	beq.n	c0de1f66 <strnlen+0x26>
c0de1f4c:	1844      	adds	r4, r0, r1
c0de1f4e:	0003      	movs	r3, r0
c0de1f50:	e002      	b.n	c0de1f58 <strnlen+0x18>
c0de1f52:	781a      	ldrb	r2, [r3, #0]
c0de1f54:	2a00      	cmp	r2, #0
c0de1f56:	d004      	beq.n	c0de1f62 <strnlen+0x22>
c0de1f58:	3301      	adds	r3, #1
c0de1f5a:	42a3      	cmp	r3, r4
c0de1f5c:	d1f9      	bne.n	c0de1f52 <strnlen+0x12>
c0de1f5e:	0008      	movs	r0, r1
c0de1f60:	bd10      	pop	{r4, pc}
c0de1f62:	1a19      	subs	r1, r3, r0
c0de1f64:	e7fb      	b.n	c0de1f5e <strnlen+0x1e>
c0de1f66:	2100      	movs	r1, #0
c0de1f68:	e7f9      	b.n	c0de1f5e <strnlen+0x1e>
c0de1f6a:	46c0      	nop			; (mov r8, r8)

c0de1f6c <_ecode>:
c0de1f6c:	4144      	adcs	r4, r0
c0de1f6e:	0049      	lsls	r1, r1, #1
c0de1f70:	6c50      	ldr	r0, [r2, #68]	; 0x44
c0de1f72:	6775      	str	r5, [r6, #116]	; 0x74
c0de1f74:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de1f76:	7020      	strb	r0, [r4, #0]
c0de1f78:	7261      	strb	r1, [r4, #9]
c0de1f7a:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de1f7c:	7465      	strb	r5, [r4, #17]
c0de1f7e:	7265      	strb	r5, [r4, #9]
c0de1f80:	2073      	movs	r0, #115	; 0x73
c0de1f82:	7473      	strb	r3, [r6, #17]
c0de1f84:	7572      	strb	r2, [r6, #21]
c0de1f86:	7463      	strb	r3, [r4, #17]
c0de1f88:	7275      	strb	r5, [r6, #9]
c0de1f8a:	2065      	movs	r0, #101	; 0x65
c0de1f8c:	7369      	strb	r1, [r5, #13]
c0de1f8e:	6220      	str	r0, [r4, #32]
c0de1f90:	6769      	str	r1, [r5, #116]	; 0x74
c0de1f92:	6567      	str	r7, [r4, #84]	; 0x54
c0de1f94:	2072      	movs	r0, #114	; 0x72
c0de1f96:	6874      	ldr	r4, [r6, #4]
c0de1f98:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de1f9a:	6120      	str	r0, [r4, #16]
c0de1f9c:	6c6c      	ldr	r4, [r5, #68]	; 0x44
c0de1f9e:	776f      	strb	r7, [r5, #29]
c0de1fa0:	6465      	str	r5, [r4, #68]	; 0x44
c0de1fa2:	7320      	strb	r0, [r4, #12]
c0de1fa4:	7a69      	ldrb	r1, [r5, #9]
c0de1fa6:	0a65      	lsrs	r5, r4, #9
c0de1fa8:	5300      	strh	r0, [r0, r4]
c0de1faa:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de1fac:	0064      	lsls	r4, r4, #1
c0de1fae:	4157      	adcs	r7, r2
c0de1fb0:	4e52      	ldr	r6, [pc, #328]	; (c0de20fc <_ecode+0x190>)
c0de1fb2:	4e49      	ldr	r6, [pc, #292]	; (c0de20d8 <_ecode+0x16c>)
c0de1fb4:	0047      	lsls	r7, r0, #1
c0de1fb6:	656f      	str	r7, [r5, #84]	; 0x54
c0de1fb8:	6874      	ldr	r4, [r6, #4]
c0de1fba:	7020      	strb	r0, [r4, #0]
c0de1fbc:	756c      	strb	r4, [r5, #21]
c0de1fbe:	6967      	ldr	r7, [r4, #20]
c0de1fc0:	206e      	movs	r0, #110	; 0x6e
c0de1fc2:	7270      	strb	r0, [r6, #9]
c0de1fc4:	766f      	strb	r7, [r5, #25]
c0de1fc6:	6469      	str	r1, [r5, #68]	; 0x44
c0de1fc8:	2065      	movs	r0, #101	; 0x65
c0de1fca:	6170      	str	r0, [r6, #20]
c0de1fcc:	6172      	str	r2, [r6, #20]
c0de1fce:	656d      	str	r5, [r5, #84]	; 0x54
c0de1fd0:	6574      	str	r4, [r6, #84]	; 0x54
c0de1fd2:	3a72      	subs	r2, #114	; 0x72
c0de1fd4:	0020      	movs	r0, r4
c0de1fd6:	0020      	movs	r0, r4
c0de1fd8:	6150      	str	r0, [r2, #20]
c0de1fda:	6172      	str	r2, [r6, #20]
c0de1fdc:	206d      	movs	r0, #109	; 0x6d
c0de1fde:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de1fe0:	2074      	movs	r0, #116	; 0x74
c0de1fe2:	7573      	strb	r3, [r6, #21]
c0de1fe4:	7070      	strb	r0, [r6, #1]
c0de1fe6:	726f      	strb	r7, [r5, #9]
c0de1fe8:	6574      	str	r4, [r6, #84]	; 0x54
c0de1fea:	0a64      	lsrs	r4, r4, #9
c0de1fec:	5400      	strb	r0, [r0, r0]
c0de1fee:	4b4f      	ldr	r3, [pc, #316]	; (c0de212c <HEXDIGITS+0xf>)
c0de1ff0:	4e45      	ldr	r6, [pc, #276]	; (c0de2108 <_ecode+0x19c>)
c0de1ff2:	5320      	strh	r0, [r4, r4]
c0de1ff4:	4e45      	ldr	r6, [pc, #276]	; (c0de210c <_ecode+0x1a0>)
c0de1ff6:	3a54      	subs	r2, #84	; 0x54
c0de1ff8:	0020      	movs	r0, r4
c0de1ffa:	454f      	cmp	r7, r9
c0de1ffc:	4854      	ldr	r0, [pc, #336]	; (c0de2150 <HEXDIGITS+0x33>)
c0de1ffe:	7020      	strb	r0, [r4, #0]
c0de2000:	756c      	strb	r4, [r5, #21]
c0de2002:	6967      	ldr	r7, [r4, #20]
c0de2004:	206e      	movs	r0, #110	; 0x6e
c0de2006:	7270      	strb	r0, [r6, #9]
c0de2008:	766f      	strb	r7, [r5, #25]
c0de200a:	6469      	str	r1, [r5, #68]	; 0x44
c0de200c:	2065      	movs	r0, #101	; 0x65
c0de200e:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de2010:	656b      	str	r3, [r5, #84]	; 0x54
c0de2012:	3a6e      	subs	r2, #110	; 0x6e
c0de2014:	3020      	adds	r0, #32
c0de2016:	2578      	movs	r5, #120	; 0x78
c0de2018:	2c70      	cmp	r4, #112	; 0x70
c0de201a:	3020      	adds	r0, #32
c0de201c:	2578      	movs	r5, #120	; 0x78
c0de201e:	0a70      	lsrs	r0, r6, #9
c0de2020:	4d00      	ldr	r5, [pc, #0]	; (c0de2024 <_ecode+0xb8>)
c0de2022:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de2024:	0074      	lsls	r4, r6, #1
c0de2026:	3025      	adds	r0, #37	; 0x25
c0de2028:	7832      	ldrb	r2, [r6, #0]
c0de202a:	5300      	strh	r0, [r0, r4]
c0de202c:	6177      	str	r7, [r6, #20]
c0de202e:	0070      	lsls	r0, r6, #1
c0de2030:	534c      	strh	r4, [r1, r5]
c0de2032:	2054      	movs	r0, #84	; 0x54
c0de2034:	494d      	ldr	r1, [pc, #308]	; (c0de216c <HEXDIGITS+0x4f>)
c0de2036:	0058      	lsls	r0, r3, #1
c0de2038:	4f54      	ldr	r7, [pc, #336]	; (c0de218c <HEXDIGITS+0x6f>)
c0de203a:	454b      	cmp	r3, r9
c0de203c:	204e      	movs	r0, #78	; 0x4e
c0de203e:	4552      	cmp	r2, sl
c0de2040:	4543      	cmp	r3, r8
c0de2042:	5649      	ldrsb	r1, [r1, r1]
c0de2044:	4445      	add	r5, r8
c0de2046:	203a      	movs	r0, #58	; 0x3a
c0de2048:	4f00      	ldr	r7, [pc, #0]	; (c0de204c <_ecode+0xe0>)
c0de204a:	5355      	strh	r5, [r2, r5]
c0de204c:	0044      	lsls	r4, r0, #1
c0de204e:	724f      	strb	r7, [r1, #9]
c0de2050:	6769      	str	r1, [r5, #116]	; 0x74
c0de2052:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de2054:	4420      	add	r0, r4
c0de2056:	4665      	mov	r5, ip
c0de2058:	0069      	lsls	r1, r5, #1
c0de205a:	6552      	str	r2, [r2, #84]	; 0x54
c0de205c:	6564      	str	r4, [r4, #84]	; 0x54
c0de205e:	6d65      	ldr	r5, [r4, #84]	; 0x54
c0de2060:	5500      	strb	r0, [r0, r4]
c0de2062:	4453      	add	r3, sl
c0de2064:	4d20      	ldr	r5, [pc, #128]	; (c0de20e8 <_ecode+0x17c>)
c0de2066:	5849      	ldr	r1, [r1, r1]
c0de2068:	4f00      	ldr	r7, [pc, #0]	; (c0de206c <_ecode+0x100>)
c0de206a:	4646      	mov	r6, r8
c0de206c:	4553      	cmp	r3, sl
c0de206e:	3a54      	subs	r2, #84	; 0x54
c0de2070:	2520      	movs	r5, #32
c0de2072:	0a64      	lsrs	r4, r4, #9
c0de2074:	5500      	strb	r0, [r0, r4]
c0de2076:	4453      	add	r3, sl
c0de2078:	0043      	lsls	r3, r0, #1
c0de207a:	7445      	strb	r5, [r0, #17]
c0de207c:	6568      	str	r0, [r5, #84]	; 0x54
c0de207e:	6572      	str	r2, [r6, #84]	; 0x54
c0de2080:	6d75      	ldr	r5, [r6, #84]	; 0x54
c0de2082:	4300      	orrs	r0, r0
c0de2084:	756f      	strb	r7, [r5, #21]
c0de2086:	746e      	strb	r6, [r5, #17]
c0de2088:	7265      	strb	r5, [r4, #9]
c0de208a:	203a      	movs	r0, #58	; 0x3a
c0de208c:	6425      	str	r5, [r4, #64]	; 0x40
c0de208e:	000a      	movs	r2, r1
c0de2090:	4542      	cmp	r2, r8
c0de2092:	454e      	cmp	r6, r9
c0de2094:	4946      	ldr	r1, [pc, #280]	; (c0de21b0 <HEXDIGITS+0x93>)
c0de2096:	4943      	ldr	r1, [pc, #268]	; (c0de21a4 <HEXDIGITS+0x87>)
c0de2098:	5241      	strh	r1, [r0, r1]
c0de209a:	3a59      	subs	r2, #89	; 0x59
c0de209c:	0020      	movs	r0, r4
c0de209e:	0030      	movs	r0, r6
c0de20a0:	6553      	str	r3, [r2, #84]	; 0x54
c0de20a2:	7474      	strb	r4, [r6, #17]
c0de20a4:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de20a6:	2067      	movs	r0, #103	; 0x67
c0de20a8:	6461      	str	r1, [r4, #68]	; 0x44
c0de20aa:	7264      	strb	r4, [r4, #9]
c0de20ac:	7365      	strb	r5, [r4, #13]
c0de20ae:	2073      	movs	r0, #115	; 0x73
c0de20b0:	6572      	str	r2, [r6, #84]	; 0x54
c0de20b2:	6563      	str	r3, [r4, #84]	; 0x54
c0de20b4:	7669      	strb	r1, [r5, #25]
c0de20b6:	6465      	str	r5, [r4, #68]	; 0x44
c0de20b8:	7420      	strb	r0, [r4, #16]
c0de20ba:	3a6f      	subs	r2, #111	; 0x6f
c0de20bc:	0020      	movs	r0, r4
c0de20be:	6150      	str	r0, [r2, #20]
c0de20c0:	6172      	str	r2, [r6, #20]
c0de20c2:	206d      	movs	r0, #109	; 0x6d
c0de20c4:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de20c6:	2074      	movs	r0, #116	; 0x74
c0de20c8:	7573      	strb	r3, [r6, #21]
c0de20ca:	7070      	strb	r0, [r6, #1]
c0de20cc:	726f      	strb	r7, [r5, #9]
c0de20ce:	6574      	str	r4, [r6, #84]	; 0x54
c0de20d0:	3a64      	subs	r2, #100	; 0x64
c0de20d2:	2520      	movs	r5, #32
c0de20d4:	0a64      	lsrs	r4, r4, #9
c0de20d6:	5200      	strh	r0, [r0, r0]
c0de20d8:	6365      	str	r5, [r4, #52]	; 0x34
c0de20da:	6965      	ldr	r5, [r4, #20]
c0de20dc:	6576      	str	r6, [r6, #84]	; 0x54
c0de20de:	4d20      	ldr	r5, [pc, #128]	; (c0de2160 <HEXDIGITS+0x43>)
c0de20e0:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de20e2:	4500      	cmp	r0, r0
c0de20e4:	6378      	str	r0, [r7, #52]	; 0x34
c0de20e6:	7065      	strb	r5, [r4, #1]
c0de20e8:	6974      	ldr	r4, [r6, #20]
c0de20ea:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de20ec:	3020      	adds	r0, #32
c0de20ee:	2578      	movs	r5, #120	; 0x78
c0de20f0:	2078      	movs	r0, #120	; 0x78
c0de20f2:	6163      	str	r3, [r4, #20]
c0de20f4:	6775      	str	r5, [r6, #116]	; 0x74
c0de20f6:	7468      	strb	r0, [r5, #17]
c0de20f8:	000a      	movs	r2, r1
c0de20fa:	4f54      	ldr	r7, [pc, #336]	; (c0de224c <HEXDIGITS+0x12f>)
c0de20fc:	454b      	cmp	r3, r9
c0de20fe:	5f4e      	ldrsh	r6, [r1, r5]
c0de2100:	4553      	cmp	r3, sl
c0de2102:	544e      	strb	r6, [r1, r1]
c0de2104:	203a      	movs	r0, #58	; 0x3a
c0de2106:	7300      	strb	r0, [r0, #12]
c0de2108:	7266      	strb	r6, [r4, #9]
c0de210a:	4578      	cmp	r0, pc
c0de210c:	4854      	ldr	r0, [pc, #336]	; (c0de2260 <HEXDIGITS+0x143>)
c0de210e:	5500      	strb	r0, [r0, r4]
c0de2110:	6b6e      	ldr	r6, [r5, #52]	; 0x34
c0de2112:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de2114:	6e77      	ldr	r7, [r6, #100]	; 0x64
c0de2116:	7420      	strb	r0, [r4, #16]
c0de2118:	6b6f      	ldr	r7, [r5, #52]	; 0x34
c0de211a:	6e65      	ldr	r5, [r4, #100]	; 0x64
	...

c0de211d <HEXDIGITS>:
c0de211d:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef
c0de212d:	6500 6378 7065 6974 6e6f 255b 5d64 203a     .exception[%d]: 
c0de213d:	524c 303d 2578 3830 0a58 4500 5252 524f     LR=0x%08X..ERROR
c0de214d:	3000 0078 6e55 6168 646e 656c 2064 656d     .0x.Unhandled me
c0de215d:	7373 6761 2065 6425 000a 6553 7474 6e69     ssage %d..Settin
c0de216d:	2067 6461 7264 7365 2073 6573 746e 7420     g address sent t
c0de217d:	3a6f 0020 6542 656e 6966 6963 7261 0079     o: .Beneficiary.
c0de218d:	000a 6552 6563 7669 6465 6120 206e 6e69     ..Received an in
c0de219d:	6176 696c 2064 6373 6572 6e65 6e49 6564     valid screenInde
c0de21ad:	0a78 4100 4f4d 4e55 2054 4553 544e 203a     x..AMOUNT SENT: 
c0de21bd:	7325 000a 5300 6c65 6365 6f74 2072 6e49     %s...Selector In
c0de21cd:	6564 2078 253a 2064 6f6e 2074 7573 7070     dex :%d not supp
c0de21dd:	726f 6574 0a64 5500 4453 0054 6e55 6168     orted..USDT.Unha
c0de21ed:	646e 656c 2064 6573 656c 7463 726f 4920     ndled selector I
c0de21fd:	646e 7865 203a 6425 000a 4e55 5449 0053     ndex: %d..UNITS.
c0de220d:	6544 6f70 6973 0074 694d 7373 6e69 2067     Deposit.Missing 
c0de221d:	6573 656c 7463 726f 6e49 6564 3a78 2520     selectorIndex: %
c0de222d:	0a64 5300 6c65 6365 6f74 2072 6e49 6564     d..Selector Inde
c0de223d:	2078 6425 6e20 746f 7320 7075 6f70 7472     x %d not support
c0de224d:	6465 000a 454f 4854 4100 4f4d 4e55 2054     ed..OETH.AMOUNT 
c0de225d:	4552 4543 5649 4445 203a 7325 000a           RECEIVED: %s...

c0de226c <ORIGIN_DEFI_SELECTORS>:
c0de226c:	0db0 d0e3 e97d d443 29f6 156e 2373 7cbc     ....}.C..)n.s#.|
c0de227c:	2124 3df0 7ed6 a641 a424 353c 8d59 c04b     $!.=.~A.$.<5Y.K.
c0de228c:	f389 414b 0b96 35aa 9053 cb93 c746 5981     ..KA...5S...F..Y
c0de229c:	5a0f 8a09 1ffd bfc1 8169 c6b6               .Z......i...

c0de22a8 <OETH_ADDRESS>:
c0de22a8:	6c85 fb4e c176 aed1 e202 eb0c a203 a0a6     .lN.v...........
c0de22b8:	0b8b c38d                                   ....

c0de22bc <OUSD_ADDRESS>:
c0de22bc:	8e2a 671e c26e d838 92a9 7b30 5b49 b345     *..gn.8...0{I[E.
c0de22cc:	aafe 865e                                   ..^.

c0de22d0 <DAI_ADDRESS>:
c0de22d0:	176b 7454 90e8 c494 a94d 958b ed4e c4ea     k.Tt....M...N...
c0de22e0:	2795 0f1d                                   .'..

c0de22e4 <USDC_ADDRESS>:
c0de22e4:	b8a0 9169 21c6 368b d1c1 4a9d 9e2e ceb0     ..i..!.6...J....
c0de22f4:	0636 48eb                                   6..H

c0de22f8 <USDT_ADDRESS>:
c0de22f8:	c1da 957f 2e8d 23e5 20a2 0662 4599 c197     .......#. b..E..
c0de2308:	833d c71e                                   =...

c0de230c <OETH_VAULT_ADDRESS>:
c0de230c:	2539 3340 5a94 e4a2 9c80 97c2 707e be87     9%@3.Z......~p..
c0de231c:	8be4 abd7                                   ....

c0de2320 <CURVE_OETH_POOL_ADDRESS>:
c0de2320:	b194 7674 3ba9 6232 7bd8 329a 6569 e9d1     ..tv.;2b.{.2ie..
c0de2330:	9c1f e713                                   ....

c0de2334 <CURVE_OUSD_POOL_ADDRESS>:
c0de2334:	6587 7b0d c3bf f1a9 8705 77d7 0682 1767     .e.{.......w..g.
c0de2344:	d919 0d91                                   ....

c0de2348 <g_pcHex>:
c0de2348:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de2358 <g_pcHex_cap>:
c0de2358:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de2368 <NULL_ETH_ADDRESS>:
	...

c0de237c <_etext>:
c0de237c:	d4d4      	bmi.n	c0de2328 <CURVE_OETH_POOL_ADDRESS+0x8>
c0de237e:	d4d4      	bmi.n	c0de232a <CURVE_OETH_POOL_ADDRESS+0xa>
c0de2380:	d4d4      	bmi.n	c0de232c <CURVE_OETH_POOL_ADDRESS+0xc>
c0de2382:	d4d4      	bmi.n	c0de232e <CURVE_OETH_POOL_ADDRESS+0xe>
c0de2384:	d4d4      	bmi.n	c0de2330 <CURVE_OETH_POOL_ADDRESS+0x10>
c0de2386:	d4d4      	bmi.n	c0de2332 <CURVE_OETH_POOL_ADDRESS+0x12>
c0de2388:	d4d4      	bmi.n	c0de2334 <CURVE_OUSD_POOL_ADDRESS>
c0de238a:	d4d4      	bmi.n	c0de2336 <CURVE_OUSD_POOL_ADDRESS+0x2>
c0de238c:	d4d4      	bmi.n	c0de2338 <CURVE_OUSD_POOL_ADDRESS+0x4>
c0de238e:	d4d4      	bmi.n	c0de233a <CURVE_OUSD_POOL_ADDRESS+0x6>
c0de2390:	d4d4      	bmi.n	c0de233c <CURVE_OUSD_POOL_ADDRESS+0x8>
c0de2392:	d4d4      	bmi.n	c0de233e <CURVE_OUSD_POOL_ADDRESS+0xa>
c0de2394:	d4d4      	bmi.n	c0de2340 <CURVE_OUSD_POOL_ADDRESS+0xc>
c0de2396:	d4d4      	bmi.n	c0de2342 <CURVE_OUSD_POOL_ADDRESS+0xe>
c0de2398:	d4d4      	bmi.n	c0de2344 <CURVE_OUSD_POOL_ADDRESS+0x10>
c0de239a:	d4d4      	bmi.n	c0de2346 <CURVE_OUSD_POOL_ADDRESS+0x12>
c0de239c:	d4d4      	bmi.n	c0de2348 <g_pcHex>
c0de239e:	d4d4      	bmi.n	c0de234a <g_pcHex+0x2>
c0de23a0:	d4d4      	bmi.n	c0de234c <g_pcHex+0x4>
c0de23a2:	d4d4      	bmi.n	c0de234e <g_pcHex+0x6>
c0de23a4:	d4d4      	bmi.n	c0de2350 <g_pcHex+0x8>
c0de23a6:	d4d4      	bmi.n	c0de2352 <g_pcHex+0xa>
c0de23a8:	d4d4      	bmi.n	c0de2354 <g_pcHex+0xc>
c0de23aa:	d4d4      	bmi.n	c0de2356 <g_pcHex+0xe>
c0de23ac:	d4d4      	bmi.n	c0de2358 <g_pcHex_cap>
c0de23ae:	d4d4      	bmi.n	c0de235a <g_pcHex_cap+0x2>
c0de23b0:	d4d4      	bmi.n	c0de235c <g_pcHex_cap+0x4>
c0de23b2:	d4d4      	bmi.n	c0de235e <g_pcHex_cap+0x6>
c0de23b4:	d4d4      	bmi.n	c0de2360 <g_pcHex_cap+0x8>
c0de23b6:	d4d4      	bmi.n	c0de2362 <g_pcHex_cap+0xa>
c0de23b8:	d4d4      	bmi.n	c0de2364 <g_pcHex_cap+0xc>
c0de23ba:	d4d4      	bmi.n	c0de2366 <g_pcHex_cap+0xe>
c0de23bc:	d4d4      	bmi.n	c0de2368 <NULL_ETH_ADDRESS>
c0de23be:	d4d4      	bmi.n	c0de236a <NULL_ETH_ADDRESS+0x2>
c0de23c0:	d4d4      	bmi.n	c0de236c <NULL_ETH_ADDRESS+0x4>
c0de23c2:	d4d4      	bmi.n	c0de236e <NULL_ETH_ADDRESS+0x6>
c0de23c4:	d4d4      	bmi.n	c0de2370 <NULL_ETH_ADDRESS+0x8>
c0de23c6:	d4d4      	bmi.n	c0de2372 <NULL_ETH_ADDRESS+0xa>
c0de23c8:	d4d4      	bmi.n	c0de2374 <NULL_ETH_ADDRESS+0xc>
c0de23ca:	d4d4      	bmi.n	c0de2376 <NULL_ETH_ADDRESS+0xe>
c0de23cc:	d4d4      	bmi.n	c0de2378 <NULL_ETH_ADDRESS+0x10>
c0de23ce:	d4d4      	bmi.n	c0de237a <NULL_ETH_ADDRESS+0x12>
c0de23d0:	d4d4      	bmi.n	c0de237c <_etext>
c0de23d2:	d4d4      	bmi.n	c0de237e <_etext+0x2>
c0de23d4:	d4d4      	bmi.n	c0de2380 <_etext+0x4>
c0de23d6:	d4d4      	bmi.n	c0de2382 <_etext+0x6>
c0de23d8:	d4d4      	bmi.n	c0de2384 <_etext+0x8>
c0de23da:	d4d4      	bmi.n	c0de2386 <_etext+0xa>
c0de23dc:	d4d4      	bmi.n	c0de2388 <_etext+0xc>
c0de23de:	d4d4      	bmi.n	c0de238a <_etext+0xe>
c0de23e0:	d4d4      	bmi.n	c0de238c <_etext+0x10>
c0de23e2:	d4d4      	bmi.n	c0de238e <_etext+0x12>
c0de23e4:	d4d4      	bmi.n	c0de2390 <_etext+0x14>
c0de23e6:	d4d4      	bmi.n	c0de2392 <_etext+0x16>
c0de23e8:	d4d4      	bmi.n	c0de2394 <_etext+0x18>
c0de23ea:	d4d4      	bmi.n	c0de2396 <_etext+0x1a>
c0de23ec:	d4d4      	bmi.n	c0de2398 <_etext+0x1c>
c0de23ee:	d4d4      	bmi.n	c0de239a <_etext+0x1e>
c0de23f0:	d4d4      	bmi.n	c0de239c <_etext+0x20>
c0de23f2:	d4d4      	bmi.n	c0de239e <_etext+0x22>
c0de23f4:	d4d4      	bmi.n	c0de23a0 <_etext+0x24>
c0de23f6:	d4d4      	bmi.n	c0de23a2 <_etext+0x26>
c0de23f8:	d4d4      	bmi.n	c0de23a4 <_etext+0x28>
c0de23fa:	d4d4      	bmi.n	c0de23a6 <_etext+0x2a>
c0de23fc:	d4d4      	bmi.n	c0de23a8 <_etext+0x2c>
c0de23fe:	d4d4      	bmi.n	c0de23aa <_etext+0x2e>
