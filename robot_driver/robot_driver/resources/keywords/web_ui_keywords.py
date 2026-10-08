import re
import time
from Libraries import shared_utils
from datetime import datetime, timedelta
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.common.exceptions import StaleElementReferenceException, ElementClickInterceptedException
from Libraries.Selectors import load_json_file
from Libraries.driver_manager import driver_manager_instance
from resources.keywords import common
import pyautogui

web_signin_dict = load_json_file("resources/Page_objects/Web_signin.json")
tac_dict = load_json_file("resources/Page_objects/TAC.json")
calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
tr_console_calendar_dict = load_json_file("resources/Page_objects/rooms_console_calendar.json")


def initiate_web_driver(device, explict_url=None):
    url = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?response_type=id_token&scope=openid%20profile&client_id=5e3ce6c0-2b1f-4285-8d4b-75ee78787346&redirect_uri=https%3A%2F%2Fteams.microsoft.com%2Fgo&state=eyJpZCI6IjEzNWY2NDM2LTExNGUtNDNiYy1iMjFhLWJkMGY4YWFlNGZhOCIsInRzIjoxNzE4MTc1NTAzLCJtZXRob2QiOiJyZWRpcmVjdEludGVyYWN0aW9uIn0%3D&nonce=cb8fcdc6-5fb5-4a79-beed-af0ebc2a5f96&client_info=1&x-client-SKU=MSAL.JS&x-client-Ver=1.3.4&prompt=select_account&client-request-id=e0fe0fc2-2879-4f77-b522-cefa68a12384&response_mode=fragment&sso_reload=true"
    if explict_url:
        url = explict_url
    driver = driver_manager_instance.initiate_driver(device)
    driver.get(url)


def initiate_driver_and_tac_get(device):
    return initiate_web_driver(device, explict_url="https://admin.teams.microsoft.com")


def initiate_driver_for_zoom_meeting(device):
    return initiate_web_driver(
        device,
        explict_url="https://www.zoom.us/signin?amp_device_id=d0a03183-0642-48e6-839d-7b03d68891f6&_ics=1737441536748&irclickid=%7E17YULDGyrhoijmohklszpgh%7Ec-efhb-ge-ejkab97YVNIzsmjc-2&_gl=1*1h9h7yw*_gcl_au*MTE3NzA2MzAxMC4xNzM3NDQxMzA4*_ga*OTQ5MjE1MTkuMTczNzQ0MTUzNw..*_ga_L8TBF28DDX*MTczNzQ0MTUzNi4xLjAuMTczNzQ0MTUzNi4wLjAuMA..#/login",
    )


def perform_web_signin_method_for_zoom(device):
    username, password, _, _ = common.get_credentials(device)
    expected_displayname = common.device_displayname(device)
    print(expected_displayname)
    common.wait_for_element(device, web_signin_dict, "zoom_signin_fld").send_keys(username)
    common.wait_for_element(device, web_signin_dict, "zoom_Password_fld").send_keys(password)
    common.wait_for_and_click(device, web_signin_dict, "Sign_In")
    common.wait_for_and_click(device, web_signin_dict, "zoom_profile_pic")
    common.sleep_with_msg(device, 10, "Waiting for the page to load")

    zoom_signing_in = common.wait_for_element(device, web_signin_dict, "zoom_profile_card").text
    if zoom_signing_in != expected_displayname:
        raise AssertionError(f"Unexpected username_signin: '{zoom_signing_in}', expected '{expected_displayname}'")
    print(f"{device}: Signed in with expected user '{expected_displayname}'...")


def perform_web_signin_method(device, tac_signin=False, new_calander_toggle=True):
    username, password, _, _ = common.get_credentials(device)
    expected_displayname = common.device_displayname(device)

    common.wait_for_and_click(device, web_signin_dict, "web_username_field")
    common.wait_for_element(device, web_signin_dict, "web_username_field").send_keys(username)
    common.wait_for_and_click(device, web_signin_dict, "web_next_btn")
    common.wait_for_and_click(device, web_signin_dict, "web_pswd_field")
    common.wait_for_element(device, web_signin_dict, "web_pswd_field").send_keys(password)
    common.wait_for_and_click(device, web_signin_dict, "web_next_btn", "id")
    time.sleep(1)  # Avoid StaleElementReferenceException warning
    common.wait_for_and_click(device, web_signin_dict, "web_next_btn", "id")
    if not tac_signin:
        user_signing_in = common.wait_for_element(device, web_signin_dict, "username_signin", "xpath").text
        if user_signing_in != expected_displayname:
            raise AssertionError(
                f"Unexpected username_signin (xpath): '{user_signing_in}', expected '{expected_displayname}'"
            )
        common.click_if_present(device, web_signin_dict, "got_it_button")
        common.click_if_present(device, web_signin_dict, "do_it_later")
        common.wait_for_and_click(device, web_signin_dict, "username_signin", "xpath")
        handle_teams_popup(device)

        # There is a 'loading' script which runs as the sign-in progresses. Wait until it appears:
        common.wait_for_element(device, web_signin_dict, "loading", wait_attempts=80)
        common.wait_while_present(device, web_signin_dict, "loading", max_wait_attempts=60)

        # Once 'loading' starts, it 'flickers' (appears/disappears) - we only want the last disappearance.

        _max_loops = 20
        _loop = 0
        while True:
            _loop += 1
            common.sleep_with_msg(device, 5, "Ignore any screen 'flickering'")
            # Wait until any 'loading' script disappears again:
            common.wait_while_present(device, web_signin_dict, "loading", max_wait_attempts=60)

            # "avatar" has always been present, but blocked by "loading", check if is unblocked:
            _element = common.wait_for_element(device, web_signin_dict, "avatar")
            try:
                _element.click()
                print(f"{device}: Sign-in page active after {_loop} attempts of {_max_loops}")
                break
            except ElementClickInterceptedException:
                # Still blocked, log and retry:
                print(f"{device}: ElementClickInterceptedException ignored on attempt {_loop}")

            # Retry or Fail:
            if _loop >= _max_loops:
                raise AssertionError(f"{device}: Sign-in page did not activate after {_max_loops} loops")

        common.sleep_with_msg(device, 3, "waiting for the username to appear")
        user_signing_in = common.wait_for_element(device, web_signin_dict, "username_signin", "xpath1").text
        if user_signing_in != expected_displayname:
            raise AssertionError(
                f"Unexpected username_signin (xpath1): '{user_signing_in}', expected '{expected_displayname}'"
            )

        ## Bug 4501948: [Robot] [Browser] [Test Issue] Calendar tab does not always populate
        #
        # Go to the Calendar tab (for the first time):
        if not common.click_if_present(device, web_signin_dict, "calendar_button"):
            common.wait_for_and_click(device, web_signin_dict, "more_apps_button")
            common.wait_for_and_click(device, web_signin_dict, "calendar_button")
            # TODO: what do we need to do here? Can we just transition back? :
            common.debug_dump(device, "found_calendar_on_more_apps")

        # We MUST sleep here - In the bug, the calendar may briefly show before dissappearing:
        shared_utils.sleep_with_msg(device, 5, "Allow 1st-time calendar to display")

        # Check for Calendar components (missing in Bug 4501948):
        if common.is_element_present(device, web_signin_dict, "check_bug_4501948"):
            print(f"{device}: Bug 4501948 is NOT present.")
        else:
            # Workaround: Just clicking on 'Activity' tab and then 'Calendar' tabs seems to cause Calendar to populate.
            print(f"{device}: Bug 4501948 is present, attempting workaround...")

            common.wait_for_and_click(device, web_signin_dict, "activity_button")
            shared_utils.sleep_with_msg(device, 2, "Waiting for Activity tab to stabilize")

            common.wait_for_and_click(device, web_signin_dict, "calendar_button")
            shared_utils.sleep_with_msg(device, 5, "Allow (fixed) calendar to display")

            if not common.is_element_present(device, web_signin_dict, "check_bug_4501948"):
                raise AssertionError(f"{device}: Bug 4501948 is still present, workaround FAILED...")
            print(f"{device}: Bug 4501948 - WORKAROUND SUCCESS")

    else:
        common.sleep_with_msg(device, 10, "Allow tac web page to settle")
        common.wait_for_and_click(device, tac_dict, "web_profile_pic")
        admin_signing_in = common.wait_for_element(device, tac_dict, "tac_web_profile_card").text
        if admin_signing_in != expected_displayname:
            raise AssertionError(f"Unexpected username_signin: '{admin_signing_in}', expected '{expected_displayname}'")
    print(f"{device}: Signed in with expected user '{expected_displayname}'...")
    if new_calander_toggle:
        verify_and_modify_new_calender_toggle(device)


