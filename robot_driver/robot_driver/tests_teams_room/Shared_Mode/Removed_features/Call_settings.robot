#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    call_settings     23     sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Test Cases ***
#
#TC1: [Calling settings] Verify the options present under calling setting
#    [Tags]  316658  p1     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    verify options in device settings calling    device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1
#
#
#TC2: [Calling Setting] Verify DUT can blocked number
#    [Tags]    316660      p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    block the numbers    from_device=device_1     to_device=device_2
#    device setting back  device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    verify if user gets incoming call  device=device_1
#    unblock the number from calling   device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1,device_2
#
#*** Keywords ***
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#
#navigate calling option
#    [Arguments]       ${device}
#    navigate to teams admin settings   ${device}
#    verify calling option in device settings page     ${device}
#
#unblock the number from calling
#    [Arguments]       ${device}
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    unblock the number  device=device_1
