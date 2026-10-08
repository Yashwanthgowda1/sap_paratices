from appium.webdriver.common.mobileby import MobileBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import common
from Selectors import load_json_file
from initiate_driver import obj_dev as obj
from initiate_driver import config
import settings_keywords
import call_keywords
import calendar_keywords
import time
from Libraries.shared_utils import (
    getconfig_displayname,
    getconfig_device_model,
)


display_time = 2
action_time = 3

people_dict = load_json_file("resources/Page_objects/People.json")
calls_dict = load_json_file("resources/Page_objects/Calls.json")
common_dict = load_json_file("resources/Page_objects/Common.json")
app_bar_dict = load_json_file("resources/Page_objects/App_bar.json")
home_screen_dict = load_json_file("resources/Page_objects/Home_screen.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
people_lcp_dict = load_json_file("resources/Page_objects/People_lcp.json")


def navigate_to_people_tab(device):
    if verify_people_navigation(device):
        return
    if common.click_if_present(device, common_dict, "back") or common.click_if_present(device, common_dict, "home_btn"):
        time.sleep(action_time)
    common.click_if_present(device, home_screen_dict, "home_bar_icon")
    if not (
        common.click_if_present(device, people_dict, "people_tab")
        or common.click_if_present(device, people_dict, "people_tab_cap")
    ):
        common.wait_for_and_click(device, app_bar_dict, "more_tab")
        common.wait_for_and_click(device, people_dict, "people_tab")
        people_text = common.wait_for_element(device, people_dict, "Header").text
        if people_text != "People":
            raise AssertionError(f"{device} is not on People tab")
    if verify_people_navigation(device):
        return
    raise AssertionError(f"{device}: Navigation to people tab failed")


def verify_people_navigation(device):
    common.sleep_with_msg(device, 2, "waiting for header on People tab")
    if common.is_element_present(device, people_dict, "Header", "id"):
        head_text = common.wait_for_element(device, people_dict, "Header").text
        print(f"Tab header is: {head_text}")
        if head_text == "People" or common.is_element_present(device, people_dict, "all_contacts_drop_down"):
            print(f"{device} is on People tab")
            return True
    elif common.is_element_present(device, people_dict, "all_contacts_drop_down"):
        print(f"{device} is on People tab now")
        return True
    elif common.is_element_present(device, people_dict, "people_view"):
        print(f"{device} is on People tab now")
        return True
    else:
        print(f"{device} is not on People tab")
        return False


def verify_plus_icon_on_people_tab(device):
    navigate_to_people_tab(device)
    if common.is_lcp(device):
        common.wait_for_element(device, people_dict, "people_more_lcp")
    else:
        common.wait_for_element(device, people_dict, "plus_icon")


def click_on_plus_icon_on_people_tab(device):
    common.wait_for_and_click(device, people_dict, "plus_icon")


def verify_plus_icon_two_options(device):
    common.wait_for_element(device, people_dict, "create_new_group")
    common.wait_for_element(device, people_dict, "add_from_directory")


def select_people_app_option_and_verify(device, option):
    if option.lower() not in ["create new group", "add from directory", "create new contact"]:
        raise AssertionError(f"Illegal value for 'option': '{option}'")
    if option.lower() == "create new group":
        common.wait_for_and_click(device, people_dict, "create_new_group")
        verify_create_new_group_page(device)
    elif option.lower() == "add from directory":
        common.wait_for_and_click(device, people_dict, "add_from_directory")
        verify_add_from_directory_page(device)
    elif option.lower() == "create new contact":
        common.wait_for_and_click(device, people_dict, "create_new_contact")
        verify_create_new_contact_page(device)


def verify_create_new_group_page(device):
    common.wait_for_element(device, people_dict, "name_your_group")


def verify_add_from_directory_page(device):
    common.wait_for_element(device, people_dict, "add_from_directory_text_view")


def verify_create_new_contact_page(device):
    common.wait_for_element(device, people_dict, "create_new_contact_text_view")


def click_drop_down_menu_and_verify_list_of_groups(device):
    common.sleep_with_msg(device, 5, "Wait for groups to load and stabilize")
    group_name_list = common.get_all_elements_texts(device, people_dict, "group_list")
    if len(group_name_list) < 5:
        common.scroll_the_page(device, common.wait_for_element(device, people_dict, "people_list_container"), "up")
        group_name_list.extend(common.get_all_elements_texts(device, people_dict, "group_list"))
        if len(set(group_name_list)) < 5:
            raise AssertionError(f"{device}: All default groups aren't displayed: {group_name_list}")
    print(f"{device}: All default groups are visible on device: '{group_name_list}'")


def verify_default_group_name_from_drop_down(device):
    common.wait_for_element(device, people_dict, "favorites_group")
    common.wait_for_element(device, people_dict, "speed_dial_group")
    common.wait_for_element(device, people_dict, "other_contacts_group")


def select_group_from_drop_down(device, group_name):
    group_name_dict = {
        "all contacts": "all_contacts_group",
        "speed dial": "speed_dial_group",
        "other contacts": "other_contacts_group",
        "favorites": "favorites_group",
        "tagged": "tagged_group",
    }
    if group_name.lower() in group_name_dict.keys():
        group_name = group_name_dict[group_name.lower()]
        dicty = people_dict
    else:
        tmp_dict = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
        group_name = "group_name_xpath"
        dicty = tmp_dict
    if not common.is_element_present(device, dicty, group_name):
        common.scroll_the_page(device, common.wait_for_element(device, people_dict, "people_list_container"), "up")
        time.sleep(2)
    common.wait_for_and_click(device, dicty, group_name)


def verify_favorite_contacts_under_speed_dial_group(device):
    common.wait_for_element(device, people_dict, "speed_dial_group")
    user_title_elements = []
    user_list = common.wait_for_element(device, people_dict, "user_title", cond=EC.presence_of_all_elements_located)
    for i in user_list:
        user_title_elements.append(str(i.text))
    if len(user_title_elements) == 0:
        raise AssertionError("No favorite contacts added under speed dial group")
    print("list of favorite contacts : ", user_title_elements)


def close_add_contact_on_people_tab(device):
    common.wait_for_and_click(device, people_dict, "plus_icon")


def add_from_directory(from_device, to_device, group_name):
    verify_plus_icon_on_people_tab(from_device)
    click_on_plus_icon_on_people_tab(from_device)
    verify_plus_icon_two_options(from_device)
    select_people_app_option_and_verify(from_device, "Add from directory")
    displayname = config["devices"][to_device]["user"]["displayname"]

    common.kb_trigger_search(from_device, people_dict, "add_edit_text", displayname)

    tmp_dict = common.get_dict_copy(people_dict, "search_result_item_container", "config_display", displayname)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")

    group_name = group_name.lower().capitalize()
    tmp_dict1 = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
    common.wait_for_and_click(from_device, tmp_dict1, "group_name_xpath")

    print(f"{from_device} selected group name '{group_name}'")
    common.wait_for_and_click(from_device, people_dict, "action_submit")
    common.wait_for_element(from_device, people_dict, "group_arrow")
    select_group_from_drop_down(from_device, group_name)
    time.sleep(display_time)
    verify_usergroup_name_on_people_tab(from_device, to_device, group_name)
    if common.is_portrait_mode_cnf_device(from_device):
        common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")
    # Tap on same group to contract the user list
    select_group_from_drop_down(from_device, group_name)


def verify_usergroup_name_on_people_tab(from_device, to_device, group_name):
    open_people_card_from_people_app(from_device, to_device, group_name)
    displayname = common.device_displayname(to_device)
    if not common.is_element_present(from_device, people_dict, "appears_in_groups"):
        if config["devices"][from_device]["model"].lower() == "gilbert":
            calendar_keywords.scroll_down_secondary_tab(from_device)
    group_name_fetched = common.wait_for_element(from_device, people_dict, "appears_in_groups").text

    print("Group name is : ", group_name_fetched)
    group_names = group_name_fetched.split(",")
    grp_list = []
    for names in group_names:
        grp_list.append(names.lower().strip())
    print("grp_list : ", grp_list)
    time.sleep(display_time)
    if not group_name.lower() in grp_list:
        raise AssertionError(f"{from_device}: User: '{displayname}' is not added to the '{group_name}' group")
    print(f"{from_device}: User: '{displayname}' is added to the '{group_name}' group")


def open_people_card_from_people_app(from_device, to_device, group_name):
    displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(people_dict, "contact_title", "group_name", group_name)
    temp_dict = common.get_dict_copy(temp_dict, "contact_title", "replace_username", displayname)
    # In case, if double tapping on the group name has shrunk the username, tap on group name again to get username
    common.sleep_with_msg(from_device, 5, "Wait for group participant to load and stabilize")
    if not common.is_element_present(from_device, temp_dict, "contact_title", "xpath"):
        select_group_from_drop_down(from_device, group_name)
    common.wait_for_and_click(from_device, temp_dict, "contact_title", "xpath")
    # wait for sometime and again tap on the contact for group name to be loaded
    time.sleep(5)
    if common.is_portrait_mode_cnf_device(from_device):
        common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")
        common.sleep_with_msg(from_device, 7, "React to back button click")
    settings_keywords.refresh_main_tab(from_device)
    common.wait_for_and_click(from_device, temp_dict, "contact_title", "xpath")


def verify_contact_card_details_on_people_app_page(from_device, to_device, group_name="All Contacts"):
    navigate_to_people_tab(from_device)
    open_people_card_from_people_app(from_device, to_device, group_name)
    displayname = getconfig_displayname(to_device)
    common.wait_for_element(from_device, people_dict, "user_profile_picture")
    tmp_dict = common.get_dict_copy(people_dict, "user_name_toolbar_title", "display_name", displayname)
    common.wait_for_element(from_device, tmp_dict, "user_name_toolbar_title")
    common.wait_for_element(from_device, people_dict, "make_an_audio_call")
    common.wait_for_element(from_device, people_dict, "email")
    if not common.is_element_present(from_device, people_dict, "appears_in"):
        print(f"{from_device}: The user is on not in any group, so group name is not displayed")


def verify_selected_usergroup_name(from_device, group_name):
    _group_names = common.wait_for_element(from_device, people_dict, "appears_in_groups").text
    _groups = _group_names.split(",")
    _group_list = []
    for _name in _groups:
        _group_list.append(_name.lower().strip())
    if group_name.lower() not in _group_list:
        raise AssertionError(f"{from_device}: Couldn't find '{group_name}' group in appears in list: '{_group_list}'")


def verify_multiple_group_name_for_one_user(from_device, to_device, group_name):
    navigate_to_people_tab(from_device)
    displayname = config["devices"][to_device]["user"]["displayname"]
    expected_group_names_list = group_name.split(",")
    open_people_card_from_people_app(from_device, to_device, expected_group_names_list[0])
    common.sleep_with_msg(from_device, 3, "Wait until contact card loads")
    if not common.is_element_present(from_device, people_dict, "appears_in_groups"):
        if config["devices"][from_device]["model"].lower() == "gilbert":
            calendar_keywords.scroll_down_secondary_tab(from_device)
    reflect_group_names = common.wait_for_element(from_device, people_dict, "appears_in_groups").text
    verify_contact_card_details_on_people_app_page(from_device, to_device, expected_group_names_list[0])

    reflect_group_names = reflect_group_names.split(",")
    actual_group_names_list = []
    for names in reflect_group_names:
        actual_group_names_list.append(names.lower().strip())
    for names in expected_group_names_list:
        name = names.lower().strip()
        if name not in actual_group_names_list:
            raise AssertionError(
                f"{from_device}: '{to_device}' user's expected group list: '{expected_group_names_list}', but found: '{actual_group_names_list}'"
            )
    if common.is_portrait_mode_cnf_device(from_device):
        common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")


def create_new_group(device, group_name="test_group", group_creation_result="original"):
    if group_creation_result.lower() not in ["original", "duplicate"]:
        raise AssertionError(f"{device}: Illegal argument for 'group_creation_result': '{group_creation_result}'")
    verify_plus_icon_on_people_tab(device)
    click_on_plus_icon_on_people_tab(device)
    verify_plus_icon_two_options(device)
    select_people_app_option_and_verify(device, "Create new group")
    group_name_field = common.wait_for_element(device, people_dict, "name_your_group")
    group_name_field.send_keys(group_name)
    if config["devices"][device]["model"].lower() == "gilbert":
        common.hide_keyboard(device)
    common.wait_for_and_click(device, people_dict, "create_btn")
    common.sleep_with_msg(device, 3, "Wait post creating the group")
    if group_creation_result.lower() == "duplicate":
        validate_duplicate_group_name(device, group_name)
        return
    # If there is an existing group with same name, ignore the error message and access the existing group
    if common.is_element_present(device, people_dict, "error_msg", "xpath"):
        common.wait_for_and_click(device, people_dict, "ok_btn")
        common.wait_for_and_click(device, people_dict, "cancel_btn")
    time.sleep(display_time)
    click_drop_down_menu_and_verify_group_name(device, group_name)


def click_drop_down_menu_and_verify_group_name(device, group_name):
    if not common.click_if_element_appears(device, people_dict, "group_name_arrow", max_attempts=3):
        common.wait_for_element(device, people_dict, "group_arrow")
    tmp_dict = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
    common.wait_for_element(device, tmp_dict, "group_name_xpath")
    time.sleep(display_time)
    select_group_from_drop_down(device, group_name)


def delete_group_if_exist(device, group_names):
    navigate_to_people_tab(device)
    group_names = group_names.split(",")
    for group_name in group_names:
        tmp_dict = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
        if common.is_element_present(device, tmp_dict, "group_name_xpath"):
            delete_group(device, group_name)


def delete_group(device, group_name):
    navigate_to_people_tab(device)
    select_group_from_drop_down(device, group_name)
    temp_dict = common.get_dict_copy(people_dict, "more_option", "group_name", group_name)
    time.sleep(display_time)
    common.wait_for_and_click(device, temp_dict, "more_option", "xpath")
    common.wait_for_and_click(device, people_dict, "edit_group")
    temp_dict = common.get_dict_copy(people_dict, "name_your_group", "Name your group", group_name)
    common.wait_for_element(device, temp_dict, "name_your_group", "xpath")
    _model = common.device_model(device)
    if _model in ["loveland", "glendale"]:
        common.press_hardkeys(device, hardkey_intent=4)
    common.wait_for_and_click(device, people_dict, "delete_group")
    common.click_if_element_appears(device, home_screen_dict, "home_bar_icon", max_attempts=2)
    navigate_to_people_tab(device)
    tmp_dict = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
    common.wait_while_present(device, tmp_dict, "group_name_xpath", max_wait_attempts=2)


def edit_group_name(device, old_group_name, new_group_name):
    common.wait_for_element(device, people_dict, "group_arrow")
    time.sleep(display_time)
    select_group_from_drop_down(device, old_group_name)
    temp_dict = common.get_dict_copy(people_dict, "more_option", "group_name", old_group_name)
    time.sleep(3)
    if not common.click_if_present(device, temp_dict, "more_option", "xpath"):
        common.wait_for_and_click(device, people_dict, "more_option", "xpath1")
    common.wait_for_and_click(device, people_dict, "edit_group")
    tmp_dict = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", old_group_name)
    temp_dict1 = common.get_dict_copy(people_dict, "name_your_group", "Name your group", old_group_name)
    time.sleep(display_time)
    if not common.click_if_element_appears(device, tmp_dict, "group_name_xpath", max_attempts=3):
        common.wait_for_and_click(device, temp_dict1, "name_your_group", "xpath")
    elem = common.wait_for_element(device, people_dict, "name_your_group").clear()
    elem.send_keys(new_group_name)
    common.wait_for_and_click(device, people_dict, "save_btn")
    time.sleep(display_time)
    if common.is_element_present(device, people_dict, "error_msg"):
        common.wait_for_and_click(device, people_dict, "ok_btn")
        common.wait_for_and_click(device, people_dict, "cancel_btn")
    click_drop_down_menu_and_verify_group_name(device, new_group_name)


def clicked_first_contact(device):
    common.wait_for_and_click(device, people_dict, "contact_title")


def validate_global_search_and_call_park_icon(device):
    common.wait_for_and_click(device, calls_dict, "search")
    common.wait_for_element(device, calls_dict, "search_text")
    common.wait_for_and_click(device, calls_dict, "Call_Back_Button")
    common.wait_for_and_click(device, people_dict, "people_more_tab")
    common.wait_for_element(device, people_dict, "people_tab_unpark_call")
    call_keywords.dismiss_call_more_options(device)


def validate_create_new_group_with_empty_name(device):
    verify_plus_icon_on_people_tab(device)
    click_on_plus_icon_on_people_tab(device)
    verify_plus_icon_two_options(device)
    select_people_app_option_and_verify(device, "Create new group")
    common.wait_for_element(device, people_dict, "name_your_group").send_keys("")
    common.wait_for_and_click(device, people_dict, "create_btn")
    common.wait_for_element(device, people_dict, "empty_group_error_msg")
    common.wait_for_and_click(device, people_dict, "ok_btn")
    common.wait_for_and_click(device, people_dict, "cancel_btn")


def verify_added_group_name_for_user(from_device, to_device, group_name):
    select_group_from_drop_down(from_device, group_name)
    verify_usergroup_name_on_people_tab(from_device, to_device, group_name)

    # Back button only expected in portrait mode:
    if common.is_portrait_mode_cnf_device(from_device):
        common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")

    # tap again on the same group to contract the user list
    select_group_from_drop_down(from_device, group_name)


def add_contact_to_group_by_global_contact_search_icon(from_device, to_device, group_name):
    driver = obj.device_store.get(alias=from_device)
    displayname = config["devices"][to_device]["user"]["displayname"]
    username = config["devices"][to_device]["user"]["username"].split("@")[0]
    print("search text :", username)
    try:
        WebDriverWait(driver, 30).until(EC.element_to_be_clickable((MobileBy.ID, calls_dict["search"]["id"]))).click()
        element = WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((MobileBy.ID, calls_dict["search_text"]["id"]))
        )
        element.send_keys(username)
        time.sleep(display_time)
        try:
            driver.hide_keyboard()
        except Exception as e:
            print("Cannot hide keyboard : ", e)
        search_result_xpath = (calls_dict["search_result_item_container"]["xpath"]).replace(
            "config_display", displayname
        )
        print("Search result xpath : ", search_result_xpath)
        WebDriverWait(driver, 30).until(EC.element_to_be_clickable((MobileBy.XPATH, search_result_xpath))).click()
        time.sleep(display_time)
        print("We are in User contact card page")
        try:
            WebDriverWait(driver, 5).until(
                EC.element_to_be_clickable((MobileBy.ID, people_dict["ppl_more_options_button"]["id"]))
            ).click()
            print("Clicked on more_options_button id.")
        except Exception as e:
            try:
                WebDriverWait(driver, 5).until(
                    EC.element_to_be_clickable((MobileBy.ID, people_dict["ppl_more_options_button"]["id1"]))
                ).click()
                print("Clicked on more_options_button id1")
            except Exception as e:
                WebDriverWait(driver, 5).until(
                    EC.element_to_be_clickable((MobileBy.XPATH, people_dict["ppl_more_options_button"]["xpath"]))
                ).click()
                print("Clicked on more_options_button xpath")
        print("Clicked on MORE button")
        WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((MobileBy.XPATH, people_dict["add_to_contacts"]["xpath"]))
        ).click()
        print("Clicked on ADD TO CONTACT button")
        group_name = group_name.lower().capitalize()
        group_name_xpath = (people_dict["group_name_xpath"]["xpath"]).replace("group_name", group_name)
        print("Search group_name_xpath xpath : ", group_name_xpath)
        group_name_xpath1 = (people_dict["group_name_xpath"]["xpath1"]).replace("group_name", group_name)
        print("Search group_name_xpath xpath1 : ", group_name_xpath1)
        try:
            WebDriverWait(driver, 5).until(EC.element_to_be_clickable((MobileBy.XPATH, group_name_xpath))).click()
        except Exception as e:
            settings_keywords.swipe_till_end(from_device)
            WebDriverWait(driver, 5).until(EC.element_to_be_clickable((MobileBy.XPATH, group_name_xpath1))).click()
        time.sleep(display_time)
        print("selected ", group_name, " group name")
        WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((MobileBy.ID, people_dict["action_submit"]["id"]))
        ).click()
        print("Clicked on Save button")
        call_keywords.come_back_to_home_screen(from_device)
        verify_added_group_name_for_user(from_device, to_device, group_name)
    except Exception as e:
        raise AssertionError("Xpath not found")


