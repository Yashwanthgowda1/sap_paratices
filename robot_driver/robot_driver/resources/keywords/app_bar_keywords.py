import time
from appium.webdriver.common.mobileby import MobileBy
from Libraries.Selectors import load_json_file
from appium.webdriver.common.touch_action import TouchAction
from initiate_driver import obj_dev as obj
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
import voicemail_keywords
import calendar_keywords
import common
import re
import shared_utils
from resources.keywords import settings_keywords

display_time = 3
action_time = 3

app_bar_dict = load_json_file("resources/Page_objects/App_bar.json")
calls_dict = load_json_file("resources/Page_objects/Calls.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
common_dict = load_json_file("resources/Page_objects/Common.json")
call_view_dict = load_json_file("resources/Page_objects/Call_views.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
people_dict = load_json_file("resources/Page_objects/People.json")
navigation_dict = load_json_file("resources/Page_objects/Navigation.json")
walkie_talkie_dict = load_json_file("resources/Page_objects/walkie_talkie.json")
lcp_homescreen_dict = load_json_file("resources/Page_objects/lcp_homescreen.json")
home_screen_dict = load_json_file("resources/Page_objects/Home_screen.json")


def click_hide_more_apps(device):
    print("device :", device)
    common.wait_for_and_click(device, app_bar_dict, "hide_more_app_icon", selector_key="xpath")


def verify_available_app_present_on_screen(device):
    devices = device.split(",")
    # time.sleep(display_time)
    for device in devices:
        print("device :", device)
        driver = obj.device_store.get(alias=device)
        try:
            ele = []
            tab = driver.find_elements_by_id(app_bar_dict["available_app"]["id"])
            for app in tab:
                ele.append(app)
                print("Available apps", app)
        except Exception as e:
            raise AssertionError
        pass


def view_scheduled_meeting_entries(device):
    print("device :", device)
    calendar_keywords.refresh_for_meeting_visibility(device)
    common.get_all_elements_texts(device, calendar_dict, "meeting_title_name")


def click_reorder_option(device):
    print("device :", device)
    common.wait_for_and_click(device, app_bar_dict, "reorder")
    common.wait_for_element(device, app_bar_dict, "edit_navigation")


def click_save_button(device):
    common.wait_for_and_click(device, app_bar_dict, "save_button")


def verify_default_tabs_along_with_more_option(device):
    print("device :", device)
    common.wait_for_element(device, app_bar_dict, "call_tab")
    common.wait_for_element(device, app_bar_dict, "calendar_tab")
    common.wait_for_element(device, walkie_talkie_dict, "walkie_talkie_tab")
    common.wait_for_element(device, app_bar_dict, "more_tab")


def validate_home_screen_after_reorder_of_apps(device, tab):
    tabs = tab.split(",")
    for tab in tabs:
        if tab.lower() == "calls tab":
            if common.is_element_present(device, app_bar_dict, "call_tab", "xpath"):
                print(f"{device}: Calls Tab is present on the app bar")
            else:
                common.wait_for_and_click(device, calendar_dict, "app_bar_more")
                common.wait_for_element(device, app_bar_dict, "call_tab", "xpath")
                common.wait_for_and_click(device, common_dict, "hide_more_app_icon")
        elif tab.lower() == "calendar tab":
            if common.is_element_present(device, app_bar_dict, "calendar_tab", "xpath"):
                print(f"{device}: Calendar Tab is present on the app bar")
            else:
                common.wait_for_and_click(device, calendar_dict, "app_bar_more")
                if not common.is_element_present(device, app_bar_dict, "calendar_tab", "xpath"):
                    if not common.is_portrait_mode_cnf_device(device):
                        raise AssertionError(f"{device}: Calendar app not found on app bar")
                    if not common.is_element_present(device, calendar_dict, "app_bar_dialpad_icon"):
                        raise AssertionError(f"{device}: Calendar app not found on device")
                print(f"{device}: Calendar Tab is present inside more options")
                common.wait_for_and_click(device, common_dict, "hide_more_app_icon")
        elif tab.lower() == "people tab":
            if common.is_element_present(device, app_bar_dict, "people_tab", "xpath"):
                print(f"{device}: People Tab is present on the app bar")
            else:
                common.wait_for_and_click(device, calendar_dict, "app_bar_more")
                common.wait_for_element(device, app_bar_dict, "people_tab", "xpath")
                common.wait_for_and_click(device, common_dict, "hide_more_app_icon")
        elif tab.lower() == "voicemail tab":
            if common.is_element_present(device, app_bar_dict, "voicemail_tab", "xpath"):
                print(f"{device}: Voicemail Tab is present on the app bar")
            else:
                common.wait_for_and_click(device, calendar_dict, "app_bar_more")
                common.wait_for_element(device, app_bar_dict, "voicemail_tab", "xpath")
                common.wait_for_and_click(device, common_dict, "hide_more_app_icon")


def navigate_to_more_option(device):
    device, account = common.decode_device_spec(device)
    if account.lower() == "meeting_user":
        common.wait_for_and_click(device, app_bar_dict, "more_tab")
        return
    common.wait_for_and_click(device, app_bar_dict, "more_tab")
    if not common.is_element_present(device, app_bar_dict, "voicemail_tab", "xpath"):
        if not common.is_element_present(device, app_bar_dict, "walkie_talkie_tab"):
            common.wait_for_element(device, app_bar_dict, "people_tab")
    common.wait_for_element(device, app_bar_dict, "reorder")


def verify_favorites_and_recent_call_tab(device):
    print("device :", device)
    common.wait_for_element(device, app_bar_dict, "favorites_tab")
    common.wait_for_element(device, app_bar_dict, "recent_tab")
    common.wait_for_element(device, app_bar_dict, "Make_a_call")
    if not common.is_portrait_mode_cnf_device(device):
        common.wait_for_element(device, app_bar_dict, "call_icon", "xpath")


def validate_reorder_of_apps(device, tab, destination):
    if not tab.lower() in ["calendar tab", "people tab", "calls tab"]:
        raise AssertionError(f"Illegal tab specified: '{tab}'")
    if not destination.lower() in ["people tab", "calendar tab", "more tab"]:
        raise AssertionError(f"Illegal destination specified: '{destination}'")
    print("device :", device)
    print("Tab is :", tab)
    print("Destination is :", destination)
    common.wait_for_and_click(device, app_bar_dict, "more_tab")
    common.wait_for_and_click(device, app_bar_dict, "reorder")
    time.sleep(display_time)
    if tab.lower() == "calendar tab":
        if destination.lower() == "people tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "calendar_app", destination, app_bar_dict, "people_app"
            )
        else:
            raise AssertionError("Unable to move the source element to target element")
    elif tab.lower() == "people tab":
        if destination.lower() == "calendar tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "people_app", destination, app_bar_dict, "calendar_app"
            )
        else:
            raise AssertionError("Unable to move the source element to target element")
    elif tab.lower() == "calls tab":
        if destination.lower() == "more tab":
            common.perform_drag_and_drop(device, tab, app_bar_dict, "call_app", destination, app_bar_dict, "more_tab")
            print("Unable to move the app from main section to more section ")
            print("Two app should present on main screen")
        else:
            raise AssertionError("Able to Move the app from main section to more section")
    common.wait_for_and_click(device, app_bar_dict, "save_button")


