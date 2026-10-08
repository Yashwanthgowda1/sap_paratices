import platform
import time
import traceback
import subprocess
from threading import Lock
from subprocess import CalledProcessError, TimeoutExpired, PIPE

from Libraries import shared_utils
from Libraries.shared_utils import print
from Libraries.shared_utils import (
    sleep_with_msg,
    getconfig_is_emulator,
    getconfig_device_udid,
    getconfig_teams_app_package,
    getconfig_teams_app_activity,
    getconfig_optional_intent_args,
    getconfig_device_port,
    getconfig_device_model,
    getconfig_device_oem,
    is_norden_console,
)

adb_connect_lock = Lock()


def ts_print(*args):
    # Prepend UTC timestamp to 'args' and output with flush after write:
    print(time.strftime("%Y-%m-%d %H:%M:%S UTC ", time.gmtime()), *args, flush=True)


def print_exception(context, device_name=None):
    if device_name is None:
        ts_print(f"{context}: {traceback.format_exc()}")
    else:
        ts_print(f"{device_name}: {context}: {traceback.format_exc()}")


def connect_device(device_name: str, config: dict):
    _udid = getconfig_device_udid(device_name)
    ts_print(f"{device_name}: ADB connect_device, udid={_udid}...")
    if _udid.startswith("emulator"):
        return

    # ts_print(f"{device_name}: connect with: {cmd_connect}")
    cmd_connect = ["adb", "connect", _udid]
    try:
        with adb_connect_lock:
            _result = subprocess.run(
                cmd_connect,
                check=True,
                shell=True,
                capture_output=True,  # Will not work under debugger - TODO
                text=True,
                timeout=float(10),
            )
    except CalledProcessError as cpe:
        raise AssertionError(
            f"{device_name}: ADB command '{cmd_connect}' failed, CPE {cpe.returncode}, {cpe.stderr}:{cpe.stdout}"
        ) from cpe
    except Exception as e:
        ts_print(f"{device_name}: ADB connect_device failed: {e}...")
        raise

    # This will also 'fail' if the device is connected but 'offline':
    #   Every time the adb server sends a command to the adbd daemon on a device it expects a
    #   response. If it does not get the response within allotted time limit (~3 seconds) ADB
    #   marks the device 'offline', but does not set a failed return code.
    #
    #   The timeouts can be caused by many different software and or hardware problems on the device and the host system itself.
    #
    # If so, command result contains "failed to connect to xx.xx.xx.xx:5555"
    # Also, cannot connect to xx.xx.xx.xx:5555: No connection could be made because the target machine actively refused it. (10061)
    if "failed" in _result.stdout.lower() or "cannot connect" in _result.stdout.lower():
        ts_print(f"FATAL: {device_name} ({_udid}) not responding - ADB: {_result.stdout}, {_result.stderr}")
        raise AssertionError(f"{device_name} connect to ({_udid}) failed")

    ts_print(f"{device_name}: ADB connect_device: {_result.stdout}")

    # Additional insurance - make sure the device is not 'offline'
    #   and explicit fail_remove=False to avoid recursion.
    wait_for_device_online(device_name, config, fail_remove=False)

    root_device(device_name, config)

    # Again, make sure the 'root' did not knock the device 'offline'
    wait_for_device_online(device_name, config)


def grant_teams_app_permission(device_name: str, config=None):
    """
    Grants all Teams app permissions to the device. Useful for emulator run
    """
    udid = getconfig_device_udid(device_name)
    app_package = shared_utils.getconfig_teams_app_package()
    all_required_permissions = [
        "android.permission.ACCESS_FINE_LOCATION",
        "android.permission.ACCESS_COARSE_LOCATION",
        "android.permission.READ_PHONE_STATE",
        "android.permission.READ_EXTERNAL_STORAGE",
        "android.permission.WRITE_EXTERNAL_STORAGE",
        "android.permission.CAMERA",
        "android.permission.RECORD_AUDIO",
        "android.permission.READ_CONTACTS",
        "android.permission.BLUETOOTH_CONNECT",
    ]
    for permission in all_required_permissions:
        cmd_grant_permission = [
            "adb",
            "-s",
            udid,
            "shell",
            "pm",
            "grant",
            app_package,
            permission,
        ]
        ts_print(f"{device_name}: Granting permission with: '{cmd_grant_permission}'")
        try:
            _grant_result = subprocess.run(
                cmd_grant_permission,
                text=True,
                stdout=subprocess.PIPE,
                check=True,
                timeout=float(10),
            )
            _result = _grant_result.stdout.strip()
        except TimeoutExpired:
            ts_print(f"{device_name}: WARN: Grant permission result: TimeoutExpired ignored (after 10 secs).")
        except CalledProcessError:
            ts_print(f"{device_name}: WARN: Grant permission result: CalledProcessError ignored.")


