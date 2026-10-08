import json
import os
from io import open
import traceback
from threading import Lock
import time
import subprocess
from datetime import datetime
from PIL import Image
from appium.webdriver.common.mobileby import MobileBy
from appium.webdriver.common.touch_action import TouchAction

from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import (
    TimeoutException,
    WebDriverException,
    StaleElementReferenceException,
    ElementClickInterceptedException,
)
from urllib3.exceptions import ProtocolError
from robot.libraries.BuiltIn import BuiltIn
from Libraries import shared_utils
from Libraries.shared_utils import (
    print,
    get_extended_path_prefix,
    encode_devices_and_accounts,
    is_debug,
    getconfig_is_emulator,
)

# We are moving these:
from Libraries.shared_utils import sleep_with_msg as new_sleep_with_msg
from Libraries.shared_utils import run_parallel as new_run_parallel
from Libraries.Selectors import load_json_file
from Libraries.AccountSetup import AccountSetup
from Libraries.initiate_driver import config, root_console, read_config as modified_config
from Libraries import initiate_driver, device_control
from Libraries import SignInOut
from resources.keywords import settings_keywords
from resources.keywords import call_keywords
from resources.keywords import calendar_keywords
from resources.keywords import ztp_keywords
from resources.keywords import call_views_keywords
from resources.keywords import tr_home_screen_keywords
from resources.keywords import lcp_signinout
from resources.keywords import device_settings_keywords

obj = AccountSetup.getInstance()
bugreport_dir_lock = Lock()

display_time = 2
action_time = 3

