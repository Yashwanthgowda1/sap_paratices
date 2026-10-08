*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Resource    resources/keywords/common.robot

*** Variables ***
${wait_time} =  10s

*** Test Cases ***
TC1: [Build Verification] Firmware for production should be released signed
    [Tags]    316716    sanity_tc_sm    bvt_tc_sm    exclude_ftp_sm
    verify status of device firmware for production     device=console_1

TC2: [Customer Readiness] ADB access to be disabled by default
    [Tags]    316715    bvt_tc_sm    sanity_tc_sm    exclude_ftp_sm
    verify adb access is disabled for device

TC3:[Version_Info] DUT user to check the apk version code & version name installed on DUT.
    [Tags]    468558    P2    exclude_ftp_sm
    check installed teams version    device=console_1

TC4:[Device settings] DUT user to check for service provider options in Device settings, User settings and Admin settings.
    [Tags]    401962    sanity_tc_sm    bvt_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to settings page  console=console_1
    verify service provider is absent       device=console_1
    Navigate to device settings page   console=console_1
    verify service provider is absent       device=console_1
    Come back from admin settings page    device_list=console_1
    Navigate to teams admin settings page    console=console_1
    verify service provider is absent       device=console_1
    come back from admin settings page   device_list=console_1
    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=console_1

TC5:[User Settings] User to reboot the DUT from phone settings
    [Tags]    315688    sanity_tc_sm    bvt_tc_sm    exclude_ftp_sm
    [Tags]    315688    sanity_tc_sm     bvt_tc_sm    exclude_ftp_sm    
    [Setup]  Testcase Setup for shared User    count=2
    Verify time display on home screen   console=console_1
    Reboot Norden Or Console        device=console_1    paired_devices=device_1
    Verify time display on home screen   console=console_1
    [Teardown]   Capture on Failure

*** Keywords ***
Navigate to settings page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Navigate to device settings page
    [Arguments]     ${console}
    Tap on device settings page     ${console}

Navigate to teams admin settings page
	[Arguments]     ${console}
	Tap on more option  ${console}
    Tap on settings page   ${console}
	Navigate to meeting and calling options from device settings page	${console}	meeting
