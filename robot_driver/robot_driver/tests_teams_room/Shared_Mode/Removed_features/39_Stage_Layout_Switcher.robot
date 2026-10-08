#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Library     DateTime
#Library     OperatingSystem
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC2:[Stage Layout Switcher] Verify that Gallery Layout with chat.
#    [Tags]    444530   P0
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2      meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2       state=Connected
#    verify the gallery layout selected default and with chat    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2
#
#*** Keywords ***
