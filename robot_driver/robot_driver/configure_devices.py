import glob
import sys
import os
import subprocess
from subprocess import CalledProcessError, PIPE
import time
import json
from collections import OrderedDict
import argparse
from argparse import RawTextHelpFormatter
import shutil
from datetime import datetime
from Libraries import shared_utils

MODULE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(MODULE_DIR))
sys.path.append(os.path.join(MODULE_DIR, "Libraries"))
sys.path.append(os.path.join(MODULE_DIR, "resources", "keywords"))

from Libraries.shared_utils import (
    get_configured_device_property,
    getconfig_is_emulator,
    getconfig_all_device_names,
    is_norden_console,
    getconfig_device_udid,
)
from resources.keywords.common import is_norden, is_panel, is_phone
from Libraries.device_control import (
    reset_Teams_app,
    connect_device,
    ping_device,
    ts_print,
    print_exception,
    print_device_info,
    reboot_device,
    storage_percent_in_use,
    install_with_retry,
    wait_for_device_online,
    is_app_installed,
)

# Setup flow:
#   initialize:
#       sanity checks: arguments, environment, robot config, etc.
#   each device:
#       connect/root
#       reboot
#       clear Teams (sign-out any user)
#       install APKs
#

# Warn if any device reporting storage in use of >= this percentage:
MAX_IN_USE_PERCENT = 80


def parser_util(descr):
    parser = argparse.ArgumentParser(
        fromfile_prefix_chars="@",
        formatter_class=RawTextHelpFormatter,
        description=descr,
    )

    parser.add_argument(
        "--apkdir",
        default=None,
        type=str,
        required=True,
        help="\t\tCanary Teams APKs will be in 'flavor' subdirectories of this directory.\n"
        "\t\tExample: '-apkdir C:\\XX' will expect 'panelRelease' flavor APK to be:\n"
        "\t\t\tC:\\XX\\zipalign-panelRelease\\Microsoft-Teams-2024012301-ARM64.apk'\n\n",
    )

    parser.add_argument(
        "--cp_apk",
        help="\t\tThe Company Portal APK to install\n"
        "\t\tWARNING: This APK will be installed on ALL devices in config.json.\n\n",
    )

    parser.add_argument(
        "--sequential",
        default=False,
        required=False,
        action="store_true",
        help="\t\tIf specified, devices will be sequentially set up (slow, used for debugging).\n\n",
    )

    parser.add_argument(
        "--skipreinstall",
        default=False,
        required=False,
        action="store_true",
        help="\t\tIf specified, APKs will not be re-installed if the\n"
        "\t\tinstalled version matches the APK version.\n\n",
    )
    parser.add_argument(
        "--skipreboot",
        default=False,
        required=False,
        action="store_true",
        help="\t\tIf specified, devices will not be rebooted.\n\n",
    )
    parser.add_argument(
        "--skipclear",
        default=False,
        required=False,
        action="store_true",
        help="\t\tIf specified, SIGN_OUT_ACCOUNT will not be sent to Teams.\n\n",
    )
    parser.add_argument(
        "--allowdebug",
        default=False,
        required=False,
        action="store_true",
        help="\t\tIf specified, Debug artifacts have precedence over Release.\n\n",
    )
    parser.add_argument(
        "--skipinstalls",
        default=None,
        required=False,
        action="store_true",
        help="\t\tIf specified, ALL APK installs are skipped.\n\n",
    )
    parser.add_argument(
        "--mitm",
        default=None,
        required=False,
        action="store_true",
        help="\t\tIf specified, Man-in-the-middle initialization is performed.\n\n",
    )

    return vars(parser.parse_args())


def load_json_file(filename):
    """
    Return the JSON from JSON a file.
    Params:
        filename: The JSON file to open and read.
    """

    def _loadit(fullfilename):
        with open(fullfilename, encoding="utf-8") as reader:
            return json.loads(reader.read(), object_pairs_hook=OrderedDict)

    # Use abspath() so failures show the actual path used.
    fullfilename = os.path.abspath(filename)
    return _loadit(fullfilename)


