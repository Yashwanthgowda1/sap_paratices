#*** Settings ***
#Force Tags   pm_ztp   19   pm
#Resource    ../resources/keywords/common.robot
#
#Suite Setup   ZTP Setup
#Suite Teardown   Suite Failure Capture
#
#*** Test Cases ***
#TC1: [ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone
#    [Tags]  305241  sanity_pm
#    [Setup]  Testcase Setup for ZTP    count=1
#    verify the signin ui for ztp    device=device_1
#    [Teardown]  Capture on Failure
#
#TC2: [CP Enrollment] No blocking GUI
#    [Tags]  305251
#    [Setup]  Testcase Setup for Meeting User  count=1
#    verify home page screen  device=device_1
#    sign out method  device=device_1
#    verify teams app signin page    device=device_1
#    [Teardown]  Capture on Failure
#
#TC3: [ZTP][Sign-in] Settings must provide options to provision phone
#    [Tags]  305266   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup for ZTP    count=1
#    verify teams app signin page    device=device_1
#    verify settings option from signin page    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC4: [ZTP][Sign-in] Selecting cloud option to provisioning the phone
#    [Tags]  305270
#    [Setup]  Testcase Setup for ZTP    count=1
#    verify teams app signin page    device=device_1
#    verify settings from signin page    device_1
#    verify cloud option for provisioning device    device_1
#    verify teams app signin page    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC5: [ZTP][Sign-in] DUT User should able go back to sign-in page from cloud
#    [Tags]  305277
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    verify settings from signin page    device_1
#    verify cloud option   device_1
#    navigate back to signin page form cloud    device_1
#    verify teams app signin page    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC6: [ZTP][Sign-in] For provisioning the phone, DUT needs to show UI to enter verification code
#    [Tags]  305280   sanity_pm
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    verify settings from signin page    device_1
#    verify provision phone option    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC7: [ZTP]Device login url on Landing page
#    [Tags]  305309
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud settings as public    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc high    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc dod    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud settings as public    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC8: [CP Enrollment] Re-enrollment with same user
#    [Tags]  305246    sanity_pm
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    sign in method  device=device_1   user=meeting_user
#    verify home page screen  device=device_1
#    sign out method  device=device_1
#    verify signin button on signin page  count=1
#    sign in method  device=device_1   user=meeting_user
#    verify home page screen  device=device_1
#    [Teardown]  Capture on Failure
#
#TC9: [CP Enrollment] Sending failure cases with invalid password in signin
#    [Tags]  305248
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    Verify signin with wrong password     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC10: [CP Enrollment] Unenrollment
#    [Tags]  305255
#    [Setup]  Testcase Setup for Meeting User  count=1
#    verify home page screen  device=device_1
#    sign out method  device=device_1
#    verify teams app signin page    device=device_1
#    [Teardown]  Capture on Failure
#
#*** Keywords ***
#ZTP Setup
#    sign out method  device_1