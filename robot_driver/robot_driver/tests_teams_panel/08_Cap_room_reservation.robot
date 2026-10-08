*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Teams Shared Devices License] [Home screen] User to cancel the room reservation process
    [Tags]  342053   sanity     bvt_panels_pr
    [Setup]  Testcase Setup for CAP User for panel  count=1
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1:cap_user
    cancel room reservation  device=device_1
    validate room availability status   device=device_1   status=available
    [Teardown]  Capture on Failure

TC2:[Teams Shared Devices License] [Adhoc Reservation Confirmation Dialog] Verify that the Adhoc Reservation Confirmation Dialog disappears after 4 seconds and text Dialog is not cut off
    [Tags]  342055
    [Setup]  Testcase Setup for CAP User for panel  count=1
    verify room parameters    device=device_1:cap_user
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1:cap_user
    reserve room    device=device_1:cap_user
    validate room availability status   device=device_1   status=reserved
    [Teardown]  Run Keywords    Capture on Failure  AND   cancel the current reserved meeting   device=device_1

*** Keywords ***

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

cancel the current reserved meeting
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    Come back to home screen    device_list=device_1
    checkout of the reserved meeting   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available