calls_dict = load_json_file("resources/Page_objects/Calls.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
navigation_dict = load_json_file("resources/Page_objects/Navigation.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
home_screen_dict = load_json_file("resources/Page_objects/Home_screen.json")
tr_Signin_dict = load_json_file("resources/Page_objects/tr_Signin.json")
tr_home_screen_dict = load_json_file("resources/Page_objects/tr_home_screen.json")
tr_console_signin_dict = load_json_file("resources/Page_objects/rooms_console_signin.json")
panels_home_screen_dict = load_json_file("resources/Page_objects/panels_homescreen.json")
lcp_homescreen_dict = load_json_file("resources/Page_objects/lcp_homescreen.json")
common_dict = load_json_file("resources/Page_objects/common.json")
ztp_dict = load_json_file("resources/Page_objects/ztp.json")
device_settings_dict = load_json_file("resources/Page_objects/Device_settings.json")
web_signin_dict = load_json_file("resources/Page_objects/Web_signin.json")
sign_dict = load_json_file("resources/Page_objects/Signin.json")


def verify_device_users(device_list=None, user_list: str = None, retry=True):
    """
    Verify that indicated devices have the specified users signed in.
    """
    print(f"verify_device_users device_list={device_list}, user_list={user_list}, retry={retry}")

    devices = encode_devices_and_accounts(device_list, user_list)
    print(f"Devices: {devices}")
    device_list = shared_utils.make_list(devices)

    signed_in_users = get_users_signed_in_on_devices(devices)

    print("Signed in Users : ", signed_in_users)

    desired_users = []
    for device in device_list:
        username = device_displayname(device)
        desired_users.append(username)

    print("Desired Users :", desired_users)
    device_list_new = []
    signout_device_list = []

    user_index = 0
    for signed, desired in zip(signed_in_users, desired_users):
        if signed:
            print(f"{device}: signed={signed}, desired={desired}")
            if signed != desired:
                if signed.lower() == desired.lower():
                    print(
                        f"*ERROR* : Config error: Bad case-sensitive 'displayname': Configured: '{desired}', actual: '{signed}'."
                    )
            if signed.lower().strip().replace(" ", "") != desired.lower().strip().replace(" ", ""):
                device_list_new.append(device_list[user_index])
                signout_device_list.append(device_list[user_index])
            else:
                print(f"Accepting configured username: {desired} as {signed.lower().strip().replace(' ', '')}")
        else:
            print(f"{device}: No user is signed in")
            device_list_new.append(device_list[user_index])
        user_index += 1

    if len(signout_device_list) != 0:
        print(f"Signing out these devices: {signout_device_list}")
        # TODO:
        #   Speedup - we could just reset_Teams:
        shared_utils.run_parallel(signout_device_list, SignInOut.sign_out_method)

    if len(device_list_new) != 0:
        print(f"Signing in these devices: {device_list_new}")
        shared_utils.run_parallel(device_list_new, SignInOut.sign_in_method)
        # No need to verify - will raise if fail
    print(f"Verified devices: {devices}")


def get_users_signed_in_on_devices(devices):
    results = new_run_parallel(devices, get_user_signed_in_on_device)
    return results


def get_user_signed_in_on_device(device):
    signed_in_username = None

    print(f"{device}: get_user_signed_in_on_device")

    if is_at_ZTP(device):
        print(f"{device}: No user signed in")
        return None

    try:
        if is_touch_console(device):
            return wait_for_element(device, tr_console_signin_dict, "room_user_name", "id").text

        if not is_norden(device):
            # Workaround for this bug: 3816487(Bug 3816487: [Phones][Automation][nGMS] Unexpected 'Lock Screen' appearing)
            if is_lcp(device):
                if is_element_present(device, lcp_homescreen_dict, "time_on_lock_screen") or is_element_present(
                    device, lcp_homescreen_dict, "emergency_call_info_on_lock_screen"
                ):
                    press_hardkeys(device, hardkey_intent=66)
            call_keywords.navigate_to_landing_page(device, disconnect=False)
        return get_user_name(device)

    except Exception as e:
        #
        # Poor assumption here - treating all exceptions as 'no user signed in'
        #   This is not necessarily true!
        #   We should instead check if any user is signed in, and THEN fetch the name.
        #
        print(f"{device}: Cannot get username signed in:{''.join(traceback.format_exception_only(type(e), e))}")

    settings_keywords.get_screenshot(name=f"{device}_signed_in_username_fail")
    SignInOut.capture_cp_and_logcat_logs(device)

    print(f"{device}: Could not get user name, resetting device...")

    # Because ALL exceptions are treated as 'no user signed in', we don't know if Teams, the driver (Appium), or the device failed.
    # Reset EVERYTHING:
    try:
        obj.re_setup_device_driver(device, config)
    except Exception as e:
        # Catastrophic: leave some clues:
        raise AssertionError(f"{device}: FATAL FAILURE, cannot reset: {type(e).__name__}: {e}") from e

    # Here, we should be sitting at the Teams splash screen:
    try:
        if is_lcp(device):
            lcp_signinout.signin_method_for_lcp(device)
        else:
            SignInOut.sign_in(device_list=device)

        signed_in_username = get_user_name(device)
        print(f"{device}: SUCCESS after re-signining in.")
    except Exception as e:
        print(f"*WARN*:: {device}: FAILURE after re-signining . Error is: {e}")
        # Adding this block for handle the 'got it' pop up when user skip password field
        sleep_with_msg(device, 5, "waiting for device to sign-in")
        if not click_if_element_appears(device, sign_dict, "Gotit_button"):
            raise e
        signed_in_username = get_user_name(device)

    return signed_in_username


def is_at_ZTP(device_name):
    # Returns True if device is showing the ZTP screen (no user logged in)
    _at_ztp = False

    if (
        is_element_present(device_name, sign_dict, "sign_in_on_the_device")
        # possibly overkill:
        or is_element_present(device_name, sign_dict, "dfc_login_code")
        or is_element_present(device_name, sign_dict, "refresh_code_button")
    ):
        _at_ztp = True

    print(f"{device_name}: is_at_ZTP={_at_ztp}")
    return _at_ztp


def get_user_name(device):
    print(f"{device}: Checking username on device")

    if is_at_ZTP(device):
        name = None
    elif is_norden(device):
        name = tr_home_screen_keywords.tr_get_user_name(device)
    elif is_panel(device):
        name = wait_for_element(device, panels_home_screen_dict, "room_name").text
    elif is_lcp(device):
        wait_for_and_click(device, lcp_homescreen_dict, "user_profile_picture")
        name = wait_for_element(device, lcp_homescreen_dict, "username").text
        sleep_with_msg(device, 3, "Let ui become stable")
        wait_for_and_click(device, lcp_homescreen_dict, "lcp_back_button")
    elif is_touch_console(device):
        # This is either the homescreen or the pairing screen username field:
        name = wait_for_element(device, tr_console_signin_dict, "room_user_name", "id").text
    else:
        if not device_settings_keywords.is_device_unlocked(device):
            device_settings_keywords.unlock_phone_lock(device)
        wait_for_and_click(device, navigation_dict, "Navigation")
        name = wait_for_element(device, navigation_dict, "user_name").text
        wait_for_and_click(device, settings_dict, "user_displayname")
        wait_for_and_click(device, calls_dict, "Call_Back_Button")
    print(f"{device}: username={name}")
    return name


def dial_hardkeys(device, hardkeys, acceptable_digits="+0123456789*#"):
    """Use ADB to dial the specified hard keys"""
    print(f"{device}: dial_hardkeys '{hardkeys}'")

    if is_element_present(device, calls_dict, "zero"):
        print(f"{device}: NOTE: dial_hardkeys: soft dialpad present and ignored")

    _udid = device_udid(device)

    for i in hardkeys:
        if i not in acceptable_digits:
            raise AssertionError(f"{device}: digit '{i}' is not acceptable in '{acceptable_digits}'")

        if i == "#":
            _keycode = "KEYCODE_POUND"
        elif i == "*":
            _keycode = "KEYCODE_STAR"
        elif i == "+":
            # longpress '0' for '+'
            _keycode = "--longpress KEYCODE_0"
        else:
            _keycode = f"KEYCODE_{i}"
        subprocess.call(
            f"adb -s {_udid} shell input keyevent {_keycode}",
            shell=True,
        )


def navigate_to_hamburger_menu(device):
    wait_for_and_click(device, navigation_dict, "Navigation")
    time.sleep(action_time)


def teardown_meeting_test_case(devices):
    device_list = devices.split(",")
    for device in device_list:
        print("device : ", device)
        click_if_present(device, calls_dict, "Call_Back_Button")
        time.sleep(7)
        if is_element_present(device, calendar_dict, "alert_message"):
            wait_for_and_click(device, calendar_dict, "discard_pop_up")


def device_type(device):
    # Deprecated: please use: shared_utils.getconfig_device_class(device)
    return shared_utils.getconfig_device_class(device)


def device_displayname(device):
    # Deprecated: please use: shared_utils.getconfig_displayname(device)
    return shared_utils.getconfig_displayname(device)


def device_phonenumber(device):
    # Deprecated: please use: shared_utils.getconfig_phonenumber(device)
    return shared_utils.getconfig_phonenumber(device)


def device_pstndisplay(device):
    # Deprecated: please use: shared_utils.getconfig_pstndisplay(device)
    return shared_utils.getconfig_pstndisplay(device)


def device_extention_number(device):
    # Deprecated: please use: shared_utils.getconfig_extention_number(device)
    return shared_utils.getconfig_extention_number(device)


def device_username(device):
    # Deprecated: please use: shared_utils.device_username(device)
    return shared_utils.getconfig_username(device)


def device_admin_credentials(device):
    # Deprecated: please use: shared_utils.getconfig_admin_credentials(device)
    return shared_utils.getconfig_admin_credentials(device)


def device_model(device):
    # Deprecated: please use: shared_utils.getconfig_device_model(device)
    return shared_utils.getconfig_device_model(device)


def device_oem(device):
    # Deprecated: please use: shared_utils.getconfig_device_oem(device)
    return shared_utils.getconfig_device_oem(device)


def device_udid(device):
    # Deprecated: please use: shared_utils.getconfig_device_udid(device)
    return shared_utils.getconfig_device_udid(device)


def capture_logcat_logs(name, device_list=None):
    if isinstance(device_list, list):
        devices = device_list
    else:
        if device_list is None:
            devices = shared_utils.getconfig_all_device_names()
        else:
            devices = device_list.split(",")

    print("Devices : ", devices)

    name = filename_from_string(name)
    newpath = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "logcat_logs")
    if not os.path.exists(newpath):
        os.makedirs(newpath)

    _capture_logcat_logs_in_parallel(devices, name, newpath)


def _capture_logcat_logs_in_parallel(devices, name, newpath):
    new_run_parallel(devices, _capture_logcat_logs_for_single_device, name, newpath)


def _capture_logcat_logs_for_single_device(device, name, newpath):
    try:
        driver = obj.device_store.get(alias=device)
    except Exception as _no_driver:
        print(f"{device} No driver, logcat fetch skipped: {type(_no_driver).__name__}: {_no_driver}.")
        return

    try:
        logs = driver.get_log("logcat")
    except Exception as _fetchfail:
        print(f"{device} Logcat fetch failed: {type(_fetchfail).__name__}: {_fetchfail}.")
        return

    # The basic 'device crashed' crash sniffer:
    _crash_detected = False

    # These are InTune configuration error sniffers:
    _intune_bad_enroll_detected = False
    _intune_cap_limit_detected = False

    current_time = datetime.now().strftime("%H%M%S")
    log_messages = list(map(lambda log: log["message"], logs))

    file_name = get_extended_path_prefix() + os.path.join(newpath, f"{current_time}_{name}.{device}_logcat.txt")

    # If the file name is too lengthy, shorten it.
    if len(file_name) > 260:
        file_name = file_name[:260] + f".{device}_logcat.txt"

    with open(file_name, "w", encoding="utf-8") as f:
        for item in log_messages:
            if "FATAL EXCEPTION" in item or "Fatal signal" in item:
                _crash_detected = True
            if "DA_ENROLLMENT_DISABLED" in item:
                _intune_bad_enroll_detected = True
            if "DEVICE_CAP_REACHED" in item:
                _intune_cap_limit_detected = True
            f.write(f"{item}\n")

    if _crash_detected:
        report_crash(device, f"Logcat log, See {f.name}.")
    if _intune_bad_enroll_detected:
        # Sign-in fail message - Intune requires device enrollment to be enabled for this user, and it is not.
        print(f"*ERROR* {device} - 'DA_ENROLLMENT_DISABLED' detected: See {f.name}")
    if _intune_cap_limit_detected:
        # Sign-in fail message - Intune has recorded too many registrations for this device/user, you need to
        # manually clear these (as an admin, 'bulk delete' operaton on https://admin.microsoft.com, 'Show all', Endpoints, android devices).
        print(f"*ERROR* {device} - 'DEVICE_CAP_REACHED' detected: See {f.name}")


def report_crash(device_name: str, context: str):
    # Report as Test Execution Error
    print(f"*ERROR* {device_name} - CRASH DETECTED: {context}")
    # And insert the message in the keyword log
    print(f"{device_name} - CRASH DETECTED: {context}")


def wake_device_and_capture_screenshot(device):
    driver = obj.device_store.get(alias=device)
    subprocess.call(
        "adb -s {} shell input keyevent KEYCODE_WAKEUP".format(
            config["devices"][device]["desired_caps"]["udid"].split(":")[0]
        ),
        shell=True,
    )
    time.sleep(action_time)
    current_time = datetime.now().strftime("%H%M%S")
    file_name = "image_screen_" + current_time + ".png"
    driver.get_screenshot_as_file(file_name)
    # send_test_message(message=file_name)


def check_for_device_count(count):
    devices = list(config["devices"].keys())
    print("len(devices) : ", len(devices))
    print("count : ", count)
    if len(devices) < int(count):
        raise AssertionError(f"check_for_device_count({count}) failed: Only {len(devices)} defined")


def get_bugreport_on_app_crash(name, device_list=None):
    if isinstance(device_list, list):
        devices = device_list
    else:
        if device_list is None:
            devices = shared_utils.getconfig_all_device_names()
        else:
            devices = device_list.split(",")
    print("Devices : ", devices)
    time.sleep(2)

    ###########################
    # Issues with parallel bugreport gathering - allow override:
    #
    skip_parallel = BuiltIn().get_variable_value("${exp_sequential_bugreports}")
    if skip_parallel:
        BuiltIn().log_to_console(f"Variable 'exp_sequential_bugreports': Sequentially fetching bugreports...")
        for _device_name in devices:
            _get_bugreport_on_app_crash_for_single_device(_device_name, name)
    else:
        shared_utils.run_parallel(devices, _get_bugreport_on_app_crash_for_single_device, name)


def _get_bugreport_on_app_crash_for_single_device(device, name):
    _udid = shared_utils.getconfig_device_udid(device)
    try:
        if not is_element_present(device, settings_dict, "close_app_btn"):
            return
        report_crash(device, "UI - 'close_app_btn' is present!")
    except Exception as _teardown_failure:
        report_crash(device, "Appium failed, assuming App crashed!")

    ###########################
    # Issues with bugreport gathering - allow override:
    #
    if BuiltIn().get_variable_value("${exp_skip_bugreports}"):
        print(f"{device} Note - variable 'exp_skip_bugreports' is set, skipping bugreport fetch")
    else:
        # Use ADB to get a bugreport:
        newpath = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "bug_reports_for_app_crashes")

        with bugreport_dir_lock:
            if not os.path.exists(newpath):
                os.makedirs(newpath)

        current_time = datetime.now().strftime("%H%M")
        newname = os.path.join(newpath, "bugreport_" + current_time + filename_from_string(name) + "_" + device)
        cmd = f"adb -s {_udid} bugreport {newname}"

        # Best effort - try to get ADB to get a bugreport:
        try:
            subprocess.check_output(cmd, text=True, shell=True)
            print(f"{device} bugreport in '{newname}'")
        except subprocess.CalledProcessError as cpe:
            print(f"{device} cannot create bugreport: '{cpe}'")

    # Best effort - try to acknowledge the app-crash:
    try:
        wait_for_and_click(device, settings_dict, "close_app_btn")
        sleep_with_msg(device, 15, "'Close app' button pressed, Teams should be restarting")
        # Done, App should be restarting
        return
    except:
        # Here, appium cannot talk to the device. Do a full reset.
        print(f"{device} Appium failed, cannot dismiss any app crash pop-up")

    print(f"{device}: Resetting device")

    # TODO: This must not be threaded - Appium restart can encounter an internal 'lock file' conflict.
    #   Very rare, but clearly logged by Appium.
    try:
        obj.re_setup_device_driver(device, config)
        print(f"{device}: re_setup_device_driver sucessful")
    except Exception as e:
        print(f"{device}: Fatal: re_setup_device_driver failed with {type(e).__name__}: {e}")


