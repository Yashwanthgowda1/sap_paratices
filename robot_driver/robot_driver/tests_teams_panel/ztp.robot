*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup  ZTP Setup
Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[ZTP][Sign-in] DUT Sign-in options
    [Tags]  307733   sanity     bvt_panels_pr
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    [Teardown]  Capture on Failure

TC2:[ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone.
    [Tags]  307736   sanity     bvt_panels_pr
    [Setup]  Testcase Setup for ZTP    count=1
    verify the signin ui for ztp    device=device_1
    [Teardown]  Capture on Failure

TC3:[CP Enrollment] Sending failure cases with invalid password in signin
    [Tags]  307762
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC4:[ZTP][Sign-in] Settings must provide options to provision phone
    [Tags]  307829   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings option from signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC5:[ZTP][Sign-in] Selecting cloud option to provisioning the phone
    [Tags]  307845
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option for provisioning device    device_1
    verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC6:[ZTP][Sign-in] User should able go back to sign-in page from cloud
    [Tags]  307866
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option   device_1
    navigate back to signin page form cloud    device_1
    verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC7:[ZTP][Sign-in] For provisioning the phone, Teams App needs to show UI to enter verification code
    [Tags]  307872   sanity      bvt_panels_pr
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify provision phone option    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC8:[CP Enrollment] Re-enrollment with different user
    [Tags]  307752
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    sign in method  device_1
    verify room parameters    device=device_1
    Signin with other user    device=device_1   other_user_account=device_1:cap_user
    [Teardown]  Run Keywords    Capture on Failure    AND   sign out method     device=device_1     AND    Device setting back till signin btn visible    device=device_1

TC9:[CP Enrollment] Re-enrollment with same user
    [Tags]  307756   sanity
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    sign in method  device_1
    verify room parameters    device=device_1
    sign out method  device_1
    verify teams app signin page    device=device_1
    sign in method  device_1
    verify room parameters    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND   sign out method     device=device_1     AND    Device setting back till signin btn visible    device=device_1

TC10:[CP Enrollment] No blocking GUI
    [Tags]  307771
    [Setup]  run keywords  Testcase Setup for ZTP    count=1    AND    sign in method    device_1   AND    verify device users  device_list=device_1
    sign out method  device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC11:[CP Enrollment] Unenrollment
    [Tags]  307785
    [Setup]  run keywords  Testcase Setup for ZTP    count=1    AND    sign in method    device_1   AND    verify device users  device_list=device_1
    sign out method  device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC12:[Sign-in] Verify DCF code after performing screen transition
	[Tags]   339589
	[Setup]  Testcase Setup for ZTP  count=1
	verify teams app signin page    device=device_1
    ${old_dfc_code} =     fetch dfc code      device=device_1
    verify settings from signin page    device_1
    verify cloud option    device_1
    Come back to home screen    device_list=device_1
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=same
    verify settings from signin page    device_1
    verify provision phone ui       device_1
    Come back to home screen    device_list=device_1
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=same
    verify settings from signin page    device_1
    Come back to home screen    device_list=device_1
    #verify report an issue      device_1
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}      device=device_1    status=same
    verify settings from signin page    device_1
    verify device settings page for ztp panel  device=device_1
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}       ${new_dfc_code}     device=device_1     status=same
    verify settings from signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC13:[Admin settings] DUT user to access Device Settings from Sign-in page
	[Tags]   307462   sanity     bvt_panels_pr
	[Setup]  Testcase Setup for ZTP  count=1
	verify teams app signin page    device=device_1
	verify settings from signin page    device_1
	verify device settings page for ztp panel  device=device_1
	verify settings from signin page    device_1
	[Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC14:[Device settings] DUT user to access Device Settings from Sign-in page
	[Tags]   321927
	[Setup]  Testcase Setup for ZTP  count=1
	verify teams app signin page    device=device_1
	verify settings from signin page    device_1
	verify device settings page for ztp panel  device=device_1
	verify settings from signin page    device_1
	[Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC15:[ZTP][Sign-in] User to sign-in from another device (web sign-in) with DCF code
    [Tags]  307744    bvt   sanity   smoke_panels	 bvt_panels     AA_Panels   CP_Panels
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=user
    verify room parameters    device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]     Run Keywords    Capture on Failure    AND    sign out method    device_1

TC16:[ZTP][Sign-in] Sign-in on this device should support username/password flow
    [Tags]  307746     sanity   AA_Panels   CP_Panels    bvt_panels_pr
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    sign in method  device_1
    verify room parameters    device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]    Capture on Failure

*** Keywords ***
ZTP Setup
    sign out method  device_1