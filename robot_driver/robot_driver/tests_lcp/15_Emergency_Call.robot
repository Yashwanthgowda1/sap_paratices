*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture
*** Variables ***
${wait_time} =  15

*** Test Cases ***
TC1: [E911] Verify E911 call support
    [Tags]  243894      sanity_lcp      bvt_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=1
    navigate to people tab    device=device_1
    make emergency call lcp   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify emergency call state     device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2: [E911] Sign in to make an emergency call
    [Tags]  243898      sanity_lcp
    [Setup]  Testcase Setup     count=1
    sign out method    device_1
    Verify sign in to make an emergency call    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     signin method for lcp  device=device_1
