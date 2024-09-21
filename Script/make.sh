rm -rf build
mkdir build
riscv64-unknown-elf-as -c -o build/startup.o src/startup.s -march=rv32imzicsr -mabi=ilp32
riscv64-unknown-elf-gcc -c -o build/main.o src/main.c -march=rv32imzicsr -mabi=ilp32
riscv64-unknown-elf-gcc -o build/main.elf build/startup.o build/main.o -T linker.ld -nostdlib -march=rv32imzicsr -mabi=ilp32 -O0  
riscv64-unknown-elf-objcopy -O binary --only-section=.text* build/main.elf build/ICACHE.bin
riscv64-unknown-elf-objcopy -O binary --only-section=.data*  build/main.elf build/DCACHE.bin
python3 make_mem.py build/ICACHE.bin > build/ICACHE.mem
python3 generate_banks_memory.py build/DCACHE.bin 
python3 make_combined_banks_memory.py build/DCACHE.bin > DCACHE.mem
riscv64-unknown-elf-objdump -S -s build/main.elf > build/main.dump
# riscv64-unknown-elf-objdump -S -s build/main.o > build/test.dump