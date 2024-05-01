.global verilate
verilate:
li x12 , 12
li x15, 5
add x13, x15, x12
j verilate
hoop:
add x13, x15, x12
nop
nop
j hoop

