*** Settings ***
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[DGJ]TC user should have option to enable Zoom meeting
    [Tags]    418922      P1     sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Enable third party meetings    console=console_1
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1     AND     Disable third party meetings    console=console_1

TC2:[DGJ] Zoom meeting should not have join button option when 3P meeting option disabled in Meetings
    [Tags]    445023      P1     sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Disable third party meetings    console=console_1
    verify join button behavior when third party toggle is disabled    device=console_1    meeting_name=zoom_meeting
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC3:[DGJ]TC not able to join meeting when Zoom meeting option disabled from Meeting option
    [Tags]    445024      P1     sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Disable third party meetings    console=console_1
    verify join button behavior when third party toggle is disabled    device=console_1    meeting_name=zoom_meeting
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1
*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable third party meetings
    [Arguments]    ${console}
    Navigate to app settings screen     console=${console}
    Navigate to meeting and calling options from device settings page       console=${console}  option=meeting
    Enable and disable third party meetings zoom toggle    device=${console}    state=on
    come back from admin settings page      device_list=${console}

Disable third party meetings
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}   option=meeting
    Enable and disable third party meetings zoom toggle     device=${console}       state=off
    come back from admin settings page      device_list=${console}
