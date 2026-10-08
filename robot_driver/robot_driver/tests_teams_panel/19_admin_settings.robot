*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Admin Settings] Admin settings are password protected in the DUT
    [Tags]  325639  bvt   sanity	 bvt_panels     bvt_panels_pr   exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2:[Admin settings] User to access Panel App settings from Admin settings
    [Tags]  307429   sanity
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3:[Admin Settings] Verify Wallpaper option under teams admin setting.
    [Tags]  321274
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to background tab in panel     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4:[Admin settings] User to verify the intent for Panel App settings access
    [Tags]  307432   sanity    bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    Verify presence of Intents        device=device_1         feature=panel_app_settings         state=absent
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to panel home screen    device=device_1

TC5:[Admin settings] User to verify display settings from Admin settings
	[Tags]  307391      exclude_device_settings
	[Setup]  Testcase Setup  count=1
	Verify homescreen on panel   device=device_1
    Navigation to settings page in panel  device=device_1
    verify display settings option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6:[Admin Settings] User to verify the options behind the Admin settings
	[Tags]  307380   sanity     bvt_panels_pr
	[Setup]  Testcase Setup  count=1
	Verify homescreen on panel   device=device_1
	Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7:[Admin settings] User to sign-out of Teams from Admin settings
    [Tags]    307437
    [Setup]  Testcase Setup   count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1  AND     sign in method     device_1

TC8:[Admin settings] User to verify network settings from Admin settings
    [Tags]    307424    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    verify network option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9:[Admin Settings] User to verify network configuration settings from Admin settings
    [Tags]    307421    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    verify network option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10:[Admin settings]User to verify debug option from Admin settings
    [Tags]    307413    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify debug option in panel  device=device_1
    [Teardown]  Run Keywords     Capture on Failure  AND  Come back to home screen    device_list=device_1

TC11:[Admin settings] User to change time and date settings from Admin settings
    [Tags]    307385    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    Navigate and modify time format to 24hr in panel admin settings    device=device_1
    fetch and validate time format inside or outside app       device=device_1     time_format=24hr     app_state=outside
    [Teardown]  Run Keywords     Capture on Failure     AND    Navigate and modify time format to 12hr in panel admin settings    device=device_1      AND      fetch and validate time format inside or outside app       device=device_1     time_format=12hr     app_state=outside

TC12:[Admin Settings] Admin password should be masked
    [Tags]    339838    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    Verify presence of Intents        device=device_1         feature=admin_password         state=absent
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to panel home screen    device=device_1

*** Keywords ***

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

Navigate and modify admin password for panel
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    modify admin password in panel    device=device_1       status=set

Navigate and reset admin password for panel
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    modify admin password in panel    device=device_1       status=reset

Come back to panel home screen
    [Arguments]     ${device}
    device setting back  device=device_1
    come back to home screen   device_list=device_1

Navigate and modify time format to 24hr in panel admin settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    Navigate and change time and date in admin settings for panel   device=device_1   time_format=24hr
    go back to homescreen from admin settings options   device=device_1

Navigate and modify time format to 12hr in panel admin settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    Navigate and change time and date in admin settings for panel     device=device_1     time_format=12hr
    go back to homescreen from admin settings options   device=device_1