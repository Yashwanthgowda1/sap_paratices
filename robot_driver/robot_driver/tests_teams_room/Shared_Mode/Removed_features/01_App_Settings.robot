#*** Settings ***
#Library     DateTime
#Library     OperatingSystem
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC7:[App Settings] Teams app user to see and define Privacy and cookies
#    [Tags]    312855    P2
#    [Setup]  Testcase Setup for Meeting User   count=1
#    Navigate to about page     device=device_1
#    verify privacy cookies     device=device_1
#    Click close btn    device_list=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
#
#TC5:[App Settings] Teams App User to see the terms of use
#    [Tags]  312850  P2
#    [Setup]  Testcase Setup for Meeting User   count=1
#    Navigate to about page   device=device_1
#    verify microsoft software license terms  device=device_1
#    Click back btn    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    App Setting Teardown   device=device_1
#
#TC6:[App Settings] Teams App User to view the third-party Notices of use
#    [Tags]  312849  P2
#    [Setup]  Testcase Setup for Meeting User   count=1
#    Navigate to about page   device=device_1
#    verify third party software and information     device=device_1
#    Click close btn    device_list=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

#*** Keywords ***
