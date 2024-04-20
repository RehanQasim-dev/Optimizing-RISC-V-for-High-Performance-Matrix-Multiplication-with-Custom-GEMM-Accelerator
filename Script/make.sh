rm -rf build
mkdir build
riscv64-unknown-elf-as -c -o build/startup.o src/startup.s -march=rv32i -mabi=ilp32
 riscv64-unknown-elf-as -c -o build/main.o src/verilate.s -march=rv32i -mabi=ilp32
riscv64-unknown-elf-gcc -o build/main.elf build/startup.o build/main.o -T linker.ld -nostdlib -march=rv32i -mabi=ilp32 -O0  # Example: use -O0 for optimization level 2
riscv64-unknown-elf-objcopy -O binary --only-section=.text* build/main.elf build/ICACHE.bin
riscv64-unknown-elf-objcopy -O binary --only-section=.data*  build/main.elf build/DCACHE.bin
python3 maketxt1.py build/ICACHE.bin > build/ICACHE.mem
python3 maketxt2.py build/DCACHE.bin > build/DCACHE.mem
riscv64-unknown-elf-objdump -S -s build/main.elf > build/main.dump
riscv64-unknown-elf-objdump -S -s build/main.o > build/test.dump