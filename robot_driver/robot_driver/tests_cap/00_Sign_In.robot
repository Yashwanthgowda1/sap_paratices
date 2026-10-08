*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [Sign-in] Sign-out from the DUT
    [Tags]  148671    P1    bvt_cap  sanity_cap        Certification_cap    auth_cap    auth_cap_p0
    [Setup]  Testcase Setup for CAP User    count=1
    Sign out method    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     sign in method     device=device_1    user=cap_search_enabled

TC2 : [Sign-in] User with Intune license can sign in to DUT
    [Tags]  149357    P1    bvt_cap  sanity_cap        Certification_cap    auth_cap    auth_cap_p0
    [Setup]  Testcase Setup for CAP User    count=1
    Log     This message is displayed if user is signed-in
    [Teardown]  Capture on Failure

TC3 : [Sign in] UI verification after sign in
    [Documentation]  Verify that dail pad on screen, retrive parking call icon and search icon tabs are on the teams app UI.
    [Tags]  150054    P1        Certification_cap    auth_cap    sanity_cap    bvt_cap
    [Setup]  Testcase Setup for CAP User    count=1
    Verify that sign in is successful  device_list=device_1  state=sign in
    Verify user have dial pad on screen     device_list=device_1
    Verify teams app have call park capability   device_list=device_1
    Verify home screen time dates   device=device_1     device_type=cap_home_screen_enabled
    [Teardown]  Capture on Failure

TC4 : [Sign-in] Sign-in to DUT with wrong Password
    [Tags]  148762    P2    auth_cap
    [Setup]   Run Keywords    Testcase Setup for CAP User    count=1    AND   sign out method     device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1   user=cap_search_enabled

TC5 : [Sign in] DID of the user should be displayed on the home screen
    [Tags]  150013    P2     bvt_cap     sanity_cap    auth_cap    auth_cap_p0
    [Setup]  Testcase Setup for CAP User    count=1
    Verify user DID num on home screen    device=device_1:cap_search_enabled
    [Teardown]  Capture on Failure

TC6 : [Sign-in] Sign-in to Teams App with invalid user
    [Tags]  148734    P3    auth_cap
    [Setup]   Run Keywords    Testcase Setup for CAP User    count=1    AND   sign out method     device=device_1
    Verify signin with invalid user     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1    user=cap_search_enabled

TC7 : [Sign-in] Sign-in attempt in DUT with invalid domain name
    [Tags]  149018    P3    auth_cap
    [Setup]   Run Keywords    Testcase Setup for CAP User    count=1    AND   sign out method     device=device_1
    Verify signin with invalid domain     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1    user=cap_search_enabled

TC8 : [Sign-in] User to re-sign-in multiple times to with same user
    [Tags]   339835     P2    auth_cap
    [Setup]  Testcase Setup for CAP User     count=1
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    Sign in method      device=device_1      user=cap_search_enabled
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    Sign in method      device=device_1      user=cap_search_enabled
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    Sign in method      device=device_1      user=cap_search_enabled
    [Teardown]   Capture on Failure

TC9 : [Sign-in] User to sign-out from existing account and sign-in with a different account
    [Tags]  313990     bvt_cap   sanity_cap    auth_cap    auth_cap_p0
    [Setup]  Testcase Setup for CAP User    count=1
    verify that sign in is successful     device_list=device_1       state=sign in
    Sign out method    device=device_1
    Sign in method      device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND   Sign out method    device=device_1

TC10 : [Sign-in] User to be signed in to DUT within a specified time limit
    [Tags]  435767   sanity_cap
    [Setup]  Testcase Setup for CAP User    count=1
    Navigate to people tab    device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
