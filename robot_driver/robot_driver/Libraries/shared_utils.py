import json
import platform
import subprocess
import threading
import time
import traceback
from builtins import print as builtin_print
from subprocess import PIPE
from datetime import datetime
from functools import partial

from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn


def _init_config(file_name: str) -> dict:
    """
    Returns: parsed configuration object from "config.json"
    """
    return json.loads(open(file_name).read())


config = _init_config("config.json")


def _init_is_debug() -> bool:
    """
    Returns: True if `"debug" : "True"` is found in the "config.json" object
    """
    try:
        return config["is_debug"].lower() == "true"
    except KeyError:
        # key not found in config. assume not debug
        return False


is_debug = _init_is_debug()


def print(*args, **kwargs):
    """
    if `is_debug` then also print to the console for easier debugging
    """
    builtin_print(*args, **kwargs)
    if is_debug:
        concat_args = " ".join(str(arg) for arg in args)
        logger.console(f"{datetime.now()} : {concat_args}")


def snif_print(device, what):
    # Avoid spamming the log with temporary 'sniffer' type messages unless explicitly requested.
    if BuiltIn().get_variable_value("${exp_print_snifs}"):
        print(f"{device}: SNIFFER - {what}")


def sleep_with_msg(device, wait_seconds, why_message):
    """Sleep after emitting a message why"""
    if device:
        print(f"{device}: sleeping {wait_seconds}: {why_message}")
    else:
        print(f"Sleeping {wait_seconds}: {why_message}")

    time.sleep(wait_seconds)


def get_port_pid(port):
    """
    Get the PID of the process using the specified port.

    Args:
        port (int): The port number to check.

    Returns:
        str: The PID of the process using the specified port.
    """
    find_tool = get_shell_filter_tool()
    try:
        if is_windows():
            # Note trailing space:
            port_output = subprocess.run(
                f'netstat -ano | {find_tool} /C:":{str(port)} "', text=True, stdout=subprocess.PIPE, shell=True
            )
            if port_output.returncode == 1 or not port_output.stdout:
                return None

            print("port_output : ", port_output.stdout)
            port_pid = port_output.stdout.splitlines()[0].rsplit()[-1].strip()
        else:
            # Note trailing space:
            port_output = subprocess.check_output(f'lsof -i -n -P | {find_tool} ":{str(port)} "', text=True, shell=True)
            print("port_output : ", port_output)
            port_pid = port_output.split()[1]

        print("port_pid : ", port_pid)
        return port_pid

    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e}")
        return None


def get_pid_for_localhost_ports(port_range):
    """
    Retrieves the process ID (PID) for a given range of localhost ports.

    This function executes a system command to list network connections and filters
    the output to find connections on localhost (127.0.0.1) within the specified port range.
    It then extracts and returns the PID associated with the first matching connection.

    Args:
    port_range (str): A string representing the port range in regex format to search for.
                      For example, "82[0-9][0-9]" will search for ports in the range 8200-8299.

    Returns:
    str: The PID of the process using the specified port range, or None if no matching
         connection is found or an error occurs.

    Example:
    >>> port_range = "82[0-9][0-9]"
    >>> pid = get_pid_for_localhost_ports(port_range)
    >>> print("PID:", pid)
    PID: 1234
    """
    find_tool = get_shell_filter_tool()

    if is_windows():
        # Windows-specific netstat command
        # Note trailing space:
        command = ["netstat", "-o", "-n", "-a", "|", find_tool, "/R", f'/C:"127.0.0.1:{port_range} "']
    else:
        command = ["netstat", "-anv", "|", find_tool, f'"127.0.0.1.{port_range} "']

    # Execute the command
    # Note: cannot use 'check' - stdout is a pipe
    output = subprocess.run(command, stdout=subprocess.PIPE, shell=True, timeout=10)

    # Check if the output is empty
    if output.returncode == 1:
        return None

    if output.returncode != 0:
        print(f"get_pid_for_localhost_ports: Unexpected: {output}")
        return None

    if not output.stdout:
        return None

    # Process the output to extract the PID
    lines = output.stdout.splitlines()
    if not lines:
        return None

    if is_windows():
        port_pid = lines[0].rsplit()[-1].strip()
    else:
        parts = lines[0].split()
        if len(parts) < 9:
            print("Error: Unexpected output format")
            return None
        port_pid = parts[8].strip()

    # Decode the PID if necessary
    port_pid = port_pid.decode("utf-8") if isinstance(port_pid, bytes) else port_pid

    #
    # Issue: There can be multiple ports. This code only considers the first.
    #
    if len(lines) > 1:
        print(f"Found {len(lines)} ports in use for '127.0.0.1.{port_range} ', ignoring all but the first: {port_pid}")

    return port_pid


