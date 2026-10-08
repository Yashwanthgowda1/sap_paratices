from selenium import webdriver
from selenium.common import WebDriverException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
import common
from Selectors import load_json_file
from initiate_driver import obj_dev as obj
from initiate_driver import config
from device_control import reset_Teams_app

display_time = 2
action_time = 3

calls_dict = load_json_file("resources/Page_objects/Calls.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
home_screen_dict = load_json_file("resources/Page_objects/Home_screen.json")
sign_dict = load_json_file("resources/Page_objects/Signin.json")
web_signin_dict = load_json_file("resources/Page_objects/Web_signin.json")


def verify_that_sign_in_is_successful(device_list, state):
    if state.lower() not in ["sign in", "sign out"]:
        raise AssertionError(f"Unexpected value for state: {state}")
    devices = device_list.split(",")
    print("Devices : ", devices)
    for device in devices:
        print("device : ", device)
        driver = obj.device_store.get(alias=device)
        if state.lower() == "sign in":
            common.click_if_present(device, calls_dict, "Call_Back_Button")
            common.click_if_present(device, home_screen_dict, "home_bar_icon")
            if (
                common.is_element_present(device, calendar_dict, "calendar_tab")
                or common.is_element_present(device, calls_dict, "call_park")
                or common.is_element_present(device, calls_dict, "calls_tab")
                or common.is_element_present(device, home_screen_dict, "more_option")
            ):
                print("Sign in is successfully completed")
                return
            elif not common.is_portrait_mode_cnf_device(device):
                raise AssertionError(f"Sign in is not completed on {device}")
            common.wait_for_element(device, calendar_dict, "app_bar_dialpad_icon")
            common.wait_for_element(device, calendar_dict, "app_bar_meet_now")
            common.wait_for_element(device, calendar_dict, "app_bar_more")
        elif state.lower() == "sign out":
            common.wait_for_element(device, sign_dict, "sign_in_on_the_device")


def verify_web_sign_with_different_protocol(device, protocol_type):
    # Secure means "https" and not_secure means "http"
    if protocol_type.lower() not in ["not_secure", "secure"]:
        raise AssertionError(f"{device}: Unexpected value for meeting release warning state: {protocol_type}")
    oem_ = common.device_oem(device)
    model_ = common.device_model(device)
    if model_ in [
        "beverly hills",
        "hollywood",
        "flint",
        "westchester",
        "brooklyn",
        "hollywood_13",
        "beverly hills_13",
    ] or oem_ in [
        "washington",
        "california",
    ]:
        chrome_driver = webdriver.Chrome()
        ip_address = common.device_udid(device).split(":")[0]

        if protocol_type.lower() == "secure":
            link = f"https://{ip_address}"
            chrome_driver.get(link)
            print("URL entered", link)
            chrome_driver.maximize_window()
            verifyElement = chrome_driver.find_element(
                by=By.XPATH, value=web_signin_dict["connection_isn't_private"]["xpath"]
            )
            wait = WebDriverWait(chrome_driver, timeout=7)
            wait.until(lambda d: verifyElement.is_displayed())
            if verifyElement.is_displayed():
                print(f"Login with {protocol_type} method")
            else:
                raise AssertionError("Valid web page result is not displayed")

        elif protocol_type.lower() == "not_secure":
            try:
                link = f"http://{ip_address}"
                chrome_driver.get(link)
                print("URL entered", link)

            except WebDriverException as e:
                print(f"Login with {protocol_type} method is not support")
        chrome_driver.close()
    else:
        print("This Test case is not applicable for this OEM")


def teams_restart_auth(device_name):
    reset_Teams_app(device_name, config, [config["companyPortal_Package"], config["common_desired_caps"]["appPackage"]])
