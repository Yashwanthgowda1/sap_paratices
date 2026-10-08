*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${5_minutes_wait_time} =  5 minutes
${display_time} =  5

*** Test Cases ***
TC1:[Checkout and extend reservation] Verify checkout and extend reservation options are available under Meeting settings
    [Tags]   332648
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings       device=device_1
    verify presence of check out and extend reservation button in meetings      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   go back to homescreen from admin settings options   device=device_1

TC2:[Checkout and extend reservation] Verify User to enable the checkout and extend reservation in Meeting settings
    [Tags]   332712
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings       device=device_1
    verify presence of check out and extend reservation button in meetings      device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=on
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1      AND    Disable check out and extend room reservation toggles     device=device_1

TC3:[Teams Shared Devices License] [Checkout and extend reservation] Verify “Checkout” and “Extend reservation” are seen under Manage option
    [Tags]   332720
    [Setup]  Testcase Setup   count=2
    Verify homescreen on panel   device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    verify current or upcoming meetings displays on home screen    device=device_2
    Refresh calls main tab    device=device_2
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=Reserved
    Verify meeting state   device_list=device_2    state=Connected
    Enable check out and extend room reservation toggles     device=device_1
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    [Teardown]   Run Keywords   Capture on Failure    AND     End meeting       device=device_2       AND     Verify meeting state    device_list=device_2   state=Disconnected    AND   cancel the current reserved meeting   device=device_1    AND    Capture on Failure

TC4:[Checkout and extend reservation] Verify the room is available once the user checked out from the current meeting(Not Joined)
    [Tags]   332741
    [Setup]  Testcase Setup   count=2
    Verify homescreen on panel   device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    verify current or upcoming meetings displays on home screen    device=device_2
    Refresh calls main tab    device=device_2
    Refresh calls main tab    device=device_2
    Verify meeting display on home screen     device=device_2
    Verify meeting state   device_list=device_2    state=Disconnected
    Enable check out and extend room reservation toggles     device=device_1
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   cancel the current reserved meeting   device=device_1

TC5:[Checkout and extend reservation] Verify “Checkout” option in the panel is disabled if the MTRA is in a meeting.
    [Tags]   332721
    [Setup]  Testcase Setup   count=2
    Verify homescreen on panel   device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    Refresh calls main tab    device=device_2
    Refresh calls main tab    device=device_2
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=Reserved
    Verify meeting state   device_list=device_2    state=Connected
    Enable check out and extend room reservation toggles   device=device_1
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    verify state of extend room reservation or check out option on homescreen      device=device_1      option=check_out      state=disabled
    [Teardown]  Run Keywords    Capture on Failure  AND     End meeting   device=device_2   AND     Verify meeting state    device_list=device_2   state=Disconnected    AND   cancel the current reserved meeting   device=device_1

TC6:[Checkout and extend reservation] Verify Ready to check out? confirmation message is seen in the panel when user taps on check out from Manage option
    [Tags]   332740
    [Setup]  Testcase Setup   count=2
    Verify homescreen on panel   device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    Refresh calls main tab    device=device_2
    Refresh calls main tab    device=device_2
    Verify meeting display on home screen     device=device_2
    Verify meeting state   device_list=device_2    state=Disconnected
    Enable check out and extend room reservation toggles     device=device_1
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    checkout of the reserved meeting   device=device_1
    [Teardown]  Run Keywords    Capture on Failure     AND    Disable check out and extend room reservation toggles     device=device_1

TC7:[Checkout and extend reservation] Verify the user is able to extend the room reservation multiple times as a room organizer.
    [Tags]   332775
    [Setup]  Testcase Setup  count=2
    verify room parameters    device=device_1
    Enable check out and extend room reservation toggles     device=device_1
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1
    reserve room    device=device_1
    validate room availability status   device=device_1   status=reserved
    Refresh calls main tab    device=device_2
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=Reserved
    Verify meeting state   device_list=device_2    state=Connected
    extend room reservation from panel homescreen      device=device_1
    extend room reservation from panel homescreen      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     End meeting       device=device_2       AND     Verify meeting state    device_list=device_2   state=Disconnected    AND   cancel the current reserved meeting   device=device_1

TC8:[Checkout and extend reservation] Verify Panel user should be able to see the “Manage” option, in the current ongoing meeting.
    [Tags]   332719
    [Setup]  Testcase Setup   count=2
    verify room parameters    device=device_1
    validate room availability status   device=device_1   status=available
    Enable check out and extend room reservation toggles     device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    Refresh calls main tab  device=device_1
    Refresh calls main tab    device=device_2
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=Reserved
    Verify meeting state   device_list=device_2    state=Connected
    verify manage button on homescreen   device=device_1
    [Teardown]  Run Keywords    Capture on Failure     AND     End meeting       device=device_2       AND     Verify meeting state    device_list=device_2   state=Disconnected    AND   cancel the current reserved meeting   device=device_1