def root_device(device_name, config=None):
    # Optional - attempt to root the connection - allows storage info printing

    _udid = getconfig_device_udid(device_name)

    cmd_root = ["adb", "-s", str(_udid), "root"]
    cmd_timeout = float(1 * 60)
    # ts_print(f"{device_name}: root with: {cmd_root}")
    try:
        #
        #   Note: this can cause 'restarting adbd as root' - we need the 'adb_connect_lock' mutex:
        #
        with adb_connect_lock:
            _results = subprocess.run(cmd_root, capture_output=True, encoding="utf-8", timeout=cmd_timeout)
            ts_print(f"{device_name}: 'root' result: '{_results}'")
            if _results.returncode != 0:
                print(f"{device_name}: Failed to 'root' device: returncode={_results.returncode} not 0")
            else:
                sleep_with_msg(device_name, 2, "Allow root activation")

    except CalledProcessError:
        print_exception("'root' failed result", device_name)
    except TimeoutExpired:
        ts_print(f"{device_name}: 'root' result: TimeoutExpired(after {cmd_timeout} secs).")


def disconnect_device(device_name: str, config: dict):
    _udid = getconfig_device_udid(device_name)
    ts_print(f"{device_name}: disconnect_device, udid={_udid}")

    cmd_disconnect = ["adb", "disconnect", str(_udid)]
    ts_print(f"{device_name}: disonnect with: {cmd_disconnect}")
    with adb_connect_lock:
        _results = subprocess.run(cmd_disconnect, capture_output=True, encoding="utf-8", check=True, shell=True)
        sleep_with_msg(device_name, 2, "disconnect_device")
    ts_print(f"{device_name}: disconnect result: '{_results}'")


def ping_device(device_name: str, config: dict, max_pings=10):
    udid = getconfig_device_udid(device_name)
    if udid.count(".") != 3:
        ts_print(f"{device_name}: '{udid}' doesn't appear to be an IP address, ping skipped.")
        return
    just_ip = udid.split(":")[0]

    # Option for the number of packets as a function of OS
    param = "-n" if platform.system().lower() == "windows" else "-c"

    inter_ping_sleep = 3

    cmd_ping = ["ping", param, "1", just_ip]
    for attempt in range(1, max_pings + 1):
        try:
            response = subprocess.check_output(cmd_ping, text=True, stderr=PIPE)
            # For Windows
            if f"Reply from {just_ip}" in response:
                break
            # For Linux/Mac
            if f"bytes from {just_ip}" in response:
                break
        except CalledProcessError as pingFail:
            # Ignore, but report
            if "timed out" in pingFail.output:
                ts_print(f"{device_name}: ping_device {just_ip}: Request timed out.")
            else:
                ts_print(f"{device_name}: ping_device {just_ip}: {str(pingFail.output).strip()}")
        sleep_with_msg(device_name, inter_ping_sleep, "ping_device > inter_ping_sleep")

    if attempt == max_pings:
        raise AssertionError(f"{device_name} (ping {just_ip}): did not respond after {str(attempt)} attempts.")

    ts_print(f"{device_name}: ping {just_ip} responded after {str(attempt)} of {str(max_pings)} attempts.")

    if attempt > 1:
        # Newly responding: Wait a bit more, a 'root' connect will be honored, even
        # if the device is not fully up:
        post_ping_sleep = 15
        ts_print(f"{device_name}: Newly responding to ping, sleeping an additional {str(post_ping_sleep)}.")
        sleep_with_msg(device_name, post_ping_sleep, "ping_device > post_ping_sleep")


