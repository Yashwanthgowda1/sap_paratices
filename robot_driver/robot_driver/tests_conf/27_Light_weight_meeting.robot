*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup    Lightweight Meeting Test case Setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1: [Light weight meeting] Verfiy that under calling option, user can enable/ disable the "Enable lightweight meeting experience"
    [Tags]   401906     P1
    [Setup]  Testcase Setup for Meeting User   count=1
    disable lightweight meeting experience     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND   enable lightweight meeting experience   device=device_1  AND   Come back to home screen     device_list=device_1

TC2: [Light weight meeting] Verify the UI after joining the meeting from Homescreen
    [Tags]   401907     bvt_tpc  sanity_tpc  P0
    [Setup]  Run Keywords   Testcase Setup for Meeting User   count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure     AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC3: [Light weight meeting] Verify the UI after joining the meeting from meeting join option under calendar.
    [Tags]    401908      bvt_tpc    sanity_tpc  P0
    [Setup]   Run Keywords    Testcase Setup for Meeting User   count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1      participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC4: [Light weight meeting] Verify the Enable lightweight meeting experience" option is present under meeting option.
    [Tags]   401909      P1
    [Setup]   Testcase Setup for Meeting User    count=1
    verify meetings option under app settings page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure     AND   Come back to home screen     device_list=device_1

TC5: [Light weight meeting] Verify the UI when the other participant (TDC1/DUT2/or any participant present in the meeting) ask to join the meeting.
    [Tags]     401910   sanity_tpc   P1
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=3    AND    verify meeting present    device=device_1
    Join Meeting    device=device_2,device_3     meeting=lightweight_meeting
    verify meeting state   device_list=device_2,device_3       state=connected
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_2        to_device=device_1:meeting_user
    pick incoming call  device=device_1
    verify meeting state   device_list=device_1       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2,device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3

TC6: [Light weight meeting] Verify more options(...) in a meeting.
    [Tags]  401917    P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User  count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2      meeting=lightweight_meeting        join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC7: [Lightweight meeting] Verify "Tap to return call" banner in other tabs.
    [Tags]  401940    P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User  count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2      meeting=lightweight_meeting        join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2     state=Connected
    click back    device=device_1
    tap to return to meeting  device=device_1     action=verify
    navigate to people tab    device=device_1
    tap to return to meeting  device=device_1     action=verify
    join meeting from tap to return banner   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2      state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC8: [Lightweight stage] Verify that Lightweight Experience should be enabled by default under meeting option.
    [Tags]    401949     P0  sanity_tpc  bvt_tpc
    [Setup]   Testcase Setup for Meeting User   count=1
    verify lightweight meeting experience in meeting option     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC9: Verify live captions in a meeting
    [Tags]    401914      bvt_tpc    sanity_tpc  P0
    [Setup]   Run Keywords    Testcase Setup for Meeting User   count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1      participants=device_2
    turn on live caption and validate    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC10: Verify Turn off live captions in a meeting
    [Tags]   401915      P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User   count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1      participants=device_2
    turn on live caption and validate    device=device_1
    turn off live caption and validate    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC11: [Light weight meeting] Verify the reactions button while in a meeting.
    [Tags]    401911     bvt_tpc     sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User    count=2
    create meeting   device=device_2    meeting=Reactions     participants=device_1:meeting_user
    Join Meeting    device=device_1,device_2      meeting=Reactions      join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify presence of reactions button in call control     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   testcase teardown setup for remove meeting  device=device_1      to_device=device_2      meeting=Reactions

TC12: [Light weight meeting] Verify the raise hand in a meeting
    [Tags]     401912      P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify presence of reactions button in call control     device=device_1
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC13: [Lightweight meeting] Verify the meeting UI and toggle button (Resume/Hold) when user switches the meeting.
    [Tags]   401944  sanity_tpc  P1
    [Setup]    Run Keywords    Testcase Setup for Meeting User     count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    switch meeting from one meeting to another meeting   device=device_1:meeting_user     current_meeting=lightweight_meeting    next_meeting=meeting_lightweight_01
    verify meeting state   device_list=device_1,device_2       state=connected
    resume the meeting      device=device_1
    Wait for Some Time    time=${wait_time}
    resume the meeting      device=device_1
    verify meeting title in hold banner  device=device_1        meeting_1=meeting_lightweight_01     meeting_2=lightweight_meeting
    end meeting from hold banner        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC14: Verify the UI after joining the meeting from Meet now
    [Tags]    401913    sanity_tpc   P1
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify presence of reactions button in call control    device=device_1
    verify meeting more options      device=device_1:meeting_user
    verify manage audio and video option    device=device_1     count=2    role=organiser
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Verify meet now close button  device=device_1   AND   Come back to home screen   device_list=device_1,device_2

