*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Run Keywords        Suite Failure Capture        AND        Enable app restart toggle button    device=device_1    status=off 

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 :[Auto Restart] DUT user to verify Auto Restart option in settings page.
    [Tags]   319491   P2
    [Setup]  Testcase Setup for Meeting User    count=1
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 :[Auto Restart] DUT user checks App Restart option disabled by default.
    [Tags]   319492   P2
    [Setup]  Testcase Setup for Meeting User    count=1
    verify app restart toggle button    device=device_1     toggle=off
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 :[Auto Restart] DUT user enables App Restart option.
    [Tags]    319493   P2
    [Setup]  Testcase Setup for Meeting User    count=1
    Enable app restart toggle button    device=device_1    status=on
    [Teardown]  Run Keywords    Capture on Failure   AND     Enable app restart toggle button    device=device_1    status=off    AND   Come back to home screen    device_list=device_1

TC4 :[Auto Restart] DUT user checks options present after enabling the App restart option.
    [Tags]   319494  P2
    [Setup]  Testcase Setup for Meeting User    count=1
    Enable app restart toggle button    device=device_1      status=on
    verify options after enabling auto restart toggle btn     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Enable app restart toggle button  device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC5 :[Auto Restart] DUT user disables the "Automatically" option.
    [Tags]   319495  P2
    [Setup]  Testcase Setup for Meeting User    count=1
    Enable app restart toggle button    device=device_1       status=on
    verify options after enabling auto restart toggle btn     device=device_1
    enable disable automatically toggle btn inside app restart      device=device_1
    verify options after disabling automatically toggle btn    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Enable app restart toggle button  device=device_1   status=off   AND   Come back to home screen    device_list=device_1

*** Keywords ***
Verify app restart toggle button
    [Arguments]     ${device}    ${toggle}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    verify app restart toggle   ${device}     ${toggle}

Enable app restart toggle button
    [Arguments]     ${device}     ${status}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    Click on toggle btn    ${device}      ${status}