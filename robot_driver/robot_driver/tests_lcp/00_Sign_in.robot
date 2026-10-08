*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1: [Sign-in] User to Sign-in from web sign-in
    [Tags]  243622  bvt_lcp     sanity_lcp        Certification_lcp    auth_lcp    auth_lcp_p0
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2: [Sign in] DID of the user should be displayed on the Home screen
    [Tags]  243840  bvt_lcp     sanity_lcp    auth_lcp    auth_lcp_p0
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3: [Sign-out] User to Sign-out from existing account and Sign-in with a different account
    [Tags]  244254   bvt_lcp    sanity_lcp    auth_lcp    auth_lcp_p0
    [Setup]  Testcase Setup     count=2
    sign out  device_list=device_1
    verify signin ui on lcp  device=device_1
    signin method for lcp  device=device_1
    verify ui post signin  device=device_1
    navigate to calls tab    device=device_1
    navigate to calls favorites page    device=device_1
    come back to home screen page and verify    device=device_1
    navigate to people tab   device=device_1
    come back to home screen page and verify    device=device_1
    navigate to voicemail tab    device=device_1
    come back to home screen page and verify    device=device_1
    sign out  device_list=device_1
    verify signin ui on lcp  device=device_1
    signin method for lcp    device=device_1   user=device_2
    verify ui post signin  device=device_1      user_account=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1     AND     sign out  device_list=device_1     AND    Wait for Some Time    time=20    AND      signin method for lcp   device=device_1

TC4: [Sign-in] User to re sign-in multiple times to with same user via Web
    [Tags]  244260    auth_lcp
    [Setup]   Testcase Setup     count=1
    repeat keyword  3 times     signout and signin   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5: [Sign-in] User to Sign-in from web sign-in
    [Tags]      460730      bvt_lcp     sanity_lcp        Certification_lcp    auth_lcp    auth_lcp_p0
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    signout and signin   device=device_1
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6: [Sign-out] Sign-out from DUT
   [Tags]     460727      bvt_lcp         sanity_lcp        Certification_lcp    auth_lcp    auth_lcp_p0
   [Setup]  Testcase Setup     count=1
   sign out  device_list=device_1
   verify signin ui on lcp  device=device_1
   [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1     AND     signin method for lcp  device=device_1


*** Keywords ***
signout and signin
    [Arguments]  ${device}
    verify ui post signin  device=device_1
    sign out  device_list=device_1
    verify signin ui on lcp  device=device_1
    signin method for lcp   device=device_1