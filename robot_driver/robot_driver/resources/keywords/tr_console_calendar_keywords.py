from appium.webdriver.common.mobileby import MobileBy

import tr_calendar_keywords
from initiate_driver import obj_dev as obj
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from initiate_driver import config
from Libraries.Selectors import load_json_file
import common
import time
import calendar_keywords
import tr_console_settings_keywords
import settings_keywords
import call_keywords
import subprocess
import tr_home_screen_keywords
from datetime import datetime, timedelta

wait_time = 5
display_time = 2
action_time = 3
refresh_time = 10

tr_calendar_dict = load_json_file("resources/Page_objects/tr_calendar.json")
calls_dict = load_json_file("resources/Page_objects/Calls.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
tr_settings_dict = load_json_file("resources/Page_objects/tr_settings.json")
tr_console_signin_dict = load_json_file("resources/Page_objects/rooms_console_signin.json")
tr_device_settings_dict = load_json_file("resources/Page_objects/tr_device_settings.json")
tr_calls_dict = load_json_file("resources/Page_objects/tr_calls.json")
tr_home_screen_dict = load_json_file("resources/Page_objects/tr_home_screen.json")
tr_console_home_screen_dict = load_json_file("resources/Page_objects/rooms_console_home_screen.json")
tr_console_calls_dict = load_json_file("resources/Page_objects/rooms_console_calls.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
tr_console_calendar_dict = load_json_file("resources/Page_objects/rooms_console_calendar.json")
rooms_console_calender_dict = load_json_file("resources/Page_objects/rooms_console_calendar.json")
tr_console_settings_dict = load_json_file("resources/Page_objects/rooms_console_settings.json")
panels_home_screen_dict = load_json_file("resources/Page_objects/panels_homescreen.json")
web_signin_dict = load_json_file("resources/Page_objects/Web_signin.json")


def join_a_meeting(console, device=None, meeting="test_meeting"):
    print(
        "joins meeting named test_meeting by default unless stated otherwise; Meeting : ",
        meeting,
    )
    consoles = console.split(",")
    for console in consoles:
        print("console :", console)
        _max_attempts = 15
        list_of_meetings = []
        if ":" in meeting:
            meeting = common.device_displayname(meeting)
        m_list = common.get_all_elements_texts(console, calendar_dict, "meeting_title_name", "xpath")
        print(f"meeting title names:{m_list}")
        for _attempt in range(_max_attempts):
            if meeting in m_list:
                print(f"{console}: After scrolling {_attempt} times found meeting: '{meeting}'")
                break
            tr_calendar_keywords.scroll_up_meeting_tab(console)
            m_list.extend(common.get_all_elements_texts(console, calendar_dict, "meeting_title_name", "xpath"))
            if _attempt == _max_attempts - 1:
                raise AssertionError(f"{console}: After scrolling {_attempt} times meeting did not appear: '{meeting}'")
        meeting_list = common.wait_for_element(
            console, calendar_dict, "meeting_title_name", "xpath", cond=EC.presence_of_all_elements_located
        )
        join_button_list = common.wait_for_element(
            console, calendar_dict, "cnf_device_join_button", "xpath", cond=EC.presence_of_all_elements_located
        )
        if len(meeting_list) < len(join_button_list):
            join_button_list = join_button_list[1:]
            if len(meeting_list) != len(join_button_list):
                raise AssertionError(
                    f"Number of meetings displayed: {len(meeting_list)} is not equal to number of join buttons: {len(join_button_list)}"
                )
        for i in meeting_list:
            list_of_meetings.append(str(i.text))
        print("List of Meeting displayed on home screen :", list_of_meetings)
        meeting_position = 0
        search_attempt = 1
        for _meeting in list_of_meetings:
            if _meeting.lower() == meeting.lower():
                meeting_position = list_of_meetings.index(_meeting)
                print("Expected Meeting is displayed on screen : ", _meeting)
                break
            search_attempt += 1
            if search_attempt == len(list_of_meetings) + 1:
                raise AssertionError(f"Expected meeting: {meeting} is not displayed")
        print("Meeting is display at position  : ", meeting_position)
        join_button_list[meeting_position].click()
        print("Clicked Join button on device : ", console)
    if device is not None:
        calendar_keywords.join_meeting(device, meeting)
    if console is not None and meeting.lower() == "webex_meeting":
        common.sleep_with_msg(device, 15, "waiting for third party meeting start UI load")


def verify_meeting_display_on_home_page(console):
    consoles = console.split(",")
    for console in consoles:
        print("console :", console)
        elem1 = common.wait_for_element(console, tr_console_calendar_dict, "meeting_list_name")
        print("meeting name is :", elem1.text)
        elem2 = common.wait_for_element(console, tr_console_calendar_dict, "meeting_time")
        print("Meeting time is :", elem2.text)
        elem3 = common.wait_for_element(console, tr_console_calendar_dict, "meeting_organizer_name")
        print("meeting_organizer name is : ", elem3.text)
        common.wait_for_element(console, calendar_dict, "cnf_device_join_button_id")
        common.wait_for_element(console, tr_console_calendar_dict, "meeting_logo")


def verify_and_view_list_of_participant(console):
    print("Device : ", console)
    added_participant_list = []
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_element(console, tr_console_calendar_dict, "invite_someone_box")
    call_roster_header = common.wait_for_element(console, tr_calls_dict, "call_roster_header").text
    call_roster_list = int(call_roster_header.split()[-1].replace("(", "").replace(")", ""))
    print("Call roster list : ", call_roster_list)
    time.sleep(action_time)
    participant_list = common.get_all_elements_texts(console, calls_dict, "call_participant_name")
    for participant in participant_list:
        added_participant_list.append(participant)
    if call_roster_list == 2:
        print("Participants List : ", added_participant_list[:2])
    elif call_roster_list == 3:
        print("Participants List : ", added_participant_list[:3])
    else:
        print("Participants List : ", added_participant_list)
    print("Participants List : ", added_participant_list)
    return added_participant_list


def verify_start_recording_notification_display_on_screen(device):
    common.wait_for_element(device, tr_calls_dict, "recording_notification")


def verify_functionality_of_volume_button(console, button, state=None):
    if button.lower() not in ["up", "down"]:
        raise AssertionError(f"Invalid 'state' requested: {button}")
    if state is not None:
        if common.is_element_present(console, calls_dict, "Hang_up_button"):
            print(f"{console} : Call control visible on screen")
        else:
            tr_console_settings_keywords.tap_on_device_center_point(console)
            print(f" {console} : Clicked on center point")
    common.wait_for_element(console, tr_console_calls_dict, "volume_icon")
    if button.lower() == "up":
        if common.is_element_present(console, tr_console_calls_dict, "volume_plus"):
            common.wait_for_and_click(console, tr_console_calls_dict, "volume_plus")
        else:
            raise AssertionError(f"{console} : Volume Up button is not visible")
    elif button.lower() == "down":
        if common.is_element_present(console, tr_console_calls_dict, "volume_minus"):
            common.wait_for_and_click(console, tr_console_calls_dict, "volume_minus")
        else:
            raise AssertionError(f"{console} : Volume down button is not visible")


def start_meet_now_meeting(from_device, to_device, method):
    if method.lower() not in ["display_name", "phone_number"]:
        raise AssertionError(f"Unexpected value for method: {method}")
    print("from_device :", from_device)
    print("to_device :", to_device)
    if ":" in to_device:
        user = to_device.split(":")[1]
        print("User account : ", user)
        account = None
        if user.lower() == "meeting_user":
            account = "meeting_user"
    else:
        account = "user"
    print("Account :", account)
    to_device = to_device.split(":")[0]
    print("to_device : ", to_device)
    common.wait_for_and_click(from_device, tr_console_home_screen_dict, "meet_now_icon")
    if "console" in from_device:
        device_name = "consoles"
    else:
        device_name = "devices"
    udid_ = config[device_name][from_device]["desired_caps"]["udid"]
    if method.lower() == "display_name":
        if "device" in from_device:
            displayname = config["consoles"][to_device][account]["displayname"]
            common.wait_for_and_click(from_device, tr_calls_dict, "Add_participants_btn")

        else:
            displayname = config["devices"][to_device][account]["displayname"]
            print("Search text :", displayname)
        common.wait_for_and_click(from_device, calls_dict, "search_contact_box")
        # element = common.wait_for_element(from_device, calls_dict, "search_contact_box")
        print("Invite someone Screen is visible")
        cmd = "adb -s " + udid_ + " shell input text " + displayname
        subprocess.run(cmd, stdout=subprocess.PIPE, shell=True)
        # element.send_keys(displayname)
        time.sleep(display_time)
        print("participant list is available during the search")
    elif method.lower() == "phone_number":
        if "device" in from_device:
            phonenumber = config["consoles"][to_device][account]["phonenumber"]
        else:
            phonenumber = config["devices"][to_device][account]["phonenumber"]
        print("Phone Number : ", phonenumber)
        common.wait_for_and_click(from_device, calls_dict, "search_contact_box")
        cmd = "adb -s " + udid_ + " shell input text " + phonenumber
        subprocess.run(cmd, stdout=subprocess.PIPE, shell=True)
        # ele = common.wait_for_element(from_device, calls_dict, "search_contact_box")
        # ele.send_keys(phonenumber)
    common.wait_for_and_click(from_device, calls_dict, "search_result_item_container", "id")
    common.wait_for_element(to_device, tr_calls_dict, "accept_button")


def add_participant_to_the_conversation(from_device, to_device, method):
    if method.lower() not in ["display_name", "phone_number"]:
        raise AssertionError(f"Unexpected value for method: {method}")
    print("from_device :", from_device)
    to_devices = to_device.split(",")
    print("Devices : ", to_devices)
    print("Method : ", method)
    devices = []
    accounts = []
    for device in to_devices:
        if ":" in device:
            user = device.split(":")[1]
            print("User account : ", user)
            if user.lower() == "pstn_user":
                account = "pstn_user"
            elif user.lower() == "meeting_user":
                account = "meeting_user"
            else:
                account = "user"
        else:
            account = "user"
        print("Account :", account)
        device = device.split(":")[0]
        print("device : ", device)
        devices.append(device)
        accounts.append(account)
    print("Devices : ", devices)
    print("Accounts : ", accounts)
    time.sleep(3)
    if "console" in from_device:
        device_name = "consoles"
    else:
        device_name = "devices"
    udid_ = config[device_name][from_device]["desired_caps"]["udid"]
    if not common.is_element_present(from_device, calls_dict, "Hang_up_button"):
        tr_console_settings_keywords.tap_on_device_center_point(from_device)
    if "console" in from_device:
        common.wait_for_and_click(from_device, tr_console_calendar_dict, "search_icon")
    else:
        calendar_keywords.navigate_to_add_participant_page(from_device)
        if not common.click_if_present(from_device, tr_calls_dict, "add_participants"):
            common.wait_for_and_click(from_device, calls_dict, "add_people_to_meeting")
    # element = common.wait_for_element(from_device, tr_console_calendar_dict, "invite_someone_box", "id")
    if method.lower() == "display_name":
        for device, account in zip(devices, accounts):
            print("Device and Account : ", device, account)
            if "console" in from_device:
                displayname = config["devices"][device][account]["displayname"]
                username = config["devices"][device][account]["username"].split("@")[0]
            else:
                displayname = config["consoles"][device][account]["displayname"]
                username = config["consoles"][device][account]["username"].split("@")[0]
            print("Adding Device with user name : ", device, username, displayname)
            cmd = "adb -s " + udid_ + " shell input text " + displayname
            subprocess.run(cmd, stdout=subprocess.PIPE, shell=True)
            # element.send_keys(displayname)
            time.sleep(display_time)
            print("Display name entered into the edit box")
            if "console" not in from_device:
                if config["devices"][from_device]["model"].lower() not in [
                    "spokane",
                    "sammamish",
                    "vancouver",
                    "pullman",
                ]:
                    common.hide_keyboard(from_device)
            # tmp_dict = common.get_dict_copy(
            #     tr_console_calendar_dict, "search_result_user_name", "user_name", displayname
            # )
            # common.wait_for_and_click(from_device, tmp_dict, "search_result_user_name")
            common.wait_for_and_click(from_device, calls_dict, "search_result_item_container", "id")
    elif method.lower() == "phone_number":
        for device, account in zip(devices, accounts):
            print("Device and Account : ", device, account)
            if "console" in from_device:
                phonenumber = config["devices"][device][account]["phonenumber"]
                pstn_display = config["devices"][device][account]["pstndisplay"]
            else:
                phonenumber = config["consoles"][device][account]["phonenumber"]
                pstn_display = config["consoles"][device][account]["pstndisplay"]
            print("Adding Device :", device)
            print("Phone Number : ", phonenumber)
            cmd = "adb -s " + udid_ + " shell input text " + phonenumber
            subprocess.run(cmd, stdout=subprocess.PIPE, shell=True)
            # element.send_keys(pstn_display)
            print("Entered phone number into edit box")
            common.wait_for_and_click(from_device, tr_console_calendar_dict, "search_result_user_name")
            common.sleep_with_msg(from_device, 2, "Wait for keyboard to hide")


def verify_show_meeting_names_toggle_btn_status(console):
    print("Console :", console)
    common.wait_for_element(console, tr_calendar_dict, "show_meeting_names_text")
    meeting_name_toggle_btn_status = common.wait_for_element(console, tr_calendar_dict, "meeting_names_on_toggle").text
    if meeting_name_toggle_btn_status == "ON":
        print("Show meeting names toggle btn is enabled")
    elif meeting_name_toggle_btn_status == "OFF":
        common.wait_for_and_click(console, tr_calendar_dict, "meeting_names_on_toggle")


def get_meeting_details(console):
    meeting_name_title = common.wait_for_element(console, calendar_dict, "meeting_title_name").text
    meeting_name = meeting_name_title[::]
    print("Meeting name is :", meeting_name)
    return meeting_name


def click_back_btn(console):
    print("Console :", console)
    common.wait_for_and_click(console, tr_console_calendar_dict, "back_btn")


def validate_the_functionality_of_meeting_names_toggle_btn(console, state):
    print("Console:", console)
    print("State:", state)
    common.wait_for_element(console, tr_calendar_dict, "show_meeting_names_text")
    common.change_toggle_button(console, tr_calendar_dict, "meeting_names_toggle", state)


def join_the_meeting(console, organizer_name):
    join_a_meeting(console, meeting=organizer_name)
    console = console.split(":")[0]
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    actual_meeting = common.wait_for_element(console, tr_calendar_dict, "meeting_action_bar_title_text").text
    meeting = ["all_day_meeting", "all_day_meeting1", "rooms_console_meeting", "console_lock_meeting"]
    if actual_meeting.lower() not in [m.lower() for m in meeting]:
        raise AssertionError(f"{console} is not joined in the expected meeting {actual_meeting}")


def mute_all_active_participants(console):
    print("Mute all the participants from device : ", console)
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_element(console, tr_console_calendar_dict, "invite_someone_box")
    common.wait_for_and_click(console, calendar_dict, "Mute_all", "xpath1")
    text_elem = common.wait_for_element(console, tr_console_calendar_dict, "mute_everyone_text").text
    if text_elem != "Mute everyone?":
        raise AssertionError(f"Given text 'Mute everyone?' is not matched with {text_elem}")
    common.wait_for_and_click(console, calendar_dict, "Mute_all_ok", "id")


def turn_on_live_captions_option(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    common.wait_for_and_click(console, tr_calendar_dict, "turn_on_live_captions")
    common.wait_for_element(console, calendar_dict, "live_caption_msg")


def turn_off_live_captions_option(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    common.wait_for_and_click(console, tr_calendar_dict, "turn_off_live_captions")


def verify_for_lock_meeting_visibility(console_list, state):
    print("State: ", state)
    consoles = console_list.split(",")
    for console in consoles:
        print("Console: ", console)
        common.wait_for_element(console, calls_dict, "Hang_up_button")
        common.wait_for_and_click(console, calls_dict, "call_more_options")
        if state.lower() == "lock_meeting":
            common.wait_for_element(console, tr_calendar_dict, "lock_the_meeting")
        elif state.lower() == "unlock_meeting":
            common.wait_for_element(console, tr_calendar_dict, "unlock_the_meeting", "xpath")
            time.sleep(display_time)
        call_keywords.dismiss_the_popup_screen(console)


def tap_on_lock_meeting_option(console):
    print("Console :", console)
    driver = obj.device_store.get(alias=console)
    try:
        WebDriverWait(driver, 10).until(EC.element_to_be_clickable((MobileBy.ID, calls_dict["Hang_up_button"]["id"])))
        print("Call control visible on screen")
    except Exception as e:
        tr_console_settings_keywords.tap_on_device_center_point(console)
        print("Clicked on center point as call control is not visible")
    WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((MobileBy.ID, calls_dict["call_more_options"]["id"]))
    ).click()
    print("Clicked on Call more option")
    try:
        lock_meeting = WebDriverWait(driver, 15).until(
            EC.element_to_be_clickable((MobileBy.XPATH, tr_calendar_dict["lock_the_meeting"]["xpath"]))
        )
        lock_meeting.click()
        print("Clicked on lock meeting option.")
        notification = WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((MobileBy.ID, tr_calendar_dict["meeting_lock_notification"]["id"]))
        )
        if notification.is_displayed():
            return "Meeting is now locked pop-up msg is visible on the screen"
        else:
            raise AssertionError("Meeting is now locked pop-up msg is not visible on the screen.")
    except Exception as e:
        raise AssertionError("Failed to tap on lock meeting option")


def tap_on_unlock_meeting_option(console):
    print("Device :", console)
    driver = obj.device_store.get(alias=console)
    try:
        WebDriverWait(driver, 10).until(EC.element_to_be_clickable((MobileBy.ID, calls_dict["Hang_up_button"]["id"])))
        print("Call control visible on screen")
    except Exception as e:
        tr_console_settings_keywords.tap_on_device_left_bottom(console)
        print("Clicked on center point as call control is not visible")
    WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((MobileBy.ID, calls_dict["call_more_options"]["id"]))
    ).click()
    print("Clicked on Call more option")
    try:
        unlock_meeting = WebDriverWait(driver, 15).until(
            EC.element_to_be_clickable((MobileBy.XPATH, tr_calendar_dict["unlock_the_meeting"]["xpath"]))
        )
        unlock_meeting.click()
        print("Clicked on Unlock the meeting option.")
        notification = WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((MobileBy.ID, tr_calendar_dict["meeting_lock_notification"]["id"]))
        )
        if notification.is_displayed():
            return "Meeting is now unlocked pop-up msg is displayed on the screen"
        else:
            raise AssertionError("Meeting unlocked pop-up msg is not displayed on the screen")
    except Exception as e:
        raise AssertionError("Failed to tap on unlock meeting option")


