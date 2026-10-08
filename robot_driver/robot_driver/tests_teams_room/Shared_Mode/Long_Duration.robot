*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${5_minutes_wait_time} =  4 min 50 sec
${wait_time} =  3
*** Test Cases ***
TC1:[Meet] The DUT should leave the meeting, when no user is added to meeting.
    [Tags]      344891   P2
    [Setup]   Testcase Setup for Meeting User     count=1
    click on meet now button        device=device_1
    Wait for Some Time    time=${5_minutes_wait_time}
    verify About to Leave and snooze options     device=device_1
    Verify the DUT should leave the meeting     device=device_1
    [Teardown]  Run Keywords    Capture on Failure

TC2:[Meet] The DUT should leave the meeting, when user selects "Leave meeting" option in about to leave meeting pop-up.
    [Tags]      344893   P2
    [Setup]   Testcase Setup for Meeting User     count=2
    click on meet now button        device=device_1
    Wait for Some Time    time=${5_minutes_wait_time}
    verify and click on meet mode     device=device_1    mode=leave_now
    Verify the DUT should leave the meeting     device=device_1
    [Teardown]  Run Keywords    Capture on Failure

TC3:[Meet] Verify the DUT should stay in meeting, when user selects "snooze" option in about to leave meeting pop-up.
    [Tags]      344894   P2
    [Setup]   Testcase Setup for Meeting User     count=2
    click on meet now button        device=device_1
    Wait for Some Time    time=${5_minutes_wait_time}
    verify and click on meet mode     device=device_1    mode=snooze
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC4:[MTRA] Verify more than one active meeting.
    [Tags]     444870       P2    sanity_sm
    [Setup]  Testcase Setup    count=1
    create meeting for checking available state
    Run Keywords    Log    Waiting for 15 minutes until both meetings are reflected as active..    AND    Sleep     15 minutes
    refresh calender tab    device=device_1
    verify meeting reflected on calendar tab    device=device_1     meeting=upcoming_meeting
    verify meeting reflected on calendar tab     device=device_1      meeting=upcoming_meeting_double_book
    [Teardown]  Capture on Failure

TC5:[MTRA] Verify active meeting details are correct and join button.
    [Tags]     444866      sanity_sm        P1
    [Setup]  Testcase Setup    count=1
    create meeting upcoming meeting
    Run Keywords    Log    Waiting for 5 minutes until meeting reflected as active..    AND    Sleep     5 minutes
    refresh calender tab    device=device_1
    verify meeting reflected on calendar tab    device=device_1     meeting=upcoming_meeting
    [Teardown]  Capture on Failure

TC6:[Whiteboard sharing] Launch whiteboard from home screen and leave idle for > 5min
    [Tags]      349055     P2
    [Setup]   Testcase Setup for Meeting User     count=1
    verify Start meeting and verify Whiteboard launch  device=device_1
    Wait for Some Time    time=${5_minutes_wait_time}
    verify About to Leave and snooze options     device=device_1
    Wait for Some Time    time=${wait_time}
    verify whiteboard tools not displayed on screen      device=device_1
    Verify the DUT should leave the meeting     device=device_1
    [Teardown]  Run Keywords    Capture on Failure

*** Keywords ***
Verify the DUT should leave the meeting
    [Arguments]     ${device}
    Verify home page screen    ${device}

create meeting for checking available state
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min     use_current_time=True
    Wait for Some Time      time=${wait_time}
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting_double_book     time_duration=30 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=15

Verify active meeting in calander tab
    [Arguments]     ${device}       ${meeting}
    verify start and end time display on calendar tab     device=device_1      meeting=upcoming_meeting

create meeting upcoming meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=10