def reboot_device(device_name: str, config: dict):
    _udid = getconfig_device_udid(device_name)
    ts_print(f"{device_name}: reboot_device, udid={_udid}")

    cmd_reboot = ["adb", "-s", str(_udid), "reboot"]
    # ts_print(f"{device_name}: reboot with: '{cmd_reboot}'")
    try:
        # Note short timeout - device connection sometimes hangs, and we want to begin
        # pinging it before it is ready to respond.
        subprocess.run(cmd_reboot, capture_output=True, text=True, check=True, timeout=float(10))
        time.sleep(2)
    except TimeoutExpired:
        # Assuming this is ok - the socket does not always close even when the device is rebooting.
        ts_print(f"{device_name}: reboot - 'TimeoutExpired'")

    if getconfig_is_emulator(device_name):
        print(f"{device_name}: is an emulator, skip offline transition and ping.")
        wait_for_device_online(device_name, config, fail_remove=False)
    else:
        # Wait for adb to report the device is 'offline'
        wait_for_device_offline(device_name, config)

        # Wait for the device to respond to 'ping'
        ping_device(device_name, config, max_pings=40)

        # Now wait for ADB to re-establish with this device:
        # If the device does not re-establish, explicitly reconnect it ('fail_remove=True'). Some devices
        # will forcably close the connection on reboot, preventing ADB from re-establishing.
        _max_attempts = int(60 * 2)
        if is_norden_console(device_name):
            _max_attempts = int(60 * 3)
        wait_for_device_online(device_name, config, max_attempts=_max_attempts, fail_remove=True)

        # Some devices will accept 'root' before they are able to honor it.
        # They might still be starting up.
        sleep_with_msg(device_name, 5, "reboot reactions")

    # Here, we know the device was rebooted and lost the 'root', device may transition to/from offline.
    root_device(device_name, config)
    wait_for_device_online(device_name, config)


def get_adb_devices_output(device_name) -> list:
    cmd_devices = ["adb", "devices", "-l"]
    try:
        _result = subprocess.run(cmd_devices, capture_output=True, text=True, check=True)
    except CalledProcessError as cpe:
        print(f"CPE on 'adb devices', rc:{cpe.returncode}, output:{cpe.output}")
        raise
    _ret = _result.stdout.splitlines(keepends=False)
    # ts_print(f"{device_name}: Adb output: {_ret}")
    return _ret


def wait_for_device_offline(device_name: str, config: dict, max_attempts=30):
    #
    # Wait for ADB to report the device as 'offline'.
    #   Typically ADB reports the device 'offline' when the device
    #   fails to report a heartbeat/response for 3 seconds.
    #
    ts_print(f"{device_name}: wait_for_device_offline...")

    _udid = getconfig_device_udid(device_name)
    for attempt in range(1, max_attempts + 1):
        try:
            _lines = get_adb_devices_output(device_name)
        except CalledProcessError:
            sleep_with_msg(device_name, 2, f"Failed attempt {attempt} of {max_attempts} wait_for_device_offline retry")
            # Attempt to continue
            continue
        for _line in _lines:
            _words = _line.split()
            if _udid in _words:
                if _words[1] == "offline":
                    ts_print(f"{device_name}: offline with '{_line.strip()}'")
                    ts_print(f"{device_name}: offline after {attempt} of {max_attempts} checks")
                    return
                if _words[1] != "device":
                    ts_print(f"WARNING: {device_name}: Unexpected device state is '{_words[1]}', ignored.")
        time.sleep(1)
    raise AssertionError(f"{device_name}: NOT OFFLINE after {max_attempts} attempts.")


def wait_for_device_removed(device_name: str, config: dict, max_attempts=30):
    #
    # Wait for ADB to stop reporting the device.
    #   Typically ADB stops reporting the device several seconds after a 'reconnect' command is issued.
    #
    ts_print(f"{device_name}: wait_for_device_removed...")

    _udid = getconfig_device_udid(device_name)
    for attempt in range(1, max_attempts + 1):
        try:
            _lines = get_adb_devices_output(device_name)
        except CalledProcessError:
            sleep_with_msg(device_name, 2, f"Failed attempt {attempt} of {max_attempts} wait_for_device_removed retry")
            # Attempt to continue
            continue
        _found = False

        for _line in _lines:
            _words = _line.split()
            if _udid in _words:
                _found = True
                ts_print(f"{device_name}: still present with '{_line.strip()}'")
                break
        if not _found:
            ts_print(f"{device_name}: removed after {attempt} of {max_attempts} checks")
            return
        time.sleep(1)
    raise AssertionError(f"{device_name}: NOT REMOVED after {max_attempts} attempts.")


