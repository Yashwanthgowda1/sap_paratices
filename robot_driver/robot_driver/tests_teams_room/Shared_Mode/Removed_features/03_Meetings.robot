#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Library     DateTime
#Library     OperatingSystem
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC15:[Meetings]DUT user enable raise hand in the meeting
#    [Tags]  237863  P1
#    [Setup]  Testcase Setup for Meeting User     count=3
#    Join meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3
#    Select raise hand option  device=device_1
#    Verify raise hand notification   device_list=device_2,device_3
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#For below test case no meeting should be created on Home screen.
#TC4:[MTRA] Verify that new calendar UI visible.
#    [Tags]     444850
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify that new calendar UI visible     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#*** Keywords ***
