import math

def write_header(filename: str, size: int) -> None:
    """Write the header of the file."""
    width = int(math.log(size, 2))
    with open(filename, 'w') as file:
        file.write(f"DEPTH = {size};\nWIDTH = {width};\nADDRESS_RADIX = DEC;\nDATA_RADIX = DEC;\n\nCONTENT\nBEGIN\n")

def write_sine(filename: str, size: int) -> None:
    """Write the sine wave to the file."""
    write_header(filename, size)
    with open(filename, 'a') as file:
        for i in range(size):
            file.write(str(i) + " : " + str(int(127 * math.sin(2 * math.pi * i / size))) + ";\n")
        file.write("END;")

def write_square(filename: str, size: int) -> None:
    """Write the square wave to the file."""
    write_header(filename, size)
    with open(filename, 'a') as file:
        for i in range(size):
            file.write(str(i) + " : " + str(int(127 * math.copysign(1, math.sin(2 * math.pi * i / size)))) + ";\n")
        file.write("END;")

if __name__ == '__main__':
    write_sine("SOUND_SINE_1024.mif", 1024)
    write_square("SOUND_SQUARE_1024.mif", 1024)