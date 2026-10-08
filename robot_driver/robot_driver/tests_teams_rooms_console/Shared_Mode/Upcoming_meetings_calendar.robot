*** Settings ***
Documentation       Should not create any meeting device_1:user
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[MTRA+TC] Verify that new calendar UI visible.
    [Documentation]     should not create any meeting for device_1:user
    [Tags]    444609    P2
    [Setup]  Testcase Setup for User    count=1
    Verify available all day visible in calendar ui     device=console_1
    [Teardown]  Capture Failure

TC2:[MTRA] Verify Focus tile in available state.
    [Documentation]     should not create any meeting for device_1:user
    [Tags]    444792    P2
    [Setup]  Testcase Setup for User    count=1
    Verify the available focus tile bar     device=console_1
    Verify available all day visible in calendar ui     device=console_1
    [Teardown]  Capture Failure

TC3:[MTRA] Verify Focus tile when there is Room availability on the current day/Next day in Ambient screen.
    [Documentation]     should not create any meeting for device_1:user
    [Tags]    468383      P3
    [Setup]  Testcase Setup for User    count=1
    Verify available all day visible in calendar ui     device=console_1
    [Teardown]  Capture Failure

TC4:[Home screen] No upcoming meetings on Touch Console
    [Documentation]     should not create any meeting for device_1:user
    [Tags]     314968     P2    sanity_tc_sm
    [Setup]  Testcase Setup for User    count=1
    Verify the available focus tile bar     device=console_1
    Verify available all day visible in calendar ui     device=console_1
    Verify date and time with user details on home screen       console=console_1
    [Teardown]  Capture Failure

*** Keywords ***
