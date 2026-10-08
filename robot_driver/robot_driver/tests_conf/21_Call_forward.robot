*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Run Keywords        Suite Failure Capture        AND     Disable Call forward    devices=device_1,device_2,device_3

*** Variables ***
${wait_time1} =  10
${wait_time2} =  25

*** Test Cases ***
TC1 :[Call Forward] DUT user to forward the call to Call Group - Call from another DUT user
    [Tags]    316056
    [Setup]  Run Keywords   Testcase Meeting Setup for GCP User   count=3    AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward    devices=device_1,device_2,device_3

TC1 :[Call Forward] DUT user to forward TDC call to PSTN user
    [Tags]    316038     bvt_tpc     sanity_tpc  P0
    [Setup]  run keywords  Testcase Meeting PSTN Setup Main   count=3  AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_2:pstn_user
    click on calls tab      device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Wait for Some Time    time=${wait_time2}
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND  Call forward Teardown    devices=device_1,device_2,device_3

TC2: [Call Forward] DUT user to forward PSTN user call to TDC
    [Tags]  316040     P2
    [Setup]  run keywords  Testcase Meeting PSTN Setup Main    count=3    AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_3
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Wait for Some Time    time=${wait_time2}
    Verify incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND     Call forward Teardown    devices=device_1,device_2,device_3

TC3: [Call Forward] DUT user to forward one PSTN call to another PSTN user
    [Tags]   316039    P1
    [Setup]  Run Keywords   Testcase Meeting 2 PSTN Setup Main    count=3    AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_3:pstn_user
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Wait for Some Time    time=${wait_time2}
    Verify incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND      Call forward Teardown    devices=device_1,device_2,device_3

*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

Call forward Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
