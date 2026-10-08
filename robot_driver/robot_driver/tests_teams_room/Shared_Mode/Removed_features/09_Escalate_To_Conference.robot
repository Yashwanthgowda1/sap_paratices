#*** Settings ***
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#*** Test Cases ***
#TC4:[Escalate to conference] DUT user can add TDC user while in call with another DUT user
#    [Tags]   237774     444791   P1    sanity_sm
#    [Setup]   Testcase Setup for Meeting User  count=3
#    Make Video call using display name  from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Close participants screen   device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call    device=device_3
#    Close participants screen   device=device_1
#    Verify list of participants   from_device=device_1      connected_device_list=device_1:meeting_user,device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1,device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#
#*** Keywords ***