def validate_drag_and_drop_app_from_one_section_to_other_section(device, tab, destination):
    print("device :", device)
    print("tab :", tab)
    print("destination :", destination)
    driver = obj.device_store.get(alias=device)
    time.sleep(display_time)
    apps_in_more_section = driver.find_elements_by_xpath(app_bar_dict["more_tab"]["xpath"])
    time.sleep(display_time)
    if len(apps_in_more_section) == 0:
        print("All apps are present on the main section")
        return
    if tab.lower() == "calls tab":
        if destination.lower() == "voicemail tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "call_app", destination, app_bar_dict, "voicemail_app"
            )
        elif destination.lower() == "calendar tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "call_app", destination, app_bar_dict, "calendar_app"
            )
            print("Come back to default setting")
        elif destination.lower() == "people tab":
            common.perform_drag_and_drop(device, tab, app_bar_dict, "call_app", destination, app_bar_dict, "people_app")
        elif destination.lower() == "walkie talkie tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "call_app", destination, walkie_talkie_dict, "walkie_talkie_tab"
            )
        else:
            raise AssertionError(f"Unexpected value for destination : {destination}")
    elif tab.lower() == "calendar tab":
        if destination.lower() == "voicemail tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "calendar_app", destination, app_bar_dict, "voicemail_app"
            )
        elif destination.lower() == "people tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "calendar_app", destination, app_bar_dict, "people_app"
            )
        else:
            raise AssertionError("None of the Tab matched with the Destination")
    elif tab.lower() == "people tab":
        if destination.lower() == "voicemail tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "people_app", destination, app_bar_dict, "voicemail_app"
            )
        elif destination.lower() == "calendar tab":
            common.perform_drag_and_drop(
                device, tab, app_bar_dict, "people_app", destination, app_bar_dict, "calendar_app"
            )
        else:
            raise AssertionError("None of the Tab matched with the Destination")
    elif tab.lower() == "voicemail tab":
        common.perform_drag_and_drop(device, tab, app_bar_dict, "voicemail_app", destination, app_bar_dict, "call_app")
    elif tab.lower() == "walkie talkie tab":
        common.perform_drag_and_drop(
            device, tab, walkie_talkie_dict, "walkie_talkie_tab", destination, app_bar_dict, "voicemail_app"
        )
    else:
        raise AssertionError(f"Unexpected value for tab : {tab}")
    common.wait_for_and_click(device, app_bar_dict, "save_button")
    common.sleep_with_msg(device, 3, "Wait for sometime post clicking on the save button")