def validate_duplicate_group_name(device, group_name):
    common.wait_for_element(device, people_dict, "error_msg")
    common.wait_for_and_click(device, people_dict, "ok_btn")
    groupname = common.wait_for_element(device, people_dict, "name_your_group", "id").text
    if groupname != group_name:
        raise AssertionError(
            f"{device}: Duplicate group pop-up is displayed for group: '{groupname}', but expected pop-up for: '{group_name}'"
        )
    common.wait_for_and_click(device, people_dict, "cancel_btn")


def click_cancel_btn(device):
    if config["devices"][device]["model"].lower() == "gilbert":
        common.hide_keyboard(device)
    common.wait_for_and_click(device, people_dict, "cancel_btn")


def verify_group_page_when_no_user_added(device, group_name):
    temp_dict = common.get_dict_copy(people_dict, "more_option_for_group_participant", "group_name", group_name)
    common.wait_while_present(device, temp_dict, "more_option_for_group_participant", "xpath1")


def validate_selected_group_users_name_on_people_tab(device, participant_device, group_name):
    expected_username = common.device_displayname(participant_device)
    temp_dict = common.get_dict_copy(people_dict, "more_option_for_group_participant", "group_name", group_name)
    actual_username = common.wait_for_element(device, temp_dict, "more_option_for_group_participant", "xpath1").text
    if expected_username != actual_username:
        raise AssertionError(f"{device}: Expected user: {expected_username}, but found: {actual_username}")


