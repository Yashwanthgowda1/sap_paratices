from appium.webdriver.common.mobileby import MobileBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from Libraries.device_control import is_app_installed
from Libraries.initiate_driver import obj_dev as obj
from Libraries.initiate_driver import config
from resources.keywords import settings_keywords
import subprocess
import common
import time
from Libraries.Selectors import load_json_file
from resources.keywords import tr_settings_keywords
from resources.keywords import call_keywords
from resources.keywords import device_settings_keywords
from resources.keywords import tr_call_keywords
from datetime import timedelta
from datetime import datetime
from resources.keywords import tr_calendar_keywords
from resources.keywords import tr_home_screen_keywords
from Libraries import SignInOut
import re
from Libraries import shared_utils


display_time = 2
action_time = 3
action_time2 = 10

tr_settings_dict = load_json_file("resources/Page_objects/tr_settings.json")
tr_device_settings_dict = load_json_file("resources/Page_objects/tr_device_settings.json")
device_settings_dict = load_json_file("resources/Page_objects/Device_settings.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
tr_calendar_dict = load_json_file("resources/Page_objects/tr_calendar.json")
tr_calls_dict = load_json_file("resources/Page_objects/tr_calls.json")
common_dict = load_json_file("resources/Page_objects/Common.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
call_view_dict = load_json_file("resources/Page_objects/Call_views.json")
calls_dict = load_json_file("resources/Page_objects/Calls.json")
tr_home_screen_dict = load_json_file("resources/Page_objects/tr_home_screen.json")
tr_console_settings_dict = load_json_file("resources/Page_objects/rooms_console_settings.json")
sign_dict = load_json_file("resources/Page_objects/Signin.json")
tr_console_calendar_dict = load_json_file("resources/Page_objects/rooms_console_calendar.json")
tr_console_home_screen_dict = load_json_file("resources/Page_objects/rooms_console_home_screen.json")
app_bar_dict = load_json_file("resources/Page_objects/App_bar.json")
tr_console_signin_dict = load_json_file("resources/Page_objects/rooms_console_signin.json")
panels_device_settings_dict = load_json_file("resources/Page_objects/panels_device_settings.json")


def click_on_device_settings_page(device):
    print("device :", device)
    driver = obj.device_store.get(alias=device)
    try:
        WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((MobileBy.XPATH, tr_device_settings_dict["device_settings"]["xpath"]))
        ).click()
        print("Clicked on the Device Setting page: device settings page is visible")
    except Exception as e:
        raise AssertionError("Xpath not found")


def verify_back_button(device):
    print("device :", device)
    driver = obj.device_store.get(alias=device)
    try:
        ele = WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((MobileBy.XPATH, tr_device_settings_dict["back_button"]["xpath"]))
        )
        if ele.is_displayed():
            print("User have option to navigate back to app settings")
    except Exception as e:
        raise AssertionError("User don't  have option to navigate back to app settings")


def navigate_back_from_device_settings(device):
    common.wait_for_and_click(device, tr_device_settings_dict, "back_button")


def verify_device_type(device):
    print("device :", device)
    if common.is_norden(device):
        status = "norden"
    else:
        status = "null"
    return status


def check_device_type(device):
    print(f"{device}: Check device type")
    actual_val = device_settings_keywords.firmware_validation_of_device(device, option="device_type")
    expected_val = (config["device_type"]).lower()
    if expected_val in ["panel", "panels", "ipPhone", "lcp"]:
        if actual_val in ["panel", "panels", "ipPhone", "lcp"]:
            print(f"{device}: Device type matched: {actual_val}")
            return
    elif actual_val == expected_val:
        print(f"{device}: Device type matched: {actual_val}")
        return
    raise AssertionError(f"{device}: Actual device type: {actual_val} doesn't match expected value: {expected_val}")


def check_device_firmware_version(device):
    print(f"{device}: Check device firmware")
    expected_value = config["devices"][device]["firmware"]
    print(f"{device}: Expected firmware version is:{expected_value}")
    actual_value = device_settings_keywords.firmware_validation_of_device(device, option="firmware_version")
    print(f"{device}: Actual firmware version is:{actual_value}")
    if actual_value != expected_value:
        raise AssertionError(f"Firmware version reported : {actual_value} is not as expected: {expected_value}")


def navigate_back_from_device_settings_page(device):
    print("device :", device)
    settings_keywords.device_setting_back(device)
    if config["devices"][device]["model"].lower() in [
        "sammamish",
        "spokane",
        "everett",
        "renton",
        "vancouver",
        "pullman",
        "kent",
    ]:
        settings_keywords.device_setting_back(device)
    print("Naviagte back from device settings page")


def check_device_encryption_state(device):
    print("Check encryption state on :", device)
    udid_ = config["devices"][device]["desired_caps"]["udid"]
    print(udid_)
    dev_type = subprocess.check_output("adb -s " + udid_ + " shell getprop ro.crypto.state", shell=True)
    output = dev_type.splitlines()[0].rsplit()[-1].strip()
    actual_val = str(output, "utf-8")
    print("Device encryption state is : {}".format(actual_val))
    try:
        expected_val = (config["encryption_state"]).lower()
    except KeyError as e:
        raise AssertionError("Value is not defined in the config file")
    if actual_val == expected_val:
        print("Device encryption state is matched")
    else:
        raise AssertionError("Device encryption state is not matched")


def verify_encryption_supported_device(device):
    print("device :", device)
    if common.is_norden(device):
        status = "encrypted"
    else:
        status = "unsupported"
    return status


def navigate_to_meetings_option_in_device_settings_page(device):
    driver = obj.device_store.get(alias=device)
    common.wait_for_and_click(device, tr_device_settings_dict, "device_settings")
    if config["devices"][device]["model"].lower() in [
        "oakland",
        "irvine",
        "eureka",
        "santamonica",
        "pasadena",
        "palo alto",
        "whitter",
    ]:
        if config["devices"][device]["model"].lower() in ["santamonica", "pasadena", "whitter"]:
            for i in range(3):
                if common.is_element_present(device, tr_device_settings_dict, "teams_admin_settings1"):
                    break
                settings_keywords.swipe_till_end(device)
        else:
            device_settings_keywords.swipe_right_side_screen_till_bottom(device)
            device_settings_keywords.swipe_right_side_screen_till_bottom(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_element(device, settings_dict, "admin_pswd_option").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, settings_dict, "admin_enter")

    elif config["devices"][device]["model"].lower() in [
        "sammamish",
        "spokane",
        "everett",
        "renton",
        "vancouver",
        "pullman",
        "kent",
    ]:
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_settings", "xpath")
        common.wait_for_element(device, tr_device_settings_dict, "username_filed").send_keys(
            config["devices"][device]["admin_username"]
        )
        common.wait_for_element(device, tr_device_settings_dict, "password_filed").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, tr_device_settings_dict, "ok")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")

    elif config["devices"][device]["model"].lower() in ["houston", "austin", "sanantonio", "laredo"]:
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_settings", "xpath1")
        common.wait_for_element(device, device_settings_dict, "edit_text_number_pin").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, device_settings_dict, "submit_button")
        common.wait_for_and_click(device, device_settings_dict, "system_settings")
        common.wait_for_and_click(device, tr_device_settings_dict, "service_provider")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")

    elif config["devices"][device]["model"].lower() == "atlanta":
        device_settings_keywords.swipe_till_sign_out(device)
        device_settings_keywords.swipe_till_sign_out(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings2")
        common.wait_for_element(device, settings_dict, "admin_pass").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, settings_dict, "admin_enter_btn")

    elif config["devices"][device]["model"].lower() == "tucson":
        common.wait_for_and_click(device, tr_device_settings_dict, "device_administration")
        common.wait_for_and_click(device, tr_device_settings_dict, "device_administration_login")
        common.wait_for_element(device, settings_dict, "admin_pass").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, device_settings_dict, "ok")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")

    elif config["devices"][device]["model"].lower() in ["detroit", "dearborn", "southfield", "jackson", "royal oak"]:
        common.wait_for_and_click(device, tr_device_settings_dict, "teams")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings2", "xpath")
        ele = common.wait_for_element(
            device, tr_console_settings_dict, "admin_pass_field2", cond=EC.presence_of_all_elements_located
        )
        ele[-1].send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, sign_dict, "Sign_in")

    elif config["devices"][device]["model"].lower() in ["san francisco"]:
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        e1 = common.wait_for_element(device, settings_dict, "admin_pass")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_pass_enter")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings2")

    elif config["devices"][device]["model"].lower() in ["kodiak", "palmer", "homer"]:
        common.wait_for_and_click(device, tr_device_settings_dict, "login_to_admin")
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_settings1")
        passcode = common.wait_for_element(device, tr_device_settings_dict, "admin_passcode")
        passcode.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "login_button")
        common.scroll_the_page(
            device,
            common.wait_for_element(device, device_settings_dict, "device_settings_scroll_view_dt"),
            swiping="up",
        )
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_setting")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_setting1")

    elif config["devices"][device]["model"].lower() in [
        "vernon",
        "georgia",
        "manchester",
        "barre",
        "newport",
        "burlington",
        "alburgh",
    ]:
        device_settings_keywords.enabling_the_teams_admin_settings(device)

    elif config["devices"][device]["model"].lower() == "aurora":
        common.wait_for_and_click(device, tr_device_settings_dict, "admin")
        common.wait_for_element(device, tr_device_settings_dict, "username_filed").send_keys(
            config["devices"][device]["admin_username"]
        )
        common.wait_for_element(device, tr_device_settings_dict, "password_field").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, settings_dict, "Login_btn")
        common.wait_for_and_click(device, tr_device_settings_dict, "general")
        common.wait_for_and_click(device, tr_device_settings_dict, "service_provider")
        common.wait_for_and_click(device, tr_device_settings_dict, "access_settings")

    elif config["devices"][device]["model"].lower() in ["page", "mesa"]:
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "Device_administration")
        common.wait_for_and_click(device, tr_device_settings_dict, "device_administration_login")
        e1 = common.wait_for_element(device, settings_dict, "admin_pass")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, calendar_dict, "ok_button")
        settings_keywords.swipe_till_end(device)
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings_2")

    elif config["devices"][device]["model"].lower() == "augusta":
        for i in range(5):
            if common.is_element_present(device, tr_device_settings_dict, "teams_admin_settings1"):
                break
            settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        e1 = common.wait_for_element(device, settings_dict, "admin_pass")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_pass_enter")

    elif config["devices"][device]["model"].lower() == "kadubesnhalli":
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "admin")
        e1 = common.wait_for_element(device, settings_dict, "max_admin_password")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "ok")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")

    common.wait_for_and_click(device, tr_settings_dict, "meetings_button")
    common.wait_for_element(device, tr_calendar_dict, "show_meeting_names_text")


