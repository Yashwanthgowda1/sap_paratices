#*** Settings ***
#Force Tags    private_meetings
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
##Suite Setup     Meeting Setup
##Suite Teardown  Meeting teardown
#
#*** Variables ***
#${wait_time} =  10
#
#*** Test Cases ***
#TC1 : [Private meetings] User to verify the presence of "Meetings" option under Teams App settings
#    [Tags]  248064   bvt
#    [Setup]    Testcase Setup   count=1
#    Verify meetings btn presence under App settings    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC2 : [Private meetings] User to verify "Meetings" option under Teams App settings
#    [Tags]  248065   bvt
#    [Setup]    Testcase Setup   count=1
#    Verify meetings option under App settings page   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC3 : [Private meetings] User to disable the "Show meeting names" option on the device
#    [Tags]  248066   p1
#    [Setup]    Testcase Setup   count=1
#    Disable show meeting names     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND    Enable show meeting names    device=device_1
#
#TC4 : [Private meetings] User to verify meeting titles in calendar tab when privacy toggle is turned off on the device
#    [Tags]  248068   p1
#    [Setup]    Run Keywords     Testcase Setup   count=1     AND     Create Meeting  device=device_1
#    Disable show meeting names    device=device_1
#    Come back to home screen    device_list=device_1
#    Navigate to calendar tab    device=device_1
#    Verify meeting title should match with organizer name    organizer=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND    Enable show meeting names    device=device_1
#
#TC5 : [Private meetings] User to verify all-day meetings in calendar tab when privacy toggle is turned off on the device
#    [Tags]  248075   p2
#    [Setup]    Run Keywords     Testcase Setup   count=1     AND     create meeting  device=device_1     meeting=all_day_meeting1    all_day_meeting=ON
#    Disable show meeting names    device=device_1
#    Come back to home screen    device_list=device_1
#    Navigate to calendar tab    device=device_1
#    #Verify meeting title should match with organizer name    organizer=device_1
#    Verify all day meeting title should match with organizer name    organizer=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Enable show meeting names    device=device_1    AND    Delete All Day Event TC Teardown     devices=device_1    meeting=all_day_meeting1
#
#TC6 : [Private meetings] User to create new meetings when privacy toggle is turned off on the device
#    [Tags]  248077   p2
#    [Setup]    Testcase Setup   count=1
#    Disable show meeting names    device=device_1
#    Come back to home screen    device_list=device_1
#    Navigate to calendar tab    device=device_1
#    create meeting   device=device_1    meeting=meeting1
#    Verify meeting title should match with organizer name    organizer=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND     Enable show meeting names    device=device_1    AND    Delete meeting TC Teardown     devices=device_1    meeting=meeting1   count=2
#
#TC7 : [Private meetings] User to verify the meeting title after joining the meeting when privacy toggle is turned off on the device
#    [Tags]  248079   p1
#    [Setup]    Testcase Setup   count=1
#    Disable show meeting names    device=device_1
#    Come back to home screen    device_list=device_1
#    Navigate to calendar tab    device=device_1
#    create meeting   device=device_1    meeting=meeting2
#    Verify meeting title should match with organizer name    organizer=device_1
#    Join Meeting when privacy toggle is turned off   device=device_1     organizer_name=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1   state=Connected
#    Verify meeting name after joining the meeting    device=device_1    meeting=meeting2
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure   AND     Enable show meeting names    device=device_1   AND    Delete meeting TC Teardown     devices=device_1    meeting=meeting2   count=2
#
#
#
#*** Keywords ***
#Delete All Day Event TC Teardown
#    [Arguments]     ${devices}      ${meeting}
#    Come back to home screen    ${devices}
#    Teardown Meeting Test Case     ${devices}
#    Delete all day meetings      ${devices}    ${meeting}
#
#Delete meeting TC Teardown
#    [Arguments]     ${devices}      ${meeting}    ${count}
#    come_back_home_screen_for_user    ${count}
#    Teardown Meeting Test Case     ${devices}
#    Delete meeting      ${devices}    ${meeting}
#    remove_meeting_from_calender_for_user   ${count}