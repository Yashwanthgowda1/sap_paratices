*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Meetings] Meeting should sync automatically on DUT
    [Tags]    444943    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
    Verify meeting display on home page   console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC2:[Meetings]Touch Console user can turn off/on the video while in a meeting
    [Tags]    315047    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Turn off video call   console=console_1
    Turn on video call  console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Meetings] Touch Console user can see the list of the participants in the meeting
    [Tags]      315051   bvt_tc_sm     sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant  console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[Meetings] Touch Console user can exit meeting by using the hang-up icon
    [Tags]    315063    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    Come back to home screen page   console_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2


#feature has been modified user not get the recording option
#TC4: [Meetings] Touch Console user gets meeting recording notification when any participants starts recording the session
#    [Tags]      315061   bvt_sm     sanity_sm
#    [Setup]   Testcase Setup for shared User    count=2
#    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Start recording   device_list=device_2
#    Verify start recording notification display on screen  console=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Meetings] Touch Console user can Increase/decrease volume while in meeting
    [Tags]      315055      bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Verify functionality of volume button    console=console_1   button=UP     state=In_meeting
    Verify functionality of volume button    console=console_1   button=Down   state=In_meeting
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Meetings] Verify 'Mute' & 'hang up' option while the Touch Console user joins the meeting
    [Tags]    444933    468421   P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant  console=console_1
    Validate call control bar options    console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[Meetings]Touch Console user can mute/ unmute microphone while in a meeting
    [Tags]    315049    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User    count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant   console=console_1
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC8:[Meetings]Touch Console user can add participants to the meeting & check turn off incoming video options
    [Tags]      444938    sanity_tc_sm    P1
    [Setup]   Testcase Shared Mode PSTN Setup Main   count=3
    Join a meeting   console=console_1     device=device_3    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_3     state=Connected
    Verify and view list of participant    console=console_1
    Add participant to the conversation using phonenumber   from_device=console_1    to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Verify for meeting state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Turn off incoming video call   console=console_1
    Turn on incoming video call   console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC9:[Meetings] Touch Console user can mute the other participants in the meeting
    [Tags]    315069    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User     count=3
    Join a meeting   console=console_1     device=device_2,device_3    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify and view list of participant    console=console_1
    Mute all active participants    console=console_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    Unmutes the phone call   device=device_2
    Unmutes the phone call   device=device_3
    Verify meeting Mute State       device_list=device_2,device_3   state=Unmute
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC10:[Meetings] User view the other participants (yet to join participants) on the Touch console screen
    [Tags]    315087    P2
    [Setup]   Testcase Setup for shared User     count=3
    Join a meeting   console=console_1     device=device_2,device_3    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify and view list of participant    console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC11:[Meetings] User can see a preview of the video stream
    [Tags]    444936    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Verify video preview on screen    device=device_2
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC12:[Meetings] Verify Live captions on Touch Console
    [Documentation]  Validated only the option of live captions not the compelete functionality
    [Tags]    315095    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Turn on live captions option    console=console_1
    Turn off live captions option   console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC13:[Meetings] Touch Console user disabled raise hand in the meeting
    [Tags]    315093    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Verify and select raise hand option   console=console_1
    Verify raise hand notification   device_list=device_2
    Verify and select lower hand option   console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

