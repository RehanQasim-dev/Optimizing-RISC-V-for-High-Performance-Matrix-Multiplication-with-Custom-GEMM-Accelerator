#!/usr/bin/env python3
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

#from sys import argv
import sys 
# binfile = sys.argv[1]

binfile = "C:/Users/Prince/Desktop/rv32_for_fyp/Script/build/DCACHE.bin"

with open(binfile, "rb") as f:
    bindata = f.read()
print ("the binary data is ", bindata)
#assert len(bindata) < 4*nwords
#assert len(bindata) % 4 == 0
nwords = len(bindata) // 16

print(nwords)
addr = 0
bank =0
bank_0_data =""
bank_1_data =""
bank_2_data =""
bank_3_data =""
bank_4_data =""
bank_5_data =""
bank_6_data =""
bank_7_data =""
bank_8_data =""
bank_9_data =""
bank_10_data =""
bank_11_data =""
bank_12_data =""
bank_13_data =""
bank_14_data =""
bank_15_data =""
for i in range(nwords):
    w = bindata[16*i : 16*i+16]
    bank_0_data=   str("%02x" % w[0]) + bank_0_data 
    bank_1_data=   str("%02x" % w[1]) + bank_1_data 
    bank_2_data=   str("%02x" % w[2]) + bank_2_data 
    bank_3_data=   str("%02x" % w[3]) + bank_3_data 
    bank_4_data=   str("%02x" % w[4]) + bank_4_data 
    bank_5_data=   str("%02x" % w[5]) + bank_5_data 
    bank_6_data=   str("%02x" % w[6]) + bank_6_data 
    bank_7_data=   str("%02x" % w[7]) + bank_7_data 
    bank_8_data=   str("%02x" % w[8]) + bank_8_data 
    bank_9_data=   str("%02x" % w[9]) + bank_9_data 
    bank_10_data=  str("%02x" % w[10]) + bank_10_data 
    bank_11_data=  str("%02x" % w[11]) + bank_11_data 
    bank_12_data=  str("%02x" % w[12]) + bank_12_data 
    bank_13_data=  str("%02x" % w[13]) + bank_13_data 
    bank_14_data=  str("%02x" % w[14]) + bank_14_data 
    bank_15_data=  str("%02x" % w[15]) + bank_15_data 

for i in range(1):
    print ("@%01x" % (addr + 0) ,   (bank_0_data) )
    print ("@%01x" % (addr + 1) ,   (bank_1_data) )
    print ("@%01x" % (addr + 2) ,   (bank_2_data) )
    print ("@%01x" % (addr + 3) ,   (bank_3_data) )
    print ("@%01x" % (addr + 4) ,   (bank_4_data) )
    print ("@%01x" % (addr + 5) ,   (bank_5_data) )
    print ("@%01x" % (addr + 6) ,   (bank_6_data) )
    print ("@%01x" % (addr + 7) ,   (bank_7_data) )
    print ("@%01x" % (addr + 8) ,   (bank_8_data) )
    print ("@%01x" % (addr + 9) ,   (bank_9_data) )
    print ("@%01x" % (addr + 10),  (bank_10_data) )
    print ("@%01x" % (addr + 11),  (bank_11_data) )
    print ("@%01x" % (addr + 12),  (bank_12_data) )
    print ("@%01x" % (addr + 13),  (bank_13_data) )
    print ("@%01x" % (addr + 14),  (bank_14_data) )
    print ("@%01x" % (addr + 15),  (bank_15_data) )

