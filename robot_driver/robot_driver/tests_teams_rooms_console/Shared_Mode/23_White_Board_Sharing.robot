*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Resource    ../../resources/keywords/common.robot

Suite Setup     initiate web driver in setup
Suite Teardown    Run Keywords     Suite Failure Capture    AND   close driver


*** Variables ***
${wait_time} =  10
${wait_time1} =  3
${30_minutes_wait_time} =  30 minutes
${5_minutes_wait_time} =  5 minutes
${action_time} =  5

*** Test Cases ***
TC1:[Whiteboard Sharing] TC user should have an option to share whiteboard during meeting
    [Tags]    315256    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify whiteboard sharing option on call control bar   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Whiteboard Sharing]DUT user to verify the whiteboard tools during meeting
    [Tags]    315260    P1
    [Setup]  Testcase Setup for shared User   count=2
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Verify whiteboard tools display on screen    device=device_1
    Stop presenting whiteboard share screen   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Whiteboard Sharing] Rejoin for the same meeting should not create new whiteboard
    [Tags]    315284    sanity_tc_sm    P1
    [Setup]  Testcase Setup for shared User   count=3
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify whiteboard sharing option under more option        device=console_1
    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2,device_3
    Whiteboard sharing should not visible after disconnect from the meeting       console=console_1     device=device_1
    Verify for call state       console_list=console_1      state=Disconnected
    Join a meeting   console=console_1      meeting=whiteboard_sharing_meeting
    Verify for call state       console_list=console_1      state=Connected
    Verify whiteboard sharing option under more option        device=console_1
    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2,device_3
    Click on stop whiteboard sharing    console=console_1       device=device_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC4:[Whiteboard] Observe Whiteboard when DUT user rejoins the meeting when removed by TDC
    [Tags]    322901    P2
    [Setup]  Testcase Setup for shared User   count=3
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify whiteboard sharing option under more option        device=device_2
    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2,device_3
    Remove user from meeting call   from_device=device_2      to_device=console_1:meeting_user      device_type=console
    Verify someone removed you from the meeting call  device=console_1
    Close participants screen   device=device_2
    Verify for call state    console_list=console_1    state=Disconnected
    Join a meeting   console=console_1     meeting=whiteboard_sharing_meeting
    Verify meeting state   device_list=device_1     state=Connected
    Wait for Some Time    time=${wait_time}
    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user
    Stop presenting whiteboard share screen    device=device_2
    Verify whiteboard should not visible on all participants    device_list=device_1,device_2,device_3
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting      console=console_1    device=device_2,device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC5:[Whiteboard Sharing] DUT user to verify settings option on whiteboard
    [Tags]    315292        P2
    [Setup]  Testcase Setup for shared User   count=2
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Verify sliding menu option inside settings icon    device=device_1
    Stop presenting whiteboard share screen   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2      AND     come back to calendar page on TDC   device=tdc_1

TC6:[Whiteboard Sharing] Verify Share Whiteboard is not displaying when DUT is an attendee
    [Tags]    322897        P2
    [Setup]  Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Make an attendee   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an attendee now notification     device=console_1
    Verify white board sharing option should not visible after making an attendee   device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[MS Whiteboard] Verify mic status is same when whiteboard is shared as it is in meeting
    [Tags]    322898        P2
    [Setup]  Testcase Setup for shared User   count=2
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Mutes the phone call    device=device_2
    Verify meeting Mute State    device_list=device_2    state=mute
    verify whiteboard sharing option under more option   device=device_2
    Check for whiteboard visibility of participants and validate  from_device=device_2    connected_device_list=device_1
    Verify mic status from another user     from_device=console_1   to_device=device_2      mic_status=mute
    Unmutes the phone call   device=device_2
    Verify meeting Mute State    device_list=device_2    state=unmute
    Verify mic status from another user     from_device=console_1   to_device=device_2      mic_status=unmute
    Stop presenting whiteboard share screen     device=device_2
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2        AND     come back to calendar page on TDC   device=tdc_1

TC8:[Whiteboard] Verify DUT user screen when whiteboard is being shared and TDC user is spotlighted
    [Tags]    322906        P2
    [Setup]  Testcase Setup for shared User   count=2
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    make a spotlight   from_device=device_2   to_device=device_2
    verify spotlight text on device   device=device_2   text=spotlight
    Close participants screen   device=device_2
    verify spotlight icon on main screen in the meeting  device=device_1
    Verify half white board sharing and half spotlighted screen in the call screen      device=device_1
    Stop presenting whiteboard share screen   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2            AND     come back to calendar page on TDC   device=tdc_1

