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
TC1 : [Calendar] Verify Join option for Meeting scheduled from TDC
    [Tags]  305788     P0    bvt_tpc     sanity_tpc
    [Setup]    Testcase Setup for Meeting User   count=2
    Create Meeting  device=device_2     meeting=cnf_device_meeting      participants=device_1:meeting_user
    Refresh cnf device for meeting visibility      device=device_1
    Scroll till meeting visible     device=device_1      meeting=cnf_device_meeting
    Verify join button displayed on conf device    device=device_1
    Join meeting   device=device_1   meeting=cnf_device_meeting     join_styles=conference
    Verify meeting name while joining   device=device_1    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify UI returns to home page      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2    count=2

TC2 : [Calendar] DUT to display all the participants information on the meeting roster
    [Tags]  305793
    [Setup]    run keywords   Testcase Setup for Meeting User   count=3   AND   Meeting Setup   count=3
    create meeting  device=device_2     participants=device_1:meeting_user,device_3       meeting=Multiple_participant_meeting
    Refresh for Meeting Visibility      device=device_3
    Join Meeting    device=device_1,device_2,device_3     meeting=Multiple_participant_meeting       join_styles=conference,None,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Verify participant list from meeting roster     device=device_1      connected_device_list=device_1:meeting_user,device_2,device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1,device_2,device_3   count=3

TC3 : [Calendar] DUT user joins the scheduled meeting and Mute/unmute itself
    [Tags]  305791   P0     bvt_tpc  sanity_tpc
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2     participants=device_1:meeting_user       meeting=cnf_device_meeting
    Join Meeting    device=device_2,device_1     meeting=cnf_device_meeting      join_styles=None,conference
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Mutes the meeting     device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the meeting    device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    test case teardown     devices=device_1,device_2     count=2

TC4 : [Calendar] DUT user can Far-mute TDC in a conference call
    [Tags]  305855   sanity_tpc  P1
    [Setup]    run keywords   Testcase Setup for Meeting User   count=3   AND   Meeting Setup   count=3
    create meeting  device=device_2     participants=device_1:meeting_user,device_3       meeting=farmute_client_meet
    Refresh for Meeting Visibility      device=device_2
    Refresh for Meeting Visibility      device=device_3
    Join Meeting    device=device_2,device_1,device_3     meeting=farmute_client_meet    join_styles=None,conference,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Unmutes the meeting    device=device_3
    Farmute the call    from_device=device_1      to_device=device_3
    Verify meeting Mute State    device_list=device_3    state=mute
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3

TC5 : [Calendar] DUT user to mute all the audience
    [Tags]  305908   bvt_tpc     sanity_tpc  P0
    [Setup]    run keywords   Testcase Setup for Meeting User   count=3   AND   Meeting Setup   count=3
    Create Meeting  device=device_2     meeting=mute_all_audience
    Wait for Some Time    time=${wait_time}
    Join Meeting   device=device_2      meeting=mute_all_audience
    Wait for Some Time    time=${wait_time}
    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user,device_3
    Pick incoming call    device=device_1,device_3
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    Unmutes the meeting     device=device_2
    Verify meeting Mute State    device_list=device_2    state=unmute
    End meeting     device=device_1,device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    count=3

TC6 : [Calendar] DUT user can remove TDC user from a conference call
    [Tags]  305856   sanity_tpc  P1
    [Setup]    Testcase Setup for Meeting User   count=3
    create meeting  device=device_2       participants=device_1:meeting_user,device_3    meeting=remove_meeting
    Refresh for Meeting Visibility      device=device_3
    Join Meeting    device=device_1,device_2,device_3     meeting=remove_meeting     join_styles=conference,None,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Unmutes the meeting    device=device_3
    Remove user from meeting    from_device=device_1      to_device=device_3
    Verify someone removed you from the meeting text    device=device_3
    click back btn  device=device_1
    Verify meeting state    device_list=device_3   state=Disconnected
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1,device_2    count=3

TC7 : [Calendar] Join the scheduled meeting from DUT and do add/remove participants
    [Tags]  305790   P0  bvt_tpc     sanity_tpc
    [Setup]    Testcase Setup for Meeting User   count=3
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=add_remove_meeting
    Join Meeting    device=device_2,device_1     meeting=add_remove_meeting      join_styles=None,conference
    Wait for Some Time    time=${wait_time}
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Unmutes the meeting    device=device_3
    Remove user from meeting    from_device=device_1      to_device=device_3
    Verify someone removed you from the meeting text    device=device_3
    click back btn  device=device_1
    Verify meeting state    device_list=device_3   state=Disconnected
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1,device_2    count=3

