*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***

*** Test Cases ***
TC1:[Stage Layout Switcher] Verify the layout switcher UI is shown.
    [Tags]    444472    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1     state=Connected
    Verify layout switcher ui        device=console_1
    Verify that chat toggle button should be disabled by default        device=console_1
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC2:[Stage Layout Switcher] Verify that Gallery Layout switch.
    [Tags]    444473    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User     count=1
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1     state=Connected
    Verify that gallery mode should be selected by default      device=console_1
    Verify that chat toggle button should be disabled by default        device=console_1
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC3:[Stage Layout Switcher] Verify the Gallery Layout with Chat.
    [Tags]    444474    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User     count=1
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1     state=Connected
    Verify that gallery mode should be selected by default      device=console_1
    Verify that chat toggle button should be disabled by default        device=console_1
    verify meeting chat     console=console_1       action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC4:[Stage Layout Switcher] Verify the Large Gallery Layout switch.
    [Tags]    444476    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    change meeting mode     device=console_1    mode=large_gallery
    Verify large gallery mode after switching      device=console_1
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Stage Layout Switcher][ Verify the Large Gallery Layout with Chat panel.
    [Tags]    444477    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    change meeting mode     device=console_1    mode=large_gallery
    Verify large gallery mode after switching      device=console_1
    verify meeting chat     console=console_1       action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Stage Layout Switcher] Verify the Together Mode switch.
    [Tags]    444480    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    Change meeting mode     device=console_1    mode=together
    Verify together mode after switching        device=console_1
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[Stage Layout Switcher]Verify the Together Mode with chat.
    [Tags]    444482    P2
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    Change meeting mode     device=console_1    mode=together
    Verify together mode after switching        device=console_1
    verify meeting chat     console=console_1       action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC8:[Stage Layout Switcher] Verify the Front Row switch.
    [Tags]    444484    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1     state=Connected
    Verify layout switcher ui        device=console_1
    Verify that chat toggle button should be disabled by default        device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    select the drop down under show on left and show on right     device=console_1     show_on_left=raised_hands     show_on_right=chat
    Verify the right and left after switching the dropdown options in front row     device=device_1     mode=raised_hands
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC9:[Stage Layout Switcher][ Verify that Gallery layout , when show meeting Chat is disabled in settings.
	[Tags]    444488    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=1
    Disable the show meeting chat option    console=console_1
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1     state=Connected
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    verify that chat toggle button is not present   device=console_1
    Disconnect the call     console=console_1
    Verify for call state    console_list=console_1    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1     AND     Enable the show meeting chat option     console=console_1

TC10:[Stage Layout Switcher] Verify that Large Gallery when show meeting Chat is disabled under the teams admin settings.
	[Tags]    444491    P2
    [Setup]   Testcase Setup for shared User   count=2
    Disable the show meeting chat option    console=console_1
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that chat toggle button is not present   device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    Change meeting mode    device=console_1      mode=large_gallery
    verify large gallery mode after switching       device=console_1
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2  AND     Enable the show meeting chat option     console=console_1

TC11:[Stage Layout Switcher] Verify the Together Mode when show meeting Chat is disabled under the teams admin settings.
	[Tags]    444492    P2
    [Setup]   Testcase Setup for shared User   count=2
    Disable the show meeting chat option    console=console_1
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that chat toggle button is not present   device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    change meeting mode     device=console_1    mode=together
    Verify together mode after switching       device=console_1
    verify changed mode  device=device_1      changed_mode=together_mode
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2  AND     Enable the show meeting chat option     console=console_1

TC12:[Stage Layout Switcher] Verify that Front Row when show meeting Chat is disabled under the teams admin settings
	[Tags]    444493    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Disable the show meeting chat option    console=console_1
    Join a meeting   console=console_1      device=device_2      meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that chat toggle button is not present   device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1     chat_toggle=off
    select the drop down under show on left and show on right     device=console_1     show_on_left=raised_hands     show_on_right=hide
    Verify the right and left after switching the dropdown options in front row     device=device_1     mode=raised_hands
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2  AND     Enable the show meeting chat option     console=console_1

TC13:[Stage Layout Switcher] Verify the Front Row layout with Left and Right Panels.
    [Tags]    444500    P2
    [Setup]   Testcase Setup for shared User     count=2
    Disable the show meeting chat option    console=console_1
    Join a meeting   console=console_1      device=device_2     meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that chat toggle button is not present   device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    change meeting mode     device=console_1    mode=front_row
    select the drop down under show on left and show on right     device=console_1     show_on_left=raised_hands     show_on_right=hide
    Verify the right and left after switching the dropdown options in front row     device=device_1     mode=raised_hands
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2  AND     Enable the show meeting chat option     console=console_1

TC14:[Stage Layout Switcher] Verify the layout & Chat option for Basic credentials users
    [Tags]    444504    P1    sanity_tc_sm
    Navigate to app settings screen   console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1      option=meeting
    Verify pro tags under meetings     device=console_1    option=show_meeting_names
    come back from admin settings page      device_list=console_1
    Create TDC Meetings     meeting_name=test_meeting_1     participants=device_1:basic_user,device_2       time_duration=7 min    use_current_time=True
    Join a meeting   console=console_1     device=device_2           meeting=test_meeting_1
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify stage layout greyed out for basic user        device=console_1
    Web Driver Initialization and TDC Meeting Setup with Screen Sharing
    End up call     console=console_1     device=device_2
    Verify for call state    console_list=console_1     device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC15:[Stage Layout Switcher] Verify Front Row default layout when user selected Front row as default and show meeting chat is disabled under teams admin settings.
    [Tags]   444497    P1    sanity_tc_sm
    [Setup]      Testcase Setup for shared User     count=2
    Disable the show meeting chat option    console=console_1
    Join a meeting   console=console_1      device=device_2     meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options       device=console_1
    Verify that chat toggle button is not present   device=console_1
    Verify that gallery mode should be selected by default      device=console_1
    Dismiss the popup screen        device=console_1
    change meeting mode     device=console_1    mode=front_row
    select the drop down under show on left and show on right     device=console_1     show_on_left=raised_hands     show_on_right=hide
    Verify the right and left after switching the dropdown options in front row     device=device_1     mode=raised_hands
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2  AND     Enable the show meeting chat option     console=console_1

*** Keywords ***
End up call
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Disable the show meeting chat option
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable and disable the chat toggle in admin setting     device=${console}   state=off
    come back from admin settings page      device_list=${console}

Enable the show meeting chat option
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable and disable the chat toggle in admin setting     device=${console}   state=on
    come back from admin settings page      device_list=${console}

Create TDC Meetings
    [Arguments]          ${meeting_name}      ${participants}           ${time_duration}    ${use_current_time}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    create TDC meeting on desktop   device=tdc_1    meeting_name=${meeting_name}     participants=${participants}    time_duration=${time_duration}      use_current_time=${use_current_time}    roundup_end_time=off
    close web driver    tdc_1
    refresh calender tab    device=console_1

Web Driver Initialization and TDC Meeting Setup with Screen Sharing
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=test_meeting_1      click=left
    join the meeting in TDC     device=tdc_1:user
    initiate tdc screen sharing    device=tdc_1:user

Testcase console setup for basic user
    [Arguments]    ${count}
    Console setup for basic user
    Testcase Setup for basic User   ${count}

Console setup for basic user
    Sign Out Console
    Sign Out
    Sign In    user_list=basic_user
    Sign In Console    user_list=basic_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=basic_user

Testcase Setup for basic User
    [Arguments]     ${count}
    Set Global Variable     ${tc_flag}     False
    Check for device count      count=${count}
    Set Global Variable     ${tc_flag}     True
    Reset Logcat Capture    ${count}
    Reset Logcat Capture    device=console_1
    Verify Device Users     user_list=${basic_users}[:${count}]
    Verify Console Users    device_list=device_1   console_list=console_1  user_list=basic_user

