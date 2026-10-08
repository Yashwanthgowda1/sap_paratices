*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown   Run Keywords   Suite Failure Capture   AND   enable show meeting name in panel     device=device_1

*** Test Cases ***
TC1:[Private meetings] User to verify the presence of "Meetings" option under Panels App settings
    [Tags]  307963   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2:[Private meetings] User to disable the "Show meeting names" option on the device
    [Tags]  307967   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verifying meeting name based on show meeting name status     device=device_1     toggle=on
    navigate to meetings option in panel app settings    device=device_1
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=off
    go back to homescreen from admin settings options   device=device_1
    navigate to meetings option in panel app settings    device=device_1
    enable or disable show meeting name toggle in panel        device=device_1      show_meeting_state=on
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3:[Private Meeting] Verify that while connecting meeting, meeting name must be displayed
    [Tags]  314127
    [Setup]  Testcase Setup   count=2
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    navigate to meetings option in panel app settings    device=device_1
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=off
    verifying meeting name based on show meeting name status     device=device_1     toggle=off
    verify room parameters    device=device_1
    join rooms meeting   device=device_2    meeting=Reserved
    Verify meeting state   device_list=device_2    state=Connected
    verify meeting name      device=device_2    meeting=Reserved
    [Teardown]  Run Keywords    Capture on Failure  AND    End meeting     device=device_2     AND      Verify meeting state    device_list=device_2   state=Disconnected  AND      navigate to meetings option in panel app settings    device=device_1     AND   enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=on    AND    Come back to home screen    device_list=device_1    AND     cancel the current reserved meeting     device=device_1

TC4:[Private meetings] Verify when user enable & disable "Show meeting names" toggle multiple times, changes must reflect accordingly
    [Tags]  307972   sanity     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    navigate to meetings option in panel app settings    device=device_1
    verifying meeting name based on show meeting name status     device=device_1     toggle=on
    navigate to meetings option in panel app settings    device=device_1
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=off
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=on
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=off
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=on
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=off
    Refresh calls main tab  device=device_1
    verifying meeting name based on show meeting name status     device=device_1     toggle=off
    navigate to meetings option in panel app settings    device=device_1
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=on
    Refresh calls main tab  device=device_1
    verifying meeting name based on show meeting name status     device=device_1     toggle=on
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1     AND     cancel the current reserved meeting     device=device_1

*** Keywords ***

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

wait and after timeout check homescreen
    [Arguments]     ${device}
     Wait for Some Time    time=30
     verify room parameters  device=device_1

cancel the current reserved meeting
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    checkout of the reserved meeting   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

Come back to panel home screen
    [Arguments]     ${device}
    device setting back  device=device_1
    come back to home screen   device_list=device_1

enable show meeting name in panel
    [Arguments]     ${device}
    navigate to meetings option in panel app settings    device=device_1
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=on
    go back to homescreen from admin settings options   device=device_1

Enable and validate room reservation toggle in panel
    [Arguments]     ${device}
    navigate to meetings option in panel app settings    device=device_1
    enable or disable room reservation toggle in panel    device=device_1      room_reservation_state=on
    validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=on
    Come back to home screen    device_list=device_1

Disable and validate room reservation toggle in panel
    [Arguments]     ${device}
    navigate to meetings option in panel app settings    device=device_1
    enable or disable room reservation toggle in panel    device=device_1      room_reservation_state=on
    validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=on
    Come back to home screen    device_list=device_1