def navigate_to_hidden_app_inside_more_option(device):
    # time.sleep(display_time)
    print("device :", device)
    driver = obj.device_store.get(alias=device)
    try:
        WebDriverWait(driver, 15).until(
            EC.element_to_be_clickable((MobileBy.ID, app_bar_dict["voicemail_tab"]["id"]))
        ).click()
        voicemail_keywords.navigate_to_voicemail_tab(device)
    except Exception as e:
        raise AssertionError("Navigate to Voicemail Tab is Failed")


def select_default_view_option(device, option):
    if option.lower() not in ["speed dial", "recent call history", "call dialpad"]:
        raise AssertionError(f"{device}: Unexpected value for option: {option}")
    if not common.is_portrait_mode_cnf_device(device) and option.lower() == "call dialpad":
        print(f"{device} is not a portrait mode device. Hence, dialpad is not supported under default view section")
        common.click_if_present(device, calls_dict, "Call_Back_Button")
        return
    common.wait_for_and_click(device, app_bar_dict, "Calling")
    swipe_page_up(device)
    common.wait_for_and_click(device, app_bar_dict, "default_view")
    if option.lower() == "speed dial":
        common.wait_for_and_click(device, app_bar_dict, "speed_dial")
    elif option.lower() == "recent call history":
        common.wait_for_and_click(device, app_bar_dict, "recent_call_history")
    elif option.lower() == "call dialpad":
        common.wait_for_and_click(device, app_bar_dict, "call_dialpad", "id")
    common.wait_for_and_click(device, app_bar_dict, "relaunch_btn")
    common.wait_for_element(device, calls_dict, "search")


def validate_default_app_present_on_main_screen(device):
    common.wait_for_element(device, app_bar_dict, "call_app")
    common.wait_for_element(device, people_dict, "people_app")


def swipe_page_up(device):
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
        print("Swiping co-ordinates : ", width / 8, 4 * (height / 5), width / 8, height / 5)
        driver.swipe(width / 8, 4 * (height / 5), width / 8, height / 5)
    pass


