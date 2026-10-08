*** Settings ***
Resource    ../resources/keywords/common.robot
Force Tags      exclude_pairing     checkin_TC3
Suite Setup    Teams Panel along with Rooms Setup
Suite Teardown  Run Keywords    Suite Failure Capture    AND   Reset device pairing

*** Variables ***
${1_minutes_wait_time} =  1 minutes
${2_minutes_wait_time} =  2 minutes
${3_minutes_wait_time} =  3 minutes
${4_minutes_wait_time} =  4 minutes
${5_minutes_wait_time} =  5 minutes
${6_minutes_wait_time} =  6 minutes
${8_minutes_wait_time} =  8 minutes
${10_minutes_wait_time} =  10 minutes
${display_time} =  10

*** Test Cases ***

TC1:[Active Room Management] Verify Warning and room release notification when 10 min is selected in settings
    [Tags]   322003     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=10
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_6        time_duration=15 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab    device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    Wait for Some Time    time=${8_minutes_wait_time}
    verify presence of room release warning         device=device_2      presence=present
    Wait for Some Time    time=${4_minutes_wait_time}
    verify room release activity based on checkin into meeting         device=device_2      state=released       meeting=panel_meeting_6
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available
    [Teardown]  Run Keywords    Capture on Failure     AND     delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_6        AND     Refresh calls main tab  device=device_1     AND      disable checkin toggle         device=device_1

TC2:[Active Room Management] Verify when user press the check-in button, room should not be released
    [Tags]   322102    TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=5
    enable checkin notification toggle          device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_7        time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    Wait for Some Time    time=${2_minutes_wait_time}
    checkin into meeting from panel        device=device_1                  notification_appear=appear
    verify room release activity based on checkin into meeting                 device=device_2                state=not_released        meeting=panel_meeting_7
    verify presence of room release warning         device=device_2      presence=absent
    Wait for Some Time    time=${5_minutes_wait_time}
    Verify meeting display on home screen     device=device_2
    [Teardown]  Run Keywords    Capture on Failure    AND     delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_7     AND      disable checkin toggle      device=device_1     AND    disable checkin notification toggle     device=device_1

TC3:[Active Room Management] Verify the notification and room release when release after time is decreased to 10 from 15 min
    [Tags]   322008     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1     release_time=15
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_8        time_duration=15 min       participants=device_1     use_current_time=True      roundup_end_time=off
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    Wait for Some Time    time=${10_minutes_wait_time}
    navigate to meetings option in panel app settings       device=device_1
    select release time for meeting        device=device_1        release_time=10
    Refresh calls main tab    device=device_2
    verify room release activity based on checkin into meeting                 device=device_2                state=released        meeting=panel_meeting_8
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available
    [Teardown]  Run Keywords    Capture on Failure    AND     delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_8        AND   disable checkin toggle    device=device_1

TC4:[Active Room Management] Verify when user join the same meeting from Norden, room should not be released
    [Tags]   322104     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=5
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_9     time_duration=8 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=panel_meeting_9
    Verify meeting state   device_list=device_2    state=Connected
    Refresh calls main tab  device=device_1
    verify presence of check in button on homescreen     device=device_1         presence_status=absent
    Wait for Some Time    time=${5_minutes_wait_time}
    Verify meeting state   device_list=device_2    state=Connected
    verify room release activity based on checkin into meeting                 device=device_2                state=not_released         meeting=panel_meeting_9
    [Teardown]  Run Keywords    Capture on Failure   AND   End meeting     device=device_2    AND     delete all meetings from tdc     device=tdc_1:meeting_user     meeting_list=panel_meeting_9       AND     disable checkin toggle     device=device_1

