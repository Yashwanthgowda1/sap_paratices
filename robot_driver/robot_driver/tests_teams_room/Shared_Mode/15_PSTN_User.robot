*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Initiate spotlight] User to check the initiate spotlight for the PSTN user.
    [Tags]     381980    P2    
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    Join Meeting    device=device_1,device_2     meeting=lock_meeting
    make admit and deny in the meeting      from_device=device_2   to_device=device_1     lobby=admit_lobby
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2   state=Connected
    make a spotlight   from_device=device_1      to_device=device_1:meeting_user
    verify spotlight text on device   device=device_1   text=spotlight
    Close participants screen   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2  state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

TC2:[Join by Code]Verify different tenant in "Join with an ID"
    [Tags]      345105    P2    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    join with an meeting id   device=device_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    verify waiting in the lobby message     device=device_1
    Join meeting   device=device_2   meeting=lock_meeting
    make admit and deny in the meeting      from_device=device_2   to_device=device_1:pstn_user     lobby=admit_lobby
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC3:[Meetings]Verify that the meeting name is not displayed, when created by PSTN user while "show meeting names" option is disable
    [Tags]      303661      P2
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=1
    ${meeting_name_before_disabling_show_meeting_names}=  Get meeting name    device=device_1
    Modify show meeting names option     device=device_1   state=off
    ${meeting_name_after_disabling_show_meeting_names}=  Get meeting name    device=device_1
    Verify meeting name on homescreen after disabling   device_1    ${meeting_name_before_disabling_show_meeting_names}    ${meeting_name_after_disabling_show_meeting_names}
    join rooms meeting after hiding the title name   device=device_1    organizer_name=device_2:user
    verify waiting in the lobby message     device=device_1
    Verify meeting state   device_list=device_1   state=Connected
    End meeting   device=device_1
    Verify meeting state   device_list=device_1   state=Disconnected
    Modify show meeting names option     device=device_1   state=on
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC4: [Large Gallery] Verify Large Gallery in video meeting with other tenant user
    [Tags]       316712    P2
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    Join Meeting    device=device_1,device_2     meeting=lock_meeting
    make admit and deny in the meeting      from_device=device_2   to_device=device_1     lobby=admit_lobby
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2   state=Connected
    disable video call  device=device_1
    verify layout options when other tenant user         device=device_1
    change meeting mode     device=device_1     mode=together
    verify changed mode    device=device_1      changed_mode=together_mode
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2  state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

TC5:[Large Gallery] Verify Together mode in audio meeting with another tenant user
    [Tags]      316707       P1     sanity_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    Join Meeting    device=device_1,device_2     meeting=lock_meeting
    make admit and deny in the meeting      from_device=device_2   to_device=device_1     lobby=admit_lobby
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2   state=Connected
    disable video call  device=device_1,device_2
    verify together mode is not present when turning off video call     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2  state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

TC6:[Meetings] Verify camera is disable when DUT user join the meeting by dialing into the conference bridge number
    [Tags]      316931      P1       sanity_sm
    Testcase Meeting PSTN Setup as Main device   count=3
    make a call with conference id     from_device=device_2     to_device=device_3
    Verify meeting state   device_list=device_2,device_3    state=Connected
    Add participant to conversation using phonenumber    from_device=device_2      to_device=device_1:pstn_user
    Accept incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Close roaster button on participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Verify camera is disable when user join the meeting by dialing into the conference bridge number       device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3

# Ensure that 'PSTN Disabled' is added last
TC1:[Call-App] Verify user can enter mail id/user name and search For External Participants.
    [Tags]        444777      P0     bvt_sm      sanity_sm
    [Setup]  Testcase Setup for PSTN Disabled    count=2
    verify external text when entered cross tenant mail id    from_device=device_1    to_device=device_2:pstn_disabled
    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC2:[Home screen] PSTN disabled user should not have dial pad icon
    [Tags]        237867      P2
    [Setup]  Testcase Setup for PSTN Disabled    count=2
    Verify user should not have dialpad     device=device_2
    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC3:[Dialpad] Verify dialpad intent for PSTN/Non PSTN user
    [Tags]       409900    P2
    [Setup]  Testcase Setup for PSTN Disabled    count=2
    verify and click on dail pad   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=DIALPADICON_STATE       state=present
    Reset Logcat Capture    device=device_2
    verify and click on dail pad   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_2      feature=pstn_disabled_dialpad_state       state=present
    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Modify show meeting names option
    [Arguments]       ${device}   ${state}
    Navigate to app settings page  ${device}
    navigate to meetings option in device settings page   ${device}
    hide or unhide meeting names    ${device}    ${state}
    Come back from admin settings page      device_list=${device}

verify layout options when other tenant user
    [Arguments]     ${device}
    verify layout options after disable video call     ${device}

Verify user can enter mail id/user name and search For External Participants
    [Arguments]     ${from_device}     ${to_device}
    Make outgoing call with username     ${from_device}     ${to_device}
