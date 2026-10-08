*** Settings ***
Resource  ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Multiple calls] DUT user is on landing page, receives 3 calls on the same time.
     [Tags]  319273   P2
     [Setup]  Testcase Setup for Meeting User    count=4
     navigate to calendar tab    device=device_1
     Navigate to calls tab   device=device_2,device_3,device_4
     initiate simultaneous call  devices=device_2,device_3,device_4   target_device=device_1:meeting_user    method=display_name
     verify multiple incoming calls  device=device_1
     accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=verify
     disconnect call   device_1
     [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC2 : [Multiple calls] DUT user in call, receives multiple call_2
    [Tags]  319275    P2
    [Setup]  Testcase Setup for Meeting User     count=4
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    verify incoming call  device=device_1   status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to calls tab   device=device_3,device_4
    initiate simultaneous call  devices=device_3,device_4   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1    full_screen_call=accept      notification_call=accept    count=3
    Verify Call State    device_list=device_2     state=Hold
    disconnect call       device=device_2,device_3,device_4
    verify call state and disconnect        device=device_1
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC3 : [Multiple calls] DUT user in call, receives multiple call, reject notification call
    [Tags]  319276   P2
    [Setup]  Testcase Setup for Meeting User  count=4
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    verify incoming call  device=device_1   status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to calls tab   device=device_3,device_4
    initiate simultaneous call  devices=device_3,device_4   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1    full_screen_call=accept    notification_call=reject
    resume one of the multiple calls   device=device_1    count=3
    disconnect call   device_2,device_3,device_4
    verify call state and disconnect        device=device_1
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC4 : [Multiple calls] DUT user in meeting, receives multiple calls.
    [Tags]  319278   P2
    [Setup]  Testcase Setup for Meeting User  count=4
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=test_meeting
    Join Meeting    device=device_1,device_2     meeting=test_meeting        join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Navigate to calls tab   device=device_3,device_4
    initiate simultaneous call  devices=device_3,device_4   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1    full_screen_call=accept    notification_call=accept
    Verify Call State    device_list=device_2     state=Hold
    disconnect call       device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC5 : [Multiple calls] DUT user in Multiple calls from another DUT and TDC
    [Tags]  319284   P2
    [Setup]  Testcase Setup for Meeting User  count=3
    Navigate to calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept
    disconnect call   device_2,device_3
    Verify Call State   device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC6 : [Multiple calls] DUT user receives multiple calls while on DND
    [Tags]  319286   P2
    [Setup]   Testcase Setup for Meeting User  count=3
    check presence feature  device=device_1     state=Available
    Select user presence   device=device_1     state=dnd
    Verify user presence   device=device_1     state=dnd
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls in DND status   device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC7 : [Multiple calls] DUT user is in call, receives multiple_1
    [Tags]  319204   P1
    [Setup]  Testcase Setup for Meeting User   count=4
    click on calls tab     device=device_4
    make outgoing call using display name  from_device=device_4   to_device=device_1
    verify incoming call  device=device_1   status=appear
    pick incoming call  device=device_1
    verify call state  device_list=device_1,device_4   state=connected
    initiate simultaneous call   devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=4
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC8 : [Multiple Calls] DUT user is on landing page, receives multiple calls and accept full screen call
    [Tags]  319268   sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User    count=3
    navigate to calendar tab    device=device_1
    Navigate to calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=verify
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC9 : [Multiple Calls] DUT user is on landing page, receives multiple calls and accept notification call
    [Tags]  319269   P0  sanity_tpc  bvt_tpc
    [Setup]  Testcase Setup for Meeting User    count=3
    navigate to calendar tab    device=device_1
    Navigate to calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=verify    notification_call=accept
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC10 : [Multiple calls] DUT user is on landing page, receives multiple calls and accept from notification
    [Tags]  319271   P2
    [Setup]  Testcase Setup for Meeting User    count=3
    navigate to calendar tab    device=device_1
    Navigate to calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=reject    notification_call=accept
    verify in call ribbon from main tab  device=device_1
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC11 : [Multiple calls] DUT user is on landing page, receives multiple calls and accept both the calls.
    [Tags]  319272   P1
    [Setup]  Testcase Setup for Meeting User    count=3
    navigate to calendar tab    device=device_1
    Navigate to calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept     notification_call=accept
    disconnect call   device_2,device_3
    Verify Call State   device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC12 : [Multiple calls] DUT user in Multiple calls from GCP and TDC
    [Documentation]  Precondition device_2 add device_1:meeting_user as call group members
    [Tags]  319285   P2
    [Setup]  run keywords   Testcase Meeting Setup for GCP User   count=4   AND     Enable call forwarding to call group     from_device=device_2    contact_device=device_1:meeting_user
    click on calls tab     device=device_3
    make outgoing call using display name  from_device=device_3   to_device=device_2:gcp_user
    click on calls tab     device=device_4
    make outgoing call using display name  from_device=device_4   to_device=device_1:meeting_user
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=4
    disconnect call  device=device_1,device_4
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC13 : [Multiple Calls] DUT user is on landing page, receives multiple calls and accept full screen call and ignore notification
    [Tags]  319270  P1  sanity_tpc
    [Setup]  Testcase Setup for Meeting User    count=3
    navigate to calendar tab    device=device_1
    Navigate to calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept     notification_call=reject
    Verify Call State   device_list=device_1    state=connected
    disconnect call   device_1
    Verify Call State   device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3