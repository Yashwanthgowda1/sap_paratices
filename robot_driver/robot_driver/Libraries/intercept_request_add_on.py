#  Copyright © Microsoft Corporation. All rights reserved.
from enum import Enum

from mitmproxy import http, command


class InterceptResponseConfig(Enum):
    """
    Enum for defining different response configurations for intercepted requests.
    """

    NotInterceptedConfig = ([], 200, b"OK", {"Content-Type": "text/plain"})
    CreateMeetingFailedResponseConfig = (
        ["/calendarEvents", "/chatsvc"],
        500,
        b"Internal Server Error",
        {"Content-Type": "text/plain"},
    )

    def __init__(self, intercept_request_path, status_code, content, headers):
        self._value_ = intercept_request_path
        self.intercept_request_path = intercept_request_path
        self.status_code = status_code
        self.content = content
        self.headers = headers


class InterceptCommand(Enum):
    """
    Enum for defining different intercept commands.
    Instead of changing proxy configuration directly,
    the command is sent to the proxy server to change the configuration.
    """

    INTERCEPT_MEETING_FAILED = "intercept_meeting_failed"
    INTERCEPT_CLEAR = "intercept_clear"


class InterceptRequestAddOn:
    """
    Add-on for intercepting HTTP requests
    contains the config for different request path and respective response.
    Also, if request path matches the predefined commands, it will change the config accordingly.
    """

    # commandMap is used to map the command to switch the intercept config
    commandMap = {
        InterceptCommand.INTERCEPT_MEETING_FAILED.name: InterceptResponseConfig.CreateMeetingFailedResponseConfig,
        InterceptCommand.INTERCEPT_CLEAR.name: InterceptResponseConfig.NotInterceptedConfig,
    }

    config: InterceptResponseConfig = InterceptResponseConfig.NotInterceptedConfig

    def request(self, flow: http.HTTPFlow):
        # check if the request is the command to switch the intercept config
        for command_name, intercept_config in self.commandMap.items():
            if command_name in flow.request.path:
                self._setInterceptConfig(intercept_config)
                flow.response = http.Response.make(200, b"OK", {"Content-Type": "text/plain"})
                return
        # intercept the request if the config is set
        for intercept_request_path in self.config.intercept_request_path:
            if intercept_request_path in flow.request.path:
                flow.response = http.Response.make(
                    self.config.status_code,  # (optional) status code
                    self.config.content,  # (optional) content
                    self.config.headers,  # (optional) headers
                )

    def _setInterceptConfig(self, intercept_config: InterceptResponseConfig):
        self.config = intercept_config

    @command.command(InterceptCommand.INTERCEPT_MEETING_FAILED.value)
    def intercept_meeting(self) -> None:
        self._setInterceptConfig(InterceptResponseConfig.CreateMeetingFailedResponseConfig)

    @command.command(InterceptCommand.INTERCEPT_CLEAR.value)
    def clear_intercept(self) -> None:
        self._setInterceptConfig(InterceptResponseConfig.NotInterceptedConfig)


addons = [InterceptRequestAddOn()]