def get_shell_filter_tool():
    """
    Get the name of the shell filter tool for the current platform.

    Returns:
    str: The name of the shell filter tool (e.g., "findstr" or "grep").
    """
    return "findstr" if is_windows() else "grep"


def kill_process_by_pid(pid, kill_entire_process_tree):
    """
    Kill a process by its PID.

    Args:
    pid (str): The process ID to kill.
    kill_entire_process_tree (bool): True to kill the entire process tree, False otherwise. Works only on Windows.

    Raises:
    CalledProcessError: If there is an error executing the kill command.
    """
    if pid is None:
        return
    if is_windows():
        if kill_entire_process_tree:
            command = ["taskkill", "/PID", pid, "/T", "/F"]
        else:
            command = ["taskkill", "/PID", pid, "/F"]
    else:
        command = ["kill", "-9", pid]
    try:
        print("Kill pid: " + pid)
        subprocess.run(command, check=True, stdout=subprocess.PIPE)
    except subprocess.CalledProcessError as e:
        print(f"Kill process failed with error: {e}")


def get_extended_path_prefix():
    """
    Returns the extended-length path prefix for Windows platforms.

    The extended-length path prefix '\\\\?\\' allows for file paths longer than
    the typical 260-character limit imposed by the Windows API. This function
    returns the prefix if the platform is Windows, and an empty string otherwise.

    Returns:
        str: '\\\\?\\' if the platform is Windows, otherwise an empty string.
    """
    return "\\\\?\\" if is_windows() else ""


def is_windows():
    """
    Determines if the current platform is Windows.

    Returns:
        bool: True if the platform is Windows, False otherwise.
    """
    return platform.system().lower() == "windows"


def run_parallel(device_list, func, *args, **kwargs) -> list:
    """
    Execute 'func' for each of the keys in 'device_list', on separate threads.
        When threads are finished:
            results are reported to caller (a list, same order as the keys) OR
            a SINGLE 'composite' ChildThreadError is raised.

        NOTE: The first argument to 'func' MUST be a device name (or deviceName:role).
    """

    def threaded_child(d_name: str, results: dict, real_func, *_args, **_kwargs):
        """
        This wrapper hides the 'results' linkage used between the parent and thread child.
        """
        try:
            results[d_name]["result"] = real_func(d_name, *_args, **_kwargs)
        except Exception as ex:
            results[d_name]["result"] = ex

    def format_thread_exception(d_name: str, exception):
        """
        Return an exception string which can be concatenated with
            others to form a 'summary' exception message for multiple threads.
        """
        tb_only = traceback.format_tb(exception.__traceback__)
        ex_only = "".join(traceback.format_exception_only(type(exception), exception))

        return "----" + d_name + ":\n  " + "".join(tb_only).strip() + f"\n  {ex_only.strip()}\n"

    if device_list is None:
        # ISSUE: We should not take this dependency on 'config', raise instead:
        # device_list = list(config["devices"].keys())
        raise AssertionError("No thread list specified")
    elif isinstance(device_list, str):
        device_list = device_list.split(",")
    elif not isinstance(device_list, list):
        raise AssertionError(f"'device_list' unexpected type: '{type(device_list).__name__}'")

    _func_name = _determine_function_name(func)
    print(f"run_parallel: device_list={device_list}, func={_func_name}")

    # Create and initialize the parent/child result relay dictionary:
    thread_dict = {}
    for device_name in device_list:
        thread_dict[device_name] = {
            "thread": threading.Thread(
                target=threaded_child,
                name=str(device_name) + "_thread",
                args=(device_name, thread_dict, func, *args),
                kwargs=kwargs,
            ),
            "result": None,
        }

    # Start child threads:
    for device_name in device_list:
        print(f"starting '{device_name}' thread {thread_dict[device_name]['thread']}")
        thread_dict[device_name]["thread"].start()

    # Wait for child threads to finish:
    # Future: This 'join' is sequential.
    #   We could possibly do any(), and early-abort all others on failure...
    for device_name in device_list:
        pid = thread_dict[device_name]["thread"].ident
        print(f"wait for '{device_name}' thread {pid}: {thread_dict[device_name]['thread']}")
        thread_dict[device_name]["thread"].join()

    # Assemble composite results/exceptions:
    all_errors = ""
    all_failed_names = []
    ret_list = []
    for device_name in device_list:
        _retval = thread_dict[device_name]["result"]
        if isinstance(_retval, Exception):
            all_errors = all_errors + format_thread_exception(device_name, _retval)
            all_failed_names.append(device_name)
        else:
            ret_list.append(_retval)

    # And return/raise the composite:
    if len(all_errors) > 1:
        which = '"' + '", "'.join(all_failed_names) + '"'
        raise ChildThreadError(f"'{_func_name}' ({which}) failed:\n" + all_errors.strip())

    # All threads completed:
    print(f"run_parallel: {_func_name} complete. results={ret_list}")
    return ret_list


