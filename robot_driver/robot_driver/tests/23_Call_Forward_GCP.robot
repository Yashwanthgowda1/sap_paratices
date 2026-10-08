*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Devices ensure to satisfy 'Testcase Setup for GCP User' setup

Suite Setup       Testcase Setup for GCP User   count=3
Suite Teardown    Suite Failure Capture


*** Test Cases ***
TC1 : [Call Forward]DUT user redirects unanswered calls to call group
    [Tags]   308318            bvt_pr  alt_blocked
    [Setup]  run keywords   Testcase Setup for GCP User   count=3   AND     Enable unanswered call to call group     from_device=device_1    contact_device=device_2
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    verify incoming call        device=device_1         status=appear
    wait until call disconnected    device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Unanswered call Teardown    devices=device_1,device_2,device_3

TC2 : [Simul-ring] DUT user can configure a call group to ring simultaneously for an incoming call from another DUT user
    [Tags]     307817    sanity_tp     bvt_pr  alt_blocked
    [Setup]     Run Keywords   Testcase Setup for GCP User   count=3    AND     verify and disable call forwarding    device=device_1   AND   Enable Also Ring Call group     device=device_1
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Verify call notification    device=device_2     status=appear
    Pick incoming call    device=device_1
    Verify call notification    device=device_2     status=disappear
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3

TC3 :Verify DUT user able to forward the Private line call from TDC user to Call group
    [Tags]  476404     P0       sanity_tp       bvt_tp
    [Setup]  Run Keywords   Testcase Setup for GCP User   count=3     AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    Click on calls tab   device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=disappear
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward    devices=device_1,device_2,device_3

TC4 : [Call Forward] DUT user to forward the call to Call Group - Call from PSTN user
    [Tags]  307837   advance_calling         bvt_pr  alt_blocked
    [Setup]  Run Keywords   Testcase Setup for GCP PSTN User    count=3    AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward    devices=device_1,device_2,device_3

*** Keywords ***
Unanswered call Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    Come back to home screen    device_list=device_1,device_2,device_3
    Disable unanswered call    device=device_1      contact_device=device_2

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

Call Ring Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    Disable Also Ring    device=device_1

