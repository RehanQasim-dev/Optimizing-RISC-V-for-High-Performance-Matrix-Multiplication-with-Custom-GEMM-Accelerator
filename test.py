import numpy as np

Matrix_A = [
    [   5,  -18,  -12,  -12,    6,   -2,   -5,  -17,    0,   -8,    3],
    [   1,  -16,   -1,   -8,   -8,    6,   -2,    7,   -7,   -8,  -19],
    [  -7,  -11,  -13,   -1,   10,  -18,   -8,    4,   -5,    2,    3],
    [ -15,   -5,  -13,    9,   -6,    0,   -8,   10,    0,    2,   -5],
    [  -8,   -5,    2,   -7,   -4,  -19,   -7,  -18,    8,  -19,    6],
    [   9,    3,  -10,   -2,    2,    4,    6,    9,  -12,    6,    4],
    [   8,    3,    7,   -4,    9,    6,    0,  -14,    0,  -19,    4],
    [   9,  -16,   -9,  -14,   -4,   -3,   -2,    3,    6,   -8,    2],
    [   7,  -17,    7,  -10,  -15,   -8,    7,  -14,   -5,  -15,   -9],
    [   8,    1,    0,   -2,    9,  -14,    5,    3,    4,    6,  -14],
    [   0,   -1,  -13,   -4,    1,    0,    1,  -19,    4,    8,   -6]
]

Matrix_B = [
    [   4,    2,    9,    9,  -12,    3,   -1,    9,   -8,   -4,    7],
    [ -15,    4,  -14,  -16,   10,    0,  -14,    1,    2,   -2,   -2],
    [ -13,   -7,  -15,  -11,  -19,  -15,    9,   -5,   -7,  -13,   -3],
    [ -14,   -3,  -19,    7,    8,    6,    2,  -18,    2,    0,  -18],
    [ -12,  -17,   -5,    8,   -3,    9,   -1,   -2,    1,    7,    2],
    [   2,    8,    2,    9,   -7,    5,   -6,    0,    6,  -13,    5],
    [   1,    3,    0,    4,    0,   10,    6,  -19,  -11,  -15,   -8],
    [ -12,   -3,    1,   -4,    6,  -15,  -18,    1,  -15,    6,   -5],
    [  -6,    0,    3,   -2,  -10,  -19,  -19,    9,   -4,   -5,   -1],
    [   9,   -2,  -19,  -14,    3,    0,    2,    7,  -17,  -10,    1],
    [ -15,    1,  -12,   -7,   -4,    2,    0,  -13,    0,  -19,    1]
]
import numpy as np

# Convert Matrix_A and Matrix_B to numpy arrays
Matrix_A = np.array(Matrix_A, dtype=np.int32)
Matrix_B = np.array(Matrix_B, dtype=np.int32)

