*** Settings ***
Documentation       Should not create any meeting device_1:user
Resource    ../../resources/keywords/common.robot

*** Variables ***
${5_minutes_wait_time} =  5 minutes
${15_minutes_wait_time} =  15 minutes

*** Test Cases ***
TC1:[Sign-in]User to sign-in from another device(web-sign-in)
    [Tags]    314722     bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User       count=1
    Console sign out method   console=console_1
    signin method with dcf code    device=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    Verify presence of Intents        device=console_1         feature=keycode         state=absent
   [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1

TC2:[Auth] Verify Web sign-in with new DCF code after code expiration of existing DCF code.
    [Tags]   435964      bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User       count=1
    Console sign out method   console=console_1
    ${old_dfc_code}=     fetch dfc code      device=console_1
    Wait for Some Time    time=${5_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=console_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}   device=console_1    status=different
    signin method with dcf code    device=console_1     user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    [Teardown]  Capture on Failure

TC3:[Auth] Verify sign in functionality with expired DCF code & new DCF code after signing-out from account.
    [Tags]    435965     P1    bvt_tc_sm     sanity_tc_sm
    [Setup]    Testcase Setup for Meeting User     count=1
    Console sign out method   console=console_1
    ${old_dfc_code}=     fetch dfc code      device=console_1
    Wait for Some Time    time=${15_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=console_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}   device=console_1    status=different
    signin method with dcf code    device=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    sign in by invalid dcf code    device=device_1    invalid_dcf_code=${old_dfc_code}        user=meeting_user
    [Teardown]  Capture on Failure

*** Keywords ***