#*** Settings ***
#Library     DateTime
#Library     OperatingSystem
#Resource    ../../resources/keywords/common.robot
#
#*** Variables ***
#*** Test Cases ***
#TC1:[Auto Dismiss] DUT user to rate the rating in rating screen
#    [Tags]  237952  P1
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#*** Keywords ***