def filename_from_string(name):
    """Sanitize the string 'name' to a valid fileneme."""
    name = (
        name.replace(" ", "_")
        .replace(":", "-")
        .replace("/", "_")
        .replace('"', "")
        .replace(".", "")
        .replace("'", "")
        .replace(",", "")
        .replace(">", "")
        .replace("<", "")
        .replace("?", "")
        .replace("*", "")
        .replace("#", "")
    )
    return name


def verify_hamburger_menu(device):
    print("device: ", device)
    driver = obj.device_store.get(alias=device)
    displayname = config["devices"][device]["user"]["displayname"]
    print("displayname : ", displayname)
    try:
        WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((MobileBy.ID, settings_dict["user_profile_pic"]["id"]))
        )
        print("Profile picture visible")
        try:
            elem1 = WebDriverWait(driver, 30).until(
                EC.presence_of_element_located((MobileBy.ID, settings_dict["user_designation"]["id"]))
            )
            print("User Designation is available : ", elem1.text)
        except Exception as e:
            print("Designation is not available for the user")
        elem2 = WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((MobileBy.ID, settings_dict["user_displayname"]["id"]))
        )
        print("User displayname : ", elem2.text)
        if elem2.text == displayname:
            print("User displayname is matching in Hamburger menu")
        else:
            raise AssertionError("User displayname is not matching in Hamburger menu")
    except Exception as e:
        raise AssertionError("Xpath not found")


def is_norden(device):
    _model = shared_utils.getconfig_device_model(device)
    b_is_listed = _model in [
        "sammamish",
        "spokane",
        "oakland",
        "san francisco",
        "atlanta",
        "tucson",
        "irvine",
        "houston",
        "austin",
        "detroit",
        "everett",
        "eureka",
        "renton",
        "dearborn",
        "kodiak",
        "vernon",
        "aurora",
        "vancouver",
        "page",
        "georgia",
        "augusta",
        "jackson",
        "pasadena",
        "santamonica",
        "manchester",
        "sanantonio",
        "mesa",
        "palmer",
        "laredo",
        "barre",
        "newport",
        "homer",
        "southfield",
        "nordenemulator",
        "burlington",
        "alburgh",
        "palo alto",
        "pullman",
        "royal oak",
        "kent",
        "kadubesnhalli",
    ]

    print(f"{device}: '{_model}' is_norden: {b_is_listed}")
    return b_is_listed


_SUPPORTED_SELECTOR_STYLES = ["id", "id1", "command", "text", "xpath", "xpath1"]


def get_element_with_condition(
    device, selector_dict, selector_dict_key, selector_key, cond=EC.presence_of_element_located, wait_secs=1
):
    """
    Unconditionally fetch an element or raise
    Retry if ProtocolError encountered, recoverable.
    """
    if not isinstance(device, str):
        raise AssertionError(f"{device}: Expecting 'str', got '{type(device)}'.")

    device_name, _ = decode_device_spec(device)
    driver = obj.device_store.get(device_name)
    selector = selector_dict[selector_dict_key][selector_key]
    _retry_attempts = 5
    _retry_sleep_secs = 3
    while True:
        try:
            if selector_key in ["id", "id1"]:
                return WebDriverWait(driver, wait_secs).until(cond((MobileBy.ID, selector)))
            if selector_key == "command":
                return WebDriverWait(driver, wait_secs).until(cond((MobileBy.ANDROID_UIAUTOMATOR, selector)))
            if selector_key == "text":
                command = f'new UiSelector().text("{selector}")'
                return WebDriverWait(driver, wait_secs).until(cond((MobileBy.ANDROID_UIAUTOMATOR, command)))
            return WebDriverWait(driver, wait_secs).until(cond((MobileBy.XPATH, selector)))
        except TimeoutException as _toerr:
            # _toerr.msg = f"{device}: " + _toerr.msg
            raise
        except WebDriverException as _wderror:
            _wderror.msg = f"{device}: " + _wderror.msg
            raise _wderror
        except ProtocolError as _perror:
            if _retry_attempts > 0:
                _retry_attempts = _retry_attempts - 1
                print(
                    f"{device}: ProtocolError, retry in {_retry_sleep_secs}, attempts left: {_retry_attempts}. {str(_perror)}"
                )
                time.sleep(_retry_sleep_secs)
                continue
            raise _perror


def get_all_elements_texts(device, selector_dict, selector_dict_key, selector_key=None):
    """
    Return a list containing the texts from all selector matches.
    """
    # Note: WebDriver magic: Instead of a 'WebElement', a 'list of WebElements' is
    #    returned when 'EC.presence_of_all_elements_located' is specified.
    _magic = EC.presence_of_all_elements_located

    element_list = []
    if selector_key is None:
        for _key in selector_dict[selector_dict_key]:
            if _key not in _SUPPORTED_SELECTOR_STYLES:
                print(f"{device}: Warning - get_all_elements_texts() ignoring unsupported selector key '{_key}'")
                continue
            try:
                element_list = get_element_with_condition(device, selector_dict, selector_dict_key, _key, cond=_magic)
                break
            except TimeoutException:
                continue
        if len(element_list) == 0:
            raise AssertionError(f"{device}: could not find any '{selector_dict_key}' elements")
    else:
        if not selector_key in _SUPPORTED_SELECTOR_STYLES:
            raise AssertionError(
                f"{device}: get_all_elements_texts() unsupported selector key '{selector_key}' specified"
            )
        try:
            element_list = get_element_with_condition(
                device, selector_dict, selector_dict_key, selector_key, cond=_magic
            )
        except TimeoutException:
            raise AssertionError(f"{device}: could not find any '{selector_dict_key}[{selector_key}]' elements")

    return_list = []
    try:
        for element in element_list:
            return_list.append(element.text)
    except StaleElementReferenceException:
        # While collecting element texts, the element went stale
        print(f"{device}: StaleElementReferenceException - UI changed while collecting elements texts")
        raise

    print(f"{device}: Text of '{selector_dict_key}' elements: {return_list}")
    return return_list


def is_element_present(
    device, selector_dict, selector_dict_key, selector_key=None, cond=EC.presence_of_element_located, silent=False
):
    """
    Return Element or False if specified element is present with specified element condition.
    """

    def single_selector_is_element_present(device, selector_dict, selector_dict_key, selector_key, cond):
        if selector_key not in _SUPPORTED_SELECTOR_STYLES:
            return False
        try:
            _element = get_element_with_condition(device, selector_dict, selector_dict_key, selector_key, cond=cond)
            if not silent:
                if _element:
                    print(f"{device}: element is present: '{selector_dict_key}[{selector_key}]'")
            return _element
        except TimeoutException:
            pass
        return False

    if is_debug:
        silent = False  # Some additional logging

    _element = None
    if selector_key is None:
        _has_valid_selector_key = False

        for _selector_key in selector_dict[selector_dict_key]:
            if _selector_key in _SUPPORTED_SELECTOR_STYLES:
                _has_valid_selector_key = True
                try:
                    if _element := single_selector_is_element_present(
                        device, selector_dict, selector_dict_key, _selector_key, cond
                    ):
                        break
                except StaleElementReferenceException:
                    # Optimization: the element WAS there, but is now gone. Skip any remaining selects:
                    _element = None
                    break
        if not _has_valid_selector_key:
            raise AssertionError(f"{device}: Selector dictionary '{selector_dict_key}' has no valid selector keys")
    else:
        if not selector_key in _SUPPORTED_SELECTOR_STYLES:
            raise AssertionError(f"{device}: Unsupported selector key '{selector_key}'")
        try:
            _element = single_selector_is_element_present(device, selector_dict, selector_dict_key, selector_key, cond)
        except StaleElementReferenceException:
            _element = None
            pass

    if not silent:
        if not _element:
            print(f"{device}: element is not present: '{selector_dict_key}'")

    return _element


def click_if_present(device, selector_dict, selector_dict_key, selector_key=None):
    """
    If element exists, click on it and return True
    Otherwise return False
    """

    def single_selector_click_if_present(device, selector_dict, selector_dict_key, selector_key):
        if selector_key not in _SUPPORTED_SELECTOR_STYLES:
            return False

        _element = is_element_present(
            device, selector_dict, selector_dict_key, selector_key, cond=EC.element_to_be_clickable
        )
        if not _element:
            return False

        # It's possible that the element disappears. Warn if it does - UI could be crashing...
        try:
            _element.click()
            return True
        except StaleElementReferenceException:
            print(f"{device}: WARN - UI changed, '{selector_dict_key}' became stale after being not stale")
            return False
        except ElementClickInterceptedException as intercepted:
            if not dismiss_TDC_advertisements(device):
                debug_dump(device, "no_ads_dismissed_click_if_present")
                intercepted.msg = f"{device}: click_if_present: " + intercepted.msg
                raise intercepted

        # Retry: Element click should no longer be intercepted, but allow the 'dismissed' element to clear:
        wait_for_and_click(device, selector_dict, selector_dict_key, selector_key)
        return True

    if selector_key is None:
        for _selector_key in selector_dict[selector_dict_key]:
            if single_selector_click_if_present(device, selector_dict, selector_dict_key, _selector_key):
                print(f"{device}: Clicked on '{selector_dict_key}' using '{_selector_key}'")
                return True
    elif single_selector_click_if_present(device, selector_dict, selector_dict_key, selector_key):
        print(f"{device}: Clicked on '{selector_dict_key}'")
        return True

    # print(f"{device}: '{selector_dict_key}' was not present")
    return False


