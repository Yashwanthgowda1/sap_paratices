import common
from Selectors import load_json_file
import call_keywords
from selenium.webdriver.support import expected_conditions as EC
import voicemail_keywords

lcp_calls_dict = load_json_file("resources/Page_objects/lcp_calls.json")
calls_dict = load_json_file("resources/Page_objects/Calls.json")
common_dict = load_json_file("resources/Page_objects/Common.json")
lcp_homescreen_dict = load_json_file("resources/Page_objects/lcp_homescreen.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")


def swap_calls(device):
    common.wait_for_and_click(device, lcp_calls_dict, "lcp_call_bar_entry_more_option")
    common.wait_for_and_click(device, lcp_calls_dict, "call_swap")


def make_emergency_call_lcp(device):
    emergency_phone_no = "933"
    common.wait_for_and_click(device, calls_dict, "search_icon")
    contact = common.wait_for_element(device, calls_dict, "search_text")
    contact.send_keys(emergency_phone_no)
    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", emergency_phone_no)
    common.wait_for_and_click(device, tmp_dict, "search_result_item_container", "xpath")
    # settings_keywords.swipe_till_end(device)
    # settings_keywords.swipe_till_end(device)
    # tmp_dict1 = common.get_dict_copy(
    #     lcp_calls_dict, "lcp_call_using_phone_no", "replace_with_phone_no", emergency_phone_no
    # )
    # common.wait_for_and_click(device, tmp_dict1, "lcp_call_using_phone_no")
    common.wait_for_element(device, calls_dict, "Hang_up_button")


def verify_options_inside_calls_tab(device):
    call_keywords.navigate_to_calls_tab(device)
    common.wait_for_element(device, calls_dict, "recent_tab")
    common.wait_for_element(device, calls_dict, "favorites_tab")
    common.wait_for_and_click(device, common_dict, "home_btn")


def verify_calls_tab_when_signed_in_with_cap_account(device):
    common.wait_for_and_click(device, lcp_homescreen_dict, "calls_tab")
    common.wait_for_element(device, lcp_calls_dict, "lcp_dial_tab")


def verify_transfer_target_search_screen_for_lcp(device, to_device, speed_dial_user, option):
    if option.lower() not in ["transfer_now", "consult_first"]:
        raise AssertionError(f"{device}: Unexpected value for Transfer option: {option}")
    common.wait_for_element(device, calls_dict, "Hang_up_button")
    common.wait_for_and_click(device, calls_dict, "Transfer")
    if option.lower() == "transfer_now":
        common.wait_for_and_click(device, calls_dict, "Transfer_now")
        common.wait_for_element(device, lcp_calls_dict, "transfer_title")
    elif option.lower() == "consult_first":
        common.wait_for_and_click(device, calls_dict, "consult_first")
        common.wait_for_element(device, lcp_calls_dict, "consult")
    common.wait_for_element(device, calls_dict, "Call_Back_Button")
    common.wait_for_element(device, lcp_calls_dict, "dialpad_button")
    common.wait_for_element(device, lcp_calls_dict, "search_button")
    common.wait_for_element(device, calls_dict, "Resume_call_from_hold_banner")
    common.wait_for_element(device, calls_dict, "end_button_in_hold_banner")
    common.wait_for_and_click(device, lcp_calls_dict, "search_button")
    common.wait_for_element(device, calls_dict, "search_contact_box")
    common.wait_for_element(device, lcp_calls_dict, "people_or_phone")
    actual_speed_dial_user = common.get_all_elements_texts(device, calls_dict, "contact_display_name")
    expected_speed_dial_user = common.device_displayname(speed_dial_user)
    if expected_speed_dial_user not in actual_speed_dial_user:
        raise AssertionError(
            f"{actual_speed_dial_user} user in the speed dial is not as expected {expected_speed_dial_user}"
        )
    user_name = common.device_displayname(to_device)
    common.wait_for_element(device, calls_dict, "search_contact_box").send_keys(user_name)
    tmp_dict = common.get_dict_copy(calls_dict, "search_result_item_container", "config_display", user_name)
    common.wait_for_element(device, tmp_dict, "search_result_item_container", "xpath")


def verify_presence_status_in_voicemail_tab(from_device, to_device):
    if not common.is_lcp(from_device):
        voicemail_keywords.verify_user_contact_details_who_left_voice_mail(to_device, from_device)
    user_name = common.device_displayname(to_device)
    all_profile_elements = common.wait_for_element(
        from_device, calls_dict, "user_profile_picture", cond=EC.presence_of_all_elements_located
    )
    element = [elements.get_attribute("content-desc") for elements in all_profile_elements]
    msg = [ele.split(":")[-1].lstrip() for ele in element]
    if len(msg) > 1 and msg[0].lower() in ["available", "busy", "dnd", "offline", "away"]:
        print(f"Presence status for {user_name} is {msg[0]}")
    else:
        raise AssertionError(f"Presence status not found for {user_name}")


def verify_favorite_page_lcp(device):
    call_keywords.navigate_to_calls_favorites_page(device)
    if not common.is_element_present(device, lcp_calls_dict, "verify_lcp_in_favourite_page"):
        common.wait_for_element(device, calls_dict, "add_your_speed_dial_numbers")
