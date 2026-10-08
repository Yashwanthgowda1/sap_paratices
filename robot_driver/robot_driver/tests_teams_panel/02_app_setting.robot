*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown   Run Keywords   Suite Failure Capture   AND   enable show meeting name in panel     device=device_1

*** Test Cases ***
TC1:[App settings] User to have settings icon on the home screen
    [Tags]  307277
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2:[App settings] User to verify App settings page
    [Tags]  307287   sanity     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify all options in panel settings  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3:[App settings] User to report an issue from App Settings
    [Tags]  307291   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify report an issue in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4:[App settings] User to verify the about section from App settings page
    [Tags]  307303   sanity     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify about option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5:[App settings] User to verify Device settings page
    [Tags]  307311   sanity     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   device setting back  device=device_1   AND   come back to home screen   device_list=device_1

TC6:[Disable Room Reservation] Verify disable room reservations option in meetings
    [Tags]  333201
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verify room reservation toggle in panel    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7:[Disable Room Reservation] Verify disable room reservations option toggle button is enabled by default.
    [Tags]  333203
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verify room reservation toggle in panel is on    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8:[Disable Room Reservation] Verify home screen when disable room reservation is turned ON.
    [Tags]  333209
    [Setup]  Testcase Setup   count=1
    Enable and validate room reservation toggle in panel        device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9:[Disable Room Reservation] Verify home screen when disable room reservation is turned OFF.
    [Tags]  333210
    [Setup]  Testcase Setup   count=1
    Disable and validate room reservation toggle in panel     device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND    Enable and validate room reservation toggle in panel        device=device_1

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