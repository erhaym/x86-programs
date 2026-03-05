# x86 programs

Collection of x86 Assembly programs. (Intel syntax)

## Assemble

```bash
nasm -f elf bubble_sort.asm -o bubble_sort.o
```

## Link

```bash
gcc -no-pie -m32 bubble_sort.o -o bubble_sort
```

## Run

```bash
./bubble_sort
```
