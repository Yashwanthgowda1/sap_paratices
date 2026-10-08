*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  2
${action_time} =  5

*** Test Cases ***
TC1:[Front Row] Verify Front row option is present under Layout option on call control bar.
     [Tags]  380447      445150       P0   bvt_sm      sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify front row on call control bar    device=device_1    mode=front_row
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

# This feature is not supported in the new apk(2024031401). Reference: Feature Test Request 419702: [MTRA][W parity H1] Stage Layout switcher
#TC2:[Front Row] Verify Switch orientation toggle must be hidden when Front row is selected layout in a meeting.
#    [Tags]  380449      bvt_sm_blocked_by_feature_3333843      sanity_sm
#    [Setup]    Testcase Setup for Meeting User      count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify switch orientation toggle hidden after taping on frontrow   device=device_1
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2        state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC2:[Front Row] Check for White board sharing in Front Row.
    [Tags]   381853     P2
    [Setup]    Testcase Setup for Meeting User      count=3
    Join meeting   device=device_1,device_2,device_3    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Change meeting mode     device=device_1    mode=front_row
    verify front row participant  from_device=device_1    connected_device_list=device_2,device_3
    verify whiteboard sharing option under more option   device=device_1
    Wait for Some Time    time=${action_time}
    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
    verify front row participant  from_device=device_1    connected_device_list=device_2,device_3
    Stop presenting whiteboard share screen     device=device_1
    Wait for Some Time    time=${wait_time}
    End meeting      device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3:[Front Row] Verify Raise hands on the front row UI.
    [Tags]    380451    P2
    [Setup]    Testcase Setup for Meeting User      count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify front row participant  from_device=device_1    connected_device_list=device_2
    select raise hand option    device=device_1
    verify raise hand reaction  device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC4:[Front Row] Verify Participant tray on the front row Layout.
    [Tags]   380452    P2
    [Setup]    Testcase Setup for Meeting User      count=2
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify front row participant  from_device=device_1    connected_device_list=device_2
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC5:[Front Row] Verify Top bar in the meeting when DUT user selects Front Row Layout
     [Tags]   380454    P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1       meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1       state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify top bar in front row      device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6:[Front Row] Check for front row from report an issue page in meeting.
    [Tags]    381852      P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1       meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1       state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    Report an issue     device=device_1
    Click close btn    device_list=device_1
    Wait for Some Time    time=${wait_time}
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7:[Front Row] Verify U-bar in the Meeting when user selects Front Row
    [Tags]      380455        P2
    [Setup]    Testcase Setup for Meeting User      count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    Verify docked ubar      device=device_1
    Wait for Some Time    time=${wait_time}
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC8:[Front row] Verify the Content when whiteboard is shared.
    [Tags]   380471    P2
    [Setup]    Testcase Setup for Meeting User      count=3
    Join meeting   device=device_1,device_2,device_3    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Change meeting mode     device=device_1    mode=front_row
    verify front row participant  from_device=device_1    connected_device_list=device_2,device_3
    verify whiteboard sharing option under more option   device=device_1
    Wait for Some Time    time=${action_time}
    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
    verify front row participant  from_device=device_1    connected_device_list=device_2,device_3
    Stop presenting whiteboard share screen     device=device_1
    Wait for Some Time    time=${wait_time}
    End meeting      device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9:[Front Row] DUT user to verify the default view when no content shared.
     [Tags]   380469       P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1       meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1       state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify waiting for others to join      device=device_1
    verify top bar in front row      device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC10:[Front Row] Verify Front row behavior with single Participant.
     [Tags]     381904    P2
     [Setup]    Testcase Setup for Meeting User      count=1
     Verify meeting display on home screen     device=device_1
     Join meeting   device=device_1       meeting=cnf_device_meeting
     Verify meeting state   device_list=device_1       state=Connected
     change meeting mode     device=device_1    mode=front_row
     verify waiting for others to join      device=device_1
     End meeting      device=device_1
     Verify meeting state    device_list=device_1        state=Disconnected
     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC11:[Front Row] Verify that When no content is shared solid gray background with meeting info state is displayed
    [Tags]      380468      P2
    [Setup]    Testcase Setup for Meeting User      count=2
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    Verify no content and meeting info is displayed in screen   device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC12:[Front row] Verify the toggle of "Default to front Row" for Basic license
    [Tags]      382268      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for MTRA Basic User     count=1
    Navigate to app settings page   device=device_1
    navigate to meetings option in device settings page      device=device_1
    Verify the pro tag on front row     device=device_1        default_state_layout=front_row      pro_tag=check
    Come back from admin settings page     device_list=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND     Come back to home screen     device_list=device_1

TC13:[Front Row] Verify that Link shared by the TDC users should not be accessible
    [Tags]       380527     P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting from TDC
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    User should not able to access the link on chat layer in all layouts    device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC       device=tdc_1:user

*** Keywords ***
Verify front row on call control bar
    [Arguments]    ${device}    ${mode}
    change meeting mode     ${device}   ${mode}

Verify docked ubar
     [Arguments]    ${device}
     verify call control bar   ${device}

verify waiting for others to join
    [Arguments]    ${device}
    verify front row mode      device=device_1

verify front row toggle from device setting
    [Arguments]     ${device}
    Enable front row toggle from device setting     ${device}    default_state_layout=front_row

Navigate back from the device settings page
    [Arguments]     ${device}
    device setting back     ${device}
    device setting back     ${device}
    come back to home screen  ${device}

verify Front Row mode and Top bar in the meeting
    [Arguments]     ${device}
    verify chat on the front row ui     ${device}

Verify no content and meeting info is displayed in screen
    [Arguments]     ${device}
    verify_meeting_info_details_in_the_meeting      ${device}

Verify the pro tag on front row
    [Arguments]    ${device}        ${default_state_layout}     ${pro_tag}
    Enable front row toggle from device setting     ${device}        ${default_state_layout}        ${pro_tag}

User should not able to access the link on chat layer in all layouts
    [Arguments]       ${device}
    verify meeting chat     console=${device}        action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking
    Change meeting mode     ${device}    mode=front_row
    Verify front row mode   device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking


Join the meeting from TDC
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=lock_meeting      click=left
    join_the_meeting_in_TDC     device=tdc_1:user