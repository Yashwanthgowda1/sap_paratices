import subprocess
import time
import re

from Libraries import shared_utils
from Libraries.Selectors import load_json_file

from resources.keywords import calendar_keywords
from resources.keywords import common

from Libraries.initiate_driver import obj_dev as obj

calendar_dict = load_json_file("resources/Page_objects/Calendar.json")
settings_dict = load_json_file("resources/Page_objects/Settings.json")
navigation_dict = load_json_file("resources/Page_objects/Navigation.json")
calls_dict = load_json_file("resources/Page_objects/Calls.json")


def reset_logcat_capture(count=None, device=None):
    print(f"reset_logcat_capture(count={count}, device={device})")

    # Sanity: Either 'count' or 'device', NOT both:
    if count and device:
        raise AssertionError(f"reset_logcat_capture: Either 'count' OR 'device' - NOT both.")

    devices = []

    if count:
        # Note: 'devices' only, no 'consoles':
        try:
            count = int(count)
        except ValueError:
            raise AssertionError(f"reset_logcat_capture: ValueError: 'count={count}' - expecting an int.")

        devices = shared_utils.getconfig_all_devices_by_class("devices")[0:count]
    elif device:
        devices = shared_utils.make_list(device)
    else:
        raise AssertionError(f"reset_logcat_capture: Must specify either 'count' OR 'device'.")

    print(f"reset_logcat_capture: Clearing logcat on devices: {devices}")

    for device in devices:
        driver = obj.device_store.get(alias=device)
        logs_previous = driver.get_log("logcat")
        # TODO: We are ignoring any crashes reported in the old logs - might be useful info...
    print(f"reset_logcat_capture: logcat logs cleared: {devices}")


def verify_intents(device, intent, user):
    driver = obj.device_store.get(alias=device)
    time.sleep(5)
    logs_current = driver.get_log("logcat")
    # print "Current log cat : \n", logs_current
    filter = "com.microsoft.skype.teams.ipphone.APP_USER_STATE"
    if user == "user":
        filter_user = "IS_CAP 0"
    elif user in ["meeting_user", "cap_search_enabled", "cap_user"]:
        filter_user = "IS_CAP 1"
    if intent == "sign_in":
        filter_mode = "SIGNED_IN 1"
    elif intent == "sign_out":
        filter_mode = "SIGNED_IN 0"
        filter_user = "IS_CAP 0"
    res = []
    for i in logs_current:
        if filter in i["message"] and filter_mode in i["message"]:
            print("Intent : ", i)
            assert filter_user in i["message"], "Intent Not found"
            res.append(i)
    if len(res) == 0:
        raise AssertionError("Intent not found")
    else:
        print("Intent {} found in logcat".format(res))
    pass


def stop_logcat_capture(device):
    devices = device.split(",")
    for device in devices:
        driver = obj.device_store.get(alias=device)
        logs_post = driver.get_log("logcat")
        print("Previous logs : ", logs_post)
    pass


