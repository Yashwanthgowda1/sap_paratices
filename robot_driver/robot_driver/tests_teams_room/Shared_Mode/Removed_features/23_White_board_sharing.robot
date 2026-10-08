#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Library     DateTime
#Library     OperatingSystem
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC14:[Whiteboard Sharing] Incoming call during meeting when DUT shared whiteboard
#    [Tags]      305663      P1
#    [Setup]  Testcase Setup for Meeting User   count=3
#    Verify meeting display on home screen     device=device_1
#    Join the meeting        device=tdc_1:non_pro_user      meeting_name=whiteboard_sharing_meeting
#    Join meeting   device=device_1,device_2         meeting=whiteboard_sharing_meeting
#    Verify and click on white board sharing in call control bar   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Make outgoing call with phonenumber    from_device=device_3     to_device=device_1
#    verify user should not get second incoming call     device=device_1
#    Stop presenting whiteboard share screen   device=device_1
#    Wait for Some Time    time=${wait_time}
#    Disconnect the call on TDC      device=tdc_1:non_pro_user
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC9:[Whiteboard Sharing] DUT user to mute the call from whiteboard screen
#     [Tags]      305655    P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join the meeting        device=tdc_1:non_pro_user      meeting_name=whiteboard_sharing_meeting
#    Join meeting   device=device_1,device_2         meeting=whiteboard_sharing_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify whiteboard sharing option under more option   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Mutes the phone call    device=device_2
#    Verify meeting Mute State    device_list=device_2    state=mute
#    Unmutes the phone call   device=device_1
#    Verify meeting Mute State    device_list=device_1    state=unmute
#    Stop presenting whiteboard share screen     device=device_1
#    Wait for Some Time    time=${wait_time}
#    Disconnect the call on TDC      device=tdc_1:non_pro_user
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC8:[Whiteboard Sharing]DUT user to access whiteboard tools during meeting
#    [Tags]      305647      P2
#    [Setup]  Testcase Setup for Meeting User   count=2
#    Verify meeting display on home screen     device=device_1
#    Join the meeting        device=tdc_1:non_pro_user      meeting_name=whiteboard_sharing_meeting
#    Join meeting   device=device_1,device_2         meeting=whiteboard_sharing_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Verify whiteboard tools display on screen    device=device_1
#    Stop presenting whiteboard share screen   device=device_1
#    Wait for Some Time    time=${wait_time}
#    Disconnect the call on TDC      device=tdc_1:non_pro_user
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC23:[Whiteboard]DUT user Disable the Whiteboard from the Teams admin settings.
#    [Tags]     339424        P2
#    [Setup]  Testcase Setup for Meeting User     count=1
#    navigate to teams admin settings page   device=device_1
#    Enable and disable white board sharing toggle     device=device_1     state=off
#    come back from admin settings page     device_list=device_1
#    verify whiteboard sharing option is not present in home screen  device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1       AND     Enable the whiteboard sharing   device=device_1

#TC12:[Whiteboard]Verify DUT user should be able to see MS Whiteboard option in home screen
#    [Tags]   339392   P2
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    verify white board is in home page screen     device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1

#*** Keywords ***
