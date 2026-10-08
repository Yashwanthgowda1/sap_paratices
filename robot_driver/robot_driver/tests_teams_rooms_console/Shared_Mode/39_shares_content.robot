*** Settings ***
Resource    ../../resources/keywords/common.robot

Suite Setup      Web Driver Initialization and TDC Meeting Setup with Screen Sharing
Suite Teardown    Run Keywords  Suite Failure Capture    AND   close driver
*** Variables ***
${wait_time} =  10
*** Test Cases ***
TC1:[Call] TDC user 1 sharing desktop with DUT user and TDC user 2.
    [Tags]     444740         P2
    [Setup]  Testcase Setup for shared User       count=3
    make outgoing call from tdc using number    device=tdc_1:user     to_device=device_1:meeting_user,device_3
    Pick up incoming call    console=console_1
    Accept incoming call      device=device_3
    Wait for Some Time    time=${wait_time}
    verify call state in tdc     device=tdc_1:user     state=connected
    Verify for call state     console_list=console_1    device_list=device_3     state=connected
    Verify for call state     console_list=console_1      state=connected
    End the meeting      console=console_1
    verify call state in tdc     device=tdc_1:user     state=disconnected
    Verify for call state     console_list=console_1    device_list=device_3     state=disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC2:[Meetings] Touch Console user can view content shared by other participant in the meeting.
    [Tags]    444940   P1
    [Setup]   Testcase Setup for shared User    count=1
    Join a meeting   console=console_1       meeting=rooms_console_meeting
    Verify for call state  console_list=console_1   state=Connected
    verify content shared from tdc      device=device_1
    verify participants grid present in the meeting     device=device_1     grid_state=on
    Verify and view list of participant     console=console_1
    End the meeting      console=console_1
    Verify for call state     console_list=console_1       state=disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC3:[Content] Layout icon in gallery mode during the content sharing
    [Tags]    315081   P2
    [Setup]   Testcase Setup for shared User    count=1
    Join a meeting   console=console_1       meeting=rooms_console_meeting
    Verify for call state  console_list=console_1   state=Connected
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=console_1
    Verifying layout options with two connected devices   device=console_1
    End the meeting      console=console_1
    Verify for call state     console_list=console_1         state=disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC4:[Meetings] Verify Focus on content mode in layout during the content sharing
    [Tags]    315085   P1
    [Setup]   Testcase Setup for shared User    count=1
    Join a meeting   console=console_1      meeting=rooms_console_meeting
    Verify for call state  console_list=console_1   state=Connected
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=console_1
    End the meeting      console=console_1
    Verify for call state     console_list=console_1        state=disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC5:[Stage Layout Switcher] Verify the Focus on Contents layout.
    [Tags]    444487    P2
    [Setup]   Testcase Setup for shared User     count=1
    Join a meeting   console=console_1      meeting=rooms_console_meeting
    Verify for call state     console_list=console_1     state=Connected
    verify content shared from tdc      device=device_1
    Verify that gallery mode should be selected by default      device=console_1
    Verify that chat toggle button should be disabled by default        device=console_1
    verify focus on content mode       device=console_1
    verify participants grid present in the meeting     device=device_1
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC6:[Stage Layout Switcher] Verify that Gallery layout when show meeting Chat is disabled in teams admin settings, with content.
    [Tags]    444490    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=1
    Enable and disable the show meeting chat option    console=console_1    state=off
    Join a meeting   console=console_1      meeting=rooms_console_meeting
    Verify for call state     console_list=console_1     state=Connected
    verify content shared from tdc      device=device_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    verify that chat toggle button is not present   device=console_1
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1     AND     Enable and disable the show meeting chat option    console=console_1    state=on

TC7:[Chat]Verify the chat option when DUT user enables chat option in Content+ Gallery mode.
    [Tags]    380060    P2
    [Setup]   Testcase Setup for shared User   count=1
    disconnect call and Join TDC meeting with Screen Sharing     meeting=console_lock_meeting
    Join a meeting   console=console_1       meeting=console_lock_meeting
    Verify for call state     console_list=console_1        state=connected
    verify default gallery and content people selection during sharing      device=console_1
    verify meeting chat     console=console_1        action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose_2
    Verify messages on chat layers      device=device_1     message=checking for the testing purpose_2
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1     state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1

TC8:[Chat]Verify the chat option in Content+ People mode when DUT user disables "show meeting chat" option from Admin settings.
    [Tags]    380061    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=1
    Enable and disable the show meeting chat option    console=console_1    state=off
    Join a meeting   console=console_1       meeting=console_lock_meeting
    Verify for call state     console_list=console_1        state=connected
    verify default gallery and content people selection during sharing      device=console_1
    verify that chat toggle button is not present   device=console_1
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1     state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1     AND     Enable and disable the show meeting chat option    console=console_1    state=on    AND    disconnect call and Join TDC meeting with Screen Sharing     meeting=rooms_console_meeting