def verify_presence_in_contact_card_page(device):
    driver = obj.device_store.get(alias=device)
    try:
        WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((MobileBy.XPATH, people_dict["presence_xpath"]["xpath"]))
        )
        print("Participant Presence available")
    except Exception as e:
        raise AssertionError("Xpath not found")
    try:
        WebDriverWait(driver, 5).until(
            EC.element_to_be_clickable((MobileBy.XPATH, common_dict["back"]["xpath"]))
        ).click()
        print("Clicked on BACK button")
    except Exception as e:
        pass


def validate_when_user_search_for_its_own_name_in_search_result(device):
    verify_plus_icon_on_people_tab(device)
    click_on_plus_icon_on_people_tab(device)
    verify_plus_icon_two_options(device)
    select_people_app_option_and_verify(device, "Add from directory")
    displayname = common.device_displayname(device)
    print(f"{device}: User displayname: {displayname}")
    common.kb_trigger_search(device, people_dict, "add_edit_text", displayname)
    tmp_dict = common.get_dict_copy(people_dict, "search_result_item_container", "config_display", displayname)
    common.wait_for_element(device, tmp_dict, "search_result_item_container", "xpath")
    common.return_to_home_screen(device)


def remove_user_from_group(from_device, to_device, group_names, select_contact="group", failTest=True):
    if not select_contact.lower() in ["group", "all_contacts"]:
        raise AssertionError(f"Illegal option specified: '{select_contact}'")
    navigate_to_people_tab(from_device)
    group_names = group_names.split(",")
    for group_name in group_names:
        group_name = "all contacts" if select_contact.lower() == "all_contacts" else group_name
        common.wait_for_element(from_device, people_dict, "group_arrow")
        user_to_be_removed = common.device_displayname(to_device)
        # Select the group
        select_group_from_drop_down(from_device, group_name)
        # Prepare to locate the user's more options
        temp_dict = common.get_dict_copy(people_dict, "contact_more_options", "group_name", group_name)
        temp_dict = common.get_dict_copy(temp_dict, "contact_more_options", "replace_username", user_to_be_removed)
        # In case, if double tapping on the group name has shrunk the username, tap on group name again to get username
        common.sleep_with_msg(from_device, 5, "Wait for group participant to load and stabilize")
        if not common.is_element_present(from_device, temp_dict, "contact_more_options"):
            print(f"{user_to_be_removed}: is not found in : {group_name} xpath: {temp_dict}")
            select_group_from_drop_down(from_device, group_name)

        if not common.is_element_present(from_device, temp_dict, "contact_more_options"):
            if failTest:
                raise AssertionError(
                    f"{from_device}: not able to find  '{user_to_be_removed}' more option under '{group_name}'"
                )
            else:
                print(
                    f"{from_device}: not able to find '{user_to_be_removed}' more option under '{group_name} - ignoring failure'"
                )
                return

        common.wait_for_and_click(from_device, temp_dict, "contact_more_options")
        common.wait_for_element(from_device, people_dict, "add_to_group")
        common.wait_for_and_click(from_device, people_dict, "remove_from_group")
        time.sleep(display_time)
        common.click_if_present(from_device, common_dict, "back")


