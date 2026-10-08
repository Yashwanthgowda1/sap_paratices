#*** Settings ***
#Documentation   Validating the functionality of Lock meeting Feature.
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC4: [Lock Meeting] Verify that DUT user should not able to join the meeting when the meeting is locked by TDC user
#     [Tags]  260597   P1        sanity_sm
#     [Setup]  Testcase Setup for Meeting User     count=3
#     Join meeting   device=device_2,device_3    meeting=lock_meeting
#     Verify meeting state   device_list=device_2,device_3    state=Connected
#     Tap on lock meeting   device=device_2
#     Verify user cannot join the locked meeting    device=device_1     meeting=lock_meeting
#     End meeting      device=device_2,device_3
#     Verify meeting state    device_list=device_2,device_3    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#*** Keywords ***
