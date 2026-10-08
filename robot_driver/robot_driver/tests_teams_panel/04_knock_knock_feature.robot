*** Settings ***
Resource    ../resources/keywords/common.robot
Force Tags     exclude_pairing
Suite Setup    Teams Panel along with Rooms Setup
Suite Teardown  Run Keywords    Suite Failure Capture   AND   Come back to home screen    device_list=device_1     AND   Reset device pairing

*** Variables ***
${display_time} =  10
${2_minutes_wait_time} =  2 minutes

*** Test Cases ***
TC1:[Knock-knock]User to connect to a device
    [Tags]  307975   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup  count=2
    navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
    verify device is paired     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2:[Knock Knock]Reserving Ad hoc meeting
    [Tags]  307979   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup  count=2
    verify room parameters    device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    refresh meeting visibility for norden device     device=device_2
    verify current or upcoming meetings displays on home screen    device=device_2
    cancel the current reserved meeting     device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND     cancel the current reserved meeting     device=device_1     AND     Come back to home screen    device_list=device_1,device_2

TC3:[Knock-knock]UI verification after the device is paired
    [Tags]  307989   bvt   sanity	 bvt_panels     bvt_panels_pr       exclude_pairing
    [Setup]  Testcase Setup  count=2
    navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
    verify device is paired     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4:[Knock Knock] Verify the Check-in option after pairing
    [Tags]  307991   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup  count=2
    navigate to meetings option in panel app settings       device=device_1
    verify checkin toggle button in panel   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5:[Knock-knock]User to verify Device pairing option on the device
    [Tags]  307974   sanity
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6:[Knock Knock] Join meeting in Collab bar
    [Tags]  307981   sanity     bvt_panels_pr
    [Setup]  Testcase Setup  count=2
    verify room parameters    device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    Wait for Some Time    time=15
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=Reserved
    Verify meeting state   device_list=device_2    state=Connected
    Wait for Some Time    time=10
    End meeting     device=device_2
    cancel the current reserved meeting     device=device_1
    [Teardown]  Run Keywords    Capture on Failure     AND    end the rooms meeting if it is in connected state     device=device_2    AND    cancel the current reserved meeting     device=device_1     AND    Come back to home screen    device_list=device_1,device_2

TC7:[Knock-knock] Verify check in button is appearing on ad-hoc meeting once reservation is confirmed.
	 [Tags]   417638   bvt   sanity	 bvt_panels     bvt_panels_pr       checkin_TC2
     [Setup]  Testcase Setup   count=2
     navigate to meetings option in panel app settings       device=device_1
     enable or disable checkin toggle button in panel            device=device_1             state=on
     go back to homescreen from admin settings options   device=device_1
     validate room availability status   device=device_1   status=available
     verify room availability to reserve  device=device_1    action=reserve
     validate room availability status   device=device_1   status=reserved
     Refresh calls main tab  device=device_1
     Refresh calls main tab    device=device_2
     Verify meeting display on home screen     device=device_2
     verify presence of check in button on homescreen     device=device_1    presence_status=absent
     [Teardown]  Run Keywords    Capture on Failure      AND    disable checkin toggle         device=device_1     AND    cancel the current reserved meeting     device=device_1

TC8:[Knock Knock] Enable check in option after joining the meeting in Collab bar
    [Tags]  307993      TDC_meeting_test        checkin_TC2
    [Setup]  Testcase Setup  count=2
    Verify homescreen on panel   device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_3     time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab    device=device_2
    Refresh calls main tab    device=device_1
    verify meeting name on panel homescreen    device=device_1     meeting=panel_meeting_3
    join rooms meeting   device=device_2    meeting=panel_meeting_3
    Verify meeting state   device_list=device_2    state=Connected
    navigate to meetings option in panel app settings    device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=on
    go back to homescreen from admin settings options   device=device_1
    verify presence of check in button on homescreen   device=device_1  presence_status=present
    End meeting     device=device_2
    Verify meeting state   device_list=device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_3        AND     disable checkin toggle    device_list=device_1

