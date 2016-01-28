TDIR=./target
rust: build
	rustc -O --target i686-unknown-linux-gnu --crate-type lib \
		-o $(TDIR)/kernel.o --emit obj kernel.rs
	as --32 -o $(TDIR)/boot.o boot.s
	ld -m elf_i386 -T link.ld -o $(TDIR)/myfirstkernel.bin \
		$(TDIR)/boot.o $(TDIR)/kernel.o

llvm: build
	llc -march=x86 -filetype=asm -o=$(TDIR)/kernel.s kernel.ll
	as --32 -o $(TDIR)/kernel.o $(TDIR)/kernel.s
	as --32 -o $(TDIR)/boot.o boot.s
	ld -m elf_i386 -T link.ld -o $(TDIR)/myfirstkernel.bin \
		$(TDIR)/boot.o $(TDIR)/kernel.o

build:
	mkdir -p $(TDIR)

install:
	cp $(TDIR)/myfirstkernel.bin /boot/myfirstkernel.bin

clean:
	rm -rf $(TDIR)

run:
	qemu-system-i386 -kernel target/myfirstkernel.bin &