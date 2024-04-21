.global verilate
verilate:
li x12 , -12
li x15, 5
j hoop
nop
nop

loop:
add x12, x15, x12
sw x15, 0x00(x0)
nop
nop
lw x16, 0x00(x0)
nop
nop
j loop
nop
nop

hoop:
j loop
nop
nop

