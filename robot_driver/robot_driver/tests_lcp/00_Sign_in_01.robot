*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s
${16_minutes_wait_time} =  16 minutes


*** Test Cases ***
TC1 :[Auth] Verify DUT user is Sign in back with the same account via Web Sign after a Manual Sign out from the settings
    [Tags]    435867    ftp_lcp    sanity_LCP    p1
    [Setup]    Testcase Setup    count=1
    Sign out method    device_1
    signin method for lcp   device=device_1
    verify ui post signin  device=device_1
    [Teardown]    Run Keywords    Capture on Failure     AND    Test Case Teardown    device_1

TC2 :[Auth]Verify Web Sign-In using new DCF code after expiring the existing DCF code.
    [Tags]    435864   ftp_lcp   sanity_LCP    bvt_lcp    p0
    [Setup]    Testcase Setup    count=1
    Sign out method    device=device_1
    Wait for Some Time    time=${wait_time}
    ${old_dfc_code}=     fetch dfc code      device=device_1
    Wait for Some Time    time=${16_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=different
    signin method for lcp   device=device_1
    verify ui post signin  device=device_1
    [Teardown]    Run Keywords    Capture on Failure     AND    Test Case Teardown    device_1

TC3 :[Sign-in][Public]User to sign-in using Teams License Account.
    [Tags]    348302    p2
    [Setup]    Testcase Setup    count=1
    Sign out method    device=device_1
    verify signin ui on lcp  device=device_1
    Verify settings from signin page    device_1
    Verify cloud option   device_1
    navigate back to signin page form cloud    device_1
    verify signin ui on lcp  device=device_1
    signin method for lcp   device=device_1
    verify ui post signin  device=device_1
    [Teardown]    Run Keywords    Capture on Failure     AND    Test Case Teardown    device_1

TC4 :[Sign-in][Intune]User should be able to sign-in using DCF code using Intune License Account..
   [Tags]      348319    bvt_lcp    sanity_lcp    auth_lcp    auth_lcp_p0
   [Setup]  Testcase Setup    count=1
   sign out method  device=device_1
   Wait for Some Time    time=${wait_time}
   signin method for lcp  device=device_1    user=intune_user
   Wait for Some Time    time=${wait_time}
   verify user contact info        device=device_1:intune_user
   [Teardown]   Run Keywords    Capture on Failure     AND    Test Case Teardown    device_1
	

*** Keywords ***
Test Case Teardown
    [Arguments]     ${device}
    Sign out method     ${device}
    Wait for Some Time    time=${wait_time}
    signin method for lcp    ${device}