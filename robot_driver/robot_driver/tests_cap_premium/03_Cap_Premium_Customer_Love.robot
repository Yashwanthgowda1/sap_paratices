*** Settings ***
Resource    ../resources/keywords/common.robot



Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Customer Love] [Cap Premium] Verify appbar title with DID assigned account.
    [Tags]     401645       BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=1
    verify app bar title with date time and DID number    device=device_1    other_user=device_1:cap_search_enabled
    [Teardown]  Capture on Failure

TC2 : [Customer Love] [Cap Premium] Verify appbar title for Hot Desk user
    [Tags]    401648     P1      Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User   count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode    device=device_1
    verify app bar title with date time and DID number    device=device_1       other_user=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1    AND   End hot desk    device=device_1

TC3 : [Customer Love] [Cap Premium] Verify appbar title when user navigates to other tabs and back to homescreen
    [Tags]    401771     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=1
    verify home screen app bar user navigates back from other tabs   device=device_1:cap_search_enabled
    open settings page  device=device_1
    Come back to home screen    device_list=device_1
    verify app bar title with date time and DID number     device=device_1    other_user=device_1:cap_search_enabled
    Navigate to device setting page     device=device_1
    device setting back  device=device_1
    click back      device=device_1
    verify app bar title with date time and DID number    device=device_1    other_user=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC4 : [Customer Love] [Cap Premium] Verify appbar title when sign out and sign in with another user.
    [Tags]   401774     P2
    [Setup]   Testcase Setup for CAP Premium User    count=2
    verify app bar title with date time and DID number    device=device_1       other_user=device_1:cap_search_enabled
    Signin with other user    device=device_1   other_user_account=device_2
    verify app bar title with date time and DID number    device=device_1       other_user=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1