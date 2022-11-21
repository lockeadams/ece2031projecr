
def generate_signal(note: str, octave: int, sharp: bool) -> str:
    """Generates an input signal for the TONE_GEN peripheral.
    Args:
        note: The note to be played.
        octave: The octave of the note to be played.
        sharp: Whether the note is sharp or not.
    Returns:
        A 16-bit bitstring representing the input signal for the TONE_GEN peripheral.
    """
    notes = "CDEFGAB"
    signal = ["1" if n == note else "0" for n in notes]
    signal += format(octave, "#06b")[2:5]
    signal += "1" if sharp else "0"
    signal += "00000" # unused bits
    return "".join(signal)


# notes for twinkle twinkle little star
notes = ["C", "C", "G", "G", "A", "A", "G", "F", "F", "E", "E", "D", "D", "C", "G", "G", "F", "F", "E", "E", "D", "G", "G", "F", "F", "E", "E", "D", "C", "C", "G", "G", "A", "A", "G", "F", "F", "E", "E", "D", "D", "C"]
instructions = [generate_signal(note, 4, False) for note in notes]
print(instructions)
