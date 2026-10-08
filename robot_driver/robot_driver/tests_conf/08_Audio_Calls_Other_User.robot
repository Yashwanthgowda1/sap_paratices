*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time1} =  5
${wait_time2} =  25
${wait_time3} =  40
${15_minutes_wait_time} =  15 minutes
${60s_wait_time} =  60


*** Test Cases ***
TC1: [Outgoing Calls] DUT user calls PSTN user from Dialpad
    [Tags]  305954      outgoing_calls   bvt_tpc     sanity_tpc
    [Setup]  Testcase Meeting PSTN Setup Main   count=2
    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Call Mute] DUT user to mute/unmute itself while in a call with PSTN user
    [Tags]   306065  sanity_tpc  P1
    [Setup]  Testcase Meeting PSTN Setup Main   count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Call Transfer] DUT user blind transfer the TDC call to PSTN
    [Tags]   305794   bvt_tpc    sanity_tpc     P0
    [Setup]  Testcase Meeting PSTN Setup Main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Call Transfer] DUT user consultative transfers the PSTN call to TDC
    [Tags]  306082    bvt_tpc    sanity_tpc  P0
    [Setup]  Testcase Meeting PSTN Setup Main   count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

# Feature changed: We cannot see pstn user in muted state
TC5 : [Esc to Conf.] DUT user in P2P call with TDC, adds PSTN user
    [Tags]  305858   bvt_tpc     sanity_tpc  P0
    [Setup]  Testcase Meeting PSTN Setup Main   count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_3    state=mute
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Esc to Conf.] DUT user in P2P call with another DUT user, adds PSTN user to call
    [Tags]  305860   sanity_tpc  P1
    [Setup]  Testcase Meeting PSTN Setup Main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1:meeting_user,device_2:pstn_user,device_3
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Verify Call State    device_list=device_1,device_2     state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1:meeting_user,device_2:pstn_user
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [Esc to Conf.] DUT user to add TDC again to the call
    [Tags]  305862    bvt_tpc    sanity_tpc  P0
    [Setup]  Testcase Meeting PSTN Setup Main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1:meeting_user,device_2:pstn_user,device_3
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Verify Call State    device_list=device_1,device_2     state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1:meeting_user,device_2:pstn_user
    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8 : [Call Transfer] DUT user blind transfer one PSTN user call to another PSTN user
    [Tags]   306079  sanity_tpc  P1
    [Setup]  Testcase Meeting 2 PSTN Setup Main   count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9 : [Call Merge] DUT user merge PSTN user call with TDC user
    [Tags]   306094    P0    bvt_tpc     sanity_tpc
    [Setup]  Testcase meeting pstn setup main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber      from_device=device_1           to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Come back to home screen    device_list=device_1    disconnect=False
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1            to_device=device_3
    Pick incoming call   device=device_3
    Wait for Some Time    time=${wait_time}
    verify call state    device_list=device_1,device_3     state=Connected
    Verify and merge call    device=device_1     from_device=device_2:pstn_user
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    disconnect call       device=device_1,device_2
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    come back to home screen    device_list=device_1,device_2,device_3

TC10 : [Call Transfer] DUT user to transfer the PSTN call to another DUT user
    [Tags]   306078  sanity_tpc  P1
    [Setup]  Testcase Meeting PSTN Setup Main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1            state=Disconnected
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC11 : [Multiple Call Banner] DUT user can hold the muted call with the PSTN user
    [Tags]  306624    bvt_tpc    sanity_tpc     P0
    [Setup]    Testcase Meeting PSTN Setup Main   count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Wait for Some Time    time=${wait_time}
    Hold the call    device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Call Merge] Verify an active call with another DUT user can be merged into an MoH call.
    [Tags]  318527    P2
    [Setup]  Testcase Meeting PSTN Setup Main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber      from_device=device_1           to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    hold the call    device=device_1
    verify call state  device_list=device_2         state=Hold
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3         to_device=device_1:meeting_user
    Pick incoming call   device=device_1
    verify call state    device_list=device_1,device_3     state=Connected
    Verify and merge call    device=device_1     from_device=device_2:pstn_user
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    disconnect call       device=device_1,device_2
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    come back to home screen    device_list=device_1,device_2,device_3

TC13 : [Call Merge] Verify an user should be able to merge PSTN call with another DUT user, another DUT's call is on hold
    [Tags]  318528   P2
    [Setup]  Testcase Meeting PSTN Setup Main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name   from_device=device_1           to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab     device=device_2
    Make outgoing call using phonenumber      from_device=device_2           to_device=device_1:meeting_user
    Pick incoming call   device=device_1
    verify call state    device_list=device_2,device_3     state=Connected
    Verify and merge call    device=device_1     from_device=device_3
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    disconnect call       device=device_1,device_2
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    come back to home screen    device_list=device_1,device_2,device_3

