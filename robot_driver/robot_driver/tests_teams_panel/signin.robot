*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${2_minutes_wait_time} =  2 minutes

*** Test Cases ***
TC1:[Sign-in] User with Intune license can sign-in to DUT
    [Tags]  307660   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup  count=1
    verify room parameters   device=device_1
    [Teardown]  Capture on Failure

TC2:[Sign in] UI verification after sign in
    [Tags]  307664   sanity     bvt_panels_pr
    [Setup]  Testcase Setup  count=1
    verify room parameters   device=device_1
    verify scrollable agenda view  device=device_1
    #verify extensibility apps on homescreen  device=device_1
    [Teardown]  Capture on Failure

TC3:[Sign-in] User to be signed in to DUT within a specified time limit
    [Tags]  307668
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    sign in method  device_1
    Verify homescreen on panel       device=device_1
    [Teardown]  Capture on Failure

TC4:[Sign-in] Sign-out from the DUT
    [Tags]  307626   bvt   sanity	 bvt_panels     fw_panels    bvt_panels_pr
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1  AND     sign in method     device_1

TC5:[Sign-in] Sign into DUT with invalid user
    [Tags]  307628
    [Setup]  run keywords    Testcase Setup  count=1   AND   sign out method  device=device_1
    verify signin with invalid user  device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1

TC6:[Sign-in] Sign-in to DUT with wrong Password
    [Tags]  307630   sanity     bvt_panels_pr
    [Setup]  run keywords    Testcase Setup  count=1   AND   sign out method  device=device_1
    verify signin with wrong password  device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1

TC7:[Sign-in] Sign-in attempt in DUT with invalid domain name
    [Tags]  307634
    [Setup]  run keywords    Testcase Setup  count=1   AND   sign out method  device=device_1
    verify signin with invalid domain  device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Device setting back till signin btn visible    device=device_1   AND     sign in method     device_1

TC8:[Sign-in] User to sign-out from existing account and sign-in with a different account
    [Tags]  307666   bvt	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup  count=1
    Verify homescreen on panel   device=device_1
    Signin with other user    device=device_1   other_user_account=device_1:cap_user
    [Teardown]  Capture on Failure

TC9:[Sign-in] User to re-sign-in multiple times to with same user
    [Tags]  307679
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1
    Verify homescreen on panel   device=device_1
    [Teardown]  Capture on Failure

TC10:[Sign in] User is signed into the DUT, the application will broadcast an intent
    [Tags]  321579
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Reset Logcat Capture    device=device_1
    Sign in method     device=device_1
    Verify Intents      device=device_1     intent=sign_in     user=meeting_user
    [Teardown]  Capture on Failure

TC11:[Pro license account sign in]Verify that DUT user should able to sign-in with Pro license account
    [Tags]  393065   341662    bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup  count=1
    verify room parameters   device=device_1
    [Teardown]  Capture on Failure

TC12:[Basic license account sign in] Verify the DUT user should not be able to sign in with Basic license account
    [Tags]  341661
    [Setup]  Testcase Setup  count=1
    Signin with other user    device=device_1     other_user_account=device_1:sku_user
    verify teams app signin page    device=device_1
    [Teardown]  Capture on Failure

TC13:[Pro license account sign in] Verify the DUT user should be able to sign in with Pro license account
    [Tags]   341670
    [Setup]  Testcase Setup  count=1
    verify room parameters   device=device_1
    [Teardown]  Capture on Failure

TC14:[Pro license account sign in]Verifying "Pro license information" Displaying in about page.
    [Tags]  341672
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify about option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC15:[Basic license account sign in] Verify the DUT user should not be able to sign in with Basic license account
    [Tags]  341669
    [Setup]  Testcase Setup  count=1
    Signin with other user    device=device_1     other_user_account=device_1:sku_user
    verify teams app signin page    device=device_1
    [Teardown]  Capture on Failure

TC16:[Panels]Verify Account sign in with only a "Basic" license assigned account.
    [Tags]  416683
    [Setup]  Testcase Setup  count=1
    Signin with other user    device=device_1     other_user_account=device_1:sku_user
    verify teams app signin page    device=device_1
    [Teardown]  Capture on Failure

TC17:[Pro license account sign in]Verifying "Pro license information" Displaying in about page.
    [Tags]   341671
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify about option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC18:[Admin settings] User to sign out from App settings
    [Tags]  307458   sanity    bvt_panels_pr
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1  AND     sign in method     device_1

TC19:[Device settings] Admin to sign-out of Teams from Admin settings
	[Tags]  321924
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1  AND     sign in method     device_1

TC20:[Teams Shared Devices License] [Sign-in] Sign-out from the DUT
	[Tags]  341981
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1  AND     sign in method     device_1

TC21:[SKU Pro] Verify "Pro license information" Displaying in about page.
    [Tags]  341663
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify about option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC22:[Teams Shared Devices License] [Sign-in] User to sign-in from another device (web sign-in)
    [Tags]  341994
    [Setup]  Testcase Setup    count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=user
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Capture on Failure

TC23:[Web UI] User to verify the https support for Web UI
    [Tags]  307479
    [Setup]  Testcase Setup    count=1
    verify web sign with different protocol    protocol_type=secure     device=device_1
    [Teardown]  Capture on Failure