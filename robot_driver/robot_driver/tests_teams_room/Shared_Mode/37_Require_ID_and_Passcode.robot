*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Require ID and Passcode]Verify "Require passcode for all meetings " option & its default state under "Meetings"
    [Tags]       444349   sanity_sm    bvt_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    navigate to teams admin settings page   device=device_1
    Verify require passcode for all meetings option under the meetings    device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND     Come back to home screen     device_list=device_1

TC2:[Require ID and passcode]Verify "Require passcode for all meetings" must reset when device sign-out
    [Tags]     444358    sanity_sm    bvt_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    navigate to teams admin settings page   device=device_1
    Verify require passcode for all meetings option under the meetings      device=device_1
    Enable and disable Require passcode for all meetings toggle     device=device_1     state=on
    Come back from admin settings page     device_list=device_1
    sign out method  device=device_1
    Sign in method     device=device_1     user=meeting_user
    navigate to teams admin settings page   device=device_1
    verify that Require passcode for all meetings toggle should be disabled by default      device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1

TC3:[Require ID and passcode]Verify "Require passcode for all meetings " is default off with toggle button under "Meetings"
     [Tags]      444266     P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    navigate to teams admin settings page   device=device_1
    Verify require passcode for all meetings option under the meetings    device=device_1
    verify that Require passcode for all meetings toggle should be disabled by default      device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND     Come back to home screen     device_list=device_1

TC4:[Require ID and Passcode]Verify options available under Join by ID screen in a meeting when user enables " Require passcode for all meetings" under "Meetings"
    [Tags]     444338   P1        sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    navigate to teams admin settings page   device=device_1
    Verify require passcode for all meetings option under the meetings      device=device_1
    Enable and disable Require passcode for all meetings toggle     device=device_1     state=on
    Come back from admin settings page     device_list=device_1
    verify join with an meeting id options   device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1


*** Keywords ***

Navigate back from the device settings page
    [Arguments]     ${device}
    Click close btn    device_list=${device}
    device setting back     ${device}
    device setting back     ${device}
    Click close btn    device_list=${device}


Verify Require passcode for all meetings under "Meetings"
    [Arguments]     ${device}
    Verify require passcode for all meetings option under the meetings      ${device}


disable the require passcode meeting toggle
    [Arguments]     ${device}
    navigate to teams admin settings page   ${device}
    Verify require passcode for all meetings option under the meetings      ${device}
    Enable and disable Require passcode for all meetings toggle     ${device}       state=off
    Come back from admin settings page     device_list=${device}



