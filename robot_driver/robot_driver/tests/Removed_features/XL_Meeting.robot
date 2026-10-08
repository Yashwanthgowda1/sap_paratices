#*** Settings ***
#Force Tags    xl_meeting
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#Suite Setup     Meeting Setup
##Suite Teardown  Meeting teardown
#
#*** Variables ***
#${wait_time} =  10
#
#
#*** Test Cases ***
#TC1 : Verify that Teams App is able to join the meeting by tapping on join button
#    [Tags]    222169    bvt
#    [Setup]   Testcase Setup    count=1
#    Navigate to Calendar tab   device=device_1
#    Verify join button displayed   device=device_1
#    Join meeting    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    End meeting     device=device_1
#    Verify meeting state   device_list=device_1    state=Disconnected
#    [Teardown]   Run Keywords   Capture on Failure     AND     Come back to home screen    device_list=device_1
#
#TC2 : Verify that Scheduled meeting is present in calender tab after sign in
#    [Tags]    224273    bvt
#    [Setup]   Testcase Setup    count=1
#    Navigate to Calendar tab   device=device_1
#    Select Meeting      device=device_1
#    [Teardown]    Capture on Failure
#
#TC3 : Verify that meeting is displayed with join button
#    [Tags]    222140    p1
#    [Setup]   Testcase Setup    count=1
#    Navigate to Calendar tab   device=device_1
#    Select Meeting      device=device_1
#    Verify join button displayed   device=device_1
#    [Teardown]    Capture on Failure
#
#TC4 : Verify that Teams App user can add another Teams App user to the meeting
#    [Tags]    222143    222142    p1
#    [Setup]   Testcase Setup    count=2
#    Join Meeting    device=device_1
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    pick incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure   AND    Test Case Teardown without deleting meeting     devices=device_1
#
#TC5 : Verify that Teams App user can add PSTN user to the meeting
#    [Tags]    222144   p1
#    [Setup]   Testcase Setup for PSTN User    count=2
#    Join Meeting    device=device_1
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
#    pick incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure   AND    Test Case Teardown without deleting meeting     devices=device_1
#
#TC6 : Verify that Teams App user can mute all other participants
#    [Tags]    222147   p1
#    [Setup]   Testcase Setup    count=3
#    create meeting  device=device_1   meeting=test_meeting1
#    Join Meeting    device=device_1     meeting=test_meeting1
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Mute all participants       device=device_1
#    Verify meeting Mute State    device_list=device_2    state=Mute
#    Verify meeting Mute State    device_list=device_3    state=Mute
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure   AND   Test Case Teardown     devices=device_1    meeting=test_meeting1   count=3
#
#TC7 : Raise hand in the meeting
#    [Tags]    222148    P2
#    [Setup]   Testcase Setup    count=3
#    create meeting  device=device_1   meeting=test_meeting2
#    Join Meeting    device=device_1     meeting=test_meeting2
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Raise hand     device=device_1
#    Verify raise hand    from_device=device_2    to_device=device_1
#    Verify raise hand    from_device=device_3    to_device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_1    meeting=test_meeting2   count=3
#
#TC8 : Lower hand in the meeting
#    [Tags]    222149    P2
#    [Setup]   Testcase Setup    count=3
#    create meeting  device=device_1   meeting=test_meeting3
#    Join Meeting    device=device_1     meeting=test_meeting3
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Raise hand     device=device_1
#    Verify raise hand    from_device=device_2    to_device=device_1
#    Verify raise hand    from_device=device_3    to_device=device_1
#    Lower hand     device=device_1
#    Verify raise hand symbol    from_device=device_2    status=off
#    Verify raise hand symbol    from_device=device_3    status=off
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_1    meeting=test_meeting3   count=3
#
#TC9 : Verify that call roster screens like Hands Raised, In Lobby and others Invited are present in the ongoing meeting screen
#    [Tags]    222150    P1
#    [Setup]   Testcase Setup    count=4
#    create meeting  device=device_1   meeting=test_meeting4
#    Join Meeting    device=device_1     meeting=test_meeting4
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3,device_4
#    pick incoming call    device=device_2,device_3,device_4
#    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
#    Raise hand symbol verification on call roster screen    device=device_1
#    ${participant_count}     Get participant count     from_device=device_1      connected_device_list=device_1,device_2,device_3,device_4
#    Log   Participant count is : ${participant_count}
#    End meeting     device=device_1,device_2,device_3,device_4
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_1    meeting=test_meeting4   count=4
#
#TC10 : Verify that add participants rectangular button is present
#    [Tags]    222151    P1
#    [Setup]   Testcase Setup    count=3
#    create meeting  device=device_1   meeting=test_meeting5
#    Join Meeting    device=device_1     meeting=test_meeting5
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Add participants symbol verification on call roster screen    device=device_1
#    Navigate to add participant page    device=device_1
#    ${participant_list}     Get participant list    from_device=device_1
#    Log   Participant list is : ${participant_list}
#    Back to meeting page    device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_1    meeting=test_meeting5   count=3
#
#TC11 : Verify that participants counts are displayed properly
#    [Tags]    222152    P1
#    [Setup]   Testcase Setup    count=3
#    create meeting  device=device_1   meeting=test_meeting6
#    Join Meeting    device=device_1     meeting=test_meeting6
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    ${participant_count}     Get participant count     from_device=device_1      connected_device_list=device_1,device_2,device_3
#    Log   Participant count is : ${participant_count}
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_1    meeting=test_meeting6   count=3
#
#
#
#
#
#*** Keywords ***
#Meeting Setup
#    Testcase Setup    count=1
#    Create Meeting  device=device_1
#
#Test Case Teardown
#    [Arguments]     ${devices}      ${meeting}    ${count}
#    come_back_home_screen_for_user    ${count}
#    Teardown Meeting Test Case     ${devices}
#    Delete meeting      ${devices}    ${meeting}
#    remove_meeting_from_calender_for_user   ${count}
#
#Test Case Teardown without deleting meeting
#    [Arguments]     ${devices}
#    Come back to home screen    ${devices}
#    Teardown Meeting Test Case     ${devices}
