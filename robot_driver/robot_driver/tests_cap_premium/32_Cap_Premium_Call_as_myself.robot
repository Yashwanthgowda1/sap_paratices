*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup    Call as my self Setup
Suite Teardown     Run Keywords     Suite Failure Capture     AND        Call as my self Teardown


*** Test Cases ***
TC 1:[Call as Myself] Verify that if the DUT user has boss, Call as Myself with a dropdown icon should be display under Dialpad.
    [Tags]     452744       P0      Sanity_CAPPremium      BVT_CAPPremium     phonesCY23_4
    [Setup]    Testcase Setup for CAP Premium User   count=2
    click on calls tab     device=device_1
    verify call as myself drop down button      device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND        Come back to home screen     device_list=device_1,device_2


*** Keywords ***
Call as my self Setup
    Testcase Setup for CAP Premium User   count=3
    Add new delegates with Make call permission and validate   from_device=device_3    to_device=device_1:cap_search_enabled
    Add new delegates with Make call permission and validate   from_device=device_2    to_device=device_1:cap_search_enabled
    verify and set dialpad option for portrait device    device=device_1

Call as my self Teardown
    Delete delegate from manage delegate   from_device=device_3    to_device=device_1:cap_search_enabled
    Delete delegate from manage delegate   from_device=device_2    to_device=device_1:cap_search_enabled


