*** Settings ***
Documentation   Ensure device_1 HDMI input is connected to the laptop before starting the suite.
Resource    ../../resources/keywords/common.robot
Force Tags      HDMI_ingest


*** Test Cases ***
TC1:[HDMI Ingest][touch Console]Verify the HDMI ingest in meeting/Call
    [Tags]      322643   bvt_tc_sm     sanity_tc_sm     exclude_ftp_sm
    [Setup]   Testcase Setup for shared User    count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2        console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    verify HDMI ingest in the device        device=device_1     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[HDMI Ingest]User share Laptop screen using HDMI Ingest
    [Tags]      322639      P1      sanity_tc_sm        exclude_ftp_sm
    [Setup]   Testcase Setup for shared User    count=1
    verify HDMI ingest in the device        device=device_1     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC3:[HDMI Ingest][touch Console]Verify the touch console home screen
    [Tags]      322642      P1           exclude_ftp_sm
    [Setup]   Testcase Setup for shared User    count=1
    Verify stop sharing option on console screen when HDMI ingest        device=device_1     console=console_1
    Verify user should not get exit screen and stop projecting      device=device_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC4:[HDMI Ingest]Touch Console user can mute the meeting when the screen shared
    [Tags]      323034      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=3
    verify HDMI ingest in the device        device=device_1     console=console_1
    Join a meeting   console=console_1     device=device_2,device_3    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user    to_device=device_2,device_3        console=console_1
    Mute all active participants    console=console_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    Verify HDMI sharing is visible after user mute participants in meeting      from_device=device_1:meeting_user        to_device=device_2,device_3        console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC5:[HDMI Ingest]Touch Consoleuser can add participant while sharing the laptop screen
    [Tags]      323033      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=3
    verify HDMI ingest in the device        device=device_1     console=console_1
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify HDMI ingest in the call  from_device=device_1:meeting_user    to_device=device_2        console=console_1
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2,device_3        console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC6:[HDMI Ingest] Touch console user verify that there is no option to exit full screen in meeting
    [Tags]      323273      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User    count=1
    Verify stop sharing option on console screen when HDMI ingest        device=device_1     console=console_1
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify user should not get exit screen and stop projecting      device=device_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    verify HDMI ingest in the device        device=device_1     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[HDMI Ingest][touch Console]DUT User join meeting while content sharing
    [Tags]      322644      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=2
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    modify touchscreen control toggle state     console=console_1   state=enabled
    Come back from admin settings page      device_list=console_1
    verify HDMI ingest in the device        device=device_1     console=console_1
    User tap on exist full screen in hdmi sharing      device=device_1      screen_type=minimized
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2        console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    verify HDMI ingest in the device        device=device_1     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC8:[HDMI Ingest] Verify that user remain in the content mode when content is being shared.
    [Tags]      323324      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=2
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    modify touchscreen control toggle state     console=console_1   state=disabled
    Come back from admin settings page      device_list=console_1
    verify HDMI ingest in the device        device=device_1     console=console_1
    User click on the hdmi share option     console=console_1   device=device_1     state=off
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    user click hdmi share option in the call    console=console_1       device=device_1
    Verify HDMI ingest in the call      from_device=device_1:meeting_user    to_device=device_2        console=console_1
    Verify content mode on layout when sharing content    device=console_1
    Verify user stop sharing the content in the call        device=device_1     console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2      AND     user click on the hdmi share option     console=console_1   device=device_1

TC9:[HDMI Ingest]User exit full screen and stop sharing.
    [Tags]      322641      P1      sanity_tc_sm        exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=2
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    modify touchscreen control toggle state     console=console_1   state=enabled
    Come back from admin settings page      device_list=console_1
    verify HDMI ingest in the device        device=device_1     console=console_1
    User tap on exist full screen in hdmi sharing      device=device_1      screen_type=minimized
    user maximize the hdmi sharing screen   device=device_1      screen_type=maximized
    User tap on stop sharing button on hdmi sharing screen      device=device_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2      AND     user click on the hdmi share option     console=console_1   device=device_1

TC10:[HDMI Ingest] Touch console user stop sharing screen in a meeting
    [Tags]      323277      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=2
    Verify stop sharing option on console screen when HDMI ingest        device=device_1     console=console_1
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify HDMI ingest in the call  from_device=device_1:meeting_user    to_device=device_2        console=console_1
    Verify user stop sharing the content in the call        device=device_1     console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2      AND     user click on the hdmi share option     console=console_1   device=device_1

TC11:[HDMI Ingest]Device should support 720p/1080p while sharing the screen
    [Tags]      323311      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=2
    verify HDMI ingest in the device        device=device_1     console=console_1
    Verify dp set on device  device=device_1
    Check teams app supported UI   device=device_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC12:[HDMI Ingest]DUT User receive a call while sharing screen
    [Tags]      323365      P2      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=2
    verify HDMI ingest in the device        device=device_1     console=console_1
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify content paused statement while connecting in call        device=console_1
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    End meeting      device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2       state=Disconnected
    verify HDMI ingest in the device        device=device_1     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC13:[HDMI Ingest] Touch console user share White board after HDMI content sharing stopped
    [Tags]      323319      P1      sanity_tc_sm      exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=2
    Verify stop sharing option on console screen when HDMI ingest        device=device_1     console=console_1
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify HDMI ingest in the call  from_device=device_1:meeting_user    to_device=device_2        console=console_1
    Verify user stop sharing the content in the call        device=device_1     console=console_1
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Stop presenting whiteboard share screen   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2      AND     user click on the hdmi share option     console=console_1   device=device_1     AND     come back to calendar page on TDC   device=tdc_1

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Verify stop sharing option on console screen when HDMI ingest
    [Arguments]    ${device}    ${console}
    verify HDMI ingest in the device    ${device}   ${console}

Verify HDMI sharing is visible after user mute participants in meeting
    [Arguments]    ${from_device}   ${to_device}    ${console}
    Verify HDMI ingest in the call  ${from_device}  ${to_device}    ${console}

Navigate to app settings screen page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

user maximize the hdmi sharing screen
    [Arguments]     ${device}       ${screen_type}
    User tap on exist full screen in hdmi sharing   ${device}   ${screen_type}

Join the meeting
    [Arguments]         ${device}    ${meeting_name}
    initiate web driver     ${device}
    perform web signin method       ${device}
    right click on created meeting from tdc       ${device}       ${meeting_name}       click=left
    join the meeting in TDC     ${device}

Verify and click on white board sharing in call control bar
    [Arguments]    ${device}
    Verify whiteboard sharing option under more option   ${device}
