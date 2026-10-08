*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup     Reboot Device

*** Variables ***

*** Test Cases ***
TC1:[Landing Page] DUT user reboot DUT
    [Tags]     238023      P2
    Verify home page screen    device=device_1
    [Teardown]   Capture on Failure

TC2:[Meet] Meet option should not disappear after device reboot
    [Tags]     259710      P2
    tap on meet now and validate    device=device_1
    [Teardown]   Capture on Failure

TC3:[Call] call option should not disappear after device reboot
    [Tags]     444822      P2
    verify call option should not disappear after device reboot    device=device_1
    [Teardown]   Capture on Failure

TC4:[Require ID and passcode] Verify "Require passcode for all meetings" option & its status must persists after device reboots
    [Tags]    444356     P2
    [Setup]     Testcase Setup for Meeting User     count=1
    navigate to teams admin settings page   device=device_1
    Verify require passcode for all meetings option under the meetings    device=device_1
    verify that Require passcode for all meetings toggle should be disabled by default      device=device_1
    Come back from admin settings page     device_list=device_1
    Reboot Device
    enable and disable Require passcode toggle    device=device_1     state=on
    Come back from admin settings page     device_list=device_1
    Reboot Device
    navigate to teams admin settings page   device=device_1
    Verify require passcode for all meetings option under the meetings    device=device_1
    verify that require passcode for all meetings toggle should be enabled      device=device_1     state=on
    Come back from admin settings page     device_list=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND     Come back to home screen     device_list=device_1

*** Keywords ***
Reboot Device
    Testcase Setup for Meeting User     count=1
    Verify home page screen    device=device_1
    Reboot Norden Or Console     device=device_1
    Wait For Some Time    ${wait_time}
    Testcase Setup for Meeting User     count=1

verify call option should not disappear after device reboot
    [Arguments]     ${device}
    Verify home page screen    ${device}

enable and disable Require passcode toggle
    [Arguments]     ${device}       ${state}
    navigate to teams admin settings page   ${device}
    Verify require passcode for all meetings option under the meetings      ${device}
    enable and disable Require passcode for all meetings toggle      ${device}    ${state}
    Come back from admin settings page      device_list=${device}