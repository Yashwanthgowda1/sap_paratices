*** Settings ***
Resource    ../resources/keywords/common.robot

#Suite Setup     User Setup Main
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s
${16_minutes_wait_time} =  16 minutes

*** Test Cases ***
TC1 : [Sign-in] User with Intune license can sign-in to DUT
    [Tags]  308426    bvt_tp     sanity_tp    bvt_pr           alt_credentials        Certification_audio    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup    count=1
    Log     This message is displayed if user is signed-in
    [Teardown]  Capture on Failure

TC2 : [Sign in] UI verification after sign in
    [Documentation]  Verify that calls, meetings and voicemail tabs are synced on the teams app UI.
    [Tags]  309094                 alt_credentials        Certification_audio    auth_audio
    [Setup]  Testcase Setup    count=1
    Navigate to calendar tab    device=device_1
    Navigate to voicemail tab    device=device_1
    Navigate to people tab    device=device_1
    Navigate to calls tab       device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [Sign-in] Sign-out from the DUT
    [Tags]  306760    bvt_tp    sanity_tp    bvt_pr         alt_credentials     Certification_audio    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup    count=1
    sign out method    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     sign in method     device_1

TC4 : [Sign in] Verify DID of the user should not be displayed on the Dial pad.
    [Tags]  309010    bvt_tp     sanity_tp             alt_blocked        Certification_audio    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup    count=1
    Verify user DID num on home screen    device=device_1
    [Teardown]  Capture on Failure

TC5 : [Sign-in] Sign into DUT with invalid user
    [Tags]  306788    P3    alt_credentials    auth_audio
    [Setup]   Run Keywords    Testcase Setup    count=1    AND   sign out method     device=device_1
    Verify signin with invalid user     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1

TC6 : [Sign-in] Sign-in attempt in DUT with invalid domain name
    [Tags]  307175    P3    alt_bug    auth_audio
    [Setup]   Run Keywords    Testcase Setup    count=1    AND   sign out method     device=device_1
    Verify signin with invalid domain     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1

TC7 : [Sign-in] Sign-in to DUT with wrong Password
    [Tags]  306804    P3    alt_credentials    auth_audio
    [Setup]   Run Keywords    Testcase Setup    count=1    AND   sign out method     device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1

TC8 : [Sign-in] User to sign-out from existing account and sign-in with a different account
    [Tags]  310263    bvt_tp     sanity_tp             alt_blocked    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup    count=1
    Navigate to calendar tab    device=device_1
    Navigate to voicemail tab    device=device_1
    Navigate to people tab    device=device_1
    Navigate to calls tab       device=device_1
    Signin with other user    device=device_1   other_user_account=device_2
    [Teardown]  Run Keywords    Capture on Failure    AND    Sign out method    device_1    AND     Sign in method     device_1

TC9 : [Sign-in] User to re-sign-in multiple times with same user in the DUT
    [Tags]  310281    P1    alt_bug    auth_audio
    [Setup]  Testcase Setup    count=1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    [Teardown]  Capture on Failure

TC10 : [Sign-in] User to be signed in to DUT within a specified time limit
    [Tags]  310266   sanity_tp            alt_credentials    auth_audio
    [Setup]  Testcase Setup    count=1
    Navigate to people tab    device=device_1
    Navigate to calls tab       device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11 : [License Stacking] Verify DUT should display Conference UI, when user sign with Room (Pro) license with Personal Policy account
    [Tags]      419789     auth_audio    auth_audio_p0
    [Setup]  Testcase Setup    count=1
    Sign out method    device_1
    Sign in method      device=device_1      user=meeting_user
    verify home screen for cnf device    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Sign out method    device_1    AND     Sign in method     device_1

TC12: [Auth] Verify DUT user is Sign in back with the same account via Web Sign after a Manual Sign out from the settings
    [Tags]      435470   sanity_tp      bvt_pr    auth_audio
    [Setup]  Testcase Setup    count=1
    Sign out method    device_1
    signin method with dcf code    device=device_1    user=user
    Verify home screen page     device=device_1
    [Teardown]  Capture on Failure

TC13 : [Auth]Verify Web Sign-In using new DCF code after expiring the existing DCF code.
    [Tags]  435459     auth_audio_p0    auth_audio     sanity_tp         bvt_tp
    [Setup]  Testcase Setup    count=1
    Sign out method    device=device_1
    ${old_dfc_code}=     fetch dfc code      device=device_1
    Wait for Some Time    time=${16_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=different
    signin method with dcf code    device=device_1    user=user
    Verify home screen page     device=device_1
    [Teardown]  Capture on Failure

TC14 : [Sign-in] User to sign-in with username and password
    [Tags]     343783   P2
    [Setup]  Testcase Setup    count=1
    Log     This message is displayed if user is signed-in
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure

TC15 : [Sign in] Sign in button should functional at sign in screen
    [Tags]     343785   P2
    [Setup]  Testcase Setup    count=1
    Log     This message is displayed if user is signed-in
    verify that sign in is successful     device_list=device_1     state=sign in
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure

TC16 : [Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user
    [Tags]     343787    P3
    [Setup]  run keywords   Testcase Setup    count=3   AND    Signin with other user    device=device_2   other_user_account=device_1
    verify that sign in is successful     device_list=device_1,device_2       state=sign in
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Sign out method    device_2
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure    AND     Sign out method    device_2   AND   Sign in method     device_2

TC17 :[Sign-in] [Public][Hot desk] User to sign-in with Hot desk user for Teams License Account
    [Tags]   346121      P2
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Wait for Some Time    time=${wait_time}
    Verify hot desking mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2   AND   End hot desk    device=device_1

TC18 : [Sign-in] Verify DCF code after performing screen transition
    [Tags]    339578    P2
    [Setup]    Testcase Setup    count=1
    Teams Restart Auth     device_name=device_1
    navigate to different screens and refresh button should not present in dfc screen    device=device_1
    [Teardown]    Run Keywords    Capture On Failure

TC19 : [Auth]Verify Manual sign-in using new DCF code after expiring the existing code
    [Tags]    435464    P2
    [Setup]    Testcase Setup    count=1
    Sign out method    device=device_1
    verify teams app signin page    device=device_1
    ${old_dfc_code}=     fetch dfc code      device=device_1
    Wait for Some Time    time=${16_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=different
    Sign in method     device_1
    Verify home screen page     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Sign out method    device=device_1    AND    Sign in method    device_1