def wait_for_element(
    device, selector_dict, selector_dict_key, selector_key=None, wait_attempts=30, cond=EC.presence_of_element_located
):
    """
    This method waits for, and returns the first element found in the specified selector dictionary.
    """
    attempt = 0
    for attempt in range(wait_attempts):
        if selector_key is None:
            for k in selector_dict[selector_dict_key]:
                if _element := is_element_present(device, selector_dict, selector_dict_key, k, cond, silent=True):
                    print(f"{device}: found '{selector_dict_key}[{k}]' on attempt {attempt + 1} of {wait_attempts}")
                    return _element
                # print(f"DEBUG: Attempt {attempt}: element '{selector_dict_key}[{key}]' not present")
        elif _element := is_element_present(device, selector_dict, selector_dict_key, selector_key, cond, silent=True):
            print(f"{device}: found '{selector_dict_key}[{selector_key}]' on attempt {attempt + 1} of {wait_attempts}")
            return _element

    debug_dump(device, f"{selector_dict_key}__not_found")

    raise AssertionError(f"{device}: could not find '{selector_dict_key}' after {attempt + 1} attempts")


def debug_dump(device, context):
    # If configured, Dump screenshot and XML.
    #   This will dump if robot is invoked with:
    #       "-v dump_on_wait_fail:any"
    #   default is None:
    #       "-v dump_on_wait_fail:"
    device, _ = decode_device_spec(device)
    _dump = BuiltIn().get_variable_value("${dump_on_wait_fail}")
    print(f"{device}: variable 'dump_on_wait_fail' is '{_dump}'")
    if _dump:
        context = f"{context}_{device}"
        BuiltIn().log_to_console(f"{device}: 'dump_on_wait_fail' - {context}")
        settings_keywords.get_screenshot(context, device_list=device, with_xml=True)


def verify_ui_element_visible(device, is_visible, selector_dict, selector_dict_key, selector_key=None):
    if is_visible:
        wait_for_element(device, selector_dict, selector_dict_key, selector_key, cond=EC.visibility_of_element_located)
    else:
        if is_element_present(device, selector_dict, selector_dict_key, selector_key):
            raise AssertionError(f"{device}: {selector_dict_key} is visible, expected invisible")


def wait_for_and_click(
    device, selector_dict, selector_dict_key, selector_key=None, wait_attempts=30, ignore_connection_drop=False
):
    """
    This method waits for the specified element to be clickable and clicks on it.
    """
    _el = wait_for_element(
        device,
        selector_dict,
        selector_dict_key,
        selector_key=selector_key,
        wait_attempts=wait_attempts,
        cond=EC.element_to_be_clickable,
    )
    try:
        _el.click()
        print(f"{device}: clicked on '{selector_dict_key}'")
        return
    except ElementClickInterceptedException as intercepted:
        if not dismiss_TDC_advertisements(device):
            debug_dump(device, "no_ads_dismissed_wait_for_and_click")
            intercepted.msg = f"{device}: wait_for_and_click: " + intercepted.msg
            raise intercepted
    except StaleElementReferenceException:
        print(
            f"*WARN* {device}: WARN - UI changed, '{selector_dict_key}' became stale after being not stale, retrying..."
        )
    except WebDriverException as we:
        if ignore_connection_drop:
            # 'ignore_connection_drop=True' - device MAY drop the connection when reboot 'click' is performed - the click MAY fail AFTER being performed.
            #   Best effort - the framework needs to be told that a 'drop' is allowable.
            _dropmsg = get_drop_text(we)
            if _dropmsg:
                print(f"{device}: Found and ignored connection drop: '{_dropmsg}'")
                return
            # Odd, is there some other 'drop' we are missing?
            print(f"{device}: Unexpected - did not find drop in '{we}'")
        raise

    # Retry
    sleep_with_msg(device, 2, "Let element become stable")
    wait_for_element(
        device,
        selector_dict,
        selector_dict_key,
        selector_key=selector_key,
        wait_attempts=wait_attempts,
        cond=EC.element_to_be_clickable,
    ).click()

    print(f"{device}: re-clicked on '{selector_dict_key}'")


def wait_while_present(device_name, selector_dict, selector_dict_key, selector_key=None, max_wait_attempts=10):
    """
    This method waits for the specified element to disappear and raises if it doesn't.
    """
    attempt = 0
    for attempt in range(max_wait_attempts):
        # Note awkward syntax - 'EC.invisibility_of_element' returns True if element goes AWAY or 'invisible':
        if is_element_present(
            device_name, selector_dict, selector_dict_key, selector_key, cond=EC.invisibility_of_element, silent=True
        ):
            print(f"{device_name}: '{selector_dict_key}' is no longer present after {attempt} seconds")
            return
        time.sleep(1)

    raise AssertionError(f"{device_name}: '{selector_dict_key}' still present after {attempt + 1} attempts")


def raise_if_present(device_name, selector_dict, selector_dict_key, selector_key=None, max_wait_attempts=3):
    """
    This method raises an exception if the specified element appears.
    """
    attempt = 0
    for attempt in range(max_wait_attempts):
        if is_element_present(device_name, selector_dict, selector_dict_key, selector_key):
            raise AssertionError(f"{device_name}: '{selector_dict_key}' is present")

    print(f"{device_name}: '{selector_dict_key}' is not present  after {attempt} seconds")


def poll_for_toast_text(device, poll_attempts=15):
    """
    This method waits for a 'toast' to appear and returns its text.
    """
    start = time.perf_counter()
    driver = obj.device_store.get(device)
    attempt = 0

    # This key is very specific, we could also allow this to be specified...
    toast_key = 'class="android.widget.Toast" text="'

    for attempt in range(poll_attempts):
        # Just grab the XML - we need to be quick and we also need the text.
        # This avoids the StaleElementReferenceException - the toast is very short-lived.
        screen_xml = str(driver.page_source.encode("utf-8"))

        ndx_key_start = screen_xml.find(toast_key)
        if ndx_key_start < 0:
            continue
        ndx_text_start = ndx_key_start + len(toast_key)
        ndx_text_end = screen_xml.find('"', ndx_text_start)

        if ndx_text_end <= ndx_text_start:
            print(f"WARN {device}: Unexpected toast format start={ndx_text_start}, end={ndx_text_end}")

        toast_text = screen_xml[ndx_text_start:ndx_text_end]
        print(
            f"{device}: Toast '{toast_text}' appeared at {time.perf_counter() - start} seconds on attempt {attempt + 1} of {poll_attempts}"
        )
        return toast_text

    raise AssertionError(
        f"{device}: could not find a 'toast' after {time.perf_counter() - start} seconds and {attempt + 1} attempts"
    )


def get_dict_copy(parent_dict, parent_dict_key, replace_token, replace_val):
    """
    Return a clone of the specified parent dictionary containing all
    valid selectors which contain the 'replace_token' replaced by 'replace_val'.
    """
    _new_parent_copy = dict()
    _new_child_dict = dict()

    for child_dict_key in parent_dict[parent_dict_key]:
        if not child_dict_key in _SUPPORTED_SELECTOR_STYLES:
            # ignore unknown keys
            continue
        if not replace_token in parent_dict[parent_dict_key][child_dict_key]:
            # In case we want to fix these:
            # print(f"*WARN* Problematic dictionary passed to get_dict_copy(),'{parent_dict_key}'['{child_dict_key}'] has no '{replace_token}' token.")
            continue

        # Looks good, add the selector with the replaced value:
        _new_child_dict[child_dict_key] = parent_dict[parent_dict_key][child_dict_key].replace(
            replace_token, replace_val
        )

    if len(_new_child_dict) == 0:
        raise AssertionError(f"Dictionary '{parent_dict_key}' has no valid selectors containing '{replace_token}'")

    _new_parent_copy[parent_dict_key] = _new_child_dict
    return _new_parent_copy


def kb_trigger_search(device, selector_dict, selector_dict_key, search_text, selector_key=None, wait_attempts=10):
    """
    Trigger search using virtual keyboard events.
    Note: The element 'selector_dict_key' must have property 'clickable' == True
    """
    # Bring up the virtual keyboard for the search box, type the name, and close the keyboard.
    wait_for_and_click(device, selector_dict, selector_dict_key, selector_key, wait_attempts)

    subprocess.call(
        "adb -s {} shell input keyboard text '{}'".format(
            config["devices"][device]["desired_caps"]["udid"].split(":")[0], search_text
        ),
        shell=True,
    )
    hide_keyboard(device)


def hide_keyboard(device):
    """Hide the device soft keyboard"""
    print(f"{device}: hide keyboard")
    driver = obj.device_store.get(device)
    driver.hide_keyboard()


def sleep_with_msg(device, wait_seconds, why_message):
    new_sleep_with_msg(device, wait_seconds, why_message)


def is_panel(device):
    _model = device_model(device)
    b_is_listed = _model in [
        "westchester",
        "beverly hills",
        "brooklyn",
        "arlington",
        "flint",
        "savannah",
        "hollywood",
        "richland",
        "surprise",
        "richford",
        "hollywood_13",
        "plano",
        "beverly hills_13",
    ]

    print(f"{device}: '{_model}' is_panel: {b_is_listed}")
    return b_is_listed


def is_lcp(device):
    _model = device_model(device)
    b_is_listed = _model in [
        "malibu",
        "glendale",
        "bothell",
        "malibu_13",
        "loveland",
    ]

    print(f"{device}: '{_model}' is_lcp: {b_is_listed}")
    return b_is_listed


