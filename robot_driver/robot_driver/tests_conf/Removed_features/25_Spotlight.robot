#Suite Setup     Meeting Setup
#Suite Teardown    Suite Failure Capture
#
#*** Variables ***
#${wait_time} =   10
#
#
#*** Test Cases ***
#TC1 : [Spotlight] TDC user able to enable and spotlight during the meeting
#    [Tags]  306241    bvt_tpc    sanity_tpc  P0
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=cnf_device_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an spotlight   from_device=device_2   to_device=device_1:meeting_user
#    verify spotlight icon for user   device=device_1
#    verify spotlight avatar   device_list=device_3
#    remove spotlight  from_device=device_2    to_device=device_1:meeting_user
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC2 : [Spotlight] Spotlight overrides the Pin in the meeting
#    [Tags]  306243   bvt_tpc     sanity_tpc  P0
#    [Setup]    Testcase Setup for Meeting User   count=4
#    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting     join_styles=conference,None,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_2      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify meeting state   device_list=device_1,device_2,device_3,device_4     state=Connected
#    make an pin    from_device=device_1    to_device=device_3
#    verify participant name which is pinned in main stage    device_list=device_1
#    make an spotlight   from_device=device_2   to_device=device_4
#    verify participant name which is spotlighted in main stage    device_list=device_1
#    verify participant name which is pinned in main stage      device_list=device_1
#    remove spotlight    from_device=device_2   to_device=device_4
#    verify participant name which is pinned in main stage       device_list=device_1
#    End meeting     device=device_1,device_2,device_3,device_4
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3,device_4     count=4
#
#TC3 : [Spotlight] Remove spotlight option should be displayed for spotlighted participant
#    [Tags]  306245    p2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=cnf_device_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an spotlight   from_device=device_2   to_device=device_1:meeting_user
#    verify remove spotlight option  from_device=device_3   to_device=device_1:meeting_user
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC4 : [Spotlight] Spotlighted should end once the spotlighted user leave the meeting
#    [Tags]  306247    p2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=cnf_device_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an pin   from_device=device_2     to_device=device_1:meeting_user
#    make an spotlight   from_device=device_2   to_device=device_3
#    End meeting     device=device_3
#    verify participant name which is pinned in main stage   device_list=device_2
#    Join Meeting    device=device_3         meeting=cnf_device_meeting
#    verify no spotlight icon for user in add participant page    device=device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC5 : [Spotlight]Verify that Pin icon should not replaces Spotlight icon if participant that user has pinned was Spotlight by organizer
#    [Tags]  319120    p2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=cnf_device_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify presenter options in meeting from organizer or presenter   from_device=device_2   to_device=device_1:meeting_user
#    make an spotlight   from_device=device_2   to_device=device_1:meeting_user
#    verify participant name which is spotlighted in main stage   device_list=device_2,device_3
#    verify spotlighted participant can not pin from other participant  from_device=device_3     to_device=device_1:meeting_user
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC6 : [Spotlight] User clicking on spotlight icon there should not be any popup/Notification
#    [Tags]  306246   p2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=cnf_device_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an spotlight   from_device=device_2   to_device=device_1:meeting_user
#    verify participant name which is spotlighted in main stage   device_list=device_2,device_3
#    check display when clicked on spotlight icon     device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC7 :[Reactions] DUT user to verify the reactions when the user is displayed on the main stage of TDC user
#    [Tags]  248189   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2     meeting=Reactions       join_styles=conference,None
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify reaction button in call control     device=device_1
#    make an spotlight  from_device=device_2      to_device=device_1:meeting_user
#    Tap on reaction button in call control      device=device_1
#    Tap on like button    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2   count=2

#TC8:[Lightweight meeting] Verify DUT has an option to spotlight DUT user.
#    [Tags]   401933    P2
#    [Setup]   Testcase Setup for Meeting User  count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=lightweight_meeting        join_styles=conference,None,None
#    verify meeting state   device_list=device_1,device_2,device_3       state=connected
#    verify lightweight meeting ui   device=device_1     participants=device_2,device_3
#    verify manage audio and video option  device=device_1    count=3     role=presenter
#    make an spotlight   from_device=device_1   to_device=device_2
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3

#TC9:[Lightweight meeting] Verify DUT has an remove spotlight option to the spotlighted participant.
#    [Tags]   401934    P2
#    [Setup]   Testcase Setup for Meeting User  count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=lightweight_meeting        join_styles=conference,None,None
#    verify meeting state   device_list=device_1,device_2,device_3       state=connected
#    verify lightweight meeting ui   device=device_1     participants=device_2,device_3
#    verify manage audio and video option  device=device_1    count=3     role=presenter
#    make an spotlight   from_device=device_1   to_device=device_2
#    remove spotlight  from_device=device_1    to_device=device_2    action=verify
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3

#TC10: [Light weight meeting] Verify Spotlight participant in the meeting.
#    [Tags]  401932     P2
#    [Setup]   Testcase Setup for Meeting User  count=3
#    Join Meeting    device=device_1,device_2,device_3      meeting=lightweight_meeting       join_styles=conference,None,None
#    Verify meeting state   device_list=device_1,device_2,device_3      state=Connected
#    Wait for Some Time    time=${wait_time}
#    verify manage audio and video option  device=device_1    count=3     role=presenter
#    make an spotlight    from_device=device_3   to_device=device_1:meeting_user
#    verify spotlight icon for user   device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3       state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3

#*** Keywords ***
#Meeting Setup
#    create meeting    device=device_2       participants=device_1:meeting_user,device_3     meeting=cnf_device_meeting
#
#Test Case Teardown without deleting meeting
#    [Arguments]     ${devices}   ${count}
#    check for device count      count=${count}
#    Come back to home screen    ${devices}
#    Close dial pad  device=device_1
#    Teardown Meeting Test Case     ${devices}
