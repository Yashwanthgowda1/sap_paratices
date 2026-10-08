*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Require ID and Passcode] Verify "Require passcode for all meetings " option & its default state under "Meetings."
    [Tags]    444233    sanity_tc_sm    bvt_tc_sm
    [Setup]     Testcase Setup for shared User   count=1
    Navigate to teams admin settings page   console=console_1
    Verify require passcode for all meetings option under the meetings   device=console_1
    come back from admin settings page      device_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC2:[Require ID and passcode] Verify DUT user should be able to enable/disable "Require passcode for all meetings " under meetings.
    [Tags]    444238    sanity_tc_sm    bvt_tc_sm
    [Setup]    Testcase Setup for shared User   count=1
    Navigate to teams admin settings page   console=console_1
    Enable the required passcode for all meetings option     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND   Disable the required passcode for all meetings option     console=console_1     AND     Come back to home screen page   console_list=console_1

TC3:[Require ID and passcode] Verify "Require passcode for all meetings" must reset when device sign-out
    [Tags]    444242    sanity_tc_sm    bvt_tc_sm
    [Setup]    Testcase Setup for shared User   count=1
    Navigate to teams admin settings page   console=console_1
    Enable the required passcode for all meetings option     console=console_1
    Console sign out method   console=console_1
    Sign out method    device=device_1
    Sign in method     device=device_1      user=meeting_user
    Console sign in method     console=console_1        user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Navigate to teams admin settings page   console=console_1
    Verify that require passcode for all meetings toggle should be disabled by default   device=console_1
    come back from admin settings page      device_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC4:[Require ID and Passcode] Verify the meeting when user disable the "Require passcode for all meetings" under "Meetings."
    [Tags]    444270    P2
    [Setup]    Testcase Setup for shared User   count=1
    Navigate to teams admin settings page   console=console_1
    Verify that require passcode for all meetings toggle should be disabled by default   device=console_1
    come back from admin settings page      device_list=console_1
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state       console_list=console_1
    End the meeting     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC5:[Require ID and Passcode] Verify "Require passcode for all meetings" under "Meetings."
    [Documentation]    Keep this basic license test case at the end of the suite. If you wish to add any additional test cases, please position them before this one.
    [Tags]    444260    P1    sanity_tc_sm
    [Setup]    Testcase console setup for basic user       count=1
    Navigate to app settings screen   console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1      option=meeting
    Verify pro tags under meetings     device=console_1    option=require_id_and_passcode
    come back from admin settings page      device_list=console_1

*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Navigate to teams admin settings page
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting

Enable the required passcode for all meetings option
    [Arguments]    ${console}
    Verify require passcode for all meetings option under the meetings   device=${console}
    Enable and disable require passcode for all meetings toggle     device=${console}    state=on
    come back from admin settings page      device_list=${console}

Disable the required passcode for all meetings option
    [Arguments]    ${console}
    navigate to teams admin settings page       ${console}
    Verify require passcode for all meetings option under the meetings   device=${console}
    Enable and disable require passcode for all meetings toggle     device=${console}    state=off
    come back from admin settings page      device_list=${console}

Console setup for basic user
    Sign Out Console
    Sign Out
    Sign In    user_list=basic_user,user,user
    Sign In Console    user_list=basic_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=basic_user

Testcase console setup for basic user
    [Arguments]    ${count}
    Console setup for basic user
    Testcase Setup for basic User   ${count}