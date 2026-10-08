*** Settings ***
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Sign-in] User to sign-in with valid username and password
    [Tags]  237605  bvt_sm   sanity_sm  smoke_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    [Teardown]  Capture on Failure

TC2:[Sign out] Account sign out option should be under Admin settings for Room/meeting account
    [Tags]  237869  bvt_sm   sanity_sm  smoke_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Sign out method    device=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND   Sign in method     device=device_1     user=meeting_user

TC3:[Sign-in] User to be signed in to DUT within a specified time limit
    [Tags]  237846  P2
    [Setup]    Testcase Setup for Meeting User     count=1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Navigate to app settings page    device=device_1
    [Teardown]  Run Keywords  Capture on Failure   AND   Sign in Teardown  device=device_1

TC4:[Sign-in] User to sign-out from existing account and sign-in with a different account
    [Tags]  237845  bvt_sm  sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Verify home page screen   device=device_1
    Sign out method    device=device_1
    Sign in method     device=device_1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Sign out method    device=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND   Sign in method     device=device_1     user=meeting_user

TC5:[Sign-in] User to re-sign-in multiple times with same user in DUT
    [Tags]  237856    P2
    [Setup]  Testcase Setup for Meeting User   count=1
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device=device_1     user=meeting_user
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device=device_1     user=meeting_user
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device=device_1     user=meeting_user
    [Teardown]   Capture on Failure

TC6:[Sign in] DID of the user should be displayed on the Homescreen and dialpad
    [Tags]  265132   bvt    bvt_sm      sanity_sm
    [Setup]  Testcase Setup for Meeting User  count=1
    verify did displayed on homescreen and on dialpad    device=device_1:meeting_user
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC7:[Sign in] Date and time should be available on sign in screen
    [Tags]  303884   P2
    [Setup]  Testcase Setup for Meeting User  count=1
    verify current time display on home screen   device=device_1
    [Teardown]   Capture on Failure

TC8:[Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user
    [Tags]  237850   P2
    [Setup]  run keywords   Testcase Setup for Meeting User    count=2   AND    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
    Validate that signin is successfully completed    device_list=device_2     state=Sign in
    validate rooms ui after signin   device=device_1
    sign out method  device=device_1
    Sign in method     device=device_1     user=meeting_user
    [Teardown]  Run Keywords   Capture on Failure    AND   Sign in Teardown  device=device_1,device_2

TC9:[Sign-in] Sign-out from the DUT
    [Tags]  265113   bvt_sm   sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=1
    Sign out method    device=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND   Sign in method     device=device_1     user=meeting_user

TC10:[Sign in] Sign in button should functional at sign in screen
    [Tags]   317197   P2
    [Setup]  Testcase Setup for Meeting User  count=1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    [Teardown]    Run Keywords   Capture on Failure

TC11:[Sign-in] Verify DCF code after performing screen transition
     [Tags]   339587      P2
     [Setup]  Testcase Setup for Meeting User  count=1
     Sign out method    device=device_1
     navigate to different screens and refresh button should not present in dfc screen      device=device_1
     [Teardown]  Run Keywords   Capture on Failure  AND    Sign in method     device=device_1     user=meeting_user

TC12:[Sign-in] Sign into DUT with invalid user
    [Tags]   343740      P2
    [Setup]   Run Keywords     Testcase Setup for Meeting User    count=1    AND   sign out method     device=device_1
    Verify signin with invalid user     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1   AND      Sign in method     device=device_1     user=meeting_user

TC13:[Sign-in] Sign-in to DUT with wrong Password
    [Tags]   343741      P1
    [Setup]   Run Keywords     Testcase Setup for Meeting User    count=1    AND   sign out method     device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1   AND      Sign in method     device=device_1     user=meeting_user

TC14:[Sign-in] Sign-in attempt in DUT with invalid domain name
    [Tags]   343743   P2
    [Setup]   Run Keywords     Testcase Setup for Meeting User    count=1    AND   sign out method     device=device_1
    Verify signin with invalid domain     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND      Sign in method     device=device_1     user=meeting_user

TC15:DUT user to verify the error message in sign in page, when user signs in with an unsupported account.
    [Tags]      344911      bvt_sm   sanity_sm
    [Setup]   Run Keywords     Testcase Setup for Meeting User    count=1    AND   sign out method     device=device_1
    verify the error message in sign in page     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1   AND      Sign in method     device=device_1     user=meeting_user

TC16:[Pro]Verify DUT user should be able to see the license details of the account signed in under Teams about page
    [Tags]      338850  P1      sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to about page    device=device_1
    Verify user license details in about page    device=device_1   user=meeting_user
    navigate back to more option page    device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

Tc17:[Sign-in] User sign-in successfully with a complex password including special characters
    [Tags]      237706      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Sign out method    device=device_1
    Sign in method     device=device_1   user=complex_pwd_user
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Sign out method    device=device_1
    Sign in method     device=device_1     user=meeting_user
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC18:[Sign-in] User with Intune license can sign-in to DUT
    [Documentation]  Should clear the CAP limit before triggering a run.
    [Tags]      316959      bvt_sm      sanity_sm   exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Sign out method    device=device_1
    Sign in method     device=device_1   user=intune_license_user
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Sign out method    device=device_1
    Sign in method     device=device_1     user=meeting_user
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC19:[Basic]Verify upsell message displayed under setting and admin settings are non-actionable
    [Tags]      338845  P1      sanity_sm     exclude_ftp_sm
    [Setup]  Testcase Setup for MTRA Basic User     count=1
    Navigate to app settings page    device=device_1
    Verify up sell message under the admin settings and non actionable    device=device_1
    navigate to teams admin settings    device=device_1
    Verify up sell message under the admin settings and non actionable    device=device_1
    Come back from admin settings page      device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC20:[Basic]Verify DUT user should be able to see the license details of the account signed in under Teams about
    [Tags]      338848  P1      sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for MTRA Basic User     count=1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Navigate to about page    device=device_1
    Verify user license details in about page    device=device_1       user=basic_user
    navigate back to more option page    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC21:[Basic]Verify whether DUT user is able to see Pro tag for Show meeting names and Room capacity Notification
    [Tags]  338846      P1  sanity_sm   exclude_ftp_sm
    [Setup]  Testcase Setup for MTRA Basic User     count=1
    Navigate to app settings page   device=device_1
    navigate to meetings option in device settings page      device=device_1
    Verify pro tags under meetings    device=device_1    option=show_meeting_names
    Verify pro tags under meetings      device=device_1    option=max_room_occupancy_notification
    come back from admin settings page    device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1

*** Keywords ***
Sign in Teardown
    [Arguments]     ${device}
    Click close btn    device_list=${device}
    Come back to home screen    device_list=${device}

verify the error message in sign in page
    [Arguments]     ${device}
    Verify signin with invalid user      ${device}

