*** Settings ***
Resource  ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_times} =  10

*** Test Cases ***
TC 1 : [Multiple Calls] DUT user is on calls tab, receives multiple calls and accept notification call
    [Tags]  308862    P0    bvt_tp   sanity_tp      Certification_audio         bvt_pr
    [Setup]  Testcase Setup  count=3
    click on calls tab    device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=verify    notification_call=accept
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC 2 : [Multiple Calls] DUT user is on calls tab, receives multiple calls and accept full screen call and ignore notification
    [Tags]  308864   sanity_tp   P1
    [Setup]  Testcase Setup  count=3
    click on calls tab    device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=reject
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC 3 :[Multiple calls] DUT user is on calls tab, receives multiple calls and accept both the calls.
    [Tags]  308870   P1     Certification_audio
    [Setup]  Testcase Setup   count=3
    click on calls tab   device=device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept   count=3
    disconnect call     device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC 4 :[Multiple calls] DUT user is in call, receives multiple_1
    [Tags]  308879   P1
    [Setup]  Testcase Setup   count=4
    click on calls tab   device=device_4
    make outgoing call using display name  from_device=device_4   to_device=device_1
    verify incoming call  device=device_1   status=appear
    pick incoming call  device=device_1
    wait for some time  ${wait_time}
    verify call state  device_list=device_1,device_4   state=connected
    initiate simultaneous call   devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=4
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC 5 :[Multiple calls] DUT user receives multiple calls while playing VM
    [Tags]  308897   P1
    [Setup]  Testcase Setup   count=3
    Send Voicemail      from_device=device_2   to_device=device_1
    Click on calls tab    device=device_1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Play voicemail    device=device_1
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
    verify voicemail status while in call    device=device_1
    disconnect call   device_1
    navigate to calls tab   device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC 6 :[Multiple calls] DUT user on device setting page, receives multiple calls.
    [Tags]   308902  P1     Certification_audio
    [Setup]  Testcase Setup   count=3
    navigate to device setting page   device=device_1
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND    Device Setting Back     device=device_1    AND   come back home screen for user    count=3


TC 7 :[Multiple calls] DUT user is on calls tab, receives 3 calls on the same time.
    [Tags]  308873   P2
    [Setup]  Testcase Setup   count=4
    click on calls tab   device=device_1
    initiate simultaneous call  devices=device_2,device_3,device_4   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=verify    count=3
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC 8 :[Multiple calls] DUT user in call, receives multiple call_2
    [Tags]  308881   P2
    [Setup]  Testcase Setup   count=4
    click on calls tab   device=device_1
    make outgoing call using display name  from_device=device_4   to_device=device_1
    verify incoming call  device=device_1   status=appear
    pick incoming call  device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=4
    disconnect call       device=device_1
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC 9 :[Multiple calls] DUT user in call, receives multiple call, reject notification call
    [Tags]  308884   P2
    [Setup]  Testcase Setup   count=4
    click on calls tab   device=device_1
    make outgoing call using display name  from_device=device_4   to_device=device_1
    verify incoming call  device=device_1   status=appear
    pick incoming call  device=device_1
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls   device=device_1    full_screen_call=accept     notification_call=reject       count=3
    resume call from call hold banner   device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    disconnect call         device=device_4
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC 10 : [Multiple calls] DUT user in meeting, receives multiple calls.
    [Tags]  308890   P2
    [Setup]  Testcase Setup   count=4
    create meeting  device=device_4       participants=device_1    meeting=tests_meeting
    Join Meeting    device=device_1,device_4     meeting=tests_meeting
    Verify meeting state   device_list=device_1,device_4    state=Connected
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls   device=device_1    full_screen_call=accept     notification_call=accept      count=4
    disconnect call   device=device_1
    End meeting   device=device_1
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND    test case teardown     devices=device_4    count=4

TC 11 : [Multiple calls] DUT user in Multiple calls from another DUT and TDC
    [Tags]  308914   P2
    [Setup]  Testcase Setup   count=3
    click on calls tab    device=device_1
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
    disconnect call   device_1
    Verify Call State   device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3


TC 12 : [Multiple calls] DUT user receives multiple calls while on DND
    [Tags]  308920   P3
    [Setup]  Testcase Setup   count=3
    Select user presence   device=device_1     state=dnd
    Verify user presence   device=device_1     state=dnd
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls in DND status   device=device_1
    Wait for Some Time    time=${wait_times}
    disconnect call  device=device_2,device_3
    verify call entries are synced in call log    from_device=device_1     to_device=device_2     state=missed
    verify call entries are synced in call log    from_device=device_1     to_device=device_3      state=missed
    [Teardown]  run keywords    Capture on Failure   AND    come back home screen for user    count=3   AND    Select user presence   device=device_1    state=available


TC 13 : [Multiple calls] DUT user in Multiple calls from GCP and TDC
    [Tags]  308917   P2
    [Setup]  run keywords   Testcase Setup for GCP User   count=4   AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2:gcp_user
    click on calls tab   device=device_3
    make outgoing call using display name  from_device=device_3   to_device=device_1
    click on calls tab   device=device_4
    make outgoing call using display name  from_device=device_4   to_device=device_2:gcp_user
    verify multiple incoming calls  device=device_2
    accept multiple incoming calls  device=device_2   full_screen_call=accept    notification_call=accept    count=4
    verify call state and disconnect  device=device_1,device_2,device_3,device_4
    Verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4    AND    verify and disable call forwarding    device=device_1

TC 14:[Heads up Notification] DUT is on calls tab, receives multiple calls and accept notification call.
    [Tags]    381407    certification_audio     p2
    [Setup]    Testcase Setup   count=3
    click on calls tab   device=device_1,device_2,device_3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls    device=device_1
    pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify any incoming call disappeared    device=device_1     type=on_call_banner
    verify call state and disconnect  device=device_1,device_2,device_3
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC 15: Verify that the DUT does not get stuck when receiving an incoming call during an outgoing call operation
    [Tags]    489576
    [Setup]    Testcase Setup    count=3
    click on calls tab  device=device_2,device_1,device_3
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick Incoming Call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect Call    device=device_1
    Verify Call State And Disconnect    device=device_2,device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC 16: [Multiple calls] DUT user in Multiple calls from DUT and another DUT
    [Tags]    476595
    [Setup]    Testcase Setup    count=4
    Click On Calls Tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click On Calls Tab    device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_3,device_1    state=Connected
    Click On Calls Tab    device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1
    verify multiple incoming calls    device=device_1
    pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_4,device_1    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Hold
    Disconnect Call    device=device_1
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    Verify Call State And Disconnect    device=device_2,device_3
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Remove meeting from calender for meeting policy test      ${count}

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Click on calls tab   ${from_device}
    Make outgoing call using phonenumber    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=35s
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected