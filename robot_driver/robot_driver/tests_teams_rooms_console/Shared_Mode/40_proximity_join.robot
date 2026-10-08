*** Settings ***
Resource    ../../resources/keywords/common.robot

Suite Setup      Web Driver Initialization and Join meeting    
Suite Teardown    Run Keywords  Suite Failure Capture    AND   close driver

*** Variables ***
${wait_time} =  10s

*** Test Cases ***
TC1:[Proximity join] DUT should ignore the incoming call during meeting
    [Tags]     315232         P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User       count=2
    initiate proximity meeting    edit_meeting_name=console_lock_meeting
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1        state=connected
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    verify user should not get second incoming call     device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    Wait for Some Time    time=${wait_time}
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    Disconnect the call on TDC      device=tdc_1:user
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Proximity join]Verify proximity join is done between the mobile/TDC and the Touch console when meeting duration > 30 mins
    [Tags]     315240    sanity_tc_sm   bvt_tc_sm
    [Setup]  Testcase Setup for shared User       count=1
    Create proximity TDC Meetings     meeting_name=proximity_meeting     participants=device_1:meeting_user       time_duration=40 min
    initiate proximity meeting    edit_meeting_name=proximity_meeting
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1        state=connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    Disconnect the call on TDC      device=tdc_1:user
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1      AND    Delete proximity meeting

TC3:[Proximity join]Verify proximity join is done between the mobile/TDC and the Norden device when meeting duration < 30 mins
    [Tags]     315248    sanity_tc_sm   bvt_tc_sm
    [Setup]  Testcase Setup for shared User       count=1
    Create proximity TDC Meetings     meeting_name=proximity_meeting     participants=device_1:meeting_user       time_duration=20 min
    initiate proximity meeting    edit_meeting_name=proximity_meeting
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1        state=connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    Disconnect the call on TDC      device=tdc_1:user
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1      AND    Delete proximity meeting

TC4:[Proximity join]Verify proximity join is done between the mobile/TDC and the Norden device when meeting duration == 30 mins
    [Tags]     315250    sanity_tc_sm   P1
    [Setup]  Testcase Setup for shared User       count=1
    Create proximity TDC Meetings     meeting_name=proximity_meeting     participants=device_1:meeting_user       time_duration=30 min
    initiate proximity meeting    edit_meeting_name=proximity_meeting
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1        state=connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    Disconnect the call on TDC      device=tdc_1:user
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1      AND    Delete proximity meeting

*** Keywords ***
Web Driver Initialization and Join meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user

initiate proximity meeting
    [Arguments]    ${edit_meeting_name}
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=${edit_meeting_name}      click=left
    join proximit meeting on TDC    device=tdc_1:user    participant=device_1:meeting_user

Create proximity TDC Meetings
    [Arguments]          ${meeting_name}      ${participants}           ${time_duration}
    create TDC meeting on desktop   device=tdc_1    meeting_name=${meeting_name}     participants=${participants}    time_duration=${time_duration}      use_current_time=True   roundup_end_time=off

Delete proximity meeting
    right click on created meeting from tdc       tdc_1:user     edit_meeting_name=proximity_meeting
    delete meeting from tdc     tdc_1

close driver
    close web driver    tdc_1:user
