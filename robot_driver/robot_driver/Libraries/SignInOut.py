import time
import threading
import subprocess
import uuid
import traceback

from selenium.webdriver.support import expected_conditions as EC
from robot.libraries.BuiltIn import BuiltIn

from Libraries.initiate_driver import obj_dev as obj
from Libraries.initiate_driver import config
from Libraries.initiate_driver import root_console
from Libraries import shared_utils
from Libraries.shared_utils import (
    encode_devices_and_accounts,
    getconfig_all_device_names,
    decode_device_specifier,
    getconfig_is_emulator,
)
from Libraries.AccountSetup import AccountSetup
from Libraries.Selectors import load_json_file

from resources.keywords import common
from resources.keywords import device_settings_keywords
from resources.keywords import settings_keywords
from resources.keywords import home_screen_keywords
from resources.keywords import tr_signin_keywords
from resources.keywords import lcp_signinout
from resources.keywords import panels_homescreen_keywords
from resources.keywords import perf_keywords

display_time = 2
action_time = 5
retry_attempt = 3
app_settle = 10

obj_dev = AccountSetup.getInstance()

calls_dict = load_json_file("resources/Page_objects/Calls.json")
sign_dict = load_json_file("resources/Page_objects/Signin.json")
navigation_dict = load_json_file("resources/Page_objects/Navigation.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
tr_Signin_dict = load_json_file("resources/Page_objects/tr_Signin.json")
tr_home_screen_dict = load_json_file("resources/Page_objects/tr_home_screen.json")
tr_calls_dict = load_json_file("resources/Page_objects/tr_calls.json")
panels_home_screen_dict = load_json_file("resources/Page_objects/panels_homescreen.json")
home_screen_dict = load_json_file("resources/Page_objects/Home_screen.json")
tr_console_signin_dict = load_json_file("resources/Page_objects/rooms_console_signin.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
tr_console_home_screen_dict = load_json_file("resources/Page_objects/rooms_console_home_screen.json")
tr_settings_dict = load_json_file("resources/Page_objects/tr_settings.json")
panels_device_settings_dict = load_json_file("resources/Page_objects/panels_device_settings.json")
lcp_homescreen_dict = load_json_file("resources/Page_objects/lcp_homescreen.json")
tr_device_settings_dict = load_json_file("resources/Page_objects/tr_device_settings.json")
tr_console_settings_dict = load_json_file("resources/Page_objects/rooms_console_settings.json")
web_signin_dict = load_json_file("resources/Page_objects/Web_signin.json")
ztp_dict = load_json_file("resources/Page_objects/ztp.json")
app_bar_dict = load_json_file("resources/Page_objects/App_bar.json")
people_dict = load_json_file("resources/Page_objects/People.json")


def sign_in(device_list=None, user_list=None):
    if not device_list and not user_list:
        # Legacy - nothing specified == all devices/consoles configured.
        device_list = getconfig_all_device_names()
        print(f"sign_in: No devices/accounts specified, using default:{device_list}")

    devices = encode_devices_and_accounts(device_list, user_list)
    print(f"Devices: {devices}")
    devices = shared_utils.getconfig_trim_to_configured_devices(devices)

    #
    # Warning: this ignores all exceptions, (but Robot will report them as unhandled/ignored domain exceptions).
    # TODO: replace with run_parallel() - but we first need to evaluate how errors are handled...
    #
    print(f"sign_in: Creating threads for '{devices}'")
    jobs = []
    for device in devices:
        print(f"sign_in: {device}")
        thread = threading.Thread(target=sign_in_catch_and_dump, args=(device, None))
        jobs.append(thread)
    print("Starting threads\n")
    for j in jobs:
        j.start()
    print("Waiting for all threads to join\n")
    for j in jobs:
        j.join()
    print("All threads completed and joined")


def sign_in_catch_and_dump(device, user=None):
    """
    Parent method to catch and dump all exceptions.
    - This will eventually be used to pass the failure back to the main
        thread and allow sign_in() to fail gracefully.
    """
    print(f"{device}: sign_in_catch_and_dump user={user}")
    try:
        if common.is_lcp(device):
            lcp_signinout.signin_method_for_lcp(device, user)
        else:
            sign_in_method(device, user)
        return
    except Exception:
        print(f"{device}: Sign-In failed with Exception:\n{traceback.format_exc()}")

    try:
        device_name, _ = decode_device_specifier(device)
        settings_keywords.get_screenshot(f"{device_name}_sign_in_failure", device_list=device, with_xml=True)
        capture_cp_and_logcat_logs(device)
    except Exception as e:
        print(f"{device}: Unexpected (ignored) - Capture logs failed:\n{traceback.format_exc()}")

    print(f"{device}: Sign-in failed, begin Retry Sign-In...")

    try:
        obj_dev.re_setup_device_driver(device, config)
    except Exception as e:
        print(f"{device}: Fatal: re_setup_device_driver failed with {type(e).__name__}: {e}")
        raise

    print(f"{device}: Retry Sign-In after reset...")

    try:
        if common.is_lcp(device):
            lcp_signinout.signin_method_for_lcp(device, user)
        else:
            sign_in_method(device, user)
        print(f"{device}: Retry Sign-In after reset SUCCESSFUL.")
    except Exception as e:
        print(f"{device}: Fatal: Retry Sign-In after reset FAILED with {type(e).__name__}: {e}")
        raise


def sign_in_method(device, user=None, verify_home_screen_enabled="off"):
    if not verify_home_screen_enabled.lower() in ["on", "off"]:
        raise AssertionError("Invalid verification")

    print(f"{device}: sign_in_method user={user}")
    _model = shared_utils.getconfig_device_model(device)
    _oem = shared_utils.getconfig_device_oem(device)
    ########################
    # Accept both encoded and non-encoded device names
    # Future: Remove the 'user' arg - all 'device's should be encoded as 'device_name[:user_role]'.
    # Until the removal, create/use the encoded device names here:
    if ":" in device and user:
        raise AssertionError(f"{device}: Cannot specify both encoded device AND user role '{user}'")

    # (future remove) If not already encoded, do so now:
    if ":" not in device and user:
        device = f"{device}:{user}"
    #
    ########################

    common.sleep_with_msg(device, app_settle, "Allow app to settle")

    username, password, device, account = common.get_credentials(device)
    # Check and enable GGC Cloud option
    if common.is_norden(device):
        oem = common.device_oem(device)
        if oem == "arizona":
            common.click_if_present(device, sign_dict, "close")
            print("clicked on the screen")

    if common.is_gcc_enabled():
        if account == "pstn_user":
            common.select_cloud_option_from_signin_page(device, "public")
        else:
            common.select_cloud_option_from_signin_page(device, "gcc")

    print(f"{device}: Sign in, username: {username}, account type: {account}")

    # Handling the system time zone pop-up before sign-in
    if shared_utils.getconfig_device_model(device) == "arizona":
        device_settings_keywords.handle_system_time_zone_popup(device)

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

    if _model not in [
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
    ]:
        common.hide_keyboard(device)
    common.wait_for_and_click(device, sign_dict, "Sign_in_button")

    if getconfig_is_emulator(device):
        if common.is_norden(device):
            # Find the webview host password before enter the password
            common.wait_for_element(device, sign_dict, "common_auth_webview")

    common.wait_for_element(device, sign_dict, "Password").send_keys(password)
    print(f"{device}: entered the user password")

    if not common.click_if_present(device, sign_dict, "Sign_in"):
        common.wait_for_and_click(device, sign_dict, "signin_button")

    if common.is_panel(device) or common.is_norden(device):
        if common.click_if_element_appears(device, sign_dict, "register", max_attempts=10):
            print(f"{device} :clicked on register button")

    if not common.is_norden(device) and not common.is_panel(device):
        # This loop is waiting for the sign-in to complete:
        _check_for_gotit = True
        _check_for_register = True
        _signin_check = False
        _max_loop = 10
        for attempt in range(_max_loop):
            common.sleep_with_msg(device, 10, "Waiting for sign-in to complete")

            # Handling the system time zone pop-up before Got it button
            if config["devices"][device]["oem"].lower() == "arizona":
                device_settings_keywords.handle_system_time_zone_popup(device)

            if account in [
                "cap_search_enabled",
                "cap_search_disabled",
                "meeting_user",
                "cappro_personal_policy_assigned_account",
                "standard_resource_assigned_account",
                "premiumuser_assigned_account",
            ]:
                common.click_if_present(device, sign_dict, "register")
                common.click_if_present(device, sign_dict, "Gotit_button")
                if account in ["cap_search_enabled", "cap_search_disabled"]:
                    if common.is_element_present(device, calls_dict, "dialpad_tab") or common.is_element_present(
                        device, calls_dict, "call_park"
                    ):
                        print(f"Dialpad is visible, sign-in is successful on attempt {attempt} of {_max_loop - 1}")
                        _signin_check = True
                elif account in [
                    "meeting_user",
                    "cappro_personal_policy_assigned_account",
                    "standard_resource_assigned_account",
                    "premiumuser_assigned_account",
                ]:
                    # To handle phones nightly runs "meeting_user" [room accounts with Room basic + DCP + E5]
                    common.click_if_element_appears(device, home_screen_dict, "home_bar_icon", max_attempts=3)
                    if common.is_element_present(device, calendar_dict, "calendar_tab") or common.is_element_present(
                        device, calendar_dict, "meet_now"
                    ):
                        print(
                            f"Meet now/Calendar is visible, sign-in is successful attempt {attempt} of {_max_loop - 1}"
                        )
                        _signin_check = True
                if _signin_check:
                    if _model == "arizona":
                        common.sleep_with_msg(device, 15, "Wait for timezone pop-up post tapping on Got it button")
                        device_settings_keywords.handle_system_time_zone_popup(device)
                    break
            else:
                if common.click_if_present(device, sign_dict, "continue"):
                    common.wait_for_and_click(device, sign_dict, "continue")

                if _check_for_register and common.click_if_present(device, sign_dict, "register"):
                    print(f"{device}: Clicked on 'register'")
                    _check_for_register = False

                if _check_for_gotit and common.click_if_present(device, sign_dict, "Gotit_button"):
                    print(f"{device}: Clicked on 'Gotit_button'")
                    _check_for_gotit = False

                    # Handling the system time zone pop-up after tapping on got-it button
                    if _oem == "arizona":
                        device_settings_keywords.handle_system_time_zone_popup(device)

                common.click_if_present(device, home_screen_dict, "home_bar_icon")
                # Classic non-Home page:
                if common.is_element_present(device, calls_dict, "calls_tab"):
                    print(f"{device}: Calls tab is visible, sign-in successful on attempt {attempt} of {_max_loop - 1}")
                    break

                # Home page display:
                if common.is_element_present(device, calls_dict, "user_profile_picture"):
                    print(
                        f"{device}: Home-screen is displayed, sign-in is successful on attempt {attempt} of {_max_loop - 1}"
                    )
                    break

            if attempt == _max_loop - 1:
                print(f"{device}: Failed Sign-in. Timeout waiting on sign-in completion after {attempt} attempts.")
                raise AssertionError("Device did not complete sign-in : " + device)

        common.sleep_with_msg(device, 30, "Sign in complete, allow notifications arrival")
        if verify_home_screen_enabled == "on":
            home_screen_keywords.verify_home_screen_tiles(device)
            home_screen_keywords.verify_home_screen_time_dates(device)
    # Handling the NPS survey pop-up
    if common.is_element_present(device, sign_dict, "nps_survyey_container"):
        handle_nps_survey_pop_up(device)
    if common.is_panel(device):
        room_name = common.wait_for_element(device, panels_home_screen_dict, "room_name", wait_attempts=40).text
        print(f"{device}: Device logged in with room name :", room_name)
    else:
        if account in ["user", "delegate_user", "gcp_user", "cq_user", "pstn_user"]:
            if common.is_norden(device):
                tr_signin_keywords.validate_that_signin_successful(device, "sign in")
                print(f"{device}: Device logged in as user type '{account}'")
            else:
                common.click_if_present(device, home_screen_dict, "home_bar_icon")
                common.wait_for_element(device, home_screen_dict, "more_option")
                settings_keywords.verify_and_change_call_settings(device)
        elif account in ["cap_search_enabled", "cap_search_disabled", "meeting_user"]:
            print(f"{device}: {account}")
            if common.is_norden(device):
                tr_signin_keywords.validate_that_signin_successful(device, "sign in")
                print(f"{device}: username is visible for meeting user on home screen ")
            else:
                if account == "meeting_user":
                    common.wait_for_element(device, home_screen_dict, "hs_phonenum")
                elif account in ["cap_search_enabled", "cap_search_disabled"]:
                    if not common.is_element_present(device, settings_dict, "hotline_UI"):
                        if not common.is_element_present(device, calls_dict, "calls_tab"):
                            common.wait_for_element(device, calls_dict, "call_park")


def sign_out(device_list=None):
    if device_list is None:
        # TODO: This should be: devices = AccountSetup.getInstance().get_driver_names()
        devices = list(config["devices"].keys())
    else:
        if isinstance(device_list, list):
            devices = device_list
        else:
            devices = device_list.split(",")
    print("Devices: ", devices)

    try:
        shared_utils.run_parallel(devices, sign_out_method)
    except Exception as e:
        print(f"WARN Ignored sign_out failure: {e}")


def sign_out_method(device, hot_line="disabled"):
    device, _ = decode_device_specifier(device)
    if hot_line.lower() not in ["enabled", "disabled"]:
        raise AssertionError(f"Illegal value for 'hot_line':'{hot_line}'")
    print(f"{device}: sign_out_method")

    if common.is_element_present(device, sign_dict, "sign_in_on_the_device"):
        print(f"{device}: User is already sign-out and is on sign-in page")
        return

    if common.is_lcp(device):
        if common.is_element_present(device, sign_dict, "refresh_code_button") or common.is_element_present(
            device, sign_dict, "dcf_code"
        ):
            print(f"{device}: User is already sign-out and is on sign-in page")
            return

    if hot_line.lower() == "enabled":
        device_settings_keywords.sign_out_oem(device)
        return
    if common.is_norden(device):
        time.sleep(display_time)
        if common.is_element_present(device, sign_dict, "sign_in_on_the_device"):
            print("We are in sign in page already Sign out is Successfully Completed")
            return
        common.wait_for_and_click(device, tr_home_screen_dict, "more_button")
    elif common.is_panel(device):
        if common.is_element_present(device, sign_dict, "sign_in_on_the_device"):
            print(f"{device}: In sign in page already Sign out is Successfully Completed")
            return
        common.wait_for_and_click(device, panels_home_screen_dict, "settings_icon")
    else:
        common.click_if_present(device, calls_dict, "Call_Back_Button")
        time.sleep(action_time)
        common.click_if_present(device, calls_dict, "Call_Back_Button")
        time.sleep(action_time)
        if common.click_if_present(device, home_screen_dict, "home_bar_icon"):
            time.sleep(action_time)
        if common.is_lcp(device):
            common.wait_for_and_click(device, lcp_homescreen_dict, "homescreen_menu")
        elif not common.click_if_present(device, navigation_dict, "Navigation"):
            if not common.is_portrait_mode_cnf_device(device):
                raise AssertionError(f"{device} couldn't open navigation menu")
            common.wait_for_and_click(device, calendar_dict, "app_bar_more")
    if not common.is_panel(device):
        common.wait_for_and_click(device, navigation_dict, "Settings_button")
        if getconfig_is_emulator(device):
            norden_go_to_setting_by_adb(device)
        elif common.is_lcp(device):
            time.sleep(5)
            swipe_till_sign_out(device)
            time.sleep(5)
            swipe_till_sign_out(device)
            time.sleep(5)
            swipe_till_sign_out(device)
        elif not common.is_norden(device):
            time.sleep(action_time)
            common.scroll_the_page(
                device, common.wait_for_element(device, settings_dict, "settings_page_scroll_view"), swiping="up"
            )
            if config["devices"][device]["model"].lower() == "gilbert":
                common.scroll_the_page(
                    device, common.wait_for_element(device, settings_dict, "settings_page_scroll_view"), swiping="up"
                )
        time.sleep(action_time)
    # if common.click_if_present(device, settings_dict, "Sign_out", "id"):
    if common.is_norden(device):
        device_settings_keywords.sign_out_oem(device)
    else:
        if common.click_if_present(device, settings_dict, "Sign_out"):
            common.wait_for_and_click(device, sign_dict, "Sign_out_ok_button", "id")
        else:
            print(f"{device}: Sign out from inside device settings")
            device_settings_keywords.sign_out_oem(device)
    for _attempt in range(90):
        if common.is_lcp(device):
            if common.is_element_present(device, sign_dict, "login_info"):
                return
        elif common.is_element_present(device, sign_dict, "sign_in_on_the_device"):
            if common.is_norden(device) or common.is_panel(device):
                common.sleep_with_msg(device, 4, "waiting to force stop cp after sign out")
                force_stop_company_portal(device)
                common.sleep_with_msg(device, 15, "wait for sign in page to load")
            return
        time.sleep(1)
    settings_keywords.get_screenshot(name="stalled_sign_out")
    capture_cp_and_logcat_logs(device)
    raise AssertionError(f"{device}: Unable to find sign-in button - sign-out did not complete.")


def norden_go_to_setting_by_adb(device):
    common.navigate_to_screen_using_adb(
        device,
        "com.microsoft.skype.teams.ipphone/com.microsoft.skype.teams.views.activities.NordenAdminSettingsActivity",
    )


def swipe_till_sign_out(device):
    driver = obj.device_store.get(alias=device)
    window_size = driver.get_window_size()
    print("Window size: ", window_size)
    height = window_size["height"]
    print("Window Height :", height)
    width = window_size["width"]
    print("Window Width :", width)
    if height > width:
        print("Swiping co-ordinates : ", width / 2, 4 * (height / 5), width / 2, height / 5)
        driver.swipe(width / 2, 4 * (height / 5), width / 2, height / 5)
    else:
        print("Swiping co-ordinates : ", width / 4, 4 * (height / 5), width / 4, height / 5)
        driver.swipe(width / 4, 4 * (height / 5), width / 4, height / 5)
    pass


def sign_out_from_HD_mode(device):
    common.click_if_present(device, calls_dict, "Call_Back_Button")
    common.click_if_present(device, calls_dict, "Call_Back_Button")
    common.wait_for_and_click(device, navigation_dict, "Navigation")
    common.wait_for_and_click(device, navigation_dict, "Settings_button")
    common.sleep_with_msg(device, 5, "Wait until the page loads")
    swipe_till_sign_out(device)
    common.sleep_with_msg(device, 3, "Waiting for swiping to complete")
    if common.click_if_present(device, settings_dict, "Sign_out"):
        common.wait_for_and_click(device, sign_dict, "Sign_out_ok_button")
    else:
        print("Sign out mostly inside device settings: ", device)
        device_settings_keywords.sign_out_oem(device)
    common.click_if_element_appears(device, sign_dict, "Gotit_button", max_attempts=30)


def check_version_disable_home_app(device):
    print("feature is removed in 2023-U3 app")
    # if not common.click_if_present(device, navigation_dict, "Navigation"):
    #     # Home screen may already be disabled, still need to verify settings
    #     common.wait_for_and_click(device, calls_dict, "user_profile_picture")
    # time.sleep(action_time)
    #
    # common.wait_for_and_click(device, navigation_dict, "Settings_button")
    # common.sleep_with_msg(device, action_time, "Clicked on settings option")
    #
    # if config["devices"][device]["model"].lower() == "gilbert":
    #     settings_keywords.swipe_till_end(device)
    #     print(f"{device}: Swiped on settings screen")
    #
    # for attempt in range(2):
    #     if common.is_element_present(device, settings_dict, "Home_screen_button"):
    #         settings_keywords.disable_home_screen(device)
    #         settings_keywords.verify_home_screen_status(device, "OFF")
    #         break
    #     calendar_keywords.scroll_only_once(device)
    # common.click_if_present(device, calls_dict, "Call_Back_Button")


def verify_and_enable_home_app(device):
    print("feature is removed in 2023-U3 app")
    # # Click if home screen is not enabled on device or the home screen is enabled, but user is on different tab
    # if not common.click_if_present(device, navigation_dict, "Navigation"):
    #     # If the home screen is already enabled on the device, user's profile picture will be visible
    #     common.wait_for_and_click(device, calls_dict, "user_profile_picture")
    #     common.wait_for_and_click(device, navigation_dict, "Settings_button")
    # common.wait_for_element(device, settings_dict, "general_settings")
    # if config["devices"][device]["model"].lower() == "gilbert":
    #     settings_keywords.swipe_till_end(device)
    # settings_keywords.enable_home_screen(device)
    # settings_keywords.verify_home_screen_status(device, "ON")


def capture_cp_and_logcat_logs(device):
    device, _ = decode_device_specifier(device)
    try:
        if config["cp_logs_capture"].lower() == "true":
            # sleeping to make sure the CP activity is logged in the CP log before we capture it.
            common.sleep_with_msg(device, 10, "Make sure the CP activity is logged in the CP log before we capture it")
            guid = str(uuid.uuid4())
            print(f"{device}: guid : ", guid)
            try:
                subprocess.call(
                    "adb -s {} shell am broadcast -a "
                    "com.microsoft.windowsintune.companyportal.intent.action.IPPHONE_UPLOAD_LOGS "
                    "--es SessionID '{}' -n com.microsoft.windowsintune.companyportal/.omadm.IPPhoneReceiver".format(
                        config["devices"][device]["desired_caps"]["udid"].split(":")[0], guid
                    ),
                    shell=True,
                )
                BuiltIn().log_to_console(message="Captured CP logs with GUID : " + guid)
            except Exception as e:
                print(f"{device}: Could not capture CP Logs")
            common.capture_logcat_logs(name="logcat_" + guid + "_", device_list=device)
            # need 3 minutes wait time for the CP log to be uploaded to powerlift once the capture is initiated
            common.sleep_with_msg(
                device, 180, "Waiting for the CP log to be uploaded to powerlift once the capture is initiated"
            )
        else:
            print(f"{device}: Capturing CP logs is not enabled in config file")
    except KeyError as e:
        print(f"{device}: CP log flag not found in config, so not capturing CP log")


def device_setting_back_till_signin_btn_visible(device):
    for i in range(4):
        if common.is_lcp(device):
            if common.is_element_present(device, sign_dict, "login_info"):
                common.wait_for_element(device, sign_dict, "login_info")
                return
        elif common.is_element_present(device, sign_dict, "sign_in_on_the_device", "id"):
            common.wait_for_element(device, sign_dict, "sign_in_on_the_device", "id")
            return
        settings_keywords.device_setting_back(device)
        print("Clicked Device setting back ", i, " time.")
        time.sleep(action_time)
    if common.is_lcp(device):
        common.wait_for_element(device, sign_dict, "login_info")
    else:
        common.wait_for_element(device, sign_dict, "sign_in_on_the_device", "id")


def signin_with_other_user(device, other_user_account):
    print("device :", device)
    sign_out_method(device)
    if common.is_lcp(device):
        user = other_user_account
        lcp_signinout.signin_method_for_lcp(device, user)
        return
    username, password, other_device, account = common.get_credentials(other_user_account)
    print(f"{device}: signing in using '{other_device}:{account}' credentials: {username}")
    # Check and enable GGC Cloud option
    if common.is_gcc_enabled():
        if account == "pstn_user":
            common.select_cloud_option_from_signin_page(device, "public")
        else:
            common.select_cloud_option_from_signin_page(device, "gcc")

    common.sleep_with_msg(device, app_settle, "Allow app to settle")
    if common.is_element_present(device, sign_dict, "dfc_login_code"):
        # Given that this device has just been reset, this will probably never fire:
        if common.click_if_present(device, sign_dict, "refresh_code_button"):
            common.sleep_with_msg(device, 5, "Clicked on refresh_code Button")

    common.wait_for_and_click(device, sign_dict, "sign_in_on_the_device")
    common.wait_for_element(device, sign_dict, "Username").send_keys(username)
    print(f"{device}: entered the username '{username}'")

    # Soft keyboard may be hiding the Sign-in button:
    if not common.click_if_present(device, sign_dict, "Sign_in_button"):
        common.hide_keyboard(device)
        common.wait_for_and_click(device, sign_dict, "Sign_in_button")

    # Manually tapping on the password field on devices where password screen is not visible
    # if config["devices"][device]["model"].lower() in [
    #     "olympia",
    #     "seattle",
    #     "tacoma",
    #     "redmond",
    #     "manhattan",
    #     "kirkland",
    # ]:
    #     common.sleep_with_msg(device, 40, "Waiting for the password entry screen to appear")
    #     udid_ = config["devices"][device]["desired_caps"]["udid"]
    #     try:
    #         if config["devices"][device]["model"].lower() in ["olympia", "seattle", "tacoma", "kirkland"]:
    #             subprocess.run("adb -s " + udid_ + " shell input tap 100 450", stdout=subprocess.PIPE, shell=True)
    #         elif config["devices"][device]["model"].lower() == "redmond":
    #             subprocess.run("adb -s " + udid_ + " shell input tap 400 330", stdout=subprocess.PIPE, shell=True)
    #         elif config["devices"][device]["model"].lower() == "manhattan":
    #             subprocess.run("adb -s " + udid_ + " shell input tap 600 430", stdout=subprocess.PIPE, shell=True)
    #         common.sleep_with_msg(device, 7, f"Waiting to enter password on {device}")
    #         cmd = "adb -s " + udid_ + " shell input text " + password
    #         subprocess.run(cmd, stdout=subprocess.PIPE, shell=True)
    #         subprocess.run(
    #             "adb -s " + udid_ + " shell input keyevent KEYCODE_ENTER",
    #             stdout=subprocess.PIPE,
    #             shell=True,
    #         )
    #         print(f"{device}: Manually entered the user password")
    #     except CalledProcessError as failure:
    #         print(f"{device}: Failed ({failure.returncode}) manual input of the user password: {failure.output}")
    #         raise AssertionError("Manual password entry failed.")
    # else:

    common.wait_for_element(device, sign_dict, "Password").send_keys(password)
    print(f"{device}: entered the user password")
    common.hide_keyboard(device)
    if not common.click_if_present(device, sign_dict, "Sign_in"):
        common.wait_for_and_click(device, sign_dict, "signin_button")
    if account == "sku_user":
        common.sleep_with_msg(device, 15, "Waiting for sign-in process")
        common.wait_for_element(device, sign_dict, "basic_license_error")
        return

    if common.is_panel(device) or common.is_norden(device):
        if common.click_if_element_appears(device, sign_dict, "register", max_attempts=10):
            print(f"{device} :clicked on register button")

    if not common.is_norden(device) and not common.is_panel(device):
        # This loop is waiting for the sign-in to complete:
        _check_for_gotit = True
        _signin_check = False
        _max_loop = 10
        for attempt in range(_max_loop):
            common.sleep_with_msg(device, 10, "Waiting for sign-in to complete")

            # Handling the system time zone pop-up before Got it button
            if config["devices"][device]["model"].lower() == "arizona":
                device_settings_keywords.handle_system_time_zone_popup(device)
            common.click_if_present(device, sign_dict, "register")
            if account in ["cap_search_enabled", "cap_search_disabled", "meeting_user"]:
                if account in ["cap_search_enabled", "cap_search_disabled"]:
                    if common.is_element_present(device, calls_dict, "dialpad_tab"):
                        print(f"Dialpad is visible, sign-in is successful on attempt {attempt} of {_max_loop - 1}")
                        _signin_check = True
                elif account == "meeting_user":
                    # To handle phones nightly runs "meeting_user" [room accounts with Room basic + DCP + E5]
                    # We get "got it" button for these accounts, as opposed to room accounts with only [Room pro + DCP]
                    common.click_if_present(device, sign_dict, "Gotit_button")
                    common.click_if_element_appears(device, home_screen_dict, "home_bar_icon", max_attempts=3)
                    if common.is_element_present(device, calendar_dict, "calendar_tab") or common.is_element_present(
                        device, calendar_dict, "meet_now"
                    ):
                        print(
                            f"Meet now/Calendar is visible, sign-in is successful on attempt {attempt} of {_max_loop - 1}"
                        )
                        _signin_check = True
                if _signin_check:
                    if config["devices"][device]["model"].lower() == "arizona":
                        common.sleep_with_msg(device, 15, "Wait for timezone pop-up post tapping on Got it button")
                        device_settings_keywords.handle_system_time_zone_popup(device)
                    break
            else:
                if _check_for_gotit and common.click_if_present(device, sign_dict, "Gotit_button"):
                    print(f"{device}: Clicked on 'Gotit_button'")
                    _check_for_gotit = False

                    # Handling the system time zone pop-up after tapping on got-it button
                    if config["devices"][device]["model"].lower() == "arizona":
                        common.sleep_with_msg(device, 15, "Wait for timezone pop-up post tapping on Got it button")
                        device_settings_keywords.handle_system_time_zone_popup(device)

                # Classic non-Home page:
                if common.is_element_present(device, calls_dict, "calls_tab"):
                    print(f"{device}: Calls tab is visible, sign-in successful on attempt {attempt} of {_max_loop - 1}")
                    break

            if attempt == _max_loop - 1:
                print(f"{device}: Failed Sign-in. Timeout waiting on sign-in completion after {attempt} attempts.")
                raise AssertionError("Device did not complete sign-in : " + device)

        common.sleep_with_msg(device, 30, "Sign in complete, allow notifications arrival")
        if account not in ["cap_search_enabled", "cap_search_disabled", "meeting_user"]:
            check_version_disable_home_app(device)

    if account in ["user", "delegate_user", "gcp_user", "cq_user", "pstn_user"]:
        if common.is_norden(device):
            tr_signin_keywords.validate_that_signin_successful(device, "sign in")
            print(f"{device}: Device logged in as user type '{account}'")
        elif common.is_panel(device):
            room_name = common.wait_for_element(device, panels_home_screen_dict, "room_name", wait_attempts=40).text
            print(f"{device}: Device logged in with room name :", room_name)
        else:
            common.click_if_present(device, home_screen_dict, "home_bar_icon")
            common.wait_for_element(device, home_screen_dict, "more_option")
            settings_keywords.verify_and_change_call_settings(device)
    elif account in ["cap_search_enabled", "cap_search_disabled", "meeting_user"]:
        print(f"{device}: {account}")
        if common.is_norden(device):
            common.wait_for_element(
                device,
                tr_home_screen_dict,
                "more_button",
                cond=EC.visibility_of_element_located,
            )
            common.wait_for_element(
                device,
                tr_home_screen_dict,
                "user_name_v1",
                cond=EC.visibility_of_element_located,
            )
            print(f"{device}: More button and username is visible for meeting user on home screen ")
        elif common.is_panel(device):
            room_name = common.wait_for_element(device, panels_home_screen_dict, "room_name", wait_attempts=40).text
            print(f"{device}: Device logged in with room name :", room_name)
        else:
            if account == "meeting_user":
                time.sleep(display_time)
                if not common.is_element_present(device, calendar_dict, "calendar_tab"):
                    common.wait_for_element(device, calendar_dict, "meet_now")
                    return
            elif account == "cap_search_enabled":
                if not common.is_element_present(device, calls_dict, "calls_tab"):
                    common.wait_for_element(device, calls_dict, "call_park")
    elif common.is_norden(device) and account == "cap_user":
        common.sleep_with_msg(device, 10, "Waiting for sign-in process")
        common.wait_for_element(device, sign_dict, "signin_failure_error", wait_attempts=40)


def sign_in_console(console_list=None, user_list=None):
    if isinstance(console_list, list):
        consoles = console_list
        users = user_list
    else:
        if console_list is None:
            consoles = list(config["consoles"].keys())
            if user_list is None:
                users = [None] * len(consoles)
            else:
                users = user_list.split(",")
        else:
            consoles = console_list.split(",")
            users = user_list.split(",")
    print("Consoles : ", consoles)
    print("Users : ", users)
    print("sign_in_console: Creating threads")
    jobs = []
    for console, user in zip(consoles, users):
        thread = threading.Thread(target=sign_in_catch_dump, args=(console, user))
        jobs.append(thread)
    print("Starting threads\n")
    for j in jobs:
        j.start()
    print("Waiting for all threads to join\n")
    for j in jobs:
        j.join()
        print("All threads completed and joined")


def swipe_for_sign_out(console):
    driver = obj.device_store.get(alias=console)
    window_size = driver.get_window_size()
    height = window_size["height"]
    width = window_size["width"]
    print("Swiping co-ordinates : ", width / 2, 3 * (height / 4), width / 2, height / 4)
    driver.swipe(width / 2, 3 * (height / 4), width / 2, height / 4)


def console_sign_out_method(console):
    print("Console: ", console)
    time.sleep(30)
    if common.is_element_present(console, sign_dict, "sign_in_on_the_device"):
        print("We are in sign in page already Sign out is Successfully Completed")
        return
    if not common.click_if_present(console, tr_settings_dict, "settings_button"):
        common.wait_for_and_click(console, tr_console_home_screen_dict, "more_option")
        common.wait_for_and_click(console, tr_settings_dict, "settings_button")
    print("Sign out mostly inside device setting: ", console)
    device_settings_keywords.sign_out_console_oem(console)
    for _attempt in range(90):
        if common.is_element_present(console, sign_dict, "sign_in_on_the_device"):
            # Issue: This is missing, is it neeeded for MTRA/Console??
            # common.sleep_with_msg(console, 4, "waiting to force stop cp after sign out")
            # force_stop_company_portal(console)
            return
        time.sleep(1)
    common.capture_screenshot(name="exception_while_signing_out")
    capture_console_cp_and_logcat_logs(console)
    raise AssertionError(f"{console}: Unable to find 'sign_in_on_the_device' - sign-out did not complete.")


def sign_out_console(console_list=None):
    if console_list is None:
        consoles = list(config["consoles"].keys())
    else:
        if isinstance(console_list, list):
            consoles = console_list
        else:
            consoles = console_list.split(",")
    print("Consoles : ", consoles)
    print("sign_out_console: Creating threads")
    jobs = []
    for console in consoles:
        thread = threading.Thread(target=console_sign_out_method, args=(console,))
        jobs.append(thread)
    print("Starting threads\n")
    for j in jobs:
        j.start()
    print("Waiting for all threads to join\n")
    for j in jobs:
        j.join()
    print("All threads completed and joined")


def capture_console_cp_and_logcat_logs(console):
    try:
        if config["cp_logs_capture"].lower() == "true":
            # sleeping to make sure the CP activity is logged in the CP log before we capture it.
            time.sleep(10)
            guid = str(uuid.uuid4())
            print("guid : ", guid)
            try:
                subprocess.call(
                    "adb -s {} shell am broadcast -a "
                    "com.microsoft.windowsintune.companyportal.intent.action.IPPHONE_UPLOAD_LOGS "
                    "--es SessionID '{}' -n com.microsoft.windowsintune.companyportal/.omadm.IPPhoneReceiver".format(
                        config["consoles"][console]["desired_caps"]["udid"].split(":")[0],
                        guid,
                    ),
                    shell=True,
                )
                BuiltIn().log_to_console(message="Captured CP logs with GUID : " + guid)
            except Exception as e:
                print("Could not capture CP Logs")
            common.logcat_logs_capture(name="logcat_" + guid + "_", console_list=console)
            # need 3 minutes wait time for the CP log to be uploaded to powerlift once the capture is initiated
            time.sleep(180)
        else:
            print("Capturing CP logs is not enabled in config file")
    except KeyError as e:
        print("CP log flag not found in config, so not capturing CP log")


def get_pairing_code(device, console, user=None, retry_1=True, multi_pair=None):
    print("from_device :", device)
    print("to_device :", console)

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

    account = user_types.get(user.lower(), "user") if user else "user"

    print("Account  :", account)
    try:
        if not common.is_element_present(console, tr_console_signin_dict, "select_device_paring_text"):
            common.wait_for_element(console, tr_console_home_screen_dict, "meet_now_icon")
            common.wait_for_element(console, tr_console_home_screen_dict, "more_option")
            print(f"{console}: User is on home screen automatically piared with the device")
            return
        else:
            max_retry = 5
            for attempt in range(max_retry):
                if common.is_element_present(console, tr_console_signin_dict, "select_device_paring_text"):
                    print("Select a device to start pairing text is visible")
                    break
                common.click_if_present(console, tr_console_signin_dict, "search_again")
            room_name = common.wait_for_element(console, tr_console_signin_dict, "room_name")
            print("Selected rooms name :", room_name.text)
            device_serial_no = config["consoles"][console]["serial_number"]
            print("Device serial number : ", device_serial_no)
            serial_text = common.wait_for_element(
                console, tr_console_signin_dict, "rooms_description", "id", cond=EC.presence_of_all_elements_located
            )
            elem_list = [str(item.text).split(":")[1].strip() for item in serial_text]
            print("Device serial number on the console for pairing : ", elem_list)
            if multi_pair:
                if len(elem_list) <= 2:
                    raise AssertionError(
                        f"Expected multiple devices to be paired (multi_pair=True), but found only {len(elem_list)} device(s)."
                    )
            user_position = 0
            for console_serial_no in elem_list:
                if console_serial_no == device_serial_no:
                    user_position = elem_list.index(console_serial_no)
                    print(f"expected device no to click:", console_serial_no)
            serial_text[user_position].click()
            print("Clicked on room results list displayed on screen")
            for attempt in range(max_retry):
                if common.is_element_present(device, tr_console_signin_dict, "get_pair_code"):
                    pair_code = common.wait_for_element(device, tr_console_signin_dict, "get_pair_code").text
                    break
                common.click_if_present(console, tr_console_signin_dict, "back_layout")
                serial_text[user_position].click()
                if attempt == max_retry - 1:
                    raise AssertionError(f"{device} couldn't find pair code after {attempt + 1} attempts")
            element = common.wait_for_element(console, tr_console_signin_dict, "room_code")
            print(f"Enter the pairing code displayed on :", {device})
            element.send_keys(pair_code)
            print("Successfully entered the pairing code")
            common.wait_for_and_click(console, tr_console_signin_dict, "pair_button")
    except Exception as e:
        print("Caught exception while pairing console, retrying. Check screenshot.")
        common.capture_screenshot(name="exception_while_pairing_code")
        capture_console_cp_and_logcat_logs(console)
        obj_dev.re_setup_console_driver(console, config, root_console)
        if retry_1 is True:
            console_sign_in_method(console, user, retry=False)
            get_pairing_code(device, console, user, retry_1=False)
        else:
            raise AssertionError("Sign-in Failed after retrying to pair code")


def console_sign_in_method(console, user=None, retry=True):
    ########################
    # Accept both encoded and non-encoded console names
    # Future: Remove the 'user' arg - all 'device's should be encoded as 'device_name[:user_role]'.
    # Until the removal, create/use the encoded device names here:
    if ":" in console and user:
        raise AssertionError(f"{console}: Cannot specify both encoded console AND user role '{user}'")

    # (future remove) If not already encoded, do so now:
    if ":" not in console and user:
        console = f"{console}:{user}"
    #
    ########################
    username, password, console, account = common.get_credentials(console)
    _oem = common.device_oem(console)

    if _oem == "arizona":
        # Handling the screen pop up regarding pairing
        common.click_if_present(console, app_bar_dict, "back")
        common.click_if_present(console, sign_dict, "close")
        print("clicked on the screen")

    if common.is_gcc_enabled():
        if account == "pstn_user":
            common.select_cloud_option_from_signin_page(console, "public")
        else:
            common.select_cloud_option_from_signin_page(console, "gcc")

    print("Device : ", console)
    print("Getting Driver details ")
    print("Object :", obj)
    driver = obj.device_store.get(alias=console)
    common.sleep_with_msg(console, app_settle, "console_sign_in_method > app_settle")
    if not common.is_element_present(console, sign_dict, "dfc_login_code"):
        if common.click_if_present(console, sign_dict, "refresh_code_button"):
            common.wait_for_element(console, sign_dict, "dfc_login_code")

    common.wait_for_and_click(console, sign_dict, "sign_in_on_the_device")

    search_input = common.wait_for_element(console, sign_dict, "Username")
    search_input.send_keys(username)
    print(f"Entered username '{username}'")

    if config["consoles"][console]["model"].lower() not in ["fresno", "fremont"]:
        common.hide_keyboard(console)

    common.wait_for_and_click(console, sign_dict, "Sign_in_button")
    try:
        common.wait_for_element(console, sign_dict, "Password").send_keys(password)
        print("Entered the password")
        driver.hide_keyboard()
        common.wait_for_and_click(console, sign_dict, "Sign_in")
        print("Clicked on the sign in button")
        if common.click_if_element_appears(console, sign_dict, "register"):
            print(f"{console} :clicked on register button")
        common.wait_for_element(console, tr_console_signin_dict, "room_name", wait_attempts=100)
        if not common.is_element_present(console, tr_console_signin_dict, "select_device_paring_text"):
            common.wait_for_element(console, tr_console_signin_dict, "auto_pair_msg")
    except AssertionError as e:
        print("Caught exception while signing in console, retrying. Check screenshot.")
        common.capture_screenshot(name="exception_while_signing_in")
        capture_console_cp_and_logcat_logs(console)
        obj_dev.re_setup_console_driver(console, config, root_console)
        if retry is True:
            console_sign_in_method(console, user, retry=False)
        else:
            raise Exception("Sign In Failed for device : ", console)


def get_device_pairing_code(device_list=None, console_list=None, user_list=None, multi_pair=None):
    if isinstance(device_list, list) and isinstance(console_list, list):
        devices = device_list
        consoles = console_list
        users = user_list
    else:
        if device_list is None:
            devices = list(config["devices"].keys())
            if user_list is None:
                users = [None] * len(devices)
            else:
                users = user_list.split(",")
        elif console_list is None:
            consoles = list(config["consoles"].keys())
            if user_list is None:
                users = [None] * len(consoles)
            else:
                users = user_list.split(",")
        else:
            devices = device_list.split(",")
            consoles = console_list.split(",")
            users = user_list.split(",")
    print("Devices : ", devices)
    print("Consoles : ", consoles)
    print("Users : ", users)
    print("get_device_pairing_code: Creating threads")
    jobs = []
    for device, console, user in zip(devices, consoles, users):
        thread = threading.Thread(target=get_pairing_code, args=(device, console, user, multi_pair))
        jobs.append(thread)
    print("Starting threads\n")
    for j in jobs:
        j.start()
    print("Waiting for all threads to join\n")
    for j in jobs:
        j.join()
    print("All threads completed and joined")


def sign_in_catch_dump(console, user=None):
    """
    Parent method to catch and dump all exceptions.
    - This will eventually be used to pass the failure back to the main
        thread and allow sign_in() to fail gracefully.
    """
    try:
        console_sign_in_method(console, user)
        return
    except Exception:
        print(f"{console}: Sign-In failed with Exception:\n{traceback.format_exc()}")
        common.capture_screenshot(f"{console}_sign_in_failure", console_list=console, with_xml=True)
        capture_console_cp_and_logcat_logs(console)
        obj_dev.re_setup_console_driver(console, config, root_console)

        print(f"{console}: Retry Sign-In after reset.")
        console_sign_in_method(console, user)


def verify_signin_button_on_signin_page(count):
    devices = []
    if count == "1":
        devices = common.get_device_name_list(count)
    elif count == "2":
        devices = common.get_device_name_list(count)
    elif count == "3":
        devices = common.get_device_name_list(count)
    if "consoles" in config:
        for console in list(config["consoles"].keys()):
            if not common.is_element_present(console, sign_dict, "sign_in_on_the_device"):
                raise AssertionError("Device is not on the sign-in page")
        return
    for device in devices:
        if not common.is_element_present(device, sign_dict, "sign_in_on_the_device"):
            raise AssertionError("Device is not on the sign-in page")


def get_pairing_code_from_rooms_device(from_device1, to_device1):
    print("from_device :", from_device1)
    print("to_device :", to_device1)
    pair_code_on_rooms = common.wait_for_element(from_device1, tr_console_signin_dict, "get_pair_code").text
    print(f"pairing code displayed on rooms device: {pair_code_on_rooms}")
    code_field_on_panel = common.wait_for_element(to_device1, tr_console_signin_dict, "room_code")
    code_field_on_panel.click()
    code_field_on_panel.send_keys(pair_code_on_rooms)
    print(f"{to_device1}: Entered the pair code displayed on rooms device")
    common.hide_keyboard(to_device1)
    common.wait_for_and_click(to_device1, tr_console_signin_dict, "pair_button")
    common.wait_for_element(from_device1, panels_device_settings_dict, "all_set")
    common.wait_for_element(to_device1, panels_device_settings_dict, "all_set")


def select_rooms_device_to_pair_from_panel(from_device, to_device):
    common.sleep_with_msg(from_device, 5, "Waiting for the available devices display to pair")
    _max_retry = 5
    for _attempt in range(_max_retry):
        if common.is_element_present(from_device, tr_console_signin_dict, "rooms_description"):
            break
        common.click_if_present(from_device, tr_console_signin_dict, "search_again")
        time.sleep(4)
        if _attempt == _max_retry - 1:
            raise AssertionError(f"{from_device} couldn't find any device to pair after {_attempt + 1} tries")
    common.wait_for_element(from_device, tr_console_signin_dict, "select_device_paring_text")
    room_name = common.wait_for_element(from_device, tr_console_signin_dict, "room_name").text
    print(f"Displayed Rooms device: {room_name}")
    expected_device_serial_no = shared_utils.getconfig_device_serial_number(to_device)
    displayed_serial_no = common.wait_for_element(
        from_device, tr_console_signin_dict, "rooms_description", "id", cond=EC.presence_of_all_elements_located
    )
    elem_list = [str(item.text).split(":")[1].strip() for item in displayed_serial_no]
    print("Device serial number on the panel for pairing : ", elem_list)
    user_position = 0
    for serial_no in elem_list:
        if serial_no == expected_device_serial_no:
            user_position = elem_list.index(serial_no)
            print(f"expected device no to click:", serial_no)
    displayed_serial_no[user_position].click()
    print("Clicked on serial no from list displayed on screen")


def verifying_no_device_is_available_for_pairing(device):
    common.wait_for_element(device, panels_device_settings_dict, "pro_tag_for_cap_user")
    common.wait_for_element(device, panels_device_settings_dict, "pro_warning_for_cap_user")
    common.wait_for_and_click(device, people_dict, "ok_btn")
    common.wait_for_element(device, panels_device_settings_dict, "pro_tag_for_cap_user")


def cancel_device_pairing_process_in_panel(device):
    common.wait_for_and_click(device, tr_console_signin_dict, "back_layout")
    common.wait_for_element(device, panels_device_settings_dict, "device_pairing_in_panel")


def force_stop_company_portal(device):
    # The below code snippet is temporary work-around for sign out app crash, BUG IDs: 3162022, 2870680
    print(
        f"{device}: Force Stop CP: Handling Sign out bug for Norden by force stopping company portal, BUG IDs: 3162022, 2870680"
    )
    _model = shared_utils.getconfig_device_model
    udid_ = common.device_udid(device)
    _result = subprocess.run(
        "adb -s " + udid_ + " shell am force-stop " + config["companyPortal_Package"],
        stdout=subprocess.PIPE,
        shell=True,
    )
    print(f"{device}: Kill CP returns: {_result}")
    # We're handling back button, this back button is intermittent.
    # If we encounter this on any other device, we have to handle them.
    if _model in ["spokane", "sammamish", "page"] or common.is_panel(device):
        for attempt in range(20):
            if common.is_element_present(device, sign_dict, "sign_in_on_the_device"):
                break
            # Another workaround:
            #   The 'partner admin settings' app may be active/visible, hiding the ZTP screen, dismiss it too.
            if common.click_if_present(device, tr_device_settings_dict, "back_button", "xpath"):
                print(f"{device}: Clicked on back button after {attempt} attempts")
    # Final check: After stopping CP, all devices must be (or transition) back on the ZTP screen:
    common.wait_for_element(device, sign_dict, "sign_in_on_the_device")


def signin_method_with_dcf_code(device, user=None):
    if user is None or user == "None":
        user = device
    elif "device" not in user:
        user = device + ":" + user
    username, password, user, account = common.get_credentials(user)
    # Check and enable GGC Cloud option
    if common.is_gcc_enabled():
        if account == "pstn_user":
            common.select_cloud_option_from_signin_page(device, "public")
        else:
            common.select_cloud_option_from_signin_page(device, "gcc")
    common.sleep_with_msg(device, 10, "Allow app to settle")
    if common.is_element_present(device, sign_dict, "refresh_code_button"):
        common.wait_for_and_click(device, sign_dict, "refresh_code_button")
        common.sleep_with_msg(device, 5, "Allow refresh of DFC code")
        if not common.is_element_present(device, sign_dict, "dfc_login_code"):
            perf_keywords.wait_and_click_refresh_code_button(device)
    dfc_login_code = common.wait_for_element(device, sign_dict, "dfc_login_code").text
    lcp_signinout.perform_web_sign(dfc_login_code, username, password)
    common.sleep_with_msg(device, 30, "Waiting for landing page to appear")
    common.click_if_element_appears(device, sign_dict, "Gotit_button")
    if "console" in device:
        common.wait_for_element(device, tr_console_signin_dict, "room_name", wait_attempts=100)
        if not common.is_element_present(device, tr_console_signin_dict, "select_device_paring_text"):
            common.wait_for_element(device, tr_console_signin_dict, "auto_pair_msg")
    else:
        if common.is_panel(device):
            panels_homescreen_keywords.verify_room_parameters(device)
        elif common.is_conf(device):
            home_screen_keywords.verify_home_screen_for_cnf_device(device)
        elif user in ["cap_search_enabled", "cap_search_disabled"]:
            time.sleep(display_time)
            if not common.is_element_present(device, settings_dict, "hotline_UI"):
                common.wait_for_element(device, calls_dict, "call_park")


def sign_in_by_invalid_dcf_code(device, invalid_dcf_code, user=None):
    if user is None or user == "None":
        user = device
    elif "device" not in user:
        user = device + ":" + user
    username, password, user, account = common.get_credentials(user)
    lcp_signinout.perform_web_sign(invalid_dcf_code, username, password, invalid_dcf_code_validate="on")


def handle_nps_survey_pop_up(device):
    """
    Handles the NPS survey pop-up that appears after sign-in.
    """
    common.tap_outside_the_popup(device, common.wait_for_element(device, sign_dict, "nps_survyey_container"))
