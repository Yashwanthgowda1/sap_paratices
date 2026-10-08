*** Settings ***
Documentation    Validating the functionality of console sigin/signout feature.
Resource   ../../resources/keywords/common.robot

*** Variables ***

*** Test Cases ***
TC1:[Group call] Verify attendee cannot add participants in the group call
    [Tags]    322520    bvt_tc_sm    sanity_tc_sm    exclude_ftp_sm_count_four    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User   count=4
    Initiates conference meeting using Meet now option   from_device=device_2     to_device=device_3
    Accept incoming call    device=device_3
    Verify meeting state   device_list=device_2,device_3    state=Connected
    Add participant to the conversation using display name  from_device=device_2    to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for meeting state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Make an attendee   from_device=device_2     to_device=console_1:meeting_user    device_type=console
    Verify you are an attendee now notification   device=console_1
    verify attendee participant not able to add user in meeting  from_device=console_1      to_device=device_4
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3,device_4

TC2:[Meet now] Participant count updates, when organizer adds the participant after meeting is started.
    [Tags]    315378    P2    exclude_ftp_sm_count_four    exclude_ftp_sm
    [Setup]   Testcase Setup for shared User   count=4
    Start meeting using meet now    from_device=console_1    to_device=device_2
    Accept incoming call      device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    ${before_adding_participants_in_meeting}=    get connected participants count    from_device=console_1      connected_device_list=console_1:meeting_user,device_2
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Add participant to the conversation using display name   from_device=console_1    to_device=device_4
    Accept incoming call      device=device_4
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3,device_4     state=Connected
     ${after_adding_participants_in_meeting}=     get connected participants count    from_device=console_1      connected_device_list=console_1:meeting_user,device_2,device_3,device_4
    run keyword if   ${before_adding_participants_in_meeting}+2 == ${after_adding_participants_in_meeting}   Log   Participant count in the meeting got increased
    ...  ELSE   fail   Participant count in the meeting is not increased.
    Verify video preview on screen  device=device_1,device_2,device_3,device_4
    End a meeting     console=console_1       device=device_2,device_3,device_4
    Verify for call state    console_list=console_1    device_list=device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3,device_4

TC4:[Meet Now] Start new meet now from Home screen
    [Tags]    322383    P2    exclude_ftp_sm_count_four    exclude_ftp_sm
    [Setup]   Testcase Shared Mode PSTN Setup Main    count=4
    Start meeting using meet now    from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1      device_list=device_3     state=Connected
    Add participant to the conversation using phonenumber  from_device=console_1    to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Add participant to the conversation using display name   from_device=console_1    to_device=device_4
    Accept incoming call      device=device_4
    Verify for call state     console_list=console_1    device_list=device_2,device_3,device_4    state=Connected
    End a meeting      console=console_1        device=device_3,device_4
    Verify for call state    console_list=console_1    device_list=device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3,device_4

TC5:[Spotlight] Spotlight overrides the Pin in the meeting
    [Tags]    315222    P2    exclude_ftp_sm_count_four    exclude_ftp_sm
    [Setup]   Testcase Setup for shared User     count=4
    Join a meeting   console=console_1     device=device_2,device_3,device_4    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3,device_4     state=Connected
    Verify and view list of participant    console=console_1
    make a pin and unpin   from_device=console_1      to_device=device_3    action=pin      device_type=console
    verify participant name which is pinned in main stage       device_list=device_1
    make a spotlight   from_device=device_2   to_device=device_4
    verify spotlight text on device   device=device_4   text=spotlight
    Verify participant name which is spotlighted in main stage    device_list=device_1
    Close participants screen   device=device_2
    verify spotlight icon    device=device_3
    End a meeting     console=console_1       device=device_2,device_3,device_4
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3,device_4      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3,device_4

*** Keywords ***
verify attendee participant not able to add user in meeting
    [Arguments]    ${from_device}   ${to_device}
    Verify not able to add user in meeting      ${from_device}   ${to_device}
    Verify notification not able to add new user        ${from_device}

End a meeting
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}
