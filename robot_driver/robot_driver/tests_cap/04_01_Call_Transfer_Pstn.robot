*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  15
${wait_time3} =  40

*** Test Cases ***
TC1 : [Call Transfer] DUT user blind transfers the PSTN call to teams client
    [Tags]  148726  P2        Certification_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=3
    click on people tab     device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Call Transfer] DUT user to transfer the PSTN call to another DUT user
    [Tags]  148976  P2   sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=3
    click on people tab     device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Call Transfer] DUT user blind transfer the teams client call to PSTN
    [Tags]  148727  P2  bvt_cap  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=3
    click on people tab     device=device_1
    Make outgoing call using display name  from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Blindtransfers the call using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Call Transfer] DUT user blind transfer one PSTN user call to another PSTN user
    [Tags]  148729  P1   sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP 2 PSTN User   count=3
    click on calls tab    device=device_2
    Make outgoing call using phonenumber  from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using phonenumber   from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Call Transfer] DUT user do consultative transfer one PSTN user call to another PSTN user
    [Tags]  148730  P2        Certification_cap
    [Setup]  Testcase Setup for CAP 2 PSTN User   count=3
    click on calls tab    device=device_2
    Make outgoing call using phonenumber  from_device=device_2    to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using phonenumber   from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Call Transfer] DUT user End the call while consultative transfers the PSTN call to TDC
    [Tags]    339419      P2
    [Setup]  Testcase Setup for CAP PSTN User    count=3
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_2,device_1
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [Call Transfer] TDC user End the call while consultative transfers the PSTN call from DUT
    [Tags]   339420      P2
    [Setup]    Run Keywords   Testcase Setup for CAP PSTN User      count=3      AND    Enable unanswered call to voicemail   from_device=device_3    contact_device=device_1
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    verify incoming call    device=device_3      status=appear
    reject incoming call     device_list=device_3
    Verify Call State     device_list=device_3     state=Disconnected
    verify voicemail forwarding message text      device=device_1
    Disable unanswered call      device=device_3     contact_device=device_1
    Disconnect call     device=device_2,device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Disable unanswered call    device=device_3      contact_device=device_1    AND     come back to home screen    device_list=device_1,device_2,device_3

TC8 : [Call Transfer] DUT user resume while consultative transfers the PSTN call to TDC
    [Tags]    339418    P1     sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User        count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    resume the call         device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9 : [Call Transfer] Call transfer icon should not be shown in call banner after rejecting the PSTN transferred call from DUT in TDC.
    [Tags]    382552    P2
    [Setup]  Testcase Setup for CAP PSTN User        count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    rejects the incoming call   device_list=device_3
    Verify Call State    device_list=device_3    state=Disconnected
    verify call transfer option is disabled when first transferred call is rejected    device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC10 : [Call Transfer]Verify when transfer target person is PSTN user, work voicemail option must be listed
    [Tags]   321048   P2
    [Setup]  Testcase Setup for CAP PSTN User        count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify work voicemail option in call transfer    from_device=device_1     to_device=device_2:pstn_user     method=phone_number
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
