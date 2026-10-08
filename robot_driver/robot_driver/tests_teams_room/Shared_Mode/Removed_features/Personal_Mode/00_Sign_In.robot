#*** Settings ***
#Documentation   Sign in
#Force Tags    pm_signin    00   pm
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =      10s
#
#*** Test Cases ***
#TC1: [Sign-in] User to sign-in with username and password
#    [Tags]  125314   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    [Teardown]  Capture on Failure
#
#TC2: [Sign-in] Sign-out from the DUT
#    [Tags]  126760   bvt   bvt_pm    sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Sign out method    device=device_1
#    [Teardown]  Run Keywords   Capture on Failure  AND   Sign in method     device=device_1
#
#TC3: [Sign-in] User to re-sign-in multiple times to with same user
#    [Tags]  207465  P2
#    [Setup]  Testcase Setup     count=1
#    Sign out method    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Sign in method     device=device_1
#    Sign out method    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Sign in method     device=device_1
#    Sign out method    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Sign in method     device=device_1
#    [Teardown]   Capture on Failure
#
#TC4: [Sign-in] User to sign-out from existing account and sign-in with a different account
#    [Tags]  207454   P2
#    [Setup]   Testcase Setup   count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    Verify home page screen   device=device_1
#    Sign out method    device=device_1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign out
#    Sign in method     device=device_1     user=meeting_user
#    Sign out method    device=device_1
#    [Teardown]  Run Keywords   Capture on Failure  AND   Sign in method     device=device_1
#
#TC5: [Sign-in] User to be signed in on the DUT within a specified time limit
#    [Tags]  207455   P2
#    [Setup]    Testcase Setup    count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    Navigate to app settings page    device=device_1
#    [Teardown]  Run Keywords  Capture on Failure   AND   Sign in Teardown  device=device_1
#
#TC6: [Sign in] DID of the user should be displayed on the Homescreen
#    [Tags]  304947   sanity_pm   P1
#    [Setup]  Testcase Setup  count=1
#    verify did displayed on homescreen and on dialpad    device=device_1
#    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC7: [Sign in] Date and time should be available on sign in screen
#    [Tags]  304950   P2
#    [Setup]  Testcase Setup  count=1
#    verify current time display on home screen   device=device_1
#    [Teardown]   Capture on Failure
#
#TC8: [Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user
#    [Tags]  304937  P2
#    [Setup]  run keywords   Testcase Setup    count=2   AND    Signin with other user    device=device_2   other_user_account=device_1
#    Validate that signin is successfully completed    device_list=device_2     state=Sign in
#    validate rooms ui after signin   device=device_1
#    sign out method  device=device_1
#    Sign in method     device=device_1     user=meeting_user
#    [Teardown]  Run Keywords   Capture on Failure    AND   Sign in Teardown  device=device_1,device_2
#
#TC9: [Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user and TDC sign-outs after receiving call in DUT
#    [Tags]  304938  P3
#    [Setup]  run keywords   Testcase Setup   count=3   AND    Signin with other user    device=device_2   other_user_account=device_1
#    Validate that signin is successfully completed    device_list=device_2     state=Sign in
#    validate rooms ui after signin   device=device_1
#    Make outgoing call with phonenumber    from_device=device_3     to_device=device_1
#    Accept incoming call  device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Sign out method    device=device_2
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure    AND   Sign in Teardown  device=device_1,device_2,device_3
#
#*** Keywords ***
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#
#Sign in Teardown
#    [Arguments]     ${device}
#    Click close btn    device_list=${device}
#    Come back to home screen    device_list=${device}