TC15: [Lightweight meeting] Verify the meeting UI when user is already in a call.
    [Tags]   401945  sanity_tpc  P1
    [Setup]    Run Keywords    Testcase Setup for Meeting User   count=2    AND    verify meeting present    device=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name  from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State     device_list=device_1,device_2    state=Connected
    click back     device=device_1
    Join Meeting    device=device_1     meeting=lightweight_meeting     join_styles=conference
    verify call state     device_list=device_1    state=Hold
    verify lightweight meeting ui   device=device_1      participants=device_1:meeting_user
    end meeting from hold banner        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND  Test Case Teardown without deleting meeting     devices=device_1,device_2

TC16: [Lightweight meeting] Verify full meeting experience in more option.
    [Tags]  401937   sanity_tpc  P1
    [Setup]    Run Keywords    Testcase Setup for Meeting User     count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify full meeting experience option in meeting    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC17: [Light weight meeting] Verify the mic status in a meeting.
    [Tags]  401923     P1
    [Setup]    Run Keywords    Testcase Setup for Meeting User     count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1,device_2    state=mute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC18: [Light weight meeting] Verify people option in a meeting.
    [Tags]  401926     P1
    [Setup]    Run Keywords    Testcase Setup for Meeting User     count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2      meeting=lightweight_meeting        join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify manage audio and video option  device=device_1    count=2     role=presenter
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC19: [Light weight meeting]"Tap to return to meeting" should display on all the tiles.
    [Tags]   401925     P1
    [Setup]   Run Keywords    Testcase Setup for Meeting User  count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2      meeting=lightweight_meeting        join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2     state=Connected
    click back    device=device_1
    navigate to calendar tab   device=device_1
    tap to return to meeting  device=device_1     action=verify
    navigate to people tab    device=device_1
    tap to return to meeting  device=device_1     action=verify
    join meeting from tap to return banner   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2      state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC20: [Lightweight meeting] Verify the meeting UI when DUT user switches between the meeting.
    [Tags]   401943     P1
    [Setup]    Run Keywords    Testcase Setup for Meeting User     count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    switch meeting from one meeting to another meeting   device=device_1:meeting_user     current_meeting=lightweight_meeting    next_meeting=meeting_lightweight_01
    verify meeting state   device_list=device_1,device_2       state=connected
    Wait for Some Time    time=${wait_time}
    verify meeting title in hold banner  device=device_1        meeting_1=lightweight_meeting     meeting_2=meeting_lightweight_01
    end meeting from hold banner        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC21: [Lightweight meeting] Verify the meeting UI when DUT user rejects the incoming call in an ongoing meeting.
    [Tags]  401946     P1
    [Setup]   Run Keywords    Testcase Setup for Meeting User  count=3    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2      meeting=lightweight_meeting        join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2     state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:meeting_user
    reject incoming call when already in call     device_list=device_1
    Wait for Some Time    time=${wait_time}
    verify call state and disconnect        device=device_3
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2      state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3

TC22: [Lightweight stage] Verify that Raise hand should be displayed on the main screen as well as in the meeting roaster.
    [Tags]    416649   P1    sanity_tpc
    [Setup]   Testcase Setup for Meeting User    count=2
    create meeting  device=device_2       participants=device_1:meeting_user       meeting=rise_hand_meeting
    Join Meeting    device=device_1,device_2     meeting=rise_hand_meeting       join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND   delete specific meeting    device=device_2    meeting=rise_hand_meeting

TC23: [lightweight stage] Verify no reactions should be present under more option.
    [Tags]    416648    P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify reactions options not present in call more options     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    #AND    Test Case Teardown     devices=device_2     count=2

TC24: [Lightweight meeting] Verify the UI when DUT user disable the "Enable lightweight meeting experience option" under meeting.
    [Tags]     401947      P1
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=2    AND    verify meeting present    device=device_1
    disable lightweight meeting experience     device=device_1
    go back to previous page     device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify legacy meeting ui        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND     enable lightweight meeting experience   device=device_1    AND   Come back to home screen     device_list=device_1,device_2

TC25: [Light weight meeting] Verify the live caption when DUT user raise hand in a meeting.
    [Tags]   401916    P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1      participants=device_2
    turn on live caption and validate    device=device_1
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure      AND   Come back to home screen     device_list=device_1

