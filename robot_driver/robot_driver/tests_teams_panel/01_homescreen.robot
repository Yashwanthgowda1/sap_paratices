*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${Long_meeting_title} =  Meeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeetttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiinnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
${wait_time} =  10
${display_time} =  5

*** Test Cases ***
TC1:[Home screen] Home screen view after sign-in
    [Tags]  307137   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    [Teardown]  Capture on Failure

TC2:[Home screen] "Schedule Now" screen shall time out and return to home screen within 2 minutes
    [Tags]  307150  bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup  count=1
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1
    verify scheduling screen timeout  device=device_1
    validate room availability status   device=device_1   status=available
    [Teardown]  Capture on Failure

TC3:[Home screen] User to verify the meeting tiles in the agenda view of room's calendar on home screen
    [Tags]  307193
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    verify scrollable agenda view  device=device_1
    verify meeting details in scrollable agenda view  device=device_1
    [Teardown]  Capture on Failure

TC4:[Home screen] User to cancel the room reservation process
    [Tags]  307197   sanity     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1
    cancel room reservation  device=device_1
    validate room availability status   device=device_1   status=available
    [Teardown]  Capture on Failure

TC5:[Home screen] User to have maximum of two app icons on the home screen
    [Tags]  307238
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    [Teardown]  Capture on Failure

TC6:[Home screen] User to verify the meeting time in the agenda view of room's calendar
    [Tags]  307247
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    verify extensibility apps on homescreen  device=device_1
    verify scrollable agenda view  device=device_1
    verify meeting details in scrollable agenda view  device=device_1
    verify room availability to reserve  device=device_1
    [Teardown]  Capture on Failure

TC7:[Home screen] User to verify tapping on the meeting timeslots in the scrollable agenda view of room's calendar
    [Tags]  307256
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    verify extensibility apps on homescreen  device=device_1
    verify scrollable agenda view  device=device_1
    verify meeting details in scrollable agenda view  device=device_1
    tap on future meeting tiles and verify  device=device_1
    [Teardown]  Capture on Failure

TC8:[Adhoc Reservation Confirmation Dialog] Verify that the Adhoc Reservation Confirmation Dialog disappears after 4 seconds and text Dialog is not cut off
    [Tags]  322046
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    [Teardown]  Run Keywords    Capture on Failure  AND   cancel the current reserved meeting   device=device_1

TC9:[Home screen] Verify join option should not be present for the meetings scheduled for the panel from TDC
    [Tags]  307168     TDC_meeting_test       exclude_pairing      checkin_TC1
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    validate room availability status   device=device_1   status=available
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_1       time_duration=10 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    verify meeting name on panel homescreen    device=device_1     meeting=panel_meeting_1
    navigate to meetings option in panel app settings    device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=on
    go back to homescreen from admin settings options   device=device_1
    Wait for Some Time       time=${wait_time}
    verify presence of check in button on homescreen   device=device_1  presence_status=present
    [Teardown]  Run Keywords    Capture on Failure  AND    delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_1    AND    disable checkin toggle     device=device_1

TC10:[Calendar UX] Verify default screen UI on mid scroll (If user scrolls & walks away, modal should reset after 10 seconds)
    [Tags]  322228
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    verify scrollable agenda view  device=device_1
    verify meeting details in scrollable agenda view  device=device_1
    Wait for Some Time       time=${wait_time}
    validate room availability status   device=device_1   status=available
    [Teardown]  Capture on Failure

TC11:[Home screen] Verify that there are only availabilities when there are no meetings scheduled and meeting without title
    [Tags]  322053      TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=      time_duration=5 min       participants=device_1     use_current_time=True      roundup_end_time=off
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=(No Title)       count_of_other_meetings=1
    [Teardown]  Run Keywords    Capture on Failure   AND    delete all meetings from tdc     device=tdc_1:meeting_user      meeting_list=no_meeting_name

TC12:[Home screen] User to verify the "Check-in" button on the screen
     [Tags]   307158        TDC_meeting_test       exclude_pairing      checkin_TC1
     [Setup]  Testcase Setup   count=2
     navigate to meetings option in panel app settings       device=device_1
     enable or disable checkin toggle button in panel            device=device_1             state=on
     go back to homescreen from admin settings options   device=device_1
     create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_meeting_2       time_duration=5 min       participants=device_1     use_current_time=True      roundup_end_time=off
     Refresh calls main tab  device=device_1
     Refresh calls main tab    device=device_2
     verify meeting name on panel homescreen    device=device_1     meeting=panel_meeting_2
     Verify meeting display on home screen     device=device_2
     checkin into meeting from panel        device=device_1                  notification_appear=not_appear
     [Teardown]  Run Keywords    Capture on Failure      AND   delete all meetings from tdc     device=tdc_1:meeting_user   meeting_list=panel_meeting_2        AND      disable checkin toggle         device=device_1

TC13:[CHD][Chat] Validate that "chat" options should not be displayed on Panel
	[Tags]   322103
	[Setup]  Testcase Setup  count=1
	verify room parameters    device=device_1
	verify chat option is absent on homescreen        device=device_1
	[Teardown]  Run Keywords    Capture on Failure

TC14:[Home screen] User to verify the meeting time while reserving the room
    [Tags]   307185
    [Setup]  Testcase Setup  count=1
    verify room parameters    device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    [Teardown]  Run Keywords    Capture on Failure  AND   cancel the current reserved meeting   device=device_1

TC16:[Home screen] User to switch between the apps
    [Tags]  307213   sanity
    [Setup]  Testcase Setup   count=1
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1
    cancel room reservation  device=device_1
    # Temprorily commenting these test steps because Nearby Rooms app is not appearing on panel R0 accounts
#    verify nearby rooms app on panel homescreen      device=device_1
#    navigate inside nearby rooms app      device=device_1
#    navigate back to home screen from app      device=device_1
    [Teardown]   Run Keywords   Capture on Failure     AND    Come back to home screen    device_list=device_1   #navigate back to home screen from app      device=device_1

TC17:[Home screen] Verify meeting room name extended to next line when username is very big
    [Tags]  322006   bvt   sanity	 bvt_panels
    [Setup]  Testcase Setup for longname User for panel   count=1
    verify room parameters    device=device_1:longname_user
    verify long username on panel homescreen      device=device_1:longname_user
    [Teardown]  Capture on Failure

TC18:[Teams Shared Devices License] [Home screen] User to verify the meeting time while reserving the room
    [Tags]   342611    bvt   sanity	 bvt_panels    bvt_panels_pr    smoke_panels
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    verify scrollable agenda view  device=device_1
    verify meeting details in scrollable agenda view  device=device_1
    Wait for Some Time       time=${wait_time}
    validate room availability status   device=device_1   status=available
    [Teardown]  Run Keywords    Capture on Failure    AND    Refresh calls main tab  device=device_1

*** Keywords ***
navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

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

disable checkin toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable checkin toggle button in panel            device=device_1             state=off
    go back to homescreen from admin settings options       device=device_1

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}
