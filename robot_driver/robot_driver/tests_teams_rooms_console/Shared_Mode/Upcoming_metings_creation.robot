*** Settings ***
Documentation       Should not create any meeting device_1:user
Resource    ../../resources/keywords/common.robot

Suite Setup  Delete all meetings if exist

*** Variables ***
${wait_time} =  15
${1_minutes_wait_time} =  1 minutes
${5_minutes_wait_time} =  5 minutes
*** Test Cases ***
TC1:[MTRA+TC] Verify that new meeting created is visible.
    [Tags]      444611      P1       sanity_tc_sm
    [Setup]  Testcase Setup for User    count=1
    Verify meeting displayed on home page with available    device=console_1       meeting=upcoming_meeting
    [Teardown]  Capture Failure

TC2:[MTRA+TC] Verify that new meeting created is showing as upcoming meeting style and chevron (>) is visble.
    [Tags]     444614      P2
    [Setup]  Testcase Setup for User    count=1
    Verify meeting displayed on home page with available    device=console_1       meeting=upcoming_meeting
    Verify upcoming meeting details     device=console_1   meeting=upcoming_meeting
    [Teardown]  Capture Failure

TC3:[MTRA+TC] Verify available meeting have no actionable buttons.
    [Tags]     444647      P2
    [Setup]  Testcase Setup for User    count=1
    Verify should not display join button       console=console_1       meeting=upcoming_meeting
    [Teardown]  Capture Failure

TC4:[MTRA+TC] Verify tapping on non-focus title meetings in calendar displays meeting detail dialog.
    [Tags]     444776      P3
    [Setup]  Testcase Setup for User    count=1
    Verify meeting displayed on home page with available    device=console_1        meeting=upcoming_meeting
    Verify the non-focus meeting tile   device=console_1       meeting=upcoming_meeting
    [Teardown]  Capture Failure

TC5:[MTRA+TC] Verify meetings time format & meeting details screen
    [Tags]     444636      P2
    [Setup]  Testcase Setup for User    count=1
    Verify meeting displayed on home page with available    device=console_1        meeting=upcoming_meeting
    Verify upcoming meeting details     device=console_1   meeting=upcoming_meeting
    [Teardown]  Capture Failure

TC6:[MTRA+TC] Verify that new meeting created is showing as upcoming meeting style.
    [Tags]     444612       bvt_tc_sm       sanity_tc_sm
    [Setup]  Testcase Setup for User    count=1
    Verify meeting displayed on home page with available    device=console_1       meeting=upcoming_meeting
    Verify upcoming meeting details     device=console_1   meeting=upcoming_meeting
    [Teardown]  Capture Failure

TC7:[MTRA+TC] Verify active meeting details are correct.
    [Tags]     444655       sanity_tc_sm        P1
    [Setup]  Testcase Setup for User    count=1
    Delete all meetings if exist with timegap
    Wait for Some Time      time=${wait_time}
    Verify meeting displayed on home page with available    device=console_1        meeting=upcoming_meeting
    Get join button before 10 mins meeting start time      device=console_1     verify_arrow=True
    [Teardown]  Capture Failure

TC8:[MTRA+TC] Verify the meeting is promoted as Active meeting 10 mins before the start time.
    [Tags]     444654    bvt_tc_sm       sanity_tc_sm
    [Setup]  Testcase Setup for User    count=1
    Delete all meetings if exist with timegap
    Wait for Some Time      time=${wait_time}
    Verify meeting displayed on home page with available    device=console_1        meeting=upcoming_meeting
    Verify the non-focus meeting tile       device=console_1       meeting=upcoming_meeting
    Get join button before 10 mins meeting start time      device=console_1     verify_arrow=True
    [Teardown]  Capture Failure

TC9:[MTRA+TC] Verify available meeting is displayed between meetings.
    [Tags]    444641    sanity_tc_sm    P1
    [Setup]  Testcase Setup for User    count=1
    create meeting for checking available state
    Wait for Some Time      time=${1_minutes_wait_time}
    Verify available tile between the meetings       device=device_1
    [Teardown]  Capture Failure

