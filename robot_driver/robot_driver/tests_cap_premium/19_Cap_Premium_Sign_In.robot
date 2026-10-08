*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Sign-in][Public]User to sign-in using Teams License Account.
    [Tags]  348206     P2    auth_cappremium
    [Setup]  Testcase Setup for CAP Premium User     count=1
    Sign out method      device=device_1
    verify settings from signin page   device=device_1
    verify cloud option for provisioning device   device=device_1
    sign in method     device=device_1    user=cap_search_enabled
    [Teardown]  Run Keywords    Capture on Failure

TC2 : [Sign-in] [Public][Hot desk] User to sign-in with Hot desk user for Teams License Account
    [Tags]  348205     P2    auth_cappremium
    [Setup]   Testcase Setup for CAP Premium User     count=1
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1  AND   End hot desk    device=device_1

TC3 : Verify DUT user sign out from the current account
    [Tags]   416792    P2    auth_cappremium
    [Setup]  Testcase Setup for CAP Premium User     count=1
    Sign out method      device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     sign in method     device=device_1    user=cap_search_enabled

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1