# from serial import Serial
# sudo -E python3 python_uart.py
import serial
import time
import random
import numpy as np
port = "/dev/ttyUSB1"
# baudrate = 19210
baudrate = 9600
def random_value():
    return random.randint(-128, 127)

# Define matrix dimensions
M = 50
K = 18
N = 20


# Generate random matrix
matrixA = [[random_value() for _ in range(K)] for _ in range(M)]
matrixB = [[random_value() for _ in range(N)] for _ in range(K)]


# print(dir(serial))
# print(hex(byte_string[0]))
with serial.Serial(port=port, baudrate=baudrate, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_TWO, timeout=2) as ser:
    byte_string = M.to_bytes(4, byteorder='little',signed=False)  # 'big' or 'little' for byte order
    ser.write(byte_string)
    time.sleep(0.4)
    byte_string = K.to_bytes(4, byteorder='little',signed=False)  # 'big' or 'little' for byte order
    ser.write(byte_string)
    time.sleep(0.4)
    byte_string = N.to_bytes(4, byteorder='little',signed=False)  # 'big' or 'little' for byte order
    ser.write(byte_string)
    time.sleep(0.4)
    # byte_string = K_.to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
    # ser.write(byte_string)
    for i in range(M):
        for j in range(K):       
            byte_string = matrixA[i][j].to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
            print(byte_string)
            ser.write(byte_string)
    time.sleep(3)
    for i in range(K):
        for j in range(N):       
            byte_string = matrixB[i][j].to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
            print(byte_string)
            ser.write(byte_string)
    # print("Serial baud rate: " + str(baudrate))
    # print("Sending data: " + data_to_send.decode())  # Convert bytes to string for printing

    # l = len(data_to_send)
    # count = 0

    # while (count < l):
    #     d = data_to_send[count:count + kk]
    #     if count + kk <= l:
    #         d = data_to_send[count:count + kk]
    #         if print_log == 1:
    #             print(f"Sending {len(d)} bytes: {d}")
    #         ser.write(d)
    #         if read == 1:
    #             s = ser.read(kk)
    #             if print_log == 1:
    #                 print(f"Received {len(s)} bytes: {s}")
    #         count += kk
    #     if count & 0xFFFFF == 0:
    #         print(f'{count} bytes transferred')

    # if count < l:
    #     for x in range(l - count):
    #         d = int.to_bytes(data_to_send[count], length=1, byteorder='little')
    #         if print_log == 1:
    #             print(f"Sending {d}")
    #         ser.write(d)
    #         if read == 1:
    #             s = ser.read(1)
    #             if print_log == 1:
    #                 print(f"Received {s}")
    #         count += 1
    #         if count >= l:
    #             break
    # print("Finished transmission!")
    # print (np.array(matrixA))
    # print (np.array(matrixB))
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
print(np.dot(np.array(matrixA),np.array(matrixB)))