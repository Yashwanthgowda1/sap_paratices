*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation   Suite Setup Requirements : This suite requires minimum of 1 devices in config
...             Purpose : Device_1 should be sign-out

Suite Setup  ZTP Setup
Suite Teardown    Run keyword and ignore error   ZTP Teardown

*** Variables ***
${wait_time} =  10
${wait_time2} =  15
${wait_time3} =  30
${16_minutes_wait_time} =  16 minutes

*** Test Cases ***
TC 1 : [ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone.
    [Tags]  311592   sanity_tp    P1    auth_audio
    [Setup]  Testcase Setup for ZTP    count=1
    verify the signin ui for ztp    device=device_1
    [Teardown]  Capture on Failure

TC 2 : [CP Enrollment] Sending failure cases with invalid password in signin
    [Tags]  311606    P1        bvt_pr    auth_audio
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    Verify signin with wrong password     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 3 : [CP Enrollment] No blocking GUI
    [Tags]  311612    P1    auth_audio
    [Setup]  run keywords  Testcase Setup for ZTP    count=1    AND    sign in method    device_1   AND    verify device users  device_list=device_1
    sign out method   device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 4 : [ZTP][Sign-in] Settings must provide options to provision phone
    [Tags]  311644    P0    bvt_tp   sanity_tp      bvt_pr    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=device_1
    verify settings option from signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 5 : [ZTP][Sign-in] Selecting cloud option to provisioning the phone
    [Tags]  311653    P1            bvt_pr    auth_audio
    [Setup]  Testcase setup for ztp    count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option for provisioning device    device_1
    verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 6 : [ZTP][Sign-in] User should able go back to sign-in page from cloud
    [Tags]  311668    P1    auth_audio
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option   device_1
    navigate back to signin page form cloud    device_1
    verify teams app signin page    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 7 : [ZTP][Sign-in] For provisioning the phone, Teams App needs to show UI to enter verification code
    [Tags]  311674   sanity_tp    P1    auth_audio
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify provision phone option    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 8 : [ZTP]Device login url on Landing page
    [Tags]  311731    P1    auth_audio
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

TC 9 : [Device Settings] DUT user to access Device Settings from Sign-in page
    [Tags]  307691   P1     Certification_audio    auth_audio
    [Setup]  Testcase Setup for ZTP  count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 10 : [ZTP]Teams app user can access the device setting from Sign in page.
    [Tags]  320260   P2    auth_audio
    [Setup]  Testcase Setup for ZTP  count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 11 : Teams app should come back on Sign in screen when tap on back button from Provision Phone
    [Tags]     321113      P2    auth_audio
    [Setup]  Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    verify provision phone ui   device=device_1
    click back  device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 12 : [ZTP]Teams app should come back on sign in screen when tap on back button from device settings screen
    [Tags]  321140     P2    auth_audio
    [Setup]  Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 13: [Phone Licensing] Verify user is blocked to sign in with Microsoft Teams Rooms Basic (new) license with user policy
    [Tags]      381607      sanity_tp     P1    auth_audio
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 14: [Phone Licensing]Verify "Sign-In error" message should be display when an license is Not supported for an account used to sign into a Teams
    [Tags]      381577      sanity_tp     P1    auth_audio
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 15: [Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when user signs in with an unsupported account.
    [Tags]      346128         P1    auth_audio
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with unsupported account for phones       device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 16: [License Stacking] Verify DUT user is blocked to signed with Room (Basic) license with Personal policy enabled account.
    [Tags]      419786      P0    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:mtra_basic_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 17:DUT user to verify the error message in sign in page, when user sign in with maximum set OS account.
    [Tags]      346195    p1    sanity_tp    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:maximum_os_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 18: DUT user to verify the error message in sign in page, when user sign in with minimum set OS account
    [Tags]      346193    P1    sanity_tp    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:minimum_os_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 19: [Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when sign in with enrollment restriction account.
    [Tags]      346177        P1        sanity_tp    auth_audio    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:enrollment_restrict_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC 20: [License Stacking] Verify DUT should display Personal UI, when user sign in with TSD + User/Personal License + MTR Pro License with Personal policy assigned account
    [Tags]       419798        P0        sanity_tp      bvt_tp    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:cap_mtra_pro_license_with_personal_policy_assigned_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC 21:[License Stacking] Verify DUT should display Personal UI, when user sign in with TSD + User/Personal License with Personal policy assigned account.
    [Tags]       419797       P0        sanity_tp      bvt_tp    auth_audio    auth_audio_p0
    [Setup]  Testcase Setup for ZTP    count=1
    verify signin with license is not supported account used for signin phones       device=device_1:cap_personal_license_with_personal_policy_assigned_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC22: [Sign in]Sign in with CAP License and Meeting sign in policy assigned accounts should lunch CAP UI mode
    [Tags]  311883      P2    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=CAP_License_and_Meeting_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify homescreen for cap policy account    device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]    Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC23: [Sign in]Sign in with CAP License and CAP sign in policy assigned account should launch CAP UI mode
    [Tags]   311881      P2    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=CAP_License_and_CAP_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify homescreen for cap policy account    device=device_1
     Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]   Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC24: [Sign in]Sign in with Personal License and Meeting sign in policy assigned accounts should launch Personal UI mode.
    [Tags]   311878      P2    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Personal_License_and_Meeting_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify home screen tiles     device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC25: [Sign in]sign in with Personal License and CAP sign in policy assigned accounts should launch CAP UI
    [Tags]   311876      P2     exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Personal_License_and_CAP_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify homescreen for cap policy account    device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]   Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC26: [Sign in]Sign in with Personal License and User sign in policy assigned accounts should launch Personal UI mode
    [Tags]   311874      P2     exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Personal_License_and_User_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify home screen tiles     device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC27: [Sign in]Sign in with CAP License and User sign in policy assigned accounts should launch Personal UI mode
    [Tags]   311880      P2     exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=CAP_License_and_User_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify homescreen for cap policy account    device=device_1    cap_premium=enabled
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC28: [License Stacking] Verify DUT should display Advanced CAP UI, when user sign in with TSD + MTR Basic License with Personal policy assigned account
    [Tags]  419803    bvt_tp   sanity_tp    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=cap_basic_personal_policy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify homescreen for cap policy account    device=device_1    cap_premium=enabled
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC29: [License Stacking] Verify DUT should display Personal UI, when user sign in with User/Personal License + MTR Basic with Personal policy assigned account
    [Tags]  419802    bvt_tp   sanity_tp    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Personal_Basic_Personal_Policy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify home screen tiles     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC30: [License Stacking] Verify DUT should display Personal UI, when user sign in with TSD + User/Personal License + MTR standard License with Personal policy assigned account
    [Tags]  419799    sanity_tp    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=cappersonal_standard_personalpolicy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify home screen tiles     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC31: [License Stacking] Verify DUT should display Conference UI, when user sign in with TSD + MTR Standard License with Personal policy assigned account.
    [Tags]   419795    P1    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=CAPStandard_PersonalPolicy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify home screen for cnf device   device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC32: [License Stacking] Verify DUT should display Conference UI, when user sign in with TSD + MTR Pro License & Personal policy assigned account.
    [Tags]   419794    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=cappro_personal_policy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify home screen for cnf device   device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC33: [License Stacking] Verify DUT should display Personal UI, when user sign in with User/Personal License + MTR Standard License & Personal policy assigned account
    [Tags]  419791   P1      exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Personalstandard_personalpolicy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify home screen tiles     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC34: [License Stacking] Verify DUT should display Advanced CAP UI, when user sign in with CAP/TSD License with Personal Policy account.
    [Tags]  419790     bvt_tp    sanity_tp   exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=CAP_License_and_User_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify homescreen for cap policy account    device=device_1    cap_premium=enabled
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC35: [License Stacking] Verify DUT should display Personal UI, when user signs in with User/Personal License + MTR Premium License & Personal policy assigned account.
    [Tags]   419793    sanity_tp     exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=personalpremium_personalpolicy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify home screen tiles     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC36: [License Stacking] Verify DUT should display Conference UI, when user sign in with TSD + MTR Premium License with Personal policy assigned account
    [Tags]   419796    exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=cappremium_personalpolicy_assigned_account
    verify home screen for cnf device   device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC37: [License Stacking] Verify DUT should display Personal UI, when user signs in with TSD + User/Personal License + MTR Premium License with Personal assigned account
    [Tags]  419801   P1      exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=cappersonalpremium_personalpolicy_assigned_account
    Wait for Some Time    time=${wait_time2}
    verify home screen tiles     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC38: [License Stacking] Verify DUT should display Conference UI, when user sign with Room (Standard) license with Personal Policy account
    [Tags]   419787     exclude_ftp
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=standard_resource_assigned_account
    verify home screen for cnf device   device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC39: [Sign-in][Public]User to sign-in using Teams License Account.
    [Tags]  346123    P2
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device_1
    verify cloud option   device_1
    navigate back to signin page form cloud    device_1
    verify teams app signin page    device_1
    Sign in method     device_1
    Wait for Some Time    time=${wait_time}
    Verify home screen page     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     Sign out method   device=device_1

