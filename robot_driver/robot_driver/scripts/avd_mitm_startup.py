import os
import sys
import subprocess
import time

# This script is used by man-in-the-middle tests.
#   An emulator is communicating via a man-in-the-middle proxy.
#
# This script is used to start the android emulator AFTER the man-in-the-middle proxy is launched.
# (The emulator needs the proxy running, or it will fail to use it.)
#
# After launching the emulator, we explicitly kill off the
#   proxy - another proxy instance will be started/used by robot testcode as
#   an in-process client.


def startup(avd_name, proxy_port):
    print(f"Startup({avd_name}, {proxy_port})")

    os.system("taskkill /f /im mitmproxy.exe")

    # The emulator process name is 'qemu-system-x86_64.exe'
    # Kill it to ensure the proxy is started first:
    rc = os.system("taskkill /f /im qemu-system-x86_64.exe")
    if rc == 0:
        _shutdown_default = 20
        # We killed the emulator, the driver will shut down in ANDROID_EMULATOR_WAIT_TIME_BEFORE_KILL seconds - default=20.
        #
        # Note: Manual close of the emulator: takes 20 seconds to close this window.
        #   Can be overidden with "ANDROID_EMULATOR_WAIT_TIME_BEFORE_KILL" - is default 20 seconds
        if os.environ.get("ANDROID_EMULATOR_WAIT_TIME_BEFORE_KILL"):
            _shutdown_default = int(os.environ.get("ANDROID_EMULATOR_WAIT_TIME_BEFORE_KILL"))
        sleep_with_msg(_shutdown_default, "Allow emulator shutdown")

    mitm_command = ["cmd", "/C", "start", "mitmproxy", "-p", proxy_port]
    mitm_process = subprocess.Popen(
        mitm_command,
        stderr=subprocess.STDOUT,
    )
    if rc := mitm_process.poll() is not None:
        raise RuntimeError(f"Failed to start mitmproxy on port {proxy_port}, rc={rc}")

    print(f"Started mitmproxy on port {proxy_port} with PID: {mitm_process.pid}")

    # Might not be necessary:
    sleep_with_msg(2, f"Sleeping before starting emulator AVD '{avd_name}'...")

    # Windows: Cause the new process to be orphaned - the framework is 'waiting' for this thread to complete.
    creationflags = (
        subprocess.DETACHED_PROCESS | subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.CREATE_BREAKAWAY_FROM_JOB
    )

    emulator_command = [
        # These "cmd /K start" args give the emulator window slightly
        #   more info, but do not appear to be necessary:
        "cmd",
        "/K",
        "start",
        # But these are required:
        "emulator",
        "-avd",
        avd_name,
        "-writable-system",
        "-http-proxy",
        f"http://127.0.0.1:{proxy_port}",
        # This is 'cold boot' takes up to two minutes
        "-no-snapshot-load",
    ]
    emulator_process = subprocess.Popen(emulator_command, creationflags=creationflags)
    if rc := emulator_process.poll() is not None:
        raise RuntimeError(f"Failed to start emulator AVD '{avd_name}' using proxy port {proxy_port}, rc={rc}")
    print(f"Started emulator using proxy port {proxy_port} with PID: {emulator_process.pid}")

    # If emulater is 'starting from scratch' it might take this long (or longer?):
    sleep_with_msg(10, "Sleeping after emulator startup and before killing mitmproxy...")

    os.system("taskkill /f /im mitmproxy.exe")


def sleep_with_msg(wait_seconds, why_message):
    """Sleep after emitting a message why"""
    print(f"Sleeping {wait_seconds}: {why_message}")

    time.sleep(wait_seconds)


if __name__ == "__main__":
    AVD_NAME = sys.argv[1]
    PROXY_PORT = sys.argv[2]

    print(f"Initializing AVD {AVD_NAME} and MITM to use port {PROXY_PORT}")

    startup(AVD_NAME, PROXY_PORT)