def navigate_to_calendar_tab_in_TDC(device):
    if not common.click_if_present(device, web_signin_dict, "calendar_button"):
        print(f"{device}: calendar button not found clicking on more option..")
        common.wait_for_and_click(device, web_signin_dict, "more_apps_button")
        common.wait_for_and_click(device, web_signin_dict, "calendar_button")
    common.sleep_with_msg(device, 5, "wait for the page response completely")
    common.click_if_present(device, web_signin_dict, "got_it_button")
    common.click_if_present(device, web_signin_dict, "do_it_later")
    common.wait_for_element(device, web_signin_dict, "create_new_meeting_btn")


def create_TDC_meeting_on_desktop(
    device,
    meeting_name,
    time_duration="10 hr",
    supporting_device=None,
    participants=None,
    all_day_meeting="off",
    private_meeting="off",
    following_day_meeting="off",
    e2ee="off",
    use_current_time=False,
    roundup_end_time="on",
    start_meeting_time="off",
    start_meeting_time_after=5,
    consecutive_meeting="off",
    concurrent_meeting="off",
    sensitivity_label="off",
    primary_label_type="off",
    primary_label_mode="off",
    secondary_label_type="off",
    secondary_label_mode="off",
    fetch_meeting_info=False,
):
    # For now the meeting duration can be 23 hr or less or all day on
    # Note: Mention either hr or min value properly
    # we can not give value like 2 hr 20 min
    if not common.is_element_present(device, web_signin_dict, "calendar_page"):
        print("it is not calendar page so opening the page")
        navigate_to_calendar_tab_in_TDC(device)

    if participants is not None:
        if common.is_norden(participants.split(",")[0]):
            if meeting_name.lower() not in [
                "extend_meeting",
                "cnf_device_meeting",
                "lock_meeting",
                "all_day_meeting",
                "all_day_meeting_1",
                "all_day_meeting_2",
                "non_allday_meeting",
                "upcoming_meeting",
                "rooms_private_meeting",
                "rooms_console_meeting",
                "console_lock_meeting",
                "e2ee",
                "test_meeting",
                "test_meeting_1",
                "test_meeting_2",
                "pstn_meeting",
                "whiteboard_sharing_meeting",
                "upcoming_meeting_double_book",
                "zoom_meeting",
                "sensitivity_label_meeting",
                "room_camera_meeting",
                "proximity_meeting",
                "spof_meeting",
            ]:
                raise AssertionError(f"Unexpected state for meeting_name: {meeting_name}")

    if all_day_meeting.lower() not in ["on", "off"]:
        raise AssertionError(f"Unexpected state for all_day_meeting: {all_day_meeting}")

    if private_meeting.lower() not in ["on", "off"]:
        raise AssertionError(f"Unexpected state for private_meeting: {private_meeting}")

    if following_day_meeting.lower() not in ["on", "off"]:
        raise AssertionError(f"Unexpected state for following_day_meeting: {following_day_meeting}")

    if roundup_end_time.lower() not in ["on", "off"]:
        raise AssertionError(f"Unexpected state for roundup_end_time: {roundup_end_time}")

    current_meeting_end_time = None
    current_meeting_start_time = None
    if consecutive_meeting == "on" or concurrent_meeting == "on":
        if supporting_device:
            current_reserved_meeting_time = common.wait_for_element(
                supporting_device, calendar_dict, "meeting_time"
            ).text
        else:
            current_reserved_meeting_time = common.wait_for_element(participants, calendar_dict, "meeting_time").text
        print(f"current_reserved_meeting_time:{current_reserved_meeting_time}")
        current_meeting_start_time, current_meeting_end_time = current_reserved_meeting_time.split("-")
        print(
            f"current_meeting_start_time:{current_meeting_start_time}, current_meeting_end_time:{current_meeting_end_time}"
        )

    common.click_if_present(device, web_signin_dict, "do_it_later")
    common.wait_for_and_click(device, web_signin_dict, "create_new_meeting_btn")
    common.wait_for_element(device, web_signin_dict, "add_title").send_keys(meeting_name)

    if participants is not None:
        for participant in participants.split(","):
            participant_username = common.device_username(participant)
            common.wait_for_element(device, web_signin_dict, "add_participant").send_keys(participant_username)
            recheck = 3
            for attempt in range(recheck):
                try:
                    common.wait_for_and_click(device, web_signin_dict, "select_add_user")
                    print(f"{participant_username}: added")
                    break  # If successful, break out of the retry loop
                except StaleElementReferenceException:
                    print(f"Stale element reference on attempt {attempt + 1}. Retrying...")
                    time.sleep(2)  # Optional: Adding a small delay before retrying
                    if attempt == recheck - 1:
                        raise

    if private_meeting.lower() == "on":
        print("checking the private meeting")
        common.wait_for_and_click(device, web_signin_dict, "show_as")
        common.wait_for_and_click(device, web_signin_dict, "private")

    if all_day_meeting == "on":
        common.wait_for_and_click(device, web_signin_dict, "web_all_day_toggle")
    else:
        # Custom meeting creation with user's choice of time_duration
        # Entering the starting time
        time.sleep(5)
        start_time, end_time = calculate_start_and_end_time(
            time_duration,
            roundup_end_time,
            use_current_time,
            start_meeting_time,
            start_meeting_time_after,
            consecutive_meeting,
            concurrent_meeting,
            current_meeting_end_time,
            current_meeting_start_time,
        )
        enter_start_or_end_time_to_TDC(device, web_signin_dict, "start_time", start_time)
        # Create a meeting for the following day.
        if following_day_meeting == "on":
            today = datetime.now()
            next_day = today + timedelta(days=1)
            day = next_day.strftime("%d, %B, %Y").lstrip("0")
            print(day)
            common.wait_for_and_click(device, web_signin_dict, "end_date_calender")
            temp_dict = common.get_dict_copy(web_signin_dict, "end_date", "end_date", day)
            common.wait_for_and_click(device, temp_dict, "end_date")
            print("created the following day meeting")
        else:
            enter_start_or_end_time_to_TDC(device, web_signin_dict, "end_timer", end_time)

    if e2ee == "on":
        common.wait_for_and_click(device, web_signin_dict, "more_options_button")
        print("clicked on more option")
        time.sleep(1)
        # should replace driver by using common.wait_for_and_click whenever possible
        # common.wait_for_and_click(device, web_signin_dict, "e2ee_toggle", "id")
        driver = driver_manager_instance.get_driver(device)
        common.sleep_with_msg(device, 5, "wait for e2ee toggle reflection")
        toggle = driver.find_element(By.ID, web_signin_dict["e2ee_toggle"]["id"])
        driver.execute_script("arguments[0].scrollIntoView(true);", toggle)
        toggle.click()
        common.sleep_with_msg(device, 5, "wait for e2ee toggle reflection")
        if not common.click_if_present(device, web_signin_dict, "save_button"):
            common.wait_for_and_click(device, web_signin_dict, "apply")
        print("Enable e2ee")

    if sensitivity_label == "on":
        verify_and_change_the_sensitivity_label(
            device, primary_label_type, primary_label_mode, secondary_label_type, secondary_label_mode
        )
    common.click_if_present(device, web_signin_dict, "got_it_button")
    common.wait_for_and_click(device, web_signin_dict, "web_send_meeting_btn")
    time.sleep(1)
    # Verification for meeting created
    print(
        f"created new meeting : {meeting_name} on {datetime.today().strftime('%d-%m-%Y')}  {datetime.today().strftime('%X')}"
    )
    verify_meeting_created_or_not(device, meeting_name)
    if fetch_meeting_info:
        edit_meeting_name = meeting_name
        right_click_on_created_meeting_from_tdc(device, edit_meeting_name)
        open_and_edit_created_meeting_from_tdc(device)
        return page_scroll_and_get_meeting_id_and_passcode(device)


