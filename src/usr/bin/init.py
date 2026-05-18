#!/usr/bin/python3
import sys, os
import clear, shutdown

file_path = os.path.dirname(os.path.realpath(__file__))

clear.clear_screen()
print("Hello World :3")
print("owOS Build 2026.05.18")
print("Made with <3 (and a lot of frustration) by Baked Beans <https://bkd.lol>")
print("Input 'help' for all commands")

def prompt():
    c_input = input("uwush > ")
    check(c_input)

def check(input):
    if input == "help":
        with open(f"{file_path}/commands", "r") as f:
            for line in f:
                sys.stdout.write(line)
            print("\n")
    elif input == "shutdown":
        shutdown.shutdown()
    else:
        print(f"Unrecognized command '{input}'.")
    prompt()



while True:
    prompt()
