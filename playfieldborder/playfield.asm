    processor 6502
    include "vcs.h"
    include "macro.h"

    seg
    org $F000

Reset:
    CLEAN_START

    ldx #$80        ; blue background color
    stx COLUBK

    lda #$1C        ; yellow playfield color
    sta COLUPF

StartFrame:
    lda #02
    sta VBLANK      ; turn VBLANK on
    sta VSYNC       ; turn VSYNC on

    ; Generate the tree lines of VSYNC
    REPEAT 3
        sta WSYNC   ; tree scanlines for VSYNC
    REPEND
    lda #0
    sta VSYNC       ; turn off VSYNC

    ; Let the TIA output the 37 recommended lines of VBLANK
    REPEAT 37
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK      ; turn off VBLANK

    ; Set the CTRLPF register to allow playfield reflection
    ldx #%00000001  ; CTRLPF register (D0 means reflect the PF)
    stx CTRLPF

    ; Draw the 192 visible scanlines

    ; Skip 7 scanlines with no PF set
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; Set the PF0 to 1110 (LSB first) and PF1-PF2 as 1111 1111
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; Set the next 164 lines only with PF0 third bit enabled
    ldx #%00100000
    stx PF0
    ldx #0
    stx PF1
    stx PF2
    REPEAT 164
        sta WSYNC
    REPEND

    ; Set the PF0 to 1110 (LSB first) and PF1-PF2 as 1111 1111
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; Skip 7 scanlines with no PF set
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

    ; Output 30 more VBLANK overscan lines to coplete our frame
    lda #2
    sta VBLANK
    REPEAT 30
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK

    jmp StartFrame

    org $FFFC
    .word Reset
    .word Reset
