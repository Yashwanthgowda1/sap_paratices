#*** Settings ***
#Documentation   Personal Mode
#Force Tags    pm_esc_to_conf       pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  10
#
#*** Test Cases ***
#TC1: [Esc to conference] Check participant's profile while adding to the call
#    [Documentation]  Tested for DUT only
#    [Tags]   215145   P2
#    [Setup]  Testcase Setup     count=3
#    Make Video call using display name   from_device=device_3     to_device=device_1
#    Accept incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify participant list    from_device=device_1      connected_device_list=device_1,device_2,device_3
#    Check participants profile view   device=device_1
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC2: [Escalate to conference] DUT user can add another DUT user while in call with TDC user
#    [Tags]   194921    sanity_pm
#    [Setup]   Testcase Setup   count=3
#    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name    from_device=device_1      to_device=device_3
#    Accept incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify list of participants   from_device=device_1      connected_device_list=device_1,device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#
#
#
#
#*** Keywords ***
#Test Case Teardown
#    [Arguments]     ${devices}
#    Come back to home screen     ${devices}