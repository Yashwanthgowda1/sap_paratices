*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s


*** Test Cases ***
TC1 : [Appearance] Dark appearance setting should reset to light theme when user signs out
    [Tags]  309066   bvt_tp  sanity_tp      alt_credentials      bvt_pr
    [Setup]  Testcase Setup    count=1
    verify and enable dark theme     device=device_1
    Sign out method    device=device_1
    Sign in method     device=device_1
    Verify dark theme status     device=device_1    status=OFF
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    verify and disable dark theme     device=device_1

TC2 : Verify that Dark theme is accepted by Home screen
    [Tags]    320297
    [Setup]  Testcase Setup    count=1
    verify home screen tiles     device=device_1
    verify home screen date and time for cnf device     device=device_1
    verify and enable dark theme     device=device_1
    Verify dark theme status     device=device_1    status=ON
    [Teardown]   Run Keywords    Capture on Failure    AND    verify and disable dark theme     device=device_1    AND    Come back to home screen    device_list=device_1

*** Keywords ***
Back Button Once
    [Arguments]     ${device}
    run keyword if test passed      Click Back Btn      ${device}