TC9:[Meeting] TDC user share the Whiteboard during meeting with DUT
    [Tags]     315168    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User   count=2
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    share whiteboard    device=tdc_1:non_pro_user
    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2
    Verify user should not have stop presenting button     device=console_1
    Stop presenting whiteboard share screen    device=device_2
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2


TC10:[Whiteboard sharing] Verify Reactions flow on whiteboard when someone shares reactions during meeting
    [Tags]    322908    P2
    [Setup]  Testcase Setup for shared User   count=3
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Verify reactions visible on screen after taping     from_device=device_2        to_device=device_1
    Verify reactions visible on screen after taping     from_device=device_3        to_device=device_1
    Send the message from chat option in TDC  device=tdc_1:non_pro_user     message=checking for the testing purpose
    verify should not get the reaction pop up on chat layout    device=device_1
    Stop presenting whiteboard share screen   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting      console=console_1    device=device_2,device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC11:[Whiteboard]Verifying the Whiteboard sharing screen visible to the added Participants when paired with Console.
    [Tags]    339665    P2
    [Setup]  Testcase Setup for shared User   count=3
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2,device_3
    Stop presenting whiteboard share screen   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting      console=console_1    device=device_2,device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC12:[Whiteboard sharing] Launch whiteboard from home screen and leave idle for > 5min
    [Tags]    349057    P2
    [Setup]  Testcase Setup for shared User   count=1
    verify initiate Whiteboard under more option      console=console_1    device=device_1
    Wait for Some Time    time=${5_minutes_wait_time}
    verify About to Leave and snooze options     device=console_1
    verify whiteboard tools not displayed on screen      device=device_1
    Verify time display on home screen   console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1    device_list=device_1

TC13:[Whiteboard Sharing] Shared whiteboard should not be displayed for PSTN user
    [Tags]    315276    P1     sanity_tc_sm
    [Setup]  Testcase Shared Mode PSTN Setup Main   count=2
    Join a meeting   console=console_1         meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=None     state=Connected
    Add participant to the conversation using phonenumber   from_device=console_1    to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Verify for meeting state     console_list=console_1    device_list=device_2    state=Connected
    Verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2:pstn_user
    verify whiteboard tools not displayed on screen     device=device_2
    End a meeting      console=console_1    device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC14: [Whiteboard] Verifying the text displayed when User Tap on Whiteboard option when FoR is paired with Touch Console.
    [Tags]    339658       P0     bvt_tc_sm     sanity_tc_sm
    [Setup]  Testcase Setup for shared User   count=1
    verify or start meeting after whiteboard launch    device=console_1    start_meeting_option=verify
    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1
    Verify Stop Whiteboard Button Behavior when Tapped on it    device=console_1
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1

TC15: [Whiteboard]Verify DUT throws a auto exit pop up when user leave the DUT idle for 30min with whiteboard opened, when paired with Console.
    [Tags]    339660       P2
    [Setup]  Testcase Setup for shared User   count=1
    verify or start meeting after whiteboard launch     device=console_1    start_meeting_option=click
    Wait for Some Time    time=${30_minutes_wait_time}
    Verify Stop Whiteboard Button Behavior when Tapped on it    device=console_1
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1

TC16: [Whiteboard]DUT user Verify the Reactions while in meeting on whiteboard screen when FoR is paired with Console.
    [Tags]    340122      P2
    [Setup]  Testcase Setup for shared User   count=2
    verify Start meeting and verify Whiteboard launch  device=console_1
    Wait for Some Time    time=${action_time}
    Add participant to the conversation using display name   from_device=console_1    to_device=device_2
    Accept incoming call    device=device_2
    Verify meeting state    device_list=console_1,device_2    state=Connected
    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
    Wait for Some Time    time=${action_time}
    Verify reactions visible on screen after taping     from_device=device_2        to_device=device_1
    End meeting     device=console_1,device_2
    Verify meeting state    device_list=console_1,device_2  state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC17: [Whiteboard]Verify when DUT user Stop white board " Continue or Exit whiteboard" pop up should be displayed
    [Tags]    340123     P2
    [Setup]  Testcase Setup for shared User   count=1
    verify or start meeting after whiteboard launch     device=console_1    start_meeting_option=verify
    Wait for Some Time    time=${action_time}
    Verify Stop Whiteboard Button Behavior when Tapped on it    device=console_1
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1