def perform_drag_and_drop(
    device,
    src_element_name,
    src_selector_dict,
    src_selector_dict_key,
    dest_element_name,
    dest_selector_dict,
    dest_selector_dict_key,
):
    print("Devices for Action :", device)
    driver = obj.device_store.get(alias=device)
    source_element = wait_for_element(device, src_selector_dict, src_selector_dict_key)
    print(f"{src_element_name} source element is :", source_element)
    destination_element = wait_for_element(device, dest_selector_dict, dest_selector_dict_key)
    print(f"{dest_element_name} destination element is :", destination_element)
    try:
        actions = TouchAction(driver)
        actions.long_press(source_element).move_to(destination_element).release().perform()
    except Exception as e:
        raise AssertionError("Unable to move the {src_element_name} tab from one section to another section", e)


def is_touch_console(console):
    _model = device_model(console)

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
    print(f"{console}: '{_model}' is_touch_console: {b_is_listed}")
    return b_is_listed


def verify_console_users(device_list=None, console_list=None, user_list=None, retry=True):
    if device_list is None:
        devices = list(config["devices"].keys())
        users = ["None"] * len(devices) if user_list is None else user_list.split(",")
    else:
        devices = device_list.split(",")
        users = user_list.split(",")
    if console_list is None:
        consoles = list(config["consoles"].keys())
        users = ["None"] * len(consoles) if user_list is None else user_list.split(",")
    else:
        consoles = console_list.split(",")
        users = user_list.split(",")
    print("devices : ", devices)
    print("consoles : ", consoles)
    print("Users : ", users)

    signed_users = []
    signed_users_console = []

    for device, console, user in zip(devices, consoles, users):
        try:
            user_name = get_console_user_name(console)

            if not user_name:
                user_name = "None"

            signed_users.append(user_name)
            signed_users_console.append(console)
            continue
        except Exception as e:
            print(f"Could not get user name on console {console}, attempting to re-sign in. Error: {str(e)}")
        capture_screenshot(name=f"{console}_before_verify_users")
        SignInOut.capture_console_cp_and_logcat_logs(console)
        obj.re_setup_console_driver(console, config, root_console)

        # Re-sign in the console
        try:
            SignInOut.sign_in_console(console_list=[console], user_list=[user])
            SignInOut.get_device_pairing_code(device_list=[device], console_list=[console], user_list=[user])

            # Rechecking the signed-in user
            user_name = get_console_user_name(console)

            if not user_name:
                user_name = "None"

            signed_users.append(user_name)
            signed_users_console.append(console)
            capture_screenshot(name=f"{console}_after_verify_users")
        except Exception as e:
            # TODO: Why are we ignoring this?
            print(f"Failed to re-sign in on console {console}. Error: {str(e)}")

    print("Signed Users: ", signed_users)
    print("Signed Users on Consoles: ", signed_users_console)
    desired_users = []
    user_types = {
        "pstn_user": "pstn_user",
        "meeting_user": "meeting_user",
        "standard_user": "standard_user",
        "premium_user": "premium_user",
        "basic_user": "basic_user",
        "manufacture_block_user": "manufacture_block_user",
        "complex_pwd_user": "complex_pwd_user",
        "intune_license_user": "intune_license_user",
        "pstn_disabled": "pstn_disabled",
    }

    for device, console, user in zip(devices, consoles, users):
        account = user_types.get(user.lower(), "user") if user != "None" else "user"
        username = config["consoles"][console][account]["displayname"]
        desired_users.append(username)

    print("Desired Users: ", desired_users)

    # Identifying the consoles and users to re-sign
    device_list_new, console_list_new, user_list_new = [], [], []

    for signed, desired in zip(signed_users, desired_users):
        if signed != desired:
            device_list_new.append(devices[signed_users.index(signed)])
            console_list_new.append(consoles[signed_users.index(signed)])
            user_list_new.append(users[signed_users.index(signed)])

    print("New Device List: ", device_list_new)
    print("New Console List: ", console_list_new)
    print("New User List: ", user_list_new)

    if len(console_list_new) != 0:
        SignInOut.sign_out_console(console_list=console_list_new)
        SignInOut.sign_in_console(console_list=console_list_new, user_list=user_list_new)
        SignInOut.get_device_pairing_code(
            device_list=device_list_new, console_list=console_list_new, user_list=user_list_new
        )

        if retry:
            verify_device_users(device_list_new, user_list_new, retry=False)
        else:
            raise AssertionError(f"{console_list_new}: Unable to complete sign-in and pairing after retrying.")


def get_console_user_name(console):
    # Deprecated: Use get_user_name() instead.
    return get_user_name(console)


def logcat_logs_capture(name, console_list=None):
    # Deprecated: Use capture_logcat_logs() instead
    return capture_logcat_logs(name, console_list)


def capture_screenshot(name, console_list=None, with_xml=True):
    # Deprecated: Use get_screenshot() instead
    return settings_keywords.get_screenshot(name=name, device_list=console_list, with_xml=with_xml)


def get_device_name_list(count):
    _device_names = list(config["devices"].keys())
    if len(_device_names) < int(count):
        raise AssertionError(f"Config error: {count} devices requested, but only {len(_device_names)} available")
    return _device_names[0 : int(count)]


def is_portrait_mode_cnf_device(device):
    driver = obj.device_store.get(alias=device)
    window_size = driver.get_window_size()
    height = window_size["height"]
    width = window_size["width"]
    if height > width:
        print(f"{device} is a portrait mode device")
        return True
    return False


def click_if_element_appears(device, selector_dict, selector_dict_key, max_attempts=15):
    """
    This method waits for the specified element to be clickable, clicks on it if found and returns True.
    Else, returns False
    """
    attempt = 0
    for attempt in range(1, max_attempts):
        if click_if_present(device, selector_dict, selector_dict_key):
            print(f"{selector_dict_key} appeared on attempt {attempt} of {max_attempts}")
            return True
        time.sleep(1)
    print(f"{device}: '{selector_dict_key}' did not appear after {attempt + 1} attempts")
    return False


def is_phone(device):
    """
    checks if device is the IP Phone flavor
    """
    _model = device_model(device)
    b_is_listed = _model in [
        "phoenix",
        "scottsdale",
        "gilbert",
        "chandler",
        "long island",
        "queens",
        "olympia",
        "seattle",
        "redmond",
        "san jose",
        "santa cruz",
        "riverside",
        "bakersfield",
        "kirkland",
        "riverside_13",
        "santa cruz_13",
        "bakersfield_13",
    ]

    print(f"{device}: '{_model}' is_phone: {b_is_listed}")
    return b_is_listed


def verify_devices_configured_in_panels_setup(device_list=None):
    if device_list is not None:
        device_list = device_list.split(",")
        if len(device_list) != 1 and device_list[0] != list(config["devices"].keys())[0]:
            raise AssertionError(f"Specified list does not start with the configured list: {device_list}")
    else:
        device_list = list(config["devices"].keys())
    if len(device_list) > 2:
        print(f"*WARN*:: Required '2' devices but found '{len(device_list)}' devices")
    if len(device_list) == 1:
        verify_device_category(device_list[0], "panel")
    elif len(device_list) == 2:
        verify_device_category(device_list[0], "panel")
        verify_device_category(device_list[1], "norden")
    # elif len(device_list) == 3:
    #     verify_device_category(device_list[0], "panel")
    #     verify_device_category(device_list[1], "norden")
    #     verify_device_category(device_list[2], "panel")


def verify_device_category(device, category):
    if category.lower() not in ["phone", "panel", "norden"]:
        raise AssertionError(f"Unexpected value for device category: {category}")
    if category.lower() == "panel":
        if is_panel(device):
            return
    if category.lower() == "norden":
        if is_norden(device):
            return
    if category.lower() == "phone":
        if is_phone(device):
            return
    raise AssertionError(f"{device} is not a {category}")


def verify_device_users_in_panels_setup(device_list=None):
    if device_list is None:
        device_list = list(config["devices"].keys())
    else:
        device_list = device_list.split(",")
    # if len(device_list) == 4:
    #     panel_login_account1 = config["devices"][device_list[0]]["user"]["username"]
    #     rooms_login_account1 = config["devices"][device_list[1]]["user"]["username"]
    #     phone_login_account = config["devices"][device_list[2]]["user"]["username"]
    #     panel_login_account2 = config["devices"][device_list[3]]["user"]["username"]
    #     if (
    #         panel_login_account1 != rooms_login_account1
    #         and panel_login_account1 != panel_login_account2
    #         and rooms_login_account1 == phone_login_account
    #     ):
    #         raise AssertionError(
    #             f"Panels login account and Rooms login account are expected to be same, but found:\n Panels login account1: {panel_login_account1}\tRooms login account1: {rooms_login_account1}\n Panels login account2: {panel_login_account2}\nPhones login account is expected to be different than panels login account, but found: {phone_login_account}"
    #         )
    # if len(device_list) == 3:
    #     panel_login_account = config["devices"][device_list[0]]["user"]["username"]
    #     rooms_login_account = config["devices"][device_list[1]]["user"]["username"]
    #     phone_login_account = config["devices"][device_list[2]]["user"]["username"]
    #     if panel_login_account != rooms_login_account and rooms_login_account == phone_login_account:
    #         raise AssertionError(
    #             f"Panels login account and Rooms login account are expected to be same, but found:\n Panels login account: {panel_login_account}\tRooms login account: {rooms_login_account}\nPhones login account is expected to be different than panels login account, but found: {phone_login_account}"
    #         )
    if len(device_list) == 2:
        panel_login_account = config["devices"][device_list[0]]["user"]["username"]
        rooms_login_account = config["devices"][device_list[1]]["user"]["username"]
        if panel_login_account != rooms_login_account:
            raise AssertionError(
                f"Panels login account and Rooms login account are expected to be same, but found:\n Panels login account: {panel_login_account}\tRooms login account: {rooms_login_account}"
            )