def find_executable(which, env_dir_vars):
    # First try from path:
    target = shutil.which(which)

    if target:
        # target is in the path:
        return target

    # Search for target, using the environment variables as hints
    for _varname in env_dir_vars:
        if _varname not in os.environ:
            # The variable is not defined:
            continue
        _dirnames = os.environ[_varname].split(";")
        for _dirname in _dirnames:
            if not os.path.isdir(_dirname):
                # The variable is not a directory:
                ts_print(f"Variable '{_varname}' specifies a non-existent directory '{_dirname}', ignored.")
                continue

            # Now search subdirectories for the executable name
            for root, _, files in os.walk(_dirname):
                if which in files:
                    return os.path.join(root, which)
    return None


def get_apk_version(apk_file):
    # """
    # Return the version of the new APK if possible, if not return the APK name as the version.
    # """

    # Set the default version - from the APK name.
    # ASSUMPTION: APK name is in the form of: xxxxxxxxMicrosoftTeams-2023040602.apk, version is the 10 digits before the '.apk':
    apk_version = apk_file[len(apk_file) - 14 : len(apk_file) - 4]

    _aapt_exe = find_executable("aapt.exe", ["ANDROID_SDK_ROOT", "ANDROID_HOME"])

    if not _aapt_exe:
        ts_print("WARNING: Cannot find 'aapt.exe', using APK filename instead.")
    else:
        cmd_get_apk_version1 = f"{_aapt_exe} dump xmltree {apk_file} AndroidManifest.xml"
        cmd_get_apk_version2 = 'findstr /C:"versionName"'

        ts_print(f"Fetch version from APK with: {cmd_get_apk_version1} | {cmd_get_apk_version2}")

        try:
            p1 = subprocess.Popen(cmd_get_apk_version1, text=True, stdout=PIPE)
            p2 = subprocess.Popen(cmd_get_apk_version2, text=True, stdin=p1.stdout, stdout=PIPE)
            p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
            output = p2.communicate()[0].strip()

            if output:
                # Expecting: 'A: android:versionName(0x0101021c)="1449/1.0.94.2023320302" (Raw: "1449/1.0.94.2023320302")'
                ts_print(f"Raw version in APK: {apk_file}: {output}")
                apk_version = output[len(output) - 12 : len(output) - 2]
        except CalledProcessError as cpe:
            ts_print(f"WARNING command failed '{cmd_get_apk_version1}', code: {cpe.returncode} output: {cpe.output}")

    ts_print(f"APK version for '{apk_file}' is: '{apk_version}'")
    return apk_version


def get_installed_version(device_name, app_name):
    _udid = getconfig_device_udid(device_name)

    if not is_app_installed(device_name, app_name):
        return "not installed"

    # Note: packages can also be present as "Hidden". If "Hidden" appears in this
    #   output before we find a "versionName", the package is not installed.
    #   Ignore for now - only seen on very old devices...
    cmd_get_app_version = (
        f'adb -s {_udid} shell "dumpsys package {app_name} | grep -e \\"versionName\\" -e \\"Hidden\\""'
    )
    try:
        device_version_cp = subprocess.run(cmd_get_app_version, stdout=PIPE, stderr=PIPE, text=True, timeout=float(10))
        print(f"{device_name}: Version query returns: {device_version_cp}")
        if device_version_cp.returncode != 0:
            return f"fetch error: rc={device_version_cp.returncode}"

        _lines = str(device_version_cp.stdout).splitlines()

    except CalledProcessError as e:
        print(f"{device_name}: Version query returns failure: {e}")
        return "fetch error"

    if len(_lines) > 0:
        device_version = _lines[0].strip().split("/")

        # Info only: Announce any 'Hidden' versions stamps?
        if len(_lines) > 2:
            xtra_text = "\n\t".join(_lines[1:])
            print(f"{device_name}: INFO: Extra version info returned:\n{xtra_text}")

        # Expecting something like: device_version='    versionName=1449/1.0.94.2023320302' or blank.
        if len(device_version) == 2:
            # - if 'Hidden' is encountered first, the non-hidden version is assumed to be uninstalled.
            device_version = device_version[1].split(".")
            # Compare just the version number '2018121201' with the APK name.
            if len(device_version) > 3:
                return device_version[3]

    print(f"{device_name}: Unexpected Version: {device_version}")
    return "Unexpected device version"


