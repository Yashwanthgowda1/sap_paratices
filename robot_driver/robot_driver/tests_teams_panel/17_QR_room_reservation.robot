*** Settings ***

Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:Verify that the toggle " Allow room reservation sby QR code" is present under teams admin settings
	[Tags]   423510
	[Setup]  Testcase Setup   count=1
	navigate to meetings option in panel app settings    device=device_1
    verify presence of QR room reservation option in meetings    device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND    Come back to home screen    device_list=device_1

TC2:Verify that the DUT user is able to enable the toggle " Allow room reservation sby QR code" under teams admin settings
	[Tags]   423511
	[Setup]  Testcase Setup   count=1
	navigate to meetings option in panel app settings        device=device_1
    enable or disable QR code toggle button in meetings     device=device_1     status=on
    go back to homescreen from admin settings options       device=device_1
    verify QR Code on homescreen        device=device_1     state=present
	[Teardown]  Run Keywords    Capture on Failure      AND    Come back to home screen    device_list=device_1

TC3:Verify that the DUT user is able to disable the toggle " Allow room reservations by QR code" under teams admin settings
	[Tags]   423512
	[Setup]  Testcase Setup   count=1
	disable QR code toggle      device=device_1
	Refresh calls main tab  device=device_1
	verify QR Code on homescreen        device=device_1     state=absent
	[Teardown]  Run Keywords    Capture on Failure      AND        Come back to home screen    device_list=device_1     AND     enable QR code toggle       device=device_1

TC4:Verify that available main tile is still showing green reserve button when QR code is disappeared from home screen
	[Tags]   423513
	[Setup]  Testcase Setup   count=1
	disable QR code toggle      device=device_1
	Refresh calls main tab  device=device_1
	verify QR Code on homescreen        device=device_1     state=absent
    [Teardown]  Run Keywords    Capture on Failure       AND        Come back to home screen    device_list=device_1    AND     enable QR code toggle       device=device_1

TC5:Verify that DUT user is able to disable "Allow roome resrvations on device" and enable " Allow room reservations by QR code" under teams admin settings
	[Tags]   423514
	[Setup]  Testcase Setup   count=1
	navigate to meetings option in panel app settings    device=device_1
	verify presence of QR room reservation option in meetings    device=device_1
    verify room reservation toggle in panel    device=device_1
    disable room reservation toggle and QR code toggle
    verify QR Code on homescreen        device=device_1     state=absent
    navigate to meetings option in panel app settings        device=device_1
    enable or disable room reservation toggle in panel      device=device_1     room_reservation_state=on
    validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=on
    [Teardown]  Run Keywords    Capture on Failure        AND        Come back to home screen    device_list=device_1   AND     enable QR code toggle       device=device_1

TC6:Verify that no purple banner saying "Room reservations are disabled for this room" is displaying when "Allow room reservation" toggle is disabled
	[Tags]   423515
	[Setup]  Testcase Setup   count=1
	navigate to meetings option in panel app settings    device=device_1
	verify presence of QR room reservation option in meetings    device=device_1
    verify room reservation toggle in panel    device=device_1
    enable or disable room reservation toggle in panel      device=device_1     room_reservation_state=off
    validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=off
    verify QR Code on homescreen        device=device_1     state=present
    enable QR code toggle       device=device_1
    verify QR Code on homescreen        device=device_1     state=present
     navigate to meetings option in panel app settings        device=device_1
    enable or disable room reservation toggle in panel      device=device_1     room_reservation_state=off
    validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=off
    [Teardown]  Run Keywords    Capture on Failure        AND        Come back to home screen    device_list=device_1   AND     enabling room reservation toggle

TC7:Verify that purple banner saying "Room reservations are disabled for this room" is displaying when "Allow room reservation" and "Allow room reservations by QR code " are disabled
	[Tags]   423516
	[Setup]  Testcase Setup   count=1
	navigate to meetings option in panel app settings    device=device_1
	verify presence of QR room reservation option in meetings    device=device_1
    verify room reservation toggle in panel    device=device_1
    disable room reservation toggle and QR code toggle
    verify QR Code on homescreen        device=device_1     state=absent
    [Teardown]  Run Keywords    Capture on Failure        AND        Come back to home screen    device_list=device_1   AND     enabling room reservation toggle and QR code toggle

TC8:Verify that QR code is appeared in top left of home screen and scan to reserve underneath
	[Tags]   423008
	[Setup]  Testcase Setup   count=1
	navigate to meetings option in panel app settings    device=device_1
    verify presence of QR room reservation option in meetings    device=device_1
    go back to homescreen from admin settings options       device=device_1
    verify QR Code on homescreen        device=device_1     state=present
    [Teardown]  Run Keywords    Capture on Failure       AND        Come back to home screen    device_list=device_1

*** Keywords ***
navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

disable QR code toggle
	[Arguments]     ${device}
	navigate to meetings option in panel app settings        device=device_1
	enable or disable QR code toggle button in meetings     device=device_1     status=off
	go back to homescreen from admin settings options       device=device_1
	verify room parameters   device=device_1

enable QR code toggle
	[Arguments]     ${device}
	navigate to meetings option in panel app settings        device=device_1
	enable or disable QR code toggle button in meetings     device=device_1     status=on
	go back to homescreen from admin settings options       device=device_1
	verify room parameters   device=device_1

disable room reservation toggle and QR code toggle
	enable or disable QR code toggle button in meetings     device=device_1     status=off
	enable or disable room reservation toggle in panel      device=device_1     room_reservation_state=off
	validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=off

enabling room reservation toggle
	navigate to meetings option in panel app settings        device=device_1
	enable or disable room reservation toggle in panel      device=device_1     room_reservation_state=on
	validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=on

enabling room reservation toggle and QR code toggle
	 navigate to meetings option in panel app settings        device=device_1
     enable or disable QR code toggle button in meetings     device=device_1     status=on
     enable or disable room reservation toggle in panel      device=device_1     room_reservation_state=on
     validate room reservation toggle when enabled or disbaled       device=device_1           room_reservation_state=on
     verify room parameters   device=device_1
