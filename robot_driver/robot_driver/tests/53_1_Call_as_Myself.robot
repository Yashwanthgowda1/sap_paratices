*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 set dialpad option

Suite Setup    Call as my self Setup
Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  10



*** Test Cases ***
TC 1:[Call as Myself] Verify that if the DUT user doesn't have any boss (Delegator), only Call button should be display under the Dialpad.
    [Tags]     452741
    [Setup]  Testcase Setup  count=1
    click on calls tab     device=device_1
    verify call as myself drop down button is not available when user does not have any boss      device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC 2:[Call as Myself] Verify that if a boss (delegator) removes the DUT user from the delegation, under drop down Boss username should be removed in Calls tab.
    [Tags]     452764   P1
    [Setup]  Testcase Setup  count=3
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1
    Come back to home screen     device_list=device_1
    click on calls tab     device=device_1
    refresh calls main tab in dail pad view   device=device_1
    verify option in call as myself drop down button      device=device_1       to_device=device_3
    click on home bar icon        device=device_1
    Delete delegate from manage delegate   from_device=device_3    to_device=device_1
    Wait for Some Time    time=${wait_time}
    click on calls tab     device=device_1
    refresh calls main tab in dail pad view   device=device_1
    verify call as myself drop down button is not available when user does not have any boss      device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_3


*** Keywords ***
Call as my self Setup
    verify and set dialpad option for portrait device    device=device_1