TC5:[Active Room Management] Verify if end user finishes meeting early, room will be booked for the entire duration
    [Tags]   322106     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=5
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_10        time_duration=15 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    Refresh calls main tab    device=device_2
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    Wait for Some Time    time=${2_minutes_wait_time}
    join rooms meeting   device=device_2    meeting=panel_meeting_10
    Verify meeting state   device_list=device_2    state=Connected
    End meeting     device=device_2
    Verify meeting state    device_list=device_2   state=Disconnected
    Wait for Some Time    time=${5_minutes_wait_time}
    verify room release activity based on checkin into meeting                 device=device_2                state=not_released        meeting=panel_meeting
    verify presence of room release warning         device=device_2      presence=absent
    verify meeting name on panel homescreen    device=device_1     meeting=panel_meeting_10
    [Teardown]  Run Keywords    Capture on Failure     AND      delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_10     AND     disable checkin toggle           device=device_1

TC6:[Active Room Management] Verify when Room release is OFF, Room release settings should be hidden and Room should not be released
    [Tags]   322107     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    navigate to meetings option in panel app settings       device=device_1
    verify checkin toggle button in panel   device=device_1
    go back to homescreen from admin settings options   device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_11        time_duration=5 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    Refresh calls main tab    device=device_2
    Verify meeting display on home screen     device=device_2
    Wait for Some Time    time=${3_minutes_wait_time}
    Verify meeting display on home screen     device=device_2
    verify presence of room release warning         device=device_2      presence=absent
    [Teardown]  Run Keywords    Capture on Failure     AND  delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_11

TC7:[CHD][Teams Panel][Check-ins]Verify that "Check-ins" image after user click on check-in option
    [Tags]   322115     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=on
    enable or disable checkin notification toggle button in panel          device=device_1            checkin_notification_state=on
    go back to homescreen from admin settings options   device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_12       time_duration=5 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    checkin into meeting from panel        device=device_1                  notification_appear=appear
    [Teardown]  Run Keywords    Capture on Failure     AND   delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_12       AND      disable checkin toggle      device=device_1

TC8:[Active Room Management] Verify Check-in notification toggle is OFF and Room release toggle is ON and user doesn't check-in
    [Tags]   322134     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=5
    disable checkin notification toggle            device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_13       time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    Wait for Some Time    time=${6_minutes_wait_time}
    verify room release activity based on checkin into meeting         device=device_2      state=released         meeting=panel_meeting_13
    Refresh calls main tab  device=device_1
    verify presence of room release warning         device=device_2      presence=absent
    validate room availability status   device=device_1   status=available
    [Teardown]  Run Keywords    Capture on Failure    AND   delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_13     AND     Refresh calls main tab  device=device_1     AND      disable checkin toggle         device=device_1

TC9:[Active Room Management] Verify Check-in notification toggle is OFF and Room release toggle is ON and user check-in
    [Tags]   322138     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=5
    disable checkin notification toggle            device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_14       time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    checkin into meeting from panel        device=device_1                  notification_appear=not_appear
    Wait for Some Time    time=${5_minutes_wait_time}
    verify room release activity based on checkin into meeting                 device=device_2                state=not_released       meeting=panel_meeting_14
    [Teardown]  Run Keywords    Capture on Failure     AND    delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_14       AND      disable checkin toggle     device=device_1

TC10:[Active Room Management] Verify Check-in should not display in Adhoc meeting
     [Tags]   322158          TDC_meeting_test
     [Setup]  Testcase Setup   count=2
     navigate to meetings option in panel app settings       device=device_1
     enable or disable checkin toggle button in panel            device=device_1             state=on
     go back to homescreen from admin settings options   device=device_1
     validate room availability status   device=device_1   status=available
     verify room availability to reserve  device=device_1    action=reserve
     validate room availability status   device=device_1   status=reserved
     Refresh calls main tab  device=device_1
     refresh meeting visibility for norden device     device=device_2
     Verify meeting display on home screen     device=device_2
     verify presence of check in button on homescreen     device=device_1    presence_status=absent
     [Teardown]  Run Keywords    Capture on Failure      AND    cancel the current reserved meeting    device=device_1       AND      disable checkin toggle         device=device_1

