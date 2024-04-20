rmdir -r build
mkdir build
riscv64-unknown-elf-as -c -o build/startup.o src/startup.s -march=rv32im -mabi=ilp32
riscv64-unknown-elf-gcc -c -o build/main.o src/main1.c -march=rv32im -mabi=ilp32
riscv64-unknown-elf-gcc -o build/main.elf build/startup.o build/main.o -T linker.ld -nostdlib -march=rv32im -mabi=ilp32
riscv64-unknown-elf-objcopy -O binary --only-section=.text* build/main.elf build/ICACHE.bin
riscv64-unknown-elf-objcopy -O binary --only-section=.data*  build/main.elf build/DCACHE.bin
python maketxt1.py build/ICACHE.bin > build/ICACHE.mem
python maketxt2.py build/DCACHE.bin > build/DCACHE.mem
riscv64-unknown-elf-objdump -S -s build/main.elf > build/main.dump
riscv64-unknown-elf-objdump -S -s build/main.o > build/test.dump