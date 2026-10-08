#*** Settings ***
#Documentation   Validating the functionality of console sigin/signout feature.
#Force Tags    pm_signin   pm
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =      10s
#${wait_for_time} =      5s
#
#*** Test Cases ***
#TC1: [Sign-in] User to sign-in with username and password
#    [Tags]   314600   bvt_pm        sanity_pm
#    [Setup]  Testcase Setup for User     count=1
#    Verify signin is successful    console_list=console_1     state=Sign in
#    [Teardown]   Capture Failure
#
#TC2: [Sign-in] Sign-out from the Device
#     [Tags]   314703   bvt_pm   sanity_pm
#     [Setup]  Testcase Setup for User     count=1
#     Console sign out method   console=console_1
#     [Teardown]  Run Keywords   Capture Failure    AND   console sign in method    console=console_1  AND  Get device pairing code    device_list=device_1    console_list=console_1   user_list=user
#
#TC3: [Sign-in] User to sign-out from existing account and sign-in with a different account
#     [Tags]   314833   bvt_pm       sanity_pm
#     [Setup]  Testcase Setup for User   count=1
#     Verify signin is successful   console_list=console_1     state=Sign in
#     Console sign out method   console=console_1
#     Verify signin is successful    console_list=console_1     state=Sign out
#     Verify home page screen   device=device_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1     user=meeting_user
#     Console sign in method     console=console_1    user=meeting_user
#     Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
#     Verify signin is successful    console_list=console_1     state=Sign in
#     Wait for Some Time    time=${wait_for_time}
#     Console sign out method   console=console_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1
#     [Teardown]  Run Keywords   Capture Failure  AND  console sign in method    console=console_1   AND   Get device pairing code    device_list=device_1    console_list=console_1   user_list=user
#
#TC:4 [Sign-in] User to re-sign-in multiple times to with same user
#     [Tags]   314847   P2
#     [Setup]  Testcase Setup for User      count=1
#     Console sign out method   console=console_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1
#     Console sign in method    console=console_1
#     Get device pairing code    device_list=device_1    console_list=console_1   user_list=user
#     Wait for Some Time    time=${wait_for_time}
#     Console sign out method   console=console_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1
#     Console sign in method     console=console_1
#     Get device pairing code    device_list=device_1    console_list=console_1   user_list=user
#     Wait for Some Time    time=${wait_for_time}
#     Console sign out method   console=console_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1
#     [Teardown]  Run Keywords   Capture Failure  AND   console sign in method    console=console_1  AND   Get device pairing code   device_list=device_1    console_list=console_1   user_list=user
#
#
#*** Keywords ***