*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Panel][Device Restart] Verify Device Restart Settings
    [Tags]  465186
    [Setup]  Testcase Setup   count=1
    verify room parameters      device=device_1
    navigate to meetings option in panel app settings       device=device_1
    navigate and verify device restrat page in teams admin settings in panel      device_1
    go back to homescreen from admin settings options   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2:[Panel][Device Restart] Enable / Disable Restart Setting
    [Tags]  465187
    [Setup]  Testcase Setup   count=1
    verify room parameters      device=device_1
    navigate to meetings option in panel app settings       device=device_1
    navigate and verify device restrat page in teams admin settings in panel      device_1
    verify maintenance toggle button is on by default     device=device_1
    enable or disable and verify maintenance toggle button in panel        device=device_1      state=off
    enable or disable and verify maintenance toggle button in panel        device=device_1      state=on
    go back to homescreen from admin settings options   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***
navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1