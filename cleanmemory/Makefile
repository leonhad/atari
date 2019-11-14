all: cart.bin

cart.bin: clearmem.asm
	dasm clearmem.asm -f3 -scart.sym -lcart.lst -v0 -ocart.a26

clean:
	rm -f cart.bin cart.a26 a.out cart.sym cart.lst