def capture_bugreport_post_run(device_list=None):
    if "capture_bug_reports_post_run" not in config.keys() or config["capture_bug_reports_post_run"].lower() == "false":
        print("Bug reports collection post the automation run hasn't been enabled in the config")
        return
    if isinstance(device_list, list):
        devices = device_list
    else:
        if device_list is None:
            devices = list(config["devices"].keys())
        else:
            devices = device_list.split(",")
    print("Devices : ", devices)

    ###########################
    # Issues with parallel bugreport gathering - allow override:
    #
    skip_parallel = BuiltIn().get_variable_value("${exp_sequential_bugreports}")
    if skip_parallel:
        BuiltIn().log_to_console(f"Variable 'exp_sequential_bugreports': Sequentially fetching bugreports...")
        for _device_name in devices:
            _capture_bugreport_post_run_for_single_device(_device_name)
    else:
        shared_utils.run_parallel(devices, _capture_bugreport_post_run_for_single_device)


def _capture_bugreport_post_run_for_single_device(device):
    _udid = shared_utils.getconfig_device_udid(device)
    newpath = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "bug_reports")

    with bugreport_dir_lock:
        if not os.path.exists(newpath):
            os.makedirs(newpath)

    current_time = datetime.now().strftime("%H%M")
    newname = os.path.join(newpath, "bugreport_" + current_time + "_" + device)
    cmd = f"adb -s {_udid} bugreport {newname}"
    try:
        subprocess.check_output(cmd, text=True, shell=True)
        print(f"{device} bugreport in '{newname}'")
    except subprocess.CalledProcessError as cpe:
        print(f"{device} cannot create bugreport: '{cpe}'")


def is_ecs_enabled():
    if "ecs_flag" not in config.keys() or config["ecs_flag"] == "disabled":
        return False
    if config["ecs_flag"] != "enabled":
        raise AssertionError(f"'ecs_flag' field in config has unexpected value: {config['ecs_flag']}")
    # ECS flag is enabled for these accounts
    return True


def is_gcc_enabled():
    if "gcc_flag" not in config.keys() or config["gcc_flag"] == "disabled":
        return False
    elif config["gcc_flag"].lower() != "enabled":
        raise AssertionError(f"'gcc_flag' field in config has unexpected value: {config['gcc_flag']}")
    # GCC flag is enabled for these accounts
    return True


def select_cloud_option_from_signin_page(device, cloud):
    if cloud.lower() not in ["public", "gcc"]:
        raise AssertionError(f"Unexpected value for cloud option: {cloud}")
    if is_lcp(device):
        lcp_signinout.verify_signin_ui_on_lcp(device)
    else:
        wait_for_element(device, ztp_dict, "Step1_text_on_signin_page")
        wait_for_element(device, ztp_dict, "Step2_text_on_signin_page")
    wait_for_and_click(device, device_settings_dict, "fre_partner_settings")
    ztp_keywords.verify_cloud_option(device)
    if cloud.lower() == "public":
        ztp_keywords.verify_login_url_with_cloud_settings_as_public(device)
    elif cloud.lower() == "gcc":
        ztp_keywords.verify_login_url_with_cloud_setting_as_gcc(device)


def decode_device_spec(device):
    """
    This method decodes a 'device' specifier.
    Any device specifier can be encoded as '[device name]:[account type]'.
    If not specified, the default account type is 'user'.
    It returns device name and account type.
    """
    if type(device) != str:
        raise AssertionError(f"'{device}' is not a str type")

    _pieces = device.split(":")

    device_name = _pieces[0]

    if len(_pieces) > 1:
        account_type = _pieces[1]
    else:
        account_type = "user"

    # Sanity checks, test for KeyError:
    devices = shared_utils.getconfig_device_class(device)

    if device_name not in config[devices]:
        raise AssertionError(f"Config error: referenced device: '{device_name}' in not defined")
    if account_type not in config[devices][device_name]:
        raise AssertionError(f"Config error: device '{device_name}' has no '{account_type}' defined")

    return device_name, account_type


def get_credentials(device):
    """
    This method fetchs user credentials associated with the specified device.
    It returns username, password, device_name and account type.
    """
    if type(device) != str:
        raise AssertionError(f"'{device}' is not a str type")

    device_name, account_type = decode_device_spec(device)

    devices = device_type(device)

    # Sanity checks, test for KeyError:
    if not config[devices][device_name][account_type]["username"]:
        raise AssertionError(f"Config error: device '{device}' has no 'username' defined")
    if not config[devices][device_name][account_type]["password"]:
        raise AssertionError(f"Config error: device '{device}' has no 'password' defined")

    username = config[devices][device_name][account_type]["username"]
    password = config[devices][device_name][account_type]["password"]

    return username, password, device_name, account_type


def capture_config_details():
    """Test if config printing is enabled"""
    if "capture_config" in config.keys() and config["capture_config"].lower() == "enabled":
        return True
    return False


def navigate_to_screen_using_adb(device, activity):
    if not getconfig_is_emulator(device):
        print(f"WARN - {device} is not emulator. Should not navigate using adb.")
        return
    _udid = device_udid(device)
    cmd_root = ["adb", "-s", str(_udid), "root"]
    cmd_launch = [
        "adb",
        "-s",
        str(_udid),
        "shell",
        "am",
        "start",
        "-a",
        "android.intent.action.VIEW",
        "-c",
        "android.intent.category.DEFAULT",
        "-n",
        str(activity),
    ]
    try:
        subprocess.run(cmd_root, capture_output=True, encoding="utf-8", check=True, shell=True)
        _result = subprocess.run(cmd_launch, capture_output=True, encoding="utf-8", check=True, shell=True)
        print(f"{device} launch activity result: '{_result}'")
    except subprocess.CalledProcessError:
        print(f"{device} failed to launch activity: {activity}")


def is_screen_size_7_inch_or_more(device):
    _model = device_model(device)
    b_is_listed = _model in [
        # "santa cruz","bakersfield" removed due to this bug 3318018
        "redmond",
        "san jose",
        "long island",
        "queens",
    ]

    print(f"{device}: '{_model}' is_screen_size_7_inch_or_more: {b_is_listed}")
    return b_is_listed


def is_hard_dial_pad_present(device):
    _model = device_model(device)
    b_is_listed = _model in [
        "riverside",
        "riverside_13",
        "bakersfield",
        "bakersfield_13",
        "santa cruz",
        "santa cruz_13",
        "gilbert",
    ]

    print(f"{device}: '{_model}' is_hard_dial_pad_present: {b_is_listed}")
    return b_is_listed


def is_conf(device):
    _model = device_model(device)
    b_is_listed = _model in ["tacoma", "manhattan", "berkely"]

    print(f"{device}: '{_model}' is_conf: {b_is_listed}")
    return b_is_listed


def return_to_home_screen(device_list):
    devices = device_list.split(",")
    for device in devices:
        call_views_keywords.go_back_to_previous_page(device)
        time.sleep(2)
        click_if_present(device, home_screen_dict, "home_bar_icon")
        call_views_keywords.go_back_to_previous_page(device)


def run_parallel(device_list, func, *args, **kwargs) -> list:
    print("Note: This 'run_parallel' is moved to shared_utils")
    return new_run_parallel(device_list, func, *args, **kwargs)


def tap_outside_the_popup(device, container_element):
    driver = obj.device_store.get(alias=device)
    device_size = driver.get_window_size()
    device_height = device_size["height"]
    device_width = device_size["width"]
    time.sleep(display_time)
    print("Device co-ordinates : ", device_width, device_height)

    # Getting the location of the container_element x and y
    c_location_x = container_element.location["x"]
    c_location_y = container_element.location["y"]
    print(f"container coordinates location: ", c_location_x, c_location_y)

    # Getting the size of the container_element width and height
    c_size_width = container_element.size["width"]
    c_size_height = container_element.size["height"]
    print(f"Size of the container: ", c_size_width, c_size_height)

    if "console" not in device:
        if is_lcp(device):
            if c_location_x >= 0:
                ele_tap_x = c_size_width + 10

            if c_location_y >= 0:
                ele_tap_y = c_size_width + 10

            try:
                driver.tap([(ele_tap_x, ele_tap_y)])
                print(f"{device}: Tapped the coordinates: ", ele_tap_x, ele_tap_y)
            except Exception as e:
                print(f"Error tapping coordinates: \n{traceback.format_exc()}")
            return

    if c_location_x <= 0:
        ele_tap_x = c_size_width - 10
    elif c_location_x >= device_width:
        ele_tap_x = c_location_x - 10
    else:
        ele_tap_x = c_location_x - 10

    if c_location_y <= 0:
        ele_tap_y = c_size_height + 10
    elif c_location_y >= device_height:
        ele_tap_y = c_location_y - 10
    else:
        ele_tap_y = device_height - 10

    if ele_tap_x >= device_width:
        ele_tap_x = device_width - 10
    elif ele_tap_y >= device_height:
        ele_tap_y = device_height - 10

    try:
        driver.tap([(ele_tap_x, ele_tap_y)])
        print(f"{device}: Tapped the coordinates: ", ele_tap_x, ele_tap_y)
    except Exception as e:
        print(f"Error tapping coordinates: \n{traceback.format_exc()}")