TC40: [Sign-in][Intune]User should be able to sign-in using Non-Intune License Account.
    [Tags]  346203    P2
    [Setup]  Testcase Setup for ZTP  count=1
    Sign in method     device_1
    Wait for Some Time    time=${wait_time}
    Verify home screen page     device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     Sign out method   device=device_1

TC41: [Sign-in] [Public]User to sign-in using DCF code using Teams License Account.
    [Tags]    346119     sanity_tp   P1
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=user
    Wait for Some Time    time=${wait_time}
    Verify home screen page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC42: [Sign-in][Intune]User should be able to sign-in code using AADP1 License Account.
    [Tags]   346200    P2
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=aadp_license_account
    Wait for Some Time    time=${wait_time}
    verify that sign in is successful     device_list=device_1     state=sign in
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC43: [Sign-in][AADP1]User should be able to sign-in using DCF code using AADP1 License Account.
    [Tags]    346202     P2
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=aadp_license_account
    Wait for Some Time    time=${wait_time3}
    verify that sign in is successful     device_list=device_1     state=sign in
    [Teardown]   Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC44: [Sign in] Date and time should be available on sign in screen
    [Tags]    320114     P2
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify date and time on sign in screen    device=device_1
    [Teardown]   Capture on Failure

TC45: [License Stacking] Verify UI, when user signed with CAP/TSD License & Basic CAP Policy assigned account
    [Tags]   451551     P2
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=CAP_License_and_CAP_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify homescreen for cap policy account    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Sign out method    device_1

