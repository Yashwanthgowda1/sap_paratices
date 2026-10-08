#*** Settings ***
#Documentation   App Settings
#Force Tags    pm_app_settings   01   pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#*** Variables ***
#${wait_for_time} =  3
#
#
#*** Test Cases ***
#TC1: [App settings] DUT user has the option to sign out
#    [Tags]  194872  bvt  bvt_pm   sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Sign out method    device=device_1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign out
#    [Teardown]  Run Keywords    Capture on Failure  AND     Sign in method     device=device_1
#
#TC2: [App settings] User checks the about option in app settings
#    [Tags]  194873   P1
#    [Setup]  Testcase Setup    count=1
#    Navigate to app settings page    device=device_1
#    Verify about page  device=device_1
#    Click back btn    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    App Setting Teardown   device=device_1
#
#TC3: [App settings] User checks 'Report an issue' option in app settings
#    [Tags]  194875   bvt  bvt_pm   sanity_pm
#    [Setup]  Testcase Setup    count=1
#    Navigate to app settings page    device=device_1
#    Report an issue  device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND    App Setting Teardown     device=device_1
#
#TC4: [App settings] User should have the option to navigate to device settings
#    [Tags]  194876   P1
#    [Setup]  Testcase Setup    count=1
#    Navigate to device settings page  device=device_1
#    Navigate back from device settings page   device=device_1
#    Click back btn    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    App Setting Teardown   device=device_1
#
#TC5:[App Settings] Teams App User to view the third-party Notices of use
#    [Tags]  312848   P2
#    [Setup]  Testcase Setup    count=1
#    Navigate to about page  device=device_1
#    verify third party software and information    device=device_1
#    Click back btn    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    App Setting Teardown   device=device_1
#
#TC6:[App Settings] Teams App User to see the terms of use
#    [Tags]  312851   P2
#    [Setup]  Testcase Setup    count=1
#    Navigate to about page  device=device_1
#    verify microsoft software license terms  device=device_1
#    Click back btn    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    App Setting Teardown   device=device_1
#
#TC7:[App Settings] Teams app user to see and define Privacy and cookies
#    [Tags]  312854   P2
#    [Setup]  Testcase Setup    count=1
#    Navigate to about page  device=device_1
#    verify privacy cookies     device=device_1
#    Click back btn    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    App Setting Teardown   device=device_1
#
#
#
#
#
#*** Keywords ***
#App Setting Teardown
#    [Arguments]     ${device}
#    Click close btn    device_list=${device}
#    Come back to home screen    device_list=${device}
#
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#
#Navigate to device settings page
#    [Arguments]     ${device}
#    Click on more option   device=${device}
#    Click on settings page  device=${device}
#    Click on device settings page  device=${device}
#    Wait for Some Time    time=${wait_for_time}
#
#Navigate to about page
#     [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#    click on about page  ${device}
#