def get_todays_date():
    return datetime.today().strftime("%Y-%m-%d")


def right_click_on_created_meeting_from_tdc(device, edit_meeting_name, click="right"):
    navigate_to_calendar_tab_in_TDC(device)

    if edit_meeting_name.lower() not in [
        "cnf_device_meeting",
        "lock_meeting",
        "e2ee",
        "extend_meeting",
        "all_day_meeting",
        "test_meeting",
        "test_meeting_1",
        "test_meeting_2",
        "upcoming_meeting",
        "pstn_meeting",
        "all_day_meeting_1",
        "all_day_meeting_2",
        "whiteboard_sharing_meeting",
        "console_lock_meeting",
        "zoom_meeting",
        "sensitivity_label_meeting",
        "canceled: whiteboard_sharing_meeting",
        "rooms_console_meeting",
        "proximity_meeting",
    ]:
        raise AssertionError(f"Unexpected state for meeting_name: {edit_meeting_name}")

    common.sleep_with_msg(device, 10, "right_click_on_created_meeting_from_tdc 1")

    print(f"{device}: click={click}, edit_meeting_name='{edit_meeting_name}'")
    temp_dict = common.get_dict_copy(web_signin_dict, "meeting_names_on_calender", "meeting_name", edit_meeting_name)
    element = common.wait_for_element(device, temp_dict, "meeting_names_on_calender")

    # The element is present, no reason to sleep here:
    # common.sleep_with_msg(device, 5, "right_click_on_created_meeting_from_tdc 2")

    driver = driver_manager_instance.get_driver(device)
    driver.execute_script("arguments[0].scrollIntoView(true);", element)

    common.sleep_with_msg(device, 5, "right_click_on_created_meeting_from_tdc 3")

    actions = ActionChains(driver)
    if click.lower() == "left":
        actions.click(element).perform()
    else:
        actions.context_click(element).perform()

    common.sleep_with_msg(device, 5, "right_click_on_created_meeting_from_tdc 4")


def delete_meeting_from_tdc(device):
    common.wait_for_and_click(device, web_signin_dict, "Cancel", "xpath")


def delete_all_meetings_from_tdc(device, meeting_list=None):
    expected_displayname = common.device_displayname(device)
    navigate_to_calendar_tab_in_TDC(device)
    common.sleep_with_msg(device, 5, "wait to sync the existing meetings")

    # Default list of meetings to delete
    meetings_to_delete = [
        "all_day_meeting",
        "all_day_meeting_1",
        "all_day_meeting_2",
        "non_allday_meeting",
        "extend_meeting",
        "cnf_device_meeting",
        "lock_meeting",
        "upcoming_meeting",
        "rooms_private_meeting",
        "rooms_console_meeting",
        "console_lock_meeting",
        "test_meeting",
        "test_meeting_1",
        "test_meeting_2",
        "pstn_meeting",
        "whiteboard_sharing_meeting",
        "upcoming_meeting_double_book",
        "zoom_meeting",
        "sensitivity_label_meeting",
        "proximity_meeting",
    ]

    # Parse the provided meeting list or use the default
    meetings_list_to_delete = meeting_list.split(",") if meeting_list else meetings_to_delete
    print(f"{device}: Meetings to delete: {meetings_list_to_delete}")
    driver = driver_manager_instance.get_driver(device)

    for meeting_name in meetings_list_to_delete:
        if meeting_name == "no_meeting_name":
            meeting_name = expected_displayname

        meeting_xpath = common.get_dict_copy(
            web_signin_dict, "meeting_names_on_calender", "meeting_name", meeting_name
        )["meeting_names_on_calender"]["xpath"]
        print(f"{device}: Selector for '{meeting_name}': {meeting_xpath}")

        sanity_cutoff = 10
        handle_attempts = 0
        while True:
            try:
                elements = driver.find_elements(By.XPATH, meeting_xpath)

                if not elements:
                    print(f"{device}: No instances of {meeting_name} found.")
                    break
                _n_elenents = len(elements)
                print(f"{device}: Found {_n_elenents} instances of '{meeting_name}'.")

                if _n_elenents > sanity_cutoff:
                    print(
                        f"*WARN* {device}: Found {len(elements)} instances of meeting '{meeting_name}' expecting at most {sanity_cutoff}. Is this intended?"
                    )
                    sanity_cutoff = _n_elenents + 1

                handle_attempts += 1
                if handle_attempts > sanity_cutoff:
                    # This indicated we have 'handled' an instance multiple times - the Cancel was ignored:
                    raise AssertionError(
                        f"{device}: Too many handle attempts for meeting '{meeting_name}' - the Cancel was ignored."
                    )

                # Accept or delete each instance of the meeting
                any_instance_handled = False
                for element in elements:
                    driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", element)
                    time.sleep(1)
                    ActionChains(driver).context_click(element).perform()
                    time.sleep(3)

                    # Attempt to 'handle' each instance (click "Cancel" or "accept" depending on availability)
                    if common.click_if_present(device, web_signin_dict, "Cancel"):
                        print(f"{device}: Successfully deleted an instance of {meeting_name}.")
                        common.sleep_with_msg(device, 3, f"Cancelled meeting '{meeting_name}' - let UI refresh")
                        # Need to refresh the 'elements' list
                        any_instance_handled = True
                        break

                    if common.click_if_present(device, web_signin_dict, "accept"):
                        print(f"{device}: Cancel option not available for {meeting_name}. Accepting the meeting.")
                        common.sleep_with_msg(device, 3, f"Accepted meeting '{meeting_name}' - let UI refresh")
                        # Accept button does not disappear so just process the rest of the list - do not 'break' to refresh the instance list

                # If no meetings were canceled, the UI is unchanged and 'refresh' will do nothing - we are done.
                if not any_instance_handled:
                    print(f"{device}: All instances of {meeting_name} handled.")
                    break

            except Exception as e:
                print(f"{device}: Meeting '{meeting_name}', An unexpected error occurred: {e}")
                raise

        print(f"{device}: Finished deleting all instances of {meeting_name}.")


