*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup     Web Driver Initialization and Join meeting
Suite Teardown    Run Keywords  Suite Failure Capture     AND   close driver

*** Variables ***
${action_time} =  5

*** Test Cases ***
TC1: [Proximity join] DUT should ignore the incoming call during meeting
    [Tags]     305633
    [Setup]  Testcase Setup for Meeting User     count=1
    initiate proximity meeting     edit_meeting_name=lock_meeting
    Accept incoming call   device=device_1
    Verify Call State    device_list=device_1    state=Connected
    Make Video call using display name  from_device=device_2     to_device=device_1:meeting_user
    Verify user should not get second incoming_call     device=device_1
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2:[Proximity Join] DUT user able enable or disable the Proximity Join via Landing Page
    [Tags]      418886
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to app settings page  device=device_1
    navigate to teams admin settings     device=device_1
    verify protected apps are available under admin settings    device=device_1
    navigate to general option      device=device_1
    select proximity join btn      device=device_1       state=off
    select proximity join btn      device=device_1       state=on
    come back from admin settings page   device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1

TC3:[Proximity join]Verify proximity join option after reboot in DUT.
    [Tags]      305640
    [Setup]     Testcase Setup for Meeting User     count=1
    Navigate to app settings page  device=device_1
    navigate to teams admin settings     device=device_1
    verify protected apps are available under admin settings    device=device_1
    navigate to general option      device=device_1
    select proximity join btn      device=device_1       state=on
    come back from admin settings page   device_list=device_1
    Reboot Norden Or Console        device=device_1
    Verify home page screen    device=device_1
    Navigate to app settings page  device=device_1
    navigate to teams admin settings     device=device_1
    verify protected apps are available under admin settings    device=device_1
    navigate to general option      device=device_1
    verify the status select proximity join toggle btn          device=device_1     status=on
    come back from admin settings page   device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1

TC4:[Proximity join]Verify proximity join is done between the mobile/TDC and the Norden device when meeting duration > 30 mins
    [Tags]      305637       bvt_sm     sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Create proximity TDC Meetings     meeting_name=proximity_meeting         participants=device_1:meeting_user       time_duration=40 min
    initiate proximity meeting     edit_meeting_name=proximity_meeting
    Accept incoming call      device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect the call on TDC      device=tdc_1:user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1  AND    Delete proximity meeting

TC5:[Proximity join]Verify proximity join is done between the mobile/TDC and the Norden device when meeting duration < 30 mins
    [Tags]      305641    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Create proximity TDC Meetings     meeting_name=proximity_meeting         participants=device_1:meeting_user       time_duration=20 min
    initiate proximity meeting     edit_meeting_name=proximity_meeting
    Accept incoming call      device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect the call on TDC      device=tdc_1:user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1  AND    Delete proximity meeting

TC6:[Proximity join]Verify proximity join is done between the mobile/TDC and the Norden device when meeting duration == 30 mins
    [Tags]      305642    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Create proximity TDC Meetings     meeting_name=proximity_meeting         participants=device_1:meeting_user       time_duration=30 min
    initiate proximity meeting     edit_meeting_name=proximity_meeting
    Accept incoming call      device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect the call on TDC      device=tdc_1:user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1  AND    Delete proximity meeting

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
    create TDC meeting on desktop   device=tdc_1    meeting_name=${meeting_name}     participants=${participants}    time_duration=${time_duration}      use_current_time=True    roundup_end_time=off

Delete proximity meeting
    right click on created meeting from tdc       tdc_1:user     edit_meeting_name=proximity_meeting
    delete meeting from tdc     tdc_1
    
close driver
    close web driver    tdc_1:user