def verify_apps_under_more_option(device, tab=None):
    if ":" in device:
        user = device.split(":")[1]
        device = device.split(":")[0]
    else:
        user = "user"
    common.wait_for_and_click(device, calendar_dict, "app_bar_more")
    if user == "meeting_user":
        if common.is_portrait_mode_cnf_device(device):
            common.wait_for_element(device, calendar_dict, "app_bar_meet_now")
            common.wait_for_element(device, calendar_dict, "app_bar_dialpad_icon")
            common.wait_for_element(device, people_dict, "people_tab")
            common.wait_for_element(device, navigation_dict, "Settings_button")
            common.wait_for_element(device, navigation_dict, "what's_new")
            common.wait_for_element(device, calls_dict, "Call_Back_Button")
            return
        common.wait_for_element(device, app_bar_dict, "reorder")
    else:
        more_apps_list = common.get_all_elements_texts(device, app_bar_dict, "hidden_app_name")
        if tab is not None:
            tabs = tab.split(",")
            for tab_name in tabs:
                if tab_name.lower() not in more_apps_list:
                    raise AssertionError(f"{tab_name} is not present under more options")
    common.wait_for_and_click(device, app_bar_dict, "hide_more_app_icon")


def app_bar_feature(device):
    print("device :", device)
    if common.is_portrait_mode_cnf_device(device):
        status = "fail"
    else:
        status = "pass"
    return status


def Verify_line_keys_new_badge(device, option="disappeared"):
    common.wait_for_and_click(device, common_dict, "more_tab")
    if option.lower() == "appear":
        common.wait_for_element(device, app_bar_dict, "Line_Keys_badge")
    elif option.lower() == "disappeared":
        common.raise_if_present(device, app_bar_dict, "Line_Keys_badge")
    common.wait_for_element(device, app_bar_dict, "shared_lines")
    common.wait_for_and_click(device, app_bar_dict, "reorder")
    common.wait_for_and_click(device, lcp_homescreen_dict, "lcp_back_button")


def Verify_and_click_Line_keys_app_in_more_tab(device):
    common.wait_for_and_click(device, common_dict, "more_tab")
    common.wait_for_and_click(device, app_bar_dict, "Line_Keys_app")
    common.click_if_present(device, calls_dict, "parked_call_dismiss_button")
    common.wait_for_element(device, calls_dict, "search")
    common.wait_for_element(device, calls_dict, "call_park")
    common.wait_for_element(device, home_screen_dict, "home_bar_icon")
    common.wait_for_element(device, app_bar_dict, "Assign_line_key_options")
    common.wait_for_element(device, app_bar_dict, "Pages_with_Arrow_mark")


def Verify_and_click_assign_Line_key_inside_line_keys_app(device):
    common.wait_for_and_click(device, app_bar_dict, "Assign_line_key_options")
    common.wait_for_element(device, app_bar_dict, "Assign_line_key_header")
    common.wait_for_element(device, app_bar_dict, "Assign_line_key")
    common.wait_for_element(device, app_bar_dict, "Manage_line_keys")


def Verify_and_click_assign_Line_key_option_in_assign_Line_key(device):
    if common.is_element_present(device, app_bar_dict, "Assign_line_key"):
        common.wait_for_and_click(device, app_bar_dict, "Assign_line_key")
    common.wait_for_element(device, app_bar_dict, "speed_dial")
    common.wait_for_element(device, calls_dict, "Transfer")
    common.wait_for_element(device, app_bar_dict, "Consult_transfer")
    common.wait_for_element(device, app_bar_dict, "shared_lines")
    common.wait_for_element(device, app_bar_dict, "queues_tab")


def verify_and_click_speed_dial_option_in_assign_line_key_option(device):
    if common.is_element_present(device, app_bar_dict, "speed_dial"):
        common.wait_for_and_click(device, app_bar_dict, "speed_dial")
    common.wait_for_element(device, app_bar_dict, "Assign_line_key")
    common.wait_for_element(device, app_bar_dict, "contacts_details")
    common.wait_for_element(device, calls_dict, "search")
    common.wait_for_element(device, app_bar_dict, "Make_a_call")