def close_web_driver(device):
    for _ in range(1):
        common.sleep_with_msg(device, 10, "close_web_driver")
        driver_manager_instance.quit_driver(device)


def handle_teams_popup(device):
    common.sleep_with_msg(device, 5, "checking the popup to visible")
    if not common.click_if_present(device, web_signin_dict, "maybe_later"):
        print(f"{device}: 'maybe_later' element not found or not visible.")


def enter_start_or_end_time_to_TDC(device, sel_dict, sel_dict_key, time_val):
    # Make sure the text box has focus:
    common.wait_for_and_click(device, sel_dict, sel_dict_key)
    time_box = common.wait_for_element(device, sel_dict, sel_dict_key)
    time_box.send_keys(Keys.CONTROL + "a")  # For Windows/Linux
    time_box.send_keys(Keys.BACKSPACE)
    print(f"{device}: cleared the timebox")
    # time.sleep(3)
    time_box.send_keys(str(time_val))
    # time.sleep(3)
    time_box.send_keys(Keys.RETURN)
    # time.sleep(5)


def verify_TDC_meeting_creation(device, meeting_name, start_time, end_time):
    temp_dict = common.get_dict_copy(web_signin_dict, "meeting_names_on_calender", "meeting_name", meeting_name)
    common.wait_for_and_click(device, temp_dict, "meeting_names_on_calender")
    reserved_meeting = common.get_all_elements_texts(device, web_signin_dict, "meeting_time_span")
    reserved_meeting_time = reserved_meeting[1]
    if start_time.lower() in reserved_meeting_time.lower() and end_time.lower() in reserved_meeting_time.lower():
        print(f"Meeting created successfully at: {reserved_meeting_time}")
    else:
        raise AssertionError(
            f"Meeting is not created properly as reserved_meeting_time:{reserved_meeting_time} is not as expected, start_time:{start_time} and end_time:{end_time}"
        )


def round_to_next_half_hour(dt):
    """Round a datetime object to the next 0 or 30 minutes."""
    if dt.minute < 15:
        rounded_time = dt.replace(minute=30, second=0, microsecond=0)
        print("rounded 30 minutes")
    elif dt.minute > 40:
        rounded_time = (dt + timedelta(hours=1)).replace(minute=30, second=0, microsecond=0)
        print("rounded 30 minutes if near to the next hour")
    else:
        rounded_time = (dt + timedelta(hours=1)).replace(minute=0, second=0, microsecond=0)
        print("rounded 0 minutes and added 1 hour")
    return rounded_time


def calculate_start_and_end_time(
    time_duration,
    roundup_end_time,
    use_current_time=False,
    start_meeting_time="off",
    start_meeting_time_after=30,
    consecutive_meeting="off",
    concurrent_meeting="off",
    current_meeting_end_time=None,
    current_meeting_start_time=None,
):
    # Validate and parse the time duration
    pattern = r"(\d+)\s*(min|hr)"
    match = re.match(pattern, time_duration.lower())
    if not match:
        raise AssertionError(
            "Time duration must be specified in 'minutes' (min) or 'hours' (hr), e.g., '30 min' or '15 hr'.'{time_duration}'"
        )

    duration_value = int(match.group(1))
    unit = match.group(2)

    # Get the current time
    now = datetime.now()
    # Determine the start time based on the use_current_time flag
    if consecutive_meeting == "on":
        start_time = datetime.strptime(current_meeting_end_time.strip(), "%I:%M %p")
        print(f"current_meeting_end_time is :{current_meeting_end_time} and {type(current_meeting_end_time)}")
    elif concurrent_meeting == "on":
        start_time = datetime.strptime(current_meeting_start_time.strip(), "%I:%M %p")
        print(f"current_meeting_start_time is :{current_meeting_start_time} and {type(current_meeting_start_time)}")
    elif use_current_time:
        start_time = now.replace(second=0, microsecond=0)
    elif start_meeting_time == "on":
        current_time = now.replace(second=0, microsecond=0)
        start_time = current_time + timedelta(minutes=start_meeting_time_after)
    else:
        start_time = round_to_next_half_hour(now)

    # Determine if the duration is in hours or minutes and calculate end time
    if unit == "min":
        duration = timedelta(minutes=duration_value)
    else:
        duration = timedelta(hours=duration_value)

    end_time = start_time + duration

    # Round the end_time to the nearest 0 or 30 minutes
    end_time = round_to_next_half_hour(end_time) if roundup_end_time.lower() == "on" else end_time

    # Format the start and end times to 12-hour AM/PM format
    formatted_start_time = start_time.strftime("%I:%M %p").lstrip("0")
    formatted_end_time = end_time.strftime("%I:%M %p").lstrip("0")

    return formatted_start_time, formatted_end_time


def refresh_page_and_navigate_to_calendar(device):
    # Refresh the page and navigate back to the calendar
    driver = driver_manager_instance.get_driver(device)
    driver.refresh()
    navigate_to_calendar_tab_in_TDC(device)
    common.sleep_with_msg(device, 5, "Waiting after refresh to sync meetings")


def join_the_meeting_in_TDC(device):
    driver = driver_manager_instance.get_driver(device)
    common.wait_for_and_click(device, web_signin_dict, "join_btn_tdc")
    try:
        time.sleep(3)
        driver.switch_to.alert().accept()
    except Exception as e:
        common.click_if_present(device, web_signin_dict, "without_audio_or_video")
    common.wait_for_and_click(device, web_signin_dict, "join_btn_tdc", "xpath1")
    common.wait_for_element(device, web_signin_dict, "leave_btn_tdc")


def send_the_message_from_chat_option_in_TDC(device, message):
    time.sleep(2)
    if not common.is_element_present(device, web_signin_dict, "send_button"):
        common.wait_for_and_click(device, web_signin_dict, "chat_button_in_meeting")
    msg = "https://teams.microsoft.com" if "link" in message else message
    common.wait_for_element(device, web_signin_dict, "send_chat").send_keys(msg)
    common.wait_for_and_click(device, web_signin_dict, "send_button")


def Disconnect_the_call_on_TDC(device):
    time.sleep(3)
    if not common.click_if_present(device, web_signin_dict, "hang_up_button"):
        common.wait_for_and_click(device, web_signin_dict, "leave_btn_tdc")
    if not common.is_element_present(device, web_signin_dict, "create_new_meeting_btn"):
        common.click_if_present(device, web_signin_dict, "dismiss_rating_button")
        common.click_if_present(device, web_signin_dict, "dismiss_btn_tdc")
    common.is_element_present(device, web_signin_dict, "create_new_meeting_btn")


def come_back_to_calendar_page_on_TDC(device):
    if not common.is_element_present(device, web_signin_dict, "create_new_meeting_btn"):
        Disconnect_the_call_on_TDC(device)
    common.wait_for_element(device, web_signin_dict, "meet_now_TDC")


def navigate_to_manage_teams_devices_in_tac(device, device_options="Phones"):
    if device_options not in ["Phones", "CollaborationBars", "TeamsPanels"]:
        raise AssertionError(f"{device}: Unexpected value for option: {device_options}")

    common.wait_for_and_click(device, tac_dict, "teams_device_option")
    tmp_dict = common.get_dict_copy(tac_dict, "tac_device_options", "device_type", device_options)
    common.wait_for_and_click(device, tmp_dict, "tac_device_options")
    common.wait_for_element(device, tac_dict, "tac_device_health_summary")


