*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Admin Settings] DUT user verify Protected apps are available under Admin settings for Shared account
    [Tags]    322324    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=settings_page
    verify protected apps are available under admin settings       device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC2:[Admin Settings] User to check for pairing in Teams admin settings.
    [Tags]    410122    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=devices
    Verify the options inside the devices       device=console_1
    Verify the options inside the console pairing   device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

verify admin sign-out option behind admin settings
    [Arguments]       ${console}
    verify protected apps are available under admin settings    device=${console}