def assign_username_in_line_keys(device, to_device):
    displayname = shared_utils.getconfig_displayname(to_device)
    print(f"diaplay name: {displayname}")
    common.wait_for_and_click(device, calls_dict, "search")
    common.wait_for_element(device, calls_dict, "search_contact_box").send_keys(displayname)
    name = common.wait_for_element(device, calls_dict, "search_result_item_container").text
    if name != displayname:
        raise AssertionError(f"{device}: Contact searched for: {displayname}, but search result obtained: {name}")
    common.wait_for_and_click(device, calls_dict, "search_result_item_container")
    common.wait_for_element(device, calls_dict, "call_park")
    contact_name = common.wait_for_element(device, app_bar_dict, "contacts_details").text
    print(f"diaplay name after assign: {contact_name}")
    if not re.search(displayname, contact_name):
        raise AssertionError(f"Line key is not updated: '{displayname}'")


def assign_default_suggested_contact_in_line_keys(device, to_device, manage_line_key="off"):
    common.wait_for_element(device, calls_dict, "search")
    displayname = shared_utils.getconfig_displayname(to_device)
    alluser_names = common.get_all_elements_texts(device, app_bar_dict, "contacts_details")
    print(f"All contact names found: {alluser_names}")
    if displayname not in alluser_names:
        raise AssertionError(f"User name is not visible : '{displayname}'")
    temp_dict = common.get_dict_copy(app_bar_dict, "contacts_details", "config_display", displayname)
    common.wait_for_and_click(device, temp_dict, "contacts_details", "xpath")
    if manage_line_key.lower() == "on":
        settings_keywords.device_setting_back(device)
    common.wait_for_element(device, calls_dict, "call_park")
    after_assign = common.wait_for_element(device, app_bar_dict, "contacts_details").text
    print(f"display name after assign: {after_assign}")
    if displayname not in after_assign:
        raise AssertionError(f"Line key is not updated: '{displayname}'")


def click_on_assigned_line_key_with_speed_dial(device):
    common.wait_for_and_click(device, app_bar_dict, "Assign_line_key_options")
    common.click_if_present(device, calls_dict, "myself_xpath")
    common.wait_for_element(device, calls_dict, "Decline_call_button")


def long_press_on_assigned_username(device):
    driver = obj.device_store.get(alias=device)
    if driver is None:
        raise ValueError(f"Device with alias '{device}' not found in device store.")
    elem = common.wait_for_element(device, app_bar_dict, "Assign_line_key_options")
    actions = TouchAction(driver)
    actions.long_press(elem, duration=5000).perform()
    common.wait_for_element(device, app_bar_dict, "Assign_line_key_header")
    common.wait_for_element(device, app_bar_dict, "Reassign_line_key")
    common.wait_for_element(device, app_bar_dict, "Unassign_line_key")
    common.wait_for_element(device, app_bar_dict, "Manage_line_keys")


def click_on_reassign_line_key_option(device):
    common.wait_for_and_click(device, app_bar_dict, "Reassign_line_key")
    Verify_and_click_assign_Line_key_option_in_assign_Line_key(device)


def click_on_unassign_line_key_option(device):
    before_unassing = common.wait_for_element(device, app_bar_dict, "contacts_details").text
    print(f"{device}: diaplay name before unassign {before_unassing}")
    driver = obj.device_store.get(alias=device)
    elem = common.wait_for_element(device, app_bar_dict, "Assign_line_key_options")
    actions = TouchAction(driver)
    actions.long_press(elem, duration=5000).perform()
    if common.is_element_present(device, app_bar_dict, "Unassign_line_key"):
        common.wait_for_and_click(device, app_bar_dict, "Unassign_line_key")
        common.wait_for_element(device, calls_dict, "call_park")
        after_unassign = common.wait_for_element(device, app_bar_dict, "contacts_details").text
        print(f"{device}: diaplay name after unassign {after_unassign}")
        if before_unassing == after_unassign:
            raise AssertionError(f"Line key is not Unassigned: '{before_unassing}'")
    else:
        print(f"{device}:Line keys are Unassigned: '{before_unassing}'")