TC9:[Knock Knock] Verify that Checkin button should not display in current meeting at panel app home screen after pairing device, if Checkin toggle is off
    [Tags]  321271      TDC_meeting_test        checkin_TC2
    [Setup]  Testcase Setup  count=1
    Verify homescreen on panel   device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_4     time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    verify meeting name on panel homescreen    device=device_1     meeting=panel_meeting_4
    navigate to meetings option in panel app settings    device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=off
    go back to homescreen from admin settings options   device=device_1
    verify presence of check in button on homescreen   device=device_1  presence_status=absent
    [Teardown]  Run Keywords    Capture on Failure  AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_4       AND    disable checkin toggle    device_list=device_1

TC10:[Knock Knock]Verify Textbox and Pair button is displaying in Panel after Pair code is sent to Norden
    [Tags]  308004
    [Setup]  Testcase Setup  count=2
    navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
    verify device is paired     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11:[Knock-knock] User to verify reset pairing option and starts searching again
    [Tags]  308001
    [Setup]   Testcase Setup  count=2
    navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
    verify device is paired     device=device_1
    reset device pairing in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2  AND  Teams Panel along with Rooms Setup

TC12: [Knock Knock] Verify Search again button starts searching again
    [Tags]  321260
    [Setup]  Testcase Setup  count=2
    navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
    verify device is paired     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC13:[Knock Knock] Verify that Checkin button display for meetings at panel app home screen after pairing device
     [Tags]   321266        TDC_meeting_test        checkin_TC2
     [Setup]  Testcase Setup   count=2
     enable checkin toggle and select release time in panel      device=device_1         release_time=5
     enable checkin notification toggle          device=device_1
     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_5        time_duration=15 min       participants=device_1     use_current_time=True      roundup_end_time=off
     Refresh calls main tab  device=device_1
     Refresh calls main tab    device=device_2
     Verify meeting display on home screen     device=device_2
     Wait for Some Time    time=${2_minutes_wait_time}
     checkin into meeting from panel        device=device_1                  notification_appear=appear
     [Teardown]  Run Keywords    Capture on Failure    AND     delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_5        AND      disable both checkin and checkin notification toggle      device=device_1

TC14:[Knock Knock]Pair the DUT with the Collab bar.
    [Tags]  307978  sanity     bvt_panels_pr
    [Setup]  Testcase Setup   count=2
    navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
    verify device is paired     device=device_1
    go back to homescreen from admin settings options   device=device_1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    sign in method  device_1    user=cap_user
    Verify homescreen on panel      device=device_1:cap_user
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing page on panel       device=device_1
    verifying no device is available for pairing    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

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
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing tab on panel     device=device_1     pair_status=${pair_status}

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

cancel the current reserved meeting
    [Arguments]     ${device}
    verify meeting already got cancelled       device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    Come back to home screen    device_list=device_1
    checkout of the reserved meeting   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

Reset device pairing
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing page on panel       device=device_1
    verify reset pairing is present or not      device=device_1
    reset device pairing in panel  device=device_1

disable checkin toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=off
    Come back to home screen    device_list=device_1

verify reset pairing is present or not
    [Arguments]     ${device}
    ${status}     is_device_paired_to_panel       ${device}
    Pass Execution if    '${status}' == 'fail'    ${device}: Device pairing already got reset.

enable checkin toggle and select release time in panel
    [Arguments]     ${device}   ${release_time}
    verify room parameters    device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=on
    select release time for meeting        device=device_1        release_time=${release_time}

enable checkin notification toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin notification toggle button in panel          device=device_1              checkin_notification_state=on
    go back to homescreen from admin settings options   device=device_1

disable both checkin and checkin notification toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin notification toggle button in panel          device=device_1              checkin_notification_state=off
    go back to homescreen from admin settings options   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=off
    Come back to home screen    device_list=device_1

verify meeting already got cancelled
    [Arguments]     ${device}
    ${status}     is_meeting_got_cancelled_in_panel       ${device}
    Pass Execution if    '${status}' == 'pass'    ${device}: Meeting already got cancelled.

refresh meeting visibility for norden device
    [Arguments]    ${device}
    Refresh meeting visibility for conf device  ${device}

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}

end the rooms meeting if it is in connected state
    [Arguments]     ${device}
    ${status}     is_meeting_connected_in_norden       ${device}
    Run keyword if  '${status}' == 'fail'      End meeting     ${device}
    ...  ELSE   Log   ${device}: Meeting is not in connectd state.