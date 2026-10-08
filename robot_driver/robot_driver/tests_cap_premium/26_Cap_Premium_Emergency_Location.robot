*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Run Keywords    Suite Failure Capture

*** Variables ***

*** Test Cases ***

TC1: [Emergency Location] Verify "Emergency Location” section is available under Settings -> Calling tab
    [Tags]    382043     P0     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User      count=1
    verify emergency location option under callings settings    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2 : [Emergency Location] Verify “Emergency Location” is available under contacts card (user profile) screen.
    [Tags]   382044    P0     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User      count=1
    verify set your emergency location option under user profile    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
