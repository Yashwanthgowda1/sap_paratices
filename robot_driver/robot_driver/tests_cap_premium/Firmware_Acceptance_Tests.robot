*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 :[Device Properties] Check firmware version
     [Tags]   448528         fw_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User  count=1
    Check device firmware version    device=device_1
    [Teardown]   Run Keywords   Capture on Failure

TC2 :[Build Verification] Firmware for production should be released signed.
    [Tags]      448659         fw_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User     count=1
    verify status of device firmware for production   device=device_1
    [Teardown]   Run Keywords   Capture on Failure

TC3 :[User Settings] User to reboot the device
    [Tags]      447501         fw_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=1
    reboot phones    device=device_1
    Verify Home Screen Page    device=device_1
    [Teardown]   Run Keywords   Capture on Failure

TC4 :[Customer Readiness] ADB access to be disabled by default
    [Tags]     447878         fw_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=1
    verify home screen tiles       device=device_1      device_type=cap_home_screen_enabled
    verify adb access is disabled for device
    [Teardown]     Run Keywords   Capture on Failure

*** Keywords ***