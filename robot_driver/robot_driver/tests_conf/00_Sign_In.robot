*** Settings ***
Resource    ../resources/keywords/common.robot

#Suite Setup     Meeting Policy Setup Main
Suite Teardown    Suite Failure Capture

*** Variables ***
${16_minutes_wait_time} =  16 minutes

*** Test Cases ***
TC1 : [Sign-in] User with Intune license can sign-in to DUT
    [Tags]  305940   bvt_tpc     sanity_tpc  P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify that sign in is successful   device_list=device_1     state=Sign in
    [Teardown]  Capture on Failure

TC2 : [Sign-in] Sign-out from the DUT
    [Tags]  305780    bvt_tpc    sanity_tpc  P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User    count=1
    sign out method    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     sign in method     device_1    user=meeting_user

TC3 : [Sign-in] User to sign-out from existing account and sign-in with a different account
    [Tags]  306129    bvt_tpc    sanity_tpc  P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User   count=1
    Navigate to people tab    device=device_1
    Navigate to calendar tab    device=device_1
    Sign out method    device_1
    Sign in method     device=device_1
    [Teardown]  Capture on Failure

TC4 : [Sign-in] User to be signed in to DUT within a specified time limit
    [Tags]   306130  sanity_tpc  P1    auth_tpc
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to people tab    device=device_1
    Navigate to calendar tab    device=device_1
    [Teardown]  Capture on Failure

TC5 : [MeetingsignIn] MeetingsSignIn _sign out option should be behind admin settings
    [Tags]  306250    bvt_tpc    sanity_tpc  P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User    count=1
    Open settings page   device=device_1
    verify signout option should be in device settings    device_list=device_1
    repeat keyword   2 times     device setting back     device=device_1
    [Teardown]   Run Keywords    Capture on Failure     AND     Device setting back   device=device_1    AND    Come back to home screen    device_list=device_1

TC6 : [MeetingsignIn] Sign in with MeetingSignIn policy assigned user
    [Tags]  306249  bvt_tpc  sanity_tpc  P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to people tab    device=device_1
    Navigate to calendar tab    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1

TC7 :[Sign in] Verify DID of the user should not be displayed on the Dial pad.
    [Tags]  305993    bvt_tpc    sanity_tpc     P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User    count=1
    navigate to dial pad tab for conf      device=device_1
    Verify DID number should not present on dialpad         device=device_1:meeting_user
    [Teardown]  Run Keywords    Capture on Failure  AND    click_close_btn    device_list=device_1

TC8 : [Sign in] UI verification after sign in
    [Tags]  320337    P2    auth_tpc
    [Setup]  Testcase Setup for Meeting User    count=1
    verify home screen for cnf device    device=device_1
    [Teardown]  Run Keywords    Capture on Failure

TC9 : [Sign-in] Sign-in attempt in DUT with invalid domain name
    [Tags]  305870    P3    auth_tpc
    [Setup]  Testcase Setup for Meeting User    count=1
    sign out method     device=device_1
    Verify signin with invalid domain     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Device setting back till signin btn visible    device=device_1   AND   Sign in method      device=device_1      user=meeting_user

TC10 : [License Stacking] Verify DUT should display Personal UI when signed in with Personal license & Room policy assigned account.
    [Tags]    419806    P0    auth_tpc    auth_tpc_p0    sanity_tpc    bvt_tpc
    [Setup]  Testcase Setup for Meeting User    count=1
    Signin with other user    device=device_1   other_user_account=device_1
    Verify home screen page     device=device_1
    [Teardown]  Run Keywords    Capture on Failure

TC11 : [License Stacking] Verify DUT display Conference UI when signed in with Room (Pro) License & Room policy assigned account
    [Tags]  419810  bvt_tpc     sanity_tpc    P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User    count=1
    verify home screen for cnf device    device=device_1
    verify home screen date and time for cnf device     device=device_1
    [Teardown]  Run Keywords    Capture on Failure

TC12 : [Phone Licensing] Verify home screen after signing with account having Microsoft Teams Rooms Pro (new) license assigned with meeting policy
    [Tags]    381803    P0    auth_tpc    auth_tpc_p0    sanity_tpc     bvt_tpc
    [Setup]  Testcase Setup for Meeting User    count=1
    verify home screen for cnf device    device=device_1
    [Teardown]   Capture on Failure

TC13 : [Auth] Verify DUT user is Sign in back with the same account via Web Sign after a Manual Sign out from the settings
    [Tags]  435752  sanity_tpc  P1    auth_tpc
    [Setup]  Testcase Setup for Meeting User    count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=meeting_user
    [Teardown]  Capture on Failure

TC14: [Auth]Verify Web Sign-In using new DCF code after expiring the existing DCF code.
    [Tags]  435748  sanity_tpc    bvt_tpc   P0    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for Meeting User    count=1
    sign out method  device=device_1
    ${old_dfc_code}=     fetch dfc code      device=device_1
    Wait for Some Time    time=${16_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=different
    signin method with dcf code    device=device_1    user=meeting_user
    [Teardown]  Capture on Failure

TC15 : [Sign-in] User to re-sign-in multiple times to with same user
   [Tags]     306139
   [Setup]  Testcase Setup for Meeting User    count=1
   Sign out method    device=device_1
   Wait for Some Time    time=${wait_time}
   Sign in method      device=device_1      user=meeting_user
   Sign out method    device=device_1
   Wait for Some Time    time=${wait_time}
   Sign in method      device=device_1      user=meeting_user
   Sign out method    device=device_1
   Wait for Some Time    time=${wait_time}
   Sign in method      device=device_1      user=meeting_user
   [Teardown]   Capture on Failure

TC16 : [Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user and TDC sign-outs while getting call
    [Tags]  306135  P1    auth_tpc
    [Setup]  Testcase Setup for Meeting User    count=3
    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
    Navigate to people tab    device=device_1
    Navigate to calendar tab    device=device_1
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:meeting_user
    verify incoming call   device=device_1,device_2    status=appear
    Wait for Some Time    time=${wait_time}
    Rejects the incoming call     device_list=device_2
    verify incoming call  device=device_1,device_2    status=disappear
    sign out method   device=device_2
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC17 : [Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user
    [Tags]  306134  P1    auth_tpc
    [Setup]  Testcase Setup for Meeting User    count=2
    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
    Navigate to people tab    device=device_1
    Navigate to calendar tab    device=device_1
    Navigate to people tab    device=device_2
    Navigate to calendar tab    device=device_2
    sign out  device_list=device_1,device_2
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC18 : [Sign-in] Sign-in to DUT with wrong Password
     [Tags]  305807    P3    auth_tpc
     [Setup]  Testcase Setup for Meeting User      count=1
     Sign out method    device=device_1
     Verify signin with wrong password     device=device_1
     [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
