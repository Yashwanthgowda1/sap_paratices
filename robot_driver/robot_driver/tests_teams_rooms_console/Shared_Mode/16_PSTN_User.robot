*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10
${3swait_time} =  3
${60s_wait_time} =  60

*** Test Cases ***
TC1:[Incoming Call] DUT receives call from PSTN user
    [Tags]    444728    P1    sanity_tc_sm
    [Setup]  Testcase Shared Mode PSTN Setup Main    count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Outgoing Call] Touch Console user calls to PSTN user from more menu dialpad
    [Tags]    314996    P1    sanity_tc_sm
    [Setup]  Testcase Shared Mode PSTN Setup Main   count=2
    Tap on more option      console=console_1
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2:pstn_user
    Accept incoming call     device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Outgoing Call] DUT calls to PSTN user from home screen Call app
    [Tags]    444711    bvt_tc_sm    sanity_tc_sm
    [Setup]    Testcase Shared Mode PSTN Setup Main     count=2
    Make outgoing call using dial pad   from_device=console_1     to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect call     device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[Escalate to Conference] DUT can add PSTN user while in call with TDC user
    [Tags]    444715    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Shared Mode PSTN Setup Main    count=3
    Place an outgoing call using dial pad    from_device=device_3     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_3    state=Connected
    Add participant to the conversation using phonenumber    from_device=console_1    to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2    state=disconnected
    Verify and view list of participant     console=console_1
    Disconnect the call    console=console_1
    Verify for call state    console_list=console_1    device_list=device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC5:[Escalate to conference] DUT user can add TDC user while in call with PSTN user
    [Tags]    444716    sanity_tc_sm    P1
    [Setup]   Testcase Shared Mode PSTN Setup Main    count=3
    Make outgoing call using auto dial from dial pad    from_device=console_1     to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    Hang up call     console=console_1     device=device_2
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC6:[Call control] DUT user hold the muted call with PSTN user
    [Tags]    315021    P2
    [Setup]    Testcase Shared Mode PSTN Setup Main     count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Hold current call   console=console_1
    Verify for call state     console_list=console_1        state=Hold
    Wait for Some Time     time=${60s_wait_time}
    Resume current call  console=console_1
    Verify for call state     console_list=console_1     state=Resume
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    Disconnect call     device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[Escalate to conference] DUT user can add another PSTN user while in call with a PSTN user
    [Tags]    444722    P2
    [Setup]   Testcase Shared Mode For 2 PSTN Setup   count=3
    Make outgoing call using auto dial from dial pad    from_device=console_1     to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to the conversation using phonenumber    from_device=console_1    to_device=device_3:pstn_user
    Accept incoming call      device=device_3
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    Hang up call     console=console_1     device=device_2
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC8:[Home Screen] Dial pad should be available for PSTN enabled user
    [Tags]    314980    P1    sanity_tc_sm
    [Setup]  Testcase Shared Mode PSTN Setup Main    count=2
    check dial pad on landing page   console=console_1
    Verify dial pad in more option      console=console_1
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2:pstn_user
    Accept incoming call     device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC9:[Chat]Verify the chat option in P2P PSTN call when user enables chat option.
    [Tags]    380076    P2
    [Setup]   Testcase Shared Mode PSTN Setup Main    count=2
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2:pstn_user
    Accept incoming call     device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify layouts option should not present on call control bar   device=console_1
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC10:[Call-App] Verify user can enter mail id/ DID for PSTN or cross tenants call/meeting.
    [Tags]    444618    P2
    [Setup]    Testcase Shared Mode PSTN Setup Main    count=2
    verify external text when entered cross tenant mail id    from_device=console_1    to_device=device_2:pstn_user
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC11:[Call App] Verify user can enter mail id/username and search For External Participants
    [Tags]    444619    bvt_tc_sm    sanity_tc_sm
    [Setup]    Testcase Shared Mode PSTN Setup Main    count=2
    Make outgoing call with username using dial pad    from_device=console_1     to_device=device_2:pstn_user
    Accept incoming call     device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC12:[Home screen] PSTN disabled user should not have dial pad icon on Touch Console home screen
    [Tags]    314978    P2
    [Setup]   Testcase setup for shared mode PSTN disabled Setup as Main device     count=1
    Verify user should not have dialpad     device=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC13:[Large Gallery] Verify Large Gallery in video meeting with other tenant user
    [Documentation]  Add device_2:pstn_user details as attendee in rooms_console_meeting
    [Tags]    322599    P2
    [Setup]    Testcase Shared Mode PSTN Setup Main    count=2
    Join a meeting   console=console_1      device=device_2     meeting=rooms_console_meeting
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify waiting in the lobby message     device=device_2
    Check video call Off state      device_list=device_2
    verify gallery and front row visible on layout      console=console_1
    End a meeting     console=console_1     device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1     device_list=device_2

TC14:[Large Gallery] Verify Together mode in audio meeting with other tenant user
    [Tags]    322598    P1     sanity_tc_sm
    [Setup]    Testcase Shared Mode PSTN Setup Main    count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify layout options   device=console_1
    End a meeting     console=console_1     device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC15:[Reactions]Verify a reaction window should be shown when meeting is created by PSTN user
    [Tags]   418766    P2
    [Setup]    Testcase Shared Mode PSTN Setup Main    count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify reactions options in call control bar     console=console_1
    Verify and select raise hand option  console=console_1
    Verify raise hand notification      device_list=device_2
    lower the raised hand from another user     from_device=device_2   to_device=console_1      device_type=console
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]  Run Keywords   Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

*** Keywords ***
Hang up call
    [Arguments]    ${console}    ${device}
    Disconnect the call    console=${console}
    Disconnect call     device=${device}

End a meeting
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

verify dial pad in more option
    [Arguments]     ${console}
     Verify available options in more    ${console}
     Click on back layout btn       ${console}

Navigate to app settings screen page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Navigate back to settings screen
    [Arguments]     ${console}
    Tap on device right corner  ${console}
    Click back btn   ${console}
    device setting back btn     ${console}
    Click on close button    console_list=${console}

Disabling the auto accept meeting invite and start my video automatically
    [Arguments]     ${console}      ${state}
    Navigate to app settings screen page    ${console}
    Navigate to meeting and calling options from device settings page       ${console}   option=calling
    accept meeting invites automatically   device=${console}      state=off
    start my video automatically       device=${console}      state=off
    Navigate back to settings screen    ${console}
    Click on back layout btn   ${console}


verify gallery and front row visible on layout
    [Arguments]     ${console}
    verify_layout_options_after_disable_video_call      device=${console}