def _main():
    start_time = datetime.now()

    thisArgs = parser_util("configure_devices")
    ts_print(thisArgs)
    ###############
    # Behaviors settings
    #
    # True if we send SIGN_OUT_ACCOUNT to Teams.
    skip_clear = thisArgs["skipclear"]
    #
    # True if we reboot devices before using
    skip_reboot = thisArgs["skipreboot"]
    #
    # True if we skip reinstalling the same APK (versions match)
    skip_reinstall = thisArgs["skipreinstall"]
    #
    ###############

    cp_apk = thisArgs["cp_apk"]
    if cp_apk:
        cp_apk = os.path.abspath(cp_apk)
        ts_print(f"Normalized cp_apk='{cp_apk}'")

    _config_file = "config.json"
    if not os.path.isfile(_config_file):
        ts_print(f"Aborting: Robot configuration file '{_config_file}' missing.")
        sys.exit(1)

    config = load_json_file("config.json")

    # Sanity check config items:
    _cp_app_name = str(config["companyPortal_Package"])
    if _cp_app_name.lower() != "com.microsoft.windowsintune.companyportal":
        ts_print(
            f"Aborting: Robot configuration file '{_config_file}' unexpected 'companyPortal_Package': '{_cp_app_name}'"
        )
        sys.exit(1)

    _teams_app_name = str(config["common_desired_caps"]["appPackage"])
    if _teams_app_name.lower() != "com.microsoft.skype.teams.ipphone":
        ts_print(
            f"Aborting: Robot configuration file '{_config_file}' unexpected '['common_desired_caps']['appPackage']': '{_teams_app_name}'"
        )
        sys.exit(1)

    # Do not print, contains passwords:
    # for device in config["devices"]:
    #     ts_print(f"{device} : {config['devices'][device]}")

    if thisArgs["apkdir"]:
        ts_print(f"Teams APKs will be taken from {thisArgs['apkdir']}.")

    # Company Portal:
    cp_apk_version = None
    if cp_apk is None:
        ts_print("NOTE: No CP APK file specified. Will use existing application.")
    else:
        if not os.path.isfile(cp_apk) or not cp_apk.lower().endswith(".apk"):
            ts_print(f"WARNING: CP APK file '{cp_apk}' is missing or invalid. Will use existing CP application.")
            cp_apk = None
        else:
            if skip_reinstall:
                # Now we need to know what the actual APK version is:
                cp_apk_version = get_apk_version(cp_apk)

    # Force any 'offline' connections to be abandoned:

    ts_print("Explicitly restart ADB server...")
    _result = subprocess.run("adb kill-server", check=True, text=True, capture_output=True)
    time.sleep(2)
    _result = subprocess.run("adb start-server", check=True, text=True, capture_output=True)
    ts_print(f"Restart stdout:{_result.stdout.strip()}")
    ts_print(f"Restart stderr:{_result.stderr.strip()}")
    time.sleep(2)

    _installs = 0  # so we can avoid the final sleep if no installs were performed.

    install_counts = _setup_devices_in_parallel(
        getconfig_all_device_names(),
        config,
        skip_clear,
        skip_reboot,
        _cp_app_name,
        _teams_app_name,
        cp_apk,
        skip_reinstall,
        cp_apk_version,
        thisArgs,
    )
    for result in install_counts:
        _installs += result

    # Let last device catch up, if any:
    if _installs > 0:
        _final_sleep = 20
        ts_print(f"Final sleep of {_final_sleep}...")
        time.sleep(_final_sleep)

    time_elapsed = datetime.now() - start_time

    total_seconds = int(time_elapsed.total_seconds())
    hours, remainder = divmod(total_seconds, 60 * 60)
    minutes, seconds = divmod(remainder, 60)
    ts_print(f"Complete, Time elapsed {hours} hrs {minutes} min {seconds} sec")

    sys.exit(0)


