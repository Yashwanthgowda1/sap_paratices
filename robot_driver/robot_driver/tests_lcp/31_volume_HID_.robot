*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***

TC1: [Volume] DUT user to test the volume hard button after sign-in
    [Tags]   243750    certification_audio    sanity_lcp
    [Setup]     Testcase Setup    count=1
    increase volume and verify    device=device_1    volume_stream=system
    decrease volume and verify    device=device_1    volume_stream=system
    [Teardown]   Capture on Failure