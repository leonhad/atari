all:
	dasm *.asm -f3 -v0 -ocart.bin

run:
	stella cart.bin

all: joystickinput.asm
	dasm joystickinput.asm -f3 -v0 -scart.sym -lcart.lst -ocart.a26

clean:
	rm -f cart.bin cart.a26 a.out cart.sym cart.lst