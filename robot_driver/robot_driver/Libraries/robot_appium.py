"""
This module contains Appium related implementations for Robot
"""

from __future__ import annotations

from typing import Dict, Any

from selenium.webdriver.remote.command import Command
from appium.webdriver.appium_connection import AppiumConnection

# Appium 'command' classifiers
#   These command groupings are used to identify commands
#   which build, clear, consume or ignore the 'cache':
#
CMDS_CacheBuilders = [Command.FIND_ELEMENT]
CMDS_CacheClearers = [
    "actions",
    "clear",
    Command.CLEAR_ELEMENT,
    Command.CLICK_ELEMENT,
    Command.EXECUTE_ASYNC_SCRIPT,
    Command.FIND_CHILD_ELEMENTS,
    Command.FIND_ELEMENTS,
    Command.FIND_ELEMENTS_FROM_SHADOW_ROOT,
    Command.NEW_SESSION,
    Command.DELETE_SESSION,
    "w3cExecuteScript",
    "setImmediateValue",
    Command.SCREENSHOT,
    Command.GET_LOG,
    Command.GET_PAGE_SOURCE,
]
CMDS_CacheConsumers = [
    Command.GET_ELEMENT_TEXT,
    Command.GET_ELEMENT_ATTRIBUTE,
    Command.FIND_CHILD_ELEMENT,
    Command.FIND_ELEMENT_FROM_SHADOW_ROOT,
]
CMDS_CacheIgnore = [
    "hideKeyboard",
    "isElementDisplayed",
    "isElementEnabled",
    "getWindowRect",
    "getElementRect",
    Command.SEND_KEYS_TO_ELEMENT,
    Command.QUIT,
]


class CachingAppiumConnection(AppiumConnection):
    """
    Overide to allow access to execute/responses to take advantage element text caching.
    The intent is to avoid StaleElementReference exceptions caused by the sequence:

        ele = find_element("user name text box")
        str = ele.text  # If 'ele' goes out-of-scope before its text is fetched, the exception is raised.

    This override allows this operation to be atomic - if the element is found, so is its text.

    All Appium changes are invisible unless 'desired_caps' contains:
        "appium:settings[shouldUseCompactResponses]": false,
        "appium:settings[elementResponseAttributes]": "text",
    These caps settings will cause Appium to include 'element text' with each 'element'.

    """

    def __init__(
        self,
        device_name,
        remote_server_addr: str,
        keep_alive: bool = False,
        ignore_proxy: bool | None = False,
        init_args_for_pool_manager: Dict[str, Any] | None = None,
    ):
        """
        Override '__init__' in AppiumConnection to allow context 'device_name' context to be specified
        """
        self.device_name = device_name
        self.last_element = None
        super().__init__(remote_server_addr, keep_alive, ignore_proxy, init_args_for_pool_manager)
        print(f"{self.device_name}: CachingAppiumConnection initialized")

    def invalidate_cache(self):
        """Forget any cached data"""
        self.last_element = None

    def execute(self, command, params):
        """
        Override 'execute()' in RemoteConnection
        This override allows us to satisfy requests from a local cache instead of passing the request to the device.
        Interesting 'commands' are pre/post processed:
        1. Pre-processed commands MAY return appropriate responses from the local cache.
        2. Post-processed commands build the local cache.
        """
        # Debugging ONLY - make sure all commands are accounted for:
        if (
            command not in CMDS_CacheBuilders
            and command not in CMDS_CacheClearers
            and command not in CMDS_CacheConsumers
            and command not in CMDS_CacheIgnore
        ):
            print(f"DEBUG_CACHE: {self.device_name}: Unaccounted command={command}, params={params}")

        # Pre-processing of commands before executing:

        # These commands unconditionally clear any cached values:
        if command in CMDS_CacheClearers:
            self.invalidate_cache()
        elif self.last_element:
            # There is something in the cache, can we use it?
            if command == Command.GET_ELEMENT_TEXT:
                print(f"{self.device_name}: Using cached element text: '{self.last_element['text']}'")
                _ret = {"sessionId": self.last_element["ELEMENT"], "value": self.last_element["text"]}
                self.invalidate_cache()
                return _ret
            elif command == Command.GET_ELEMENT_ATTRIBUTE:
                if "name" in params:
                    if "text" in params["name"] or "name" in params["name"]:
                        # Odd mapping here - Appium treats get_attribute("name") and get_attribute("text") the same...
                        # This mapping is enforced here when we cache the values, key is simply 'value', not 'text' or'name'.
                        print(f"{self.device_name}: Using cached element attribute text: '{self.last_element['text']}'")
                        _ret = {"value": self.last_element["text"]}
                        self.invalidate_cache()
                        return _ret

        # Pre-processing complete - let Appium do its thing:
        _ret = super().execute(command, params)
        # Note: 'params' is no longer available...

        # Post processing:
        # The command has been executed, is the response interesting?
        if command == Command.FIND_ELEMENT:
            # Possibly interesting, make sure to forget any old values:
            self.invalidate_cache()

            # Look for elements found having the additional 'text' attributes, and cache it:

            # If the response contains a 'status', it is a failure response (and no 'text'):
            if "status" not in _ret:
                # Resposse should have a 'value' dict containing ALL the values:
                if "value" in _ret and isinstance(_ret["value"], dict):
                    if "text" in _ret["value"] and "ELEMENT" in _ret["value"]:
                        # print(f"{self.device_name}: found element with text, caching: '{_ret['value']}'")
                        self.last_element = _ret["value"]
                else:
                    # just making sure assumptions are correct:
                    print(f"WARN: {self.device_name}: Unexpected _ret= '{_ret}'")

        # Handled above:
        # elif command == Command.GET_ELEMENT_TEXT:
        #     print(f"NEWSTUFF {self.device_name}: Get text command '{Command.GET_ELEMENT_TEXT}' returns: '{_ret}'")

        # Handled above:
        # elif command == Command.GET_ELEMENT_ATTRIBUTE:
        #     print(f"NEWSTUFF {self.device_name}: Get attribute command '{Command.GET_ELEMENT_ATTRIBUTE}' returns: '{_ret}'")

        elif command in [
            Command.FIND_CHILD_ELEMENT,
            Command.FIND_ELEMENT_FROM_SHADOW_ROOT,
        ]:
            # Unexpected, we do not use these, fix if we do:
            print(f"*WARN* {self.device_name}: Unexpected, caching not implemented '{command}' returns: '{_ret}'")

        return _ret

    @staticmethod
    def is_caching_enabled(device_name, caps):
        # Report if the specified 'caps' has text caching settings configured.
        # All of our Appium caching changes are invisible unless 'desired_caps' contains:
        #   "appium:settings[shouldUseCompactResponses]": false,
        #   "appium:settings[elementResponseAttributes]": "text",
        has_compact_response_off = False
        has_text_added = False

        for item in caps.keys():
            if item.lower() == "appium:settings[shouldUseCompactResponses]".lower():
                if caps[item] == False:
                    has_compact_response_off = True
            elif item.lower() == "appium:settings[elementResponseAttributes]".lower():
                if caps[item] == "text":
                    has_text_added = True

            if has_compact_response_off and has_text_added:
                break

        if has_compact_response_off and has_text_added:
            print(f"{device_name}: Text caching is enabled")
            return True
        print(
            f"{device_name}: Text caching is NOT enabled: has_compact_response_off={has_compact_response_off}, has_text_added={has_text_added}"
        )
        return False
