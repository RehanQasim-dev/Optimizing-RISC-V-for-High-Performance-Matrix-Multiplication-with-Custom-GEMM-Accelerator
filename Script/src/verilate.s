.global verilate
verilate:
li x12 , 2345
li x15, 45
j loop
nop
nop

loop:
addi x15, x15, 1010
sw x15, 0x00(x0)
nop
nop
j loop
nop
nop

hoop:
j hoop
nop
nop

