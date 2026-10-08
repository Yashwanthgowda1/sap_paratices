*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Run Keywords    Suite Failure Capture         AND     Disable Call forward lcp   devices=device_1

*** Variables ***


*** Test Cases ***
TC1: Verify Send to Voicemail option should not present for incoming forwarded group call notification
    [Tags]  452351    sanity_lcp      phonesCY23_4
    [Setup]  run keywords   Testcase Setup for GCP User   count=3   AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    verify group incoming call notification should not contains redirect to voicemail     device=device_2         from_device=device_3      to_device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3     AND     Disable Call forward lcp   devices=device_1

TC2: Verify DUT user able to forward the Private line call from TDC user to Call group
    [Tags]  476769  bvt_lcp    sanity_lcp
    [Setup]  run keywords   Testcase Setup for GCP User   count=3   AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1
    verify privateline label on call screen     device=device_1
    Verify incoming call    device=device_2     status=disappear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3     AND     Disable Call forward lcp   devices=device_1

TC3: [Call Forward] DUT user redirects unanswered calls to call group
    [Tags]  243603      sanity_lcp  
    [Setup]  run keywords   Testcase Setup for GCP User   count=3   AND     Enable unanswered call to call group     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Unanswered call Teardown   devices=device_1,device_2,device_3

*** Keywords ***
Disable Call forward lcp
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    open settings page  device=device_1
    disable call forwarding    device=device_1

Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2