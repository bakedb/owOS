import sys
def clear_screen():
    sys.stdout.write("\033[2J\033[H")
    sys.stdout.flush()