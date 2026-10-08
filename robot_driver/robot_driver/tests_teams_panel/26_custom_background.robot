*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Custom background] Background setting screen on Pro or TSD licensed
    [Tags]  465194
    [Setup]  Testcase Setup   count=1
    verify room parameters      device=device_1
    navigate to background option in panel app settings      device=device_1
    verify background page in teams admin settings in panel     device=device_1       status=custom
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2:[Custom background] Custom background enables automatically on Pro / TSD account after the config is pushed from TAC
    [Tags]  465196
    [Setup]  Testcase Setup   count=1
    verify room parameters      device=device_1
    navigate to background option in panel app settings      device=device_1
    verify background page in teams admin settings in panel     device=device_1       status=custom
    verify background wallpaper selected     device=device_1       status=custom
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3:[Custom background] Background setting screen on Legacy licenses such as Premium and Standard
    [Tags]  465195
    [Setup]  Testcase Setup for premium license User for panel  count=1
    verify room parameters      device=device_1:premium_user
    navigate to background option in panel app settings      device=device_1
    verify background page in teams admin settings in panel     device=device_1       status=default
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***

navigate to background option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel      device=${device}
    verify device settings option in panel      device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    navigate to background tab in panel     device=${device}