j config 
j handler

config: 
    li x1 , 0xFFFFFFFF
    csrrw x0 , mstatus, x1
    csrrw x0 , mie , x1
    li x2 , 0x10
    csrrw x0 , mtvec, x2
    j main 

main:
    li x4 , 0x10
    li x5 , 0x30
    add x6, x4, x5
    sw x6, 0x00(x0)
    sub x7, x1, x5


handler:
    csrrw x0, mie, x0

    li  x15, 0x123
    li x16 , 0x333
    xor x17, x16, x15

    csrrw x0, mie, x1
    mret
	nop
	nop
	nop



