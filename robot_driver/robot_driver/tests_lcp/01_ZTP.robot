*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup  ZTP Setup
Suite Teardown  Run keywords    Suite Failure Capture   AND     Signin method for lcp    device=device_1

*** Test Cases ***
TC1: [Sign-in] User to sign-in from another device (web sign-in) with DCF code
    [Tags]  250060     bvt_lcp      sanity_lcp    auth_lcp    auth_lcp_p0
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify ztp signin ui on lcp  device=device_1
    [Teardown]  Capture on Failure

TC2: [Sign-in] DUT Sign-in options
    [Tags]  250057    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    [Teardown]  Capture on Failure

TC3: [Sign-in] For LCP devices , Sign-in on this device must be disabled/hidden
    [Tags]  250062      sanity_lcp    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    verify sign in on the device is disabled    device=device_1
    [Teardown]  Capture on Failure

TC4: [ZTP]Teams app user can access the device setting from Sign in page
    [Tags]  320269    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    verify signin ui on lcp  device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC5: [Sign-in] Selecting cloud option to provisioning the phone
    [Tags]  250088    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    verify settings from signin page    device=device_1
    verify cloud option for provisioning lcp device    device_1
    Device setting back     device=device_1
    verify signin ui on lcp  device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC6: [CP Enrollment] No blocking GUI
    [Tags]  250069    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    [Teardown]  Capture on Failure

TC7: [ZTP][Sign-in] For provisioning the phone, DUT needs to show UI to enter verification code
    [Tags]  250098      sanity_lcp    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    verify settings from signin page    device=device_1
    Verify provision phone option lcp    device_1
    Device setting back     device=device_1
    verify signin ui on lcp  device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC8: Teams app should come back on Sign in screen when tap on back button from Provision Phone
    [Tags]  321133    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    verify settings from signin page    device=device_1
    Verify provision phone option lcp    device_1
    Device setting back     device=device_1
    verify signin ui on lcp  device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

TC9: [ZTP]Teams app should come back on sign in screen when tap on back button from device settings screen
    [Tags]  321144    auth_lcp
    [Setup]  Testcase Setup for LCP ZTP  count=1
    verify signin ui on lcp  device=device_1
    verify settings from signin page    device=device_1
    click on device settings page     device=device_1
    Device setting back     device=device_1
    verify signin ui on lcp  device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

*** Keywords ***
ZTP Setup
    sign out method  device_1

verify cloud option for provisioning lcp device
    [Arguments]    ${device}
    verify cloud option    ${device}

Verify provision phone option lcp
    [Arguments]    ${device}
    verify provision phone ui    ${device}