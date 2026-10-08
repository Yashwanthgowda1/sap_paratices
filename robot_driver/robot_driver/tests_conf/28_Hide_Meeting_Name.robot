*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Setup       Hide meeting setup
Suite Teardown    Run Keywords    Suite Failure Capture   AND    Hide meeting teardown


*** Variables ***
${wait_time} =      10s
${5m_wait_time} =    5 minutes

*** Test Cases ***
TC1: [Meetings]Verify that while connecting and after joined to meeting/all day meeting, meeting name must be displayed
    [Tags]  322057      bvt_tpc      sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=2
    verify and join meeting when show meeting title toggle is off     device=device_1     organizer_name=device_2       meeting=hide_meeting
    Join Meeting    device=device_2     meeting=hide_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2    count=2

TC2: [Meetings]Verify the meeting name is shown in calendar or notification when the "show meeting names" option enabled
    [Tags]   322059      bvt_tpc   sanity_tpc    P0
    [Setup]    Testcase Setup for Meeting User    count=2
    Enable show meeting names     device=device_1
    verify meeting has meeting name    device=device_1     meeting=hide_meeting
    Join Meeting    device=device_1,device_2     meeting=hide_meeting        join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2   state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2    count=2    AND     disable show meeting names  device=device_1

TC3: [Meetings]Verify that no meeting name is shown for All day meeting when "Show meeting names" option is disabled
    [Tags]  322062        sanity_tpc     P1
    [Setup]   Testcase Setup for Meeting User    count=2
    create meeting  device=device_2       participants=device_1:meeting_user   meeting=hide_meeting_all_day     all_day_meeting=ON
    verify and join meeting when show meeting title toggle is off     device=device_1     organizer_name=device_2       meeting=hide_meeting_all_day       all_day_meeting=on
    Verify meeting state   device_list=device_1   state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_1,device_2    count=2

TC4: [Meetings]Verify that no meeting name is shown in calendar or notification
    [Tags]    322056      P2
    [Setup]   Testcase Setup for Meeting User    count=2
    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC5: [Meetings]Verify meeting name in calendar or notification for newly scheduled meeting
    [Tags]    322060       P2
    [Setup]  Testcase Setup for Meeting User    count=2
    verify meeting title shows meeting organizer name   device=device_1      organizer=device_2
    Enable show meeting names     device=device_1
    Create Meeting  device=device_2     meeting=hide_meeting1     participants=device_1:meeting_user
    Refresh cnf device for meeting visibility      device=device_1
    verify meeting has meeting name     device=device_1     meeting=hide_meeting1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2      AND     clear all day meeting and meeting history from calendar   devices=device_2      AND     disable show meeting names  device=device_1

TC6: [Meetings] Verify when user enable & disable "Show meeting names" toggle multiple times, changes must reflect accordingly
    [Tags]   322061      P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Create Meeting  device=device_2     meeting=hide_meeting     participants=device_1:meeting_user
    Verify meetings option under App settings page     device=device_1
    Enable show meeting names option    device=device_1
    Disable show meeting names option  device=device_1
    Enable show meeting names option    device=device_1
    Disable show meeting names option  device=device_1
    Enable show meeting names option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1       AND   disable show meeting names  device=device_1

TC7: [Meetings] Verify meeting name on meeting detail screen when user enable & disable "Show meeting names"
    [Tags]    322064       P2
    [Setup]   Testcase Setup for Meeting User   count=2
    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
    Enable show meeting names     device=device_1
    Refresh cnf device for meeting visibility      device=device_1
    verify meeting has meeting name     device=device_1     meeting=hide_meeting
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2      AND     disable show meeting names  device=device_1

TC8:[Private meetings] User to disable/Enable the "Show meeting names" option on the device
    [Tags]      536698        bvt_tpc   sanity_tpc    
    [Setup]   Testcase Setup for Meeting User    count=2
    disable show meeting names  device=device_1
    Create Meeting   device=device_2     meeting=hide_meeting1     participants=device_1:meeting_user
    verify and join meeting when show meeting title toggle is off     device=device_1     organizer_name=device_2       meeting=hide_meeting1
    Verify meeting state   device_list=device_1    state=Connected
    verify meeting has meeting name     device=device_1     meeting=hide_meeting1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2      AND     clear all day meeting and meeting history from calendar   devices=device_2        AND     Hide meeting teardown

*** Keywords ***
Meeting Setup
    [Arguments]     ${count}
    Remove meeting from calender for meeting policy test      ${count}

Hide meeting setup
    clear meetings from calendar tab    devices=device_2
    Create Meeting  device=device_2     meeting=hide_meeting     participants=device_1:meeting_user
    Come back to home screen    device_list=device_1
    Verify meetings option under App settings page    device=device_1
    Disable show meeting names option   device=device_1
    Come back to home screen    device_list=device_1


Test Case Teardown without deleting meeting
    [Arguments]     ${devices}    ${count}
    check for device count      count=${count}
    Come back to home screen    ${devices}

Test Case Teardown All Day Event
    [Arguments]     ${devices}      ${organizer}       ${meeting}
    Capture on Failure
    Come back to home screen    ${devices}
    navigate to calendar tab    ${organizer}
    Delete all day meetings      ${organizer}    ${meeting}
    clear all day meeting and meeting history from calendar   ${devices}
    Come back to home screen    ${devices}


Hide meeting teardown
    Enable show meeting names     device=device_1

