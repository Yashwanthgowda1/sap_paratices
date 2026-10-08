from initiate_driver import obj_dev as obj
from initiate_driver import config
from Libraries.Selectors import load_json_file
import common
import time
import subprocess
import tr_call_keywords
from Libraries import SignInOut
from Libraries import shared_utils

display_time = 2
action_time = 3

calls_dict = load_json_file("resources/Page_objects/Calls.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
tr_settings_dict = load_json_file("resources/Page_objects/tr_settings.json")
tr_device_settings_dict = load_json_file("resources/Page_objects/tr_device_settings.json")
tr_console_settings_dict = load_json_file("resources/Page_objects/rooms_console_settings.json")
tr_console_signin_dict = load_json_file("resources/Page_objects/rooms_console_signin.json")
sign_dict = load_json_file("resources/Page_objects/Signin.json")
tr_calendar_dict = load_json_file("resources/Page_objects/tr_calendar.json")
device_settings_dict = load_json_file("resources/Page_objects/Device_settings.json")
signin_dict = load_json_file("resources/Page_objects/Signin.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
tr_console_home_screen_dict = load_json_file("resources/Page_objects/rooms_console_home_screen.json")


def tap_on_settings_page(console):
    print("Console :", console)
    common.wait_for_and_click(console, tr_settings_dict, "settings_button")
    time.sleep(3)
    if not common.is_element_present(console, settings_dict, "Device_Settings"):
        SignInOut.swipe_for_sign_out(console)
    common.wait_for_element(console, settings_dict, "Device_Settings")


def click_on_close_button(console_list):
    consoles = console_list.split(",")
    for console in consoles:
        print("Console :", console)
        time.sleep(3)
        if not common.click_if_present(console, tr_console_settings_dict, "back_layout"):
            common.wait_for_and_click(console, tr_console_settings_dict, "back_button")


def click_on_back_layout_btn(console):
    consoles = console.split(",")
    for console in consoles:
        print("Console :", console)
        common.wait_for_and_click(console, tr_console_settings_dict, "back_layout")


def tap_on_device_center_point(console):
    consoles = console.split(",")
    for console in consoles:
        time.sleep(action_time)
        driver = obj.device_store.get(alias=console)
        window_size = driver.get_window_size()
        height = window_size["height"]
        width = window_size["width"]
        subprocess.call(
            "adb -s {} shell input tap {} {}".format(
                config["consoles"][console]["desired_caps"]["udid"].split(":")[0],
                width / 2,
                height / 2,
            ),
            shell=True,
        )
        time.sleep(display_time)
        print("Tapped co-ordinates : ", width / 2, height / 2)


def verify_options_inside_settings_page(console):
    print("device : ", console)
    account = "user"
    if ":" in console:
        user = console.split(":")[1]
        console = console.split(":")[0]
        print("User account : ", user)
        if user.lower() == "meeting_user":
            account = "meeting_user"
    print("Account :", account)
    if account == "meeting_user":
        # according to the new UI from report an issue is removed from the about page
        # common.wait_for_element(console, tr_settings_dict, "Report_an_issue")
        common.wait_for_element(console, tr_settings_dict, "about")
        # common.wait_for_element(console, tr_settings_dict, "device_health")
        common.wait_for_element(console, tr_device_settings_dict, "device_settings")
    else:
        common.wait_for_element(console, tr_settings_dict, "meetings_button")
        common.wait_for_element(console, tr_settings_dict, "calling_button")
        common.wait_for_element(console, tr_settings_dict, "wallpapers_button")
        common.wait_for_element(console, tr_settings_dict, "Report_an_issue")
        common.wait_for_element(console, tr_settings_dict, "about")
        common.wait_for_element(console, tr_settings_dict, "device_health")
        common.wait_for_element(console, settings_dict, "Sign_out")
        common.wait_for_element(console, tr_device_settings_dict, "device_settings")


def device_setting_back_btn(console):
    print("console :", console)
    subprocess.call(
        "adb -s {} shell input keyevent 4".format(config["consoles"][console]["desired_caps"]["udid"].split(":")[0]),
        shell=True,
    )
    pass


def tap_on_device_settings_page(console):
    print("console :", console)
    common.wait_for_and_click(console, tr_device_settings_dict, "device_settings")
    model = common.device_model(console)
    if model.lower() != "vermont":
        common.wait_for_element(console, settings_dict, "Device_Settings")


def tap_on_device_right_corner(console):
    consoles = console.split(",")
    for console in consoles:
        time.sleep(action_time)
        driver = obj.device_store.get(alias=console)
        window_size = driver.get_window_size()
        height = window_size["height"]
        width = window_size["width"]
        subprocess.call(
            "adb -s {} shell input tap {} {}".format(
                config["consoles"][console]["desired_caps"]["udid"].split(":")[0], width - 20, 20
            ),
            shell=True,
        )
        time.sleep(display_time)
        print("Tapped co-ordinates : ", width - 20, 20)


def user_checks_device_type(console):
    print("Check device type on :", console)
    udid_ = config["consoles"][console]["desired_caps"]["udid"]
    print(udid_)
    dev_type = subprocess.check_output("adb -s " + udid_ + " shell settings get secure teams_device_type", shell=True)
    output = dev_type.splitlines()[0].rsplit()[-1].strip().lower()
    actual_val = str(output, "utf-8")
    print("Device Type is {} ".format(actual_val))
    expected_val = (config["console_type"]).strip().lower()
    if actual_val != expected_val:
        raise AssertionError(
            f"{console}: Actual device type: {actual_val} doesn't match expected value: {expected_val}"
        )


def verify_user_signing_with_wrong_password(console):
    username = config["consoles"][console]["user"]["username"]
    wrong_password = config["user"]["invalid_password"]
    if not common.is_element_present(console, sign_dict, "dfc_login_code"):
        common.wait_for_element(console, sign_dict, "refresh_code_button")
    common.wait_for_and_click(console, sign_dict, "sign_in_on_the_device")
    search_input = common.wait_for_element(console, sign_dict, "Username", "xpath")
    search_input.send_keys(username)
    print("Entered username")
    common.wait_for_and_click(console, sign_dict, "Sign_in_button")
    common.wait_for_element(console, sign_dict, "Password").send_keys(wrong_password)
    print(f"{console}: entered the wrong password")
    if not common.click_if_present(console, sign_dict, "Sign_in"):
        common.wait_for_and_click(console, sign_dict, "signin_button")
    common.wait_for_element(console, sign_dict, "invalid_password_error")


def verify_options_inside_calling(console):
    common.wait_for_element(console, tr_device_settings_dict, "voicemail")
    tr_call_keywords.swipe_till_end_page(console)
    common.wait_for_element(console, tr_device_settings_dict, "ringtones")
    tr_call_keywords.swipe_till_end_page(console)
    common.wait_for_element(console, tr_device_settings_dict, "block_calls")
    tap_on_device_right_corner(console)


def verify_console_pairing_option(console):
    common.wait_for_and_click(console, tr_device_settings_dict, "console_pairing")
    common.wait_for_element(console, tr_device_settings_dict, "reset_pairing")
    common.wait_for_element(console, tr_device_settings_dict, "unpair_devices")


def verify_inside_general_option(console):
    common.wait_for_element(console, tr_device_settings_dict, "front_of_room_display")
    common.wait_for_element(console, tr_device_settings_dict, "enable_touchscreen_controls")
    common.wait_for_element(console, tr_device_settings_dict, "wallpaper")


def modify_touchscreen_control_toggle_state(console, state):
    if not state.lower() in ["enabled", "disabled"]:
        raise AssertionError(f"Unexpected state:{state}")
    state = "on" if state.lower() == "enabled" else "off" if state.lower() == "disabled" else state
    common.change_toggle_button(console, tr_device_settings_dict, "enable_touchscreen_controls_toggle_ON", state)


def verify_intents_for_touchscreen_control(device, state):
    if not state.lower() in ["enabled", "disabled"]:
        raise AssertionError(f"Unexpected state:{state}")
    driver = obj.device_store.get(alias=device)
    time.sleep(5)
    logs_current = driver.get_log("logcat")
    # print ("Current log cat : \n", logs_current)
    filter = "SETTINGS_ENABLE_TOUCHSCREEN_CONTROLS"
    if state.lower() == "enabled":
        filter_mode = "true"
    elif state.lower() == "disabled":
        filter_mode = "false"
    res = []
    for i in logs_current:
        if filter in i["message"] and filter_mode in i["message"]:
            print("Intent : ", i)
            res.append(i)
    if len(res) == 0:
        raise AssertionError("Intent not found")
    else:
        print("Intent {} found in logcat".format(res))


def verify_meeting_chat_under_admin_settings(console):
    common.wait_for_element(console, tr_device_settings_dict, "show_meeting_chat")
    common.wait_for_element(console, tr_calendar_dict, "chat_toggle_in_device_setting")


def verify_enable_touchscreen_controls_with_toggle(console):
    common.wait_for_element(console, tr_device_settings_dict, "front_of_room_display")
    common.wait_for_element(console, tr_device_settings_dict, "enable_touchscreen_controls")
    common.wait_for_element(console, tr_device_settings_dict, "enable_if_room_has_touchscreen_display")
    common.wait_for_element(console, tr_device_settings_dict, "enable_touchscreen_controls_toggle_off")


def verify_and_click_on_unpairing_option(console):
    verify_console_pairing_option(console)
    common.wait_for_and_click(console, tr_device_settings_dict, "unpair_devices")
    common.wait_for_element(console, calendar_dict, "alert_title")
    common.wait_for_and_click(console, device_settings_dict, "ok")
    common.sleep_with_msg(console, 10, "wait until the unpairing the device")
    common.wait_for_element(console, signin_dict, "sign_in_on_the_device")


def verify_and_reset_the_device_pairing(console):
    verify_console_pairing_option(console)
    common.wait_for_and_click(console, tr_device_settings_dict, "reset_pairing")
    common.wait_for_element(console, tr_console_signin_dict, "room_name")
    if not common.is_element_present(console, tr_console_signin_dict, "select_device_paring_text"):
        common.wait_for_element(console, tr_console_signin_dict, "auto_pair_msg")
    common.wait_for_element(console, tr_console_home_screen_dict, "meet_now_icon")
    common.wait_for_element(console, tr_console_home_screen_dict, "more_option")


def check_soft_keyboard_details(console, should_be_visible, message):
    time.sleep(5)
    _udid = common.device_udid(console)
    key = subprocess.check_output("adb -s " + _udid + " shell dumpsys window", shell=True, stderr=subprocess.STDOUT)
    key_check = str(key, "utf-8")
    _model = common.device_oem(console)
    if _model != "vermont":
        if ("mInputMethodTarget" in key_check) != should_be_visible:
            raise AssertionError(message)


def verify_soft_keyboard_hiding_on_while_search_and_calling_function(console):
    common.wait_for_and_click(console, tr_console_home_screen_dict, "call_icon")
    common.wait_for_element(console, calls_dict, "search_contact_box")
    check_soft_keyboard_details(console, True, f"{console} after clicking on dial pad, keyboard is not visible")
    common.wait_for_and_click(console, calls_dict, "one")
    check_soft_keyboard_details(console, False, f"{console} after dialing the number, keyboard is still visible")
    common.wait_for_and_click(console, calls_dict, "search_contact_box")
    check_soft_keyboard_details(console, True, f"{console} after clicking on search icon, keyboard is not visible")
    tap_on_device_center_point(console)
    check_soft_keyboard_details(console, False, f"{console} after clicking on search icon, keyboard is still visible")


def tap_on_device_left_bottom(console):
    consoles = console.split(",")
    for console in consoles:
        time.sleep(action_time)
        driver = obj.device_store.get(alias=console)
        window_size = driver.get_window_size()
        height = window_size["height"]
        width = window_size["width"]

        # Tap at left-bottom corner (5% from left, 95% from top)
        x = int(width * 0.05)
        y = int(height * 0.95)

        subprocess.call(
            "adb -s {} shell input tap {} {}".format(
                config["consoles"][console]["desired_caps"]["udid"].split(":")[0],
                x,
                y,
            ),
            shell=True,
        )
        time.sleep(display_time)
        print("Tapped co-ordinates : ", x, y)


def change_wallpaper_on_console(console, wallpaper):
    if wallpaper.lower() not in ["seaside_bliss", "vivid"]:
        raise AssertionError(f"Unexpected wallpaper to select:{wallpaper}")
    common.wait_for_element(console, tr_device_settings_dict, "front_of_room_display")
    common.wait_for_and_click(console, tr_device_settings_dict, "wallpaper")
    common.wait_for_element(console, tr_device_settings_dict, "background_wallpaper_text")
    if wallpaper.lower() == "seaside_bliss":
        dict_key = "seaside_Bliss_wallpaper_not_select"
    else:
        dict_key = "vivid_wallpaper_not_select"
    common.wait_for_and_click(console, tr_device_settings_dict, dict_key)
    common.sleep_with_msg(console, 5, "Waiting for apply wallpaper")


def verify_signin_with_license_is_not_supported_account_used_for_signin_norden(device):
    username, password = shared_utils.getconfig_account_credentials(device)
    device, account_type = shared_utils.decode_device_specifier(device)
    print(device, account_type)
    if not common.is_element_present(device, sign_dict, "dfc_login_code"):
        # Given that this device has just been reset, this will probably never fire:
        if not common.click_if_present(device, sign_dict, "refresh_code_button"):
            print(f"{device}: Refresh code was not present")
        common.sleep_with_msg(device, 7, "Clicked on refresh code, waiting for UI to Stabilize")
        common.wait_for_element(device, sign_dict, "dfc_login_code")

    # At this point on few devices [A20] we are seeing Dialog "Long press open system menu" # BUG 3525081
    common.wait_for_and_click(device, sign_dict, "sign_in_on_the_device")
    common.wait_for_element(device, sign_dict, "Username").send_keys(username)
    print(f"{device}: entered the username '{username}'")
    _model = shared_utils.getconfig_device_model(device)
    if (
        _model
        not in [
            "spokane",
            "sammamish",
            "irvine",
            "oakland",
            "eureka",
            "everett",
            "renton",
            "vancouver",
            "palo alto",
            "pullman",
            "kent",
        ]
        or _model == "Flint"
    ):
        common.hide_keyboard(device)
    common.wait_for_and_click(device, sign_dict, "Sign_in_button")
    common.sleep_with_msg(device, 7, "Waiting for the password entry screen to appear")
    common.wait_for_element(device, sign_dict, "Password").send_keys(password)
    print(f"{device}: entered the password")
    common.wait_for_and_click(device, sign_dict, "Sign_in")
    if account_type in [
        "personal_policy_user",
        "maximum_os_account",
        "minimum_os_account",
    ]:
        error_message = common.wait_for_element(device, sign_dict, "signin_failure_error", wait_attempts=60).text
        print(error_message)
        allowed_error_messages = [
            "Your current license is not supported on this device. Ask your IT administrator for details.",
            "Device OS version doesn't meet maximum OS company policy. Contact your admin",
            "Device OS version doesn't meet minimum OS company policy. Contact your admin",
            "This device isn’t enrolled in device administrator. Contact your admin",
        ]
        if error_message.strip() not in [msg.strip() for msg in allowed_error_messages]:
            raise AssertionError(f"Unsupported account error message is not found: {error_message}")
    else:
        raise AssertionError(f"account type {account_type} is not recognized")