def verify_and_select_raise_hand_option(console):
    common.wait_for_element(console, calendar_dict, "hang_up_btn")
    common.wait_for_and_click(console, tr_console_calendar_dict, "reactions_button")
    common.wait_for_and_click(console, tr_console_calendar_dict, "raise_hand_icon")


def verify_and_select_lower_hand_option(console):
    common.wait_for_element(console, calendar_dict, "hang_up_btn")
    common.wait_for_and_click(console, tr_console_calendar_dict, "reactions_button")
    common.wait_for_and_click(console, tr_console_calendar_dict, "lower_hand_icon")


def verify_notification_for_raise_hand(console_list):
    consoles = console_list.split(",")
    for console in consoles:
        driver = obj.device_store.get(alias=console)
        print("Console : ", console)
        try:
            WebDriverWait(driver, 15).until(
                EC.presence_of_element_located((MobileBy.ID, tr_calendar_dict["raise_hand_notification"]["id"]))
            )
            print("Raise hand notification is displayed on the screen")
        except TimeoutException:
            try:
                WebDriverWait(driver, 15).until(
                    EC.presence_of_element_located((MobileBy.ID, tr_calendar_dict["raise_hand_notification"]["id"]))
                )
                print("Raise hand notification is displayed on the screen")
            except TimeoutException:
                raise AssertionError("Raise hand notification is not visible on the screen")


