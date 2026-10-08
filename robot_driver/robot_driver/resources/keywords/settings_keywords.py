import time
import subprocess
from PIL import Image
import os
from datetime import datetime
import re

from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import InvalidElementStateException
from appium.webdriver.common.mobileby import MobileBy
from robot.libraries.BuiltIn import BuiltIn

from Libraries import shared_utils
from Libraries.Selectors import load_json_file
from Libraries.initiate_driver import config
from Libraries.initiate_driver import obj_dev as obj
from Libraries.initiate_driver import root_console

from resources.keywords import call_keywords
from resources.keywords import people_keywords
from resources.keywords import calendar_keywords
from resources.keywords import call_views_keywords
from resources.keywords import common
from resources.keywords import home_screen_keywords
from resources.keywords import device_settings_keywords
from resources.keywords import panel_meetings_device_settings_keywords
from resources.keywords import app_bar_keywords
from resources.keywords import voicemail_keywords
from resources.keywords import tr_device_settings_keywords
from resources.keywords import tr_app_settings_keywords
from resources.keywords import tr_settings_keywords

display_time = 2
action_time = 2
sleep_time = 5
sleep_time1 = 10

tr_calendar_dict = load_json_file("resources/Page_objects/tr_calendar.json")
navigation_dict = load_json_file("resources/Page_objects/Navigation.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
calls_dict = load_json_file("resources/Page_objects/Calls.json")
home_screen_dict = load_json_file("resources/Page_objects/Home_screen.json")
sign_dict = load_json_file("resources/Page_objects/Signin.json")
common_dict = load_json_file("resources/Page_objects/Common.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
hot_desk_dict = load_json_file("resources/Page_objects/Hot_desk.json")
device_settings_dict = load_json_file("resources/Page_objects/Device_settings.json")
lcp_homescreen_dict = load_json_file("resources/Page_objects/lcp_homescreen.json")
lcp_calls_dict = load_json_file("resources/Page_objects/lcp_calls.json")
app_bar_dict = load_json_file("resources/Page_objects/App_bar.json")
tr_Signin_dict = load_json_file("resources/Page_objects/tr_Signin.json")
tr_device_settings_dict = load_json_file("resources/Page_objects/tr_device_settings.json")
panels_device_settings_dict = load_json_file("resources/Page_objects/panels_device_settings.json")
people_dict = load_json_file("resources/Page_objects/people.json")
tr_settings_dict = load_json_file("resources/Page_objects/tr_settings.json")
# This flag is explicitly set ONLY during standalone testing.
# If set, the code deals with errors which should normally be fatal.
StandaloneTesting = False


def click_back(device):
    devices = device.split(",")
    for device in devices:
        common.wait_for_and_click(device, calls_dict, "Call_Back_Button")


def device_setting_back(device):
    """
    Avoid this - We should use the UI instead of inserting key events with ADB.
    """
    print(f"{device}: WARN - Using ADB - device back button, instead of UI back")
    _udid = common.device_udid(device)
    subprocess.call(
        f"adb -s {_udid} shell input keyevent KEYCODE_BACK",
        shell=True,
    )


def open_settings_page(device):
    for _attempt in range(20):
        common.click_if_present(device, calls_dict, "Call_Back_Button")
        common.click_if_present(device, home_screen_dict, "home_bar_icon")
        if common.is_lcp(device):
            common.wait_for_and_click(device, lcp_homescreen_dict, "homescreen_menu")
            common.wait_for_and_click(device, lcp_homescreen_dict, "settings_icon")
            return
        elif common.click_if_present(device, navigation_dict, "Navigation"):
            break
        elif common.click_if_present(device, calls_dict, "user_profile_picture"):
            break
        if _attempt == 19:
            raise AssertionError(f"{device} couldn't open navigation menu")
    time.sleep(3)
    common.wait_for_and_click(device, navigation_dict, "Settings_button")
    common.wait_for_element(device, settings_dict, "settings_page_header")


def enable_call_forwarding(device):
    devices = device.split(",")
    for device in devices:
        set_call_forwarding(device, "ON")


def disable_call_forwarding(device):
    devices = device.split(",")
    for device in devices:
        set_call_forwarding(device, "OFF")
        device_setting_back(device)
        common.click_if_present(device, device_settings_dict, "admin_settings_yes")
        device_setting_back(device)
        common.click_if_present(device, calls_dict, "Call_Back_Button")


def set_call_forwarding(device, desired_state):
    """
    Ensure Call Forwarding is the 'desired_state'. Either:
    a) Toggle Call Forwarding, or
    b) verify Call Forwarding is already in the desired state, or
    c) Verify the option is unavailable, AND there is no phone number defined.
    """

    global state
    time.sleep(display_time)
    if not common.click_if_present(device, settings_dict, "Calling"):
        swipe_till_end(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, settings_dict, "Device_Settings")
        device_settings_keywords.advance_calling_option_oem(device)
        common.wait_for_element(device, settings_dict, "call_forwarding")

    time.sleep(display_time)

    # Make sure we get to the Calling Options page
    common.wait_for_element(device, settings_dict, "Calling_opts_pagetitle")

    if not common.is_element_present(
        device, settings_dict, "Call_forward_toggle", selector_key="id", cond=EC.element_to_be_clickable
    ):
        account_type = "user"
        phonenumber = config["devices"][device][account_type]["phonenumber"]
        print(f"{device}['{account_type}']['phonenumber'] is '{phonenumber}'")
        if len(phonenumber) < 3:
            print(f"{device}: No phone number configured, missing Call_forward_toggle is ignored")
            return

    call_forwarding_toggle = common.wait_for_element(device, settings_dict, "Call_forward_toggle")
    call_forwarding_status = call_forwarding_toggle.get_attribute("checked")
    print(f"call_forwarding_status :{call_forwarding_status}")

    if desired_state == "ON":
        state = "true"
    elif desired_state == "OFF":
        state = "false"
    print(f"{device}: Set call_forwarding to '{desired_state}, state: {state}'")

    if call_forwarding_status == state:
        print(f"{device}: Call forwarding is already '{desired_state}'")
    else:
        common.wait_for_and_click(device, settings_dict, "Call_forward_toggle", "id")
        # Adding explicit sleep time since calling page is taking more time to load if any switch is toggled
        common.sleep_with_msg(device, 7, "Waiting for calling tab to load post toggling")
        call_forwarding_toggle = common.wait_for_element(device, settings_dict, "Call_forward_toggle")
        call_forwarding_status = call_forwarding_toggle.get_attribute("checked")
        if state != call_forwarding_status:
            raise AssertionError(f"{device}: Unexpected state of Call forwarding toggle")
        if state == "true":
            time.sleep(display_time)
            if common.is_element_present(device, settings_dict, "also_ring"):
                raise AssertionError(f"{device}: Call forwarding did not transition to {desired_state} after click")
        else:
            common.wait_for_element(device, settings_dict, "also_ring")


def click_device_settings(device):
    _attempt = 0
    while _attempt < 5:
        if not common.is_panel(device):
            if common.click_if_present(device, settings_dict, "Device_Settings"):
                return
            common.scroll_the_page(
                device, common.wait_for_element(device, settings_dict, "settings_page_scroll_view"), swiping="up"
            )

        else:
            if common.click_if_present(device, settings_dict, "Device_Settings"):
                return
            swipe_till_end(device)
        _attempt += 1
    common.wait_for_and_click(device, settings_dict, "Device_Settings")


def swipe_till_end(device):
    driver = obj.device_store.get(alias=device)
    window_size = driver.get_window_size()
    print(f"{device}: Window size: ", window_size)
    height = window_size["height"]
    # print("Window Height :", height)
    width = window_size["width"]
    # print("Window Width :", width)
    try:
        if height > width:
            print(f"{device}: Swiping portrait co-ordinates : ", width / 2, 4 * (height / 5), width / 2, height / 5)
            driver.swipe(width / 2, 4 * (height / 5), width / 2, height / 5)
        else:
            print(f"{device}: Swiping landscape co-ordinates : ", width / 4, 4 * (height / 5), width / 4, height / 5)
            driver.swipe(width / 4, 4 * (height / 5), width / 4, height / 5)
    except InvalidElementStateException:
        common.sleep_with_msg(device, 5, "Trapped InvalidElementStateException, retrying...")
        if height > width:
            driver.swipe(width / 2, 4 * (height / 5), width / 2, height / 5)
        else:
            driver.swipe(width / 4, 4 * (height / 5), width / 4, height / 5)
        print(f"{device}: Retry Success!")


def click_settings_debug(device):
    print("device :", device)
    driver = obj.device_store.get(alias=device)
    WebDriverWait(driver, 30).until(
        EC.element_to_be_clickable((MobileBy.XPATH, settings_dict["Debug"]["xpath"]))
    ).click()
    print("Clicked on settings>Debug button")
    time.sleep(display_time)


def enable_dark_theme(device):
    print("device :", device)
    common.wait_for_and_click(device, settings_dict, "Appearance_btn")
    time.sleep(action_time)
    if common.is_element_present(device, settings_dict, "dark_theme_selected"):
        print(f"{device} is already selected dark theme")
        common.wait_for_and_click(device, calendar_dict, "touch_outside")
    else:
        common.wait_for_and_click(device, settings_dict, "dark_theme")
        common.wait_for_and_click(device, settings_dict, "restart_btn")
        common.sleep_with_msg(device, 30, "Wait for app restart post tapping on dark theme")
        # Workaround for BUG:3719192(To dismiss got it button)
        common.click_if_element_appears(device, sign_dict, "Gotit_button", max_attempts=5)


def disable_dark_theme(device):
    print("device :", device)
    common.wait_for_and_click(device, settings_dict, "Appearance_btn")
    time.sleep(action_time)
    if common.is_element_present(device, settings_dict, "light_theme_selected"):
        print(f"{device} is already selected light theme")
        device_setting_back(device)
    else:
        common.wait_for_and_click(device, settings_dict, "light_theme")
        common.wait_for_and_click(device, settings_dict, "restart_btn")
    common.sleep_with_msg(device, 30, "Wait for app restart post tapping on light theme")


def verify_dark_theme_status(device, status):
    open_settings_page(device)
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    print("device :", device)
    time.sleep(display_time)
    common.wait_for_and_click(device, settings_dict, "Appearance_btn")
    if status.lower() == "off":
        common.wait_for_element(device, settings_dict, "light_theme_selected")
    elif status.lower() == "on":
        common.wait_for_element(device, settings_dict, "dark_theme_selected")
    device_setting_back(device)


def ignorefail_decorator(func):
    """
    Decorator to log and eat any exceptions raised by the wrapped method.
    Intended for preventing non-critical operations from interfereing with critical operations.
    """

    def _ignorefail(self, *args, **kwargs):
        try:
            result = func(self, *args)
            return result
        except Exception as e:
            # This is the last resort - exceptions should have been handled by the wrapped
            #   method. Mark these as errors and fix:
            print(f"ERROR: Ignored Exception in {func.__name__}: {type(e)}: {e})")
            return None

    return _ignorefail


def get_screenshot(name: str, device_list=None, with_xml: bool = True):
    """
    Gather device screenshots/xml (either real data or generic placeholders)
    """

    @ignorefail_decorator
    def ignorefail_get_screenshot(name: str, device_list=None, with_xml: bool = True):
        # Parameter sanith checks
        if not isinstance(name, str):
            raise AssertionError(f"get_screenshot: Cannot handle a 'name' parameter of type {type(name)}.")

        if isinstance(device_list, list):
            devices = device_list
        elif device_list is None:
            # Dump all known drivers:
            devices = obj.device_store.aliases
        elif isinstance(device_list, str):
            devices = device_list.split(",")
        else:
            raise AssertionError(
                f"get_screenshot: Cannot handle a 'device_list' parameter of type {type(device_list)}."
            )

        if not isinstance(with_xml, bool):
            raise AssertionError(f"get_screenshot: Cannot handle a 'with_xml' parameter of type {type(with_xml)}.")

        # Default screenshot if unavailable from device
        unavailable_screenshot = "unavailable.png"

        name = common.filename_from_string(name)

        print("name : ", name)
        devices.sort()
        print("Devices : ", devices)

        img_filename_list = []
        xml_list = {}

        # Gather data from all the requested devices:
        for device in devices:
            # Make sure the specified device is not the 'encoded' name:
            device_name, _ = common.decode_device_spec(device)
            try:
                driver = obj.device_store.get(device_name)
                file_name = device_name + ".png"
                driver.get_screenshot_as_file(file_name)
                img_filename_list.append(file_name)

                try:
                    xml_list[device_name] = driver.page_source.encode("utf-8")
                except Exception as e:
                    print(f"{device_name}: WARNING Unable to fetch XML: {str(e)}")
                    xml_list[device_name] = '<?xml version="1.0" encoding="utf-8"?><ui>XML unavailable</ui>'.encode(
                        "utf-8"
                    )

            except Exception as e:
                print(f"{device_name}: WARNING Unable to fetch screenshot of '{device}': {str(e)}")
                # Continue, but fill the screenshots/XML files
                # with placeholder data (at least the timestamp will be useful)
                img_filename_list.append(unavailable_screenshot)
                xml_list[device_name] = '<?xml version="1.0" encoding="utf-8"?><ui>XML unavailable</ui>'.encode("utf-8")

        # Compose the output composite bitmap:
        border_width = 3
        img_filename_list.sort()
        images = [Image.open(x) for x in img_filename_list]
        widths, heights = list(zip(*(i.size for i in images)))
        total_width = sum(widths) + border_width + (len(devices) * border_width)
        max_height = max(heights)

        # Start with a large Black canvas to paste images onto:
        new_im = Image.new("RGB", (total_width, max_height), (0, 0, 0))

        x_offset = border_width
        for im in images:
            new_im.paste(im, (x_offset, 0))
            x_offset += im.size[0] + border_width

        # Set the output composite bitmap name:
        current_time = datetime.now().strftime("%H%M%S")
        file_name = current_time + "_" + name + ".png"

        # Save the output composite bitmap:
        try:
            newpath = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "screenshots")
        except Exception as e:
            if not StandaloneTesting:
                raise AssertionError(
                    f"get_screenshot: Screenshot unavailable, cannot determine output directory: {str(e)}"
                )
            # Standalone testing - using: ".\..\..\screenshots" (relative to this file).
            newpath = os.path.dirname(os.path.abspath(__file__))  # "."
            newpath = os.path.dirname(newpath)  # ".\.."
            newpath = os.path.dirname(newpath)  # ".\..\.."
            newpath = os.path.join(newpath, "screenshots")
        if not os.path.exists(newpath):
            os.makedirs(newpath)

        image_name = shared_utils.get_extended_path_prefix() + os.path.join(newpath, file_name)

        # If the file name is too lengthy, shorten it.
        if len(image_name) > 260:
            image_name = image_name[:260] + ".png"

        new_im.save(image_name)

        print(f"Devices: {str(devices)} - New screenshot: {file_name}")
        try:
            BuiltIn().log(message="<image src=screenshots" + os.sep + file_name + ' width="90%">', html=True)
        except Exception as e:
            if not StandaloneTesting:
                print(f"WARNING: Cannot log screenshot reference: {str(e)}")

        # Save XML files:
        if with_xml:
            for device_name in xml_list:
                try:
                    file_name1 = (
                        shared_utils.get_extended_path_prefix()
                        + os.path.join(newpath, file_name)
                        + "_"
                        + device_name
                        + ".xml"
                    )

                    # If the file name is too lengthy, shorten it.
                    if len(file_name1) > 260:
                        file_name1 = file_name1[:260] + f"_{device_name}.xml"

                    with open(file_name1, "wb") as xml_file:
                        xml_file.write(xml_list[device_name])
                except Exception as e:
                    print(f"WARNING: Unable to write ui XML log for {device_name}! : {str(e)}")

        # Clean up any temporary device bitmaps
        for file_name in img_filename_list:
            if file_name == unavailable_screenshot:
                continue
            try:
                os.remove(file_name)
            except Exception as e:
                print(f"WARNING: Unable to clean temporary file: {file_name}: {str(e)}")

    ignorefail_get_screenshot(name, device_list, with_xml)


def refresh_calls_main_tab(device):
    devices = device.split(":")
    device = devices[0]
    driver = obj.device_store.get(alias=device)
    if common.is_phone(device):
        container = common.wait_for_element(device, calls_dict, "calls_tab_container")
        container_bounds = container.get_attribute("bounds").replace("][", ",").strip("]").strip("[").split(",")
        cont_cord = list(map(int, container_bounds))
        print(f"Container bounds: {cont_cord}")
        x1 = cont_cord[0] + (cont_cord[2] - cont_cord[0]) / 2
        y1 = cont_cord[1] + 20
        x2 = x1
        y2 = y1 + 4 * (cont_cord[3] - cont_cord[1]) / 5
        driver.swipe(x1, y1, x2, y2)
        time.sleep(action_time)
        driver.swipe(x1, y1, x2, y2)
        print(f"{device}: swiped and refreshed co-ordinates:({x1},{y1}), ({x2}, {y2})")
        return
    window_size = driver.get_window_size()
    print("Window size: ", window_size)
    height = window_size["height"]
    print("Window Height :", height)
    width = window_size["width"]
    print("Window Width :", width)
    if height > width:
        print("Refreshing co-ordinates : ", width / 2, height / 3, width / 2, 4 * (height / 5))
        driver.swipe(width / 2, height / 3, width / 2, 4 * (height / 5))
        time.sleep(action_time)
        driver.swipe(width / 2, height / 3, width / 2, 4 * (height / 5))
    else:
        print("Refreshing co-ordinates : ", 3 * (width / 4), height / 3, 3 * (width / 4), 4 * (height / 5))
        driver.swipe(3 * (width / 4), height / 3, 3 * (width / 4), 4 * (height / 5))
        time.sleep(action_time)
        driver.swipe(3 * (width / 4), height / 3, 3 * (width / 4), 4 * (height / 5))
    time.sleep(display_time)


def refresh_main_tab(device):
    driver = obj.device_store.get(alias=device)
    window_size = driver.get_window_size()
    print("Window size: ", window_size)
    height = window_size["height"]
    width = window_size["width"]
    if height > width:
        print("Refreshing co-ordinates : ", width / 2, height / 3, width / 2, 4 * (height / 5))
        driver.swipe(width / 2, height / 3, width / 2, 4 * (height / 5))
        time.sleep(action_time)
        driver.swipe(width / 2, height / 3, width / 2, 4 * (height / 5))
    else:
        print("Refreshing co-ordinates : ", width / 4, height / 3, width / 4, 4 * (height / 5))
        driver.swipe(width / 4, height / 3, width / 4, 4 * (height / 5))
        time.sleep(action_time)
        driver.swipe(width / 4, height / 3, width / 4, 4 * (height / 5))
    time.sleep(display_time)


def call_forward_setup(from_device, contact_device, call_forward_to):
    if not call_forward_to.lower() in ["contacts", "call group", "delegate", "voicemail"]:
        raise AssertionError(f"Illegal call_forward_to specified: '{call_forward_to}'")

    if ":" in contact_device:
        devices, account = common.decode_device_spec(contact_device)
        if account == "pstn_user":
            display_name = config["devices"][devices][account]["pstndisplay"]
        else:
            display_name = common.config["devices"][devices][account]["displayname"]
    else:
        display_name = common.device_displayname(contact_device)

    for from_device in from_device.split(","):
        print("device : ", from_device)
        if not common.click_if_element_appears(from_device, settings_dict, "Calling", max_attempts=3):
            # If the user is already on calling settings page, proceed with toggle button check.
            if not common.is_element_present(from_device, settings_dict, "call_forwarding"):
                swipe_till_end(from_device)
                swipe_till_end(from_device)
                common.wait_for_and_click(from_device, settings_dict, "Device_Settings")
                device_settings_keywords.advance_calling_option_oem(from_device)
                common.wait_for_element(from_device, settings_dict, "call_forwarding")

        time.sleep(sleep_time1)
        common.change_toggle_button(from_device, settings_dict, "Call_forward_toggle", desired_state="on")
        common.sleep_with_msg(from_device, 6, "Let the element stabilize post click")
        common.wait_for_and_click(from_device, settings_dict, "forward_option_btn")

        if (call_forward_to.lower()) == "contacts":
            common.wait_for_and_click(from_device, settings_dict, "contact_option")
            time.sleep(display_time)
            common.click_if_present(from_device, settings_dict, "add_contact_option")
            element = common.wait_for_element(from_device, settings_dict, "search_contact_box")
            element.send_keys(display_name)
            time.sleep(display_time)
            common.hide_keyboard(from_device)
            tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", display_name)
            common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")
        elif call_forward_to.lower() == "call group":
            common.wait_for_and_click(from_device, settings_dict, "also_ring_call_group_btn")
        elif call_forward_to.lower() == "delegate":
            if common.is_lcp(from_device):
                common.wait_for_and_click(from_device, settings_dict, "also_ring_delegate_btn")
            else:
                _max_attempts = 2
                for _attempt in range(_max_attempts):
                    if common.click_if_present(from_device, settings_dict, "also_ring_delegate_btn"):
                        break
                    # If delegate option is absent, there might not be any delegates added. Hence, add it and continue
                    if _attempt == _max_attempts - 1:
                        common.return_to_home_screen(from_device)
                        open_settings_page(from_device)
                        open_manage_delegate_page(from_device)
                        add_new_delegate(from_device, contact_device)
                        call_views_keywords.go_back_to_previous_page(from_device)
                        open_settings_page(from_device)
                        call_forward_setup(from_device, contact_device, "delegate")
        elif call_forward_to.lower() == "voicemail":
            common.wait_for_and_click(from_device, settings_dict, "voicemail_option")
        time.sleep(3)
        if common.is_lcp(from_device):
            device_setting_back(from_device)
        else:
            common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")


def select_if_unanswered_option(device):
    if common.is_lcp(device):
        common.wait_for_and_click(device, settings_dict, "Calling")
    else:
        if not common.click_if_present(device, settings_dict, "Calling", "xpath"):
            swipe_till_end(device)
            swipe_till_end(device)
            common.wait_for_and_click(device, settings_dict, "Device_Settings")
            device_settings_keywords.advance_calling_option_oem(device)
            common.wait_for_element(device, settings_dict, "call_forwarding")
    if not common.is_element_present(device, settings_dict, "unanswered_btn"):
        # Clean-up failure: Call forwarding might have been enabled. Check and rectify.
        common.change_toggle_button(device, settings_dict, "Call_forward_toggle", "off")
    common.wait_for_and_click(device, settings_dict, "unanswered_btn")


def unanswered_call_setup(from_device, select_option, contact_device=None):
    if not select_option.lower() in ["contacts", "off", "call group", "delegate", "voicemail"]:
        raise AssertionError(f"Illegal select_option specified: '{select_option}'")
    select_if_unanswered_option(from_device)
    if select_option.lower() == "contacts":
        pstn_displayname = common.device_pstndisplay(contact_device)
        common.wait_for_and_click(from_device, settings_dict, "contact_option")
        time.sleep(display_time)
        common.click_if_present(from_device, settings_dict, "add_contact_option")
        element = common.wait_for_element(from_device, settings_dict, "search_contact_box")
        element.send_keys(pstn_displayname)
        time.sleep(display_time)
        common.hide_keyboard(from_device)
        tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", pstn_displayname)
        common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")
    elif select_option.lower() == "off":
        common.wait_for_and_click(from_device, settings_dict, "unanswerd_off")
        time.sleep(display_time)
    elif select_option.lower() == "voicemail":
        common.wait_for_and_click(from_device, settings_dict, "voicemail_option")
    elif select_option.lower() == "call group":
        common.wait_for_and_click(from_device, settings_dict, "also_ring_call_group_btn")
    elif select_option.lower() == "delegate":
        common.wait_for_and_click(from_device, settings_dict, "also_ring_delegate_btn")
    time.sleep(3)
    device_setting_back(from_device)
    device_setting_back(from_device)
    call_keywords.come_back_to_home_screen(from_device)


def select_also_ring_option(device):
    print("device :", device)
    time.sleep(display_time)
    if not common.click_if_present(device, settings_dict, "Calling", "xpath"):
        swipe_till_end(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, settings_dict, "Device_Settings")
        device_settings_keywords.advance_calling_option_oem(device)
        common.wait_for_element(device, settings_dict, "call_forwarding")
    if not common.click_if_element_appears(device, settings_dict, "also_ring_btn", max_attempts=3):
        # Some clean-up failure - call forwarding might be enabled. So, also-ring option is unavailable.
        # Click on call forward toggle to disable it and proceed with also-ring click.
        common.wait_for_element(device, settings_dict, "call_forwarding")
        common.change_toggle_button(device, settings_dict, "Call_forward_toggle", "off")
        common.wait_for_and_click(device, settings_dict, "also_ring_btn")


def setup_also_ring(device, select_option, contact_device=None):
    if not select_option.lower() in ["contact", "off", "call group", "delegate", "voicemail"]:
        raise AssertionError(f"Illegal select_option specified: '{select_option}'")
    if select_option.lower() == "contact" and contact_device is None:
        raise AssertionError(
            f"{device}: Invalid parameters for specified test: 'select_option': '{select_option}' and 'contact_device': '{contact_device}'"
        )
    select_also_ring_option(device)
    if select_option.lower() == "off":
        common.wait_for_and_click(device, settings_dict, "also_ring_off_btn")
    elif select_option.lower() == "contact":
        devices, account = common.decode_device_spec(contact_device)
        display_name = common.config["devices"][devices][account]["displayname"]
        if account == "pstn_user":
            display_name = config["devices"][devices][account]["pstndisplay"]
        common.wait_for_and_click(device, settings_dict, "contact_option")
        time.sleep(5)
        common.click_if_present(device, settings_dict, "add_contact_option")
        element = common.wait_for_element(device, settings_dict, "search_contact_box")
        element.send_keys(display_name)
        common.hide_keyboard(device)
        tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", display_name)
        common.wait_for_and_click(device, tmp_dict, "search_result_item_container", "xpath")
    elif select_option.lower() == "voicemail":
        common.wait_for_and_click(device, settings_dict, "voicemail_option")
    elif select_option.lower() == "call group":
        common.wait_for_and_click(device, settings_dict, "also_ring_call_group_btn")
    elif select_option.lower() == "delegate":
        common.wait_for_and_click(device, settings_dict, "also_ring_delegate_btn")
    time.sleep(3)
    device_setting_back(device)
    device_setting_back(device)
    common.return_to_home_screen(device)


def device_back_from_tz(device):
    if config["devices"][device]["model"].lower() in ["Olympia"]:
        device_setting_back(device)
        device_setting_back(device)
    else:
        pass


def select_user_presence(device, state):
    if not state.lower() in ["available", "busy", "dnd", "be right back", "offline", "away", "reset_status"]:
        raise AssertionError(f"Illegal state specified: '{state}'")
    device, account = common.decode_device_spec(device)
    if common.is_lcp(device):
        common.wait_for_and_click(device, lcp_homescreen_dict, "homescreen_menu")
        common.wait_for_element(device, lcp_homescreen_dict, "user_current_status")
        common.wait_for_and_click(device, lcp_homescreen_dict, "status_drop_down_button")
    else:
        common.click_if_present(device, calls_dict, "Call_Back_Button")
        time.sleep(action_time)
        common.click_if_present(device, home_screen_dict, "home_bar_icon")
        common.wait_for_and_click(device, navigation_dict, "Navigation")
        common.wait_for_and_click(device, navigation_dict, "more_current_presence_btn")
    if state.lower() == "available":
        if config["devices"][device]["model"].lower() == "riverside" and account == "cap_search_enabled":
            common.wait_for_element(device, navigation_dict, "default_presence_state")
        elif config["devices"][device]["model"].lower() == "olympia" and account == "cap_search_enabled":
            common.wait_for_element(device, navigation_dict, "default_presence_state")
        else:
            common.wait_for_and_click(device, navigation_dict, "Available")
    elif state.lower() == "busy":
        common.wait_for_and_click(device, navigation_dict, "Busy")
    elif state.lower() == "dnd":
        common.wait_for_and_click(device, navigation_dict, "Do_not_disturb")
    elif state.lower() == "be right back":
        common.wait_for_and_click(device, navigation_dict, "Be_right_back")
    elif state.lower() == "offline":
        if common.is_lcp(device):
            swipe_till_end(device)
        common.wait_for_and_click(device, navigation_dict, "Offline")
    elif state.lower() == "away":
        if common.is_lcp(device):
            swipe_till_end(device)
        common.wait_for_and_click(device, navigation_dict, "Away")
    elif state.lower() == "reset_status":
        if common.is_lcp(device):
            swipe_till_end(device)
        common.wait_for_and_click(device, navigation_dict, "reset_status")
    if common.is_lcp(device):
        common.wait_for_and_click(device, lcp_homescreen_dict, "more_cancel_button")
        return
    common.wait_for_and_click(device, settings_dict, "user_displayname")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")


def verify_user_presence(device, state):
    if state.lower() not in ["available", "busy", "dnd", "be right back", "offline", "away", "in a call"]:
        print(f"Unexpected value for state: {state}")
    if common.is_lcp(device):
        common.wait_for_and_click(device, lcp_homescreen_dict, "homescreen_menu")
        common.wait_for_element(device, lcp_homescreen_dict, "user_current_status")
    else:
        common.click_if_present(device, home_screen_dict, "home_bar_icon")
        common.wait_for_and_click(device, navigation_dict, "Navigation")
    presence_text = common.wait_for_element(device, navigation_dict, "current_presence_label").text.lower()
    print("Current presence is : ", presence_text)
    if state.lower() != presence_text:
        if not (state.lower() == "dnd" and presence_text == "do not disturb"):
            raise AssertionError(
                f"expected presence value: {state} doesn't match the actual presence value: {presence_text}"
            )
    print(f"Selected presence on {device} is {presence_text}")
    if common.is_lcp(device):
        common.wait_for_and_click(device, lcp_homescreen_dict, "more_cancel_button")
        return
    common.wait_for_and_click(device, settings_dict, "user_displayname")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")


def open_manage_delegate_page(device):
    common.wait_for_and_click(device, settings_dict, "manage_delegates")
    common.sleep_with_msg(device, 3, "Wait for manage delegates page to load")

    # The "Your Delegates" title should be present ONLY if there are delegates.
    # Issue: The delegates list is sometimes not populated yet (as in 1st access)
    #
    # Workaround:
    if common.is_element_present(device, calls_dict, "your_delegates"):
        # The "Your Delegates" title is present, make sure the list is populated:
        if not common.is_element_present(device, settings_dict, "your_delegates_list"):
            # The list is not populated!
            print(f"{device} Workaround - Empty delegates list, refreshing...")
            # Workaround: Exit the 'Manage Delegates' page, and re-enter:
            common.wait_for_and_click(device, settings_dict, "manage_delegates_back")
            common.wait_for_and_click(device, settings_dict, "manage_delegates")
            common.sleep_with_msg(device, 3, "Wait for manage delegates page to load, again")
            if common.is_element_present(device, calls_dict, "your_delegates"):
                if not common.is_element_present(device, settings_dict, "your_delegates_list"):
                    raise AssertionError(f"{device} The delegates list is still empty after refresh workaround.")
            else:
                # Unexpected (never seen, but possible), the Title "your_delegates" removed after refresh. Log it:
                print(f"{device} 'Your Delegates' title removed after refreshing.")


def add_new_delegate(from_device, to_device, permission="All", action="save"):
    if not permission.lower() in ["make call", "receive call", "all"]:
        raise AssertionError(f"Illegal permission specified: '{permission}'")
    delegate_username = common.device_displayname(to_device)
    print(
        f"{from_device}: Delegate to be added: '{delegate_username}', from device: '{from_device}', with permission: '{permission}'"
    )

    # Check if there are any existing delegates that matches 'delegate_username'
    if common.is_element_present(from_device, calls_dict, "your_delegates"):
        # Title "your_delegates" exists, so there MUST be at least one "your_delegates_list" entry:
        your_delegates_list_elems = common.wait_for_element(
            from_device, settings_dict, "your_delegates_list", cond=EC.presence_of_all_elements_located
        )
        your_delegates_list = []
        for del_obj in your_delegates_list_elems:
            your_delegates_list.append(del_obj.get_attribute("content-desc"))
        if delegate_username in your_delegates_list:
            print(f"{from_device}: Existing delegates: '{your_delegates_list}', already includes '{delegate_username}'")
            return

    # No delegates or no delegate with 'delegate_username' name - proceed with addition
    common.kb_trigger_search(from_device, settings_dict, "add_delegates", delegate_username)

    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", delegate_username)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")
    elems = common.wait_for_element(
        from_device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )

    #
    # Warning: Huge assumptions here about order, number, and meaning of permissions switches:
    #
    make_call = elems[0]
    receive_call = elems[1]

    if permission.lower() == "make call":
        elem_text = make_call.get_attribute("checked")
        if elem_text != "true":
            make_call.click()
            print("Make calls switch is turned ON")
        elem_text = receive_call.get_attribute("checked")
        if elem_text == "true":
            receive_call.click()
            print("Receive calls switch is turned OFF")

    elif permission.lower() == "receive call":
        elem_text = receive_call.get_attribute("checked")
        if elem_text != "true":
            receive_call.click()
            print("Receive calls is turned ON")
        elem_text = make_call.get_attribute("checked")
        if elem_text == "true":
            make_call.click()
            print("Make calls switch is turned OFF")
    elif permission.lower() == "all":
        if config["devices"][from_device]["model"].lower() == "gilbert":
            swipe_till_end(from_device)
        for elem in elems:
            elem_text = elem.get_attribute("checked")
            if elem_text != "true":
                elem.click()
        print("All the permission switches are ON")
    if action.lower() == "save":
        common.wait_for_and_click(from_device, settings_dict, "save_permissions")
        common.sleep_with_msg(from_device, 5, "Wait for the saved delegates list to refresh")
        for i in range(2):
            common.click_if_present(from_device, calls_dict, "Call_Back_Button")
            time.sleep(3)
    elif action.lower() == "discard":
        for _ in range(2):
            common.wait_for_and_click(from_device, app_bar_dict, "back")
        open_manage_delegate_page(from_device)
        common.wait_for_element(from_device, settings_dict, "user_title")
        users = common.get_all_elements_texts(from_device, settings_dict, "user_title")
        if users.count(delegate_username) > 0:
            raise AssertionError(f"{to_device} is added as delegate after click on back")