def click_on_about_page(device):
    # Select 'About' option
    common.wait_for_and_click(device, tr_settings_dict, "about")
    # Confirm page opens:
    common.wait_for_element(device, tr_device_settings_dict, "version")
    print(f"{device}: 'About' page opened")


def verify_microsoft_software_license_terms(device):
    common.wait_for_element(device, tr_device_settings_dict, "about")
    if not common.is_element_present(device, tr_device_settings_dict, "license"):
        raise AssertionError("license is not present in about page ")
    common.wait_for_element(device, tr_device_settings_dict, "version")
    common.wait_for_element(device, tr_device_settings_dict, "calling_version")
    tr_call_keywords.swipe_till_end_page(device)
    common.wait_for_element(device, tr_device_settings_dict, "release branch")
    call_keywords.dismiss_the_popup_screen(device)


def verify_third_party_software_and_information(device):
    common.wait_for_element(device, tr_device_settings_dict, "about")
    for i in range(5):
        if common.is_element_present(device, tr_device_settings_dict, "third_party_software_notices_and_information"):
            break
        tr_call_keywords.swipe_till_end_page(device)
    common.wait_for_and_click(device, tr_device_settings_dict, "third_party_software_notices_and_information")
    common.wait_for_element(device, tr_device_settings_dict, "third_party_software_notices_and_information2")
    common.wait_for_element(device, tr_device_settings_dict, "third_party_software_notices_and_information_web_test")
    if not common.click_if_present(device, tr_calls_dict, "close_roaster_button"):
        common.wait_for_and_click(device, common_dict, "back")


def verify_privacy_cookies(device):
    common.wait_for_element(device, tr_device_settings_dict, "about")
    tr_call_keywords.swipe_till_end_page(device)
    common.wait_for_and_click(device, tr_device_settings_dict, "privacy_cookies")
    common.wait_for_element(device, tr_device_settings_dict, "Microsoft_Privacy_Statement")
    if not common.click_if_present(device, tr_calls_dict, "close_roaster_button"):
        common.wait_for_and_click(device, common_dict, "back")


def navigate_to_meeting_and_calling_options_from_device_settings_page(console, option):
    if option.lower() not in ["calling", "meeting", "devices", "general", "settings_page"]:
        raise AssertionError(f"Unexpected value for method: {option}")
    driver = obj.device_store.get(alias=console)
    time.sleep(3)
    SignInOut.swipe_for_sign_out(console)
    if not common.click_if_present(console, tr_settings_dict, "device_settings"):
        common.wait_for_and_click(console, settings_dict, "Device_Settings")
    if config["consoles"][console]["model"].lower() in ["fresno", "fremont"]:
        print("Inside device settings page")
        time.sleep(3)
        for i in range(3):
            if common.is_element_present(console, tr_device_settings_dict, "teams_admin_settings1"):
                break
            device_settings_keywords.swipe_till_admin_settings(console)
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_element(console, settings_dict, "admin_pass", "xpath1").send_keys(
            config["consoles"][console]["admin_password"]
        )
        print("Entered the admin password value")
        common.wait_for_and_click(console, settings_dict, "admin_enter")

    elif config["consoles"][console]["model"].lower() in ["yakima", "sequim"]:
        common.wait_for_and_click(console, tr_device_settings_dict, "admin_settings", "xpath")
        print("Clicked on Admin settings page ")
        e1 = common.wait_for_element(
            console, tr_device_settings_dict, "edit_box_field", "xpath", cond=EC.visibility_of_all_elements_located
        )
        e1[0].send_keys(config["consoles"][console]["admin_username"])
        print("Admin Username entered")
        time.sleep(action_time)
        e1[1].send_keys(config["consoles"][console]["admin_password"])
        common.wait_for_and_click(console, tr_device_settings_dict, "ok")
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings1")

    elif config["consoles"][console]["model"].lower() in ["lansing"]:
        common.wait_for_element(console, device_settings_dict, "michigan_admin_signin")
        if common.is_element_present(console, tr_device_settings_dict, "teams_admin_settings2"):
            common.wait_for_and_click(console, tr_device_settings_dict, "michigan_back_button")
        if common.is_element_present(console, tr_device_settings_dict, "teams_admin_settings2"):
            common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings2")
        else:
            time.sleep(action_time)
            common.scroll_the_page(
                console,
                common.wait_for_element(console, tr_device_settings_dict, "device_settings_scroll_view"),
                swiping="up",
            )
            common.wait_for_and_click(console, tr_device_settings_dict, "teams_option")
            common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings2")
        ele = common.wait_for_element(
            console, tr_console_settings_dict, "admin_pass_field2", cond=EC.presence_of_all_elements_located
        )
        ele[-1].click()
        ele[-1].send_keys(config["consoles"][console]["admin_password"])
        common.wait_for_and_click(console, sign_dict, "Sign_in")

    elif config["consoles"][console]["model"].lower() in ["dallas"]:
        common.wait_for_and_click(console, tr_device_settings_dict, "admin_settings", "xpath1")
        common.wait_for_element(console, device_settings_dict, "edit_text_number_pin").send_keys(
            config["consoles"][console]["admin_password"]
        )
        common.wait_for_and_click(console, device_settings_dict, "submit_button")
        common.wait_for_and_click(console, device_settings_dict, "system_settings")
        common.wait_for_and_click(console, tr_device_settings_dict, "service_provider")
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings1")

    elif config["consoles"][console]["model"].lower() in ["pittsford"]:
        device_settings_keywords.enabling_the_teams_admin_settings(console)

    elif config["consoles"][console]["model"].lower() in ["denver"]:
        common.wait_for_and_click(console, tr_device_settings_dict, "admin")
        common.wait_for_element(console, tr_device_settings_dict, "username_filed").send_keys(
            config["consoles"][console]["admin_username"]
        )
        common.wait_for_element(console, tr_device_settings_dict, "password_field").send_keys(
            config["consoles"][console]["admin_password"]
        )
        common.wait_for_and_click(console, settings_dict, "Login_btn")
        common.wait_for_and_click(console, tr_device_settings_dict, "general")
        common.wait_for_and_click(console, tr_device_settings_dict, "service_provider")
        common.wait_for_and_click(console, tr_device_settings_dict, "access_settings")

    elif config["consoles"][console]["model"].lower() == "athens":
        time.sleep(action_time)
        device_settings_keywords.swipe_till_admin_sign_out(console)
        device_settings_keywords.swipe_till_admin_sign_out(console)
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings1")
        e1 = common.wait_for_element(console, settings_dict, "admin_pass")
        e1.send_keys(config["consoles"][console]["admin_password"])
        common.wait_for_and_click(console, tr_device_settings_dict, "admin_pass_enter")

    elif config["consoles"][console]["model"].lower() in ["tempe"]:
        common.wait_for_and_click(console, tr_device_settings_dict, "Device_administration")
        common.wait_for_and_click(console, tr_device_settings_dict, "device_administration_login")
        e1 = common.wait_for_element(console, settings_dict, "admin_pass")
        e1.send_keys(config["consoles"][console]["admin_password"])
        common.wait_for_and_click(console, calendar_dict, "ok_button")
        device_settings_keywords.swipe_till_admin_sign_out(console)
        device_settings_keywords.swipe_till_admin_sign_out(console)
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings_2")

    elif config["consoles"][console]["model"].lower() == "wrangell":
        common.scroll_the_page(
            console, common.wait_for_element(console, tr_device_settings_dict, "device_admin_scroll"), swiping="up"
        )
        common.wait_for_and_click(console, tr_device_settings_dict, "login_to_admin")
        common.wait_for_and_click(console, tr_device_settings_dict, "admin_settings1")
        passcode = common.wait_for_element(console, tr_device_settings_dict, "admin_passcode")
        passcode.send_keys(config["consoles"][console]["admin_password"])
        common.wait_for_and_click(console, tr_device_settings_dict, "login_button")
        driver.swipe(606, 1176, 60, 176)
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_setting")
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_setting1")

    if option.lower() == "meeting":
        common.wait_for_and_click(console, tr_settings_dict, "meetings_button")
        common.wait_for_element(console, tr_calendar_dict, "show_meeting_names_text")
    elif option.lower() == "calling":
        common.wait_for_and_click(console, tr_settings_dict, "calling_button")
        common.wait_for_element(console, tr_calls_dict, "call_forwarding_btn")
    elif option.lower() == "devices":
        common.wait_for_and_click(console, tr_device_settings_dict, "devices")
        common.wait_for_element(console, tr_device_settings_dict, "console_pairing")
    elif option.lower() == "general":
        common.wait_for_and_click(console, tr_device_settings_dict, "general")
        common.sleep_with_msg(console, 3, "wait for the screen page to load")
        common.wait_for_element(console, tr_device_settings_dict, "front_of_room_display")
    elif option.lower() == "settings_page":
        common.wait_for_element(console, tr_settings_dict, "meetings_button")
        common.wait_for_element(console, tr_device_settings_dict, "devices")
        common.wait_for_element(console, tr_device_settings_dict, "general")


