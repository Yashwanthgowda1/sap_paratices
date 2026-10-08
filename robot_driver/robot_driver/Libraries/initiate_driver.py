import os
import subprocess
import json
from subprocess import DEVNULL, PIPE
from collections import OrderedDict

from robot.libraries.BuiltIn import BuiltIn

from Libraries.AccountSetup import AccountSetup
from Libraries.device_control import connect_device, root_device, reset_Teams_app
from Libraries import shared_utils
from Libraries.shared_utils import print, config

obj_dev = AccountSetup.getInstance()
appium_servers = {}


def _as_get():
    global appium_servers
    return appium_servers


def start_appium_servers(device_list):
    device_list = shared_utils.make_list(device_list)
    print(f"start_appium_servers device_list={device_list}")
    port_range = "82[0-9][0-9]"

    # Do we really need to clear the whole range?
    port_pid = shared_utils.get_pid_for_localhost_ports(port_range)
    if port_pid:
        print("port_pid : ", port_pid)
        shared_utils.kill_process_by_pid(port_pid, False)
        print("Cleared ports in range 8200-8299")
    else:
        print(f"Not running anything with 127.0.0.1:{port_range}")

    # Sanity check - must specify unique ports per instance:
    port_list = []
    for d in device_list:
        _port = shared_utils.getconfig_device_port(d)
        print("port ", _port)
        port_list.append(_port)
    if len(port_list) != len(set(port_list)):
        raise AssertionError("Use different Ports for different devices")

    print("Appium listen ports: ", port_list)
    for port in port_list:
        print(f"Clear Appium listen port: '{port}'")

        if port_pid := shared_utils.get_port_pid(port):
            shared_utils.kill_process_by_pid(port_pid, False)
            print(f"Killed pid '{port_pid}' using port '{port}'.")
        else:
            print(f"Nothing using port '{port}'.")
    shared_utils.sleep_with_msg(None, 3, "Cleared Appium port processes")

    # Make sure the logging directory exists:
    newpath = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "appium_logs")
    if not os.path.exists(newpath):
        os.makedirs(newpath)

    # Now launch the Appium server instances:
    for device in device_list:
        start_single_appium_server(device, newpath)

    print(f"Appium Servers: startup complete, ports: {port_list}")


def start_single_appium_server(device, logdir=None):
    device, _ = shared_utils.decode_device_specifier(device)
    if not logdir:
        logdir = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "appium_logs")

    port = shared_utils.getconfig_device_port(device)
    fname = f"appium_{device}_{str(port)}.txt"
    log_name = os.path.join(logdir, fname)
    instance = 0

    while os.path.exists(log_name):
        if instance > 100:
            print(f"{device}: WARN: > 100 {fname} files, re-using {log_name}")
            break
        instance += 1
        fname = f"appium_{device}_{str(port)}_{instance}.txt"
        log_name = os.path.join(logdir, fname)

    print(f"{device}: Starting Appium Server, listening on port {port}...")

    _instance = subprocess.Popen(
        ["appium", "-p", str(port), "--log", log_name, "--log-timestamp"],
        text=True,
        stdout=DEVNULL,
        stdin=DEVNULL,
        shell=shared_utils.is_windows(),
    )
    _as_get()[device] = _instance
    print(f"Tracking Appium Server '{device}' in Appium Servers list {appium_servers}")

    # Correlation: device name, pid, port, and log name:
    print(f"{device}: Launched Appium Server (pid={_instance.pid}) listening on port {port}, logging to {fname}")

    shared_utils.sleep_with_msg(device, 3, f"Let Appium Server start up")


