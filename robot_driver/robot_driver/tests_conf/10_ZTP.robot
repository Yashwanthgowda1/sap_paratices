*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup  ZTP Setup
Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  20
${10_minutes_wait_time} =  10 minutes

*** Test Cases ***
TC1 : [ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone.
    [Tags]   306331  sanity_tpc  P1    auth_tpc
    [Setup]  Testcase Setup for ZTP      count=1
    verify the signin ui for ztp   device=device_1
    [Teardown]  Capture on Failure

TC2 : [Sign-in] Settings must provide options to provision phone
    [Tags]  306357    P0     sanity_tpc  bvt_tpc    auth_tpc    auth_tpc_p0
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings option from signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC3 :[ZTP][Sign-in] For provisioning the phone, Teams App needs to show UI to enter verification code
    [Tags]   306371  sanity_tpc  P1    auth_tpc
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify provision phone option    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC4 : [ZTP]Teams app should come back on sign in screen when tap on back button from device settings screen
    [Tags]   321143      P2    auth_tpc
    [Setup]  Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    Verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC5 : Teams app should come back on Sign in screen when tap on back button from Provision Phone
    [Tags]      321134      P2    auth_tpc
    [Setup]     Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    verify provision phone ui   device=device_1
    Device setting back     device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC6 : [Sign in] Date and time should be available on sign in screen
    [Tags]  320130    P2    auth_tpc
    [Setup]     Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC7 : [ZTP]Teams app user can access the device setting from Sign in page.
    [Tags]   320270      P2    auth_tpc
    [Setup]     Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    verify settings from signin page    device_1
    close settings window from signin page      device=device_1    action=verify
    verify cloud option    device_1
    verify login url with cloud setting as gcc    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC8 : [ZTP]Teams app user should able to edit the verification code on provision phone screen
     [Tags]      320314      P2    auth_tpc
     [Setup]    Testcase Setup for ZTP    count=1
     verify settings from signin page    device=device_1
     verify provision phone ui   device=device_1
     Verify able to edit the code on provision phone ui      device=device_1
     [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC9: [Auth] [Phone Licensing] Verify user is blocked to sign in with Microsoft Teams Rooms Basic (new) license with user policy
    [Tags]  435850      P1    auth_tpc
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC10: [Phone Licensing]Verify "Sign-In error" message should be display when an license is Not supported for an account used to sign into a Teams
    [Tags]  435857       P1    auth_tpc
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC11: [Phone Licensing] Verify user is blocked to sign in with Microsoft Teams Rooms Basic (new) license
    [Tags]  381802      P2    auth_tpc
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC12 : [Sign-in][Public]User to sign-in using Teams License Account..
    [Tags]  348328    P2    auth_tpc
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option   device_1
    navigate back to signin page form cloud    device_1
    verify teams app signin page    device_1
    Sign in method      device=device_1      user=meeting_user
    Come back to home screen    device_list=device_1
    verify home screen for cnf device    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     Sign out method   device=device_1

TC13: [CP Enrollment] No blocking GUI
    [Tags]      306342
    [Setup]     run keywords  Testcase Setup for ZTP    count=1    AND    sign in method    device=device_1   user=meeting_user
    Sign out method   device=device_1
    Verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC14 : [Sign-in] User should able go back to sign-in page from cloud
   [Tags]      306368
   [Setup]  Testcase Setup for ZTP  count=1
   verify teams app signin page    device=device_1
   verify settings from signin page    device_1
   verify cloud option   device_1
   navigate back to signin page form cloud    device_1
   verify teams app signin page    device_1
   [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC15: [Sign-in] Sign into DUT with invalid user
    [Tags]          305795
    [Setup]   Run Keywords    Testcase Setup for Meeting User     count=1    AND   sign out method     device=device_1
    Verify signin with invalid user     device=device_1
    [Teardown]  Run Keywords    Capture on Failure

TC16 :[ZTP]Device login url on Landing page
    [Tags]  306400    P1
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
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC17 : [CP Enrollment] Sending failure cases with invalid password in signin
    [Tags]  306339    P1
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC18 : [Sign-in] Selecting cloud option to provisioning the phone
    [Tags]  306361    P1
    [Setup]  Testcase setup for ztp    count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option for provisioning device    device_1
    verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

*** Keywords ***
ZTP Setup
    sign out method  device_1