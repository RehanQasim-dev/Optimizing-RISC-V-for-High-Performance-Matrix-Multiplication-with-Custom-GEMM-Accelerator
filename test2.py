import random
import numpy as np
# Function to generate random integer in range [-100, 100]
def random_value():
    return random.randint(-128, 127)

# Define matrix dimensions
M = 20
K = 20
N = 20


# Generate random matrix
matrixA = [[random_value() for _ in range(K)] for _ in range(M)]

# Print matrix in C format
print("int8_t A[M][K] = {")
for row in matrixA:
    print("    {", end="")
    for i, val in enumerate(row):
        if i < len(row) - 1:
            print(f"{val:4}, ", end="")
        else:
            print(f"{val:4}", end="")
    print(" },")
print("};")

matrixB = [[random_value() for _ in range(N)] for _ in range(K)]

# Print matrix in C format
print("int8_t B[K][N] = {")
for row in matrixB:
    print("    {", end="")
    for i, val in enumerate(row):
        if i < len(row) - 1:
            print(f"{val:4}, ", end="")
        else:
            print(f"{val:4}", end="")
    print(" },")
print("};")

matrix=np.dot(np.array(matrixA),np.array(matrixB))
print(matrix)
# for row in matrix:
#     for byte in row:
#         hex_value = hex(byte)[2:].zfill(2)  # Convert byte to hex and remove '0x' prefix, then zero-fill to ensure 2 digits
#         print(hex_value, end=", ")  # Print the hex value with a comma separator
#     print()  # Move to the next line after each row