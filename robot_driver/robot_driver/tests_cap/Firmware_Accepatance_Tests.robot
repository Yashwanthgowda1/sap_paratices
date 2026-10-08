*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC 1:[Device Properties] Check firmware version
     [Tags]   261891         fw_cap    sanity_cap    bvt_cap
    [Setup]  Testcase Setup for CAP User   count=1
    Check device firmware version    device=device_1
    [Teardown]   Run Keywords   Capture on Failure

TC 2:[Build Verification] Firmware for production should be released signed.
    [Tags]      314149         fw_cap    sanity_cap    bvt_cap
    [Setup]  Testcase Setup for CAP User     count=1
    verify status of device firmware for production   device=device_1
    [Teardown]   Run Keywords   Capture on Failure

TC 3:[User Settings] User to reboot the device
    [Tags]      148741         fw_cap
    [Setup]  Testcase Setup for CAP User     count=1
    reboot phones    device=device_1
    Verify Home Screen Page    device=device_1
    [Teardown]   Run Keywords   Capture on Failure

TC 4:[Customer Readiness] ADB access to be disabled by default
    [Tags]      149383         fw_cap    sanity_cap    bvt_cap
    [Setup]  Testcase Setup for CAP User    count=1
    verify home screen UI for cap   device=device_1
    verify adb access is disabled for device
    [Teardown]     Run Keywords   Capture on Failure

*** Keywords ***