def verify_call_view_is_not_present(device):
    common.wait_for_element(device, tr_calls_dict, "call_forwarding_btn")
    if common.is_element_present(device, call_view_dict, "call_view"):
        raise AssertionError("call view is not present in calling  page ")
    if not common.click_if_present(device, tr_calls_dict, "close_roaster_button"):
        common.wait_for_and_click(device, common_dict, "back")


def verify_auto_answer_setting_options(device):
    common.wait_for_element(device, tr_settings_dict, "calling_button")
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_calls_dict, "accept_meeting_automatically")
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_calls_dict, "accept_video_automatically")
    time.sleep(5)
    if not common.click_if_present(device, tr_calls_dict, "close_roaster_button"):
        common.wait_for_and_click(device, common_dict, "back")


# def check_device_capabilities(device):
#     print("Check device capabilities on :", device)
#     udid_ = config["devices"][device]["desired_caps"]["udid"]
#     device_cap = subprocess.check_output(
#         "adb -s " + udid_ + " shell settings get secure teams_device_capabilities", shell=True
#     )
#     print("Device Type is {} ".format(device_cap))


def verify_options_in_device_settings_calling(device):
    common.wait_for_element(device, tr_settings_dict, "calling_button_text")
    common.wait_for_element(device, settings_dict, "call_forwarding")
    common.wait_for_element(device, settings_dict, "also_ring")
    common.wait_for_element(device, settings_dict, "if_unanswered")
    tr_settings_keywords.swipe_screen_page(device)
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_settings_dict, "Calls_for_you")
    tr_settings_keywords.swipe_screen_page(device)
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_settings_dict, "block_calls_with_no_caller_ID")
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_settings_dict, "Blocked_numbers")
    call_keywords.device_right_corner_click(device)


def verify_calling_option_should_not_be_present_under_teams_admin_settings(device):
    common.wait_while_present(device, tr_calls_dict, "accept_button")


def unblock_the_number(device):
    common.wait_for_element(device, tr_settings_dict, "calling_button_text")
    tr_settings_keywords.swipe_screen_page(device)
    tr_settings_keywords.swipe_screen_page(device)
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_and_click(device, tr_settings_dict, "Blocked_numbers")
    common.wait_for_element(device, tr_settings_dict, "blocked_list")
    common.wait_for_and_click(device, tr_settings_dict, "unblock_number")
    common.wait_for_and_click(device, tr_settings_dict, "unblock_ok_button")
    call_keywords.device_right_corner_click(device)
    if not common.click_if_present(device, tr_calls_dict, "close_roaster_button"):
        common.wait_for_and_click(device, common_dict, "back")


def verify_if_user_gets_incoming_call(device):
    common.sleep_with_msg(device, 10, "Waiting for call status")
    if common.is_element_present(device, tr_calls_dict, "accept_button"):
        raise AssertionError("User is getting an incoming call")


def navigate_to_teams_admin_settings(device):
    driver = obj.device_store.get(alias=device)
    common.wait_for_and_click(device, tr_device_settings_dict, "device_settings")
    if config["devices"][device]["model"].lower() in [
        "oakland",
        "irvine",
        "eureka",
        "pasadena",
        "santamonica",
        "palo alto",
        "whitter",
    ]:
        if config["devices"][device]["model"].lower() in ["pasadena", "santamonica", "whitter"]:
            for i in range(3):
                if common.is_element_present(device, tr_device_settings_dict, "teams_admin_settings1"):
                    break
                settings_keywords.swipe_till_end(device)
        else:
            device_settings_keywords.swipe_right_side_screen_till_bottom(device)
            device_settings_keywords.swipe_right_side_screen_till_bottom(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_element(device, settings_dict, "admin_pswd_option").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, settings_dict, "admin_enter")

    elif config["devices"][device]["model"].lower() in [
        "sammamish",
        "spokane",
        "everett",
        "renton",
        "vancouver",
        "pullman",
        "kent",
    ]:
        if not common.is_element_present(device, tr_device_settings_dict, "teams_admin_settings1", "xpath"):
            common.wait_for_and_click(device, tr_device_settings_dict, "admin_settings", "xpath")
            common.wait_for_element(device, tr_device_settings_dict, "username_filed").send_keys(
                config["devices"][device]["admin_username"]
            )
            common.wait_for_element(device, tr_device_settings_dict, "password_filed").send_keys(
                config["devices"][device]["admin_password"]
            )
            common.wait_for_and_click(device, tr_device_settings_dict, "ok")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1", "xpath")

    elif config["devices"][device]["model"].lower() in ["houston", "austin", "sanantonio", "laredo"]:
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_settings", "xpath1")
        common.wait_for_element(device, device_settings_dict, "edit_text_number_pin").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, device_settings_dict, "submit_button")
        common.wait_for_and_click(device, device_settings_dict, "system_settings")
        common.wait_for_and_click(device, tr_device_settings_dict, "service_provider")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
    elif config["devices"][device]["model"].lower() == "atlanta":
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_element(device, settings_dict, "admin_pass").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, settings_dict, "admin_enter_btn")
    elif config["devices"][device]["model"].lower() == "tucson":
        common.wait_for_and_click(device, tr_device_settings_dict, "device_administration")
        common.wait_for_and_click(device, tr_device_settings_dict, "device_administration_login")
        common.wait_for_element(device, settings_dict, "admin_pass").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, device_settings_dict, "ok")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
    elif config["devices"][device]["model"].lower() in ["detroit", "dearborn", "southfield", "jackson", "royal oak"]:
        common.wait_for_and_click(device, tr_device_settings_dict, "teams")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings2", "xpath")
        ele = common.wait_for_element(
            device, tr_console_settings_dict, "admin_pass_field2", cond=EC.presence_of_all_elements_located
        )
        ele[-1].send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, sign_dict, "Sign_in")

    elif config["devices"][device]["model"].lower() in ["san francisco"]:
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        e1 = common.wait_for_element(device, settings_dict, "admin_pass")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_pass_enter")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings2")

    elif config["devices"][device]["model"].lower() in ["kodiak", "palmer", "homer"]:
        common.wait_for_and_click(device, tr_device_settings_dict, "login_to_admin")
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_settings1")
        passcode = common.wait_for_element(device, tr_device_settings_dict, "admin_passcode")
        passcode.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "login_button")
        common.scroll_the_page(
            device,
            common.wait_for_element(device, device_settings_dict, "device_settings_scroll_view_dt"),
            swiping="up",
        )
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_setting")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_setting1")

    elif config["devices"][device]["model"].lower() in [
        "vernon",
        "georgia",
        "manchester",
        "barre",
        "newport",
        "burlington",
        "alburgh",
    ]:
        device_settings_keywords.enabling_the_teams_admin_settings(device)

    elif config["devices"][device]["model"].lower() == "aurora":
        common.wait_for_and_click(device, tr_device_settings_dict, "admin")
        common.wait_for_element(device, tr_device_settings_dict, "username_filed").send_keys(
            config["devices"][device]["admin_username"]
        )
        common.wait_for_element(device, tr_device_settings_dict, "password_field").send_keys(
            config["devices"][device]["admin_password"]
        )
        common.wait_for_and_click(device, settings_dict, "Login_btn")
        common.wait_for_and_click(device, tr_device_settings_dict, "general")
        common.wait_for_and_click(device, tr_device_settings_dict, "service_provider")
        common.wait_for_and_click(device, tr_device_settings_dict, "access_settings")

    elif config["devices"][device]["model"].lower() in ["page", "mesa"]:
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "Device_administration")
        common.wait_for_and_click(device, tr_device_settings_dict, "device_administration_login")
        e1 = common.wait_for_element(device, settings_dict, "admin_pass")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, calendar_dict, "ok_button")
        settings_keywords.swipe_till_end(device)
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings_2")

    elif config["devices"][device]["model"].lower() == "augusta":
        for i in range(5):
            if common.is_element_present(device, tr_device_settings_dict, "teams_admin_settings1"):
                break
            settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")
        e1 = common.wait_for_element(device, settings_dict, "admin_pass")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "admin_pass_enter")

    elif config["devices"][device]["model"].lower() == "kadubesnhalli":
        settings_keywords.swipe_till_end(device)
        common.wait_for_and_click(device, tr_device_settings_dict, "admin")
        e1 = common.wait_for_element(device, settings_dict, "max_admin_password")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "ok")
        common.wait_for_and_click(device, tr_device_settings_dict, "teams_admin_settings1")


