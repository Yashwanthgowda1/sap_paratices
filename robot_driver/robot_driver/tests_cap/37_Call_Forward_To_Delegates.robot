*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Setup      enable call forwoding display on home screen        device=device_1:cap_search_enabled
Suite Teardown    run keywords      Suite Failure Capture       AND     verify and set call forwarding on home screen       device=device_1        option=off


*** Variables ***
${wait_time} =  10
${wait_time2} =  20

*** Test Cases ***
TC1 : [Call forward on home screen] Verify that DUT user call should be forwarded to delegates, When DUT user selects Forward to my delegates from the Call forwarding section on Home screen.
    [Tags]      452451          phonesCY23_4         sanity_cap     bvt_cap
    [Setup]    Testcase Setup for CAP Delegate User    count=3
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    Click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_2     status=appear
    Verify incoming call    device=device_1     status=disappear
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure      AND        dismiss call forwarding pop up on home screen       device=device_1      AND     Come back to home screen    device_list=device_1,device_2,device_3


*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

enable call forwoding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=on

disable call forwoding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=off
