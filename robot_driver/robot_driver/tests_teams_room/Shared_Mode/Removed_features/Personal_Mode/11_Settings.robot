#*** Settings ***
#Documentation   Settings
#Force Tags    pm_settings      pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  10
#
#*** Test Cases ***
#TC1: [Settings] Calling settings options supported for Normal account
#    [Tags]   222010   sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Navigate to app settings page    device=device_1
#    Verify calling settings options   device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND    Test Case Teardown   device=device_1
#
#
#
#
#
#
#*** Keywords ***
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#
#
#Test Case Teardown
#    [Arguments]     ${device}
#    Click back btn   ${device}
#    Click close btn    device_list=${device}
#    Come back to home screen    device_list=${device}