TC9:[Checkout and extend reservation] Verify “Extend Reservation” option is disabled if the room is extended again from the panel if the room is not reserved by the organizer
    [Tags]   332742        TDC_meeting_test
    [Setup]  Testcase Setup   count=2
    verify room parameters    device=device_1
    Enable check out and extend room reservation toggles   device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_23       time_duration=8 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    Refresh calls main tab    device=device_2
    refresh meeting visibility for norden device     device=device_2
    Verify meeting display on home screen     device=device_2
    join rooms meeting   device=device_2    meeting=panel_meeting_23
    Verify meeting state   device_list=device_2    state=Connected
    verify and click manage button on homescreen   device=device_1
    verify presence of check out and extend reservation button on homescreen    device=device_1
    extend room reservation from panel homescreen      device=device_1         meeting_type=outlook
    verify state of extend room reservation or check out option on homescreen      device=device_1      option=extend_rr        state=disabled
    [Teardown]  Run Keywords    Capture on Failure    AND    End meeting       device=device_2       AND     Verify meeting state    device_list=device_2   state=Disconnected   AND   delete all meetings from tdc     device=tdc_1:meeting_user      meeting_list=panel_meeting_23        AND   Wait for Some Time    time=${5_minutes_wait_time}   AND    cancel the current reserved meeting   device=device_1

TC10:[Checkout and extend reservation] Verify "Extended" text is displayed right after the meeting name when the current meeting is extended if the user is not the organizer
     [Tags]   332773        TDC_meeting_test
     [Setup]  Testcase Setup   count=2
     Verify homescreen on panel   device=device_1
     Enable check out and extend room reservation toggles     device=device_1
     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_24       time_duration=5 min       participants=device_1     use_current_time=True      roundup_end_time=off
     Refresh calls main tab    device=device_1
     Refresh calls main tab    device=device_2
     refresh meeting visibility for norden device     device=device_2
     Verify meeting display on home screen     device=device_2
     Verify meeting state   device_list=device_2    state=Disconnected
     verify and click manage button on homescreen   device=device_1
     verify presence of check out and extend reservation button on homescreen    device=device_1
     extend room reservation from panel homescreen      device=device_1      meeting_type=outlook
     Verify extended meeting title on panel homescreen      device=device_1       presence_status=present
     [Teardown]  Run Keywords    Capture on Failure     AND    Disable check out and extend room reservation toggles     device=device_1     AND     delete all meetings from tdc     device=tdc_1:meeting_user      meeting_list=panel_meeting_24       AND    checkout of the reserved meeting   device=device_1

TC11:[Checkout and extend reservation] Verify Extending the meeting, should always extend the original meeting invite
     [Tags]   332774        TDC_meeting_test
     [Setup]  Testcase Setup   count=2
     Verify homescreen on panel   device=device_1
     Enable check out and extend room reservation toggles   device=device_1
     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_25       time_duration=8 min       participants=device_1     use_current_time=True      roundup_end_time=off
     refresh main tab    device=device_1
     Refresh calls main tab    device=device_2
     refresh meeting visibility for norden device     device=device_2
     Verify meeting display on home screen     device=device_2
     join rooms meeting   device=device_2    meeting=panel_meeting_25
     Verify meeting state   device_list=device_2    state=Connected
     verify and click manage button on homescreen   device=device_1
     verify presence of check out and extend reservation button on homescreen    device=device_1
     extend room reservation from panel homescreen      device=device_1      meeting_type=outlook
     [Teardown]  Run Keywords    Capture on Failure      AND     End meeting       device=device_2       AND     Verify meeting state    device_list=device_2   state=Disconnected    AND     delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=panel_meeting_25        AND    Wait for Some Time    time=${5_minutes_wait_time}     AND   cancel the current reserved meeting   device=device_1

TC12:[Checkout and extend reservation] Verify “Extend Reservation” option is disabled if the room is not available after the current meeting.
     [Tags]   332739        TDC_meeting_test
     [Setup]  Testcase Setup   count=2
     verify room parameters    device=device_1
     Enable check out and extend room reservation toggles   device=device_1
     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meet1        time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
     create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=panel_meet2     time_duration=10 min       participants=device_1     consecutive_meeting=on
     Refresh calls main tab  device=device_1
     refresh meeting visibility for norden device     device=device_2
     Verify meeting display on home screen     device=device_2
     join rooms meeting   device=device_2    meeting=panel_meet1
     Verify meeting state   device_list=device_2    state=Connected
     verify and click manage button on homescreen   device=device_1
     verify presence of check out and extend reservation button on homescreen    device=device_1
     verify state of extend room reservation or check out option on homescreen      device=device_1      option=extend_rr        state=disabled
     verify state of extend room reservation or check out option on homescreen      device=device_1      option=check_out        state=disabled
     [Teardown]  Run Keywords    Capture on Failure     AND    End meeting       device=device_2       AND     Verify meeting state    device_list=device_2   state=Disconnected    AND    delete all meetings from tdc     device=tdc_1:meeting_user       meeting_list=panel_meet1,panel_meet2

*** Keywords ***

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

cancel the current reserved meeting
    [Arguments]     ${device}
    checkout of the reserved meeting   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=off
    go back to homescreen from admin settings options       device=device_1
    refresh main tab    device=device_1
    validate room availability status   device=device_1   status=available

Enable check out and extend room reservation toggles
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=on
    go back to homescreen from admin settings options       device=device_1

Disable check out and extend room reservation toggles
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=off
    go back to homescreen from admin settings options       device=device_1

refresh meeting visibility for norden device
    [Arguments]    ${device}
    Refresh meeting visibility for conf device  ${device}

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}