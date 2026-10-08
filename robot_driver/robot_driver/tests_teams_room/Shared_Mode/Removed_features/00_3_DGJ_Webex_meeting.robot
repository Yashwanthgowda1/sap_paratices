#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution make sure that  Webex meeting is created
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC1:[DGJ]Webex Meeting Should be displayed in Home screen
#    [Tags]     445043        bvt_sm       sanity_sm     exclude_ftp_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify Webex Meeting Should be displayed in Home screen
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC3:[DGJ]DUT user should be able to join Webex Meeting from Teams and See call control options
#    [Tags]     328329        bvt_sm       sanity_sm     exclude_ftp_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Join Meeting    device=device_1      meeting=webex_meeting
#    Wait for Some Time    time=${action_time}
#    Verify meeting state   device_list=device_1     state=Connected
#    verify the docked ubar when third party meeting joins    device=device_1        meetting_mode=webex
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#
#*** Keywords ***
