import subprocess
import uuid
from Libraries.shared_utils import getconfig_device_udid
from Libraries.Selectors import load_json_file
from resources.keywords import common
from Libraries.initiate_driver import obj_dev as obj
import time

non_disruptive_update_dict = load_json_file("resources/Page_objects/non_disruptive_update.json")
postpone_pattern = "User has postponed the software update"
dismiss_pattern = "Dismissed disruptive command banner, checking call status and meeting schedule"


def broadcast_disruptive_command_intent(device, command_type, action=None, timespan_requested_in_minutes=120):
    # Generate a unique correlation ID
    correlation_id = str(uuid.uuid4())

    # Construct the action details JSON string
    if action is not None:
        action_details = ""
    else:
        action_details = f'{{"commandType": "{command_type}","timespanRequestedInMinutes":{timespan_requested_in_minutes}, "commandId": 234}}'

    # Construct the adb command
    adb_command = (
        f"adb -s {getconfig_device_udid(device)} shell am broadcast -a com.microsoft.skype.teams.ipphone.action "
        f"--es actionType TEAMS_ACK_AGENT_COMMAND "
        f'--es CorrelationId "{correlation_id}" '
        f"--es actionDetails '{action_details}'"
    )

    # Execute the adb command
    try:
        subprocess.run(adb_command, shell=True, check=True)
        print(f"{device}: Broadcast intent sent successfully with CorrelationId: {correlation_id}")
    except Exception as e:
        print(f"{device}: Failed to send broadcast intent: {e}")
        raise AssertionError(f"{device}: Failed to send broadcast intent")


def click_on_postpone_button(device):
    common.click_if_present(device, non_disruptive_update_dict, "postpone_button")


def click_on_dismiss_button(device):
    common.click_if_present(device, non_disruptive_update_dict, "dismiss_button")


def verify_postpone_pattern_in_logcat_logs(device):
    verify_pattern_in_logcat_logs(device, postpone_pattern)


def verify_dismiss_pattern_in_logcat_logs(device):
    verify_pattern_in_logcat_logs(device, dismiss_pattern)


def verify_pattern_in_logcat_logs(device, pattern):
    driver = obj.device_store.get(alias=device)
    print(f"{device}: pattern '{pattern}'")
    time.sleep(2)
    logs_current = driver.get_log("logcat")
    res = []
    for i in logs_current:
        if pattern in i["message"]:
            print("pattern : ", i)
            res.append(i)
    if len(res) == 0:
        raise AssertionError(f"{device}: pattern not found")
    else:
        print(f"{device}: pattern {pattern} found in logcat at {res}")


def verify_postpone_and_dismiss_button_on_consent_banner(device, status="present"):
    if status.lower() not in ["absent", "present"]:
        raise AssertionError(f"{device}: Invalid value for option: {status}")
    if status == "present":
        common.wait_for_element(device, non_disruptive_update_dict, "consent_banner")
        common.wait_for_element(device, non_disruptive_update_dict, "postpone_button")
        common.wait_for_element(device, non_disruptive_update_dict, "dismiss_button")
    else:  # status == "absent"
        if common.is_element_present(
            device, non_disruptive_update_dict, "consent_banner"
        ) and common.is_element_present(device, non_disruptive_update_dict, "banner_text_option"):
            raise AssertionError(f"{device}: Banner is present on the Home Screen")