def verify_calling_option_in_device_settings_page(device):
    common.wait_for_and_click(device, tr_settings_dict, "calling_button")
    common.wait_for_element(device, tr_settings_dict, "calling_button_text")


def navigate_to_admin_only_enter_password_page(console):
    print("console :", console)
    driver = obj.device_store.get(alias=console)
    common.wait_for_and_click(console, settings_dict, "Device_Settings")
    if config["consoles"][console]["model"].lower() in ["fresno", "fremont"]:
        time.sleep(action_time)
        print("Inside device settings page")
        device_settings_keywords.swipe_till_admin_sign_out(console)
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings1")
        common.wait_for_element(console, settings_dict, "admin_pass", "xpath1").send_keys(
            config["consoles"][console]["admin_password"]
        )
        print("Entered the admin password value")

    elif config["consoles"][console]["model"].lower() in ["yakima", "sequim"]:
        time.sleep(3)
        if not common.is_element_present(console, tr_device_settings_dict, "admin_credentials_pop_up"):
            common.wait_for_and_click(console, tr_device_settings_dict, "admin_settings", "xpath")
            print("Clicked on Admin settings page ")
            e1 = common.wait_for_element(
                console, tr_device_settings_dict, "edit_box_field", "xpath", cond=EC.visibility_of_all_elements_located
            )
            e1[0].send_keys(config["consoles"][console]["admin_username"])
            print("Admin Username entered")
            time.sleep(action_time)
            e1[1].send_keys(config["consoles"][console]["admin_password"])

    elif config["consoles"][console]["model"].lower() in ["lansing"]:
        device_settings_keywords.swipe_till_admin_sign_out(console)
        common.wait_for_and_click(console, tr_device_settings_dict, "teams")
        common.wait_for_and_click(console, tr_device_settings_dict, "teams_admin_settings2", "xpath")
        ele = common.wait_for_element(
            console, tr_console_settings_dict, "admin_pass_field2", cond=EC.presence_of_all_elements_located
        )
        ele[-1].send_keys(config["consoles"][console]["admin_password"])

    elif config["consoles"][console]["model"].lower() in ["dallas"]:
        common.wait_for_and_click(console, tr_device_settings_dict, "admin_settings", "xpath1")
        common.wait_for_element(console, device_settings_dict, "edit_text_number_pin").send_keys(
            config["consoles"][console]["admin_password"]
        )

    elif config["consoles"][console]["model"].lower() in ["pittsford"]:
        device_settings_keywords.enabling_the_teams_admin_settings(console)

    elif config["consoles"][console]["model"].lower() in ["denver"]:
        common.wait_for_and_click(console, tr_device_settings_dict, "admin")
        common.wait_for_element(console, tr_device_settings_dict, "username_filed").send_keys(
            config["consoles"][console]["admin_username"]
        )
        common.wait_for_element(console, tr_device_settings_dict, "password_field").send_keys(
            config["consoles"][console]["admin_password"]
        )
        common.wait_for_and_click(console, settings_dict, "Login_btn")
        common.wait_for_and_click(console, tr_device_settings_dict, "general")
        common.wait_for_and_click(console, tr_device_settings_dict, "service_provider")
        common.wait_for_and_click(console, tr_device_settings_dict, "access_settings")


def extend_room_reservation_toggle(device, state):
    common.wait_for_element(device, tr_calendar_dict, "show_meeting_names_text")
    for i in range(7):
        if common.is_element_present(device, tr_calendar_dict, "extend_room_reservation_tgl"):
            break
        tr_settings_keywords.swipe_screen_page(device)
    common.change_toggle_button(device, tr_calendar_dict, "extend_room_reservation_tgl", state)


def verify_and_extend_reservation(device, time_in_minutes):
    common.wait_for_element(device, calendar_dict, "hang_up_btn")
    common.wait_for_and_click(device, calls_dict, "call_more_options")
    common.wait_for_and_click(device, tr_calendar_dict, "extend_reservation")
    common.wait_for_element(device, tr_calendar_dict, "new_end_time_for_meeting")
    if time_in_minutes == "15":
        common.wait_for_and_click(device, tr_calendar_dict, "extend_reservation_15_minutes")
    elif time_in_minutes == "30":
        common.wait_for_and_click(device, tr_calendar_dict, "extend_reservation_30_minutes")
    elif time_in_minutes == "45":
        common.wait_for_and_click(device, tr_calendar_dict, "extend_reservation_45_minutes")
    elif time_in_minutes == "60":
        common.wait_for_and_click(device, tr_calendar_dict, "extend_reservation_60_minutes")
    common.wait_for_and_click(device, tr_calendar_dict, "confirm_button")
    common.wait_for_element(device, tr_calendar_dict, "extend_reservation_popup")


def verify_extend_reservation_in_call_more_options(device):
    common.wait_for_element(device, calendar_dict, "hang_up_btn")
    common.wait_for_and_click(device, calls_dict, "call_more_options")
    common.wait_for_element(device, tr_calendar_dict, "extend_reservation")
    tr_calendar_keywords.dismiss_call_more_options(device)


def verify_tick_symbol_at_right_side_along_with_the_confirm_button(device):
    common.wait_for_element(device, calendar_dict, "hang_up_btn")
    common.wait_for_and_click(device, calls_dict, "call_more_options")
    common.wait_for_and_click(device, tr_calendar_dict, "extend_reservation")
    common.wait_for_element(device, tr_calendar_dict, "new_end_time_for_meeting")
    common.wait_for_element(device, tr_calendar_dict, "tick_symbol")
    common.wait_for_and_click(device, tr_calendar_dict, "Dismiss")