def validate_username_and_designation_on_people_tab(device):
    first_group_participant = common.wait_for_element(device, people_dict, "user_title").text
    if common.is_element_present(device, people_dict, "user_designation"):
        designation = common.wait_for_element(device, people_dict, "user_designation").text
        print(f"{device}: first group participant is: {first_group_participant}, designation is: {designation}")


def add_user_to_newly_created_group_from_add_contact_page(from_device, to_device, group_name):
    verify_plus_icon_on_people_tab(from_device)
    click_on_plus_icon_on_people_tab(from_device)
    verify_plus_icon_two_options(from_device)
    select_people_app_option_and_verify(from_device, "Add from directory")
    displayname = config["devices"][to_device]["user"]["displayname"]

    common.kb_trigger_search(from_device, people_dict, "add_edit_text", displayname)

    tmp_dict = common.get_dict_copy(people_dict, "search_result_item_container", "config_display", displayname)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")
    common.wait_for_and_click(from_device, people_dict, "create_group_text")
    common.wait_for_element(from_device, people_dict, "name_your_group").send_keys(group_name)
    common.wait_for_and_click(from_device, people_dict, "create_btn")
    if common.is_element_present(from_device, people_dict, "error_msg"):
        common.wait_for_and_click(from_device, people_dict, "ok_btn")
        common.wait_for_and_click(from_device, people_dict, "cancel_btn")
    tmp_dict1 = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
    common.wait_for_and_click(from_device, tmp_dict1, "group_name_xpath")
    print("selected ", group_name, " group name")
    common.wait_for_and_click(from_device, people_dict, "action_submit")
    common.click_if_present(from_device, calls_dict, "Call_Back_Button")


