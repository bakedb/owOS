import subprocess, sys, time, put

def shutdown():
    prompt = put.read("Are you sure you want to shut down the system? [y/N] ")
    if prompt in ["y", "Y"]:
        put.write("Shutting down...")
        put.write("Goodbye :3")
        time.sleep(1)
        sys.stdout.flush()
        subprocess.run(["poweroff"])