def click_on_dial_pad_in_speed_dial_option(device, to_device):
    common.wait_for_element(device, calls_dict, "search")
    common.wait_for_and_click(device, app_bar_dict, "Make_a_call")
    common.wait_for_element(device, calls_dict, "call_park")
    phone_number = shared_utils.getconfig_phonenumber(to_device)
    print(f"Actual phone number: {phone_number}")
    if not common.is_element_present(device, calls_dict, "soft_dial_pad"):
        common.wait_for_element(device, calls_dict, "use_hard_keys_to_dial_a_number")
    common.wait_for_element(device, calls_dict, "entered_phn_num").send_keys(phone_number)
    common.wait_for_and_click(device, calls_dict, "call_as_myself")
    common.wait_for_element(device, calls_dict, "call_park")
    after_assign = common.wait_for_element(device, app_bar_dict, "contacts_details").text
    target_number = str().join(re.findall(r"\d+", after_assign))
    print(f"Expected phone number: {target_number}")
    if phone_number != target_number:
        raise AssertionError(f"Line key is not updated: '{phone_number}'")


def verify_and_click_on_transfer_option_in_assign_line_key_option(device):
    common.wait_for_element(device, app_bar_dict, "Assign_line_key_header")
    common.wait_for_and_click(device, calls_dict, "Transfer")
    verify_and_click_speed_dial_option_in_assign_line_key_option(device)


def verify_and_click_on_consult_transfer_option_in_assign_line_key_option(device):
    common.wait_for_element(device, app_bar_dict, "Assign_line_key_header")
    common.wait_for_and_click(device, app_bar_dict, "Consult_transfer")
    verify_and_click_speed_dial_option_in_assign_line_key_option(device)


def click_on_dial_pad_in_transfer_option(device, to_device):
    click_on_dial_pad_in_speed_dial_option(device, to_device)


def click_on_dial_pad_in_consult_transfer_option(device, to_device):
    click_on_dial_pad_in_speed_dial_option(device, to_device)


def verify_and_add_user_to_queue_in_linekey(device):
    common.wait_for_and_click(device, app_bar_dict, "queues_tab")
    common.sleep_with_msg(device, 5, "wait for load the refresh the pages load")
    common.wait_for_and_click(device, calls_dict, "Call_Queue_long_name")


def assing_queue_agent_to_linekey(device):
    common.wait_for_element(device, calls_dict, "search")
    alluser_names = common.get_all_elements_texts(device, app_bar_dict, "contacts_details")
    expected_prefixes = ["Call_Que", "New_Dynamic", "Dynamic_Agents"]
    if not any(any(prefix in name for name in alluser_names) for prefix in expected_prefixes):
        raise AssertionError(f"The received value is incorrect: {alluser_names}")


def verify_assigned_queue_user_remains_same_position(device):
    alluser_names = common.get_all_elements_texts(device, app_bar_dict, "contacts_details")
    expected_keywords = ["Call_Que", "New_Dynamic", "Dynamic_Agents"]
    first_user = alluser_names[0]
    if not any(keyword in first_user for keyword in expected_keywords):
        raise AssertionError(f"The top user '{first_user}' is incorrect. Full list: {alluser_names}")


def click_assigned_user_on_line_key_and_verify(device):
    common.wait_for_and_click(device, app_bar_dict, "contacts_details")
    print("the assigned user clicked on")


