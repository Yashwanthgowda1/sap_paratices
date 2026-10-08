*** Settings ***
Resource    ../resources/keywords/common.robot

#Suite Setup     Meeting Policy Setup Main
#Suite Teardown  User Teardown

*** Variables ***

*** Test Cases ***
#TC1 : [Sign-in] Sign-out from the Teams App
#    [Tags]  144489   P1
#    [Setup]    Testcase Setup for Meeting User   count=1
#    sign out method    device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     sign in method     device=device_1  user=meeting_user
#
#TC2 : [Sign-in] MeetingsSignIn _sign out option should be behind admin settings
#    [Tags]  180409   bvt
#    [Setup]  Testcase Setup for Meeting User    count=1
#    Verify user do not have sign out option     device_list=device_1
#    verify signout option should be in device settings    device_list=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Device Setting Teardown   device_1
#
#TC3 : [Calendar] Verify Calendar tab UI displays all the scheduled meeting entries
#    [Tags]  179924  179759  bvt
#    [Setup]  run keywords  Testcase Setup for Meeting User   count=2   AND    Meeting Setup   count=2
#    Create Meeting  device=device_2     meeting=tz_meeting      participants=device_1:meeting_user
#    ${timezone_value}  Get device current TimeZone    device=device_1
#    ${current_timezone_name}   get timezone name   ${timezone_value}
#    Change device TimeFormat   device=device_1      required_timeformat=24
#    Refresh the page      device=device_1
#    Scroll till meeting visible     device=device_1      meeting=tz_meeting
#    ${meeting_time}   Get scheduled meeting time on cnf device   device=device_1
#    Come back to home screen    device_list=device_1
#    Change device TimeZone     device=device_1    required_timezone=IST
#    Refresh the page      device=device_1
#    Scroll till meeting visible     device=device_1      meeting=tz_meeting
#    ${meeting_time_after_tz_change}  Get scheduled meeting time on cnf device   device=device_1
#    Come back to home screen    device_list=device_1
#    ${converted_time}     Get converted meeting tz      ${meeting_time}     ${current_timezone_name}     IST
#    run keyword if  '${meeting_time_after_tz_change}' == '${converted_time}'    Log   Meeting time got changed according to Changed timezone.
#    ...   ELSE   fail   Unable to change Meeting time according to Changed timezone.
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2     meeting=tz_meeting    count=2

*** Keywords ***
Meeting Setup
    [Arguments]     ${count}
    Remove meeting from calender for meeting policy test      ${count}

Test Case Teardown
    [Arguments]     ${devices}      ${meeting}    ${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Delete meeting      ${devices}    ${meeting}
    Remove meeting from calender for meeting policy test      ${count}

Device Setting Teardown
    [Arguments]     ${device}
    Device Setting Back     ${device}
    Come back to home screen    ${device}
