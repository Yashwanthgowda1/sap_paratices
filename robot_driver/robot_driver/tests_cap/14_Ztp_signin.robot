*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup  ZTP Setup
Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC 1 : [ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone
    [Tags]  261557    P1     sanity_cap    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    Verify the signin ui for ztp    device=device_1
    [Teardown]  Capture on Failure

TC 2 : [CP Enrollment] Sending failure cases with invalid password in signin
    [Tags]  261565    P1    auth_cap
    [Setup]  Testcase Setup for ZTP  count=1
    Verify teams app signin page    device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 3 : [CP Enrollment] No blocking GUI
    [Tags]  261568    P1    auth_cap
    [Setup]  run keywords  Testcase Setup for ZTP    count=1    AND    sign in method    device=device_1   user=cap_search_enabled
    Sign out method   device=device_1
    Verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 4 : [ZTP][Sign-in] Settings must provide options to provision phone
    [Tags]  261583    P0    bvt_cap  sanity_cap    auth_cap    auth_cap_p0
    [Setup]  Testcase Setup for ZTP    count=1
    Verify teams app signin page    device=device_1
    Verify settings option from signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 5 : [ZTP][Sign-in] Selecting cloud option to provisioning the phone
    [Tags]  261587    P1    auth_cap
    [Setup]  Testcase setup for ztp    count=1
    Verify teams app signin page    device=device_1
    Verify settings from signin page    device_1
    Verify cloud option for provisioning device    device_1
    Verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 6 : [ZTP][Sign-in] User should able go back to sign-in page from cloud
    [Tags]  261594    P1    auth_cap
    [Setup]  Testcase Setup for ZTP  count=1
    Verify teams app signin page    device=device_1
    Verify settings from signin page    device_1
    Verify cloud option   device_1
    Navigate back to signin page form cloud    device_1
    Verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 7 : [ZTP][Sign-in] For provisioning the phone, Teams App needs to show UI to enter verification code
    [Tags]  261597    P1     sanity_cap    auth_cap
    [Setup]  Testcase Setup for ZTP  count=1
    Verify teams app signin page    device=device_1
    Verify settings from signin page    device_1
    Verify provision phone option    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC8 : [ZTP]Device login url on Landing page
    [Tags]  261626    P1
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    verify login url with cloud settings as public    device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    verify login url with cloud setting as gcc    device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    verify login url with cloud setting as gcc high    device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    verify login url with cloud setting as gcc dod    device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    verify login url with cloud settings as public    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC9 : [ZTP][Sign-in] Teams App Sign-in options
    [Tags]  261556    P0    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    [Teardown]  Capture on Failure

TC10 : [ZTP]Teams app user can access the device setting from Sign in page.
    [Tags]  320271     P2    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC11 :Teams app should come back on Sign in screen when tap on back button from Provision Phone
     [Tags]     321136      P2    auth_cap
     [Setup]  Testcase Setup for ZTP    count=1
     verify settings from signin page    device=device_1
     verify provision phone ui   device=device_1
     click back  device=device_1
     verify teams app signin page    device=device_1
     [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC12 : [ZTP]Teams app should come back on sign in screen when tap on back button from device settings screen
    [Tags]  321145     P2    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC13:[Phone Licensing][CAP] Verify user is blocked to sign in with Microsoft Teams Rooms Basic (new) license with CAP policy
    [Tags]    381765   P2    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC14:[Phone Licensing]Verify "Sign-In error" message should be display when an license is Not supported for an account used to sign into a Teams
    [Tags]   381762     P1     sanity_cap    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC15: [Phone Licensing][Homescreen][CAP] Dial Pad should be present in Homescreen with Date ,Month & Time displaying.
    [Tags]   381760   P0    bvt_cap   sanity_cap    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    sign in method     device_1    user=cap_search_enabled
    verify home screen UI for cap   device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1   AND   Sign out method    device=device_1

TC16: [License Stacking] Verify DUT should display CAP UI, when user sign with User/Personal License + MTR Basic & Basic CAP Policy assigned account.
    [Tags]    419901   P0    bvt_cap   sanity_cap    auth_cap    auth_cap_p0
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:cap_mtra_pro_license_with_personal_policy_assigned_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC17:[License Stacking] Verify DUT should display CAP UI, when user sign with TSD + User/Personal License & Basic CAP Policy assigned account
    [Tags]    419896   P0    bvt_cap   sanity_cap    auth_cap    auth_cap_p0
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:cap_personal_license_with_personal_policy_assigned_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC18:[Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when sign in with enrollment restriction account.
    [Tags]    348571    P1     sanity_cap    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:enrollment_restrict_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC19:[Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when user sign in with maximun set OS account.
    [Tags]      348567    P2    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:maximum_os_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC20:[Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when user sign in with minimum set OS account.
    [Tags]   348566      P2    auth_cap
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:minimum_os_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC21:[Device Settings] User to access Device Settings from Sign-in page
    [Tags]  149146
    [Setup]  Testcase Setup for ZTP  count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

#Test case removed due to following bug - Bug 4100287: [MTRA]Report an issue option is missing under settings.
#TC21 : [ZTP]Teams app user should able to report an issue at sign in page
#      [Tags]   320962     P2    auth_cap
#      [Setup]  Testcase Setup for ZTP    count=1
#      report an issue from signin page    device=device_1
#      [Teardown]  Run Keywords    Capture on Failure

*** Keywords ***
ZTP Setup
    Sign out method  device_1
