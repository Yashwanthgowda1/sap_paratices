import os
import subprocess
import time
import traceback
from threading import Lock

from appium import webdriver
from appium.webdriver.appium_connection import AppiumConnection
from appium.webdriver.common.appiumby import AppiumBy

from selenium.common.exceptions import InvalidSessionIdException, NoSuchElementException
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.chrome.webdriver import WebDriver as chrome_webdriver

from robot.libraries.BuiltIn import BuiltIn

from Libraries.robot_appium import CachingAppiumConnection
from Libraries.device_control import ping_device, connect_device, reset_Teams_app, grant_teams_app_permission
from Libraries.Store import Store
from Libraries import shared_utils

_logdir_create_lock = Lock()


class AccountSetup:
    __instance = None

    def __new__(cls, *args, **kwargs):
        if not cls.__instance:
            cls.__instance = super(AccountSetup, cls).__new__(cls, *args, **kwargs)
        return cls.__instance

    @classmethod
    def getInstance(cls):
        if cls.__instance is None:
            cls.__instance = AccountSetup()
        return cls.__instance

    def __init__(self):
        self.__instance.device_store = Store()
        print(f"Singleton created: AccountSetup: {self.__instance}, Store={self.__instance.device_store}")

    def get_driver_names(self):
        return self.device_store.aliases

    def setup_device_driver(self, device, config=None, resetApp=True):
        """Get an webdriver instance."""
        device, _ = shared_utils.decode_device_specifier(device)
        device_class = shared_utils.getconfig_device_class(device)

        if device_class == "browsers":
            chrome_options = ChromeOptions()
            # Always use incognito/maximized modes:
            chrome_options.add_argument("--incognito")
            chrome_options.add_argument("--start-maximized")

            # No, occasionally leaves "chrome.exe" instances running - blocks pipeline ('logfile in use').
            #   We want all 'chrome.exe' instances to be torn down when the sandbox is torn down:
            #   chrome_options.add_argument("--no-sandbox")

            chrome_options.add_argument("--disable-notifications")
            chrome_options.add_argument("--disable-media-stream")

            prefs = {
                "profile.default_content_setting_values.media_stream_camera": 2,  # using 2 for blocking camera ,Allow camera 1 is not working
                "profile.default_content_setting_values.media_stream_mic": 2,  # Block microphone
                "profile.default_content_setting_values.notifications": 2,  # Block notifications
            }
            chrome_options.add_experimental_option("prefs", prefs)

            # Always capture cromedriver logs, similar to 'appium_logs':
            _logdir = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "chrome_logs")

            with _logdir_create_lock:
                # directory must exist:
                if not os.path.exists(_logdir):
                    os.makedirs(_logdir)

            # Generate a filename based on the current time
            timestamp = time.strftime("%Y%m%d_%H%M%S")
            _log_file = os.path.join(_logdir, f"{device}_{timestamp}.log")

            # Add, with 'verbose':
            chrome_options.add_argument("--verbose")
            chrome_options.add_argument(f"--log-file={_log_file}")
            print(f"{device}: Chromedriver logging to: {_log_file}")

            driver = chrome_webdriver(options=chrome_options)

            # The parent directory of 'chromedriver.exe' will suffice for determining the chromedriver version:
            print(f"driver.service.path={driver.service.path}")

        else:
            _common_caps = shared_utils.getconfig_common_caps()
            _device_caps = shared_utils.getconfig_device_caps(device)
            # device_class == devices/consoles
            desired_cap = {**_common_caps, **_device_caps}

            if not resetApp:
                # Remove 'fullReset' (or 'appium:fullreset') from desired capabilities as it conflicts with 'noReset', which preserves app state:
                if any(k.lower().find("fullreset") >= 0 for k in desired_cap):
                    print(f"{device}: Removing 'fullReset' from desired_capabilities")
                    desired_cap = {k: v for k, v in desired_cap.items() if k.lower().find("fullreset") >= 0}
                print(f"{device}: Adding 'noReset' to desired_capabilities")
                desired_cap["noReset"] = True

            endpointSuffix = self.appium_endpoint_suffix(device)

            if shared_utils.getconfig_is_emulator(device):
                grant_teams_app_permission(device)

            # Note: No attempt is made to enforce that the 'caching' settings are present - it is optional.
            _port = shared_utils.getconfig_device_port(device)
            if CachingAppiumConnection.is_caching_enabled(device, desired_cap):
                appium_executor = CachingAppiumConnection(
                    device,
                    remote_server_addr="http://127.0.0.1:" + str(_port) + endpointSuffix,
                )
            else:
                appium_executor = AppiumConnection(remote_server_addr="http://127.0.0.1:" + str(_port) + endpointSuffix)

            try:
                driver = webdriver.Remote(
                    appium_executor,
                    desired_capabilities=desired_cap,
                )
            except InvalidSessionIdException as err:
                driver = None

            if not driver:
                shared_utils.sleep_with_msg(device, 2, "Driver create: InvalidSessionIdException - retrying...")
                driver = webdriver.Remote(
                    appium_executor,
                    desired_capabilities=desired_cap,
                )

            shared_utils.sleep_with_msg(device, 10, "setup_device_driver - Allow Appium startup")

        # Track/remember this webDriver:
        self.device_store.add(driver, alias=device)
        print(f"Added '{device_class}' WebDriver for: {device}")

    def re_setup_device_driver(self, device, config=None):
        """
        Tear-down and re-establish automation with the specified device.
        """
        print(f"{device}: re_setup_device_driver")
        device, _ = shared_utils.decode_device_specifier(device)
        udid_ = shared_utils.getconfig_device_udid(device)

        # First, establish that the webdriver is broken and needs to be restarted:
        _driver_is_broken = True

        if self.device_store.has_alias(device):
            try:
                _driver = self.device_store.get(device)
                _driver.find_element(by=AppiumBy.XPATH, value="//crash_check")
                _driver_is_broken = False
            except NoSuchElementException as e:
                print(f"{device}: webdriver is ok, returns: NoSuchElementException")
                _driver_is_broken = False
            except Exception as e:
                print(f"{device}: webdriver is broken, returns: '{type(e).__name__}': {e}")

        if _driver_is_broken:
            self.teardown_device_driver(device)
        else:
            print(f"{device}: webdriver appears healthy - reset skipped")

        _is_ip = udid_.count(".") == 3
        print(f"{device}: UDID '{udid_}' is_ip={_is_ip}")

        #
        # IP-connected device may be restarting or unplugged - verify/re-do EVERYTHING.
        #
        if _is_ip:
            try:
                ping_device(device, config)
                connect_device(device, config)
            except Exception as e:
                print(f"{device}: re_setup_device_driver - Cannot re-connect - '{type(e).__name__}': {e}")
                raise

        # do we really want to do this here?
        reset_Teams_app(device)

        attached_devices = subprocess.check_output("adb devices", shell=True).decode("utf-8")
        print(f"Info: adb devices reports: {attached_devices}")

        if _driver_is_broken:
            self.setup_device_driver(device, config)

        print(f"{device}: Webdriver and/or Teams have been reset")

    def teardown_device_driver(self, device):
        """
        If 'device' has a Webdriver, ask it to quit
        """
        device, _ = shared_utils.decode_device_specifier(device)
        if not self.device_store.has_alias(device):
            print(f"teardown_device_driver: No driver for'{device}'")
            return
        driver = self.device_store.get(device)
        try:
            driver.quit()
            print(f"teardown_device_driver: terminated driver for'{device}'")
        except Exception as e:
            print(f"{device}: WARN teardown_device_driver: caught {type(e).__name__}: {e}")
        finally:
            self.device_store.remove(device)

    def setup_console_driver(self, console, config):
        self.setup_device_driver(console, config)

    def appium_endpoint_suffix(self, device):
        appium_version = subprocess.check_output("appium -v", shell=True).decode("utf-8").rstrip()
        endpointSuffix = ""
        if appium_version < "2.0.0":
            endpointSuffix = "/wd/hub"
        print(f"{device}: Appium version: {appium_version}, endpointSuffix: {endpointSuffix}")
        return endpointSuffix

    def re_setup_console_driver(self, console, config, root_console):
        return self.re_setup_device_driver(console)
        # self.teardown_console_driver(console)
        # udid_ = config["consoles"][console]["desired_caps"]["udid"]
        # root_console(console, config)
        # reset_Teams_app(console, config, [config["companyPortal_Package"], config["common_desired_caps"]["appPackage"]])
        # attached_devices = subprocess.check_output("adb devices", shell=True).decode("utf-8")
        # print(attached_devices)
        # self.setup_console_driver(console, config)
        # print("Added alias with name AGAIN : ", console)

    def teardown_console_driver(self, console):
        return self.teardown_device_driver(console)
