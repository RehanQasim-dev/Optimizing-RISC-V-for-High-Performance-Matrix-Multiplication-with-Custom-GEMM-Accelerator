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
    # Extract 16 bytes (one word)
    w = bindata[16 * i: 16 * (i + 1)]
    # Iterate over each byte in the word
    for j in range(16):
        # Append the byte to the corresponding bank's data
        bank_data[j] += bytes([w[j]])

# Convert address to binary and pad to 4 bits
def address_to_binary(addr):
    binary = bin(addr)[2:]
    return binary.zfill(4)

# Iterate over the bank data and print the result
for i, bank in enumerate(bank_data):
    with open(f"build/memory{i}.mem", "w") as bank_file:
        for byte in bank:
            hex_value = hex(byte)[2:].zfill(2)  # Convert byte to hex and remove '0x' prefix, then zero-fill to ensure 2 digits
            bank_file.write(f"{hex_value}\n")
