NAME=Homework1
nasm -f elf -d ELF_TYPE $NASM/asm_io.asm
nasm -f elf $NAME.asm
gcc -m32 -o $NAME.out $NAME.o $NASM/driver.c $NASM/asm_io.o
