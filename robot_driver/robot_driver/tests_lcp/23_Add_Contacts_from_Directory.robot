*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1: [Add contacts from directory] [People] DUT user to accept the incoming call while in "Add to directory" page in people tab
    [Tags]  452660      sanity_lcp
    [Setup]  Testcase Setup     count=2
    Navigate to Add from directory screen     device=device_1
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify add from directory page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2