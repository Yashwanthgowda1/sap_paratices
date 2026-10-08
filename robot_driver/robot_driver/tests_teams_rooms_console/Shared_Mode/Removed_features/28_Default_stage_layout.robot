#*** Settings ***
#Force Tags    Default_stage_layout    28     sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#
#*** Test Cases ***
#TC1:[Default stage Layout] Verify the options under the Default stage layout under Teams admin settings
#    [Tags]      381450      bvt_sm      sanity_sm
#    [Setup]   Testcase Setup for shared User    count=1
#    Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC2:[Default Layout] Verify the functionality of content only option once user selected under the Default stage layout under Teams admin settings
#	[Tags]      381487      bvt_sm      sanity_sm
#    [Setup]   Testcase Setup for shared User    count=2
#    Navigate to meeting page    console=console_1
#    change default stage layout     device=console_1      default_state_layout=content_only
#    come back from admin settings page      device_list=console_1
#    Join a meeting   console=console_1     device=device_2:norden    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC3:[Default Layout] Verify the functionality of content+Gallery option once user selected under the Default stage layout under Teams admin settings
#	[Tags]      381488      bvt_sm      sanity_sm
#    [Setup]   Testcase Setup for shared User    count=2
#    Navigate to meeting page    console=console_1
#    change default stage layout     device=console_1      default_state_layout=content_gallery
#    come back from admin settings page      device_list=console_1
#    Join a meeting   console=console_1     device=device_2:norden    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=console_1     mode=content_gallery
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC4:[Default Layout] Verify the functionality of Frontrow once user selected under the Default stage layout under Teams admin settings
#	[Tags]      381489      bvt_sm      sanity_sm
#    [Setup]   Testcase Setup for shared User    count=2
#    Navigate to meeting page    console=console_1
#    change default stage layout     device=console_1      default_state_layout=front_row
#    come back from admin settings page      device_list=console_1
#    Join a meeting   console=console_1     device=device_2:norden    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    verify front row mode      device=console_1
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify front row mode      device=console_1
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC5:[Default stage Layout] Verify the Default stage layout option in meetings under the teams admin settings
#	[Tags]      381448      sanity_sm
#    [Setup]   Testcase Setup for shared User    count=1
#    Navigate to meeting page    console=console_1
#    Verify drop down icon and dropdown values in default stage layout      device=console_1
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC6:[Default stage Layout] Verify the functionality of dropdown icon under the Default stage layout under Teams admin settings
#	[Tags]      381480
#    [Setup]   Testcase Setup for shared User    count=1
#    Navigate to meeting page    console=console_1
#    Verify drop down icon and dropdown values in default stage layout      device=console_1
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC7:[Default Layout] Verify the functionality of content only option once user selected under the Default stage layout under Teams admin settings
#	[Tags]      381483      sanity_sm
#    [Setup]   Testcase Setup for shared User    count=1
#    Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=content_only
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC8:[Default Layout] Verify the content only option under the Default stage layout under Teams admin settings
#    [Tags]    381484
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to meeting page    console=console_1
#    Verify drop down icon and dropdown values in default stage layout      device=console_1
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC9:[Default Layout] Verify that Front row default layout setting should be ignored once the user changes the layout during a meeting
#	[Tags]      381502      sanity_sm
#	[Setup]   Testcase Setup for shared User    count=2
#    Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=front_row
#    come back from admin settings page      device_list=console_1
#    Join a meeting   console=console_1     device=device_2:norden    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    verify front row mode      device=console_1
#    change meeting mode     device=device_1     mode=gallery
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=console_1     mode=content_gallery
#    Stop presenting whiteboard share screen   device=console_1
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC10:[Default Layout] Verify that Content+Gallery default layout setting should be ignored once the user changes the layout during a meeting
#	[Tags]      381513      sanity_sm
#	[Setup]   Testcase Setup for shared User    count=2
#    Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=content_gallery
#    come back from admin settings page      device_list=console_1
#    Join a meeting   console=console_1     device=device_2:norden    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    change meeting mode     device=device_1     mode=front_row
#    verify front row mode      device=console_1
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify front row mode      device=console_1
#    Stop presenting whiteboard share screen   device=console_1
#    verify front row mode      device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC11:[Default Layout] verify the Content+Gallery option under the Default stage layout in Teams admin settings
#	[Tags]    381485
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to meeting page    console=console_1
#    Verify drop down icon and dropdown values in default stage layout      device=console_1
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC12:[Default Layout] verify the Front row option under the Default stage layout in Teams admin settings
#	[Tags]    381486
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to meeting page    console=console_1
#    Verify drop down icon and dropdown values in default stage layout      device=console_1
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC13:[Default Layout] Verify that "Content+Galery" default layout setting should work when joining meeting with no content shared
#	[Tags]      381491
#	[Setup]   Testcase Setup for shared User    count=2
#    Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=content_gallery
#    come back from admin settings page      device_list=console_1
#    Join a meeting   console=console_1     device=device_2:norden    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=console_1     mode=content_gallery
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC14:[Default Layout] Verify that "Content only" default layout setting should work when joining the meeting with no content shared
#	[Tags]      381492
#	[Setup]   Testcase Setup for shared User    count=2
#    Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=content_only
#    come back from admin settings page      device_list=console_1
#    Join a meeting   console=console_1     device=device_2:norden    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=console_1     mode=content_only
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC15:[Default Layout] Verify the default layout set to Content in meet now
#	[Tags]      381512
#	[Setup]   Testcase Setup for shared User    count=2
#	Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=content_only
#    come back from admin settings page      device_list=console_1
#    Start meeting using meet now    from_device=console_1    to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=console_1     mode=content_only
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC16:[Default Layout] Verify the default layout set to Content+Gallery in meet now
#	[Tags]      381514
#	[Setup]   Testcase Setup for shared User    count=2
#	Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=content_gallery
#    come back from admin settings page      device_list=console_1
#    Start meeting using meet now    from_device=console_1    to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    verify Content Gallery should be selected   device=console_1     mode=gallery
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Content Gallery should be selected   device=console_1     mode=content_gallery
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#TC17:[Default Layout] Verify the default layout set to Front Row in meet now
#	[Tags]      381516
#	[Setup]   Testcase Setup for shared User    count=2
#	Navigate to meeting page    console=console_1
#    Verify default stage layout      device=console_1
#    change default stage layout     device=console_1      default_state_layout=front_row
#    come back from admin settings page      device_list=console_1
#    Start meeting using meet now    from_device=console_1    to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    verify front row mode      device=console_1
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify front row mode      device=console_1
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1
#
#
#*** Keywords ***
#Navigate to app settings screen
#    [Arguments]   ${console}
#    Tap on more option  ${console}
#    Tap on settings page   ${console}
#
#change default stage layout
#    [Arguments]     ${device}    ${default_state_layout}
#    enable front row toggle from device setting      ${device}    ${default_state_layout}
#
#Verify and click on white board sharing in call control bar
#    [Arguments]    ${device}
#    Verify whiteboard sharing option under more option   ${device}
#
#Navigate to meeting page
#    [Arguments]       ${console}
#    Navigate to app settings screen    ${console}
#    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
#
#End a meeting
#    [Arguments]    ${console}    ${device}
#    End the meeting  ${console}
#    End meeting      ${device}
#
#Verify drop down icon and dropdown values in default stage layout
#	[Arguments]    ${device}
#    verify default stage layout     ${device}