#Last cases in the suite as enabling / disabling toggle for whiteboard
TC18:[Whiteboard]TC user Disable/Enable the Whiteboard from the Teams admin settings.
    [Tags]        346111    P2    sanity_tc_sm
    [Setup]  Testcase Setup for shared User   count=1
    Navigate to app settings screen page  console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=off
    come back from admin settings page     device_list=console_1
    verify whiteboard sharing option is not present in home screen  device=console_1
    Navigate to app settings screen page  console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=on
    come back from admin settings page     device_list=console_1
    Verify user options on home screen       console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Enable white board sharing toggle

TC19:[Whiteboard sharing] Verify that "Share Whiteboard" option is not available when "Allow room to initiate Whiteboard" toggle is disabled under admin settings.
    [Tags]    348094    P2
    [Setup]  Testcase Setup for shared User   count=2
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=off
    come back from admin settings page     device_list=console_1
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify whiteboard not present in meeting tab     device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting      console=console_1    device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Enable white board sharing toggle

TC20:[Whiteboard sharing] DUT user shares Whiteboard when one participant is sharing Desktop
    [Tags]    322895    P2
    [Setup]  Testcase Setup for shared User   count=2
    Join the meeting        device=tdc_1:non_pro_user      meeting_name=console_lock_meeting
    initiate tdc screen sharing    device=tdc_1:non_pro_user
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify content shared from tdc      device=device_1
    verify and click on white board sharing in call control bar   device=console_1
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_2
    Click stop presenting whiteboard   device=console_1
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End a meeting      console=console_1    device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC21:[Whiteboard Sharing] Verify whiteboard when meeting is scheduled with different tenant account
    [Tags]    322894    P2
    [Setup]  Testcase setup for shared mode PSTN Setup as Main device   count=2
    Join a meeting   console=console_1     device=device_2     meeting=console_lock_meeting
    verify waiting in the lobby message     device=console_1
    make admit and deny in the meeting      from_device=device_2   to_device=console_1:pstn_user     lobby=admit_lobby
    Close roaster button on participants screen   device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify whiteboard not present in meeting tab     device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Verify Stop Whiteboard Button Behavior when Tapped on it
    [Arguments]    ${device}
    verify Start Meeting and Stop Whiteboard options when the dut user launch whiteboard    ${device}

verify Stop presenting whiteboard share screen in Docked Ubar and stop whiteboard share
    [Arguments]    ${device}
    Stop presenting whiteboard share screen      ${device}

Verify and click on white board sharing in call control bar
    [Arguments]    ${device}
    Verify whiteboard sharing option under more option   ${device}

close white board popup
     [Arguments]    ${device}
     device right corner click   ${device}

initiate web driver in setup
    initiate web driver     tdc_1
    perform web signin method     tdc_1:non_pro_user
    remove canceled meeting    device=tdc_1    meeting_name=Canceled: whiteboard_sharing_meeting

Join the meeting
    [Arguments]         ${device}    ${meeting_name}
    right click on created meeting from tdc       ${device}       ${meeting_name}       click=left
    join the meeting in TDC     ${device}

Verify reactions visible on screen after taping
    [Arguments]       ${from_device}        ${to_device}
    Click like button     ${from_device}
    Verify reaction button on screen after tap on it   ${to_device}
    Click on laugh button     ${from_device}
    Verify reaction button on screen after tap on it        ${to_device}
    click on clap button     ${from_device}
    Verify reaction button on screen after tap on it       ${to_device}
    click on heart button     ${from_device}
    Verify reaction button on screen after tap on it   ${to_device}
    Verify and select raise hand option  ${from_device}
    Verify raise hand notification   ${to_device}
    Verify and select lower hand option  ${from_device}

verify should not get the reaction pop up on chat layout
    [Arguments]    ${device}
    Verify messages on chat layers      ${device}     message=checking for the testing purpose        action_type=clicking

Enable white board sharing toggle
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=on
    come back from admin settings page     device_list=console_1
    Verify user options on home screen       console=console_1
    Come back to home screen page   console_list=console_1   device_list=device_2

Navigate to app settings screen page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

close driver
    close web driver    tdc_1:non_pro_user
