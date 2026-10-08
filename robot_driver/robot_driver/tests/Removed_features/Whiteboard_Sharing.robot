*** Comments ***
Force Tags    whiteboard_sharing    45  alt_bug    alt_blocked
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

# Suite Setup     Meeting Setup
# Suite Teardown    Run Keywords    Suite Failure Capture    AND   Meeting teardown

*** Variables ***
${wait_time} =  10

*** Test Cases ***
# TC1 : [Whiteboard Sharing] DUT user should have an option to share whiteboard during meeting
#     [Tags]  248095   bvt    bvt_pr
#     [Setup]    Testcase Setup   count=2
#     Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#     Wait for Some Time    time=${wait_time}
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify whiteboard sharing option under more option for ipphone      device=device_1
#     Verify whiteboard sharing option under more option for ipphone      device=device_2
#     [Teardown]  Run Keywords    Capture on Failure    AND    test case teardown without deleting meeting    devices=device_1,device_2

#TC2 : [Whiteboard Sharing]DUT user to share whiteboard during meeting
#    [Tags]   248096   p1
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    [Teardown]  Run Keywords    Capture on Failure  AND    test case teardown without deleting meeting    devices=device_1,device_2
#
#TC3 : [Whiteboard Sharing]DUT user to verify the whiteboard tools during meeting
#    [Tags]   248099   p1
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND   test case teardown without deleting meeting    devices=device_1,device_2
#
#TC4 : [Whiteboard Sharing]DUT user to access whiteboard tools during meeting
#    [Tags]   248101   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Verify whiteboard tools functionality     devices=device_1
#    [Teardown]  Run Keywords    Capture on Failure     AND    test case teardown without deleting meeting    devices=device_1,device_2
#
#TC5 : [Whiteboard Sharing]DUT user to verify the text editing on whiteboard
#    [Tags]   248133   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Verify text editing     device=device_1     text=testing
#    [Teardown]  Run Keywords    Capture on Failure     AND   Delete text from whiteboard sharing    device=device_1     text=testing   AND   test case teardown without deleting meeting    devices=device_1,device_2
#
#TC6 : [Whiteboard Sharing]DUT user to delete the text on the whiteboard
#    [Tags]   248135   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Verify text editing     device=device_1     text=testing
#    Delete text from whiteboard sharing    device=device_1     text=testing
#    [Teardown]  Run Keywords    Capture on Failure    AND   test case teardown without deleting meeting    devices=device_1,device_2
#
#TC7 : [Whiteboard Sharing]DUT user to verify the stick notes on Whiteboard
#    [Tags]   248138   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Verify yellow sticky note editing     device=device_1     text=sticky_testing
#    [Teardown]  Run Keywords    Capture on Failure     AND   Delete yellow sticky note from whiteboard sharing    device=device_1     text=sticky_testing   AND   test case teardown without deleting meeting    devices=device_1,device_2
#
#TC8 : [Whiteboard Sharing]DUT user to delete the sticky notes from the Whiteboard
#    [Tags]   248148   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Verify yellow sticky note editing     device=device_1     text=sticky_testing
#    Delete yellow sticky note from whiteboard sharing    device=device_1     text=sticky_testing
#    [Teardown]  Run Keywords    Capture on Failure     AND    test case teardown without deleting meeting    devices=device_1,device_2
#
#TC9 : [Whiteboard Sharing]DUT user to navigate to call screen when whiteboard is being shared
#    [Tags]   248151   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Click back    device=device_1,device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify Whiteboard is being shared notification     device=device_1
#    Open whiteboard sharing screen from notification     device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND     test case teardown without deleting meeting    devices=device_1,device_2
#
#TC10 : [Whiteboard Sharing]DUT user to stop presenting the whiteboard
#    [Tags]   248162   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Click back    device=device_1,device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify Whiteboard is being shared notification     device=device_1
#    Stop whiteboard sharing from more option     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    test case teardown without deleting meeting    devices=device_1,device_2

#TC11 : [Whiteboard Sharing] DUT user to mute the call from whiteboard screen
#    [Tags]   248157   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Mutes the meeting from whiteboard sharing screen   device=device_1
#    Click back    device=device_1,device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify meeting Mute State    device_list=device_1    state=mute
#    [Teardown]  Run Keywords    Capture on Failure    AND    test case teardown without deleting meeting    devices=device_1,device_2
#
#TC12 : [Whiteboard Sharing] DUT user to verify settings option on whiteboard
#    [Tags]   248166   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Verify settings option on whiteboard   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND   test case teardown without deleting meeting    devices=device_1,device_2
#
#TC13 : [Whiteboard Sharing] Incoming call during meeting when DUT shared whiteboard
#    [Tags]   248176   p2
#    [Setup]    Testcase Setup   count=3
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Rejects the incoming call   device_list=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND   test case teardown without deleting meeting    devices=device_1,device_2
#
#TC14 : [Whiteboard Sharing] Rejoin for the same meeting should not create new whiteboard
#    [Tags]   248179   p2
#    [Setup]    Testcase Setup   count=3
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_1
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify text editing     device=device_1     text=testing
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    Come back to home screen    device_list=device_1,device_2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify text from whiteboard sharing     device=device_1     text=testing
#    Delete text from whiteboard sharing    device=device_1     text=testing
#    [Teardown]  Run Keywords    Capture on Failure    AND   test case teardown without deleting meeting    devices=device_1,device_2





#TC5 : [Whiteboard Sharing]DUT user to erase the written contents on whiteboard
#    [Tags]   248105   p2
#    [Setup]    Testcase Setup   count=2
#    Join meeting   device=device_1,device_2    meeting=whiteboard_sharing_meeting
#    Wait for Some Time    time=${wait_time}
##    Verify meeting state   device_list=device_1,device_2    state=Connected
##    Verify whiteboard sharing option under more option for ipphone      device=device_1
##    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Verify whiteboard tools     devices=device_1
#    Write something using pen   device=device_1    pen_color=red
#    Click back      device=device_1,device_2
#    [Teardown]  Run Keywords    Capture on Failure     AND    All TC Teardown


*** Keywords ***
Meeting Setup
    Testcase Setup    count=2
    clear meetings from calendar tab   devices=device_1,device_2
    create meeting  device=device_1       participants=device_2    meeting=whiteboard_sharing_meeting
    Refresh for Meeting Visibility      device=device_2

Meeting teardown
    Test Case Teardown     devices=device_1,device_2     count=2

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}
    Come back to home screen    ${devices}
    Teardown Meeting Test Case     ${devices}

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    come_back_home_screen_for_user    ${count}
    Teardown Meeting Test Case     ${devices}
    remove_meeting_from_calender_for_user   ${count}

All TC Teardown
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    Come back to home screen    device_list=device_1,device_2