def Verify_presence_of_Intents(device, feature, state):
    if not state.lower() in ["present", "absent"]:
        raise AssertionError(f"Unexpected state:{state}")
    _model = common.device_model(device)
    driver = obj.device_store.get(alias=device)
    time.sleep(5)
    logs_current = driver.get_log("logcat")
    # print ("Current log cat : \n", logs_current)
    if feature == "panel_app_settings":
        if _model in [
            "flint",
            "arlington",
            "surprise",
            "hollywood",
            "beverly hills",
            "plano",
            "hollywood_13",
            "beverly hills_13",
        ]:
            print(f"{device}: No validation for device model '{_model}'")
            return
        else:
            filter = "com.microsoft.skype.teams.ipphone.partner.LAUNCH_PANEL_SETTINGS"
    elif feature == "admin_pass_change":
        new_admin_pass = shared_utils.get_configured_device_property(device, "admin_new_password")
        filter = new_admin_pass
    elif feature == "KEYCODE_DPAD_RIGHT":
        filter = "KEYCODE_DPAD_RIGHT"
    elif feature == "KEYCODE_DPAD_LEFT":
        filter = "KEYCODE_DPAD_LEFT"
    elif feature == "KEYCODE_507":
        filter = "keyCode=507"
    elif feature == "KEYCODE_506":
        filter = "keyCode=506"
    elif feature == "keycode":
        filter = "keycode"
    elif feature == "KEYCODE_0":
        filter = "KEYCODE_0"
    elif feature == "KEYCODE_STAR":
        filter = "KEYCODE_STAR"
    elif feature == "KEYCODE_POUND":
        filter = "KEYCODE_POUND"
    elif feature == "KEYCODE_203":
        filter = "keycode:203"
    elif feature == "KEYCODE_VOLUME_UP":
        filter = "KEYCODE_VOLUME_UP"
    elif feature == "KEYCODE_VOLUME_DOWN":
        filter = "KEYCODE_VOLUME_DOWN"
    elif feature == "KEYCODE_MUTE":
        filter = "KEYCODE_MUTE"
    elif feature == "KEYCODE_BUTTON_14":
        filter = "KEYCODE_BUTTON_14"
    elif feature == "KEYCODE_CONTACTS":
        filter = "KEYCODE_CONTACTS"
    elif feature == "KEYCODE_BUTTON_16":
        filter = "KEYCODE_BUTTON_16"
    elif feature == "KEYCODE_BUTTON_12":
        filter = "KEYCODE_BUTTON_12"
    elif feature == "KEYCODE_BUTTON_13":
        filter = "KEYCODE_BUTTON_13"
    elif feature == "KEYCODE_BUTTON_15":
        filter = "KEYCODE_BUTTON_15"
    elif feature == "keycode:506":
        filter = "keycode:506"
    elif feature == "volume_music_speaker":
        filter = "volume_music_speaker"
    elif feature == "DIALPADICON_STATE":
        filter = "DIALPADICON_STATE 1"
    elif feature == "pstn_disabled_dialpad_state":
        filter = "DIALPADICON_STATE 0"
    elif feature == "DIALPAD_KEYCODE":
        features = "0123456789"
        for i in features:
            if i not in features:
                raise AssertionError(f"{device}: digit '{i}' is not acceptable in '{features}'")
            else:
                filter = f"KEYCODE_{i}"
            print(f"{filter}")
            Verify_presence_of_intents_in_logcat(device, filter, state, logs_current)
        return
    elif feature == "TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION":
        filter = "TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION"
    elif feature == "SoftwareUpdateCommandHandler":
        filter = "SoftwareUpdateCommandHandler failed"
    elif feature == "admin_password":
        admin_password = shared_utils.get_configured_device_property(device, "admin_password")
        if _model in ["beverly hills", "hollywood", "hollywood_13", "beverly hills_13"]:
            admin_password = f"LockManager: CheckPassword 2,admin,{admin_password},"
        filter = admin_password
    elif feature == "user_password":
        username, password, device, account = common.get_credentials(device)
        filter = password
    elif feature == "seaside_bliss":
        filter = "Seaside Bliss"
    elif feature == "lock_password":
        phone_lock = shared_utils.getconfig_device_phone_password(device)
        filter = phone_lock
    else:
        raise ValueError(f"unknown feature value: {feature}")
    Verify_presence_of_intents_in_logcat(device, filter, state, logs_current)


def Verify_presence_of_intents_in_logcat(device, filter, state, logs_current):
    res = []
    for i in logs_current:
        if filter in i["message"]:
            res.append(i)
    if state.lower() == "present":
        if len(res) == 0:
            raise AssertionError("Intent not found", logs_current)
        else:
            print("Intent {} found in logcat".format(res))
    elif state.lower() == "absent":
        if len(res) == 0:
            print("Intent is absent as per expected")
        else:
            raise AssertionError("Intent {} found in logcat".format(res), logs_current)