def change_toggle_button(device, sel_dict, sel_dict_key, desired_state, must_change=False, post_click_delay=4):
    # Check/Uncheck a toggle button.
    # If 'must_change' is True and the toggle is already in 'desired_state', raise
    if desired_state.lower() not in ["on", "off"]:
        raise AssertionError(f"{device}: Illegal value for 'desired_state': {desired_state}")

    if desired_state.lower() == "on":
        desired_state = "true"
    else:
        desired_state = "false"
    toggle_button = wait_for_element(device, sel_dict, sel_dict_key)
    _model = device_model(device)
    if _model in ["arlington", "plano"] and sel_dict_key == "time_format_option":
        check_attribute = "selected"
    else:
        check_attribute = "checked"
    actual_attribute_state = toggle_button.get_attribute(check_attribute).lower()
    print(f"before clicking: actual_attribute_state:{actual_attribute_state} \ndesired_state:{desired_state}")
    if actual_attribute_state != desired_state:
        wait_for_and_click(device, sel_dict, sel_dict_key)
        sleep_with_msg(device, post_click_delay, "Let the element stabilize post click")
        toggle_button = wait_for_element(device, sel_dict, sel_dict_key)
        actual_attribute_state = toggle_button.get_attribute(check_attribute).lower()
        if actual_attribute_state != desired_state:
            raise AssertionError(
                f"{device}: Toggle button '{sel_dict_key}' did not change after clicking. Expected '{desired_state}', actual '{actual_attribute_state}'"
            )
    elif must_change:
        raise AssertionError(f"{device}: Toggle button '{sel_dict_key}' is already '{actual_attribute_state}'")
    print(f"{device}: Toggle button '{sel_dict_key}' is now '{actual_attribute_state}'")


def verify_toggle_button(device, sel_dict, sel_dict_key, desired_state):
    if desired_state.lower() not in ["on", "off"]:
        raise AssertionError(f"{device}: Illegal value for 'desired_state': {desired_state}")

    if desired_state.lower() == "on":
        desired_state = "true"
    else:
        desired_state = "false"

    toggle_button = wait_for_element(device, sel_dict, sel_dict_key)
    actual_checked_state = toggle_button.get_attribute("checked").lower()
    if actual_checked_state != desired_state:
        raise AssertionError(
            f"{device}: Toggle button '{sel_dict_key}' is not in desired state:{desired_state} actual state:'{actual_checked_state}'"
        )
    else:
        print(f"Toggle is already in desired state: {desired_state}")


def return_toggle_status(device, sel_dict, sel_dict_key):
    toggle_button = wait_for_element(device, sel_dict, sel_dict_key)
    actual_checked_state = toggle_button.get_attribute("checked").lower()
    if actual_checked_state == "true":
        return True
    else:
        return False


def is_portrait_conf(device):
    _model = device_model(device)
    b_is_listed = _model in ["tacoma", "berkely"]

    print(f"{device}: '{_model}' is_portrait_conf: {b_is_listed}")
    return b_is_listed


def get_adb_output(device, adb_command):
    _ret = subprocess.check_output(f"adb -s {device_udid(device)} {adb_command}", shell=True, encoding="utf-8").strip()
    return _ret


def device_privateline_number(device):
    device_name, account_type = decode_device_spec(device)
    devices = device_type(device)
    return config[devices][device_name][account_type]["privatelinenumber"]


def check_clickable_state(device, sel_dict, sel_dict_key, desired_state):
    element_time = wait_for_element(device, sel_dict, sel_dict_key)
    actual_clickable_state = element_time.get_attribute("clickable").lower()
    if actual_clickable_state != desired_state:
        raise AssertionError(
            f"{device}: {sel_dict_key} did not change after clicking. Expected :'{desired_state}', actual :'{actual_clickable_state}'"
        )


def check_enabled_state(device, sel_dict, sel_dict_key, desired_state):
    element_time = wait_for_element(device, sel_dict, sel_dict_key)
    actual_clickable_state = element_time.get_attribute("enabled").lower()
    if actual_clickable_state != desired_state:
        raise AssertionError(
            f"{device}: {sel_dict_key} Unexpected Mismatch:'{desired_state}', actual :'{actual_clickable_state}'"
        )


def scroll_the_page(device, container_element, swiping):
    if not swiping.lower() in ["up", "down"]:
        raise AssertionError(f"Illegal swiping specified: '{swiping}'")
    driver = obj.device_store.get(alias=device)

    container_bounds = container_element.get_attribute("bounds").replace("][", ",").strip("]").strip("[").split(",")
    cont_cord = list(map(int, container_bounds))
    print(f"Container bounds: {cont_cord}")
    x1 = cont_cord[0] + (cont_cord[2] - cont_cord[0]) / 2
    x2 = x1

    if swiping.lower() == "up":
        y1 = cont_cord[1] + 4 * (cont_cord[3] - cont_cord[1]) / 5
        y2 = cont_cord[1] + (cont_cord[3] - cont_cord[1]) / 5

    elif swiping.lower() == "down":
        y1 = cont_cord[1] + (cont_cord[3] - cont_cord[1]) / 5
        y2 = cont_cord[1] + 4 * (cont_cord[3] - cont_cord[1]) / 5

    try:
        print(f"{device}: scrolling page co-ordinates:({x1},{y1}), ({x2}, {y2})")
        driver.swipe(x1, y1, x2, y2)

    except Exception as e:
        print(f"Error in scrolling page coordinates: \n{traceback.format_exc()}")

    time.sleep(2)


def refresh_within_the_container(device, sel_dict, sel_dict_key):
    driver = obj.device_store.get(alias=device)
    container = wait_for_element(device, sel_dict, sel_dict_key)
    container_bounds = container.get_attribute("bounds").replace("][", ",").strip("]").strip("[").split(",")
    cont_cord = list(map(int, container_bounds))
    print(f"Container bounds: {cont_cord}")
    x1 = cont_cord[0] + (cont_cord[2] - cont_cord[0]) / 2
    y1 = cont_cord[1] + 20
    x2 = x1
    y2 = y1 + 4 * (cont_cord[3] - cont_cord[1]) / 5
    driver.swipe(x1, y1, x2, y2)
    time.sleep(action_time)
    print(f"{device}: swiped and refreshed co-ordinates:({x1},{y1}), ({x2}, {y2})")


def press_hardkeys(device, hardkey_intent):
    """Use ADB to press the specified hard keys"""
    _udid = device_udid(device)
    subprocess.call(
        f"adb -s {_udid} shell input keyevent {hardkey_intent}",
        shell=True,
    )


def long_press_hardkeys(device, hardkey_intent):
    """Use ADB to press the specified hard keys"""
    _udid = device_udid(device)
    subprocess.call(
        f"adb -s {_udid} shell input keyevent --longpress {hardkey_intent}",
        shell=True,
    )


def perform_gestures_on_homescreen(device, action):
    driver = obj.device_store.get(alias=device)
    window_size = driver.get_window_size()
    print("Window size: ", window_size)
    height = window_size["height"]
    width = window_size["width"]
    print("Window Width and height :", width, height)
    if width > height:
        if action == "swipe_right":
            print(
                "(0), (height / 2), (width / 5), height / 2: ",
                0,
                height / 2,
                (width / 5),
                height / 2,
            )
            driver.swipe((0), (height / 2), (width / 5), (height / 2))
            time.sleep(action_time)
            driver.swipe((0), height / 2, (width / 5), (height / 2))
        elif action == "swipe_left":
            print(
                "(width-10), (height / 2), (width - 300), height / 2: ",
                width - 10,
                height / 2,
                (width - 200),
                height / 2,
            )
            driver.swipe((width - 10), (height / 2), (width - 300), (height / 2))
            time.sleep(action_time)
            driver.swipe((width - 10), height / 2, (width - 300), (height / 2))
        elif action == "swipe_up":
            print(
                "(width / 2), (height-10), (width / 2), (height) / 2): ",
                width / 2,
                height - 10,
                (width / 2),
                (height / 2),
            )
            driver.swipe((width / 2), (height - 10), (width / 2), (height / 2))
            time.sleep(action_time)
            driver.swipe((width / 2), height - 10, (width / 2), (height / 2))
        elif action == "swipe_down":
            calendar_keywords.scroll_down_main_tab(device)
        elif action == "drag_and_drop":
            if is_panel(device):
                perform_drag_and_drop(
                    device,
                    "QR code",
                    home_screen_dict,
                    "qr_code_container",
                    "Agenda view",
                    panels_home_screen_dict,
                    "agenda_view",
                )
            else:
                perform_drag_and_drop(
                    device, "QR code", tr_home_screen_dict, "qr_code", "Agenda view", tr_home_screen_dict, "more_button"
                )
        elif action == "swipe_top_to_bottom":
            print(
                "(width / 2), (10), (width / 2), (height-5): ",
                width / 2,
                10,
                (width / 2),
                (height - 5),
            )
            driver.swipe((width / 2), (10), (width / 2), (height - 5))
            time.sleep(action_time)
            driver.swipe((width / 2), 10, (width / 2), (height - 5))
        elif action == "double_tap":
            for i in range(2):
                wait_for_and_click(device, panels_home_screen_dict, "wallpaper")
    else:
        raise AssertionError(f"{device}: Width is less than height")