def extend_meeting_suggestions_should_show_15min_apart_of_time(device):
    common.wait_for_element(device, calendar_dict, "hang_up_btn")
    common.wait_for_and_click(device, calls_dict, "call_more_options")
    common.wait_for_and_click(device, tr_calendar_dict, "extend_reservation")
    common.wait_for_element(device, tr_calendar_dict, "new_end_time_for_meeting")
    slots_list = common.get_all_elements_texts(device, tr_calendar_dict, "extend_reservation_time")
    print(f"{device}: Time slots are: {slots_list}")
    for i in range(len(slots_list) - 1):
        s1 = datetime.strptime(slots_list[i], "%I:%M %p") + timedelta(minutes=15)
        s1 = s1.strftime("%I:%M %p").lstrip("0")
        if s1 != slots_list[i + 1]:
            raise AssertionError(f"Meeting timeslots aren't 15 minutes apart - slot1: {s1}, slot2: {slots_list[i + 1]}")
    common.wait_for_and_click(device, tr_calendar_dict, "Dismiss")


def accept_meeting_invites_automatically(device, state):
    if not state.lower() in ["on", "off"]:
        raise AssertionError(f"value for 'state' is not defined properly: '{state}'")
    if state.lower() == "on":
        state = "true"
    elif state.lower() == "off":
        state = "false"
    common.wait_for_element(device, tr_settings_dict, "calling_button_text")
    tr_settings_keywords.swipe_screen_page(device)
    toggle_btn = common.wait_for_element(device, tr_calls_dict, "accept_meeting_automatically")
    toggle_btn_status = toggle_btn.get_attribute("checked")
    print(f"Actual toggle button status: {toggle_btn_status}")
    print(f"Expected toggle button status: {state}")
    if toggle_btn_status.lower() != state.lower():
        common.wait_for_and_click(device, tr_calls_dict, "accept_meeting_automatically")
        toggle_btn = common.wait_for_element(device, tr_calls_dict, "accept_meeting_automatically")
        toggle_btn_status = toggle_btn.get_attribute("checked")
        print(f"Changed toggle button status: {toggle_btn_status.lower()}")
        if toggle_btn_status.lower() != state.lower():
            raise AssertionError(f"{device} Couldn't change the state of toggle button: {toggle_btn_status.lower()}")


def start_my_video_automatically(device, state):
    if not state.lower() in ["on", "off"]:
        raise AssertionError(f"value for 'state' is not defined properly: '{state}'")
    if state.lower() == "on":
        state = "true"
    elif state.lower() == "off":
        state = "false"
    common.wait_for_element(device, tr_settings_dict, "calling_button_text")
    tr_settings_keywords.swipe_screen_page(device)
    toggle_btn = common.wait_for_element(device, tr_calls_dict, "accept_video_automatically")
    toggle_btn_status = toggle_btn.get_attribute("checked")
    print(f"Actual toggle button status: {toggle_btn_status}")
    print(f"Expected toggle button status: {state}")
    if toggle_btn_status.lower() != state.lower():
        common.wait_for_and_click(device, tr_calls_dict, "accept_video_automatically")
        toggle_btn = common.wait_for_element(device, tr_calls_dict, "accept_video_automatically")
        toggle_btn_status = toggle_btn.get_attribute("checked")
        print(f"Changed toggle button status: {toggle_btn_status.lower()}")
        if toggle_btn_status.lower() != state.lower():
            raise AssertionError(f"{device} Couldn't change the state of toggle button: {toggle_btn_status.lower()}")


def verify_meeting_and_video_automatically_options(device):
    common.wait_for_element(device, tr_settings_dict, "calling_button")
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_calls_dict, "accept_meeting_automatically")
    tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_calls_dict, "accept_video_automatically")
    if not common.click_if_present(device, tr_calls_dict, "close_roaster_button"):
        common.wait_for_and_click(device, common_dict, "back")


def verify_auto_accept_timer_is_not_present(device):
    if common.is_element_present(device, tr_calls_dict, "auto_accept_timer"):
        raise AssertionError(f"{device}: auto accept timeer is present ")


def verify_auto_accept_toggle_is_disabled(device):
    tr_settings_keywords.swipe_screen_page(device)
    toggle = common.wait_for_element(device, tr_calls_dict, "accept_meeting_automatically").text
    if toggle.lower() != "off":
        raise AssertionError(f"{device}toggle is ON state")


def verify_auto_accept_toggle_is_not_present(device):
    tr_settings_keywords.swipe_screen_page(device)
    if common.is_element_present(device, tr_calls_dict, "accept_meeting_automatically"):
        raise AssertionError(f"{device}: auto accept toggle is present")


def verify_protected_apps_are_available_under_admin_settings(device):
    # common.wait_for_element(device, tr_settings_dict, "calling_button")
    common.wait_for_element(device, tr_settings_dict, "meetings_button")
    common.wait_for_element(device, tr_device_settings_dict, "devices")
    common.wait_for_element(device, tr_device_settings_dict, "general")
    common.wait_for_element(device, tr_device_settings_dict, "teams_sign_out")


def verify_what_is_new_under_privacy_and_cookies(device):
    common.wait_for_and_click(device, tr_device_settings_dict, "privacy_cookies")
    time.sleep(action_time2)
    common.wait_for_element(device, tr_device_settings_dict, "Microsoft_Privacy_Statement")
    time.sleep(action_time2)
    common.wait_for_and_click(device, tr_device_settings_dict, "whats_new?")
    common.wait_for_element(device, tr_device_settings_dict, "microsoft_privacy_note")


def navigate_back_to_more_option_page(device):
    time.sleep(5)
    if common.click_if_present(device, common_dict, "back"):
        common.sleep_with_msg(device, 2, "moving back 0")
    if (
        common.is_element_present(device, tr_device_settings_dict, "privacy_cookies")
        or common.is_element_present(device, tr_device_settings_dict, "terms_of_use")
        or common.is_element_present(device, tr_device_settings_dict, "third_party_software_notices_and_information")
    ):
        call_keywords.dismiss_the_popup_screen(device)
    time.sleep(3)
    if not common.click_if_present(device, calls_dict, "close_btn"):
        if common.click_if_present(device, common_dict, "back"):
            common.sleep_with_msg(device, 2, "moving back 1")
    if common.click_if_present(device, common_dict, "back"):
        common.sleep_with_msg(device, 2, "moving back 2")
    common.click_if_present(device, tr_console_settings_dict, "back_layout")
    common.wait_for_element(device, tr_console_home_screen_dict, "meet_now_icon")
    common.wait_for_element(device, tr_settings_dict, "more_button")


def verify_options_inside_about_page_console(device):
    common.wait_for_element(device, tr_device_settings_dict, "about")
    tr_call_keywords.swipe_till_end_page(device)
    tr_call_keywords.swipe_till_end_page(device)
    common.wait_for_element(device, tr_device_settings_dict, "privacy_cookies")
    common.wait_for_element(device, tr_settings_dict, "term_of_use")
    common.wait_for_element(device, tr_device_settings_dict, "third_party_software_notices_and_information")


def check_screen_resolution_version(device):
    print(f"{device}: Check Screen resolution of panel")
    expected_SR = config["devices"][device]["resolution"]
    actual_SR = device_settings_keywords.firmware_validation_of_device(device, option="screen_resolution")
    actual_SR = actual_SR.split()
    print(f"{device}: Expected Screen Resolution is: {expected_SR}")
    print(f"{device}: Actual Screen Resolution is: {actual_SR[-1]}")
    if actual_SR[-1] != expected_SR:
        raise AssertionError(f"Screen resolution reported :{actual_SR[-1]} is not as expected:{expected_SR}")


def verify_proximity_join_meeting_enabling_and_disabling_state(console, state):
    if not state.lower() in ["on", "off"]:
        raise AssertionError(f"value for 'state' is not defined properly: '{state}'")
    time.sleep(3)
    if not common.is_element_present(console, tr_console_calendar_dict, "allow_remote_control_from_personal_devices"):
        common.wait_for_element(console, tr_device_settings_dict, "front_of_room_display")
    for i in range(7):
        if common.is_element_present(console, tr_console_calendar_dict, "allow_remote_control_from_personal_devices"):
            break
        tr_settings_keywords.swipe_screen_page(console)
    # common.wait_for_element(console, tr_console_calendar_dict, "allow_remote_control_from_personal_devices")
    common.change_toggle_button(console, tr_console_calendar_dict, "proximity_join_tgl", state)


