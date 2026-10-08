#*** Settings ***
#Documentation   Outgoing Calls
#Force Tags    pm_outgoing_calls     pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#*** Variables ***
#${wait_time} =  10
#
#*** Test Cases ***
#TC1: [Outgoing Call] DUT dials to TDC call number from home screen dialpad
#    [Tags]  194756   sanity_pm
#    [Setup]  Testcase Setup   count=2
#    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC2: [Outgoing Call] DUT auto-dial to TDC call number from home screen dialpad
#    [Tags]  194757   P1
#    [Setup]  Testcase Setup   count=2
#    Make outgoing call using auto dial      from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC3: [Outgoing Call] DUT not to auto dial incorrect number
#    [Tags]  194753   P1
#    [Setup]  Testcase Setup   count=1
#    Auto dial incorrect number from dial pad   device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1
#
#TC4: [Outgoing Call] DUT calls incorrect number
#    [Tags]  194752   P2
#    [Setup]  Testcase Setup   count=1
#    Dial incorrect number from dial pad    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1
#
#
#
#*** Keywords ***
#Test Case Teardown
#    [Arguments]     ${devices}
#    Come back to home screen     ${devices}