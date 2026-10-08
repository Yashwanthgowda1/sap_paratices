import json
import os
from pathlib import Path

BASE_DIR = Path(__file__).parent.parent

def _load_json(filepath: str) -> dict:
    with open(filepath, "r") as f:
        return json.load(f)


class WebConfig:
    _data = _load_json(BASE_DIR / "config" / "web_config.json")
    _env  = os.getenv("TEST_ENV", "staging")

    BASE_URL      = _data["environments"][_env]["base_url"]
    API_BASE_URL  = _data["environments"][_env]["api_base_url"]
    BROWSER       = os.getenv("BROWSER", _data["browser"]["default"])
    HEADLESS      = os.getenv("HEADLESS", str(_data["browser"]["headless"])).lower() == "true"

    IMPLICIT_WAIT = _data["timeouts"]["implicit_wait"]
    EXPLICIT_WAIT = _data["timeouts"]["explicit_wait"]
    PAGE_LOAD     = _data["timeouts"]["page_load"]

    VALID_EMAIL    = _data["test_data"]["valid_user"]["email"]
    VALID_PASSWORD = _data["test_data"]["valid_user"]["password"]


class MobileConfig:
    _data = _load_json(BASE_DIR / "config" / "mobile_config.json")

    APPIUM_URL = os.getenv("APPIUM_URL", _data["appium_server"]["url"])

    # Desired capabilities dict — passed directly to Appium driver
    CAPABILITIES = {
        "platformName":        _data["android"]["platformName"],
        "appium:platformVersion":   _data["android"]["platformVersion"],
        "appium:deviceName":        os.getenv("DEVICE_NAME", _data["android"]["deviceName"]),
        "appium:app":               os.getenv("APP_PATH",    _data["android"]["app"]),
        "appium:appPackage":        _data["android"]["appPackage"],
        "appium:appActivity":       _data["android"]["appActivity"],
        "appium:automationName":    _data["android"]["automationName"],
        "appium:noReset":           _data["android"]["noReset"],
        "appium:fullReset":         _data["android"]["fullReset"],
        "appium:newCommandTimeout": _data["android"]["newCommandTimeout"],
        "appium:autoGrantPermissions": _data["android"]["autoGrantPermissions"],
    }

    IMPLICIT_WAIT    = _data["timeouts"]["implicit_wait"]
    EXPLICIT_WAIT    = _data["timeouts"]["explicit_wait"]
    GESTURE_DURATION = _data["timeouts"]["gesture_duration"]

    VALID_USERNAME = _data["test_data"]["valid_user"]["username"]
    VALID_PASSWORD = _data["test_data"]["valid_user"]["password"]
