#!/usr/bin/python3
import sys, os
import clear, shutdown, put

file_path = os.path.dirname(os.path.realpath(__file__))

clear.clear_screen()
put.write("Hello World :3")
put.write("owOS Build 2026.05.18")
put.write("Made with <3 (and a lot of frustration) by Baked Beans <https://bkd.lol>")
put.write("Input 'help' for all commands")

def check(input):
    if input == "help":
        with open(f"{file_path}/commands", "r") as f:
            for line in f:
                sys.stdout.write(line)
            put.write("\n")
    elif input == "shutdown":
        shutdown.shutdown()
    else:
        put.write(f"Unrecognized command '{input}'.")
    prompt()



while True:
    c_input = put.read("uwush > ")
    if c_input == "":
        continue
    check(c_input)
