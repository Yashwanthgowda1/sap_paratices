*** Settings ***
Documentation   Ensure device_1 HDMI input is connected to the laptop before starting the suite.
Resource    ../../resources/keywords/common.robot
Force Tags      HDMI_ingest

Suite Setup     Verify HDMI sharing on the screen
Suite Teardown    Run Keywords  Suite Failure Capture   AND   close driver

*** Test Cases ***
TC1:[HDMI Ingest]User share laptop screen in a meeting
    [Tags]      261424      P1      sanity_sm       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC2:[HDMI Ingest]User share Laptop screen using HDMI Ingest
    [Tags]      261422      P1      sanity_sm       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC3:[HDMI Ingest]DUT user can mute the meeting when the screen shared
    [Tags]      261426      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=3
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting        device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user    to_device=device_2,device_3
    Mute all participants  device=device_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    Verify HDMI sharing is visible after user mute participants in meeting      from_device=device_1:meeting_user        to_device=device_2,device_3
    End meeting      device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4:[HDMI Ingest]DUT user can add participant while sharing the laptop screen
    [Tags]      261425      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=3
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Accept incoming call    device=device_3
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2,device_3
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC5:[HDMI Ingest]DUT user verify that there is no option to exit full screen in meeting
    [Tags]      261427      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    User minimize the hdmi sharing screen for join the meeting       device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    Verify user should not get exit screen and stop projecting      device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC6:[HDMI Ingest]User exit full screen and stop sharing.
    [Tags]      261423      P1      sanity_sm       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify HDMI ingest in the device        device=device_1
    User tap on exist full screen in hdmi sharing      device=device_1      screen_type=minimized
    user maximize the hdmi sharing screen   device=device_1      screen_type=maximized
    User tap on stop sharing button on hdmi sharing screen      device=device_1
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7:[HDMI Ingest]DUT user stop sharing screen in a meeting
    [Tags]      261432      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting        device=device_1,device_2     meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    Verify user stop sharing the content in the call        device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC8:[HDMI Ingest]DUT User Join meeting while sharing screen
    [Tags]      261435      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    User minimize the hdmi sharing screen for join the meeting       device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC9:[HDMI Ingest]DUT User receive a call while sharing screen
    [Tags]      261437      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify HDMI ingest in the device        device=device_1
    Initiates conference meeting using Meet now option    from_device=device_2     to_device=device_1:meeting_user
    Accept incoming call    device=device_1
    Verify content paused statement while connecting in call        device=device_1
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC10:[HDMI Ingest]Device should support 720p/1080p while sharing the screen
    [Tags]      261438      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify HDMI ingest in the device        device=device_1
    Verify dp set on device  device=device_1
    Check teams app supported UI   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC11:[HDMI Auto share]Verify DUT user is able to disable "Automatically share to the room display" option from Meeting setting
    [Tags]      344639      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify HDMI ingest in the device        device=device_1
    User minimize the hdmi sharing screen for join the meeting       device=device_1
    navigate to teams admin settings page       device=device_1
    Verify content sharing options is present   device=device_1
    Enable and disable hdmi content sharing    device=device_1    state=on
    Enable and disable automatically share to room display      device=device_1     state=off
    come back from admin settings page    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND   Enable the Automatically share to the room display  AND     come back from admin settings page    device_list=device_1     AND     user maximize the hdmi sharing screen   device=device_1      screen_type=maximized

TC12:[HDMI Auto share] Verify content shared is paused when user gets a incoming meeting request
    [Tags]      344645      P1  sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User        count=2
    verify HDMI ingest in the device        device=device_1
    User minimize the hdmi sharing screen for join the meeting       device=device_1
    navigate to teams admin settings page       device=device_1
    Verify content sharing options is present   device=device_1
    Enable and disable automatically share to room display      device=device_1     state=on
    come back from admin settings page    device_list=device_1
    user maximize the hdmi sharing screen   device=device_1      screen_type=maximized
    Initiates conference meeting using Meet now option    from_device=device_2     to_device=device_1:meeting_user
    Accept incoming call    device=device_1
    Verify content paused statement while connecting in call        device=device_1
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC13:[HDMI Auto share]Verify DUT user is able to see "Exit full screen" and' Stop sharing" option when HDMI ingest shared on Home screen
    [Tags]      344648      P1      sanity_sm       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify HDMI ingest in the device        device=device_1
    User minimize the hdmi sharing screen for join the meeting       device=device_1
    navigate to teams admin settings page       device=device_1
    Verify content sharing options is present   device=device_1
    Enable and disable automatically share to room display      device=device_1     state=on
    come back from admin settings page    device_list=device_1
    user maximize the hdmi sharing screen   device=device_1      screen_type=maximized
    Verify user able to see exit full screen and stop projecting     device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC14:[HDMI Ingest] DUT user share White board after HDMI content sharing stopped
    [Tags]      261443      P1      sanity_tc_sm     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting        device=device_1,device_2     meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    Verify user stop sharing the content in the call        device=device_1
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=lock_meeting
    Verify and click on white board sharing in call control bar   device=device_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND     come back to calendar page on TDC   device=tdc_1

