#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    sm_settings   26       sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Test Cases ***
#
#TC1: [Settings] [Calling] option under the Admin only settings should be created only for shared accounts
#     [Tags]   237962   bvt  bvt_sm      sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to app settings page    device=device_1
#    navigate calling option     device=device_1
#    verify options in device settings calling    device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1
#
#
#TC2: [Settings] Auto-answer settings under calling settings
#     [Tags]     237966   P1
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    verify meeting and video automatically options  device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
#
#
#TC3: [Settings][Call views] section of the settings is not applicable to Collab bars.
#    [Tags]   237967      p1
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    verify call view is not present   device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1
#
#
#This feature is not avaialable 
# TC22:DUT user to verify the pop up displayed, when user signs in with CAP limit reached account.
#     [Tags]   344914      P1  sanity_sm      exclude_ftp_sm
#     [Setup]  Testcase Setup for Meeting User    count=1
#     Sign out method    device=device_1
#     verify signin with license is not supported account used for signin phones       device=device_1:cap_limit_reached_account
#     [Teardown]  Run Keywords   Capture on Failure  AND    Sign in method     device=device_1     user=meeting_user

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
