# from serial import Serial
import serial
import time
import random
port = "/dev/ttyUSB1"
baudrate = 9600
def random_value():
    return random.randint(-128, 127)

# Define matrix dimensions
M = 50
K = 40
# N = 20


# Generate random matrix
matrixA = [[random_value() for _ in range(K)] for _ in range(M)]

# print(dir(serial))
# print(hex(byte_string[0]))
with serial.Serial(port=port, baudrate=baudrate, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_TWO, timeout=2) as ser:
    M_=M+48
    K_=K+48
    byte_string = M_.to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
    ser.write(byte_string)
    time.sleep(0.2)
    byte_string = K_.to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
    ser.write(byte_string)
    # byte_string = K_.to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
    # ser.write(byte_string)
    for i in range(M):
        for j in range(K):       
            byte_string = matrixA[i][j].to_bytes(1, byteorder='little',signed=True)  # 'big' or 'little' for byte order
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