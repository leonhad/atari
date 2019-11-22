    processor 6502

    seg.u Variables
    org $80
Random byte

    seg code
    org $F000       ; define the ROM code origin at $F000

Start:
    sei             ; disable interrupts
    cld             ; disable the BCD decimal math mode
    ldx #$FF        ; loads the X register with value #$FF
    txs             ; transfer X register to S(tack) Pointer
    lda #%11010100
    sta Random               ; Random = $D4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the Zero Page region (from $00 to $FF)
; That means the entire TIA register space and also RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MemLoop:
    jsr GetRandom

    sta $0,X        ; store zero at address $0 + X (does not modify flags)
    dex             ; decrements X
    bne MemLoop     ; loop until X == 0 (until z-flag is set by previous DEX)

    jmp Start

GetRandom subroutine
    lda Random
    asl
    eor Random
    asl
    eor Random
    asl
    asl
    eor Random
    asl
    rol Random               ; performs a series of shifts and bit operations

    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill  ROM size to exactly 4KB
; Also tells 6502 where our program should start (at $FFFC)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC       ; moves/jumps origin to ROM address $FFFC
    .word Start     ; puts 2 bytes at position $FFFC (where program starts)
    .word Start	    ; puts interrupt vector at position $FFFE (unused in VCS)
