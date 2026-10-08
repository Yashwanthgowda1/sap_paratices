*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1: [Auto Restart] DUT user checks options present after enabling the App restart option.
    [Tags]  452457      sanity_lcp      phonesCY23_4
    [Setup]  Testcase Setup     count=1
    Enable app restart toggle button    device=device_1      status=on
    verify options after enabling auto restart toggle btn     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable app restart toggle button   device=device_1   status=off  AND   Come back to home screen    device_list=device_1

TC2: [Auto restart] Verify user should be able to enable/disable toggle button of App restart.
    [Tags]  452565      sanity_lcp      phonesCY23_4
    [Setup]  Testcase Setup     count=1
    Enable app restart toggle button    device=device_1      status=on
    verify options after enabling auto restart toggle btn     device=device_1
    Disable app restart toggle button   device=device_1   status=off
    verify options after disabling auto restart toggle btn      device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND   Come back to home screen    device_list=device_1

TC 3: [Auto Restart] DUT user disables the "Automatically" option.
    [Tags]      452459
    [Setup]  Testcase Setup  count=1
    Enable app restart toggle button    device=device_1       status=on
    verify options after enabling auto restart toggle btn     device=device_1
    enable disable automatically toggle btn inside app restart      device=device_1
    verify options after disabling automatically toggle btn    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1


*** Keywords ***

Enable app restart toggle button
    [Arguments]     ${device}     ${status}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    Click on toggle btn    ${device}      ${status}

Disable app restart toggle button
    [Arguments]     ${device}     ${status}
    return to home screen   ${device}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    Click on toggle btn    ${device}      ${status}

Verify app restart toggle button
    [Arguments]     ${device}    ${toggle}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    verify app restart toggle   ${device}     ${toggle}