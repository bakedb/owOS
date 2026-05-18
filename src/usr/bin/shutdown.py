import subprocess, sys, time

def shutdown():
    prompt = input("Are you sure you want to shut down the system? [y/N] ")
    if prompt in ["y", "Y"]:
        print("Shutting down...")
        print("Goodbye :3")
        time.sleep(1)
        sys.stdout.flush()
        subprocess.run(["poweroff"])