# Calculate target dimensions (next multiple of 16) for columns only
target_cols_A = ((Matrix_A.shape[1] - 1) // 16 + 1) * 16
target_cols_B = ((Matrix_B.shape[1] - 1) // 16 + 1) * 16
target_rows_B = ((Matrix_B.shape[0] - 1) // 16 + 1) * 16

# Pad matrices using numpy's pad function (padding columns for A, columns and rows for B)
Matrix_A = np.pad(Matrix_A, 
                  ((0, 0),  # No padding for rows
                   (0, target_cols_A - Matrix_A.shape[1])),  # Pad columns
                  mode='constant', constant_values=0)

Matrix_B = np.pad(Matrix_B, 
                  ((0, target_rows_B - Matrix_B.shape[0]),  # Pad rows
                   (0, target_cols_B - Matrix_B.shape[1])),  # Pad columns
                  mode='constant', constant_values=0)

print("Padded Matrix A shape:", Matrix_A.shape)
print("Padded Matrix B shape:", Matrix_B.shape)
print(Matrix_B)
A_sys = np.full((16,16), np.inf, dtype=np.float64)
sys_cs = np.full((16,16), 0, dtype=np.float64)
sys_ns = np.full((16,16), 0, dtype=np.float64)

for step in range(16+16+Matrix_A.shape[0]-2):
    print(f"------------------------------------------------{step}--------------------------------------------------------")
    for i in range(16):
        for j in range(16):
            if (-i-j+step)>=0 and (-i-j+step)<len(Matrix_A):

                A_sys[i,j] = Matrix_A[(-i-j+step)][i]
            else:
                A_sys[i,j] = np.inf
    for i in range(16):
        for j in range(16):
            a=A_sys[i,j]
            b=Matrix_B[i,j]
            
            if i==0:
                if step==11:
                    print(f"A[{i}][{j}]={A_sys[i,j]} B[{i}][{j}]={Matrix_B[i,j]}")
                sys_ns[i,j] = Matrix_B[i,j]*A_sys[i,j]
            else:
                cs=sys_cs[i-1,j]
                if step==11:
                    print(f"A[{i}][{j}]={A_sys[i,j]} B[{i}][{j}]={Matrix_B[i,j]} cs={cs}")
                sys_ns[i,j] = sys_cs[i-1,j]+Matrix_B[i,j]*A_sys[i,j]

    np.set_printoptions()  # Reset print options to default
    print("ns=")
    print('\n'.join([' '.join(['{:6.0f}'.format(item) for item in row]) for row in sys_ns]))
    sys_cs = sys_ns.copy()
    print("Systolic Array Input")
    np.set_printoptions(threshold=np.inf, linewidth=np.inf)
    print('\n'.join([' '.join(['{:6.0f}'.format(item) for item in row]) for row in A_sys]))



# import numpy as np

# def MATMUL(A_rows, A_cols, B_cols, A, B, C):
#     # Constants from the original C code
#     ACCUM_SIZE = 16
#     SYS_ROWS = 16
#     SYS_COLS = 16

#     # Initialize C if not provided
#     if C is None:
#         C = np.zeros((A_rows, B_cols), dtype=np.int32)

#     remaining_n = B_cols
#     remaining_m = A_rows
#     remaining_k = A_cols

#     current_n = 0
#     current_m = 0
#     current_k = 0

#     while remaining_n > 0:
#         cols_to_process = min(SYS_COLS, remaining_n)

#         while remaining_m > 0:
#             rows_to_process = min(ACCUM_SIZE, remaining_m)

#             while remaining_k > 0:
#                 rows_to_process_k = min(SYS_ROWS, remaining_k)

#                 is_last = (current_k + SYS_ROWS >= A_cols)

#                 # Simulate the GEMM operation
#                 Tile_A = A[current_m:current_m+rows_to_process, current_k:current_k+rows_to_process_k]
#                 Tile_B = B[current_k:current_k+rows_to_process_k, current_n:current_n+cols_to_process]
#                 Tile_C = np.matmul(Tile_A.astype(np.int32), Tile_B.astype(np.int32))

#                 if current_k == 0:
#                     C[current_m:current_m+rows_to_process, current_n:current_n+cols_to_process] = Tile_C
#                 else:
#                     C[current_m:current_m+rows_to_process, current_n:current_n+cols_to_process] += Tile_C

#                 remaining_k -= rows_to_process_k
#                 current_k = A_cols - remaining_k
#             print(C)
#             current_k = 0
#             remaining_m -= rows_to_process
#             current_m = A_rows - remaining_m
#             remaining_k = A_cols

#         current_m = 0
#         remaining_n -= cols_to_process
#         current_n = B_cols - remaining_n
#         remaining_m = A_rows

#     return C

# # Convert Matrix_A and Matrix_B to numpy arrays
# Matrix_A = np.array(Matrix_A, dtype=np.int8)
# Matrix_B = np.array(Matrix_B, dtype=np.int8)

# A_rows, A_cols = Matrix_A.shape
# B_cols = Matrix_B.shape[1]

# # Call the MATMUL function
# result = MATMUL(A_rows, A_cols, B_cols, Matrix_A, Matrix_B, None)

# # Print the result
# print("Result of matrix multiplication:")
# print(result)