def wait_for_device_online(device_name: str, config: dict, max_attempts=120, newly_online_sleep=30, fail_remove=True):
    #
    # Wait for ADB to report the device as 'device' (online/connected).
    #   Typically ADB reports the device 'offline' when the device
    #   fails to report a heartbeat/response for 3 seconds.
    #
    # NOTE: If the device is not reported at all, it is treated as offline, and
    #   the loop will eventually exit to raise or reconnect.
    #
    ts_print(f"{device_name}: wait_for_device_online...")

    _udid = getconfig_device_udid(device_name)
    for attempt in range(1, max_attempts + 1):
        # print(f"Attempt {attempt}...")
        try:
            _lines = get_adb_devices_output(device_name)
        except CalledProcessError:
            sleep_with_msg(device_name, 2, f"Failed attempt {attempt} of {max_attempts} wait_for_device_online retry")
            # Attempt to continue
            continue
        for _line in _lines:
            _words = _line.split()
            if _udid in _words:
                if _words[1] == "device":
                    ts_print(f"{device_name}: online with '{_line.strip()}'")
                    ts_print(f"{device_name}: online after {attempt} of {max_attempts} checks")
                    if attempt > 1:
                        ts_print(f"{device_name}: newly online, sleeping an extra {newly_online_sleep} seconds.")
                        sleep_with_msg(device_name, newly_online_sleep, "wait_for_device_online > newly_online_sleep")
                    return
                if _words[1] != "offline":
                    ts_print(f"WARNING: {device_name}: Unexpected device state is '{_words[1]}', ignored.")
        time.sleep(1)

    if not fail_remove:
        raise AssertionError(f"{device_name}: NOT ONLINE after {max_attempts} attempts.")

    # The offline-device transition did not happen.
    # Try to get ADB to forget about the device, and re-connect it.
    ts_print(f"{device_name}: WARNING Not on-line, attempt to remove from ADB/ADBD")

    # Try 1: "reconnect offline" - reset offline/unauthorized devices to force reconnect
    # Seen 1/10 - "adb -s [udid] reconnect offline" leaves offline device (x30) present for 20 seconds.
    cmd_kick_device = ["adb", "-s", str(_udid), "reconnect", "offline"]

    # Try 2: "reconnect" - kick connection from host side to force reconnect
    cmd_kick_device = ["adb", "-s", str(_udid), "reconnect"]

    subprocess.run(
        cmd_kick_device,
        text=True,
        stdout=subprocess.PIPE,
        check=True,
        timeout=10,
    )
    wait_for_device_removed(device_name, config)
    sleep_with_msg(device_name, 5, "removed, delay before reconnect attempt")
    connect_device(device_name, config)


def is_app_installed(device_name, app_name):
    _udid = getconfig_device_udid(device_name)

    # Note: the following gets all packages, we could limit to just *microsoft* packages with:
    # "shell pm list packages microsoft":
    cmd_get_installed_packages = ["adb", "-s", str(_udid), "shell", "pm", "list", "packages"]
    _installed_packages = subprocess.check_output(cmd_get_installed_packages, text=True, timeout=float(10))

    return app_name in _installed_packages