def enable_and_disable_e2ee(device, state):
    if state.lower() not in ["on", "off"]:
        raise AssertionError(f"Unexpected value for state: {state}")
    common.wait_for_and_click(device, tr_settings_dict, "calling_button")
    common.wait_for_element(device, tr_settings_dict, "calling_button_text")
    for i in range(7):
        if common.is_element_present(device, tr_device_settings_dict, "e2ee_toggle"):
            break
        tr_settings_keywords.swipe_screen_page(device)
    toggle_btn_status = common.wait_for_element(device, tr_device_settings_dict, "e2ee_toggle").text
    print(f"Actual toggle button status: {toggle_btn_status.lower()}")
    print(f"Expected toggle button status: {state.lower()}")
    if toggle_btn_status.lower() != state.lower():
        common.wait_for_and_click(device, tr_device_settings_dict, "e2ee_toggle")
        toggle_btn_status = common.wait_for_element(device, tr_device_settings_dict, "e2ee_toggle").text
        print(f"Changed toggle button status: {toggle_btn_status.lower()}")
        if toggle_btn_status.lower() != state.lower():
            raise AssertionError(f"{device} Couldn't change the state of toggle button: {toggle_btn_status.lower()}")
    common.wait_for_and_click(device, settings_dict, "cancel_btn")


def navigate_to_automatic_framing_under_teams_admin_settings(device):
    common.wait_for_and_click(device, tr_device_settings_dict, "room_camera")
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "automatic_framing")
    else:
        common.wait_for_element(device, tr_device_settings_dict, "automatic_framing")


def check_installed_teams_version(device):
    print(f"{device}: Check installed Teams version.")
    if "console" in device:
        expected_teams_apk_ver = config["consoles"][device]["teams_apk_version"]
    else:
        expected_teams_apk_ver = config["devices"][device]["teams_apk_version"]
    actual_teams_apk = device_settings_keywords.firmware_validation_of_device(device, option="apk_version")
    actual_teams_apk = re.findall(r"\d+\.\d+\.\d+\.(\d+)", actual_teams_apk)
    print(f"{device}: Expected teams APK version is: {expected_teams_apk_ver}")
    print(f"{device}: Actual teams APK version is: {actual_teams_apk}")
    if expected_teams_apk_ver not in actual_teams_apk:
        raise AssertionError(
            f"{device}: Teams APK version reported : {actual_teams_apk} is not as expected: {expected_teams_apk_ver}"
        )


def come_back_from_admin_settings_page(device_list):
    devices = device_list.split(",")
    for device in devices:
        print("device :", device)
        time.sleep(action_time)
        udid_ = common.device_udid(device)
        _model = common.device_model(device)
        for attempt in range(8):
            if common.is_element_present(device, tr_settings_dict, "more_button"):
                break

            _actions = [
                (calls_dict, "Call_Back_Button"),
                (tr_calendar_dict, "Dismiss"),
                (tr_device_settings_dict, "Logout"),
                (calendar_dict, "back"),
                (tr_device_settings_dict, "admin_back"),
                (tr_device_settings_dict, "admin_back_button"),
                (tr_device_settings_dict, "back_button"),
                (tr_console_settings_dict, "back_layout"),
                (calls_dict, "close_btn"),
            ]

            for dictionary, dict_key in _actions:
                device_type = common.device_type(device)
                if config[device_type][device]["model"].lower() in [
                    "manchester",
                    "barre",
                    "georgia",
                    "burlington",
                    "newport",
                    "alburgh",
                    "vernon",
                    "kadubesnhalli",
                ]:
                    subprocess.run(
                        "adb -s " + udid_ + " shell input keyevent KEYCODE_BACK",
                        stdout=subprocess.PIPE,
                        shell=True,
                    )
                elif common.click_if_present(device, dictionary, dict_key):
                    break
                elif _model in ["vancouver", "sequim"]:
                    subprocess.run(
                        "adb -s " + udid_ + " shell input keyevent KEYCODE_BACK",
                        stdout=subprocess.PIPE,
                        shell=True,
                    )
                    break

                if "console" in device:
                    if config["consoles"][device]["model"].lower() in ["yakima", "sequim"]:
                        if common.click_if_present(device, tr_device_settings_dict, "admin_back_button"):
                            break
                    elif config["consoles"][device]["model"].lower() == "pittsford":
                        subprocess.run(
                            "adb -s " + udid_ + " shell input keyevent KEYCODE_BACK",
                            stdout=subprocess.PIPE,
                            shell=True,
                        )
        if "console" in device:
            common.wait_for_element(device, tr_console_home_screen_dict, "room_user_name")
        else:
            if not tr_home_screen_keywords.is_home(device):
                raise AssertionError(f"{device}: still user is inside the admin settings page")


def verify_and_click_general_option_in_device_settings_page(device):
    common.wait_for_and_click(device, tr_device_settings_dict, "general")
    common.wait_for_element(device, tr_device_settings_dict, "front_of_room_display")
    common.wait_for_element(device, tr_device_settings_dict, "wireless_connection")


def verify_option_under_wireless_connection(device):
    for i in range(5):
        tr_settings_keywords.swipe_screen_page(device)
    common.wait_for_element(device, tr_device_settings_dict, "wireless_connection")
    common.wait_for_element(device, tr_device_settings_dict, "show_room_qr_code_txt")
    common.wait_for_element(device, tr_device_settings_dict, "show_room_qr_code_toggle")
    common.wait_for_element(device, tr_calendar_dict, "proximity_btn")


def enable_and_disable_qrcode_toggle(device, activity_state, device_name=None):
    common.wait_for_element(device, tr_device_settings_dict, "show_room_qr_code_txt")
    common.change_toggle_button(device, tr_device_settings_dict, "show_room_qr_code_toggle", activity_state)
    if device_name is not None:
        if common.is_element_present(device_name, tr_home_screen_dict, "qr_code"):
            raise AssertionError(
                f"After disableing the QR code toggle from {device} still Join meeting with QR code present on {device_name} homescreen"
            )


def verify_proximity_based_meeting_invitations_disabled(device):
    common.verify_toggle_button(device, tr_device_settings_dict, "proximity_toggle", desired_state="off")


def enable_and_disable_proximity_based_toggle(device, activity_state):
    common.wait_for_element(device, tr_device_settings_dict, "show_room_qr_code_txt")
    if "console" in device:
        tr_calendar_keywords.swipe_the_middle_page_to_end(device)
    common.change_toggle_button(device, tr_device_settings_dict, "proximity_toggle", activity_state)


def verify_the_options_inside_the_devices(device):
    if common.is_touch_console(device):
        common.wait_for_element(device, tr_device_settings_dict, "console_pairing")
    common.wait_for_element(device, tr_device_settings_dict, "room_camera")
    common.wait_for_element(device, tr_device_settings_dict, "content_camera")


def verify_the_options_inside_the_console_pairing(device):
    common.wait_for_and_click(device, tr_device_settings_dict, "console_pairing")
    common.wait_for_element(device, tr_device_settings_dict, "reset_pairing")
    common.wait_for_element(device, tr_device_settings_dict, "unpair_devices")


def check_installed_company_portal_version(device):
    print(f"{device}: Check installed company portal version.")
    expected_company_portal_apk_ver = config["devices"][device]["companyportal_apk_version"]
    actual_company_portal_apk = device_settings_keywords.firmware_validation_of_device(device, option="apk_version")
    print(f"{device}: Expected Company portal Apk version is: {expected_company_portal_apk_ver}")
    print(f"{device}: Actual Company portal Apk version is: {actual_company_portal_apk}")
    if expected_company_portal_apk_ver not in actual_company_portal_apk:
        raise AssertionError(
            f"{device}: Company portal Apk version reported : {actual_company_portal_apk} is not as expected: {expected_company_portal_apk_ver}"
        )


def enable_and_disable_automatic_framing_toggle(device, state):
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "automatic_framing")
    else:
        common.wait_for_element(device, tr_device_settings_dict, "automatic_framing")
        common.change_toggle_button(device, tr_device_settings_dict, "automatic_framing_tgl", state)


def verify_automatic_framing_options_are_disabled(device):
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "automatic_framing")
    else:
        common.wait_while_present(device, tr_device_settings_dict, "room")
        common.wait_while_present(device, tr_device_settings_dict, "composite")
        common.wait_for_and_click(device, tr_device_settings_dict, "back_button")


def verify_and_click_drop_down_icon_in_call_control_bar(device):
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "drop_down_button")
        print(device, "do not contain drop down button")
    else:
        common.wait_for_and_click(device, tr_device_settings_dict, "drop_down_button")