TC26: [Light weight meeting] Verify All day meeting in calendar.
    [Tags]    401931        P2
    [Setup]   Testcase Setup for Meeting User   count=2
    create meeting   device=device_2    meeting=lightweight_all_day    participants=device_1:meeting_user   all_day_meeting=ON
    Refresh cnf device for meeting visibility   device=device_1
    Verify meeting under all day event  device=device_1     meetings=lightweight_all_day
    Verify meeting under all day event  device=device_2     meetings=lightweight_all_day
    join meeting from all day meeting tab   device=device_1,device_2     meeting=lightweight_all_day
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1   AND  All Day Event Test Case Teardown     devices=device_2    meeting=lightweight_all_day   count=2

TC27: [Lightweight meeting] Verify the UI when DUT user makes an outgoing PSTN call in an ongoing meeting
    [Tags]    401948    sanity_tpc    P1
    [Setup]     Run Keywords    Testcase Meeting PSTN Setup Main   count=3    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_3     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_3       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_3
    click back      device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2    state=Disconnected
    resume the meeting      device=device_1
    verify lightweight meeting ui   device=device_1     participants=device_3
    End meeting     device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3

TC28: [Light weight meeting] Verify that when DUT is an attendee and hand is lowered by the organizer proper message should be displayed.
    [Tags]   401927    P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
    Verify you are an attendee now notification     device=device_1
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    verify and lower hand for attendee  from_device=device_2   to_device=device_1:meeting_user
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC29: [Light weight meeting] Verify that "Your mic has been disabled" message should be displayed.
    [Tags]   401924     P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=2    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
    Verify you are an attendee now notification     device=device_1
    verify and allow individual permissions to attendees   from_device=device_2       to_device=device_1:meeting_user
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC30: [Light weight meeting]Verify that user should be able to select a meeting participant (Non- Attendee) and view their profile or request them to join the meeting.
    [Tags]   401928    P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=3    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_1        to_device=device_3
    pick incoming call  device=device_3
    verify meeting state   device_list=device_3       state=connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC31: [Light weight meeting]DUT user to verify the profile of other invited participant in a ongoing meeting
    [Tags]      401929        P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User    count=3    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_1        to_device=device_3       option=view_profile
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2

TC32:[Light weight meeting] Verify that user should be able to select a meeting participant (non-Attendee) and request them to join a meeting.
    [Tags]   401930    P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User  count=3    AND    verify meeting present    device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting     join_styles=conference,None
    verify meeting state   device_list=device_1,device_2       state=connected
    verify manage audio and video option  device=device_1    count=2     role=presenter
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_1        to_device=device_3
    pick incoming call  device=device_3
    verify meeting state   device_list=device_3       state=connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3

*** Keywords ***
teardown lightweight meeting experience
    [Arguments]     ${device}
    enable lightweight meeting experience     device=${device}
    come back to home screen  device_list=${device}

Lightweight Meeting Test case Setup
    clear meetings from calendar tab    devices=device_2
    create meeting    device=device_2    meeting=lightweight_meeting    participants=device_1:meeting_user,device_3     meeting_time=on      meeting_duration=60
    create meeting     device=device_2    meeting=meeting_lightweight_01    participants=device_1:meeting_user,device_3
    enable lightweight meeting experience   device=device_1
    Come back to home screen     device_list=device_1

testcase teardown setup for remove meeting
    [Arguments]     ${device}      ${to_device}     ${meeting}
    navigate to calendar tab    ${to_device}
    delete specific meeting     device=${to_device}      meeting=${meeting}
    come back to home screen    device_list=${device},${to_device}

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}
    Come back to home screen    ${devices}
    Teardown Meeting Test Case     ${devices}

Verify meeting state
    [Arguments]     ${device_list}      ${state}
    Verify Call State    ${device_list}     ${state}

All Day Event Test Case Teardown
    [Arguments]     ${devices}      ${meeting}   ${count}
    check for device count      count=${count}
    Delete all day meetings      ${devices}    ${meeting}
    Come back to home screen    ${devices}
    Remove meeting from calender for meeting policy test      ${count}

verify meeting present
    [Arguments]    ${device}
    navigate to calendar tab    ${device}
    ${meeting_name}=    verify meeting name present    device=${device}    meeting=lightweight_meeting
    Run Keyword If    '${meeting_name}' == 'True'    clear meetings from calendar tab    devices=device_1,device_2    exclude_meeting=meeting_lightweight_01
       Create Meeting    device=device_2    meeting=lightweight_meeting    participants=device_1:meeting_user,device_3    meeting_time=on    meeting_duration=60
