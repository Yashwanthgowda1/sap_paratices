*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1: [Outgoing Calls] DUT user calls TDC user from recent tab
    [Tags]  244064      sanity_lcp
    [Setup]  run keywords  Testcase Setup    count=2     AND     make outgoing call for call log     from_device=device_1      to_device=device_2
    Navigate to calls tab   device=device_1
    call from recent tab using call history  from_device=device_1      to_device=device_2
    verify incoming call  device=device_2   status=appear
    Pick incoming call    device=device_2
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2: [Outgoing Calls] DUT user call is rejected by TDC
    [Tags]  244071     sanity_lcp
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Rejects the incoming call    device_list=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: [Outgoing Calls] DUT user to make 2nd call
    [Tags]  244072    sanity_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Outgoing Calls] User to auto dial, when edited the invalid number
    [Tags]    244084
    [Setup]    Testcase Setup for PSTN User    count=2
    auto dial edited valid num from dial pad      from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5: [Outgoing Calls] DUT user calls TDC user using Dialpad hard keys
    [Tags]      244065    sanity_lcp
    [Setup]   Testcase Setup   count=2
    dail phone number from hard keys  device=device_1    to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call control visibility  device_list=device_1,device_2
    Disconnect call     device=device_1
    Wait for Some Time    time=${wait_time}
    verify ui post signin  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Multiple Call Banner] DUT user holds the outgoing call with TDC
    [Tags]  298900    P2
    [Setup]   Testcase Setup   count=2
    navigate to people tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    verify call state and disconnect    device=device_2,device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Multiple Call Banner] DUT user holds the outgoing call with DUT user
    [Tags]  298904    P2
    [Setup]   Testcase Setup   count=2
    navigate to people tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    verify call state and disconnect    device=device_2,device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Outgoing calls] DUT user to call TDC user using different options (DID, ext., from contacts)
   [Tags]      318501
   [Setup]  Testcase Setup    count=2
   navigate to calls tab  device=device_1
   Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
   Pick incoming call    device=device_2
   Wait for Some Time    time=${wait_time}
   Verify Call State    device_list=device_1,device_2    state=Connected
   Disconnect call    device=device_1
   Verify Call State    device_list=device_1,device_2     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    navigate to people tab  device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Come back to home screen    device_list=${from_device}
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}