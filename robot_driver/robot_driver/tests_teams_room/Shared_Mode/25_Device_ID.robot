*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Device ID] Verify device ID and hardware id before and after signing in
     [Tags]     334254      P1       sanity_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    verify option in dfc settings screen and about option should not present    device=device_1
    Sign in method     device=device_1     user=meeting_user
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Navigate to about page  device=device_1
    verify device id and hardware id   device=device_1
    Click close btn    device_list=device_1
    device setting back  device=device_1
    device setting back  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC2:[Device ID] Verify device ID and hardware id after re-sign in
    [Tags]      334255     bvt_sm   sanity_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    Verify home page screen   device=device_1
    Navigate to about page  device=device_1
    ${device_id_number_before_signin_the_device} =  get device id number   device=device_1
    ${device_hardware_id_number_before_signin_the_device} =  get hardware id   device=device_1
    come back from admin settings page  device_list=device_1
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device=device_1     user=meeting_user
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Navigate to about page  device=device_1
    ${device_id_number_after_resignin_the_device} =  get device id number   device=device_1
    ${device_hardware_id_number_after_signin_the_device} =  get hardware id   device=device_1
    verify version number after resign on device   device_1    ${device_id_number_before_signin_the_device}    ${device_id_number_after_resignin_the_device}
    verify version number after resign on device    device_1     ${device_hardware_id_number_before_signin_the_device}    ${device_hardware_id_number_after_signin_the_device}
    come back from admin settings page  device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1
*** Keywords ***
verify device id and hardware id
    [Arguments]    ${device}
     get device id number   ${device}
     get hardware id    ${device}

