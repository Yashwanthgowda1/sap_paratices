*** Settings ***
Documentation   validating scenario after reboot console
Resource    resources/keywords/common.robot

Suite Setup    Run Keywords    enable proximity join option     AND      reboot console
Suite Teardown    Run Keyword  Suite Failure Capture

*** Variables ***
${wait_time} =  15s
*** Test Cases ***
TC1:[Call] call option should not disappear after device reboot
    [Tags]    468359    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User    count=1
    verify home screen options   console=console_1
    [Teardown]   Capture on Failure

TC2:[Proximity join]Verify proximity join option after reboot in Touch console.
    [Tags]    315246    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    verify the status select proximity join toggle btn    device=console_1    status=on
    verify the status allow bluetooth beaconing toggle    device=console_1    status=on
    verify the status allow remote control from personal devices toggle    device=console_1    status=on
    come back from admin settings page      device_list=console_1
    [Teardown]   Run Keywords  Capture on Failure    AND    come back from admin settings page      device_list=console_1

*** Keywords ***
reboot console
    Reboot Norden Or Console        device=console_1
    Verify time display on home screen   console=console_1
    Wait for Some Time    time=${wait_time}

Navigate to app settings screen page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

enable proximity join option
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    verify proximity join meeting enabling and disabling state    console=console_1    state=on
    enable and disable allow bluetooth beaconing toggle    device=console_1    state=on
    enable and disable allow remote control from personal devices toggle    device=console_1    state=on
    come back from admin settings page      device_list=console_1
        