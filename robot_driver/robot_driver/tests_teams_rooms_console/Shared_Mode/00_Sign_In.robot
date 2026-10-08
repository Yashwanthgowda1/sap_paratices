*** Settings ***
Documentation    Validating the functionality of console sigin/signout feature.
Resource    ../../resources/keywords/common.robot

*** Variables ***

*** Test Cases ***
TC1:[Sign-in] User to sign-in with username and password
    [Tags]     314720    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User       count=1
    Verify signin is successful    console_list=console_1     state=Sign in
    [Teardown]   Capture Failure

TC2:[Sign-out] Account sign out option should be under Admin Section for Room/meeting account
    [Tags]   314748    bvt_tc_sm     sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    Verify signin is successful   console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    [Teardown]  Run Keywords  Capture Failure    AND   Console sign in method     console=console_1    user=meeting_user  AND  Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user

TC3:[Sign-in] Sign-out from the TC and check for the intents
    [Tags]    314728    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    Verify signin is successful   console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Verify home page screen   device=device_1
    Sign out method    device=device_1
    Verify Intents      device=console_1     intent=sign_out     user=meeting_user
    [Teardown]  Run Keywords   Capture Failure    AND  Sign in method     device=device_1  user=meeting_user  AND   console sign in method    console=console_1    user=meeting_user  AND  Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user

TC4:[Sign-in] User to sign-out from existing account and sign-in with a different account
    [Tags]     314732    bvt_tc_sm      sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    Verify signin is successful   console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Verify home page screen   device=device_1
    Sign out method    device=device_1
    Sign in method     device=device_1
    Console sign in method     console=console_1
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=user
    Verify signin is successful    console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    Sign out method    device=device_1
    Sign in method     device=device_1     user=meeting_user
    [Teardown]  Run Keywords   Capture Failure  AND  console sign in method    console=console_1       user=meeting_user   AND   Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user

#Removed the testcase due to Bug 2130229: [Tracking][Norden][Blocked][CP Bug] Teams app stuck after entering username in "Connecting" page
#TC5: [Sign-in] User to re-sign-in multiple times to with same user
#     [Tags]   314746    bvt_sm      sanity_sm
#     [Setup]  Testcase Setup for shared User      count=1
#     Console sign out method   console=console_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1     user=meeting_user
#     Console sign in method    console=console_1        user=meeting_user
#     Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
#     Verify signin is successful   console_list=console_1     state=Sign in
#     Console sign out method   console=console_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1     user=meeting_user
#     Console sign in method     console=console_1       user=meeting_user
#     Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
#     Verify signin is successful   console_list=console_1     state=Sign in
#     Console sign out method   console=console_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1     user=meeting_user
#     [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC5:[Sign in] DID of the user should be displayed on the Home screen and dial pad
    [Tags]    322300      bvt_tc_sm      sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    Verify did user displayed on homescreen and on dialpad      console=console_1:meeting_user
    [Teardown]  Run Keywords   Capture Failure    AND     Come back to home screen page   console_list=console_1

