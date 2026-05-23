import sys, time
def write(text, newline=True):
    if newline:
        extension = "\n"
    else: extension = ""
    sys.stdout.write(str(text) + extension)
    sys.stdout.flush()

def read(text):
    write(text, False)
    line = sys.stdin.readline()
    if not line or line == "\n":
        time.sleep(0.1)
        return ""
    return line.strip()