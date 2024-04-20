li	a0,0
li	a1,0
jal	ra,20014 <main>
addi	sp,sp,-16
sw	s0,12(sp)
addi	s0,sp,16
sw	zero,544(zero) # 220 <n>
j	20218 <main+0x204>
lw	a5,544(zero) # 220 <n>
addi	a4,a5,16
li	a5,16
bltu	a5,a4,20040 <main+0x2c>
li	a5,16
j	20044 <main+0x30>
li	a5,0
sw	a5,512(zero) # 200 <nsize>
sw	zero,552(zero) # 228 <m>
j	20200 <main+0x1ec>
lw	a5,552(zero) # 228 <m>
addi	a4,a5,16
li	a5,16
bltu	a5,a4,20068 <main+0x54>
li	a5,16
j	2006c <main+0x58>
li	a5,0
sw	a5,520(zero) # 208 <msize>
sw	zero,548(zero) # 224 <k>
j	201e8 <main+0x1d4>
lw	a5,548(zero) # 224 <k>
addi	a5,a5,16
sltiu	a5,a5,16
xori	a5,a5,1
zext.b	a4,a5
sb	a4,540(zero) # 21c <last>
lw	a5,548(zero) # 224 <k>
seqz	a5,a5
zext.b	a4,a5
sb	a4,541(zero) # 21d <first>
lw	a5,548(zero) # 224 <k>
addi	a4,a5,16
li	a5,16
bltu	a5,a4,200b8 <main+0xa4>
li	a5,16
j	200bc <main+0xa8>
li	a5,0
sw	a5,516(zero) # 204 <ksize>
lw	a5,552(zero) # 228 <m>
slli	a4,a5,0x4
lw	a5,548(zero) # 224 <k>
add	a5,a4,a5
slli	a4,a5,0x4
li	a5,0
add	a5,a4,a5
mv	a4,a5
sw	a4,528(zero) # 210 <Tile_A_Address>
lw	a4,516(zero) # 204 <ksize>
lw	a5,548(zero) # 224 <k>
add	a5,a4,a5
addi	a5,a5,-1
slli	a4,a5,0x4
lw	a5,544(zero) # 220 <n>
add	a5,a4,a5
slli	a4,a5,0x4
li	a5,256
add	a5,a4,a5
mv	a4,a5
sw	a4,532(zero) # 214 <Tile_B_Address>
lw	a5,552(zero) # 228 <m>
slli	a4,a5,0x4
lw	a5,544(zero) # 220 <n>
add	a5,a4,a5
slli	a4,a5,0x6
li	a5,556
add	a5,a4,a5
mv	a4,a5
sw	a4,536(zero) # 218 <Tile_C_Address>
lui	a5,0x90000
addi	a5,a5,16 # 90000010 <_sidata+0x8ffdfdc0>
li	a4,16
sw	a4,0(a5)
lui	a5,0x90000
addi	a5,a5,20 # 90000014 <_sidata+0x8ffdfdc4>
li	a4,16
sw	a4,0(a5)
lui	a5,0x90000
lw	a4,528(zero) # 210 <Tile_A_Address>
sw	a4,0(a5) # 90000000 <_sidata+0x8ffdfdb0>
lui	a5,0x90000
addi	a5,a5,4 # 90000004 <_sidata+0x8ffdfdb4>
lw	a4,532(zero) # 214 <Tile_B_Address>
sw	a4,0(a5)
lui	a5,0x90000
addi	a5,a5,8 # 90000008 <_sidata+0x8ffdfdb8>
lw	a4,536(zero) # 218 <Tile_C_Address>
sw	a4,0(a5)
lbu	a5,541(zero) # 21d <first>
slli	a5,a5,0x1
lbu	a4,540(zero) # 21c <last>
or	a4,a5,a4
lui	a5,0x90000
addi	a5,a5,12 # 9000000c <_sidata+0x8ffdfdbc>
sw	a4,0(a5)
lw	a5,516(zero) # 204 <ksize>
slli	a4,a5,0x5
lw	a5,520(zero) # 208 <msize>
or	a3,a4,a5
lw	a5,512(zero) # 200 <nsize>
slli	a4,a5,0xa
lui	a5,0x90000
addi	a5,a5,24 # 90000018 <_sidata+0x8ffdfdc8>
or	a4,a3,a4
sw	a4,0(a5)
nop
lui	a5,0x90000
lw	a4,0(a5) # 90000000 <_sidata+0x8ffdfdb0>
li	a5,1
beq	a4,a5,201cc <main+0x1b8>
lw	a5,548(zero) # 224 <k>
addi	a4,a5,16
sw	a4,548(zero) # 224 <k>
lw	a4,548(zero) # 224 <k>
li	a5,15
bgeu	a5,a4,20078 <main+0x64>
lw	a5,552(zero) # 228 <m>
addi	a4,a5,16
sw	a4,552(zero) # 228 <m>
lw	a4,552(zero) # 228 <m>
li	a5,15
bgeu	a5,a4,20050 <main+0x3c>
lw	a5,544(zero) # 220 <n>
addi	a4,a5,16
sw	a4,544(zero) # 220 <n>
lw	a4,544(zero) # 220 <n>
li	a5,15
bgeu	a5,a4,20028 <main+0x14>
nop
lui	a5,0x90000
addi	a5,a5,24 # 90000018 <_sidata+0x8ffdfdc8>
lw	a4,0(a5)
li	a5,1
bne	a4,a5,20228 <main+0x214>
nop
nop
lw	s0,12(sp)
addi	sp,sp,16
ret