def verify_user_in_all_contacts(from_device, to_device):
    time.sleep(3)
    display_name = config["devices"][to_device]["user"]["displayname"]
    temp_dict = common.get_dict_copy(people_dict, "contact_title", "group_name", "All Contacts")
    temp_dict = common.get_dict_copy(temp_dict, "contact_title", "replace_username", display_name)
    if not common.is_element_present(from_device, temp_dict, "contact_title", "xpath"):
        # in case tapping on group name collapsed the group
        select_group_from_drop_down(from_device, "All Contacts")
        if not common.is_element_present(from_device, temp_dict, "contact_title", "xpath"):
            print(f"{display_name}: is not found in last attempt in : All Contacts xpath: {temp_dict}")
            raise AssertionError(f"{from_device}: {display_name} not found in all contacts list")


def verify_user_profile_avatar(device):
    people_text = common.wait_for_element(device, people_dict, "Header").text
    if not people_text == "People":
        raise AssertionError(f"{device} is not on People tab")
    common.wait_for_element(device, people_dict, "user_profile_picture")


def click_on_people_tab(device):
    time.sleep(display_time)
    if common.is_element_present(device, calls_dict, "search"):
        return
    if not common.click_if_present(device, people_dict, "people_tab"):
        if common.is_element_present(device, app_bar_dict, "more_tab"):
            common.wait_for_and_click(device, app_bar_dict, "more_tab")
            common.wait_for_and_click(device, people_dict, "people_tab")
        else:
            common.wait_for_and_click(device, people_dict, "people_tab_cap")
    time.sleep(display_time)
    if common.is_lcp(device):
        common.wait_for_element(device, calls_dict, "search_icon")
    else:
        common.wait_for_element(device, calls_dict, "search")


def check_and_close_create_new_group_window(device):
    if common.is_element_present(device, people_dict, "name_your_group"):
        common.wait_for_and_click(device, people_dict, "cancel_btn")


def verify_error_message_after_removing_group_name(device, group_name):
    if not common.click_if_element_appears(device, people_dict, "group_name_arrow", max_attempts=3):
        common.wait_for_element(device, people_dict, "group_arrow")
    select_group_from_drop_down(device, group_name)
    temp_dict = common.get_dict_copy(people_dict, "more_option", "group_name", group_name)
    common.wait_for_and_click(device, temp_dict, "more_option", "xpath")
    common.wait_for_and_click(device, people_dict, "edit_group")
    tmp_dict = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
    temp_dict1 = common.get_dict_copy(people_dict, "name_your_group", "Name your group", group_name)
    if not common.click_if_element_appears(device, tmp_dict, "group_name_xpath", max_attempts=3):
        common.wait_for_and_click(device, temp_dict1, "name_your_group", "xpath")
    elem = common.wait_for_element(device, people_dict, "name_your_group")
    elem.clear()
    common.wait_for_and_click(device, people_dict, "save_btn")
    common.wait_for_element(device, people_dict, "invalid_input")
    common.wait_for_and_click(device, people_dict, "ok_btn")
    common.wait_for_element(device, people_dict, "cancel_btn")
    elem.send_keys(group_name)
    common.wait_for_and_click(device, people_dict, "save_btn")
    click_drop_down_menu_and_verify_group_name(device, group_name)


def verify_options_inside_people_tab_for_lcp(device):
    common.wait_for_element(device, calls_dict, "search_icon")
    common.wait_for_element(device, people_dict, "all_contacts_group_lcp")
    common.wait_for_element(device, people_lcp_dict, "favorites_group")
    common.wait_for_element(device, people_lcp_dict, "other_contacts_group")
    common.wait_for_element(device, people_lcp_dict, "speed_dial_group")
    calendar_keywords.scroll_only_once(device)
    common.wait_for_element(device, people_dict, "tagged_group")
    common.wait_for_element(device, people_dict, "people_more_lcp")
    # common.get_all_elements_texts(device, people_dict, "group_list")
    # call_keywords.dismiss_the_popup_screen(device)
    common.wait_for_element(device, people_dict, "people_tab_cap")
    common.wait_for_and_click(device, common_dict, "home_btn")