def verify_and_add_user_manage_line_keys(device, page=0, landscape="left"):
    common.wait_for_and_click(device, calls_dict, "Manage_line_keys_header")
    _oem_model = shared_utils.getconfig_device_model(device)
    page_list = common.get_all_elements_texts(device, calls_dict, "manage_line_keys_options_inside")
    print("All the pages: ", page_list)
    _actual_page = page_list[page]
    print("the __actual_page", {_actual_page})
    all_values = common.get_dict_copy(calls_dict, "manage_line_keys_options_inside", "Page", _actual_page)
    common.wait_for_and_click(device, all_values, "manage_line_keys_options_inside")
    if _oem_model in ["Santa Cruz", "Santa Cruz_13", "Bakersfield", "Bakersfield_13"]:
        if landscape.lower() == "left":
            common.wait_for_and_click(device, calls_dict, "land_scape_manage_line_key_left")
        elif landscape.lower() == "right":
            common.wait_for_and_click(device, calls_dict, "land_scape_manage_line_key_right")
    common.wait_for_and_click(device, calls_dict, "click_plus_icon_manage_line_key")


def verify_add_queue_agent_in_manage_sections(device):
    common.wait_for_and_click(device, calls_dict, "delete_assign_user_in_manage_line_keys")
    common.raise_if_present(device, calls_dict, "delete_assign_user_in_manage_line_keys")


def verify_and_click_on_shared_line_option_in_assign_line_key_option(
    device, people_you_support_user, circular_delegation_user
):
    Verify_and_click_assign_Line_key_option_in_assign_Line_key(device)
    Dut_username = shared_utils.getconfig_displayname(device)
    Boss_username = shared_utils.getconfig_displayname(people_you_support_user)
    circular_delegation_username = shared_utils.getconfig_displayname(circular_delegation_user)
    common.wait_for_and_click(device, app_bar_dict, "shared_lines")
    common.wait_for_element(device, app_bar_dict, "Personal_Shared_Line", "xpath")
    name = common.wait_for_element(device, app_bar_dict, "Personal_Shared_Line", "xpath1").text
    print(f"diaplay name: {name}")
    if name != Dut_username:
        raise AssertionError(f"Expected condition to be True, but got False username: '{Dut_username}'")
    common.wait_for_element(device, app_bar_dict, "No_active_calls", "id")

    common.wait_for_element(device, app_bar_dict, "People_you_support", "xpath")
    name = common.wait_for_element(device, app_bar_dict, "People_you_support", "xpath1").text
    print(f"diaplay name: {name}")
    if name != Boss_username:
        raise AssertionError(f"Expected condition to be True, but got False username: '{Boss_username}'")
    common.wait_for_element(device, app_bar_dict, "No_active_calls", "xpath")

    common.wait_for_element(device, app_bar_dict, "Circular_delegation")
    name = common.wait_for_element(device, app_bar_dict, "Circular_delegation", "xpath1").text
    print(f"diaplay name: {name}")
    if name != circular_delegation_username:
        raise AssertionError(f"Expected condition to be True, but got False username: '{circular_delegation_username}'")
    common.wait_for_element(device, app_bar_dict, "No_active_calls", "xpath1")


