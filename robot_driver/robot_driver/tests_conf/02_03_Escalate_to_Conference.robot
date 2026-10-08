*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Esc-to-conf] Far-end user disconnects the call when DUT user is on "Add member" page
   [Tags]     305994
   [Setup]  Testcase Setup for Meeting User    count=2
   Navigate to people tab    device=device_1
   Make outgoing call using display name    from_device=device_1      to_device=device_2
   Pick incoming call    device=device_2
   Wait for Some Time    time=${wait_time}
   Verify Call State    device_list=device_1,device_2    state=Connected
   navigate to add participant page   device_name=device_1
   disconnect call       device=device_2
   Verify Call State    device_list=device_1     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Esc to Conf.] DUT user in P2P call with TDC, adds another DUT user
   [Tags]       305859
   [Setup]   Testcase Setup for Meeting User     count=3
   Navigate to people tab    device=device_1
   Make outgoing call using display name    from_device=device_1      to_device=device_3
   Pick incoming call    device=device_3
   Wait for Some Time    time=${wait_time}
   Verify Call State    device_list=device_1,device_3    state=Connected
   Add participant to conversation using display name   from_device=device_1      to_device=device_2
   Pick incoming call    device=device_2
   Wait for Some Time    time=${wait_time}
   Verify Call State    device_list=device_1,device_2,device_3    state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Esc to Conf.] DUT user in P2P call with another DUT user, adds TDC to call
    [Tags]  305861     P1
    [Setup]  Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    disconnect call       device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Esc to Conf.] DUT user in P2P call with TDC, adds another DUT user
    [Tags]    305857
    [Setup]  Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3     state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_3
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