#feature has been modified user not get the recording option
#TC14: [Meetings] Touch console to start recording the meeting
#    [Tags]  251327      bvt_sm
#    [Setup]  Testcase Setup for shared User   count=2
#    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Select start recording option   console=console_1
#    Verify recording notification display on screen  device=device_2
#    Select stop recording option     console=console_1
#    Verify saved chat history notification display on screen    device_list=device_2
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC14:[Meeting] Verify user behavior when role transition to presenter from attendee
    [Tags]      322519    bvt_tc_sm   sanity_tc_sm
    [Setup]  Testcase Setup for shared User   count=3
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Make an attendee   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an attendee now notification   device=console_1
    verify attendee participant not able to add user in meeting  from_device=console_1      to_device=device_3
    Make an presenter     from_device=device_2     to_device=console_1:meeting_user     device_type=console
    Verify you are an presenter now notification   device=console_1
    verify add user option_is visible for presenter  console=console_1
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC15:[Meeting] Verify user behaviour when role changed to presenter from attendee
    [Tags]    315443    P1
    [Setup]  Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Make an attendee   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an attendee now notification   device=console_1
    Verify user not have manage audio and video option       console=console_1
    Make an presenter   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an presenter now notification   device=console_1
    verify add user option is visible for presenter  console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC16:[Meeting] verify attendee can raise hand in meeting
    [Tags]      322518   P1     sanity_tc_sm
    [Setup]  Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Make an attendee   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an attendee now notification   device=console_1
    Verify user not have manage audio and video option       console=console_1
    Verify and select raise hand option     console=console_1
    Verify raise hand notification   device_list=device_2
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC17:[Meeting] Verify attendee cannot add participants in the meeting
    [Tags]    322517    sanity_tc_sm    P1
    [Setup]  Testcase Setup for shared User   count=3
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Make an attendee   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an attendee now notification   device=console_1
    verify attendee participant not able to add user in meeting  from_device=console_1      to_device=device_3
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC18:[Meeting] Verify "Manage audio and video" option in meeting
    [Tags]    322515    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Verify manage audio and video option in meeting    console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC19:[Meeting] Verify "Manage audio and video" option not available for attendee.
    [Tags]    322516    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant    console=console_1
    Verify manage audio and video option in meeting     console=console_1
    Make an attendee   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an attendee now notification   device=console_1
    Verify not to have ellipse manage audio and video option        console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC20:[Meetings] The menu bar can be dismissed, if the user clicks somewhere outside of the bar area
    [Tags]    315067    P2
    [Setup]  Testcase Setup for shared User     count=3
    Join a meeting   console=console_1     device=device_2,device_3    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify and view list of participant    console=console_1
    Clicking on more option and taping on outside the menu bar    console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC21:[Meeting] Teams is pre-selected as a default meeting provider
    [Tags]    315101    P2
    [Setup]   Testcase Setup for shared User   count=2
    Start meeting using meet now    from_device=console_1    to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify and view list of participant     console=console_1
    Validate call control bar options   console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC22:[MTRA] Verify Focus tile in booked state (currently booked or booking to start within 10 min or less)
    [Tags]    444794    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=1
    Verify focus tiles on calendar      device=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC23:[Meeting] While the meeting is being joined, a progress screen and list of participants is displayed
    [Tags]    444932    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    verify hang up button present in pre call screen    device=console_1
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and view list of participant  console=console_1
    End A Meeting     console=console_1    device=device_2
    Verify for call state    console_list=console_1    device_list=device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC24:[Meetings] Touch Console user gets meeting recording notification when any participants starts recording the session
    [Tags]    444939    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1    meeting=rooms_console_meeting
    Join the meeting
    Verify for meeting state     console_list=console_1     device_list=None   state=Connected
    Start the recording from TDC    device=tdc_1:user
    Verify start recording notification display on screen   device=console_1
    Disconnect the call on TDC      device=tdc_1:user
    End the meeting    console=console_1
    Verify for call state    console_list=console_1     device_list=None       state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND    Close Driver

TC25:[Meetings] Verify 'Mute' & 'hang up' option while the Touch Console user joins the meeting
    [Tags]    444933    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    verify hang up button present in pre call screen    device=console_1
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify call control bar options    console=console_1
    End A Meeting    console=console_1    device=device_2
    Verify for call state    console_list=console_1    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC26:[New Meeting] Start new meeting from more options in Home screen
    [Tags]    315099
    [Setup]  Testcase Shared Mode PSTN Setup Main     count=3
    Tap On More Option    console=console_1
    Verify More Options    console=console_1
    Start meeting using meet now   from_device=console_1    to_device=device_3
    Accept incoming call   device=device_3
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_3    state=Connected
    Add participant to the conversation using phonenumber  from_device=console_1    to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    End up call     console=console_1       device=device_2,device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Navigate to show meeting names page
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Verify show meeting names toggle btn status    ${console}
    Disable show meeting names toggle btn   ${console}
    Click back btn   ${console}
    device setting back btn     ${console}
    device setting back btn     ${console}
    Click on back layout btn   ${console}
    Come back to home screen page   console_list=${console}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable show meeting names toggle btn
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable show meeting names toggle button    ${console}
    Click back btn   ${console}
    device setting back btn     ${console}
    device setting back btn     ${console}
    Click on back layout btn   ${console}
    Come back to home screen page   console_list=${console}

verify attendee participant not able to add user in meeting
    [Arguments]    ${from_device}   ${to_device}
    Verify not able to add user in meeting      ${from_device}   ${to_device}
    Verify notification not able to add new user        ${from_device}

Verify not to have ellipse manage audio and video option
    [Arguments]    ${console}
    Verify user not have manage audio and video option     ${console}

Verify and click on white board sharing in call control bar
    [Arguments]    ${device}
    Verify whiteboard sharing option under more option   ${device}

Clicking on more option and taping on outside the menu bar
    [Arguments]    ${console}
    verify menu bar more options    ${console}
    tapping outside more option     ${console}

Join the meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=rooms_console_meeting      click=left
    join_the_meeting_in_TDC     device=tdc_1:user

close driver
    close web driver    tdc_1:user

Verify call control bar options
    [Arguments]    ${console}
    Verify docked ubar options      ${console}

End up call
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