def uninstall_app(device_name: str, app_name: str):
    """
    Unconditionally attempt to uninstall the indicated app_name
    """
    _udid = getconfig_device_udid(device_name)
    _max_uninstall_time = float(1 * 60)
    cmd_uninstall = ["adb", "-s", str(_udid), "uninstall", app_name]
    # ts_print(f"{device_name}: Uninstalling with: '{cmd_uninstall}'")
    try:
        _uninstall_result = subprocess.run(
            cmd_uninstall,
            text=True,
            stdout=subprocess.PIPE,
            check=True,
            timeout=_max_uninstall_time,
        )
        _result = _uninstall_result.stdout.strip()
        if "fail" in _result.lower():
            # Note - ignored: Uninstall result: Failure [DELETE_FAILED_DEVICE_POLICY_MANAGER]
            ts_print(f"{device_name}: WARN: Ignoring failure: Uninstall result: {_result}")
        else:
            ts_print(f"{device_name}: Uninstall result: {_result}")
        return True
    except TimeoutExpired:
        ts_print(f"{device_name}: WARN: Uninstall result: TimeoutExpired ignored (after {_max_uninstall_time} secs).")
        return True
    except:
        print_exception("ERROR: Uninstall failed", device_name)
    return False


def storage_percent_in_use(device_name):
    # Return the percentage of storage-in-use on the device (0-100).
    # Return None if not rooted or unparsible.
    _udid = getconfig_device_udid(device_name)
    cmd_storage_request = ["adb", "-s", str(_udid), "shell", "df", "/sdcard"]

    try:
        storage_response = subprocess.run(cmd_storage_request, capture_output=True, text=True, timeout=5.0)
    except subprocess.CalledProcessError as e:
        print(f"{device_name}: Failed to get device storage info: {e}")
        return None
    except subprocess.TimeoutExpired as te:
        print(f"{device_name}: Failed to get device storage info: Timeout: {te}")
        return None
    if storage_response.returncode != 0:
        print(f"{device_name}: Failed to get device storage info: rc not 0: {storage_response}")
        return None
    if not storage_response.stdout:
        ts_print(f"{device_name}: Failed to get device storage info: No output received.")
        return None

    # Expecting:
    # 'Filesystem     1K-blocks   Used Available Use% Mounted on'
    # '/dev/fuse        3094448 562196   2532252  19% /storage/emulated'
    #
    if not "Mounted" in storage_response.stdout:
        ts_print(
            f"{device_name}: Cannot fetch storage information - root verification failed with '{storage_response.stdout.strip()}'."
        )
        return None

    _lines = storage_response.stdout.splitlines()
    if len(_lines) < 2:
        ts_print(f"{device_name}: Cannot fetch storage information - unknown format: {_lines}.")
        return None

    _fields = _lines[1].split()
    if len(_fields) < 5:
        ts_print(f"{device_name}: Cannot fetch storage information - insufficient fields: {_fields}.")
        return None

    # Just FYI: available blocks
    try:
        _available_blocks = int(_fields[3])
        ts_print(f"{device_name}: INFO: {_available_blocks} 1k-blocks available.")
    except:
        ts_print(f"{device_name}: Cannot fetch 'blocks available' - was reported #3 in: {_fields}.")

    try:
        _in_use = int(_fields[4][0:-1])
        ts_print(f"{device_name}: INFO: Storage {_in_use}% in-use ({100-_in_use}% available).")
        return _in_use
    except:
        ts_print(f"{device_name}: Cannot fetch 'percent in use' - was reported #4 in: {_fields}.")

    return None


def install_with_retry(
    device_name: str,
    config: dict,
    app_name: str,
    apk_file: str,
    replace_ok: bool = False,
    attempts: int = 3,
):
    _udid = getconfig_device_udid(device_name)

    ts_print(f"{device_name}: Installing app '{app_name}' from APK file: {apk_file}")
    _max_install_time = float(10 * 60)

    _install_flags = ["-r", "-d"] if replace_ok else ["-g", "-d"]

    for attempt in range(attempts):
        ts_print(f"{device_name}: Install attempt: {attempt+1} of {attempts}")
        _ready_for_install = False

        if is_app_installed(device_name, app_name):
            ts_print(f"{device_name}: App is installed: {app_name}")
            if replace_ok:
                ts_print(f"{device_name}: App will be replaced.")
                _ready_for_install = True
            else:
                _ready_for_install = uninstall_app(device_name, app_name)
        else:
            ts_print(f"{device_name}: App not installed: {app_name}")
            _ready_for_install = True

        if _ready_for_install:
            cmd_install = ["adb", "-s", str(_udid), "install"] + _install_flags + [apk_file]
            ts_print(f"{device_name}: Installing with: '{cmd_install}'")
            try:
                _install_result = subprocess.run(
                    cmd_install,
                    text=True,
                    stdout=subprocess.PIPE,
                    check=True,
                    timeout=_max_install_time,
                )
                ts_print(f"{device_name}: Install result: {_install_result.stdout.strip()}")
                return True
            except TimeoutExpired:
                ts_print(f"{device_name}: ERROR: Install result: TimeoutExpired(after {_max_install_time} secs).")
            except:
                print_exception("ERROR: Install failed", device_name)
        if attempt == attempts - 1:
            # final failure, no more retries:
            break
        #
        # Issue: Here, the install failed - Have seen ADB report the device 'offline'
        #
        wait_for_device_online(device_name, config)

        if replace_ok:
            ts_print(f"{device_name}: Next attempt will force uninstall")
            replace_ok = False
        reboot_device(device_name, config)

    ts_print(f"{device_name}: FATAL: Install failed")
    return False


