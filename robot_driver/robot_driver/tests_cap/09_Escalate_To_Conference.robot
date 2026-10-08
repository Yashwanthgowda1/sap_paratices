*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot
Resource    ../resources/keywords/call_keywords.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s

*** Test Cases ***
TC1 : [Esc to Conf.] DUT user in P2P call with Teams client, add another teams client
    [Tags]  148984    P1    bvt_cap  sanity_cap
    [Setup]  Testcase Setup for CAP User    count=3
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify participant list     from_device=device_1      connected_device_list=device_1:cap_search_enabled,device_2,device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3     state=Connected
    Verify participant list     from_device=device_1      connected_device_list=device_1:cap_search_enabled,device_3
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Esc to Conf.] DUT user in P2P call with Teams client, add another teams app user
    [Tags]  148987    P2
    [Setup]  Testcase Setup for CAP User    count=3
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify participant list     from_device=device_1      connected_device_list=device_1:cap_search_enabled,device_2,device_3
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Esc to Conf.] DUT user in P2P call with another DUT user, add Teams client to call
    [Tags]  148994      P2
    [Setup]     Testcase Setup for CAP User     count=3
    click on people tab    device=device_1
    Make outgoing call using display name  from_device=device_1     to_device=device_2
    pick incoming call  device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify participant list     from_device=device_1      connected_device_list=device_1:cap_search_enabled,device_2,device_3
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Esc to Conf.] DUT does not display video option when P2P call is escalated to conference
    [Tags]  149091      P2
    [Setup]  Testcase Setup for CAP User    count=3
    click on calls tab    device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify not have video option in conference window    device=device_1
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Esc-to-conf] Far-end user disconnect the call when DUT user is on "Add member" page
    [Tags]  150019    P2
    [Setup]  Testcase Setup for CAP User     count=2
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to add participant page    device_name=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Esc to Conf.] DUT user in P2P call with TDC, add another TDC and make an attendee
    [Tags]  333196    P1
    [Setup]  Testcase Setup for CAP User     count=3
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Make an attendee    from_device=device_1       to_device=device_3
    Verify you are an attendee now notification     device=device_3
    Verify add participant button should not visible for attendee    device=device_3
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3       state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [Esc to Conf.] DUT user in P2P call with TDC, add another TDC and make an Presenter
    [Tags]   333197   P2
    [Setup]  Testcase Setup for CAP User     count=3
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Make an attendee    from_device=device_1       to_device=device_3
    Verify you are an attendee now notification     device=device_3
    Verify add participant button should not visible for attendee    device=device_3
    Make an presenter    from_device=device_1       to_device=device_3
    Verify you are an presenter now notification     device=device_3
    Verify add participant button should visible for presenter    device=device_3
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3       state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
