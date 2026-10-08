*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup      Web Driver Initialization and TDC Meeting Setup with Screen Sharing
Suite Teardown    Run Keywords  Suite Failure Capture     AND   close driver
*** Variables ***
${action_time} =  5

*** Test Cases ***
TC1:[Meetings] DUT user can view content shared by other participant in the meeting
    [Tags]      237696    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2:[Meetings] Layout icon in gallery mode during the content sharing
    [Tags]     237858
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    Verifying layout options with two connected devices   device=device_1
    verify the gallery layout selected default and with chat    device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC3:[Meetings] Verify Focus on content mode in layout during the content sharing
    [Tags]     237860
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    change meeting mode     device=device_1     mode=gallery
    verify focus on content mode       device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC4:[Meeting]Verify Together mode during the Meeting
    [Tags]      237912    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    verify layout switcher ui       device=device_1
    Dismiss the popup screen        device=device_1
    Change meeting mode    device=device_1      mode=together
    verify together mode after switching       device=device_1
    disable video call  device=device_1
    verify layout options after disable video call      device=device_1
    verify the gallery layout selected default and with chat    device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC5:[Meetings] Verify content + People mode in layout during the content sharing
    [Tags]     237859    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    verify default gallery and content people selection during sharing      device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6:[Spotlight] Verify if Spotlight participant leaves meeting then if content is being shared, it takes up the main stage
   [Tags]     237972      P1
   [Setup]  Testcase Setup for Meeting User     count=1
    Join Meeting    device=device_1,device_3     meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_3    state=Connected
    make a spotlight   from_device=device_1   to_device=device_3
    verify spotlight text on device   device=device_3   text=spotlight
    Close participants screen   device=device_1
    verify spotlight icon    device=device_3
    End meeting     device=device_3
    verify spotlight icon disable       device=device_1
    Verify participants list in meeting     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1,device_3  state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC7:[Reactions] Verify Hand raise notification displayed on DUT screen when content shared by other participant in the meeting
    [Tags]       316935          P1
    [Setup]  Testcase Setup for Meeting User     count=3
    Join meeting   device=device_1,device_3   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_3    state=Connected
    verify content shared from tdc      device=device_1
    Select raise hand option  device=device_3
    Verify raise hand notification   device_list=device_1
    End meeting   device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8:[Stage Layout Switcher] Verify that Gallery Layout when Content is shared.
     [Tags]     444532
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    Verifying layout options with two connected devices   device=device_1
    verify default gallery and content people selection during sharing      device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC9:[Stage Layout Switcher] Verify that Focus on Content layout.
    [Tags]      444539   sanity_sm     bvt_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    verify focus on content mode       device=device_1
    verify participants grid present in the meeting     device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC10:[MTRA] Verify that Focus on Content layout with chat.
    [Tags]      444540     sanity_sm     bvt_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    verify focus on content mode     device=device_1
    verify participants grid present in the meeting     device=device_1
    Enable and disable the chat toggle in meeting       device=device_1      state=on
    verify the chat options in meeting       device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC11:[Stage Layout Switcher] Verify the Gallery layout when show meeting chat is disabled under the teams admin settings, when content shared.
    [Tags]     444543     P2
    [Setup]  Testcase Setup for Meeting User     count=1
    enable or disable the show meeting chat option    device=device_1         state=off
    Join meeting   device=device_1  meeting=lock_meeting
    Verify meeting state   device_list=device_1  state=Connected
    verify content shared from tdc      device=device_1
    verify default gallery and content people selection during sharing      device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1    AND      enable or disable the show meeting chat option    device=device_1         state=on

TC12:[Front Row] Verify DUT is user able to select Front Layout from Call control bar.
    [Tags]   380448     P2
    [Setup]    Testcase Setup for Meeting User      count=2
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify content shared from tdc      device=device_1
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify front row participant  from_device=device_1    connected_device_list=device_2
    verify focus on content mode       device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC13:[Chat]Verify the chat option when DUT user enables chat option in Content+ people mode.
    [Tags]      379987     P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=lock_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify content shared from tdc      device=device_1
    verify default gallery and content people selection during sharing      device=device_1
    verify focus on content mode     device=device_1
    Enable and disable the chat toggle in meeting       device=device_1      state=on
    verify the chat options in meeting       device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC14:[Chat]Verify the chat option in Content+ people mode when DUT user disables "show meeting chat" option from Admin settings.
    [Tags]    379988    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    enable or disable the show meeting chat option        device=device_1         state=off
    Join meeting         device=device_1  meeting=lock_meeting
    Verify meeting state         device_list=device_1  state=Connected
    verify content shared from tdc      device=device_1
    verify default gallery and content people selection during sharing      device=device_1
    verify that chat toggle button is not present    device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1    AND      enable or disable the show meeting chat option    device=device_1         state=on

