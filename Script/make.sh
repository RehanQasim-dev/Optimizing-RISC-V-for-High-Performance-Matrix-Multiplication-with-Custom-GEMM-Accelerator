rm -rf build
mkdir build
prefix=riscv-none-elf
$prefix-as -c -o build/startup.o src/startup.s -march=rv32imzicsr -mabi=ilp32
$prefix-gcc -c -o build/main.o src/main.c -march=rv32imzicsr -mabi=ilp32
$prefix-gcc -o build/main.elf build/startup.o build/main.o -T linker.ld -nostdlib -march=rv32imzicsr -mabi=ilp32 -O0  
$prefix-objcopy -O binary --only-section=.text* build/main.elf build/ICACHE.bin
$prefix-objcopy -O binary --only-section=.data*  build/main.elf build/DCACHE.bin
python3 make_mem.py build/ICACHE.bin > build/ICACHE.mem
python3 generate_banks_memory.py build/DCACHE.bin 
# riscv-none-elf-objdump -S -s build/main.elf > build/main.dump
