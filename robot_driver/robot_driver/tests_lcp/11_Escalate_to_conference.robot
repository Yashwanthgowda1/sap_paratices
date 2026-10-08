*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =      5

*** Test Cases ***
TC1: [Esc to Conf.] DUT user in P2P call with Teams client, adds another Teams client
    [Tags]  243219
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Esc-to-conf] Far-end user disconnects the call when DUT user is on "Add member" page
    [Tags]  243845
    [Setup]  Testcase Setup   count=2
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to add participant page    device_name=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Esc to Conf.] DUT user in P2P call with TDC, add another TDC and make an attendee
    [Tags]    333190    P1
    [Setup]    Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
    Make an attendee    from_device=device_1       to_device=device_3
    Verify you are an attendee now notification     device=device_3
    Verify add participant button should not visible for attendee    device=device_3
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Esc to Conf.] DUT user in P2P call with TDC, add another TDC and make an Presenter
    [Tags]    333191    P1
    [Setup]    Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
    Make an attendee    from_device=device_1       to_device=device_3
    Verify you are an attendee now notification     device=device_3
    Verify add participant button should not visible for attendee    device=device_3
    Make an presenter    from_device=device_1       to_device=device_3
    Verify you are an presenter now notification     device=device_3
    Verify add participant button should visible for presenter    device=device_3
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3