def teardown_devices():
    """
    Process cleanup - WebDrivers and then Appium
    """

    def teardown_single_device(device):
        print(f"{device}: Appium teardown, list is {_as_get()}")
        if device not in _as_get():
            # This can happen if Appium was started but the WebDriver setup failed:
            print(f"{device}: No WebDriver")
            return
        obj_dev.teardown_device_driver(device)

        # Note: Killing the entire process tree (/T option) and forcibily terminate (/F option)
        # is the only way to kill off the zombie 'Node.exe' processes.
        try:
            shared_utils.kill_process_by_pid(str(_as_get()[device].pid), True)
        except Exception as e:
            print(f"{device}: WARNING cannot kill Appium Server:{e}")
        _as_get().pop(device)

    for device in obj_dev.get_driver_names():
        teardown_single_device(device)

    # There may be Appium Servers for which no WebDriver (currently) exists - kill them too ('file in use' issues)
    for device in _as_get():
        print(f"{device}: extra Appium Server teardown...")
        try:
            shared_utils.kill_process_by_pid(str(_as_get()[device].pid), True)
        except Exception as e:
            print(f"{device}: WARNING cannot kill extra Appium Server:{e}")


def setup_devices(device_list=None):
    """
    Process startup - First ADB Server, Appium, and then the WebDrivers
    """
    if not device_list:
        device_list = shared_utils.getconfig_all_device_names()
    else:
        # user supplied list - only use what is actually configured.
        device_list = shared_utils.getconfig_trim_to_configured_devices(device_list)

    print(f"setup_devices(device_list={device_list})")

    # Make sure the server is running before we attempt any 'threaded' connects.
    cp = subprocess.run(["adb", "start-server"], stdout=PIPE, text=True)
    print(f"Adb server startup: rc={cp.returncode}, Output: {cp.stdout.strip()}")
    shared_utils.sleep_with_msg(None, 3, "Allow adb server startup")

    start_appium_servers(device_list)

    try:
        _setup_devices_in_parallel(device_list)
    except Exception as err:
        print(f"_setup_devices_in_parallel: exception: {err}")
        # Don't leave node around:
        teardown_devices()
        raise


def _setup_devices_in_parallel(device_list):
    def setup_single_device(device_name: str):
        connect_device(device_name, config)

        # Force Teams to consistent device state prior to launching automation.
        reset_Teams_app(device_name, config)

        # Seen during threaded webdriver setup:
        #   selenium.common.exceptions.WebDriverException: Message: An unknown server-side error occurred while processing the
        #   command. Original error: Could not acquire lock on 'C:\Users\v-kargoo\AppData\Local\Temp\uia2_device_port_guard' after 25s.
        #   Original error: EPERM: operation not permitted, open 'C:\Users\v-kargoo\AppData\Local\Temp\uia2_device_port_guard'
        #
        #   Once a device hits this issue, it must be rebooted!
        #   This needs to be sequential:
        #
        # obj_dev.setup_device_driver(device_name, config)

    _devices_to_setup = shared_utils.make_list(device_list)

    ###########################
    # Issues with parallel device setup - allow override:
    #   (appears to be stable: now that 'obj_dev.setup_device_driver' is no longer threaded.)
    skip_parallel = BuiltIn().get_variable_value("${exp_skip_parallel_setup}")
    if skip_parallel:
        BuiltIn().log_to_console(f"Variable 'exp_skip_parallel_setup': Sequentially setting up devices...")
        for _device_name in _devices_to_setup:
            setup_single_device(_device_name)
    else:
        shared_utils.run_parallel(_devices_to_setup, setup_single_device)

    #
    # Do not thread! See ISSUE, above. Sequentially get WebDrivers:
    #
    for _device_name in _devices_to_setup:
        # Launch Webdriver automation:
        obj_dev.setup_device_driver(_device_name, config)
        print(f"{_device_name}: Setup complete")
    #
    ###########################


def get_authenticator_app_from_config():
    if "authenticator_app" in config.keys():
        if config["authenticator_app"].lower() not in ["companyportal", "ngms", ""]:
            raise AssertionError(f"Unexpected value for 'authenticator_app': {config['authenticator_app']}")
        return config["authenticator_app"]
    return "companyportal"


def read_config():
    """
    Read the main configuration file.
    (Logging the contents to aid debugging.)
    """
    tmp_config = json.loads(open("config.json").read(), object_pairs_hook=OrderedDict)
    # print("Config : ", tmp_config)
    return tmp_config


def root_console(console: str, config: dict):
    # Deprecated: Use root_device() instead
    root_device(console)


# No references found:
# def clearing_caches_on_all_installed_apps(device):
#     reset_Teams_app(device, config)