TC11:[CHD][Teams Panel][Check-ins]Verify that user should not be able to see check in option for created meeting when meeting has joined by Norden user
    [Tags]   322162     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=5
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_15        time_duration=8 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=panel_meeting_15
    Verify meeting state   device_list=device_2    state=Connected
    Refresh calls main tab  device=device_1
    Wait for Some Time    time=${2_minutes_wait_time}
    Verify meeting state   device_list=device_2    state=Connected
    verify presence of check in button on homescreen     device=device_1         presence_status=absent
    [Teardown]  Run Keywords    Capture on Failure  AND   End meeting     device=device_2     AND     delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_15       AND    disable checkin toggle           device=device_1

TC12:[CHD][Teams Panel][Check-ins]Verify that Banner image should not reflect on Norden when Panel user Checked-in
     [Tags]   322229     TDC_meeting_test
     [Setup]  Testcase Setup   count=2
     enable checkin toggle and select release time in panel      device=device_1         release_time=5
     disable checkin notification toggle            device=device_1
     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_16       time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
     Refresh calls main tab  device=device_1
     refresh meeting visibility for norden device     device=device_2
     Verify meeting display on home screen     device=device_2
     checkin into meeting from panel        device=device_1                  notification_appear=not_appear
     [Teardown]  Run Keywords    Capture on Failure     AND      delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_16        AND     disable checkin toggle     device=device_1

TC13:[Active Room Management] Verify Upcoming meeting check-in when there is no prior meeting
     [Tags]   322111     TDC_meeting_test
     [Setup]  Testcase Setup   count=2
     enable checkin toggle and select release time in panel      device=device_1         release_time=5
     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_17       time_duration=30 min       participants=device_1     use_current_time=True      roundup_end_time=off
     Refresh calls main tab  device=device_1
     refresh meeting visibility for norden device     device=device_2
     Verify meeting display on home screen     device=device_2
     Wait for Some Time    time=${5_minutes_wait_time}
     checkin into meeting from panel        device=device_1                  notification_appear=not_appear
     verify room release activity based on checkin into meeting                 device=device_2          state=not_released       meeting=panel_meeting_17
     Wait for Some Time    time=${5_minutes_wait_time}
     Verify meeting display on home screen     device=device_2
     [Teardown]  Run Keywords    Capture on Failure    AND      delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_17      AND      disable checkin toggle         device=device_1

TC14:[Active Room Management] Verify Room release notification auto-dismiss after 5 min
	[Tags]   322153     TDC_meeting_test
	[Setup]  Testcase Setup   count=2
	enable checkin toggle and select release time in panel      device=device_1         release_time=5
	create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_18        time_duration=15 min       participants=device_1     use_current_time=True      roundup_end_time=off
	Refresh calls main tab    device=device_1
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    Wait for Some Time    time=${3_minutes_wait_time}
    verify presence of room release warning         device=device_2      presence=present
    Wait for Some Time    time=${3_minutes_wait_time}
    verify room release activity based on checkin into meeting                 device=device_2                state=released        meeting=panel_meeting_18
    [Teardown]  Run Keywords    Capture on Failure     AND      delete all meetings from tdc     device=tdc_1:meeting_user     meeting_list=panel_meeting_18        AND      disable checkin toggle         device=device_1

