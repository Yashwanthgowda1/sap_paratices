*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  20

*** Test Cases ***
TC1 : [Multi Call Banner] DUT user holds the incoming call with TDC user
    [Tags]  306621    P1
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Multiple Call Banner] DUT user holds the outgoing call with TDC
    [Tags]  306622    P1
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Multiple Call Banner] DUT user can hold the muted call with the TDC user
    [Tags]  306623    P1
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_2
    Verify meeting Mute State    device_list=device_2    state=mute
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Multiple Call Banner] DUT user holds the incoming call with another DUT user
    [Tags]  306625    P2
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Multiple Call Banner] DUT user holds the outgoing call with DUT user
    [Tags]  306626    P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Multiple Call Banner] DUT user to tap on back button when call is on hold and take the call to full screen when tap on call hold banner if single call on hold
    [Tags]  306627   sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    tap on the banner    device=device_1
    Disconnect call      device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Multiple Call Banner] DUT user to tap on the banner when call is on hold with DUT user
    [Tags]  306629    P0     bvt_tpc     sanity_tpc
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    tap on the banner    device=device_1
    Disconnect call      device=device_1
    verify call state and disconnect        device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Multiple Call Banner] DUT user to tap on the banner when call is on hold with TDC user
    [Tags]  306630    bvt
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back      device=device_1
    verify call hold banner   from_device=device_1    to_device=device_2
    tap on the banner    device=device_1
    Disconnect call      device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Multiple Call Banner] DUT user to get incoming call from TDC user when other calls are on hold
    [Tags]  306631    P1
    [Setup]   Testcase Setup for Meeting User    count=4
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    click on calls tab     device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1:meeting_user
    verify incoming call     device=device_1    status=appear
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    Disconnect call      device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC10 : [Multiple Call Banner] DUT user to get incoming call from another DUT user when other calls are on hold
    [Tags]  306632    P1
    [Setup]   Testcase Setup for Meeting User    count=4
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab     device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Hold
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    verify incoming call     device=device_1    status=appear
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_3,device_4
    Disconnect call      device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC11 : [Multiple Call Banner] DUT user to park the incoming call from TDC user
    [Tags]  306633   P2
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    call park and get the code   device=device_1
    verify call park banner    from_device=device_1     to_device=device_2
    tap on the banner    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call      device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Multiple Call Banner] DUT user to park the outgoing call with TDC
    [Tags]  306634   P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    call park and get the code   device=device_1
    verify call park banner    from_device=device_1     to_device=device_2
    tap on the banner    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call      device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC13 : [Multiple Call Banner] DUT to hold multiple calls and park the incoming call from TDC user.
    [Tags]  306635   sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User    count=4
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    click on calls tab     device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    click call park    device=device_1
    wait for some time    time=${wait_time}
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    verify call park banner      from_device=device_1    to_device=device_4
    Disconnect call      device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   dismiss multiple call park banner   device=device_1     AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC14 :[Multiple Call Banner] DUT to hold multiple calls and park the outgoing call with TDC user.
    [Tags]  306636  P2
    [Setup]   Testcase Setup for Meeting User    count=4
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    navigate to people tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    click call park    device=device_1
    wait for some time    time=${wait_time}
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    verify call park banner      from_device=device_1    to_device=device_4
    Disconnect call      device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC15 :[Multiple Call Banner] DUT to hold the multiple incoming calls
    [Tags]  306637  P1
    [Setup]   Testcase Setup for Meeting User    count=3
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    Disconnect call      device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC16 :[Multiple Call Banner] DUT user to tap on the "multiple calls" banner
    [Tags]  306638    bvt_tpc    sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=4
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    return to home screen    device_list=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name      from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    repeat keyword  2 times     go back to previous page    device=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name      from_device=device_1     to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    click call park    device=device_1
    wait for some time    time=${wait_time}
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3,device_4
    Disconnect call      device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC17 : [Multiple Call Banner] DUT user to get multiple incoming calls at the same time
    [Tags]   306640    bvt_tpc  sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=3
    Navigate to calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls   device=device_1
    disconnect call   device=device_2,device_3
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC18 : [Multiple Call Banner] DUT user to get multiple incoming calls at same time during call on hold with TDC user
    [Tags]   306641     P1
    [Setup]   Testcase Setup for Meeting User    count=4
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1    to_device=device_3
    initiate simultaneous call  devices=device_2,device_4   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    disconnect call   device=device_2,device_3,device_4
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC19 :[Multiple call Banner] DUT user on device setting page, receives multiple calls.
    [Tags]  306642    P2
    [Setup]  Testcase Setup for Meeting User  count=3
    navigate to device setting page   device=device_1
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept
    Disconnect call      device=device_1
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC20 :[Multiple Call Banner] DUT user to verify the "multiple call Banner" while in a ongoing meeting
    [Tags]  306643    bvt_tpc    sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User  count=4
    create meeting  device=device_4     participants=device_1:meeting_user  meeting=cnf_device_meeting
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    click back       device=device_1
    Join meeting    device=device_1,device_4     meeting=cnf_device_meeting      join_styles=conference,None
    Verify meeting state   device_list=device_1,device_4    state=Connected
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    End meeting     device=device_1,device_4
    Disconnect call      device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC21 :[Multiple Call Banner] DUT user to verify the "multiple call Banner" while in a ongoing call
    [Tags]  306644   bvt_tpc     sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User  count=4
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    click back       device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    Disconnect call      device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC22 : [Multiple call banner] DUT user to tap on dismiss button on the banner
    [Tags]   306645   P1
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${wait_time}
    verify call park banner    from_device=device_1     to_device=device_2
    close call park banner    device=device_1
    Disconnect call      device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC23 : [Multi Call Banner] Verify If there is a new incoming call and other call is on hold, the incoming call is drawn into full screen.
    [Tags]   321012    P2
    [Setup]   Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    click on calls tab     device=device_3
    Make outgoing call using display name  from_device=device_3   to_device=device_1:meeting_user
    verify incoming call    device=device_1   status=appear
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC24 :[Multiple call Banner] DUT user on device setting page, receives multiple calls.
    [Tags]      319280
    [Setup]  Testcase Setup for Meeting User  count=3
    navigate to device setting page   device=device_1
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept
    Disconnect call      device=device_1
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
