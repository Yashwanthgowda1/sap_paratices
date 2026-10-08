*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:Verify New State on the panel home screen
    [Tags]   534404     P2
    [Setup]  Teams Panel along with Rooms Setup
    Verify homescreen on panel      device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available
    verify meet info     device=device_2
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=occupied
    Disconnect call     device=device_2
    validate room availability status   device=device_1   status=available
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC2:Verify "Allow occupied state" Teams admin setting
    [Tags]   534406    P1    sanity
    [Setup]  Teams Panel along with Rooms Setup
    Verify homescreen on panel      device=device_1
    navigate to device settings options inside panel admin settings   device=device_1
    verify occupied state under device setting        device=device_1
    verify occupied toggle    device=device_1    status=on
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC3:Verify Room reservation when panel/room is in occupied state
    [Tags]   534405    P0    bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Teams Panel along with Rooms Setup
    Verify homescreen on panel      device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available
    verify meet info     device=device_2
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=occupied
    check details on scheduling screen  device=device_1
    reserve room    device=device_1
    validate room availability status   device=device_1   status=reserved
    Disconnect call     device=device_2
    [Teardown]  Run Keywords    Capture on Failure    AND    cancel the current reserved meeting   device=device_1   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC4:Verify Panel state when MTR joins a call or meeting that was already on the schedule
    [Tags]   534410   P1    sanity
    [Setup]  Teams Panel along with Rooms Setup
    validate room availability status   device=device_1   status=available
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=test_meeting       time_duration=15 min       participants=device_1     use_current_time=True      roundup_end_time=off
	Refresh calls main tab    device=device_1
	verify presence of single meeting in panel    device=device_1   state=present    meeting=test_meeting
    Refresh calls main tab    device=device_2
    Verify meeting display on home screen     device=device_2
    Join the meeting
    verify occupied state should not present on home screen       device=device_1
    Disconnect the call on TDC      device=tdc_1:meeting_user
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing     AND     delete meeting     edit_meeting_name=test_meeting

TC5:Verify Panel state as occupied when MTRA start whiteboard
    [Tags]   534411   P2
    [Setup]  Teams Panel along with Rooms Setup
    validate room availability status   device=device_1   status=available
    verify Start meeting and verify Whiteboard launch    device=device_2
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=occupied
    Disconnect call     device=device_2
    validate room availability status   device=device_1   status=available
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC6:Verify "Send booking notifications" Settings
    [Tags]   534407   P1    sanity
    [Setup]  Teams Panel along with Rooms Setup
    Verify homescreen on panel      device=device_1
    navigate to device settings options inside panel admin settings   device=device_1
    verify occupied state under device setting        device=device_1
    enable or disable booking notification label toggle    device=device_1    booking_notification_state=on
    enable or disable booking notification label toggle    device=device_1    booking_notification_state=off
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC7:Verify "someone is waiting for the room" notifications
    [Tags]   534408   P0    bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Teams Panel along with Rooms Setup
    Verify homescreen on panel      device=device_1
    navigate to device settings options inside panel admin settings   device=device_1
    verify occupied state under device setting        device=device_1
    verify occupied toggle    device=device_1    status=on
    enable or disable booking notification label toggle    device=device_1    booking_notification_state=on
    Come back to home screen    device_list=device_1
    verify meet info     device=device_2
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=occupied
    check details on scheduling screen  device=device_1
    reserve room    device=device_1
    validate room availability status   device=device_1   status=reserved
    verify meeting warning notification on norden    device=device_2
    Disconnect call     device=device_2
    Verify meeting state    device_list=device_2    state=Disconnected
    navigate to device settings options inside panel admin settings   device=device_1
    enable or disable booking notification label toggle    device=device_1    booking_notification_state=off
    Come back to home screen    device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    cancel the current reserved meeting   device=device_1   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

*** Keywords ***

Teams Panel along with Rooms Setup
    Testcase Setup  count=2
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1

Reset device pairing
    navigate to device pairing option in panel app settings  device=device_1     pair_status=paired
    reset device pairing in panel  device=device_1

navigate to device pairing option in panel app settings
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing tab on panel     device=device_1     pair_status=${pair_status}

Pair Panel and Rooms device
    navigate to device pairing option in panel app settings   device=device_1    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    get pairing code from rooms device    from_device1=device_2  to_device1=device_1

navigate to device settings options inside panel admin settings
    [Arguments]    ${device}
    Navigation to settings page in panel      device=${device}
    verify device settings option in panel      device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    navigate to device settings tab in admin setting     device=${device}

Join the meeting
    right click on created meeting from tdc       tdc_1:meeting_user    edit_meeting_name=test_meeting   click=left
    join the meeting in TDC     device=tdc_1:meeting_user

delete meeting
    [Arguments]    ${edit_meeting_name}
    right click on created meeting from tdc       tdc_1:meeting_user     edit_meeting_name=${edit_meeting_name}
    delete meeting from tdc     tdc_1:meeting_user 

cancel the current reserved meeting
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=${device}
    enable or disable check out toggle btn in panel         device=${device}       checkout_toggle_status=on
    Come back to home screen    device_list=${device}
    checkout of the reserved meeting   device=${device}
    navigate to meetings option in panel app settings       device=${device}
    enable or disable check out toggle btn in panel         device=${device}       checkout_toggle_status=off
    go back to homescreen from admin settings options   device=${device}
    Refresh calls main tab  device=${device}
    validate room availability status   device=${device}   status=available

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=${device}
    verify device settings option in panel  device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    go to meetings tab in panel     device=${device}