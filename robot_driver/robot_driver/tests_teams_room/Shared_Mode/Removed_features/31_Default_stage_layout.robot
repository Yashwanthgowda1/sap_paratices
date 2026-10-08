#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  2
#${action_time} =  5
#*** Test Cases ***
#
#
#TC1:Verify that Front row default layout setting should be ignored once the user changes the layout during a meeting
#    [Tags]    381143      P1    sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    navigate to meeting page    device=device_1
#    change default stage layout     device=device_1      default_state_layout=front_row
#    Come back from admin settings page      device_list=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify front row mode      device=device_1
#    verify front row participant  from_device=device_1    connected_device_list=device_2
#    verify whiteboard sharing option under more option   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Stop presenting whiteboard share screen     device=device_1
#    Wait for Some Time    time=${wait_time}
#    change meeting mode     device=device_1     mode=together
#    verify changed mode    device=device_1      changed_mode=together_mode
#    change meeting mode     device=device_1     mode=large_gallery
#    verify changed mode  device=device_1      changed_mode=large_gallery
#    change meeting mode     device=device_1     mode=gallery
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2      state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC2:Verify that Content+Gallery default layout setting should be ignored once the user changes the layout during a meeting
#    [Tags]     381155   P1   sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    navigate to meeting page    device=device_1
#    change default stage layout     device=device_1      default_state_layout=content_only
#    Come back from admin settings page      device_list=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    change meeting mode     device=device_1     mode=together
#    verify changed mode    device=device_1      changed_mode=together_mode
#    change meeting mode     device=device_1     mode=large_gallery
#    verify changed mode  device=device_1      changed_mode=large_gallery
#    change meeting mode     device=device_1     mode=gallery
#    verify whiteboard sharing option under more option   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Stop presenting whiteboard share screen     device=device_1
#    Wait for Some Time    time=${wait_time}
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2      state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC3:Verify the options under the Default stage layout under Teams admin settings for basic licensed account.
#    [Tags]     381085    P2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    verify default stage layout      device=device_1
#    Navigate back from metting settings page         device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#
#TC4:Verify the functionality of content only option once user selected under the Default stage layout under Teams admin settings.
#    [Tags]     381091    P2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    verify default stage layout      device=device_1
#    change default stage layout     device=device_1      default_state_layout=content_only
#    Navigate back from metting settings page         device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC5:Verify the content only option under the Default stage layout under Teams admin settings.
#    [Tags]    381100       P2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    verify content only option under the Default stage layout      device=device_1
#    Navigate back from metting settings page         device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC6:verify the Content+Gallery option under the Default stage layout in Teams admin settings
#    [Tags]    381101       P2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    verify Content+Gallery option under the Default stage layout        device=device_1
#    Navigate back from metting settings page         device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC7:verify the Frontrow option under the Default stage layout in Teams admin settings
#    [Tags]    381103      P2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    Frontrow option under the Default stage layout in Teams admin settings      device=device_1
#    Navigate back from metting settings page         device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#
#TC8:Verify "Front row" default layout setting should work when joining meeting with no content shared
#    [Tags]    381116      P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    navigate to meeting page    device=device_1
#    change default stage layout     device=device_1      default_state_layout=front_row
#    Navigate back from metting settings page         device=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify front row mode      device=device_1
#    verify front row participant  from_device=device_1    connected_device_list=device_2
#    Verify meeting state    device_list=device_1,device_2      state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC9:Verify that "Content+Galery"default layout setting should work when joining meeting with no content shared
#    [Tags]     381120       P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    navigate to meeting page    device=device_1
#    change default stage layout     device=device_1      default_state_layout=content_gallery
#    Navigate back from metting settings page         device=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify whiteboard sharing option under more option   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=device_1
#    Stop presenting whiteboard share screen     device=device_1
#    Wait for Some Time    time=${wait_time}
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2      state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC10:Verify that "Content only"default layout setting should work when joining the meeting with no content shared
#    [Tags]     381121      P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    navigate to meeting page    device=device_1
#    change default stage layout     device=device_1      default_state_layout=content_only
#    Navigate back from metting settings page         device=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify whiteboard sharing option under more option   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=device_1
#    Stop presenting whiteboard share screen     device=device_1
#    Wait for Some Time    time=${wait_time}
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2      state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC11:Verify the options under the Default stage layout under Teams admin settings.
#    [Tags]     381082         bvt_sm     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    verify default stage layout      device=device_1
#    come back from admin settings page  device_list=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC12:Verify the functionality of content only option once user selected under the Default stage layout under Teams admin settings.
#    [Tags]     381106     bvt_sm     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    navigate to meeting page    device=device_1
#    change default stage layout     device=device_1     default_state_layout=content_only
#    come back from admin settings page  device_list=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify participants list in meeting    device=device_1
#    change meeting mode     device=device_1     mode=gallery
#    verify gallery particepence   from_device=device_1    connected_device_list=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2
#
#TC13:Verify the Default stage layout option in meetings under the teams admin settings.
#    [Tags]     381073     P1     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    Default stage layout option is under meetings under teams admin settings     device=device_1
#    Navigate back from metting settings page         device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC14:Verify the functionality of dropdown icon under the Default stage layout under Teams admin settings.
#    [Tags]     381089     P1     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=1
#    navigate to meeting page    device=device_1
#    verify dropdown icon under the Default stage layout under Teams admin settings     device=device_1
#    Navigate back from metting settings page         device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC15:Dual screen should show correct layouts when default is set to Content
#     [Tags]     381138    P1     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    navigate to meeting page    device=device_1
#    change default stage layout     device=device_1     default_state_layout=content_only
#    Navigate back from metting settings page         device=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify participants list in meeting    device=device_1
#    change meeting mode     device=device_1     mode=gallery
#    verify gallery particepence   from_device=device_1    connected_device_list=device_2
#    Verify and click on white board sharing in call control bar   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Stop presenting whiteboard share screen   device=device_1
#    Wait for Some Time    time=${wait_time}
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC16:Verify the default layout set to Front Row in meet now
#	[Tags]    381159    P2     tr_sm
#	[Setup]    Testcase Setup for Meeting User   count=2
#	navigate to meeting page    device=device_1
#    change default stage layout     device=device_1     default_state_layout=front_row
#    Navigate back from metting settings page         device=device_1
#    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    verify front row mode      device=device_1
#    Verify and click on white board sharing in call control bar   device=device_2
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify front row mode      device=device_1
#    Stop presenting whiteboard share screen   device=device_2
#    Wait for Some Time    time=${wait_time}
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC17:Verify the default layout set to Content+Gallery in meet now
#	[Tags]    381156    P2     tr_sm
#	[Setup]    Testcase Setup for Meeting User   count=2
#	navigate to meeting page    device=device_1
#    change default stage layout     device=device_1     default_state_layout=content_gallery
#    Navigate back from metting settings page         device=device_1
#    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    verify Content Gallery should be selected   device=device_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=device_2
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=device_1     mode=content_gallery
#    Stop presenting whiteboard share screen   device=device_2
#    Wait for Some Time    time=${wait_time}
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC18:Verify the default layout set to Content in meetnow
#	[Tags]    381154    P2     tr_sm
#	[Setup]    Testcase Setup for Meeting User   count=2
#	navigate to meeting page    device=device_1
#    change default stage layout     device=device_1     default_state_layout=content_only
#    Navigate back from metting settings page         device=device_1
#    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    verify Content Gallery should be selected   device=device_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=device_2
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=device_1     mode=content_only
#    Stop presenting whiteboard share screen   device=device_2
#    Wait for Some Time    time=${wait_time}
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC19:Verify that Content only default layout setting should be ignored once the user changes the layout during a meeting
#	[Tags]    381150    P2     tr_sm
#	[Setup]    Testcase Setup for Meeting User   count=2
#	navigate to meeting page    device=device_1
#    change default stage layout     device=device_1     default_state_layout=content_only
#    Navigate back from metting settings page         device=device_1
#    Join meeting    device=device_1:norden,device_2:       meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify participants list in meeting    device=device_1
#    verify Content Gallery should be selected   device=device_1     mode=gallery
#    change meeting mode     device=device_1     mode=front_row
#    verify front row mode      device=device_1
#    Verify and click on white board sharing in call control bar   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify front row mode      device=device_1
#    Stop presenting whiteboard share screen   device=device_1
#    Wait for Some Time    time=${wait_time}
#    verify front row mode      device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#
#*** Keywords ***
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#
#Navigate back from metting settings page
#    [Arguments]     ${device}
#    Click close btn    device_list=${device}
#    device setting back  ${device}
#    device setting back  ${device}
#    device setting back  ${device}
#    Click close btn    device_list=${device}
#
#verify gallery particepence
#    [Arguments]       ${from_device}   ${connected_device_list}
#    verify front row participant   ${from_device}   ${connected_device_list}
#
#Verify and click on white board sharing in call control bar
#    [Arguments]    ${device}
#    Verify whiteboard sharing option under more option   ${device}
#
#verify content only option under the Default stage layout
#    [Arguments]    ${device}
#    verify default stage layout     ${device}
#
#verify Content+Gallery option under the Default stage layout
#    [Arguments]    ${device}
#    verify default stage layout     ${device}
#
#navigate to meeting page
#    [Arguments]    ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#    navigate to meetings option in device settings page      ${device}
#
#Frontrow option under the Default stage layout in Teams admin settings
#    [Arguments]    ${device}
#    verify default stage layout     ${device}
#
#change default stage layout
#    [Arguments]     ${device}    ${default_state_layout}
#    enable front row toggle from device setting      ${device}    ${default_state_layout}
#
#Default stage layout option is under meetings under teams admin settings
#    [Arguments]     ${device}
#    verify default stage layout     ${device}
#
#verify dropdown icon under the Default stage layout under Teams admin settings
#    [Arguments]     ${device}
#    verify default stage layout     ${device}
