# from serial import Serial
# sudo -E python3 python_uart.py
import serial
import time
import random
import numpy as np
port = "/dev/ttyUSB1"
baudrate = 19210
def random_value():
    return random.randint(-128, 127)

# Define matrix dimensions
M = 70
K = 11
N = 60


# Generate random matrix
matrixA = [[random_value() for _ in range(K)] for _ in range(M)]
matrixB = [[random_value() for _ in range(N)] for _ in range(K)]

with serial.Serial(port=port, baudrate=baudrate, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_TWO, timeout=2) as ser:
    #sending matrices dimensions
    byte_string = M.to_bytes(4, byteorder='little',signed=False)  # 'little' for byte order
    ser.write(byte_string)
    time.sleep(0.4)
    byte_string = K.to_bytes(4, byteorder='little',signed=False)  # 'little' for byte order
    ser.write(byte_string)
    time.sleep(0.4)
    byte_string = N.to_bytes(4, byteorder='little',signed=False)  #'little' for byte order
    ser.write(byte_string)
    time.sleep(0.4)
    #sending matrix A
    for i in range(M):
        for j in range(K):       
            byte_string = matrixA[i][j].to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
            ser.write(byte_string)
    time.sleep(3)
    for i in range(K):
        for j in range(N):       
            byte_string = matrixB[i][j].to_bytes(1, byteorder='little',signed=True) 
            ser.write(byte_string)

print("int8_t A[M][K] = ")
print(np.array(matrixA))

print("int8_t B[K][N] = ")
print(np.array(matrixB))
C=np.dot(np.array(matrixA),np.array(matrixB))
print("int32_t C[M][N] = ")
print(C)
