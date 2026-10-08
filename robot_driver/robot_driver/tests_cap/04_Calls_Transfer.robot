*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Call Transfer] DUT user blind transfer one Teams client call to another Teams client
    [Tags]  148725   P1    bvt_cap   sanity_cap
    [Setup]  Testcase Setup for CAP User    count=3
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Verify display name on call toast   to_device=device_3    from_device=device_2
    Pick incoming call    device=device_3
    Verify call state and disconnect   device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Call Transfer] DUT user consultative transfer the teams client's call to another teams client
    [Tags]  148962  P2
    [Setup]  Testcase Setup for CAP User   count=3
    click on calls tab    device=device_3
    Make outgoing call using display name  from_device=device_3     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_2
    Verify user name display on call toast   to_device=device_2    from_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Call Transfer] DUT user to blind transfer the Teams client's call to another Teams client who is on DND
    [Tags]   148963     P2
    [Setup]     run keywords  Testcase Setup for CAP User    count=3     AND     Select user presence     device=device_3     state=DND
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=Disappear
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Select user presence     device=device_3     state=Available    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Call Transfer] DUT user to consult transfer the Desktop teams client call to another DUT user
    [Tags]  150048  P2
    [Setup]  Testcase Setup for CAP User   count=3
    click on people tab     device=device_1
    Make outgoing call using display name  from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_2
    Verify user name display on call toast   to_device=device_2    from_device=device_1:cap_search_enabled
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Call Transfer] DUT user to transfer the teams client call to another DUT user
    [Tags]  148974  P2
    [Setup]  Testcase Setup for CAP User   count=3
    click on people tab    device=device_1
    Make outgoing call using display name  from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_2
    Verify display name on call toast   to_device=device_2    from_device=device_3
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

