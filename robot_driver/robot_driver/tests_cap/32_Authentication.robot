*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${16_minutes_wait_time} =  16 minutes


*** Test Cases ***
TC1: [Auth] Verify DUT user is Sign in back with the same account via Web Sign after a Manual Sign out from the settings
    [Tags]   435624   P1    sanity_cap
    [Setup]   Testcase Setup for CAP User  count=1
    sign out method   device=device_1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=cap_search_enabled
    [Teardown]    Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1


TC2: [Auth]Verify Web Sign-In using new DCF code after expiring the existing DCF code.
    [Tags]   435620    P0    bvt_cap   sanity_cap
    [Setup]  Testcase Setup for CAP User  count=1
    sign out method  device=device_1
    ${old_dfc_code}=     fetch dfc code      device=device_1
    Wait for Some Time    time=${16_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=different
    signin method with dcf code    device=device_1      user=cap_search_enabled
    [Teardown]  Capture on Failure

TC3 : [Sign-in][Public]User to sign-in using Teams License Account..
    [Tags]    348232    p2
    [Setup]    Testcase Setup for CAP User    count=1
    Sign out method    device=device_1
    verify settings from signin page    device=device_1
    verify cloud option    device_1
    navigate back to signin page form cloud    device_1
    Sign in method      device=device_1    user=cap_search_enabled
    verify home screen UI for cap     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Test Case Teardown    device_1    cap_search_enabled

TC4 : [Sign-in] [Public]User to sign-in using DCF code using Teams License Account.
    [Tags]    348230    sanity_cap    FTP_Scope    p1
    [Setup]    Testcase Setup for CAP User    count=1
    Sign out method    device=device_1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=cap_search_enabled
    verify home screen UI for cap     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Test Case Teardown    device_1    cap_search_enabled

TC5 : [Auth] Verify DUT user land into the Home page when the reboot is initiated
    [Tags]    435625    p2
    [Setup]    Testcase Setup for CAP User    count=1
    reboot phones    device=device_1
    verify home screen UI for cap     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Test Case Teardown    device_1    cap_search_enabled


*** Keywords ***
Test Case Teardown
    [Arguments]     ${device}    ${user}
    Sign out method     ${device}
    Wait for Some Time    time=10s
    Sign in method    ${device}    ${user}    