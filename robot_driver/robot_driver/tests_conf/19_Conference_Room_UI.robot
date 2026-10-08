*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Conference Room] [Meet now] Meet now icon should be present on Home Screen after Sign-in
    [Tags]   306609  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User     count=1
    Navigate to Calendar tab   device=device_1
    verify meet now icon  device=device_1
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : [Conference Room] [Meet now] Start Meet now and add participant in the meeting
    [Tags]   306610   p2
    [Setup]   Testcase Setup for Meeting User     count=4
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_3,device_4
    pick incoming call    device=device_3,device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
    End meeting       device=device_1,device_2,device_3,device_4
    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC3 : [Conference Room] [Meet now] DUT user can check more options during meeting
    [Tags]   306612   bvt_tpc    sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User     count=4
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3,device_4
    pick incoming call    device=device_2,device_3,device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
    Verify meeting more options     device=device_1:meeting_user
    End meeting      device=device_1,device_2,device_3,device_4
    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC4 : [Conference Room] [Meet now] Start Meet now should display New meeting title, Mic is off, Device and join now options on the screen
    [Tags]   306615  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User     count=1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    close meet now conference page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen    device_list=device_1

TC5 : [Conference Room] [Meet now] Start Meet now and mute all Participants in Conference call
    [Tags]   306617  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User     count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    verify add participant button should visible for presenter   device=device_1
    Add participant to conversation using display name  from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Conference Room] [Meet now] Start Meet now, Verify mute UI on DUT
    [Tags]   306618  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name  from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2   state=Connected
    farmute the call       from_device=device_1       to_device=device_2
    Verify meeting Mute State    device_list=device_2    state=Mute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2

TC7 : [Conference Room] [Meet now] DUT user adds TDC user as participant, mute and unmutes during call
    [Tags]   306619   P2
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Mutes the meeting     device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the meeting    device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2

TC8 : [Conference Room] [Meet now] Start Meet now and Far mute Participants in Conference call
    [Tags]   306613   bvt_tpc    sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    edit the meeting name  device=device_1    new_meeting=Test_Meeting
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    farmute the call       from_device=device_1       to_device=device_2
    Verify meeting Mute State    device_list=device_2    state=Mute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2

TC9 : [Conference Room] [Meet now] DUT user adds more participants to conference call
    [Tags]   306614  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User     count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    edit the meeting name  device=device_1    new_meeting=Test_Meeting
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_3
    pick incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC10 : [Conference Room] [Meet now] Start Meet now, Remove Participants from Conference call
    [Tags]    306620    P2
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    edit the meeting name  device=device_1    new_meeting=Test_Meeting
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Remove user from meeting    from_device=device_1      to_device=device_2
    click back    device=device_1
    verify call control bar in meeting for cnf device   device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC11 : [Conference room UI] Verify user can dial a PSTN number from dial pad screen
    [Tags]   313015   p2
    [Setup]  Testcase Meeting PSTN Setup Main   count=2
    Navigate to Calendar tab   device=device_1
    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Conference Room][Home screen] DUT user joins meeting from Home screen
    [Tags]   306611   bvt_tpc    sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User     count=2
    create meeting  device=device_2     meeting=cnf_device_meeting    participants=device_1:meeting_user
    refresh cnf device for meeting visibility   device=device_1
    Join meeting   device=device_1    meeting=cnf_device_meeting     join_styles=conference
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    count=2

TC13 : [conference room UI]Hide Dark theme/Light theme option in setting.
    [Tags]   306596  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User     count=1
    open settings page  device=device_1
    verify appearance button for conference devices    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

TC14 : [conference room UI]Ambient screen framework of conference room user
    [Tags]   306598  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User     count=1
    verify home screen date and time for cnf device   device=device_1
    verify DID on home screen for cnf device     device=device_1
    verify home screen for cnf device   device=device_1
    [Teardown]  Run Keywords    Capture on Failure     AND    Come back to home screen   device_list=device_1

TC15 : [conference room UI]Dark theme/Light theme option in setting only for personal id.
    [Tags]   306597  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify that sign in is successful   device_list=device_1     state=Sign in
    open settings page  device=device_1
    verify appearance button for conference devices   device=device_1
    sign out method  device=device_1
    sign in method   device=device_1
    open settings page  device=device_1
    verify appearance button for conference devices   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

TC16 : [Conference Room][Home Screen] Hamburger menu not supported on conference room ID
    [Tags]   306605  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify that sign in is successful   device_list=device_1     state=Sign in
    verify home screen for cnf device   device=device_1
    verify home screen date and time for cnf device     device=device_1
    verify DID on home screen for cnf device        device=device_1
    Navigate to Calendar tab   device=device_1
    verify options in calendar tab      device=device_1        phone_number=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

