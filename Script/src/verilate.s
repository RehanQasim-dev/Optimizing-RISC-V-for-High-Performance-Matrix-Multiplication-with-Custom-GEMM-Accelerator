.global verilate
verilate:
li x12 , 12
li x15, 5
remu x13, x15, x12
nop
li x16 , -12
li x18, 5
rem x17, x16, x18
nop
li x4 , -12
li x5, 5
div x6, x4, x5
nop
li x4 , -12
li x5, 5
divu x6, x4, x5
nop
j verilate
hoop:
add x13, x15, x12
nop
nop
j hoop

