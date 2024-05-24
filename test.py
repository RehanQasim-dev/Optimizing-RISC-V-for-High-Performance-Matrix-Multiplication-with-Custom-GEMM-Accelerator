import numpy as np

# Define the matrices A and B
A = np.array([
    [-16, -102, 3],
    [49, 53, -67]
])

B = np.array([
    [76, 8],
    [99, -72],
    [-101, 12]
])

# Initialize the result matrix C with zeros
# C = np.zeros((2, 2), dtype=np.int8)

# # Perform matrix multiplication
# for i in range(2):
#     for j in range(2):
#         for k in range(3):
#             C[i][j] += A[i][k] * B[k][j]

C=np.dot(A,B)
# Print the result matrix C
print("Result of A * B:")
print(C)
