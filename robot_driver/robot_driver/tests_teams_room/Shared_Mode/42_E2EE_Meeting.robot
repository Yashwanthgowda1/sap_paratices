*** Settings ***
Documentation   Validating the functionality of E2EE meeting Feature.
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup         set up e2ee meeting       participant=device_2,device_1:pstn_user
Suite Teardown    Run Keywords   Suite Failure Capture    AND       delete the meeting  device=tdc_1:meeting_user    meeting_name=e2ee

*** Test Cases ***
TC1:[E2EE] [MTRA] [Pro-License] Verify the options under share button when TDC created a meeting by enabled E2EE option.
     [Tags]  444378    sanity_sm  P1
     [Setup]  Testcase Setup for Meeting User     count=2
     refresh calender tab    device=device_1,device_2
     Join meeting   device=device_1,device_2     meeting=e2ee
     Verify meeting state   device_list=device_1,device_2    state=Connected
     Verify ui e2ee meeting     device=device_1
     Verify security code e2ee    device=device_1,device_2
     End meeting      device=device_1,device_2
     Verify meeting state    device_list=device_1,device_2    state=Disconnected
     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC2:[E2EE] Verify Non-E2EE meeting UI
     [Tags]  444371  sanity_sm  P1
     [Setup]   Testcase Setup for Meeting User     count=2
     Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
     Accept incoming call    device=device_2
     Close participants screen   device=device_1
     Verify meeting state   device_list=device_1,device_2    state=Connected
     Verify ui non e2ee meeting    device=device_1
     End meeting      device=device_1,device_2
     Verify meeting state    device_list=device_1,device_2    state=Disconnected
     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC3:[E2EE] [MTRA] [Pro-License] Verify the shield icon with lock in ubar when TDC created a meeting by enabling E2EE option in different tenant meeting.
    [Tags]      444382   P2
    [Setup]  Testcase Meeting PSTN Setup as Main device   count=2
    Join meeting   device=device_1,device_2    meeting=e2ee
    verify waiting in the lobby message     device=device_1
    make admit and deny in the meeting      from_device=device_2   to_device=device_1:pstn_user     lobby=admit_lobby
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify security code e2ee    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
set up e2ee meeting
    [Arguments]     ${participant}
    initiate web driver     tdc_1
    perform web signin method       tdc_1:meeting_user
    create TDC meeting on desktop      device=tdc_1      meeting_name=e2ee      participants=${participant}     time_duration=1 hr    use_current_time=True      e2ee=on


delete the meeting
    [Arguments]         ${device}    ${meeting_name}
    initiate web driver     ${device}
    perform web signin method       ${device}
    right click on created meeting from tdc       ${device}       ${meeting_name}
    delete meeting from tdc    ${device}
    close web driver    ${device}