def validate_added_delegate_user_name(from_device, to_device):
    print("from_device :", from_device)
    time.sleep(action_time)
    if not common.is_element_present(from_device, settings_dict, "manage_delegates"):
        open_settings_page(from_device)
    open_manage_delegate_page(from_device)
    time.sleep(action_time)
    username = common.device_displayname(to_device)
    print("username : ", username)
    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", username)
    common.wait_for_element(from_device, tmp_dict, "search_result_item_container", "xpath")
    print(f"{username} is successfully added as a delegate")
    common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")
    common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")
    call_keywords.navigate_to_calls_favorites_page(from_device)
    refresh_calls_main_tab(from_device)


def delete_delegate_from_manage_delegate(from_device, to_device):
    common.sleep_with_msg(from_device, 5, "Wait for the favorites page to load")
    if not call_keywords.verify_delegates_in_favorites_page(from_device):
        return
    refresh_calls_main_tab(from_device)
    open_settings_page(from_device)
    open_manage_delegate_page(from_device)
    devices = to_device.split(",")
    for device in devices:
        delegate_username = common.device_displayname(device)
        tmp_dict = common.get_dict_copy(settings_dict, "your_delegates_list", "user_name", delegate_username)
        time.sleep(action_time)
        refresh_main_tab(from_device)
        time.sleep(action_time)
        common.wait_for_and_click(from_device, tmp_dict, "your_delegates_list", "xpath1")

        if config["devices"][from_device]["model"].lower() == "gilbert":
            swipe_till_end(from_device)
        common.wait_for_and_click(from_device, settings_dict, "delete_delegates", "xpath")
        # wait for manage_delegate tab post deleting a delegate
        common.sleep_with_msg(from_device, 3, "Waiting for delegates list refresh")
        common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")
        common.wait_for_and_click(from_device, settings_dict, "manage_delegates")

        common.wait_for_element(from_device, settings_dict, "manage_delegates")

        # Issue: this will fail if there were multiple delegates:
        common.wait_while_present(from_device, tmp_dict, "your_delegates_list", "xpath1")

        print(f"{from_device}: Successfully removed {delegate_username} from list of delegates")
    for attempt in range(3):
        if not common.click_if_present(from_device, calls_dict, "Call_Back_Button"):
            break
        common.sleep_with_msg(from_device, 3, f"React to 'Call_Back_Button' click, attempt: {attempt}.")


def validate_user_should_not_be_able_to_add_self_as_delegate(device):
    open_settings_page(device)
    open_manage_delegate_page(device)
    common.wait_for_and_click(device, settings_dict, "add_delegates")
    username = config["devices"][device]["user"]["displayname"]
    print("username : ", username)
    common.wait_for_element(device, settings_dict, "add_delegates").send_keys(username)
    common.hide_keyboard(device)
    time.sleep(action_time)
    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", username)
    if common.is_element_present(device, tmp_dict, "search_result_item_container", "xpath"):
        raise AssertionError("Self can be added as a delegate")
    print("Cannot add self as delegate")


def edit_delegate(from_device, to_device, permission="All"):
    if not permission.lower() in [
        "make call",
        "receive call",
        "change call and delegate settings",
        "join active calls",
        "pick up held calls",
        "all",
    ]:
        raise AssertionError(f"Illegal permission specified: '{permission}'")
    print("from_device :", from_device)
    username = common.device_displayname(to_device)
    tmp_dict = common.get_dict_copy(settings_dict, "delegate_result_username", "username", username)
    del_list = common.wait_for_element(from_device, tmp_dict, "delegate_result_username")
    del_list.click()
    time.sleep(action_time)
    elems = common.wait_for_element(
        from_device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )
    make_call = elems[0]
    receive_call = elems[1]
    change_call_and_delegate_settings = elems[2]
    join_active_calls = elems[3]
    pick_up_held_calls = elems[4]
    if permission.lower() == "make call":
        elem_text = make_call.get_attribute("checked")
        if elem_text == "true":
            print("Make calls switch is already ON")
        else:
            make_call.click()
            print("Make calls switch is turned ON")
        for elem in elems:
            elem_text = elem.get_attribute("checked")
            elem_index = elems.index(elem)
            if elem_index != 0:
                if elem_text != "false":
                    elem.click()
        print("All the other permission switches are OFF")
    elif permission.lower() == "receive call":
        elem_text = receive_call.get_attribute("checked")
        if elem_text == "true":
            print("Receive calls switch is already ON")
        else:
            receive_call.click()
            print("Receive calls switch is turned ON")
        for elem in elems:
            elem_text = elem.get_attribute("checked")
            elem_index = elems.index(elem)
            if elem_index != 1:
                if elem_text != "false":
                    elem.click()
        print("All the other permission switches are OFF")
    elif permission.lower() == "change call and delegate settings":
        elem_text = change_call_and_delegate_settings.get_attribute("checked")
        if elem_text == "true":
            print("Change call and delegate settings switch is already ON")
        else:
            change_call_and_delegate_settings.click()
            print("Change call and delegate settings switch is turned ON")
        for elem in elems:
            elem_text = elem.get_attribute("checked")
            elem_index = elems.index(elem)
            if elem_index != 2:
                if elem_text != "false":
                    elem.click()
        print("All the other permission switches are OFF")
    elif permission.lower() == "join active calls":
        elem_text = join_active_calls.get_attribute("checked")
        if elem_text == "true":
            print("Join active calls switch is already ON")
        else:
            join_active_calls.click()
            print("Join active calls switch is turned ON")
        for elem in elems:
            elem_text = elem.get_attribute("checked")
            elem_index = elems.index(elem)
            if elem_index != 3:
                if elem_text != "false":
                    elem.click()
        print("All the other permission switches are OFF")
    elif permission.lower() == "pick up held calls":
        elem_text = pick_up_held_calls.get_attribute("checked")
        if elem_text == "true":
            print("Pick up held calls switch is already ON")
        else:
            pick_up_held_calls.click()
            print("Pick up held calls switch is turned ON")
        for elem in elems:
            elem_text = elem.get_attribute("checked")
            elem_index = elems.index(elem)
            if elem_index != 4:
                if elem_text != "false":
                    elem.click()
        print("All the other permission switches are OFF")
    elif permission.lower() == "all":
        for elem in elems:
            elem_text = elem.get_attribute("checked")
            if elem_text != "true":
                elem.click()
        print("All the permission switches are ON")
    common.click_if_present(from_device, settings_dict, "save_permissions")
    common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")


def verify_user_unable_to_toggle_the_permissions(device):
    permission_titles_list = common.wait_for_element(
        device, settings_dict, "delegate_permissions", cond=EC.presence_of_all_elements_located
    )
    permission_switches_list = common.wait_for_element(
        device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )
    switch_status_before_toggling = []
    switch_status_after_toggling = []
    for i in range(len(permission_switches_list)):
        switch_status_before_toggling.append(permission_switches_list[i].get_attribute("checked"))
        permission_switches_list[i].click()
        switch_status_after_toggling.append(permission_switches_list[i].get_attribute("checked"))
    if switch_status_before_toggling != switch_status_after_toggling:
        raise AssertionError(
            f"{device}: User is able to toggle the permissions\nPermission titles: {permission_titles_list}\nExpected permission list: {switch_status_before_toggling}\nActual permission list: {switch_status_after_toggling}"
        )


def navigate_to_change_delegates_page(device):
    call_keywords.navigate_to_calls_favorites_page(device)
    common.wait_for_and_click(device, calls_dict, "favorites_more_options")
    common.wait_for_element(device, settings_dict, "view_permissions_xpath")
    common.wait_for_and_click(device, calls_dict, "change_delegates")
    common.wait_for_element(device, settings_dict, "add_delegates")


def click_device_center_point(device):
    devices = device.split(",")
    for device in devices:
        time.sleep(action_time)
        driver = obj.device_store.get(alias=device)
        window_size = driver.get_window_size()
        height = window_size["height"]
        print("Window Height :", height)
        width = window_size["width"]
        print("Window Width :", width)
        subprocess.call(
            "adb -s {} shell input tap {} {}".format(
                config["devices"][device]["desired_caps"]["udid"].split(":")[0], width / 2, height / 2
            ),
            shell=True,
        )
        time.sleep(display_time)
        print("Tapped co-ordinates : ", width / 2, height / 2)


def enable_home_screen(device):
    print("device :", device)
    home_screen_toggle_btn = common.wait_for_element(
        device, settings_dict, "home_screen_toggle_btn", cond=EC.element_to_be_clickable
    )
    toggle_text = home_screen_toggle_btn.text
    print(f"{device}: Home screen option text currently: '{toggle_text}'")
    if toggle_text == "OFF":
        home_screen_toggle_btn.click()
        time.sleep(action_time)
        print(f"{device}: Clicked on Home Screen toggle_btn button")
        common.wait_for_and_click(device, settings_dict, "restart_btn")
        common.sleep_with_msg(device, 10, "enable_home_screen")
    elif toggle_text == "ON":
        print(f"{device}: Homescreen is already enabled on the device, continuing ..")
        common.wait_for_and_click(device, calls_dict, "Call_Back_Button")
        home_screen_keywords.come_back_to_home_screen_page_and_verify(device)
    else:
        raise AssertionError(f"{device}: Invalid toggle text")


