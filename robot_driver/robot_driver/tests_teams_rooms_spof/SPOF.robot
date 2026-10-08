*** Settings ***
Resource    ../resources/keywords/common.robot
Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time}    1
*** Test Cases ***

TC1: Verify meet now failed to join when meeting intercept is on
    [Tags]    001       bvt_spof
    [Setup]   Testcase Setup for Meeting User     count=1
    Change proxy create meeting failed
    Wait for Some Time    ${wait_time}
    Verify can not join meet now    device=device_1
    Change proxy clear
    Wait for Some Time    ${wait_time}
    Verify can join meet now    device=device_1
    [Teardown]   Capture on Failure

TC2: Verify user cannot see chat when meeting intercept is on
    [Tags]    002    bvt_spof
    [Setup]   Testcase Setup for Meeting User    count=1
    Change proxy create meeting failed
    Wait for Some Time    ${wait_time}
    Join meeting    device=device_1    meeting=spof_room_meeting
    Wait for Some Time    ${wait_time}
    Verify layout options    device=device_1    participants=False
    Enable and disable the chat toggle in meeting    device=device_1    state=on
    verify the chat options in meeting       device=device_1
    End meeting    device=device_1
    Change proxy clear
    [Teardown]    Capture on Failure


*** Keywords ***
Verify can not join meet now
    [Arguments]    ${device}
    Click on meet now button only    ${device}
    Verify can not create meet now    ${device}


Verify can join meet now
    [Arguments]    ${device}
    Click on meet now button only   ${device}
    Dismiss invite people to join you    device_name=${device}
    Verify meeting state   device_list=${device}    state=Connected
    Disconnect call   device=${device}
