*** Settings ***
Force Tags    Light_weight_stage       57
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

# Light weight stage feature removed from U3-2023
*** Test Cases ***
#TC 1: [Light weight stage] Verify lightweight calling experience from DUT
#    [Tags]  334063  P2
#    [Setup]  Testcase Setup  count=1
#    verify lightweight calling experience toggle enabled by default  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1
#
#TC 2: [Lightweight stage] Verify Disabling light weight call experience
#    [Tags]  334108  P2
#    [Setup]  Testcase Setup  count=2
#    navigate to lightweight calling experience  device=device_1
#    disable lightweight calling experience   device=device_1
#    Come back to home screen    device_list=device_1
#    make outgoing call using display name   from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify calling ui at lightweight calling experience is disabled  device=device_1
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure   AND   teardown lightweight calling experience  device=device_1

*** Keywords ***
teardown lightweight calling experience
    [Arguments]     ${device}
    come back to home screen    device_list=${device}
    navigate to lightweight calling experience  device=${device}
    enable lightweight calling experience   device=${device}
    come back to home screen  device_list=${device}