def _setup_devices_in_parallel(
    devices,
    config,
    skip_clear,
    skip_reboot,
    _cp_app_name,
    _teams_app_name,
    cp_apk,
    skip_reinstall,
    cp_apk_version,
    thisArgs,
) -> list[int]:
    if thisArgs["sequential"]:
        print("WARNING SEQUENTAIL_SETUP configured...")
        ret = []
        if not isinstance(devices, list):
            raise AssertionError(f"Something wrong - 'devices' is not a list: {devices}")
        for d in devices:
            ret.append(
                _setup_device(
                    d,
                    config,
                    skip_clear,
                    skip_reboot,
                    _cp_app_name,
                    _teams_app_name,
                    cp_apk,
                    skip_reinstall,
                    cp_apk_version,
                    thisArgs,
                )
            )
        return ret

    return shared_utils.run_parallel(
        devices,
        _setup_device,
        config,
        skip_clear,
        skip_reboot,
        _cp_app_name,
        _teams_app_name,
        cp_apk,
        skip_reinstall,
        cp_apk_version,
        thisArgs,
    )


def _setup_device(
    device_name,
    config,
    skip_clear,
    skip_reboot,
    _cp_app_name,
    _teams_app_name,
    cp_apk,
    skip_reinstall,
    cp_apk_version,
    thisArgs,
) -> int:
    _installs = 0

    if thisArgs["mitm"] and getconfig_is_emulator(device_name):
        # Man-in-the-middle initialization
        # The script starts the proxy, starts the emulator, kills the proxy (Robot will restart as an in-process module)
        #
        avd_name = get_configured_device_property(device_name, "avd_name")
        avd_proxy_port = get_configured_device_property(device_name, "avd_proxy_port")

        print(f"{device_name}: MITM activation with AVD name '{avd_name}' on port {avd_proxy_port}")

        mitm_cmd = ["python", "scripts\\avd_mitm_startup.py", avd_name, str(avd_proxy_port)]
        result = subprocess.run(mitm_cmd, check=True, text=True)
        print(f"{device_name}: MITM initialized {result.returncode}")
        wait_for_device_online(device_name, config)

    # Connect the device
    ping_device(device_name, config, max_pings=40)
    connect_device(device_name, config)

    if not skip_reboot:
        ts_print(f"{device_name}: Unconditional reboot specified...")
        reboot_device(device_name, config)

    try:
        print_device_info(device_name, config)
    except:
        print_exception("WARNING: Information gather Exception ignored", device_name)

    if not skip_clear:
        reset_Teams_app(device_name, config, [_cp_app_name, _teams_app_name])

    _in_use_percent = storage_percent_in_use(device_name)
    if _in_use_percent and _in_use_percent >= MAX_IN_USE_PERCENT:
        # Info here: A 'Factory reset' is required to reclaim this space.
        # For now, this is not fatal, but APK installs may fail...
        ts_print(f"{device_name}: WARNING: LOW SPACE - consider factory resetting this device")

    # Install APKs
    if thisArgs["skipinstalls"]:
        ts_print(f"{device_name}: Unconditional skip APK installation specified.")
        return 0

    # CP first:
    if cp_apk:
        # TODO: There are several conditions in which we do NOT want to install the CP APK
        # - 'debug Teams on an emulator' is one...
        _do_install = True
        if skip_reinstall:
            installed_version = get_installed_version(device_name, _cp_app_name)
            ts_print(f"{device_name}: CP installed_version: {installed_version}, APK version: {cp_apk_version}")
            if installed_version == cp_apk_version:
                _do_install = False
                ts_print(f"{device_name}: Same CP version already installed")

        if _do_install:
            if not install_with_retry(
                device_name,
                config,
                config["companyPortal_Package"],
                cp_apk,
                replace_ok=True,
                attempts=2,
            ):
                raise AssertionError(f"{device_name}: CP install failed")
            _installs += 1

    # Then Teams:
    # Determine APK from configured device model:
    #   - ipPhoneRelease
    #   - panelRelease
    #   - nordenRelease
    #   - nordenDebug
    FLAVOR_RELEASE = None
    if is_panel(device_name):
        FLAVOR_RELEASE = "panelRelease"
    elif is_norden(device_name) or is_norden_console(device_name):
        FLAVOR_RELEASE = "nordenRelease"
    elif is_phone(device_name):
        FLAVOR_RELEASE = "ipPhoneRelease"
    else:
        raise AssertionError(
            f"{device_name}: FATAL: Cannot determine device type phone/panel/mtra of '{config['devices'][device_name]['model']}'!"
        )
    FLAVOR_DEBUG = FLAVOR_RELEASE.replace("Release", "Debug")

    # Gather all the release and debug APKs available:
    SEARCH_DIR_RELEASE = os.path.join(thisArgs["apkdir"], f"zipalign-{FLAVOR_RELEASE}")
    ts_print(f"{device_name}: Searching for '{FLAVOR_RELEASE}' APK in '{SEARCH_DIR_RELEASE}'...")
    _candidate_release = glob.glob(os.path.join(SEARCH_DIR_RELEASE, "*.apk"))

    SEARCH_DIR_DEBUG = os.path.join(thisArgs["apkdir"], f"zipalign-{FLAVOR_DEBUG}")
    ts_print(f"{device_name}: Searching for '{FLAVOR_DEBUG}' APK in '{SEARCH_DIR_DEBUG}'...")
    # Even if debug builds are not allowed, search anyway:
    _candidate_debug = glob.glob(os.path.join(SEARCH_DIR_DEBUG, "*.apk"))

    # If nothing available, warn and return:
    if len(_candidate_release) == 0 and len(_candidate_debug) == 0:
        ts_print(f"{device_name}: WARN: No '{FLAVOR_RELEASE}' APKs found, install skipped")
        return _installs

    # There should only be ONE (artifact directorys SHOULD have been cleaned up)
    if len(_candidate_release) > 1:
        raise AssertionError(
            f"{device_name}: FATAL: Found multiple '{FLAVOR_RELEASE}' APKs under '{SEARCH_DIR_RELEASE}': {_candidate_release}"
        )
    if len(_candidate_debug) > 1:
        raise AssertionError(
            f"{device_name}: FATAL: Found multiple '{FLAVOR_DEBUG}' APKs under '{SEARCH_DIR_DEBUG}': {_candidate_debug}"
        )

    # Now decide which (release/debug) APK to use:
    teams_apk = None
    if thisArgs["allowdebug"] and len(_candidate_debug) > 0:
        teams_apk = _candidate_debug[0]
        ts_print(f"{device_name}: Using Teams '{FLAVOR_DEBUG}' apk: {teams_apk}")
        if len(_candidate_release) > 0:
            ts_print(f"{device_name}: Note: Available but ignored Teams '{FLAVOR_RELEASE}' apk")
    else:
        teams_apk = _candidate_release[0]
        ts_print(f"{device_name}: Using Teams '{FLAVOR_RELEASE}' apk: {teams_apk}")
        if len(_candidate_debug) > 0:
            ts_print(f"{device_name}: Note: Available but ignored Teams '{FLAVOR_DEBUG}' apk")

    if skip_reinstall:
        teams_apk_version = get_apk_version(teams_apk)
        installed_version = get_installed_version(device_name, _teams_app_name)
        ts_print(f"{device_name}: Teams installed_version: {installed_version}, APK version: {teams_apk_version}")
        if installed_version == teams_apk_version:
            ts_print(f"{device_name}: Same Teams version already installed - re-install skipped")
            return _installs

    if not install_with_retry(
        device_name,
        config,
        config["common_desired_caps"]["appPackage"],
        teams_apk,
        replace_ok=True,
        attempts=2,
    ):
        raise AssertionError(f"{device_name}: Teams install failed")

    _installs += 1
    return _installs


if __name__ == "__main__":
    _main()
