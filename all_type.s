start:
    addi x2, x0, 10
    addi x3 , x0, 15

main:
    add x4, x2, x3
    sub x5, x2,x3
    sll x6, x2,x3
    slt x7,x2,x3
    sltu x8,x2,x3
    xor x9,x2,x3
    srl x10,x2,x3
    sra x11,x2,x3
    or x12,x2,x3
    and x13,x2,x3
    

    addi x12, x4, 14
    andi x13, x6, 33
    xori x14 ,x6 , 44
    ori x15, x7, 12
    slli x19, x10, 4
    slti x20, x7, 5
    sltiu x21, x12, 23
    srai x22, x12, 23
    srli x23, x14, 21


    sw x0, 0x00(x4)
    sh x0, 0x04(x2)
    sb x0,  0x06(x5)

    lw x29, 0x00(x4)
    lh x0, 0x04(x2)
    lb x0,  0x06(x5)
    lhu x0, 0x04(x2)
    lbu x0,  0x06(x5)


    lui x8, 0x12345
    auipc x18, 0x00004

branch:
    beq x0, x0,bnew
bnew: 
    bne x0, x4,blessthan
blessthan:
    blt x6, x4, branchgreat
branchgreat: 
    bge x4,x0, branchlessun
branchlessun:
    bltu x5,x7, branchgreatun
branchgreatun:
    bgeu x17,x31, jit

jit:
    jal x2, (main)

jumps:
    jalr x31, 0x00(x0)

    