def navigate_to_health_summary_of_device_in_tac(from_device, to_device):
    # Get the display name of user logged in on DUT
    user_logged_in = common.device_displayname(to_device)
    to_device, _ = common.decode_device_spec(to_device)
    print(f"{to_device} display name : {user_logged_in}")

    # Get the IP of DUT
    ip_address = common.device_udid(to_device)
    ip_address_without_port = ip_address.split(":")[0]
    print(f"{to_device} IP address : {ip_address_without_port}")

    # Generate the dict for IP and Username combination
    tmp_dict1 = common.get_dict_copy(tac_dict, "tac_search_result_device", "display_name", user_logged_in)
    tmp_dict2 = common.get_dict_copy(tmp_dict1, "tac_search_result_device", "udid", ip_address_without_port)

    # Device summary page is very dynamic and takes time to load
    element = None
    for attempt in range(0, 10):
        if element := common.is_element_present(from_device, tmp_dict2, "tac_search_result_device"):
            break
        common.sleep_with_msg(from_device, 5, "waiting for element to be present")
    common.wait_for_element(from_device, tac_dict, "tac_device_health_summary_card")
    print(f"{from_device}: found the {element} on attempt {attempt}")

    # Need to scroll for correct IP and user combination
    driver = driver_manager_instance.get_driver(from_device)
    element = driver.find_element(By.XPATH, tmp_dict2["tac_search_result_device"]["xpath"])
    print(f"{from_device}: scrolling to make element visible, so that we can click on it")
    driver.execute_script("arguments[0].scrollIntoView(true);", element)
    common.wait_for_and_click(from_device, tmp_dict2, "tac_search_result_device")

    # After clicking the correct IP and user combination verify we on health status page
    common.wait_for_element(from_device, tac_dict, "tac_device_health_page")


def verify_health_status_of_device_in_tac(from_device, expected_health="Healthy"):
    if expected_health not in ["Healthy", "Non-urgent", "Critical"]:
        raise AssertionError(f"{from_device}: Unexpected value for option: {expected_health}")

    # Get the actual health status text from TAC and compare with expected health
    tac_health = common.wait_for_element(from_device, tac_dict, "tac_device_health_status").text
    if tac_health != expected_health:
        raise AssertionError(f"TAC reported health status: '{tac_health}', expected health status'{expected_health}'")


def refresh_tac_and_navigate_to_dashboard(device):
    # Refresh the page and navigate back to the calendar
    driver = driver_manager_instance.get_driver(device)
    driver.refresh()
    common.wait_for_and_click(device, tac_dict, "tac_dashboard_option")


def verify_and_change_the_sensitivity_label(
    device, primary_label_type, primary_label_mode, secondary_label_type, secondary_label_mode
):
    driver = driver_manager_instance.get_driver(device)

    # Open More Options
    common.wait_for_and_click(device, web_signin_dict, "more_options_button")
    common.sleep_with_msg(device, 4, "Waiting to change the sensitivity label")

    # Handle primary sensitivity label type
    if primary_label_type == "sensitivity":
        common.wait_for_and_click(device, web_signin_dict, "sensitivity")
        if primary_label_mode == "none":
            common.wait_for_and_click(device, web_signin_dict, "none")
        elif primary_label_mode == "app_label":
            common.wait_for_and_click(device, web_signin_dict, "app_label")
        elif primary_label_mode == "new_label":
            common.wait_for_and_click(device, web_signin_dict, "new_label")
        elif primary_label_mode == "Dpec_Test":
            common.wait_for_and_click(device, web_signin_dict, "Dpec_Test")

    # Handle secondary sensitivity label type
    elif secondary_label_type == "bypass_the_lobby":
        common.wait_for_and_click(device, web_signin_dict, "bypass_the_lobby")
        if secondary_label_mode == "org_and_guests":
            common.sleep_with_msg(device, 4, "Waiting to change the lobby setting")
            common.wait_for_and_click(device, web_signin_dict, "org_and_guests")

    elif secondary_label_type == "who_can_present":
        common.sleep_with_msg(device, 4, "Waiting for sensitivity label changes")
        element = driver.find_element(By.XPATH, web_signin_dict["can_present"]["xpath"])
        driver.execute_script("arguments[0].scrollIntoView(true);", element)
        common.sleep_with_msg(device, 5, "Waiting for sensitivity label changes")
        common.wait_for_and_click(device, web_signin_dict, "label_PresenterOption")
        if secondary_label_mode == "Everyone":
            common.wait_for_and_click(device, web_signin_dict, "Everyone")

    elif secondary_label_type == "Meeting_chat":
        common.sleep_with_msg(device, 4, "Waiting for sensitivity label changes")
        element = driver.find_element(By.XPATH, web_signin_dict["Meeting_chat"]["xpath"])
        driver.execute_script("arguments[0].scrollIntoView(true);", element)
        common.wait_for_and_click(device, web_signin_dict, "MeetingChat_lable")
        common.sleep_with_msg(device, 5, "Waiting to change MeetingChat_lable  setting")
        if secondary_label_mode == "on":
            common.wait_for_and_click(device, web_signin_dict, "MeetingChat_on")
        if secondary_label_mode == "off":
            common.wait_for_and_click(device, web_signin_dict, "MeetingChat_off")
    # Save and close
    if not common.click_if_present(device, web_signin_dict, "save_button"):
        common.wait_for_and_click(device, web_signin_dict, "apply")
    # common.wait_for_and_click(device, web_signin_dict, "close")


def share_whiteboard(device):
    common.wait_for_and_click(device, web_signin_dict, "Whiteboard")
    common.wait_for_and_click(device, web_signin_dict, "new_session")
    common.sleep_with_msg(device, 8, "Waiting to share_whiteboard Reflected")


def open_and_edit_created_meeting_from_tdc(device):
    driver = driver_manager_instance.get_driver(device)
    driver.find_element(By.XPATH, web_signin_dict["Edit"]["xpath"]).click()


def page_scroll_and_get_meeting_id_and_passcode(device):
    driver = driver_manager_instance.get_driver(device)
    common.sleep_with_msg(device, 5, "waiting to open for meeting after right_click_")
    element = driver.find_element(By.XPATH, web_signin_dict["web_meeting_id"]["xpath"])
    driver.execute_script("arguments[0].scrollIntoView(true);", element)
    meeting_id_element = driver.find_element(By.XPATH, web_signin_dict["web_meeting_id"]["xpath"])
    passcode_element = driver.find_element(By.XPATH, web_signin_dict["web_passcode"]["xpath"])
    if not meeting_id_element.is_displayed() and passcode_element.is_displayed():
        raise AssertionError("Element not displayed")
    meeting_id = meeting_id_element.text
    passcode = passcode_element.text
    common.wait_for_and_click(device, web_signin_dict, "close")
    return meeting_id, passcode