TC46: [License Stacking] Verify UI, when user sign with CAP License with Personal policy enabled account.
    [Tags]   451550     P2
    [Setup]  Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=CAP_License_and_User_sign_in_policy_assigned_account
    Wait for Some Time    time=${wait_time}
    verify homescreen for cap policy account    device=device_1    cap_premium=enabled
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC47 : [CP Enrollment] Device should be enrolled with Intune licence account
    [Tags]    311633       P1
    [Setup]  Testcase Setup     count=1
    teams restart auth     device_name=device_1
    signin method with dcf code    device=device_1    user=intune_user
    Verify presence of Intents     device=device_1      feature=user_password       state=absent
    [Teardown]   Capture on Failure

TC48 : [CP Enrollment] Changing auth mode
    [Tags]    311608        P1
    [Setup]  Testcase Setup     count=1
    teams restart auth     device_name=device_1
    signin method with dcf code    device=device_1    user=user
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]   Run Keywords    Capture on Failure     AND    Sign out method    device=device_1


TC49 : [CP Enrollment] Device should be enrolled with non-Intune licence account
    [Tags]    311624        P1
    [Setup]  Testcase Setup     count=1
    teams restart auth     device_name=device_1
    signin method with dcf code    device=device_1    user=user
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]   Run Keywords    Capture on Failure     AND    Sign out method    device=device_1