def verify_that_user_cannot_join_the_locked_meeting(console, meeting):
    consoles = console.split(",")
    for console in consoles:
        join_a_meeting(console, meeting="console_lock_meeting")
        common.wait_for_element(console, tr_calendar_dict, "meeting_locked_msg")


def check_for_live_captions_visibility(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    common.wait_for_element(console, tr_calendar_dict, "turn_on_live_captions")
    tr_console_settings_keywords.tap_on_device_center_point(console)


def verify_not_having_video_preview_on_screen(console):
    if common.is_element_present(console, tr_calendar_dict, "video_view"):
        raise AssertionError("Video preview is visible on the screen ")


def verify_reactions_options_in_call_control_bar(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    if not common.click_if_present(console, tr_console_calendar_dict, "reactions_button"):
        common.wait_for_and_click(console, calendar_dict, "call_control_reactions_button")
    common.wait_for_element(console, calendar_dict, "icon_like")
    common.wait_for_element(console, calendar_dict, "icon_heart")
    common.wait_for_element(console, calendar_dict, "icon_applause")
    common.wait_for_element(console, calendar_dict, "icon_laugh")
    common.wait_for_element(console, calendar_dict, "raise_hand")
    print("Raise hand reaction buttons available")
    call_keywords.dismiss_the_popup_screen(console)


def click_on_heart_button(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    if not common.click_if_present(console, tr_console_calendar_dict, "reactions_button"):
        common.wait_for_and_click(console, calendar_dict, "call_control_reactions_button")
    common.wait_for_and_click(console, calendar_dict, "icon_heart")


def click_on_laugh_button(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    if not common.click_if_present(console, tr_console_calendar_dict, "reactions_button"):
        common.wait_for_and_click(console, calendar_dict, "call_control_reactions_button")
    common.wait_for_and_click(console, calendar_dict, "icon_laugh")


def click_on_clap_button(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    if not common.click_if_present(console, tr_console_calendar_dict, "reactions_button"):
        common.wait_for_and_click(console, calendar_dict, "call_control_reactions_button")
    common.wait_for_and_click(console, calendar_dict, "icon_applause")


def verify_not_able_to_add_user_in_meeting(from_device, to_device):
    print("device :", from_device)
    common.wait_for_element(from_device, calendar_dict, "hang_up_btn")
    verify_and_view_list_of_participant(from_device)
    common.wait_for_and_click(from_device, tr_console_calendar_dict, "search_icon")
    udid_ = config["consoles"][from_device]["desired_caps"]["udid"]
    # element = common.wait_for_element(from_device, tr_console_calendar_dict, "invite_someone_box", "id")
    account = "user"
    if ":" in to_device:
        user = to_device.split(":")[1]
        print("User account : ", user)
        if user.lower() == "meeting_user":
            account = "meeting_user"
    print("Account :", account)
    to_device = to_device.split(":")[0]
    print("to_device : ", to_device)
    displayname = config["devices"][to_device][account]["displayname"]
    # element.send_keys(displayname)
    print("Invite someone Screen is visible")
    cmd = "adb -s " + udid_ + " shell input text " + displayname
    subprocess.run(cmd, stdout=subprocess.PIPE, shell=True)
    # common.hide_keyboard(from_device)
    tmp_dict = common.get_dict_copy(tr_console_calendar_dict, "search_result_user_name", "user_name", displayname)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_user_name", "xpath")
    common.wait_for_element(from_device, tr_console_calendar_dict, "change_notification")


def verify_notification_not_able_to_add_new_user(device):
    common.wait_for_element(device, tr_console_calendar_dict, "change_notification")
    common.wait_for_element(device, tr_console_calendar_dict, "organizer_message")
    common.wait_for_and_click(device, tr_device_settings_dict, "ok")
    if common.is_element_present(device, tr_calls_dict, "participant_more_option"):
        raise AssertionError(f"{device} user able to see the ellipse in participant page")


def verify_add_user_option_is_visible_for_presenter(console):
    print("console :", console)
    common.wait_for_element(console, calendar_dict, "hang_up_btn")
    time.sleep(3)
    if not common.is_element_present(console, calls_dict, "Invite_new_user"):
        if not common.is_element_present(console, tr_console_calendar_dict, "invite_someone_box"):
            common.wait_for_element(console, tr_calls_dict, "add_participants")
    print("Invite_new_user button is visible for presenter")
    common.wait_for_element(console, tr_calls_dict, "participant_more_option")


def verify_user_not_have_manage_audio_and_video_option(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    if common.is_element_present(console, tr_calls_dict, "participant_more_option"):
        raise AssertionError(f"{console} user able to see the manage audio and video option")


def verify_user_should_not_have_lock_meeting_option(console):
    print("Console: ", console)
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    if common.is_element_present(console, tr_calendar_dict, "lock_the_meeting"):
        raise AssertionError("user is having the Lock the meeting option")
    call_keywords.dismiss_the_popup_screen(console)


def verify_manage_audio_and_video_option_in_meeting(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, tr_calls_dict, "participant_more_option")
    common.wait_for_element(console, calendar_dict, "manage_audio_and_video")
    common.wait_for_element(console, calendar_dict, "disable_mic_for_attendees")
    common.wait_for_element(console, calendar_dict, "disable_camera_for_attendees")
    common.wait_for_and_click(console, tr_calls_dict, "participant_settings_back_btn")
    common.wait_for_element(console, calls_dict, "Hang_up_button")


def verify_on_all_day_meetings_title_bar(console):
    print("console:", console)
    meeting_name = common.wait_for_element(console, tr_calendar_dict, "all_day_title_on_main_screen")
    print("Meeting name : ", meeting_name.text)
    element = common.wait_for_element(console, tr_calendar_dict, "all_day_meeting_count")
    print("All day meeting count is:", element.text)
    common.wait_for_element(console, tr_calendar_dict, "all_day_meeting_right_arrow")


def verify_menu_bar_more_options(console):
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    common.wait_for_element(console, tr_calendar_dict, "turn_off_remote_control")
    common.wait_for_element(console, tr_calendar_dict, "turn_on_live_captions")
    common.wait_for_element(console, calls_dict, "call_dial_pad")
    common.wait_for_element(console, tr_console_calendar_dict, "turn_off_incoming_video")


def tapping_outside_more_option(console):
    tr_console_settings_keywords.tap_on_device_right_corner(console)
    if common.is_element_present(console, tr_calendar_dict, "turn_on_live_captions"):
        raise AssertionError(f"{console} Able to see the more options after taping outside the menu bar")
    common.wait_for_element(console, calls_dict, "call_more_options")


def verify_meeting_title_with_meeting_time(console, meeting):
    meeting_text = common.wait_for_element(console, rooms_console_calender_dict, "meeting_title").text
    if meeting_text != meeting:
        raise AssertionError(f"Expected meeting name{meeting} is not matched with {meeting_text}")
    common.wait_for_element(console, tr_console_calendar_dict, "meeting_time")


def get_connected_participants_count(from_device, connected_device_list):
    connected_devices = connected_device_list.split(",")
    print("connected_devices length : ", len(connected_devices))
    device_list = []
    for devices in connected_devices:
        account = "user"
        device = devices.split(":")[0]
        if ":" in devices:
            user = devices.split(":")[1]
            print("User account : ", user)
            if user.lower() == "meeting_user":
                account = "meeting_user"
                device_list.append(str(config["consoles"][device][account]["displayname"]))
        else:
            device_list.append(str(config["devices"][device][account]["displayname"]))
        print("account : ", account)
        print("device : ", device)
    print("device_list : ", device_list)
    common.wait_for_element(from_device, calls_dict, "Hang_up_button")
    common.wait_for_element(from_device, tr_console_calendar_dict, "invite_someone_box", "id")
    added_participant_list = common.get_all_elements_texts(from_device, calls_dict, "call_participant_name", "id")
    call_roster_header = common.wait_for_element(from_device, tr_calls_dict, "call_roster_header", "id").text
    call_roster = call_roster_header.split()[-1]
    other_participant_text = str(call_roster)
    elem1 = other_participant_text.replace("(", "")
    elem2 = elem1.replace(")", "")
    call_roaster_list = int(elem2)
    print("Call roster list : ", call_roaster_list)
    added_participant_list = len(added_participant_list)
    if added_participant_list != call_roaster_list:
        raise AssertionError(
            f"Connected device list {call_roaster_list} and in meeting list {added_participant_list} is not matching"
        )
    print("get_connected_devices_list : ", added_participant_list)
    if len(device_list) != added_participant_list:
        raise AssertionError(f"Connected device list {added_participant_list} and given device list is not matching")
    return added_participant_list


def verify_dialpad_in_more_options(console):
    common.wait_for_and_click(console, tr_console_home_screen_dict, "more_option")
    common.wait_for_element(console, tr_console_home_screen_dict, "call_icon")


def verify_join_with_an_id_button_in_more_option(console):
    common.wait_for_and_click(console, tr_console_home_screen_dict, "more_option")
    common.wait_for_element(console, tr_calendar_dict, "join_with_an_id")
    common.wait_for_and_click(console, tr_console_settings_dict, "back_layout")
    common.wait_for_element(console, tr_console_home_screen_dict, "more_option")


def verify_precall_screen_after_clicking_on_meetnow(device, console):
    common.wait_for_and_click(console, tr_console_home_screen_dict, "meet_now_icon")
    common.wait_for_element(console, calls_dict, "search_contact_box")
    common.wait_for_element(device, calendar_dict, "dial_info")
    common.wait_for_element(device, calendar_dict, "invite_people_msg")
    meet_passcode_field = []
    ele = common.wait_for_element(device, tr_calendar_dict, "meeting_id_text").text
    ele = ele.split(":")[0]
    ele1 = common.wait_for_element(device, tr_calendar_dict, "enter_passcode_text").text
    ele1 = ele1.split(":")[0]
    meet_passcode_field.append([ele, ele1])
    dial_info_field = meet_passcode_field[0]
    if ["Meeting ID", "Passcode"] != dial_info_field:
        raise AssertionError(f"Meeting id and passcode is not visible on the precall screen, {dial_info_field}")


def verify_meeting_chat(console, action_type):
    if action_type.lower() not in ["modify", "verify"]:
        raise AssertionError(f"Unexpected value for action type: {action_type}")
    common.wait_for_and_click(console, tr_calendar_dict, "call_control_content_share_mode")
    if action_type.lower() == "verify":
        common.wait_for_element(console, tr_calendar_dict, "show_chat_option")
    elif action_type.lower() == "modify":
        common.wait_for_and_click(console, tr_calendar_dict, "show_chat_option")
    call_keywords.dismiss_the_popup_screen(console)


def verify_meeting_chat_toggle_on_behaviour(device):
    common.wait_for_element(device, tr_calendar_dict, "chat_header")


def verify_and_validate_front_row_mode(device):
    common.wait_for_and_click(device, tr_calendar_dict, "call_control_content_share_mode")
    common.wait_for_and_click(device, tr_calendar_dict, "front_row")
    time.sleep(refresh_time)
    settings_keywords.get_screenshot(name="together_mode_screen")


def verify_large_gallery_ui(device):
    common.wait_for_element(device, tr_calendar_dict, "large_gallery_text")


def verify_together_mode_ui(device):
    common.wait_for_element(device, tr_calendar_dict, "together_mode_text")


def verify_front_row_option(console):
    common.wait_for_and_click(console, tr_calendar_dict, "call_control_content_share_mode")
    common.wait_for_element(console, tr_calendar_dict, "front_row")
    tr_console_settings_keywords.tap_on_device_right_corner(console)


def verify_switch_orientation_toggle_hidden_after_taping_on_frontrow(device):
    common.wait_for_and_click(device, tr_calendar_dict, "call_control_content_share_mode")
    common.wait_for_and_click(device, tr_calendar_dict, "large_gallery_mode")
    common.wait_for_and_click(device, tr_calendar_dict, "call_control_content_share_mode")
    common.wait_for_element(device, tr_calendar_dict, "switch_gallery_orientation")
    common.wait_for_and_click(device, tr_calendar_dict, "front_row")
    common.wait_for_and_click(device, tr_calendar_dict, "call_control_content_share_mode")
    common.wait_for_and_click(device, tr_calendar_dict, "large_gallery_mode")
    common.wait_for_and_click(device, tr_calendar_dict, "call_control_content_share_mode")
    time.sleep(5)
    if common.is_element_present(device, tr_calendar_dict, "switch_gallery_orientation"):
        raise AssertionError(f"{device} switch orientation toogle is not hidden after selected on front row ")
    if "console" in device:
        tr_console_settings_keywords.tap_on_device_right_corner(device)
    else:
        call_keywords.device_right_corner_click(device)


def verify_chat_bubbles_option_on_call_control_bar(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    time.sleep(3)
    if not common.is_element_present(console, tr_console_calendar_dict, "dont_show_chat_bubble"):
        common.wait_for_element(console, tr_console_calendar_dict, "show_chat_bubble")
    tr_console_settings_keywords.tap_on_device_right_corner(console)


def verify_meeting_info_details_in_the_meeting(device):
    common.wait_for_element(device, tr_console_calendar_dict, "meeting_title")
    common.wait_for_element(device, tr_console_calendar_dict, "meeting_organizer_name")
    if "console" in device:
        common.wait_for_element(device, tr_console_calendar_dict, "join_meet_code_in_meeting")


def verify_meet_now_parameters_in_meeting_joining_ui(device):
    if "console" in device:
        account_name_expected = common.get_console_user_name(device)
    else:
        account_name_expected = tr_home_screen_keywords.tr_get_user_name(device).strip()
    common.wait_for_and_click(device, tr_console_home_screen_dict, "meet_now_icon")
    if "console" not in device:
        common.wait_for_and_click(device, tr_calendar_dict, "dismiss")
    title_name = common.wait_for_element(device, tr_calendar_dict, "meeting_action_bar_title_text").text
    if str(title_name) != f"Meeting with {account_name_expected}":
        raise AssertionError(
            f"Expected meeting title 'Meeting with {account_name_expected}'is not displayed and it does not match the actual title:{title_name}"
        )
    if not common.is_element_present(device, tr_calls_dict, "video_on"):
        common.wait_for_element(device, tr_calendar_dict, "participant_video")
    if not common.is_element_present(device, calls_dict, "call_mute_control"):
        common.wait_for_element(device, tr_calls_dict, "participant_mute")


def verify_the_organizer_options_on_ad_hoc_meeting(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_element(console, calendar_dict, "Mute_all")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    common.wait_for_element(console, tr_calendar_dict, "lock_the_meeting")
    call_keywords.dismiss_the_popup_screen(console)
    verify_manage_audio_and_video_option_in_meeting(console)


def join_meeting_after_enabling_the_required_passcode(console, meeting, passcode):
    consoles = console.split(",")
    for console in consoles:
        join_a_meeting(console, meeting="console_lock_meeting")
    join_meeting = common.wait_for_element(console, tr_calendar_dict, "join_with_a_meeting_ID").text
    print("join in:", {join_meeting})
    meeting_passcode = common.wait_for_element(console, tr_calendar_dict, "passcode_field")
    meeting_passcode.send_keys(passcode)
    common.wait_for_and_click(console, tr_calendar_dict, "join_meeting")


def join_by_id_screen_in_meeting_after_enabling_the_required_passcode(console, meeting):
    consoles = console.split(",")
    for console in consoles:
        join_a_meeting(console, meeting="console_lock_meeting")
    join_meeting = common.wait_for_element(console, tr_calendar_dict, "join_with_a_meeting_ID").text
    print("join in:", {join_meeting})
    common.wait_for_element(console, tr_calendar_dict, "meeting_id_field")
    common.wait_for_element(console, tr_calendar_dict, "passcode_field")
    common.wait_for_element(console, tr_console_settings_dict, "back_button")


def default_meeting_id_should_be_in_meeting_id_field_after_enabling_the_required_passcode(console, meeting, meeting_id):
    consoles = console.split(",")
    for console in consoles:
        join_a_meeting(console, meeting="console_lock_meeting")
    join_meeting = common.wait_for_element(console, tr_calendar_dict, "join_with_a_meeting_ID").text
    print("join in:", {join_meeting})
    actual_meeting_id = common.wait_for_element(console, tr_calendar_dict, "meeting_id_field").text
    if actual_meeting_id != meeting_id.replace(" ", ""):
        raise AssertionError(
            f" {console} Default meeting id {meeting_id.replace(' ', '')} is not matching with the {actual_meeting_id}"
        )
    common.wait_for_element(console, tr_calendar_dict, "passcode_field")
    common.wait_for_element(console, tr_console_settings_dict, "back_button")


def verify_calling_option_should_not_present_under_admin_settings_page(console):
    time.sleep(3)
    if common.is_element_present(console, tr_settings_dict, "calling_button"):
        raise AssertionError(f"{console} calling option is available under admin settings page")


def verify_lobby_message_when_user_joining_in_meeting_with_join_by_code(device):
    common.wait_for_and_click(device, tr_console_home_screen_dict, "more_option")
    common.wait_for_and_click(device, tr_calendar_dict, "join_with_an_id")
    common.wait_for_element(device, tr_calendar_dict, "join_with_a_meeting_ID")
    meeting_id_field = common.wait_for_element(device, tr_calendar_dict, "meeting_id_field")
    meeting_id_field.send_keys(config["meeting_details"]["meeting_id"])
    meeting_passcode = common.wait_for_element(device, tr_calendar_dict, "passcode_field")
    meeting_passcode.send_keys(config["meeting_details"]["meeting_passcode"])
    common.wait_for_and_click(device, tr_calendar_dict, "join_meeting")


def verify_and_join_zoom_meeting_with_incorrect_meeting_details(device, console):
    common.wait_for_and_click(console, tr_calendar_dict, "join_with_an_id")
    common.wait_for_element(console, tr_calendar_dict, "join_with_a_meeting_ID")
    common.wait_for_and_click(console, tr_calendar_dict, "zoom_button")
    common.wait_for_and_click(console, tr_calendar_dict, "Next")
    meeting_id_field = common.wait_for_element(console, tr_calendar_dict, "meeting_id_field")
    meeting_id_field.send_keys(config["zoom_meeting_details"]["invalid_meeting_id"])
    meeting_passcode = common.wait_for_element(console, tr_calendar_dict, "passcode_field")
    meeting_passcode.send_keys(config["zoom_meeting_details"]["invalid_passcode"])
    common.wait_for_and_click(console, tr_calendar_dict, "join_zooom_meeting_button")
    common.wait_for_element(device, tr_calendar_dict, "invalid_credentials_popup")
    common.wait_for_element(console, tr_calendar_dict, "cancel")
    common.sleep_with_msg(console, 30, "Getting the incorrect message in device")
    common.wait_for_element(console, tr_calendar_dict, "join_with_a_meeting_ID")
    if not common.click_if_present(console, tr_calls_dict, "close_roaster_button"):
        common.wait_for_and_click(console, tr_console_settings_dict, "back_layout")


def verify_report_an_issue_while_front_row_mode(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    common.wait_for_and_click(console, tr_settings_dict, "Report_an_issue")
    common.wait_for_element(console, settings_dict, "issue_title")
    common.wait_for_element(console, tr_settings_dict, "Title required")
    common.wait_for_element(console, tr_settings_dict, "bug details")
    common.wait_for_element(console, settings_dict, "send_bug")


def verify_do_not_show_chat_bubbles_option_on_call_control_bar(console):
    common.wait_for_element(console, calls_dict, "Hang_up_button")
    common.wait_for_and_click(console, calls_dict, "call_more_options")
    common.wait_for_element(console, tr_console_calendar_dict, "dont_show_chat_bubble")
    call_keywords.dismiss_the_popup_screen(console)


def verify_3p_meeting_in_calendar(device, meeting):
    _max_attempts = 10
    for _attempt in range(_max_attempts):
        meeting_name = common.get_all_elements_texts(device, calendar_dict, "meeting_title_name", "xpath")
        if meeting.lower() in meeting_name:
            print(f"{device}: After scrolling {_attempt} times found meeting: '{meeting_name}'")
            return
        tr_calendar_keywords.scroll_up_meeting_tab(device)
    raise AssertionError(f"3P meeting are not visible on calendar please create the 3p meetings on {device} ")


def verify_the_call_button_behavior(device, to_device):
    to_device_list = to_device.split(",")
    if len(to_device_list) > 2:
        raise AssertionError(f"to_device is containing more than two devices {to_device}")
    if not common.click_if_present(device, tr_home_screen_dict, "dial_btn"):
        common.wait_for_and_click(device, tr_console_home_screen_dict, "call_icon")
    common.hide_keyboard(device)

    call_icon_element = common.wait_for_element(device, tr_console_home_screen_dict, "call_icon", "id")

    # Check if the call icon is disabled initially
    if call_icon_element.get_attribute("enabled") != "false":
        raise AssertionError(f"{device}: Call option should be disabled initially after clicking from home screen.")

    search_box = common.wait_for_element(device, tr_calls_dict, "search_box")

    # Check behavior for each contact in to_device_list
    for contact in to_device_list:
        username = common.device_username(contact)
        search_box.send_keys(username)
        common.wait_for_and_click(device, calls_dict, "search_result_name", "id")
        if call_icon_element.get_attribute("enabled") != "true":
            raise AssertionError(f"{device}: Call button should be activated after selecting the contact {username}.")

    search_box.clear()
    common.wait_for_and_click(device, tr_console_calls_dict, "call_back_btn")
    common.wait_for_element(device, tr_console_home_screen_dict, "meet_now_icon")
    if not common.click_if_present(device, tr_home_screen_dict, "dial_btn"):
        common.wait_for_and_click(device, tr_console_home_screen_dict, "call_icon")
    common.hide_keyboard(device)

    call_icon_element = common.wait_for_element(device, tr_console_home_screen_dict, "call_icon", "id")
    if call_icon_element.get_attribute("enabled") != "false":
        raise AssertionError(f"{device}: Call option should be disabled initially after clicking from home screen.")

    # Check behavior when entering alphanumeric values
    search_box.send_keys("ac677675br")
    if call_icon_element.get_attribute("enabled") == "true":
        raise AssertionError(f"{device}: Call button should not be activated after entering alphanumeric values.")
    search_box.clear()

    # Check behavior for incorrect number with the first contact
    incorrect_number = config["incorrect_number"]["phonenumber"]
    username = common.device_displayname(to_device_list[0])
    search_box.send_keys(username)
    common.wait_for_and_click(device, calls_dict, "search_result_name", "id")
    search_box.send_keys(incorrect_number)
    if call_icon_element.get_attribute("enabled") != "true":
        raise AssertionError(f"{device}: Call button should be activated after entering contact and incorrect number.")
    search_box.clear()

    # Check behavior for correct phone number with the second contact
    correct_phonenumber = common.device_pstndisplay(to_device_list[1])
    search_box.send_keys(username)
    common.wait_for_and_click(device, calls_dict, "search_result_name", "id")
    search_box.send_keys(correct_phonenumber)
    if call_icon_element.get_attribute("enabled") != "true":
        raise AssertionError(
            f"{device}: Call button should be activated after entering contact and correct phone number."
        )

    # Click the call button
    call_icon_element.click()
    if common.is_norden(device):
        elem = common.wait_for_element(device, tr_calendar_dict, "meeting_action_bar_title_text").text
    else:
        elem = common.wait_for_element(device, tr_console_calendar_dict, "call_bar_title").text

    print(f"elem: {elem}")
    call_title = correct_phonenumber + " and " + username
    print(call_title)
    if elem != call_title:
        raise AssertionError(f"{device} user not getting the group call details {elem} as expected")


def get_meeting_details_on_user(device):
    meeting_name = common.wait_for_element(device, tr_console_calendar_dict, "meeting_list_name").text
    meeting_time = common.wait_for_element(device, tr_console_calendar_dict, "meeting_time").text
    meeting_organizer = common.wait_for_element(device, tr_console_calendar_dict, "meeting_organizer_name").text
    common.wait_for_element(device, calendar_dict, "cnf_device_join_button_id")
    common.wait_for_element(device, tr_console_calendar_dict, "meeting_logo")
    return [meeting_name, meeting_time, meeting_organizer]


def verify_meetings_synced_on_peripheral(console):
    c_list = get_meeting_details_on_user(console)
    if not c_list:
        raise AssertionError(f"expected meeting details are not synced in peripheral")


def verify_meeting_displayed_on_home_page_with_available(device, meeting):
    for i in range(5):
        if common.is_element_present(device, calendar_dict, "join_upcoming_meeting_arrow"):
            break
        common.refresh_within_the_container(device, calendar_dict, "calendar_view")
    common.wait_for_element(device, panels_home_screen_dict, "available_tile")
    _meeting = common.wait_for_element(device, tr_console_calendar_dict, "avilable_meeting_name").text
    print("meetings present on calendar tab is ", _meeting)

    if meeting.lower() != _meeting.lower():
        raise AssertionError(
            f"Expected meeting is not displayed in calendar {_meeting} please check and create {meeting}"
        )
    common.wait_for_element(device, calendar_dict, "join_upcoming_meeting_arrow")
    common.wait_for_element(device, tr_console_calendar_dict, "avilable_time_range")


def verify_should_not_display_join_button(console, meeting):
    verify_meeting_displayed_on_home_page_with_available(console, meeting)
    if common.is_element_present(console, calendar_dict, "upcoming_meeting_join_button"):
        raise AssertionError(
            f"upcoming meeting is in active state delete and create the new upcoming meeting with time gap with present time"
        )


def verify_upcoming_meeting_details(device, meeting):
    if not common.click_if_present(device, calendar_dict, "join_upcoming_meeting_arrow"):
        common.refresh_within_the_container(device, calendar_dict, "calendar_view")
        common.wait_for_and_click(device, calendar_dict, "join_upcoming_meeting_arrow")
    _meeting = common.wait_for_element(device, tr_console_calendar_dict, "created_meeting_name").text
    if meeting.lower() != _meeting.lower():
        raise AssertionError(
            f"Expected meeting is not displayed in calendar {_meeting} please check and create {meeting}"
        )
    common.wait_for_element(device, panels_home_screen_dict, "agenda_view_time_range")
    m_type = common.wait_for_element(device, tr_console_calendar_dict, "meeting_type").text
    if m_type != "Microsoft Teams meeting":
        raise AssertionError(f"Expected meeting type is not displayed in calendar {m_type}")
    common.wait_for_element(device, tr_console_calendar_dict, "upcoming_meeting_organizer")
    common.wait_for_element(device, calendar_dict, "upcoming_meeting_join_button")
    call_keywords.dismiss_the_popup_screen(device)


def get_join_button_before_10_mins_meeting_start_time(device, verify_arrow=None):
    if verify_arrow is not None:
        if not common.is_element_present(device, calendar_dict, "join_upcoming_meeting_arrow"):
            common.refresh_within_the_container(device, calendar_dict, "calendar_view")
            common.wait_for_element(device, calendar_dict, "join_upcoming_meeting_arrow")
        if common.is_element_present(device, calendar_dict, "cnf_device_join_button", "xpath"):
            raise AssertionError(
                "Active meeting is displaying; please delete the meeting and recreate it with a time gap of 15 to 20 minutes with actual time."
            )
    time_lst = common.get_all_elements_texts(device, panels_home_screen_dict, "agenda_view_time_range")
    meeting_strt_time = datetime.strptime(time_lst[0].split(" - ")[0], "%I:%M %p") - timedelta(minutes=10)
    print("meeting_start_time:", meeting_strt_time)
    current_time = common.wait_for_element(device, tr_home_screen_dict, "clock", "id").text
    print("current:", current_time)
    current_time_format = datetime.strptime(current_time, "%I:%M %p")
    wait_for_button = (meeting_strt_time - current_time_format).total_seconds()
    print("wait_for_seconds_to_check_join_button:", wait_for_button)
    assert wait_for_button < 660, "The wait time must be less than 11 minutes."
    common.wait_for_element(
        device, calendar_dict, "cnf_device_join_button", "xpath", wait_attempts=int(wait_for_button)
    )
    # Verify that approximately 10 minutes have elapsed after finding the 'join' button
    # time.sleep(wait_for_button)  # Wait for the calculated duration
    # if not common.is_element_present(device, calendar_dict, "cnf_device_join_button", "xpath"):
    #     raise AssertionError("The 'join' button did not appear as expected after 10 minutes.")


def verify_focus_tiles_on_calendar(device):
    common.wait_for_element(device, panels_home_screen_dict, "agenda_view")
    common.wait_for_element(device, rooms_console_calender_dict, "meeting_list_name")
    common.wait_for_element(device, rooms_console_calender_dict, "focus_bar")
    common.wait_for_element(device, rooms_console_calender_dict, "meeting_organizer_name")
    common.wait_for_element(device, calendar_dict, "meeting_time")
    common.wait_for_element(device, panels_home_screen_dict, "teams_logo")


def verify_participant_profile_while_adding_to_the_call(from_device, to_device, device_type=None):
    if device_type is not None and device_type.lower() != "console":
        raise AssertionError(f"Unexpected value for device type: {device_type}")
    print("from_device :", from_device)
    print("to_device :", to_device)
    to_devices = to_device.split(",")
    for to_device in to_devices:
        common.wait_for_element(from_device, calendar_dict, "hang_up_btn")
        username, password, contact_device, account_type = common.get_credentials(to_device)
        expected_username = username.split("@")[0]
        print(expected_username)
        common.sleep_with_msg(from_device, 5, "waiting to list all Participants")
        ele_text = common.wait_for_element(
            from_device, calendar_dict, "add_user", "id", cond=EC.presence_of_all_elements_located
        )
        participant_list = [str(i.text) for i in ele_text]
        print("user names are:", participant_list)
        user_position = 0
        for _user in participant_list:
            if _user.lower() == expected_username.lower():
                user_position = participant_list.index(_user)
                print(f"expected user to click:", _user)
                ele_text[user_position].click()
        common.wait_for_element(from_device, calendar_dict, "spotlight_for_everyone")
        common.wait_for_element(from_device, calendar_dict, "pin_for_me")


def verify_available_tile_between_the_meetings(device):
    if not common.is_element_present(device, calendar_dict, "join_upcoming_meeting_arrow"):
        common.refresh_within_the_container(device, calendar_dict, "calendar_view")
        common.wait_for_element(device, calendar_dict, "join_upcoming_meeting_arrow")
    all_meeting_elements = common.get_all_elements_texts(device, tr_console_calendar_dict, "meeting_list_name", "id1")
    if all_meeting_elements[2] != "Available":
        raise AssertionError(
            f"Available tile not displayed between the meetings {all_meeting_elements} check and create the meetings with 30 minutes time gap"
        )


def verify_double_booked_meetings_start_end_time_should_be_same(device):
    date_lst = common.get_all_elements_texts(device, calendar_dict, "meeting_time", "id1")
    if len(set(date_lst)) != 1:
        raise AssertionError(f"{device} does not have the same start time as the double-booked meetings {date_lst}")


def start_the_recording_from_TDC(device):
    common.wait_for_element(device, web_signin_dict, "leave_btn_tdc")
    common.wait_for_and_click(device, web_signin_dict, "more_button_in_TDC")
    common.wait_for_and_click(device, web_signin_dict, "record_btn_TDC")
    common.wait_for_and_click(device, web_signin_dict, "start_recording_TDC")
    common.sleep_with_msg(device, 10, "waiting for recording pop up")
    if common.is_element_present(device, web_signin_dict, "record_dialog"):
        common.wait_for_and_click(device, web_signin_dict, "dialog_continue")
    common.sleep_with_msg(device, 10, "waiting for recording language pop up")
    common.wait_for_and_click(device, web_signin_dict, "dialog_confirm")
    common.wait_for_element(device, web_signin_dict, "record_notification_TDC")


def verify_HDMI_ingest_in_the_device(device, console=None):
    common.sleep_with_msg(device, 5, "waiting to load the screen")
    if not common.is_element_present(device, tr_calendar_dict, "hdmi_ingest"):
        if console is not None:
            common.wait_for_and_click(console, tr_home_screen_dict, "share_button")
        else:
            common.wait_for_and_click(device, tr_home_screen_dict, "share_button")
    if console is not None:
        common.wait_for_element(console, tr_calendar_dict, "stop_sharing_hdmi")
    if not common.is_element_present(device, tr_calendar_dict, "hdmi_ingest"):
        raise AssertionError(
            f"HDMI is not connected to {device},Please plug the HDMI input from {device} into the laptop."
        )


def verify_HDMI_ingest_in_the_call(from_device, to_device, console=None):
    display_name = common.device_displayname(from_device)
    from_device = from_device.split(":")[0]
    if console is not None:
        common.wait_for_element(console, tr_calendar_dict, "hdmi_ingest_in_call")
    if not common.is_element_present(from_device, tr_calendar_dict, "hdmi_ingest"):
        raise AssertionError(
            f"HDMI is not connected to {from_device}. Please plug the HDMI input from {from_device} into the laptop."
        )
    to_devices = to_device.split(",")
    for to_device in to_devices:
        ele = common.wait_for_element(to_device, tr_calendar_dict, "video_view")
        sharing_element = ele.get_attribute("content-desc")
        print("Getting the message:", sharing_element)
        screenshare_msg = f"Screenshare from {display_name} is displayed here"
        if sharing_element != screenshare_msg:
            raise AssertionError(
                f"{to_device} is not able to see any screen sharing from {from_device}. Please check and ensure HDMI ingest is connected on {from_device}."
            )


def verify_content_mode_on_layout_when_sharing_content(device):
    common.wait_for_and_click(device, tr_calls_dict, "call_control_mode")
    if not common.is_element_present(device, tr_calendar_dict, "focus_on_content"):
        raise AssertionError(
            f"Content mode is not visible on the layouts check and plug the HDMI input from {device} into the laptop."
        )
    call_keywords.dismiss_the_popup_screen(device)


def verify_user_stop_sharing_the_content_in_the_call(device, console=None):
    if console is not None:
        common.wait_for_and_click(console, tr_calendar_dict, "hdmi_ingest_in_call")
    else:
        common.wait_for_and_click(device, tr_calendar_dict, "hdmi_ingest_in_call")
    time.sleep(2)
    if common.is_element_present(device, tr_calendar_dict, "hdmi_ingest"):
        raise AssertionError(f"Content is still showing on {device} after clicking on hdmi_ingest_in_call button")


def user_click_on_the_hdmi_share_option(console, device, state="on"):
    if state.lower() == "off":
        common.wait_for_and_click(console, tr_calendar_dict, "stop_sharing_hdmi")
        time.sleep(2)
        if common.is_element_present(device, tr_calendar_dict, "hdmi_ingest"):
            raise AssertionError(f"Content is still showing on {device} after clicking on stop sharing on {console}")
    else:
        common.wait_for_and_click(console, tr_home_screen_dict, "share_button")
        time.sleep(2)
        if not common.is_element_present(device, tr_calendar_dict, "hdmi_ingest"):
            raise AssertionError(
                f"HDMI is not connected to {device},Please plug the HDMI input from {device} into the laptop."
            )


def verify_user_should_not_get_exit_screen_and_stop_projecting(device):
    if all(
        common.is_element_present(device, tr_calendar_dict, element)
        for element in ["exit_full_screen", "stop_projecting"]
    ):
        raise AssertionError(
            f"{device} is showing 'Exit Full Screen' and 'Stop Projecting' buttons on the screen with HDMI plugged in."
        )


def user_click_hdmi_share_option_in_the_call(console, device):
    common.wait_for_and_click(console, tr_console_calendar_dict, "share_button")
    common.wait_for_and_click(console, tr_calendar_dict, "share_content_hdmi_in_meeting")
    common.wait_for_element(console, tr_calendar_dict, "hdmi_ingest_in_call")
    time.sleep(2)
    if not common.is_element_present(device, tr_calendar_dict, "hdmi_ingest"):
        raise AssertionError(
            f"HDMI is not connected to {device}. Please plug the HDMI input from {device} into the laptop."
        )


def user_tap_on_exist_full_screen_in_hdmi_sharing(device, screen_type):
    if screen_type.lower() not in ["minimized", "maximized"]:
        raise AssertionError(f"Unexpected value for screen_type: {screen_type}")
    time.sleep(2)
    if screen_type.lower() == "minimized":
        if not common.click_if_present(device, tr_calendar_dict, "exit_full_screen"):
            settings_keywords.click_device_center_point(device)
            common.wait_for_and_click(device, tr_calendar_dict, "exit_full_screen")
            common.sleep_with_msg(device, 3, "waiting for screen to minimize")
            if not common.is_element_present(device, tr_calendar_dict, "minimized_hdmi_screen"):
                raise AssertionError(
                    f"user not able to tap on exist full screen ,HDMI is not connected to {device},check and Please plug the HDMI input from {device} into the laptop."
                )
    elif screen_type.lower() == "maximized":
        common.wait_for_and_click(device, tr_calendar_dict, "minimized_hdmi_screen")
        if common.is_element_present(device, tr_calendar_dict, "minimized_hdmi_screen"):
            raise AssertionError(f"The screen is not minimized so user not able to maximize the full screen")


def user_tap_on_stop_sharing_button_on_hdmi_sharing_screen(device):
    time.sleep(2)
    if not common.click_if_present(device, tr_calendar_dict, "stop_projecting"):
        settings_keywords.click_device_center_point(device)
        common.wait_for_and_click(device, tr_calendar_dict, "stop_projecting")
    tr_home_screen_keywords.verify_home_page_screen(device)


def user_minimize_the_hdmi_sharing_screen(device):
    common.wait_for_element(device, tr_calendar_dict, "hdmi_ingest")
    if not common.click_if_present(device, tr_calendar_dict, "exit_full_screen"):
        settings_keywords.click_device_center_point(device)
        common.wait_for_and_click(device, tr_calendar_dict, "exit_full_screen")
    common.wait_for_element(device, tr_calendar_dict, "minimized_hdmi_screen")


def verify_content_paused_statement_while_connecting_in_call(device):
    common.wait_for_element(device, tr_calendar_dict, "content_sharing_paused")
    if common.is_element_present(device, tr_calendar_dict, "hdmi_ingest"):
        raise AssertionError(f" {device} After attending the call still user able to to see HDMI screen sharing")


def verify_white_board_sharing_option_should_not_visible_after_making_an_attendee(device):
    common.wait_for_element(device, calls_dict, "Hang_up_button")
    common.click_if_present(device, tr_calendar_dict, "share_button")
    if common.is_element_present(device, tr_calendar_dict, "Microsoft_whiteboard_sharing"):
        raise AssertionError(f"{device} user able to see the white board sharing option after making an attendee")


def verify_half_white_board_sharing_and_half_spotlighted_screen_in_the_call_screen(device):
    common.wait_for_element(device, tr_calls_dict, "Whiteboard")
    common.wait_for_element(device, tr_calls_dict, "secondary_participant_grid")


def verify_cancel_button_after_join_dgj_meeting(console, meeting):
    print(
        "joins meeting named test_meeting by default unless stated otherwise; Meeting : ",
        meeting,
    )
    consoles = console.split(",")
    for console in consoles:
        print("console :", console)
        _max_attempts = 10
        list_of_meetings = []
        if ":" in meeting:
            meeting = common.device_displayname(meeting)
        m_list = common.get_all_elements_texts(console, calendar_dict, "meeting_title_name", "xpath")
        print(f"meeting title names:{m_list}")
        for _attempt in range(_max_attempts):
            if meeting in m_list:
                print(f"{console}: After scrolling {_attempt} times found meeting: '{meeting}'")
                break
            tr_calendar_keywords.scroll_up_meeting_tab(console)
            m_list.extend(common.get_all_elements_texts(console, calendar_dict, "meeting_title_name", "xpath"))
            if _attempt == _max_attempts - 1:
                raise AssertionError(f"{console}: After scrolling {_attempt} times meeting did not appear: '{meeting}'")
        meeting_list = common.wait_for_element(
            console, calendar_dict, "meeting_title_name", "xpath", cond=EC.presence_of_all_elements_located
        )
        join_button_list = common.wait_for_element(
            console, calendar_dict, "cnf_device_join_button", "xpath", cond=EC.presence_of_all_elements_located
        )
        if len(meeting_list) < len(join_button_list):
            join_button_list = join_button_list[1:]
            if len(meeting_list) != len(join_button_list):
                raise AssertionError(
                    f"Number of meetings displayed: {len(meeting_list)} is not equal to number of join buttons: {len(join_button_list)}"
                )
        for i in meeting_list:
            list_of_meetings.append(str(i.text))
        print("List of Meeting displayed on home screen :", list_of_meetings)
        meeting_position = 0
        search_attempt = 1
        for _meeting in list_of_meetings:
            if _meeting.lower() == meeting.lower():
                meeting_position = list_of_meetings.index(_meeting)
                print("Expected Meeting is displayed on screen : ", _meeting)
                break
            search_attempt += 1
            if search_attempt == len(list_of_meetings) + 1:
                raise AssertionError(f"Expected meeting: {meeting} is not displayed")
        print("Meeting is display at position  : ", meeting_position)
        join_button_list[meeting_position].click()
        print("Clicked Join button on device : ", console)
        if meeting.lower() in ["zoom_meeting", "webex_meeting"]:
            common.wait_for_element(console, tr_calendar_dict, "cancel")


def verify_user_able_to_see_exit_full_screen_and_stop_projecting(device):
    common.wait_for_element(device, tr_calendar_dict, "hdmi_ingest")
    if not common.is_element_present(device, tr_calendar_dict, "exit_full_screen"):
        settings_keywords.click_device_center_point(device)
    common.wait_for_element(device, tr_calendar_dict, "exit_full_screen")
    common.wait_for_element(device, tr_calendar_dict, "stop_projecting")


def verify_add_participants_button_absent(console):
    common.wait_for_element(console, calendar_dict, "hang_up_btn")
    common.raise_if_present(console, tr_calls_dict, "add_participants")
