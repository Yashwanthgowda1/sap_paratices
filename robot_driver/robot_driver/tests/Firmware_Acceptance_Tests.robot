*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 :[Device Properties] Check firmware version
     [Tags]   310452         fw_phones      exclude_ftp
    Check device firmware version    device=device_1

TC2 :[Build Verification] Firmware for production should be released signed.
    [Tags]      310862         fw_phones        exclude_ftp       sanity_tp    bvt_tp
    verify status of device firmware for production   device=device_1

TC3 :[Customer Readiness] ADB access to be disabled by default
    [Tags]      308476         fw_phones        exclude_ftp        sanity_tp    bvt_tp
    verify adb access is disabled for device

TC4 :[User Settings] User to reboot the device
    [Tags]      306792         fw_phones            exclude_ftp         sanity_tp    bvt_tp
    [Setup]  Testcase Setup     count=1
    reboot phones    device=device_1
    Verify home screen page     device=device_1
    [Teardown]   Run Keywords   Capture on Failure

TC5 : [Device settings] DUT user to check for service provider options in Device settings, User settings and Admin settings.
    [Tags]    402134    sanity_tp    bvt_tp    ftp_Scope
    [Setup]  Testcase Setup     count=1
    Open settings page   device=device_1
    verify service provider is absent       device=device_1
    Click device settings    device=device_1
    Wait for Some Time    time=2
    verify service provider is absent       device=device_1
    open admin settings     device=device_1
    verify service provider is absent in phones    device=device_1
    [Teardown]   Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

*** Keywords ***
