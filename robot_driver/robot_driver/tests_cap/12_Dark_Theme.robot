*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [Dark Theme] User can Appearance on the device
    [Tags]  150034    P1    bvt_cap  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=1
    Verify and enable dark theme     device=device_1
    device right corner click      device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    verify and disable dark theme     device_1

TC2 : [Dark Theme] user can change dark appearance to light on the device
    [Tags]  150035    P2
    [Setup]   Run Keywords   Testcase Setup for CAP User    count=1   AND    verify and enable dark theme     device_1
    device right corner click      device=device_1
    Verify and disable dark theme     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [Dark Theme] Dark appearance setting should reset to light theme when user signs out
    [Tags]  150037   P1    bvt_cap   sanity_cap
    [Setup]  Testcase Setup for CAP User    count=1
    Verify and enable dark theme     device=device_1
    device right corner click      device=device_1
    Sign out method    device=device_1
    Sign in method     device=device_1     user=cap_search_enabled
    Verify dark theme status     device_1    status=OFF
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***