def verify_automatic_framing_options(device):
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "automatic_framing")
    else:
        common.wait_for_element(device, tr_device_settings_dict, "room_camera")
        common.change_toggle_button(device, tr_device_settings_dict, "automatic_framing_tgl", desired_state="on")
        if "console" in device:
            tr_call_keywords.swipe_till_end_page(device)
            common.sleep_with_msg(device, 5, "wait for page after swiped")
        common.wait_for_and_click(device, tr_device_settings_dict, "room")
        common.wait_for_and_click(device, tr_device_settings_dict, "composite")
        common.wait_for_and_click(device, tr_device_settings_dict, "active_speaker")
        common.wait_for_and_click(device, tr_device_settings_dict, "back_button")


def Verify_pro_tags_under_meetings(device, option):
    driver = obj.device_store.get(alias=device)
    options_dict = {
        "show_meeting_names": "pro_tag_show_meeting_name",
        "max_room_occupancy_notification": "pro_tag_Room_capacity_Notification",
        "extend_room_reservation": "pro_tag_Extend_room_reservation",
        "require_id_and_passcode": "pro_tag_require_passcode",
    }
    option_lower = option.lower()
    if option_lower not in options_dict:
        raise AssertionError(f"{device} Unexpected value for the option: {option}")
    ele = common.wait_for_element(device, tr_settings_dict, options_dict[option_lower])
    page_source_before = driver.page_source.encode("utf-8")
    ele.click()
    page_source_after = driver.page_source.encode("utf-8")
    if page_source_before != page_source_after:
        raise AssertionError(f"{device}: Up-sell message under the admin setting is actionable")


def verify_drop_down_icon_in_call_control_bar_is_present_or_not(device, state):
    state = state.lower()
    if state not in ["on", "off"]:
        raise AssertionError(f"{device}:Illegal state for {state}")
    if state == "on":
        is_visible = True
    else:
        is_visible = False
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "drop_down_button")
        print(device, "do not contain drop down button")
    else:
        common.verify_ui_element_visible(device, is_visible, tr_device_settings_dict, "drop_down_button")


def navigate_to_content_camera_under_teams_admin_settings(device):
    common.wait_for_and_click(device, tr_device_settings_dict, "content_camera")
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "automatic_framing")
    else:
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, "automatic_framing")


def verify_notification_banner_when_meeting_about_to_end(device, state):
    if state.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal state for {state}")
    common.wait_for_element(device, calendar_dict, "hang_up_btn")
    if state == "on":
        is_visible = True
    else:
        is_visible = False
    common.verify_ui_element_visible(device, is_visible, calendar_dict, "meeting_warning_banner")


def verify_meeting_warning_notification_banner_with_time_left(device_list, time_left_in_min):
    print(f"expected time left: {time_left_in_min}")
    time_left_in_min = int(time_left_in_min)
    devices = device_list.split(",")
    for device in devices:
        print(f"device: {device}")
        common.wait_for_element(device, calendar_dict, "hang_up_btn")
        for time_left in range(time_left_in_min, 2, -1):
            warning_banner_text = common.wait_for_element(device, calendar_dict, "meeting_warning_banner").text
            print(f"{device}:warning banner:{warning_banner_text}")
            print(f"Actual Time left:{warning_banner_text.split(' ')[0]} min")
            if f"{time_left}" not in warning_banner_text and f"{time_left - 1}" not in warning_banner_text:
                raise AssertionError(
                    f"{device}: expected {time_left_in_min} min ,but showing {warning_banner_text.split(' ')[0]} min"
                )
            print(f"{device}: showing as expected {time_left} min")
            common.sleep_with_msg(device, 60, "verify notification banner for every minutes")
            time_left_in_min = time_left_in_min - 1


def navigate_and_verify_teams_setting_option_from_device_settings_page(device, option):
    if option.lower() not in ["general", "meeting", "devices"]:
        raise AssertionError(f"Unexpected value for option: {option}")
    common.click_if_present(device, tr_device_settings_dict, "device_settings")
    if option.lower() == "meeting":
        common.wait_for_and_click(device, tr_settings_dict, "meetings_button")
        common.wait_for_element(device, tr_calendar_dict, "show_meeting_names_text")

    elif option.lower() == "devices":
        common.wait_for_and_click(device, tr_device_settings_dict, "devices")
        common.wait_for_element(device, tr_device_settings_dict, "content_camera")
        common.wait_for_element(device, tr_device_settings_dict, "room_camera")

    elif option.lower() == "general":
        common.wait_for_and_click(device, tr_device_settings_dict, "general")
        common.wait_for_element(device, tr_device_settings_dict, "front_of_room_display")
        common.wait_for_element(device, tr_device_settings_dict, "wireless_connection")


def verify_room_camera_option_under_admin_settings(device):
    if not common.is_element_present(device, tr_device_settings_dict, "room_camera"):
        common.wait_for_and_click(device, tr_device_settings_dict, "devices")
    common.wait_for_element(device, tr_device_settings_dict, "room_camera")


def enable_and_disable_restart_toggle(device, activity_state):
    for i in range(10):
        tr_call_keywords.swipe_till_end_page(device)
        if common.is_element_present(device, tr_settings_dict, "end"):
            break
    common.change_toggle_button(device, tr_settings_dict, "device_restart_tgl", activity_state)


def verify_device_restart_options_when_dut_user_enables_the_toggle_in_teams_admin_settings(device):
    common.wait_for_element(device, tr_settings_dict, "device_restart")
    common.wait_for_element(device, tr_settings_dict, "start")
    common.wait_for_element(device, tr_settings_dict, "end")


def verify_the_auto_pair_toogle_in_console(console, state):
    if state.lower() not in ["on", "off"]:
        raise AssertionError(f"{console}:Illegal value for state {state}")
    common.wait_for_and_click(console, tr_device_settings_dict, "console_pairing")
    toggle_state = common.wait_for_element(console, tr_device_settings_dict, "auto_pair_toggle").text
    if toggle_state.lower() != state:
        raise AssertionError(
            f"{console} Allow pairing without code toggle button is not enabled by default {toggle_state}"
        )
    # common.change_toggle_button(console, tr_device_settings_dict, "auto_pair_toggle", state)
    common.wait_for_element(console, tr_device_settings_dict, "reset_pairing")
    common.wait_for_element(console, tr_device_settings_dict, "unpair_devices")


def console_sign_in_method_for_pairing_without_code(console, user=None):
    if ":" in console and user:
        raise AssertionError(f"{console}: Cannot specify both encoded console AND user role '{user}'")
    if ":" not in console and user:
        console = f"{console}:{user}"
    username, password, console, account = common.get_credentials(console)
    _oem = common.device_oem(console)
    if _oem == "arizona":
        common.click_if_present(console, app_bar_dict, "back")
        common.click_if_present(console, sign_dict, "close")
    driver = obj.device_store.get(alias=console)
    if not common.is_element_present(console, sign_dict, "dfc_login_code"):
        if common.click_if_present(console, sign_dict, "refresh_code_button"):
            common.wait_for_element(console, sign_dict, "dfc_login_code")
    common.wait_for_and_click(console, sign_dict, "sign_in_on_the_device")
    search_input = common.wait_for_element(console, sign_dict, "Username")
    search_input.send_keys(username)
    print(f"Entered username '{username}'")
    if config["consoles"][console]["model"].lower() not in ["g", "fremont"]:
        common.hide_keyboard(console)
    common.wait_for_and_click(console, sign_dict, "Sign_in_button")

    common.wait_for_element(console, sign_dict, "Password").send_keys(password)

    driver.hide_keyboard()
    common.wait_for_and_click(console, sign_dict, "Sign_in")
    if common.click_if_element_appears(console, sign_dict, "register"):
        print(f"{console} :clicked on register button")


def verify_user_auto_and_manual_pairing(console, pairing, clicking=False):
    if pairing.lower() not in ["auto", "manual"]:
        raise AssertionError(f"{console}:Illegal value for state {pairing}")
    common.wait_for_element(console, tr_console_signin_dict, "room_name", wait_attempts=100)
    if pairing.lower() == "manual":
        common.wait_for_element(console, tr_console_signin_dict, "select_device_paring_text")
    elif pairing.lower() == "auto":
        if not common.is_element_present(console, tr_console_signin_dict, "auto_pair_msg"):
            raise AssertionError(f" Auto pairing message is not displayed on {console}'")
        if clicking is True:
            user_perform_manual_pairing_before_auto_pairing_time_out(console)


def verify_user_not_able_to_find_any_device_message_with_search_button(console):
    common.wait_for_element(console, panels_device_settings_dict, "no_device", wait_attempts=100)
    common.wait_for_element(console, tr_console_signin_dict, "search_again")


