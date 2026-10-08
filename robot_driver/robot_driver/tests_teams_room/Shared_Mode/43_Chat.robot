*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  3
${action_time} =  5

*** Test Cases ***
TC1:[Chat]Verify the chat option when DUT user enables chat option in Large Gallery mode.
     [Tags]     379980     P2
    [Setup]    Testcase Setup for Meeting User   count=2
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    change meeting mode     device=device_1     mode=large_gallery
    verify changed mode  device=device_1      changed_mode=large_gallery
    Enable and disable the chat toggle in meeting       device=device_1      state=on
    verify the chat option when DUT user enables chat option in Large Gallery mode      device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2  state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2

*** Keywords ***
Verify the chat option when DUT user enables chat option in Large Gallery mode
    [Arguments]    ${device}
    verify the chat options in meeting      ${device}