TC8 : [Calendar] DUT should not crash when cancelling the call while joining meeting
    [Tags]    305992
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=cnf_device_meeting
    Join meeting   device=device_1    meeting=cnf_device_meeting     join_styles=conference
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2     count=2

TC9 : [Calendar] For Participants on DUT, cancelled meeting should be displayed with "Canceled:" text on meeting tab UI
    [Tags]   305864  sanity_tpc  P1
    [Setup]    Testcase Setup for Meeting User   count=2
    verify cancelled meetings on home screen for cnf device   device=device_1
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=meetings_cancel
    Refresh cnf device for meeting visibility   device=device_1
    Scroll till meeting visible     device=device_1  meeting=meetings_cancel
    delete specific meeting    device=device_2    meeting=meetings_cancel
    Refresh cnf device for meeting visibility   device=device_1
    Scroll till meeting visible     device=device_1  meeting=Canceled:meetings_cancel
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_1,device_2      count=2

TC10 : [Calendar] DUT user gets multiple meetings at same time
    [Tags]  305866   P0  bvt_tpc     sanity_tpc
    [Setup]    run keywords   Testcase Setup for Meeting User   count=3   AND   Meeting Setup   count=3
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=tdc1_meeting1
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=tdc1_meeting2
    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_meeting1
    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_meeting2
    Join meeting   device=device_1    meeting=tdc2_meeting2      join_styles=conference
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1   state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2,device_3     count=3

TC11 : [Calendar] Verify all day meetings
    [Tags]    305805   bvt_tpc     sanity_tpc    P0
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=meeting1    all_day_meeting=ON
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=meeting2    all_day_meeting=ON
    Refresh cnf device for meeting visibility   device=device_1
    Verify meeting under all day event  device=device_1     meetings=meeting1,meeting2
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     All Day Event Test Case Teardown     devices=device_2    meeting=meeting2,meeting1   count=2

TC12 : [Calendar] TDC user can remove DUT user from conference
    [Tags]   305854     bvt_tpc  sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=remove_meeting
    Join Meeting    device=device_1,device_2     meeting=remove_meeting      join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Remove user from meeting    from_device=device_2      to_device=device_1:meeting_user
    #Verify someone removed you from the meeting text    device=device_1
    Verify meeting state    device_list=device_1      state=Disconnected
    click back btn  device=device_2
    End meeting     device=device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    count=2

TC13 : [Calendar] TDC user can Far-mute DUT user in conference
    [Tags]  305853   P2
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=cnf_device_meeting
    Join Meeting    device=device_2,device_1     meeting=cnf_device_meeting      join_styles=None,conference
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Unmutes the meeting    device=device_1
    Farmute the call    from_device=device_2      to_device=device_1:meeting_user
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the meeting    device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2     count=2

TC14 : [Calendar] Teams App user gets multiple All Day meeting at same time
    [Tags]  305867   P2
    [Setup]    Testcase Setup for Meeting User   count=3
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=tdc1_all_day_meeting1    all_day_meeting=ON
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=tdc1_all_day_meeting2    all_day_meeting=ON
    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_all_day_meeting1    all_day_meeting=ON
    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_all_day_meeting2    all_day_meeting=ON
    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_all_day_meeting3    all_day_meeting=ON
    Refresh cnf device for meeting visibility   device=device_1
    Verify meeting under all day event  device=device_1     meetings=tdc1_all_day_meeting1,tdc1_all_day_meeting2,tdc2_all_day_meeting1,tdc2_all_day_meeting2,tdc2_all_day_meeting3
    Join meeting from all day meeting tab     device=device_1     meeting=tdc2_all_day_meeting3
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1   state=Connected
    End meeting     device=device_1
    click back btn  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Before Delete Meetings   devices=device_1,device_2,device_3    count=3   AND     All Day Event Test Case Teardown     devices=device_2    meeting=tdc1_all_day_meeting1,tdc1_all_day_meeting2    count=3    AND     All Day Event Test Case Teardown     devices=device_3    meeting=tdc2_all_day_meeting1,tdc2_all_day_meeting2,tdc2_all_day_meeting3   count=3

TC15 : [Calendar] DUT user should be allowed to join meeting, when in P2P call.
    [Tags]  306032   P2
    [Setup]    run keywords   Testcase Setup for Meeting User   count=3   AND   Meeting Setup   count=3
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=cnf_device_meeting
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    click back btn  device=device_1
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    End meeting     device=device_1,device_2
    Disconnect call     device=device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1,device_2,device_3     count=3

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