def verify_and_modify_new_calender_toggle(device):
    driver = driver_manager_instance.get_driver(device)
    if not common.click_if_present(device, web_signin_dict, "calendar_button"):
        print(f"{device}: calendar button not found clicking on more option..")
        common.wait_for_and_click(device, web_signin_dict, "more_apps_button")
        common.wait_for_and_click(device, web_signin_dict, "calendar_button")
    common.sleep_with_msg(device, 5, "waiting for web page properly load")
    common.click_if_present(device, web_signin_dict, "lang_close_btn")
    actions = ActionChains(driver)
    for _ in range(7):
        actions.send_keys(Keys.PAGE_UP).perform()
    common.sleep_with_msg(device, 10, "waiting for Frame load proper")
    if not common.is_element_present(device, web_signin_dict, "create_new_meeting_btn"):
        page_frames = driver.find_elements(By.TAG_NAME, "iframe")
        print(f"Total number of frames: {len(page_frames)}")
        parent_frame = find_frame_with_element(device, "new_calender_toggle")
        if parent_frame:
            common.sleep_with_msg(device, 5, "waiting for Frame load")
            common.wait_for_and_click(device, web_signin_dict, "new_calendar_title")
            driver.switch_to.default_content()
            if not common.is_element_present(device, web_signin_dict, "create_new_meeting_btn"):
                driver.switch_to.frame(parent_frame)
                common.sleep_with_msg(device, 5, "waiting for feedback form appear")
                feedback_frames = find_frame_with_element(device, "feedback_form_title")
                if feedback_frames:
                    for _ in range(3):
                        actions.send_keys(Keys.PAGE_DOWN).perform()
                        if common.is_element_present(device, web_signin_dict, "skip_feedback_btn"):
                            break
                    common.wait_for_and_click(device, web_signin_dict, "skip_feedback_btn")
                driver.switch_to.default_content()
            else:
                print("No need to skip feedback form, already in default UI")
        else:
            print("Unable to find frame with 'new_calender_toggle'. Skipping frame-dependent steps.")
    else:
        print("No need to modify Teams calendar toggle, already in default UI")
    common.wait_for_element(device, web_signin_dict, "create_new_meeting_btn")
    common.dismiss_TDC_advertisements(device)
    if common.is_element_present(device, web_signin_dict, "week_view"):
        print("Week view is already selected in the calendar. No action required.")
    else:
        common.wait_for_and_click(device, web_signin_dict, "switch_calendar_view")
        common.sleep_with_msg(device, 3, "Waiting before selecting week view.")
        common.wait_for_element(device, web_signin_dict, "day")
        common.wait_for_element(device, web_signin_dict, "work_week")
        common.wait_for_element(device, web_signin_dict, "agenda")
        common.wait_for_element(device, web_signin_dict, "week_view")
        common.wait_for_and_click(device, web_signin_dict, "week_view")
    common.sleep_with_msg(device, 5, "waiting for Calender to load")
    if not (
        common.is_element_present(device, web_signin_dict, "saturday")
        and common.is_element_present(device, web_signin_dict, "sunday")
    ):
        raise AssertionError(f" Week View is not changed properly in calendar")
    print("Week View applied — Saturday and Sunday are visible.")


def navigate_to_calling_tab_in_TDC(device):
    common.wait_for_and_click(device, web_signin_dict, "call_tab")
    common.sleep_with_msg(device, 5, "wait for the page response completely")
    common.click_if_present(device, web_signin_dict, "got_it_button")
    common.click_if_present(device, web_signin_dict, "do_it_later")
    common.wait_for_element(device, web_signin_dict, "history_container")
    common.wait_for_element(device, web_signin_dict, "dial_pad")


def make_outgoing_call_from_TDC(device, to_device):
    driver = driver_manager_instance.get_driver(device)
    navigate_to_calling_tab_in_TDC(device)
    phone_number = common.device_phonenumber(to_device)
    print(f"phone number: {phone_number}")
    common.wait_for_element(device, web_signin_dict, "calling_search_button").send_keys(phone_number)
    common.wait_for_and_click(device, web_signin_dict, "select_calling_user")
    common.wait_for_and_click(device, web_signin_dict, "call_button")
    try:
        time.sleep(3)
        driver.switch_to.alert().accept()
    except Exception as e:
        common.click_if_present(device, web_signin_dict, "without_audio_or_video")
    common.wait_for_element(device, web_signin_dict, "leave_btn_tdc")


def come_back_to_calling_page_on_TDC(device):
    if not common.is_element_present(device, web_signin_dict, "history_container"):
        Disconnect_the_call_on_TDC(device)
    common.wait_for_element(device, web_signin_dict, "dial_pad")
    common.wait_for_element(device, web_signin_dict, "history_container")


def create_zoom_meeting(device, meeting_name, duration):
    # Navigate to Zoom Meetings
    common.wait_for_and_click(device, web_signin_dict, "zoom_meetings")
    common.sleep_with_msg(device, 4, "Waiting for sensitivity label changes")

    # Click on 'Schedule Meeting'
    common.wait_for_and_click(device, web_signin_dict, "Schedule_Meeting")
    print(f"The meeting title name is: {meeting_name}")

    common.sleep_with_msg(device, 4, "Waiting for sensitivity label changes")
    common.wait_for_element(device, web_signin_dict, "zoom_meeting_title").send_keys(meeting_name)

    # Set Meeting Start Time
    current_time = datetime.now().strftime("%H:%M")
    print(f"Current time: {current_time}")
    common.sleep_with_msg(device, 10, "Waiting for sensitivity label changes")

    common.wait_for_and_click(device, web_signin_dict, "zoom_hr_drop_down")
    common.wait_for_element(device, web_signin_dict, "zoom_from_time").clear()
    common.wait_for_element(device, web_signin_dict, "zoom_from_time").send_keys(current_time)
    common.click_if_present(device, web_signin_dict, "popup_list")

    # Set Meeting Duration
    duration_parts = [int(i) for i in re.findall(r"\d+", duration)]
    hours = duration_parts[0]
    minutes = duration_parts[1] if len(duration_parts) > 1 else 0

    common.sleep_with_msg(device, 5, "Waiting for sensitivity label changes")
    common.wait_for_element(device, web_signin_dict, "zoom_hr_duration").send_keys(hours)
    common.sleep_with_msg(device, 5, "Waiting for sensitivity label changes")

    if minutes:
        common.wait_for_element(device, web_signin_dict, "zoom_min_duration").send_keys(minutes)

    # Handle Iframes and Additional Options
    handle_iframe_and_options(device)

    # Finalizing Meeting Settings
    common.wait_for_and_click(device, web_signin_dict, "options_collapsed")
    common.wait_for_and_click(device, web_signin_dict, "allow_participants_to_join_anytime")
    common.sleep_with_msg(device, 3, "Meeting setup completed successfully")
    common.wait_for_and_click(device, web_signin_dict, "zoom_save")
    common.wait_for_element(device, web_signin_dict, "registration")


def handle_iframe_and_options(device):
    driver = driver_manager_instance.get_driver(device)
    actions = ActionChains(driver)
    if not (iframes := driver.find_elements(By.TAG_NAME, "iframe")):
        raise AssertionError(f"{device} No iframes found. Exiting execution as iframe is required.")
    print(f"Total number of frames: {len(iframes)}")
    driver.switch_to.frame(iframes[0])  # Switch to the first iframe
    print("Switched to the first iframe.")
    for _ in range(4):
        actions.send_keys(Keys.PAGE_DOWN).perform()
        common.sleep_with_msg(device, 4, "Scrolling down to check all frames")
        if common.is_element_present(device, web_signin_dict, "options_collapsed"):
            print("'Options' found in first iframe, exiting loop.")
            break
    if not common.is_element_present(device, web_signin_dict, "options"):
        actions.send_keys(Keys.PAGE_UP).perform()
    driver.switch_to.default_content()


