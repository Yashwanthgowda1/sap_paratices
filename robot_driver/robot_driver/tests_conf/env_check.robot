*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s


*** Test Cases ***
Environment Setup Check for Conference Device
    [Tags]      env_check_1    exclude_ftp
    [Setup]    run keywords   Testcase Setup for Meeting User   count=2   AND   Meeting Setup   count=3
    Create Meeting  device=device_2     meeting=cnf_device_meeting      participants=device_1:meeting_user
    Refresh cnf device for meeting visibility      device=device_1
    Scroll till meeting visible     device=device_1      meeting=cnf_device_meeting
    Verify join button displayed on conf device    device=device_1
    Join meeting   device=device_1   meeting=cnf_device_meeting     join_styles=conference
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify UI returns to home page      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_2     count=2


*** Keywords ***
Meeting Setup
    [Arguments]     ${count}
    Remove meeting from calender for meeting policy test      ${count}

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}   ${count}
    check for device count      count=${count}
    Come back to home screen    ${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}