#*** Settings ***
#Force Tags    sm_settings     sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#*** Test Cases ***
#TC1: [Settings] Auto-answer settings under calling settings
#     [Tags]     322741   P1
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to app settings screen    console=console_1
#    Navigate calling option in device settings      console=console_1
#    Verify auto answer setting options  device=console_1
#    Navigate back to device settings page  console=console_1
#    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1
#
#TC2:[Settings]“Call views” section of the settings is not applicable to Collab bars.
#    [Tags]      322742      P1
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to app settings screen    console=console_1
#    Navigate calling option in device settings      console=console_1
#    verify call view is not present   device=console_1
#    Navigate back to device settings page  console=console_1
#    [Teardown]  Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1
#
#TC3: [Settings] “Calling” option under the Admin only settings should be created only for shared accounts
#     [Tags]     322740      P1
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to app settings screen    console=console_1
#    Navigate calling option in device settings      console=console_1
#    Navigate back to device settings page  console=console_1
#    [Teardown]  Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1
#
#*** Keywords ***
#Navigate to app settings screen
#    [Arguments]   ${console}
#    Tap on more option  ${console}
#    Tap on settings page   ${console}
#
#
#Navigate calling option in device settings
#    [Arguments]       ${console}
#    Navigate to meeting and calling options from device settings page       ${console}  option=calling
#
#Navigate back to device settings page
#    [Arguments]       ${console}
#    Click back btn   ${console}
#    device setting back btn     ${console}
#    Click on close button    console_list=${console}
#    Click on back layout btn   ${console}
#    Come back to home screen page   console_list=${console}
