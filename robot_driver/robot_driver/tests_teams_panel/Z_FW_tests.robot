*** Settings ***
Force Tags    FW_tests   50
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Device settings] DUT user to check for service provider options in Device settings, User settings and Admin settings.
    [Tags]   401951     bvt   sanity	 bvt_panels     fw_panels     bvt_panels_pr     exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify service provider is absent       device=device_1
    verify device settings option in panel  device=device_1
    verify service provider is absent       device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    verify service provider is absent       device=device_1
    [Teardown]  Run Keywords     Capture on Failure  AND  Come back to home screen    device_list=device_1

TC2:[Device settings] User to reboot the device from Device settings
    [Tags]    307503    307641    307687    321645    321915    307411    341988    435547    bvt   sanity	 bvt_panels    fw_panels    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    reboot panel      device=device_1
    Testcase Setup   count=1
    Verify homescreen on panel   device=device_1
    [Teardown]  Run Keywords     Capture on Failure  AND  Come back to home screen    device_list=device_1

TC3:[Customer Readiness] ADB access to be disabled by default
    [Tags]   308015     bvt   sanity	 bvt_panels     fw_panels     smoke_panels
    verify adb access is disabled for device

TC4:[Admin settings] User to change admin password from Admin settings
    [Tags]  307435   sanity     fw_panels   exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigate and modify admin password for panel     device=device_1
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1     password_type=new
    Verify presence of Intents        device=device_1         feature=admin_pass_change         state=absent
    Come back to home screen    device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Navigate and reset admin password for panel     device=device_1

TC5:[Admin settings] User to change admin password from Admin settings
    [Tags]    321923    exclude_device_settings
    [Setup]  Testcase Setup   count=1
    Navigate and modify admin password for panel     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND  Come back to home screen    device_list=device_1    AND    Navigate and reset admin password for panel     device=device_1

*** Keywords ***

Navigate and modify admin password for panel
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    modify admin password in panel    device=device_1       status=set

Navigate and reset admin password for panel
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1    password_type=new
    modify admin password in panel    device=device_1       status=reset