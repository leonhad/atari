	processor 6502

	seg code
	org $F000		; define the code origin at $F000

Start:
	sei				; disable interrupts
	cld				; disable the BCD math mode
	ldx #$FF		; loads the X register with #$FF
	txs				; transfer X register to S(tack) register

; Clear the zero page region ($00 to $FF).
; Meaning the entire TIA register space and also RAM.
	lda #$00		; A = 0
	ldx #$FF		; X = #$FF

MemLoop:
	sta $0,X		; store zero at address $0 + X
	dex				; X--
	bne	MemLoop		; loop until X == 0 (z-flag set)

; Fill ROM size to exactly 4KB.
	org $FFFC
	.word Start		; reset vector at $FFFC (where program starts).
	.word Start		; interrupt vector at $FFFE (unused in VCS).