class ChildThreadError(Exception):
    """One or more child threads raised exceptions."""

    def __init__(self, msg):
        self.msg = msg


def _determine_function_name(function):
    function_name = str(function)
    if type(function) == partial:
        function = function.func
    if hasattr(function, "func_name"):
        function_name = function.func_name
    elif hasattr(function, "__name__"):
        function_name = function.__name__
    return function_name


def run_command(cmd: list):
    print("TODO: run_command() is under development")
    # Issue: Some forms of Popen hang the debugger (possibly stdout used internally)
    # The intent here is to provide a consistent, 'debugger safe' way of running commands.
    try:
        cp = subprocess.run(cmd, stdout=PIPE, text=True)
        # print(f"Command {cmd} returned code {cp.returncode}, stdout={cp.stdout}")
        return cp.returncode, cp.stdout
    except Exception as e:
        # print(f"Exception: {e}")
        return -1, f"Exception: {e}"


#
# Configuration access:
#
def is_norden_console(device):
    # TODO: Move this to globals module for import sanity and to avoid circular imports
    # Similar to common.is_touch_console(), but used for APK selection.
    #   (These model names cannot be added to common.is_norden() because of how "console" has been implemented.)
    _model = getconfig_device_model(device)
    b_is_listed = _model in [
        "fresno",
        "yakima",
        "lansing",
        "dallas",
        "sequim",
        "pittsford",
        "denver",
        "athens",
        "tempe",
        "wrangell",
        "fremont",
    ]
    print(f"{device}: '{_model}' is_norden_console: {b_is_listed}")
    return b_is_listed


def getconfig_value(value_name):
    if "config" not in globals():
        raise AssertionError("Fatal: 'config' is missing!")
    if value_name not in config:
        raise ValueError(f"Config error: '{value_name}' in not defined")
    return config[value_name]


def getconfig_common_caps():
    return getconfig_value("common_desired_caps")


def getconfig_caps_value(value_name: str):
    _caps_key = "common_desired_caps"
    _caps = getconfig_value(_caps_key)

    # Sanity check:
    if not isinstance(_caps, dict):
        raise AssertionError(f"Config error: '{_caps_key}' is not a dictionary")

    # Like Appium, allow "appium:[value_name]" OR just "[value_name]"
    if value_name in _caps:
        return _caps[value_name]

    # Not found, try without any leading "appium:...":
    if value_name.startswith("appium:"):
        value_name_shortened = value_name.split(":", 2)[1]
        if value_name_shortened in _caps:
            return _caps[value_name_shortened]
        raise ValueError(
            f"Config error: '{_caps_key}' does not not define either '{value_name}' or '{value_name_shortened}' values"
        )

    raise ValueError(f"Config error: '{_caps_key}' does not not define '{value_name}' value")


def getconfig_teams_app_activity():
    return getconfig_caps_value("appActivity")


def getconfig_teams_app_package():
    return getconfig_caps_value("appPackage")


def getconfig_optional_intent_args():
    return getconfig_caps_value("appium:optionalIntentArguments")


def getconfig_all_devices_by_class(class_list) -> list:
    if "config" not in globals():
        raise AssertionError("Fatal: 'config' is missing!")
    class_list = make_list(class_list)
    _ret_list = []
    for cls in class_list:
        if cls in config:
            _ret_list.extend(list(config[cls].keys()))
    return _ret_list


