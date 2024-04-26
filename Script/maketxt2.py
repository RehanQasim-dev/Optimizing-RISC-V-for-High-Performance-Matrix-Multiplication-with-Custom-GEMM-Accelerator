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
binfile = sys.argv[1]

#binfile = "build/main.bin"

with open(binfile, "rb") as f:
    bindata = f.read()

#assert len(bindata) < 4*nwords
#assert len(bindata) % 4 == 0
nwords = len(bindata) // 4
addr = 8
for i in range(nwords):
    w = bindata[4*i : 4*i+4]
    print("@%08x" % (addr) )
    print("%08x" % (w[0]))
    print("@%08x" % (addr+4) )
    print("%08x" % (w[1]))
    print("@%08x" % (addr+8) )
    print("%08x" % (w[2]))
    print("@%08x" % (addr+12) )
    print("%08x" % (w[3]))
    addr = addr + 32
    

