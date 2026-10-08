*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  3
${action_time} =  5

*** Test Cases ***
TC1:[Sensitivity Label ]Verify options under more in the meeting, when TDC user selects the label
    [Tags]       444217      bvt_sm    sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=off        sensitivity_label=on           primary_label_type=sensitivity       primary_label_mode=Dpec_Test      secondary_label_type=who_can_present       secondary_label_mode=Everyone
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2      meeting=sensitivity_label_meeting
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify more options in call control bar     device=device_1,device_2
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC2:[Sensitivity Label]Verify lobby when bypass lobby set to Only me & co-organizers label is assigned.
    [Tags]      444232           bvt_sm      sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=off    sensitivity_label=off    primary_label_type=sensitivity       primary_label_mode=Dpec_Test      secondary_label_type=bypass_the_lobby        secondary_label_mode=org_and_guests
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2    meeting=sensitivity_label_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC3:[Sensitivity Label]Verify the End to end encrypted shield when a sensitivity is applied to a meeting created by TDC user
    [Tags]      444212    sanity_sm  P1    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=on     sensitivity_label=off    primary_label_type=off       primary_label_mode=off      secondary_label_type=off       secondary_label_mode=off
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2     meeting=sensitivity_label_meeting
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify security code encryption enabled e2ee    device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC4:[Sensitivity Label]Verify the label name should not be displayed when a sensitivity is applied to a meeting created by Cross Tenant TDC user
    [Tags]      444215    sanity_sm  P1    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=off       sensitivity_label=off       primary_label_type=off       primary_label_mode=off      secondary_label_type=off       secondary_label_mode=off
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2     meeting=e2ee
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify ui non e2ee meeting    device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC5:[Sensitivity Label]Verify "This meeting has a sensitivty label applied" by TDC user and DUT user is an external user(Ex:Different tenant user)
    [Tags]      444216    sanity_sm  P1    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=on       sensitivity_label=off    primary_label_type=off       primary_label_mode=off      secondary_label_type=off       secondary_label_mode=off
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2     meeting=sensitivity_label_meeting
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    This meeting has a sensitivty label applied    device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC6:[Sensitivity Label]Verify options under more options in a meeting when a sensitivity label is not assigned.
    [Tags]       444224          sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=off        sensitivity_label=off           primary_label_type=off       primary_label_mode=off      secondary_label_type=off      secondary_label_mode=off
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2      meeting=sensitivity_label_meeting
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify more options in call control bar     device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC7:[Sensitivity Label]Verify share button in a meeting when sharing allowed to Everyone label is assigned.
    [Tags]    444227     sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=off        sensitivity_label=on           primary_label_type=sensitivity       primary_label_mode=Dpec_Test      secondary_label_type=who_can_present       secondary_label_mode=Everyone
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2    meeting=sensitivity_label_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify share content hdmi is present        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC8:[Sensitivity Label]Verify lobby when bypass lobby set to Everyone label is assigned.
    [Tags]      444235   sanity_sm    P1    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=on        sensitivity_label=on           primary_label_type=sensitivity       primary_label_mode=Dpec_Test      secondary_label_type=who_can_present       secondary_label_mode=Everyone
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2    meeting=sensitivity_label_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify security code e2ee    device=device_1,device_2
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC9:[Sensitivity Label]Verify chat panel in a meeting when chat enabled label is assigned.
    [Tags]     444230   sanity_sm  P1    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2       e2ee=off        sensitivity_label=on           primary_label_type=sensitivity       primary_label_mode=Dpec_Test      secondary_label_type=Meeting_chat       secondary_label_mode=on
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2    meeting=sensitivity_label_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Enable and disable the chat toggle in meeting       device=device_1      state=on
    verify the chat options in meeting       device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

TC10:[Sensitivity Label] Verify options under more options & Chat panel when TDC user disables E2EE in a ongoing meeting when a sensitivity label is assigned.
    [Tags]     444252      sanity_sm         P1    exclude_ftp_sm
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    TDC User Selects the Sensitivity Label   device=tdc_1:pstn_user      meeting_name=sensitivity_label_meeting         participants=device_2              sensitivity_label=on           primary_label_type=sensitivity       primary_label_mode=Dpec_Test      secondary_label_type=Meeting_chat       secondary_label_mode=on     e2ee=on
    refresh calender tab    device=device_1,device_2
    Wait for Some Time    time=${action_time}
    Join meeting   device=device_1,device_2    meeting=sensitivity_label_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Enable and disable the chat toggle in meeting       device=device_1      state=on
    verify the chat options in meeting       device=device_1
    Verify security code e2ee    device=device_1,device_2
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    delete the meeting       device=tdc_1:pstn_user    meeting_name=sensitivity_label_meeting   AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
TDC User Selects the Sensitivity Label
    [Arguments]         ${device}     ${meeting_name}    ${participants}        ${sensitivity_label}   ${primary_label_type}     ${primary_label_mode}    ${secondary_label_type}     ${secondary_label_mode}        ${e2ee}
    Initiate Web Driver    device=${device}
    perform web signin method   ${device}
    Create TDC Meeting On Desktop
    ...    device=${device}
    ...    meeting_name=${meeting_name}
    ...    participants=${participants}
    ...    time_duration=1 hr
    ...    use_current_time=True
    ...    sensitivity_label=${sensitivity_label}
    ...    primary_label_type=${primary_label_type}
    ...    primary_label_mode=${primary_label_mode}
    ...    secondary_label_type=${secondary_label_type}
    ...    secondary_label_mode=${secondary_label_mode}
    ...    e2ee=${e2ee}


delete the meeting
    [Arguments]         ${device}    ${meeting_name}
    initiate web driver     ${device}
    perform web signin method     ${device}
    right click on created meeting from tdc       ${device}       ${meeting_name}
    delete meeting from tdc     ${device}
    close web driver    ${device}


This meeting has a sensitivty label applied
    [Arguments]         ${device}
    verify security code encryption enabled e2ee     ${device}
