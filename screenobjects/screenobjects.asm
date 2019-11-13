    processor 6502
    include "vcs.h"
    include "macro.h"

    seg
    org $F000

Reset:
    CLEAN_START

    ldx #$80        ; blue background color
    stx COLUBK

    lda #%111        ; white playfield color
    sta COLUPF

; We set the TIA registers for the colors of P0 and P1.
    lda #$48        ; player 0 color light red
    sta COLUP0

    lda #$C6        ; player 1 color light green
    sta COLUP1

    ldy #%00000010  ; CTRLPF D1 set to 1 means (score)
    sty CTRLPF

; Start a new frame by configuring VBLANK and VSYNC
StartFrame:
    lda #2
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

; Draw the 192 visible scanlines
VisibleScanlines:
    ; Draw 10 empty scanlines at the top of the frame
    REPEAT 10
        sta WSYNC
    REPEND

    ; Display 10 scanlines for the scoreboard number
    ; Pulls data from an arrau of bytes defined at NumberBitmap
    ldy #0
ScoreboardLoop:
    lda NumberBitmap,Y
    sta PF1
    sta WSYNC
    iny
    cpy #10
    bne ScoreboardLoop

    lda #0
    sta PF1         ; disable playfield

    ; Draw 50 empty scanlines between scoreboard and player
    REPEAT 50
        sta WSYNC
    REPEND

; Display 10 scanlines fot the Player 0 graphics
; Pulls data from an array of bytes defined at PlayerBitmap
    ldy #0
Player0Loop:
    lda PlayerBitmap,Y
    sta GRP0
    sta WSYNC
    iny
    cpy #10
    bne Player0Loop

    lda #0
    sta GRP0        ; disable player 0 graphics

; Display 10 scanlines fot the Player 0 graphics
; Pulls data from an array of bytes defined at PlayerBitmap
    ldy #0
Player1Loop:
    lda PlayerBitmap,Y
    sta GRP1
    sta WSYNC
    iny
    cpy #10
    bne Player1Loop

    lda #0
    sta GRP1        ; disable player 0 graphics

; Draw the remaining 102 scanlines (192-90), since we already
; used 10+10+50+10+10=80 scanlines in the current frame
    REPEAT 102
        sta WSYNC
    REPEND

; Output 30 more VBLANK overscan lines to complete our frame
    REPEAT 30
        sta VSYNC
    REPEND

    jmp StartFrame

; Defines an array of bytes to draw the scoreboard number
; We add these bytes in the last ROM addresses.
    org $FFE8
PlayerBitmap:
    .byte #%01111110    ;  ###### 
    .byte #%11111111    ; ########
    .byte #%10011001    ; #  ##  #
    .byte #%11111111    ; ########
    .byte #%11111111    ; ########
    .byte #%11111111    ; ########
    .byte #%10111101    ; # #### #
    .byte #%11000011    ; ##    ##
    .byte #%11111111    ; ########
    .byte #%01111110    ;  ###### 

; Defines an array of bytes to draw the scoreboard number
; We add these bytes in the last ROM addresses.
    org $FFF2
NumberBitmap:
    .byte #%00001110    ; ########
    .byte #%00001110    ; ########
    .byte #%00000010    ;      ###
    .byte #%00000010    ;      ###
    .byte #%00001110    ; ########
    .byte #%00001110    ; ########
    .byte #%00001000    ; ###     
    .byte #%00001000    ; ###     
    .byte #%00001110    ; ########
    .byte #%00001110    ; ########

    org $FFFC
    .word Reset
    .word Reset
