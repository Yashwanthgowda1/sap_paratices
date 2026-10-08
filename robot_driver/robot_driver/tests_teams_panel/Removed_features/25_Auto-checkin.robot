#Revoming support for auto check-in feature because of: Bug 4162090: [Panels][Automation] Auto check in feature not supported via automation
#*** Settings ***
#Resource    ../resources/keywords/common.robot
#
#Suite Setup    Run Keywords    Testcase Setup for AC User for panel and norden    count=3   AND   enable checkin toggle and select release time in panel     device=device_1   release_time=5  AND   enable checkin toggle and select release time in panel     device=device_3         release_time=5
#Suite Teardown  Suite Failure Capture
#
#*** Variables ***
#${1_minutes_wait_time} =  1 minutes
#${2_minutes_wait_time} =  2 minutes
#${7_minutes_wait_time} =  7 minutes
#${10_minutes_wait_time} =  10 minutes
#${19_minutes_wait_time} =  19 minutes
#${25_minutes_wait_time} =  25 minutes
#
#*** Test Cases ***
##Generic flow test for Auto check-in or Multi check-in scenario
#TC0: Verify auto Check in feature on all the DUT users when meeting is scheduled from outlook.
#     [Tags]   verify_auto_checkin       TDC_meeting_test
#     [Setup]  Testcase Setup for AC User for panel and norden    count=3
#     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_27       time_duration=10 min       participants=device_1:auto_checkin_user     use_current_time=True      roundup_end_time=off
#     verify meeting with checkin button in panel      device=device_1   meeting=panel_meeting_27   state=present   presence_status=present
#     verify meeting with checkin button in panel      device=device_3   meeting=panel_meeting_27   state=present   presence_status=present
#     checkin into meeting from panel        device=device_1      notification_appear=not_appear
#     Wait for Some Time    time=${2_minutes_wait_time}
#     verify presence of check in button on homescreen    device=device_1    presence_status=absent
#     verify presence of check in button on homescreen    device=device_3    presence_status=absent
#    [Teardown]  Run Keywords    Capture on Failure    AND      delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_27        AND     Refresh calls main tab  device=device_1
#
#TC1: Verify room reservation is not released throughout the scheduled time on reserving room.
#    [Tags]   452289   bvt   sanity	 bvt_panels
#    [Setup]  Testcase Setup for AC User for panel and norden    count=3
#    validate room availability status   device=device_1   status=available
#    check details on scheduling screen    device=device_1:auto_checkin_user
#    reserve room    device=device_1:auto_checkin_user
#    Refresh calls main tab    device=device_1
#    Refresh calls main tab    device=device_3
#    validate room availability status   device=device_1   status=reserved
#    validate room availability status   device=device_3   status=reserved
#    verify presence of check in button on homescreen   device=device_1    presence_status=absent
#    verify presence of check in button on homescreen   device=device_3    presence_status=absent
#    Wait for Some Time    time=${7_minutes_wait_time}
#    Refresh calls main tab  device=device_1
#    Refresh calls main tab    device=device_3
#    validate room availability status   device=device_1   status=reserved
#    validate room availability status   device=device_3   status=reserved
#    [Teardown]  Run Keywords    Capture on Failure      AND     cancel the current reserved meeting     device=device_1     AND     Refresh calls main tab    device=device_3   AND     Come back to home screen    device_list=device_1,device_3
#
#TC2: Verify DUT user can extend room reservation on reserving a Ad-hoc meeting.
#    [Tags]   452308   bvt   sanity	 bvt_panels
#    [Setup]  Testcase Setup for AC User for panel and norden   count=3
#    enable extend room reservation toggle     device=device_1
#    enable extend room reservation toggle     device=device_3
#    validate room availability status   device=device_1   status=available
#    check details on scheduling screen    device=device_1:auto_checkin_user
#    reserve room    device=device_1:auto_checkin_user
#    Refresh calls main tab    device=device_1
#    Refresh calls main tab    device=device_3
#    validate room availability status   device=device_1   status=reserved
#    validate room availability status   device=device_3   status=reserved
#    verify presence of check in button on homescreen   device=device_1    presence_status=absent
#    verify presence of check in button on homescreen   device=device_3    presence_status=absent
#    verify manage button on homescreen   device=device_3
#    extend room reservation from panel homescreen      device=device_1
#    Verify extended meeting title on panel homescreen      device=device_1       presence_status=absent
#    Verify extended meeting title on panel homescreen      device=device_3       presence_status=absent
#    [Teardown]  Run Keywords    Capture on Failure      AND     cancel the current reserved meeting     device=device_1     AND     Come back to home screen    device_list=device_1,device_3
#
#TC3: Verify DUT user can extend room reservation on DUT, At or after the meeting start time using Manage option.
#    [Tags]   452312     TDC_meeting_test
#    [Setup]  Testcase Setup for AC User for panel and norden  count=3
#    enable extend room reservation toggle     device=device_1
#    enable extend room reservation toggle     device=device_3
#    validate room availability status   device=device_1   status=available
#    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_28        time_duration=10 min       participants=device_1:auto_checkin_user     use_current_time=True      roundup_end_time=off
#    verify meeting with checkin button in panel      device=device_1   meeting=panel_meeting_28   state=present   presence_status=present
#    verify meeting with checkin button in panel      device=device_3   meeting=panel_meeting_28   state=present   presence_status=present
#    checkin into meeting from panel        device=device_1      notification_appear=not_appear
#    Wait for Some Time    time=${2_minutes_wait_time}
#    Refresh calls main tab    device=device_3
#    verify manage button on homescreen   device=device_3
#    extend room reservation from panel homescreen      device=device_1      meeting_type=outlook
#    Verify extended meeting title on panel homescreen      device=device_1       presence_status=present
#    Verify extended meeting title on panel homescreen      device=device_3       presence_status=present
#    verify manage button on homescreen   device=device_1
#    verify manage button on homescreen   device=device_3
#    [Teardown]  Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_28      AND     cancel the current reserved meeting     device=device_1     AND   disable extend room reservation toggle     device=device_1  AND   disable extend room reservation toggle     device=device_3   AND  Come back to home screen    device_list=device_1,device_3   AND     Capture on Failure
#
#TC4: Verify DUT user can extend room reservation on Norden device after pairing with Panel on reserving a Ad-hoc meeting.
#    [Tags]   452310
#    [Setup]  Testcase Setup for AC User for panel and norden    count=3
#    enable extend room reservation toggle     device=device_1
#    enable extend room reservation toggle     device=device_3
#    validate room availability status   device=device_1   status=available
#    verify room availability to reserve  device=device_1    action=reserve
#    Refresh calls main tab    device=device_1
#    Refresh calls main tab    device=device_3
#    validate room availability status   device=device_1   status=reserved
#    validate room availability status   device=device_3   status=reserved
#    verify presence of check in button on homescreen   device=device_1    presence_status=absent
#    verify presence of check in button on homescreen   device=device_3    presence_status=absent
#    verify manage button on homescreen   device=device_1
#    extend room reservation from panel homescreen      device=device_1
#    Verify extended meeting title on panel homescreen      device=device_1       presence_status=absent
#    Verify extended meeting title on panel homescreen      device=device_3       presence_status=absent
#    verify manage button on homescreen   device=device_3
#    [Teardown]  Run Keywords    Capture on Failure      AND     cancel the current reserved meeting         device=device_1     AND      disable extend room reservation toggle    device=device_1    AND    disable extend room reservation toggle    device=device_3     AND     Come back to home screen    device_list=device_1,device_3    AND    Capture on Failure
#
#TC5: Verify DUT is not displayed check in button until the meeting start time is 20 minutes away.
#    [Tags]    452294     bvt sanity    bvt_panels       TDC_meeting_test
#    [Setup]  Testcase Setup for AC User for panel and norden    count=3
#    Create TDC Meeting with custom start time    device=tdc_1:meeting_user     meeting_name=panel_meeting_29        time_duration=10 min       participants=device_1:auto_checkin_user     start_meeting_time=on    start_meeting_time_after=30
#    verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_29     presence_status=absent
#    verify meeting with checkin button for upcoming meeting in panel      device=device_3   meeting=panel_meeting_29     presence_status=absent
#    Wait for Some Time    time=${10_minutes_wait_time}
#    verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_29     presence_status=present
#    verify meeting with checkin button for upcoming meeting in panel      device=device_3   meeting=panel_meeting_29     presence_status=present
#    Wait for Some Time    ${25_minutes_wait_time}
#    Refresh calls main tab  device=device_1
#    Refresh calls main tab    device=device_3
#    validate room availability status   device=device_1   status=available
#    validate room availability status   device=device_3   status=available
#    [Teardown]    Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_29        AND    disable extend room reservation toggle    device=device_1    AND    disable extend room reservation toggle    device=device_3    AND    Come back to home screen    device_list=device_1,device_3    AND    Capture on Failure
#
#TC6: Verify DUT user can Check out from meeting by joining meeting ahead of the meeting start time, when meeting is scheduled from outlook.
#    [Tags]    452300        TDC_meeting_test
#    [Setup]  Testcase Setup for AC User for panel and norden    count=3
#    Enable check out and extend room reservation toggles   device=device_1
#    Enable check out and extend room reservation toggles   device=device_3
#    Create TDC Meeting with custom start time    device=tdc_1:meeting_user     meeting_name=panel_meeting_30        time_duration=10 min       participants=device_1:auto_checkin_user     start_meeting_time=on    start_meeting_time_after=20
#    verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_30     presence_status=present
#    verify meeting with checkin button for upcoming meeting in panel      device=device_3   meeting=panel_meeting_30     presence_status=present
#    checkin into meeting from_panel        device=device_1      notification_appear=not_appear      meeting_type=upcoming
#    Wait for Some Time    ${1_minutes_wait_time}
#    Refresh calls main tab  device=device_1
#    Refresh calls main tab    device=device_3
#    verify presence of check in button for upcoming meeting on homescreen   device=device_1    presence_status=absent
#    verify presence of check in button for upcoming meeting on homescreen   device=device_3    presence_status=absent
#    Wait for Some Time    ${19_minutes_wait_time}
#    Refresh calls main tab  device=device_1
#    Refresh calls main tab    device=device_3
#    verify manage button on homescreen   device=device_1
#    verify manage button on homescreen   device=device_3
#    checkout of the reserved meeting   device=device_1
#    validate room availability status   device=device_1   status=available
#    [Teardown]    Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_30        AND    disable check out and extend room reservation toggles    device=device_1        AND    disable check out and extend room reservation toggles    device=device_3        AND    Capture on Failure
#
#*** Keywords ***
#enable checkin toggle and select release time in panel
#    [Arguments]     ${device}   ${release_time}
#    navigate to meetings option in panel app settigs       device=${device}
#    enable or disable checkin toggle button in panel            device=${device}             state=on
#    select release time for meeting        device=${device}        release_time=${release_time}
#
#navigate to meetings option in panel app settigs
#    [Arguments]     ${device}
#    Navigation to settings page in panel   device=${device}
#    verify device settings option in panel    device=${device}
#    navigate inside of teams admin settings in panel    device=${device}
#    go to meetings tab in panel     device=${device}
#
#verify meeting with checkin button in panel
#    [Arguments]     ${device}   ${meeting}    ${state}      ${presence_status}
#    Refresh calls main tab    device=${device}
#    verify presence of single meeting in panel    device=${device}    state=${state}    meeting=${meeting}
#    verify presence of check in button on homescreen   device=${device}    presence_status=${presence_status}
#
#cancel the current reserved meeting
#    [Arguments]     ${device}
#    verify meeting already got cancelled       device=${device}
#    navigate to meetings option in panel app settigs       device=${device}
#    enable or disable check out toggle btn in panel         device=${device}       checkout_toggle_status=on
#    Come back to home screen    device_list=${device}
#    checkout of the reserved meeting   device=${device}
#    navigate to meetings option in panel app settigs       device=${device}
#    enable or disable check out toggle btn in panel         device=${device}       checkout_toggle_status=off
#    go back to homescreen from admin settings options   device=${device}
#    Refresh calls main tab  device=${device}
#    validate room availability status   device=${device}   status=available
#
#verify meeting already got cancelled
#    [Arguments]     ${device}
#    ${status}     is_meeting_got_cancelled_in_panel       ${device}
#    Pass Execution if    '${status}' == 'pass'    ${device}: Meeting already got cancelled.
#
#enable extend room reservation toggle
#    [Arguments]     ${device}
#    navigate to meetings option in panel app settigs       device=${device}
#    enable or disable extend room reservation toggle btn in panel      device=${device}       extend_rr_state=on
#    go back to homescreen from admin settings options       device=${device}
#
#
#disable extend room reservation toggle
#    [Arguments]     ${device}
#    navigate to meetings option in panel app settigs       device=${device}
#    enable or disable extend room reservation toggle btn in panel      device=${device}       extend_rr_state=off
#    go back to homescreen from admin settings options       device=${device}
#
#verify meeting with checkin button for upcoming meeting in panel
#    [Arguments]     ${device}   ${meeting}      ${presence_status}
#    Refresh calls main tab    device=${device}
#    verify presence of upcoming single meeting in panel    device=${device}     meeting=${meeting}
#    verify presence of check in button for upcoming meeting on homescreen   device=${device}    presence_status=${presence_status}
#
#Enable check out and extend room reservation toggles
#    [Arguments]     ${device}
#    navigate to meetings option in panel app settigs       device=${device}
#    enable or disable check out toggle btn in panel         device=${device}       checkout_toggle_status=on
#    enable or disable extend room reservation toggle btn in panel      device=${device}       extend_rr_state=on
#    go back to homescreen from admin settings options       device=${device}
#
#disable check out and extend room reservation toggles
#    [Arguments]     ${device}
#    navigate to meetings option in panel app settigs       device=${device}
#    enable or disable check out toggle btn in panel         device=${device}       checkout_toggle_status=off
#    enable or disable extend room reservation toggle btn in panel      device=${device}       extend_rr_state=off
#    go back to homescreen from admin settings options       device=${device}
#
#Create TDC Meeting
#    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
#    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}
#
#Create TDC Meeting with custom start time
#    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}      ${start_meeting_time}     ${start_meeting_time_after}
#    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}    start_meeting_time=${start_meeting_time}     start_meeting_time_after=${start_meeting_time_after}