TC15:[Active Room Management] Once the first meeting gets cancelled, the second meeting should be automatically declined from both the Panel and Norden.
    [Tags]   413528   bvt   sanity	 bvt_panels     bvt_panels_pr     TDC_meeting_test
	[Setup]  Testcase Setup   count=2
	enable checkin toggle and select release time in panel      device=device_1         release_time=10
	create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_concurrent_meeting1       time_duration=30 min       participants=device_1     use_current_time=True      roundup_end_time=off
	Refresh calls main tab    device=device_1
	verify presence of single meeting in panel    device=device_1   state=present    meeting=panel_concurrent_meeting1
	create TDC meeting on desktop     device=tdc_1:meeting_user     meeting_name=panel_concurrent_meeting2       time_duration=30 min       participants=device_1      concurrent_meeting=on
	Refresh calls main tab    device=device_1
    refresh meeting visibility for norden device     device=device_2
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=panel_concurrent_meeting1,panel_concurrent_meeting2      count_of_other_meetings=2
    Wait for Some Time      time=${5_minutes_wait_time}
    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_concurrent_meeting1
    Wait for Some Time    time=${1_minutes_wait_time}
    Refresh calls main tab    device=device_1
    verify presence of single meeting in panel    device=device_1   state=absent    meeting=panel_concurrent_meeting2
    [Teardown]  Run Keywords    Capture on Failure    AND      delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_concurrent_meeting1,panel_concurrent_meeting2      AND      disable checkin toggle         device=device_1

TC16:[Active Room Management] Verify when Sign out of Teams app in Norden, pairing should be lost. Notification should not display in Norden.
    [Tags]   322100     TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    enable checkin toggle and select release time in panel      device=device_1         release_time=10
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_19        time_duration=15 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_2
    verify presence of single meeting in panel    device=device_1    state=present    meeting=panel_meeting_19
    Sign out method    device=device_2
    verify device unpaired    device=device_1    pair_status=unpaired
    Wait for Some Time    time=${6_minutes_wait_time}
    verify presence of room release warning         device=device_2      presence=absent
    Wait for Some Time    time=${6_minutes_wait_time}
    validate room availability status   device=device_1   status=available
    [Teardown]  Run Keywords    Capture on Failure    AND         delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_19

TC17:[Check-in]Verify that user should not be able get "Check in" button for All Day meetings
    [Tags]  322144     TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    create all day TDC meeting     device=tdc_1:meeting_user     meeting_name=panel_meeting_20       participants=device_1    all_day_meeting=on
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    Verify one all day meeting in panel   device=device_1     meeting=meeting1
    navigate to meetings option in panel app settings    device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=on
    go back to homescreen from admin settings options   device=device_1
    verify presence of check in button on homescreen   device=device_1           presence_status=absent
    [Teardown]  Run Keywords    Capture on Failure      AND   delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_20

*** Keywords ***

Teams Panel along with Rooms Setup
    Testcase Setup  count=2
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1

Pair Panel and Rooms device
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing page on panel       device=device_1
    verify device pairing is present or not      device=device_1
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
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing page on panel       device=device_1
    verify pairing is already reset or not      device=device_1
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

enable checkin notification toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin notification toggle button in panel          device=device_1              checkin_notification_state=on
    go back to homescreen from admin settings options   device=device_1

disable checkin notification toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin notification toggle button in panel          device=device_1              checkin_notification_state=off
    go back to homescreen from admin settings options   device=device_1

verify pairing is already reset or not
    [Arguments]     ${device}
    ${status}     is_device_paired_to_panel       ${device}
    Pass Execution if    '${status}' == 'fail'    ${device}: Device pairing already got reset.

verify device pairing is present or not
    [Arguments]     ${device}
    ${status}     is_device_paired_to_panel       ${device}
    Pass Execution if    '${status}' == 'pass'    ${device}: Device is already paired.

refresh meeting visibility for norden device
    [Arguments]    ${device}
     Refresh meeting visibility for conf device  ${device}

verify device unpaired
     [Arguments]     ${device}    ${pair_status}
    navigate to device pairing option in panel app settings   device=device_1    pair_status=unpaired
    go back to homescreen from admin settings options       device=${device}

cancel the current reserved meeting
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    Come back to home screen    device_list=device_1
    checkout of the reserved meeting   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

Create all day TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${participants}     ${all_day_meeting}
    create TDC meeting on desktop      ${device}     ${meeting_name}     participants=${participants}     all_day_meeting=${all_day_meeting}

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}
