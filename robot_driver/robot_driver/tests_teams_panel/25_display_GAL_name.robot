*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Display GAL Name] Verify Device Name Setting Section
    [Tags]    478351
    [Setup]  Testcase Setup for custom name user for panel    count=1
    verify room parameters       device=device_1:customname_user
    navigate to device settings options inside panel admin settings      device=device_1
    verify device name setting section    device=device_1    presence_status=present
    [Teardown]  Run Keywords    Capture on Failure  AND     go back to homescreen from admin settings options       device=device_1

TC2:[Display GAL Name] Verify Device Name Setting Section Should not visible
    [Tags]    478352
    [Setup]  Testcase Setup for premium license User for panel    count=1
    verify room parameters      device=device_1:premium_user
    navigate to device settings options inside panel admin settings      device=device_1
    verify device name setting section    device=device_1    presence_status=absent
    [Teardown]  Run Keywords    Capture on Failure  AND     go back to homescreen from admin settings options       device=device_1

TC3:[Display GAL Name] Set Nick Name /Custom Name Using PMP and Verify on Panel
    [Tags]    478353
    [Setup]  Testcase Setup for custom name user for panel    count=1
    verify room parameters       device=device_1:customname_user
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    reboot panel      device=device_1
    Testcase Setup for custom name User for panel    count=1
    verify room parameters       device=device_1:customname_user
    navigate to device settings options inside panel admin settings      device=device_1
    verify custom display name in teams admin setting    device=device_1:customname_user
    [Teardown]  Run Keywords    Capture on Failure  AND     go back to homescreen from admin settings options       device=device_1

*** Keywords ***

navigate to device settings options inside panel admin settings
    [Arguments]    ${device}
    Navigation to settings page in panel      device=${device}
    verify device settings option in panel      device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    navigate to device settings tab in admin setting     device=${device}


     
        