def verify_pairing_should_stop_when_click_on_search(console):
    common.wait_for_and_click(console, tr_console_signin_dict, "search_again", wait_attempts=100)
    common.raise_if_present(console, tr_console_signin_dict, "more_option")


def user_perform_manual_pairing_before_auto_pairing_time_out(console):
    room_name = common.wait_for_element(console, tr_console_signin_dict, "room_name")
    print("Selected rooms name :", room_name.text)
    device_serial_no = config["consoles"][console]["serial_number"]
    print("Device serial number : ", device_serial_no)
    serial_text = common.wait_for_element(
        console, tr_console_signin_dict, "rooms_description", "id", cond=EC.presence_of_all_elements_located
    )
    elem_list = [str(item.text).split(":")[1].strip() for item in serial_text]
    print("Device serial number on the console for pairing : ", elem_list)
    user_position = 0
    for console_serial_no in elem_list:
        if console_serial_no == device_serial_no:
            user_position = elem_list.index(console_serial_no)
            print(f"expected device no to click:", console_serial_no)
    serial_text[user_position].click()
    if common.is_element_present(console, tr_console_signin_dict, "room_code"):
        raise AssertionError(
            f"{console} pairing code is asking when performing manual pairing before auto pairing time out"
        )


def verify_web_view_chromium_support_version(device):
    print(f"{device}: check web view/Chromium support version ")
    actual_value = device_settings_keywords.firmware_validation_of_device(device, option="web_view_Chromium")
    print(f"{device}: Actual web view/Chromium support version is:{actual_value}")
    version_info = actual_value.strip().replace("versionName=", "")
    print(version_info)
    version_parts = version_info.split(".")
    version_parts = int(version_parts[0])
    if version_parts >= 114:
        return True
    else:
        raise AssertionError(f" {device}:is web view version less than 95,will not get Third-party meetings ")


def verify_no_option_is_present_under_content_camera(device):
    common.verify_ui_element_visible(device, False, tr_device_settings_dict, "room")
    common.verify_ui_element_visible(device, False, tr_device_settings_dict, "composite")
    common.verify_ui_element_visible(device, False, tr_device_settings_dict, "active_speaker")
    common.wait_for_and_click(device, tr_device_settings_dict, "back_button")


def verify_default_wallpaper(device):
    if "console" in device:
        common.wait_for_and_click(device, tr_device_settings_dict, "wallpaper")
    common.wait_for_element(device, tr_device_settings_dict, "vivid_wallpaper_selected")


def select_option_under_automatic_framing(device, option):
    if option.lower() not in ["composite", "active_speaker"]:
        raise AssertionError(f"{device}: Unexpected value for option: {option}")
    if automatic_framing_unsupported(device):
        common.verify_ui_element_visible(device, False, tr_device_settings_dict, option)
        print(device, f"does not contain {option} option")
    else:
        tr_settings_keywords.swipe_screen_page(device)
        common.wait_for_and_click(device, tr_device_settings_dict, option)
        time.sleep(action_time)


def verify_selected_option_under_automatic_framing(device, option):
    if option.lower() not in ["composite", "active_speaker"]:
        raise AssertionError(f"{device}: Unexpected value for option: {option}")
    tr_settings_keywords.swipe_screen_page(device)
    time.sleep(action_time)
    common.verify_ui_element_visible(device, True, tr_device_settings_dict, option)


def select_automatic_framing_option_under_call_control_bar(device, option):
    option = option.lower()
    if option not in ["composite", "active_speaker"]:
        raise AssertionError(f"{device}: Unexpected value for option: {option}")
    tr_settings_keywords.swipe_screen_page(device)
    time.sleep(action_time)
    common.wait_for_and_click(device, tr_device_settings_dict, option)
    time.sleep(action_time)
    common.click_if_present(device, tr_device_settings_dict, "back_button")


def automatic_framing_unsupported(device):
    _model = common.device_model(device)
    unsupported_models = _model in [
        "eureka",
        "oakland",
        "irvine",
        "santamonica",
        "pasadena",
        "fresno",
        "palo alto",
        "vernon",
        "georgia",
        "pittsford",
        "manchester",
        "burlington",
        "barre",
        "newport",
        "alburgh",
        "whitter",
        "fremont",
        "bronx",
    ]
    print(f"Device {device} do not support smart camera controls.")
    return unsupported_models


def verify_room_remote_option_under_admin_settings(device):
    common.wait_for_element(device, tr_device_settings_dict, "general")
    for i in range(4):
        if common.is_element_present(device, tr_device_settings_dict, "room_remote"):
            break
        tr_settings_keywords.swipe_screen_page(device)


def validate_the_functionality_of_room_remote_toggle_btn(device, state):
    for i in range(4):
        if common.is_element_present(device, tr_device_settings_dict, "room_remote"):
            break
        tr_settings_keywords.swipe_screen_page(device)
    common.change_toggle_button(device, tr_device_settings_dict, "room_remote_toggle", state)


def verify_source_under_room_camera(device):
    common.wait_for_element(device, tr_device_settings_dict, "source")
    common.wait_for_and_click(device, tr_device_settings_dict, "camera_with_dropdown")
    settings_keywords.device_setting_back(device)


def verify_presence_of_service_provider_packages(device):
    _oem = common.device_oem(device)
    print(f"{device}: checking service provider packages like Zoom and Webex")
    for app in ["zoom", "webex"]:
        if is_app_installed(device, app_name=app):
            raise AssertionError(f"{_oem}, {app} service provider package found when device is in Teams mode")
    print(f"{device}: {_oem}, Zoom and Webex service provider packages not found as excepted.")


def verify_default_camera(device):
    common.wait_for_element(device, tr_device_settings_dict, "built_in_camera")
    common.wait_for_element(device, tr_device_settings_dict, "camera_with_dropdown")


def user_click_room_camera(device):
    common.wait_for_and_click(device, tr_device_settings_dict, "room_camera")
    common.wait_for_element(device, tr_device_settings_dict, "source")


def verify_default_and_external_cam_names(device, camera_type):
    if camera_type.lower() not in ["default", "external_1", "external_2"]:
        raise AssertionError(f"{device}: Unexpected camera type: '{camera_type}'")
    common.wait_for_element(device, tr_device_settings_dict, "source")
    common.wait_for_and_click(device, tr_device_settings_dict, "camera_with_dropdown")
    time.sleep(3)
    expected_camera_name = shared_utils.getconfig_device_camera_name(device, camera_type)
    print(f"Expected Camera Name: {expected_camera_name}")
    temp_dict = common.get_dict_copy(tr_device_settings_dict, "camera_name", "camera_type", expected_camera_name)
    common.wait_for_and_click(device, temp_dict, "camera_name")
    selected_camera_element = common.wait_for_element(device, tr_device_settings_dict, "camera_name")
    actual_camera_name = selected_camera_element.text
    print(f"Actual Camera Name: {actual_camera_name}")
    if actual_camera_name.strip() != expected_camera_name.strip():
        raise AssertionError(
            f" Camera name is not matched. Expected: '{expected_camera_name}', Found: '{actual_camera_name}'"
        )


def verify_selected_camera(device, camera_type):
    if camera_type.lower() not in ["default", "external_1", "external_2"]:
        raise AssertionError(f"{device}: Unexpected camera type: '{camera_type}'")
    camera_name = shared_utils.getconfig_device_camera_name(device, camera_type)
    print(f"[{device}] Verifying selected camera: {camera_name}")
    temp_dict = common.get_dict_copy(tr_device_settings_dict, "camera_name", "camera_type", camera_name)
    common.wait_for_element(device, temp_dict, "camera_name")


def user_to_select_camera(device, camera_type):
    if camera_type.lower() not in ["default", "external_1", "external_2"]:
        raise AssertionError(f"{device}: Unexpected camera type: '{camera_type}'")
    camera_name = shared_utils.getconfig_device_camera_name(device, camera_type)
    print(f"[{device}] Camera Type Selected: {camera_type}, Camera Name: {camera_name}")
    common.wait_for_element(device, tr_device_settings_dict, "source")
    common.wait_for_and_click(device, tr_device_settings_dict, "camera_with_dropdown")
    print(f"[{device}] Clicked on camera dropdown")
    time.sleep(2)
    temp_dict = common.get_dict_copy(tr_device_settings_dict, "camera_name", "camera_type", camera_name)
    common.wait_for_and_click(device, temp_dict, "camera_name", "xpath")


def verify_video_pre_view(device):
    common.wait_for_element(device, tr_device_settings_dict, "room_camera")
    common.wait_for_element(device, tr_device_settings_dict, "pre_view_container")
