*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1: Verify that VQE(Voice quality recording) option available under the calling settings
    [Tags]     348041    P2
    [Setup]  Testcase Setup for CAP Premium User      count=1
    verify voice quality recording option under callings settings    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2: (VQE)Enable voice quality recording option under the calling settings.
    [Tags]    348042    P0        BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User      count=1
    verify voice quality recording option under callings settings   device=device_1
    enable or disable Voice quality recording option  device=device_1       desired_state=on
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
