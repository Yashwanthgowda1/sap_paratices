*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${10_minutes_wait_time} =   10 minutes

*** Test Cases ***
TC1: [Call Hold] DUT user hold the call with TDC
    [Tags]  318109
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  4 times     Hold and Resume the call
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2: [Call Hold] DUT user to hold the call with another DUT user
    [Tags]  244085
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  4 times     Hold and Resume the call
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: [Call Hold] DUT user can hold the call when it is already on hold from far-end
    [Tags]  244093      P2
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_2
    Verify Call State    device_list=device_2     state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Resume the call   device=device_2
    Verify Call State    device_list=device_1     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4: [Call Hold] DUT user can disconnect the call when it is already on hold from far-end
    [Tags]  244092      P2
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Wait for Some Time    time=${10_minutes_wait_time}
    Verify Call State    device_list=device_1,device_2     state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Call Hold] DUT user toggle hold/resume between two TDC users
    [Tags]  244086  sanity_lcp
    [Setup]  Testcase Setup    count=3
    navigate to people tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    resume call from call hold banner     device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    resume call from call hold banner     device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3


*** Keywords ***
Hold and Resume the call
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