def verify_list_of_group_names_in_people_tab(device):
    group_names = common.wait_for_element(
        device, people_dict, "group_list", "id", cond=EC.presence_of_all_elements_located
    )
    group_names_list = []
    for ele in group_names:
        ele1 = ele.get_attribute("content-desc")
        group_names_list.append(ele1)
    print(f"{device}: List of groups on People Tab are {group_names_list}")


def verify_all_contacts_group_name_is_in_first_group(device):
    group_names = common.wait_for_element(
        device, people_dict, "group_list", "xpath1", cond=EC.presence_of_all_elements_located
    )
    group_names_list = []
    for ele in group_names:
        ele1 = ele.get_attribute("content-desc")
        group_names_list.append(ele1)
    print(f"{device}: List of groups on People Tab are {group_names_list}")
    if "All Contacts" != group_names_list[0]:
        raise AssertionError(f"{device}: 'All contacts' is not the first group name in people tab")


def verify_search_icon_in_people_tab(device):
    if not verify_people_navigation(device):
        navigate_to_people_tab(device)
    if common.is_lcp(device):
        common.wait_for_element(device, calls_dict, "search_icon")
    else:
        common.wait_for_element(device, calls_dict, "search")
    if common.is_conf(device):
        common.wait_for_element(device, people_dict, "people_more_tab")
        common.wait_for_element(device, calls_dict, "add_contact")


def validate_when_user_search_for_a_contact_in_search_result(from_device, to_device):
    verify_search_icon_in_people_tab(from_device)
    displayname = common.device_displayname(to_device)
    if common.is_lcp(from_device):
        common.kb_trigger_search(from_device, calls_dict, "search_icon", displayname)
    else:
        common.kb_trigger_search(from_device, calls_dict, "search", displayname)
    tmp_dict = common.get_dict_copy(people_dict, "search_result_item_container", "config_display", displayname)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")
    verify_contact_card_details_on_people_app_page(from_device, to_device)
    common.wait_for_element(from_device, people_dict, "contact_card_full_view")
    if common.is_element_present(from_device, people_dict, "more_option"):
        raise AssertionError("User is able to add contact to the group by contact search")
    common.return_to_home_screen(from_device)


def validate_when_user_search_for_a_contact_in_search_result_when_secondary_contact_is_added(
    from_device, to_device, to_device_contact_number
):
    verify_search_icon_in_people_tab(from_device)
    displayname = common.device_displayname(to_device)
    common.kb_trigger_search(from_device, calls_dict, "search", displayname)
    tmp_dict = common.get_dict_copy(people_dict, "search_result_item_container", "config_display", displayname)
    common.wait_for_and_click(from_device, tmp_dict, "search_result_item_container", "xpath")
    verify_contact_card_details_on_people_app_page_when_secondary_contact_is_added(
        from_device, to_device, to_device_contact_number
    )
    common.wait_for_element(from_device, people_dict, "contact_card_full_view")


def verify_contact_card_details_on_people_app_page_when_secondary_contact_is_added(
    from_device, to_device, to_device_contact_number
):
    displayname = common.device_displayname(to_device)
    common.wait_for_element(from_device, people_dict, "user_profile_picture")
    expected_user_mail_id = common.device_username(to_device).lower()
    actual_user_mail_id = common.wait_for_element(from_device, people_dict, "user_mail_id").text
    if expected_user_mail_id != actual_user_mail_id.lower():
        raise AssertionError(f"{from_device}: User email ID is incorrect")
    common.wait_for_element(from_device, people_dict, "make_an_audio_call")
    common.wait_for_element(from_device, calls_dict, "Make_a_call_to_voicemail")
    to_device_secondary_phone_number = common.device_phonenumber(to_device_contact_number)
    expected_DID_for_work_phone = common.wait_for_element(from_device, people_dict, "work_phone_number").text
    print(f"{from_device}: Expected DID for Work Phone is :", expected_DID_for_work_phone)
    if int(to_device_secondary_phone_number) != int(expected_DID_for_work_phone):
        raise AssertionError(f"{from_device}: Added secondary phone number incorrect")
    expected_DID_for_mobile_phone = common.wait_for_element(from_device, people_dict, "mobile_phone_number").text
    print(f"{from_device}: Expected DID for Mobile Phone is :", expected_DID_for_mobile_phone)
    if int(to_device_secondary_phone_number) != int(expected_DID_for_mobile_phone):
        raise AssertionError(f"{from_device}: Added secondary phone number incorrect")


def dial_configured_secondary_number(from_device, to_device, to_device_contact_number, call_option):
    to_device_secondary_phone_number = common.device_phonenumber(to_device_contact_number)
    if call_option.lower() == "work_phone":
        expected_DID_for_work_phone = common.wait_for_element(from_device, people_dict, "work_phone_number").text
        print(f"{from_device}: Expected DID for Work Phone is :", expected_DID_for_work_phone)
        if int(to_device_secondary_phone_number) != int(expected_DID_for_work_phone):
            raise AssertionError(f"{from_device}: Added secondary phone number incorrect")
        common.wait_for_and_click(from_device, people_dict, "work_phone_number")
    elif call_option.lower() == "mobile_phone":
        expected_DID_for_mobile_phone = common.wait_for_element(from_device, people_dict, "mobile_phone_number").text
        print(f"{from_device}: Expected DID for Mobile Phone is :", expected_DID_for_mobile_phone)
        if int(to_device_secondary_phone_number) != int(expected_DID_for_mobile_phone):
            raise AssertionError(f"{from_device}: Added secondary phone number incorrect")
        common.wait_for_and_click(from_device, people_dict, "work_phone_number")


