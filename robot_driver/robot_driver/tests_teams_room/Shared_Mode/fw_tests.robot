*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot
*** Variables ***
${wait_time} =  10s
*** Test Cases ***
TC1: [Build Verification] Firmware for production should be released signed
    [Tags]  312645     312645    sanity_sm       bvt_sm    exclude_ftp_sm
    verify status of device firmware for production   device=device_1

TC2: [Customer Readiness] ADB access to be disabled by default
    [Tags]   304817    bvt_sm    sanity_sm    exclude_ftp_sm
    verify adb access is disabled for device

TC3:[Version_Info] DUT user to check the apk version code & version name installed on DUT.
    [Tags]      456308     P2    exclude_ftp_sm
    check installed teams version    device=device_1

TC4:[Device settings] DUT user to check for service provider options in Device settings, User settings and Admin settings.
    [Tags]  401951      bvt_sm      sanity_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    Navigate to app settings page  device=device_1
    verify service provider is absent       device=device_1
    click on device settings page   device=device_1
    verify service provider is absent       device=device_1
    come back from admin settings page      device_list=device_1
    navigate to teams admin settings page    device=device_1
    verify service provider is absent       device=device_1
    come back from admin settings page   device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1

TC5:[User Settings] User to reboot the DUT from device settings
    [Tags]      304756      bvt_sm      sanity_sm
    [Setup]     Testcase Setup for Meeting User     count=1
    Verify home page screen    device=device_1
    Reboot Norden Or Console        device=device_1
    Verify home page screen    device=device_1
    [Teardown]   Capture on Failure

TC6:[Device Settings] After rebooting DUT should not ask to change service provider.
    [Tags]      324521      bvt_sm      sanity_sm
    [Setup]     Testcase Setup for Meeting User     count=1
    Navigate to app settings page  device=device_1
    click on device settings page   device=device_1
    verify service provider is absent       device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

TC7:[Service Provider][CMD Prompt] DUT user to verify the presence of service provider packages when device in Teams mode
    [Tags]      472830          sanity_sm    P1
    verify presence of service provider packages    device=device_1
