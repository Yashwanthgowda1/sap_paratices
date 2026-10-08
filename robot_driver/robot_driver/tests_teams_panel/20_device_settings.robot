*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Test Cases ***
TC1:[Device settings] User to access Panel App settings from Admin settings
    [Tags]  321921   sanity    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2:[Device settings] User to sign out from App settings
    [Tags]  321926    exclude_device_settings
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1  AND     sign in method     device_1

TC3:[Device settings] User to verify the options under accessibility settings
    [Tags]  307331  bvt   sanity	 bvt_panels     bvt_panels_pr    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    verify accessibility settings option in panel       device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4:[Device settings] User to verify display settings from Admin settings
	[Tags]  321910    exclude_device_settings
	[Setup]  Testcase Setup  count=1
	Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    verify display settings option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5:[Device Settings] User to verify the device info from "about" option in Device settings
	[Tags]  307374    exclude_device_settings
	[Setup]  Testcase Setup  count=1
	Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    verify device info in about for panel       device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6:[Device Settings] User to verify the options behind the Admin settings
    [Tags]  321652    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7:[Device settings] User to verify Device settings page
    [Tags]  321644    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8:[Device settings] Admin only settings are password protected
    [Tags]  307376    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9:[Device settings] Accessibility settings should be disabled by default
    [Tags]  307319    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    verify accessibility settings option in panel       device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10:[Device settings] User to verify wi-fi settings from Admin settings
    [Tags]    321914    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    verify network option in panel    device=device_1
    verify wifi option inside network settings is off    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11:[Device settings] User to verify the intent for Panel App settings access
    [Tags]  321922    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    Verify presence of Intents        device=device_1         feature=panel_app_settings         state=present
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to panel home screen    device=device_1

TC12:[Device settings] User to verify network settings from Admin settings
    [Tags]  321920    exclude_device_settings
    [Setup]  Testcase Setup   count=1
     Verify homescreen on panel   device=device_1
     Navigation to settings page in panel  device=device_1
     verify device settings option in panel  device=device_1
     verify network option in panel     device=device_1
     [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC13:[Device Settings] User to verify network configuration settings from Admin settings
     [Tags]  321919    exclude_device_settings
     [Setup]  Testcase Setup   count=1
     Verify homescreen on panel   device=device_1
     Navigation to settings page in panel  device=device_1
     verify device settings option in panel  device=device_1
     verify network option in panel    device=device_1
     verify network configuration option in panel   device=device_1
     [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

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