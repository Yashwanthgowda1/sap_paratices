*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup    Run Keywords     Testcase Setup for CAP User for panel   count=1     AND      Enable check out and extend room reservation toggles     device=device_1
Suite Teardown  Run Keywords    disable both checkout and extend room reservation toggles     device=device_1       AND     Suite Failure Capture

*** Variables ***
${5_minutes_wait_time} =  5 minutes
${8_minutes_wait_time} =  8 minutes

*** Test Cases ***
TC1:[Teams Shared Devices License] [Checkout and extend reservation] Verify checkout and extend reservation options are available under Meeting settings
     [Tags]   342038
     [Setup]  Testcase Setup for CAP User for panel  count=1
     navigate to meetings option in panel app settings       device=device_1
     verify presence of check out and extend reservation button in meetings      device=device_1
     [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC2:[Teams Shared Devices License] [Checkout and extend reservation] Verify Ready to check out? confirmation message is seen in the panel when user taps on check out from Manage option
    [Tags]   342044
    [Setup]  Testcase Setup for CAP User for panel   count=1
    verify room parameters    device=device_1:cap_user
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1:cap_user
    reserve room    device=device_1:cap_user
    validate room availability status   device=device_1   status=reserved
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    checkout of the reserved meeting   device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND     Come back to home screen    device_list=device_1

TC3:[Teams Shared Devices License] [Checkout and extend reservation] Verify the room is available once the user checked out from the current meeting(Not Joined)
    [Tags]   342045
    [Setup]  Testcase Setup for CAP User for panel  count=1
    verify room parameters    device=device_1:cap_user
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1:cap_user
    reserve room    device=device_1:cap_user
    validate room availability status   device=device_1   status=reserved
    verify manage button on homescreen   device=device_1
    cancel the current reserved meeting   device=device_1
    [Teardown]    Run Keywords    Capture on Failure      AND    teardown cancel the current reserved meeting   device=device_1

TC4:[Teams Shared Devices License] [Checkout and extend reservation] Verify “Checkout” and “Extend reservation” are seen under Manage option
    [Tags]   342041        TDC_meeting_test
    [Setup]  Testcase Setup for CAP User for panel   count=1
    verify room parameters    device=device_1:cap_user
    validate room availability status   device=device_1   status=available
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_attendee_meeting1     time_duration=10 min       participants=device_1:cap_user     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    verify presence of single meeting in panel    device=device_1    state=present    meeting=panel_attendee_meeting1
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND   delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_attendee_meeting1

TC5:[Teams Shared Devices License] [Checkout and extend reservation] Verify "Extended" text is displayed right after the meeting name when the current meeting is extended if the user is not the organizer
    [Tags]   342047        TDC_meeting_test
    [Setup]  Testcase Setup for CAP User for panel   count=1
    verify room parameters    device=device_1:cap_user
    validate room availability status   device=device_1   status=available
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_attendee_meeting2     time_duration=10 min       participants=device_1:cap_user     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    verify presence of single meeting in panel    device=device_1    state=present    meeting=panel_attendee_meeting2
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    extend room reservation from panel homescreen      device=device_1:cap_user        meeting_type=outlook
    [Teardown]  Run Keywords    Capture on Failure       AND      delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_attendee_meeting2     AND   cancel the current reserved meeting   device=device_1

TC6:[Teams Shared Devices License] [Checkout and extend reservation] Verify Extending the meeting, should always extend the original meeting invite
    [Tags]   342048
    [Setup]  Testcase Setup for CAP User for panel   count=1
    verify room parameters    device=device_1:cap_user
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1:cap_user
    reserve room    device=device_1:cap_user
    validate room availability status   device=device_1   status=reserved
    extend room reservation from panel homescreen      device=device_1:cap_user
    [Teardown]  Run Keywords    Capture on Failure      AND     cancel the current reserved meeting   device=device_1

TC7:[Teams Shared Devices License] [Checkout and extend reservation] Verify the user is able to extend the room reservation multiple times as a room organizer.
    [Tags]   342049
    [Setup]  Testcase Setup for CAP User for panel   count=1
    verify room parameters    device=device_1:cap_user
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1:cap_user
    reserve room    device=device_1:cap_user
    validate room availability status   device=device_1   status=reserved
    extend room reservation from panel homescreen      device=device_1:cap_user
    extend room reservation from panel homescreen      device=device_1:cap_user
    [Teardown]  Run Keywords    Capture on Failure    AND   cancel the current reserved meeting   device=device_1

TC8:[Teams Shared Devices License] [Checkout and extend reservation] Verify “Extend Reservation” option is disabled if the room is extended again from the panel if the room is not reserved by the organizer
    [Tags]   342046       TDC_meeting_test
    [Setup]  Testcase Setup for CAP User for panel   count=1
    verify room parameters    device=device_1:cap_user
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_26       time_duration=8 min       participants=device_1:cap_user     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    extend room reservation from panel homescreen      device=device_1:cap_user       meeting_type=outlook
    verify state of extend room reservation or check out option on homescreen      device=device_1      option=extend_rr        state=disabled
    [Teardown]  Run Keywords    Capture on Failure     AND     checkout of the reserved meeting     device=device_1       AND     Wait for Some Time    time=${5_minutes_wait_time}    AND      cancel the current reserved meeting   device=device_1       AND        disable both checkout and extend room reservation toggles     device=device_1

TC9:[Teams Shared Devices License] [Checkout and extend reservation] Verify User to enable the checkout and extend reservation in Meeting settings
    [Tags]   342039
    [Setup]  Testcase Setup for CAP User for panel  count=1
    navigate to meetings option in panel app settings       device=device_1
    verify presence of check out and extend reservation button in meetings      device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=on
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1      AND    disable both checkout and extend room reservation toggles     device=device_1

*** Keywords ***

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

disable both checkout and extend room reservation toggles
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=off
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

cancel the current reserved meeting
    [Arguments]     ${device}
    Come back to home screen    device_list=device_1
    checkout of the reserved meeting   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

Enable check out and extend room reservation toggles
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=on
    go back to homescreen from admin settings options       device=device_1

refresh meeting visibility for norden device
    [Arguments]    ${device}
     Refresh meeting visibility for conf device  ${device}

verify meeting already got cancelled
    [Arguments]     ${device}
    ${status}     is_meeting_got_cancelled_in_panel       ${device}
    Pass Execution if    '${status}' == 'pass'    ${device}: Meeting already got cancelled.

teardown cancel the current reserved meeting
    [Arguments]     ${device}
    verify meeting already got cancelled       device=device_1
    checkout of the reserved meeting   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}
