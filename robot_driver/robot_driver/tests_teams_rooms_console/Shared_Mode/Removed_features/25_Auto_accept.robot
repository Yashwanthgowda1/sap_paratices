#*** Settings ***
#Documentation   Validating the functionality of console App settings feature.
#Force Tags    sm_app_settings   sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#Suite Setup     Enable auto accept toggle for meeting invites and my video
#Suite Teardown      Run Keywords   Suite Failure Capture  disabling auto accept meeting invite and start my video automatically
#*** Variables ***
#${wait_time} =  15
#${wait_time1}=  5
#
#*** Test Cases ***
#TC1:[Auto accept] Touch Console user should auto join meeting with video enabled
#     [Tags]  315511     bvt_sm      sanity_sm
#    [Setup]  Testcase Setup for shared User     count=2
#    Join Meeting    device=device_2:        meeting=console_lock_meeting
#    Add participant to the conversation using display name   from_device=device_2      to_device=console_1:meeting_user
#    Close participants screen   device=device_2
#    Verify meeting state   device_list=console_1,device_2    state=Connected
#    Check video call On state   device_list=console_1,device_2
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND       Come back to home screen page   console_list=console_1
#
#TC2:[Auto accept] Touch Console user should auto accept meeting join invites for scheduled meetings
#    [Tags]  315509      sanity_sm       bvt_sm
#    [Setup]  Testcase Setup for shared User     count=2
#    Join Meeting    device=device_2:        meeting=console_lock_meeting
#    Add participant to the conversation using display name   from_device=device_2      to_device=console_1:meeting_user
#    Close participants screen   device=device_2
#    Verify meeting state   device_list=console_1,device_2    state=Connected
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#TC3:[Auto accept] Touch Console user receives the incoming call manually
#    [Tags]  315519      sanity_sm    P1
#    [Setup]  Testcase Setup for shared User     count=2
#    Join Meeting    device=device_2:        meeting=console_lock_meeting
#    Add participant to the conversation using display name   from_device=device_2      to_device=console_1:meeting_user
#    Pick up incoming call    console=console_1
#    Close participants screen   device=device_2
#    Verify meeting state   device_list=console_1,device_2    state=Connected
#    Check video call On state   device_list=console_1,device_2
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#   [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#TC4: [Auto accept for Meet Now] Verify that Auto accept option should not work for P2P call
#    [Tags]  322846      P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
#    verify auto accept timer is not present    device=console_1
#    Wait for Some Time    time=${wait_time}
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1     device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#TC5: [Auto accept] Touch Console user rejects the incoming call
#    [Tags]   315517     P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Join Meeting    device=device_2:        meeting=console_lock_meeting
#    Add participant to the conversation using display name   from_device=device_2      to_device=console_1:meeting_user
#    decline the incoming call      console=console_1
#    Verify for call state    console_list=console_1    state=Disconnected
#    Close participants screen   device=device_2
#    End meeting     device=device_2
#    Verify meeting state     device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#TC6:[Auto accept] Touch Console user to enable the auto accept settings
#    [Tags]  315515      P2
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically   device=console_1      state=off
#    start my video automatically       device=console_1      state=off
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically    device=console_1      state=on
#    start my video automatically        device=console_1      state=on
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#TC7: [Auto accept]Touch Console user enables Teams Calling settings
#    [Tags]  315523      P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically   device=console_1      state=off
#    start my video automatically       device=console_1      state=off
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically    device=console_1      state=on
#    start my video automatically        device=console_1      state=on
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1
#
#TC8: [Auto accept for Meet Now] Verify Touch console accept audio call automatically for Meet now invites
#    [Tags]  322841      P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Start meeting using meet now    from_device=device_2    to_device=console_1:meeting_user
#    Close participants screen   device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    End up call     console=console_1       device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#TC9:[Auto accept for Meet Now] Verify Touch console accept Video call automatically for Meet now invites
#    [Tags]  322842    P0     sanity_sm      bvt_sm
#    [Setup]  Testcase Setup for shared User     count=2
#    Start meeting using meet now    from_device=device_2    to_device=console_1:meeting_user
#    Close participants screen   device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    End up call     console=console_1       device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#TC10:[Auto accept for Meet Now] Verify that Auto accept option will disabled after re-login
#    [Tags]  322847      P2
#    [Setup]  Testcase Setup for shared User     count=1
#    Console re login    console=console_1
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    verify auto accept toggle is disabled     device=console_1
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically    device=console_1      state=on
#    start my video automatically        device=console_1      state=on
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#   [Teardown]  Run Keywords   Capture Failure   AND     Come back to home screen page   console_list=console_1
#
#TC11:[Auto accept for Meet Now] Verify that Touch console user can decline Auto accept call
#    [Tags]  322848      P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Start meeting using meet now    from_device=device_2    to_device=console_1:meeting_user
#    decline the incoming call      console=console_1
#    Verify for call state    console_list=console_1    state=Disconnected
#    Close participants screen   device=device_2
#    Disconnect call      device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND  Come back to home screen page   console_list=console_1
#
#*** Keywords ***
#Navigate to app settings screen page
#    [Arguments]     ${console}
#    Tap on more option  ${console}
#    Tap on settings page   ${console}
#
#Navigate back to settings screen
#    [Arguments]     ${console}
#    Tap on device right corner  ${console}
#    Click back btn   ${console}
#    device setting back btn     ${console}
#    Click on close button    console_list=${console}
#
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page    ${device}
#
#navigate calling option
#    [Arguments]       ${device}
#    navigate to teams admin settings   ${device}
#    verify calling option in device settings page     ${device}
#
#
#disabling auto accept meeting invite and start my video automatically
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically   device=console_1      state=off
#    start my video automatically       device=console_1      state=off
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#
#End a meeting
#    [Arguments]    ${console}    ${device}
#    End the meeting  ${console}
#    End meeting      ${device}
#
#End up call
#    [Arguments]    ${console}    ${device}
#    Disconnect the call  ${console}
#    Disconnect call     ${device}
#
#Enable auto accept toggle for meeting invites and my video
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically    device=console_1      state=on
#    start my video automatically        device=console_1      state=on
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#
#Console re login
#    [Arguments]    ${console}
#    Console sign out method    ${console}
#    Verify signin is successful    console_list=${console}     state=Sign out
#    Console sign in method      ${console}     user=meeting_user
#    Get device pairing code    device_list=device_1    console_list=${console}      user_list=meeting_user
#    Verify signin is successful    console_list=${console}      state=Sign in