def disable_home_screen(device):
    print("device :", device)
    home_screen_toggle_btn = common.wait_for_element(
        device, settings_dict, "home_screen_toggle_btn", cond=EC.element_to_be_clickable
    )
    toggle_text = home_screen_toggle_btn.text
    print(f"{device}: Home screen option text currently: '{toggle_text}'")
    if toggle_text == "ON":
        home_screen_toggle_btn.click()
        print(f"{device}: Clicked on Home screen button")
        common.wait_for_and_click(device, settings_dict, "restart_btn")
        common.sleep_with_msg(device, 10, "disable_home_screen")
    elif toggle_text == "OFF":
        print("Homescreen is already disabled on the device, continuing ..")
        common.wait_for_and_click(device, calls_dict, "Call_Back_Button")
        call_keywords.navigate_to_calls_tab(device)
    else:
        raise AssertionError(f"{device}: Invalid toggle text")


def verify_home_screen_status(device, status):
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    print(f"{device}: verify_home_screen_status={status}")
    if status.lower() == "off":
        common.wait_for_element(device, calls_dict, "recent_tab")
    elif status.lower() == "on":
        # Homescreen is enabled, but user is on different tab
        common.click_if_present(device, home_screen_dict, "home_bar_icon")
        common.wait_for_element(device, calls_dict, "user_profile_picture")


def navigate_to_device_setting_page_from_home_screen_enable_page(device):
    print("device :", device)
    if common.is_lcp(device):
        common.wait_for_and_click(device, lcp_homescreen_dict, "homescreen_menu")
        common.wait_for_and_click(device, lcp_homescreen_dict, "settings_icon")
        swipe_till_end(device)
        swipe_till_end(device)
        click_device_settings(device)
        return
    common.wait_for_and_click(device, calls_dict, "user_profile_picture", wait_attempts=60)
    common.wait_for_and_click(device, navigation_dict, "Settings_button")
    time.sleep(action_time)
    click_device_settings(device)


def navigate_to_app_setting_page_from_home_screen(device):
    print("device :", device)
    if common.is_lcp(device):
        common.wait_for_and_click(device, lcp_homescreen_dict, "homescreen_menu")
        common.wait_for_and_click(device, lcp_homescreen_dict, "settings_icon")
        swipe_till_end(device)
        swipe_till_end(device)
        return
    common.wait_for_and_click(device, calls_dict, "user_profile_picture", wait_attempts=60)
    common.wait_for_and_click(device, navigation_dict, "Settings_button")
    time.sleep(action_time)
    print("Clicked on settings option")


def swipe_left(device):
    driver = obj.device_store.get(alias=device)
    window_size = driver.get_window_size()
    print("Window size: ", window_size)
    height = window_size["height"]
    print("Window Height :", height)
    width = window_size["width"]
    print("Window Width :", width)
    if height > width:
        print("Swiping co-ordinates : ", (3 * (width / 4), height / 2, 50, height / 2))
        driver.swipe(3 * (width / 4), height / 2, 50, height / 2)
    else:
        print("Swiping co-ordinates : ", (width / 3, height / 2, 50, height / 2))
        driver.swipe(width / 3, height / 2, 50, height / 2)


def enable_notification(device):
    toggle_button = common.wait_for_element(device, settings_dict, "notification_toggle")
    toggle_btn_state = toggle_button.get_attribute("checked")
    if toggle_btn_state.lower() == "false":
        common.wait_for_and_click(device, settings_dict, "notification_toggle")
        toggle_button = common.wait_for_element(device, settings_dict, "notification_toggle")
        toggle_btn_state = toggle_button.get_attribute("checked")
        if toggle_btn_state.lower() != "true":
            raise AssertionError(f"{device}: Cannot change the notification toggle status: {toggle_button}")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")


def disable_notification(device):
    toggle_button = common.wait_for_element(device, settings_dict, "notification_toggle")
    toggle_btn_state = toggle_button.get_attribute("checked")
    if toggle_btn_state.lower() == "true":
        common.wait_for_and_click(device, settings_dict, "notification_toggle")
        toggle_button = common.wait_for_element(device, settings_dict, "notification_toggle")
        toggle_btn_state = toggle_button.get_attribute("checked")
        if toggle_btn_state.lower() != "false":
            raise AssertionError(f"{device}: Cannot change the notification toggle status: {toggle_button}")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")


def verify_notification_status(device, status):
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    print("device :", device)
    time.sleep(display_time)
    if status.lower() == "off":
        if common.is_element_present(device, home_screen_dict, "notification_view"):
            raise AssertionError("Still notifications are visible on homescreen")
        print("Notifications are not visible on homescreen")
    elif status.lower() == "on":
        common.wait_for_element(device, home_screen_dict, "notification_view")


def verify_signin_with_invalid_user(device, user=None):
    invalid_username = config["user"]["invalid_username"]
    common.sleep_with_msg(device, 6, "verify_signin_with_invalid_user")
    if common.is_element_present(device, sign_dict, "refresh_code_button"):
        common.wait_for_and_click(device, sign_dict, "refresh_code_button")
        common.sleep_with_msg(device, 5, "Allow refresh of DFC code")
    common.wait_for_element(device, sign_dict, "dfc_login_code")
    common.wait_for_and_click(device, sign_dict, "sign_in_on_the_device")

    common.wait_for_and_click(device, sign_dict, "Username")
    common.wait_for_element(device, sign_dict, "Username").send_keys(invalid_username)
    print(f"{device} entered the invalid username '{invalid_username}'")

    if not common.click_if_present(device, sign_dict, "Sign_in_button"):
        common.hide_keyboard(device)
        common.wait_for_and_click(device, sign_dict, "Sign_in_button")

    common.wait_for_and_click(device, sign_dict, "Next_button")
    common.sleep_with_msg(device, 5, "Allow soft keyboard to appear")
    if "console" not in device:
        _model = shared_utils.getconfig_device_model(device)
        if _model not in ["spokane", "sammamish", "pullman"]:
            common.hide_keyboard(device)
    invalid_username_error = common.wait_for_element(device, sign_dict, "invalid_username_error").text
    invalid_username_error_list = [
        "This username may be incorrect. Make sure that you typed it correctly. Otherwise, contact your admin.",
        "This username may be incorrect. Make sure you typed it correctly. Otherwise, contact your admin.",
    ]
    if invalid_username_error not in invalid_username_error_list:
        raise AssertionError(
            f"{device}: Expected error message is not displayed for invalid username: {invalid_username_error}"
        )
    if not common.is_element_present(device, tr_Signin_dict, "sign_back"):
        common.hide_keyboard(device)
    common.wait_for_and_click(device, tr_Signin_dict, "sign_back")


def verify_signin_with_invalid_domain(device, user=None):
    invalid_domain = config["user"]["invalid_domain"]
    common.sleep_with_msg(device, 6, "verify_signin_with_invalid_domain")
    if common.is_element_present(device, sign_dict, "refresh_code_button"):
        common.wait_for_and_click(device, sign_dict, "refresh_code_button")
        common.sleep_with_msg(device, 5, "Allow refresh of DFC code")
    common.wait_for_element(device, sign_dict, "dfc_login_code")
    common.wait_for_and_click(device, sign_dict, "sign_in_on_the_device")
    common.wait_for_and_click(device, sign_dict, "Username")
    search_input = common.wait_for_element(device, sign_dict, "Username")
    search_input.send_keys(invalid_domain)
    print(f"{device} entered the invalid username '{invalid_domain}'")

    # Soft keyboard may be hiding the Sign-in button:
    if not common.click_if_present(device, sign_dict, "Sign_in_button"):
        common.hide_keyboard(device)
        common.wait_for_and_click(device, sign_dict, "Sign_in_button")

    common.sleep_with_msg(device, 7, "Allow sometime to see invalid error")
    error_text = common.wait_for_element(device, sign_dict, "invalid_domain_error").text
    error_text_list = [
        "Couldn’t connect to Workplace Join. Try again, or contact your admin.",
        "You’ll need to sign in with a work account.",
        "Please enter a valid sign-in address.",
    ]
    if error_text not in error_text_list:
        raise AssertionError(f"{device}: Couldn't find the invalid domain name error, got '{error_text}' instead")


def verify_signin_with_wrong_password(device, user=None):
    devices = common.device_type(device)
    if user is not None and user in "manufacture_block_user":
        username = config[devices][device]["manufacture_block_user"]["username"]
        wr_passwd = config[devices][device]["manufacture_block_user"]["password"]
    else:
        username = config[devices][device]["user"]["username"]
        wr_passwd = config["user"]["invalid_password"]
    common.sleep_with_msg(device, 6, "verify_signin_with_wrong_password")
    if common.is_element_present(device, sign_dict, "refresh_code_button"):
        common.wait_for_and_click(device, sign_dict, "refresh_code_button")
        common.sleep_with_msg(device, 5, "Allow refresh of DFC code")
    common.wait_for_element(device, sign_dict, "dfc_login_code")
    common.wait_for_and_click(device, sign_dict, "sign_in_on_the_device")
    common.wait_for_and_click(device, sign_dict, "Username")
    search_input = common.wait_for_element(device, sign_dict, "Username")
    search_input.send_keys(username)
    print("Entered username")

    # Soft keyboard may be hiding the Sign-in button:
    if not common.click_if_present(device, sign_dict, "Sign_in_button"):
        common.hide_keyboard(device)
        common.wait_for_and_click(device, sign_dict, "Sign_in_button")

    common.wait_for_element(device, sign_dict, "Password").send_keys(wr_passwd)
    print(f"{device}: entered the wrong password")
    time.sleep(display_time)

    if not common.click_if_present(device, sign_dict, "Sign_in"):
        common.wait_for_and_click(device, sign_dict, "signin_button")

    if user is not None and user in "manufacture_block_user":
        common.wait_for_element(device, tr_settings_dict, "manufacture_blocked_message", wait_attempts=50)
    else:
        common.wait_for_element(device, sign_dict, "invalid_password_error")


def navigate_to_manage_delegate_page(device):
    open_settings_page(device)
    open_manage_delegate_page(device)


def validate_view_permissions_option(from_device, to_device):
    to_device_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(settings_dict, "user_title", "user_name", to_device_displayname)
    common.wait_for_and_click(from_device, temp_dict, "user_title")
    select_permission(from_device, permission="View Permissions")
    validate_call_permissions(from_device)
    call_keywords.come_back_to_home_screen(from_device)


def validate_permissions_for_people_you_support(from_device, to_device):
    to_device_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(settings_dict, "user_title", "user_name", to_device_displayname)
    common.wait_for_and_click(from_device, temp_dict, "user_title")
    validate_call_permissions(from_device)
    common.return_to_home_screen(from_device)


def change_delegates_for_boss_and_verify(device, boss, delegate, action="verify"):
    if action.lower() not in ["verify", "delete"]:
        raise AssertionError(f"{device}: Illegal value for 'action': '{action}'")
    # Add delegate for boss from device
    boss_name = common.device_displayname(boss)
    temp_dict = common.get_dict_copy(calls_dict, "people_you_support_more_options", "user_name", boss_name)
    common.wait_for_and_click(device, temp_dict, "people_you_support_more_options")
    common.wait_for_and_click(device, calls_dict, "change_delegates")
    temp_dict = common.get_dict_copy(calls_dict, "delegate_addition_page_title", "user_name", boss_name)
    common.wait_for_element(device, temp_dict, "delegate_addition_page_title")
    if action.lower() != "delete":
        add_new_delegate(device, delegate)
    else:
        delegate_username = common.device_displayname(delegate)
        tmp_dict = common.get_dict_copy(settings_dict, "boss_delegates_list", "user_name", delegate_username)
        common.wait_for_and_click(device, tmp_dict, "boss_delegates_list")
        common.wait_for_and_click(device, settings_dict, "delete_delegates", "xpath")
        # wait for manage_delegate tab post deleting a delegate
        common.sleep_with_msg(device, 3, "Waiting for delegates list refresh")
        common.return_to_home_screen(device)
    # Verify added delegates from boss
    call_keywords.navigate_to_calls_favorites_page(boss)
    refresh_calls_main_tab(boss)
    delegate_list = common.get_all_elements_texts(boss, calls_dict, "your_delegates", "xpath1")
    delegate_name = common.device_displayname(delegate)
    if action.lower() != "delete":
        if delegate_name not in delegate_list:
            raise AssertionError(f"{boss}: Expected delegate: '{delegate_name}', but found: '{delegate_list}'")
        return
    if delegate_name in delegate_list:
        raise AssertionError(
            f"{device}: Deleted delegate: '{delegate_name}' was found in list of delegates: '{delegate_list}'"
        )


def change_call_settings_for_boss_and_verify(device, boss, call_setting, contact_point=None):
    if call_setting.lower() not in ["also_ring", "call_forward", "if_unanswered"]:
        raise AssertionError(f"{device}: Invalid argument for 'call_setting': '{call_setting}'")
    value_dict = {"voicemail": "Voicemail", "my_delegates": "My delegates"}

    del_user = device
    device, _ = common.decode_device_spec(device)

    # Change call settings of boss from device
    boss_name = common.device_displayname(boss)
    temp_dict = common.get_dict_copy(calls_dict, "people_you_support_more_options", "user_name", boss_name)
    common.wait_for_and_click(device, temp_dict, "people_you_support_more_options")
    common.wait_for_and_click(device, settings_dict, "change_call_settings_xpath")
    if call_setting.lower() == "also_ring":
        common.wait_for_and_click(device, settings_dict, "also_ring_btn")
        common.wait_for_and_click(device, settings_dict, "also_ring_delegate_btn")
        common.sleep_with_msg(device, 3, "Waiting for the contacts to load")
        username_list = common.get_all_elements_texts(device, calls_dict, "contact_list")
        delegate_name = common.device_displayname(del_user)
        if delegate_name not in username_list:
            raise AssertionError(f"{device}: Delegate expected: '{delegate_name}', but found: '{username_list}'")
    elif call_setting.lower() == "call_forward":
        if contact_point is None:
            raise AssertionError(
                f"{device}: Unexpected value for 'Contact_point' for call forwarding: '{contact_point}'"
            )
        if "device" not in contact_point and contact_point.lower() not in ["voicemail", "my_delegates", "off"]:
            raise AssertionError(f"{device}: Unexpected value for 'contact_point': '{contact_point}'")
        common.wait_for_element(device, settings_dict, "call_forwarding")
        if contact_point.lower() == "off":
            common.change_toggle_button(device, settings_dict, "Call_forward_toggle", "off")
            common.wait_for_element(device, settings_dict, "also_ring_btn")
        else:
            common.change_toggle_button(device, settings_dict, "Call_forward_toggle", "on")
            common.wait_for_and_click(device, settings_dict, "call_forward_to")
            if contact_point.lower() == "voicemail":
                common.wait_for_and_click(device, settings_dict, "voicemail_option")
            elif contact_point.lower() == "my_delegates":
                common.wait_for_and_click(device, settings_dict, "also_ring_delegate_btn")
            elif "device" in contact_point.lower():
                contact_name = common.device_displayname(contact_point)
                common.wait_for_and_click(device, settings_dict, "contact_option")
                common.click_if_present(device, settings_dict, "add_contact_option")
                common.wait_for_element(device, settings_dict, "search_contact_box")
                common.wait_for_element(device, settings_dict, "search_contact_box").send_keys(contact_name)
                time.sleep(display_time)
                common.hide_keyboard(device)
                tmp_dict = common.get_dict_copy(
                    calls_dict, "search_result_item_container", "config_display", contact_name
                )
                common.wait_for_and_click(device, tmp_dict, "search_result_item_container", "xpath")
    elif call_setting.lower() == "if_unanswered":
        common.wait_for_and_click(device, settings_dict, "unanswered_btn")
        common.wait_for_and_click(device, settings_dict, "voicemail_option")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")
    common.sleep_with_msg(device, 3, "React to back button click")
    common.click_if_present(device, calls_dict, "Call_Back_Button")

    # Validate call settings on boss
    open_settings_page(boss)
    common.wait_for_and_click(boss, settings_dict, "Calling")
    if call_setting.lower() == "also_ring":
        common.wait_for_element(boss, calls_dict, "also_ring_value")
    elif call_setting.lower() == "call_forward":
        if contact_point.lower() == "off":
            common.verify_toggle_button(boss, settings_dict, "Call_forward_toggle", "off")
        else:
            forward_to_value = common.wait_for_element(boss, calls_dict, "forward_to_value").text
            if "device" in contact_point.lower():
                if forward_to_value != "1":
                    raise AssertionError(f"{boss}: Couldn't find expected value for call forward: '{forward_to_value}'")
            elif forward_to_value != value_dict[contact_point]:
                raise AssertionError(f"{boss}: Couldn't find expected value for call forward: '{forward_to_value}'")
    elif call_setting.lower() == "if_unanswered":
        common.wait_for_element(boss, calls_dict, "unanswered_value")
    common.wait_for_and_click(boss, calls_dict, "Call_Back_Button")
    common.sleep_with_msg(device, 3, "React to back button click")
    common.click_if_present(device, calls_dict, "Call_Back_Button")


def select_permission(device, permission):
    if not permission.lower() in ["view permissions", "change delegates", "change call settings"]:
        raise AssertionError(f"Illegal permission specified: '{permission}'")
    common.wait_for_element(device, settings_dict, "view_permissions_xpath")
    common.wait_for_element(device, settings_dict, "change_delegates_xpath")
    common.wait_for_element(device, settings_dict, "change_call_settings_xpath")
    if permission.lower() == "view permissions":
        common.wait_for_and_click(device, settings_dict, "view_permissions_xpath")
    elif permission.lower() == "change delegates":
        common.wait_for_and_click(device, settings_dict, "change_delegates_xpath")
    elif permission.lower() == "change call settings":
        common.wait_for_and_click(device, settings_dict, "change_call_settings_xpath")


def validate_call_permissions(device):
    common.wait_for_element(device, settings_dict, "make_calls_xpath")
    common.wait_for_element(device, settings_dict, "receive_calls_xpath")
    common.wait_for_element(device, settings_dict, "change_call_xpath")
    common.wait_for_element(device, settings_dict, "join_active_calls")
    common.wait_for_element(device, settings_dict, "pick_up_held_calls")
    common.wait_for_element(device, settings_dict, "save_permissions")
    common.wait_for_element(device, common_dict, "back")


def validate_change_call_settings_option_and_validate_also_ring(from_device, to_device):
    to_device_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(settings_dict, "user_title", "user_name", to_device_displayname)
    common.wait_for_and_click(from_device, temp_dict, "user_title")
    select_permission(from_device, permission="Change call settings")
    common.wait_for_and_click(from_device, settings_dict, "also_ring_btn")
    common.wait_for_element(from_device, settings_dict, "also_ring_off_btn")
    common.wait_for_element(from_device, settings_dict, "contact_option")
    common.wait_for_element(from_device, settings_dict, "also_ring_delegate_btn")


def select_change_call_settings_permission(device):
    common.wait_for_and_click(device, calls_dict, "favorites_more_options")
    select_permission(device, permission="Change call settings")


def validate_if_unanswered_in_people_you_support_page(from_device, to_device):
    to_device_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(settings_dict, "user_title", "user_name", to_device_displayname)
    common.wait_for_and_click(from_device, temp_dict, "user_title")
    select_permission(from_device, permission="Change call settings")
    common.wait_for_and_click(from_device, settings_dict, "unanswered_btn")
    common.wait_for_element(from_device, settings_dict, "unanswerd_off")
    common.wait_for_element(from_device, settings_dict, "voicemail_option")
    common.wait_for_element(from_device, settings_dict, "contact_option")
    common.wait_for_element(from_device, settings_dict, "also_ring_call_group_btn")
    common.wait_for_element(from_device, settings_dict, "also_ring_delegate_btn")


