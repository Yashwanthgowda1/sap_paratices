*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup  ZTP Setup
Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Teams Shared Devices License] [CP Enrollment] Re-enrollment with same user
    [Tags]  342657   sanity
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1      user=cap_user
    verify room parameters    device=device_1:cap_user
    sign out method  device_1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1      user=cap_user
    verify room parameters    device=device_1:cap_user
    [Teardown]  Run Keywords    Capture on Failure    AND   sign out method     device=device_1     AND    Device setting back till signin btn visible    device=device_1

TC2:[Teams Shared Devices License] [CP Enrollment] Sending failure cases with invalid password in signin
    [Tags]  342659
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC3:[Teams Shared Devices License] [ZTP][Sign-in] Settings must provide options to provision phone
    [Tags]  342676   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings option from signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC4:[Teams Shared Devices License] [ZTP][Sign-in] Selecting cloud option to provisioning the phone
    [Tags]  342677
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option for provisioning device    device_1
    verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC5:[Teams Shared Devices License] [ZTP][Sign-in] User should able go back to sign-in page from cloud
    [Tags]  342684
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option   device_1
    navigate back to signin page form cloud    device_1
    verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC6:[Teams Shared Devices License] [ZTP][Sign-in] For provisioning the phone, DUT needs to show UI to enter verification code
    [Tags]  342687   sanity
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify provision phone option    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC7:[Teams Shared Devices License] [ZTP][Sign-in] DUT Sign-in options
    [Tags]  342651   sanity
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    [Teardown]  Capture on Failure

TC8:[Teams Shared Devices License] [ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone.
    [Tags]  342652   sanity
    [Setup]  Testcase Setup for ZTP    count=1
    verify the signin ui for ztp    device=device_1
    [Teardown]  Capture on Failure

TC9:[Teams Shared Devices License] [CP Enrollment] Re-enrollment with different user
    [Tags]  342656      sanity
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1      user=cap_user
    verify room parameters    device=device_1:cap_user
    Signin with other user    device=device_1   other_user_account=device_1:cap_user
    [Teardown]  Run Keywords    Capture on Failure    AND   sign out method     device=device_1     AND    Device setting back till signin btn visible    device=device_1

TC10:[Teams Shared Devices License] [CP Enrollment] No blocking GUI
    [Tags]  342662
    [Setup]  run keywords  Testcase Setup for ZTP    count=1    AND    Sign in method     device=device_1      user=cap_user   AND    verify device users  device_list=device_1
    sign out method  device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC11:[Teams Shared Devices License] [CP Enrollment] Unenrollment
    [Tags]  342666
    [Setup]  run keywords  Testcase Setup for ZTP    count=1    AND    Sign in method     device=device_1      user=cap_user   AND    verify device users  device_list=device_1
    sign out method  device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC12:[Teams Shared Devices License] [ZTP]Device login url on Landing page
    [Tags]  342715
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    verify login url with cloud settings as public    device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    verify login url with cloud setting as gcc    device_1
    verify settings from signin page only GCC    device_1
    verify cloud option    device_1
    verify login url with cloud setting as gcc high    device_1
    verify settings from signin page only GCC    device_1
    verify cloud option    device_1
    verify login url with cloud setting as gcc dod    device_1
    verify settings from signin page only GCC    device_1
    verify cloud option    device_1
    verify login url with cloud settings as public    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

*** Keywords ***

ZTP Setup
    sign out method  device_1