TC9:[Lobby]Verify DUT[Console] user is able to View the screen shared from TDC once DUT[Console] is admitted to meeting.
    [Tags]    380763    P2
    [Setup]   Testcase setup for shared mode PSTN Setup as Main device     count=1
    Verify meeting display on home page   console=console_1
    Join a meeting   console=console_1     meeting=console_lock_meeting
    verify waiting in the lobby message     device=console_1
    admit external participants into meeting on tdc    device=tdc_1:user    participant=console_1:pstn_user
    Verify for call state     console_list=console_1        state=connected
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC10:[Meetings] Verify content + people mode in layout during the content sharing
    [Tags]     315083    sanity_sm  P1
    [Setup]   Testcase Setup for shared User    count=2
    Join a meeting   console=console_1       meeting=rooms_console_meeting
    Verify for call state  console_list=console_1   state=Connected
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=console_1
    Verifying layout options with two connected devices   device=console_1
    verify participants grid present in the meeting     device=device_1     grid_state=on
    End the meeting      console=console_1
    Verify for call state     console_list=console_1         state=disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC11:[Stage Layout Switcher] Verify that Focus on Content, when show meeting Chat is disabled under the teams admin settings.
    [Tags]  444494     sanity_tc_sm     P1
    [Setup]   Testcase Setup for shared User   count=1
    Enable and disable the show meeting chat option    console=console_1    state=off
    Join a meeting   console=console_1       meeting=rooms_console_meeting
    Verify for call state     console_list=console_1        state=connected
    verify default gallery and content people selection during sharing      device=console_1
    verify that chat toggle button is not present   device=console_1
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1     state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1     AND     Enable and disable the show meeting chat option    console=console_1    state=on

TC12:[Meeting]Verify Gallery & Large Gallery mode during the Meeting
    [Tags]       315173   sanity_tc_sm     P1
    [Setup]   Testcase Setup for shared User    count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=console_1
    verify default gallery and content people selection during sharing      device=console_1
    change meeting mode     device=console_1    mode=large_gallery
    Verify large gallery mode after switching      device=console_1
    verify participants grid present in the meeting     device=device_1     grid_state=on
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC13:[Large Gallery] Verify Content and Content+Gallery Layouts when participant is pinned
    [Tags]       322586
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=console_1
    make a pin and unpin   from_device=console_1      to_device=device_2    action=pin      device_type=console
    verify default gallery and content people selection during sharing      device=console_1
    Verify pin icon     device=console_1
    verify default gallery and content people selection during sharing      device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC14:[Reactions] Verify Hand raise notification displayed on DUT screen when content shared by other participant in the meeting
    [Tags]       322891
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify content shared from tdc      device=device_1
    Verify and select raise hand option  console=console_1
    Verify raise hand notification      device_list=device_2
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC15:[Front Row] Verify DUT is user able to select Front row Layout from Call control bar.
    [Tags]      445125     sanity_tc_sm     P1
    [Setup]   Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=console_1
    Verify layout options        device=console_1
    Change meeting mode     device=console_1     mode=front_row
    select the drop down under show on left and show on right     device=console_1    show_on_left=hide    show_on_right=raised_hands
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC16:[Front Row] Verify the live captions when user sharing content in front row mode.
    [Tags]     445166    sanity_tc_sm     P1
    [Setup]   Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=console_1
    Turn on live captions option    console=console_1
    Turn off live captions option   console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

# Ensure Calling and Meetnow Related Test Cases Are Last in Sequence
TC17:[Meet now] TDC user adds Teams App user during desktop sharing in the meeting
    [Tags]     315364   P2
    [Setup]  Testcase Setup for Meeting User     count=3
    Initiate the Meet Now call from TDC
    Pick up incoming call    console=console_1
    Accept incoming call      device=device_3
    Wait for Some Time    time=${wait_time}
    initiate tdc screen sharing    device=tdc_1:user
    verify content shared from tdc      device=device_1
    stop tdc screen sharing     device=tdc_1:user
    Disconnect the call on TDC      device=tdc_1:user
    End a meeting     console=console_1       device=device_3
    Verify for meeting state    console_list=console_1      device_list=device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_3

*** Keywords ***
Web Driver Initialization and TDC Meeting Setup with Screen Sharing
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=rooms_console_meeting      click=left
    join the meeting in TDC     device=tdc_1:user
    initiate tdc screen sharing    device=tdc_1:user

disconnect call and Join TDC meeting with Screen Sharing
    [Arguments]    ${meeting}
    stop tdc screen sharing    device=tdc_1:user
    Disconnect the call on TDC      device=tdc_1:user
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=${meeting}      click=left
    join the meeting in TDC     device=tdc_1:user
    initiate tdc screen sharing    device=tdc_1:user
    
Verifying layout options with two connected devices
    [Arguments]     ${device}
     verify layout options after disable video call     ${device}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable and disable the show meeting chat option
    [Arguments]       ${console}      ${state}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page    ${console}    option=meeting
    Enable and disable the chat toggle in admin setting    device=${console}    state=${state}
    come back from admin settings page    device_list=${console}

close driver
    close web driver    tdc_1:user

Initiate the Meet Now call from TDC
    stop tdc screen sharing     device=tdc_1:user
    Disconnect the call on TDC      device=tdc_1:user
    Wait for Some Time    time=${wait_time}
    create a meeting using meet now in tdc      device=tdc_1:user
    search participate in people tab request to join    device=tdc_1:user    to_device=device_1:meeting_user,device_3
    Wait for Some Time    time=5s

End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}