TC17 : [Conference room UI] Verify Settings option under more(..) option .
    [Tags]   313033  p2
    [Setup]  Testcase Setup for Meeting User     count=1
    open settings page   device=device_1
    verify options under settings for cnf device   device=device_1
    verify signout option should be in device settings   device_list=device_1
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen   device_list=device_1

TC18 : [Conference Room][Home Screen] Verify the home screen of the DUT when meeting is scheduled
    [Tags]   306599  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify that sign in is successful   device_list=device_1     state=Sign in
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=Meeting1
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=Meeting2
    refresh cnf device for meeting visibility    device=device_1
    get scheduled meeting name on cnf device     device=device_1
    get scheduled meeting time on cnf device     device=device_1
    get scheduled meeting organizer name on cnf device   device=device_1
    verify join button displayed on conf device  device=device_1
    [Teardown]   Run Keywords   Capture on Failure  AND    Test Case Teardown     devices=device_2     count=2

TC19 : [Conference Room][Home Screen]Verify DUT Home Screen If No- Meetings Scheduled for a Day
    [Tags]   306600  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify that sign in is successful   device_list=device_1     state=Sign in
    verify home screen for cnf device    device=device_1
    refresh cnf device for meeting visibility    device=device_1
    verify no meetings scheduled on saturday    device=device_1
    verify home screen date and time for cnf device  device=device_1
    [Teardown]  Run Keywords   Capture on Failure     AND    Come back to home screen     device_list=device_1

TC20 : [Conference room UI] Verify Home screen UI
    [Tags]   319630  P1
    [Setup]  Testcase Setup for Meeting User     count=1
    verify home screen for cnf device     device=device_1
    [Teardown]    Capture on Failure

TC21 :[Conference room UI] Verify Hot desk and status options does not appear under reveal menu for room account
    [Tags]    319638    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify appearance button for conference devices     device=device_1
    verify status and hotdesk option     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen     device_list=device_1

TC22 : [Conference Room][Home Screen] Verify All day Meeting with Other Meeting on DUT Home Screen
    [Tags]    306602     sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User   count=2
    Create Meeting  device=device_2    participants=device_1:meeting_user        meeting=all_day_meeting1    all_day_meeting=ON
    Create Meeting  device=device_2    participants=device_1:meeting_user        meeting=all_day_meeting2    all_day_meeting=ON
    Create Meeting  device=device_2    participants=device_1:meeting_user        meeting=cnf_device_meeting
    Refresh cnf device for meeting visibility   device=device_1
    Verify meeting under all day event  device=device_1     meetings=all_day_meeting1,all_day_meeting2
    verify meeting has meeting list item join button     device=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND    All Day Event Test Case Teardown     devices=device_2    meeting=all_day_meeting1,all_day_meeting2   count=2

TC23 : [Conference room UI] Verify the meeting card UI when there is only all day meeting(s) on calendar,
    [Tags]    319637    P1
    [Setup]  Testcase Setup for Meeting User   count=2
    Verify that sign in is successful   device_list=device_1     state=Sign in
    Create Meeting  device=device_2    participants=device_1:meeting_user        meeting=all_day_meeting    all_day_meeting=ON
    Refresh cnf device for meeting visibility   device=device_1
    Verify meeting under all day event  device=device_1     meetings=all_day_meeting
    [Teardown]  Run Keywords   Capture on Failure  AND    All Day Event Test Case Teardown     devices=device_2    meeting=all_day_meeting      count=2

TC24 : [Conference Room] [Home Screen] Verify Available should be display on DUT Home Screen.
    [Tags]   306603   bvt_tpc    sanity_tpc  P0
    [Setup]    run keywords   Testcase Setup for Meeting User   count=2   AND  clear meetings from calendar tab     devices=device_2
    Refresh cnf device for meeting visibility   device=device_2
    verify calendar empty   device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC25 : [Conference Room] [Meet now] Start Meet now, Remove Participants from Conference call
    [Tags]    306166    P2
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    edit the meeting name  device=device_1    new_meeting=Test_Meeting
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Remove user from meeting    from_device=device_1      to_device=device_2
    click back    device=device_1
    verify call control bar in meeting for cnf device   device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

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

All Day Event Test Case Teardown
    [Arguments]     ${devices}      ${meeting}   ${count}
    check for device count      count=${count}
    Delete all day meetings      ${devices}    ${meeting}
    Come back to home screen    ${devices}
    Remove meeting from calender for meeting policy test      ${count}