def assign_linekey_user(device, option, people_you_support_user=None, circular_delegation_user=None):
    if option.lower() not in ["personal shared line", "people you support", "circular delegation"]:
        raise AssertionError(f"{device}: Unexpected value for option: {option}")
    Dut_username = shared_utils.getconfig_displayname(device)
    name = common.wait_for_element(device, app_bar_dict, "People_you_support", "xpath").text
    if option.lower() == name.lower():
        print(f"option: {option.lower()}")
        name = common.wait_for_element(device, app_bar_dict, "People_you_support", "xpath1").text
        Boss_username = shared_utils.getconfig_displayname(people_you_support_user)
        if name != Boss_username:
            raise AssertionError(f"Expected condition to be True, but got False username: '{Boss_username}'")
        common.wait_for_and_click(device, app_bar_dict, "People_you_support", "xpath1")
        common.wait_for_element(device, calls_dict, "call_park")
        after_assign = common.wait_for_element(device, app_bar_dict, "contacts_details").text
        print(f"diaplay name after assign: {after_assign}")
        if not re.search(Boss_username, after_assign):
            raise AssertionError(f"Line key is not updated: '{Boss_username}'")
        return

    name = common.wait_for_element(device, app_bar_dict, "Circular_delegation").text
    if option.lower() == name.lower():
        circular_delegation_username = shared_utils.getconfig_displayname(circular_delegation_user)
        name = common.wait_for_element(device, app_bar_dict, "Circular_delegation", "xpath1").text
        print(f"diaplay name: {name}")
        if name != circular_delegation_username:
            raise AssertionError(
                f"Expected condition to be True, but got False username: '{circular_delegation_username}'"
            )
        common.wait_for_and_click(device, app_bar_dict, "Circular_delegation", "xpath1")
        common.wait_for_element(device, calls_dict, "call_park")
        after_assign = common.wait_for_element(device, app_bar_dict, "contacts_details").text
        print(f"diaplay name after assign: {after_assign}")
        if not re.search(circular_delegation_username, after_assign):
            raise AssertionError(f"Line key is not updated: '{circular_delegation_username}'")

    else:
        name = common.wait_for_element(device, app_bar_dict, "Personal_Shared_Line", "xpath1").text
        print(f"diaplay name: {name}")
        if name != Dut_username:
            raise AssertionError(f"Expected condition to be True, but got False username: '{Dut_username}'")
        common.wait_for_and_click(device, app_bar_dict, "Personal_Shared_Line", "xpath1")
        common.wait_for_element(device, calls_dict, "call_park")
        temp_dict = common.get_dict_copy(app_bar_dict, "contacts_details", "config_display", Dut_username)
        common.wait_for_element(device, temp_dict, "contacts_details", "xpath1")
        circular_delegation_username = shared_utils.getconfig_displayname(circular_delegation_user)
        temp_dict = common.get_dict_copy(
            app_bar_dict, "contacts_details", "config_display", circular_delegation_username
        )
        common.wait_for_element(device, temp_dict, "contacts_details", "xpath1")


def click_on_assigned_linekey_username(device, to_device):
    username = shared_utils.getconfig_displayname(device)
    to_device_user = shared_utils.getconfig_displayname(to_device)
    name = common.wait_for_element(device, app_bar_dict, "contacts_details").text
    if name == username:
        temp_dict = common.get_dict_copy(app_bar_dict, "contacts_details", "config_display", to_device_user)
        common.wait_for_and_click(device, temp_dict, "contacts_details", "xpath1")
        common.click_if_present(device, calls_dict, "myself_xpath")
        common.wait_for_element(device, calls_dict, "Hang_up_button")

    else:
        name = common.wait_for_element(device, app_bar_dict, "contacts_details").text
        print(f"diaplay name: {name}")
        if name != to_device_user:
            raise AssertionError(f"Expected condition to be True, but got False username: '{to_device_user}'")
        common.wait_for_and_click(device, app_bar_dict, "contacts_details")
        common.click_if_present(device, calls_dict, "myself_xpath")
        common.wait_for_element(device, calls_dict, "Hang_up_button")


def verify_and_click_on_assigned_transfer_or_consult_transfer_line_key(device, to_device, option):
    if not option.lower() in ["transfer", "consult transfer"]:
        raise AssertionError(f"{device}: Unexpected value for option: {option}")
    common.wait_for_element(device, calls_dict, "call_park")
    common.wait_for_element(device, home_screen_dict, "home_bar_icon")
    common.wait_for_element(device, app_bar_dict, "Pages_with_Arrow_mark")
    if option.lower() == "transfer":
        common.wait_for_and_click(device, app_bar_dict, "contacts_details", "id1")
        common.wait_for_element(to_device, calls_dict, "Accept_call_button")
    elif option.lower() == "consult transfer":
        common.wait_for_and_click(device, app_bar_dict, "contacts_details", "id1")
        common.wait_for_and_click(device, calls_dict, "myself_xpath")
        common.wait_for_and_click(to_device, calls_dict, "Accept_call_button")
        common.wait_for_and_click(device, calls_dict, "line_key_transfer")


def verify_presence_of_in_a_call_status_in_linekey(device):
    common.wait_for_element(device, calls_dict, "call_park")
    common.wait_for_element(device, app_bar_dict, "In_a_call")
