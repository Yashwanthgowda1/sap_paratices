*** Settings ***
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[DGJ][Chromium support] DUT user to check web view/Chromium support version
    [Tags]    345679    P1    
    verify web view chromium support_version    device=console_1
    [Teardown]  Come back to home screen page   console_list=console_1

TC2:[DGJ]TC user should have option to enable Webex meeting
    [Tags]    444952    P1    sanity_tc_sm
    [Setup]    Testcase Setup for shared User      count=1
    Enable third party webex meetings    console=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC3:[DGJ]Device should not highlight Webex Meeting when Webex meeting option is disabled in Meetings
    [Tags]    419620    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Disable third party webex meetings    console=console_1
    verify webex icon on calendar tab      device=console_1
    verify join button behavior when third party toggle is disabled    device=console_1    meeting_name=webex_meeting
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC4:[DGJ]TC User not able to join meeting when Webex meeting option disabled from Meeting option
    [Tags]    419622    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Disable third party webex meetings    console=console_1
    verify webex icon on calendar tab      device=console_1
    verify join button behavior when third party toggle is disabled    device=console_1    meeting_name=webex_meeting
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1
*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable third party webex meetings
    [Arguments]    ${console}
    Navigate to app settings screen     console=${console}
    Navigate to meeting and calling options from device settings page       console=${console}  option=meeting
    enable and disable third party meetings webex toggle    device=${console}    state=on
    come back from admin settings page      device_list=${console}

Disable third party webex meetings
    [Arguments]    ${console}
    Navigate to app settings screen     console=${console}
    Navigate to meeting and calling options from device settings page       console=${console}  option=meeting
    enable and disable third party meetings webex toggle    device=${console}    state=off
    come back from admin settings page      device_list=${console}