def unpark_call_from_people_tab(park_code, device):
    if not common.is_element_present(device, people_dict, "people_more_tab"):
        for i in range(2):
            common.click_if_present(device, calls_dict, "Call_Back_Button")
        time.sleep(display_time)
        if not common.is_element_present(device, people_dict, "people_more_tab"):
            navigate_to_people_tab(device)
    if common.is_lcp(device):
        common.wait_for_and_click(device, people_dict, "people_more_lcp")
    else:
        common.wait_for_and_click(device, people_dict, "people_more_tab")
    common.wait_for_and_click(device, people_dict, "people_tab_unpark_call")
    unpark_code_input = common.wait_for_element(device, calls_dict, "unpark_code_edit_text")
    print("park_code : ", park_code)
    unpark_code_input.send_keys(park_code)
    if not common.is_lcp(device):
        common.wait_for_and_click(device, calls_dict, "unpark_call_ok_button")
    _max_attempt = 5
    for _attempt in range(_max_attempt):
        if common.is_element_present(device, calls_dict, "Hang_up_button"):
            return


def select_option_from_more_option_inside_all_contact_group(device, to_device, option):
    if option.lower() not in ["call", "add_speed_dial", "add_group", "remove_speed_dial"]:
        raise AssertionError(f"{device}: Unexpected value for Transfer option: {option}")
    verify_plus_icon_on_people_tab(device)
    displayname = common.device_displayname(to_device)
    common.wait_for_and_click(device, people_dict, "all_contacts_group")
    users_list = common.get_all_elements_texts(device, people_dict, "users_list_in_people_tab")
    if displayname not in users_list:
        raise AssertionError(f"{device}: {displayname} not found in all contacts list")
    tmp_dict = common.get_dict_copy(calls_dict, "all_contact_more_option", "config_display", displayname)
    common.wait_for_and_click(device, tmp_dict, "all_contact_more_option")
    common.wait_for_element(device, calls_dict, "call")
    common.wait_for_element(device, people_dict, "add_to_group")
    if not common.is_element_present(device, calls_dict, "remove_user_from_speed_dial"):
        common.wait_for_element(device, calls_dict, "call_list_item_favorites_action")
    if option.lower() == "call":
        common.wait_for_and_click(device, calls_dict, "call")
    elif option.lower() == "add_speed_dial":
        common.wait_for_and_click(device, calls_dict, "call_list_item_favorites_action")
    elif option.lower() == "add_group":
        common.wait_for_and_click(device, people_dict, "add_to_group")
    elif option.lower() == "remove_user_from_speed_dial":
        common.wait_for_and_click(device, calls_dict, "remove_user_from_speed_dial")


def add_user_to_a_group_from_all_contacts_page(from_device, to_device, group_name=None, create_new_group=None):
    verify_plus_icon_on_people_tab(from_device)
    to_device_displayname = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(people_dict, "contact_title", "group_name", "All Contacts")
    temp_dict = common.get_dict_copy(temp_dict, "contact_title", "replace_username", to_device_displayname)
    common.wait_for_and_click(from_device, people_dict, "all_contacts_group")
    # In case, if double tapping on the group name has shrunk the username, tap on group name again to get username
    if not common.is_element_present(from_device, temp_dict, "contact_title", "xpath"):
        print(f"{to_device_displayname}: is not found in : {group_name} :xpath : {temp_dict}")
        common.wait_for_and_click(from_device, people_dict, "all_contacts_group")
    users_list = common.get_all_elements_texts(from_device, people_dict, "users_list_in_people_tab")
    if to_device_displayname not in users_list:
        raise AssertionError(f"{from_device}: {to_device_displayname} not found in all contacts list")
    temp_dict1 = common.get_dict_copy(people_dict, "contact_more_options", "group_name", "All Contacts")
    temp_dict1 = common.get_dict_copy(temp_dict1, "contact_more_options", "replace_username", to_device_displayname)
    common.wait_for_and_click(from_device, temp_dict1, "contact_more_options")
    common.wait_for_element(from_device, calls_dict, "call_option")
    common.wait_for_and_click(from_device, people_dict, "add_to_group")
    common.wait_for_element(from_device, people_dict, "select_a_group_to_edit")
    common.wait_for_element(from_device, people_dict, "create_new_group")
    print(f"Group Name: {group_name}")
    print(f"Create New Group: {create_new_group}")
    if create_new_group == "test_group":
        common.wait_for_and_click(from_device, people_dict, "create_new_group")
        common.wait_for_element(from_device, people_dict, "name_your_group").send_keys(create_new_group)
        common.wait_for_and_click(from_device, people_dict, "create_btn")
        time.sleep(display_time)
        common.tap_outside_the_popup(from_device, common.wait_for_element(from_device, calls_dict, "pop_up_container"))
        return
    tmp_dict3 = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
    common.wait_for_and_click(from_device, tmp_dict3, "group_name_xpath")
    time.sleep(display_time)
    common.tap_outside_the_popup(from_device, common.wait_for_element(from_device, calls_dict, "pop_up_container"))
    common.wait_for_and_click(from_device, people_dict, "all_contacts_group")


def has_hardkey_contact_button_supported_device(device):
    _model = common.device_model(device)
    if _model in [
        "riverside_13",
        "bakersfield_13",
        "santa cruz_13",
        "Scottsdale",
        "Olympia",
        "Seattle",
        "Redmond",
        "Kirkland",
        "riverside",
        "bakersfield",
        "santa cruz",
        "Loveland",
        "Glendale",
    ]:
        print(f"{device}: is not having contact button")
        return False
    return True


