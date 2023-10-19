
build/nanox/bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0de0000 <main>:
  libcall_params[2] = RUN_APPLICATION;
  os_lib_call((unsigned int *)&libcall_params);
}

// Weird low-level black magic. No need to edit this.
__attribute__((section(".boot"))) int main(int arg0) {
c0de0000:	b5b0      	push	{r4, r5, r7, lr}
c0de0002:	b08c      	sub	sp, #48	; 0x30
c0de0004:	4604      	mov	r4, r0
  // Exit critical section
  __asm volatile("cpsie i");
c0de0006:	b662      	cpsie	i

  // Ensure exception will work as planned
  os_boot();
c0de0008:	f001 fc69 	bl	c0de18de <os_boot>
c0de000c:	466d      	mov	r5, sp

  // Try catch block. Please read the docs for more information on how to use
  // those!
  BEGIN_TRY {
    TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f002 f9a2 	bl	c0de2358 <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10b      	bne.n	c0de0036 <main+0x36>
c0de001e:	f001 fe77 	bl	c0de1d10 <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
      // Low-level black magic.
      check_api_level(CX_COMPAT_APILEVEL);
c0de0024:	f001 fc52 	bl	c0de18cc <check_api_level>

      // Check if we are called from the dashboard.
      if (!arg0) {
c0de0028:	2c00      	cmp	r4, #0
c0de002a:	d117      	bne.n	c0de005c <main+0x5c>
        // Called from dashboard, launch Ethereum app
        call_app_ethereum();
c0de002c:	f001 fc3e 	bl	c0de18ac <call_app_ethereum>
c0de0030:	2000      	movs	r0, #0
  }
  END_TRY;

  // Will not get reached.
  return 0;
}
c0de0032:	b00c      	add	sp, #48	; 0x30
c0de0034:	bdb0      	pop	{r4, r5, r7, pc}
c0de0036:	2100      	movs	r1, #0
    CATCH_OTHER(e) {
c0de0038:	8581      	strh	r1, [r0, #44]	; 0x2c
c0de003a:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de003c:	f001 fe68 	bl	c0de1d10 <try_context_set>
c0de0040:	480f      	ldr	r0, [pc, #60]	; (c0de0080 <main+0x80>)
      switch (e) {
c0de0042:	4285      	cmp	r5, r0
c0de0044:	d001      	beq.n	c0de004a <main+0x4a>
c0de0046:	2d07      	cmp	r5, #7
c0de0048:	d102      	bne.n	c0de0050 <main+0x50>
        handle_query_ui_exception((unsigned int *)arg0);
c0de004a:	4620      	mov	r0, r4
c0de004c:	f001 fc24 	bl	c0de1898 <handle_query_ui_exception>
      PRINTF("Exception 0x%x caught\n", e);
c0de0050:	480d      	ldr	r0, [pc, #52]	; (c0de0088 <main+0x88>)
c0de0052:	4478      	add	r0, pc
c0de0054:	4629      	mov	r1, r5
c0de0056:	f001 fc69 	bl	c0de192c <mcu_usb_printf>
c0de005a:	e006      	b.n	c0de006a <main+0x6a>
        if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de005c:	6820      	ldr	r0, [r4, #0]
c0de005e:	4909      	ldr	r1, [pc, #36]	; (c0de0084 <main+0x84>)
c0de0060:	4288      	cmp	r0, r1
c0de0062:	d002      	beq.n	c0de006a <main+0x6a>
          dispatch_plugin_calls(args[0], (void *)args[1]);
c0de0064:	6861      	ldr	r1, [r4, #4]
c0de0066:	f001 fbdb 	bl	c0de1820 <dispatch_plugin_calls>
    FINALLY {
c0de006a:	f001 fe47 	bl	c0de1cfc <try_context_get>
c0de006e:	4669      	mov	r1, sp
c0de0070:	4288      	cmp	r0, r1
c0de0072:	d102      	bne.n	c0de007a <main+0x7a>
c0de0074:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de0076:	f001 fe4b 	bl	c0de1d10 <try_context_set>
      os_lib_end();
c0de007a:	f001 fe1f 	bl	c0de1cbc <os_lib_end>
c0de007e:	46c0      	nop			; (mov r8, r8)
c0de0080:	00006502 	.word	0x00006502
c0de0084:	000001ff 	.word	0x000001ff
c0de0088:	000025fb 	.word	0x000025fb

c0de008c <cx_hash_get_size>:
CX_TRAMPOLINE _NR_cx_edwards_compress_point_no_throw       cx_edwards_compress_point_no_throw
CX_TRAMPOLINE _NR_cx_edwards_decompress_point_no_throw     cx_edwards_decompress_point_no_throw
CX_TRAMPOLINE _NR_cx_encode_coord                          cx_encode_coord
CX_TRAMPOLINE _NR_cx_hash_final                            cx_hash_final
CX_TRAMPOLINE _NR_cx_hash_get_info                         cx_hash_get_info
CX_TRAMPOLINE _NR_cx_hash_get_size                         cx_hash_get_size
c0de008c:	b403      	push	{r0, r1}
c0de008e:	4801      	ldr	r0, [pc, #4]	; (c0de0094 <cx_hash_get_size+0x8>)
c0de0090:	e011      	b.n	c0de00b6 <cx_trampoline_helper>
c0de0092:	0000      	.short	0x0000
c0de0094:	00000044 	.word	0x00000044

c0de0098 <cx_hash_no_throw>:
CX_TRAMPOLINE _NR_cx_hash_init                             cx_hash_init
CX_TRAMPOLINE _NR_cx_hash_init_ex                          cx_hash_init_ex
CX_TRAMPOLINE _NR_cx_hash_no_throw                         cx_hash_no_throw
c0de0098:	b403      	push	{r0, r1}
c0de009a:	4801      	ldr	r0, [pc, #4]	; (c0de00a0 <cx_hash_no_throw+0x8>)
c0de009c:	e00b      	b.n	c0de00b6 <cx_trampoline_helper>
c0de009e:	0000      	.short	0x0000
c0de00a0:	00000047 	.word	0x00000047

c0de00a4 <cx_keccak_init_no_throw>:
CX_TRAMPOLINE _NR_cx_hmac_sha256_init_no_throw             cx_hmac_sha256_init_no_throw
CX_TRAMPOLINE _NR_cx_hmac_sha384_init                      cx_hmac_sha384_init
CX_TRAMPOLINE _NR_cx_hmac_sha512                           cx_hmac_sha512
CX_TRAMPOLINE _NR_cx_hmac_sha512_init_no_throw             cx_hmac_sha512_init_no_throw
CX_TRAMPOLINE _NR_cx_hmac_update                           cx_hmac_update
CX_TRAMPOLINE _NR_cx_keccak_init_no_throw                  cx_keccak_init_no_throw
c0de00a4:	b403      	push	{r0, r1}
c0de00a6:	4801      	ldr	r0, [pc, #4]	; (c0de00ac <cx_keccak_init_no_throw+0x8>)
c0de00a8:	e005      	b.n	c0de00b6 <cx_trampoline_helper>
c0de00aa:	0000      	.short	0x0000
c0de00ac:	00000059 	.word	0x00000059

c0de00b0 <cx_x448>:
CX_TRAMPOLINE _NR_cx_swap_buffer32                         cx_swap_buffer32
CX_TRAMPOLINE _NR_cx_swap_buffer64                         cx_swap_buffer64
CX_TRAMPOLINE _NR_cx_swap_uint32                           cx_swap_uint32
CX_TRAMPOLINE _NR_cx_swap_uint64                           cx_swap_uint64
CX_TRAMPOLINE _NR_cx_x25519                                cx_x25519
CX_TRAMPOLINE _NR_cx_x448                                  cx_x448
c0de00b0:	b403      	push	{r0, r1}
c0de00b2:	4802      	ldr	r0, [pc, #8]	; (c0de00bc <cx_trampoline_helper+0x6>)
c0de00b4:	e7ff      	b.n	c0de00b6 <cx_trampoline_helper>

c0de00b6 <cx_trampoline_helper>:

.thumb_func
cx_trampoline_helper:
  ldr  r1, =CX_TRAMPOLINE_ADDR // _cx_trampoline address
c0de00b6:	4902      	ldr	r1, [pc, #8]	; (c0de00c0 <cx_trampoline_helper+0xa>)
  bx   r1
c0de00b8:	4708      	bx	r1
c0de00ba:	0000      	.short	0x0000
CX_TRAMPOLINE _NR_cx_x448                                  cx_x448
c0de00bc:	00000086 	.word	0x00000086
  ldr  r1, =CX_TRAMPOLINE_ADDR // _cx_trampoline address
c0de00c0:	00210001 	.word	0x00210001

c0de00c4 <getEthAddressStringFromBinary>:
/* This file is auto-generated, don't edit it */

#include "eth_internals.h"

void getEthAddressStringFromBinary(uint8_t *address, char *out,
                                   cx_sha3_t *sha3Context, uint64_t chainId) {
c0de00c4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de00c6:	b091      	sub	sp, #68	; 0x44
c0de00c8:	9201      	str	r2, [sp, #4]
c0de00ca:	9102      	str	r1, [sp, #8]
c0de00cc:	4605      	mov	r5, r0
c0de00ce:	2201      	movs	r2, #1
c0de00d0:	9816      	ldr	r0, [sp, #88]	; 0x58
  } locals_union;

  uint8_t i;
  bool eip1191 = false;
  uint32_t offset = 0;
  switch (chainId) {
c0de00d2:	4601      	mov	r1, r0
c0de00d4:	9203      	str	r2, [sp, #12]
c0de00d6:	4391      	bics	r1, r2
c0de00d8:	221e      	movs	r2, #30
c0de00da:	404a      	eors	r2, r1
c0de00dc:	9917      	ldr	r1, [sp, #92]	; 0x5c
c0de00de:	430a      	orrs	r2, r1
c0de00e0:	2600      	movs	r6, #0
  case 30:
  case 31:
    eip1191 = true;
    break;
  }
  if (eip1191) {
c0de00e2:	2a00      	cmp	r2, #0
c0de00e4:	4632      	mov	r2, r6
c0de00e6:	d115      	bne.n	c0de0114 <getEthAddressStringFromBinary+0x50>
c0de00e8:	af04      	add	r7, sp, #16
c0de00ea:	2433      	movs	r4, #51	; 0x33
    u64_to_string(chainId, (char *)locals_union.tmp, sizeof(locals_union.tmp));
c0de00ec:	463a      	mov	r2, r7
c0de00ee:	4623      	mov	r3, r4
c0de00f0:	f000 f858 	bl	c0de01a4 <u64_to_string>
    offset = strnlen((char *)locals_union.tmp, sizeof(locals_union.tmp));
c0de00f4:	4638      	mov	r0, r7
c0de00f6:	4621      	mov	r1, r4
c0de00f8:	f002 f9d6 	bl	c0de24a8 <strnlen>
    strlcat((char *)locals_union.tmp + offset, "0x",
c0de00fc:	183b      	adds	r3, r7, r0
            sizeof(locals_union.tmp) - offset);
c0de00fe:	1a22      	subs	r2, r4, r0
    strlcat((char *)locals_union.tmp + offset, "0x",
c0de0100:	4926      	ldr	r1, [pc, #152]	; (c0de019c <getEthAddressStringFromBinary+0xd8>)
c0de0102:	4479      	add	r1, pc
c0de0104:	4618      	mov	r0, r3
c0de0106:	f002 f941 	bl	c0de238c <strlcat>
    offset = strnlen((char *)locals_union.tmp, sizeof(locals_union.tmp));
c0de010a:	4638      	mov	r0, r7
c0de010c:	4621      	mov	r1, r4
c0de010e:	f002 f9cb 	bl	c0de24a8 <strnlen>
c0de0112:	4602      	mov	r2, r0
c0de0114:	a804      	add	r0, sp, #16
c0de0116:	9200      	str	r2, [sp, #0]
  }
  for (i = 0; i < 20; i++) {
c0de0118:	1880      	adds	r0, r0, r2
c0de011a:	4f21      	ldr	r7, [pc, #132]	; (c0de01a0 <getEthAddressStringFromBinary+0xdc>)
c0de011c:	447f      	add	r7, pc
    uint8_t digit = address[i];
c0de011e:	5da9      	ldrb	r1, [r5, r6]
c0de0120:	240f      	movs	r4, #15
    locals_union.tmp[offset + 2 * i] = HEXDIGITS[(digit >> 4) & 0x0f];
c0de0122:	090a      	lsrs	r2, r1, #4
    locals_union.tmp[offset + 2 * i + 1] = HEXDIGITS[digit & 0x0f];
c0de0124:	4021      	ands	r1, r4
c0de0126:	5c79      	ldrb	r1, [r7, r1]
c0de0128:	7041      	strb	r1, [r0, #1]
    locals_union.tmp[offset + 2 * i] = HEXDIGITS[(digit >> 4) & 0x0f];
c0de012a:	5cb9      	ldrb	r1, [r7, r2]
c0de012c:	7001      	strb	r1, [r0, #0]
  for (i = 0; i < 20; i++) {
c0de012e:	1c80      	adds	r0, r0, #2
c0de0130:	1c76      	adds	r6, r6, #1
c0de0132:	2e14      	cmp	r6, #20
c0de0134:	d1f3      	bne.n	c0de011e <getEthAddressStringFromBinary+0x5a>
c0de0136:	9e01      	ldr	r6, [sp, #4]
  }
  cx_keccak_init(sha3Context, 256);
c0de0138:	4630      	mov	r0, r6
c0de013a:	f000 f871 	bl	c0de0220 <cx_keccak_init>
c0de013e:	9a00      	ldr	r2, [sp, #0]
  cx_hash((cx_hash_t *)sha3Context, CX_LAST, locals_union.tmp, offset + 40,
c0de0140:	3228      	adds	r2, #40	; 0x28
c0de0142:	a904      	add	r1, sp, #16
c0de0144:	4630      	mov	r0, r6
c0de0146:	460b      	mov	r3, r1
c0de0148:	f000 f874 	bl	c0de0234 <cx_hash>
c0de014c:	2000      	movs	r0, #0
c0de014e:	9e02      	ldr	r6, [sp, #8]
c0de0150:	e004      	b.n	c0de015c <getEthAddressStringFromBinary+0x98>
      digit = (digit >> 4) & 0x0f;
    } else {
      digit = digit & 0x0f;
    }
    if (digit < 10) {
      out[i] = HEXDIGITS[digit];
c0de0152:	5c79      	ldrb	r1, [r7, r1]
c0de0154:	5431      	strb	r1, [r6, r0]
  for (i = 0; i < 40; i++) {
c0de0156:	1c40      	adds	r0, r0, #1
c0de0158:	2828      	cmp	r0, #40	; 0x28
c0de015a:	d019      	beq.n	c0de0190 <getEthAddressStringFromBinary+0xcc>
    if ((i % 2) == 0) {
c0de015c:	4602      	mov	r2, r0
c0de015e:	9903      	ldr	r1, [sp, #12]
c0de0160:	400a      	ands	r2, r1
    uint8_t digit = address[i / 2];
c0de0162:	0843      	lsrs	r3, r0, #1
c0de0164:	5ce9      	ldrb	r1, [r5, r3]
    if ((i % 2) == 0) {
c0de0166:	2a00      	cmp	r2, #0
c0de0168:	d003      	beq.n	c0de0172 <getEthAddressStringFromBinary+0xae>
c0de016a:	4021      	ands	r1, r4
    if (digit < 10) {
c0de016c:	2909      	cmp	r1, #9
c0de016e:	d9f0      	bls.n	c0de0152 <getEthAddressStringFromBinary+0x8e>
c0de0170:	e002      	b.n	c0de0178 <getEthAddressStringFromBinary+0xb4>
c0de0172:	0909      	lsrs	r1, r1, #4
c0de0174:	2909      	cmp	r1, #9
c0de0176:	d9ec      	bls.n	c0de0152 <getEthAddressStringFromBinary+0x8e>
c0de0178:	ae04      	add	r6, sp, #16
    } else {
      int v = (locals_union.hashChecksum[i / 2] >> (4 * (1 - i % 2))) & 0x0f;
c0de017a:	5cf3      	ldrb	r3, [r6, r3]
c0de017c:	0092      	lsls	r2, r2, #2
c0de017e:	2604      	movs	r6, #4
c0de0180:	4056      	eors	r6, r2
      if (v >= 8) {
c0de0182:	40f3      	lsrs	r3, r6
c0de0184:	071a      	lsls	r2, r3, #28
c0de0186:	5c79      	ldrb	r1, [r7, r1]
c0de0188:	d500      	bpl.n	c0de018c <getEthAddressStringFromBinary+0xc8>
c0de018a:	3920      	subs	r1, #32
c0de018c:	9e02      	ldr	r6, [sp, #8]
c0de018e:	e7e1      	b.n	c0de0154 <getEthAddressStringFromBinary+0x90>
c0de0190:	2028      	movs	r0, #40	; 0x28
c0de0192:	2100      	movs	r1, #0
      } else {
        out[i] = HEXDIGITS[digit];
      }
    }
  }
  out[40] = '\0';
c0de0194:	5431      	strb	r1, [r6, r0]
}
c0de0196:	b011      	add	sp, #68	; 0x44
c0de0198:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de019a:	46c0      	nop			; (mov r8, r8)
c0de019c:	000025b6 	.word	0x000025b6
c0de01a0:	0000256b 	.word	0x0000256b

c0de01a4 <u64_to_string>:
  }

  out_buffer[out_buffer_size - 1] = '\0';
}

void u64_to_string(uint64_t src, char *dst, uint8_t dst_size) {
c0de01a4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de01a6:	b087      	sub	sp, #28
c0de01a8:	9302      	str	r3, [sp, #8]
c0de01aa:	460b      	mov	r3, r1
c0de01ac:	4605      	mov	r5, r0
c0de01ae:	2000      	movs	r0, #0
c0de01b0:	9201      	str	r2, [sp, #4]
c0de01b2:	9006      	str	r0, [sp, #24]
  // Copy the numbers in ASCII format.
  uint8_t i = 0;
  do {
    // Checking `i + 1` to make sure we have enough space for '\0'.
    if (i + 1 >= dst_size) {
c0de01b4:	b2c7      	uxtb	r7, r0
c0de01b6:	1c78      	adds	r0, r7, #1
c0de01b8:	9902      	ldr	r1, [sp, #8]
c0de01ba:	4288      	cmp	r0, r1
c0de01bc:	d22b      	bcs.n	c0de0216 <u64_to_string+0x72>
c0de01be:	240a      	movs	r4, #10
c0de01c0:	2600      	movs	r6, #0
      THROW(0x6502);
    }
    dst[i] = src % 10 + '0';
    src /= 10;
c0de01c2:	4628      	mov	r0, r5
c0de01c4:	4619      	mov	r1, r3
c0de01c6:	4622      	mov	r2, r4
c0de01c8:	9305      	str	r3, [sp, #20]
c0de01ca:	4633      	mov	r3, r6
c0de01cc:	f001 fe3a 	bl	c0de1e44 <__aeabi_uldivmod>
c0de01d0:	9004      	str	r0, [sp, #16]
c0de01d2:	9103      	str	r1, [sp, #12]
c0de01d4:	4622      	mov	r2, r4
c0de01d6:	4633      	mov	r3, r6
c0de01d8:	f001 fe54 	bl	c0de1e84 <__aeabi_lmul>
c0de01dc:	1a28      	subs	r0, r5, r0
c0de01de:	2130      	movs	r1, #48	; 0x30
    dst[i] = src % 10 + '0';
c0de01e0:	4301      	orrs	r1, r0
c0de01e2:	9a01      	ldr	r2, [sp, #4]
c0de01e4:	55d1      	strb	r1, [r2, r7]
c0de01e6:	9c06      	ldr	r4, [sp, #24]
    i++;
c0de01e8:	1c60      	adds	r0, r4, #1
c0de01ea:	2109      	movs	r1, #9
  } while (src);
c0de01ec:	1b49      	subs	r1, r1, r5
c0de01ee:	4631      	mov	r1, r6
c0de01f0:	9b05      	ldr	r3, [sp, #20]
c0de01f2:	4199      	sbcs	r1, r3
c0de01f4:	9d04      	ldr	r5, [sp, #16]
c0de01f6:	9b03      	ldr	r3, [sp, #12]
c0de01f8:	d3db      	bcc.n	c0de01b2 <u64_to_string+0xe>

  // Null terminate string
  dst[i] = '\0';
c0de01fa:	b2c0      	uxtb	r0, r0
c0de01fc:	5416      	strb	r6, [r2, r0]

  // Revert the string
  i--;
  uint8_t j = 0;
  while (j < i) {
c0de01fe:	0620      	lsls	r0, r4, #24
c0de0200:	d007      	beq.n	c0de0212 <u64_to_string+0x6e>
    char tmp = dst[i];
c0de0202:	5dd0      	ldrb	r0, [r2, r7]
    dst[i] = dst[j];
c0de0204:	5d91      	ldrb	r1, [r2, r6]
c0de0206:	55d1      	strb	r1, [r2, r7]
    dst[j] = tmp;
c0de0208:	5590      	strb	r0, [r2, r6]
    i--;
c0de020a:	1e7f      	subs	r7, r7, #1
    j++;
c0de020c:	1c76      	adds	r6, r6, #1
  while (j < i) {
c0de020e:	42be      	cmp	r6, r7
c0de0210:	d3f7      	bcc.n	c0de0202 <u64_to_string+0x5e>
  }
}
c0de0212:	b007      	add	sp, #28
c0de0214:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0216:	4801      	ldr	r0, [pc, #4]	; (c0de021c <u64_to_string+0x78>)
      THROW(0x6502);
c0de0218:	f001 fb66 	bl	c0de18e8 <os_longjmp>
c0de021c:	00006502 	.word	0x00006502

c0de0220 <cx_keccak_init>:
 * @return           KECCAK identifier.
 * 
 * @throws           CX_INVALID_PARAMETER
 */
static inline int cx_keccak_init ( cx_sha3_t * hash, size_t size )
{
c0de0220:	b580      	push	{r7, lr}
c0de0222:	2101      	movs	r1, #1
c0de0224:	0209      	lsls	r1, r1, #8
  CX_THROW(cx_keccak_init_no_throw(hash, size));
c0de0226:	f7ff ff3d 	bl	c0de00a4 <cx_keccak_init_no_throw>
c0de022a:	2800      	cmp	r0, #0
c0de022c:	d100      	bne.n	c0de0230 <cx_keccak_init+0x10>
  return CX_KECCAK;
c0de022e:	bd80      	pop	{r7, pc}
  CX_THROW(cx_keccak_init_no_throw(hash, size));
c0de0230:	f001 fb5a 	bl	c0de18e8 <os_longjmp>

c0de0234 <cx_hash>:
 *
 * @throws             INVALID_PARAMETER
 * @throws             CX_INVALID_PARAMETER
 */
static inline size_t cx_hash ( cx_hash_t * hash, uint32_t mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len )
{
c0de0234:	b5b0      	push	{r4, r5, r7, lr}
c0de0236:	b082      	sub	sp, #8
c0de0238:	4615      	mov	r5, r2
c0de023a:	460a      	mov	r2, r1
c0de023c:	4604      	mov	r4, r0
c0de023e:	2020      	movs	r0, #32
  CX_THROW(cx_hash_no_throw(hash, mode, in, len, out, out_len));
c0de0240:	9300      	str	r3, [sp, #0]
c0de0242:	9001      	str	r0, [sp, #4]
c0de0244:	2101      	movs	r1, #1
c0de0246:	4620      	mov	r0, r4
c0de0248:	462b      	mov	r3, r5
c0de024a:	f7ff ff25 	bl	c0de0098 <cx_hash_no_throw>
c0de024e:	2800      	cmp	r0, #0
c0de0250:	d104      	bne.n	c0de025c <cx_hash+0x28>
  return cx_hash_get_size(hash);
c0de0252:	4620      	mov	r0, r4
c0de0254:	f7ff ff1a 	bl	c0de008c <cx_hash_get_size>
c0de0258:	b002      	add	sp, #8
c0de025a:	bdb0      	pop	{r4, r5, r7, pc}
  CX_THROW(cx_hash_no_throw(hash, mode, in, len, out, out_len));
c0de025c:	f001 fb44 	bl	c0de18e8 <os_longjmp>

c0de0260 <adjustDecimals>:
                    size_t targetLength, uint8_t decimals) {
c0de0260:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0262:	b083      	sub	sp, #12
c0de0264:	9302      	str	r3, [sp, #8]
c0de0266:	4614      	mov	r4, r2
c0de0268:	460e      	mov	r6, r1
c0de026a:	4607      	mov	r7, r0
  if ((srcLength == 1) && (*src == '0')) {
c0de026c:	2901      	cmp	r1, #1
c0de026e:	d107      	bne.n	c0de0280 <adjustDecimals+0x20>
c0de0270:	7838      	ldrb	r0, [r7, #0]
c0de0272:	2830      	cmp	r0, #48	; 0x30
c0de0274:	d104      	bne.n	c0de0280 <adjustDecimals+0x20>
    if (targetLength < 2) {
c0de0276:	9802      	ldr	r0, [sp, #8]
c0de0278:	2802      	cmp	r0, #2
c0de027a:	d23d      	bcs.n	c0de02f8 <adjustDecimals+0x98>
c0de027c:	2500      	movs	r5, #0
c0de027e:	e06f      	b.n	c0de0360 <adjustDecimals+0x100>
c0de0280:	9b08      	ldr	r3, [sp, #32]
  if (srcLength <= decimals) {
c0de0282:	42b3      	cmp	r3, r6
c0de0284:	d222      	bcs.n	c0de02cc <adjustDecimals+0x6c>
    if (targetLength < srcLength + 1 + 1) {
c0de0286:	1cb1      	adds	r1, r6, #2
c0de0288:	2500      	movs	r5, #0
c0de028a:	9802      	ldr	r0, [sp, #8]
c0de028c:	9101      	str	r1, [sp, #4]
c0de028e:	4281      	cmp	r1, r0
c0de0290:	4629      	mov	r1, r5
c0de0292:	d845      	bhi.n	c0de0320 <adjustDecimals+0xc0>
c0de0294:	2000      	movs	r0, #0
c0de0296:	1af1      	subs	r1, r6, r3
    while (offset < delta) {
c0de0298:	d004      	beq.n	c0de02a4 <adjustDecimals+0x44>
      target[offset++] = src[sourceOffset++];
c0de029a:	5c3a      	ldrb	r2, [r7, r0]
c0de029c:	5422      	strb	r2, [r4, r0]
c0de029e:	1c40      	adds	r0, r0, #1
    while (offset < delta) {
c0de02a0:	4281      	cmp	r1, r0
c0de02a2:	d1fa      	bne.n	c0de029a <adjustDecimals+0x3a>
    if (decimals != 0) {
c0de02a4:	2b00      	cmp	r3, #0
c0de02a6:	4602      	mov	r2, r0
c0de02a8:	d002      	beq.n	c0de02b0 <adjustDecimals+0x50>
c0de02aa:	212e      	movs	r1, #46	; 0x2e
      target[offset++] = '.';
c0de02ac:	5421      	strb	r1, [r4, r0]
c0de02ae:	1c42      	adds	r2, r0, #1
    while (sourceOffset < srcLength) {
c0de02b0:	42b0      	cmp	r0, r6
c0de02b2:	4611      	mov	r1, r2
c0de02b4:	d232      	bcs.n	c0de031c <adjustDecimals+0xbc>
c0de02b6:	1a33      	subs	r3, r6, r0
c0de02b8:	1838      	adds	r0, r7, r0
c0de02ba:	4611      	mov	r1, r2
      target[offset++] = src[sourceOffset++];
c0de02bc:	7806      	ldrb	r6, [r0, #0]
c0de02be:	5466      	strb	r6, [r4, r1]
    while (sourceOffset < srcLength) {
c0de02c0:	1e5b      	subs	r3, r3, #1
c0de02c2:	1c40      	adds	r0, r0, #1
      target[offset++] = src[sourceOffset++];
c0de02c4:	1c49      	adds	r1, r1, #1
    while (sourceOffset < srcLength) {
c0de02c6:	2b00      	cmp	r3, #0
c0de02c8:	d1f8      	bne.n	c0de02bc <adjustDecimals+0x5c>
c0de02ca:	e027      	b.n	c0de031c <adjustDecimals+0xbc>
    if (targetLength < srcLength + 1 + 2 + delta) {
c0de02cc:	1cd9      	adds	r1, r3, #3
c0de02ce:	2500      	movs	r5, #0
c0de02d0:	9802      	ldr	r0, [sp, #8]
c0de02d2:	9101      	str	r1, [sp, #4]
c0de02d4:	4281      	cmp	r1, r0
c0de02d6:	4629      	mov	r1, r5
c0de02d8:	d822      	bhi.n	c0de0320 <adjustDecimals+0xc0>
c0de02da:	1b99      	subs	r1, r3, r6
c0de02dc:	202e      	movs	r0, #46	; 0x2e
    target[offset++] = '.';
c0de02de:	7060      	strb	r0, [r4, #1]
c0de02e0:	2030      	movs	r0, #48	; 0x30
    target[offset++] = '0';
c0de02e2:	7020      	strb	r0, [r4, #0]
    for (uint32_t i = 0; i < delta; i++) {
c0de02e4:	2900      	cmp	r1, #0
c0de02e6:	d00d      	beq.n	c0de0304 <adjustDecimals+0xa4>
c0de02e8:	1ca0      	adds	r0, r4, #2
c0de02ea:	2230      	movs	r2, #48	; 0x30
      target[offset++] = '0';
c0de02ec:	9100      	str	r1, [sp, #0]
c0de02ee:	f001 fefd 	bl	c0de20ec <__aeabi_memset>
    for (uint32_t i = 0; i < delta; i++) {
c0de02f2:	9800      	ldr	r0, [sp, #0]
c0de02f4:	1c82      	adds	r2, r0, #2
c0de02f6:	e006      	b.n	c0de0306 <adjustDecimals+0xa6>
c0de02f8:	2000      	movs	r0, #0
    target[1] = '\0';
c0de02fa:	7060      	strb	r0, [r4, #1]
c0de02fc:	2030      	movs	r0, #48	; 0x30
    target[0] = '0';
c0de02fe:	7020      	strb	r0, [r4, #0]
c0de0300:	2501      	movs	r5, #1
c0de0302:	e02d      	b.n	c0de0360 <adjustDecimals+0x100>
c0de0304:	2202      	movs	r2, #2
    for (uint32_t i = 0; i < srcLength; i++) {
c0de0306:	2e00      	cmp	r6, #0
c0de0308:	4611      	mov	r1, r2
c0de030a:	d007      	beq.n	c0de031c <adjustDecimals+0xbc>
c0de030c:	4611      	mov	r1, r2
      target[offset++] = src[i];
c0de030e:	7838      	ldrb	r0, [r7, #0]
c0de0310:	5460      	strb	r0, [r4, r1]
    for (uint32_t i = 0; i < srcLength; i++) {
c0de0312:	1c7f      	adds	r7, r7, #1
c0de0314:	1e76      	subs	r6, r6, #1
      target[offset++] = src[i];
c0de0316:	1c49      	adds	r1, r1, #1
    for (uint32_t i = 0; i < srcLength; i++) {
c0de0318:	2e00      	cmp	r6, #0
c0de031a:	d1f8      	bne.n	c0de030e <adjustDecimals+0xae>
c0de031c:	2000      	movs	r0, #0
c0de031e:	5460      	strb	r0, [r4, r1]
c0de0320:	9802      	ldr	r0, [sp, #8]
c0de0322:	9b01      	ldr	r3, [sp, #4]
c0de0324:	4283      	cmp	r3, r0
c0de0326:	d81b      	bhi.n	c0de0360 <adjustDecimals+0x100>
  for (uint32_t i = startOffset; i < offset; i++) {
c0de0328:	428a      	cmp	r2, r1
c0de032a:	d20e      	bcs.n	c0de034a <adjustDecimals+0xea>
c0de032c:	2300      	movs	r3, #0
c0de032e:	e003      	b.n	c0de0338 <adjustDecimals+0xd8>
c0de0330:	1c52      	adds	r2, r2, #1
c0de0332:	4291      	cmp	r1, r2
c0de0334:	4603      	mov	r3, r0
c0de0336:	d009      	beq.n	c0de034c <adjustDecimals+0xec>
    if (target[i] == '0') {
c0de0338:	2b00      	cmp	r3, #0
c0de033a:	4610      	mov	r0, r2
c0de033c:	d000      	beq.n	c0de0340 <adjustDecimals+0xe0>
c0de033e:	4618      	mov	r0, r3
c0de0340:	5ca3      	ldrb	r3, [r4, r2]
c0de0342:	2b30      	cmp	r3, #48	; 0x30
c0de0344:	d0f4      	beq.n	c0de0330 <adjustDecimals+0xd0>
c0de0346:	2000      	movs	r0, #0
c0de0348:	e7f2      	b.n	c0de0330 <adjustDecimals+0xd0>
c0de034a:	2000      	movs	r0, #0
c0de034c:	2501      	movs	r5, #1
  if (lastZeroOffset != 0) {
c0de034e:	2800      	cmp	r0, #0
c0de0350:	d006      	beq.n	c0de0360 <adjustDecimals+0x100>
c0de0352:	2100      	movs	r1, #0
    target[lastZeroOffset] = '\0';
c0de0354:	5421      	strb	r1, [r4, r0]
    if (target[lastZeroOffset - 1] == '.') {
c0de0356:	1e40      	subs	r0, r0, #1
c0de0358:	5c22      	ldrb	r2, [r4, r0]
c0de035a:	2a2e      	cmp	r2, #46	; 0x2e
c0de035c:	d100      	bne.n	c0de0360 <adjustDecimals+0x100>
      target[lastZeroOffset - 1] = '\0';
c0de035e:	5421      	strb	r1, [r4, r0]
}
c0de0360:	4628      	mov	r0, r5
c0de0362:	b003      	add	sp, #12
c0de0364:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0366:	d4d4      	bmi.n	c0de0312 <adjustDecimals+0xb2>

c0de0368 <uint256_to_decimal>:
                        size_t out_len) {
c0de0368:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de036a:	b08b      	sub	sp, #44	; 0x2c
c0de036c:	4614      	mov	r4, r2
c0de036e:	460a      	mov	r2, r1
  if (value_len > INT256_LENGTH) {
c0de0370:	2920      	cmp	r1, #32
c0de0372:	d901      	bls.n	c0de0378 <uint256_to_decimal+0x10>
c0de0374:	2600      	movs	r6, #0
c0de0376:	e03a      	b.n	c0de03ee <uint256_to_decimal+0x86>
c0de0378:	461d      	mov	r5, r3
c0de037a:	4601      	mov	r1, r0
c0de037c:	2600      	movs	r6, #0
  uint16_t n[16] = {0};
c0de037e:	960a      	str	r6, [sp, #40]	; 0x28
c0de0380:	9609      	str	r6, [sp, #36]	; 0x24
c0de0382:	9608      	str	r6, [sp, #32]
c0de0384:	9607      	str	r6, [sp, #28]
c0de0386:	9606      	str	r6, [sp, #24]
c0de0388:	9605      	str	r6, [sp, #20]
c0de038a:	9604      	str	r6, [sp, #16]
c0de038c:	9603      	str	r6, [sp, #12]
c0de038e:	af03      	add	r7, sp, #12
  memcpy((uint8_t *)n + INT256_LENGTH - value_len, value, value_len);
c0de0390:	1ab8      	subs	r0, r7, r2
c0de0392:	3020      	adds	r0, #32
c0de0394:	f001 fea2 	bl	c0de20dc <__aeabi_memcpy>
c0de0398:	2120      	movs	r1, #32
  if (allzeroes(n, INT256_LENGTH)) {
c0de039a:	4638      	mov	r0, r7
c0de039c:	f000 f856 	bl	c0de044c <allzeroes>
c0de03a0:	2800      	cmp	r0, #0
c0de03a2:	d009      	beq.n	c0de03b8 <uint256_to_decimal+0x50>
    if (out_len < 2) {
c0de03a4:	2d02      	cmp	r5, #2
c0de03a6:	d322      	bcc.n	c0de03ee <uint256_to_decimal+0x86>
    strlcpy(out, "0", out_len);
c0de03a8:	4927      	ldr	r1, [pc, #156]	; (c0de0448 <uint256_to_decimal+0xe0>)
c0de03aa:	4479      	add	r1, pc
c0de03ac:	4620      	mov	r0, r4
c0de03ae:	462a      	mov	r2, r5
c0de03b0:	f002 f820 	bl	c0de23f4 <strlcpy>
c0de03b4:	2601      	movs	r6, #1
c0de03b6:	e01a      	b.n	c0de03ee <uint256_to_decimal+0x86>
c0de03b8:	2000      	movs	r0, #0
c0de03ba:	a903      	add	r1, sp, #12
    n[i] = __builtin_bswap16(*p++);
c0de03bc:	5a0a      	ldrh	r2, [r1, r0]
c0de03be:	ba52      	rev16	r2, r2
c0de03c0:	520a      	strh	r2, [r1, r0]
  for (int i = 0; i < 16; i++) {
c0de03c2:	1c80      	adds	r0, r0, #2
c0de03c4:	2820      	cmp	r0, #32
c0de03c6:	d1f8      	bne.n	c0de03ba <uint256_to_decimal+0x52>
c0de03c8:	a803      	add	r0, sp, #12
c0de03ca:	2120      	movs	r1, #32
  while (!allzeroes(n, sizeof(n))) {
c0de03cc:	f000 f83e 	bl	c0de044c <allzeroes>
c0de03d0:	4247      	negs	r7, r0
c0de03d2:	4147      	adcs	r7, r0
c0de03d4:	2800      	cmp	r0, #0
c0de03d6:	d00d      	beq.n	c0de03f4 <uint256_to_decimal+0x8c>
c0de03d8:	462e      	mov	r6, r5
  memmove(out, out + pos, out_len - pos);
c0de03da:	19a1      	adds	r1, r4, r6
c0de03dc:	1bad      	subs	r5, r5, r6
c0de03de:	4620      	mov	r0, r4
c0de03e0:	462a      	mov	r2, r5
c0de03e2:	f001 fe7f 	bl	c0de20e4 <__aeabi_memmove>
c0de03e6:	2000      	movs	r0, #0
  out[out_len - pos] = 0;
c0de03e8:	5560      	strb	r0, [r4, r5]
c0de03ea:	2601      	movs	r6, #1
c0de03ec:	407e      	eors	r6, r7
}
c0de03ee:	4630      	mov	r0, r6
c0de03f0:	b00b      	add	sp, #44	; 0x2c
c0de03f2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de03f4:	9500      	str	r5, [sp, #0]
    if (pos == 0) {
c0de03f6:	2d00      	cmp	r5, #0
c0de03f8:	d0f7      	beq.n	c0de03ea <uint256_to_decimal+0x82>
c0de03fa:	9e00      	ldr	r6, [sp, #0]
c0de03fc:	9401      	str	r4, [sp, #4]
c0de03fe:	9602      	str	r6, [sp, #8]
c0de0400:	2400      	movs	r4, #0
c0de0402:	4620      	mov	r0, r4
c0de0404:	ad03      	add	r5, sp, #12
      int rem = ((carry << 16) | n[i]) % 10;
c0de0406:	5b29      	ldrh	r1, [r5, r4]
c0de0408:	0400      	lsls	r0, r0, #16
c0de040a:	1846      	adds	r6, r0, r1
c0de040c:	270a      	movs	r7, #10
      n[i] = ((carry << 16) | n[i]) / 10;
c0de040e:	4630      	mov	r0, r6
c0de0410:	4639      	mov	r1, r7
c0de0412:	f001 fc8b 	bl	c0de1d2c <__udivsi3>
c0de0416:	5328      	strh	r0, [r5, r4]
c0de0418:	4347      	muls	r7, r0
c0de041a:	1bf0      	subs	r0, r6, r7
    for (int i = 0; i < 16; i++) {
c0de041c:	1ca4      	adds	r4, r4, #2
c0de041e:	2c20      	cmp	r4, #32
c0de0420:	d1f0      	bne.n	c0de0404 <uint256_to_decimal+0x9c>
c0de0422:	2130      	movs	r1, #48	; 0x30
    out[pos] = '0' + carry;
c0de0424:	4308      	orrs	r0, r1
c0de0426:	9e02      	ldr	r6, [sp, #8]
    pos -= 1;
c0de0428:	1e76      	subs	r6, r6, #1
c0de042a:	9c01      	ldr	r4, [sp, #4]
    out[pos] = '0' + carry;
c0de042c:	55a0      	strb	r0, [r4, r6]
c0de042e:	a803      	add	r0, sp, #12
c0de0430:	2120      	movs	r1, #32
  while (!allzeroes(n, sizeof(n))) {
c0de0432:	f000 f80b 	bl	c0de044c <allzeroes>
c0de0436:	4247      	negs	r7, r0
c0de0438:	4147      	adcs	r7, r0
c0de043a:	2800      	cmp	r0, #0
c0de043c:	d102      	bne.n	c0de0444 <uint256_to_decimal+0xdc>
    if (pos == 0) {
c0de043e:	2e00      	cmp	r6, #0
c0de0440:	d1dd      	bne.n	c0de03fe <uint256_to_decimal+0x96>
c0de0442:	e7d2      	b.n	c0de03ea <uint256_to_decimal+0x82>
c0de0444:	9d00      	ldr	r5, [sp, #0]
c0de0446:	e7c8      	b.n	c0de03da <uint256_to_decimal+0x72>
c0de0448:	0000225e 	.word	0x0000225e

c0de044c <allzeroes>:
  tokenDefinition_t token;
  nftInfo_t nft;
} extraInfo_t;

static __attribute__((no_instrument_function)) inline int
allzeroes(const void *buf, size_t n) {
c0de044c:	b5b0      	push	{r4, r5, r7, lr}
  uint8_t *p = (uint8_t *)buf;
  for (size_t i = 0; i < n; ++i) {
c0de044e:	1e4b      	subs	r3, r1, #1
c0de0450:	460a      	mov	r2, r1
c0de0452:	419a      	sbcs	r2, r3
c0de0454:	2900      	cmp	r1, #0
c0de0456:	d00e      	beq.n	c0de0476 <allzeroes+0x2a>
    if (p[i]) {
c0de0458:	7803      	ldrb	r3, [r0, #0]
c0de045a:	2b00      	cmp	r3, #0
c0de045c:	d10b      	bne.n	c0de0476 <allzeroes+0x2a>
c0de045e:	2301      	movs	r3, #1
c0de0460:	461c      	mov	r4, r3
  for (size_t i = 0; i < n; ++i) {
c0de0462:	428c      	cmp	r4, r1
c0de0464:	461a      	mov	r2, r3
c0de0466:	d300      	bcc.n	c0de046a <allzeroes+0x1e>
c0de0468:	2200      	movs	r2, #0
c0de046a:	42a1      	cmp	r1, r4
c0de046c:	d003      	beq.n	c0de0476 <allzeroes+0x2a>
    if (p[i]) {
c0de046e:	5d05      	ldrb	r5, [r0, r4]
  for (size_t i = 0; i < n; ++i) {
c0de0470:	1c64      	adds	r4, r4, #1
    if (p[i]) {
c0de0472:	2d00      	cmp	r5, #0
c0de0474:	d0f5      	beq.n	c0de0462 <allzeroes+0x16>
c0de0476:	2001      	movs	r0, #1
c0de0478:	4050      	eors	r0, r2
      return 0;
    }
  }
  return 1;
}
c0de047a:	bdb0      	pop	{r4, r5, r7, pc}

c0de047c <amountToString>:
                    size_t out_buffer_size) {
c0de047c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de047e:	b09d      	sub	sp, #116	; 0x74
c0de0480:	9303      	str	r3, [sp, #12]
c0de0482:	9202      	str	r2, [sp, #8]
c0de0484:	460c      	mov	r4, r1
c0de0486:	4605      	mov	r5, r0
c0de0488:	af04      	add	r7, sp, #16
c0de048a:	2664      	movs	r6, #100	; 0x64
  char tmp_buffer[100] = {0};
c0de048c:	4638      	mov	r0, r7
c0de048e:	4631      	mov	r1, r6
c0de0490:	f001 fe1e 	bl	c0de20d0 <__aeabi_memclr>
  if (uint256_to_decimal(amount, amount_size, tmp_buffer, sizeof(tmp_buffer)) ==
c0de0494:	4628      	mov	r0, r5
c0de0496:	4621      	mov	r1, r4
c0de0498:	463a      	mov	r2, r7
c0de049a:	4633      	mov	r3, r6
c0de049c:	f7ff ff64 	bl	c0de0368 <uint256_to_decimal>
c0de04a0:	2800      	cmp	r0, #0
c0de04a2:	d02c      	beq.n	c0de04fe <amountToString+0x82>
c0de04a4:	9e23      	ldr	r6, [sp, #140]	; 0x8c
c0de04a6:	9d22      	ldr	r5, [sp, #136]	; 0x88
c0de04a8:	a804      	add	r0, sp, #16
c0de04aa:	2164      	movs	r1, #100	; 0x64
  uint8_t amount_len = strnlen(tmp_buffer, sizeof(tmp_buffer));
c0de04ac:	f001 fffc 	bl	c0de24a8 <strnlen>
c0de04b0:	9001      	str	r0, [sp, #4]
c0de04b2:	210b      	movs	r1, #11
  uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de04b4:	9803      	ldr	r0, [sp, #12]
c0de04b6:	f001 fff7 	bl	c0de24a8 <strnlen>
c0de04ba:	4604      	mov	r4, r0
  memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de04bc:	b2c7      	uxtb	r7, r0
c0de04be:	42b7      	cmp	r7, r6
c0de04c0:	4632      	mov	r2, r6
c0de04c2:	d800      	bhi.n	c0de04c6 <amountToString+0x4a>
c0de04c4:	463a      	mov	r2, r7
c0de04c6:	4628      	mov	r0, r5
c0de04c8:	9903      	ldr	r1, [sp, #12]
c0de04ca:	f001 fe07 	bl	c0de20dc <__aeabi_memcpy>
  if (ticker_len > 0) {
c0de04ce:	2f00      	cmp	r7, #0
c0de04d0:	d002      	beq.n	c0de04d8 <amountToString+0x5c>
c0de04d2:	2020      	movs	r0, #32
    out_buffer[ticker_len++] = ' ';
c0de04d4:	55e8      	strb	r0, [r5, r7]
c0de04d6:	1c64      	adds	r4, r4, #1
c0de04d8:	9802      	ldr	r0, [sp, #8]
c0de04da:	9901      	ldr	r1, [sp, #4]
  if (adjustDecimals(tmp_buffer, amount_len, out_buffer + ticker_len,
c0de04dc:	9000      	str	r0, [sp, #0]
c0de04de:	b2e0      	uxtb	r0, r4
c0de04e0:	182a      	adds	r2, r5, r0
                     out_buffer_size - ticker_len - 1, decimals) == false) {
c0de04e2:	43c0      	mvns	r0, r0
c0de04e4:	1983      	adds	r3, r0, r6
  if (adjustDecimals(tmp_buffer, amount_len, out_buffer + ticker_len,
c0de04e6:	b2c9      	uxtb	r1, r1
c0de04e8:	a804      	add	r0, sp, #16
c0de04ea:	f7ff feb9 	bl	c0de0260 <adjustDecimals>
c0de04ee:	2800      	cmp	r0, #0
c0de04f0:	d005      	beq.n	c0de04fe <amountToString+0x82>
  out_buffer[out_buffer_size - 1] = '\0';
c0de04f2:	1970      	adds	r0, r6, r5
c0de04f4:	1e40      	subs	r0, r0, #1
c0de04f6:	2100      	movs	r1, #0
c0de04f8:	7001      	strb	r1, [r0, #0]
}
c0de04fa:	b01d      	add	sp, #116	; 0x74
c0de04fc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de04fe:	2007      	movs	r0, #7
c0de0500:	f001 f9f2 	bl	c0de18e8 <os_longjmp>

c0de0504 <handle_finalize>:
#include "origin_defi_plugin.h"

void handle_finalize(void *parameters) {
c0de0504:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0506:	b081      	sub	sp, #4
c0de0508:	4604      	mov	r4, r0
c0de050a:	2702      	movs	r7, #2
  ethPluginFinalize_t *msg = (ethPluginFinalize_t *)parameters;
  origin_defi_parameters_t *context =
      (origin_defi_parameters_t *)msg->pluginContext;
  msg->numScreens = 2;
c0de050c:	7747      	strb	r7, [r0, #29]
      (origin_defi_parameters_t *)msg->pluginContext;
c0de050e:	6885      	ldr	r5, [r0, #8]
c0de0510:	209c      	movs	r0, #156	; 0x9c
  if ((context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT ||
c0de0512:	5c2e      	ldrb	r6, [r5, r0]
c0de0514:	1ff0      	subs	r0, r6, #7
c0de0516:	2801      	cmp	r0, #1
c0de0518:	d809      	bhi.n	c0de052e <handle_finalize+0x2a>
       context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT_SINGLE) &&
      memcmp(msg->address, context->beneficiary, ADDRESS_LENGTH) != 0) {
c0de051a:	69a0      	ldr	r0, [r4, #24]
c0de051c:	4629      	mov	r1, r5
c0de051e:	3168      	adds	r1, #104	; 0x68
c0de0520:	2214      	movs	r2, #20
c0de0522:	f001 fdeb 	bl	c0de20fc <memcmp>
  if ((context->selectorIndex == UNISWAP_ROUTER_EXACT_INPUT ||
c0de0526:	2800      	cmp	r0, #0
c0de0528:	d001      	beq.n	c0de052e <handle_finalize+0x2a>
c0de052a:	2003      	movs	r0, #3
    msg->numScreens += 1;
c0de052c:	7760      	strb	r0, [r4, #29]
  }
  if ((context->selectorIndex == WRAP || context->selectorIndex == UNWRAP) &&
c0de052e:	3e0f      	subs	r6, #15
c0de0530:	2e01      	cmp	r6, #1
c0de0532:	d80a      	bhi.n	c0de054a <handle_finalize+0x46>
      memcmp(msg->address, context->beneficiary, ADDRESS_LENGTH) == 0) {
c0de0534:	69a0      	ldr	r0, [r4, #24]
c0de0536:	4629      	mov	r1, r5
c0de0538:	3168      	adds	r1, #104	; 0x68
c0de053a:	2214      	movs	r2, #20
c0de053c:	f001 fdde 	bl	c0de20fc <memcmp>
  if ((context->selectorIndex == WRAP || context->selectorIndex == UNWRAP) &&
c0de0540:	2800      	cmp	r0, #0
c0de0542:	d102      	bne.n	c0de054a <handle_finalize+0x46>
    msg->numScreens -= 1;
c0de0544:	7f60      	ldrb	r0, [r4, #29]
c0de0546:	1e40      	subs	r0, r0, #1
c0de0548:	7760      	strb	r0, [r4, #29]
  }
  if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de054a:	462e      	mov	r6, r5
c0de054c:	3640      	adds	r6, #64	; 0x40
c0de054e:	4916      	ldr	r1, [pc, #88]	; (c0de05a8 <handle_finalize+0xa4>)
c0de0550:	4479      	add	r1, pc
c0de0552:	2214      	movs	r2, #20
c0de0554:	4630      	mov	r0, r6
c0de0556:	f001 fdd1 	bl	c0de20fc <memcmp>
c0de055a:	2800      	cmp	r0, #0
c0de055c:	d005      	beq.n	c0de056a <handle_finalize+0x66>
    // Address is not network token (0xeee...) so we will need to look up the
    // token in the CAL.
    printf_hex_array("Setting address sent to: ", ADDRESS_LENGTH,
c0de055e:	4813      	ldr	r0, [pc, #76]	; (c0de05ac <handle_finalize+0xa8>)
c0de0560:	4478      	add	r0, pc
c0de0562:	4631      	mov	r1, r6
c0de0564:	f000 f828 	bl	c0de05b8 <printf_hex_array>
c0de0568:	e003      	b.n	c0de0572 <handle_finalize+0x6e>
                     context->contract_address_sent);
    msg->tokenLookup1 = context->contract_address_sent;
  } else {
    sent_network_token(context);
c0de056a:	4628      	mov	r0, r5
c0de056c:	f000 f83c 	bl	c0de05e8 <sent_network_token>
c0de0570:	2600      	movs	r6, #0
c0de0572:	60e6      	str	r6, [r4, #12]
    msg->tokenLookup1 = NULL;
  }
  if (!ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0574:	462e      	mov	r6, r5
c0de0576:	3654      	adds	r6, #84	; 0x54
c0de0578:	490d      	ldr	r1, [pc, #52]	; (c0de05b0 <handle_finalize+0xac>)
c0de057a:	4479      	add	r1, pc
c0de057c:	2214      	movs	r2, #20
c0de057e:	4630      	mov	r0, r6
c0de0580:	f001 fdbc 	bl	c0de20fc <memcmp>
c0de0584:	2800      	cmp	r0, #0
c0de0586:	d005      	beq.n	c0de0594 <handle_finalize+0x90>
    // Address is not network token (0xeee...) so we will need to look up the
    // token in the CAL.
    printf_hex_array("Setting address received to: ", ADDRESS_LENGTH,
c0de0588:	480a      	ldr	r0, [pc, #40]	; (c0de05b4 <handle_finalize+0xb0>)
c0de058a:	4478      	add	r0, pc
c0de058c:	4631      	mov	r1, r6
c0de058e:	f000 f813 	bl	c0de05b8 <printf_hex_array>
c0de0592:	e003      	b.n	c0de059c <handle_finalize+0x98>
                     context->contract_address_received);
    msg->tokenLookup2 = context->contract_address_received;
  } else {
    received_network_token(context);
c0de0594:	4628      	mov	r0, r5
c0de0596:	f000 f830 	bl	c0de05fa <received_network_token>
c0de059a:	2600      	movs	r6, #0
c0de059c:	2004      	movs	r0, #4
    msg->tokenLookup2 = NULL;
  }

  msg->uiType = ETH_UI_TYPE_GENERIC;
  msg->result = ETH_PLUGIN_RESULT_OK;
c0de059e:	77a0      	strb	r0, [r4, #30]
  msg->uiType = ETH_UI_TYPE_GENERIC;
c0de05a0:	7727      	strb	r7, [r4, #28]
c0de05a2:	6126      	str	r6, [r4, #16]
c0de05a4:	b001      	add	sp, #4
c0de05a6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de05a8:	000023b0 	.word	0x000023b0
c0de05ac:	00002177 	.word	0x00002177
c0de05b0:	00002386 	.word	0x00002386
c0de05b4:	00002080 	.word	0x00002080

c0de05b8 <printf_hex_array>:
}

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data
                                    __attribute__((unused))) {
c0de05b8:	b570      	push	{r4, r5, r6, lr}
c0de05ba:	460c      	mov	r4, r1
  PRINTF(title);
c0de05bc:	f001 f9b6 	bl	c0de192c <mcu_usb_printf>
c0de05c0:	2600      	movs	r6, #0
c0de05c2:	4d07      	ldr	r5, [pc, #28]	; (c0de05e0 <printf_hex_array+0x28>)
c0de05c4:	447d      	add	r5, pc
  for (size_t i = 0; i < len; ++i) {
    PRINTF("%02x", data[i]);
c0de05c6:	5da1      	ldrb	r1, [r4, r6]
c0de05c8:	4628      	mov	r0, r5
c0de05ca:	f001 f9af 	bl	c0de192c <mcu_usb_printf>
  for (size_t i = 0; i < len; ++i) {
c0de05ce:	1c76      	adds	r6, r6, #1
c0de05d0:	2e14      	cmp	r6, #20
c0de05d2:	d1f8      	bne.n	c0de05c6 <printf_hex_array+0xe>
  };
  PRINTF("\n");
c0de05d4:	4803      	ldr	r0, [pc, #12]	; (c0de05e4 <printf_hex_array+0x2c>)
c0de05d6:	4478      	add	r0, pc
c0de05d8:	f001 f9a8 	bl	c0de192c <mcu_usb_printf>
c0de05dc:	bd70      	pop	{r4, r5, r6, pc}
c0de05de:	46c0      	nop			; (mov r8, r8)
c0de05e0:	00001fc6 	.word	0x00001fc6
c0de05e4:	00002127 	.word	0x00002127

c0de05e8 <sent_network_token>:
static inline void sent_network_token(origin_defi_parameters_t *context) {
c0de05e8:	2192      	movs	r1, #146	; 0x92
  context->tokens_found |= TOKEN_SENT_FOUND;
c0de05ea:	5c42      	ldrb	r2, [r0, r1]
c0de05ec:	2301      	movs	r3, #1
c0de05ee:	4313      	orrs	r3, r2
c0de05f0:	5443      	strb	r3, [r0, r1]
c0de05f2:	3092      	adds	r0, #146	; 0x92
c0de05f4:	2112      	movs	r1, #18
  context->decimals_sent = WEI_TO_ETHER;
c0de05f6:	7041      	strb	r1, [r0, #1]
}
c0de05f8:	4770      	bx	lr

c0de05fa <received_network_token>:
static inline void received_network_token(origin_defi_parameters_t *context) {
c0de05fa:	2192      	movs	r1, #146	; 0x92
  context->tokens_found |= TOKEN_RECEIVED_FOUND;
c0de05fc:	5c42      	ldrb	r2, [r0, r1]
c0de05fe:	2302      	movs	r3, #2
c0de0600:	4313      	orrs	r3, r2
c0de0602:	5443      	strb	r3, [r0, r1]
c0de0604:	3092      	adds	r0, #146	; 0x92
c0de0606:	2112      	movs	r1, #18
  context->decimals_received = WEI_TO_ETHER;
c0de0608:	7081      	strb	r1, [r0, #2]
}
c0de060a:	4770      	bx	lr

c0de060c <handle_init_contract>:
  }
  return -1;
}

// Called once to init.
void handle_init_contract(void *parameters) {
c0de060c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de060e:	b081      	sub	sp, #4
c0de0610:	4604      	mov	r4, r0
  // Cast the msg to the type of structure we expect (here,
  // ethPluginInitContract_t).
  ethPluginInitContract_t *msg = (ethPluginInitContract_t *)parameters;

  // Make sure we are running a compatible version.
  if (msg->interfaceVersion != ETH_PLUGIN_INTERFACE_VERSION_LATEST) {
c0de0612:	7800      	ldrb	r0, [r0, #0]
c0de0614:	2701      	movs	r7, #1
c0de0616:	2806      	cmp	r0, #6
c0de0618:	d15b      	bne.n	c0de06d2 <handle_init_contract+0xc6>
    return;
  }

  // Double check that the `context_t` struct is not bigger than the maximum
  // size (defined by `msg->pluginContextLength`).
  if (msg->pluginContextLength < sizeof(origin_defi_parameters_t)) {
c0de061a:	6920      	ldr	r0, [r4, #16]
c0de061c:	289d      	cmp	r0, #157	; 0x9d
c0de061e:	d805      	bhi.n	c0de062c <handle_init_contract+0x20>
    PRINTF("Plugin parameters structure is bigger than allowed size\n");
c0de0620:	482d      	ldr	r0, [pc, #180]	; (c0de06d8 <handle_init_contract+0xcc>)
c0de0622:	4478      	add	r0, pc
c0de0624:	f001 f982 	bl	c0de192c <mcu_usb_printf>
c0de0628:	2700      	movs	r7, #0
c0de062a:	e052      	b.n	c0de06d2 <handle_init_contract+0xc6>
    msg->result = ETH_PLUGIN_RESULT_ERROR;
    return;
  }

  origin_defi_parameters_t *context =
      (origin_defi_parameters_t *)msg->pluginContext;
c0de062c:	68e5      	ldr	r5, [r4, #12]
c0de062e:	219e      	movs	r1, #158	; 0x9e

  // Initialize the context (to 0).
  memset(context, 0, sizeof(*context));
c0de0630:	4628      	mov	r0, r5
c0de0632:	f001 fd4d 	bl	c0de20d0 <__aeabi_memclr>

  uint32_t selector = U4BE(msg->selector, 0);
c0de0636:	6960      	ldr	r0, [r4, #20]
c0de0638:	f000 f856 	bl	c0de06e8 <U4BE>
  if (find_selector(selector, ORIGIN_DEFI_SELECTORS, NUM_SELECTORS,
                    &context->selectorIndex)) {
c0de063c:	462e      	mov	r6, r5
c0de063e:	369c      	adds	r6, #156	; 0x9c
  if (find_selector(selector, ORIGIN_DEFI_SELECTORS, NUM_SELECTORS,
c0de0640:	4631      	mov	r1, r6
c0de0642:	f000 f85d 	bl	c0de0700 <find_selector>
c0de0646:	2800      	cmp	r0, #0
c0de0648:	d143      	bne.n	c0de06d2 <handle_init_contract+0xc6>
c0de064a:	3595      	adds	r5, #149	; 0x95
  }

  // Set `next_param` to be the first field we expect to parse.
  // EDIT THIS: Adapt the `cases`, and set the `next_param` to be the first
  // parameter you expect to parse.
  switch (context->selectorIndex) {
c0de064c:	7836      	ldrb	r6, [r6, #0]
c0de064e:	2e06      	cmp	r6, #6
c0de0650:	dd05      	ble.n	c0de065e <handle_init_contract+0x52>
c0de0652:	4630      	mov	r0, r6
c0de0654:	3809      	subs	r0, #9
c0de0656:	2808      	cmp	r0, #8
c0de0658:	d212      	bcs.n	c0de0680 <handle_init_contract+0x74>
c0de065a:	2703      	movs	r7, #3
c0de065c:	e037      	b.n	c0de06ce <handle_init_contract+0xc2>
c0de065e:	2e02      	cmp	r6, #2
c0de0660:	dc06      	bgt.n	c0de0670 <handle_init_contract+0x64>
c0de0662:	2e00      	cmp	r6, #0
c0de0664:	d02d      	beq.n	c0de06c2 <handle_init_contract+0xb6>
c0de0666:	2e01      	cmp	r6, #1
c0de0668:	d0f7      	beq.n	c0de065a <handle_init_contract+0x4e>
c0de066a:	2e02      	cmp	r6, #2
c0de066c:	d00c      	beq.n	c0de0688 <handle_init_contract+0x7c>
c0de066e:	e021      	b.n	c0de06b4 <handle_init_contract+0xa8>
c0de0670:	1f30      	subs	r0, r6, #4
c0de0672:	2802      	cmp	r0, #2
c0de0674:	d30a      	bcc.n	c0de068c <handle_init_contract+0x80>
c0de0676:	2e03      	cmp	r6, #3
c0de0678:	d0ef      	beq.n	c0de065a <handle_init_contract+0x4e>
c0de067a:	2e06      	cmp	r6, #6
c0de067c:	d004      	beq.n	c0de0688 <handle_init_contract+0x7c>
c0de067e:	e019      	b.n	c0de06b4 <handle_init_contract+0xa8>
c0de0680:	2e07      	cmp	r6, #7
c0de0682:	d020      	beq.n	c0de06c6 <handle_init_contract+0xba>
c0de0684:	2e08      	cmp	r6, #8
c0de0686:	d115      	bne.n	c0de06b4 <handle_init_contract+0xa8>
c0de0688:	2700      	movs	r7, #0
c0de068a:	e020      	b.n	c0de06ce <handle_init_contract+0xc2>
    context->next_param = AMOUNT_SENT;
    break;
  case CURVE_POOL_EXCHANGE:
  case CURVE_POOL_EXCHANGE_UNDERLYING:
    if (memcmp(CURVE_OETH_POOL_ADDRESS,
               msg->pluginSharedRO->txContent->destination,
c0de068c:	68a0      	ldr	r0, [r4, #8]
c0de068e:	6801      	ldr	r1, [r0, #0]
c0de0690:	31a5      	adds	r1, #165	; 0xa5
    if (memcmp(CURVE_OETH_POOL_ADDRESS,
c0de0692:	4812      	ldr	r0, [pc, #72]	; (c0de06dc <handle_init_contract+0xd0>)
c0de0694:	4478      	add	r0, pc
c0de0696:	2214      	movs	r2, #20
c0de0698:	9100      	str	r1, [sp, #0]
c0de069a:	f001 fd2f 	bl	c0de20fc <memcmp>
c0de069e:	2700      	movs	r7, #0
               ADDRESS_LENGTH) == 0 ||
c0de06a0:	2800      	cmp	r0, #0
c0de06a2:	d014      	beq.n	c0de06ce <handle_init_contract+0xc2>
        memcmp(CURVE_OUSD_POOL_ADDRESS,
c0de06a4:	480e      	ldr	r0, [pc, #56]	; (c0de06e0 <handle_init_contract+0xd4>)
c0de06a6:	4478      	add	r0, pc
c0de06a8:	2214      	movs	r2, #20
c0de06aa:	9900      	ldr	r1, [sp, #0]
c0de06ac:	f001 fd26 	bl	c0de20fc <memcmp>
    if (memcmp(CURVE_OETH_POOL_ADDRESS,
c0de06b0:	2800      	cmp	r0, #0
c0de06b2:	d00c      	beq.n	c0de06ce <handle_init_contract+0xc2>
c0de06b4:	480b      	ldr	r0, [pc, #44]	; (c0de06e4 <handle_init_contract+0xd8>)
c0de06b6:	4478      	add	r0, pc
c0de06b8:	4631      	mov	r1, r6
c0de06ba:	f001 f937 	bl	c0de192c <mcu_usb_printf>
c0de06be:	2700      	movs	r7, #0
c0de06c0:	e007      	b.n	c0de06d2 <handle_init_contract+0xc6>
c0de06c2:	2708      	movs	r7, #8
c0de06c4:	e003      	b.n	c0de06ce <handle_init_contract+0xc2>
    return;
  case CURVE_ROUTER_EXCHANGE_MULTIPLE:
    context->next_param = TOKEN_SENT;
    break;
  case UNISWAP_ROUTER_EXACT_INPUT:
    context->skip += 2;
c0de06c6:	7828      	ldrb	r0, [r5, #0]
c0de06c8:	1c80      	adds	r0, r0, #2
c0de06ca:	7028      	strb	r0, [r5, #0]
c0de06cc:	2705      	movs	r7, #5
c0de06ce:	70ef      	strb	r7, [r5, #3]
c0de06d0:	2704      	movs	r7, #4
c0de06d2:	7067      	strb	r7, [r4, #1]
    return;
  }

  // Return valid status.
  msg->result = ETH_PLUGIN_RESULT_OK;
}
c0de06d4:	b001      	add	sp, #4
c0de06d6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de06d8:	00001eb2 	.word	0x00001eb2
c0de06dc:	00002224 	.word	0x00002224
c0de06e0:	00002226 	.word	0x00002226
c0de06e4:	000020db 	.word	0x000020db

c0de06e8 <U4BE>:
#define U4(hi3, hi2, lo1,lo0) ((((hi3)&0xFFu)<<24) | (((hi2)&0xFFu)<<16) | (((lo1)&0xFFu)<<8) | ((lo0)&0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off) {
  return (buf[off] << 8) | buf[off + 1];
}
static inline uint32_t U4BE(const uint8_t *buf, size_t off) {
  return (((uint32_t)buf[off]) << 24) | (buf[off + 1] << 16) | (buf[off + 2] << 8) | buf[off + 3];
c0de06e8:	7801      	ldrb	r1, [r0, #0]
c0de06ea:	0609      	lsls	r1, r1, #24
c0de06ec:	7842      	ldrb	r2, [r0, #1]
c0de06ee:	0412      	lsls	r2, r2, #16
c0de06f0:	1851      	adds	r1, r2, r1
c0de06f2:	7882      	ldrb	r2, [r0, #2]
c0de06f4:	0212      	lsls	r2, r2, #8
c0de06f6:	1889      	adds	r1, r1, r2
c0de06f8:	78c0      	ldrb	r0, [r0, #3]
c0de06fa:	1808      	adds	r0, r1, r0
c0de06fc:	4770      	bx	lr
c0de06fe:	d4d4      	bmi.n	c0de06aa <handle_init_contract+0x9e>

c0de0700 <find_selector>:
                         selector_t *out) {
c0de0700:	b570      	push	{r4, r5, r6, lr}
    if (selector == selectors[i]) {
c0de0702:	4b0d      	ldr	r3, [pc, #52]	; (c0de0738 <find_selector+0x38>)
c0de0704:	447b      	add	r3, pc
c0de0706:	681a      	ldr	r2, [r3, #0]
c0de0708:	4282      	cmp	r2, r0
c0de070a:	d104      	bne.n	c0de0716 <find_selector+0x16>
c0de070c:	2200      	movs	r2, #0
c0de070e:	2401      	movs	r4, #1
      *out = i;
c0de0710:	700a      	strb	r2, [r1, #0]
c0de0712:	1e60      	subs	r0, r4, #1
}
c0de0714:	bd70      	pop	{r4, r5, r6, pc}
c0de0716:	2500      	movs	r5, #0
c0de0718:	462a      	mov	r2, r5
c0de071a:	e007      	b.n	c0de072c <find_selector+0x2c>
c0de071c:	2401      	movs	r4, #1
  for (selector_t i = 0; i < n; i++) {
c0de071e:	2a10      	cmp	r2, #16
c0de0720:	d2f7      	bcs.n	c0de0712 <find_selector+0x12>
c0de0722:	1c52      	adds	r2, r2, #1
    if (selector == selectors[i]) {
c0de0724:	0096      	lsls	r6, r2, #2
c0de0726:	599e      	ldr	r6, [r3, r6]
c0de0728:	4286      	cmp	r6, r0
c0de072a:	d0f1      	beq.n	c0de0710 <find_selector+0x10>
  for (selector_t i = 0; i < n; i++) {
c0de072c:	2a10      	cmp	r2, #16
c0de072e:	d3f5      	bcc.n	c0de071c <find_selector+0x1c>
c0de0730:	462c      	mov	r4, r5
c0de0732:	2a10      	cmp	r2, #16
c0de0734:	d3f5      	bcc.n	c0de0722 <find_selector+0x22>
c0de0736:	e7ec      	b.n	c0de0712 <find_selector+0x12>
c0de0738:	000020e4 	.word	0x000020e4

c0de073c <handle_provide_parameter>:
    msg->result = ETH_PLUGIN_RESULT_ERROR;
    break;
  }
}

void handle_provide_parameter(void *parameters) {
c0de073c:	b5b0      	push	{r4, r5, r7, lr}
c0de073e:	4605      	mov	r5, r0
  ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *)parameters;
  origin_defi_parameters_t *context =
      (origin_defi_parameters_t *)msg->pluginContext;
c0de0740:	6884      	ldr	r4, [r0, #8]
  printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH,
                   msg->parameter);
c0de0742:	68c2      	ldr	r2, [r0, #12]
  printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH,
c0de0744:	4834      	ldr	r0, [pc, #208]	; (c0de0818 <handle_provide_parameter+0xdc>)
c0de0746:	4478      	add	r0, pc
c0de0748:	2120      	movs	r1, #32
c0de074a:	f000 f869 	bl	c0de0820 <printf_hex_array>
c0de074e:	2004      	movs	r0, #4

  msg->result = ETH_PLUGIN_RESULT_OK;
c0de0750:	7528      	strb	r0, [r5, #20]
c0de0752:	2095      	movs	r0, #149	; 0x95

  if (context->skip) {
c0de0754:	5c21      	ldrb	r1, [r4, r0]
c0de0756:	4620      	mov	r0, r4
c0de0758:	3095      	adds	r0, #149	; 0x95
c0de075a:	2900      	cmp	r1, #0
c0de075c:	d002      	beq.n	c0de0764 <handle_provide_parameter+0x28>
    // Skip this step, and don't forget to decrease skipping counter.
    context->skip--;
c0de075e:	1e49      	subs	r1, r1, #1
c0de0760:	7001      	strb	r1, [r0, #0]
      PRINTF("Selector Index %d not supported\n", context->selectorIndex);
      msg->result = ETH_PLUGIN_RESULT_ERROR;
      break;
    }
  }
c0de0762:	bdb0      	pop	{r4, r5, r7, pc}
    switch (context->selectorIndex) {
c0de0764:	79c1      	ldrb	r1, [r0, #7]
c0de0766:	2907      	cmp	r1, #7
c0de0768:	dc0c      	bgt.n	c0de0784 <handle_provide_parameter+0x48>
c0de076a:	2903      	cmp	r1, #3
c0de076c:	dc13      	bgt.n	c0de0796 <handle_provide_parameter+0x5a>
c0de076e:	2901      	cmp	r1, #1
c0de0770:	dc26      	bgt.n	c0de07c0 <handle_provide_parameter+0x84>
c0de0772:	2900      	cmp	r1, #0
c0de0774:	d039      	beq.n	c0de07ea <handle_provide_parameter+0xae>
c0de0776:	2901      	cmp	r1, #1
c0de0778:	d146      	bne.n	c0de0808 <handle_provide_parameter+0xcc>
      handle_zapper_deposit_sfrxeth(msg, context);
c0de077a:	4628      	mov	r0, r5
c0de077c:	4621      	mov	r1, r4
c0de077e:	f000 f879 	bl	c0de0874 <handle_zapper_deposit_sfrxeth>
c0de0782:	bdb0      	pop	{r4, r5, r7, pc}
    switch (context->selectorIndex) {
c0de0784:	4608      	mov	r0, r1
c0de0786:	3809      	subs	r0, #9
c0de0788:	2806      	cmp	r0, #6
c0de078a:	d210      	bcs.n	c0de07ae <handle_provide_parameter+0x72>
      handle_flipper_exchange(msg, context);
c0de078c:	4628      	mov	r0, r5
c0de078e:	4621      	mov	r1, r4
c0de0790:	f000 fa32 	bl	c0de0bf8 <handle_flipper_exchange>
c0de0794:	bdb0      	pop	{r4, r5, r7, pc}
    switch (context->selectorIndex) {
c0de0796:	1f08      	subs	r0, r1, #4
c0de0798:	2802      	cmp	r0, #2
c0de079a:	d31a      	bcc.n	c0de07d2 <handle_provide_parameter+0x96>
c0de079c:	2906      	cmp	r1, #6
c0de079e:	d029      	beq.n	c0de07f4 <handle_provide_parameter+0xb8>
c0de07a0:	2907      	cmp	r1, #7
c0de07a2:	d131      	bne.n	c0de0808 <handle_provide_parameter+0xcc>
      handle_uniswap_exchange(msg, context);
c0de07a4:	4628      	mov	r0, r5
c0de07a6:	4621      	mov	r1, r4
c0de07a8:	f000 f95e 	bl	c0de0a68 <handle_uniswap_exchange>
c0de07ac:	bdb0      	pop	{r4, r5, r7, pc}
    switch (context->selectorIndex) {
c0de07ae:	4608      	mov	r0, r1
c0de07b0:	380f      	subs	r0, #15
c0de07b2:	2802      	cmp	r0, #2
c0de07b4:	d212      	bcs.n	c0de07dc <handle_provide_parameter+0xa0>
      handle_wrap(msg, context);
c0de07b6:	4628      	mov	r0, r5
c0de07b8:	4621      	mov	r1, r4
c0de07ba:	f000 fa37 	bl	c0de0c2c <handle_wrap>
c0de07be:	bdb0      	pop	{r4, r5, r7, pc}
    switch (context->selectorIndex) {
c0de07c0:	2902      	cmp	r1, #2
c0de07c2:	d01c      	beq.n	c0de07fe <handle_provide_parameter+0xc2>
c0de07c4:	2903      	cmp	r1, #3
c0de07c6:	d11f      	bne.n	c0de0808 <handle_provide_parameter+0xcc>
      handle_vault_redeem(msg, context);
c0de07c8:	4628      	mov	r0, r5
c0de07ca:	4621      	mov	r1, r4
c0de07cc:	f000 f8a0 	bl	c0de0910 <handle_vault_redeem>
c0de07d0:	bdb0      	pop	{r4, r5, r7, pc}
      handle_curve_pool_exchange(msg, context);
c0de07d2:	4628      	mov	r0, r5
c0de07d4:	4621      	mov	r1, r4
c0de07d6:	f000 f8bd 	bl	c0de0954 <handle_curve_pool_exchange>
c0de07da:	bdb0      	pop	{r4, r5, r7, pc}
    switch (context->selectorIndex) {
c0de07dc:	2908      	cmp	r1, #8
c0de07de:	d113      	bne.n	c0de0808 <handle_provide_parameter+0xcc>
      handle_uniswap_exchange_single(msg, context);
c0de07e0:	4628      	mov	r0, r5
c0de07e2:	4621      	mov	r1, r4
c0de07e4:	f000 f9ca 	bl	c0de0b7c <handle_uniswap_exchange_single>
c0de07e8:	bdb0      	pop	{r4, r5, r7, pc}
      handle_zapper_deposit_eth(msg, context);
c0de07ea:	4628      	mov	r0, r5
c0de07ec:	4621      	mov	r1, r4
c0de07ee:	f000 f831 	bl	c0de0854 <handle_zapper_deposit_eth>
c0de07f2:	bdb0      	pop	{r4, r5, r7, pc}
      handle_curve_router_exchange(msg, context);
c0de07f4:	4628      	mov	r0, r5
c0de07f6:	4621      	mov	r1, r4
c0de07f8:	f000 f8e0 	bl	c0de09bc <handle_curve_router_exchange>
c0de07fc:	bdb0      	pop	{r4, r5, r7, pc}
      handle_vault_mint(msg, context);
c0de07fe:	4628      	mov	r0, r5
c0de0800:	4621      	mov	r1, r4
c0de0802:	f000 f859 	bl	c0de08b8 <handle_vault_mint>
c0de0806:	bdb0      	pop	{r4, r5, r7, pc}
      PRINTF("Selector Index %d not supported\n", context->selectorIndex);
c0de0808:	4804      	ldr	r0, [pc, #16]	; (c0de081c <handle_provide_parameter+0xe0>)
c0de080a:	4478      	add	r0, pc
c0de080c:	f001 f88e 	bl	c0de192c <mcu_usb_printf>
c0de0810:	2000      	movs	r0, #0
      msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de0812:	7528      	strb	r0, [r5, #20]
c0de0814:	bdb0      	pop	{r4, r5, r7, pc}
c0de0816:	46c0      	nop			; (mov r8, r8)
c0de0818:	00001dd4 	.word	0x00001dd4
c0de081c:	00001fa2 	.word	0x00001fa2

c0de0820 <printf_hex_array>:
                                    __attribute__((unused))) {
c0de0820:	b570      	push	{r4, r5, r6, lr}
c0de0822:	4614      	mov	r4, r2
c0de0824:	460d      	mov	r5, r1
  PRINTF(title);
c0de0826:	f001 f881 	bl	c0de192c <mcu_usb_printf>
  for (size_t i = 0; i < len; ++i) {
c0de082a:	2d00      	cmp	r5, #0
c0de082c:	d008      	beq.n	c0de0840 <printf_hex_array+0x20>
c0de082e:	4e07      	ldr	r6, [pc, #28]	; (c0de084c <printf_hex_array+0x2c>)
c0de0830:	447e      	add	r6, pc
    PRINTF("%02x", data[i]);
c0de0832:	7821      	ldrb	r1, [r4, #0]
c0de0834:	4630      	mov	r0, r6
c0de0836:	f001 f879 	bl	c0de192c <mcu_usb_printf>
  for (size_t i = 0; i < len; ++i) {
c0de083a:	1c64      	adds	r4, r4, #1
c0de083c:	1e6d      	subs	r5, r5, #1
c0de083e:	d1f8      	bne.n	c0de0832 <printf_hex_array+0x12>
  PRINTF("\n");
c0de0840:	4803      	ldr	r0, [pc, #12]	; (c0de0850 <printf_hex_array+0x30>)
c0de0842:	4478      	add	r0, pc
c0de0844:	f001 f872 	bl	c0de192c <mcu_usb_printf>
c0de0848:	bd70      	pop	{r4, r5, r6, pc}
c0de084a:	46c0      	nop			; (mov r8, r8)
c0de084c:	00001d5a 	.word	0x00001d5a
c0de0850:	00001ebb 	.word	0x00001ebb

c0de0854 <handle_zapper_deposit_eth>:
                                      origin_defi_parameters_t *context) {
c0de0854:	b510      	push	{r4, lr}
c0de0856:	4604      	mov	r4, r0
c0de0858:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de085a:	5c09      	ldrb	r1, [r1, r0]
c0de085c:	2908      	cmp	r1, #8
c0de085e:	d005      	beq.n	c0de086c <handle_zapper_deposit_eth+0x18>
    PRINTF("Param not supported: %d\n", context->next_param);
c0de0860:	4803      	ldr	r0, [pc, #12]	; (c0de0870 <handle_zapper_deposit_eth+0x1c>)
c0de0862:	4478      	add	r0, pc
c0de0864:	f001 f862 	bl	c0de192c <mcu_usb_printf>
c0de0868:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de086a:	7520      	strb	r0, [r4, #20]
}
c0de086c:	bd10      	pop	{r4, pc}
c0de086e:	46c0      	nop			; (mov r8, r8)
c0de0870:	00001dc6 	.word	0x00001dc6

c0de0874 <handle_zapper_deposit_sfrxeth>:
                                          origin_defi_parameters_t *context) {
c0de0874:	b5b0      	push	{r4, r5, r7, lr}
c0de0876:	4604      	mov	r4, r0
c0de0878:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de087a:	5c08      	ldrb	r0, [r1, r0]
c0de087c:	2808      	cmp	r0, #8
c0de087e:	d017      	beq.n	c0de08b0 <handle_zapper_deposit_sfrxeth+0x3c>
c0de0880:	460d      	mov	r5, r1
c0de0882:	3598      	adds	r5, #152	; 0x98
c0de0884:	2804      	cmp	r0, #4
c0de0886:	d007      	beq.n	c0de0898 <handle_zapper_deposit_sfrxeth+0x24>
c0de0888:	2803      	cmp	r0, #3
c0de088a:	d10b      	bne.n	c0de08a4 <handle_zapper_deposit_sfrxeth+0x30>
    handle_amount_sent(msg, context);
c0de088c:	4620      	mov	r0, r4
c0de088e:	f000 f9ef 	bl	c0de0c70 <handle_amount_sent>
c0de0892:	2004      	movs	r0, #4
    context->next_param = MIN_AMOUNT_RECEIVED;
c0de0894:	7028      	strb	r0, [r5, #0]
}
c0de0896:	bdb0      	pop	{r4, r5, r7, pc}
    handle_min_amount_received(msg, context);
c0de0898:	4620      	mov	r0, r4
c0de089a:	f000 f9f1 	bl	c0de0c80 <handle_min_amount_received>
c0de089e:	2008      	movs	r0, #8
    context->next_param = NONE;
c0de08a0:	7028      	strb	r0, [r5, #0]
}
c0de08a2:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Param not supported\n");
c0de08a4:	4803      	ldr	r0, [pc, #12]	; (c0de08b4 <handle_zapper_deposit_sfrxeth+0x40>)
c0de08a6:	4478      	add	r0, pc
c0de08a8:	f001 f840 	bl	c0de192c <mcu_usb_printf>
c0de08ac:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de08ae:	7520      	strb	r0, [r4, #20]
}
c0de08b0:	bdb0      	pop	{r4, r5, r7, pc}
c0de08b2:	46c0      	nop			; (mov r8, r8)
c0de08b4:	00001c96 	.word	0x00001c96

c0de08b8 <handle_vault_mint>:
                              origin_defi_parameters_t *context) {
c0de08b8:	b5b0      	push	{r4, r5, r7, lr}
c0de08ba:	4604      	mov	r4, r0
c0de08bc:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de08be:	5c08      	ldrb	r0, [r1, r0]
c0de08c0:	460d      	mov	r5, r1
c0de08c2:	3598      	adds	r5, #152	; 0x98
c0de08c4:	2803      	cmp	r0, #3
c0de08c6:	dc09      	bgt.n	c0de08dc <handle_vault_mint+0x24>
c0de08c8:	2800      	cmp	r0, #0
c0de08ca:	d013      	beq.n	c0de08f4 <handle_vault_mint+0x3c>
c0de08cc:	2803      	cmp	r0, #3
c0de08ce:	d10a      	bne.n	c0de08e6 <handle_vault_mint+0x2e>
    handle_amount_sent(msg, context);
c0de08d0:	4620      	mov	r0, r4
c0de08d2:	f000 f9cd 	bl	c0de0c70 <handle_amount_sent>
c0de08d6:	2004      	movs	r0, #4
c0de08d8:	7028      	strb	r0, [r5, #0]
}
c0de08da:	bdb0      	pop	{r4, r5, r7, pc}
  switch (context->next_param) {
c0de08dc:	2804      	cmp	r0, #4
c0de08de:	d00f      	beq.n	c0de0900 <handle_vault_mint+0x48>
c0de08e0:	2808      	cmp	r0, #8
c0de08e2:	d100      	bne.n	c0de08e6 <handle_vault_mint+0x2e>
}
c0de08e4:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Param not supported\n");
c0de08e6:	4809      	ldr	r0, [pc, #36]	; (c0de090c <handle_vault_mint+0x54>)
c0de08e8:	4478      	add	r0, pc
c0de08ea:	f001 f81f 	bl	c0de192c <mcu_usb_printf>
c0de08ee:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de08f0:	7520      	strb	r0, [r4, #20]
}
c0de08f2:	bdb0      	pop	{r4, r5, r7, pc}
    handle_token_sent(msg, context);
c0de08f4:	4620      	mov	r0, r4
c0de08f6:	f000 f9cd 	bl	c0de0c94 <handle_token_sent>
c0de08fa:	2003      	movs	r0, #3
c0de08fc:	7028      	strb	r0, [r5, #0]
}
c0de08fe:	bdb0      	pop	{r4, r5, r7, pc}
    handle_min_amount_received(msg, context);
c0de0900:	4620      	mov	r0, r4
c0de0902:	f000 f9bd 	bl	c0de0c80 <handle_min_amount_received>
c0de0906:	2008      	movs	r0, #8
c0de0908:	7028      	strb	r0, [r5, #0]
}
c0de090a:	bdb0      	pop	{r4, r5, r7, pc}
c0de090c:	00001c54 	.word	0x00001c54

c0de0910 <handle_vault_redeem>:
                                origin_defi_parameters_t *context) {
c0de0910:	b5b0      	push	{r4, r5, r7, lr}
c0de0912:	4604      	mov	r4, r0
c0de0914:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de0916:	5c08      	ldrb	r0, [r1, r0]
c0de0918:	2808      	cmp	r0, #8
c0de091a:	d017      	beq.n	c0de094c <handle_vault_redeem+0x3c>
c0de091c:	460d      	mov	r5, r1
c0de091e:	3598      	adds	r5, #152	; 0x98
c0de0920:	2804      	cmp	r0, #4
c0de0922:	d007      	beq.n	c0de0934 <handle_vault_redeem+0x24>
c0de0924:	2803      	cmp	r0, #3
c0de0926:	d10b      	bne.n	c0de0940 <handle_vault_redeem+0x30>
    handle_amount_sent(msg, context);
c0de0928:	4620      	mov	r0, r4
c0de092a:	f000 f9a1 	bl	c0de0c70 <handle_amount_sent>
c0de092e:	2004      	movs	r0, #4
    context->next_param = MIN_AMOUNT_RECEIVED;
c0de0930:	7028      	strb	r0, [r5, #0]
}
c0de0932:	bdb0      	pop	{r4, r5, r7, pc}
    handle_min_amount_received(msg, context);
c0de0934:	4620      	mov	r0, r4
c0de0936:	f000 f9a3 	bl	c0de0c80 <handle_min_amount_received>
c0de093a:	2008      	movs	r0, #8
    context->next_param = NONE;
c0de093c:	7028      	strb	r0, [r5, #0]
}
c0de093e:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Param not supported\n");
c0de0940:	4803      	ldr	r0, [pc, #12]	; (c0de0950 <handle_vault_redeem+0x40>)
c0de0942:	4478      	add	r0, pc
c0de0944:	f000 fff2 	bl	c0de192c <mcu_usb_printf>
c0de0948:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de094a:	7520      	strb	r0, [r4, #20]
}
c0de094c:	bdb0      	pop	{r4, r5, r7, pc}
c0de094e:	46c0      	nop			; (mov r8, r8)
c0de0950:	00001bfa 	.word	0x00001bfa

c0de0954 <handle_curve_pool_exchange>:
                                       origin_defi_parameters_t *context) {
c0de0954:	b5b0      	push	{r4, r5, r7, lr}
c0de0956:	4604      	mov	r4, r0
c0de0958:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de095a:	5c08      	ldrb	r0, [r1, r0]
c0de095c:	460d      	mov	r5, r1
c0de095e:	3598      	adds	r5, #152	; 0x98
c0de0960:	2802      	cmp	r0, #2
c0de0962:	dd06      	ble.n	c0de0972 <handle_curve_pool_exchange+0x1e>
c0de0964:	2803      	cmp	r0, #3
c0de0966:	d00e      	beq.n	c0de0986 <handle_curve_pool_exchange+0x32>
c0de0968:	2804      	cmp	r0, #4
c0de096a:	d012      	beq.n	c0de0992 <handle_curve_pool_exchange+0x3e>
c0de096c:	2808      	cmp	r0, #8
c0de096e:	d11c      	bne.n	c0de09aa <handle_curve_pool_exchange+0x56>
}
c0de0970:	bdb0      	pop	{r4, r5, r7, pc}
  switch (context->next_param) {
c0de0972:	2800      	cmp	r0, #0
c0de0974:	d013      	beq.n	c0de099e <handle_curve_pool_exchange+0x4a>
c0de0976:	2801      	cmp	r0, #1
c0de0978:	d117      	bne.n	c0de09aa <handle_curve_pool_exchange+0x56>
    handle_token_received(msg, context);
c0de097a:	4620      	mov	r0, r4
c0de097c:	f000 f9f6 	bl	c0de0d6c <handle_token_received>
c0de0980:	2003      	movs	r0, #3
c0de0982:	7028      	strb	r0, [r5, #0]
}
c0de0984:	bdb0      	pop	{r4, r5, r7, pc}
    handle_amount_sent(msg, context);
c0de0986:	4620      	mov	r0, r4
c0de0988:	f000 f972 	bl	c0de0c70 <handle_amount_sent>
c0de098c:	2004      	movs	r0, #4
c0de098e:	7028      	strb	r0, [r5, #0]
}
c0de0990:	bdb0      	pop	{r4, r5, r7, pc}
    handle_min_amount_received(msg, context);
c0de0992:	4620      	mov	r0, r4
c0de0994:	f000 f974 	bl	c0de0c80 <handle_min_amount_received>
c0de0998:	2008      	movs	r0, #8
c0de099a:	7028      	strb	r0, [r5, #0]
}
c0de099c:	bdb0      	pop	{r4, r5, r7, pc}
    handle_token_sent(msg, context);
c0de099e:	4620      	mov	r0, r4
c0de09a0:	f000 f978 	bl	c0de0c94 <handle_token_sent>
c0de09a4:	2001      	movs	r0, #1
c0de09a6:	7028      	strb	r0, [r5, #0]
}
c0de09a8:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Param not supported\n");
c0de09aa:	4803      	ldr	r0, [pc, #12]	; (c0de09b8 <handle_curve_pool_exchange+0x64>)
c0de09ac:	4478      	add	r0, pc
c0de09ae:	f000 ffbd 	bl	c0de192c <mcu_usb_printf>
c0de09b2:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de09b4:	7520      	strb	r0, [r4, #20]
}
c0de09b6:	bdb0      	pop	{r4, r5, r7, pc}
c0de09b8:	00001b90 	.word	0x00001b90

c0de09bc <handle_curve_router_exchange>:
                                         origin_defi_parameters_t *context) {
c0de09bc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de09be:	b081      	sub	sp, #4
c0de09c0:	460d      	mov	r5, r1
c0de09c2:	4604      	mov	r4, r0
c0de09c4:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de09c6:	5c08      	ldrb	r0, [r1, r0]
c0de09c8:	460e      	mov	r6, r1
c0de09ca:	3695      	adds	r6, #149	; 0x95
c0de09cc:	2802      	cmp	r0, #2
c0de09ce:	dd07      	ble.n	c0de09e0 <handle_curve_router_exchange+0x24>
c0de09d0:	2803      	cmp	r0, #3
c0de09d2:	d01f      	beq.n	c0de0a14 <handle_curve_router_exchange+0x58>
c0de09d4:	2804      	cmp	r0, #4
c0de09d6:	d023      	beq.n	c0de0a20 <handle_curve_router_exchange+0x64>
c0de09d8:	2808      	cmp	r0, #8
c0de09da:	d12f      	bne.n	c0de0a3c <handle_curve_router_exchange+0x80>
}
c0de09dc:	b001      	add	sp, #4
c0de09de:	bdf0      	pop	{r4, r5, r6, r7, pc}
  switch (context->next_param) {
c0de09e0:	2800      	cmp	r0, #0
c0de09e2:	d023      	beq.n	c0de0a2c <handle_curve_router_exchange+0x70>
c0de09e4:	2801      	cmp	r0, #1
c0de09e6:	d129      	bne.n	c0de0a3c <handle_curve_router_exchange+0x80>
    PRINTF("Counter: %d\n", context->counter);
c0de09e8:	7931      	ldrb	r1, [r6, #4]
c0de09ea:	481c      	ldr	r0, [pc, #112]	; (c0de0a5c <handle_curve_router_exchange+0xa0>)
c0de09ec:	4478      	add	r0, pc
c0de09ee:	f000 ff9d 	bl	c0de192c <mcu_usb_printf>
    context->counter += 1;
c0de09f2:	7937      	ldrb	r7, [r6, #4]
c0de09f4:	1c78      	adds	r0, r7, #1
c0de09f6:	7130      	strb	r0, [r6, #4]
    if (memcmp(&msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de09f8:	68e0      	ldr	r0, [r4, #12]
c0de09fa:	300c      	adds	r0, #12
c0de09fc:	4918      	ldr	r1, [pc, #96]	; (c0de0a60 <handle_curve_router_exchange+0xa4>)
c0de09fe:	4479      	add	r1, pc
c0de0a00:	2214      	movs	r2, #20
c0de0a02:	f001 fb7b 	bl	c0de20fc <memcmp>
c0de0a06:	2800      	cmp	r0, #0
c0de0a08:	d020      	beq.n	c0de0a4c <handle_curve_router_exchange+0x90>
      handle_token_received(msg, context);
c0de0a0a:	4620      	mov	r0, r4
c0de0a0c:	4629      	mov	r1, r5
c0de0a0e:	f000 f9ad 	bl	c0de0d6c <handle_token_received>
c0de0a12:	e00f      	b.n	c0de0a34 <handle_curve_router_exchange+0x78>
    handle_amount_sent(msg, context);
c0de0a14:	4620      	mov	r0, r4
c0de0a16:	4629      	mov	r1, r5
c0de0a18:	f000 f92a 	bl	c0de0c70 <handle_amount_sent>
c0de0a1c:	2004      	movs	r0, #4
c0de0a1e:	e00a      	b.n	c0de0a36 <handle_curve_router_exchange+0x7a>
    handle_min_amount_received(msg, context);
c0de0a20:	4620      	mov	r0, r4
c0de0a22:	4629      	mov	r1, r5
c0de0a24:	f000 f92c 	bl	c0de0c80 <handle_min_amount_received>
c0de0a28:	2008      	movs	r0, #8
c0de0a2a:	e004      	b.n	c0de0a36 <handle_curve_router_exchange+0x7a>
    handle_token_sent(msg, context);
c0de0a2c:	4620      	mov	r0, r4
c0de0a2e:	4629      	mov	r1, r5
c0de0a30:	f000 f930 	bl	c0de0c94 <handle_token_sent>
c0de0a34:	2001      	movs	r0, #1
c0de0a36:	70f0      	strb	r0, [r6, #3]
}
c0de0a38:	b001      	add	sp, #4
c0de0a3a:	bdf0      	pop	{r4, r5, r6, r7, pc}
    PRINTF("Param not supported\n");
c0de0a3c:	4809      	ldr	r0, [pc, #36]	; (c0de0a64 <handle_curve_router_exchange+0xa8>)
c0de0a3e:	4478      	add	r0, pc
c0de0a40:	f000 ff74 	bl	c0de192c <mcu_usb_printf>
c0de0a44:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de0a46:	7520      	strb	r0, [r4, #20]
}
c0de0a48:	b001      	add	sp, #4
c0de0a4a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0a4c:	2003      	movs	r0, #3
      context->next_param = AMOUNT_SENT;
c0de0a4e:	5230      	strh	r0, [r6, r0]
      context->skip += 20 - context->counter;
c0de0a50:	7830      	ldrb	r0, [r6, #0]
c0de0a52:	1bc0      	subs	r0, r0, r7
c0de0a54:	3013      	adds	r0, #19
c0de0a56:	7030      	strb	r0, [r6, #0]
}
c0de0a58:	b001      	add	sp, #4
c0de0a5a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0a5c:	00001c01 	.word	0x00001c01
c0de0a60:	00001f02 	.word	0x00001f02
c0de0a64:	00001afe 	.word	0x00001afe

c0de0a68 <handle_uniswap_exchange>:
                                    origin_defi_parameters_t *context) {
c0de0a68:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0a6a:	b081      	sub	sp, #4
c0de0a6c:	460c      	mov	r4, r1
c0de0a6e:	4605      	mov	r5, r0
c0de0a70:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de0a72:	5c08      	ldrb	r0, [r1, r0]
c0de0a74:	460e      	mov	r6, r1
c0de0a76:	3695      	adds	r6, #149	; 0x95
c0de0a78:	460f      	mov	r7, r1
c0de0a7a:	379a      	adds	r7, #154	; 0x9a
c0de0a7c:	2803      	cmp	r0, #3
c0de0a7e:	dc15      	bgt.n	c0de0aac <handle_uniswap_exchange+0x44>
c0de0a80:	2801      	cmp	r0, #1
c0de0a82:	dc22      	bgt.n	c0de0aca <handle_uniswap_exchange+0x62>
c0de0a84:	2800      	cmp	r0, #0
c0de0a86:	d030      	beq.n	c0de0aea <handle_uniswap_exchange+0x82>
c0de0a88:	2801      	cmp	r0, #1
c0de0a8a:	d168      	bne.n	c0de0b5e <handle_uniswap_exchange+0xf6>
        &msg->parameter[(context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH],
c0de0a8c:	8838      	ldrh	r0, [r7, #0]
c0de0a8e:	3814      	subs	r0, #20
c0de0a90:	0ec1      	lsrs	r1, r0, #27
c0de0a92:	1841      	adds	r1, r0, r1
c0de0a94:	221f      	movs	r2, #31
c0de0a96:	4391      	bics	r1, r2
c0de0a98:	1a40      	subs	r0, r0, r1
c0de0a9a:	68e9      	ldr	r1, [r5, #12]
c0de0a9c:	1809      	adds	r1, r1, r0
        &context->contract_address_received[0],
c0de0a9e:	3454      	adds	r4, #84	; 0x54
c0de0aa0:	2214      	movs	r2, #20
    memcpy(
c0de0aa2:	4620      	mov	r0, r4
c0de0aa4:	f001 fb1a 	bl	c0de20dc <__aeabi_memcpy>
c0de0aa8:	2002      	movs	r0, #2
c0de0aaa:	e055      	b.n	c0de0b58 <handle_uniswap_exchange+0xf0>
  switch (context->next_param) {
c0de0aac:	2805      	cmp	r0, #5
c0de0aae:	dc16      	bgt.n	c0de0ade <handle_uniswap_exchange+0x76>
c0de0ab0:	2804      	cmp	r0, #4
c0de0ab2:	d032      	beq.n	c0de0b1a <handle_uniswap_exchange+0xb2>
c0de0ab4:	2805      	cmp	r0, #5
c0de0ab6:	d152      	bne.n	c0de0b5e <handle_uniswap_exchange+0xf6>
    handle_beneficiary(msg, context);
c0de0ab8:	4628      	mov	r0, r5
c0de0aba:	4621      	mov	r1, r4
c0de0abc:	f000 f9c2 	bl	c0de0e44 <handle_beneficiary>
c0de0ac0:	2003      	movs	r0, #3
    context->next_param = AMOUNT_SENT;
c0de0ac2:	70f0      	strb	r0, [r6, #3]
    context->skip += 1;
c0de0ac4:	7830      	ldrb	r0, [r6, #0]
c0de0ac6:	1c40      	adds	r0, r0, #1
c0de0ac8:	e024      	b.n	c0de0b14 <handle_uniswap_exchange+0xac>
  switch (context->next_param) {
c0de0aca:	2802      	cmp	r0, #2
c0de0acc:	d02b      	beq.n	c0de0b26 <handle_uniswap_exchange+0xbe>
c0de0ace:	2803      	cmp	r0, #3
c0de0ad0:	d145      	bne.n	c0de0b5e <handle_uniswap_exchange+0xf6>
    handle_amount_sent(msg, context);
c0de0ad2:	4628      	mov	r0, r5
c0de0ad4:	4621      	mov	r1, r4
c0de0ad6:	f000 f8cb 	bl	c0de0c70 <handle_amount_sent>
c0de0ada:	2004      	movs	r0, #4
c0de0adc:	e03c      	b.n	c0de0b58 <handle_uniswap_exchange+0xf0>
  switch (context->next_param) {
c0de0ade:	2806      	cmp	r0, #6
c0de0ae0:	d030      	beq.n	c0de0b44 <handle_uniswap_exchange+0xdc>
c0de0ae2:	2808      	cmp	r0, #8
c0de0ae4:	d13b      	bne.n	c0de0b5e <handle_uniswap_exchange+0xf6>
}
c0de0ae6:	b001      	add	sp, #4
c0de0ae8:	bdf0      	pop	{r4, r5, r6, r7, pc}
    memcpy(context->contract_address_sent, msg->parameter, ADDRESS_LENGTH);
c0de0aea:	68e9      	ldr	r1, [r5, #12]
c0de0aec:	3440      	adds	r4, #64	; 0x40
c0de0aee:	2514      	movs	r5, #20
c0de0af0:	4620      	mov	r0, r4
c0de0af2:	462a      	mov	r2, r5
c0de0af4:	f001 faf2 	bl	c0de20dc <__aeabi_memcpy>
    printf_hex_array("TOKEN_SENT: ", ADDRESS_LENGTH,
c0de0af8:	481f      	ldr	r0, [pc, #124]	; (c0de0b78 <handle_uniswap_exchange+0x110>)
c0de0afa:	4478      	add	r0, pc
c0de0afc:	4629      	mov	r1, r5
c0de0afe:	4622      	mov	r2, r4
c0de0b00:	f7ff fe8e 	bl	c0de0820 <printf_hex_array>
c0de0b04:	2001      	movs	r0, #1
    context->next_param = TOKEN_RECEIVED;
c0de0b06:	70f0      	strb	r0, [r6, #3]
    context->skip = (context->offset - ADDRESS_LENGTH) / 32 - 1;
c0de0b08:	8838      	ldrh	r0, [r7, #0]
c0de0b0a:	3814      	subs	r0, #20
c0de0b0c:	0ec1      	lsrs	r1, r0, #27
c0de0b0e:	1840      	adds	r0, r0, r1
c0de0b10:	0940      	lsrs	r0, r0, #5
c0de0b12:	1e40      	subs	r0, r0, #1
c0de0b14:	7030      	strb	r0, [r6, #0]
}
c0de0b16:	b001      	add	sp, #4
c0de0b18:	bdf0      	pop	{r4, r5, r6, r7, pc}
    handle_min_amount_received(msg, context);
c0de0b1a:	4628      	mov	r0, r5
c0de0b1c:	4621      	mov	r1, r4
c0de0b1e:	f000 f8af 	bl	c0de0c80 <handle_min_amount_received>
c0de0b22:	2006      	movs	r0, #6
c0de0b24:	e018      	b.n	c0de0b58 <handle_uniswap_exchange+0xf0>
                                            (context->offset - ADDRESS_LENGTH) %
c0de0b26:	8838      	ldrh	r0, [r7, #0]
c0de0b28:	3814      	subs	r0, #20
c0de0b2a:	0ec1      	lsrs	r1, r0, #27
c0de0b2c:	1841      	adds	r1, r0, r1
c0de0b2e:	221f      	movs	r2, #31
c0de0b30:	4391      	bics	r1, r2
c0de0b32:	1a42      	subs	r2, r0, r1
        &context->contract_address_received[PARAMETER_LENGTH -
c0de0b34:	1aa0      	subs	r0, r4, r2
        (context->offset - ADDRESS_LENGTH) % PARAMETER_LENGTH + ADDRESS_LENGTH -
c0de0b36:	3a0c      	subs	r2, #12
        &context->contract_address_received[PARAMETER_LENGTH -
c0de0b38:	3074      	adds	r0, #116	; 0x74
        &msg->parameter[0],
c0de0b3a:	68e9      	ldr	r1, [r5, #12]
    memcpy(
c0de0b3c:	f001 face 	bl	c0de20dc <__aeabi_memcpy>
c0de0b40:	2008      	movs	r0, #8
c0de0b42:	e009      	b.n	c0de0b58 <handle_uniswap_exchange+0xf0>
        U2BE(msg->parameter, PARAMETER_LENGTH - sizeof(context->offset));
c0de0b44:	68e8      	ldr	r0, [r5, #12]
c0de0b46:	f000 f995 	bl	c0de0e74 <U2BE>
c0de0b4a:	4601      	mov	r1, r0
    context->offset =
c0de0b4c:	8038      	strh	r0, [r7, #0]
    PRINTF("OFFSET: %d\n", context->offset);
c0de0b4e:	4809      	ldr	r0, [pc, #36]	; (c0de0b74 <handle_uniswap_exchange+0x10c>)
c0de0b50:	4478      	add	r0, pc
c0de0b52:	f000 feeb 	bl	c0de192c <mcu_usb_printf>
c0de0b56:	2000      	movs	r0, #0
c0de0b58:	70f0      	strb	r0, [r6, #3]
}
c0de0b5a:	b001      	add	sp, #4
c0de0b5c:	bdf0      	pop	{r4, r5, r6, r7, pc}
    PRINTF("Param not supported\n");
c0de0b5e:	4804      	ldr	r0, [pc, #16]	; (c0de0b70 <handle_uniswap_exchange+0x108>)
c0de0b60:	4478      	add	r0, pc
c0de0b62:	f000 fee3 	bl	c0de192c <mcu_usb_printf>
c0de0b66:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de0b68:	7528      	strb	r0, [r5, #20]
}
c0de0b6a:	b001      	add	sp, #4
c0de0b6c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0b6e:	46c0      	nop			; (mov r8, r8)
c0de0b70:	000019dc 	.word	0x000019dc
c0de0b74:	00001a83 	.word	0x00001a83
c0de0b78:	00001b6a 	.word	0x00001b6a

c0de0b7c <handle_uniswap_exchange_single>:
                                           origin_defi_parameters_t *context) {
c0de0b7c:	b5b0      	push	{r4, r5, r7, lr}
c0de0b7e:	4604      	mov	r4, r0
c0de0b80:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de0b82:	5c08      	ldrb	r0, [r1, r0]
c0de0b84:	460d      	mov	r5, r1
c0de0b86:	3595      	adds	r5, #149	; 0x95
c0de0b88:	2803      	cmp	r0, #3
c0de0b8a:	dc0b      	bgt.n	c0de0ba4 <handle_uniswap_exchange_single+0x28>
c0de0b8c:	2800      	cmp	r0, #0
c0de0b8e:	d010      	beq.n	c0de0bb2 <handle_uniswap_exchange_single+0x36>
c0de0b90:	2801      	cmp	r0, #1
c0de0b92:	d014      	beq.n	c0de0bbe <handle_uniswap_exchange_single+0x42>
c0de0b94:	2803      	cmp	r0, #3
c0de0b96:	d126      	bne.n	c0de0be6 <handle_uniswap_exchange_single+0x6a>
    handle_amount_sent(msg, context);
c0de0b98:	4620      	mov	r0, r4
c0de0b9a:	f000 f869 	bl	c0de0c70 <handle_amount_sent>
c0de0b9e:	2004      	movs	r0, #4
c0de0ba0:	70e8      	strb	r0, [r5, #3]
}
c0de0ba2:	bdb0      	pop	{r4, r5, r7, pc}
  switch (context->next_param) {
c0de0ba4:	2804      	cmp	r0, #4
c0de0ba6:	d00f      	beq.n	c0de0bc8 <handle_uniswap_exchange_single+0x4c>
c0de0ba8:	2805      	cmp	r0, #5
c0de0baa:	d013      	beq.n	c0de0bd4 <handle_uniswap_exchange_single+0x58>
c0de0bac:	2808      	cmp	r0, #8
c0de0bae:	d11a      	bne.n	c0de0be6 <handle_uniswap_exchange_single+0x6a>
}
c0de0bb0:	bdb0      	pop	{r4, r5, r7, pc}
    handle_token_sent(msg, context);
c0de0bb2:	4620      	mov	r0, r4
c0de0bb4:	f000 f86e 	bl	c0de0c94 <handle_token_sent>
c0de0bb8:	2001      	movs	r0, #1
c0de0bba:	70e8      	strb	r0, [r5, #3]
}
c0de0bbc:	bdb0      	pop	{r4, r5, r7, pc}
    handle_token_received(msg, context);
c0de0bbe:	4620      	mov	r0, r4
c0de0bc0:	f000 f8d4 	bl	c0de0d6c <handle_token_received>
c0de0bc4:	2005      	movs	r0, #5
c0de0bc6:	e009      	b.n	c0de0bdc <handle_uniswap_exchange_single+0x60>
    handle_min_amount_received(msg, context);
c0de0bc8:	4620      	mov	r0, r4
c0de0bca:	f000 f859 	bl	c0de0c80 <handle_min_amount_received>
c0de0bce:	2008      	movs	r0, #8
c0de0bd0:	70e8      	strb	r0, [r5, #3]
}
c0de0bd2:	bdb0      	pop	{r4, r5, r7, pc}
    handle_beneficiary(msg, context);
c0de0bd4:	4620      	mov	r0, r4
c0de0bd6:	f000 f935 	bl	c0de0e44 <handle_beneficiary>
c0de0bda:	2003      	movs	r0, #3
c0de0bdc:	70e8      	strb	r0, [r5, #3]
c0de0bde:	7828      	ldrb	r0, [r5, #0]
c0de0be0:	1c40      	adds	r0, r0, #1
c0de0be2:	7028      	strb	r0, [r5, #0]
}
c0de0be4:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Param not supported\n");
c0de0be6:	4803      	ldr	r0, [pc, #12]	; (c0de0bf4 <handle_uniswap_exchange_single+0x78>)
c0de0be8:	4478      	add	r0, pc
c0de0bea:	f000 fe9f 	bl	c0de192c <mcu_usb_printf>
c0de0bee:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de0bf0:	7520      	strb	r0, [r4, #20]
}
c0de0bf2:	bdb0      	pop	{r4, r5, r7, pc}
c0de0bf4:	00001954 	.word	0x00001954

c0de0bf8 <handle_flipper_exchange>:
                                    origin_defi_parameters_t *context) {
c0de0bf8:	b5b0      	push	{r4, r5, r7, lr}
c0de0bfa:	4604      	mov	r4, r0
c0de0bfc:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de0bfe:	5c08      	ldrb	r0, [r1, r0]
c0de0c00:	2808      	cmp	r0, #8
c0de0c02:	d00f      	beq.n	c0de0c24 <handle_flipper_exchange+0x2c>
c0de0c04:	2803      	cmp	r0, #3
c0de0c06:	d107      	bne.n	c0de0c18 <handle_flipper_exchange+0x20>
c0de0c08:	460d      	mov	r5, r1
c0de0c0a:	3598      	adds	r5, #152	; 0x98
    handle_amount_sent(msg, context);
c0de0c0c:	4620      	mov	r0, r4
c0de0c0e:	f000 f82f 	bl	c0de0c70 <handle_amount_sent>
c0de0c12:	2008      	movs	r0, #8
    context->next_param = NONE;
c0de0c14:	7028      	strb	r0, [r5, #0]
}
c0de0c16:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Param not supported\n");
c0de0c18:	4803      	ldr	r0, [pc, #12]	; (c0de0c28 <handle_flipper_exchange+0x30>)
c0de0c1a:	4478      	add	r0, pc
c0de0c1c:	f000 fe86 	bl	c0de192c <mcu_usb_printf>
c0de0c20:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de0c22:	7520      	strb	r0, [r4, #20]
}
c0de0c24:	bdb0      	pop	{r4, r5, r7, pc}
c0de0c26:	46c0      	nop			; (mov r8, r8)
c0de0c28:	00001922 	.word	0x00001922

c0de0c2c <handle_wrap>:
                        origin_defi_parameters_t *context) {
c0de0c2c:	b5b0      	push	{r4, r5, r7, lr}
c0de0c2e:	4604      	mov	r4, r0
c0de0c30:	2098      	movs	r0, #152	; 0x98
  switch (context->next_param) {
c0de0c32:	5c08      	ldrb	r0, [r1, r0]
c0de0c34:	2808      	cmp	r0, #8
c0de0c36:	d017      	beq.n	c0de0c68 <handle_wrap+0x3c>
c0de0c38:	460d      	mov	r5, r1
c0de0c3a:	3598      	adds	r5, #152	; 0x98
c0de0c3c:	2805      	cmp	r0, #5
c0de0c3e:	d007      	beq.n	c0de0c50 <handle_wrap+0x24>
c0de0c40:	2803      	cmp	r0, #3
c0de0c42:	d10b      	bne.n	c0de0c5c <handle_wrap+0x30>
    handle_amount_sent(msg, context);
c0de0c44:	4620      	mov	r0, r4
c0de0c46:	f000 f813 	bl	c0de0c70 <handle_amount_sent>
c0de0c4a:	2005      	movs	r0, #5
    context->next_param = BENEFICIARY;
c0de0c4c:	7028      	strb	r0, [r5, #0]
}
c0de0c4e:	bdb0      	pop	{r4, r5, r7, pc}
    handle_beneficiary(msg, context);
c0de0c50:	4620      	mov	r0, r4
c0de0c52:	f000 f8f7 	bl	c0de0e44 <handle_beneficiary>
c0de0c56:	2008      	movs	r0, #8
    context->next_param = NONE;
c0de0c58:	7028      	strb	r0, [r5, #0]
}
c0de0c5a:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Param not supported\n");
c0de0c5c:	4803      	ldr	r0, [pc, #12]	; (c0de0c6c <handle_wrap+0x40>)
c0de0c5e:	4478      	add	r0, pc
c0de0c60:	f000 fe64 	bl	c0de192c <mcu_usb_printf>
c0de0c64:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de0c66:	7520      	strb	r0, [r4, #20]
}
c0de0c68:	bdb0      	pop	{r4, r5, r7, pc}
c0de0c6a:	46c0      	nop			; (mov r8, r8)
c0de0c6c:	000018de 	.word	0x000018de

c0de0c70 <handle_amount_sent>:
                               origin_defi_parameters_t *context) {
c0de0c70:	b580      	push	{r7, lr}
c0de0c72:	460b      	mov	r3, r1
  memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
c0de0c74:	68c1      	ldr	r1, [r0, #12]
c0de0c76:	2220      	movs	r2, #32
c0de0c78:	4618      	mov	r0, r3
c0de0c7a:	f001 fa2f 	bl	c0de20dc <__aeabi_memcpy>
}
c0de0c7e:	bd80      	pop	{r7, pc}

c0de0c80 <handle_min_amount_received>:
                                       origin_defi_parameters_t *context) {
c0de0c80:	b580      	push	{r7, lr}
c0de0c82:	460b      	mov	r3, r1
  memcpy(context->min_amount_received, msg->parameter, PARAMETER_LENGTH);
c0de0c84:	68c1      	ldr	r1, [r0, #12]
c0de0c86:	3320      	adds	r3, #32
c0de0c88:	2220      	movs	r2, #32
c0de0c8a:	4618      	mov	r0, r3
c0de0c8c:	f001 fa26 	bl	c0de20dc <__aeabi_memcpy>
}
c0de0c90:	bd80      	pop	{r7, pc}
c0de0c92:	d4d4      	bmi.n	c0de0c3e <handle_wrap+0x12>

c0de0c94 <handle_token_sent>:
                              origin_defi_parameters_t *context) {
c0de0c94:	b570      	push	{r4, r5, r6, lr}
c0de0c96:	460e      	mov	r6, r1
c0de0c98:	4605      	mov	r5, r0
  memset(context->contract_address_sent, 0,
c0de0c9a:	460c      	mov	r4, r1
c0de0c9c:	3440      	adds	r4, #64	; 0x40
c0de0c9e:	2114      	movs	r1, #20
c0de0ca0:	4620      	mov	r0, r4
c0de0ca2:	f001 fa15 	bl	c0de20d0 <__aeabi_memclr>
c0de0ca6:	209c      	movs	r0, #156	; 0x9c
  if (context->selectorIndex == CURVE_POOL_EXCHANGE ||
c0de0ca8:	5c30      	ldrb	r0, [r6, r0]
c0de0caa:	21fe      	movs	r1, #254	; 0xfe
c0de0cac:	4001      	ands	r1, r0
c0de0cae:	2904      	cmp	r1, #4
c0de0cb0:	d11d      	bne.n	c0de0cee <handle_token_sent+0x5a>
               msg->pluginSharedRO->txContent->destination,
c0de0cb2:	6868      	ldr	r0, [r5, #4]
c0de0cb4:	6806      	ldr	r6, [r0, #0]
c0de0cb6:	36a5      	adds	r6, #165	; 0xa5
    if (memcmp(CURVE_OETH_POOL_ADDRESS,
c0de0cb8:	4822      	ldr	r0, [pc, #136]	; (c0de0d44 <handle_token_sent+0xb0>)
c0de0cba:	4478      	add	r0, pc
c0de0cbc:	2214      	movs	r2, #20
c0de0cbe:	4631      	mov	r1, r6
c0de0cc0:	f001 fa1c 	bl	c0de20fc <memcmp>
c0de0cc4:	2800      	cmp	r0, #0
c0de0cc6:	d01f      	beq.n	c0de0d08 <handle_token_sent+0x74>
    } else if (memcmp(CURVE_OUSD_POOL_ADDRESS,
c0de0cc8:	4821      	ldr	r0, [pc, #132]	; (c0de0d50 <handle_token_sent+0xbc>)
c0de0cca:	4478      	add	r0, pc
c0de0ccc:	2214      	movs	r2, #20
c0de0cce:	4631      	mov	r1, r6
c0de0cd0:	f001 fa14 	bl	c0de20fc <memcmp>
c0de0cd4:	2800      	cmp	r0, #0
c0de0cd6:	d110      	bne.n	c0de0cfa <handle_token_sent+0x66>
      switch (msg->parameter[PARAMETER_LENGTH - 1]) {
c0de0cd8:	68e8      	ldr	r0, [r5, #12]
c0de0cda:	7fc0      	ldrb	r0, [r0, #31]
c0de0cdc:	2801      	cmp	r0, #1
c0de0cde:	dc1f      	bgt.n	c0de0d20 <handle_token_sent+0x8c>
c0de0ce0:	2800      	cmp	r0, #0
c0de0ce2:	d029      	beq.n	c0de0d38 <handle_token_sent+0xa4>
c0de0ce4:	2801      	cmp	r0, #1
c0de0ce6:	d122      	bne.n	c0de0d2e <handle_token_sent+0x9a>
        memcpy(context->contract_address_sent, DAI_ADDRESS, ADDRESS_LENGTH);
c0de0ce8:	491a      	ldr	r1, [pc, #104]	; (c0de0d54 <handle_token_sent+0xc0>)
c0de0cea:	4479      	add	r1, pc
c0de0cec:	e001      	b.n	c0de0cf2 <handle_token_sent+0x5e>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH], ADDRESS_LENGTH);
c0de0cee:	68e9      	ldr	r1, [r5, #12]
c0de0cf0:	310c      	adds	r1, #12
c0de0cf2:	2214      	movs	r2, #20
c0de0cf4:	4620      	mov	r0, r4
c0de0cf6:	f001 f9f1 	bl	c0de20dc <__aeabi_memcpy>
  printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH,
c0de0cfa:	481b      	ldr	r0, [pc, #108]	; (c0de0d68 <handle_token_sent+0xd4>)
c0de0cfc:	4478      	add	r0, pc
c0de0cfe:	2114      	movs	r1, #20
c0de0d00:	4622      	mov	r2, r4
c0de0d02:	f7ff fd8d 	bl	c0de0820 <printf_hex_array>
}
c0de0d06:	bd70      	pop	{r4, r5, r6, pc}
      switch (msg->parameter[PARAMETER_LENGTH - 1]) {
c0de0d08:	68e8      	ldr	r0, [r5, #12]
c0de0d0a:	7fc0      	ldrb	r0, [r0, #31]
c0de0d0c:	2801      	cmp	r0, #1
c0de0d0e:	d004      	beq.n	c0de0d1a <handle_token_sent+0x86>
c0de0d10:	2800      	cmp	r0, #0
c0de0d12:	d10c      	bne.n	c0de0d2e <handle_token_sent+0x9a>
        memcpy(context->contract_address_sent, NULL_ETH_ADDRESS,
c0de0d14:	490c      	ldr	r1, [pc, #48]	; (c0de0d48 <handle_token_sent+0xb4>)
c0de0d16:	4479      	add	r1, pc
c0de0d18:	e7eb      	b.n	c0de0cf2 <handle_token_sent+0x5e>
        memcpy(context->contract_address_sent, OETH_ADDRESS, ADDRESS_LENGTH);
c0de0d1a:	490c      	ldr	r1, [pc, #48]	; (c0de0d4c <handle_token_sent+0xb8>)
c0de0d1c:	4479      	add	r1, pc
c0de0d1e:	e7e8      	b.n	c0de0cf2 <handle_token_sent+0x5e>
      switch (msg->parameter[PARAMETER_LENGTH - 1]) {
c0de0d20:	2802      	cmp	r0, #2
c0de0d22:	d00c      	beq.n	c0de0d3e <handle_token_sent+0xaa>
c0de0d24:	2803      	cmp	r0, #3
c0de0d26:	d102      	bne.n	c0de0d2e <handle_token_sent+0x9a>
        memcpy(context->contract_address_sent, USDT_ADDRESS, ADDRESS_LENGTH);
c0de0d28:	490b      	ldr	r1, [pc, #44]	; (c0de0d58 <handle_token_sent+0xc4>)
c0de0d2a:	4479      	add	r1, pc
c0de0d2c:	e7e1      	b.n	c0de0cf2 <handle_token_sent+0x5e>
c0de0d2e:	480d      	ldr	r0, [pc, #52]	; (c0de0d64 <handle_token_sent+0xd0>)
c0de0d30:	4478      	add	r0, pc
c0de0d32:	f000 fdfb 	bl	c0de192c <mcu_usb_printf>
c0de0d36:	e7e0      	b.n	c0de0cfa <handle_token_sent+0x66>
        memcpy(context->contract_address_sent, OUSD_ADDRESS, ADDRESS_LENGTH);
c0de0d38:	4908      	ldr	r1, [pc, #32]	; (c0de0d5c <handle_token_sent+0xc8>)
c0de0d3a:	4479      	add	r1, pc
c0de0d3c:	e7d9      	b.n	c0de0cf2 <handle_token_sent+0x5e>
        memcpy(context->contract_address_sent, USDC_ADDRESS, ADDRESS_LENGTH);
c0de0d3e:	4908      	ldr	r1, [pc, #32]	; (c0de0d60 <handle_token_sent+0xcc>)
c0de0d40:	4479      	add	r1, pc
c0de0d42:	e7d6      	b.n	c0de0cf2 <handle_token_sent+0x5e>
c0de0d44:	00001bfe 	.word	0x00001bfe
c0de0d48:	00001bea 	.word	0x00001bea
c0de0d4c:	00001b10 	.word	0x00001b10
c0de0d50:	00001c02 	.word	0x00001c02
c0de0d54:	00001b6a 	.word	0x00001b6a
c0de0d58:	00001b52 	.word	0x00001b52
c0de0d5c:	00001b06 	.word	0x00001b06
c0de0d60:	00001b28 	.word	0x00001b28
c0de0d64:	0000180c 	.word	0x0000180c
c0de0d68:	00001855 	.word	0x00001855

c0de0d6c <handle_token_received>:
                                  origin_defi_parameters_t *context) {
c0de0d6c:	b570      	push	{r4, r5, r6, lr}
c0de0d6e:	460e      	mov	r6, r1
c0de0d70:	4605      	mov	r5, r0
  memset(context->contract_address_received, 0,
c0de0d72:	460c      	mov	r4, r1
c0de0d74:	3454      	adds	r4, #84	; 0x54
c0de0d76:	2114      	movs	r1, #20
c0de0d78:	4620      	mov	r0, r4
c0de0d7a:	f001 f9a9 	bl	c0de20d0 <__aeabi_memclr>
c0de0d7e:	209c      	movs	r0, #156	; 0x9c
  if (context->selectorIndex == CURVE_POOL_EXCHANGE ||
c0de0d80:	5c30      	ldrb	r0, [r6, r0]
c0de0d82:	21fe      	movs	r1, #254	; 0xfe
c0de0d84:	4001      	ands	r1, r0
c0de0d86:	2904      	cmp	r1, #4
c0de0d88:	d11d      	bne.n	c0de0dc6 <handle_token_received+0x5a>
               msg->pluginSharedRO->txContent->destination,
c0de0d8a:	6868      	ldr	r0, [r5, #4]
c0de0d8c:	6806      	ldr	r6, [r0, #0]
c0de0d8e:	36a5      	adds	r6, #165	; 0xa5
    if (memcmp(CURVE_OETH_POOL_ADDRESS,
c0de0d90:	4822      	ldr	r0, [pc, #136]	; (c0de0e1c <handle_token_received+0xb0>)
c0de0d92:	4478      	add	r0, pc
c0de0d94:	2214      	movs	r2, #20
c0de0d96:	4631      	mov	r1, r6
c0de0d98:	f001 f9b0 	bl	c0de20fc <memcmp>
c0de0d9c:	2800      	cmp	r0, #0
c0de0d9e:	d01f      	beq.n	c0de0de0 <handle_token_received+0x74>
    } else if (memcmp(CURVE_OUSD_POOL_ADDRESS,
c0de0da0:	4821      	ldr	r0, [pc, #132]	; (c0de0e28 <handle_token_received+0xbc>)
c0de0da2:	4478      	add	r0, pc
c0de0da4:	2214      	movs	r2, #20
c0de0da6:	4631      	mov	r1, r6
c0de0da8:	f001 f9a8 	bl	c0de20fc <memcmp>
c0de0dac:	2800      	cmp	r0, #0
c0de0dae:	d110      	bne.n	c0de0dd2 <handle_token_received+0x66>
      switch (msg->parameter[PARAMETER_LENGTH - 1]) {
c0de0db0:	68e8      	ldr	r0, [r5, #12]
c0de0db2:	7fc0      	ldrb	r0, [r0, #31]
c0de0db4:	2801      	cmp	r0, #1
c0de0db6:	dc1f      	bgt.n	c0de0df8 <handle_token_received+0x8c>
c0de0db8:	2800      	cmp	r0, #0
c0de0dba:	d029      	beq.n	c0de0e10 <handle_token_received+0xa4>
c0de0dbc:	2801      	cmp	r0, #1
c0de0dbe:	d122      	bne.n	c0de0e06 <handle_token_received+0x9a>
        memcpy(context->contract_address_received, DAI_ADDRESS, ADDRESS_LENGTH);
c0de0dc0:	491a      	ldr	r1, [pc, #104]	; (c0de0e2c <handle_token_received+0xc0>)
c0de0dc2:	4479      	add	r1, pc
c0de0dc4:	e001      	b.n	c0de0dca <handle_token_received+0x5e>
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH], ADDRESS_LENGTH);
c0de0dc6:	68e9      	ldr	r1, [r5, #12]
c0de0dc8:	310c      	adds	r1, #12
c0de0dca:	2214      	movs	r2, #20
c0de0dcc:	4620      	mov	r0, r4
c0de0dce:	f001 f985 	bl	c0de20dc <__aeabi_memcpy>
  printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH,
c0de0dd2:	481b      	ldr	r0, [pc, #108]	; (c0de0e40 <handle_token_received+0xd4>)
c0de0dd4:	4478      	add	r0, pc
c0de0dd6:	2114      	movs	r1, #20
c0de0dd8:	4622      	mov	r2, r4
c0de0dda:	f7ff fd21 	bl	c0de0820 <printf_hex_array>
}
c0de0dde:	bd70      	pop	{r4, r5, r6, pc}
      switch (msg->parameter[PARAMETER_LENGTH - 1]) {
c0de0de0:	68e8      	ldr	r0, [r5, #12]
c0de0de2:	7fc0      	ldrb	r0, [r0, #31]
c0de0de4:	2801      	cmp	r0, #1
c0de0de6:	d004      	beq.n	c0de0df2 <handle_token_received+0x86>
c0de0de8:	2800      	cmp	r0, #0
c0de0dea:	d10c      	bne.n	c0de0e06 <handle_token_received+0x9a>
        memcpy(context->contract_address_received, NULL_ETH_ADDRESS,
c0de0dec:	490c      	ldr	r1, [pc, #48]	; (c0de0e20 <handle_token_received+0xb4>)
c0de0dee:	4479      	add	r1, pc
c0de0df0:	e7eb      	b.n	c0de0dca <handle_token_received+0x5e>
        memcpy(context->contract_address_received, OETH_ADDRESS,
c0de0df2:	490c      	ldr	r1, [pc, #48]	; (c0de0e24 <handle_token_received+0xb8>)
c0de0df4:	4479      	add	r1, pc
c0de0df6:	e7e8      	b.n	c0de0dca <handle_token_received+0x5e>
      switch (msg->parameter[PARAMETER_LENGTH - 1]) {
c0de0df8:	2802      	cmp	r0, #2
c0de0dfa:	d00c      	beq.n	c0de0e16 <handle_token_received+0xaa>
c0de0dfc:	2803      	cmp	r0, #3
c0de0dfe:	d102      	bne.n	c0de0e06 <handle_token_received+0x9a>
        memcpy(context->contract_address_received, USDT_ADDRESS,
c0de0e00:	490b      	ldr	r1, [pc, #44]	; (c0de0e30 <handle_token_received+0xc4>)
c0de0e02:	4479      	add	r1, pc
c0de0e04:	e7e1      	b.n	c0de0dca <handle_token_received+0x5e>
c0de0e06:	480d      	ldr	r0, [pc, #52]	; (c0de0e3c <handle_token_received+0xd0>)
c0de0e08:	4478      	add	r0, pc
c0de0e0a:	f000 fd8f 	bl	c0de192c <mcu_usb_printf>
c0de0e0e:	e7e0      	b.n	c0de0dd2 <handle_token_received+0x66>
        memcpy(context->contract_address_received, OUSD_ADDRESS,
c0de0e10:	4908      	ldr	r1, [pc, #32]	; (c0de0e34 <handle_token_received+0xc8>)
c0de0e12:	4479      	add	r1, pc
c0de0e14:	e7d9      	b.n	c0de0dca <handle_token_received+0x5e>
        memcpy(context->contract_address_received, USDC_ADDRESS,
c0de0e16:	4908      	ldr	r1, [pc, #32]	; (c0de0e38 <handle_token_received+0xcc>)
c0de0e18:	4479      	add	r1, pc
c0de0e1a:	e7d6      	b.n	c0de0dca <handle_token_received+0x5e>
c0de0e1c:	00001b26 	.word	0x00001b26
c0de0e20:	00001b12 	.word	0x00001b12
c0de0e24:	00001a38 	.word	0x00001a38
c0de0e28:	00001b2a 	.word	0x00001b2a
c0de0e2c:	00001a92 	.word	0x00001a92
c0de0e30:	00001a7a 	.word	0x00001a7a
c0de0e34:	00001a2e 	.word	0x00001a2e
c0de0e38:	00001a50 	.word	0x00001a50
c0de0e3c:	00001734 	.word	0x00001734
c0de0e40:	000017c8 	.word	0x000017c8

c0de0e44 <handle_beneficiary>:
                               origin_defi_parameters_t *context) {
c0de0e44:	b570      	push	{r4, r5, r6, lr}
c0de0e46:	460c      	mov	r4, r1
c0de0e48:	4606      	mov	r6, r0
  memset(context->beneficiary, 0, sizeof(context->beneficiary));
c0de0e4a:	3468      	adds	r4, #104	; 0x68
c0de0e4c:	2514      	movs	r5, #20
c0de0e4e:	4620      	mov	r0, r4
c0de0e50:	4629      	mov	r1, r5
c0de0e52:	f001 f93d 	bl	c0de20d0 <__aeabi_memclr>
         &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
c0de0e56:	68f1      	ldr	r1, [r6, #12]
c0de0e58:	310c      	adds	r1, #12
  memcpy(context->beneficiary,
c0de0e5a:	4620      	mov	r0, r4
c0de0e5c:	462a      	mov	r2, r5
c0de0e5e:	f001 f93d 	bl	c0de20dc <__aeabi_memcpy>
  printf_hex_array("BENEFICIARY: ", ADDRESS_LENGTH, context->beneficiary);
c0de0e62:	4803      	ldr	r0, [pc, #12]	; (c0de0e70 <handle_beneficiary+0x2c>)
c0de0e64:	4478      	add	r0, pc
c0de0e66:	4629      	mov	r1, r5
c0de0e68:	4622      	mov	r2, r4
c0de0e6a:	f7ff fcd9 	bl	c0de0820 <printf_hex_array>
}
c0de0e6e:	bd70      	pop	{r4, r5, r6, pc}
c0de0e70:	00001796 	.word	0x00001796

c0de0e74 <U2BE>:
  return (buf[off] << 8) | buf[off + 1];
c0de0e74:	7fc1      	ldrb	r1, [r0, #31]
c0de0e76:	7f80      	ldrb	r0, [r0, #30]
c0de0e78:	0200      	lsls	r0, r0, #8
c0de0e7a:	1840      	adds	r0, r0, r1
c0de0e7c:	b280      	uxth	r0, r0
c0de0e7e:	4770      	bx	lr

c0de0e80 <handle_provide_token>:

// EDIT THIS: Adapt this function to your needs! Remember, the information for
// tokens are held in `msg->token1` and `msg->token2`. If those pointers are
// `NULL`, this means the ethereum app didn't find any info regarding the
// requested tokens!
void handle_provide_token(void *parameters) {
c0de0e80:	b570      	push	{r4, r5, r6, lr}
c0de0e82:	4604      	mov	r4, r0
  ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *)parameters;
  origin_defi_parameters_t *context =
      (origin_defi_parameters_t *)msg->pluginContext;
c0de0e84:	6885      	ldr	r5, [r0, #8]
  PRINTF("OETH plugin provide token: 0x%p, 0x%p\n", msg->item1, msg->item2);
c0de0e86:	68c1      	ldr	r1, [r0, #12]
c0de0e88:	6902      	ldr	r2, [r0, #16]
c0de0e8a:	4839      	ldr	r0, [pc, #228]	; (c0de0f70 <handle_provide_token+0xf0>)
c0de0e8c:	4478      	add	r0, pc
c0de0e8e:	f000 fd4d 	bl	c0de192c <mcu_usb_printf>
c0de0e92:	462e      	mov	r6, r5
c0de0e94:	3692      	adds	r6, #146	; 0x92
  if (!check_token_sent(context)) {
c0de0e96:	4628      	mov	r0, r5
c0de0e98:	f000 f876 	bl	c0de0f88 <check_token_sent>
c0de0e9c:	2800      	cmp	r0, #0
c0de0e9e:	d007      	beq.n	c0de0eb0 <handle_provide_token+0x30>
      // // We will need an additional screen to display a warning message.
      msg->additionalScreens++;
    }
  }

  if (!check_token_received(context)) {
c0de0ea0:	4628      	mov	r0, r5
c0de0ea2:	f000 f8bd 	bl	c0de1020 <check_token_received>
c0de0ea6:	2800      	cmp	r0, #0
c0de0ea8:	d01c      	beq.n	c0de0ee4 <handle_provide_token+0x64>
c0de0eaa:	2004      	movs	r0, #4
      // // We will need an additional screen to display a warning message.
      msg->additionalScreens++;
    }
  }

  msg->result = ETH_PLUGIN_RESULT_OK;
c0de0eac:	7560      	strb	r0, [r4, #21]
c0de0eae:	bd70      	pop	{r4, r5, r6, pc}
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de0eb0:	4628      	mov	r0, r5
c0de0eb2:	3040      	adds	r0, #64	; 0x40
c0de0eb4:	492f      	ldr	r1, [pc, #188]	; (c0de0f74 <handle_provide_token+0xf4>)
c0de0eb6:	4479      	add	r1, pc
c0de0eb8:	2214      	movs	r2, #20
c0de0eba:	f001 f91f 	bl	c0de20fc <memcmp>
c0de0ebe:	2800      	cmp	r0, #0
c0de0ec0:	d02a      	beq.n	c0de0f18 <handle_provide_token+0x98>
    } else if (msg->item1 != NULL) {
c0de0ec2:	68e0      	ldr	r0, [r4, #12]
c0de0ec4:	2800      	cmp	r0, #0
c0de0ec6:	d02f      	beq.n	c0de0f28 <handle_provide_token+0xa8>
      context->decimals_sent = msg->item1->token.decimals;
c0de0ec8:	7fc0      	ldrb	r0, [r0, #31]
c0de0eca:	7070      	strb	r0, [r6, #1]
      strlcpy(context->ticker_sent, (char *)msg->item1->token.ticker,
c0de0ecc:	68e1      	ldr	r1, [r4, #12]
c0de0ece:	4628      	mov	r0, r5
c0de0ed0:	307c      	adds	r0, #124	; 0x7c
c0de0ed2:	3114      	adds	r1, #20
c0de0ed4:	220b      	movs	r2, #11
c0de0ed6:	f001 fa8d 	bl	c0de23f4 <strlcpy>
      context->tokens_found |= TOKEN_SENT_FOUND;
c0de0eda:	7830      	ldrb	r0, [r6, #0]
c0de0edc:	2101      	movs	r1, #1
c0de0ede:	4301      	orrs	r1, r0
c0de0ee0:	7031      	strb	r1, [r6, #0]
c0de0ee2:	e7dd      	b.n	c0de0ea0 <handle_provide_token+0x20>
    if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de0ee4:	4628      	mov	r0, r5
c0de0ee6:	3054      	adds	r0, #84	; 0x54
c0de0ee8:	4924      	ldr	r1, [pc, #144]	; (c0de0f7c <handle_provide_token+0xfc>)
c0de0eea:	4479      	add	r1, pc
c0de0eec:	2214      	movs	r2, #20
c0de0eee:	f001 f905 	bl	c0de20fc <memcmp>
c0de0ef2:	2800      	cmp	r0, #0
c0de0ef4:	d014      	beq.n	c0de0f20 <handle_provide_token+0xa0>
    } else if (msg->item2 != NULL) {
c0de0ef6:	6920      	ldr	r0, [r4, #16]
c0de0ef8:	2800      	cmp	r0, #0
c0de0efa:	d022      	beq.n	c0de0f42 <handle_provide_token+0xc2>
      context->decimals_received = msg->item2->token.decimals;
c0de0efc:	7fc0      	ldrb	r0, [r0, #31]
c0de0efe:	70b0      	strb	r0, [r6, #2]
      strlcpy(context->ticker_received, (char *)msg->item2->token.ticker,
c0de0f00:	6921      	ldr	r1, [r4, #16]
c0de0f02:	3587      	adds	r5, #135	; 0x87
c0de0f04:	3114      	adds	r1, #20
c0de0f06:	220b      	movs	r2, #11
c0de0f08:	4628      	mov	r0, r5
c0de0f0a:	f001 fa73 	bl	c0de23f4 <strlcpy>
      context->tokens_found |= TOKEN_RECEIVED_FOUND;
c0de0f0e:	7830      	ldrb	r0, [r6, #0]
c0de0f10:	2102      	movs	r1, #2
c0de0f12:	4301      	orrs	r1, r0
c0de0f14:	7031      	strb	r1, [r6, #0]
c0de0f16:	e7c8      	b.n	c0de0eaa <handle_provide_token+0x2a>
      sent_network_token(context);
c0de0f18:	4628      	mov	r0, r5
c0de0f1a:	f000 f877 	bl	c0de100c <sent_network_token>
c0de0f1e:	e7bf      	b.n	c0de0ea0 <handle_provide_token+0x20>
      received_network_token(context);
c0de0f20:	4628      	mov	r0, r5
c0de0f22:	f000 f8bf 	bl	c0de10a4 <received_network_token>
c0de0f26:	e7c0      	b.n	c0de0eaa <handle_provide_token+0x2a>
c0de0f28:	2012      	movs	r0, #18
      context->decimals_sent = DEFAULT_DECIMAL;
c0de0f2a:	7070      	strb	r0, [r6, #1]
      strlcpy(context->ticker_sent, DEFAULT_TICKER,
c0de0f2c:	4628      	mov	r0, r5
c0de0f2e:	307c      	adds	r0, #124	; 0x7c
c0de0f30:	4911      	ldr	r1, [pc, #68]	; (c0de0f78 <handle_provide_token+0xf8>)
c0de0f32:	4479      	add	r1, pc
c0de0f34:	220b      	movs	r2, #11
c0de0f36:	f001 fa5d 	bl	c0de23f4 <strlcpy>
      msg->additionalScreens++;
c0de0f3a:	7d20      	ldrb	r0, [r4, #20]
c0de0f3c:	1c40      	adds	r0, r0, #1
c0de0f3e:	7520      	strb	r0, [r4, #20]
c0de0f40:	e7ae      	b.n	c0de0ea0 <handle_provide_token+0x20>
c0de0f42:	2012      	movs	r0, #18
c0de0f44:	70b0      	strb	r0, [r6, #2]
c0de0f46:	3587      	adds	r5, #135	; 0x87
    } else if (context->selectorIndex == VAULT_REDEEM) {
c0de0f48:	7ab0      	ldrb	r0, [r6, #10]
c0de0f4a:	2803      	cmp	r0, #3
c0de0f4c:	d106      	bne.n	c0de0f5c <handle_provide_token+0xdc>
      strlcpy(context->ticker_received, "UNITS",
c0de0f4e:	490c      	ldr	r1, [pc, #48]	; (c0de0f80 <handle_provide_token+0x100>)
c0de0f50:	4479      	add	r1, pc
c0de0f52:	220b      	movs	r2, #11
c0de0f54:	4628      	mov	r0, r5
c0de0f56:	f001 fa4d 	bl	c0de23f4 <strlcpy>
c0de0f5a:	e7a6      	b.n	c0de0eaa <handle_provide_token+0x2a>
      strlcpy(context->ticker_received, DEFAULT_TICKER,
c0de0f5c:	4909      	ldr	r1, [pc, #36]	; (c0de0f84 <handle_provide_token+0x104>)
c0de0f5e:	4479      	add	r1, pc
c0de0f60:	220b      	movs	r2, #11
c0de0f62:	4628      	mov	r0, r5
c0de0f64:	f001 fa46 	bl	c0de23f4 <strlcpy>
      msg->additionalScreens++;
c0de0f68:	7d20      	ldrb	r0, [r4, #20]
c0de0f6a:	1c40      	adds	r0, r0, #1
c0de0f6c:	7520      	strb	r0, [r4, #20]
c0de0f6e:	e79c      	b.n	c0de0eaa <handle_provide_token+0x2a>
c0de0f70:	000016d2 	.word	0x000016d2
c0de0f74:	00001a4a 	.word	0x00001a4a
c0de0f78:	00001804 	.word	0x00001804
c0de0f7c:	00001a16 	.word	0x00001a16
c0de0f80:	0000182c 	.word	0x0000182c
c0de0f84:	000017d8 	.word	0x000017d8

c0de0f88 <check_token_sent>:
static inline check_token_sent(origin_defi_parameters_t *context) {
c0de0f88:	b570      	push	{r4, r5, r6, lr}
c0de0f8a:	4604      	mov	r4, r0
  if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de0f8c:	4605      	mov	r5, r0
c0de0f8e:	3540      	adds	r5, #64	; 0x40
c0de0f90:	4919      	ldr	r1, [pc, #100]	; (c0de0ff8 <check_token_sent+0x70>)
c0de0f92:	4479      	add	r1, pc
c0de0f94:	2214      	movs	r2, #20
c0de0f96:	4628      	mov	r0, r5
c0de0f98:	f001 f8b0 	bl	c0de20fc <memcmp>
c0de0f9c:	2612      	movs	r6, #18
c0de0f9e:	2800      	cmp	r0, #0
c0de0fa0:	d022      	beq.n	c0de0fe8 <check_token_sent+0x60>
  } else if (ADDRESS_IS_OUSD(context->contract_address_sent)) {
c0de0fa2:	4916      	ldr	r1, [pc, #88]	; (c0de0ffc <check_token_sent+0x74>)
c0de0fa4:	4479      	add	r1, pc
c0de0fa6:	2214      	movs	r2, #20
c0de0fa8:	4628      	mov	r0, r5
c0de0faa:	f001 f8a7 	bl	c0de20fc <memcmp>
c0de0fae:	2800      	cmp	r0, #0
c0de0fb0:	d01a      	beq.n	c0de0fe8 <check_token_sent+0x60>
  } else if (ADDRESS_IS_DAI(context->contract_address_sent)) {
c0de0fb2:	4913      	ldr	r1, [pc, #76]	; (c0de1000 <check_token_sent+0x78>)
c0de0fb4:	4479      	add	r1, pc
c0de0fb6:	2214      	movs	r2, #20
c0de0fb8:	4628      	mov	r0, r5
c0de0fba:	f001 f89f 	bl	c0de20fc <memcmp>
c0de0fbe:	2800      	cmp	r0, #0
c0de0fc0:	d012      	beq.n	c0de0fe8 <check_token_sent+0x60>
  } else if (ADDRESS_IS_USDC(context->contract_address_sent)) {
c0de0fc2:	4910      	ldr	r1, [pc, #64]	; (c0de1004 <check_token_sent+0x7c>)
c0de0fc4:	4479      	add	r1, pc
c0de0fc6:	2214      	movs	r2, #20
c0de0fc8:	4628      	mov	r0, r5
c0de0fca:	f001 f897 	bl	c0de20fc <memcmp>
c0de0fce:	2606      	movs	r6, #6
c0de0fd0:	2800      	cmp	r0, #0
c0de0fd2:	d009      	beq.n	c0de0fe8 <check_token_sent+0x60>
  } else if (ADDRESS_IS_USDT(context->contract_address_sent)) {
c0de0fd4:	490c      	ldr	r1, [pc, #48]	; (c0de1008 <check_token_sent+0x80>)
c0de0fd6:	4479      	add	r1, pc
c0de0fd8:	2214      	movs	r2, #20
c0de0fda:	4628      	mov	r0, r5
c0de0fdc:	f001 f88e 	bl	c0de20fc <memcmp>
c0de0fe0:	2800      	cmp	r0, #0
c0de0fe2:	d001      	beq.n	c0de0fe8 <check_token_sent+0x60>
c0de0fe4:	2000      	movs	r0, #0
}
c0de0fe6:	bd70      	pop	{r4, r5, r6, pc}
c0de0fe8:	3492      	adds	r4, #146	; 0x92
c0de0fea:	7066      	strb	r6, [r4, #1]
c0de0fec:	7821      	ldrb	r1, [r4, #0]
c0de0fee:	2001      	movs	r0, #1
c0de0ff0:	4301      	orrs	r1, r0
c0de0ff2:	7021      	strb	r1, [r4, #0]
c0de0ff4:	bd70      	pop	{r4, r5, r6, pc}
c0de0ff6:	46c0      	nop			; (mov r8, r8)
c0de0ff8:	0000189a 	.word	0x0000189a
c0de0ffc:	0000189c 	.word	0x0000189c
c0de1000:	000018a0 	.word	0x000018a0
c0de1004:	000018a4 	.word	0x000018a4
c0de1008:	000018a6 	.word	0x000018a6

c0de100c <sent_network_token>:
static inline void sent_network_token(origin_defi_parameters_t *context) {
c0de100c:	2192      	movs	r1, #146	; 0x92
  context->tokens_found |= TOKEN_SENT_FOUND;
c0de100e:	5c42      	ldrb	r2, [r0, r1]
c0de1010:	2301      	movs	r3, #1
c0de1012:	4313      	orrs	r3, r2
c0de1014:	5443      	strb	r3, [r0, r1]
c0de1016:	3092      	adds	r0, #146	; 0x92
c0de1018:	2112      	movs	r1, #18
  context->decimals_sent = WEI_TO_ETHER;
c0de101a:	7041      	strb	r1, [r0, #1]
}
c0de101c:	4770      	bx	lr
c0de101e:	d4d4      	bmi.n	c0de0fca <check_token_sent+0x42>

c0de1020 <check_token_received>:
static inline check_token_received(origin_defi_parameters_t *context) {
c0de1020:	b570      	push	{r4, r5, r6, lr}
c0de1022:	4604      	mov	r4, r0
  if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de1024:	4605      	mov	r5, r0
c0de1026:	3554      	adds	r5, #84	; 0x54
c0de1028:	4919      	ldr	r1, [pc, #100]	; (c0de1090 <check_token_received+0x70>)
c0de102a:	4479      	add	r1, pc
c0de102c:	2214      	movs	r2, #20
c0de102e:	4628      	mov	r0, r5
c0de1030:	f001 f864 	bl	c0de20fc <memcmp>
c0de1034:	2612      	movs	r6, #18
c0de1036:	2800      	cmp	r0, #0
c0de1038:	d022      	beq.n	c0de1080 <check_token_received+0x60>
  } else if (ADDRESS_IS_OUSD(context->contract_address_received)) {
c0de103a:	4916      	ldr	r1, [pc, #88]	; (c0de1094 <check_token_received+0x74>)
c0de103c:	4479      	add	r1, pc
c0de103e:	2214      	movs	r2, #20
c0de1040:	4628      	mov	r0, r5
c0de1042:	f001 f85b 	bl	c0de20fc <memcmp>
c0de1046:	2800      	cmp	r0, #0
c0de1048:	d01a      	beq.n	c0de1080 <check_token_received+0x60>
  } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de104a:	4913      	ldr	r1, [pc, #76]	; (c0de1098 <check_token_received+0x78>)
c0de104c:	4479      	add	r1, pc
c0de104e:	2214      	movs	r2, #20
c0de1050:	4628      	mov	r0, r5
c0de1052:	f001 f853 	bl	c0de20fc <memcmp>
c0de1056:	2800      	cmp	r0, #0
c0de1058:	d012      	beq.n	c0de1080 <check_token_received+0x60>
  } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de105a:	4910      	ldr	r1, [pc, #64]	; (c0de109c <check_token_received+0x7c>)
c0de105c:	4479      	add	r1, pc
c0de105e:	2214      	movs	r2, #20
c0de1060:	4628      	mov	r0, r5
c0de1062:	f001 f84b 	bl	c0de20fc <memcmp>
c0de1066:	2606      	movs	r6, #6
c0de1068:	2800      	cmp	r0, #0
c0de106a:	d009      	beq.n	c0de1080 <check_token_received+0x60>
  } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de106c:	490c      	ldr	r1, [pc, #48]	; (c0de10a0 <check_token_received+0x80>)
c0de106e:	4479      	add	r1, pc
c0de1070:	2214      	movs	r2, #20
c0de1072:	4628      	mov	r0, r5
c0de1074:	f001 f842 	bl	c0de20fc <memcmp>
c0de1078:	2800      	cmp	r0, #0
c0de107a:	d001      	beq.n	c0de1080 <check_token_received+0x60>
c0de107c:	2000      	movs	r0, #0
}
c0de107e:	bd70      	pop	{r4, r5, r6, pc}
c0de1080:	3492      	adds	r4, #146	; 0x92
c0de1082:	70a6      	strb	r6, [r4, #2]
c0de1084:	7820      	ldrb	r0, [r4, #0]
c0de1086:	2102      	movs	r1, #2
c0de1088:	4301      	orrs	r1, r0
c0de108a:	7021      	strb	r1, [r4, #0]
c0de108c:	2001      	movs	r0, #1
c0de108e:	bd70      	pop	{r4, r5, r6, pc}
c0de1090:	00001802 	.word	0x00001802
c0de1094:	00001804 	.word	0x00001804
c0de1098:	00001808 	.word	0x00001808
c0de109c:	0000180c 	.word	0x0000180c
c0de10a0:	0000180e 	.word	0x0000180e

c0de10a4 <received_network_token>:
static inline void received_network_token(origin_defi_parameters_t *context) {
c0de10a4:	2192      	movs	r1, #146	; 0x92
  context->tokens_found |= TOKEN_RECEIVED_FOUND;
c0de10a6:	5c42      	ldrb	r2, [r0, r1]
c0de10a8:	2302      	movs	r3, #2
c0de10aa:	4313      	orrs	r3, r2
c0de10ac:	5443      	strb	r3, [r0, r1]
c0de10ae:	3092      	adds	r0, #146	; 0x92
c0de10b0:	2112      	movs	r1, #18
  context->decimals_received = WEI_TO_ETHER;
c0de10b2:	7081      	strb	r1, [r0, #2]
}
c0de10b4:	4770      	bx	lr
c0de10b6:	d4d4      	bmi.n	c0de1062 <check_token_received+0x42>

c0de10b8 <handle_query_contract_id>:
#include "origin_defi_plugin.h"

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de10b8:	b5b0      	push	{r4, r5, r7, lr}
c0de10ba:	4604      	mov	r4, r0
  ethQueryContractID_t *msg = (ethQueryContractID_t *)parameters;
  const origin_defi_parameters_t *context =
      (const origin_defi_parameters_t *)msg->pluginContext;
c0de10bc:	6885      	ldr	r5, [r0, #8]
  // msg->name will be the upper sentence displayed on the screen.
  // msg->version will be the lower sentence displayed on the screen.

  // For the first screen, display the plugin name.
  strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de10be:	68c0      	ldr	r0, [r0, #12]
c0de10c0:	6922      	ldr	r2, [r4, #16]
c0de10c2:	4917      	ldr	r1, [pc, #92]	; (c0de1120 <handle_query_contract_id+0x68>)
c0de10c4:	4479      	add	r1, pc
c0de10c6:	f001 f995 	bl	c0de23f4 <strlcpy>
c0de10ca:	209c      	movs	r0, #156	; 0x9c

  switch (context->selectorIndex) {
c0de10cc:	5c29      	ldrb	r1, [r5, r0]
c0de10ce:	2903      	cmp	r1, #3
c0de10d0:	dd05      	ble.n	c0de10de <handle_query_contract_id+0x26>
c0de10d2:	1f08      	subs	r0, r1, #4
c0de10d4:	280b      	cmp	r0, #11
c0de10d6:	d206      	bcs.n	c0de10e6 <handle_query_contract_id+0x2e>
c0de10d8:	4914      	ldr	r1, [pc, #80]	; (c0de112c <handle_query_contract_id+0x74>)
c0de10da:	4479      	add	r1, pc
c0de10dc:	e011      	b.n	c0de1102 <handle_query_contract_id+0x4a>
c0de10de:	d209      	bcs.n	c0de10f4 <handle_query_contract_id+0x3c>
c0de10e0:	4910      	ldr	r1, [pc, #64]	; (c0de1124 <handle_query_contract_id+0x6c>)
c0de10e2:	4479      	add	r1, pc
c0de10e4:	e00d      	b.n	c0de1102 <handle_query_contract_id+0x4a>
c0de10e6:	290f      	cmp	r1, #15
c0de10e8:	d009      	beq.n	c0de10fe <handle_query_contract_id+0x46>
c0de10ea:	2910      	cmp	r1, #16
c0de10ec:	d110      	bne.n	c0de1110 <handle_query_contract_id+0x58>
c0de10ee:	490e      	ldr	r1, [pc, #56]	; (c0de1128 <handle_query_contract_id+0x70>)
c0de10f0:	4479      	add	r1, pc
c0de10f2:	e006      	b.n	c0de1102 <handle_query_contract_id+0x4a>
c0de10f4:	2903      	cmp	r1, #3
c0de10f6:	d10b      	bne.n	c0de1110 <handle_query_contract_id+0x58>
c0de10f8:	490f      	ldr	r1, [pc, #60]	; (c0de1138 <handle_query_contract_id+0x80>)
c0de10fa:	4479      	add	r1, pc
c0de10fc:	e001      	b.n	c0de1102 <handle_query_contract_id+0x4a>
c0de10fe:	490c      	ldr	r1, [pc, #48]	; (c0de1130 <handle_query_contract_id+0x78>)
c0de1100:	4479      	add	r1, pc
c0de1102:	6960      	ldr	r0, [r4, #20]
c0de1104:	69a2      	ldr	r2, [r4, #24]
c0de1106:	f001 f975 	bl	c0de23f4 <strlcpy>
c0de110a:	2004      	movs	r0, #4
c0de110c:	7720      	strb	r0, [r4, #28]
    msg->result = ETH_PLUGIN_RESULT_ERROR;
    return;
  }

  msg->result = ETH_PLUGIN_RESULT_OK;
c0de110e:	bdb0      	pop	{r4, r5, r7, pc}
    PRINTF("Selector Index :%d not supported\n", context->selectorIndex);
c0de1110:	4808      	ldr	r0, [pc, #32]	; (c0de1134 <handle_query_contract_id+0x7c>)
c0de1112:	4478      	add	r0, pc
c0de1114:	f000 fc0a 	bl	c0de192c <mcu_usb_printf>
c0de1118:	2000      	movs	r0, #0
c0de111a:	7720      	strb	r0, [r4, #28]
c0de111c:	bdb0      	pop	{r4, r5, r7, pc}
c0de111e:	46c0      	nop			; (mov r8, r8)
c0de1120:	000014f4 	.word	0x000014f4
c0de1124:	000014a3 	.word	0x000014a3
c0de1128:	00001692 	.word	0x00001692
c0de112c:	000014b5 	.word	0x000014b5
c0de1130:	000015ff 	.word	0x000015ff
c0de1134:	00001625 	.word	0x00001625
c0de1138:	000014ca 	.word	0x000014ca

c0de113c <handle_query_contract_ui>:
    break;
  }
  return ERROR;
}

void handle_query_contract_ui(void *parameters) {
c0de113c:	b5b0      	push	{r4, r5, r7, lr}
c0de113e:	4604      	mov	r4, r0
  ethQueryContractUI_t *msg = (ethQueryContractUI_t *)parameters;
  origin_defi_parameters_t *context =
      (origin_defi_parameters_t *)msg->pluginContext;
c0de1140:	69c5      	ldr	r5, [r0, #28]
  memset(msg->title, 0, msg->titleLength);
c0de1142:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de1144:	6aa1      	ldr	r1, [r4, #40]	; 0x28
c0de1146:	f000 ffc3 	bl	c0de20d0 <__aeabi_memclr>
  memset(msg->msg, 0, msg->msgLength);
c0de114a:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de114c:	6b21      	ldr	r1, [r4, #48]	; 0x30
c0de114e:	f000 ffbf 	bl	c0de20d0 <__aeabi_memclr>
c0de1152:	2034      	movs	r0, #52	; 0x34
c0de1154:	2104      	movs	r1, #4
  msg->result = ETH_PLUGIN_RESULT_OK;
c0de1156:	5421      	strb	r1, [r4, r0]
  screens_t screen = get_screen(msg, context);
c0de1158:	4620      	mov	r0, r4
c0de115a:	4629      	mov	r1, r5
c0de115c:	f000 f828 	bl	c0de11b0 <get_screen>
  switch (screen) {
c0de1160:	2801      	cmp	r0, #1
c0de1162:	dc08      	bgt.n	c0de1176 <handle_query_contract_ui+0x3a>
c0de1164:	2800      	cmp	r0, #0
c0de1166:	d017      	beq.n	c0de1198 <handle_query_contract_ui+0x5c>
c0de1168:	2801      	cmp	r0, #1
c0de116a:	d10d      	bne.n	c0de1188 <handle_query_contract_ui+0x4c>
  case SEND_SCREEN:
    set_send_ui(msg, context);
    break;
  case RECEIVE_SCREEN:
    set_receive_ui(msg, context);
c0de116c:	4620      	mov	r0, r4
c0de116e:	4629      	mov	r1, r5
c0de1170:	f000 f9f0 	bl	c0de1554 <set_receive_ui>
  default:
    PRINTF("Received an invalid screenIndex\n");
    msg->result = ETH_PLUGIN_RESULT_ERROR;
    return;
  }
}
c0de1174:	bdb0      	pop	{r4, r5, r7, pc}
  switch (screen) {
c0de1176:	2802      	cmp	r0, #2
c0de1178:	d013      	beq.n	c0de11a2 <handle_query_contract_ui+0x66>
c0de117a:	2803      	cmp	r0, #3
c0de117c:	d104      	bne.n	c0de1188 <handle_query_contract_ui+0x4c>
    set_beneficiary_ui(msg, context);
c0de117e:	4620      	mov	r0, r4
c0de1180:	4629      	mov	r1, r5
c0de1182:	f000 fb2d 	bl	c0de17e0 <set_beneficiary_ui>
}
c0de1186:	bdb0      	pop	{r4, r5, r7, pc}
c0de1188:	3434      	adds	r4, #52	; 0x34
    PRINTF("Received an invalid screenIndex\n");
c0de118a:	4808      	ldr	r0, [pc, #32]	; (c0de11ac <handle_query_contract_ui+0x70>)
c0de118c:	4478      	add	r0, pc
c0de118e:	f000 fbcd 	bl	c0de192c <mcu_usb_printf>
c0de1192:	2000      	movs	r0, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de1194:	7020      	strb	r0, [r4, #0]
}
c0de1196:	bdb0      	pop	{r4, r5, r7, pc}
    set_send_ui(msg, context);
c0de1198:	4620      	mov	r0, r4
c0de119a:	4629      	mov	r1, r5
c0de119c:	f000 f87a 	bl	c0de1294 <set_send_ui>
}
c0de11a0:	bdb0      	pop	{r4, r5, r7, pc}
    set_warning_ui(msg, context);
c0de11a2:	4620      	mov	r0, r4
c0de11a4:	f000 fb08 	bl	c0de17b8 <set_warning_ui>
}
c0de11a8:	bdb0      	pop	{r4, r5, r7, pc}
c0de11aa:	46c0      	nop			; (mov r8, r8)
c0de11ac:	00001578 	.word	0x00001578

c0de11b0 <get_screen>:
                            const origin_defi_parameters_t *context) {
c0de11b0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de11b2:	2220      	movs	r2, #32
  uint8_t index = msg->screenIndex;
c0de11b4:	5c85      	ldrb	r5, [r0, r2]
c0de11b6:	2092      	movs	r0, #146	; 0x92
  bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de11b8:	5c0e      	ldrb	r6, [r1, r0]
c0de11ba:	2003      	movs	r0, #3
  bool both_tokens_found = token_received_found && token_sent_found;
c0de11bc:	4634      	mov	r4, r6
c0de11be:	4004      	ands	r4, r0
c0de11c0:	2302      	movs	r3, #2
c0de11c2:	2201      	movs	r2, #1
  switch (index) {
c0de11c4:	2d01      	cmp	r5, #1
c0de11c6:	dd0d      	ble.n	c0de11e4 <get_screen+0x34>
c0de11c8:	2d02      	cmp	r5, #2
c0de11ca:	d031      	beq.n	c0de1230 <get_screen+0x80>
c0de11cc:	2d03      	cmp	r5, #3
c0de11ce:	d033      	beq.n	c0de1238 <get_screen+0x88>
c0de11d0:	2d04      	cmp	r5, #4
c0de11d2:	d15c      	bne.n	c0de128e <get_screen+0xde>
    if (both_tokens_found) {
c0de11d4:	2c03      	cmp	r4, #3
c0de11d6:	d100      	bne.n	c0de11da <get_screen+0x2a>
c0de11d8:	2004      	movs	r0, #4
c0de11da:	2c00      	cmp	r4, #0
c0de11dc:	d001      	beq.n	c0de11e2 <get_screen+0x32>
c0de11de:	2c03      	cmp	r4, #3
c0de11e0:	d155      	bne.n	c0de128e <get_screen+0xde>
}
c0de11e2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de11e4:	4033      	ands	r3, r6
c0de11e6:	4032      	ands	r2, r6
  switch (index) {
c0de11e8:	2d00      	cmp	r5, #0
c0de11ea:	d02d      	beq.n	c0de1248 <get_screen+0x98>
c0de11ec:	2d01      	cmp	r5, #1
c0de11ee:	d14e      	bne.n	c0de128e <get_screen+0xde>
c0de11f0:	3192      	adds	r1, #146	; 0x92
      context->selectorIndex == WRAP || context->selectorIndex == UNWRAP;
c0de11f2:	7a8e      	ldrb	r6, [r1, #10]
    if (wrap) {
c0de11f4:	3e0f      	subs	r6, #15
c0de11f6:	2001      	movs	r0, #1
c0de11f8:	2e02      	cmp	r6, #2
c0de11fa:	4601      	mov	r1, r0
c0de11fc:	d300      	bcc.n	c0de1200 <get_screen+0x50>
c0de11fe:	2100      	movs	r1, #0
  bool both_tokens_found = token_received_found && token_sent_found;
c0de1200:	1ee7      	subs	r7, r4, #3
c0de1202:	427d      	negs	r5, r7
c0de1204:	417d      	adcs	r5, r7
    if (wrap) {
c0de1206:	430d      	orrs	r5, r1
  bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de1208:	4261      	negs	r1, r4
c0de120a:	4161      	adcs	r1, r4
    if (wrap) {
c0de120c:	2e02      	cmp	r6, #2
c0de120e:	d200      	bcs.n	c0de1212 <get_screen+0x62>
c0de1210:	2003      	movs	r0, #3
c0de1212:	4329      	orrs	r1, r5
c0de1214:	2d00      	cmp	r5, #0
c0de1216:	d100      	bne.n	c0de121a <get_screen+0x6a>
c0de1218:	4628      	mov	r0, r5
c0de121a:	2900      	cmp	r1, #0
c0de121c:	d100      	bne.n	c0de1220 <get_screen+0x70>
c0de121e:	2002      	movs	r0, #2
  bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de1220:	1e54      	subs	r4, r2, #1
c0de1222:	41a2      	sbcs	r2, r4
    if (wrap) {
c0de1224:	4311      	orrs	r1, r2
c0de1226:	d100      	bne.n	c0de122a <get_screen+0x7a>
c0de1228:	4608      	mov	r0, r1
c0de122a:	2900      	cmp	r1, #0
c0de122c:	d02d      	beq.n	c0de128a <get_screen+0xda>
c0de122e:	e7d8      	b.n	c0de11e2 <get_screen+0x32>
    if (both_tokens_found) {
c0de1230:	2c03      	cmp	r4, #3
c0de1232:	d120      	bne.n	c0de1276 <get_screen+0xc6>
c0de1234:	2003      	movs	r0, #3
}
c0de1236:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1238:	2c00      	cmp	r4, #0
c0de123a:	d018      	beq.n	c0de126e <get_screen+0xbe>
c0de123c:	2203      	movs	r2, #3
    if (both_tokens_found) {
c0de123e:	2c03      	cmp	r4, #3
c0de1240:	d117      	bne.n	c0de1272 <get_screen+0xc2>
c0de1242:	2204      	movs	r2, #4
c0de1244:	4610      	mov	r0, r2
c0de1246:	bdf0      	pop	{r4, r5, r6, r7, pc}
  bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de1248:	4265      	negs	r5, r4
c0de124a:	4165      	adcs	r5, r4
  bool both_tokens_found = token_received_found && token_sent_found;
c0de124c:	1ee1      	subs	r1, r4, #3
c0de124e:	4248      	negs	r0, r1
c0de1250:	4148      	adcs	r0, r1
    if (both_tokens_found) {
c0de1252:	4328      	orrs	r0, r5
  bool token_sent_found = context->tokens_found & TOKEN_SENT_FOUND;
c0de1254:	1e54      	subs	r4, r2, #1
c0de1256:	41a2      	sbcs	r2, r4
    if (both_tokens_found) {
c0de1258:	4302      	orrs	r2, r0
  bool both_tokens_not_found = !token_received_found && !token_sent_found;
c0de125a:	1e4c      	subs	r4, r1, #1
c0de125c:	41a1      	sbcs	r1, r4
    if (both_tokens_found) {
c0de125e:	2800      	cmp	r0, #0
c0de1260:	d10e      	bne.n	c0de1280 <get_screen+0xd0>
c0de1262:	2a00      	cmp	r2, #0
c0de1264:	d10f      	bne.n	c0de1286 <get_screen+0xd6>
c0de1266:	2002      	movs	r0, #2
c0de1268:	2a00      	cmp	r2, #0
c0de126a:	d00e      	beq.n	c0de128a <get_screen+0xda>
c0de126c:	e7b9      	b.n	c0de11e2 <get_screen+0x32>
    if (both_tokens_found) {
c0de126e:	2c03      	cmp	r4, #3
c0de1270:	d0e7      	beq.n	c0de1242 <get_screen+0x92>
c0de1272:	4610      	mov	r0, r2
c0de1274:	bdf0      	pop	{r4, r5, r6, r7, pc}
    } else if (both_tokens_not_found) {
c0de1276:	2c00      	cmp	r4, #0
c0de1278:	d000      	beq.n	c0de127c <get_screen+0xcc>
c0de127a:	2301      	movs	r3, #1
c0de127c:	4618      	mov	r0, r3
c0de127e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1280:	0048      	lsls	r0, r1, #1
    if (both_tokens_found) {
c0de1282:	2a00      	cmp	r2, #0
c0de1284:	d0ef      	beq.n	c0de1266 <get_screen+0xb6>
c0de1286:	2a00      	cmp	r2, #0
c0de1288:	d1ab      	bne.n	c0de11e2 <get_screen+0x32>
c0de128a:	2b00      	cmp	r3, #0
c0de128c:	d1a9      	bne.n	c0de11e2 <get_screen+0x32>
c0de128e:	2004      	movs	r0, #4
}
c0de1290:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1292:	d4d4      	bmi.n	c0de123e <get_screen+0x8e>

c0de1294 <set_send_ui>:
                        origin_defi_parameters_t *context) {
c0de1294:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1296:	b083      	sub	sp, #12
c0de1298:	460d      	mov	r5, r1
c0de129a:	4604      	mov	r4, r0
  if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_sent)) {
c0de129c:	460e      	mov	r6, r1
c0de129e:	3640      	adds	r6, #64	; 0x40
c0de12a0:	498c      	ldr	r1, [pc, #560]	; (c0de14d4 <set_send_ui+0x240>)
c0de12a2:	4479      	add	r1, pc
c0de12a4:	2214      	movs	r2, #20
c0de12a6:	4630      	mov	r0, r6
c0de12a8:	f000 ff28 	bl	c0de20fc <memcmp>
c0de12ac:	462f      	mov	r7, r5
c0de12ae:	3793      	adds	r7, #147	; 0x93
c0de12b0:	2800      	cmp	r0, #0
c0de12b2:	d02c      	beq.n	c0de130e <set_send_ui+0x7a>
  } else if (ADDRESS_IS_OETH(context->contract_address_sent)) {
c0de12b4:	4988      	ldr	r1, [pc, #544]	; (c0de14d8 <set_send_ui+0x244>)
c0de12b6:	4479      	add	r1, pc
c0de12b8:	2214      	movs	r2, #20
c0de12ba:	4630      	mov	r0, r6
c0de12bc:	f000 ff1e 	bl	c0de20fc <memcmp>
c0de12c0:	2800      	cmp	r0, #0
c0de12c2:	d029      	beq.n	c0de1318 <set_send_ui+0x84>
  } else if (ADDRESS_IS_OUSD(context->contract_address_sent)) {
c0de12c4:	4986      	ldr	r1, [pc, #536]	; (c0de14e0 <set_send_ui+0x24c>)
c0de12c6:	4479      	add	r1, pc
c0de12c8:	2214      	movs	r2, #20
c0de12ca:	4630      	mov	r0, r6
c0de12cc:	f000 ff16 	bl	c0de20fc <memcmp>
c0de12d0:	2800      	cmp	r0, #0
c0de12d2:	d026      	beq.n	c0de1322 <set_send_ui+0x8e>
  } else if (ADDRESS_IS_DAI(context->contract_address_sent)) {
c0de12d4:	4984      	ldr	r1, [pc, #528]	; (c0de14e8 <set_send_ui+0x254>)
c0de12d6:	4479      	add	r1, pc
c0de12d8:	2214      	movs	r2, #20
c0de12da:	4630      	mov	r0, r6
c0de12dc:	f000 ff0e 	bl	c0de20fc <memcmp>
c0de12e0:	2800      	cmp	r0, #0
c0de12e2:	d023      	beq.n	c0de132c <set_send_ui+0x98>
  } else if (ADDRESS_IS_USDC(context->contract_address_sent)) {
c0de12e4:	4982      	ldr	r1, [pc, #520]	; (c0de14f0 <set_send_ui+0x25c>)
c0de12e6:	4479      	add	r1, pc
c0de12e8:	2214      	movs	r2, #20
c0de12ea:	4630      	mov	r0, r6
c0de12ec:	f000 ff06 	bl	c0de20fc <memcmp>
c0de12f0:	2800      	cmp	r0, #0
c0de12f2:	d020      	beq.n	c0de1336 <set_send_ui+0xa2>
  } else if (ADDRESS_IS_USDT(context->contract_address_sent)) {
c0de12f4:	4980      	ldr	r1, [pc, #512]	; (c0de14f8 <set_send_ui+0x264>)
c0de12f6:	4479      	add	r1, pc
c0de12f8:	2214      	movs	r2, #20
c0de12fa:	4630      	mov	r0, r6
c0de12fc:	f000 fefe 	bl	c0de20fc <memcmp>
c0de1300:	2800      	cmp	r0, #0
c0de1302:	d11f      	bne.n	c0de1344 <set_send_ui+0xb0>
    strlcpy(context->ticker_sent, USDT_TICKER, sizeof(context->ticker_sent));
c0de1304:	4628      	mov	r0, r5
c0de1306:	307c      	adds	r0, #124	; 0x7c
c0de1308:	497c      	ldr	r1, [pc, #496]	; (c0de14fc <set_send_ui+0x268>)
c0de130a:	4479      	add	r1, pc
c0de130c:	e017      	b.n	c0de133e <set_send_ui+0xaa>
    strlcpy(context->ticker_sent, msg->network_ticker,
c0de130e:	4628      	mov	r0, r5
c0de1310:	307c      	adds	r0, #124	; 0x7c
c0de1312:	4621      	mov	r1, r4
c0de1314:	3110      	adds	r1, #16
c0de1316:	e012      	b.n	c0de133e <set_send_ui+0xaa>
    strlcpy(context->ticker_sent, OETH_TICKER, sizeof(context->ticker_sent));
c0de1318:	4628      	mov	r0, r5
c0de131a:	307c      	adds	r0, #124	; 0x7c
c0de131c:	496f      	ldr	r1, [pc, #444]	; (c0de14dc <set_send_ui+0x248>)
c0de131e:	4479      	add	r1, pc
c0de1320:	e00d      	b.n	c0de133e <set_send_ui+0xaa>
    strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de1322:	4628      	mov	r0, r5
c0de1324:	307c      	adds	r0, #124	; 0x7c
c0de1326:	496f      	ldr	r1, [pc, #444]	; (c0de14e4 <set_send_ui+0x250>)
c0de1328:	4479      	add	r1, pc
c0de132a:	e008      	b.n	c0de133e <set_send_ui+0xaa>
    strlcpy(context->ticker_sent, DAI_TICKER, sizeof(context->ticker_sent));
c0de132c:	4628      	mov	r0, r5
c0de132e:	307c      	adds	r0, #124	; 0x7c
c0de1330:	496e      	ldr	r1, [pc, #440]	; (c0de14ec <set_send_ui+0x258>)
c0de1332:	4479      	add	r1, pc
c0de1334:	e003      	b.n	c0de133e <set_send_ui+0xaa>
    strlcpy(context->ticker_sent, USDC_TICKER, sizeof(context->ticker_sent));
c0de1336:	4628      	mov	r0, r5
c0de1338:	307c      	adds	r0, #124	; 0x7c
c0de133a:	496e      	ldr	r1, [pc, #440]	; (c0de14f4 <set_send_ui+0x260>)
c0de133c:	4479      	add	r1, pc
c0de133e:	220b      	movs	r2, #11
c0de1340:	f001 f858 	bl	c0de23f4 <strlcpy>
c0de1344:	2020      	movs	r0, #32
  context->amount_length = INT256_LENGTH;
c0de1346:	7138      	strb	r0, [r7, #4]
  strlcpy(msg->title, "Send", msg->titleLength);
c0de1348:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de134a:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de134c:	496c      	ldr	r1, [pc, #432]	; (c0de1500 <set_send_ui+0x26c>)
c0de134e:	4479      	add	r1, pc
c0de1350:	f001 f850 	bl	c0de23f4 <strlcpy>
  switch (context->selectorIndex) {
c0de1354:	7a79      	ldrb	r1, [r7, #9]
c0de1356:	2908      	cmp	r1, #8
c0de1358:	dc13      	bgt.n	c0de1382 <set_send_ui+0xee>
c0de135a:	2902      	cmp	r1, #2
c0de135c:	dd1a      	ble.n	c0de1394 <set_send_ui+0x100>
c0de135e:	1f08      	subs	r0, r1, #4
c0de1360:	2805      	cmp	r0, #5
c0de1362:	d200      	bcs.n	c0de1366 <set_send_ui+0xd2>
c0de1364:	e0a4      	b.n	c0de14b0 <set_send_ui+0x21c>
c0de1366:	2903      	cmp	r1, #3
c0de1368:	d167      	bne.n	c0de143a <set_send_ui+0x1a6>
    strlcpy(msg->title, "Redeem", msg->titleLength);
c0de136a:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de136c:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de136e:	4966      	ldr	r1, [pc, #408]	; (c0de1508 <set_send_ui+0x274>)
c0de1370:	4479      	add	r1, pc
c0de1372:	f001 f83f 	bl	c0de23f4 <strlcpy>
    if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination,
c0de1376:	6860      	ldr	r0, [r4, #4]
c0de1378:	6801      	ldr	r1, [r0, #0]
c0de137a:	31a5      	adds	r1, #165	; 0xa5
c0de137c:	4863      	ldr	r0, [pc, #396]	; (c0de150c <set_send_ui+0x278>)
c0de137e:	4478      	add	r0, pc
c0de1380:	e083      	b.n	c0de148a <set_send_ui+0x1f6>
  switch (context->selectorIndex) {
c0de1382:	290c      	cmp	r1, #12
c0de1384:	dc11      	bgt.n	c0de13aa <set_send_ui+0x116>
c0de1386:	290a      	cmp	r1, #10
c0de1388:	dc16      	bgt.n	c0de13b8 <set_send_ui+0x124>
c0de138a:	2909      	cmp	r1, #9
c0de138c:	d05e      	beq.n	c0de144c <set_send_ui+0x1b8>
c0de138e:	290a      	cmp	r1, #10
c0de1390:	d016      	beq.n	c0de13c0 <set_send_ui+0x12c>
c0de1392:	e052      	b.n	c0de143a <set_send_ui+0x1a6>
c0de1394:	2900      	cmp	r1, #0
c0de1396:	d032      	beq.n	c0de13fe <set_send_ui+0x16a>
c0de1398:	2901      	cmp	r1, #1
c0de139a:	d043      	beq.n	c0de1424 <set_send_ui+0x190>
c0de139c:	2902      	cmp	r1, #2
c0de139e:	d14c      	bne.n	c0de143a <set_send_ui+0x1a6>
    strlcpy(msg->title, "Deposit", msg->titleLength);
c0de13a0:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de13a2:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de13a4:	4957      	ldr	r1, [pc, #348]	; (c0de1504 <set_send_ui+0x270>)
c0de13a6:	4479      	add	r1, pc
c0de13a8:	e080      	b.n	c0de14ac <set_send_ui+0x218>
  switch (context->selectorIndex) {
c0de13aa:	290e      	cmp	r1, #14
c0de13ac:	dc0d      	bgt.n	c0de13ca <set_send_ui+0x136>
c0de13ae:	290d      	cmp	r1, #13
c0de13b0:	d051      	beq.n	c0de1456 <set_send_ui+0x1c2>
c0de13b2:	290e      	cmp	r1, #14
c0de13b4:	d004      	beq.n	c0de13c0 <set_send_ui+0x12c>
c0de13b6:	e040      	b.n	c0de143a <set_send_ui+0x1a6>
c0de13b8:	290b      	cmp	r1, #11
c0de13ba:	d051      	beq.n	c0de1460 <set_send_ui+0x1cc>
c0de13bc:	290c      	cmp	r1, #12
c0de13be:	d13c      	bne.n	c0de143a <set_send_ui+0x1a6>
    strlcpy(context->ticker_sent, OUSD_TICKER, sizeof(context->ticker_sent));
c0de13c0:	4628      	mov	r0, r5
c0de13c2:	307c      	adds	r0, #124	; 0x7c
c0de13c4:	4953      	ldr	r1, [pc, #332]	; (c0de1514 <set_send_ui+0x280>)
c0de13c6:	4479      	add	r1, pc
c0de13c8:	e04e      	b.n	c0de1468 <set_send_ui+0x1d4>
  switch (context->selectorIndex) {
c0de13ca:	290f      	cmp	r1, #15
c0de13cc:	d052      	beq.n	c0de1474 <set_send_ui+0x1e0>
c0de13ce:	2910      	cmp	r1, #16
c0de13d0:	d133      	bne.n	c0de143a <set_send_ui+0x1a6>
    strlcpy(msg->title, "Unwrap", msg->titleLength);
c0de13d2:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de13d4:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de13d6:	4959      	ldr	r1, [pc, #356]	; (c0de153c <set_send_ui+0x2a8>)
c0de13d8:	4479      	add	r1, pc
c0de13da:	f001 f80b 	bl	c0de23f4 <strlcpy>
    if (memcmp(WOETH_ADDRESS, msg->pluginSharedRO->txContent->destination,
c0de13de:	6860      	ldr	r0, [r4, #4]
c0de13e0:	6801      	ldr	r1, [r0, #0]
c0de13e2:	31a5      	adds	r1, #165	; 0xa5
c0de13e4:	4856      	ldr	r0, [pc, #344]	; (c0de1540 <set_send_ui+0x2ac>)
c0de13e6:	4478      	add	r0, pc
c0de13e8:	2214      	movs	r2, #20
c0de13ea:	f000 fe87 	bl	c0de20fc <memcmp>
c0de13ee:	4601      	mov	r1, r0
c0de13f0:	4628      	mov	r0, r5
c0de13f2:	307c      	adds	r0, #124	; 0x7c
c0de13f4:	2900      	cmp	r1, #0
c0de13f6:	d056      	beq.n	c0de14a6 <set_send_ui+0x212>
      strlcpy(context->ticker_sent, WOUSD_TICKER, sizeof(context->ticker_sent));
c0de13f8:	4953      	ldr	r1, [pc, #332]	; (c0de1548 <set_send_ui+0x2b4>)
c0de13fa:	4479      	add	r1, pc
c0de13fc:	e055      	b.n	c0de14aa <set_send_ui+0x216>
    strlcpy(msg->title, "Deposit", msg->titleLength);
c0de13fe:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1400:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de1402:	4952      	ldr	r1, [pc, #328]	; (c0de154c <set_send_ui+0x2b8>)
c0de1404:	4479      	add	r1, pc
c0de1406:	f000 fff5 	bl	c0de23f4 <strlcpy>
    memcpy(context->amount_sent, &msg->pluginSharedRO->txContent->value.value,
c0de140a:	6860      	ldr	r0, [r4, #4]
c0de140c:	6801      	ldr	r1, [r0, #0]
c0de140e:	2662      	movs	r6, #98	; 0x62
           msg->pluginSharedRO->txContent->value.length);
c0de1410:	5d8a      	ldrb	r2, [r1, r6]
    memcpy(context->amount_sent, &msg->pluginSharedRO->txContent->value.value,
c0de1412:	3142      	adds	r1, #66	; 0x42
c0de1414:	4628      	mov	r0, r5
c0de1416:	f000 fe61 	bl	c0de20dc <__aeabi_memcpy>
    context->amount_length = msg->pluginSharedRO->txContent->value.length;
c0de141a:	6860      	ldr	r0, [r4, #4]
c0de141c:	6800      	ldr	r0, [r0, #0]
c0de141e:	5d80      	ldrb	r0, [r0, r6]
c0de1420:	7138      	strb	r0, [r7, #4]
c0de1422:	e045      	b.n	c0de14b0 <set_send_ui+0x21c>
    strlcpy(msg->title, "Deposit", msg->titleLength);
c0de1424:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1426:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de1428:	493c      	ldr	r1, [pc, #240]	; (c0de151c <set_send_ui+0x288>)
c0de142a:	4479      	add	r1, pc
c0de142c:	f000 ffe2 	bl	c0de23f4 <strlcpy>
    strlcpy(context->ticker_sent, SFRXETH_TICKER, sizeof(context->ticker_sent));
c0de1430:	4628      	mov	r0, r5
c0de1432:	307c      	adds	r0, #124	; 0x7c
c0de1434:	493a      	ldr	r1, [pc, #232]	; (c0de1520 <set_send_ui+0x28c>)
c0de1436:	4479      	add	r1, pc
c0de1438:	e037      	b.n	c0de14aa <set_send_ui+0x216>
    PRINTF("Unhandled selector Index: %d\n", context->selectorIndex);
c0de143a:	4837      	ldr	r0, [pc, #220]	; (c0de1518 <set_send_ui+0x284>)
c0de143c:	4478      	add	r0, pc
c0de143e:	f000 fa75 	bl	c0de192c <mcu_usb_printf>
c0de1442:	2034      	movs	r0, #52	; 0x34
c0de1444:	2100      	movs	r1, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de1446:	5421      	strb	r1, [r4, r0]
}
c0de1448:	b003      	add	sp, #12
c0de144a:	bdf0      	pop	{r4, r5, r6, r7, pc}
    strlcpy(context->ticker_sent, USDT_TICKER, sizeof(context->ticker_sent));
c0de144c:	4628      	mov	r0, r5
c0de144e:	307c      	adds	r0, #124	; 0x7c
c0de1450:	4934      	ldr	r1, [pc, #208]	; (c0de1524 <set_send_ui+0x290>)
c0de1452:	4479      	add	r1, pc
c0de1454:	e008      	b.n	c0de1468 <set_send_ui+0x1d4>
    strlcpy(context->ticker_sent, USDC_TICKER, sizeof(context->ticker_sent));
c0de1456:	4628      	mov	r0, r5
c0de1458:	307c      	adds	r0, #124	; 0x7c
c0de145a:	4934      	ldr	r1, [pc, #208]	; (c0de152c <set_send_ui+0x298>)
c0de145c:	4479      	add	r1, pc
c0de145e:	e003      	b.n	c0de1468 <set_send_ui+0x1d4>
    strlcpy(context->ticker_sent, DAI_TICKER, sizeof(context->ticker_sent));
c0de1460:	4628      	mov	r0, r5
c0de1462:	307c      	adds	r0, #124	; 0x7c
c0de1464:	4930      	ldr	r1, [pc, #192]	; (c0de1528 <set_send_ui+0x294>)
c0de1466:	4479      	add	r1, pc
c0de1468:	220b      	movs	r2, #11
c0de146a:	f000 ffc3 	bl	c0de23f4 <strlcpy>
c0de146e:	2012      	movs	r0, #18
c0de1470:	7038      	strb	r0, [r7, #0]
c0de1472:	e01d      	b.n	c0de14b0 <set_send_ui+0x21c>
    strlcpy(msg->title, "Wrap", msg->titleLength);
c0de1474:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de1476:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de1478:	492d      	ldr	r1, [pc, #180]	; (c0de1530 <set_send_ui+0x29c>)
c0de147a:	4479      	add	r1, pc
c0de147c:	f000 ffba 	bl	c0de23f4 <strlcpy>
    if (memcmp(WOETH_ADDRESS, msg->pluginSharedRO->txContent->destination,
c0de1480:	6860      	ldr	r0, [r4, #4]
c0de1482:	6801      	ldr	r1, [r0, #0]
c0de1484:	31a5      	adds	r1, #165	; 0xa5
c0de1486:	482b      	ldr	r0, [pc, #172]	; (c0de1534 <set_send_ui+0x2a0>)
c0de1488:	4478      	add	r0, pc
c0de148a:	2214      	movs	r2, #20
c0de148c:	f000 fe36 	bl	c0de20fc <memcmp>
c0de1490:	4601      	mov	r1, r0
c0de1492:	4628      	mov	r0, r5
c0de1494:	307c      	adds	r0, #124	; 0x7c
c0de1496:	2900      	cmp	r1, #0
c0de1498:	d002      	beq.n	c0de14a0 <set_send_ui+0x20c>
c0de149a:	4927      	ldr	r1, [pc, #156]	; (c0de1538 <set_send_ui+0x2a4>)
c0de149c:	4479      	add	r1, pc
c0de149e:	e004      	b.n	c0de14aa <set_send_ui+0x216>
c0de14a0:	491b      	ldr	r1, [pc, #108]	; (c0de1510 <set_send_ui+0x27c>)
c0de14a2:	4479      	add	r1, pc
c0de14a4:	e001      	b.n	c0de14aa <set_send_ui+0x216>
      strlcpy(context->ticker_sent, WOETH_TICKER, sizeof(context->ticker_sent));
c0de14a6:	4927      	ldr	r1, [pc, #156]	; (c0de1544 <set_send_ui+0x2b0>)
c0de14a8:	4479      	add	r1, pc
c0de14aa:	220b      	movs	r2, #11
c0de14ac:	f000 ffa2 	bl	c0de23f4 <strlcpy>
                 context->decimals_sent, context->ticker_sent, msg->msg,
c0de14b0:	783a      	ldrb	r2, [r7, #0]
  amountToString(context->amount_sent, context->amount_length,
c0de14b2:	7939      	ldrb	r1, [r7, #4]
                 context->decimals_sent, context->ticker_sent, msg->msg,
c0de14b4:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                 msg->msgLength);
c0de14b6:	6b23      	ldr	r3, [r4, #48]	; 0x30
  amountToString(context->amount_sent, context->amount_length,
c0de14b8:	9000      	str	r0, [sp, #0]
c0de14ba:	9301      	str	r3, [sp, #4]
                 context->decimals_sent, context->ticker_sent, msg->msg,
c0de14bc:	462b      	mov	r3, r5
c0de14be:	337c      	adds	r3, #124	; 0x7c
  amountToString(context->amount_sent, context->amount_length,
c0de14c0:	4628      	mov	r0, r5
c0de14c2:	f7fe ffdb 	bl	c0de047c <amountToString>
  PRINTF("AMOUNT SENT: %s\n", msg->msg);
c0de14c6:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de14c8:	4821      	ldr	r0, [pc, #132]	; (c0de1550 <set_send_ui+0x2bc>)
c0de14ca:	4478      	add	r0, pc
c0de14cc:	f000 fa2e 	bl	c0de192c <mcu_usb_printf>
}
c0de14d0:	b003      	add	sp, #12
c0de14d2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de14d4:	0000165e 	.word	0x0000165e
c0de14d8:	00001576 	.word	0x00001576
c0de14dc:	000014af 	.word	0x000014af
c0de14e0:	0000157a 	.word	0x0000157a
c0de14e4:	00001285 	.word	0x00001285
c0de14e8:	0000157e 	.word	0x0000157e
c0de14ec:	0000119e 	.word	0x0000119e
c0de14f0:	00001582 	.word	0x00001582
c0de14f4:	000012a3 	.word	0x000012a3
c0de14f8:	00001586 	.word	0x00001586
c0de14fc:	0000144f 	.word	0x0000144f
c0de1500:	000011bf 	.word	0x000011bf
c0de1504:	000013e3 	.word	0x000013e3
c0de1508:	00001254 	.word	0x00001254
c0de150c:	00001512 	.word	0x00001512
c0de1510:	0000132b 	.word	0x0000132b
c0de1514:	000011e7 	.word	0x000011e7
c0de1518:	00001322 	.word	0x00001322
c0de151c:	0000135f 	.word	0x0000135f
c0de1520:	0000123b 	.word	0x0000123b
c0de1524:	00001307 	.word	0x00001307
c0de1528:	0000106a 	.word	0x0000106a
c0de152c:	00001183 	.word	0x00001183
c0de1530:	00001285 	.word	0x00001285
c0de1534:	0000141c 	.word	0x0000141c
c0de1538:	00001111 	.word	0x00001111
c0de153c:	000013aa 	.word	0x000013aa
c0de1540:	000014be 	.word	0x000014be
c0de1544:	0000110a 	.word	0x0000110a
c0de1548:	000012d7 	.word	0x000012d7
c0de154c:	00001385 	.word	0x00001385
c0de1550:	0000125b 	.word	0x0000125b

c0de1554 <set_receive_ui>:
                           origin_defi_parameters_t *context) {
c0de1554:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1556:	b083      	sub	sp, #12
c0de1558:	460d      	mov	r5, r1
c0de155a:	4604      	mov	r4, r0
  if (ADDRESS_IS_NETWORK_TOKEN(context->contract_address_received)) {
c0de155c:	460e      	mov	r6, r1
c0de155e:	3654      	adds	r6, #84	; 0x54
c0de1560:	497d      	ldr	r1, [pc, #500]	; (c0de1758 <set_receive_ui+0x204>)
c0de1562:	4479      	add	r1, pc
c0de1564:	2214      	movs	r2, #20
c0de1566:	4630      	mov	r0, r6
c0de1568:	f000 fdc8 	bl	c0de20fc <memcmp>
c0de156c:	462f      	mov	r7, r5
c0de156e:	3794      	adds	r7, #148	; 0x94
c0de1570:	2800      	cmp	r0, #0
c0de1572:	d02c      	beq.n	c0de15ce <set_receive_ui+0x7a>
  } else if (ADDRESS_IS_OETH(context->contract_address_received)) {
c0de1574:	4979      	ldr	r1, [pc, #484]	; (c0de175c <set_receive_ui+0x208>)
c0de1576:	4479      	add	r1, pc
c0de1578:	2214      	movs	r2, #20
c0de157a:	4630      	mov	r0, r6
c0de157c:	f000 fdbe 	bl	c0de20fc <memcmp>
c0de1580:	2800      	cmp	r0, #0
c0de1582:	d029      	beq.n	c0de15d8 <set_receive_ui+0x84>
  } else if (ADDRESS_IS_OUSD(context->contract_address_received)) {
c0de1584:	4977      	ldr	r1, [pc, #476]	; (c0de1764 <set_receive_ui+0x210>)
c0de1586:	4479      	add	r1, pc
c0de1588:	2214      	movs	r2, #20
c0de158a:	4630      	mov	r0, r6
c0de158c:	f000 fdb6 	bl	c0de20fc <memcmp>
c0de1590:	2800      	cmp	r0, #0
c0de1592:	d026      	beq.n	c0de15e2 <set_receive_ui+0x8e>
  } else if (ADDRESS_IS_DAI(context->contract_address_received)) {
c0de1594:	4975      	ldr	r1, [pc, #468]	; (c0de176c <set_receive_ui+0x218>)
c0de1596:	4479      	add	r1, pc
c0de1598:	2214      	movs	r2, #20
c0de159a:	4630      	mov	r0, r6
c0de159c:	f000 fdae 	bl	c0de20fc <memcmp>
c0de15a0:	2800      	cmp	r0, #0
c0de15a2:	d023      	beq.n	c0de15ec <set_receive_ui+0x98>
  } else if (ADDRESS_IS_USDC(context->contract_address_received)) {
c0de15a4:	4973      	ldr	r1, [pc, #460]	; (c0de1774 <set_receive_ui+0x220>)
c0de15a6:	4479      	add	r1, pc
c0de15a8:	2214      	movs	r2, #20
c0de15aa:	4630      	mov	r0, r6
c0de15ac:	f000 fda6 	bl	c0de20fc <memcmp>
c0de15b0:	2800      	cmp	r0, #0
c0de15b2:	d020      	beq.n	c0de15f6 <set_receive_ui+0xa2>
  } else if (ADDRESS_IS_USDT(context->contract_address_received)) {
c0de15b4:	4971      	ldr	r1, [pc, #452]	; (c0de177c <set_receive_ui+0x228>)
c0de15b6:	4479      	add	r1, pc
c0de15b8:	2214      	movs	r2, #20
c0de15ba:	4630      	mov	r0, r6
c0de15bc:	f000 fd9e 	bl	c0de20fc <memcmp>
c0de15c0:	2800      	cmp	r0, #0
c0de15c2:	d11f      	bne.n	c0de1604 <set_receive_ui+0xb0>
    strlcpy(context->ticker_received, USDT_TICKER,
c0de15c4:	4628      	mov	r0, r5
c0de15c6:	3087      	adds	r0, #135	; 0x87
c0de15c8:	496d      	ldr	r1, [pc, #436]	; (c0de1780 <set_receive_ui+0x22c>)
c0de15ca:	4479      	add	r1, pc
c0de15cc:	e017      	b.n	c0de15fe <set_receive_ui+0xaa>
    strlcpy(context->ticker_received, msg->network_ticker,
c0de15ce:	4628      	mov	r0, r5
c0de15d0:	3087      	adds	r0, #135	; 0x87
c0de15d2:	4621      	mov	r1, r4
c0de15d4:	3110      	adds	r1, #16
c0de15d6:	e012      	b.n	c0de15fe <set_receive_ui+0xaa>
    strlcpy(context->ticker_received, OETH_TICKER,
c0de15d8:	4628      	mov	r0, r5
c0de15da:	3087      	adds	r0, #135	; 0x87
c0de15dc:	4960      	ldr	r1, [pc, #384]	; (c0de1760 <set_receive_ui+0x20c>)
c0de15de:	4479      	add	r1, pc
c0de15e0:	e00d      	b.n	c0de15fe <set_receive_ui+0xaa>
    strlcpy(context->ticker_received, OUSD_TICKER,
c0de15e2:	4628      	mov	r0, r5
c0de15e4:	3087      	adds	r0, #135	; 0x87
c0de15e6:	4960      	ldr	r1, [pc, #384]	; (c0de1768 <set_receive_ui+0x214>)
c0de15e8:	4479      	add	r1, pc
c0de15ea:	e008      	b.n	c0de15fe <set_receive_ui+0xaa>
    strlcpy(context->ticker_received, DAI_TICKER,
c0de15ec:	4628      	mov	r0, r5
c0de15ee:	3087      	adds	r0, #135	; 0x87
c0de15f0:	495f      	ldr	r1, [pc, #380]	; (c0de1770 <set_receive_ui+0x21c>)
c0de15f2:	4479      	add	r1, pc
c0de15f4:	e003      	b.n	c0de15fe <set_receive_ui+0xaa>
    strlcpy(context->ticker_received, USDC_TICKER,
c0de15f6:	4628      	mov	r0, r5
c0de15f8:	3087      	adds	r0, #135	; 0x87
c0de15fa:	495f      	ldr	r1, [pc, #380]	; (c0de1778 <set_receive_ui+0x224>)
c0de15fc:	4479      	add	r1, pc
c0de15fe:	220b      	movs	r2, #11
c0de1600:	f000 fef8 	bl	c0de23f4 <strlcpy>
c0de1604:	2020      	movs	r0, #32
  context->amount_length = INT256_LENGTH;
c0de1606:	70f8      	strb	r0, [r7, #3]
  strlcpy(msg->title, "Receive Min", msg->titleLength);
c0de1608:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de160a:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de160c:	495d      	ldr	r1, [pc, #372]	; (c0de1784 <set_receive_ui+0x230>)
c0de160e:	4479      	add	r1, pc
c0de1610:	f000 fef0 	bl	c0de23f4 <strlcpy>
  switch (context->selectorIndex) {
c0de1614:	7a39      	ldrb	r1, [r7, #8]
c0de1616:	2908      	cmp	r1, #8
c0de1618:	dc1a      	bgt.n	c0de1650 <set_receive_ui+0xfc>
c0de161a:	2903      	cmp	r1, #3
c0de161c:	dc7c      	bgt.n	c0de1718 <set_receive_ui+0x1c4>
c0de161e:	1e48      	subs	r0, r1, #1
c0de1620:	2802      	cmp	r0, #2
c0de1622:	d33a      	bcc.n	c0de169a <set_receive_ui+0x146>
c0de1624:	2900      	cmp	r1, #0
c0de1626:	d048      	beq.n	c0de16ba <set_receive_ui+0x166>
c0de1628:	2903      	cmp	r1, #3
c0de162a:	d000      	beq.n	c0de162e <set_receive_ui+0xda>
c0de162c:	e087      	b.n	c0de173e <set_receive_ui+0x1ea>
    if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination,
c0de162e:	6860      	ldr	r0, [r4, #4]
c0de1630:	6801      	ldr	r1, [r0, #0]
c0de1632:	31a5      	adds	r1, #165	; 0xa5
c0de1634:	485b      	ldr	r0, [pc, #364]	; (c0de17a4 <set_receive_ui+0x250>)
c0de1636:	4478      	add	r0, pc
c0de1638:	2214      	movs	r2, #20
c0de163a:	f000 fd5f 	bl	c0de20fc <memcmp>
c0de163e:	4601      	mov	r1, r0
c0de1640:	4628      	mov	r0, r5
c0de1642:	3087      	adds	r0, #135	; 0x87
c0de1644:	2900      	cmp	r1, #0
c0de1646:	d100      	bne.n	c0de164a <set_receive_ui+0xf6>
c0de1648:	e082      	b.n	c0de1750 <set_receive_ui+0x1fc>
      strlcpy(context->ticker_received, "USD MIX",
c0de164a:	4958      	ldr	r1, [pc, #352]	; (c0de17ac <set_receive_ui+0x258>)
c0de164c:	4479      	add	r1, pc
c0de164e:	e045      	b.n	c0de16dc <set_receive_ui+0x188>
  switch (context->selectorIndex) {
c0de1650:	290b      	cmp	r1, #11
c0de1652:	dc06      	bgt.n	c0de1662 <set_receive_ui+0x10e>
c0de1654:	2909      	cmp	r1, #9
c0de1656:	d015      	beq.n	c0de1684 <set_receive_ui+0x130>
c0de1658:	290a      	cmp	r1, #10
c0de165a:	d043      	beq.n	c0de16e4 <set_receive_ui+0x190>
c0de165c:	290b      	cmp	r1, #11
c0de165e:	d011      	beq.n	c0de1684 <set_receive_ui+0x130>
c0de1660:	e06d      	b.n	c0de173e <set_receive_ui+0x1ea>
c0de1662:	290c      	cmp	r1, #12
c0de1664:	d049      	beq.n	c0de16fa <set_receive_ui+0x1a6>
c0de1666:	290d      	cmp	r1, #13
c0de1668:	d00c      	beq.n	c0de1684 <set_receive_ui+0x130>
c0de166a:	290e      	cmp	r1, #14
c0de166c:	d167      	bne.n	c0de173e <set_receive_ui+0x1ea>
    memcpy(context->min_amount_received, context->amount_sent,
c0de166e:	4628      	mov	r0, r5
c0de1670:	3020      	adds	r0, #32
c0de1672:	2220      	movs	r2, #32
c0de1674:	4629      	mov	r1, r5
c0de1676:	f000 fd31 	bl	c0de20dc <__aeabi_memcpy>
    strlcpy(context->ticker_received, USDC_TICKER,
c0de167a:	4628      	mov	r0, r5
c0de167c:	3087      	adds	r0, #135	; 0x87
c0de167e:	4944      	ldr	r1, [pc, #272]	; (c0de1790 <set_receive_ui+0x23c>)
c0de1680:	4479      	add	r1, pc
c0de1682:	e044      	b.n	c0de170e <set_receive_ui+0x1ba>
    memcpy(context->min_amount_received, context->amount_sent,
c0de1684:	4628      	mov	r0, r5
c0de1686:	3020      	adds	r0, #32
c0de1688:	2220      	movs	r2, #32
c0de168a:	4629      	mov	r1, r5
c0de168c:	f000 fd26 	bl	c0de20dc <__aeabi_memcpy>
    strlcpy(context->ticker_received, OUSD_TICKER,
c0de1690:	4628      	mov	r0, r5
c0de1692:	3087      	adds	r0, #135	; 0x87
c0de1694:	493d      	ldr	r1, [pc, #244]	; (c0de178c <set_receive_ui+0x238>)
c0de1696:	4479      	add	r1, pc
c0de1698:	e039      	b.n	c0de170e <set_receive_ui+0x1ba>
    if (memcmp(OETH_VAULT_ADDRESS, msg->pluginSharedRO->txContent->destination,
c0de169a:	6860      	ldr	r0, [r4, #4]
c0de169c:	6801      	ldr	r1, [r0, #0]
c0de169e:	31a5      	adds	r1, #165	; 0xa5
c0de16a0:	483c      	ldr	r0, [pc, #240]	; (c0de1794 <set_receive_ui+0x240>)
c0de16a2:	4478      	add	r0, pc
c0de16a4:	2214      	movs	r2, #20
c0de16a6:	f000 fd29 	bl	c0de20fc <memcmp>
c0de16aa:	4601      	mov	r1, r0
c0de16ac:	4628      	mov	r0, r5
c0de16ae:	3087      	adds	r0, #135	; 0x87
c0de16b0:	2900      	cmp	r1, #0
c0de16b2:	d011      	beq.n	c0de16d8 <set_receive_ui+0x184>
      strlcpy(context->ticker_received, OUSD_TICKER,
c0de16b4:	493a      	ldr	r1, [pc, #232]	; (c0de17a0 <set_receive_ui+0x24c>)
c0de16b6:	4479      	add	r1, pc
c0de16b8:	e010      	b.n	c0de16dc <set_receive_ui+0x188>
           &msg->pluginSharedRO->txContent->value.value,
c0de16ba:	6860      	ldr	r0, [r4, #4]
c0de16bc:	6801      	ldr	r1, [r0, #0]
c0de16be:	2662      	movs	r6, #98	; 0x62
           msg->pluginSharedRO->txContent->value.length);
c0de16c0:	5d8a      	ldrb	r2, [r1, r6]
    memcpy(context->min_amount_received,
c0de16c2:	4628      	mov	r0, r5
c0de16c4:	3020      	adds	r0, #32
c0de16c6:	3142      	adds	r1, #66	; 0x42
c0de16c8:	f000 fd08 	bl	c0de20dc <__aeabi_memcpy>
    context->amount_length = msg->pluginSharedRO->txContent->value.length;
c0de16cc:	6860      	ldr	r0, [r4, #4]
c0de16ce:	6800      	ldr	r0, [r0, #0]
c0de16d0:	5d80      	ldrb	r0, [r0, r6]
c0de16d2:	70f8      	strb	r0, [r7, #3]
    strlcpy(context->ticker_received, OETH_TICKER,
c0de16d4:	4628      	mov	r0, r5
c0de16d6:	3087      	adds	r0, #135	; 0x87
c0de16d8:	492f      	ldr	r1, [pc, #188]	; (c0de1798 <set_receive_ui+0x244>)
c0de16da:	4479      	add	r1, pc
c0de16dc:	220b      	movs	r2, #11
c0de16de:	f000 fe89 	bl	c0de23f4 <strlcpy>
c0de16e2:	e019      	b.n	c0de1718 <set_receive_ui+0x1c4>
    memcpy(context->min_amount_received, context->amount_sent,
c0de16e4:	4628      	mov	r0, r5
c0de16e6:	3020      	adds	r0, #32
c0de16e8:	2220      	movs	r2, #32
c0de16ea:	4629      	mov	r1, r5
c0de16ec:	f000 fcf6 	bl	c0de20dc <__aeabi_memcpy>
    strlcpy(context->ticker_received, USDT_TICKER,
c0de16f0:	4628      	mov	r0, r5
c0de16f2:	3087      	adds	r0, #135	; 0x87
c0de16f4:	492e      	ldr	r1, [pc, #184]	; (c0de17b0 <set_receive_ui+0x25c>)
c0de16f6:	4479      	add	r1, pc
c0de16f8:	e009      	b.n	c0de170e <set_receive_ui+0x1ba>
    memcpy(context->min_amount_received, context->amount_sent,
c0de16fa:	4628      	mov	r0, r5
c0de16fc:	3020      	adds	r0, #32
c0de16fe:	2220      	movs	r2, #32
c0de1700:	4629      	mov	r1, r5
c0de1702:	f000 fceb 	bl	c0de20dc <__aeabi_memcpy>
    strlcpy(context->ticker_received, DAI_TICKER,
c0de1706:	4628      	mov	r0, r5
c0de1708:	3087      	adds	r0, #135	; 0x87
c0de170a:	492a      	ldr	r1, [pc, #168]	; (c0de17b4 <set_receive_ui+0x260>)
c0de170c:	4479      	add	r1, pc
c0de170e:	220b      	movs	r2, #11
c0de1710:	f000 fe70 	bl	c0de23f4 <strlcpy>
c0de1714:	2012      	movs	r0, #18
c0de1716:	7038      	strb	r0, [r7, #0]
                 context->decimals_received, context->ticker_received, msg->msg,
c0de1718:	783a      	ldrb	r2, [r7, #0]
  amountToString(context->min_amount_received, context->amount_length,
c0de171a:	78f9      	ldrb	r1, [r7, #3]
                 context->decimals_received, context->ticker_received, msg->msg,
c0de171c:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                 msg->msgLength);
c0de171e:	6b23      	ldr	r3, [r4, #48]	; 0x30
  amountToString(context->min_amount_received, context->amount_length,
c0de1720:	9000      	str	r0, [sp, #0]
c0de1722:	9301      	str	r3, [sp, #4]
c0de1724:	4628      	mov	r0, r5
c0de1726:	3020      	adds	r0, #32
                 context->decimals_received, context->ticker_received, msg->msg,
c0de1728:	3587      	adds	r5, #135	; 0x87
  amountToString(context->min_amount_received, context->amount_length,
c0de172a:	462b      	mov	r3, r5
c0de172c:	f7fe fea6 	bl	c0de047c <amountToString>
  PRINTF("AMOUNT RECEIVED: %s\n", msg->msg);
c0de1730:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de1732:	481a      	ldr	r0, [pc, #104]	; (c0de179c <set_receive_ui+0x248>)
c0de1734:	4478      	add	r0, pc
c0de1736:	f000 f8f9 	bl	c0de192c <mcu_usb_printf>
}
c0de173a:	b003      	add	sp, #12
c0de173c:	bdf0      	pop	{r4, r5, r6, r7, pc}
    PRINTF("Unhandled selector Index: %d\n", context->selectorIndex);
c0de173e:	4812      	ldr	r0, [pc, #72]	; (c0de1788 <set_receive_ui+0x234>)
c0de1740:	4478      	add	r0, pc
c0de1742:	f000 f8f3 	bl	c0de192c <mcu_usb_printf>
c0de1746:	2034      	movs	r0, #52	; 0x34
c0de1748:	2100      	movs	r1, #0
    msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de174a:	5421      	strb	r1, [r4, r0]
}
c0de174c:	b003      	add	sp, #12
c0de174e:	bdf0      	pop	{r4, r5, r6, r7, pc}
      strlcpy(context->ticker_received, "LST MIX",
c0de1750:	4915      	ldr	r1, [pc, #84]	; (c0de17a8 <set_receive_ui+0x254>)
c0de1752:	4479      	add	r1, pc
c0de1754:	e7c2      	b.n	c0de16dc <set_receive_ui+0x188>
c0de1756:	46c0      	nop			; (mov r8, r8)
c0de1758:	0000139e 	.word	0x0000139e
c0de175c:	000012b6 	.word	0x000012b6
c0de1760:	000011ef 	.word	0x000011ef
c0de1764:	000012ba 	.word	0x000012ba
c0de1768:	00000fc5 	.word	0x00000fc5
c0de176c:	000012be 	.word	0x000012be
c0de1770:	00000ede 	.word	0x00000ede
c0de1774:	000012c2 	.word	0x000012c2
c0de1778:	00000fe3 	.word	0x00000fe3
c0de177c:	000012c6 	.word	0x000012c6
c0de1780:	0000118f 	.word	0x0000118f
c0de1784:	00001033 	.word	0x00001033
c0de1788:	0000101e 	.word	0x0000101e
c0de178c:	00000f17 	.word	0x00000f17
c0de1790:	00000f5f 	.word	0x00000f5f
c0de1794:	000011ee 	.word	0x000011ee
c0de1798:	000010f3 	.word	0x000010f3
c0de179c:	0000109e 	.word	0x0000109e
c0de17a0:	00000ef7 	.word	0x00000ef7
c0de17a4:	0000125a 	.word	0x0000125a
c0de17a8:	00000e42 	.word	0x00000e42
c0de17ac:	00000f7f 	.word	0x00000f7f
c0de17b0:	00001063 	.word	0x00001063
c0de17b4:	00000dc4 	.word	0x00000dc4

c0de17b8 <set_warning_ui>:
                           __attribute__((unused))) {
c0de17b8:	b510      	push	{r4, lr}
c0de17ba:	4604      	mov	r4, r0
  strlcpy(msg->title, "WARNING", msg->titleLength);
c0de17bc:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de17be:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de17c0:	4905      	ldr	r1, [pc, #20]	; (c0de17d8 <set_warning_ui+0x20>)
c0de17c2:	4479      	add	r1, pc
c0de17c4:	f000 fe16 	bl	c0de23f4 <strlcpy>
  strlcpy(msg->msg, "Unknown token", msg->msgLength);
c0de17c8:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de17ca:	6b22      	ldr	r2, [r4, #48]	; 0x30
c0de17cc:	4903      	ldr	r1, [pc, #12]	; (c0de17dc <set_warning_ui+0x24>)
c0de17ce:	4479      	add	r1, pc
c0de17d0:	f000 fe10 	bl	c0de23f4 <strlcpy>
}
c0de17d4:	bd10      	pop	{r4, pc}
c0de17d6:	46c0      	nop			; (mov r8, r8)
c0de17d8:	00000d50 	.word	0x00000d50
c0de17dc:	00000eab 	.word	0x00000eab

c0de17e0 <set_beneficiary_ui>:
                               origin_defi_parameters_t *context) {
c0de17e0:	b5b0      	push	{r4, r5, r7, lr}
c0de17e2:	b082      	sub	sp, #8
c0de17e4:	460c      	mov	r4, r1
c0de17e6:	4605      	mov	r5, r0
  strlcpy(msg->title, "Beneficiary", msg->titleLength);
c0de17e8:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de17ea:	6aaa      	ldr	r2, [r5, #40]	; 0x28
c0de17ec:	490b      	ldr	r1, [pc, #44]	; (c0de181c <set_beneficiary_ui+0x3c>)
c0de17ee:	4479      	add	r1, pc
c0de17f0:	f000 fe00 	bl	c0de23f4 <strlcpy>
  msg->msg[0] = '0';
c0de17f4:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
c0de17f6:	2130      	movs	r1, #48	; 0x30
c0de17f8:	7001      	strb	r1, [r0, #0]
  msg->msg[1] = 'x';
c0de17fa:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
c0de17fc:	2178      	movs	r1, #120	; 0x78
c0de17fe:	7041      	strb	r1, [r0, #1]
                                msg->pluginSharedRW->sha3, 0);
c0de1800:	6828      	ldr	r0, [r5, #0]
c0de1802:	6802      	ldr	r2, [r0, #0]
  getEthAddressStringFromBinary((uint8_t *)context->beneficiary, msg->msg + 2,
c0de1804:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
c0de1806:	2100      	movs	r1, #0
c0de1808:	9100      	str	r1, [sp, #0]
c0de180a:	9101      	str	r1, [sp, #4]
c0de180c:	3468      	adds	r4, #104	; 0x68
c0de180e:	1c81      	adds	r1, r0, #2
c0de1810:	4620      	mov	r0, r4
c0de1812:	f7fe fc57 	bl	c0de00c4 <getEthAddressStringFromBinary>
}
c0de1816:	b002      	add	sp, #8
c0de1818:	bdb0      	pop	{r4, r5, r7, pc}
c0de181a:	46c0      	nop			; (mov r8, r8)
c0de181c:	00000f03 	.word	0x00000f03

c0de1820 <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de1820:	b580      	push	{r7, lr}
c0de1822:	4602      	mov	r2, r0
c0de1824:	20ff      	movs	r0, #255	; 0xff
c0de1826:	4603      	mov	r3, r0
c0de1828:	3304      	adds	r3, #4
  switch (message) {
c0de182a:	429a      	cmp	r2, r3
c0de182c:	dc0c      	bgt.n	c0de1848 <dispatch_plugin_calls+0x28>
c0de182e:	3002      	adds	r0, #2
c0de1830:	4282      	cmp	r2, r0
c0de1832:	d018      	beq.n	c0de1866 <dispatch_plugin_calls+0x46>
c0de1834:	2081      	movs	r0, #129	; 0x81
c0de1836:	0040      	lsls	r0, r0, #1
c0de1838:	4282      	cmp	r2, r0
c0de183a:	d018      	beq.n	c0de186e <dispatch_plugin_calls+0x4e>
c0de183c:	429a      	cmp	r2, r3
c0de183e:	d122      	bne.n	c0de1886 <dispatch_plugin_calls+0x66>
    handle_finalize(parameters);
c0de1840:	4608      	mov	r0, r1
c0de1842:	f7fe fe5f 	bl	c0de0504 <handle_finalize>
}
c0de1846:	bd80      	pop	{r7, pc}
c0de1848:	2341      	movs	r3, #65	; 0x41
c0de184a:	009b      	lsls	r3, r3, #2
  switch (message) {
c0de184c:	429a      	cmp	r2, r3
c0de184e:	d012      	beq.n	c0de1876 <dispatch_plugin_calls+0x56>
c0de1850:	3006      	adds	r0, #6
c0de1852:	4282      	cmp	r2, r0
c0de1854:	d013      	beq.n	c0de187e <dispatch_plugin_calls+0x5e>
c0de1856:	2083      	movs	r0, #131	; 0x83
c0de1858:	0040      	lsls	r0, r0, #1
c0de185a:	4282      	cmp	r2, r0
c0de185c:	d113      	bne.n	c0de1886 <dispatch_plugin_calls+0x66>
    handle_query_contract_ui(parameters);
c0de185e:	4608      	mov	r0, r1
c0de1860:	f7ff fc6c 	bl	c0de113c <handle_query_contract_ui>
}
c0de1864:	bd80      	pop	{r7, pc}
    handle_init_contract(parameters);
c0de1866:	4608      	mov	r0, r1
c0de1868:	f7fe fed0 	bl	c0de060c <handle_init_contract>
}
c0de186c:	bd80      	pop	{r7, pc}
    handle_provide_parameter(parameters);
c0de186e:	4608      	mov	r0, r1
c0de1870:	f7fe ff64 	bl	c0de073c <handle_provide_parameter>
}
c0de1874:	bd80      	pop	{r7, pc}
    handle_provide_token(parameters);
c0de1876:	4608      	mov	r0, r1
c0de1878:	f7ff fb02 	bl	c0de0e80 <handle_provide_token>
}
c0de187c:	bd80      	pop	{r7, pc}
    handle_query_contract_id(parameters);
c0de187e:	4608      	mov	r0, r1
c0de1880:	f7ff fc1a 	bl	c0de10b8 <handle_query_contract_id>
}
c0de1884:	bd80      	pop	{r7, pc}
    PRINTF("Unhandled message %d\n", message);
c0de1886:	4803      	ldr	r0, [pc, #12]	; (c0de1894 <dispatch_plugin_calls+0x74>)
c0de1888:	4478      	add	r0, pc
c0de188a:	4611      	mov	r1, r2
c0de188c:	f000 f84e 	bl	c0de192c <mcu_usb_printf>
}
c0de1890:	bd80      	pop	{r7, pc}
c0de1892:	46c0      	nop			; (mov r8, r8)
c0de1894:	00000e33 	.word	0x00000e33

c0de1898 <handle_query_ui_exception>:
void handle_query_ui_exception(unsigned int *args) {
c0de1898:	2183      	movs	r1, #131	; 0x83
c0de189a:	0049      	lsls	r1, r1, #1
  switch (args[0]) {
c0de189c:	6802      	ldr	r2, [r0, #0]
c0de189e:	428a      	cmp	r2, r1
c0de18a0:	d103      	bne.n	c0de18aa <handle_query_ui_exception+0x12>
    ((ethQueryContractUI_t *)args[1])->result = ETH_PLUGIN_RESULT_ERROR;
c0de18a2:	6840      	ldr	r0, [r0, #4]
c0de18a4:	2134      	movs	r1, #52	; 0x34
c0de18a6:	2200      	movs	r2, #0
c0de18a8:	5442      	strb	r2, [r0, r1]
}
c0de18aa:	4770      	bx	lr

c0de18ac <call_app_ethereum>:
void call_app_ethereum() {
c0de18ac:	b580      	push	{r7, lr}
c0de18ae:	b084      	sub	sp, #16
  libcall_params[0] = (unsigned int)"Ethereum";
c0de18b0:	4805      	ldr	r0, [pc, #20]	; (c0de18c8 <call_app_ethereum+0x1c>)
c0de18b2:	4478      	add	r0, pc
c0de18b4:	9001      	str	r0, [sp, #4]
c0de18b6:	2001      	movs	r0, #1
  libcall_params[2] = RUN_APPLICATION;
c0de18b8:	9003      	str	r0, [sp, #12]
c0de18ba:	0200      	lsls	r0, r0, #8
  libcall_params[1] = 0x100;
c0de18bc:	9002      	str	r0, [sp, #8]
c0de18be:	a801      	add	r0, sp, #4
  os_lib_call((unsigned int *)&libcall_params);
c0de18c0:	f000 f9ee 	bl	c0de1ca0 <os_lib_call>
}
c0de18c4:	b004      	add	sp, #16
c0de18c6:	bd80      	pop	{r7, pc}
c0de18c8:	00000d32 	.word	0x00000d32

c0de18cc <check_api_level>:

// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
c0de18cc:	b580      	push	{r7, lr}
  if (apiLevel < get_api_level()) {
c0de18ce:	f000 f9dc 	bl	c0de1c8a <get_api_level>
c0de18d2:	280d      	cmp	r0, #13
c0de18d4:	d200      	bcs.n	c0de18d8 <check_api_level+0xc>
    os_sched_exit(-1);
  }
}
c0de18d6:	bd80      	pop	{r7, pc}
c0de18d8:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de18da:	f000 f9f7 	bl	c0de1ccc <os_sched_exit>

c0de18de <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de18de:	b580      	push	{r7, lr}
c0de18e0:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de18e2:	f000 fa15 	bl	c0de1d10 <try_context_set>
#endif // HAVE_BOLOS
}
c0de18e6:	bd80      	pop	{r7, pc}

c0de18e8 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de18e8:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF  
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de18ea:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de18ec:	4804      	ldr	r0, [pc, #16]	; (c0de1900 <os_longjmp+0x18>)
c0de18ee:	4478      	add	r0, pc
c0de18f0:	4621      	mov	r1, r4
c0de18f2:	f000 f81b 	bl	c0de192c <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de18f6:	f000 fa01 	bl	c0de1cfc <try_context_get>
c0de18fa:	4621      	mov	r1, r4
c0de18fc:	f000 fd38 	bl	c0de2370 <longjmp>
c0de1900:	00000daa 	.word	0x00000daa

c0de1904 <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de1904:	b5b0      	push	{r4, r5, r7, lr}
c0de1906:	b082      	sub	sp, #8
c0de1908:	460c      	mov	r4, r1
c0de190a:	4605      	mov	r5, r0
c0de190c:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de190e:	7081      	strb	r1, [r0, #2]
c0de1910:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de1912:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de1914:	0a21      	lsrs	r1, r4, #8
c0de1916:	7041      	strb	r1, [r0, #1]
c0de1918:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de191a:	f000 f9e3 	bl	c0de1ce4 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de191e:	b2a1      	uxth	r1, r4
c0de1920:	4628      	mov	r0, r5
c0de1922:	f000 f9df 	bl	c0de1ce4 <io_seph_send>
}
c0de1926:	b002      	add	sp, #8
c0de1928:	bdb0      	pop	{r4, r5, r7, pc}
c0de192a:	d4d4      	bmi.n	c0de18d6 <check_api_level+0xa>

c0de192c <mcu_usb_printf>:
#include "usbd_def.h"
#include "usbd_core.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de192c:	b083      	sub	sp, #12
c0de192e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1930:	b08c      	sub	sp, #48	; 0x30
c0de1932:	ac11      	add	r4, sp, #68	; 0x44
c0de1934:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de1936:	2800      	cmp	r0, #0
c0de1938:	d100      	bne.n	c0de193c <mcu_usb_printf+0x10>
c0de193a:	e18c      	b.n	c0de1c56 <mcu_usb_printf+0x32a>
c0de193c:	4606      	mov	r6, r0
c0de193e:	a811      	add	r0, sp, #68	; 0x44
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de1940:	9006      	str	r0, [sp, #24]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de1942:	7830      	ldrb	r0, [r6, #0]
c0de1944:	2800      	cmp	r0, #0
c0de1946:	d100      	bne.n	c0de194a <mcu_usb_printf+0x1e>
c0de1948:	e185      	b.n	c0de1c56 <mcu_usb_printf+0x32a>
c0de194a:	2001      	movs	r0, #1
c0de194c:	9001      	str	r0, [sp, #4]
c0de194e:	e004      	b.n	c0de195a <mcu_usb_printf+0x2e>
c0de1950:	1976      	adds	r6, r6, r5
c0de1952:	7830      	ldrb	r0, [r6, #0]
c0de1954:	2800      	cmp	r0, #0
c0de1956:	d100      	bne.n	c0de195a <mcu_usb_printf+0x2e>
c0de1958:	e17d      	b.n	c0de1c56 <mcu_usb_printf+0x32a>
c0de195a:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de195c:	5d70      	ldrb	r0, [r6, r5]
c0de195e:	2800      	cmp	r0, #0
c0de1960:	d003      	beq.n	c0de196a <mcu_usb_printf+0x3e>
c0de1962:	2825      	cmp	r0, #37	; 0x25
c0de1964:	d001      	beq.n	c0de196a <mcu_usb_printf+0x3e>
            ulIdx++)
c0de1966:	1c6d      	adds	r5, r5, #1
c0de1968:	e7f8      	b.n	c0de195c <mcu_usb_printf+0x30>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de196a:	4630      	mov	r0, r6
c0de196c:	4629      	mov	r1, r5
c0de196e:	f7ff ffc9 	bl	c0de1904 <mcu_usb_prints>
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de1972:	5d70      	ldrb	r0, [r6, r5]
c0de1974:	2825      	cmp	r0, #37	; 0x25
c0de1976:	d1eb      	bne.n	c0de1950 <mcu_usb_printf+0x24>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de1978:	1970      	adds	r0, r6, r5
c0de197a:	1c46      	adds	r6, r0, #1
c0de197c:	2300      	movs	r3, #0
c0de197e:	2420      	movs	r4, #32
c0de1980:	9305      	str	r3, [sp, #20]
c0de1982:	4618      	mov	r0, r3
c0de1984:	e001      	b.n	c0de198a <mcu_usb_printf+0x5e>
c0de1986:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de1988:	d119      	bne.n	c0de19be <mcu_usb_printf+0x92>
c0de198a:	7831      	ldrb	r1, [r6, #0]
c0de198c:	1c76      	adds	r6, r6, #1
c0de198e:	2200      	movs	r2, #0
c0de1990:	292d      	cmp	r1, #45	; 0x2d
c0de1992:	ddf8      	ble.n	c0de1986 <mcu_usb_printf+0x5a>
c0de1994:	2947      	cmp	r1, #71	; 0x47
c0de1996:	dc37      	bgt.n	c0de1a08 <mcu_usb_printf+0xdc>
c0de1998:	460a      	mov	r2, r1
c0de199a:	3a30      	subs	r2, #48	; 0x30
c0de199c:	2a0a      	cmp	r2, #10
c0de199e:	d21c      	bcs.n	c0de19da <mcu_usb_printf+0xae>
c0de19a0:	9403      	str	r4, [sp, #12]
c0de19a2:	2230      	movs	r2, #48	; 0x30
c0de19a4:	461f      	mov	r7, r3
                {
                    //
                    // If this is a zero, and it is the first digit, then the
                    // fill character is a zero instead of a space.
                    //
                    if((format[-1] == '0') && (ulCount == 0))
c0de19a6:	460b      	mov	r3, r1
c0de19a8:	4053      	eors	r3, r2
c0de19aa:	463c      	mov	r4, r7
c0de19ac:	433b      	orrs	r3, r7
c0de19ae:	d000      	beq.n	c0de19b2 <mcu_usb_printf+0x86>
c0de19b0:	9a03      	ldr	r2, [sp, #12]
c0de19b2:	230a      	movs	r3, #10
                    }

                    //
                    // Update the digit count.
                    //
                    ulCount *= 10;
c0de19b4:	4363      	muls	r3, r4
                    ulCount += format[-1] - '0';
c0de19b6:	185b      	adds	r3, r3, r1
c0de19b8:	3b30      	subs	r3, #48	; 0x30
c0de19ba:	4614      	mov	r4, r2
c0de19bc:	e7e5      	b.n	c0de198a <mcu_usb_printf+0x5e>
            switch(*format++)
c0de19be:	2925      	cmp	r1, #37	; 0x25
c0de19c0:	d05d      	beq.n	c0de1a7e <mcu_usb_printf+0x152>
c0de19c2:	292a      	cmp	r1, #42	; 0x2a
c0de19c4:	d000      	beq.n	c0de19c8 <mcu_usb_printf+0x9c>
c0de19c6:	e0ef      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de19c8:	7830      	ldrb	r0, [r6, #0]
c0de19ca:	2873      	cmp	r0, #115	; 0x73
c0de19cc:	d000      	beq.n	c0de19d0 <mcu_usb_printf+0xa4>
c0de19ce:	e0eb      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de19d0:	9906      	ldr	r1, [sp, #24]
c0de19d2:	1d08      	adds	r0, r1, #4
c0de19d4:	9006      	str	r0, [sp, #24]
c0de19d6:	2002      	movs	r0, #2
c0de19d8:	e013      	b.n	c0de1a02 <mcu_usb_printf+0xd6>
            switch(*format++)
c0de19da:	292e      	cmp	r1, #46	; 0x2e
c0de19dc:	d000      	beq.n	c0de19e0 <mcu_usb_printf+0xb4>
c0de19de:	e0e3      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de19e0:	7830      	ldrb	r0, [r6, #0]
c0de19e2:	282a      	cmp	r0, #42	; 0x2a
c0de19e4:	d000      	beq.n	c0de19e8 <mcu_usb_printf+0xbc>
c0de19e6:	e0df      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
c0de19e8:	7870      	ldrb	r0, [r6, #1]
c0de19ea:	2848      	cmp	r0, #72	; 0x48
c0de19ec:	d004      	beq.n	c0de19f8 <mcu_usb_printf+0xcc>
c0de19ee:	2873      	cmp	r0, #115	; 0x73
c0de19f0:	d002      	beq.n	c0de19f8 <mcu_usb_printf+0xcc>
c0de19f2:	2868      	cmp	r0, #104	; 0x68
c0de19f4:	d000      	beq.n	c0de19f8 <mcu_usb_printf+0xcc>
c0de19f6:	e0d7      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
c0de19f8:	1c76      	adds	r6, r6, #1
                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de19fa:	9906      	ldr	r1, [sp, #24]
c0de19fc:	1d08      	adds	r0, r1, #4
c0de19fe:	9006      	str	r0, [sp, #24]
c0de1a00:	2001      	movs	r0, #1
c0de1a02:	6809      	ldr	r1, [r1, #0]
            switch(*format++)
c0de1a04:	9105      	str	r1, [sp, #20]
c0de1a06:	e7c0      	b.n	c0de198a <mcu_usb_printf+0x5e>
c0de1a08:	2967      	cmp	r1, #103	; 0x67
c0de1a0a:	dd0a      	ble.n	c0de1a22 <mcu_usb_printf+0xf6>
c0de1a0c:	4f94      	ldr	r7, [pc, #592]	; (c0de1c60 <mcu_usb_printf+0x334>)
c0de1a0e:	447f      	add	r7, pc
c0de1a10:	2972      	cmp	r1, #114	; 0x72
c0de1a12:	dd11      	ble.n	c0de1a38 <mcu_usb_printf+0x10c>
c0de1a14:	2973      	cmp	r1, #115	; 0x73
c0de1a16:	d034      	beq.n	c0de1a82 <mcu_usb_printf+0x156>
c0de1a18:	2975      	cmp	r1, #117	; 0x75
c0de1a1a:	d035      	beq.n	c0de1a88 <mcu_usb_printf+0x15c>
c0de1a1c:	2978      	cmp	r1, #120	; 0x78
c0de1a1e:	d011      	beq.n	c0de1a44 <mcu_usb_printf+0x118>
c0de1a20:	e0c2      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
c0de1a22:	2962      	cmp	r1, #98	; 0x62
c0de1a24:	dc18      	bgt.n	c0de1a58 <mcu_usb_printf+0x12c>
c0de1a26:	2948      	cmp	r1, #72	; 0x48
c0de1a28:	d100      	bne.n	c0de1a2c <mcu_usb_printf+0x100>
c0de1a2a:	e0a9      	b.n	c0de1b80 <mcu_usb_printf+0x254>
c0de1a2c:	2958      	cmp	r1, #88	; 0x58
c0de1a2e:	d000      	beq.n	c0de1a32 <mcu_usb_printf+0x106>
c0de1a30:	e0ba      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
c0de1a32:	9602      	str	r6, [sp, #8]
c0de1a34:	2001      	movs	r0, #1
c0de1a36:	e007      	b.n	c0de1a48 <mcu_usb_printf+0x11c>
c0de1a38:	2968      	cmp	r1, #104	; 0x68
c0de1a3a:	d100      	bne.n	c0de1a3e <mcu_usb_printf+0x112>
c0de1a3c:	e0a4      	b.n	c0de1b88 <mcu_usb_printf+0x25c>
c0de1a3e:	2970      	cmp	r1, #112	; 0x70
c0de1a40:	d000      	beq.n	c0de1a44 <mcu_usb_printf+0x118>
c0de1a42:	e0b1      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
c0de1a44:	9602      	str	r6, [sp, #8]
c0de1a46:	2000      	movs	r0, #0
c0de1a48:	9004      	str	r0, [sp, #16]
                case 'p':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1a4a:	9806      	ldr	r0, [sp, #24]
c0de1a4c:	1d01      	adds	r1, r0, #4
c0de1a4e:	9106      	str	r1, [sp, #24]
c0de1a50:	6800      	ldr	r0, [r0, #0]
c0de1a52:	900b      	str	r0, [sp, #44]	; 0x2c
c0de1a54:	2510      	movs	r5, #16
c0de1a56:	e020      	b.n	c0de1a9a <mcu_usb_printf+0x16e>
            switch(*format++)
c0de1a58:	2963      	cmp	r1, #99	; 0x63
c0de1a5a:	d100      	bne.n	c0de1a5e <mcu_usb_printf+0x132>
c0de1a5c:	e0a8      	b.n	c0de1bb0 <mcu_usb_printf+0x284>
c0de1a5e:	2964      	cmp	r1, #100	; 0x64
c0de1a60:	d000      	beq.n	c0de1a64 <mcu_usb_printf+0x138>
c0de1a62:	e0a1      	b.n	c0de1ba8 <mcu_usb_printf+0x27c>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1a64:	9806      	ldr	r0, [sp, #24]
c0de1a66:	1d01      	adds	r1, r0, #4
c0de1a68:	9106      	str	r1, [sp, #24]
c0de1a6a:	6800      	ldr	r0, [r0, #0]
c0de1a6c:	900b      	str	r0, [sp, #44]	; 0x2c
c0de1a6e:	250a      	movs	r5, #10
                    if((long)ulValue < 0)
c0de1a70:	2800      	cmp	r0, #0
c0de1a72:	9602      	str	r6, [sp, #8]
c0de1a74:	d500      	bpl.n	c0de1a78 <mcu_usb_printf+0x14c>
c0de1a76:	e0d2      	b.n	c0de1c1e <mcu_usb_printf+0x2f2>
c0de1a78:	2000      	movs	r0, #0
c0de1a7a:	9004      	str	r0, [sp, #16]
c0de1a7c:	e00d      	b.n	c0de1a9a <mcu_usb_printf+0x16e>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de1a7e:	1e70      	subs	r0, r6, #1
c0de1a80:	e09c      	b.n	c0de1bbc <mcu_usb_printf+0x290>
c0de1a82:	461c      	mov	r4, r3
c0de1a84:	2100      	movs	r1, #0
c0de1a86:	e081      	b.n	c0de1b8c <mcu_usb_printf+0x260>
c0de1a88:	9602      	str	r6, [sp, #8]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1a8a:	9806      	ldr	r0, [sp, #24]
c0de1a8c:	1d01      	adds	r1, r0, #4
c0de1a8e:	9106      	str	r1, [sp, #24]
c0de1a90:	6800      	ldr	r0, [r0, #0]
c0de1a92:	900b      	str	r0, [sp, #44]	; 0x2c
c0de1a94:	2000      	movs	r0, #0
c0de1a96:	9004      	str	r0, [sp, #16]
c0de1a98:	250a      	movs	r5, #10
c0de1a9a:	9801      	ldr	r0, [sp, #4]
c0de1a9c:	4606      	mov	r6, r0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de1a9e:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0de1aa0:	9105      	str	r1, [sp, #20]
c0de1aa2:	428d      	cmp	r5, r1
c0de1aa4:	9403      	str	r4, [sp, #12]
c0de1aa6:	d902      	bls.n	c0de1aae <mcu_usb_printf+0x182>
c0de1aa8:	4607      	mov	r7, r0
c0de1aaa:	4602      	mov	r2, r0
c0de1aac:	e016      	b.n	c0de1adc <mcu_usb_printf+0x1b0>
                    for(ulIdx = 1;
c0de1aae:	1e5a      	subs	r2, r3, #1
c0de1ab0:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0de1ab2:	9005      	str	r0, [sp, #20]
c0de1ab4:	4628      	mov	r0, r5
c0de1ab6:	4607      	mov	r7, r0
c0de1ab8:	4614      	mov	r4, r2
c0de1aba:	2100      	movs	r1, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de1abc:	4628      	mov	r0, r5
c0de1abe:	463a      	mov	r2, r7
c0de1ac0:	460b      	mov	r3, r1
c0de1ac2:	f000 f9df 	bl	c0de1e84 <__aeabi_lmul>
c0de1ac6:	1e4a      	subs	r2, r1, #1
c0de1ac8:	4191      	sbcs	r1, r2
c0de1aca:	9a05      	ldr	r2, [sp, #20]
c0de1acc:	4290      	cmp	r0, r2
c0de1ace:	d802      	bhi.n	c0de1ad6 <mcu_usb_printf+0x1aa>
                    for(ulIdx = 1;
c0de1ad0:	1e62      	subs	r2, r4, #1
c0de1ad2:	2900      	cmp	r1, #0
c0de1ad4:	d0ef      	beq.n	c0de1ab6 <mcu_usb_printf+0x18a>
c0de1ad6:	4623      	mov	r3, r4
c0de1ad8:	9a01      	ldr	r2, [sp, #4]
c0de1ada:	9c03      	ldr	r4, [sp, #12]
                    if(ulNeg)
c0de1adc:	4630      	mov	r0, r6
c0de1ade:	4050      	eors	r0, r2
c0de1ae0:	1a19      	subs	r1, r3, r0
                    if(ulNeg && (cFill == '0'))
c0de1ae2:	2e00      	cmp	r6, #0
c0de1ae4:	d002      	beq.n	c0de1aec <mcu_usb_printf+0x1c0>
c0de1ae6:	2600      	movs	r6, #0
c0de1ae8:	4614      	mov	r4, r2
c0de1aea:	e00b      	b.n	c0de1b04 <mcu_usb_printf+0x1d8>
c0de1aec:	b2e2      	uxtb	r2, r4
c0de1aee:	2600      	movs	r6, #0
c0de1af0:	2a30      	cmp	r2, #48	; 0x30
c0de1af2:	4634      	mov	r4, r6
c0de1af4:	d106      	bne.n	c0de1b04 <mcu_usb_printf+0x1d8>
c0de1af6:	aa07      	add	r2, sp, #28
c0de1af8:	461c      	mov	r4, r3
c0de1afa:	232d      	movs	r3, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de1afc:	7013      	strb	r3, [r2, #0]
c0de1afe:	4623      	mov	r3, r4
c0de1b00:	2601      	movs	r6, #1
c0de1b02:	9c01      	ldr	r4, [sp, #4]
                    if((ulCount > 1) && (ulCount < 16))
c0de1b04:	1e8a      	subs	r2, r1, #2
c0de1b06:	2a0d      	cmp	r2, #13
c0de1b08:	d80f      	bhi.n	c0de1b2a <mcu_usb_printf+0x1fe>
c0de1b0a:	1e49      	subs	r1, r1, #1
c0de1b0c:	d00d      	beq.n	c0de1b2a <mcu_usb_printf+0x1fe>
c0de1b0e:	4240      	negs	r0, r0
c0de1b10:	9000      	str	r0, [sp, #0]
c0de1b12:	a807      	add	r0, sp, #28
                        for(ulCount--; ulCount; ulCount--)
c0de1b14:	1980      	adds	r0, r0, r6
                            pcBuf[ulPos++] = cFill;
c0de1b16:	9a03      	ldr	r2, [sp, #12]
c0de1b18:	b2d2      	uxtb	r2, r2
c0de1b1a:	9303      	str	r3, [sp, #12]
c0de1b1c:	f000 fae6 	bl	c0de20ec <__aeabi_memset>
                        for(ulCount--; ulCount; ulCount--)
c0de1b20:	9803      	ldr	r0, [sp, #12]
c0de1b22:	1830      	adds	r0, r6, r0
c0de1b24:	9900      	ldr	r1, [sp, #0]
c0de1b26:	1840      	adds	r0, r0, r1
c0de1b28:	1e46      	subs	r6, r0, #1
                    if(ulNeg)
c0de1b2a:	2c00      	cmp	r4, #0
c0de1b2c:	d103      	bne.n	c0de1b36 <mcu_usb_printf+0x20a>
c0de1b2e:	a807      	add	r0, sp, #28
c0de1b30:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de1b32:	5581      	strb	r1, [r0, r6]
c0de1b34:	1c76      	adds	r6, r6, #1
                    for(; ulIdx; ulIdx /= ulBase)
c0de1b36:	2f00      	cmp	r7, #0
c0de1b38:	d01c      	beq.n	c0de1b74 <mcu_usb_printf+0x248>
c0de1b3a:	484e      	ldr	r0, [pc, #312]	; (c0de1c74 <mcu_usb_printf+0x348>)
c0de1b3c:	4478      	add	r0, pc
c0de1b3e:	9003      	str	r0, [sp, #12]
c0de1b40:	e012      	b.n	c0de1b68 <mcu_usb_printf+0x23c>
                        if (!ulCap) {
c0de1b42:	9c03      	ldr	r4, [sp, #12]
c0de1b44:	9805      	ldr	r0, [sp, #20]
c0de1b46:	4639      	mov	r1, r7
c0de1b48:	f000 f8f0 	bl	c0de1d2c <__udivsi3>
c0de1b4c:	4629      	mov	r1, r5
c0de1b4e:	f000 f973 	bl	c0de1e38 <__aeabi_uidivmod>
c0de1b52:	5c60      	ldrb	r0, [r4, r1]
c0de1b54:	a907      	add	r1, sp, #28
c0de1b56:	5588      	strb	r0, [r1, r6]
                    for(; ulIdx; ulIdx /= ulBase)
c0de1b58:	4638      	mov	r0, r7
c0de1b5a:	4629      	mov	r1, r5
c0de1b5c:	f000 f8e6 	bl	c0de1d2c <__udivsi3>
c0de1b60:	1c76      	adds	r6, r6, #1
c0de1b62:	42bd      	cmp	r5, r7
c0de1b64:	4607      	mov	r7, r0
c0de1b66:	d805      	bhi.n	c0de1b74 <mcu_usb_printf+0x248>
                        if (!ulCap) {
c0de1b68:	9804      	ldr	r0, [sp, #16]
c0de1b6a:	2800      	cmp	r0, #0
c0de1b6c:	d1e9      	bne.n	c0de1b42 <mcu_usb_printf+0x216>
c0de1b6e:	4c42      	ldr	r4, [pc, #264]	; (c0de1c78 <mcu_usb_printf+0x34c>)
c0de1b70:	447c      	add	r4, pc
c0de1b72:	e7e7      	b.n	c0de1b44 <mcu_usb_printf+0x218>
c0de1b74:	a807      	add	r0, sp, #28
                    mcu_usb_prints(pcBuf, ulPos);
c0de1b76:	4631      	mov	r1, r6
c0de1b78:	f7ff fec4 	bl	c0de1904 <mcu_usb_prints>
c0de1b7c:	9e02      	ldr	r6, [sp, #8]
c0de1b7e:	e6e8      	b.n	c0de1952 <mcu_usb_printf+0x26>
c0de1b80:	461c      	mov	r4, r3
c0de1b82:	4f39      	ldr	r7, [pc, #228]	; (c0de1c68 <mcu_usb_printf+0x33c>)
c0de1b84:	447f      	add	r7, pc
c0de1b86:	e000      	b.n	c0de1b8a <mcu_usb_printf+0x25e>
c0de1b88:	461c      	mov	r4, r3
c0de1b8a:	9901      	ldr	r1, [sp, #4]
                    pcStr = va_arg(vaArgP, char *);
c0de1b8c:	9a06      	ldr	r2, [sp, #24]
c0de1b8e:	1d13      	adds	r3, r2, #4
c0de1b90:	9306      	str	r3, [sp, #24]
                    switch(cStrlenSet) {
c0de1b92:	b2c3      	uxtb	r3, r0
                    pcStr = va_arg(vaArgP, char *);
c0de1b94:	6810      	ldr	r0, [r2, #0]
                    switch(cStrlenSet) {
c0de1b96:	2b00      	cmp	r3, #0
c0de1b98:	d014      	beq.n	c0de1bc4 <mcu_usb_printf+0x298>
c0de1b9a:	2b01      	cmp	r3, #1
c0de1b9c:	d035      	beq.n	c0de1c0a <mcu_usb_printf+0x2de>
c0de1b9e:	2b02      	cmp	r3, #2
c0de1ba0:	d116      	bne.n	c0de1bd0 <mcu_usb_printf+0x2a4>
                        if (pcStr[0] == '\0') {
c0de1ba2:	7800      	ldrb	r0, [r0, #0]
c0de1ba4:	2800      	cmp	r0, #0
c0de1ba6:	d040      	beq.n	c0de1c2a <mcu_usb_printf+0x2fe>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de1ba8:	482e      	ldr	r0, [pc, #184]	; (c0de1c64 <mcu_usb_printf+0x338>)
c0de1baa:	4478      	add	r0, pc
c0de1bac:	2105      	movs	r1, #5
c0de1bae:	e006      	b.n	c0de1bbe <mcu_usb_printf+0x292>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de1bb0:	9806      	ldr	r0, [sp, #24]
c0de1bb2:	1d01      	adds	r1, r0, #4
c0de1bb4:	9106      	str	r1, [sp, #24]
c0de1bb6:	6800      	ldr	r0, [r0, #0]
c0de1bb8:	900b      	str	r0, [sp, #44]	; 0x2c
c0de1bba:	a80b      	add	r0, sp, #44	; 0x2c
c0de1bbc:	2101      	movs	r1, #1
c0de1bbe:	f7ff fea1 	bl	c0de1904 <mcu_usb_prints>
c0de1bc2:	e6c6      	b.n	c0de1952 <mcu_usb_printf+0x26>
c0de1bc4:	2300      	movs	r3, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de1bc6:	5cc2      	ldrb	r2, [r0, r3]
c0de1bc8:	1c5b      	adds	r3, r3, #1
c0de1bca:	2a00      	cmp	r2, #0
c0de1bcc:	d1fb      	bne.n	c0de1bc6 <mcu_usb_printf+0x29a>
                    switch(ulBase) {
c0de1bce:	1e5d      	subs	r5, r3, #1
c0de1bd0:	2900      	cmp	r1, #0
c0de1bd2:	d01d      	beq.n	c0de1c10 <mcu_usb_printf+0x2e4>
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de1bd4:	2d00      	cmp	r5, #0
c0de1bd6:	d020      	beq.n	c0de1c1a <mcu_usb_printf+0x2ee>
c0de1bd8:	9602      	str	r6, [sp, #8]
c0de1bda:	2600      	movs	r6, #0
c0de1bdc:	9505      	str	r5, [sp, #20]
c0de1bde:	9004      	str	r0, [sp, #16]
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de1be0:	5d84      	ldrb	r4, [r0, r6]
c0de1be2:	0920      	lsrs	r0, r4, #4
c0de1be4:	1838      	adds	r0, r7, r0
c0de1be6:	2501      	movs	r5, #1
c0de1be8:	4629      	mov	r1, r5
c0de1bea:	f7ff fe8b 	bl	c0de1904 <mcu_usb_prints>
c0de1bee:	200f      	movs	r0, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de1bf0:	4020      	ands	r0, r4
c0de1bf2:	1838      	adds	r0, r7, r0
c0de1bf4:	4629      	mov	r1, r5
c0de1bf6:	9d05      	ldr	r5, [sp, #20]
c0de1bf8:	f7ff fe84 	bl	c0de1904 <mcu_usb_prints>
c0de1bfc:	9804      	ldr	r0, [sp, #16]
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de1bfe:	1c76      	adds	r6, r6, #1
c0de1c00:	42b5      	cmp	r5, r6
c0de1c02:	d1ed      	bne.n	c0de1be0 <mcu_usb_printf+0x2b4>
c0de1c04:	462f      	mov	r7, r5
c0de1c06:	9e02      	ldr	r6, [sp, #8]
c0de1c08:	e019      	b.n	c0de1c3e <mcu_usb_printf+0x312>
c0de1c0a:	9d05      	ldr	r5, [sp, #20]
                    switch(ulBase) {
c0de1c0c:	2900      	cmp	r1, #0
c0de1c0e:	d1e1      	bne.n	c0de1bd4 <mcu_usb_printf+0x2a8>
                        mcu_usb_prints(pcStr, ulIdx);
c0de1c10:	4629      	mov	r1, r5
c0de1c12:	f7ff fe77 	bl	c0de1904 <mcu_usb_prints>
c0de1c16:	4627      	mov	r7, r4
c0de1c18:	e011      	b.n	c0de1c3e <mcu_usb_printf+0x312>
c0de1c1a:	2700      	movs	r7, #0
c0de1c1c:	e00f      	b.n	c0de1c3e <mcu_usb_printf+0x312>
                        ulValue = -(long)ulValue;
c0de1c1e:	4240      	negs	r0, r0
c0de1c20:	900b      	str	r0, [sp, #44]	; 0x2c
c0de1c22:	2600      	movs	r6, #0
            ulCap = 0;
c0de1c24:	9604      	str	r6, [sp, #16]
c0de1c26:	9801      	ldr	r0, [sp, #4]
c0de1c28:	e739      	b.n	c0de1a9e <mcu_usb_printf+0x172>
c0de1c2a:	4627      	mov	r7, r4
                          do {
c0de1c2c:	9805      	ldr	r0, [sp, #20]
c0de1c2e:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de1c30:	480e      	ldr	r0, [pc, #56]	; (c0de1c6c <mcu_usb_printf+0x340>)
c0de1c32:	4478      	add	r0, pc
c0de1c34:	2101      	movs	r1, #1
c0de1c36:	f7ff fe65 	bl	c0de1904 <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de1c3a:	1e64      	subs	r4, r4, #1
c0de1c3c:	d1f8      	bne.n	c0de1c30 <mcu_usb_printf+0x304>
                    if(ulCount > ulIdx)
c0de1c3e:	42af      	cmp	r7, r5
c0de1c40:	d800      	bhi.n	c0de1c44 <mcu_usb_printf+0x318>
c0de1c42:	e686      	b.n	c0de1952 <mcu_usb_printf+0x26>
                        while(ulCount--)
c0de1c44:	1bec      	subs	r4, r5, r7
                            mcu_usb_prints(" ", 1);
c0de1c46:	480a      	ldr	r0, [pc, #40]	; (c0de1c70 <mcu_usb_printf+0x344>)
c0de1c48:	4478      	add	r0, pc
c0de1c4a:	2101      	movs	r1, #1
c0de1c4c:	f7ff fe5a 	bl	c0de1904 <mcu_usb_prints>
                        while(ulCount--)
c0de1c50:	1c64      	adds	r4, r4, #1
c0de1c52:	d3f8      	bcc.n	c0de1c46 <mcu_usb_printf+0x31a>
c0de1c54:	e67d      	b.n	c0de1952 <mcu_usb_printf+0x26>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de1c56:	b00c      	add	sp, #48	; 0x30
c0de1c58:	bcf0      	pop	{r4, r5, r6, r7}
c0de1c5a:	bc01      	pop	{r0}
c0de1c5c:	b003      	add	sp, #12
c0de1c5e:	4700      	bx	r0
c0de1c60:	00000ed2 	.word	0x00000ed2
c0de1c64:	00000b08 	.word	0x00000b08
c0de1c68:	00000d6c 	.word	0x00000d6c
c0de1c6c:	00000908 	.word	0x00000908
c0de1c70:	000008f2 	.word	0x000008f2
c0de1c74:	00000db4 	.word	0x00000db4
c0de1c78:	00000d70 	.word	0x00000d70

c0de1c7c <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de1c7c:	df01      	svc	1
    cmp r1, #0
c0de1c7e:	2900      	cmp	r1, #0
    bne exception
c0de1c80:	d100      	bne.n	c0de1c84 <exception>
    bx lr
c0de1c82:	4770      	bx	lr

c0de1c84 <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de1c84:	4608      	mov	r0, r1
    bl os_longjmp
c0de1c86:	f7ff fe2f 	bl	c0de18e8 <os_longjmp>

c0de1c8a <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de1c8a:	b580      	push	{r7, lr}
c0de1c8c:	b082      	sub	sp, #8
c0de1c8e:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de1c90:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de1c92:	9000      	str	r0, [sp, #0]
c0de1c94:	2001      	movs	r0, #1
c0de1c96:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de1c98:	f7ff fff0 	bl	c0de1c7c <SVC_Call>
c0de1c9c:	b002      	add	sp, #8
c0de1c9e:	bd80      	pop	{r7, pc}

c0de1ca0 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de1ca0:	b580      	push	{r7, lr}
c0de1ca2:	b082      	sub	sp, #8
c0de1ca4:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de1ca6:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de1ca8:	9000      	str	r0, [sp, #0]
c0de1caa:	4803      	ldr	r0, [pc, #12]	; (c0de1cb8 <os_lib_call+0x18>)
c0de1cac:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de1cae:	f7ff ffe5 	bl	c0de1c7c <SVC_Call>
  return;
}
c0de1cb2:	b002      	add	sp, #8
c0de1cb4:	bd80      	pop	{r7, pc}
c0de1cb6:	46c0      	nop			; (mov r8, r8)
c0de1cb8:	01000067 	.word	0x01000067

c0de1cbc <os_lib_end>:

void __attribute__((noreturn)) os_lib_end ( void ) {
c0de1cbc:	b082      	sub	sp, #8
c0de1cbe:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de1cc0:	9001      	str	r0, [sp, #4]
c0de1cc2:	2068      	movs	r0, #104	; 0x68
c0de1cc4:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de1cc6:	f7ff ffd9 	bl	c0de1c7c <SVC_Call>

  // The os_lib_end syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de1cca:	deff      	udf	#255	; 0xff

c0de1ccc <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de1ccc:	b082      	sub	sp, #8
c0de1cce:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de1cd0:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de1cd2:	9000      	str	r0, [sp, #0]
c0de1cd4:	4802      	ldr	r0, [pc, #8]	; (c0de1ce0 <os_sched_exit+0x14>)
c0de1cd6:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de1cd8:	f7ff ffd0 	bl	c0de1c7c <SVC_Call>

  // The os_sched_exit syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de1cdc:	deff      	udf	#255	; 0xff
c0de1cde:	46c0      	nop			; (mov r8, r8)
c0de1ce0:	0100009a 	.word	0x0100009a

c0de1ce4 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de1ce4:	b580      	push	{r7, lr}
c0de1ce6:	b082      	sub	sp, #8
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de1ce8:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de1cea:	9000      	str	r0, [sp, #0]
c0de1cec:	4802      	ldr	r0, [pc, #8]	; (c0de1cf8 <io_seph_send+0x14>)
c0de1cee:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de1cf0:	f7ff ffc4 	bl	c0de1c7c <SVC_Call>
  return;
}
c0de1cf4:	b002      	add	sp, #8
c0de1cf6:	bd80      	pop	{r7, pc}
c0de1cf8:	02000083 	.word	0x02000083

c0de1cfc <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de1cfc:	b580      	push	{r7, lr}
c0de1cfe:	b082      	sub	sp, #8
c0de1d00:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de1d02:	9001      	str	r0, [sp, #4]
c0de1d04:	2087      	movs	r0, #135	; 0x87
c0de1d06:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de1d08:	f7ff ffb8 	bl	c0de1c7c <SVC_Call>
c0de1d0c:	b002      	add	sp, #8
c0de1d0e:	bd80      	pop	{r7, pc}

c0de1d10 <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de1d10:	b580      	push	{r7, lr}
c0de1d12:	b082      	sub	sp, #8
c0de1d14:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de1d16:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de1d18:	9000      	str	r0, [sp, #0]
c0de1d1a:	4803      	ldr	r0, [pc, #12]	; (c0de1d28 <try_context_set+0x18>)
c0de1d1c:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de1d1e:	f7ff ffad 	bl	c0de1c7c <SVC_Call>
c0de1d22:	b002      	add	sp, #8
c0de1d24:	bd80      	pop	{r7, pc}
c0de1d26:	46c0      	nop			; (mov r8, r8)
c0de1d28:	0100010b 	.word	0x0100010b

c0de1d2c <__udivsi3>:
c0de1d2c:	2200      	movs	r2, #0
c0de1d2e:	0843      	lsrs	r3, r0, #1
c0de1d30:	428b      	cmp	r3, r1
c0de1d32:	d374      	bcc.n	c0de1e1e <__udivsi3+0xf2>
c0de1d34:	0903      	lsrs	r3, r0, #4
c0de1d36:	428b      	cmp	r3, r1
c0de1d38:	d35f      	bcc.n	c0de1dfa <__udivsi3+0xce>
c0de1d3a:	0a03      	lsrs	r3, r0, #8
c0de1d3c:	428b      	cmp	r3, r1
c0de1d3e:	d344      	bcc.n	c0de1dca <__udivsi3+0x9e>
c0de1d40:	0b03      	lsrs	r3, r0, #12
c0de1d42:	428b      	cmp	r3, r1
c0de1d44:	d328      	bcc.n	c0de1d98 <__udivsi3+0x6c>
c0de1d46:	0c03      	lsrs	r3, r0, #16
c0de1d48:	428b      	cmp	r3, r1
c0de1d4a:	d30d      	bcc.n	c0de1d68 <__udivsi3+0x3c>
c0de1d4c:	22ff      	movs	r2, #255	; 0xff
c0de1d4e:	0209      	lsls	r1, r1, #8
c0de1d50:	ba12      	rev	r2, r2
c0de1d52:	0c03      	lsrs	r3, r0, #16
c0de1d54:	428b      	cmp	r3, r1
c0de1d56:	d302      	bcc.n	c0de1d5e <__udivsi3+0x32>
c0de1d58:	1212      	asrs	r2, r2, #8
c0de1d5a:	0209      	lsls	r1, r1, #8
c0de1d5c:	d065      	beq.n	c0de1e2a <__udivsi3+0xfe>
c0de1d5e:	0b03      	lsrs	r3, r0, #12
c0de1d60:	428b      	cmp	r3, r1
c0de1d62:	d319      	bcc.n	c0de1d98 <__udivsi3+0x6c>
c0de1d64:	e000      	b.n	c0de1d68 <__udivsi3+0x3c>
c0de1d66:	0a09      	lsrs	r1, r1, #8
c0de1d68:	0bc3      	lsrs	r3, r0, #15
c0de1d6a:	428b      	cmp	r3, r1
c0de1d6c:	d301      	bcc.n	c0de1d72 <__udivsi3+0x46>
c0de1d6e:	03cb      	lsls	r3, r1, #15
c0de1d70:	1ac0      	subs	r0, r0, r3
c0de1d72:	4152      	adcs	r2, r2
c0de1d74:	0b83      	lsrs	r3, r0, #14
c0de1d76:	428b      	cmp	r3, r1
c0de1d78:	d301      	bcc.n	c0de1d7e <__udivsi3+0x52>
c0de1d7a:	038b      	lsls	r3, r1, #14
c0de1d7c:	1ac0      	subs	r0, r0, r3
c0de1d7e:	4152      	adcs	r2, r2
c0de1d80:	0b43      	lsrs	r3, r0, #13
c0de1d82:	428b      	cmp	r3, r1
c0de1d84:	d301      	bcc.n	c0de1d8a <__udivsi3+0x5e>
c0de1d86:	034b      	lsls	r3, r1, #13
c0de1d88:	1ac0      	subs	r0, r0, r3
c0de1d8a:	4152      	adcs	r2, r2
c0de1d8c:	0b03      	lsrs	r3, r0, #12
c0de1d8e:	428b      	cmp	r3, r1
c0de1d90:	d301      	bcc.n	c0de1d96 <__udivsi3+0x6a>
c0de1d92:	030b      	lsls	r3, r1, #12
c0de1d94:	1ac0      	subs	r0, r0, r3
c0de1d96:	4152      	adcs	r2, r2
c0de1d98:	0ac3      	lsrs	r3, r0, #11
c0de1d9a:	428b      	cmp	r3, r1
c0de1d9c:	d301      	bcc.n	c0de1da2 <__udivsi3+0x76>
c0de1d9e:	02cb      	lsls	r3, r1, #11
c0de1da0:	1ac0      	subs	r0, r0, r3
c0de1da2:	4152      	adcs	r2, r2
c0de1da4:	0a83      	lsrs	r3, r0, #10
c0de1da6:	428b      	cmp	r3, r1
c0de1da8:	d301      	bcc.n	c0de1dae <__udivsi3+0x82>
c0de1daa:	028b      	lsls	r3, r1, #10
c0de1dac:	1ac0      	subs	r0, r0, r3
c0de1dae:	4152      	adcs	r2, r2
c0de1db0:	0a43      	lsrs	r3, r0, #9
c0de1db2:	428b      	cmp	r3, r1
c0de1db4:	d301      	bcc.n	c0de1dba <__udivsi3+0x8e>
c0de1db6:	024b      	lsls	r3, r1, #9
c0de1db8:	1ac0      	subs	r0, r0, r3
c0de1dba:	4152      	adcs	r2, r2
c0de1dbc:	0a03      	lsrs	r3, r0, #8
c0de1dbe:	428b      	cmp	r3, r1
c0de1dc0:	d301      	bcc.n	c0de1dc6 <__udivsi3+0x9a>
c0de1dc2:	020b      	lsls	r3, r1, #8
c0de1dc4:	1ac0      	subs	r0, r0, r3
c0de1dc6:	4152      	adcs	r2, r2
c0de1dc8:	d2cd      	bcs.n	c0de1d66 <__udivsi3+0x3a>
c0de1dca:	09c3      	lsrs	r3, r0, #7
c0de1dcc:	428b      	cmp	r3, r1
c0de1dce:	d301      	bcc.n	c0de1dd4 <__udivsi3+0xa8>
c0de1dd0:	01cb      	lsls	r3, r1, #7
c0de1dd2:	1ac0      	subs	r0, r0, r3
c0de1dd4:	4152      	adcs	r2, r2
c0de1dd6:	0983      	lsrs	r3, r0, #6
c0de1dd8:	428b      	cmp	r3, r1
c0de1dda:	d301      	bcc.n	c0de1de0 <__udivsi3+0xb4>
c0de1ddc:	018b      	lsls	r3, r1, #6
c0de1dde:	1ac0      	subs	r0, r0, r3
c0de1de0:	4152      	adcs	r2, r2
c0de1de2:	0943      	lsrs	r3, r0, #5
c0de1de4:	428b      	cmp	r3, r1
c0de1de6:	d301      	bcc.n	c0de1dec <__udivsi3+0xc0>
c0de1de8:	014b      	lsls	r3, r1, #5
c0de1dea:	1ac0      	subs	r0, r0, r3
c0de1dec:	4152      	adcs	r2, r2
c0de1dee:	0903      	lsrs	r3, r0, #4
c0de1df0:	428b      	cmp	r3, r1
c0de1df2:	d301      	bcc.n	c0de1df8 <__udivsi3+0xcc>
c0de1df4:	010b      	lsls	r3, r1, #4
c0de1df6:	1ac0      	subs	r0, r0, r3
c0de1df8:	4152      	adcs	r2, r2
c0de1dfa:	08c3      	lsrs	r3, r0, #3
c0de1dfc:	428b      	cmp	r3, r1
c0de1dfe:	d301      	bcc.n	c0de1e04 <__udivsi3+0xd8>
c0de1e00:	00cb      	lsls	r3, r1, #3
c0de1e02:	1ac0      	subs	r0, r0, r3
c0de1e04:	4152      	adcs	r2, r2
c0de1e06:	0883      	lsrs	r3, r0, #2
c0de1e08:	428b      	cmp	r3, r1
c0de1e0a:	d301      	bcc.n	c0de1e10 <__udivsi3+0xe4>
c0de1e0c:	008b      	lsls	r3, r1, #2
c0de1e0e:	1ac0      	subs	r0, r0, r3
c0de1e10:	4152      	adcs	r2, r2
c0de1e12:	0843      	lsrs	r3, r0, #1
c0de1e14:	428b      	cmp	r3, r1
c0de1e16:	d301      	bcc.n	c0de1e1c <__udivsi3+0xf0>
c0de1e18:	004b      	lsls	r3, r1, #1
c0de1e1a:	1ac0      	subs	r0, r0, r3
c0de1e1c:	4152      	adcs	r2, r2
c0de1e1e:	1a41      	subs	r1, r0, r1
c0de1e20:	d200      	bcs.n	c0de1e24 <__udivsi3+0xf8>
c0de1e22:	4601      	mov	r1, r0
c0de1e24:	4152      	adcs	r2, r2
c0de1e26:	4610      	mov	r0, r2
c0de1e28:	4770      	bx	lr
c0de1e2a:	e7ff      	b.n	c0de1e2c <__udivsi3+0x100>
c0de1e2c:	b501      	push	{r0, lr}
c0de1e2e:	2000      	movs	r0, #0
c0de1e30:	f000 f806 	bl	c0de1e40 <__aeabi_idiv0>
c0de1e34:	bd02      	pop	{r1, pc}
c0de1e36:	46c0      	nop			; (mov r8, r8)

c0de1e38 <__aeabi_uidivmod>:
c0de1e38:	2900      	cmp	r1, #0
c0de1e3a:	d0f7      	beq.n	c0de1e2c <__udivsi3+0x100>
c0de1e3c:	e776      	b.n	c0de1d2c <__udivsi3>
c0de1e3e:	4770      	bx	lr

c0de1e40 <__aeabi_idiv0>:
c0de1e40:	4770      	bx	lr
c0de1e42:	46c0      	nop			; (mov r8, r8)

c0de1e44 <__aeabi_uldivmod>:
c0de1e44:	2b00      	cmp	r3, #0
c0de1e46:	d111      	bne.n	c0de1e6c <__aeabi_uldivmod+0x28>
c0de1e48:	2a00      	cmp	r2, #0
c0de1e4a:	d10f      	bne.n	c0de1e6c <__aeabi_uldivmod+0x28>
c0de1e4c:	2900      	cmp	r1, #0
c0de1e4e:	d100      	bne.n	c0de1e52 <__aeabi_uldivmod+0xe>
c0de1e50:	2800      	cmp	r0, #0
c0de1e52:	d002      	beq.n	c0de1e5a <__aeabi_uldivmod+0x16>
c0de1e54:	2100      	movs	r1, #0
c0de1e56:	43c9      	mvns	r1, r1
c0de1e58:	1c08      	adds	r0, r1, #0
c0de1e5a:	b407      	push	{r0, r1, r2}
c0de1e5c:	4802      	ldr	r0, [pc, #8]	; (c0de1e68 <__aeabi_uldivmod+0x24>)
c0de1e5e:	a102      	add	r1, pc, #8	; (adr r1, c0de1e68 <__aeabi_uldivmod+0x24>)
c0de1e60:	1840      	adds	r0, r0, r1
c0de1e62:	9002      	str	r0, [sp, #8]
c0de1e64:	bd03      	pop	{r0, r1, pc}
c0de1e66:	46c0      	nop			; (mov r8, r8)
c0de1e68:	ffffffd9 	.word	0xffffffd9
c0de1e6c:	b403      	push	{r0, r1}
c0de1e6e:	4668      	mov	r0, sp
c0de1e70:	b501      	push	{r0, lr}
c0de1e72:	9802      	ldr	r0, [sp, #8]
c0de1e74:	f000 f830 	bl	c0de1ed8 <__udivmoddi4>
c0de1e78:	9b01      	ldr	r3, [sp, #4]
c0de1e7a:	469e      	mov	lr, r3
c0de1e7c:	b002      	add	sp, #8
c0de1e7e:	bc0c      	pop	{r2, r3}
c0de1e80:	4770      	bx	lr
c0de1e82:	46c0      	nop			; (mov r8, r8)

c0de1e84 <__aeabi_lmul>:
c0de1e84:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1e86:	46ce      	mov	lr, r9
c0de1e88:	4647      	mov	r7, r8
c0de1e8a:	0415      	lsls	r5, r2, #16
c0de1e8c:	0c2d      	lsrs	r5, r5, #16
c0de1e8e:	002e      	movs	r6, r5
c0de1e90:	b580      	push	{r7, lr}
c0de1e92:	0407      	lsls	r7, r0, #16
c0de1e94:	0c14      	lsrs	r4, r2, #16
c0de1e96:	0c3f      	lsrs	r7, r7, #16
c0de1e98:	4699      	mov	r9, r3
c0de1e9a:	0c03      	lsrs	r3, r0, #16
c0de1e9c:	437e      	muls	r6, r7
c0de1e9e:	435d      	muls	r5, r3
c0de1ea0:	4367      	muls	r7, r4
c0de1ea2:	4363      	muls	r3, r4
c0de1ea4:	197f      	adds	r7, r7, r5
c0de1ea6:	0c34      	lsrs	r4, r6, #16
c0de1ea8:	19e4      	adds	r4, r4, r7
c0de1eaa:	469c      	mov	ip, r3
c0de1eac:	42a5      	cmp	r5, r4
c0de1eae:	d903      	bls.n	c0de1eb8 <__aeabi_lmul+0x34>
c0de1eb0:	2380      	movs	r3, #128	; 0x80
c0de1eb2:	025b      	lsls	r3, r3, #9
c0de1eb4:	4698      	mov	r8, r3
c0de1eb6:	44c4      	add	ip, r8
c0de1eb8:	464b      	mov	r3, r9
c0de1eba:	4343      	muls	r3, r0
c0de1ebc:	4351      	muls	r1, r2
c0de1ebe:	0c25      	lsrs	r5, r4, #16
c0de1ec0:	0436      	lsls	r6, r6, #16
c0de1ec2:	4465      	add	r5, ip
c0de1ec4:	0c36      	lsrs	r6, r6, #16
c0de1ec6:	0424      	lsls	r4, r4, #16
c0de1ec8:	19a4      	adds	r4, r4, r6
c0de1eca:	195b      	adds	r3, r3, r5
c0de1ecc:	1859      	adds	r1, r3, r1
c0de1ece:	0020      	movs	r0, r4
c0de1ed0:	bc0c      	pop	{r2, r3}
c0de1ed2:	4690      	mov	r8, r2
c0de1ed4:	4699      	mov	r9, r3
c0de1ed6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de1ed8 <__udivmoddi4>:
c0de1ed8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1eda:	4657      	mov	r7, sl
c0de1edc:	464e      	mov	r6, r9
c0de1ede:	4645      	mov	r5, r8
c0de1ee0:	46de      	mov	lr, fp
c0de1ee2:	b5e0      	push	{r5, r6, r7, lr}
c0de1ee4:	0004      	movs	r4, r0
c0de1ee6:	b083      	sub	sp, #12
c0de1ee8:	000d      	movs	r5, r1
c0de1eea:	4692      	mov	sl, r2
c0de1eec:	4699      	mov	r9, r3
c0de1eee:	428b      	cmp	r3, r1
c0de1ef0:	d830      	bhi.n	c0de1f54 <__udivmoddi4+0x7c>
c0de1ef2:	d02d      	beq.n	c0de1f50 <__udivmoddi4+0x78>
c0de1ef4:	4649      	mov	r1, r9
c0de1ef6:	4650      	mov	r0, sl
c0de1ef8:	f000 f8c0 	bl	c0de207c <__clzdi2>
c0de1efc:	0029      	movs	r1, r5
c0de1efe:	0006      	movs	r6, r0
c0de1f00:	0020      	movs	r0, r4
c0de1f02:	f000 f8bb 	bl	c0de207c <__clzdi2>
c0de1f06:	1a33      	subs	r3, r6, r0
c0de1f08:	4698      	mov	r8, r3
c0de1f0a:	3b20      	subs	r3, #32
c0de1f0c:	469b      	mov	fp, r3
c0de1f0e:	d433      	bmi.n	c0de1f78 <__udivmoddi4+0xa0>
c0de1f10:	465a      	mov	r2, fp
c0de1f12:	4653      	mov	r3, sl
c0de1f14:	4093      	lsls	r3, r2
c0de1f16:	4642      	mov	r2, r8
c0de1f18:	001f      	movs	r7, r3
c0de1f1a:	4653      	mov	r3, sl
c0de1f1c:	4093      	lsls	r3, r2
c0de1f1e:	001e      	movs	r6, r3
c0de1f20:	42af      	cmp	r7, r5
c0de1f22:	d83a      	bhi.n	c0de1f9a <__udivmoddi4+0xc2>
c0de1f24:	42af      	cmp	r7, r5
c0de1f26:	d100      	bne.n	c0de1f2a <__udivmoddi4+0x52>
c0de1f28:	e07b      	b.n	c0de2022 <__udivmoddi4+0x14a>
c0de1f2a:	465b      	mov	r3, fp
c0de1f2c:	1ba4      	subs	r4, r4, r6
c0de1f2e:	41bd      	sbcs	r5, r7
c0de1f30:	2b00      	cmp	r3, #0
c0de1f32:	da00      	bge.n	c0de1f36 <__udivmoddi4+0x5e>
c0de1f34:	e078      	b.n	c0de2028 <__udivmoddi4+0x150>
c0de1f36:	2200      	movs	r2, #0
c0de1f38:	2300      	movs	r3, #0
c0de1f3a:	9200      	str	r2, [sp, #0]
c0de1f3c:	9301      	str	r3, [sp, #4]
c0de1f3e:	2301      	movs	r3, #1
c0de1f40:	465a      	mov	r2, fp
c0de1f42:	4093      	lsls	r3, r2
c0de1f44:	9301      	str	r3, [sp, #4]
c0de1f46:	2301      	movs	r3, #1
c0de1f48:	4642      	mov	r2, r8
c0de1f4a:	4093      	lsls	r3, r2
c0de1f4c:	9300      	str	r3, [sp, #0]
c0de1f4e:	e028      	b.n	c0de1fa2 <__udivmoddi4+0xca>
c0de1f50:	4282      	cmp	r2, r0
c0de1f52:	d9cf      	bls.n	c0de1ef4 <__udivmoddi4+0x1c>
c0de1f54:	2200      	movs	r2, #0
c0de1f56:	2300      	movs	r3, #0
c0de1f58:	9200      	str	r2, [sp, #0]
c0de1f5a:	9301      	str	r3, [sp, #4]
c0de1f5c:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0de1f5e:	2b00      	cmp	r3, #0
c0de1f60:	d001      	beq.n	c0de1f66 <__udivmoddi4+0x8e>
c0de1f62:	601c      	str	r4, [r3, #0]
c0de1f64:	605d      	str	r5, [r3, #4]
c0de1f66:	9800      	ldr	r0, [sp, #0]
c0de1f68:	9901      	ldr	r1, [sp, #4]
c0de1f6a:	b003      	add	sp, #12
c0de1f6c:	bc3c      	pop	{r2, r3, r4, r5}
c0de1f6e:	4690      	mov	r8, r2
c0de1f70:	4699      	mov	r9, r3
c0de1f72:	46a2      	mov	sl, r4
c0de1f74:	46ab      	mov	fp, r5
c0de1f76:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1f78:	4642      	mov	r2, r8
c0de1f7a:	2320      	movs	r3, #32
c0de1f7c:	1a9b      	subs	r3, r3, r2
c0de1f7e:	4652      	mov	r2, sl
c0de1f80:	40da      	lsrs	r2, r3
c0de1f82:	4641      	mov	r1, r8
c0de1f84:	0013      	movs	r3, r2
c0de1f86:	464a      	mov	r2, r9
c0de1f88:	408a      	lsls	r2, r1
c0de1f8a:	0017      	movs	r7, r2
c0de1f8c:	4642      	mov	r2, r8
c0de1f8e:	431f      	orrs	r7, r3
c0de1f90:	4653      	mov	r3, sl
c0de1f92:	4093      	lsls	r3, r2
c0de1f94:	001e      	movs	r6, r3
c0de1f96:	42af      	cmp	r7, r5
c0de1f98:	d9c4      	bls.n	c0de1f24 <__udivmoddi4+0x4c>
c0de1f9a:	2200      	movs	r2, #0
c0de1f9c:	2300      	movs	r3, #0
c0de1f9e:	9200      	str	r2, [sp, #0]
c0de1fa0:	9301      	str	r3, [sp, #4]
c0de1fa2:	4643      	mov	r3, r8
c0de1fa4:	2b00      	cmp	r3, #0
c0de1fa6:	d0d9      	beq.n	c0de1f5c <__udivmoddi4+0x84>
c0de1fa8:	07fb      	lsls	r3, r7, #31
c0de1faa:	469c      	mov	ip, r3
c0de1fac:	4661      	mov	r1, ip
c0de1fae:	0872      	lsrs	r2, r6, #1
c0de1fb0:	430a      	orrs	r2, r1
c0de1fb2:	087b      	lsrs	r3, r7, #1
c0de1fb4:	4646      	mov	r6, r8
c0de1fb6:	e00e      	b.n	c0de1fd6 <__udivmoddi4+0xfe>
c0de1fb8:	42ab      	cmp	r3, r5
c0de1fba:	d101      	bne.n	c0de1fc0 <__udivmoddi4+0xe8>
c0de1fbc:	42a2      	cmp	r2, r4
c0de1fbe:	d80c      	bhi.n	c0de1fda <__udivmoddi4+0x102>
c0de1fc0:	1aa4      	subs	r4, r4, r2
c0de1fc2:	419d      	sbcs	r5, r3
c0de1fc4:	2001      	movs	r0, #1
c0de1fc6:	1924      	adds	r4, r4, r4
c0de1fc8:	416d      	adcs	r5, r5
c0de1fca:	2100      	movs	r1, #0
c0de1fcc:	3e01      	subs	r6, #1
c0de1fce:	1824      	adds	r4, r4, r0
c0de1fd0:	414d      	adcs	r5, r1
c0de1fd2:	2e00      	cmp	r6, #0
c0de1fd4:	d006      	beq.n	c0de1fe4 <__udivmoddi4+0x10c>
c0de1fd6:	42ab      	cmp	r3, r5
c0de1fd8:	d9ee      	bls.n	c0de1fb8 <__udivmoddi4+0xe0>
c0de1fda:	3e01      	subs	r6, #1
c0de1fdc:	1924      	adds	r4, r4, r4
c0de1fde:	416d      	adcs	r5, r5
c0de1fe0:	2e00      	cmp	r6, #0
c0de1fe2:	d1f8      	bne.n	c0de1fd6 <__udivmoddi4+0xfe>
c0de1fe4:	9800      	ldr	r0, [sp, #0]
c0de1fe6:	9901      	ldr	r1, [sp, #4]
c0de1fe8:	465b      	mov	r3, fp
c0de1fea:	1900      	adds	r0, r0, r4
c0de1fec:	4169      	adcs	r1, r5
c0de1fee:	2b00      	cmp	r3, #0
c0de1ff0:	db25      	blt.n	c0de203e <__udivmoddi4+0x166>
c0de1ff2:	002b      	movs	r3, r5
c0de1ff4:	465a      	mov	r2, fp
c0de1ff6:	4644      	mov	r4, r8
c0de1ff8:	40d3      	lsrs	r3, r2
c0de1ffa:	002a      	movs	r2, r5
c0de1ffc:	40e2      	lsrs	r2, r4
c0de1ffe:	001c      	movs	r4, r3
c0de2000:	465b      	mov	r3, fp
c0de2002:	0015      	movs	r5, r2
c0de2004:	2b00      	cmp	r3, #0
c0de2006:	db2b      	blt.n	c0de2060 <__udivmoddi4+0x188>
c0de2008:	0026      	movs	r6, r4
c0de200a:	465f      	mov	r7, fp
c0de200c:	40be      	lsls	r6, r7
c0de200e:	0033      	movs	r3, r6
c0de2010:	0026      	movs	r6, r4
c0de2012:	4647      	mov	r7, r8
c0de2014:	40be      	lsls	r6, r7
c0de2016:	0032      	movs	r2, r6
c0de2018:	1a80      	subs	r0, r0, r2
c0de201a:	4199      	sbcs	r1, r3
c0de201c:	9000      	str	r0, [sp, #0]
c0de201e:	9101      	str	r1, [sp, #4]
c0de2020:	e79c      	b.n	c0de1f5c <__udivmoddi4+0x84>
c0de2022:	42a3      	cmp	r3, r4
c0de2024:	d8b9      	bhi.n	c0de1f9a <__udivmoddi4+0xc2>
c0de2026:	e780      	b.n	c0de1f2a <__udivmoddi4+0x52>
c0de2028:	4642      	mov	r2, r8
c0de202a:	2320      	movs	r3, #32
c0de202c:	2100      	movs	r1, #0
c0de202e:	1a9b      	subs	r3, r3, r2
c0de2030:	2200      	movs	r2, #0
c0de2032:	9100      	str	r1, [sp, #0]
c0de2034:	9201      	str	r2, [sp, #4]
c0de2036:	2201      	movs	r2, #1
c0de2038:	40da      	lsrs	r2, r3
c0de203a:	9201      	str	r2, [sp, #4]
c0de203c:	e783      	b.n	c0de1f46 <__udivmoddi4+0x6e>
c0de203e:	4642      	mov	r2, r8
c0de2040:	2320      	movs	r3, #32
c0de2042:	1a9b      	subs	r3, r3, r2
c0de2044:	002a      	movs	r2, r5
c0de2046:	4646      	mov	r6, r8
c0de2048:	409a      	lsls	r2, r3
c0de204a:	0023      	movs	r3, r4
c0de204c:	40f3      	lsrs	r3, r6
c0de204e:	4644      	mov	r4, r8
c0de2050:	4313      	orrs	r3, r2
c0de2052:	002a      	movs	r2, r5
c0de2054:	40e2      	lsrs	r2, r4
c0de2056:	001c      	movs	r4, r3
c0de2058:	465b      	mov	r3, fp
c0de205a:	0015      	movs	r5, r2
c0de205c:	2b00      	cmp	r3, #0
c0de205e:	dad3      	bge.n	c0de2008 <__udivmoddi4+0x130>
c0de2060:	2320      	movs	r3, #32
c0de2062:	4642      	mov	r2, r8
c0de2064:	0026      	movs	r6, r4
c0de2066:	1a9b      	subs	r3, r3, r2
c0de2068:	40de      	lsrs	r6, r3
c0de206a:	002f      	movs	r7, r5
c0de206c:	46b4      	mov	ip, r6
c0de206e:	4646      	mov	r6, r8
c0de2070:	40b7      	lsls	r7, r6
c0de2072:	4666      	mov	r6, ip
c0de2074:	003b      	movs	r3, r7
c0de2076:	4333      	orrs	r3, r6
c0de2078:	e7ca      	b.n	c0de2010 <__udivmoddi4+0x138>
c0de207a:	46c0      	nop			; (mov r8, r8)

c0de207c <__clzdi2>:
c0de207c:	b510      	push	{r4, lr}
c0de207e:	2900      	cmp	r1, #0
c0de2080:	d103      	bne.n	c0de208a <__clzdi2+0xe>
c0de2082:	f000 f807 	bl	c0de2094 <__clzsi2>
c0de2086:	3020      	adds	r0, #32
c0de2088:	e002      	b.n	c0de2090 <__clzdi2+0x14>
c0de208a:	1c08      	adds	r0, r1, #0
c0de208c:	f000 f802 	bl	c0de2094 <__clzsi2>
c0de2090:	bd10      	pop	{r4, pc}
c0de2092:	46c0      	nop			; (mov r8, r8)

c0de2094 <__clzsi2>:
c0de2094:	211c      	movs	r1, #28
c0de2096:	2301      	movs	r3, #1
c0de2098:	041b      	lsls	r3, r3, #16
c0de209a:	4298      	cmp	r0, r3
c0de209c:	d301      	bcc.n	c0de20a2 <__clzsi2+0xe>
c0de209e:	0c00      	lsrs	r0, r0, #16
c0de20a0:	3910      	subs	r1, #16
c0de20a2:	0a1b      	lsrs	r3, r3, #8
c0de20a4:	4298      	cmp	r0, r3
c0de20a6:	d301      	bcc.n	c0de20ac <__clzsi2+0x18>
c0de20a8:	0a00      	lsrs	r0, r0, #8
c0de20aa:	3908      	subs	r1, #8
c0de20ac:	091b      	lsrs	r3, r3, #4
c0de20ae:	4298      	cmp	r0, r3
c0de20b0:	d301      	bcc.n	c0de20b6 <__clzsi2+0x22>
c0de20b2:	0900      	lsrs	r0, r0, #4
c0de20b4:	3904      	subs	r1, #4
c0de20b6:	a202      	add	r2, pc, #8	; (adr r2, c0de20c0 <__clzsi2+0x2c>)
c0de20b8:	5c10      	ldrb	r0, [r2, r0]
c0de20ba:	1840      	adds	r0, r0, r1
c0de20bc:	4770      	bx	lr
c0de20be:	46c0      	nop			; (mov r8, r8)
c0de20c0:	02020304 	.word	0x02020304
c0de20c4:	01010101 	.word	0x01010101
	...

c0de20d0 <__aeabi_memclr>:
c0de20d0:	b510      	push	{r4, lr}
c0de20d2:	2200      	movs	r2, #0
c0de20d4:	f000 f80a 	bl	c0de20ec <__aeabi_memset>
c0de20d8:	bd10      	pop	{r4, pc}
c0de20da:	46c0      	nop			; (mov r8, r8)

c0de20dc <__aeabi_memcpy>:
c0de20dc:	b510      	push	{r4, lr}
c0de20de:	f000 f835 	bl	c0de214c <memcpy>
c0de20e2:	bd10      	pop	{r4, pc}

c0de20e4 <__aeabi_memmove>:
c0de20e4:	b510      	push	{r4, lr}
c0de20e6:	f000 f885 	bl	c0de21f4 <memmove>
c0de20ea:	bd10      	pop	{r4, pc}

c0de20ec <__aeabi_memset>:
c0de20ec:	0013      	movs	r3, r2
c0de20ee:	b510      	push	{r4, lr}
c0de20f0:	000a      	movs	r2, r1
c0de20f2:	0019      	movs	r1, r3
c0de20f4:	f000 f8dc 	bl	c0de22b0 <memset>
c0de20f8:	bd10      	pop	{r4, pc}
c0de20fa:	46c0      	nop			; (mov r8, r8)

c0de20fc <memcmp>:
c0de20fc:	b530      	push	{r4, r5, lr}
c0de20fe:	2a03      	cmp	r2, #3
c0de2100:	d90c      	bls.n	c0de211c <memcmp+0x20>
c0de2102:	0003      	movs	r3, r0
c0de2104:	430b      	orrs	r3, r1
c0de2106:	079b      	lsls	r3, r3, #30
c0de2108:	d11c      	bne.n	c0de2144 <memcmp+0x48>
c0de210a:	6803      	ldr	r3, [r0, #0]
c0de210c:	680c      	ldr	r4, [r1, #0]
c0de210e:	42a3      	cmp	r3, r4
c0de2110:	d118      	bne.n	c0de2144 <memcmp+0x48>
c0de2112:	3a04      	subs	r2, #4
c0de2114:	3004      	adds	r0, #4
c0de2116:	3104      	adds	r1, #4
c0de2118:	2a03      	cmp	r2, #3
c0de211a:	d8f6      	bhi.n	c0de210a <memcmp+0xe>
c0de211c:	1e55      	subs	r5, r2, #1
c0de211e:	2a00      	cmp	r2, #0
c0de2120:	d00e      	beq.n	c0de2140 <memcmp+0x44>
c0de2122:	7802      	ldrb	r2, [r0, #0]
c0de2124:	780c      	ldrb	r4, [r1, #0]
c0de2126:	4294      	cmp	r4, r2
c0de2128:	d10e      	bne.n	c0de2148 <memcmp+0x4c>
c0de212a:	3501      	adds	r5, #1
c0de212c:	2301      	movs	r3, #1
c0de212e:	3901      	subs	r1, #1
c0de2130:	e004      	b.n	c0de213c <memcmp+0x40>
c0de2132:	5cc2      	ldrb	r2, [r0, r3]
c0de2134:	3301      	adds	r3, #1
c0de2136:	5ccc      	ldrb	r4, [r1, r3]
c0de2138:	42a2      	cmp	r2, r4
c0de213a:	d105      	bne.n	c0de2148 <memcmp+0x4c>
c0de213c:	42ab      	cmp	r3, r5
c0de213e:	d1f8      	bne.n	c0de2132 <memcmp+0x36>
c0de2140:	2000      	movs	r0, #0
c0de2142:	bd30      	pop	{r4, r5, pc}
c0de2144:	1e55      	subs	r5, r2, #1
c0de2146:	e7ec      	b.n	c0de2122 <memcmp+0x26>
c0de2148:	1b10      	subs	r0, r2, r4
c0de214a:	e7fa      	b.n	c0de2142 <memcmp+0x46>

c0de214c <memcpy>:
c0de214c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de214e:	46c6      	mov	lr, r8
c0de2150:	b500      	push	{lr}
c0de2152:	2a0f      	cmp	r2, #15
c0de2154:	d943      	bls.n	c0de21de <memcpy+0x92>
c0de2156:	000b      	movs	r3, r1
c0de2158:	2603      	movs	r6, #3
c0de215a:	4303      	orrs	r3, r0
c0de215c:	401e      	ands	r6, r3
c0de215e:	000c      	movs	r4, r1
c0de2160:	0003      	movs	r3, r0
c0de2162:	2e00      	cmp	r6, #0
c0de2164:	d140      	bne.n	c0de21e8 <memcpy+0x9c>
c0de2166:	0015      	movs	r5, r2
c0de2168:	3d10      	subs	r5, #16
c0de216a:	092d      	lsrs	r5, r5, #4
c0de216c:	46ac      	mov	ip, r5
c0de216e:	012d      	lsls	r5, r5, #4
c0de2170:	46a8      	mov	r8, r5
c0de2172:	4480      	add	r8, r0
c0de2174:	e000      	b.n	c0de2178 <memcpy+0x2c>
c0de2176:	003b      	movs	r3, r7
c0de2178:	6867      	ldr	r7, [r4, #4]
c0de217a:	6825      	ldr	r5, [r4, #0]
c0de217c:	605f      	str	r7, [r3, #4]
c0de217e:	68e7      	ldr	r7, [r4, #12]
c0de2180:	601d      	str	r5, [r3, #0]
c0de2182:	60df      	str	r7, [r3, #12]
c0de2184:	001f      	movs	r7, r3
c0de2186:	68a5      	ldr	r5, [r4, #8]
c0de2188:	3710      	adds	r7, #16
c0de218a:	609d      	str	r5, [r3, #8]
c0de218c:	3410      	adds	r4, #16
c0de218e:	4543      	cmp	r3, r8
c0de2190:	d1f1      	bne.n	c0de2176 <memcpy+0x2a>
c0de2192:	4665      	mov	r5, ip
c0de2194:	230f      	movs	r3, #15
c0de2196:	240c      	movs	r4, #12
c0de2198:	3501      	adds	r5, #1
c0de219a:	012d      	lsls	r5, r5, #4
c0de219c:	1949      	adds	r1, r1, r5
c0de219e:	4013      	ands	r3, r2
c0de21a0:	1945      	adds	r5, r0, r5
c0de21a2:	4214      	tst	r4, r2
c0de21a4:	d023      	beq.n	c0de21ee <memcpy+0xa2>
c0de21a6:	598c      	ldr	r4, [r1, r6]
c0de21a8:	51ac      	str	r4, [r5, r6]
c0de21aa:	3604      	adds	r6, #4
c0de21ac:	1b9c      	subs	r4, r3, r6
c0de21ae:	2c03      	cmp	r4, #3
c0de21b0:	d8f9      	bhi.n	c0de21a6 <memcpy+0x5a>
c0de21b2:	2403      	movs	r4, #3
c0de21b4:	3b04      	subs	r3, #4
c0de21b6:	089b      	lsrs	r3, r3, #2
c0de21b8:	3301      	adds	r3, #1
c0de21ba:	009b      	lsls	r3, r3, #2
c0de21bc:	4022      	ands	r2, r4
c0de21be:	18ed      	adds	r5, r5, r3
c0de21c0:	18c9      	adds	r1, r1, r3
c0de21c2:	1e56      	subs	r6, r2, #1
c0de21c4:	2a00      	cmp	r2, #0
c0de21c6:	d007      	beq.n	c0de21d8 <memcpy+0x8c>
c0de21c8:	2300      	movs	r3, #0
c0de21ca:	e000      	b.n	c0de21ce <memcpy+0x82>
c0de21cc:	0023      	movs	r3, r4
c0de21ce:	5cca      	ldrb	r2, [r1, r3]
c0de21d0:	1c5c      	adds	r4, r3, #1
c0de21d2:	54ea      	strb	r2, [r5, r3]
c0de21d4:	429e      	cmp	r6, r3
c0de21d6:	d1f9      	bne.n	c0de21cc <memcpy+0x80>
c0de21d8:	bc04      	pop	{r2}
c0de21da:	4690      	mov	r8, r2
c0de21dc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de21de:	0005      	movs	r5, r0
c0de21e0:	1e56      	subs	r6, r2, #1
c0de21e2:	2a00      	cmp	r2, #0
c0de21e4:	d1f0      	bne.n	c0de21c8 <memcpy+0x7c>
c0de21e6:	e7f7      	b.n	c0de21d8 <memcpy+0x8c>
c0de21e8:	1e56      	subs	r6, r2, #1
c0de21ea:	0005      	movs	r5, r0
c0de21ec:	e7ec      	b.n	c0de21c8 <memcpy+0x7c>
c0de21ee:	001a      	movs	r2, r3
c0de21f0:	e7f6      	b.n	c0de21e0 <memcpy+0x94>
c0de21f2:	46c0      	nop			; (mov r8, r8)

c0de21f4 <memmove>:
c0de21f4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de21f6:	46c6      	mov	lr, r8
c0de21f8:	b500      	push	{lr}
c0de21fa:	4288      	cmp	r0, r1
c0de21fc:	d90c      	bls.n	c0de2218 <memmove+0x24>
c0de21fe:	188b      	adds	r3, r1, r2
c0de2200:	4298      	cmp	r0, r3
c0de2202:	d209      	bcs.n	c0de2218 <memmove+0x24>
c0de2204:	1e53      	subs	r3, r2, #1
c0de2206:	2a00      	cmp	r2, #0
c0de2208:	d003      	beq.n	c0de2212 <memmove+0x1e>
c0de220a:	5cca      	ldrb	r2, [r1, r3]
c0de220c:	54c2      	strb	r2, [r0, r3]
c0de220e:	3b01      	subs	r3, #1
c0de2210:	d2fb      	bcs.n	c0de220a <memmove+0x16>
c0de2212:	bc04      	pop	{r2}
c0de2214:	4690      	mov	r8, r2
c0de2216:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de2218:	2a0f      	cmp	r2, #15
c0de221a:	d80c      	bhi.n	c0de2236 <memmove+0x42>
c0de221c:	0005      	movs	r5, r0
c0de221e:	1e56      	subs	r6, r2, #1
c0de2220:	2a00      	cmp	r2, #0
c0de2222:	d0f6      	beq.n	c0de2212 <memmove+0x1e>
c0de2224:	2300      	movs	r3, #0
c0de2226:	e000      	b.n	c0de222a <memmove+0x36>
c0de2228:	0023      	movs	r3, r4
c0de222a:	5cca      	ldrb	r2, [r1, r3]
c0de222c:	1c5c      	adds	r4, r3, #1
c0de222e:	54ea      	strb	r2, [r5, r3]
c0de2230:	429e      	cmp	r6, r3
c0de2232:	d1f9      	bne.n	c0de2228 <memmove+0x34>
c0de2234:	e7ed      	b.n	c0de2212 <memmove+0x1e>
c0de2236:	000b      	movs	r3, r1
c0de2238:	2603      	movs	r6, #3
c0de223a:	4303      	orrs	r3, r0
c0de223c:	401e      	ands	r6, r3
c0de223e:	000c      	movs	r4, r1
c0de2240:	0003      	movs	r3, r0
c0de2242:	2e00      	cmp	r6, #0
c0de2244:	d12e      	bne.n	c0de22a4 <memmove+0xb0>
c0de2246:	0015      	movs	r5, r2
c0de2248:	3d10      	subs	r5, #16
c0de224a:	092d      	lsrs	r5, r5, #4
c0de224c:	46ac      	mov	ip, r5
c0de224e:	012d      	lsls	r5, r5, #4
c0de2250:	46a8      	mov	r8, r5
c0de2252:	4480      	add	r8, r0
c0de2254:	e000      	b.n	c0de2258 <memmove+0x64>
c0de2256:	002b      	movs	r3, r5
c0de2258:	001d      	movs	r5, r3
c0de225a:	6827      	ldr	r7, [r4, #0]
c0de225c:	3510      	adds	r5, #16
c0de225e:	601f      	str	r7, [r3, #0]
c0de2260:	6867      	ldr	r7, [r4, #4]
c0de2262:	605f      	str	r7, [r3, #4]
c0de2264:	68a7      	ldr	r7, [r4, #8]
c0de2266:	609f      	str	r7, [r3, #8]
c0de2268:	68e7      	ldr	r7, [r4, #12]
c0de226a:	3410      	adds	r4, #16
c0de226c:	60df      	str	r7, [r3, #12]
c0de226e:	4543      	cmp	r3, r8
c0de2270:	d1f1      	bne.n	c0de2256 <memmove+0x62>
c0de2272:	4665      	mov	r5, ip
c0de2274:	230f      	movs	r3, #15
c0de2276:	240c      	movs	r4, #12
c0de2278:	3501      	adds	r5, #1
c0de227a:	012d      	lsls	r5, r5, #4
c0de227c:	1949      	adds	r1, r1, r5
c0de227e:	4013      	ands	r3, r2
c0de2280:	1945      	adds	r5, r0, r5
c0de2282:	4214      	tst	r4, r2
c0de2284:	d011      	beq.n	c0de22aa <memmove+0xb6>
c0de2286:	598c      	ldr	r4, [r1, r6]
c0de2288:	51ac      	str	r4, [r5, r6]
c0de228a:	3604      	adds	r6, #4
c0de228c:	1b9c      	subs	r4, r3, r6
c0de228e:	2c03      	cmp	r4, #3
c0de2290:	d8f9      	bhi.n	c0de2286 <memmove+0x92>
c0de2292:	2403      	movs	r4, #3
c0de2294:	3b04      	subs	r3, #4
c0de2296:	089b      	lsrs	r3, r3, #2
c0de2298:	3301      	adds	r3, #1
c0de229a:	009b      	lsls	r3, r3, #2
c0de229c:	18ed      	adds	r5, r5, r3
c0de229e:	18c9      	adds	r1, r1, r3
c0de22a0:	4022      	ands	r2, r4
c0de22a2:	e7bc      	b.n	c0de221e <memmove+0x2a>
c0de22a4:	1e56      	subs	r6, r2, #1
c0de22a6:	0005      	movs	r5, r0
c0de22a8:	e7bc      	b.n	c0de2224 <memmove+0x30>
c0de22aa:	001a      	movs	r2, r3
c0de22ac:	e7b7      	b.n	c0de221e <memmove+0x2a>
c0de22ae:	46c0      	nop			; (mov r8, r8)

c0de22b0 <memset>:
c0de22b0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de22b2:	0005      	movs	r5, r0
c0de22b4:	0783      	lsls	r3, r0, #30
c0de22b6:	d04a      	beq.n	c0de234e <memset+0x9e>
c0de22b8:	1e54      	subs	r4, r2, #1
c0de22ba:	2a00      	cmp	r2, #0
c0de22bc:	d044      	beq.n	c0de2348 <memset+0x98>
c0de22be:	b2ce      	uxtb	r6, r1
c0de22c0:	0003      	movs	r3, r0
c0de22c2:	2203      	movs	r2, #3
c0de22c4:	e002      	b.n	c0de22cc <memset+0x1c>
c0de22c6:	3501      	adds	r5, #1
c0de22c8:	3c01      	subs	r4, #1
c0de22ca:	d33d      	bcc.n	c0de2348 <memset+0x98>
c0de22cc:	3301      	adds	r3, #1
c0de22ce:	702e      	strb	r6, [r5, #0]
c0de22d0:	4213      	tst	r3, r2
c0de22d2:	d1f8      	bne.n	c0de22c6 <memset+0x16>
c0de22d4:	2c03      	cmp	r4, #3
c0de22d6:	d92f      	bls.n	c0de2338 <memset+0x88>
c0de22d8:	22ff      	movs	r2, #255	; 0xff
c0de22da:	400a      	ands	r2, r1
c0de22dc:	0215      	lsls	r5, r2, #8
c0de22de:	4315      	orrs	r5, r2
c0de22e0:	042a      	lsls	r2, r5, #16
c0de22e2:	4315      	orrs	r5, r2
c0de22e4:	2c0f      	cmp	r4, #15
c0de22e6:	d935      	bls.n	c0de2354 <memset+0xa4>
c0de22e8:	0027      	movs	r7, r4
c0de22ea:	3f10      	subs	r7, #16
c0de22ec:	093f      	lsrs	r7, r7, #4
c0de22ee:	013e      	lsls	r6, r7, #4
c0de22f0:	46b4      	mov	ip, r6
c0de22f2:	001e      	movs	r6, r3
c0de22f4:	001a      	movs	r2, r3
c0de22f6:	3610      	adds	r6, #16
c0de22f8:	4466      	add	r6, ip
c0de22fa:	6015      	str	r5, [r2, #0]
c0de22fc:	6055      	str	r5, [r2, #4]
c0de22fe:	6095      	str	r5, [r2, #8]
c0de2300:	60d5      	str	r5, [r2, #12]
c0de2302:	3210      	adds	r2, #16
c0de2304:	42b2      	cmp	r2, r6
c0de2306:	d1f8      	bne.n	c0de22fa <memset+0x4a>
c0de2308:	260f      	movs	r6, #15
c0de230a:	220c      	movs	r2, #12
c0de230c:	3701      	adds	r7, #1
c0de230e:	013f      	lsls	r7, r7, #4
c0de2310:	4026      	ands	r6, r4
c0de2312:	19db      	adds	r3, r3, r7
c0de2314:	0037      	movs	r7, r6
c0de2316:	4222      	tst	r2, r4
c0de2318:	d017      	beq.n	c0de234a <memset+0x9a>
c0de231a:	1f3e      	subs	r6, r7, #4
c0de231c:	08b6      	lsrs	r6, r6, #2
c0de231e:	00b4      	lsls	r4, r6, #2
c0de2320:	46a4      	mov	ip, r4
c0de2322:	001a      	movs	r2, r3
c0de2324:	1d1c      	adds	r4, r3, #4
c0de2326:	4464      	add	r4, ip
c0de2328:	c220      	stmia	r2!, {r5}
c0de232a:	42a2      	cmp	r2, r4
c0de232c:	d1fc      	bne.n	c0de2328 <memset+0x78>
c0de232e:	2403      	movs	r4, #3
c0de2330:	3601      	adds	r6, #1
c0de2332:	00b6      	lsls	r6, r6, #2
c0de2334:	199b      	adds	r3, r3, r6
c0de2336:	403c      	ands	r4, r7
c0de2338:	2c00      	cmp	r4, #0
c0de233a:	d005      	beq.n	c0de2348 <memset+0x98>
c0de233c:	b2c9      	uxtb	r1, r1
c0de233e:	191c      	adds	r4, r3, r4
c0de2340:	7019      	strb	r1, [r3, #0]
c0de2342:	3301      	adds	r3, #1
c0de2344:	429c      	cmp	r4, r3
c0de2346:	d1fb      	bne.n	c0de2340 <memset+0x90>
c0de2348:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de234a:	0034      	movs	r4, r6
c0de234c:	e7f4      	b.n	c0de2338 <memset+0x88>
c0de234e:	0014      	movs	r4, r2
c0de2350:	0003      	movs	r3, r0
c0de2352:	e7bf      	b.n	c0de22d4 <memset+0x24>
c0de2354:	0027      	movs	r7, r4
c0de2356:	e7e0      	b.n	c0de231a <memset+0x6a>

c0de2358 <setjmp>:
c0de2358:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de235a:	4641      	mov	r1, r8
c0de235c:	464a      	mov	r2, r9
c0de235e:	4653      	mov	r3, sl
c0de2360:	465c      	mov	r4, fp
c0de2362:	466d      	mov	r5, sp
c0de2364:	4676      	mov	r6, lr
c0de2366:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de2368:	3828      	subs	r0, #40	; 0x28
c0de236a:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de236c:	2000      	movs	r0, #0
c0de236e:	4770      	bx	lr

c0de2370 <longjmp>:
c0de2370:	3010      	adds	r0, #16
c0de2372:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de2374:	4690      	mov	r8, r2
c0de2376:	4699      	mov	r9, r3
c0de2378:	46a2      	mov	sl, r4
c0de237a:	46ab      	mov	fp, r5
c0de237c:	46b5      	mov	sp, r6
c0de237e:	c808      	ldmia	r0!, {r3}
c0de2380:	3828      	subs	r0, #40	; 0x28
c0de2382:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de2384:	1c08      	adds	r0, r1, #0
c0de2386:	d100      	bne.n	c0de238a <longjmp+0x1a>
c0de2388:	2001      	movs	r0, #1
c0de238a:	4718      	bx	r3

c0de238c <strlcat>:
c0de238c:	b570      	push	{r4, r5, r6, lr}
c0de238e:	2a00      	cmp	r2, #0
c0de2390:	d02a      	beq.n	c0de23e8 <strlcat+0x5c>
c0de2392:	7803      	ldrb	r3, [r0, #0]
c0de2394:	2b00      	cmp	r3, #0
c0de2396:	d029      	beq.n	c0de23ec <strlcat+0x60>
c0de2398:	1884      	adds	r4, r0, r2
c0de239a:	0003      	movs	r3, r0
c0de239c:	e002      	b.n	c0de23a4 <strlcat+0x18>
c0de239e:	781d      	ldrb	r5, [r3, #0]
c0de23a0:	2d00      	cmp	r5, #0
c0de23a2:	d018      	beq.n	c0de23d6 <strlcat+0x4a>
c0de23a4:	3301      	adds	r3, #1
c0de23a6:	42a3      	cmp	r3, r4
c0de23a8:	d1f9      	bne.n	c0de239e <strlcat+0x12>
c0de23aa:	1a26      	subs	r6, r4, r0
c0de23ac:	1b92      	subs	r2, r2, r6
c0de23ae:	d016      	beq.n	c0de23de <strlcat+0x52>
c0de23b0:	780d      	ldrb	r5, [r1, #0]
c0de23b2:	000b      	movs	r3, r1
c0de23b4:	2d00      	cmp	r5, #0
c0de23b6:	d00a      	beq.n	c0de23ce <strlcat+0x42>
c0de23b8:	2a01      	cmp	r2, #1
c0de23ba:	d002      	beq.n	c0de23c2 <strlcat+0x36>
c0de23bc:	7025      	strb	r5, [r4, #0]
c0de23be:	3a01      	subs	r2, #1
c0de23c0:	3401      	adds	r4, #1
c0de23c2:	3301      	adds	r3, #1
c0de23c4:	781d      	ldrb	r5, [r3, #0]
c0de23c6:	2d00      	cmp	r5, #0
c0de23c8:	d1f6      	bne.n	c0de23b8 <strlcat+0x2c>
c0de23ca:	1a5b      	subs	r3, r3, r1
c0de23cc:	18f6      	adds	r6, r6, r3
c0de23ce:	2300      	movs	r3, #0
c0de23d0:	7023      	strb	r3, [r4, #0]
c0de23d2:	0030      	movs	r0, r6
c0de23d4:	bd70      	pop	{r4, r5, r6, pc}
c0de23d6:	001c      	movs	r4, r3
c0de23d8:	1a26      	subs	r6, r4, r0
c0de23da:	1b92      	subs	r2, r2, r6
c0de23dc:	d1e8      	bne.n	c0de23b0 <strlcat+0x24>
c0de23de:	0008      	movs	r0, r1
c0de23e0:	f000 f82e 	bl	c0de2440 <strlen>
c0de23e4:	1836      	adds	r6, r6, r0
c0de23e6:	e7f4      	b.n	c0de23d2 <strlcat+0x46>
c0de23e8:	2600      	movs	r6, #0
c0de23ea:	e7f8      	b.n	c0de23de <strlcat+0x52>
c0de23ec:	0004      	movs	r4, r0
c0de23ee:	2600      	movs	r6, #0
c0de23f0:	e7de      	b.n	c0de23b0 <strlcat+0x24>
c0de23f2:	46c0      	nop			; (mov r8, r8)

c0de23f4 <strlcpy>:
c0de23f4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de23f6:	2a00      	cmp	r2, #0
c0de23f8:	d013      	beq.n	c0de2422 <strlcpy+0x2e>
c0de23fa:	3a01      	subs	r2, #1
c0de23fc:	2a00      	cmp	r2, #0
c0de23fe:	d019      	beq.n	c0de2434 <strlcpy+0x40>
c0de2400:	2300      	movs	r3, #0
c0de2402:	1c4f      	adds	r7, r1, #1
c0de2404:	1c46      	adds	r6, r0, #1
c0de2406:	e002      	b.n	c0de240e <strlcpy+0x1a>
c0de2408:	3301      	adds	r3, #1
c0de240a:	429a      	cmp	r2, r3
c0de240c:	d016      	beq.n	c0de243c <strlcpy+0x48>
c0de240e:	18f5      	adds	r5, r6, r3
c0de2410:	46ac      	mov	ip, r5
c0de2412:	5ccd      	ldrb	r5, [r1, r3]
c0de2414:	18fc      	adds	r4, r7, r3
c0de2416:	54c5      	strb	r5, [r0, r3]
c0de2418:	2d00      	cmp	r5, #0
c0de241a:	d1f5      	bne.n	c0de2408 <strlcpy+0x14>
c0de241c:	1a60      	subs	r0, r4, r1
c0de241e:	3801      	subs	r0, #1
c0de2420:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de2422:	000c      	movs	r4, r1
c0de2424:	0023      	movs	r3, r4
c0de2426:	3301      	adds	r3, #1
c0de2428:	1e5a      	subs	r2, r3, #1
c0de242a:	7812      	ldrb	r2, [r2, #0]
c0de242c:	001c      	movs	r4, r3
c0de242e:	2a00      	cmp	r2, #0
c0de2430:	d1f9      	bne.n	c0de2426 <strlcpy+0x32>
c0de2432:	e7f3      	b.n	c0de241c <strlcpy+0x28>
c0de2434:	000c      	movs	r4, r1
c0de2436:	2300      	movs	r3, #0
c0de2438:	7003      	strb	r3, [r0, #0]
c0de243a:	e7f3      	b.n	c0de2424 <strlcpy+0x30>
c0de243c:	4660      	mov	r0, ip
c0de243e:	e7fa      	b.n	c0de2436 <strlcpy+0x42>

c0de2440 <strlen>:
c0de2440:	b510      	push	{r4, lr}
c0de2442:	0783      	lsls	r3, r0, #30
c0de2444:	d027      	beq.n	c0de2496 <strlen+0x56>
c0de2446:	7803      	ldrb	r3, [r0, #0]
c0de2448:	2b00      	cmp	r3, #0
c0de244a:	d026      	beq.n	c0de249a <strlen+0x5a>
c0de244c:	0003      	movs	r3, r0
c0de244e:	2103      	movs	r1, #3
c0de2450:	e002      	b.n	c0de2458 <strlen+0x18>
c0de2452:	781a      	ldrb	r2, [r3, #0]
c0de2454:	2a00      	cmp	r2, #0
c0de2456:	d01c      	beq.n	c0de2492 <strlen+0x52>
c0de2458:	3301      	adds	r3, #1
c0de245a:	420b      	tst	r3, r1
c0de245c:	d1f9      	bne.n	c0de2452 <strlen+0x12>
c0de245e:	6819      	ldr	r1, [r3, #0]
c0de2460:	4a0f      	ldr	r2, [pc, #60]	; (c0de24a0 <strlen+0x60>)
c0de2462:	4c10      	ldr	r4, [pc, #64]	; (c0de24a4 <strlen+0x64>)
c0de2464:	188a      	adds	r2, r1, r2
c0de2466:	438a      	bics	r2, r1
c0de2468:	4222      	tst	r2, r4
c0de246a:	d10f      	bne.n	c0de248c <strlen+0x4c>
c0de246c:	3304      	adds	r3, #4
c0de246e:	6819      	ldr	r1, [r3, #0]
c0de2470:	4a0b      	ldr	r2, [pc, #44]	; (c0de24a0 <strlen+0x60>)
c0de2472:	188a      	adds	r2, r1, r2
c0de2474:	438a      	bics	r2, r1
c0de2476:	4222      	tst	r2, r4
c0de2478:	d108      	bne.n	c0de248c <strlen+0x4c>
c0de247a:	3304      	adds	r3, #4
c0de247c:	6819      	ldr	r1, [r3, #0]
c0de247e:	4a08      	ldr	r2, [pc, #32]	; (c0de24a0 <strlen+0x60>)
c0de2480:	188a      	adds	r2, r1, r2
c0de2482:	438a      	bics	r2, r1
c0de2484:	4222      	tst	r2, r4
c0de2486:	d0f1      	beq.n	c0de246c <strlen+0x2c>
c0de2488:	e000      	b.n	c0de248c <strlen+0x4c>
c0de248a:	3301      	adds	r3, #1
c0de248c:	781a      	ldrb	r2, [r3, #0]
c0de248e:	2a00      	cmp	r2, #0
c0de2490:	d1fb      	bne.n	c0de248a <strlen+0x4a>
c0de2492:	1a18      	subs	r0, r3, r0
c0de2494:	bd10      	pop	{r4, pc}
c0de2496:	0003      	movs	r3, r0
c0de2498:	e7e1      	b.n	c0de245e <strlen+0x1e>
c0de249a:	2000      	movs	r0, #0
c0de249c:	e7fa      	b.n	c0de2494 <strlen+0x54>
c0de249e:	46c0      	nop			; (mov r8, r8)
c0de24a0:	fefefeff 	.word	0xfefefeff
c0de24a4:	80808080 	.word	0x80808080

c0de24a8 <strnlen>:
c0de24a8:	b510      	push	{r4, lr}
c0de24aa:	2900      	cmp	r1, #0
c0de24ac:	d00b      	beq.n	c0de24c6 <strnlen+0x1e>
c0de24ae:	7803      	ldrb	r3, [r0, #0]
c0de24b0:	2b00      	cmp	r3, #0
c0de24b2:	d00c      	beq.n	c0de24ce <strnlen+0x26>
c0de24b4:	1844      	adds	r4, r0, r1
c0de24b6:	0003      	movs	r3, r0
c0de24b8:	e002      	b.n	c0de24c0 <strnlen+0x18>
c0de24ba:	781a      	ldrb	r2, [r3, #0]
c0de24bc:	2a00      	cmp	r2, #0
c0de24be:	d004      	beq.n	c0de24ca <strnlen+0x22>
c0de24c0:	3301      	adds	r3, #1
c0de24c2:	42a3      	cmp	r3, r4
c0de24c4:	d1f9      	bne.n	c0de24ba <strnlen+0x12>
c0de24c6:	0008      	movs	r0, r1
c0de24c8:	bd10      	pop	{r4, pc}
c0de24ca:	1a19      	subs	r1, r3, r0
c0de24cc:	e7fb      	b.n	c0de24c6 <strnlen+0x1e>
c0de24ce:	2100      	movs	r1, #0
c0de24d0:	e7f9      	b.n	c0de24c6 <strnlen+0x1e>
c0de24d2:	46c0      	nop			; (mov r8, r8)

c0de24d4 <_ecode>:
c0de24d4:	4144      	adcs	r4, r0
c0de24d6:	0049      	lsls	r1, r1, #1
c0de24d8:	6c50      	ldr	r0, [r2, #68]	; 0x44
c0de24da:	6775      	str	r5, [r6, #116]	; 0x74
c0de24dc:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de24de:	7020      	strb	r0, [r4, #0]
c0de24e0:	7261      	strb	r1, [r4, #9]
c0de24e2:	6d61      	ldr	r1, [r4, #84]	; 0x54
c0de24e4:	7465      	strb	r5, [r4, #17]
c0de24e6:	7265      	strb	r5, [r4, #9]
c0de24e8:	2073      	movs	r0, #115	; 0x73
c0de24ea:	7473      	strb	r3, [r6, #17]
c0de24ec:	7572      	strb	r2, [r6, #21]
c0de24ee:	7463      	strb	r3, [r4, #17]
c0de24f0:	7275      	strb	r5, [r6, #9]
c0de24f2:	2065      	movs	r0, #101	; 0x65
c0de24f4:	7369      	strb	r1, [r5, #13]
c0de24f6:	6220      	str	r0, [r4, #32]
c0de24f8:	6769      	str	r1, [r5, #116]	; 0x74
c0de24fa:	6567      	str	r7, [r4, #84]	; 0x54
c0de24fc:	2072      	movs	r0, #114	; 0x72
c0de24fe:	6874      	ldr	r4, [r6, #4]
c0de2500:	6e61      	ldr	r1, [r4, #100]	; 0x64
c0de2502:	6120      	str	r0, [r4, #16]
c0de2504:	6c6c      	ldr	r4, [r5, #68]	; 0x44
c0de2506:	776f      	strb	r7, [r5, #29]
c0de2508:	6465      	str	r5, [r4, #68]	; 0x44
c0de250a:	7320      	strb	r0, [r4, #12]
c0de250c:	7a69      	ldrb	r1, [r5, #9]
c0de250e:	0a65      	lsrs	r5, r4, #9
c0de2510:	5300      	strh	r0, [r0, r4]
c0de2512:	6e65      	ldr	r5, [r4, #100]	; 0x64
c0de2514:	0064      	lsls	r4, r4, #1
c0de2516:	4157      	adcs	r7, r2
c0de2518:	4e52      	ldr	r6, [pc, #328]	; (c0de2664 <_ecode+0x190>)
c0de251a:	4e49      	ldr	r6, [pc, #292]	; (c0de2640 <_ecode+0x16c>)
c0de251c:	0047      	lsls	r7, r0, #1
c0de251e:	656f      	str	r7, [r5, #84]	; 0x54
c0de2520:	6874      	ldr	r4, [r6, #4]
c0de2522:	7020      	strb	r0, [r4, #0]
c0de2524:	756c      	strb	r4, [r5, #21]
c0de2526:	6967      	ldr	r7, [r4, #20]
c0de2528:	206e      	movs	r0, #110	; 0x6e
c0de252a:	7270      	strb	r0, [r6, #9]
c0de252c:	766f      	strb	r7, [r5, #25]
c0de252e:	6469      	str	r1, [r5, #68]	; 0x44
c0de2530:	2065      	movs	r0, #101	; 0x65
c0de2532:	6170      	str	r0, [r6, #20]
c0de2534:	6172      	str	r2, [r6, #20]
c0de2536:	656d      	str	r5, [r5, #84]	; 0x54
c0de2538:	6574      	str	r4, [r6, #84]	; 0x54
c0de253a:	3a72      	subs	r2, #114	; 0x72
c0de253c:	0020      	movs	r0, r4
c0de253e:	0020      	movs	r0, r4
c0de2540:	6150      	str	r0, [r2, #20]
c0de2542:	6172      	str	r2, [r6, #20]
c0de2544:	206d      	movs	r0, #109	; 0x6d
c0de2546:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de2548:	2074      	movs	r0, #116	; 0x74
c0de254a:	7573      	strb	r3, [r6, #21]
c0de254c:	7070      	strb	r0, [r6, #1]
c0de254e:	726f      	strb	r7, [r5, #9]
c0de2550:	6574      	str	r4, [r6, #84]	; 0x54
c0de2552:	0a64      	lsrs	r4, r4, #9
c0de2554:	5400      	strb	r0, [r0, r0]
c0de2556:	4b4f      	ldr	r3, [pc, #316]	; (c0de2694 <HEXDIGITS+0x9>)
c0de2558:	4e45      	ldr	r6, [pc, #276]	; (c0de2670 <_ecode+0x19c>)
c0de255a:	5320      	strh	r0, [r4, r4]
c0de255c:	4e45      	ldr	r6, [pc, #276]	; (c0de2674 <_ecode+0x1a0>)
c0de255e:	3a54      	subs	r2, #84	; 0x54
c0de2560:	0020      	movs	r0, r4
c0de2562:	454f      	cmp	r7, r9
c0de2564:	4854      	ldr	r0, [pc, #336]	; (c0de26b8 <HEXDIGITS+0x2d>)
c0de2566:	7020      	strb	r0, [r4, #0]
c0de2568:	756c      	strb	r4, [r5, #21]
c0de256a:	6967      	ldr	r7, [r4, #20]
c0de256c:	206e      	movs	r0, #110	; 0x6e
c0de256e:	7270      	strb	r0, [r6, #9]
c0de2570:	766f      	strb	r7, [r5, #25]
c0de2572:	6469      	str	r1, [r5, #68]	; 0x44
c0de2574:	2065      	movs	r0, #101	; 0x65
c0de2576:	6f74      	ldr	r4, [r6, #116]	; 0x74
c0de2578:	656b      	str	r3, [r5, #84]	; 0x54
c0de257a:	3a6e      	subs	r2, #110	; 0x6e
c0de257c:	3020      	adds	r0, #32
c0de257e:	2578      	movs	r5, #120	; 0x78
c0de2580:	2c70      	cmp	r4, #112	; 0x70
c0de2582:	3020      	adds	r0, #32
c0de2584:	2578      	movs	r5, #120	; 0x78
c0de2586:	0a70      	lsrs	r0, r6, #9
c0de2588:	4d00      	ldr	r5, [pc, #0]	; (c0de258c <_ecode+0xb8>)
c0de258a:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de258c:	0074      	lsls	r4, r6, #1
c0de258e:	3025      	adds	r0, #37	; 0x25
c0de2590:	7832      	ldrb	r2, [r6, #0]
c0de2592:	5300      	strh	r0, [r0, r4]
c0de2594:	6177      	str	r7, [r6, #20]
c0de2596:	0070      	lsls	r0, r6, #1
c0de2598:	534c      	strh	r4, [r1, r5]
c0de259a:	2054      	movs	r0, #84	; 0x54
c0de259c:	494d      	ldr	r1, [pc, #308]	; (c0de26d4 <HEXDIGITS+0x49>)
c0de259e:	0058      	lsls	r0, r3, #1
c0de25a0:	4f54      	ldr	r7, [pc, #336]	; (c0de26f4 <HEXDIGITS+0x69>)
c0de25a2:	454b      	cmp	r3, r9
c0de25a4:	204e      	movs	r0, #78	; 0x4e
c0de25a6:	4552      	cmp	r2, sl
c0de25a8:	4543      	cmp	r3, r8
c0de25aa:	5649      	ldrsb	r1, [r1, r1]
c0de25ac:	4445      	add	r5, r8
c0de25ae:	203a      	movs	r0, #58	; 0x3a
c0de25b0:	4f00      	ldr	r7, [pc, #0]	; (c0de25b4 <_ecode+0xe0>)
c0de25b2:	5355      	strh	r5, [r2, r5]
c0de25b4:	0044      	lsls	r4, r0, #1
c0de25b6:	4f57      	ldr	r7, [pc, #348]	; (c0de2714 <HEXDIGITS+0x89>)
c0de25b8:	5445      	strb	r5, [r0, r1]
c0de25ba:	0048      	lsls	r0, r1, #1
c0de25bc:	724f      	strb	r7, [r1, #9]
c0de25be:	6769      	str	r1, [r5, #116]	; 0x74
c0de25c0:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de25c2:	4420      	add	r0, r4
c0de25c4:	4665      	mov	r5, ip
c0de25c6:	0069      	lsls	r1, r5, #1
c0de25c8:	6552      	str	r2, [r2, #84]	; 0x54
c0de25ca:	6564      	str	r4, [r4, #84]	; 0x54
c0de25cc:	6d65      	ldr	r5, [r4, #84]	; 0x54
c0de25ce:	5500      	strb	r0, [r0, r4]
c0de25d0:	4453      	add	r3, sl
c0de25d2:	4d20      	ldr	r5, [pc, #128]	; (c0de2654 <_ecode+0x180>)
c0de25d4:	5849      	ldr	r1, [r1, r1]
c0de25d6:	4f00      	ldr	r7, [pc, #0]	; (c0de25d8 <_ecode+0x104>)
c0de25d8:	4646      	mov	r6, r8
c0de25da:	4553      	cmp	r3, sl
c0de25dc:	3a54      	subs	r2, #84	; 0x54
c0de25de:	2520      	movs	r5, #32
c0de25e0:	0a64      	lsrs	r4, r4, #9
c0de25e2:	5500      	strb	r0, [r0, r4]
c0de25e4:	4453      	add	r3, sl
c0de25e6:	0043      	lsls	r3, r0, #1
c0de25e8:	7445      	strb	r5, [r0, #17]
c0de25ea:	6568      	str	r0, [r5, #84]	; 0x54
c0de25ec:	6572      	str	r2, [r6, #84]	; 0x54
c0de25ee:	6d75      	ldr	r5, [r6, #84]	; 0x54
c0de25f0:	4300      	orrs	r0, r0
c0de25f2:	756f      	strb	r7, [r5, #21]
c0de25f4:	746e      	strb	r6, [r5, #17]
c0de25f6:	7265      	strb	r5, [r4, #9]
c0de25f8:	203a      	movs	r0, #58	; 0x3a
c0de25fa:	6425      	str	r5, [r4, #64]	; 0x40
c0de25fc:	000a      	movs	r2, r1
c0de25fe:	4542      	cmp	r2, r8
c0de2600:	454e      	cmp	r6, r9
c0de2602:	4946      	ldr	r1, [pc, #280]	; (c0de271c <HEXDIGITS+0x91>)
c0de2604:	4943      	ldr	r1, [pc, #268]	; (c0de2714 <HEXDIGITS+0x89>)
c0de2606:	5241      	strh	r1, [r0, r1]
c0de2608:	3a59      	subs	r2, #89	; 0x59
c0de260a:	0020      	movs	r0, r4
c0de260c:	0030      	movs	r0, r6
c0de260e:	6553      	str	r3, [r2, #84]	; 0x54
c0de2610:	7474      	strb	r4, [r6, #17]
c0de2612:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de2614:	2067      	movs	r0, #103	; 0x67
c0de2616:	6461      	str	r1, [r4, #68]	; 0x44
c0de2618:	7264      	strb	r4, [r4, #9]
c0de261a:	7365      	strb	r5, [r4, #13]
c0de261c:	2073      	movs	r0, #115	; 0x73
c0de261e:	6572      	str	r2, [r6, #84]	; 0x54
c0de2620:	6563      	str	r3, [r4, #84]	; 0x54
c0de2622:	7669      	strb	r1, [r5, #25]
c0de2624:	6465      	str	r5, [r4, #68]	; 0x44
c0de2626:	7420      	strb	r0, [r4, #16]
c0de2628:	3a6f      	subs	r2, #111	; 0x6f
c0de262a:	0020      	movs	r0, r4
c0de262c:	6150      	str	r0, [r2, #20]
c0de262e:	6172      	str	r2, [r6, #20]
c0de2630:	206d      	movs	r0, #109	; 0x6d
c0de2632:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de2634:	2074      	movs	r0, #116	; 0x74
c0de2636:	7573      	strb	r3, [r6, #21]
c0de2638:	7070      	strb	r0, [r6, #1]
c0de263a:	726f      	strb	r7, [r5, #9]
c0de263c:	6574      	str	r4, [r6, #84]	; 0x54
c0de263e:	3a64      	subs	r2, #100	; 0x64
c0de2640:	2520      	movs	r5, #32
c0de2642:	0a64      	lsrs	r4, r4, #9
c0de2644:	5200      	strh	r0, [r0, r0]
c0de2646:	6365      	str	r5, [r4, #52]	; 0x34
c0de2648:	6965      	ldr	r5, [r4, #20]
c0de264a:	6576      	str	r6, [r6, #84]	; 0x54
c0de264c:	4d20      	ldr	r5, [pc, #128]	; (c0de26d0 <HEXDIGITS+0x45>)
c0de264e:	6e69      	ldr	r1, [r5, #100]	; 0x64
c0de2650:	4500      	cmp	r0, r0
c0de2652:	6378      	str	r0, [r7, #52]	; 0x34
c0de2654:	7065      	strb	r5, [r4, #1]
c0de2656:	6974      	ldr	r4, [r6, #20]
c0de2658:	6e6f      	ldr	r7, [r5, #100]	; 0x64
c0de265a:	3020      	adds	r0, #32
c0de265c:	2578      	movs	r5, #120	; 0x78
c0de265e:	2078      	movs	r0, #120	; 0x78
c0de2660:	6163      	str	r3, [r4, #20]
c0de2662:	6775      	str	r5, [r6, #116]	; 0x74
c0de2664:	7468      	strb	r0, [r5, #17]
c0de2666:	000a      	movs	r2, r1
c0de2668:	4f54      	ldr	r7, [pc, #336]	; (c0de27bc <HEXDIGITS+0x131>)
c0de266a:	454b      	cmp	r3, r9
c0de266c:	5f4e      	ldrsh	r6, [r1, r5]
c0de266e:	4553      	cmp	r3, sl
c0de2670:	544e      	strb	r6, [r1, r1]
c0de2672:	203a      	movs	r0, #58	; 0x3a
c0de2674:	7300      	strb	r0, [r0, #12]
c0de2676:	7266      	strb	r6, [r4, #9]
c0de2678:	4578      	cmp	r0, pc
c0de267a:	4854      	ldr	r0, [pc, #336]	; (c0de27cc <HEXDIGITS+0x141>)
c0de267c:	5500      	strb	r0, [r0, r4]
c0de267e:	6b6e      	ldr	r6, [r5, #52]	; 0x34
c0de2680:	6f6e      	ldr	r6, [r5, #116]	; 0x74
c0de2682:	6e77      	ldr	r7, [r6, #100]	; 0x64
c0de2684:	7420      	strb	r0, [r4, #16]
c0de2686:	6b6f      	ldr	r7, [r5, #52]	; 0x34
c0de2688:	6e65      	ldr	r5, [r4, #100]	; 0x64
	...

c0de268b <HEXDIGITS>:
c0de268b:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef
c0de269b:	6500 6378 7065 6974 6e6f 255b 5d64 203a     .exception[%d]: 
c0de26ab:	524c 303d 2578 3830 0a58 4500 5252 524f     LR=0x%08X..ERROR
c0de26bb:	3000 0078 6e55 6168 646e 656c 2064 656d     .0x.Unhandled me
c0de26cb:	7373 6761 2065 6425 000a 4f57 5355 0044     ssage %d..WOUSD.
c0de26db:	6553 7474 6e69 2067 6461 7264 7365 2073     Setting address 
c0de26eb:	6573 746e 7420 3a6f 0020 6542 656e 6966     sent to: .Benefi
c0de26fb:	6963 7261 0079 000a 7257 7061 5200 6365     ciary...Wrap.Rec
c0de270b:	6965 6576 2064 6e61 6920 766e 6c61 6469     eived an invalid
c0de271b:	7320 7263 6565 496e 646e 7865 000a 4d41      screenIndex..AM
c0de272b:	554f 544e 5320 4e45 3a54 2520 0a73 0000     OUNT SENT: %s...
c0de273b:	6553 656c 7463 726f 4920 646e 7865 3a20     Selector Index :
c0de274b:	6425 6e20 746f 7320 7075 6f70 7472 6465     %d not supported
c0de275b:	000a 5355 5444 5500 686e 6e61 6c64 6465     ..USDT.Unhandled
c0de276b:	7320 6c65 6365 6f74 2072 6e49 6564 3a78      selector Index:
c0de277b:	2520 0a64 5500 494e 5354 5500 776e 6172      %d..UNITS.Unwra
c0de278b:	0070 6544 6f70 6973 0074 694d 7373 6e69     p.Deposit.Missin
c0de279b:	2067 6573 656c 7463 726f 6e49 6564 3a78     g selectorIndex:
c0de27ab:	2520 0a64 5300 6c65 6365 6f74 2072 6e49      %d..Selector In
c0de27bb:	6564 2078 6425 6e20 746f 7320 7075 6f70     dex %d not suppo
c0de27cb:	7472 6465 000a 454f 4854 4100 4f4d 4e55     rted..OETH.AMOUN
c0de27db:	2054 4552 4543 5649 4445 203a 7325 000a     T RECEIVED: %s..
c0de27eb:	                                             .

c0de27ec <ORIGIN_DEFI_SELECTORS>:
c0de27ec:	0db0 d0e3 e97d d443 29f6 156e 2373 7cbc     ....}.C..)n.s#.|
c0de27fc:	2124 3df0 7ed6 a641 a424 353c 8d59 c04b     $!.=.~A.$.<5Y.K.
c0de280c:	f389 414b 0b96 35aa 9053 cb93 c746 5981     ..KA...5S...F..Y
c0de281c:	5a0f 8a09 1ffd bfc1 8169 c6b6 3f65 6e55     .Z......i...e?Un
c0de282c:	7652 ba08                                   Rv..

c0de2830 <OETH_ADDRESS>:
c0de2830:	6c85 fb4e c176 aed1 e202 eb0c a203 a0a6     .lN.v...........
c0de2840:	0b8b c38d                                   ....

c0de2844 <OUSD_ADDRESS>:
c0de2844:	8e2a 671e c26e d838 92a9 7b30 5b49 b345     *..gn.8...0{I[E.
c0de2854:	aafe 865e                                   ..^.

c0de2858 <DAI_ADDRESS>:
c0de2858:	176b 7454 90e8 c494 a94d 958b ed4e c4ea     k.Tt....M...N...
c0de2868:	2795 0f1d                                   .'..

c0de286c <USDC_ADDRESS>:
c0de286c:	b8a0 9169 21c6 368b d1c1 4a9d 9e2e ceb0     ..i..!.6...J....
c0de287c:	0636 48eb                                   6..H

c0de2880 <USDT_ADDRESS>:
c0de2880:	c1da 957f 2e8d 23e5 20a2 0662 4599 c197     .......#. b..E..
c0de2890:	833d c71e                                   =...

c0de2894 <OETH_VAULT_ADDRESS>:
c0de2894:	2539 3340 5a94 e4a2 9c80 97c2 707e be87     9%@3.Z......~p..
c0de28a4:	8be4 abd7                                   ....

c0de28a8 <WOETH_ADDRESS>:
c0de28a8:	eedc 6570 6142 21af 4cc4 3c09 0e30 bbd3     ..peBa.!.L.<0...
c0de28b8:	b797 9281                                   ....

c0de28bc <CURVE_OETH_POOL_ADDRESS>:
c0de28bc:	b194 7674 3ba9 6232 7bd8 329a 6569 e9d1     ..tv.;2b.{.2ie..
c0de28cc:	9c1f e713                                   ....

c0de28d0 <CURVE_OUSD_POOL_ADDRESS>:
c0de28d0:	6587 7b0d c3bf f1a9 8705 77d7 0682 1767     .e.{.......w..g.
c0de28e0:	d919 0d91                                   ....

c0de28e4 <g_pcHex>:
c0de28e4:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de28f4 <g_pcHex_cap>:
c0de28f4:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de2904 <NULL_ETH_ADDRESS>:
	...

c0de2918 <_etext>:
c0de2918:	d4d4      	bmi.n	c0de28c4 <CURVE_OETH_POOL_ADDRESS+0x8>
c0de291a:	d4d4      	bmi.n	c0de28c6 <CURVE_OETH_POOL_ADDRESS+0xa>
c0de291c:	d4d4      	bmi.n	c0de28c8 <CURVE_OETH_POOL_ADDRESS+0xc>
c0de291e:	d4d4      	bmi.n	c0de28ca <CURVE_OETH_POOL_ADDRESS+0xe>
c0de2920:	d4d4      	bmi.n	c0de28cc <CURVE_OETH_POOL_ADDRESS+0x10>
c0de2922:	d4d4      	bmi.n	c0de28ce <CURVE_OETH_POOL_ADDRESS+0x12>
c0de2924:	d4d4      	bmi.n	c0de28d0 <CURVE_OUSD_POOL_ADDRESS>
c0de2926:	d4d4      	bmi.n	c0de28d2 <CURVE_OUSD_POOL_ADDRESS+0x2>
c0de2928:	d4d4      	bmi.n	c0de28d4 <CURVE_OUSD_POOL_ADDRESS+0x4>
c0de292a:	d4d4      	bmi.n	c0de28d6 <CURVE_OUSD_POOL_ADDRESS+0x6>
c0de292c:	d4d4      	bmi.n	c0de28d8 <CURVE_OUSD_POOL_ADDRESS+0x8>
c0de292e:	d4d4      	bmi.n	c0de28da <CURVE_OUSD_POOL_ADDRESS+0xa>
c0de2930:	d4d4      	bmi.n	c0de28dc <CURVE_OUSD_POOL_ADDRESS+0xc>
c0de2932:	d4d4      	bmi.n	c0de28de <CURVE_OUSD_POOL_ADDRESS+0xe>
c0de2934:	d4d4      	bmi.n	c0de28e0 <CURVE_OUSD_POOL_ADDRESS+0x10>
c0de2936:	d4d4      	bmi.n	c0de28e2 <CURVE_OUSD_POOL_ADDRESS+0x12>
c0de2938:	d4d4      	bmi.n	c0de28e4 <g_pcHex>
c0de293a:	d4d4      	bmi.n	c0de28e6 <g_pcHex+0x2>
c0de293c:	d4d4      	bmi.n	c0de28e8 <g_pcHex+0x4>
c0de293e:	d4d4      	bmi.n	c0de28ea <g_pcHex+0x6>
c0de2940:	d4d4      	bmi.n	c0de28ec <g_pcHex+0x8>
c0de2942:	d4d4      	bmi.n	c0de28ee <g_pcHex+0xa>
c0de2944:	d4d4      	bmi.n	c0de28f0 <g_pcHex+0xc>
c0de2946:	d4d4      	bmi.n	c0de28f2 <g_pcHex+0xe>
c0de2948:	d4d4      	bmi.n	c0de28f4 <g_pcHex_cap>
c0de294a:	d4d4      	bmi.n	c0de28f6 <g_pcHex_cap+0x2>
c0de294c:	d4d4      	bmi.n	c0de28f8 <g_pcHex_cap+0x4>
c0de294e:	d4d4      	bmi.n	c0de28fa <g_pcHex_cap+0x6>
c0de2950:	d4d4      	bmi.n	c0de28fc <g_pcHex_cap+0x8>
c0de2952:	d4d4      	bmi.n	c0de28fe <g_pcHex_cap+0xa>
c0de2954:	d4d4      	bmi.n	c0de2900 <g_pcHex_cap+0xc>
c0de2956:	d4d4      	bmi.n	c0de2902 <g_pcHex_cap+0xe>
c0de2958:	d4d4      	bmi.n	c0de2904 <NULL_ETH_ADDRESS>
c0de295a:	d4d4      	bmi.n	c0de2906 <NULL_ETH_ADDRESS+0x2>
c0de295c:	d4d4      	bmi.n	c0de2908 <NULL_ETH_ADDRESS+0x4>
c0de295e:	d4d4      	bmi.n	c0de290a <NULL_ETH_ADDRESS+0x6>
c0de2960:	d4d4      	bmi.n	c0de290c <NULL_ETH_ADDRESS+0x8>
c0de2962:	d4d4      	bmi.n	c0de290e <NULL_ETH_ADDRESS+0xa>
c0de2964:	d4d4      	bmi.n	c0de2910 <NULL_ETH_ADDRESS+0xc>
c0de2966:	d4d4      	bmi.n	c0de2912 <NULL_ETH_ADDRESS+0xe>
c0de2968:	d4d4      	bmi.n	c0de2914 <NULL_ETH_ADDRESS+0x10>
c0de296a:	d4d4      	bmi.n	c0de2916 <NULL_ETH_ADDRESS+0x12>
c0de296c:	d4d4      	bmi.n	c0de2918 <_etext>
c0de296e:	d4d4      	bmi.n	c0de291a <_etext+0x2>
c0de2970:	d4d4      	bmi.n	c0de291c <_etext+0x4>
c0de2972:	d4d4      	bmi.n	c0de291e <_etext+0x6>
c0de2974:	d4d4      	bmi.n	c0de2920 <_etext+0x8>
c0de2976:	d4d4      	bmi.n	c0de2922 <_etext+0xa>
c0de2978:	d4d4      	bmi.n	c0de2924 <_etext+0xc>
c0de297a:	d4d4      	bmi.n	c0de2926 <_etext+0xe>
c0de297c:	d4d4      	bmi.n	c0de2928 <_etext+0x10>
c0de297e:	d4d4      	bmi.n	c0de292a <_etext+0x12>
c0de2980:	d4d4      	bmi.n	c0de292c <_etext+0x14>
c0de2982:	d4d4      	bmi.n	c0de292e <_etext+0x16>
c0de2984:	d4d4      	bmi.n	c0de2930 <_etext+0x18>
c0de2986:	d4d4      	bmi.n	c0de2932 <_etext+0x1a>
c0de2988:	d4d4      	bmi.n	c0de2934 <_etext+0x1c>
c0de298a:	d4d4      	bmi.n	c0de2936 <_etext+0x1e>
c0de298c:	d4d4      	bmi.n	c0de2938 <_etext+0x20>
c0de298e:	d4d4      	bmi.n	c0de293a <_etext+0x22>
c0de2990:	d4d4      	bmi.n	c0de293c <_etext+0x24>
c0de2992:	d4d4      	bmi.n	c0de293e <_etext+0x26>
c0de2994:	d4d4      	bmi.n	c0de2940 <_etext+0x28>
c0de2996:	d4d4      	bmi.n	c0de2942 <_etext+0x2a>
c0de2998:	d4d4      	bmi.n	c0de2944 <_etext+0x2c>
c0de299a:	d4d4      	bmi.n	c0de2946 <_etext+0x2e>
c0de299c:	d4d4      	bmi.n	c0de2948 <_etext+0x30>
c0de299e:	d4d4      	bmi.n	c0de294a <_etext+0x32>
c0de29a0:	d4d4      	bmi.n	c0de294c <_etext+0x34>
c0de29a2:	d4d4      	bmi.n	c0de294e <_etext+0x36>
c0de29a4:	d4d4      	bmi.n	c0de2950 <_etext+0x38>
c0de29a6:	d4d4      	bmi.n	c0de2952 <_etext+0x3a>
c0de29a8:	d4d4      	bmi.n	c0de2954 <_etext+0x3c>
c0de29aa:	d4d4      	bmi.n	c0de2956 <_etext+0x3e>
c0de29ac:	d4d4      	bmi.n	c0de2958 <_etext+0x40>
c0de29ae:	d4d4      	bmi.n	c0de295a <_etext+0x42>
c0de29b0:	d4d4      	bmi.n	c0de295c <_etext+0x44>
c0de29b2:	d4d4      	bmi.n	c0de295e <_etext+0x46>
c0de29b4:	d4d4      	bmi.n	c0de2960 <_etext+0x48>
c0de29b6:	d4d4      	bmi.n	c0de2962 <_etext+0x4a>
c0de29b8:	d4d4      	bmi.n	c0de2964 <_etext+0x4c>
c0de29ba:	d4d4      	bmi.n	c0de2966 <_etext+0x4e>
c0de29bc:	d4d4      	bmi.n	c0de2968 <_etext+0x50>
c0de29be:	d4d4      	bmi.n	c0de296a <_etext+0x52>
c0de29c0:	d4d4      	bmi.n	c0de296c <_etext+0x54>
c0de29c2:	d4d4      	bmi.n	c0de296e <_etext+0x56>
c0de29c4:	d4d4      	bmi.n	c0de2970 <_etext+0x58>
c0de29c6:	d4d4      	bmi.n	c0de2972 <_etext+0x5a>
c0de29c8:	d4d4      	bmi.n	c0de2974 <_etext+0x5c>
c0de29ca:	d4d4      	bmi.n	c0de2976 <_etext+0x5e>
c0de29cc:	d4d4      	bmi.n	c0de2978 <_etext+0x60>
c0de29ce:	d4d4      	bmi.n	c0de297a <_etext+0x62>
c0de29d0:	d4d4      	bmi.n	c0de297c <_etext+0x64>
c0de29d2:	d4d4      	bmi.n	c0de297e <_etext+0x66>
c0de29d4:	d4d4      	bmi.n	c0de2980 <_etext+0x68>
c0de29d6:	d4d4      	bmi.n	c0de2982 <_etext+0x6a>
c0de29d8:	d4d4      	bmi.n	c0de2984 <_etext+0x6c>
c0de29da:	d4d4      	bmi.n	c0de2986 <_etext+0x6e>
c0de29dc:	d4d4      	bmi.n	c0de2988 <_etext+0x70>
c0de29de:	d4d4      	bmi.n	c0de298a <_etext+0x72>
c0de29e0:	d4d4      	bmi.n	c0de298c <_etext+0x74>
c0de29e2:	d4d4      	bmi.n	c0de298e <_etext+0x76>
c0de29e4:	d4d4      	bmi.n	c0de2990 <_etext+0x78>
c0de29e6:	d4d4      	bmi.n	c0de2992 <_etext+0x7a>
c0de29e8:	d4d4      	bmi.n	c0de2994 <_etext+0x7c>
c0de29ea:	d4d4      	bmi.n	c0de2996 <_etext+0x7e>
c0de29ec:	d4d4      	bmi.n	c0de2998 <_etext+0x80>
c0de29ee:	d4d4      	bmi.n	c0de299a <_etext+0x82>
c0de29f0:	d4d4      	bmi.n	c0de299c <_etext+0x84>
c0de29f2:	d4d4      	bmi.n	c0de299e <_etext+0x86>
c0de29f4:	d4d4      	bmi.n	c0de29a0 <_etext+0x88>
c0de29f6:	d4d4      	bmi.n	c0de29a2 <_etext+0x8a>
c0de29f8:	d4d4      	bmi.n	c0de29a4 <_etext+0x8c>
c0de29fa:	d4d4      	bmi.n	c0de29a6 <_etext+0x8e>
c0de29fc:	d4d4      	bmi.n	c0de29a8 <_etext+0x90>
c0de29fe:	d4d4      	bmi.n	c0de29aa <_etext+0x92>