def perform_the_scrolling(device, container_element):
    """Helper function to perform the swipe action on the meeting tab."""
    driver = obj.device_store.get(alias=device)

    # Get the bounds of the container element
    container_bounds = container_element.get_attribute("bounds").replace("][", ",").strip("]").strip("[").split(",")
    container_bounds = list(map(int, container_bounds))
    print(f"Container bounds: {container_bounds}")

    # Calculate X-axis center, and Y-axis scroll start and end points
    x = (container_bounds[0] + container_bounds[2]) // 2
    y_start = container_bounds[3]  # Bottom of the container (scroll start)
    y_end = container_bounds[1]  # Top of the container (scroll end)

    # Perform the swipe action
    driver.swipe(x, y_start, x, y_end)
    print(f"{device}: Scrolled from ({x}, {y_start}) to ({x}, {y_end})")


def press_specific_hardkey(device, hard_key, status):
    # hard_key should be in upper case
    if hard_key not in ["HANDSETHOOK", "SPEAKER", "HEADSETHOOK", "BLUETOOTH"]:
        raise ValueError(f"{device}: Invalid value for hard_key:{hard_key}")
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"{device}: Illegal value for 'status': {status}")
    _udid = device_udid(device)
    val = 1 if status.lower() == "on" else 0
    hardkey_intent = f"{hard_key} {val}"
    reslut = subprocess.call(
        f"adb -s {_udid} shell am broadcast -n com.microsoft.skype.teams.ipphone/.IpPhoneBroadcastReceiver -a com.microsoft.skype.teams.ipphone.partner.PHONE_STATE_UPDATED --ei {hardkey_intent}",
        shell=True,
    )
    if reslut != 0:
        raise AssertionError(f"{device}: Failed to press hardkey: {hard_key} with status: {status}")


def is_landscape_device_5_inch_or_above(device):
    _model = device_model(device)
    if _model in ["bakersfield", "gilbert", "santa cruz", "santa cruz_13", "bakersfield_13"]:
        print(f"{device}: '{_model}' is landscape device 5 inch or above device: {_model}")
        return _model


def has_hardkey_teams_button_supported_device(device):
    _model = device_model(device)
    if _model in [
        "riverside",
        "riverside_13",
        "bakersfield",
        "bakersfield_13",
        "santa cruz",
        "santa cruz_13",
        "redmond",
        "Seattle",
        "Kirkland",
        "gilbert",
        "glendale",
    ]:
        print(f"{device}: '{_model}' has_hardkey_teams_button_supported_device")
        return True

    return False


def dismiss_TDC_advertisements(device):
    """
    Method attempts to dismiss Teams ads which intercept clicks.
    If successful return True, else False.
    """
    _device_class = shared_utils.getconfig_device_class(device)
    if _device_class != "browsers":
        raise AssertionError(f"{device}: Unexpected device class '{_device_class}' is not 'browsers'")

    print(f"{device}: Checking for ads to dismiss...")

    # SNIFFERS - I think the pop-up changed, the latest has no 'span' - check for both, clean up when there is evidence.
    # The new pop-up allows dismiss/close - we want that if available.
    if is_element_present(device, web_signin_dict, "popup_get_started_button"):
        shared_utils.snif_print(device, "The OLD 'New Teams UI Layout' offer is present.")
    if is_element_present(device, web_signin_dict, "popup_get_started_button_new"):
        shared_utils.snif_print(device, "The NEW 'New Teams UI Layout' offer is present.")

    if click_if_present(device, web_signin_dict, "got_it_button"):
        return True

    if click_if_present(device, web_signin_dict, "got_it_button2"):
        return True

    if click_if_present(device, web_signin_dict, "do_it_later"):
        return True

    if click_if_present(device, web_signin_dict, "maybe_later"):
        return True

    if click_if_present(device, web_signin_dict, "popup_close_get_started_button"):
        # The 'new Calendar style' offer - just close.
        return True

    # Removed - Improper implementation: Just because 'resize_frame' is present it does not necessarily dismiss anything.
    #   "got_it_button2" was already attempted - fix needed, or removal:
    # if is_element_present(device, web_signin_dict, "resize_frame"):
    #     click_if_present(device, web_signin_dict, "resize_frame", "xpath1")
    #     click_if_present(device, web_signin_dict, "got_it_button2")
    #     return True

    # Nothing was dismissed
    print(f"{device}: No ads were dismissed.")
    return False


def convert_dict_to_json(data):
    # Convert dictionary to a nicely formatted JSON string
    return json.dumps(data, indent=4)


def device_emergency_location(device):
    device_name, _ = decode_device_spec(device)
    devices = device_type(device)
    return config[devices][device_name]["Emergency_location"].lower().strip()


def get_drop_text(e: WebDriverException):
    _text = str(e).lower()
    if _text.find("cannot be proxied") > 0:
        return "cannot be proxied"
    if _text.find("could not proxy") > 0:
        return "could not proxy"
    if _text.find("socket hang up") > 0:
        return "socket hang up"
    return None


def wait_for_device_restart_and_reconnect(device_list, wait_attempts=15):
    _all_devices = shared_utils.make_list(device_list)
    shared_utils.run_parallel(_all_devices, _wait_and_reconnect, wait_attempts)


def _wait_and_reconnect(device, wait_attempts):
    # Device has been told to reboot.
    print(f"{device}: STARTING wait_for_device_restart_and_reconnect(wait_attempts={wait_attempts})")

    driver = obj.device_store.get(alias=device)

    # Loop, waiting for Appium Web to fail.
    # Expected failure WebDriverException message:
    #   Message: device_1: An unknown server-side error occurred while processing the command. Original error: 'POST /element' cannot be proxied to UiAutomator2 server because the instrumentation process is not running (probably crashed).
    #   Message: An unknown server-side error occurred while processing the command. Original error: Could not proxy command to the remote server. Original error: socket hang up
    msg = None
    for attempt in range(wait_attempts):
        try:
            x = WebDriverWait(driver, 1).until(
                EC.presence_of_element_located((MobileBy.ID, "com.microsoft.skype.teams.ipphone:id/FAKE"))
            )
            print(f"{device}: Unexpected (Ignored): find returned: {x}")
        except WebDriverException as e:
            msg = get_drop_text(e)
            if msg:
                break

            # Quietly ignore expected exceptions:
            if str(e).lower().find("NoSuchElementError".lower()) > 0:
                print(f"{device}: Ignored: NoSuchElementError")
            else:
                print(f"{device}: Unexpected (Ignored): {e}")
        time.sleep(1)
    if not msg:
        raise AssertionError(
            f"{device} did not restart: Expected Webdriver close did not happen after {attempt} attempts."
        )

    print(f"{device}: after {attempt} attempts, Webdriver reports: {msg}")

    print(f"{device}: wait_for_device_offline")
    device_control.wait_for_device_offline(device, config=None)
    #
    #   Adb connection is now 'offline' - device is rebooting.
    #
    # Now wait, adb is attempting to re-establish
    print(f"{device}: wait_for_device_online")
    # max_attempts - IpPhones complete around attempt 120 - increased to 240:
    # newly_online_sleep - IP Phones will not appear 'online' until after Teams homescreen has appeared.
    #   This behavior might be device dependent.
    device_control.wait_for_device_online(device, max_attempts=240, newly_online_sleep=20, config=None)

    print(f"{device}: offline/online transition complete")

    # Webdriver not connected anymore, forget it:
    print(f"{device}: teardown WebDriver")
    obj.teardown_device_driver(device)

    shared_utils.sleep_with_msg(device, 5, "Allow Webdriver termination")

    # restart Appium webdriver (and don't reset app):
    print(f"{device}: restart Appium webdriver")
    obj.setup_device_driver(device, config, resetApp=False)

    print(f"{device}: FINISHED wait_for_device_restart_and_reconnect - RESTARTED AND READY")


def room_camera_supported_devices(device):
    _model = device_model(device)
    if _model in ["houston", "austin", "aurlington", "dallas", "sanantonia", "laredo"]:
        print(f"{device}: is supported for room camera")
        return True
    return False


def verify_keyboard_pop_up_while_entering_input(device, appear):
    appear_lower = appear.lower()
    if appear_lower not in ["yes", "on"]:
        raise AssertionError(f"Unexpected value for keyboard: {appear}")
    udid = device_udid(device)
    sleep_with_msg(device, 3, "Waiting for keyboard to pop up...")
    output = (
        subprocess.check_output(f"adb -s {udid} shell dumpsys input_method | findstr mInputShown", shell=True)
        .decode("utf-8")
        .strip()
    )
    keyboard_shown = "mInputShown=true" in output
    if appear_lower == "on":
        if keyboard_shown:
            print(f"{device}: Keyboard popped up as expected.")
            return True
        else:
            raise AssertionError(f"{device}: Expected keyboard popup, but it did not appear.")
    else:
        if not keyboard_shown:
            print(f"{device}: Keyboard did not pop up as expected.")
            return True
        else:
            raise AssertionError(f"{device}: Expected keyboard not to pop up, but it appeared.")
