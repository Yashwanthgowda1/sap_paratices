#  Copyright © Microsoft Corporation. All rights reserved.
import os
import requests
import subprocess
import threading

from intercept_request_add_on import InterceptCommand
from Libraries.shared_utils import get_configured_device_property


class ProxySingleton:
    __instance = None

    @staticmethod
    def get_instance():
        if ProxySingleton.__instance is None:
            ProxySingleton()
        return ProxySingleton.__instance

    def __init__(self):
        if ProxySingleton.__instance is not None:
            raise Exception("This class is a singleton!")
        else:
            ProxySingleton.__instance = self
        self.process = None
        self.thread = None
        self.device_name = None


def output_reader(proc):
    for line in iter(proc.stdout.readline, b""):
        print("Proxy_output: {0}".format(line.decode("utf-8", errors="ignore")), end="")


def start_proxy(device_name):
    """
    Starts the mitmdump proxy in a separate thread, port 8888, with the intercept_request_add_on.py script.
    """
    avd_proxy_port = get_configured_device_property(device_name, "avd_proxy_port")
    try:
        proxy_singleton = ProxySingleton.get_instance()
        current_dir_path = os.path.dirname(os.path.abspath(__file__))
        addon_file_path = os.path.join(current_dir_path, "intercept_request_add_on.py")
        command = ["mitmdump", "-p", f"{avd_proxy_port}", "-s", addon_file_path]
        process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        print(f"Started mitmdump on port {avd_proxy_port} with PID: {process.pid}")
        thread = threading.Thread(target=output_reader, args=(process,))
        thread.start()
        proxy_singleton.process = process
        proxy_singleton.thread = thread
        proxy_singleton.device_name = device_name
    except Exception as e:
        print(f"An error occurred while starting mitmdump: {e}")


def stop_proxy():
    """
    Stops the mitmdump proxy and waits for the thread to finish.
    """
    try:
        process = ProxySingleton.get_instance().process
        thread = ProxySingleton.get_instance().thread
        if process is None:
            raise Exception(f"mitmdump is not running. Process is None.")
        if thread is None:
            raise Exception(f"mitmdump is not running. Thread is None.")
        print(f"Stopping mitmdump at {process.pid}...")
        process.terminate()
        process.wait(timeout=0.2)
        thread.join()
        print("mitmdump stopped.")
    except Exception as e:
        print(f"An error occurred while stopping mitmdump: {e}")


def _change_proxy_config_by_command(command: InterceptCommand):
    """
    Changes the proxy configuration based on the given command.

    Args:
        command (InterceptCommand): The command to change the proxy configuration.

    Raises:
        Exception: If an error occurs while changing the proxy configuration.
    """
    print(f"Changing proxy config by command: {command.name}")
    device_name = ProxySingleton.get_instance().device_name
    avd_proxy_port = get_configured_device_property(device_name, "avd_proxy_port")

    try:
        response = requests.get(f"http://127.0.0.1:{avd_proxy_port}/{command.name}", timeout=60)
        print(f"Response from proxy: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"An error occurred while changing proxy config: {e}")


def change_proxy_create_meeting_failed():
    _change_proxy_config_by_command(InterceptCommand.INTERCEPT_MEETING_FAILED)


def change_proxy_clear():
    _change_proxy_config_by_command(InterceptCommand.INTERCEPT_CLEAR)