TC15:[Front Row] Verify Content area with HDMI ingest on Front row Layout.
    [Tags]    380453    P2  exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User     count=1
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting         device=device_1    meeting=cnf_device_meeting
    Verify meeting state         device_list=device_1  state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    Verify stop sharing option on homescreen when HDMI ingest    device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC16:[Front Row] Verify Spotlighted participant should be enlarged when layout is changed from front row to Content+people layout.
    [Tags]    381784    P1  exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User     count=3
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting        device=device_1,device_2,device_3     meeting=cnf_device_meeting
    Verify meeting state         device_list=device_1,device_2,device_3  state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    make a spotlight   from_device=device_3      to_device=device_2
    verify spotlight text on device   device=device_2   text=spotlight
    change meeting mode     device=device_1    mode=gallery
    verify default gallery and content people selection during sharing    device=device_1
    Verify stop sharing option on homescreen when HDMI ingest    device=device_1
    End meeting      device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC17:[HDMI Ingest] Verify that user remain in the same layout they were before content is being shared
    [Tags]    316600    P2  exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User     count=2
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    verify layout options   device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Verify HDMI ingest in the device        device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

#keep below test case on last , hdmi ingest screen share stop here.
TC18:[HDMI Ingest] TDC/Mobile user share screen when DUT user sharing content through HDMI ingest
    [Tags]    261444    P2  exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User     count=2
    User minimize the hdmi sharing screen for join the meeting      device=device_1
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify HDMI ingest in the call      from_device=device_1:meeting_user      to_device=device_2
    Web Driver Initialization and TDC Meeting Setup with Screen Sharing
    Verify user should not get exit screen and stop projecting      device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Verify stop sharing option on homescreen when HDMI ingest
    [Arguments]     ${device}
    verify HDMI ingest in the device        ${device}

Verify HDMI sharing is visible after user mute participants in meeting
    [Arguments]    ${from_device}   ${to_device}
    Verify HDMI ingest in the call  ${from_device}  ${to_device}

User minimize the hdmi sharing screen for join the meeting
    [Arguments]     ${device}
    User minimize the hdmi sharing screen       ${device}

user maximize the hdmi sharing screen
    [Arguments]     ${device}       ${screen_type}
    User tap on exist full screen in hdmi sharing   ${device}   ${screen_type}

Verify HDMI sharing on the screen
    Verify HDMI ingest in the device        device=device_1

navigate to teams admin settings page
    [Arguments]    ${device}
    Click on more option   ${device}
    Click on settings page   ${device}
    Navigate to meetings option in device settings page      ${device}

Navigate to admin setting and enable hdmi content sharing
    [Arguments]     ${device}
    navigate to teams admin settings page      ${device}
    verify content sharing options is present   device=${device}
    Enable and disable hdmi content sharing     device=${device}     state=on

Enable the Automatically share to the room display
    navigate to teams admin settings page       device=device_1
    Enable and disable automatically share to room display     device=device_1     state=on

Join the meeting
    [Arguments]         ${device}    ${meeting_name}
    initiate web driver         ${device}
    perform web signin method       ${device}
    right click on created meeting from tdc       ${device}       ${meeting_name}       click=left
    join the meeting in TDC     ${device}

Verify and click on white board sharing in call control bar
        [Arguments]    ${device}
        Verify whiteboard sharing option under more option   ${device}

Web Driver Initialization and TDC Meeting Setup with Screen Sharing
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=lock_meeting      click=left
    join the meeting in TDC     device=tdc_1:user
    initiate tdc screen sharing    device=tdc_1:user

close driver
    close web driver    tdc_1:user
