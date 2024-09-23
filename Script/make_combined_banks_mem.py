#!/usr/bin/env python3
import sys

binfile = sys.argv[1]
# binfile = "C:/Users/Prince/Desktop/rv32_for_fyp/Script/build/DCACHE.bin"

with open(binfile, "rb") as f:
    bindata = f.read()

# Pad the data with zeros to make it evenly divisible by 16
remainder = len(bindata) % 16
if remainder != 0:
    bindata += b'\x00' * (16 - remainder)

# Calculate the number of words (assuming each word is 16 bytes)
nwords = len(bindata) // 16

# Initialize lists to store data for each bank
bank_data = [b"" for _ in range(16)]

# Iterate over the words in the binary file
for i in range(nwords):
    w = bindata[16 * i: 16 * (i + 1)]
    for j in range(16):
        bank_data[j] += bytes([w[j]])

def address_to_binary(addr):
    binary = bin(addr)[2:]
    return binary.zfill(4)

for i, bank in enumerate(bank_data):
    binary_address = address_to_binary(i)
    print("@" + binary_address, end=" ")
    for byte in bank:
        print(byte, end="")
    print()
