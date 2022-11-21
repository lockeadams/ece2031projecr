ORG 0

	; Get the switch values
	IN     Switches
	; Send to the peripheral
	OUT	   Beep
	OUT    Volume
	; Delay for 1 second
	CALL   Delay
	; Do it again
	JUMP   0
	
; Subroutine to delay for 0.2 seconds.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoop
	RETURN

; Letters   
Bit6:      DW &B0001000000
Bit5:      DW &B0000100000
Bit4:      DW &B0000010000  
; Octaves 
Bit3:      DW &B0000001000
Bit2:      DW &B0000000100
Bit1:      DW &B0000000010 
; Sharp  
Bit0:      DW &B0000000001

 
; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40
Volume:    EQU &H41
