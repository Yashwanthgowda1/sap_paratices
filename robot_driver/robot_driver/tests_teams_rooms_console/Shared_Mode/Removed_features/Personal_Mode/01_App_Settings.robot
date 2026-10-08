#*** Settings ***
#Documentation   Validating the functionality of Console App Settings feature.
#Force Tags    pm_app_settings   pm
#Library       DateTime
#Library      OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  10
#
#*** Test Cases ***
#TC1: [App settings] Touch Console user has the option to sign out
#     [Tags]   314737   P1   sanity_pm
#     [Setup]  Testcase Setup for User     count=1
#     Console sign out method   console=console_1
#     Verify signin is successful    console_list=console_1     state=Sign out
#     [Teardown]  Run Keywords   Capture Failure  AND  console sign in method    console=console_1    AND    Get device pairing code    device_list=device_1    console_list=console_1   user_list=user
#
#TC2: [App settings] User checks 'Report an issue' option in app settings
#     [Tags]     314741   bvt_pm     sanity_pm
#     [Setup]  Testcase Setup for User    count=1
#     Navigate to app settings screen page    console=console_1
#     Verify report an issue and validate    console=console_1
#     [Teardown]  Run Keywords   Capture Failure  AND    App Settings Teardown    console=console_1
#
#
#
#*** Keywords ***
#Navigate to app settings screen page
#    [Arguments]     ${console}
#    Tap on more option  ${console}
#    Tap on settings page   ${console}
#
#App Settings Teardown
#    [Arguments]     ${console}
#    Click on close button    console_list=${console}
#    Click on back layout btn   ${console}
#    Come back to home screen page   console_list=${console}
