#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    e2ee  36   sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  3
#${action_time} =  5
#
#*** Test Cases ***
#TC1:[E2EE] Verify if the E2EE option is visible under calling setting and user can enable and disable the E2EE option under calling.
#    [Tags]      317493        sanity_sm       bvt_sm_blocked_by_bug_3322296     #bvt_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    navigate to teams admin settings page  device=device_1
#    enable and disable e2ee    device=device_1  state=on
#    enable and disable e2ee    device=device_1  state=off
#    Navigate back from the device settings page     device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#*** Keywords ***
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#navigate to teams admin settings page
#    [Arguments]    ${device}
#    Navigate to app settings page    ${device}
#    navigate to teams admin settings      ${device}
#
#Navigate back from the device settings page
#    [Arguments]     ${device}
#    device setting back     ${device}
#    device setting back     ${device}
#    come back to home screen  ${device}
