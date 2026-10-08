*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Docked uBar] User to verify the options on call control bar
    [Tags]   306302  sanity_tpc  P1
    [Setup]   run keywords    Testcase Setup for Meeting User    count=2    AND    Meeting Setup    count=2
    Create Meeting  device=device_2     meeting=cnf_device_meeting      participants=device_1:meeting_user
    Refresh cnf device for meeting visibility   device=device_1
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    verify lightweight meeting ui   device=device_1    participants=device_2 
    End meeting       device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure     AND    Test Case Teardown without deleting meeting     devices=device_2     count=2

TC2 : [Docked uBar] User to verify the show/hide behavior of call control bar
    [Tags]    306301    bvt_tpc  sanity_tpc  P0
    [Setup]   run keywords    Testcase Setup for Meeting User    count=2    AND    Meeting Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    verify lightweight meeting ui    device=device_1    participants=device_2
    End meeting        device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_2     count=2


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

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Remove meeting from calender for meeting policy test      ${count}