def verify_checking_the_mute_intents(device, intent):
    driver = obj.device_store.get(alias=device)
    time.sleep(5)
    logs_current = driver.get_log("logcat")
    filter = "com.microsoft.skype.teams.ipphone.APP_MUTE_STATE"
    if intent == "mute_off":
        filter_mode = "MUTE_STATE 0"
    elif intent == "mute_on":
        filter_mode = "MUTE_STATE 1"
    res = []
    for i in logs_current:
        if filter in i["message"] and filter_mode in i["message"]:
            print("Intent : ", i)

            res.append(i)
    if len(res) == 0:
        raise AssertionError("Intent not found")
    else:
        print("Intent {} found in logcat".format(res))


def is_dailpad_intents_supported_device(device):
    _model = common.device_model(device)
    if _model in ["riverside_13", "bakersfield_13", "santa cruz_13", "malibu_13"]:
        print(f"{device}: is not having intents support")
        return True
    return False


def verify_multiple_intents(device, features_list, intents_list):
    driver = obj.device_store.get(alias=device)
    time.sleep(5)
    if isinstance(intents_list, str):
        intents_list = intents_list.split(",")
    if isinstance(features_list, str):
        features = features_list.split(",")
    logs_current = driver.get_log("logcat")
    # print(logs_current)

    intent_conditions = {
        "sign_in": "SIGNED_IN 1",
        "sign_out": "SIGNED_IN 0",
        "incomming_call": "INCOMING_CALL  1",
        "not_incomming_call": "INCOMING_CALL  0",
        "in_call": "IN_CALL 1",
        "not_in_call": "IN_CALL 0",
        "voicemail_playing": "VOICEMAILPLAYING 1",
        "voicemail_not_playing": "VOICEMAILPLAYING 0",
        # Regex for speaker on/off
        "speaker_on": r"(SPEAKER\s*1|SPEAKER:\(1:On\)|SPEAKER=1)",
        "speaker_off": r"(SPEAKER\s*0|SPEAKER:\(0:Off\)|SPEAKER=0)",
        # Regex for handset/headset on/off
        "handset_on": r"(HANDSETHOOK\s*1|HANDSETHOOK:\(1:On\)|HANDSETHOOK=1)",
        "handset_off": r"(HANDSETHOOK\s*0|HANDSETHOOK:\(0:Off\)|HANDSETHOOK=0)",
        "headset_on": r"(HEADSETHOOK\s*1|HEADSETHOOK:\(1:On\)|HEADSETHOOK=1)",
        "headset_off": r"(HEADSETHOOK\s*0|HEADSETHOOK:\(0:Off\)|HEADSETHOOK=0)",
        # Regex for bluetooth on/off
        "bluetooth_on": r"(BLUETOOTH\s*1|BLUETOOTH:\(1:On\))",
        "bluetooth_off": r"(BLUETOOTH\s*0|BLUETOOTH:\(0:Off\))",
        "dialpad_disable": "DIALPAD_STATE 0",
        "dialpad_enable": "DIALPAD_STATE 1",
        "dialpad_showing_number": "DIALPAD_STATE 2",
        # non_discrptivebanner
        "meeting_cancelled": "NotDeferred",
        "meeting_scheduled": "MeetingScheduled",
        "incall": "InCall",
        "UserDeferred": "UserDeferred",
    }

    res = []

    # Loop through each feature in the features list
    for feature in features:
        # Loop through each intent in the intents list
        for intent in intents_list:
            if intent not in intent_conditions:
                raise ValueError(f"Unknown intent: {intent}")

            # Set mode for each intent
            filter_mode = intent_conditions[intent]

            # Check logs for each feature and intent combination
            for log_entry in logs_current:
                log_message = log_entry["message"]
                if re.search(feature, log_message) and re.search(filter_mode, log_message):
                    print(f"Intent '{intent}' for feature '{feature}' found in log: {log_entry}")
                    res.append((feature, intent, log_entry))
                    break

    if len(res) == len(intents_list):
        print(f"All intents {intents_list} for all features {features} found in logcat")
    else:
        print(f"intents captured{res}")
        raise AssertionError("Some intents were not found")


