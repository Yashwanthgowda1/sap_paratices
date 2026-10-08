*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Resource    ../../resources/keywords/common.robot

Suite Setup   create PSTN meeting
Suite Teardown   delete the meeting      device=tdc_1:pstn_user    meeting_name=pstn_meeting

*** Variables ***
${action_time} =  5

*** Test Cases ***
TC1:[Reactions]Verify a reaction window should be shown when meeting is created by PSTN user
    [Tags]      327129       P2
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    refresh calender tabs
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=pstn_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify reactions buttons in call control     device=device_1
    tap on heart button     device=device_1
    verify reaction on screen    device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC2:[Whiteboard Sharing] Shared whiteboard should not be displayed for PSTN user
    [Tags]      305658        P2
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=pstn_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify whiteboard sharing option under more option   device=device_1
    Wait for Some Time    time=${action_time}
    Shared whiteboard should not be displayed for PSTN user     device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC3:[Whiteboard Sharing] Verify whiteboard when meeting is scheduled with different tenant account
    [Tags]      305666       P2
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    refresh calender tabs
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=pstn_meeting
    verify waiting in the lobby message     device=device_2
    make admit and deny in the meeting      from_device=device_1   to_device=device_2     lobby=admit_lobby
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify whiteboard not present in meeting tab     device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
create PSTN meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:pstn_user
    create TDC meeting on desktop    device=tdc_1     meeting_name=pstn_meeting     participants=device_2       time_duration=10 hr        use_current_time=True
    close web driver    device=tdc_1

delete the meeting
    [Arguments]         ${device}    ${meeting_name}
    initiate web driver     ${device}
    perform web signin method     ${device}
    right click on created meeting from tdc       ${device}       ${meeting_name}
    delete meeting from tdc     ${device}
    close web driver    ${device}

refresh calender tabs
    refresh calender tab    device=device_1
    refresh calender tab    device=device_2

Shared whiteboard should not be displayed for PSTN user
    [Arguments]         ${device}
    verify whiteboard tools not displayed on screen     ${device}