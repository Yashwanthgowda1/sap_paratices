*** Settings ***
Library     DateTime
Resource    ../../resources/keywords/common.robot

Suite Setup   ZTP Setup
Suite Teardown   Suite Failure Capture

*** Variables ***
${5_minutes_wait_time} =  5 minutes

*** Test Cases ***
TC1:[ZTP][Sign-in] Settings must provide options to provision phone
    [Tags]    314809    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    verify settings option from signin page    device=console_1
    [Teardown]  Run Keywords    Capture Failure    AND    Device setting back till signin btn visible    device=console_1

TC2:[ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone.
    [Tags]    314760    P1    sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    verify the signin ui for ztp    device=console_1
    [Teardown]  Capture Failure

TC3:[ZTP][Sign-in] Sign-in on this device should support username/password flow
    [Tags]    314766    P1
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    Console sign in method     console=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    [Teardown]  Run Keywords    Capture Failure    AND      Console sign out method   console=console_1     AND     verify teams app signin page    device=console_1

TC4:[CP Enrollment] No blocking GUI
    [Tags]    314780    P1
    [Setup]  Testcase Setup for shared User       count=1
    Validate user details along with home screen options    console=console_1:meeting_user
    Console sign out method   console=console_1
    verify teams app signin page    device=console_1
    [Teardown]  Capture Failure

TC5:[ZTP][Sign-in] User should able go back to sign-in page from cloud
    [Tags]    314831    P1
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=console_1
    verify settings from signin page    device=console_1
    verify cloud option   device=console_1
    navigate back to DCF sign in page    device=console_1
    verify teams app signin page    device=console_1
    [Teardown]  Capture Failure

TC6:[ZTP][Sign-in] Emergency call banner should always be available in signed out state
    [Tags]    314794    P1    sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    Verify emergency call label in sign in page     device=console_1
    [Teardown]  Capture Failure

TC7:[ZTP][Sign-in] For provisioning the phone, DUT needs to show UI to enter verification code and able to edit the verification code on provision phone screen
    [Tags]    314836    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=console_1
    verify settings from signin page    device=console_1
    Verify provision phone ui    device=console_1
    Verify able to edit the code on provision phone ui      device=console_1
    navigate back to DCF sign in page    device=console_1
    [Teardown]  Capture Failure

TC8:[CP Enrollment] Sending failure cases with invalid password in signin
    [Tags]    314774    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=console_1
    Verify signin with wrong password     device=console_1
    navigate back to DCF sign in page    device=console_1
    [Teardown]  Run Keywords    Capture Failure    AND    Device setting back btn     console=console_1

TC9:[CP Enrollment] Re-enrollment with different user
    [Tags]    314768    P1
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=console_1
    sign out method  device=device_1
    sign in method  device=device_1
    Console sign in method     console=console_1
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=user
    Verify signin is successful    console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    sign in method  device=device_1    user=meeting_user
    Console sign in method     console=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    [Teardown]  Run Keywords    Capture Failure    AND   Console sign out method   console=console_1

TC10:[CP Enrollment] Re-enrollment with same user
    [Tags]    314770    P1
    [Setup]  Testcase Setup for ZTP  count=1
    verify teams app signin page    device=console_1
    sign out method  device=device_1
    sign in method  device=device_1   user=meeting_user
    Console sign in method     console=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    Console sign out method   console=console_1
    sign out method  device=device_1
    verify signin button on signin page  count=1
    sign in method  device=device_1   user=meeting_user
    Console sign in method     console=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    [Teardown]  Run Keywords    Capture Failure    AND   Console sign out method   console=console_1

TC11:[ZTP][Sign-in] Selecting cloud option to provisioning the phone
    [Tags]    314817    P1
    [Setup]  Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    verify settings from signin page    device=console_1
    Verify cloud option to provisioning the Phone    device=console_1
    verify teams app signin page    device=console_1
    [Teardown]  Run Keywords    Capture Failure    AND     Device setting back btn     console=console_1

TC12:[CP Enrollment] Unenrollment
    [Tags]    314788    P2
    [Setup]  Testcase Setup for shared User       count=1
    Validate user details along with home screen options    console=console_1:meeting_user
    Console sign out method   console=console_1
    verify teams app signin page    device=console_1
    [Teardown]  Capture Failure

TC13:[ZTP][Sign-in] Teams App Sign-in options
    [Tags]    314758    P1
    [Setup]  Testcase Setup for ZTP    count=1
    verify the signin ui for ztp    device=console_1
    Verify presence of Intents        device=console_1         feature=keycode         state=absent
    [Teardown]  Capture Failure

TC14:[ZTP][Sign-in] User to sign-in from another device (web sign-in) with DCF code
    [Tags]    314764    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    ${old_dfc_code}=     fetch dfc code      device=console_1
    verify ztp signin ui    device=console_1
    Wait for Some Time    time=${5_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=console_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=console_1    status=different
    signin method with dcf code    device=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
    Verify signin is successful   console_list=console_1     state=Sign in
    Verify presence of Intents        device=console_1         feature=keycode         state=absent
    [Teardown]  Run keywords    Capture Failure     AND     Console sign out method   console=console_1

TC15:[ZTP] Welcome message should display at sign in page and able to dismiss setting pop up from DCF screen
    [Tags]    322339    P2
    [Setup]  Testcase Setup for ZTP    count=1
    Verify welcome message on dfc screen    device=console_1
    verify teams app signin page    device=console_1
    verify settings option from signin page    device=console_1
    verify teams app signin page    device=console_1
    [Teardown]  Capture Failure

TC16:[ZTP][Sign-in] User delay in sign-in from another device (web sign-in) and the button must be updated to refresh code
    [Tags]    314762    P2
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    Wait for Some Time    time=${5_minutes_wait_time}
    verify User delay in sign-in from device    device=console_1
    signin method with dcf code    device=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
    Verify signin is successful   console_list=console_1     state=Sign in
    Verify presence of Intents        device=console_1         feature=keycode         state=absent
    [Teardown]  Run keywords    Capture Failure     AND     Console sign out method   console=console_1

TC17:DUT should come back on DCF screen when tap on back button from device settings, cloud and provisioning screen
    [Tags]    418947    P2
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    verify settings from signin page    device=console_1
    navigate back to DCF sign in page    device=console_1
    verify settings from signin page    device=console_1
    verify cloud option   device=console_1
    navigate back to DCF sign in page    device=console_1
    verify settings from signin page    device=console_1
    Verify provision phone ui    device=console_1
    navigate back to DCF sign in page    device=console_1
    [Teardown]  Capture Failure

TC18:[ZTP]Selected cloud's options should not get deselect when tap on back button on cloud setting page
    [Tags]    322337    P2
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    verify settings from signin page    device=console_1
    verify cloud option   device=console_1
    verify login url with cloud setting as gcc    device=console_1
    verify settings from signin page    device=console_1
    verify cloud option   device=console_1
    verify cloud options selected or not    device=console_1    options=gcc
    verify login url with cloud settings as public    device=console_1
    [Teardown]  Capture Failure

TC19:[ZTP]Device login url on Landing page
    [Tags]       314893     P1
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page     device=console_1
    verify settings from signin page     device=console_1
    verify cloud option    device=console_1
    verify login url with cloud settings as public     device=console_1
    verify settings from signin page     device=console_1
    verify cloud option     device=console_1
    verify login url with cloud setting as gcc     device=console_1
    verify settings from signin page     device=console_1
    verify cloud option     device=console_1
    verify login url with cloud setting as gcc high     device=console_1
    verify settings from signin page     device=console_1
    verify cloud option     device=console_1
    verify login url with cloud setting as gcc dod     device=console_1
    verify settings from signin page     device=console_1
    verify cloud option     device=console_1
    verify login url with cloud settings as public     device=console_1
    [Teardown]  Capture Failure

TC20:Keyboard should pop up when go to the sign in page to enter the credentials
    [Tags]    418948    P2
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    click sign in on this device    device=console_1
    verify keyboard pop up while entering input    device=console_1    appear=yes
    navigate back to DCF sign in page    device=console_1

TC21:[License Stacking]TC User to verify sign in error with Personal account
    [Tags]    415277    P0     bvt_tc_sm    sanity_tc_sm
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    verify signin with license is not supported account used for signin norden     device=console_1:personal_policy_user
    [Teardown]  Run Keywords    Capture Failure    AND    Device setting back till signin btn visible    device=console_1

TC22: DUT user to verify the error message in sign in page, when user sign in with minimum set OS account.
    [Tags]    418697       P2        exclude_ftp_sm
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    verify signin with license is not supported account used for signin norden            device=console_1:minimum_os_account
    [Teardown]  Run Keywords    Capture Failure    AND    Device setting back till signin btn visible    device=console_1

TC23: DUT user to verify the error message in sign in page, when user sign in with maximun set OS account.
    [Tags]    418698        P2        exclude_ftp_sm
    [Setup]    Testcase Setup for ZTP    count=1
    verify teams app signin page    device=console_1
    verify signin with license is not supported account used for signin norden            device=console_1:maximum_os_account
    [Teardown]  Run Keywords    Capture Failure    AND    Device setting back till signin btn visible    device=console_1

*** Keywords ***
ZTP Setup
    Console sign out method   console=console_1

Verify cloud option to provisioning the Phone
    [Arguments]    ${device}
    verify cloud option    ${device}
    navigate back to signin page form cloud    device=${device}

navigate back to DCF sign in page
    [Arguments]    ${device}
    navigate back to signin page form cloud    device=${device}

verify User delay in sign-in from device
    [Arguments]     ${device}
    verify ztp signin ui        ${device}