TC50: [CP Enrollment] Re-enrollment with same user
    [Tags]    311602    P1               sanity_tp
    [Setup]    Testcase Setup for ZTP    count=1
    Teams Restart Auth     device_name=device_1
    Sign In Method    device=device_1
    Wait For Some Time    time=10s
    Sign Out Method    device=device_1
    Sign In Method    device=device_1
    Wait For Some Time    time=10s
    Verify Presence Of Intents    device=device_1    feature=user_password    state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device=device_1

TC51: [CP Enrollment] Re-enrollment with different user
    [Tags]    311600    P1   
    [Setup]    Testcase Setup   count=2
    Teams Restart Auth     device_name=device_1
    Wait For Some Time    time=${wait_time2}
    Sign In Method    device=device_1
    Sign Out Method    device=device_1
    Wait For Some Time    time=${wait_time}
    Signin with other user    device=device_1   other_user_account=device_2:user
    Verify Presence Of Intents    device=device_1    feature=user_password    state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device=device_1

TC52: [ZTP]Teams app user should able to edit the verification code on provision phone screen
    [Tags]    320306    p2
    [Setup]    Testcase Setup for ZTP    count=1
    verify settings from signin page    device=device_1
    verify provision phone ui   device=device_1
    Verify able to edit the code on provision phone ui      device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC53: [ZTP][Sign-in] User to sign-in from another device (web sign-in) with DCF code
    [Tags]    311596    bvt_tp     sanity_tp    smoke_tp    p0
    [Setup]    Testcase Setup for ZTP    count=1
    Teams Restart Auth     device_name=device_1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=user
    Wait for Some Time    time=10s
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    verify that sign in is successful     device_list=device_1     state=sign in
    [Teardown]   Run Keywords    Capture on Failure     AND    Sign out method    device=device_1

