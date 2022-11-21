; Twinkle.asm
; Plays Twinkle Twinkle Little Star

ORG 0

Song:

    ; C
    LOAD C
    OUT Beep
    CALL Delay

    ; C
    LOAD C
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; A
    LOAD A
    OUT Beep
    CALL Delay

    ; A
    LOAD A
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; D
    LOAD D
    OUT Beep
    CALL Delay

    ; D
    LOAD D
    OUT Beep
    CALL Delay

    ; C
    LOAD C
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; D
    LOAD D
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; D
    LOAD D
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; C
    LOAD C
    OUT Beep
    CALL Delay

    ; C
    LOAD C
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; A
    LOAD A
    OUT Beep
    CALL Delay

    ; A
    LOAD A
    OUT Beep
    CALL Delay

    ; G
    LOAD G
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; F
    LOAD F
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; E
    LOAD E
    OUT Beep
    CALL Delay

    ; D
    LOAD D
    OUT Beep
    CALL Delay

    ; D
    LOAD D
    OUT Beep
    CALL Delay

    ; C
    LOAD C
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; Restart Song
    JUMP Song

Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoop
	RETURN



; Notes
C: DW &B1000000001000000
D: DW &B0100000001000000
E: DW &B0010000001000000
F: DW &B0001000001000000
G: DW &B0000100001000000
A: DW &B0000010001000000
B: DW &B0000001001000000

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40