TC10:[MTRA+TC] Verify double booked meetings display in the calendar.
    [Tags]    444771    P2
    [Setup]  Testcase Setup for User    count=1
    create Double booked meetings
    Wait for Some Time      time=${1_minutes_wait_time}
    Verify double booked meetings start end time should be same     device=console_1
    [Teardown]  Capture Failure

TC11:[MTRA+TC] Verify meeting join button visible for Upcoming meetings
    [Tags]     444657       P2
    [Setup]  Testcase Setup for User    count=1
    Delete all meetings if exist and create new meeting with 15min time gap
    Verify meeting displayed on home page with available    device=console_1        meeting=upcoming_meeting
    Verify the non-focus meeting tile       device=console_1       meeting=upcoming_meeting
    Wait for Some Time      time=${5_minutes_wait_time}
    Refresh calender tab    device=console_1
    Get join button before 10 mins meeting start time      device=console_1      verify_arrow=None
    [Teardown]  Capture Failure

TC23:[Meetings] Verify Canceled meetings when user enable & disable "Show meeting names"
    [Tags]    323039   P2
    [Setup]  Testcase Setup for shared User   count=1
    create new test meeting
    Wait for Some Time    time=${wait_time}
    Refresh Console Calendar Tab    device=console_1
    Wait for Some Time    time=${wait_time}
    verify meeting reflected on calendar tab    device=console_1    meeting=test_meeting
    delete the meeting      device=tdc_1:meeting_user    meeting_name=test_meeting
    Enable and Disable show meeting names toggle btn    console=console_1
    come back from admin settings page      device_list=console_1
    verify test meeting is not present on calendar tab      device=console_1        meeting=test_meeting
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC4:[MTRA] Verify more than one active meeting.
    [Tags]     444751      P2    sanity_sm
    [Setup]  Testcase Setup for User    count=1
    Verify Multiple Active Meetings with Time Gap and Join Button Availability
    Run Keywords    Log    Waiting for 15 minutes until both meetings are reflected as active..    AND    Sleep     15 minutes
    refresh calender tab    device=console_1
    verify meeting reflected on calendar tab    device=console_1     meeting=upcoming_meeting
    verify meeting reflected on calendar tab     device=console_1      meeting=upcoming_meeting_double_book
    [Teardown]     Run Keywords    Capture Failure    AND   close web driver    tdc_1


*** Keywords ***
Delete all meetings if exist
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min    roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=25

verify the non-focus meeting tile
    [Arguments]     ${device}     ${meeting}
    Verify upcoming meeting details     ${device}      ${meeting}

Delete all meetings if exist with timegap
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min    roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=20

create meeting for checking available state
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=15 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=30
    Wait for Some Time      time=${wait_time}
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting_double_book     time_duration=30 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=90

create Double booked meetings
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=15 min        use_current_time=True
    Wait for Some Time      time=${1_minutes_wait_time}
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting_double_book     time_duration=15 min       supporting_device=console_1     concurrent_meeting=on

Delete all meetings if exist and create new meeting with 15min time gap
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min    roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=15

Refresh Console Calendar Tab
   [Arguments]    ${device}
    : FOR    ${index}    IN RANGE    3
        Scroll Up Meeting Tab    device=${device}
    END

create new test meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=test_meeting           time_duration=10 hr       use_current_time=True

delete the meeting
    [Arguments]         ${device}    ${meeting_name}
    right click on created meeting from tdc       ${device}       ${meeting_name}
    delete meeting from tdc     ${device}
    close web driver        ${device}

Navigate to app settings screen
    [Arguments]    ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable and Disable show meeting names toggle btn
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Disable show meeting names toggle btn    ${console}
    Enable show meeting names toggle button    ${console}
    come back from admin settings page      device_list=${console}

Verify Multiple Active Meetings with Time Gap and Join Button Availability
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting     time_duration=30 min     use_current_time=True
    Wait for Some Time      time=${wait_time}
    create TDC meeting on desktop    device=tdc_1     meeting_name=upcoming_meeting_double_book     time_duration=30 min      roundup_end_time=off    start_meeting_time=on       start_meeting_time_after=15
