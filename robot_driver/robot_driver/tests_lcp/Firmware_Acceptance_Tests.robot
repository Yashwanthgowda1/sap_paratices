*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  20


*** Test Cases ***
TC1 :[Device Properties] Check firmware version
    [Tags]   244313         fw_lcp    sanity_lcp    bvt_lcp
    Check device firmware version    device=device_1

TC2 :[Build Verification] Firmware for production should be released signed.
    [Tags]      244469         fw_lcp    sanity_lcp    bvt_lcp
    verify status of device firmware for production   device=device_1

TC3 :[Customer Readiness] ADB access to be disabled by default
    [Tags]      243655         fw_lcp    sanity_lcp    bvt_lcp
    verify adb access is disabled for device

TC4 :[CAP Policy] User SignIn intent
    [Tags]       459032    fw_lcp
    [Setup]  Testcase Setup for CAP User     count=1
    Sign Out    device_list=device_1
    Wait for Some Time    time=${wait_time}
    Sign In     device_list=device_1    user_list=cap_search_enabled
    Wait for Some Time    time=${wait_time}
    Verify Intents      device=device_1     intent=sign_in     user=cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 :[User Settings] User to reboot the device
    [Tags]      242952         fw_lcp    sanity_lcp    bvt_lcp
    [Setup]  Testcase Setup     count=1
    reboot phones    device=device_1
    verify ui post signin  device=device_1
    [Teardown]   Run Keywords   Capture on Failure

*** Keywords ***