def verify_meeting_created_or_not(device, meeting_name):
    navigate_to_calendar_tab_in_TDC(device)
    print(f"expected meeting to check :{meeting_name}")
    temp_dict = common.get_dict_copy(web_signin_dict, "meeting_names_on_calender", "meeting_name", meeting_name)
    common.wait_for_element(device, temp_dict, "meeting_names_on_calender")
    print(f"{meeting_name} created successfully")


def remove_canceled_meeting(device, meeting_name):
    """Before create meeting , need to check ,if canceled meeting exist then need to delete."""
    temp_dict = common.get_dict_copy(web_signin_dict, "meeting_names_on_calender", "meeting_name", meeting_name)
    for i in range(10):
        if common.is_element_present(device, temp_dict, "meeting_names_on_calender"):
            print(f"{meeting_name}: Found, proceeding to delete.")
            right_click_on_created_meeting_from_tdc(device, edit_meeting_name=meeting_name)
            remove_meeting_from_tdc(device)
        else:
            print(f"{meeting_name}: Not found, exiting loop.")
            break


def remove_meeting_from_tdc(device):
    common.wait_for_and_click(device, web_signin_dict, "remove_from_calendar")
    print("meeting successfully removed from calendar")


def initiate_tdc_screen_sharing(device):
    move_mouse_to_screen_center()
    # Press Ctrl + Shift + E to start screen sharing
    pyautogui.keyDown("ctrl")
    pyautogui.keyDown("shift")
    pyautogui.press("e")
    pyautogui.keyUp("shift")
    pyautogui.keyUp("ctrl")
    common.sleep_with_msg(device, 3, "Waiting for screen sharing to start.")

    # Press Ctrl + Shift + Space to open the share tray
    pyautogui.keyDown("ctrl")
    pyautogui.keyDown("shift")
    pyautogui.press("space")
    pyautogui.keyUp("shift")
    pyautogui.keyUp("ctrl")
    common.sleep_with_msg(device, 3, "Waiting for the share tray to open.")

    # Press Ctrl + Shift + Tab (navigate options)
    pyautogui.keyDown("ctrl")
    pyautogui.keyDown("shift")
    pyautogui.press("tab")
    pyautogui.keyUp("shift")
    pyautogui.keyUp("ctrl")
    common.sleep_with_msg(device, 3, "Waiting to navigate through sharing options.")

    # Press Tab twice to navigate to the "Entire Screen" option
    pyautogui.press("tab", presses=2, interval=0.5)
    common.sleep_with_msg(device, 3, "Waiting to navigate through sharing options.")

    # Press Enter to confirm sharing
    pyautogui.press("enter")
    common.sleep_with_msg(device, 3, "Confirming screen sharing selection.")

    print("Screen sharing initiated successfully.")

    # Handle the desktop window and press "Controller" tab
    pyautogui.keyDown("ctrl")
    pyautogui.press("tab")
    pyautogui.keyUp("ctrl")
    common.sleep_with_msg(
        device, 3, "Handling the desktop window and selecting the 'Controller' tab."
    )  # Wait for UI response

    # Verify if sharing indicator is present
    common.wait_for_element(device, web_signin_dict, "stop_sharing_indicator")


def accept_incoming_calls_in_tdc(device):
    common.wait_for_and_click(device, web_signin_dict, "accept_call_button")
    handle_teams_popup_during_accept_call(device)
    common.wait_while_present(device, web_signin_dict, "accept_call_button")


def handle_teams_popup_during_accept_call(device):
    common.sleep_with_msg(device, 5, "checking the popup to be visible")
    if not common.click_if_present(device, web_signin_dict, "without_audio_or_video"):
        print(f"{device}: 'maybe_later' element not found or not visible.")


def make_outgoing_call_from_tdc_using_number(device, to_device):
    common.wait_for_and_click(device, web_signin_dict, "phone_option")
    common.wait_for_element(device, web_signin_dict, "dial_pad_digits_in_tdc")
    participants = to_device.split(",")
    print("Participants : ", participants)
    if to_device is not None:
        for participant in participants:
            participant_phonenumber = shared_utils.getconfig_phonenumber(participant)
            common.wait_for_element(device, web_signin_dict, "Type_a_name_or_number").send_keys(participant_phonenumber)
            recheck = 3
            for attempt in range(recheck):
                try:
                    common.wait_for_and_click(device, web_signin_dict, "select_add_user")
                    print(f"{participant_phonenumber}: added")
                    break  # If successful, break out of the retry loop
                except StaleElementReferenceException:
                    print(f"Stale element reference on attempt {attempt + 1}. Retrying...")
                    time.sleep(2)  # Optional: Adding a small delay before retrying
                    if attempt == recheck - 1:
                        raise
    common.wait_for_and_click(device, web_signin_dict, "click_on_call")
    handle_teams_popup_during_accept_call(device)
    common.sleep_with_msg(device, 5, "wait for call ui get stable")
    common.wait_for_element(device, web_signin_dict, "leave_btn_tdc")


def verify_call_state_in_tdc(device, state):
    if state.lower() not in ["connected", "disconnected", "hold", "resume"]:
        raise AssertionError(f"Invalid state specified: {state}")
    print("device : ", device)
    if state.lower() == "connected":
        common.wait_for_element(device, web_signin_dict, "hang_up_button_in_tdc")
    elif state.lower() == "disconnected":
        common.sleep_with_msg(device, 2, "wait for stable the call")
        common.raise_if_present(device, web_signin_dict, "hang_up_button_in_tdc")
    elif state.lower() == "hold":
        common.sleep_with_msg(device, 2, "wait for hold the call appear")
        common.wait_for_element(device, web_signin_dict, "hold_label_in_tdc")
    elif state.lower() == "resume":
        common.sleep_with_msg(device, 2, "wait for resume get stable")
        common.wait_for_element(device, web_signin_dict, "resume_button")


def disconnect_the_call_in_tdc(device):
    common.wait_for_and_click(device, web_signin_dict, "hang_up_button_in_tdc")
    common.click_if_present(device, web_signin_dict, "hang_up_button_in_tdc", "xpath1")
    common.wait_while_present(device, web_signin_dict, "hang_up_button_in_tdc")


def enable_real_time_text_meeting_web(device):
    common.wait_for_and_click(device, web_signin_dict, "more_option_in_rtt_meeting")
    common.wait_for_element(device, web_signin_dict, "language_and_speech")
    common.wait_for_and_click(device, web_signin_dict, "language_and_speech")
    common.wait_for_and_click(device, web_signin_dict, "turn_on_rtt_option")
    common.wait_for_and_click(device, web_signin_dict, "turn_on_rtt_enable")
    common.wait_for_element(device, web_signin_dict, "rtt_text_message")


def share_rtt_message_from_chat_option_in_TDC(device):
    text_need_to_send = shared_utils.getconfig_device_rtt_msg(device)
    common.wait_for_element(device, web_signin_dict, "rtt_text_message").send_keys(text_need_to_send)


def find_frame_with_element(device, element_key):
    driver = driver_manager_instance.get_driver(device)
    frames = driver.find_elements(By.TAG_NAME, "iframe")
    print(f"Total number of frames: {len(frames)}")
    for i, frame in enumerate(frames):
        driver.switch_to.frame(frame)
        if common.is_element_present(device, web_signin_dict, element_key):
            print(f"Found element '{element_key}' in frame {i + 1}")
            return frame
    return None


