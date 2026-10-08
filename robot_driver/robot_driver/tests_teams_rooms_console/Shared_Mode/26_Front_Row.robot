*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***

*** Test Cases ***
TC1:[Front Row] Verify Front row option is present under Layout option on call control bar.
    [Tags]    445124    bvt_tc_sm    sanity_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify front row option     console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

#TC2:[Front Row] Verify Switch orientation toggle must be hidden when Front row is selected layout in a meeting.
#    [Tags]  380543  bvt_sm      sanity_sm
#    [Setup]   Testcase Setup for shared User   count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify switch orientation toggle hidden after taping on frontrow   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Front Row] Verify Raise hands on the front row UI.
    [Tags]    445127    P2
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode      device=device_1
    Verify and select raise hand option  console=console_1
    Verify raise hand notification      device_list=device_2
    Verify highlighted raised hand in meeting        device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Front Row] Verify Participant tray on the front row Layout.
    [Tags]    445128    P2
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify participant tray on front row layout     device=device_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[Front Row] Verify U-bar in the Meeting when user selects Front Row
    [Tags]    445131    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Verify docked ubar options      console=console_1
    Verify meeting info details in the meeting      device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Front row] Verify the Content when whiteboard is shared.
    [Tags]    445144    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Verify and click on white board sharing in call control bar   device=console_1
    Wait for Some Time    time=${wait_time}
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Stop presenting whiteboard share screen   device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Front Row] Verify Top bar in the meeting when DUT user selects Front Row Layout
    [Tags]     445130    P2
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Verify the chat options in meeting      device=device_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[Front Row] Check for White board sharing in Front Row.
    [Tags]    382111    P2
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Verify and click on white board sharing in call control bar   device=console_1
    Wait for Some Time    time=${wait_time}
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Verify front row mode   device=device_1
    Stop presenting whiteboard share screen   device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC8:[Front Row] Check for front row from report an issue page in meeting.
	[Tags]    382110    P2
    [Setup]   Testcase Setup for shared User     count=1
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1      state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Verify report an issue while front row mode     console=console_1
    Click close btn    device_list=console_1
    Verify front row mode   device=device_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC9:[Front Row] DUT user to verify the default view when no content shared.
	[Tags]     445142    P2
    [Setup]   Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Verify participant tray on front row layout      device=device_1
    verify top bar in front row      device=device_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC10:[Front Row] Verify that When no content is shared solid gray background with meeting info state is displayed
    [Tags]    445141    P2
    [Setup]  Testcase Setup for shared User      count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Verify no content and meeting info is displayed in screen       console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1     device_list=device_2

TC11:[Front row] Verify the "Default stage layout" >>front Row for Basic license.
    [Tags]    380579    P2
    [Setup]  Testcase console setup for basic user       count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=meeting
    Verify the front row with pro tag     device=console_1        default_state_layout=front_row      pro_tag=check
    come back from admin settings page      device_list=console_1
    [Teardown]   Run Keywords   Capture Failure    AND      Come back to home screen page   console_list=console_1

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Verify participant tray on front row layout
    [Arguments]    ${device}
    Verify front row mode   ${device}

Verify and click on white board sharing in call control bar
    [Arguments]    ${device}
    Verify whiteboard sharing option under more option   ${device}

Verify the front row with pro tag
    [Arguments]    ${device}        ${default_state_layout}     ${pro_tag}
    Enable front row toggle from device setting     ${device}        ${default_state_layout}        ${pro_tag}

Console setup for basic user
    Sign Out Console
    Sign Out
    Sign In    user_list=basic_user,user,user
    Sign In Console    user_list=basic_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=basic_user

Testcase console setup for basic user
    [Arguments]    ${count}
    Console setup for basic user
    Testcase Setup for basic User   ${count}

Verify no content and meeting info is displayed in screen
    [Arguments]     ${console}
    verify_meeting_info_details_in_the_meeting      device=${console}
