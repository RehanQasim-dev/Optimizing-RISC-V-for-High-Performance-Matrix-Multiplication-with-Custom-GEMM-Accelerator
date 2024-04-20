main: 
    addi x2, x0, 13
    addi x3, x0, 14
haszard:
    add x4, x3, x2
    add x5,x4, x3
    addi x10,x0,0
    beq x5, x5, foraward
    add x10,x10,x10
foraward:
    addi x6, x0, 13
    lw x7, 0x00(x6)
    add x8, x7, x7