def is_Teams_running_on_device(device_name):
    _udid = getconfig_device_udid(device_name)
    _teams_appname = getconfig_teams_app_package()
    cmd_teams_pid = [
        "adb",
        "-s",
        str(_udid),
        "shell",
        "pidof",
        _teams_appname,
    ]
    try:
        _result = subprocess.check_output(cmd_teams_pid, text=True).strip()
        print(f"{device_name}: Pid of Teams is {_result}")
        if len(_result) < 2:
            return False
        return True
    except subprocess.CalledProcessError as e:
        print(f"{device_name}: Failed to get PID of Teams: {e}")
        return False


def start_Teams_on_device(device_name, sleep_after=20):
    _udid = getconfig_device_udid(device_name)
    _teams_app_package = getconfig_teams_app_package()
    _teams_app_activity = getconfig_teams_app_activity()
    _optional_intent_args = getconfig_optional_intent_args()

    cmd_teams_start = [
        "adb",
        "-s",
        str(_udid),
        "shell",
        "am",
        "start",
        "-W",
        "-n",
        f"{_teams_app_package}/{_teams_app_activity}",
        "-S",
        "-a",
        "android.intent.action.MAIN",
        "-c",
        "android.intent.category.LAUNCHER",
        "-f",
        "0x10200000",
    ]
    cmd_teams_start.extend(_optional_intent_args.split())
    print(f"{device_name}: Starting Teams with '{cmd_teams_start}'")

    _result = subprocess.check_output(cmd_teams_start, text=True).strip()
    sleep_with_msg(device_name, sleep_after, "Allow Teams Startup")
    print(f"{device_name}: Started Teams")


def reset_Teams_app(device_name: str, config: dict = None, apps: list = None, timeout_is_fatal=False):
    """
    This method returns the Teams app to 'signed out' login screen.
    """
    if getconfig_is_emulator(device_name):
        #
        # Here, although Teams is installed on this device, it might not be active.
        #   For emulators - we do not know what state the emulator was 'saved' in. Although
        #   Appium will later force Teams to be running, but we need it now to handle the SIGN_OUT_ACCOUNT.
        #
        if is_Teams_running_on_device(device_name):
            print(f"{device_name}: Teams is running")
        else:
            print(f"{device_name}: Teams is NOT running, attempting to start it")
            start_Teams_on_device(device_name)

    # Broadcast signout
    _udid = getconfig_device_udid(device_name)
    cmd_b_signout = [
        "adb",
        "-s",
        str(_udid),
        "shell",
        "am",
        "broadcast",
        "-n",
        "com.microsoft.skype.teams.ipphone/.IpPhoneBroadcastReceiver",
        "-a",
        "com.microsoft.skype.teams.ipphone.partner.SIGN_OUT_ACCOUNT",
    ]

    try:
        _result = subprocess.run(
            cmd_b_signout,
            text=True,
            capture_output=True,
            check=True,
            timeout=10.0,
        )
    except CalledProcessError as cpe:
        raise AssertionError(
            f"{device_name}: Broadcast signout failed, CPE {cpe.returncode}, {cpe.stderr}:{cpe.stdout}"
        )
    except subprocess.TimeoutExpired as te:
        if timeout_is_fatal:
            raise
        print(
            f"{device_name}: WARNING: Ignoring Broadcast signout 'TimeoutExpired' error. Timeout={te.timeout}, Output={te.stderr}:{te.stdout}"
        )
        return

    # This should never fire because run has 'check=True':
    if not _result.returncode == 0:
        raise AssertionError(
            f"{device_name}: Broadcast signout failed rc={_result.returncode}, {_result.stderr}:{_result.stdout}"
        )

    # TODO - instead of sleeping, we could use ADB to poll for the splash screen appearance
    _sleep_post_signout = 25
    if getconfig_is_emulator(device_name):
        _sleep_post_signout = 10
    if shared_utils.getconfig_device_class(device_name) == "consoles":
        _sleep_post_signout = 90
    sleep_with_msg(device_name, _sleep_post_signout, "After broadcast SIGN_OUT_ACCOUNT")

    # Issue: ADB reports the device as 'offline'
    root_device(device_name)


