.global verilate
verilate:
li x12 , 12
li x15, 5
mul x13, x15, x12
sw x13, 0x00(x0)
lw x12, 0x00(x0)
j hoop
hoop:
j hoop