def move_mouse_to_screen_center():
    x, y = pyautogui.position()
    if x in (0, pyautogui.size().width - 1) or y in (0, pyautogui.size().height - 1):
        print("Mouse is in fail-safe zone. Moving it slightly away first.")
        pyautogui.moveTo(100, 100)
    screen_width, screen_height = pyautogui.size()
    pyautogui.moveTo(screen_width // 2, screen_height // 2)


def admit_external_participants_into_meeting_on_tdc(device, participant):
    print(participant)
    display_name = shared_utils.getconfig_displayname(participant)
    common.click_if_present(device, web_signin_dict, "popup_close_get_started_button", "xpath1")
    common.sleep_with_msg(device, 4, "waiting for admit popup")
    admit_pop_up_text = common.wait_for_element(device, web_signin_dict, "external_participant_popup").text
    print(admit_pop_up_text)
    if display_name in admit_pop_up_text:
        common.wait_for_and_click(device, web_signin_dict, "admit_external_participant")
        print(f"{participant}: admitted")
    else:
        raise AssertionError(f"unable to find {participant} for admit")


def verify_the_pin_option_in_tdc(device, to_device):
    common.wait_for_and_click(device, web_signin_dict, "people_tab")
    driver = driver_manager_instance.get_driver(device)
    user_name = shared_utils.getconfig_displayname(to_device)
    tmp_dict = common.get_dict_copy(web_signin_dict, "pin_option_in_people_tab", "username_to_pin", user_name)
    element_to_hover = common.wait_for_element(device, tmp_dict, "pin_option_in_people_tab")
    action = ActionChains(driver)
    action.move_to_element(element_to_hover).perform()
    time.sleep(3)
    common.wait_for_and_click(device, web_signin_dict, "triple_dots_under_mouse_action")
    common.wait_for_and_click(device, web_signin_dict, "pin_for_me")
    temp_dict_user = common.get_dict_copy(web_signin_dict, "pinned_elements", "username_to_pin", user_name)
    if "Pinned" not in str(temp_dict_user):
        raise AssertionError(f"{device}: is not pinned")


def verify_raise_hand_in_tdc(device):
    common.wait_for_element(device, web_signin_dict, "raise_hand_in_tdc")


def create_a_meeting_using_meet_now_in_tdc(device, meeting_name="test_meeting"):
    if not common.click_if_present(device, web_signin_dict, "calendar_button"):
        print(f"{device}: calendar button not found clicking on more option..")
        common.wait_for_and_click(device, web_signin_dict, "more_apps_button")
        common.wait_for_and_click(device, web_signin_dict, "calendar_button")
    common.sleep_with_msg(device, 5, "wait for the page response completely")
    common.click_if_present(device, web_signin_dict, "got_it_button")
    common.click_if_present(device, web_signin_dict, "do_it_later")
    verify_and_modify_new_calender_toggle(device)
    common.wait_for_and_click(device, web_signin_dict, "meet_now_in_tdc")
    common.wait_for_element(device, web_signin_dict, "start_meet_now_popup")
    common.wait_for_element(device, web_signin_dict, "meeting_name").send_keys(meeting_name)
    common.wait_for_and_click(device, web_signin_dict, "start_meet_now_button")
    handle_teams_popup_during_accept_call(device)
    common.wait_for_and_click(device, web_signin_dict, "join_button_in_tdc")
    common.sleep_with_msg(device, 5, "waiting for the stable the web")
    common.wait_for_element(device, web_signin_dict, "invite_people_to_join_you_popups")
    common.wait_for_and_click(device, web_signin_dict, "add_participants")
    common.wait_for_element(device, web_signin_dict, "hang_up_button_in_tdc")


def search_participate_in_people_tab_request_to_join(device, to_device):
    participants = to_device.split(",")
    print("Participants : ", participants)
    for participant in participants:
        display_name = shared_utils.getconfig_displayname(participant)
        common.wait_for_element(device, web_signin_dict, "invite_someone_or_dial_number_for_meet_now").send_keys(
            display_name
        )
        temp_username = common.get_dict_copy(web_signin_dict, "searched_user", "user_name", display_name)
        elements = common.wait_for_element(device, temp_username, "searched_user")
        driver = driver_manager_instance.get_driver(device)
        e = ActionChains(driver)
        e.move_to_element(elements).perform()
        temp_user_request = common.get_dict_copy(web_signin_dict, "request_to_join", "user_name", display_name)
        common.wait_for_and_click(device, temp_user_request, "request_to_join")


def stop_tdc_screen_sharing(device):
    common.wait_for_element(device, web_signin_dict, "leave_btn_tdc")
    common.wait_for_and_click(device, web_signin_dict, "stop_sharing_indicator")
    common.wait_for_element(device, web_signin_dict, "share_icon")


def verify_Rtt_text_box_availability(device):
    common.raise_if_present(device, web_signin_dict, "verify_rtt_text_box_on_tdc")


def verify_disable_real_time_text_meeting_web(device):
    common.wait_for_and_click(device, web_signin_dict, "more_option_in_rtt_meeting")
    common.wait_for_and_click(device, web_signin_dict, "language_and_speech")
    common.wait_for_element(device, web_signin_dict, "verify_disable_of_rtt")


def join_proximit_meeting_on_TDC(device, participant):
    driver = driver_manager_instance.get_driver(device)
    common.wait_for_and_click(device, web_signin_dict, "join_btn_tdc")
    try:
        time.sleep(3)
        driver.switch_to.alert().accept()
    except Exception as e:
        common.click_if_present(device, web_signin_dict, "without_audio_or_video")
    common.wait_for_element(device, web_signin_dict, "join_btn_tdc", "xpath1")
    common.wait_for_and_click(device, web_signin_dict, "room_audio")
    common.wait_for_and_click(device, web_signin_dict, "room_input")
    display_name = shared_utils.getconfig_displayname(participant)
    print(f"Participant:{display_name}")
    input_text = common.wait_for_element(device, web_signin_dict, "room_input")
    input_text.send_keys(display_name)
    common.wait_for_and_click(device, web_signin_dict, "room_user_search_result")
    common.wait_for_and_click(device, web_signin_dict, "join_btn_tdc", "xpath1")
    common.wait_for_element(device, web_signin_dict, "leave_btn_tdc")


def simulate_and_verify_chats_for_dut(from_device, to_device, message, send_message_batch):
    batch_count = int(send_message_batch)  # Directly convert to int
    if not common.is_element_present(from_device, web_signin_dict, "send_button"):
        common.wait_for_and_click(from_device, web_signin_dict, "chat_button_in_meeting")
    for i in range(1, batch_count + 1):
        full_message = f"{str(message)} {i}"
        print(f"Sending: {full_message}")
        msg = "https://teams.microsoft.com" if "link" in full_message else full_message
        common.wait_for_element(from_device, web_signin_dict, "send_chat").send_keys(msg)
        common.wait_for_and_click(from_device, web_signin_dict, "send_button")
        common.wait_for_element(to_device, tr_console_calendar_dict, "chat_notification_bubble")
    len_message = common.get_all_elements_texts(to_device, tr_console_calendar_dict, "chat_notification_bubble")
    if len(len_message) > 3:
        raise AssertionError(f"More tha Three messages are displayed on {to_device}: {len_message}")
    common.sleep_with_msg(to_device, 4, "Wait for message to disappear on device")
    common.raise_if_present(to_device, tr_console_calendar_dict, "chat_notification_bubble")