def current_volume_level(device, volume_stream):
    _oem = common.device_oem(device)
    _udid = common.device_udid(device)
    stream_type = {"system": "STREAM_SYSTEM", "calling": "STREAM_VOICE_CALL", "music": "STREAM_MUSIC"}
    if volume_stream not in stream_type:
        raise ValueError(f"Unknown volume_stream: {volume_stream}")
    command_type = stream_type[volume_stream]
    command = (
        f'powershell -Command "adb -s {_udid} shell dumpsys audio | '
        f"Select-String -Pattern '{command_type}' -Context 0,5 | "
        'Select-Object -First 1"'
    )
    try:
        output = subprocess.check_output(command, shell=True, text=True).strip()
        print(f"Command output: {output}")
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {e.output}")
        output = e.output.strip()
    if _oem == "Washington":
        match = re.search(r"\(speaker\):\s*(\d+)", output)
        if match:
            volume = int(match.group(1))
            print(volume)
            return volume
        else:
            print("streamVolume not found")
    else:
        match = re.search(r"streamVolume:(\d+)", output)
        if match:
            volume = int(match.group(1))
            print(volume)
            return volume
        else:
            print("streamVolume not found")


def adjust_volume_if_at_max_or_min(device, volume, volume_stream):
    _oem = common.device_oem(device)
    print(f"Adjusting volume {volume}")
    max_volume = None
    if _oem == "arizona":
        max_volume = 10
        print(f"device oem {_oem}")
    elif _oem == "washington":
        max_volume = 16
        print(f"device oem {_oem}")
    elif _oem == "california":
        max_volume = 15
        print(f"device oem {_oem}")

    if volume == max_volume:
        print(f"current volume {volume} max_volume {max_volume}")
        calendar_keywords.volume_down_using_keyevent(device)
    elif volume == 0:
        print(f"current volume is zero")
        calendar_keywords.volume_up_using_keyevent(device)
    time.sleep(10)
    Cvolume = current_volume_level(device, volume_stream)
    print(f"adjusted volume is {Cvolume}")
    return Cvolume


def set_volume_to_lowest(device, Cvolume, volume_stream):
    _oem = common.device_oem(device)
    iteration = 1 if _oem == "Washington" else 2
    if Cvolume == 1:
        return

    _udid = shared_utils.getconfig_device_udid(device)
    if Cvolume == 0:
        for _ in range(iteration):
            subprocess.call(
                f"adb -s {_udid} shell input keyevent 24",
                shell=True,
            )

    else:
        for _ in range(iteration):
            subprocess.call(
                f"adb -s {_udid} shell input keyevent 25",
                shell=True,
            )
        time.sleep(5)
        Cvolume = current_volume_level(device, volume_stream)
        print(f"volume changed to {Cvolume}")
        if Cvolume != 1:
            set_volume_to_lowest(device, Cvolume, volume_stream)


def compare_volume(device, volume, volume_stream, volume_state):
    if volume_state.lower() not in ["increasing", "decreasing", "constant"]:
        raise AssertionError(f"Unknown volume_state: {volume_state}")
    print(f"Initial volume {volume}")
    stream_type = {"system": "STREAM_SYSTEM", "calling": "STREAM_VOICE_CALL", "music": "STREAM_MUSIC"}
    if volume_stream not in stream_type:
        raise AssertionError(f"Unknown volume_stream: {volume_stream}")
    _volume = current_volume_level(device, volume_stream)
    print(f"First volume {_volume}")
    if volume_state == "increasing":
        if not volume > _volume:
            raise AssertionError(f"{device}: volume didn't increase '{_volume}'")

    elif volume_state == "decreasing":
        if not volume < _volume:
            raise AssertionError(f"{device}: volume didn't decrease '{_volume}'")

    elif volume_state == "constant":
        if not volume == _volume:
            raise AssertionError(f"{device}: volume is not constant '{_volume}'")
    return f"{device}: volume comparison successful for state '{volume_state}'"
