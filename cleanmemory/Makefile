all: cart.bin

cart.bin: clearmem.asm
	dasm clearmem.asm -f3 -v0 -ocart.bin

clean:
	rm -f cart.bin a.out
