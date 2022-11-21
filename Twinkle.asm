; Twinkle.asm
; Plays Twinkle Twinkle Little Star

ORG 0
Song:

    ; C
    IN Switches
    ADD C
    OUT Beep
    CALL Delay

    ; C
    IN Switches
    ADD C
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; A
    IN Switches
    ADD A
    OUT Beep
    CALL Delay

    ; A
    IN Switches
    ADD A
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; D
    IN Switches
    ADD D
    OUT Beep
    CALL Delay

    ; D
    IN Switches
    ADD D
    OUT Beep
    CALL Delay

    ; C
    IN Switches
    ADD C
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; D
    IN Switches
    ADD D
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; D
    IN Switches
    ADD D
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; C
    IN Switches
    ADD C
    OUT Beep
    CALL Delay

    ; C
    IN Switches
    ADD C
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; A
    IN Switches
    ADD A
    OUT Beep
    CALL Delay

    ; A
    IN Switches
    ADD A
    OUT Beep
    CALL Delay

    ; G
    IN Switches
    ADD G
    OUT Beep
    CALL Delay

    ; Delay
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; F
    IN Switches
    ADD F
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; E
    IN Switches
    ADD E
    OUT Beep
    CALL Delay

    ; D
    IN Switches
    ADD D
    OUT Beep
    CALL Delay

    ; D
    IN Switches
    ADD D
    OUT Beep
    CALL Delay

    ; C
    IN Switches
    ADD C
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
C: DW &B1000000000000000
D: DW &B0100000000000000
E: DW &B0010000000000000
F: DW &B0001000000000000
G: DW &B0000100000000000
A: DW &B0000010000000000
B: DW &B0000001000000000

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40
