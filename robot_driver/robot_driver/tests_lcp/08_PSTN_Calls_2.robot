*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1: [Call Transfer] DUT user blind transfer one PSTN user call to another PSTN user
    [Tags]  244106      P1        Certification_lcp    sanity_lcp
    [Setup]  Testcase Setup for 2 PSTN User   count=3
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Verify call state and disconnect   device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Call Transfer] DUT user do consultative transfer one PSTN user call to another PSTN user
    [Tags]  244110      P2        Certification_lcp
    [Setup]  Testcase Setup for 2 PSTN User   count=3
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using phonenumber  from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Esc to Conf.] DUT user in call with PSTN user add PSTN user
    [Tags]  243785            Certification_lcp
    [Setup]  Testcase Setup for 2 PSTN User   count=3
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Call Forward] DUT user to forward one PSTN call to another PSTN user
    [Tags]  242932      sanity_lcp
    [Setup]  run keywords   Testcase Setup for 2 PSTN User   count=3   AND     Enable call forwarding and add contact   from_device=device_1    contact_device=device_2:pstn_user
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable Call forward lcp   devices=device_1,device_2,device_3

TC5: [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from another PSTN user
    [Tags]   243536      sanity_lcp
    [Setup]    run keywords   Testcase Setup for 2 PSTN User    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2:pstn_user
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Call Ring Teardown   devices=device_1,device_2,device_3

TC6 : [Call Merge] Verify that DUT user is able to Merge two PSTN calls
   [Tags]   318459
   [Setup]  Testcase Setup for 2 PSTN User   count=3
   navigate to calls tab  device=device_2
   Make outgoing call using phonenumber    from_device=device_2            to_device=device_1
   Pick incoming call    device=device_1
   verify call state   device_list=device_1,device_2   state=Connected
   navigate to calls tab  device=device_3
   Make outgoing call using phonenumber    from_device=device_3            to_device=device_1
   Pick incoming call   device=device_1
   verify call state    device_list=device_1,device_3     state=Connected
   Verify and merge call    device=device_1     from_device=device_2:pstn_user
   verify call state     device_list=device_1,device_2,device_3     state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Call Ring Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    Disable Also Ring    device=device_1

Disable Call forward lcp
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    open settings page  device=device_1
    disable call forwarding    device=device_1
