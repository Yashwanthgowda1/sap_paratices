*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [E911] Sign in to make an emergency call
    [Tags]  306008
    [Setup]  Testcase Setup for Meeting User    count=1
    sign out method    device_1
    Verify sign in to make an emergency call    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     Sign in method     device=device_1   user=meeting_user

TC2 : [E911] Verify E911 call support
    [Tags]  306007  bvt_tpc  sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to Calendar tab   device=device_1
    verify dial pad for conference    device=device_1
    Dial emergency num and validate    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC3: [Emergency Location] Verify "Emergency Location” section is available under Settings -> Calling tab
    [Tags]    382126     P0     bvt_tpc  sanity_tpc
    [Setup]  Testcase Setup for Meeting User    count=1
    verify emergency location option under callings settings    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

*** Keywords ***