TC54: [CP Enrollment] DCF Time out
    [Tags]      311604          sanity_tp
    [Setup]  Testcase Setup  count=1
    Teams Restart Auth     device_name=device_1
    verify teams app signin page    device=device_1
    ${old_dfc_code}=     fetch dfc code      device=device_1
    Wait for Some Time    time=${16_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=different
    sign in by invalid dcf code    device=device_1    invalid_dcf_code=${old_dfc_code}        user=user
    [Teardown]   Run Keywords    Capture on Failure     AND    Sign out method    device=device_1
 
TC55: [ZTP][Sign-in] Sign-in on this device should support username/password flow
    [Tags]        311598        sanity_tp    p1
    [Setup]    Testcase Setup for ZTP    count=1
    Teams Restart Auth     device_name=device_1
    verify teams app signin page    device=device_1
    Sign In Method    device=device_1
    Verify Presence Of Intents    device=device_1    feature=user_password    state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device=device_1

TC56 : [License Stacking] Verify DUT should display Personal UI, when user sign with User/Personal License with Personal policy enabled account.
    [Tags]    419783    sanity_tp    bvt_tp
    [Setup]    Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Personal_License_and_User_sign_in_policy_assigned_account
    verify home screen tiles     device=device_1
    verify home screen date and time for cnf device     device=device_1
    Open settings page   device=device_1
    return to home screen    device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device_1

TC57 : [Sign in]Sign in with Meeting License and Meeting sign in policy assigned accounts should launch Meeting UI mode
    [Tags]    311889
    [Setup]    Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Meeting_License_Meeting_sign_in_policy
    Wait for Some Time    time=10s
    verify home screen for cnf device    device=device_1
    Verify Presence Of Intents    device=device_1    feature=user_password    state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device=device_1

TC58 : [Sign in]Sign in with Meeting License and CAP sign in policy assigned accounts should launch Meeting UI mode
    [Tags]    311887
    [Setup]    Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Meeting_License_CAP_sign_in_policy
    Wait for Some Time    time=10s
    verify home screen for cnf device    device=device_1
    Verify Presence Of Intents    device=device_1    feature=user_password    state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device=device_1

TC59 : [Sign in]Sign in with Meeting License and User sign in policy assigned accounts should launch Meeting UI mode
    [Tags]    311885
    [Setup]    Testcase Setup for ZTP    count=1
    Sign in method      device=device_1      user=Meeting_License_User_sign_in_policy
    Wait for Some Time    time=10s
    verify home screen for cnf device    device=device_1
    Verify Presence Of Intents    device=device_1    feature=user_password    state=absent
    [Teardown]  Run Keywords    Capture on Failure   AND    Sign out method    device=device_1

TC60: [ZTP][Sign-in] Date and time should be available on welcome and Sign-in page
    [Tags]    311628
    [Setup]    Testcase Setup for ZTP    count=1
    Teams Restart Auth    device_name=device_1
    Wait For Some Time    time=10s
    Verify Date And Time On Sign In Screen    device=device_1
    Click Sign In On This Device    device=device_1
    Verify Date And Time On Sign In Screen    device=device_1
    [Teardown]    Capture On Failure

TC61: [ZTP][Sign-in] Emergency call banner should always be available in signed out state
    [Tags]    311626    sanity_tp
    [Setup]    Testcase Setup for ZTP    count=1
    Teams Restart Auth     device_name=device_1
    verify teams app signin page    device=device_1
    verify emergency call label in sign in page    device=device_1
    [Teardown]  Capture on Failure

TC62: [ZTP]Teams app should be able to find out the MAC id of device and able to select the time zone of device
    [Tags]    321146
    [Setup]    Testcase Setup for ZTP    count=1
    Teams Restart Auth     device_name=device_1
    verify MAC id in about in device settings    device=device_1
    verify time and date in device setting page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC63:[ZTP][Sign-in] User delay in sign-in from another device (web sign-in) and the button must be updated to refresh code
    [Tags]    311594      P1    sanity_tp
    [Setup]   Testcase Setup for ZTP    count=1
    verify ztp signin ui   device=device_1
    signin method with dcf code    device=device_1
    Verify home screen page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Sign out method    device=device_1

TC64 : [ZTP][Sign-in] For provisioning the phone, user try to register in public cloud with invalid code
    [Tags]    311698
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=device_1
    verify settings from signin page    device=device_1
    verify cloud option    device=device_1
    Device setting back till signin btn visible    device=device_1
    verify settings from signin page    device=device_1
    verify provision phone option    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC65 : [License Stacking] Verify DUT should display Personal UI, when user signs in with User/Personal License + MTR Pro License with Personal policy assigned account.
    [Tags]    419792    sanity_tp    exclude_ftp
    [Setup]  Testcase Setup for ZTP  count=1
    Sign in method      device=device_1      user=Personal_License_and_MTR_Pro_License_with_Personal_policy_assigned_account
    Wait for Some Time    time=10s
    Verify home screen page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Sign out method    device=device_1

TC66 : [Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when user signs in with DA enrollment disabled account.
    [Tags]    346152
    [Setup]  Testcase Setup for ZTP  count=1
    verify signin with license is not supported account used for signin phones       device=device_1:DA_enrollment_disabled_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC67 : [Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when user sign in with Invalid OS set account.
    [Tags]    346163    sanity_tp    bvt_tp
    [Setup]  Testcase Setup for ZTP  count=1
    verify signin with license is not supported account used for signin phones       device=device_1:invalid_OS_set_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC68 : [Expose CP errors during sign-in]DUT user to verify the error message in sign in page, when user sign in with manufacture blocked account.
    [Tags]    346169    sanity_tp    bvt_tp
    [Setup]  Testcase Setup for ZTP  count=1
    verify signin with license is not supported account used for signin phones       device=device_1:manufacture_blocked_account
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1


#Test case removed due to following bug - Bug 4100287: [MTRA]Report an issue option is missing under settings.
#TC48 : [ZTP]Teams app user should able to report an issue at sign in page
#      [Tags]   320956     P2    auth_audio
#      [Setup]  Testcase Setup for ZTP    count=1
#      report an issue from signin page    device=device_1
#      [Teardown]  Run Keywords    Capture on Failure    AND     go back to previous page    device=device_1

*** Keywords ***
ZTP Setup
    sign out method  device_1

ZTP Teardown
    Suite Failure Capture
    sign in method     device_1