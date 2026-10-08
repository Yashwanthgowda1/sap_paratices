#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    pm_whiteboard  03   pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#*** Test Cases ***
#TC1: [Whiteboard Sharing] DUT user should have an option to share whiteboard during meeting
#    [Tags]  241729   bvt   bvt_pm
#    [Setup]  Testcase Setup     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option on call control bar   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC2: [Whiteboard Sharing] DUT user to share whiteboard during meeting
#    [Tags]  241730   sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Refresh Meeting visibility   device=device_1
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar     device=device_1
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC3: [Whiteboard Sharing] Incoming call during meeting when DUT shared whiteboard
#    [Tags]  241733   sanity_pm
#    [Setup]  Testcase Setup     count=3
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=device_1
#    Make outgoing call with phonenumber    from_device=device_3     to_device=device_1
#    Verify incoming call notification   device=device_1
#    Stop presenting whiteboard share screen  device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4: [Whiteboard Sharing] DUT user to verify settings option on whiteboard
#    [Tags]  229145   P1
#    [Setup]  Testcase Setup     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=device_1
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Verify sliding menu option inside settings icon    device=device_1
#    Stop presenting whiteboard share screen   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC5: [Whiteboard Sharing]DUT user to verify the whiteboard tools during meeting
#    [Tags]  229134  bvt   bvt_pm
#    [Setup]  Testcase Setup     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=device_1
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Verify whiteboard tools display on screen    device=device_1
#    Stop presenting whiteboard share screen   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC6: [Whiteboard Sharing]DUT user to navigate to call screen when whiteboard is being shared
#    [Tags]  229142   P2
#    [Setup]  Testcase Setup     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=device_1
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Navigate back to call screen after tapping on back button  device=device_1
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC7: [Whiteboard Sharing] DUT user to mute the call from whiteboard screen
#    [Tags]  229143   P2
#    [Setup]  Testcase Setup     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=device_1
#    Check for whiteboard visibility of participants and validate   from_device=device_1    connected_device_list=device_1,device_2
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Stop presenting whiteboard share screen   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC8: [Whiteboard Sharing] DUT user to stop presenting the whiteboard
#    [Documentation]  Tested for DUT only
#    [Tags]  229144   bvt   bvt_pm
#    [Setup]  Testcase Setup     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=device_1
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Stop presenting whiteboard share screen    device=device_1
#    Verify call screen state after tapping on stop presenting button    device_list=device_1,device_2    state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC9: [Whiteboard Sharing]DUT user to access whiteboard tools during meeting
#    [Tags]  229135    sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify participants list in meeting     device=device_1
#    Verify and click on white board sharing in call control bar   device=device_1
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Verify whiteboard tools display on screen   device=device_1
#    Verify functionality of whiteboard tools   device=device_1
#    Stop presenting whiteboard share screen   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC10 : [Whiteboard Sharing] Rejoin for the same meeting should not create new whiteboard
#    [Documentation]  Tested for DUT only
#    [Tags]  229152  P1
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Verify and click on white board sharing in call control bar   device=device_1
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Verify text editing on whiteboard share screen   device=device_1   text=testing_wb
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    Come back to home screen page    device=device_1
#    Join meeting   device=device_1:norden   meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option   device=device_1
#    Verify text display on whiteboard sharing screen   devices=device_1,device_2   text=testing_wb
#    Delete text from whiteboard sharing screen  device=device_1   text=testing_wb
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC11: [Whiteboard Sharing]DUT user to verify the text editing on whiteboard
#    [Tags]  229138  P2
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Verify whiteboard sharing option under more option   device=device_1
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Verify text editing on whiteboard share screen   device=device_1   text=testing_wb
#    Verify text display on whiteboard sharing screen   devices=device_1,device_2   text=testing_wb
#    Delete text from whiteboard sharing screen   device=device_1   text=testing_wb
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC12: [Whiteboard Sharing]DUT user to delete the text on the whiteboard
#    [Tags]  229139   P2
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Verify whiteboard sharing option under more option   device=device_1
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Verify text editing on whiteboard share screen   device=device_1   text=testing_wb
#    Verify text display on whiteboard sharing screen   devices=device_1,device_2   text=testing_wb
#    Verify text box options and validate    device=device_1    text=testing_wb
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC13: [Whiteboard Sharing]DUT user to verify the stick notes on Whiteboard
#    [Tags]  229140   P2
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:   meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Check video call on state   device_list=device_1,device_2
#    Verify whiteboard sharing option under more option   device=device_1
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Validate Drag and Drop functinality of sticky notes    device=device_1   text=testing_wb
#    Verify text display on whiteboard sharing screen   devices=device_1,device_2    text=testing_wb
#    Delete sticky note from whiteboard share screen   device=device_1   text=testing_wb
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC14: [Whiteboard Sharing]DUT user to delete the sticky notes from the Whiteboard
#    [Tags]  229141   P2
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:   meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Check video call on state   device_list=device_1,device_2
#    Verify whiteboard sharing option under more option   device=device_1
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Verify text editing on whiteboard share screen   device=device_1   text=testing_wb
#    Verify text display on whiteboard sharing screen   devices=device_1,device_2   text=testing_wb
#    Verify text box options and validate    device=device_1    text=testing_wb
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#
#
#
#
#*** Keywords ***
#Come back to home screen page
#    [Arguments]    ${device}
#    Come back to home screen    ${device}
#
#Verify and click on white board sharing in call control bar
#        [Arguments]    ${device}
#        Verify whiteboard sharing option under more option   ${device}
