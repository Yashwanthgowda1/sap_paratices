*** Settings ***
Library     DateTime
Resource    ../resources/keywords/common.robot

Suite Teardown      Run Keywords    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [Customer Love]Verify appbar title with DID assigned account.
    [Tags]     401775      P0     bvt_cap    sanity_cap
    [Setup]   Testcase Setup for CAP User    count=1
    verify app bar title with date time and DID number    device=device_1    other_user=device_1:cap_search_enabled
    [Teardown]  Capture on Failure

TC2 : [Customer Love] Verify appbar title when user navigates to other tabs and back to homescreen
    [Tags]   401783     P0     bvt_cap   sanity_cap
    [Setup]   Testcase Setup for CAP User    count=1
    open settings page  device=device_1
    Come back to home screen    device_list=device_1
    verify app bar title with date time and DID number     device=device_1    other_user=device_1:cap_search_enabled
    Navigate to device setting page     device=device_1
    device setting back  device=device_1
    click back      device=device_1
    verify app bar title with date time and DID number    device=device_1    other_user=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC3 : [Customer Love] Verify appbar title for Hot Desk user
    [Tags]    401778    P1   sanity_cap
    [Setup]   Testcase Setup for CAP User   count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode    device=device_1
    verify app bar title with date time and DID number    device=device_1       other_user=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1    AND   End hot desk    device=device_1

TC4 : [Customer Love] Verify appbar title when sign out and sign in with another user.
    [Tags]   401786     P2
    [Setup]   Testcase Setup for CAP User    count=2
    verify app bar title with date time and DID number    device=device_1       other_user=device_1:cap_search_enabled
    Signin with other user    device=device_1   other_user_account=device_2
    verify app bar title with date time and DID number    device=device_1       other_user=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC5 : [Customer Love]Verify appbar title when appearance is changed to Dark Theme
    [Tags]    401780     P2
    [Setup]  Testcase Setup for CAP User   count=1
    verify and enable dark theme     device=device_1
    device right corner click      device=device_1
    verify app bar title with date time and DID number    device=device_1     other_user=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1    AND    verify and disable dark theme     device_1

*** Keywords ***

Disable Hotline
       [Arguments]     ${device}
       disable hotline option from home screen      ${device}