def create_new_contact(from_device, to_device, group_name):
    verify_plus_icon_on_people_tab(from_device)
    click_on_plus_icon_on_people_tab(from_device)
    select_people_app_option_and_verify(from_device, "Create new contact")
    contact_phone = common.device_phonenumber(to_device)
    contact_name = common.device_displayname(to_device)
    temp_dict = common.get_dict_copy(people_dict, "create_contact_edit_field", "edit_field_content", "Full Name")
    full_name_field = common.wait_for_element(from_device, temp_dict, "create_contact_edit_field")
    full_name_field.send_keys(contact_name)
    if getconfig_device_model(from_device).lower() == "gilbert":
        common.hide_keyboard(from_device)
    temp_dict = common.get_dict_copy(people_dict, "create_contact_edit_field", "edit_field_content", "Phone")
    phone_field = common.wait_for_element(from_device, temp_dict, "create_contact_edit_field")
    phone_field.send_keys(contact_phone)
    if getconfig_device_model(from_device).lower() == "gilbert":
        common.hide_keyboard(from_device)
    common.wait_for_and_click(from_device, people_dict, "action_submit")
    group_name = group_name.lower().capitalize()
    tmp_dict1 = common.get_dict_copy(people_dict, "group_name_xpath", "group_name", group_name)
    common.wait_for_and_click(from_device, tmp_dict1, "group_name_xpath")
    common.wait_for_and_click(from_device, people_dict, "action_submit")
    common.wait_for_element(from_device, people_dict, "group_arrow")
    select_group_from_drop_down(from_device, group_name)
    time.sleep(display_time)
    verify_usergroup_name_on_people_tab(from_device, to_device, group_name)
    if common.is_portrait_mode_cnf_device(from_device):
        common.wait_for_and_click(from_device, calls_dict, "Call_Back_Button")
    # Tap on same group to contract the user list
    select_group_from_drop_down(from_device, group_name)


def delete_external_contact(from_device, to_device, failTest=True):
    user_to_be_removed = common.device_displayname(to_device)
    delete_external_contact_by_name(from_device, user_to_be_removed, failTest)


def delete_external_contact_by_name(from_device, user_to_be_removed, failTest=True):
    navigate_to_people_tab(from_device)
    common.wait_for_element(from_device, people_dict, "group_arrow")
    temp_dict = common.get_dict_copy(people_dict, "contact_more_options", "group_name", "All Contacts")
    temp_dict = common.get_dict_copy(temp_dict, "contact_more_options", "replace_username", user_to_be_removed)
    common.wait_for_and_click(from_device, people_dict, "all_contacts_group")
    # In case, if double tapping on the group name has shrunk the username, tap on group name again to get username
    if not common.is_element_present(from_device, temp_dict, "contact_more_options", "xpath"):
        common.wait_for_and_click(from_device, people_dict, "all_contacts_group")

    if not common.is_element_present(from_device, temp_dict, "contact_more_options", "xpath"):
        if failTest:
            print(f"{user_to_be_removed}: more option not found in All Contacts xpath: {temp_dict}")
            raise AssertionError(f"{from_device}: {user_to_be_removed} more option not found in all contacts list")
        else:
            print(f"{from_device}: User '{user_to_be_removed}' more options not found - ignoring failure'")
            return

    common.wait_for_and_click(from_device, temp_dict, "contact_more_options")
    common.sleep_with_msg(from_device, 5, "Wait for more options to load and stabilize")
    # Tap on more options and delete
    common.wait_for_and_click(from_device, people_dict, "delete_contact")
    common.wait_while_present(from_device, people_dict, "delete_contact", max_wait_attempts=2)
    common.click_if_present(from_device, common_dict, "back")


def edit_external_contact(from_device, to_device, updated_name):
    navigate_to_people_tab(from_device)
    common.wait_for_element(from_device, people_dict, "group_arrow")
    user_to_be_updated = common.device_displayname(to_device)
    # Open all contact group and find the user to be updated
    temp_dict = common.get_dict_copy(people_dict, "contact_title", "group_name", "All Contacts")
    temp_dict = common.get_dict_copy(temp_dict, "contact_title", "replace_username", user_to_be_updated)
    common.wait_for_and_click(from_device, people_dict, "all_contacts_group")
    # In case, if double tapping on the group name has shrunk the username, tap on group name again to get username
    if not common.is_element_present(from_device, temp_dict, "contact_title", "xpath"):
        common.wait_for_and_click(from_device, people_dict, "all_contacts_group")
    # Prepare to locate the user's more options
    temp_dict1 = common.get_dict_copy(people_dict, "contact_more_options", "group_name", "All Contacts")
    temp_dict1 = common.get_dict_copy(temp_dict1, "contact_more_options", "replace_username", user_to_be_updated)
    common.sleep_with_msg(from_device, 5, "Wait for group participant to load and stabilize")
    # Tap on more options and edit
    common.wait_for_and_click(from_device, temp_dict1, "contact_more_options")
    common.sleep_with_msg(from_device, 5, "Wait for more options to load and stabilize")
    common.wait_for_and_click(from_device, people_dict, "edit_contact", "xpath")
    contact_phone = common.device_phonenumber(to_device)
    contact_name = common.device_displayname(to_device)
    # Removing already entered name and phone number
    temp_dict = common.get_dict_copy(people_dict, "create_contact_edit_field", "edit_field_content", contact_name)
    full_name_field = common.wait_for_element(from_device, temp_dict, "create_contact_edit_field")
    full_name_field.send_keys("")
    if getconfig_device_model(from_device).lower() == "gilbert":
        common.hide_keyboard(from_device)
    temp_dict = common.get_dict_copy(people_dict, "create_contact_edit_field", "edit_field_content", contact_phone)
    phone_field = common.wait_for_element(from_device, temp_dict, "create_contact_edit_field")
    phone_field.send_keys("")
    if getconfig_device_model(from_device).lower() == "gilbert":
        common.hide_keyboard(from_device)
    common.wait_for_and_click(from_device, people_dict, "action_submit")
    # Validating error messages
    common.wait_for_element(from_device, people_dict, "create_contact_error_dialog_message")
    common.wait_for_and_click(from_device, people_dict, "ok_btn")
    common.wait_for_element(from_device, people_dict, "create_contact_name_validation_error_text")
    common.wait_for_element(from_device, people_dict, "create_contact_phone_validation_error_text")
    # enter valid details
    full_name_field.send_keys(updated_name)
    if getconfig_device_model(from_device).lower() == "gilbert":
        common.hide_keyboard(from_device)
    phone_field.send_keys(contact_phone)
    if getconfig_device_model(from_device).lower() == "gilbert":
        common.hide_keyboard(from_device)
    common.wait_for_and_click(from_device, people_dict, "action_submit")
    common.wait_for_element(from_device, people_dict, "group_arrow")


def Tap_on_dropdown_icon_next_to_all_contacts(device):
    navigate_to_people_tab(device)
    common.wait_for_and_click(device, people_dict, "all_contacts_drop_down")