TC14 : [Multiple calls] DUT user in Multiple calls, Blind Transfer one TDC call to another PSTN user
    [Tags]  319282   P2
    [Setup]  Testcase Meeting 2 PSTN Setup Main   count=4
    initiate simultaneous call  devices=device_4,device_3   target_device=device_1:meeting_user    method=phone_number
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls   device=device_1    full_screen_call=accept    notification_call=accept   transfer_method=blind   from_device=device_1  to_device=device_2:pstn_user   method=phone_number
    Pick incoming call    device=device_2
    resume the call   device=device_1
    disconnect call   device=device_1,device_2
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC15 : [Multiple calls] DUT user in Multiple calls, Blind Transfer PSTN call to another PSTN user
    [Tags]   319283   P2
    [Setup]  Testcase Meeting 2 PSTN Setup Main   count=4
    initiate simultaneous call  devices=device_2,device_4   target_device=device_1:meeting_user    method=phone_number
    verify multiple incoming calls   device=device_1
    accept multiple incoming calls  device=device_1    full_screen_call=accept    notification_call=accept   transfer_method=blind   from_device=device_1  to_device=device_3:pstn_user   method=phone_number
    Pick incoming call    device=device_3
    resume the call    device=device_1
    disconnect call    device=device_1,device_2
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC16 : [Meet now] Verify DUT user can initiate meeting with multiple participants, PSTN user and initiated from Meet now
    [Tags]   320188  p2
    [Setup]   Testcase Meeting PSTN Setup Main   count=3
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_2:pstn_user,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen    device_list=device_1,device_2,device_3

TC17 : [Multiple Call Banner] DUT user to tap on back button when call is on hold with PSTN user
    [Tags]   306628   P2
    [Setup]   Testcase Meeting PSTN Setup Main   count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Disconnect call      device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC18 :[Call Merge] Verify that DUT user is able to Merge two PSTN calls
    [Tags]   318460     p2
    [Setup]   Testcase Meeting 2 PSTN Setup Main    count=3
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify call state     device_list=device_2     state=Hold
    Verify and merge call      device=device_1     from_device=device_2:pstn_user
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    disconnect call        device=device_1,device_2
    Verify Call State           device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC19 : [Incoming Calls] DUT displays the phone number of PSTN user
    [Tags]  314136     P2
    [Setup]   Testcase Meeting PSTN Setup Main     count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    verify pstn display number on incoming call UI    from_device=device_1   to_device=device_2:pstn_user
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC20 : [Call Transfer] DUT user resume while consultative transfers the PSTN call to TDC
    [Tags]    339425    sanity_tpc  P1
    [Setup]  Testcase Meeting PSTN Setup Main      count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
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

TC21 : [Call Transfer] DUT user End the call while consultative transfers the PSTN call to TDC
    [Tags]    339426    P2
    [Setup]  Testcase Meeting PSTN Setup Main      count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2   state=Disconnected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC22 : [Call Transfer] Call transfer icon should not be shown in call banner after rejecting the PSTN transferred call from DUT in TDC.
    [Tags]    382554    P2
    [Setup]  Testcase Meeting PSTN Setup Main      count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2   state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Rejects the incoming call   device_list=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Wait for Some Time    time=${wait_time2}
    verify call transfer option is disabled when first transferred call is rejected  device=device_1
    Disconnect call     device=device_2,device_1
    Verify Call State    device_list=device_2,device_1    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure        AND    Come back to home screen    device_list=device_1,device_2,device_3

TC23 : [Call Transfer] TDC user End the call while consultative transfers the PSTN call from DUT
    [Tags]    339427     p2
    [Setup]   Testcase Meeting PSTN Setup Main    count=3
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    verify incoming call    device=device_3      status=appear
    Wait for Some Time    time=${wait_time3}
    Verify Call State    device_list=device_3     state=Disconnected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure        AND    Come back to home screen    device_list=device_1,device_2,device_3

TC24 : [Call Park] DUT user to park the PSTN call.
    [Tags]      313747      bvt_tpc     sanity_tpc
    [Setup]   Testcase Meeting PSTN Setup Main    count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time1}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Wait for Some Time    time=${wait_time1}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    return to home screen   device_list=device_2
    Dismiss Multiple Call Park Banner	device=device_1
    Navigate to calendar tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time1}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${wait_time1}
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen    device_list=device_1,device_2

TC25:[Outgoing Calls] User to auto dial, when edited the invalid number.
   [Tags]      306059
   [Setup]  Testcase Meeting PSTN Setup Main    count=2
   Auto dial edited valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
   Pick incoming call    device=device_2
   Wait for Some Time    time=${wait_time}
   Verify Call State    device_list=device_1,device_2    state=Connected
   Disconnect call     device=device_1
   Verify Call State    device_list=device_1,device_2     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC26 : [Call hand off] Verify that DUT to add PSTN to the call
    [Tags]      306521
    [Setup]  Testcase Meeting PSTN Setup Main   count=4
    Signin with other user    device=device_3   other_user_account=device_1:meeting_user
    click on calls tab     device=device_4
    Make outgoing call using phonenumber    from_device=device_4      to_device=device_1:meeting_user
    Pick incoming call    device=device_3
    Verify Call State     device_list=device_3,device_4    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3,device_4    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
    Disconnect call     device=device_1,device_2,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC27: [Outgoing Calls] auto dial with valid PSTN number.
    [Tags]  306058    p1
    [Setup]  Testcase Meeting PSTN Setup Main    count=2
    Auto dial with valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC28 : [Esc to Conf.] DUT user in call with PSTN user, add PSTN user
    [Tags]  305990  P1
    [Setup]  Testcase Meeting 2 PSTN Setup Main    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Call forward Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    verify and disable call forwarding    device=device_1

Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2:pstn_user

Call Ring Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    Disable Also Ring    device=device_1