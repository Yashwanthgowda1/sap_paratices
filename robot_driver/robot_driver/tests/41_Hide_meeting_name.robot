*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation    Suite Setup Requirements : This suite requires minimum of 2 devices in config
...              Purpose: Device_2 should multiple meetings and add Device_1 as participants

Suite Setup       Hide meeting names suite setup
Suite Teardown    Run Keyword and ignore error    Hide meeting names suite teardown

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1: [Meetings]Verify that while connecting and after joined to meeting/all day meeting, meeting name must be displayed
    [Tags]  311484      bvt_tp   sanity_tp     P0        bvt_pr
    [Setup]    Testcase Setup   count=2
    Join Meeting    device=device_1,device_2     meeting=hide_meeting_names
    Verify meeting state   device_list=device_1,device_2   state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    navigate to calendar tab        device=device_1
    navigate to calendar tab        device=device_2
    Verify meeting under all day event  device=device_1     meetings=hide_meeting
    Verify meeting under all day event  device=device_2     meetings=hide_meeting
    join meeting from all day meeting tab   device=device_1,device_2     meeting=hide_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Test Case Teardown   devices=device_1,device_2

TC2: [Meetings]Verify that no meeting name is shown for All day meeting when "Show meeting names" option is disabled
    [Tags]  311567      bvt_tp   sanity_tp     P0
    [Setup]    Testcase Setup   count=2
    disable show meeting names  device=device_1
    verify and join meeting when show meeting title toggle is off     device=device_1     organizer_name=device_2       meeting=hide_meeting_names       all_day_meeting= on
    Verify meeting state   device_list=device_1   state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Test Case Teardown   devices=device_1,device_2

TC3: [Private meetings] User to disable the "Show meeting names" option on the device
    [Tags]    311108        P0   bvt_tp  sanity_tp
    [Setup]    Testcase Setup   count=2
    navigate to calendar tab    device=device_1
    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC4: [Meetings]Verify meeting name in calendar or notification for newly scheduled meeting
    [Tags]    311490        P2
    [Setup]    Testcase Setup   count=2
    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
    Enable show meeting names     device=device_1
    navigate to calendar tab    device=device_1
    refresh main tab         device=device_1
    verify meeting has meeting name     device=device_1     meeting=hide_meeting_names
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2          AND     disable show meeting names  device=device_1

TC5: [Meetings] Verify meeting name on meeting detail screen when user enable & disable "Show meeting names"
    [Tags]    311571        P2
    [Setup]    Testcase Setup   count=2
    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
    Enable show meeting names     device=device_1
    navigate to calendar tab    device=device_1
    refresh main tab    device=device_1
    verify meeting has meeting name     device=device_1     meeting=hide_meeting_names
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2     AND     disable show meeting names  device=device_1

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Capture on Failure
    Teardown Meeting Test Case     ${devices}
    Come back to home screen    ${devices}


Hide meeting names suite setup
    Enable show meeting names     device=device_1
    clear all day meeting and meeting history from calendar   devices=device_1,device_2
    create meeting   device=device_2    meeting=hide_meeting_names    participants=device_1
    create meeting  device=device_2       participants=device_1   meeting=hide_meeting    all_day_meeting=ON

Hide meeting names suite teardown
    Suite Failure Capture
    clear all day meeting and meeting history from calendar   devices=device_1,device_2

