#Revoming support for auto check-in feature because of: Bug 4162090: [Panels][Automation] Auto check in feature not supported via automation
#*** Settings ***
#Resource    ../resources/keywords/common.robot
#
#Suite Setup    Run Keywords    Teams Panel along with Rooms Setup    AND   enable checkin toggle and select release time in panel     device=device_1    release_time=5    AND    enable checkin toggle and select release time in panel    device=device_3    release_time=5
#Suite Teardown  Run Keywords     Suite Failure Capture   AND    Reset device pairing
#
#*** Variables ***
#${20_minutes_wait_time} =  20 minutes
#${7_minutes_wait_time} =  7 minutes
#${5_minutes_wait_time} =  5 minutes
#${2_minutes_wait_time} =  2 minutes
#${3_minutes_wait_time} =  3 minutes
#${13_minutes_wait_time} =  13 minutes
#${14_minutes_wait_time} =  14 minutes
#${4_minutes_wait_time} =    4 minutes
#${11_minutes_wait_time} =    11 minutes
#${12_minutes_wait_time} =    12 minutes
#
#*** Test Cases ***
#TC1: Verify Check in option is displayed on all the DUT users when meeting is scheduled from outlook.
#     [Tags]   452292    bvt   sanity	 bvt_panels     TDC_meeting_test
#     [Setup]  Testcase Setup for AC User for panel and norden    count=3
#     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_31       time_duration=10 min       participants=device_1:auto_checkin_user     roundup_end_time=off        start_meeting_time=on    start_meeting_time_after=20
#     verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_31     presence_status=present
#     verify meeting with checkin button for upcoming meeting in panel      device=device_3   meeting=panel_meeting_31     presence_status=present
#     checkin into meeting from panel        device=device_1      notification_appear=not_appear
#     Wait for Some Time    time=${2_minutes_wait_time}
#     verify presence of check in button on homescreen    device=device_1    presence_status=absent
#     verify presence of check in button on homescreen    device=device_3    presence_status=absent
#     Wait for Some Time    time=${5_minutes_wait_time}
#     verify meeting with checkin button for upcoming meeting in panel     device=device_1   meeting=panel_meeting_31    presence_status=absent
#     verify meeting with checkin button for upcoming meeting in panel      device=device_3   meeting=panel_meeting_31   presence_status=absent
#    [Teardown]  Run Keywords    Capture on Failure    AND     delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_31     AND     Refresh calls main tab  device=device_1
#
#TC2: Verify Check in option is disappeared on DUT after joining the meeting on Norden device before the meeting start time and before the room is released, when meeting is scheduled from outlook.
#     [Tags]   452296    452295    bvt   sanity	 bvt_panels     TDC_meeting_test
#     [Setup]  Testcase Setup for AC User for panel and norden    count=3
#     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_32       time_duration=10 min       participants=device_1:auto_checkin_user        roundup_end_time=off         start_meeting_time=on    start_meeting_time_after=20
#     verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_32     presence_status=present
#     verify meeting with checkin button for upcoming meeting in panel     device=device_3   meeting=panel_meeting_32      presence_status=present
#     join rooms meeting   device=device_2      meeting=panel_meeting_32       meeting_type=upcoming
#     Verify meeting state   device_list=device_2     state=Connected
#     verify presence of check in button on homescreen    device=device_1    presence_status=absent
#     verify presence of check in button on homescreen    device=device_3    presence_status=absent
#     Wait for Some Time    time=${5_minutes_wait_time}
#     verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_32     presence_status=absent
#     verify meeting with checkin button for upcoming meeting in panel     device=device_3   meeting=panel_meeting_32      presence_status=absent
#     End meeting   device=device_2
#    Verify meeting state    device_list=device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND       delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_32      AND     Refresh calls main tab  device=device_1
#
#TC3: Verify Check in option is disappeared on DUT by not joining the meeting on Norden device after the meeting start time but before the room is released, when meeting is scheduled from outlook.
#     [Tags]   452298    bvt   sanity	 bvt_panels     TDC_meeting_test
#     [Setup]  Testcase Setup for AC User for panel and norden    count=3
#     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_33       time_duration=7 min       participants=device_1:auto_checkin_user     roundup_end_time=off        start_meeting_time=on    start_meeting_time_after=20
#     verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_33     presence_status=present
#     verify meeting with checkin button for upcoming meeting in panel      device=device_3   meeting=panel_meeting_33     presence_status=present
#     Wait for Some Time    time=${20_minutes_wait_time}
#     Verify meeting state    device_list=device_2   state=Disconnected
#     Wait for Some Time    time=${7_minutes_wait_time}
#     validate room availability status   device=device_1   status=available
#    [Teardown]  Run Keywords    Capture on Failure    AND      delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_33        AND     Refresh calls main tab  device=device_1
#
#TC4: Verify Check in option Norden and user can extend room reservation on Norden device after pairing with Panel on reserving a Ad-hoc meeting.
#    [Tags]    452313    bvt sanity    bvt_panels        TDC_meeting_test
#    [Setup]  Testcase Setup for AC User for panel and norden    count=3
#    enable extend room reservation toggle     device=device_1
#    enable extend room reservation toggle     device=device_3
#    validate room availability status   device=device_1   status=available
#    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_34        time_duration=10 min       participants=device_1:auto_checkin_user     roundup_end_time=off       start_meeting_time=on    start_meeting_time_after=20
#    verify meeting with checkin button for upcoming meeting in panel      device=device_1   meeting=panel_meeting_34     presence_status=present
#    verify meeting with checkin button for upcoming meeting in panel      device=device_3   meeting=panel_meeting_34     presence_status=present
#    Refresh calls main tab    device=device_2
#    join rooms meeting   device=device_2      meeting=panel_meeting_34    meeting_type=upcoming
#    Verify meeting state   device_list=device_2     state=Connected
#    Wait for Some Time    time=${7_minutes_wait_time}
#    verify presence of check in button on homescreen    device=device_1    presence_status=absent
#    verify presence of check in button on homescreen    device=device_3    presence_status=absent
#    Wait for Some Time    time=${14_minutes_wait_time}
#    extend room reservation from panel homescreen      device=device_1    meeting_type=outlook
#    Refresh calls main tab    device=device_1
#    Refresh calls main tab    device=device_3
#    Verify extended meeting title on panel homescreen      device=device_1       presence_status=present
#    Verify extended meeting title on panel homescreen      device=device_3       presence_status=present
#    verify meeting with checkin button in panel      device=device_1   meeting=panel_meeting_34   state=present   presence_status=absent
#    verify meeting with checkin button in panel      device=device_3   meeting=panel_meeting_34   state=present   presence_status=absent
#    verify manage button on homescreen   device=device_1
#    verify manage button on homescreen   device=device_3
#    End meeting   device=device_2
#    Wait for Some Time    time=${5_minutes_wait_time}
#    [Teardown]    Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_34        AND    clear all meetings except test meeting       device=device_3     AND    disable extend room reservation toggle   device=device_1    AND    disable extend room reservation toggle   device=device_3    AND    Come back to home screen   device_list=device_1,device_3    AND    Capture on Failure
#
#TC5: Verify user can join All day meeting created by outlook.
#    [Tags]    452349    bvt sanity    bvt_panels        TDC_meeting_test
#    [Setup]  Testcase Setup for AC User for panel and norden    count=3
#    validate room availability status   device=device_1   status=available
#    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=allday_new1     participants=device_1:auto_checkin_user      all_day_meeting=on
#    Refresh calls main tab    device=device_1
#    Refresh calls main tab    device=device_3
#    verify presence of check in button on homescreen    device=device_1    presence_status=absent
#    verify presence of check in button on homescreen    device=device_3    presence_status=absent
#    Refresh calls main tab    device=device_1
#    Verify one all day meeting in panel    device=device_1     meeting=allday_new1
#    Refresh calls main tab    device=device_2
#    join rooms meeting   device=device_2      meeting=allday_new1
#    Verify meeting state   device_list=device_2     state=Connected
#    verify presence of check in button on homescreen    device=device_2    presence_status=absent
#    End meeting   device=device_2
#    Verify meeting state   device_list=device_2     state=disconnected
#    [Teardown]    Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=allday_new1     AND    disable extend room reservation toggle    device=device_1    AND    disable extend room reservation toggle    device=device_3    AND    Come back to home screen    device_list=device_1,device_3    AND    Capture on Failure
#*** Keywords ***
#
#Teams Panel along with Rooms Setup
#    Testcase Setup for AC User for panel and norden  count=3
#    Pair Panel and Rooms device   device=device_1    from_device=device_1    to_device=device_2    from_device1=device_2  to_device1=device_1
#    Come back to home screen    device_list=device_1
#
#Pair Panel and Rooms device
#    [Arguments]     ${device}       ${from_device}       ${to_device}     ${from_device1}       ${to_device1}
#    Navigation to settings page in panel    device=${device}
#    verify device settings option in panel   device=${device}
#    navigate inside of teams admin settings in panel    device=${device}
#    navigate to device pairing page on panel       device=${device}
#    verify device pairing is present or not      device=${device}
#    select rooms device to pair from panel   from_device=${from_device}    to_device=${to_device}
#    get pairing code from rooms device    from_device1=${from_device1}  to_device1=${to_device1}
#
#verify device pairing is present or not
#    [Arguments]     ${device}
#    ${status}     is_device_paired_to_panel       ${device}
#    Pass Execution if    '${status}' == 'pass'    ${device}: Device is already paired.
#
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
#verify meeting with checkin button for upcoming meeting in panel
#    [Arguments]     ${device}   ${meeting}      ${presence_status}
#    Refresh calls main tab    device=${device}
#    verify presence of upcoming single meeting in panel    device=${device}     meeting=${meeting}
#    verify presence of check in button for upcoming meeting on homescreen   device=${device}    presence_status=${presence_status}
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
#verify reset pairing is present or not
#    [Arguments]     ${device}
#    ${status}     is_device_paired_to_panel       ${device}
#    Pass Execution if    '${status}' == 'fail'    ${device}: Device pairing already got reset.
#
#Reset device pairing
#    Navigation to settings page in panel  device=device_1
#    verify device settings option in panel  device=device_1
#    navigate inside of teams admin settings in panel    device=device_1
#    navigate to device pairing page on panel       device=device_1
#    verify reset pairing is present or not      device=device_1
#    reset device pairing in panel  device=device_1
#    go back to homescreen from admin settings options       device=device_1
#
#refresh meeting visibility for norden device
#    [Arguments]    ${device}
#     Refresh meeting visibility for conf device  ${device}
#
#verify meeting with checkin button in panel
#    [Arguments]     ${device}   ${meeting}    ${state}      ${presence_status}
#    Refresh calls main tab    device=${device}
#    verify presence of single meeting in panel    device=${device}    state=${state}    meeting=${meeting}
#    verify presence of check in button on homescreen   device=${device}    presence_status=${presence_status}
#
#Create TDC Meeting
#    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${roundup_end_time}     ${start_meeting_time}     ${start_meeting_time_after}
#    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     roundup_end_time=${roundup_end_time}      start_meeting_time=${start_meeting_time}     start_meeting_time_after=${start_meeting_time_after}
#
#Create all day TDC Meeting
#    [Arguments]       ${device}      ${meeting_name}     ${participants}     ${all_day_meeting}
#    create TDC meeting on desktop      ${device}     ${meeting_name}     participants=${participants}     all_day_meeting=${all_day_meeting}