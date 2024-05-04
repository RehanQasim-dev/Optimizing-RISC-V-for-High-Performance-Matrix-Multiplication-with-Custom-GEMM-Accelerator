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
bank_data = [""] * 16

# Iterate over the words in the binary file
for i in range(nwords):
    # Extract 16 bytes (one word)
    w = bindata[16 * i : 16 * (i + 1)]
    # Iterate over each byte in the word
    for j in range(16):
        # Append the byte as a hexadecimal string to the corresponding bank's data
        bank_data[j] = "%0b16" % w[j] + bank_data[j]

# Iterate over the bank data and print the result
for i, bank in enumerate(bank_data):
    print("@%01x" % i, bank)
