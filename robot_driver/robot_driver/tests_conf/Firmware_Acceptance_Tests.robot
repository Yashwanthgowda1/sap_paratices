*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 :[Device Properties] Check firmware version
     [Tags]   310452         fw_conf    exclude_ftp
    Check device firmware version    device=device_1

TC2 :[Build Verification] Firmware for production should be released signed.
    [Tags]      314154         fw_conf    sanity_tpc    bvt_tpc
    verify status of device firmware for production   device=device_1

TC3 :[User Settings] User to reboot the device
    [Tags]      305797         fw_conf    sanity_tpc    bvt_tpc
    [Setup]  Testcase Setup for Meeting User     count=1
    reboot phones    device=device_1
    Verify Home Screen Page    device=device_1
    [Teardown]    Capture on Failure

TC4 :[Customer Readiness] ADB access to be disabled by default
    [Tags]      305950         fw_conf    sanity_tpc    bvt_tpc
    verify adb access is disabled for device
    
*** Keywords ***