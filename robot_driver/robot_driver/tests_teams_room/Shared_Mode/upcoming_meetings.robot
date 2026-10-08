*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup     Delete all meetings if exist and create meeting upcoming meeting

*** Variables ***
${wait_time} =  15
${1_minutes_wait_time} =  1 minutes
${5_minutes_wait_time} =  5 minutes

*** Test Cases ***
TC1:[MTRA] Verify that new meeting created is showing as upcoming meeting style.
    [Tags]     444852      P2
    [Setup]  Testcase Setup    count=1
    Verify meeting displayed on home page with available    device=device_1       meeting=upcoming_meeting
    Verify upcoming meeting details     device=device_1   meeting=upcoming_meeting
    [Teardown]  Capture on Failure

TC2:[MTRA] Verify meeting information should be visible.
    [Tags]     444854      P2    sanity_sm
    [Setup]  Testcase Setup    count=1
    Verify meeting displayed on home page with available    device=device_1       meeting=upcoming_meeting
    Verify meeting information should be visible     device=device_1   meeting=upcoming_meeting
    [Teardown]  Capture on Failure

TC3:[MTRA] Verify tapping on non-focus title meetings in calendar displays meeting detail dialog.
    [Tags]     444982      P3
    [Setup]  Testcase Setup    count=1
    Verify tapping on non-focus title meetings in calendar displays meeting detail dialog   device=device_1         meeting=upcoming_meeting
    [Teardown]  Capture on Failure

TC4:[MTRA] Verify the meeting is promoted as Active meeting 10 mins before the start time.
    [Tags]     444864
    [Setup]  Testcase Setup    count=1
    Verify meeting displayed on home page with available    device=device_1        meeting=upcoming_meeting
    Verify the non-focus meeting tile       device=device_1            meeting=upcoming_meeting
    Get join button before 10 mins meeting start time      device=device_1      verify_arrow=True
    [Teardown]  Capture on Failure

TC5:[MTRA] Verify double booked meetings display in the calendar.
    [Tags]     444980       P2
    [Setup]  Testcase Setup    count=1
    create Double booked meetings
    Wait for Some Time    time=${wait_time}
    Verify double booked meetings start end time should be same     device=device_1
    [Teardown]  Capture on Failure

TC6:[MTRA] Verify available meeting is displayed between meetings.
    [Tags]     444855      sanity_sm    P1
    [Setup]  Testcase Setup    count=1
    create meeting for checking available state
    Wait for Some Time      time=${1_minutes_wait_time}
    Verify available meeting is displayed between meetings      device=device_1
    [Teardown]  Capture on Failure

TC7:[Meetings] Verify Canceled meetings when user enable & disable "Show meeting names"
    [Tags]     303657    P2
    [Setup]  Testcase Setup    count=1
    create new test meeting
    Wait for Some Time    time=${wait_time}
    refresh calender tab    device=device_1
    verify meeting reflected on calendar tab    device=device_1     meeting=test_meeting
    delete the meeting      device=tdc_1:meeting_user    meeting_name=test_meeting
    navigate to Show meeting names      device=device_1
    hide or unhide meeting names     device=device_1   state=off
    Come back from admin settings page      device_list=device_1
    verify test meeting is not present on calendar tab      device=device_1         meeting=test_meeting
    navigate to Show meeting names      device=device_1
    hide or unhide meeting names     device=device_1    state=on
    Come back from admin settings page      device_list=device_1
   [Teardown]  Run Keywords     Capture on Failure  AND    Come back to home screen    device_list=device_1     AND     Modify show meeting names option     device=device_1   state=on

TC8:[MTRA] Verify private meeting join.
    [Documentation]  While creating the meeting need to click on private mode
    [Tags]      444971       P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1   meeting=Private meeting
    Verify meeting state   device_list=device_1    state=Connected
    Verify call control bar   device_list=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC9:[MTRA] Verify meeting join button visible.
    [Tags]     444868   P2
    [Setup]  Testcase Setup    count=1
    Delete all meetings if exist and create new meeting with 15min time gap
    Verify meeting displayed on home page with available    device=device_1        meeting=upcoming_meeting
    Verify the non-focus meeting tile       device=device_1            meeting=upcoming_meeting
    Wait for Some Time      time=${5_minutes_wait_time}
    Refresh calender tab    device=device_1
    Get join button before 10 mins meeting start time      device=device_1      verify_arrow=None
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
Delete all meetings if exist and create meeting upcoming meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min    roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=25
    Wait for Some Time    time=${wait_time}

Verify meeting information should be visible
    [Arguments]     ${device}     ${meeting}
    Verify upcoming meeting details     device=device_1   meeting=upcoming_meeting

create meeting for checking available state
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=15 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=30
    Wait for Some Time      time=${wait_time}
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting_double_book     time_duration=30 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=90

Delete all meetings if exist with timegap
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min    roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=20

verify the non-focus meeting tile
    [Arguments]     ${device}     ${meeting}
    Verify upcoming meeting details     ${device}      ${meeting}

Delete all meetings if exist with timegap and create cuttent meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min    roundup_end_time=off    start_meeting_time=on           use_current_time=True

Verify meeting synced on peripheral
    [Arguments]     ${device}
    get meeting details on user   ${device}

Verify tapping on non-focus title meetings in calendar displays meeting detail dialog
    [Arguments]     ${device}   ${meeting}
    Verify meeting displayed on home page with available   device=device_1         meeting=upcoming_meeting
    Verify the non-focus meeting tile   device=device_1        meeting=upcoming_meeting

create meeting non allday meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=non_allday_meeting       use_current_time=True       following_day_meeting=on

create new test meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=test_meeting     participants=device_1       time_duration=10 hr
    close web driver        tdc_1

delete the meeting
    [Arguments]         ${device}    ${meeting_name}
    initiate web driver     ${device}
    perform web signin method    ${device}
    right click on created meeting from tdc       ${device}       ${meeting_name}
    delete meeting from tdc     ${device}
    close web driver        ${device}

Verify available meeting is displayed between meetings
    [Arguments]     ${device}
    Verify available tile between the meetings       ${device}

navigate to Show meeting names
    [Arguments]    ${device}
    Navigate to app settings page    device=device_1
    navigate to meetings option in device settings page      device=device_1

create Double booked meetings
   initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=15 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=30
    Wait for Some Time      time=${wait_time}
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting_double_book     time_duration=30 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=90

Modify show meeting names option
    [Arguments]       ${device}   ${state}
    Navigate to app settings page  ${device}
    navigate to meetings option in device settings page   ${device}
    hide or unhide meeting names    ${device}    ${state}
    Come back from admin settings page      device_list=${device}

Delete all meetings if exist and create new meeting with 15min time gap
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min    roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=15