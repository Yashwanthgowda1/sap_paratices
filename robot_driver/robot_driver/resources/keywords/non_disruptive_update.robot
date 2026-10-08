*** Settings ***
Library     non_disruptive_update


*** Variables ***
${timespan_requested_in_minutes} =  30
${command_type} =  "SoftwareUpdate"

*** Keywords ***
Send Software Update intent
    [Arguments]     ${device}
    Broadcast Disruptive Command Intent    device=${device}    command_type=${command_type}    timespan_requested_in_minutes=${timespan_requested_in_minutes}

Postpone the request
    [Arguments]     ${device}
    Click On Postpone Button    ${device}
    Verify Postpone Pattern In Logcat Logs    ${device}

Dismiss the request
    [Arguments]     ${device}
    Click On Dismiss Button    ${device}
    Verify Dismiss Pattern In Logcat Logs    ${device}

Verify auto dismiss pattern
    [Arguments]     ${device}
    Verify Dismiss Pattern In Logcat Logs    ${device}