TC15:[Front Row] Verify the live captions when user sharing content in front row mode.
    [Tags]   380522        P2
    [Setup]    Testcase Setup for Meeting User      count=2
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify front row participant  from_device=device_1    connected_device_list=device_2
    Unmutes the phone call   device=device_1
    Verify meeting Mute State    device_list=device_1    state=unmute
    Turn on live captions and validate   device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC16:[Meeting]Verify Gallery & Large Gallery mode during the Meeting
    [Tags]     237911   P1
    [Setup]  Testcase Setup for Meeting User     count=3
    Join meeting   device=device_1,device_3   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_3    state=Connected
    verify content shared from tdc      device=device_1
    verify the gallery layout selected default and with chat    device=device_1
    change meeting mode     device=device_1    mode=large_gallery
    verify changed mode  device=device_1      changed_mode=large_gallery
    End meeting      device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_3

TC17:[Stage Layout Switcher] Verify that Focus on Content when show meeting Chat is disabled under the teams admin settings.
    [Tags]     444587     P2
    [Setup]  Testcase Setup for Meeting User     count=1
    enable or disable the show meeting chat option    device=device_1         state=off
    Join meeting   device=device_1  meeting=lock_meeting
    Verify meeting state   device_list=device_1  state=Connected
    verify that chat toggle button is not present   device=device_1
    verify content shared from tdc      device=device_1
    verify default gallery and content people selection during sharing      device=device_1
    verify that chat toggle button is not present    device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1    AND      enable or disable the show meeting chat option    device=device_1         state=on

# Ensure Calling and Meetnow Related Test Cases Are Last in Sequence
TC18:[Call] TDC user 1 sharing desktop with DUT user and TDC user 2.
    [Tags]     444816     P2
    [Setup]     Run Keywords   close driver     AND     Testcase Setup for Meeting User     count=3
    Initiate the call from TDC    device=tdc_1:user     to_device=device_1:meeting_user,device_3:user
    Accept incoming call      device=device_1,device_3
    Wait for Some Time    time=${action_time}
    initiate tdc screen sharing    device=tdc_1:user
    verify content shared from tdc      device=device_1
    stop tdc screen sharing     device=tdc_1:user
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_3    AND     close driver

TC19:[Meet now] TDC user adds Teams App user during desktop sharing in the meeting
    [Tags]     259704   P2
    [Setup]  Testcase Setup for Meeting User     count=3
    Initiate the Meet Now call from TDC
    Accept incoming call      device=device_1,device_3
    initiate tdc screen sharing    device=tdc_1:user
    verify content shared from tdc      device=device_1
    stop tdc screen sharing     device=tdc_1:user
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_3    AND     close driver

*** Keywords ***
Web Driver Initialization and TDC Meeting Setup with Screen Sharing
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=lock_meeting      click=left
    join the meeting in TDC     device=tdc_1:user
    initiate tdc screen sharing    device=tdc_1:user

Verifying layout options with two connected devices
    [Arguments]     ${device}
     verify layout options after disable video call     ${device}

Verify reactions visible on screen after taping
    [Arguments]       ${from_device}        ${to_device}
    Click like button     ${from_device}
    Verify reaction button on screen after tap on it   ${to_device}
    Tap on laugh button     ${from_device}
    Verify reaction button on screen after tap on it        ${to_device}
    Tap on clap button     ${from_device}
    Verify reaction button on screen after tap on it       ${to_device}
    Tap on heart button     ${from_device}
    Verify reaction button on screen after tap on it   ${to_device}
    Verify and select raise hand option  ${from_device}
    Verify raise hand notification   ${to_device}
    Verify and select lower hand option  ${from_device}

enable or disable the show meeting chat option
    [Arguments]       ${device}     ${state}
    Navigate to app settings page    ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable the chat toggle in admin setting     ${device}        ${state}
    come back from admin settings page  device_list=${device}

Navigate to app settings page
    [Arguments]     ${device}
    Click on more option   ${device}
    Click on settings page   ${device}

close driver
    close web driver    tdc_1:user

Initiate the Meet Now call from TDC
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    create a meeting using meet now in tdc      device=tdc_1:user
    search participate in people tab request to join    device=tdc_1:user    to_device=device_1:meeting_user,device_3
    Wait for Some Time    time=5s

Initiate the call from TDC
    [Arguments]     ${device}     ${to_device}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    make outgoing call from tdc using number    ${device}     ${to_device}