def get_device_property(device_name: str, prop_name: str):
    _udid = getconfig_device_udid(device_name)
    cmd_getprop = ["adb", "-s", str(_udid), "shell", "getprop", prop_name]
    _result = subprocess.run(
        cmd_getprop,
        text=True,
        capture_output=True,
        check=True,
        timeout=5.0,
    )
    return _result.stdout.strip()


def print_device_info(device_name: str, config: dict):
    # _device = get_device_property(device_name, "ro.product.device")
    _manufacturer = get_device_property(device_name, "ro.product.manufacturer")
    _model = get_device_property(device_name, "ro.product.model")
    _build = get_device_property(device_name, "ro.build.id")
    _version_firmware = get_device_property(device_name, "persist.product.version")
    _version_hardware = get_device_property(device_name, "hwversion")
    _mac = get_device_property(device_name, "persist.net.wifi.wlan_mac")
    if _mac == "":
        # device dependency, try model "riverside" location
        _mac = get_device_property(device_name, "persist.net.bt.mac")

    # TODO: report Teams version?
    # filter_tool = get_shell_filter_tool()
    # teams_version_command = [
    #     "adb",
    #     "-s",
    #     str(_udid),
    #     "shell",
    #     "dumpsys",
    #     "package",
    #     "com.microsoft.skype.teams.ipphone",
    #     "|",
    #     filter_tool,
    #     "versionName",
    # ]
    # teams_version = subprocess.check_output(teams_version_command, shell=is_windows())
    # print("Teams version : ", teams_version)

    ts_print(f"{device_name}: INFO: device is {_manufacturer}, {_model}, Build Id: {_build}.")
    ts_print(f"{device_name}: INFO: Firmware version:'{_version_firmware}', Build Id: {_build}.")
    ts_print(f"{device_name}: INFO: Hardware version: '{_version_hardware}', MAC: {_mac}.")

    _config_oem = getconfig_device_oem(device_name)
    _config_model = getconfig_device_model(device_name)
    _config_port = getconfig_device_port(device_name)
    ts_print(
        f"{device_name}: INFO: device is configured for port '{_config_port}' and as oem='{_config_oem}', model='{_config_model}'."
    )


####
#    Playground/standalone tests - go crazy...
####
if __name__ == "__main__":
    ############################################################
    # Adjust PYTHONPATH to allow imports relative to this file
    import os
    import sys

    ABS_DOT_DOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    if ABS_DOT_DOT_DIR not in sys.path:
        sys.path.append(os.path.join(ABS_DOT_DOT_DIR))
    #
    ############################################################

    ############################################################
    # Load the configuration
    from configure_devices import load_json_file

    try:
        # Note: Using default/real configuration - "../config.json"
        cfg = load_json_file(ABS_DOT_DOT_DIR + "/config.json")
    except:
        print_exception("While loading config.json")
        exit(1)
    #
    ############################################################

    def some_test(a_config: dict):
        # Examples:
        #   print_device_info("device_1", a_config)
        #   wait_for_device_online("device_1", a_config)
        #   reboot_device("device_2", a_config)
        # And something harmless:
        ts_print("This is an example of a 'ts_print' timestamped message.")

    some_test(cfg)