def verify_user_presence_from_other_user(from_device, to_device, state):
    if state.lower() not in ["in call", "available", "busy", "dnd", "be right back", "offline", "away"]:
        raise AssertionError(f"Unexpected value for option : {state}")
    print(f"Arguments: {from_device}, {to_device}, {state}")
    to_device, account = common.decode_device_spec(to_device)
    to_device_displayname = config["devices"][to_device][account]["displayname"]
    to_device_username = config["devices"][to_device][account]["username"].split("@")[0]
    common.return_to_home_screen(from_device)
    people_keywords.click_on_people_tab(from_device)
    if common.is_lcp(from_device):
        common.wait_for_and_click(from_device, calls_dict, "search_icon")
    else:
        common.wait_for_and_click(from_device, calls_dict, "search")
    element = common.wait_for_element(from_device, calls_dict, "search_text")
    element.send_keys(to_device_username)
    time.sleep(display_time)
    common.hide_keyboard(from_device)
    search_result_xpath = common.get_dict_copy(
        calls_dict, "search_result_item_container", "config_display", to_device_displayname
    )
    if common.is_lcp(from_device):
        common.wait_for_element(from_device, search_result_xpath, "search_result_item_container", "xpath")
    else:
        common.wait_for_and_click(from_device, search_result_xpath, "search_result_item_container", "xpath")
    if state.lower() == "in call":
        presence_xpath = common.get_dict_copy(
            settings_dict, "in_call_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "in_call_presence_xpath", wait_attempts=180)
    elif state.lower() == "available":
        presence_xpath = common.get_dict_copy(
            settings_dict, "available_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "available_presence_xpath", wait_attempts=180)
    elif state.lower() == "busy":
        presence_xpath = common.get_dict_copy(settings_dict, "busy_presence_xpath", "username", to_device_displayname)
        common.wait_for_element(from_device, presence_xpath, "busy_presence_xpath")
    elif state.lower() == "dnd":
        presence_xpath = common.get_dict_copy(settings_dict, "dnd_presence_xpath", "username", to_device_displayname)
        common.wait_for_element(from_device, presence_xpath, "dnd_presence_xpath", wait_attempts=180)
    elif state.lower() == "be right back":
        presence_xpath = common.get_dict_copy(
            settings_dict, "be_right_back_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "be_right_back_presence_xpath")
    elif state.lower() == "offline":
        presence_xpath = common.get_dict_copy(
            settings_dict, "offline_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "offline_presence_xpath", wait_attempts=180)
    elif state.lower() == "away":
        presence_xpath = common.get_dict_copy(settings_dict, "away_presence_xpath", "username", to_device_displayname)
        common.wait_for_element(from_device, presence_xpath, "away_presence_xpath")
    common.return_to_home_screen(from_device)


def traverse_to_settings_notification(device):
    # Click if home screen is not enabled on device or the home screen is enabled, but user is on different tab
    if not common.click_if_present(device, navigation_dict, "Navigation"):
        # If the home screen is already enabled on the device, user's profile picture will be visible
        common.wait_for_and_click(device, calls_dict, "user_profile_picture")
    common.wait_for_and_click(device, navigation_dict, "Settings_button")
    time.sleep(action_time)


def disable_call_forwarding_and_verify(device):
    print(f"disable_call_forwarding_and_verify('{device}')")
    open_settings_page(device)
    disable_call_forwarding(device)
    call_keywords.come_back_to_home_screen(device, disconnect=False)


def verify_and_change_call_settings(device):
    open_settings_page(device)
    set_call_forwarding(device, "OFF")
    verify_and_change_busy_on_busy_settings(device)
    common.click_if_present(device, calls_dict, "Call_Back_Button")
    device_setting_back(device)
    common.click_if_present(device, device_settings_dict, "admin_settings_yes")
    device_setting_back(device)
    common.click_if_present(device, calls_dict, "Call_Back_Button")


def verify_and_change_busy_on_busy_settings(device):
    common.sleep_with_msg(device, 5, "Waiting for 'calling' page to load")
    if not common.is_element_present(device, calls_dict, "when_in_another_call"):
        print(f"{device} doesn't have 'when in another call' option under 'calling' tab")
        return
    common.wait_for_element(device, calls_dict, "when_in_another_call")
    if not common.is_element_present(device, calls_dict, "new_calls_ring_me"):
        common.wait_for_and_click(device, calls_dict, "when_in_another_call")
        common.wait_for_and_click(device, calls_dict, "new_calls_ring_me")
    common.wait_for_and_click(device, common_dict, "back")
    common.wait_for_element(device, settings_dict, "Calling")


def navigate_back_once(device):
    print("device :", device)
    subprocess.call(
        "adb -s {} shell input keyevent 4".format(config["devices"][device]["desired_caps"]["udid"].split(":")[0]),
        shell=True,
    )
    pass


if __name__ == "__main__":
    #
    # Standalone testing of methods in this file.
    # (may require changes to "PYTHONPATH")
    #

    # Enable workarounds:
    StandaloneTesting = True

    # Run some tests
    try:
        get_screenshot("one_device", "device1")
        get_screenshot("defaults")
        get_screenshot("noXML", with_xml=False)
        get_screenshot({"xx": "bb"})
        get_screenshot(None)
        get_screenshot("badList", device_list={"xx": "bb"})
        get_screenshot("badBool", with_xml="XFalse")
        print("All good, no exceptions from 'get_screenshot()'")
    except Exception as e:
        print(f"ERROR! Unexpected Exception: {e}")


def verify_presence_feature(device):
    print("device :", device)
    if common.is_portrait_mode_cnf_device(device):
        status = "fail"
    else:
        status = "pass"
    return status


def verify_appearance_button_for_conference_devices(device):
    if common.is_portrait_mode_cnf_device(device):
        print(f"Feature not applicable: Skipping verifications on portrait mode devices")
        return
    common.wait_for_and_click(device, settings_dict, "Appearance_btn")
    common.wait_for_element(device, settings_dict, "dark_theme")


def verify_options_under_settings_for_cnf_device(device):
    print("device :", device)
    common.wait_for_element(device, settings_dict, "profile_btn")
    common.wait_for_element(device, settings_dict, "auto_restart")
    common.wait_for_element(device, settings_dict, "send_feedback")
    common.wait_for_element(device, settings_dict, "about_btn")
    common.wait_for_element(device, settings_dict, "Device_Settings")


def verify_appearance_option(device):
    print("device :", device)
    if common.is_portrait_mode_cnf_device(device):
        status = "fail"
    else:
        status = "pass"
    return status


def verify_cancel_button_and_validate_not_to_enable_advance_calling(device):
    open_settings_page(device)
    _max_attempts = 3
    for _attempt in range(_max_attempts):
        if common.is_element_present(device, settings_dict, "Device_Settings"):
            common.wait_for_and_click(device, settings_dict, "Device_Settings")
            break
        else:
            swipe_till_end(device)
    device_settings_keywords.advance_calling_option_oem(device)
    common.wait_for_and_click(device, settings_dict, "adv_call_toggle_btn")
    print(f"{device}: Clicked on Advance calling toggle button")
    common.wait_for_element(device, settings_dict, "adv_call_restart_btn")
    common.wait_for_and_click(device, settings_dict, "adv_call_cancel_btn")
    print(
        f"{device} : Acknowledge window is displayed stating You'll need to restart the app to apply changes with Cancel and Restart button"
    )
    common.wait_for_element(device, settings_dict, "adv_call_toggle_btn")
    device_setting_back(device)
    device_setting_back(device)
    time.sleep(action_time)
    common.click_if_present(device, device_settings_dict, "admin_settings_yes")
    device_setting_back(device)
    common.click_if_present(device, calls_dict, "Call_Back_Button")
    time.sleep(display_time)
    if not common.is_element_present(device, home_screen_dict, "call_tab"):
        common.wait_for_element(device, calls_dict, "dialpad_tab")


def verify_cap_premium_calling_setting_options(device):
    open_settings_page(device)
    swipe_till_end(device)
    swipe_till_end(device)
    common.wait_for_and_click(device, settings_dict, "Device_Settings")
    device_settings_keywords.advance_calling_option_oem(device)
    common.wait_for_element(device, settings_dict, "call_forwarding")
    common.wait_for_element(device, settings_dict, "also_ring")
    device_setting_back(device)
    device_setting_back(device)
    device_setting_back(device)


def verify_and_enable_advance_calling_option(device):
    print(f"device : {device}")
    if common.is_lcp(device):
        for i in range(10):
            if common.is_element_present(device, lcp_homescreen_dict, "homescreen_menu"):
                break
            common.sleep_with_msg(device, 1, "Waiting for sign-in to complete")
    set_advance_calling(device, "ON")
    time.sleep(3)
    common.wait_for_element(device, home_screen_dict, "people_tab")
    disable_call_forwarding_and_verify(device)


def disable_advance_calling_option(device):
    set_advance_calling(device, "OFF")


def set_advance_calling(device, status):
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    print(f"device : {device}")
    open_settings_page(device)
    _max_attempts = 5
    for _attempt in range(_max_attempts):
        if common.is_element_present(device, settings_dict, "Device_Settings"):
            common.wait_for_and_click(device, settings_dict, "Device_Settings")
            break
        else:
            swipe_till_end(device)
    device_settings_keywords.advance_calling_option_oem(device)
    adv_call_toggle_button = common.wait_for_element(device, settings_dict, "adv_call_toggle_btn")
    adv_call_toggle_status = adv_call_toggle_button.get_attribute("checked")
    print(f"{device}: Advance calling option status currently: '{adv_call_toggle_status}'")
    if status == "ON":
        state = "true"
    elif status == "OFF":
        state = "false"
    if adv_call_toggle_status == state:
        print(f"{device}: Advance calling Option status is already: {adv_call_toggle_status}")
    else:
        adv_call_toggle_button.click()
        print(f"{device}: Clicked on Advance calling option toggle button")
        common.wait_for_element(device, settings_dict, "adv_call_cancel_btn")
        common.wait_for_and_click(device, settings_dict, "adv_call_restart_btn")
        print(f"{device}: Clicked on Restart button")
    common.sleep_with_msg(device, 10, "set_advance_calling")
    if common.is_lcp(device):
        print(f"{device}: already in home screen")
    else:
        call_keywords.come_back_to_home_screen(device)
    time.sleep(display_time)
    if not (
        common.is_element_present(device, home_screen_dict, "call_tab")
        or common.is_element_present(device, lcp_homescreen_dict, "forward_screen_menu")
    ):
        common.wait_for_element(device, calls_dict, "dialpad_tab")


def verify_advance_calling_toggle_status_for_cap(device, toggle):
    if not common.click_if_element_appears(device, settings_dict, "hotline_settings_btn", max_attempts=5):
        open_settings_page(device)
        swipe_till_end(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, settings_dict, "Device_Settings")
    device_settings_keywords.advance_calling_option_oem(device)
    common.verify_toggle_button(device, settings_dict, "adv_call_toggle_btn", desired_state=toggle)
    call_keywords.come_back_to_home_screen(device)


def change_delegate_of_delegate_user(from_device, to_device, add_device):
    navigate_to_manage_delegate_page(from_device)
    common.return_to_home_screen(from_device)
    call_keywords.navigate_to_calls_favorites_page(from_device)
    common.wait_for_element(from_device, calls_dict, "contacts_grid")
    delegate_username = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", delegate_username)
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_and_click(from_device, settings_dict, "change_delegates_xpath")
    add_delegate_displayname = common.device_displayname(add_device)
    common.wait_for_element(from_device, settings_dict, "add_delegates").send_keys(add_delegate_displayname)
    subprocess.call(
        "adb -s {} shell input keyevent 66".format(
            config["devices"][from_device]["desired_caps"]["udid"].split(":")[0]
        ),
        shell=True,
    )
    subprocess.call(
        "adb -s {} shell input keyevent 67".format(
            config["devices"][from_device]["desired_caps"]["udid"].split(":")[0]
        ),
        shell=True,
    )
    common.wait_for_and_click(from_device, calls_dict, "search_result_name")
    common.wait_for_and_click(from_device, settings_dict, "change_call_and_delegate_setting_toggle_off")
    if common.is_element_present(from_device, settings_dict, "change_call_and_delegate_setting_toggle_off"):
        raise AssertionError(f"{from_device} permission toggle not changed")
    common.wait_for_and_click(from_device, settings_dict, "save_permissions")
    time.sleep(sleep_time)
    users = common.get_all_elements_texts(from_device, settings_dict, "user_title")
    if add_delegate_displayname not in users:
        raise AssertionError(f"{to_device} is not added in delegate user")
    click_back(from_device)


def verify_auto_restart_option_inside_settings_page(device):
    _max_attempts = 3
    for i in range(_max_attempts):
        if common.is_element_present(device, settings_dict, "auto_restart"):
            break
        calendar_keywords.scroll_only_once(device)
        time.sleep(3)
    common.wait_for_element(device, settings_dict, "auto_restart")


def verify_app_restart_toggle(device, toggle):
    if toggle.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'toggle': '{toggle}'")
    common.wait_for_and_click(device, settings_dict, "auto_restart")
    common.wait_for_element(device, settings_dict, "app_restart")
    common.verify_toggle_button(device, settings_dict, "app_restart_toggle_btn", toggle)


def click_on_toggle_btn(device, status):
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    common.wait_for_and_click(device, settings_dict, "auto_restart")
    common.wait_for_element(device, settings_dict, "app_restart")
    common.change_toggle_button(device, settings_dict, "app_restart_toggle_btn", status)
    common.verify_toggle_button(device, settings_dict, "app_restart_toggle_btn", status)


def verify_options_after_enabling_auto_restart_toggle_btn(device):
    common.wait_for_element(device, settings_dict, "automatically_toggle_btn")


def verify_options_after_disabling_automatically_toggle_btn(device):
    common.wait_for_element(device, settings_dict, "daily")


def enable_disable_automatically_toggle_btn_inside_app_restart(device, status="off"):
    # common.wait_for_and_click(device, settings_dict, "automatically_toggle_btn")
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    common.change_toggle_button(device, settings_dict, "automatically_toggle_btn", status)
    common.verify_toggle_button(device, settings_dict, "automatically_toggle_btn", status)


def verify_auto_app_restart_time_set(device, hours, minutes, period):
    time = common.wait_for_element(device, settings_dict, "auto_restart_daily_time_picker").text
    time_match = re.search(r"(\d+):(\d+)\s*(AM|PM)?", time)
    if time_match:
        set_hours = int(time_match.group(1))
        set_minutes = int(time_match.group(2))
        set_period = time_match.group(3)
    print(f"Current time {hours}:{minutes} {period}")
    if set_hours == hours and set_minutes == minutes and set_period == period:
        print(f"{device}: auto app restart time matched")
    else:
        raise AssertionError(f"{device}: auto app restart time did not matched")


def set_timer_for_app_restart(device, time_=2):
    time = common.wait_for_element(device, tr_calendar_dict, "current_time").text
    time_match = re.search(r"(\d+):(\d+)\s*(AM|PM)?", time)
    if time_match:
        hours = int(time_match.group(1))
        minutes = int(time_match.group(2))
        period = time_match.group(3)
    print(f"Current time {hours}:{minutes} {period}")
    common.click_if_present(device, settings_dict, "daily")
    common.wait_for_and_click(device, settings_dict, "swith_to_text_input_to_set_timer")
    common.wait_for_element(device, settings_dict, "set_time")
    minutes += time_
    if period:
        if minutes >= 60:
            hours += 1
            minutes %= 60
        if hours > 12:
            hours %= 12
            period = "PM" if period == "AM" else "AM"
    else:
        if minutes >= 60:
            hours += 1
            minutes %= 60
        if hours > 24:
            hours %= 24
    print(f"Set time {hours}:{minutes} {period}")
    hour_input = common.wait_for_element(device, tr_calendar_dict, "hour_text_box")
    hour_input.clear()
    hour_input.send_keys(hours)
    min_input = common.wait_for_element(device, tr_calendar_dict, "min_text_box")
    min_input.clear()
    min_input.send_keys(minutes)
    if period:
        common.wait_for_and_click(device, calendar_dict, "timezone_dropdown")
        if period == "PM":
            common.wait_for_and_click(device, settings_dict, "pm")
        elif period == "AM":
            common.wait_for_and_click(device, settings_dict, "am")
        else:
            raise AssertionError(f"Wrong period format {period}")
    common.wait_for_and_click(device, settings_dict, "Sign_out_ok")
    if common.wait_for_element(device, settings_dict, "app_restart"):
        verify_auto_app_restart_time_set(device, hours, minutes, period)
        print(f"device 1:{device} timer is set successfully to time {hours}:{minutes} {period}")


def verify_app_restarting_at_set_time(device):
    verify_app_restarting_notification(device)
    time.sleep(sleep_time1)
    verify_app_restarting_pop_up(device)


def verify_app_restarting_notification(device, status="present"):
    if status.lower() not in ["present", "absent"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    if status == "present":
        common.wait_for_element(device, settings_dict, "restarting_notification", wait_attempts=90)
    elif status == "absent":
        common.raise_if_present(device, settings_dict, "restarting_notification", max_wait_attempts=90)


def verify_app_restarting_pop_up(device):
    common.wait_for_element(device, settings_dict, "restarting_app", wait_attempts=90)
    print(f"device :{device} App restarted successfully")


def navigate_to_auto_app_restart(device):
    open_settings_page(device)
    verify_auto_restart_option_inside_settings_page(device)
    common.wait_for_and_click(device, settings_dict, "auto_restart")
    common.wait_for_element(device, settings_dict, "app_restart")


def verify_conf_room_UI_feature(device):
    print("device :", device)
    if common.is_portrait_mode_cnf_device(device):
        status = "pass"
    else:
        status = "fail"
    return status


def verify_delegate_permission_option_in_manage_delegates(device, to_device):
    delegate_displayname = common.device_displayname(to_device)
    to_device, _ = common.decode_device_spec(to_device)
    time.sleep(3)
    users = common.get_all_elements_texts(device, settings_dict, "user_title")
    if delegate_displayname not in users:
        raise AssertionError(
            f"{device}: Expected delegate user: '{delegate_displayname}' is not in list of delegate users: {users}"
        )
    search_result_xpath = common.get_dict_copy(
        calls_dict,
        "search_result_item_container",
        "config_display",
        delegate_displayname,
    )
    common.wait_for_and_click(device, search_result_xpath, "search_result_item_container", "xpath")
    common.click_if_present(device, settings_dict, "view_permissions_xpath")
    time.sleep(display_time)
    delegate_permissions_list = [
        "Make calls",
        "Receive calls",
        "Change call and delegate settings",
        "Join active calls",
        "Pick up held calls",
        "Remove delegate",
    ]
    permissions_title_list = common.get_all_elements_texts(device, settings_dict, "delete_delegates")
    permission_toggle_list = common.wait_for_element(
        device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )
    if permissions_title_list != delegate_permissions_list:
        raise AssertionError(
            f"{device}: Not all permissions are displayed: '{permissions_title_list}' for the user: {delegate_displayname}. Expected permissions: '{delegate_permissions_list}'"
        )
    for permission_toggle in permission_toggle_list:
        if permission_toggle.get_attribute("checked") != "true":
            raise AssertionError(
                f"{device}: Permission toggle is not enabled for all permissions: '{permission_toggle_list}'"
            )
    click_back(device)
    common.wait_for_element(device, settings_dict, "user_title")


def disable_option_in_delegates_permission(device, to_device, option):
    if option not in [
        "Make_calls",
        "Receive_calls",
        "Change_call_and_delegate_settings",
        "Join_active_calls",
        "Pick_up_held_calls",
    ]:
        raise AssertionError(f"Illegal value for status: {option}")
    option1 = option.replace("_", " ")
    delegate_displayname = common.device_displayname(to_device)
    search_result_xpath = common.get_dict_copy(
        calls_dict, "search_result_item_container", "config_display", delegate_displayname
    )
    common.wait_for_and_click(device, search_result_xpath, "search_result_item_container", "xpath")
    delegate_options = option1
    title = common.get_all_elements_texts(device, settings_dict, "delete_delegates")
    toggle_switch = common.wait_for_element(
        device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )
    for name, toggle in zip(title, toggle_switch):
        if name == delegate_options:
            print(name, delegate_options)
            toggle_status1 = toggle.get_attribute("checked")
            print(f"{device}: Toggle for {delegate_options} current state is: {toggle_status1}")
            if toggle_status1 != "false":
                toggle.click()
                toggle_status2 = toggle.get_attribute("checked")
                print(f"{device}: Toggle for {delegate_options} current sate after clicking is: {toggle_status2}")
                if toggle_status2 != "false":
                    raise AssertionError(
                        f"{device}: Toggle for {delegate_options} is not clicked old state:{toggle_status1}, current state:{toggle_status2}"
                    )
            time.sleep(display_time)
    common.wait_for_and_click(device, settings_dict, "save_delegate_permissions")
    common.wait_for_element(device, settings_dict, "user_title")
    users = common.get_all_elements_texts(device, settings_dict, "user_title")
    if delegate_displayname not in users:
        raise AssertionError(f"{to_device} is not added in delegate user")


def verify_search_results_for_delegates_at_manage_delegates_screen(device, to_device):
    delegate_displayname = common.device_displayname(to_device)
    common.kb_trigger_search(device, settings_dict, "add_delegates", delegate_displayname)
    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", delegate_displayname)
    common.wait_for_element(device, tmp_dict, "search_result_item_container", "xpath")
    click_back(device)


def verify_people_you_support_more_option_at_favorites_page(from_device, to_device):
    time.sleep(display_time)
    if not common.is_element_present(from_device, calls_dict, "people_you_support"):
        call_keywords.navigate_to_calls_favorites_page(from_device)
        refresh_calls_main_tab(from_device)
        common.wait_for_element(from_device, calls_dict, "people_you_support")
    boss_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", boss_displayname)
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_element(from_device, calls_dict, "view_Permissions")
    common.wait_for_element(from_device, calls_dict, "view_shared_line")
    common.wait_for_element(from_device, calls_dict, "change_delegates")
    common.wait_for_element(from_device, settings_dict, "change_call_settings_xpath")
    call_keywords.dismiss_call_more_options(from_device)


def verify_existing_delegates_and_delegators_in_manage_delegates(device, people_you_support, your_delegates):
    your_delegate_displayname = common.device_displayname(your_delegates)
    people_you_support_displayname = common.device_displayname(people_you_support)
    common.wait_for_element(device, calls_dict, "your_delegates")
    common.wait_for_element(device, calls_dict, "people_you_support")
    ele = common.get_all_elements_texts(device, calls_dict, "user_title")
    if your_delegate_displayname not in ele:
        raise AssertionError(f"{device}: Couldn't find {your_delegate_displayname} in {ele}")
    if people_you_support_displayname not in ele:
        raise AssertionError(f"{device}: Couldn't find {people_you_support_displayname} in {ele}")


def enable_permission_for_delegates(device, to_device):
    navigate_to_manage_delegate_page(device)
    delegate_displayname = common.device_displayname(to_device)
    search_result_xpath = common.get_dict_copy(
        calls_dict, "search_result_item_container", "config_display", delegate_displayname
    )
    common.wait_for_and_click(device, search_result_xpath, "search_result_item_container")
    while common.is_element_present(device, settings_dict, "change_call_and_delegate_setting_toggle_off"):
        common.wait_for_and_click(device, settings_dict, "change_call_and_delegate_setting_toggle_off")
    common.wait_while_present(device, settings_dict, "change_call_and_delegate_setting_toggle_off")
    common.return_to_home_screen(device)


def disable_lightweight_meeting_experience(device):
    if not common.is_element_present(device, settings_dict, "Enable_lightweight_meeting_experience"):
        common.return_to_home_screen(device)
        calendar_keywords.verify_meetings_option_under_app_settings_page(device)
    calendar_keywords.enable_or_disable_lightweight_meeting_experience(device, "OFF")


def enable_lightweight_meeting_experience(device):
    if not common.is_element_present(device, settings_dict, "Enable_lightweight_meeting_experience"):
        common.return_to_home_screen(device)
        calendar_keywords.verify_meetings_option_under_app_settings_page(device)
    calendar_keywords.enable_or_disable_lightweight_meeting_experience(device, "ON")


def verify_lightweight_meeting_experience_in_meeting_option(device):
    if not common.is_element_present(device, settings_dict, "Enable_lightweight_meeting_experience"):
        call_keywords.come_back_to_home_screen(device)
        calendar_keywords.verify_meetings_option_under_app_settings_page(device)
    common.wait_for_element(device, settings_dict, "Enable_lightweight_meeting_experience")
    lightweight_meeting_experience_toggle = common.wait_for_element(
        device, settings_dict, "Enable_lightweight_meeting_experience_toggle_btn"
    )
    lightweight_meeting_experience_toggle_status = lightweight_meeting_experience_toggle.get_attribute("checked")
    if lightweight_meeting_experience_toggle_status != "true":
        raise AssertionError(
            f"light weight meeting toggle have been disabled :{lightweight_meeting_experience_toggle_status}"
        )


def verify_device_display_type(device):
    print("device :", device)
    if common.is_portrait_mode_cnf_device(device):
        display_type = "portrait"
    else:
        display_type = "landscape"
    return display_type


def verify_join_call_option_should_not_present_inside_the_more_icon_of_boss(from_device, to_device):
    refresh_calls_main_tab(from_device)
    common.wait_for_element(from_device, calls_dict, "people_you_support")
    boss_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", boss_displayname)
    common.wait_while_present(
        from_device, settings_dict, "join_call_option_inside_the_more_icon_of_boss", max_wait_attempts=3
    )
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_element(from_device, calls_dict, "view_Permissions")
    common.wait_while_present(
        from_device, settings_dict, "join_call_option_inside_the_more_icon_of_boss", max_wait_attempts=3
    )
    common.wait_for_and_click(from_device, calendar_dict, "touch_outside")


def verify_join_call_option_should_not_present_in_call_favorites_page(from_device, to_device):
    time.sleep(display_time)
    common.click_if_present(from_device, home_screen_dict, "home_bar_icon")
    common.click_if_present(from_device, calls_dict, "Call_Back_Button")
    if not common.is_element_present(from_device, calls_dict, "people_you_support"):
        call_keywords.navigate_to_calls_favorites_page(from_device)
        refresh_calls_main_tab(from_device)
    user_displayname = common.device_displayname(to_device)
    boss = common.get_all_elements_texts(from_device, settings_dict, "contact_display_name")
    if user_displayname not in boss:
        raise AssertionError(f"{from_device} is not found {to_device} name:{boss}")
    active_call_duration = (
        common.wait_for_element(from_device, calls_dict, "ongoing_active_call_duration").text
    ).split(":")
    if active_call_duration[0] != "Active call":
        raise AssertionError(f"{from_device}: Calls are not on Active")
    time.sleep(display_time)
    if common.is_element_present(from_device, settings_dict, "join_call_option_of_boss"):
        raise AssertionError(f"{from_device} Join Call option is Present.")


def verify_resume_call_option_should_not_present_in_call_favorites_page(from_device, to_device):
    time.sleep(display_time)
    common.click_if_present(from_device, home_screen_dict, "home_bar_icon")
    common.click_if_present(from_device, calls_dict, "Call_Back_Button")
    if not common.is_element_present(from_device, calls_dict, "people_you_support"):
        call_keywords.navigate_to_calls_favorites_page(from_device)
        refresh_calls_main_tab(from_device)
    user_displayname = common.device_displayname(to_device)
    boss = common.get_all_elements_texts(from_device, settings_dict, "contact_display_name")
    if user_displayname not in boss:
        raise AssertionError(f"{from_device} is not found {to_device} name:{boss}")
    active_call_duration = (
        common.wait_for_element(from_device, calls_dict, "ongoing_active_call_duration").text
    ).split(":")
    if active_call_duration[0] != "On hold":
        raise AssertionError(f"{from_device}: Calls are not on Hold")
    time.sleep(display_time)
    if common.is_element_present(from_device, settings_dict, "resume_call_in_more_option_with_boss"):
        raise AssertionError(f"{from_device} Resume Call option is Present.")


def enable_option_in_delegates_permission(device, to_device, option):
    if option not in [
        "Make_calls",
        "Receive_calls",
        "Change_call_and_delegate_settings",
        "Join_active_calls",
        "Pick_up_held_calls",
    ]:
        raise AssertionError(f"Illegal value for status: {option}")
    option1 = option.replace("_", " ")
    navigate_to_manage_delegate_page(device)
    delegate_displayname = common.device_displayname(to_device)
    search_result_xpath = common.get_dict_copy(
        calls_dict, "search_result_item_container", "config_display", delegate_displayname
    )
    common.wait_for_and_click(device, search_result_xpath, "search_result_item_container", "xpath")
    time.sleep(action_time)
    title = common.get_all_elements_texts(device, settings_dict, "delete_delegates")
    delegate_options = option1
    toggle_switch = common.wait_for_element(
        device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )
    for name, toggle in zip(title, toggle_switch):
        if name == delegate_options:
            print(name, delegate_options)
            toggle_status1 = toggle.get_attribute("checked")
            print(f"{device}: Toggle for {delegate_options} current state is: {toggle_status1}")
            if toggle_status1 != "true":
                toggle.click()
                toggle_status2 = toggle.get_attribute("checked")
                print(f"{device}: Toggle for {delegate_options} current sate after clicking is: {toggle_status2}")
                if toggle_status2 != "true":
                    raise AssertionError(
                        f"{device}: Toggle for {delegate_options} is not clicked old state:{toggle_status1},current state:{toggle_status2}"
                    )
            time.sleep(display_time)
    common.wait_for_and_click(device, settings_dict, "save_delegate_permissions")
    common.wait_for_element(device, settings_dict, "user_title")
    users = common.get_all_elements_texts(device, settings_dict, "user_title")
    if delegate_displayname not in users:
        raise AssertionError(f"{to_device} is not added in delegate user")


def verify_and_join_call_using_join_button_with_boss(from_device, to_device, option="join_call"):
    if option.lower() not in ["verify", "join_call"]:
        raise AssertionError(f"Illegal value for 'option': '{option}'")
    refresh_calls_main_tab(from_device)
    common.sleep_with_msg(from_device, 3, "Waiting for page to load")
    if not common.is_element_present(from_device, calls_dict, "your_delegates"):
        common.wait_for_element(from_device, calls_dict, "people_you_support")
    user_displayname = common.device_displayname(to_device)
    boss = common.get_all_elements_texts(from_device, settings_dict, "contact_display_name")
    if user_displayname not in boss:
        raise AssertionError(f"{from_device} is not found {to_device} name:{boss}")
    active_call_duration = (
        common.wait_for_element(from_device, calls_dict, "ongoing_active_call_duration").text
    ).split(":")
    if active_call_duration[0] != "Active call":
        raise AssertionError(f"{from_device} active call duration: '{option}'")
    if option == "join_call":
        common.wait_for_and_click(from_device, settings_dict, "join_call_option_of_boss")
        common.wait_for_element(from_device, calls_dict, "Hang_up_button")
    elif option == "verify":
        common.wait_for_element(from_device, settings_dict, "join_call_option_of_boss")


def verify_and_resume_call_using_resume_call_in_more_option_with_boss_or_delegate(
    from_device, to_device, option="join_call", shared_line="disabled", role="boss"
):
    if option.lower() not in ["verify", "join_call"]:
        raise AssertionError(f"Illegal value for 'option': '{option}'")
    if role.lower() not in ["boss", "delegate"]:
        raise AssertionError(f"Illegal value for 'role': '{role}'")
    refresh_calls_main_tab(from_device)
    if role.lower() == "delegate":
        common.wait_for_element(from_device, calls_dict, "your_delegates")
    else:
        common.wait_for_element(from_device, calls_dict, "people_you_support")
    boss_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", boss_displayname)
    common.wait_for_element(from_device, calls_dict, "Resume")
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_element(from_device, calls_dict, "view_Permissions")
    common.wait_for_element(from_device, calls_dict, "call_list_item_call_action")
    common.wait_for_element(from_device, calls_dict, "call_list_view_profile_action")
    common.wait_for_element(from_device, calls_dict, "call_list_leave_voicemail")
    if shared_line.lower() == "enabled":
        common.wait_for_element(from_device, calls_dict, "view_shared_line")
    if option == "join_call":
        common.wait_for_and_click(from_device, settings_dict, "resume_call_in_more_option_with_boss")
        common.wait_for_element(from_device, calls_dict, "Hang_up_button")
    elif option == "verify":
        common.wait_for_element(from_device, settings_dict, "resume_call_in_more_option_with_boss")
        call_keywords.dismiss_call_more_options(from_device)


def verify_and_join_call_using_join_call_in_more_option_with_boss_and_delegate(
    from_device, to_device, option="join_call", shared_line="disabled"
):
    if option.lower() not in ["verify", "join_call", "call"]:
        raise AssertionError(f"Illegal value for 'option': '{option}'")
    refresh_calls_main_tab(from_device)
    boss_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", boss_displayname)
    active_call_duration = common.wait_for_element(from_device, calls_dict, "ongoing_active_call_duration").text.split(
        ":"
    )
    if active_call_duration[0] != "Active call":
        raise AssertionError(f"{from_device}: There are no active calls on device: {active_call_duration[0]}")
    common.wait_for_element(from_device, settings_dict, "join_call_option_of_boss")
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_element(from_device, calls_dict, "view_Permissions")
    common.wait_for_element(from_device, calls_dict, "call_list_item_call_action")
    common.wait_for_element(from_device, calls_dict, "call_list_view_profile_action")
    common.wait_for_element(from_device, calls_dict, "call_list_leave_voicemail")
    if shared_line.lower() == "enabled":
        common.wait_for_element(from_device, calls_dict, "view_shared_line")
    if option == "join_call":
        common.wait_for_and_click(from_device, settings_dict, "join_call_option_of_boss")
        common.wait_for_element(from_device, calls_dict, "Hang_up_button")
    elif option == "verify":
        common.wait_for_element(from_device, settings_dict, "join_call_option_of_boss")
        call_keywords.dismiss_call_more_options(from_device)
    elif option == "call":
        common.wait_for_and_click(from_device, settings_dict, "call_option_inside_the_more_icon_of_boss")
        common.wait_for_element(from_device, calls_dict, "Hang_up_button")


def verify_hotline_option(device):
    print("device :", device)
    open_settings_page(device)
    swipe_till_end(device)
    swipe_till_end(device)
    common.wait_for_and_click(device, settings_dict, "Device_Settings")
    device_settings_keywords.advance_calling_option_oem(device)
    common.wait_for_element(device, calls_dict, "hotline")


def verify_hotline_option_is_disabled_by_default(device):
    common.wait_for_element(device, calls_dict, "hotline")
    hotline_text = common.wait_for_element(device, settings_dict, "hotline_status_text").text
    if hotline_text != "Disabled":
        raise AssertionError("Hotline Toggle is not disabled")


def configure_contact_number_in_hotline(device, configured_user):
    print("device :", device)
    display_name = common.device_displayname(configured_user)
    user_phone_number = common.device_phonenumber(configured_user)
    common.wait_for_and_click(device, calls_dict, "hotline")
    time.sleep(display_time)
    if not common.click_if_present(device, calls_dict, "add_contact"):
        common.wait_for_and_click(device, settings_dict, "hotline_edit_btn")
    common.wait_for_and_click(device, settings_dict, "search_contact_box")
    contact = common.wait_for_element(device, settings_dict, "search_contact_box")
    contact.clear()
    contact.send_keys(user_phone_number)
    common.wait_for_and_click(device, settings_dict, "hotline_display_name")
    disp_name = common.wait_for_element(device, settings_dict, "hotline_display_name")
    disp_name.clear()
    disp_name.send_keys(display_name)
    common.wait_for_and_click(device, settings_dict, "hotline_save_btn")
    common.wait_for_and_click(device, settings_dict, "hotline_toogle")
    common.wait_for_and_click(device, settings_dict, "restart_btn")


def verify_cancel_btn_while_adding_contact_number_in_hotline(device, configured_user):
    print("device :", device)
    display_name = common.device_displayname(configured_user)
    user_phone_number = common.device_phonenumber(configured_user)
    common.wait_for_and_click(device, calls_dict, "hotline")
    time.sleep(display_time)
    if not common.click_if_present(device, calls_dict, "add_contact"):
        common.wait_for_and_click(device, settings_dict, "hotline_edit_btn")
    common.wait_for_and_click(device, settings_dict, "search_contact_box")
    contact = common.wait_for_element(device, settings_dict, "search_contact_box")
    contact.clear()
    contact.send_keys(user_phone_number)
    common.wait_for_and_click(device, settings_dict, "hotline_display_name")
    disp_name = common.wait_for_element(device, settings_dict, "hotline_display_name")
    disp_name.clear()
    disp_name.send_keys(display_name)
    common.wait_for_and_click(device, calls_dict, "cancel_btn")


def verify_not_saved_user_name_in_hotline_while_adding_or_editing(device, configured_user):
    common.wait_for_and_click(device, calls_dict, "hotline")
    expected_user = common.device_displayname(configured_user)
    print("Expected Hotline Users are:", expected_user)
    if common.is_element_present(device, calls_dict, "add_contact"):
        print(f"{device}:configured user name is not saved in hotline")
        return
    actual_user = common.get_all_elements_texts(device, settings_dict, "hotline_user_name")
    print("Actual Hotline Users are:", actual_user)
    if expected_user in actual_user:
        raise AssertionError(f"Expected Hotline user names {expected_user} displayed in {actual_user}")


def verify_hotline_homescreen_UI(device, state="Enabled"):
    if state.lower() not in ["enabled", "disabled"]:
        raise AssertionError(f"Illegal value for 'state': '{state}'")
    if state.lower() == "disabled":
        if not common.is_element_present(device, calls_dict, "calls_tab"):
            common.wait_for_element(device, calls_dict, "call_park")
    else:
        common.wait_for_element(device, settings_dict, "hotline_UI")


def verify_user_can_not_call_to_anyone_when_hotline_is_enabled(device):
    time.sleep(display_time)
    if common.is_element_present(device, settings_dict, "hotline_UI"):
        return
    else:
        if not common.is_element_present(device, calls_dict, "calls_tab"):
            common.wait_for_element(device, calls_dict, "dialpad_tab")


def disable_hotline_option_from_home_screen(device):
    common.wait_for_and_click(device, settings_dict, "hotline_settings_btn")
    device_settings_keywords.advance_calling_option_oem(device)
    common.wait_for_and_click(device, calls_dict, "hotline")
    common.wait_for_and_click(device, settings_dict, "hotline_toogle")
    common.wait_for_and_click(device, settings_dict, "restart_btn")


def change_hotline_toggle_for_cap(device, toogle_status):
    if toogle_status.lower() not in ["enable", "disable"]:
        raise AssertionError(f"Illegal value for 'status': '{toogle_status}'")
    toogle_btn = common.wait_for_element(device, settings_dict, "hotline_toogle").text
    print(toogle_btn)
    if toogle_status.lower() == "disable":
        if toogle_btn != "ON":
            raise AssertionError(f"f{device} Hotline toggle is already disabled by default")
    if toogle_status.lower() == "enable":
        if toogle_btn != "OFF":
            raise AssertionError(f"f{device} Hotline toggle is already enabled by default")
    common.wait_for_and_click(device, settings_dict, "hotline_toogle")
    common.wait_for_and_click(device, settings_dict, "restart_btn")


def verify_hotline_toggle_status_for_cap(device, toogle_status):
    if toogle_status.lower() not in ["enabled", "disabled"]:
        raise AssertionError(f"Illegal value for 'status': '{toogle_status}'")
    common.wait_for_and_click(device, settings_dict, "hotline_settings_btn")
    device_settings_keywords.advance_calling_option_oem(device)
    common.wait_for_and_click(device, calls_dict, "hotline")
    common.wait_for_element(device, settings_dict, "hotline_toogle")
    if toogle_status.lower() == "enabled":
        common.verify_toggle_button(device, settings_dict, "hotline_toogle", "on")
    if toogle_status.lower() == "disabled":
        common.verify_toggle_button(device, settings_dict, "hotline_toogle", "off")


def edit_configured_hotline_contact_details_from_hotline_homescreen(device, edited_configured_user):
    for i in range(5):
        if not common.click_if_present(device, calls_dict, "Call_Back_Button"):
            break
    user_phone_number = config["devices"][edited_configured_user]["user"]["phonenumber"]
    display_name = config["devices"][edited_configured_user]["user"]["displayname"]
    common.wait_for_and_click(device, settings_dict, "hotline_settings_btn")
    device_settings_keywords.advance_calling_option_oem(device)
    common.wait_for_and_click(device, calls_dict, "hotline")
    common.wait_for_and_click(device, settings_dict, "hotline_edit_btn")
    common.wait_for_and_click(device, settings_dict, "search_contact_box")
    contact = common.wait_for_element(device, settings_dict, "search_contact_box")
    contact.clear()
    contact.send_keys(user_phone_number)
    common.wait_for_and_click(device, settings_dict, "hotline_display_name")
    disp_name = common.wait_for_element(device, settings_dict, "hotline_display_name")
    disp_name.clear()
    disp_name.send_keys(display_name)
    common.wait_for_and_click(device, settings_dict, "hotline_save_btn")
    common.wait_for_and_click(device, settings_dict, "restart_btn")


def come_back_to_home_screen_from_hotline_page(device):
    call_keywords.come_back_to_home_screen(device)
    if not (
        common.is_element_present(device, home_screen_dict, "call_tab")
        or common.is_element_present(device, calls_dict, "dialpad_tab")
    ):
        common.wait_for_element(device, settings_dict, "hotline_UI")


def configure_emergency_number_in_hotline(device):
    print("device :", device)
    emergency_phone_number = "933"
    display_name = "Emergency Contact"
    common.wait_for_and_click(device, calls_dict, "hotline")
    time.sleep(display_time)
    if not common.click_if_present(device, calls_dict, "add_contact"):
        common.wait_for_and_click(device, settings_dict, "hotline_edit_btn")
    common.wait_for_and_click(device, settings_dict, "search_contact_box")
    contact = common.wait_for_element(device, settings_dict, "search_contact_box")
    contact.clear()
    contact.send_keys(emergency_phone_number)
    common.wait_for_and_click(device, settings_dict, "hotline_display_name")
    disp_name = common.wait_for_element(device, settings_dict, "hotline_display_name")
    disp_name.clear()
    disp_name.send_keys(display_name)
    common.wait_for_and_click(device, settings_dict, "hotline_save_btn")
    common.wait_for_and_click(device, settings_dict, "hotline_toogle")
    common.wait_for_and_click(device, settings_dict, "restart_btn")


def configure_invalid_contact_details_in_hotline(device):
    print("device :", device)
    invalid_contact_number = config["incorrect_number"]["phonenumber"]
    invalid_display_name = config["user"]["invalid_username"]
    common.wait_for_and_click(device, calls_dict, "hotline")
    time.sleep(display_time)
    if not common.click_if_present(device, calls_dict, "add_contact"):
        common.wait_for_and_click(device, settings_dict, "hotline_edit_btn")
    common.wait_for_and_click(device, settings_dict, "search_contact_box")
    contact = common.wait_for_element(device, settings_dict, "search_contact_box")
    contact.clear()
    contact.send_keys(invalid_contact_number)
    common.wait_for_and_click(device, settings_dict, "hotline_display_name")
    disp_name = common.wait_for_element(device, settings_dict, "hotline_display_name")
    disp_name.clear()
    disp_name.send_keys(invalid_display_name)
    common.wait_for_and_click(device, settings_dict, "hotline_save_btn")
    common.wait_for_and_click(device, settings_dict, "hotline_toogle")
    common.wait_for_and_click(device, settings_dict, "restart_btn")


def navigate_to_settings_page_from_hotline_home_screen(device):
    common.wait_for_element(device, settings_dict, "hotline_UI")
    common.wait_for_and_click(device, settings_dict, "hotline_settings_btn")
    common.wait_for_element(device, settings_dict, "About")
    device_setting_back(device)


def verify_and_enable_cap_premium(device):
    """This keyword just verifies  whether device is cap or cap premium,
    and enables to cap premium if device is in cap"""
    time.sleep(display_time)
    if common.is_lcp(device):
        if common.is_element_present(device, lcp_homescreen_dict, "voicemail_tab") and common.is_element_present(
            device, lcp_homescreen_dict, "lock"
        ):
            set_advance_calling(device, status="ON")
        return
    elif common.is_element_present(device, calls_dict, "dialpad_tab") and common.is_element_present(
        device, calls_dict, "call_park"
    ):
        set_advance_calling(device, status="ON")
    else:
        print(f"{device} is already in cap premium")


def verify_presence_of_other_user_from_calls_tab(from_device, to_device, state):
    if state.lower() not in ["in call", "available", "busy", "dnd", "be right back", "offline", "away"]:
        raise AssertionError(f"Unexpected value for option : {state}")
    to_device_displayname = common.device_displayname(to_device)
    time.sleep(display_time)
    common.wait_for_element(from_device, lcp_calls_dict, "recent_user_entry_lcp")
    if state.lower() == "in call":
        presence_xpath = common.get_dict_copy(
            settings_dict, "in_call_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "in_call_presence_xpath", wait_attempts=180)
    elif state.lower() == "available":
        presence_xpath = common.get_dict_copy(
            settings_dict, "available_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "available_presence_xpath", wait_attempts=180)
    elif state.lower() == "busy":
        presence_xpath = common.get_dict_copy(settings_dict, "busy_presence_xpath", "username", to_device_displayname)
        common.wait_for_element(from_device, presence_xpath, "busy_presence_xpath")
        print(f"{to_device_displayname} is Busy")
    elif state.lower() == "dnd":
        presence_xpath = common.get_dict_copy(settings_dict, "dnd_presence_xpath", "username", to_device_displayname)
        common.wait_for_element(from_device, presence_xpath, "dnd_presence_xpath", wait_attempts=180)
    elif state.lower() == "be right back":
        presence_xpath = common.get_dict_copy(
            settings_dict, "be_right_back_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "be_right_back_presence_xpath")
        print(f"{to_device_displayname} in Be Right Back mode")
    elif state.lower() == "offline":
        presence_xpath = common.get_dict_copy(
            settings_dict, "offline_presence_xpath", "username", to_device_displayname
        )
        common.wait_for_element(from_device, presence_xpath, "offline_presence_xpath", wait_attempts=180)
    elif state.lower() == "away":
        presence_xpath = common.get_dict_copy(settings_dict, "away_presence_xpath", "username", to_device_displayname)
        common.wait_for_element(from_device, presence_xpath, "away_presence_xpath")
        print(f"{to_device_displayname} is Away")


def verify_delegate_options_inside_call_info_with_boss_when_boss_is_in_call_with_other_user(from_device, boss):
    call_keywords.navigate_to_calls_favorites_page(from_device)
    refresh_calls_main_tab(from_device)
    common.wait_for_element(from_device, calls_dict, "people_you_support")
    boss_displayname = common.device_displayname(boss)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", boss_displayname)
    common.wait_while_present(from_device, calls_dict, "Resume", max_wait_attempts=3)
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_element(from_device, calls_dict, "call_list_item_call_action")
    common.wait_for_element(from_device, calls_dict, "call_list_view_profile_action")
    common.wait_for_element(from_device, calls_dict, "view_Permissions")
    common.wait_for_and_click(from_device, calendar_dict, "touch_outside")


def verify_boss_options_inside_call_info_with_delegate_when_delegate_is_in_call_with_other_user(from_device, delegate):
    call_keywords.navigate_to_calls_favorites_page(from_device)
    refresh_calls_main_tab(from_device)
    common.wait_for_element(from_device, calls_dict, "your_delegates")
    delegate_displayname = common.device_displayname(delegate)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", delegate_displayname)
    common.wait_for_element(from_device, calls_dict, "Resume")
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_element(from_device, calls_dict, "resume_call_at_recent_tab_more")
    common.wait_for_element(from_device, calls_dict, "call_list_item_call_action")
    common.wait_for_element(from_device, calls_dict, "call_list_view_profile_action")
    common.wait_for_element(from_device, calls_dict, "view_Permissions")
    common.wait_for_and_click(from_device, calendar_dict, "touch_outside")


def verify_resume_call_option_should_not_present_inside_the_more_icon_of_boss(from_device, to_device):
    refresh_calls_main_tab(from_device)
    common.wait_for_element(from_device, calls_dict, "people_you_support")
    boss_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(calls_dict, "favorites_more_options", "user_name", boss_displayname)
    common.wait_for_and_click(from_device, temp_dict, "favorites_more_options", "xpath")
    common.wait_for_element(from_device, calls_dict, "view_Permissions")
    common.wait_while_present(from_device, settings_dict, "resume_call_in_more_option_with_boss", max_wait_attempts=3)
    call_keywords.dismiss_call_more_options(from_device)


def verify_default_options_present_in_delegate_settings_page(from_device, to_device):
    navigate_to_manage_delegate_page(from_device)
    username = common.device_displayname(to_device)
    common.kb_trigger_search(from_device, settings_dict, "add_delegates", username)
    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", username)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")
    time.sleep(display_time)
    common.wait_for_element(from_device, settings_dict, "save_permissions")
    title = common.get_all_elements_texts(from_device, settings_dict, "delete_delegates")
    print(f"{from_device}: Delegate options present while adding delegate are :{title}")
    expected_delegate_options = [
        "Make calls",
        "Receive calls",
        "Change call and delegate settings",
        "Join active calls",
        "Pick up held calls",
    ]
    if title != expected_delegate_options:
        raise AssertionError(f"{from_device}: Delegate options present are incorrect")


def verify_default_options_enabled_while_adding_delegate_in_delegate_settings_page(device):
    title = common.get_all_elements_texts(device, settings_dict, "delete_delegates")
    print(f"{device}: Delegate options present while adding delegate are :{title}")
    toggle_switch = common.wait_for_element(
        device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )
    toggles_state_list = []
    for ele in toggle_switch:
        ele1 = ele.get_attribute("checked")
        toggles_state_list.append(ele1)
        print(toggles_state_list)
    enabled_toggles_list = toggles_state_list[:2]
    disabled_toggles_list = toggles_state_list[2:]
    print(
        f"{device}: enabled and disabled toggles list are respectively :", enabled_toggles_list, disabled_toggles_list
    )
    for i in enabled_toggles_list:
        if i != "true":
            raise AssertionError(f"{device}: Default enabled toggle options are not as expected")
    for j in disabled_toggles_list:
        if j != "false":
            raise AssertionError(f"{device}: Default disabled toggle options are not as expected")
    click_back(device)


def verify_and_resume_call_using_resume_button_with_boss(from_device, to_device, option="join_call"):
    if option.lower() not in ["verify", "join_call"]:
        raise AssertionError(f"Illegal value for 'option': '{option}'")
    refresh_calls_main_tab(from_device)
    common.wait_for_element(from_device, calls_dict, "people_you_support")
    user_displayname = common.device_displayname(to_device)
    boss = common.get_all_elements_texts(from_device, settings_dict, "contact_display_name")
    if user_displayname not in boss:
        raise AssertionError(f"{from_device} is not found {to_device} name:{boss}")
    if option == "join_call":
        common.wait_for_and_click(from_device, calls_dict, "Resume")
        common.wait_for_element(from_device, calls_dict, "Hang_up_button")
    elif option == "verify":
        common.wait_for_element(from_device, calls_dict, "Resume")


def is_dial_pad_applicable_for_cap(device):
    print("device :", device)
    if config["devices"][device]["model"].lower() in ["riverside", "riverside_13"]:
        status = "pass"
    else:
        status = "fail"
    return status


def verify_signin_with_license_is_not_supported_account_used_for_signin_phones(device):
    username, password, device, account_type = common.get_credentials(device)
    print(username, password, device, account_type)
    if common.is_element_present(device, sign_dict, "refresh_code_button"):
        common.wait_for_and_click(device, sign_dict, "refresh_code_button")
        common.sleep_with_msg(device, 5, "Allow refresh of DFC code")
    common.wait_for_element(device, sign_dict, "dfc_login_code")
    common.wait_for_and_click(device, sign_dict, "sign_in_on_the_device")
    common.wait_for_element(device, sign_dict, "Username").send_keys(username)
    print(f"Entered username: {username}")
    _model = common.device_model(device)
    if _model in ["gilbert", "santa cruz_13", "redmond_13", "santa cruz", "bakersfield_13", "bakersfield"]:
        common.hide_keyboard(device)
    common.wait_for_and_click(device, sign_dict, "Sign_in_button")
    common.sleep_with_msg(device, 7, "Waiting for the password entry screen to appear")
    common.wait_for_element(device, sign_dict, "Password").send_keys(password)
    print(f"{device}: entered the password")
    if _model in ["gilbert", "santa cruz_13", "redmond_13", "santa cruz", "bakersfield_13", "bakersfield"]:
        common.hide_keyboard(device)
    if not common.click_if_present(device, sign_dict, "Sign_in"):
        common.wait_for_and_click(device, sign_dict, "signin_button")
    common.sleep_with_msg(device, 30, "Waiting for sign-in to complete")
    if account_type == "mtra_basic_account":
        error_message = common.wait_for_element(device, sign_dict, "signin_failure_error", wait_attempts=40).text
        if (
            error_message.strip()
            != "Your current license is not supported on this device. Ask your IT administrator for details.".strip()
        ):
            raise AssertionError(f"unsupported account error message is not found: {error_message}")

    elif account_type in [
        "maximum_os_account",
        "minimum_os_account",
        "invalid_OS_set_account",
        "DA_enrollment_disabled_account",
    ]:
        error_message = common.wait_for_element(device, sign_dict, "signin_failure_error", wait_attempts=60).text
        allowed_error_messages = [
            "Device OS version doesn't meet maximum OS company policy. Contact your admin",
            "Device OS version doesn't meet minimum OS company policy. Contact your admin",
            "This device isn’t enrolled in device administrator. Contact your admin",
        ]
        if error_message.strip() not in [msg.strip() for msg in allowed_error_messages]:
            raise AssertionError(f"Unsupported account error message is not found: {error_message}")

    elif account_type in ["cap_limit_reached_account", "enrollment_restrict_account", "manufacture_blocked_account"]:
        error_message = common.wait_for_element(device, sign_dict, "signin_failure_error", wait_attempts=40).text
        allowed_error_messages = [
            "Couldn’t connect to Workplace Join. Try again, or contact your admin.",
            "This device needs to be enrolled in device administrator. Contact your IT admin.",
            "Couldn’t enroll in Intune due to the device limit. Contact your admin.",
            "This device isn’t enrolled in device administrator. Contact your admin",
            "This device is blocked by company policy. Contact your admin",
        ]
        if error_message.strip() not in [msg.strip() for msg in allowed_error_messages]:
            raise AssertionError(f"Unsupported account error message is not found: {error_message}")

    elif account_type in [
        "cap_mtra_pro_license_with_personal_policy_assigned_account",
        "cap_personal_license_with_personal_policy_assigned_account",
    ]:
        common.sleep_with_msg(device, 30, "waiting for complete sign-in")
        home_screen_keywords.verify_home_screen_tiles(device)
        home_screen_keywords.verify_home_screen_time_dates(device)

    else:
        raise AssertionError(f"account type {account_type} is not recognized")


def verify_set_your_emergency_location_option_under_user_profile(device):
    expected_mail_id, password, device, account = common.get_credentials(device)
    common.wait_for_and_click(device, navigation_dict, "Navigation")
    common.wait_for_and_click(device, settings_dict, "user_displayname")
    actual_mail_id = common.wait_for_element(device, calls_dict, "mail_id").text.lower()
    if actual_mail_id != expected_mail_id.lower():
        raise AssertionError(f"{device}: Expected mail id: '{expected_mail_id.lower()}', but found: '{actual_mail_id}'")
    common.wait_for_element(device, settings_dict, "set_your_emergency_location")


def verify_each_option_in_teams_admin_setting_for_conf(device):
    driver = obj.device_store.get(alias=device)
    if config["devices"][device]["model"].lower() == "manhattan":
        common.wait_for_and_click(device, device_settings_dict, "admin_settings")
        element1 = common.wait_for_element(device, settings_dict, "admin_passwd")
        element1.send_keys(config["devices"][device]["admin_password"])
        common.hide_keyboard(device)
        common.wait_for_and_click(device, settings_dict, "Login_btn")
        common.wait_for_and_click(device, device_settings_dict, "teams_admin_settings")
        common.wait_for_and_click(device, device_settings_dict, "teams_admin_settings_btn")
    elif config["devices"][device]["model"].lower() == "tacoma":
        common.wait_for_and_click(device, settings_dict, "Admin_Only", "xpath")
        common.wait_for_element(device, settings_dict, "admin_passwd", "xpath").send_keys(
            config["devices"][device]["admin_password"]
        )
        driver.execute_script("mobile: performEditorAction", {"action": "done"})
        app_bar_keywords.swipe_page_up(device)
    elif config["devices"][device]["model"].lower() == "berkely":
        common.wait_for_and_click(device, settings_dict, "device_admin_pswd")
        common.wait_for_element(device, settings_dict, "device_admin_pswd").send_keys(
            config["devices"][device]["admin_password"]
        )
        driver.execute_script("mobile: performEditorAction", {"action": "done"})
        common.hide_keyboard(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, device_settings_dict, "teams_admin_settings", "text")
    common.wait_for_and_click(device, settings_dict, "Sign_out")
    common.wait_for_element(device, calendar_dict, "alert_title")
    common.wait_for_and_click(device, settings_dict, "adv_call_cancel_btn")
    common.wait_for_and_click(device, settings_dict, "Calling")
    common.wait_for_element(device, settings_dict, "call_forwarding")
    common.wait_for_and_click(device, app_bar_dict, "back")


def verify_signin_with_unsupported_account_for_phones(device):
    username = "device@g.com"
    time.sleep(6)
    if common.is_element_present(device, sign_dict, "refresh_code_button"):
        common.wait_for_and_click(device, sign_dict, "refresh_code_button")
        common.sleep_with_msg(device, 5, "Allow refresh of DFC code")
    common.wait_for_element(device, sign_dict, "dfc_login_code")
    common.wait_for_and_click(device, sign_dict, "sign_in_on_the_device")
    common.wait_for_and_click(device, sign_dict, "Username")
    search_input = common.wait_for_element(device, sign_dict, "Username")
    search_input.send_keys(username)
    print("Entered username")
    common.wait_for_and_click(device, sign_dict, "Sign_in_button")
    error_message = common.wait_for_element(device, sign_dict, "unsupported_account_error").text
    if error_message != "You’ll need to sign in with a work account.":
        raise AssertionError(f"unsupported account error message is not found: {error_message}")


def verify_admin_setting_signout_for_conf(device):
    driver = obj.device_store.get(alias=device)
    model = config["devices"][device]["model"].lower()
    if model == "manhattan":
        common.wait_for_and_click(device, device_settings_dict, "admin_settings")
        element1 = common.wait_for_element(device, settings_dict, "admin_passwd")
        element1.send_keys(config["devices"][device]["admin_password"])
        common.hide_keyboard(device)
        common.wait_for_and_click(device, settings_dict, "Login_btn")
        common.wait_for_and_click(device, device_settings_dict, "admin_back_button")
        common.wait_for_and_click(device, device_settings_dict, "user_sign_out_yes")
    elif model == "tacoma":
        common.wait_for_and_click(device, settings_dict, "Admin_Only", "xpath")
        common.wait_for_element(device, settings_dict, "admin_passwd", "xpath").send_keys(
            config["devices"][device]["admin_password"]
        )
        driver.execute_script("mobile: performEditorAction", {"action": "done"})
        common.wait_for_and_click(device, tr_device_settings_dict, "back_button")
        call_keywords.come_back_to_home_screen(device)
        open_settings_page(device)
        click_device_settings(device)
        common.wait_for_and_click(device, settings_dict, "Admin_Only", "xpath")
        common.wait_for_element(device, settings_dict, "admin_passwd")
        common.wait_for_and_click(device, device_settings_dict, "admin_setting_popup_close_btn")
        call_keywords.come_back_to_home_screen(device)

    elif model == "berkely":
        common.wait_for_and_click(device, settings_dict, "device_admin_pswd")
        common.wait_for_element(device, settings_dict, "device_admin_pswd").send_keys(
            config["devices"][device]["admin_password"]
        )
        driver.execute_script("mobile: performEditorAction", {"action": "done"})
        common.hide_keyboard(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, device_settings_dict, "admin_sign_out")
        common.wait_for_and_click(device, device_settings_dict, "ok")
        call_keywords.come_back_to_home_screen(device)
        open_settings_page(device)
        click_device_settings(device)
        common.wait_for_and_click(device, settings_dict, "device_admin_pswd")
        common.wait_for_element(device, settings_dict, "device_admin_pswd").send_keys(
            config["devices"][device]["admin_password"]
        )
        driver.execute_script("mobile: performEditorAction", {"action": "done"})
        call_keywords.come_back_to_home_screen(device)


def verify_call_forwarding_label_status_on_home_screen(device, status, to_device=None):
    if status.lower() not in ["off", "voicemail", "contact_or_number", "delegate", "call_group"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")

    if to_device is not None:
        if ":" in to_device:
            devices, account = common.decode_device_spec(to_device)
            if account == "pstn_user":
                display_name = config["devices"][devices][account]["pstndisplay"]
            else:
                display_name = config["devices"][devices][account]["displayname"]
        else:
            display_name = common.device_displayname(to_device)

    common.click_if_present(device, calls_dict, "Call_Back_Button")
    common.click_if_present(device, home_screen_dict, "home_bar_icon")

    if not common.is_element_present(device, navigation_dict, "Navigation"):
        common.wait_for_element(device, calls_dict, "user_profile_picture")

    if status.lower() == "off":
        common.wait_for_element(device, home_screen_dict, "dont_forward_calls")

    elif status.lower() == "voicemail":
        common.wait_for_element(device, home_screen_dict, "forward_to_voicemail")

    elif status.lower() == "contact_or_number":
        forwarding_display_name = "Forward to " + display_name
        tmp_dict = common.get_dict_copy(
            calls_dict, "search_result_item_container", "config_display", forwarding_display_name
        )
        common.wait_for_element(device, tmp_dict, "search_result_item_container", "xpath")

    elif status.lower() == "delegate":
        common.wait_for_element(device, home_screen_dict, "forward_to_my_delegates")

    elif status.lower() == "call_group":
        common.wait_for_element(device, home_screen_dict, "forward_to_call_group")


def verify_and_change_toggle_status_for_call_forwarding_display_on_home_screen(device, status):
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")

    device, account = common.decode_device_spec(device)
    _model = common.device_model(device)

    open_settings_page(device)
    time.sleep(display_time)

    if not common.click_if_present(device, settings_dict, "Calling"):
        swipe_till_end(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, settings_dict, "Device_Settings")
        device_settings_keywords.advance_calling_option_oem(device)
        common.wait_for_element(device, settings_dict, "call_forwarding")
    if common.is_lcp(device):
        if _model not in ["glendale", "loveland"]:
            swipe_till_end(device)
    common.change_toggle_button(
        device, settings_dict, "call_forwarding_display_on_home_screen_toggle", desired_state=status
    )

    # come back to home screen page
    if (_model == "olympia" and account == "cap_search_enabled") or _model == "riverside_13" or _model == "riverside":
        call_keywords.come_back_to_home_screen(device)
    else:
        call_views_keywords.go_back_to_previous_page(device)

    if status.lower() == "on":
        if not common.is_lcp(device):
            if not account == "cap_search_enabled":
                common.wait_for_element(device, settings_dict, "call_forwarding_label_text_on_home_screen")
        common.wait_for_element(device, settings_dict, "call_forwarding_icon_on_home_screen")

    elif status.lower() == "off":
        if common.is_element_present(
            device, settings_dict, "call_forwarding_icon_on_home_screen"
        ) or common.is_element_present(device, settings_dict, "call_forwarding_label_text_on_home_screen"):
            raise AssertionError(
                f"{device} is after disable toggle also appearing call forwarding  status on home screen: {status}"
            )


def reboot_panel(device):
    _model = shared_utils.getconfig_device_model(device)
    if _model in [
        "beverly hills",
        "westchester",
        "brooklyn",
        "hollywood",
        "surprise",
        "hollywood_13",
        "beverly hills_13",
    ]:
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings")
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_panel_option")
        common.wait_for_and_click(device, device_settings_dict, "ok")
    elif _model in ["arlington", "plano"]:
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings")
        common.wait_for_and_click(device, calendar_dict, "ok_button")
    elif _model == "richland":
        panel_meetings_device_settings_keywords.navigate_inside_admin_setting_in_panel(device, password_type="old")
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_and_click(device, tr_device_settings_dict, "restart")
        common.wait_for_element(device, panels_device_settings_dict, "system_restart_alert")
        common.wait_for_and_click(device, sign_dict, "continue")
    elif _model == "savannah":
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings")
        common.wait_for_and_click(device, device_settings_dict, "ok")
    elif _model == "flint":
        common.wait_for_and_click(device, device_settings_dict, "system_settings")
        time.sleep(action_time)
        common.scroll_the_page(
            device,
            common.wait_for_element(device, tr_device_settings_dict, "device_settings_scroll_view"),
            swiping="up",
        )
        common.wait_for_and_click(device, settings_dict, "restart_btn", "id1")

    elif common.is_panel(device):
        common.sleep_with_msg(device, 25, "Waiting for device to come online...")
    else:
        raise AssertionError(f"{device}: No validation specified for device model '{_model}'")


def verify_adb_access_is_disabled_for_device():
    print("verify device is online")
    _udid = config["adb_disabled_device"]["udid"].strip(":5555")
    print(f"connect device : {_udid}")
    cmd_ping = "ping  " + str(_udid.split(":")[0])
    _result = subprocess.run(
        cmd_ping,
        stdout=subprocess.PIPE,
        text=True,
        check=True,
        timeout=float(1 * 60),
    )
    if f"Reply from {_udid}" in _result.stdout:
        print(f"{_udid}: is online.")
        print("Check if ADB is disabled on :", _udid)
        cmd_connect = "adb connect " + str(_udid.split(":")[0])
        time.sleep(2)
        result = subprocess.run(
            cmd_connect,
            stdout=subprocess.PIPE,
            text=True,
            check=True,
            timeout=float(1 * 60),
        )
        if f"cannot connect to {_udid}:5555" not in result.stdout.lower():
            raise AssertionError(
                f"{_udid}: is not in adb disabled build as per expected and able to connect using adb."
            )
        print(f"Verified {_udid}: is in adb disabled build as per expected.")
    else:
        raise AssertionError(f"{_udid}: is not online.")


# def connect_panel():
#     for device in list(config["devices"].keys()):
#         connect_device(device, config)


def verify_and_set_call_forwarding_on_home_screen(device, option, to_device=None):
    if option.lower() not in ["off", "voicemail", "contact_or_number", "delegate", "call_group"]:
        raise AssertionError(f"Illegal value for 'status': '{option}'")
    if to_device is not None:
        if ":" in to_device:
            devices, account = common.decode_device_spec(to_device)
            if account == "pstn_user":
                display_name = config["devices"][devices][account]["pstndisplay"]
            else:
                display_name = common.config["devices"][devices][account]["displayname"]
        else:
            display_name = common.device_displayname(to_device)

    common.click_if_present(device, calls_dict, "Call_Back_Button")
    common.click_if_present(device, home_screen_dict, "home_bar_icon")

    if not common.is_element_present(device, navigation_dict, "Navigation"):
        common.wait_for_element(device, calls_dict, "user_profile_picture")

    if not (
        common.click_if_present(device, settings_dict, "call_forwarding_icon_on_home_screen")
        or common.click_if_present(device, settings_dict, "forwarding_icon_on_calls_tab")
    ):
        common.wait_for_and_click(device, settings_dict, "call_forwarding_pop_up_open_or_close_button")

    if option.lower() == "off":
        if common.is_lcp(device):
            calendar_keywords.scroll_down_device_setting_tab(device)
        common.wait_for_and_click(device, home_screen_dict, "dont_forward_calls")

    elif option.lower() == "voicemail":
        common.wait_for_and_click(device, home_screen_dict, "forward_to_voicemail")

    elif option.lower() == "contact_or_number":
        common.wait_for_and_click(device, home_screen_dict, "forward_to_contact_or_number")
        common.click_if_element_appears(device, settings_dict, "add_contact_option", max_attempts=3)
        element = common.wait_for_element(device, settings_dict, "search_contact_box")
        element.send_keys(display_name)
        common.hide_keyboard(device)
        tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", display_name)
        common.wait_for_and_click(device, tmp_dict, "search_result_item_container", "xpath")
        common.wait_for_and_click(device, calls_dict, "Call_Back_Button")

    elif option.lower() == "delegate":
        common.wait_for_and_click(device, home_screen_dict, "forward_to_my_delegates")

    elif option.lower() == "call_group":
        common.wait_for_and_click(device, home_screen_dict, "forward_to_call_group")

    if common.is_lcp(device):
        device_setting_back(device)
        return
    common.click_if_present(device, calls_dict, "Call_Back_Button")
    dismiss_call_forwarding_pop_up_on_home_screen(device)
    time.sleep(action_time)
    if not (
        common.is_element_present(device, people_dict, "people_tab_cap")
        or common.is_element_present(device, calls_dict, "search")
    ):
        verify_call_forwarding_label_status_on_home_screen(device=device, status=option, to_device=to_device)


def dismiss_call_forwarding_pop_up_on_home_screen(device):
    time.sleep(action_time)
    if common.is_element_present(device, settings_dict, "forwarding_text"):
        common.wait_for_and_click(device, settings_dict, "call_forwarding_pop_up_open_or_close_button")
    elif common.is_element_present(device, settings_dict, "call_forwarding_pop_up_layout_on_calls_tab"):
        call_keywords.dismiss_call_more_options(
            device, common.wait_for_element(device, settings_dict, "call_forwarding_pop_up_layout_on_calls_tab")
        )


def verify_display_home_screen_toggle_status_under_calling(device, status):
    if status.lower() not in ["on", "off"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    open_settings_page(device)
    time.sleep(display_time)
    _model = common.device_model(device)
    if not common.click_if_present(device, settings_dict, "Calling"):
        swipe_till_end(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, settings_dict, "Device_Settings")
        device_settings_keywords.advance_calling_option_oem(device)
        common.wait_for_element(device, settings_dict, "call_forwarding")
    common.wait_for_element(device, settings_dict, "display_on_home_screen")
    common.wait_for_element(device, settings_dict, "call_forwarding_display_on_home_screen_toggle")
    if common.is_lcp(device):
        if _model not in ["glendale", "loveland"]:
            swipe_till_end(device)

    if status == "on":
        common.verify_toggle_button(
            device, settings_dict, "call_forwarding_display_on_home_screen_toggle", desired_state=status
        )

    elif status == "off":
        common.verify_toggle_button(
            device, settings_dict, "call_forwarding_display_on_home_screen_toggle", desired_state=status
        )

    # come back to home screen page
    call_views_keywords.go_back_to_previous_page(device)


def verify_call_forwarding_option_in_call_forward_icon(device, verify_call_group="on"):
    if verify_call_group.lower() not in ["off", "on"]:
        raise AssertionError(f"Illegal value for 'verify_call_group': '{verify_call_group}'")
    time.sleep(action_time)
    if common.is_lcp(device):
        common.wait_for_and_click(device, settings_dict, "call_forwarding_icon_on_home_screen")
    elif not common.click_if_present(device, settings_dict, "forwarding_icon_on_calls_tab"):
        common.wait_for_and_click(device, settings_dict, "call_forwarding_icon_on_home_screen")

    common.wait_for_element(device, home_screen_dict, "forward_to_voicemail")
    common.wait_for_element(device, home_screen_dict, "forward_to_my_delegates")
    common.wait_for_element(device, home_screen_dict, "forward_to_contact_or_number")
    if verify_call_group == "on":
        common.wait_for_element(device, home_screen_dict, "forward_to_call_group")

    if common.is_lcp(device):
        calendar_keywords.scroll_down_device_setting_tab(device)
    common.wait_for_element(device, home_screen_dict, "dont_forward_calls")
    # To disimiss pop-up
    if common.is_lcp(device):
        device_setting_back(device)
    else:
        common.wait_for_and_click(device, home_screen_dict, "dont_forward_calls")
        if not common.is_element_present(device, people_dict, "people_tab_cap"):
            dismiss_call_forwarding_pop_up_on_home_screen(device)


def verify_call_forwarding_option_when_no_delegate_present_on_device(device):
    common.wait_for_and_click(device, settings_dict, "call_forwarding_icon_on_home_screen")
    common.wait_for_element(device, home_screen_dict, "dont_forward_calls")
    common.wait_for_element(device, home_screen_dict, "forward_to_voicemail")
    common.wait_while_present(device, home_screen_dict, "forward_to_my_delegates")
    common.wait_for_element(device, home_screen_dict, "forward_to_contact_or_number")
    common.wait_for_and_click(device, settings_dict, "call_forwarding_icon_on_home_screen")


def verify_call_forwarding_icon(device):
    time.sleep(action_time)
    if not common.is_element_present(device, settings_dict, "forwarding_icon_on_calls_tab"):
        common.wait_for_element(device, settings_dict, "call_forwarding_icon_on_home_screen")


def verify_call_forwarding_icon_should_not_appear_on_home_screen(device):
    if common.is_element_present(
        device, settings_dict, "call_forwarding_icon_on_home_screen"
    ) or common.is_element_present(device, settings_dict, "forwarding_icon_on_calls_tab"):
        raise AssertionError(f"{device} is after disable toggle also appearing call forwarding icon")


def verify_call_forwarding_status_on_calling(device, option, to_device=None):
    if option.lower() not in ["off", "voicemail", "contact_or_number", "delegate", "call_group"]:
        raise AssertionError(f"Illegal value for 'status': '{option}'")

    if to_device is not None:
        if ":" in to_device:
            devices, account = common.decode_device_spec(to_device)
            if account == "pstn_user":
                display_name = config["devices"][devices][account]["pstndisplay"]
            else:
                display_name = common.config["devices"][devices][account]["displayname"]
        else:
            display_name = common.device_displayname(to_device)

    open_settings_page(device)
    time.sleep(display_time)
    if not common.click_if_present(device, settings_dict, "Calling"):
        swipe_till_end(device)
        swipe_till_end(device)
        common.wait_for_and_click(device, settings_dict, "Device_Settings")
        device_settings_keywords.advance_calling_option_oem(device)

    common.wait_for_element(device, settings_dict, "call_forwarding")

    if option.lower() == "off":
        common.verify_toggle_button(device, settings_dict, "Call_forward_toggle", desired_state="off")

    elif option.lower() == "voicemail":
        common.wait_for_element(device, settings_dict, "call_forward_to")
        common.wait_for_element(device, settings_dict, "voicemail_option")

    elif option.lower() == "contact_or_number":
        common.wait_for_and_click(device, settings_dict, "call_forward_to")
        tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", display_name)
        common.wait_for_element(device, tmp_dict, "search_result_item_container", "xpath")

    elif option.lower() == "delegate":
        common.wait_for_element(device, settings_dict, "call_forward_to")
        common.wait_for_element(device, settings_dict, "my_delegates_option")

    elif option.lower() == "call_group":
        common.wait_for_element(device, settings_dict, "call_forward_to")
        common.wait_for_element(device, settings_dict, "call_group_option")

    # come back to home screen page
    call_views_keywords.go_back_to_previous_page(device)


def remove_all_delegates_on_device(devices):
    devices = devices.split(",")
    for device in devices:
        driver = obj.device_store.get(alias=device)
        navigate_to_manage_delegate_page(device)
        for i in range(3):
            common.wait_for_element(device, settings_dict, "manage_delegates_tab_text")
            common.sleep_with_msg(device, 5, "Wait for manage delegates page to stabilize")
            # Check if there are any delegates added for the user
            if common.is_element_present(device, calls_dict, "your_delegates"):
                common.wait_for_and_click(device, settings_dict, "your_delegates_list")
                common.sleep_with_msg(device, 3, "Wait for delegates permission tab to load")
                username = common.wait_for_element(device, settings_dict, "username_in_permission_tab").text
                common.wait_for_element(device, settings_dict, "delegate_actions_text")
                common.wait_for_and_click(device, settings_dict, "delete_delegates", "xpath")
                print(f"{device}: Deleted delegate: {username}")
                common.sleep_with_msg(device, 10, "Wait for delegate to be deleted")
        for attempt in range(3):
            if not common.click_if_present(device, calls_dict, "Call_Back_Button"):
                break
            common.sleep_with_msg(device, 3, f"React to 'Call_Back_Button' click, attempt: {attempt}.")


def verify_options_after_disabling_auto_restart_toggle_btn(device):
    common.wait_while_present(device, settings_dict, "automatically_toggle_btn", max_wait_attempts=3)


def verify_and_change_the_contact_on_forward_to_contact_or_number_on_home_screen(device, contact_device):
    if ":" in contact_device:
        devices, account = common.decode_device_spec(contact_device)
        if account == "pstn_user":
            display_name = config["devices"][devices][account]["pstndisplay"]
        else:
            display_name = config["devices"][devices][account]["displayname"]
    else:
        display_name = common.device_displayname(contact_device)

    if not (
        common.click_if_present(device, settings_dict, "call_forwarding_icon_on_home_screen")
        or common.click_if_present(device, settings_dict, "forwarding_icon_on_calls_tab")
    ):
        common.wait_for_and_click(device, settings_dict, "call_forwarding_pop_up_open_or_close_button")

    common.wait_for_and_click(device, home_screen_dict, "forward_to_contact_or_number")
    common.wait_for_and_click(device, settings_dict, "add_contact_option")
    common.wait_for_element(device, settings_dict, "search_contact_box").send_keys(display_name)
    common.hide_keyboard(device)
    temp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", display_name)
    common.wait_for_and_click(device, temp_dict, "search_result_item_container")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")
    dismiss_call_forwarding_pop_up_on_home_screen(device)


def verify_send_feedback_page(device, policy="all"):
    if not policy.lower() in ["log_collection_disabled", "email_disabled", "feedback_disabled", "all"]:
        raise AssertionError(f"Illegal policy specified: '{policy}'")
    open_settings_page(device)
    common.scroll_the_page(
        device, common.wait_for_element(device, settings_dict, "settings_page_scroll_view"), swiping="up"
    )
    common.wait_for_and_click(device, settings_dict, "Help")
    common.click_if_element_appears(device, settings_dict, "send_feedback")
    if common.is_lcp(device):
        _max_attempts = 4
        for i in range(_max_attempts):
            calendar_keywords.scroll_only_once(device)
    if config["devices"][device]["model"].lower() == "gilbert":
        swipe_till_end(device)
    if policy.lower() == "feedback_disabled":
        common.raise_if_present(device, settings_dict, "summarize_your_feedback")
    elif policy.lower() == "log_collection_disabled":
        common.wait_for_element(device, settings_dict, "summarize_your_feedback")
        common.raise_if_present(device, settings_dict, "attach_logs_to_help_troubleshoot_text")
        common.raise_if_present(device, settings_dict, "attach_logs_to_help_troubleshoot_toggle")
    elif policy.lower() == "email_disabled":
        common.wait_for_element(device, settings_dict, "summarize_your_feedback")
        common.raise_if_present(device, settings_dict, "allow_microsoft_to_contact_me_text")
        common.raise_if_present(device, settings_dict, "allow_microsoft_to_contact_me_toggle")
    else:
        common.wait_for_element(device, settings_dict, "summarize_your_feedback")
        common.wait_for_element(device, settings_dict, "allow_microsoft_to_contact_me_text")
        common.wait_for_element(device, settings_dict, "allow_microsoft_to_contact_me_toggle")
        common.wait_for_element(device, settings_dict, "attach_logs_to_help_troubleshoot_text")
        common.wait_for_element(device, settings_dict, "attach_logs_to_help_troubleshoot_toggle")


def give_feedback_to_microsoft(device, available_toggles="all"):
    if not available_toggles.lower() in ["log_collection", "contact_me", "all"]:
        raise AssertionError(f"Illegal toggle specified: '{available_toggles}'")
    if common.is_lcp(device):
        calendar_keywords.scroll_down_device_setting_tab(device)
        calendar_keywords.scroll_down_device_setting_tab(device)
    if config["devices"][device]["model"].lower() == "gilbert":
        calendar_keywords.scroll_down_device_setting_tab(device)
        calendar_keywords.scroll_down_device_setting_tab(device)
    common.wait_for_and_click(device, settings_dict, "feedback_text_section")
    common.wait_for_element(device, settings_dict, "feedback_text_section").send_keys(
        config["Report_feedback"]["bug_details"]
    )
    common.hide_keyboard(device)
    if common.is_lcp(device):
        swipe_till_end(device)
        swipe_till_end(device)
    if config["devices"][device]["model"].lower() == "gilbert":
        swipe_till_end(device)
    if available_toggles.lower() == "log_collection":
        common.change_toggle_button(
            device, settings_dict, "attach_logs_to_help_troubleshoot_toggle", desired_state="on"
        )
    elif available_toggles.lower() == "contact_me":
        common.change_toggle_button(device, settings_dict, "allow_microsoft_to_contact_me_toggle", desired_state="on")
    else:
        common.change_toggle_button(device, settings_dict, "allow_microsoft_to_contact_me_toggle", desired_state="on")
        common.change_toggle_button(
            device, settings_dict, "attach_logs_to_help_troubleshoot_toggle", desired_state="on"
        )
    common.wait_for_and_click(device, settings_dict, "send_bug")
    common.wait_while_present(device, settings_dict, "send_bug")


def verify_delegate_permissions_selectively(device, from_device, exclude_permission):
    if exclude_permission not in [
        "make_calls",
        "receive_calls",
        "change_call_settings",
        "join_calls",
        "pick_up_held_calls",
    ]:
        raise AssertionError(f"{device}: Wrong value for 'exclude_permission': '{exclude_permission}'")
    permission_dict = {
        "make_calls": "Make calls",
        "receive_calls": "Receive calls",
        "change_call_settings": "Change call and delegate settings",
        "join_calls": "Join active calls",
        "pick_up_held_calls": "Pick up held calls",
    }
    delegate_displayname = common.device_displayname(from_device)
    users = common.get_all_elements_texts(device, settings_dict, "user_title")
    if delegate_displayname not in users:
        raise AssertionError(
            f"{device}: Expected delegate user: '{delegate_displayname}' is not in list of delegate users: {users}"
        )
    search_result_xpath = common.get_dict_copy(
        calls_dict, "search_result_item_container", "config_display", delegate_displayname
    )
    common.wait_for_and_click(device, search_result_xpath, "search_result_item_container", "xpath")
    time.sleep(display_time)
    delegate_permissions_list = [
        "Make calls",
        "Receive calls",
        "Change call and delegate settings",
        "Join active calls",
        "Pick up held calls",
    ]
    permissions_title_list = common.get_all_elements_texts(device, settings_dict, "delete_delegates")
    permission_toggle_list = common.wait_for_element(
        device, settings_dict, "permission_switch", cond=EC.presence_of_all_elements_located
    )
    if permissions_title_list != delegate_permissions_list:
        raise AssertionError(
            f"{device}: Not all permissions are displayed: '{permissions_title_list}' for the user: {delegate_displayname}. Expected permissions: '{delegate_permissions_list}'"
        )
    permission_toggle_state_list = []
    for permission_toggle in permission_toggle_list:
        permission_toggle_state_list.append(permission_toggle.get_attribute("checked"))
    if (
        permission_toggle_state_list[delegate_permissions_list.index(permission_dict[exclude_permission])].lower()
        != "false"
    ):
        raise AssertionError(
            f"{device}: permission toggle for '{permission_dict[exclude_permission]}' is not disabled: '{permission_toggle_state_list[delegate_permissions_list.index(permission_dict[exclude_permission])]}'"
        )
    click_back(device)
    common.wait_for_element(device, settings_dict, "user_title")


def verify_user_presence_cannot_be_changed_for_conf(device):
    common.click_if_present(device, home_screen_dict, "home_bar_icon")
    time.sleep(2)
    common.wait_for_and_click(device, navigation_dict, "Navigation")
    common.check_clickable_state(device, navigation_dict, "more_current_presence_btn", desired_state="false")
    common.wait_for_and_click(device, settings_dict, "user_displayname")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")


def add_emergency_location(device):
    device_ = common.device_emergency_location(device)
    emergency = device_.split(",")
    if len(emergency) < 6:
        raise ValueError(f"Invalid emergency location data: {device_}")
    streetnumber = emergency[0]
    streetname = emergency[1]
    city = emergency[2]
    state = emergency[3]
    postal_code = emergency[4]
    country_1 = emergency[5].capitalize()
    common.wait_for_element(device, settings_dict, "streetnumber").send_keys(streetnumber)
    common.wait_for_element(device, settings_dict, "streetname").send_keys(streetname)
    for i in range(2):
        common.scroll_the_page(
            device,
            common.wait_for_element(device, tr_device_settings_dict, "device_settings_scroll_view"),
            swiping="up",
        )
    common.wait_for_element(device, settings_dict, "city").send_keys(city)
    common.wait_for_element(device, settings_dict, "state").send_keys(state)
    common.wait_for_element(device, settings_dict, "postalcode").send_keys(postal_code)
    common.wait_for_and_click(device, settings_dict, "country")
    temp_country = common.get_dict_copy(settings_dict, "select_country", "country_select", country_1)
    common.wait_for_element(device, settings_dict, "countrylist")
    for i in range(3):
        if common.click_if_present(device, temp_country, "select_country"):
            break
        else:
            common.scroll_the_page(
                device, common.wait_for_element(device, settings_dict, "countrylist"), swiping="down"
            )
    if not country_1 == common.wait_for_element(device, temp_country, "select_country").text:
        raise AssertionError(f"{device} invalid country name")
    common.wait_for_and_click(device, settings_dict, "addbutton")


def verify_presence_of_location_not_detected_banner_in_calls_tab(device, action="verify"):
    if action.lower() not in ["verify", "add", "absence"]:
        raise ValueError(f"Invalid action: {action}. Allowed actions are 'verify', 'add', or 'absence'.")
    is_banner_present = common.is_element_present(device, calls_dict, "location_not_detected_banner")
    if action.lower() == "absence":
        assert not is_banner_present, "'location_not_detected_banner is not present'"
        return
    if is_banner_present:
        common.wait_for_element(device, calls_dict, "location_not_detected_banner")
        common.wait_for_element(device, calls_dict, "Dismiss_location_missing_banner_icon")
        if action.lower() == "verify":
            common.wait_for_element(device, calls_dict, "Add_your_location")
        elif action.lower() == "add":
            common.wait_for_and_click(device, calls_dict, "Add_your_location")
    else:
        print("Location is already added. No action required.")


def verify_delegate_permission(from_device, to_device):
    delegate_username = common.device_displayname(to_device)
    common.kb_trigger_search(from_device, settings_dict, "add_delegates", delegate_username)
    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", delegate_username)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container")
    validate_call_permissions(from_device)
    verify_default_options_enabled_while_adding_delegate_in_delegate_settings_page(from_device)
    common.return_to_home_screen(from_device)


def verify_and_click_queues_in_more_tab(device):
    home_screen_keywords.verify_home_screen_tiles(device)
    common.wait_for_and_click(device, app_bar_dict, "more_tab")
    common.wait_for_element(device, app_bar_dict, "reorder")
    common.wait_for_and_click(device, settings_dict, "queues")
    common.wait_for_element(device, settings_dict, "Opt_into_a_queue_to_receive_calls")


def verify_call_queue_name_on_agent(device):
    devices = device.split(",")
    for device in devices:
        common.wait_for_element(device, calls_dict, "behalf_calling_text")


def verify_call_queue_option_in_queue_tab(device):
    common.wait_for_element(device, settings_dict, "Opt_into_a_queue_to_receive_calls")
    common.wait_for_element(device, settings_dict, "call_queue_Test")
    common.wait_for_element(device, settings_dict, "call_queue_toggle_button")


def verify_and_click_on_queues_name(device, status="on"):
    common.wait_for_and_click(device, settings_dict, "call_queues_name")
    common.wait_for_element(device, settings_dict, "call_queue_Test")
    if status.lower() == "on":
        common.wait_for_element(device, settings_dict, "Opted-in")
    elif status.lower() == "off":
        common.wait_for_element(device, settings_dict, "Opted-out")
    common.wait_for_element(device, call_views_keywords.call_view_dict, "people_option")
    common.wait_for_element(device, app_bar_dict, "call_tab")
    if common.is_portrait_mode_cnf_device(device):
        common.wait_for_element(device, app_bar_dict, "Make_a_call")
    else:
        common.wait_for_element(device, calls_dict, "dial_pad")


def verify_people_tab_in_queues_name(device, status="on"):
    common.wait_for_and_click(device, call_views_keywords.call_view_dict, "people_option")
    common.wait_for_and_click(device, settings_dict, "leads")
    common.wait_for_element(device, settings_dict, "Observing")
    device_name = device_cq_displayname(device)
    if status.lower() == "on":
        user_name = common.get_all_elements_texts(device, people_dict, "contact_title")
        if not device_name in user_name:
            raise AssertionError(f"Display name not visible under Observing: '{device_name}'")
    common.wait_for_and_click(device, settings_dict, "Observing")
    for i in range(5):
        if common.is_element_present(device, settings_dict, "Opted_out_section"):
            if status.lower() == "off":
                user_name = common.get_all_elements_texts(device, people_dict, "contact_title")
                if not device_name in user_name:
                    raise AssertionError(f"Display name not visible under Opted_out: '{device_name}'")
            break
        common.scroll_the_page(
            device,
            common.wait_for_element(device, settings_dict, "people_tab_scroll_view_in_call_queues_name"),
            swiping="up",
        )


def verify_cq_call_log_in_calls_tab(device, to_device, status="Outgoing"):
    if status.lower() not in ["outgoing", "incoming"]:
        raise AssertionError(f"Illegal value for 'status': '{status}'")
    common.wait_for_element(device, settings_dict, "callqueues")
    contact_details = common.device_displayname(to_device)
    contact_details_phnumber = common.device_pstndisplay(to_device)
    refresh_calls_main_tab(device)
    call_log_name = common.get_all_elements_texts(device, calls_dict, "call_participant_name")
    if contact_details_phnumber != str(call_log_name[0]) or contact_details != call_log_name[0]:
        raise AssertionError(
            f"{device}: expected values {contact_details_phnumber} or {contact_details}  but  Displayed: '{call_log_name[0]}'"
        )
    call_status_and_call_duration = common.wait_for_element(device, calls_dict, "call_duration").text
    if status.lower() == "incoming":
        values = call_status_and_call_duration.split(":")
        condition = f"{status}:" + values[1]
        if condition.lower() not in call_status_and_call_duration.lower():
            raise AssertionError(f"{device} call status is not {status} and actutal :{call_status_and_call_duration}")
    elif status.lower() == "outgoing":
        values = call_status_and_call_duration.split(":")
        condition = f"{status}:" + values[1]
        if condition.lower() not in call_status_and_call_duration.lower():
            raise AssertionError(f"{device} call status is not {status} and actutal :{call_status_and_call_duration}")


def navigate_to_calls_in_queue_tab(device):
    common.wait_for_and_click(device, app_bar_dict, "call_tab")


def device_cq_displayname(device):
    device_name, account_type = common.decode_device_spec(device)
    devices = common.device_type(device)
    return config[devices][device_name]["cq_user"]["displayname"]


def verify_status_of_call_queue_toggle_button(device, status):
    common.verify_toggle_button(device, settings_dict, "call_queue_toggle_button", desired_state=status)
    if common.is_element_present(device, settings_dict, "Opt_into_a_queue_to_receive_calls"):
        if status.lower() == "on":
            common.wait_for_element(device, settings_dict, "Opted-in")
        elif status.lower() == "off":
            common.wait_for_element(device, settings_dict, "Opted-out")
    common.return_to_home_screen(device)


def navigate_call_queue_toogle_in_calling_settings(device):
    open_settings_page(device)
    common.wait_for_and_click(device, settings_dict, "Calling")
    for i in range(5):
        if common.is_element_present(device, settings_dict, "call_queue_toggle_button"):
            break
        common.scroll_the_page(
            device,
            common.wait_for_element(device, tr_device_settings_dict, "device_settings_scroll_view"),
            swiping="up",
        )
    common.wait_for_element(device, settings_dict, "call_queue_toggle_button")
    if not common.is_element_present(device, settings_dict, "callqueues"):
        for i in range(1):
            if common.is_element_present(device, settings_dict, "callqueues"):
                break
            common.scroll_the_page(
                device,
                common.wait_for_element(device, tr_device_settings_dict, "device_settings_scroll_view"),
                swiping="down",
            )
    common.wait_for_element(device, settings_dict, "callqueues")
    common.wait_for_element(device, settings_dict, "Disable_a_queue_to_opt_out")
    print(f"{device} call queues and disable a queue to opt out is present")


def verify_call_queues_section_is_absent_in_calling_settings(device):
    open_settings_page(device)
    common.wait_for_and_click(device, settings_dict, "Calling")
    for i in range(3):
        common.raise_if_present(device, settings_dict, "call_queue_toggle_button")
        common.scroll_the_page(
            device,
            common.wait_for_element(device, tr_device_settings_dict, "device_settings_scroll_view"),
            swiping="up",
        )


def verify_emergency_location(device):
    device_ = common.device_emergency_location(device)
    emergency = device_.replace(",", " ").split()
    emergency = " ".join([word.capitalize() if i == len(emergency) - 1 else word for i, word in enumerate(emergency)])
    temp_location = common.get_dict_copy(settings_dict, "set_your_emergency_location", "device_", emergency)
    txt = common.wait_for_element(device, temp_location, "set_your_emergency_location").text
    if not txt == emergency:
        raise AssertionError(f"{device} values are missing {temp_location}")


def verify_location_fields_are_empty_in_emergency_location(device):
    common.wait_for_and_click(device, settings_dict, "set_your_emergency_location")
    common.wait_for_element(device, settings_dict, "streetnumber").clear()
    common.wait_for_element(device, settings_dict, "streetname").clear()
    for i in range(2):
        common.scroll_the_page(
            device,
            common.wait_for_element(device, tr_device_settings_dict, "device_settings_scroll_view"),
            swiping="up",
        )
    common.wait_for_element(device, settings_dict, "city").clear()
    common.wait_for_element(device, settings_dict, "state").clear()
    common.wait_for_element(device, settings_dict, "postalcode").clear()
    common.wait_for_element(device, settings_dict, "addbutton")
    common.wait_for_element(device, settings_dict, "cancelbutton")


def verify_status_save_emergency_location_button(device, status):
    if status.lower() not in ["enabled", "disabled"]:
        raise ValueError(f"Invalid status: {status}. Allowed values are 'enabled' or 'disabled'.")
    add_button = common.wait_for_element(device, settings_dict, "addbutton")
    is_enabled = add_button.is_enabled()
    if status == "enabled":
        assert is_enabled, f"Expected 'add button' to be enabled on {device}, but it is disabled."
    elif status == "disabled":
        assert not is_enabled, f"Expected 'add button' to be disabled on {device}, but it is enabled."
    common.wait_for_and_click(device, settings_dict, "cancelbutton")


def enable_or_disable_call_queue_toggle(device, desired_state):
    change_queue_toggle_button(device, desired_state)


def enable_call_queue_toggle(device):
    enable_or_disable_call_queue_toggle(device, True)


def disable_call_queue_toggle(device):
    enable_or_disable_call_queue_toggle(device, False)


def change_queue_toggle_button(device, desired_state):
    actual_status_of_call_queues_toggle = common.return_toggle_status(device, settings_dict, "call_queue_toggle_button")
    print(
        f"before clicking: actual_attribute_state:{actual_status_of_call_queues_toggle} \ndesired_state:{desired_state}"
    )
    if actual_status_of_call_queues_toggle == desired_state:
        return print("Toggle is enabled")
    for i in range(3):
        actual_status_of_call_queues_toggle = verify_the_state_of_toggle_on_or_off(
            device, settings_dict, "call_queue_toggle_button"
        )
        if actual_status_of_call_queues_toggle == desired_state:
            break

    if actual_status_of_call_queues_toggle != desired_state:
        raise AssertionError(
            f"{device}: Toggle button:  call_queue_toggle_button,  did not change after clicking. Expected '{desired_state}', actual '{actual_status_of_call_queues_toggle}'"
        )


def verify_the_state_of_toggle_on_or_off(device, sel_dict, sel_dict_key):
    common.wait_for_and_click(device, sel_dict, sel_dict_key)
    common.sleep_with_msg(device, 3, "Let the element stabilize post click")
    actual_attribute_state_verify = common.return_toggle_status(device, sel_dict, sel_dict_key)
    return actual_attribute_state_verify


def verify_AA_and_CQ_configured_in_call_as_myself(from_device, to_device):
    if common.is_portrait_mode_cnf_device(from_device):
        for i in range(3):
            if common.is_element_present(from_device, calls_dict, "call_as_myself_arrow"):
                break
            common.wait_for_and_click(from_device, calls_dict, "Make_a_call")
    else:
        for i in range(3):
            if common.is_element_present(from_device, calls_dict, "call_as_myself_arrow"):
                break
            people_keywords.navigate_to_people_tab(from_device)
            voicemail_keywords.navigate_to_voicemail_tab(from_device)
            common.return_to_home_screen(from_device)
            call_keywords.click_on_calls_tab(from_device)
    common.wait_for_and_click(from_device, calls_dict, "call_as_myself_arrow")
    verify_option_inside_dropdown_diapad(from_device)
    call_device_name = shared_utils.getconfig_pstndisplay(to_device)
    element = common.wait_for_element(from_device, calls_dict, "entered_phn_num")
    element.clear()
    time.sleep(display_time)
    element.send_keys(call_device_name)
    common.wait_for_element(from_device, calendar_dict, "hang_up_btn")


def verify_option_inside_dropdown_diapad(device):
    list = common.wait_for_element(device, calls_dict, "user_name").text
    if list not in ["Call as myself", "Call as call_queue_new"]:
        raise AssertionError(f"{device} option not present")
    common.tap_outside_the_popup(device, common.wait_for_element(device, calls_dict, "call_as_myself_bottom_pop_up"))


def reboot_norden_or_console(device, paired_devices=None, paired_reboot_option="both"):
    # Paired devices:
    #   If specified, paired_devices are expected to reboot as specified by 'paired_reboot_option'.
    #   When a "console" is asked to reboot it CAN (depending on oem/model) offer 3 choices:
    #   - Just the console, just the paired MTRA, or both.
    #   - Default behavior is "both".
    #
    if paired_devices:
        if not paired_reboot_option:
            raise AssertionError(f"{device}: paired_devices specified but no paired_reboot_option")
        paired_devices = shared_utils.make_list(paired_devices)

    if paired_reboot_option:
        paired_reboot_option = paired_reboot_option.lower()  # normalize
        if paired_reboot_option not in {"controller", "mtra", "both"}:
            raise AssertionError(f"{device}: Invalid paired_reboot_option '{paired_reboot_option}'")

    # NOTE: this method is using 'oem', not 'model' - may be insufficient...
    _oem = shared_utils.getconfig_device_oem(device)
    print(
        f"{device} reboot_norden_or_console, oem={_oem}, paired_devices={paired_devices}, paired_reboot_option='{paired_reboot_option}'"
    )

    tr_app_settings_keywords.click_on_more_option(device)
    tr_settings_keywords.click_on_settings_page(device)
    tr_device_settings_keywords.click_on_device_settings_page(device)
    if _oem in ["washington"]:
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_and_click(device, tr_device_settings_dict, "restart")
        if shared_utils.getconfig_is_console_class(device):
            # get_screenshot("reboot_options", device_list=device, with_xml=True)
            # There should be 3 options. the console, the paired MTRA, or both.
            if not paired_reboot_option or paired_reboot_option == "controller":
                common.wait_for_and_click(device, tr_device_settings_dict, "reboot_option_btn")
            elif paired_reboot_option == "mtra":
                common.wait_for_and_click(device, tr_device_settings_dict, "reboot_option__mtra_btn")
            else:  # 'both'
                common.wait_for_and_click(device, tr_device_settings_dict, "reboot_option_both_btn")
        common.wait_for_and_click(device, tr_device_settings_dict, "continue", ignore_connection_drop=True)
    elif _oem in ["texas"]:
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings")
        common.wait_for_and_click(device, device_settings_dict, "ok", "xpath", ignore_connection_drop=True)
    elif _oem in ["alaska"]:
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings", "xpath1")
        if shared_utils.getconfig_is_console_class(device):
            common.wait_for_and_click(device, tr_device_settings_dict, "alaska_reboot", "xpath1")
            common.wait_for_and_click(
                device, tr_device_settings_dict, "alaska_reboot", "id1", ignore_connection_drop=True
            )
        else:
            common.wait_for_and_click(device, tr_device_settings_dict, "alaska_reboot", "xpath")
            common.wait_for_and_click(
                device, tr_device_settings_dict, "alaska_reboot", "id", ignore_connection_drop=True
            )
    elif _oem in ["california"]:
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings")
        common.wait_for_and_click(device, panels_device_settings_dict, "reboot_panel_option")
        common.wait_for_and_click(device, device_settings_dict, "ok", "xpath", ignore_connection_drop=True)
    elif _oem in ["arizona"]:
        if not shared_utils.getconfig_is_console_class(device):
            common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings")
            common.wait_for_and_click(device, panels_device_settings_dict, "reboot_panel_option")
            common.wait_for_and_click(device, device_settings_dict, "ok", "xpath", ignore_connection_drop=True)
    elif _oem in ["michigan"]:
        if not common.is_element_present(device, device_settings_dict, "system_settings"):
            common.wait_for_and_click(device, tr_device_settings_dict, "michigan_back_button")
        else:
            common.wait_for_and_click(device, device_settings_dict, "system_settings")
            common.sleep_with_msg(device, 3, "Transition to 'system_settings'")
            common.scroll_the_page(
                device,
                common.wait_for_element(device, tr_device_settings_dict, "device_settings_scroll_view"),
                swiping="up",
            )
            common.wait_for_and_click(device, settings_dict, "restart_btn", "id1", ignore_connection_drop=True)
            if shared_utils.getconfig_is_console_class(device):
                common.wait_for_and_click(device, settings_dict, "restart_btn", "xpath", ignore_connection_drop=True)
    elif _oem in ["Bangalore"]:
        common.wait_for_and_click(device, settings_dict, "Debug")
        e1 = common.wait_for_element(device, settings_dict, "admin_passwd")
        e1.send_keys(config["devices"][device]["admin_password"])
        common.wait_for_and_click(device, tr_device_settings_dict, "ok")
        common.wait_for_and_click(device, tr_device_settings_dict, "restart")
        common.wait_for_and_click(device, tr_device_settings_dict, "confirm")

    elif _oem in ["georgia"]:
        if shared_utils.getconfig_is_console_class(device):
            for i in range(3):
                if common.is_element_present(device, panels_device_settings_dict, "athens_debug"):
                    break
                device_settings_keywords.swipe_till_admin_settings(device)
            common.wait_for_and_click(device, panels_device_settings_dict, "athens_debug")
            e1 = common.wait_for_element(device, settings_dict, "admin_pass")
            _, _admin_pw = shared_utils.getconfig_admin_credentials(device)
            e1.send_keys(_admin_pw)
            common.wait_for_and_click(device, tr_device_settings_dict, "admin_pass_enter")
            common.wait_for_and_click(device, panels_device_settings_dict, "reboot_option_in_device_settings", "xpath1")
            common.wait_for_and_click(device, device_settings_dict, "ok", ignore_connection_drop=True)
        else:
            common.wait_for_and_click(device, settings_dict, "Debug")
            common.wait_for_and_click(
                device,
                panels_device_settings_dict,
                "reboot_option_in_device_settings",
                "xpath1",
                ignore_connection_drop=True,
            )
    else:
        raise AssertionError(f"{device}: No validation specified for device: '{_oem}'")
    if _oem in ["alaska", "georgia"] and shared_utils.getconfig_is_console_class(device):
        print("device connected through external cable with triggered system")
        common.sleep_with_msg(device, 110, f"waiting for '{_oem}' console: reboot complete")
        obj.re_setup_console_driver(device, config, root_console)
        return

    # Now wait for all rebooting devices to be reconnected:
    if paired_devices and paired_reboot_option == "mtra":
        # The device itself will not reboot, only the paired devices
        common.wait_for_device_restart_and_reconnect(paired_devices)
    else:
        _all_devices = shared_utils.make_list(device)
        if paired_devices:
            _all_devices.extend(paired_devices)

        common.wait_for_device_restart_and_reconnect(_all_devices)


def verify_phone_lock_status_in_device_settings(device, status="off"):
    if config["devices"][device]["oem"].lower() in ["washington", "california"]:
        common.wait_for_and_click(device, device_settings_dict, "phone_lock")
        common.wait_for_element(device, device_settings_dict, "phone_lock_toggle")
        common.verify_toggle_button(device, device_settings_dict, "phone_lock_toggle", status)
    elif config["devices"][device]["oem"].lower() in ["arizona"]:
        common.wait_for_and_click(device, device_settings_dict, "security_btn")
        common.wait_for_element(device, device_settings_dict, "Screen_lock")
        common.wait_for_element(device, device_settings_dict, "none_option")


def verify_and_click_on_more_info_icon_in_call_queue(device):
    common.wait_for_and_click(device, calls_dict, "call_participant_info_button")
    common.wait_for_element(device, calls_dict, "call")
    common.wait_for_element(device, calls_dict, "call_list_view_profile_action")
    common.wait_for_element(device, calls_dict, "add_user_to_speed_dial")


def verify_logging_option_is_enabled_admin_settings(device):
    open_settings_page(device)
    click_device_settings(device)
    device_settings_keywords.open_admin_settings(device)
    _model = shared_utils.getconfig_device_model(device)
    if _model in ["gilbert", "scottsdale"]:
        common.wait_for_element(device, settings_dict, "Account_Signout")
        common.wait_for_and_click(device, app_bar_dict, "back")
        device_settings_keywords.swipe_the_page_till_signout(device)
        device_settings_keywords.swipe_the_page_till_signout(device)
        common.wait_for_and_click(device, settings_dict, "Debugging_setting")
        common.wait_for_and_click(device, settings_dict, "logging_setting")
        common.wait_for_and_click(device, settings_dict, "Log_Level")
        common.wait_for_element(device, app_bar_dict, "cancel_btn")
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_element(device, settings_dict, "Log_Level")
        common.wait_for_and_click(device, calendar_dict, "back")

    elif _model in ["seattle", "olympia", "Redmond", "kirkland"]:
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_element(device, settings_dict, "logging_setting", "xpath")
        common.wait_for_and_click(device, calendar_dict, "back")

    elif _model in ["santa cruz_13", "bakersfield_13", "riverside_13"]:
        common.wait_for_element(device, settings_dict, "logging_setting")
        common.wait_for_and_click(device, calendar_dict, "back")

    else:
        raise AssertionError(f"Model {_model} not recognized")
    common.return_to_home_screen(device)


def set_log_level_from_Admin_settings(device):
    open_settings_page(device)
    click_device_settings(device)
    device_settings_keywords.open_admin_settings(device)
    _model = shared_utils.getconfig_device_model(device)
    if _model in ["gilbert", "scottsdale"]:
        common.wait_for_element(device, settings_dict, "Account_Signout")
        common.wait_for_and_click(device, app_bar_dict, "back")
        device_settings_keywords.swipe_the_page_till_signout(device)
        device_settings_keywords.swipe_the_page_till_signout(device)
        common.wait_for_and_click(device, settings_dict, "Debugging_setting")
        common.wait_for_and_click(device, settings_dict, "logging_setting")
        common.wait_for_and_click(device, settings_dict, "Log_Level")
        common.wait_for_element(device, app_bar_dict, "cancel_btn")
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_element(device, settings_dict, "Log_Level")
        common.wait_for_and_click(device, calendar_dict, "back")

    elif _model in ["seattle", "olympia", "Redmond", "kirkland"]:
        common.wait_for_and_click(device, settings_dict, "Debug")
        common.wait_for_element(device, settings_dict, "logging_setting", "xpath")
        common.wait_for_and_click(device, settings_dict, "Log_Level")
        common.wait_for_element(device, app_bar_dict, "cancel_btn")
        common.wait_for_and_click(device, settings_dict, "Log_Levels_in_admin")
        common.wait_for_and_click(device, calendar_dict, "back")
        common.wait_for_and_click(device, device_settings_dict, "save_btn")

    elif _model in ["santa cruz_13", "bakersfield_13", "riverside_13"]:
        common.wait_for_element(device, settings_dict, "logging_setting")
        common.wait_for_and_click(device, settings_dict, "Log_Level")
        common.wait_for_and_click(device, settings_dict, "Log_Levels_in_admin")
        common.wait_for_element(device, settings_dict, "Log_Level")
        common.wait_for_and_click(device, calendar_dict, "back")

    else:
        raise AssertionError(f"Model {_model} not recognized")
    common.return_to_home_screen(device)


def navigate_to_hamberger_menu_lock_icon(device):
    for _attempt in range(5):
        common.click_if_present(device, calls_dict, "Call_Back_Button")
        common.click_if_present(device, home_screen_dict, "home_bar_icon")
        if common.is_lcp(device):
            common.wait_for_and_click(device, lcp_homescreen_dict, "homescreen_menu")
            common.wait_for_and_click(device, lcp_homescreen_dict, "settings_icon")
            return
        elif common.click_if_present(device, navigation_dict, "Navigation"):
            break
        if _attempt == 5:
            raise AssertionError(f"{device} couldn't open navigation menu")
    time.sleep(1)
    common.wait_for_element(device, navigation_dict, "Set_status_message")
    common.wait_for_element(device, device_settings_dict, "connect_device")
    common.wait_for_element(device, navigation_dict, "hot_desk_btn")
    common.wait_for_element(device, navigation_dict, "Settings_button")
    common.wait_for_and_click(device, device_settings_dict, "Lock")


def verify_call_queues_new_badge(device, option):
    if option.lower() not in ["appear", "disappeared"]:
        raise AssertionError(f"{device}: Illegal option specified: {option}")
    common.wait_for_and_click(device, home_screen_dict, "more_option")
    if option.lower() == "appear":
        common.wait_for_element(device, settings_dict, "call_queue_new_badge")
    else:
        common.raise_if_present(device, settings_dict, "call_queue_new_badge")
    common.wait_for_and_click(device, home_screen_dict, "reorder")
    common.wait_for_and_click(device, lcp_homescreen_dict, "lcp_back_button")
