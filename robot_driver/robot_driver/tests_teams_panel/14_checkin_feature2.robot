*** Settings ***
Resource    ../resources/keywords/common.robot
Force Tags      exclude_pairing     checkin_TC4
Suite Teardown  Run Keywords    Suite Failure Capture

*** Variables ***
${2_minutes_wait_time} =  2 minutes
${3_minutes_wait_time} =  3 minutes
${4_minutes_wait_time} =  4 minutes
${5_minutes_wait_time} =  5 minutes
${8_minutes_wait_time} =  8 minutes
${10_minutes_wait_time} =  10 minutes

*** Test Cases ***
TC1:[Active Room Management] Verify Check-in notification should not display in Norden when devices are not paired
    [Tags]   322101        TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1     release_time=5
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_21       time_duration=5 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    Refresh calls main tab    device=device_2
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    Refresh calls main tab  device=device_1
    verify presence of check in button on homescreen     device=device_1         presence_status=present
    checkin into meeting from panel        device=device_1                  notification_appear=not_appear
    verify room release activity based on checkin into meeting                 device=device_2                state=not_released       meeting=panel_meeting_21
    [Teardown]  Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_21        AND      disable checkin toggle           device=device_1

TC2:[check-in] Verify that check in option should not available for the time of meeting on the Panel
    [Tags]   321976       TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_22        time_duration=8 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Teams Panel along with Rooms Setup
    Refresh calls main tab  device=device_1
    refresh meeting visibility for norden device     device=device_2
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=panel_meeting_22       count_of_other_meetings=1
    navigate to meetings option in panel app settings       device=device_1
    verify checkin toggle button in panel   device=device_1
    go back to homescreen from admin settings options   device=device_1
    verify presence of check in button on homescreen     device=device_1         presence_status=absent
    [Teardown]  Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user     meeting_list=panel_meeting_22       AND       Reset device pairing

*** Keywords ***

Teams Panel along with Rooms Setup
    Testcase Setup  count=2
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1

Pair Panel and Rooms device
    navigate to device pairing option in panel app settings   device=device_1    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    get pairing code from rooms device    from_device1=device_2  to_device1=device_1

navigate to device pairing option in panel app settings
    [Arguments]     ${device}    ${pair_status}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing tab on panel     device=device_1      pair_status=${pair_status}

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

Reset device pairing
    navigate to device pairing option in panel app settings  device=device_1     pair_status=paired
    reset device pairing in panel  device=device_1

enable checkin toggle and select release time in panel
    [Arguments]     ${device}   ${release_time}
    verify room parameters    device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=on
    select release time for meeting        device=device_1        release_time=${release_time}

disable checkin toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=off
    go back to homescreen from admin settings options   device=device_1

refresh meeting visibility for norden device
    [Arguments]    ${device}
     Refresh meeting visibility for conf device  ${device}

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}
