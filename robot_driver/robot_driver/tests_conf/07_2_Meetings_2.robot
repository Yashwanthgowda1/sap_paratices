*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

#Suite Setup     Meeting Setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =   10
${20s_wait_time} =  20
${Long_meeting_title} =  Meeeeeeeeeeeeeeeetttttttttttttttiiiiiiiiiiiinnnnnnnnnnnnnnngggggggggggggggg


*** Test Cases ***
TC1 : [Calendar] Calendar tab UI displays all the scheduled meeting entries
    [Tags]   305850  bvt_tpc     sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=1
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=Meeting1
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=Meeting2
    Refresh cnf device for meeting visibility   device=device_1
    get list of scheduled meetings on cnf device    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    count=2

TC2 : [Meetings] DUT user joins the meeting scheduled without any title
    [Tags]  312750   p2
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=
    Join Meeting    device=device_1,device_2     meeting=(No title)      join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2     state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_2    count=2

TC3 : [Meetings] For Organizer on DUT, Cancelled meetings should not be displayed in meeting tab
    [Tags]  312753   p2
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2     participants=device_1:meeting_user    meeting=Cancel_meeting
    Wait for Some Time    time=${wait_time}
    refresh cnf device for meeting visibility     device=device_1
    Select Meeting      device=device_2    meeting=Cancel_meeting
    delete specific meeting    device=device_2    meeting=Cancel_meeting
    Verify meeting should not be displayed   device=device_1      meeting=Cancel_meeting
    verify canceled meeting should not visible for organizer     device=device_2   meeting=Canceled: Cancel_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_2    count=2

TC4 : [Meetings] Verify meeting description
    [Tags]  312756   p2
    [Setup]   Testcase Setup for Meeting User   count=2
    create meeting  device=device_2     participants=device_1:meeting_user    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    refresh cnf device for meeting visibility     device=device_1
    get scheduled meeting name on cnf device     device=device_1
    get scheduled meeting organizer name on cnf device   device=device_1
    verify join button displayed on conf device  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_2    count=2

TC5 : [Meetings] Meeting object on DUT should get updated when user navigates out and returns to the Meetings tab
    [Tags]  312760   p2
    [Setup]   run keywords   Testcase Setup for Meeting User   count=2   AND   Meeting Setup   count=2
    create meeting  device=device_2     participants=device_1:meeting_user    meeting=test_meeting
    navigate to people tab   device=device_1
    come back to home screen    device_list=device_1
    navigate to calendar tab    device=device_1
    meeting exist or not     device=device_1     meeting_name=test_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_2    count=2

TC6 : [Calendar] Long meeting titles should be truncated with ellipses in meeting object on DUT
    [Tags]   305873  p3
    [Setup]  run keywords   Testcase Setup for Meeting User   count=2   AND   Meeting Setup   count=2
    Create Meeting  device=device_2    participants=device_1:meeting_user          meeting=${Long_meeting_title}
    Refresh cnf device for meeting visibility   device=device_1
    Select long title meeting      device=device_1    meeting=${Long_meeting_title}
    Verify truncated meeting title      devices=device_1   meeting=${Long_meeting_title}
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2      count=2

TC7 : [Meetings] Validate the in call screen banner during back press of an ongoing meeting.
    [Tags]  320290   p2
    [Setup]    Testcase Setup for Meeting User   count=2
    Create Meeting  device=device_2     participants=device_1:meeting_user   meeting=cnf_device_meeting
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    click back     device=device_1
    Join meeting from tap to return banner       device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_2    count=2

TC8 : [Meetings] Validate the options of the current user from the meeting details page
    [Tags]  320289    p2
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify manage audio and video option    device=device_1     count=2    role=presenter
    verify presenter options in meeting from attendee     from_device=device_1     to_device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_2    count=2

TC9 : [Busy on Busy] [Meeting]Verify DUT user shouldn't get the incoming call,When DUT user is in meeting
    [Tags]   452016   bvt_tpc     sanity_tpc  P0    phonesCY23_4
    [Setup]   Testcase Setup for Meeting User  count=3
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Create Meeting  device=device_2     participants=device_1:meeting_user   meeting=cnf_device_meeting
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Navigate to people tab    device=device_3
    verify busy on busy error message while already in call   device=device_3         to_device=device_1:meeting_user      method=display_name
    verify incoming call    device=device_1    status=disappear
    Wait for Some Time    time=${wait_time}
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2  count=2     AND    select the options inside when in another call option   device=device_1     option=new_calls_ring_me    AND   Come back to home screen    device_list=device_1,device_2,device_3

TC10:[Busy on Busy][Meeting] Verify DUT user should get the incoming call,When user selects New calls ring me under When in another call in Calling
    [Tags]   452047      sanity_tpc  P1    phonesCY23_4
    [Setup]   Testcase Setup for Meeting User  count=3
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    Create Meeting  device=device_2     participants=device_1:meeting_user   meeting=cnf_device_meeting
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Meeting State    device_list=device_1    state=hold
    Disconnect call     device=device_3
    Resume The Meeting    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2  count=2   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC11 : [Calendar] DUT user to reject the meeting invite call from TDC
    [Tags]  305903   P2
    [Setup]    Testcase Setup for Meeting User   count=3
    create meeting  device=device_2       participants=device_1:meeting_user,device_3    meeting=reject_meeting
    Join Meeting    device=device_2,device_3      meeting=reject_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
    rejects the incoming call     device_list=device_1
    verify home screen for cnf device    device=device_1
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    count=3

TC12 :[Meeting] After Selecting Audio off, DUT user should be able to get the pop - up notification.
    [Tags]   402610   p2
    [Setup]   Testcase Setup for Meeting User  count=2
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting     join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify switch audio route options in meeting UI         device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2    count=2

TC13 : [Calendar] Participant count updates, when organizer adds the participant after meeting is started.
    [Tags]    306030    p2
    [Setup]   Testcase Setup for Meeting User    count=3
    create meeting  device=device_2       participants=device_1:meeting_user,device_3    meeting=participant_count_meeting
    Join Meeting    device=device_1          meeting=participant_count_meeting      join_styles=conference
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    ${participant_count_before_adding}     Get participant count     from_device=device_1      connected_device_list=device_1:meeting_user
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    ${participant_count_after_adding}      Get participant count     from_device=device_1      connected_device_list=device_1:meeting_user,device_2,device_3
    run keyword if  ${participant_count_before_adding}+2 == ${participant_count_after_adding}    Log   Participant count got increased
    ...   ELSE   fail   Participant count didn't increased.
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3  state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND    Test Case Teardown     devices=device_2    count=3

*** Keywords ***
Meeting Setup
    [Arguments]     ${count}
    Remove meeting from calender for meeting policy test      ${count}

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Remove meeting from calender for meeting policy test      ${count}

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}   ${count}
    check for device count      count=${count}
    Come back to home screen    ${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}

All Day Event Test Case Teardown
    [Arguments]     ${devices}      ${meeting}   ${count}
    check for device count      count=${count}
    Delete all day meetings      ${devices}    ${meeting}
    Come back to home screen    ${devices}
    Remove meeting from calender for meeting policy test      ${count}

Before Delete Meetings
    [Arguments]     ${devices}   ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=${devices}
    Teardown Meeting Test Case     devices=${devices}

Navigate to device setting page
    [Arguments]     ${device}
    Open settings page   device=${device}
    Click device settings   device=${device}