def getconfig_all_device_names():
    _devices_names = getconfig_all_devices_by_class(["devices", "consoles"])
    return _devices_names


def getconfig_is_device_defined(device: str) -> bool:
    # Returns True if the specified device is defined, else False
    try:
        _device_name, _acct_name = decode_device_specifier(device)
    except ValueError:
        return False
    _device_class = getconfig_device_class(_device_name)
    return _acct_name in config[_device_class][_device_name]


def getconfig_trim_to_configured_devices(device_list: list[str]) -> list[str]:
    # Given a list of devices, return a list of only the devices which are actually configured.
    device_list = make_list(device_list)
    _defined_list = [device for device in device_list if getconfig_is_device_defined(device)]
    if _defined_list != device_list:
        print("NOTE Not all specified devices were configured.")
        print(f"Trimmed {device_list}\nTo: {_defined_list}")
    else:
        print("All devices defined.")

    if not _defined_list:
        raise AssertionError(f"No specified devices were configured!: {device_list}")

    return _defined_list


def make_list(what) -> list:
    # Helper method - always return a list
    if not what:
        return []
    if isinstance(what, list):
        return what
    if isinstance(what, str):
        return what.split(",")
    raise AssertionError(f"make_list: Unexpected type: {type(what).__name__}")


def encode_devices_and_accounts(device_list, acct_list) -> str:
    # - The default user is the "user" credentials from config.json
    # - if a device has another user signed in, that user is signed-out and the specified user is signed in.
    # - if there is no user signed in, the specified user is signed in.
    # Parameters:
    #     device_list = comma separated list of encoded "device name":"account type" specifiers.
    # Parameters (legacy):
    #     device_list = comma separated list of (unencoded) "device name" specifiers.
    #     user_list = comma separated list of (unencoded) "account type" specifiers.

    if not device_list and not acct_list:
        raise AssertionError("make_encoded_device_list: No devices OR user types specified")

    acct_list = make_list(acct_list)
    device_list = make_list(device_list)

    # For compatibility with legacy parameters, an empty 'device_list' means all "devices" from config.
    # NOT RECOMMENDED - prevents "consoles" and "browsers"
    if not device_list or len(device_list) < len(acct_list):
        device_list = []
        _all_devices = getconfig_all_devices_by_class(["devices"])

        for ndx in range(0, len(acct_list)):
            try:
                device_list.append(_all_devices[ndx])
            except IndexError:
                print(
                    f"Warning: Insuffient 'devices': user_list specifies {len(acct_list)}, but only {len(_all_devices)} are configured"
                )
                break

    return encode_device_specifier(device_list, acct_list)


def encode_device_specifier(devices, accounts) -> str:
    """
    This method encodes to a string '[device name]:[account type]'.
    Input: 'devices' and 'accounttypes' may be None, lists or comma separated string value.
    Output: a single string (possibly containing multiple, comma separated. encodings)
    """

    if not devices and not accounts:
        raise AssertionError("Cannot encode - no devices or account types specified")

    _devlist = make_list(devices)
    _acctlist = make_list(accounts)

    if len(_devlist) < len(_acctlist):
        print(f"Devices: {_devlist}, Accounts: {_acctlist}")
        raise ValueError(
            f"Cannot encode - {len(_acctlist)} account types specified, but only {len(_devlist)} specified"
        )
    else:
        # Set defaults:
        while len(_acctlist) < len(_devlist):
            _acctlist.append("user")

    _encoded_list = ""
    for name, acct in zip(_devlist, _acctlist):
        # if the name was already encoded, use it instead of the default
        _name_pieces = str(name).split(":", 2)
        if len(_name_pieces) > 1:
            acct = _name_pieces[1]
            name = _name_pieces[0]

        if _encoded_list:
            _encoded_list += f",{name}:{acct}"
        else:
            _encoded_list = f"{name}:{acct}"
    # print(f"From devices: {devices}, accounttypes {accounts}, List is: '{_encoded_list}'")
    return _encoded_list


def decode_device_specifier(device):
    """
    This method decodes a 'device' specifier.
    Any device specifier can be encoded as '[device name]:[account type]'.
    If not specified, the default account type is 'user'.
    It returns device name and account type.
    """
    if type(device) != str:
        raise AssertionError(f"'{device}' is not a str type")

    _pieces = device.split(":", 2)

    device_name = _pieces[0]

    if len(_pieces) > 1:
        account_type = _pieces[1]
    else:
        account_type = "user"

    # Sanity checks, test for KeyError:
    devices = getconfig_device_class(device_name)

    if device_name not in config[devices]:
        raise ValueError(f"Config error: referenced device: '{device_name}' in not defined")
    if account_type not in config[devices][device_name]:
        raise ValueError(f"Config error: device '{device_name}' has no '{account_type}' defined")

    return device_name, account_type


def getconfig_device_class(device_name):
    device_name = device_name.split(":", 2)[0]

    if device_name in config["devices"]:
        return "devices"
    if "consoles" in config and device_name in config["consoles"]:
        return "consoles"
    if "browsers" in config and device_name in config["browsers"]:
        return "browsers"
    raise ValueError(f"Device name '{device_name}' is not configured")


def getconfig_is_console_class(device):
    return getconfig_device_class(device) == "consoles"


# Device account properties:


def get_configured_device_account_property(device, propname):
    device_name, account_type = decode_device_specifier(device)
    devices = getconfig_device_class(device)
    if account_type not in config[devices][device_name]:
        raise ValueError(f"{device_name}: Config has no '{account_type}' defined  for '{devices}/{device_name}'")
    if propname not in config[devices][device_name][account_type]:
        raise ValueError(
            f"{device_name}: Config has no '{propname}' defined  for '{devices}/{device_name}/{account_type}'"
        )
    return config[devices][device_name][account_type][propname]


def getconfig_displayname(device):
    return get_configured_device_account_property(device, "displayname")


def getconfig_phonenumber(device):
    return get_configured_device_account_property(device, "phonenumber")


def getconfig_pstndisplay(device):
    return get_configured_device_account_property(device, "pstndisplay")


def getconfig_extention_number(device):
    return get_configured_device_account_property(device, "extension")


def getconfig_username(device):
    return get_configured_device_account_property(device, "username")


# Device properties:
def get_configured_device_property(device, propname):
    device_name, _ = decode_device_specifier(device)
    devices = getconfig_device_class(device_name)
    if propname not in config[devices][device_name]:
        raise ValueError(f"{device_name}: Config has no '{propname}' defined  for '{devices}/{device_name}'")
    return config[devices][device_name][propname]


def getconfig_device_port(device):
    return get_configured_device_property(device, "port")


def getconfig_admin_credentials(device):
    _name = get_configured_device_property(device, "admin_username")
    _pw = get_configured_device_property(device, "admin_password")
    return _name, _pw


def getconfig_device_model(device):
    return get_configured_device_property(device, "model").lower()


def getconfig_device_serial_number(device):
    return get_configured_device_property(device, "serial_number").lower()


def getconfig_device_oem(device):
    return get_configured_device_property(device, "oem").lower()


def getconfig_device_emergency_location(device):
    return get_configured_device_property(device, "emergency_location")


def getconfig_device_caps(device):
    return get_configured_device_property(device, "desired_caps")


def getconfig_device_udid(device):
    device_name, _ = decode_device_specifier(device)
    devices = getconfig_device_class(device_name)
    return config[devices][device_name]["desired_caps"]["udid"]


def getconfig_is_emulator(device):
    return getconfig_device_udid(device).lower().startswith("emulator")


def getconfig_device_rtt_msg(device):
    return get_configured_device_account_property(device, "rtt_text_data")


def getconfig_device_phone_password(device):
    return get_configured_device_property(device, "phone_screen_lock_password")


def getconfig_device_camera_name(device, camera_type="default"):
    camera_type = camera_type.lower()
    _cameras = get_configured_device_property(device, "camera")
    if not isinstance(_cameras, dict):
        raise ValueError(f"{device}: Config has no 'camera' dictionary defined, found '{_cameras}'")
    if not camera_type in _cameras:
        raise ValueError(f"{device}: Config has no '{camera_type}' defined in '{_cameras}'")
    _camera_name = str(_cameras[camera_type])
    return _camera_name


def getconfig_nickname_displayname(device):
    return get_configured_device_account_property(device, "nickname_displayname")


def getconfig_cq_no(device):
    """
    Returns the CQ number for the specified in config

    """
    cq_no = "cq_no"
    return getconfig_value(cq_no)


def getconfig_account_credentials(device):
    user_name = get_configured_device_account_property(device, "username")
    user_password = get_configured_device_account_property(device, "password")
    return user_name, user_password
