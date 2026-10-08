*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
*** Keywords ***
Navigate to app settings page
    [Arguments]     ${device}
    Click on more option   ${device}
    Click on settings page   ${device}

Enable and disable zoom meeting toggle
    [Arguments]     ${device}       ${state}
    Navigate to app settings page     ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable third party meetings zoom toggle  ${device}       ${state}
    Come back from admin settings page    device_list=${device}

Enable and disable third party webex meetings
    [Arguments]     ${device}       ${state}
    Navigate to app settings page    ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable third party meetings webex toggle    ${device}     ${state}
    Come back from admin settings page    device_list=${device}

DUT user should have option to enable Webex meeting
    [Arguments]       ${device}   ${state}
    Navigate to app settings page    device=device_1
    navigate to meetings option in device settings page      device=device_1
    Enable and disable third party meetings webex toggle    device=device_1     state=off
    Come back from admin settings page    device_list=device_1

Enable third party meetings
    [Arguments]     ${device}
    Navigate to app settings page    ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable third party meetings zoom toggle  ${device}    state=on
    Come back from admin settings page    device_list=${device}

Disable third party meetings
    [Arguments]     ${device}
    Navigate to app settings page     ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable third party meetings zoom toggle   ${device}    state=off
    Come back from admin settings page    device_list=${device}

Navigate to about page
    [Arguments]     ${device}
    Click on more option   ${device}
    Click on settings page   ${device}
    click on about page  ${device}

navigate to teams admin settings page
    [Arguments]    ${device}
    Click on more option   ${device}
    Click on settings page   ${device}
    navigate to teams admin settings      ${device}