TC6:[Sign-in] User to be signed in to Teams App within a specified time limit
    [Tags]    314734    P2
    [Setup]  Testcase Setup for shared User      count=1
    Verify signin is successful   console_list=console_1     state=Sign in
    Verify Home page options   console=console_1:meeting_user
    [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1

TC7:[Sign-in] User to Sign-in Touch console and TDC simultaneously with same valid user
    [Tags]    323361    P2
    [Setup]  run keywords   Testcase Setup for shared User    count=2   AND    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
    Validate that signin is successfully completed    device_list=device_2     state=Sign in
    Validate user details along with home screen options    console=console_1:meeting_user
    Console sign out method   console=console_1
    Console sign in method     console=console_1        user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1      device_list=device_2

TC8:[Sign-in] Sign into DUT with invalid user
    [Tags]   343759      P2
    [Setup]   Run Keywords     Testcase Setup for shared User    count=1    AND   Console sign out method   console=console_1
    Verify signin with invalid user     device=console_1
    [Teardown]  Run Keywords   Capture Failure   AND    Sign in Teardown    device_list=device_1    console=console_1

TC9:[Sign-in] Sign-in to DUT with wrong Password
    [Tags]   343760      P1
    [Setup]   Run Keywords     Testcase Setup for shared User    count=1    AND   Console sign out method   console=console_1
    Verify signin with wrong password     device=console_1
    Navigate back to signin page     console=console_1
    [Teardown]  Run Keywords   Capture Failure    AND       Sign in Teardown    device_list=device_1    console=console_1

TC10:[Sign-in] Sign-in attempt in DUT with invalid domain name
    [Tags]   343762   P2
    [Setup]   Run Keywords     Testcase Setup for shared User    count=1    AND   Console sign out method   console=console_1
    Verify signin with invalid domain     device=console_1
    [Teardown]  Run Keywords   Capture Failure   AND    Sign in Teardown    device_list=device_1    console=console_1

TC11:DUT user to verify the error message in sign in page, when user signs in with an unsupported account.
    [Tags]   344993     bvt_tc_sm       sanity_tc_sm
    [Setup]   Run Keywords     Testcase Setup for shared User    count=1    AND   Console sign out method   console=console_1
    Verify signin with invalid user     device=console_1
    [Teardown]  Run Keywords   Capture Failure   AND    Sign in Teardown    device_list=device_1    console=console_1

TC12:DUT user to verify the error message in sign in page, when user sign in with manufacture blocked account.
    [Tags]    344996    P1    sanity_tc_sm      exclude_ftp_sm
    [Setup]   Run Keywords     Testcase Setup for shared User    count=1    AND   Console sign out method   console=console_1
    verify sign in with manufacture blocked account     device=console_1    user=manufacture_block_user
    [Teardown]  Run Keywords   Capture Failure    AND       Sign in Teardown    device_list=device_1    console=console_1

TC13:[Pro]Verify Touch console user should be able to see the license details of the account signed in under Teams about page
    [Tags]    345323    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User       count=1
    Navigate to about page    console=console_1
    Verify user license details in about page    device=console_1   user=meeting_user
    navigate back to more option page    device=console_1
    [Teardown]   Run Keywords   Capture Failure    AND      Come back to home screen page   console_list=console_1

TC14:[Basic]Verify upsell message displayed under setting and admin settings are non-actionable
    [Tags]  345326    P1    sanity_tc_sm
    [Setup]  Testcase console setup for basic user       count=1
    Verify signin is successful    console_list=console_1     state=Sign in
    Navigate to settings page    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=settings_page
    Verify up sell message under the admin settings and non actionable      device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords   Capture Failure   AND    Come back to home screen page   console_list=console_1

TC15:[Basic]Verify whether DUT user is able to see Pro tag for Show meeting names and Room capacity Notification
    [Tags]  345327    P1    sanity_tc_sm
    [Setup]   Testcase console setup for basic user      count=1
    Navigate to settings page    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=meeting
    Verify up sell message under the admin settings and non actionable      device=console_1    option=meeting
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords   Capture Failure   AND    Come back to home screen page   console_list=console_1

TC16:[Basic]Verify DUT user should be able to see the license details of the account signed in under Teams about
    [Tags]    345329    P1    sanity_tc_sm
    [Setup]  Testcase console setup for basic user       count=1
    Navigate to about page    console=console_1
    Verify user license details in about page    device=console_1   user=basic_user
    navigate back to more option page    device=console_1
    [Teardown]   Run Keywords   Capture Failure    AND      Come back to home screen page   console_list=console_1

TC17:[Sign-in] User sign-in successfully with a complex password including special characters
    [Tags]      314726      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User      count=1
    Verify signin is successful    console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    Sign out method    device=device_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Sign in method     device=device_1   user=complex_pwd_user
    Console sign in method     console=console_1    user=complex_pwd_user
    Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    Verify presence of Intents        device=console_1         feature=keycode         state=absent
    Console sign out method   console=console_1
    Sign out method    device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND    console and device sign in teardown

TC18:[Sign-in] User with Intune license can sign-in to DUT
    [Tags]      322312      bvt_tc_sm       sanity_tc_sm    exclude_ftp_sm
    [Setup]   Testcase Setup for shared User      count=1
    Console sign out method   console=console_1
    Sign out method    device=device_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Sign in method     device=device_1      user=intune_license_user
    Console sign in method     console=console_1    user=intune_license_user
    Get device pairing code    device_list=device_1    console_list=console_1   user_list=intune_license_user
    Verify signin is successful    console_list=console_1     state=Sign in
    Verify presence of Intents        device=console_1         feature=keycode         state=absent
    Console sign out method   console=console_1
    Sign out method    device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND    console and device sign in teardown

TC19:[Sign in] Sign in button should functional at sign in screen
    [Tags]      322313      P2
    [Setup]  Testcase Setup for shared User       count=1
    Console sign out method   console=console_1
    Verify welcome message on dfc screen    device=console_1
    console sign in method    console=console_1       user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
    Verify presence of Intents        device=console_1         feature=keycode         state=absent
    [Teardown]  Run keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1

TC20:[Sign-in] Verify DCF code after performing screen transition
	[Tags]      339592
	[Setup]   Testcase Setup for shared User      count=1
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    navigate to different screens and refresh button should not present in dfc screen      device=console_1
    [Teardown]  Run Keywords  Capture Failure    AND    Sign in Teardown    device_list=device_1    console=console_1

*** Keywords ***
Sign in Teardown
    [Arguments]     ${device_list}      ${console}
    Device setting back btn    ${console}
    Console sign in method    ${console}      user=meeting_user
    Get device pairing code    ${device_list}    console_list=${console}     user_list=meeting_user

Verify Home page options
    [Arguments]     ${console}
    validate user details along with home screen options        ${console}

Navigate back to signin page
    [Arguments]     ${console}
    Navigate back to signin page form cloud     device=${console}

Navigate to about page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}
    click on about page  device=${console}

Navigate to settings page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

verify sign in with manufacture blocked account
    [Arguments]     ${device}       ${user}
    Verify signin with wrong password       ${device}       ${user}

Console setup for basic user
    Sign Out Console
    Sign Out
    Sign In    user_list=basic_user,user,user
    Sign In Console    user_list=basic_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=basic_user

Testcase console setup for basic user
    [Arguments]    ${count}
    Console setup for basic user
    Testcase Setup for basic User   ${count}


console and device sign in teardown
    Sign In    user_list=meeting_user
    Sign In Console    user_list=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
