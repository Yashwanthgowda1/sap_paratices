*** Settings ***
Force Tags    Meeting_Reminder
Resource     ../resources/keywords/common.robot

*** Variables ***
${wait_time} =   10

*** Test Cases ***
#TC1 : [Meeting Reminder] Teams device to show reminder for upcoming meetings only on Home screen
#   [Tags]   204898  205002  bvt   38_bvt
#   [Setup]   Run Keywords   Testcase Setup    count=2   AND    Home Screen Enable     device=device_1   AND  Clear notifications from home screen   device=device_1
#   Create meeting   device=device_2     participants=device_1    meeting=test_meeting1
#   Wait for Some Time    time=${wait_time}
#   Come back to home screen page and verify   device=device_1
#   Verify meeting present on home screen   device=device_1     meeting=test_meeting1
#   Validate meeting reminder notification for upcoming time on home screen  device=device_1   meeting=test_meeting1
#   Verify meeting notification scroll  device=device_1
#   [Teardown]  Run Keywords    Capture on Failure  AND    Home screen Disable    device=device_1  AND   Test Case Teardown     devices=device_2    meeting=test_meeting1   count=2
#
#TC2 : [Meeting Reminder] Once meeting time is reached, the countdown timer on notifications disappear
#   [Tags]   205004    P2
#   [Setup]   Run Keywords   Testcase Setup    count=2    AND    Home Screen Enable     device=device_1    AND  Clear notifications from home screen   device=device_1
#   Create meeting   device=device_2    meeting=Outlook_meeting     participants=device_1
#   Refresh for Meeting Visibility      device=device_1
#   Wait for Some Time    time=${wait_time}
#   Come back to home screen page and verify   device=device_1
#   Verify meeting present on home screen   device=device_1      meeting=Outlook_meeting
#   Validate meeting reminder notification for upcoming time on home screen  device=device_1
#   [Teardown]  Run Keywords    Capture on Failure  AND    Home screen Disable    device=device_1  AND  Test Case Teardown    devices=device_2    meeting=Outlook_meeting   count=2
#
#TC3 : [Meeting Reminder] Teams device to show reminder for upcoming meetings in 15mins, 10mins and 5 mins before the meeting starts
#   [Tags]   205006    P2
#   [Setup]   Run Keywords   Testcase Setup    count=2    AND    Home Screen Enable     device=device_1  AND    Clear notifications from home screen   device=device_1
#   Create meeting   device=device_2    meeting=test_meeting2     participants=device_1
#   Refresh for Meeting Visibility      device=device_1
#   Wait for Some Time    time=${wait_time}
#   Come back to home screen page and verify   device=device_1
#   Verify meeting present on home screen   device=device_1      meeting=test_meeting2
#   Validate meeting reminder notification for upcoming time interval on home screen  device=device_1
#   [Teardown]  Run Keywords    Capture on Failure   AND    Home screen Disable    device=device_1   AND  Test Case Teardown    devices=device_2    meeting=test_meeting2   count=2
#
#TC4 : [Meeting Reminder] Upcoming meeting notification should be removed when organizer cancels the meeting
#   [Tags]   205176    P2
#   [Setup]   Run Keywords   Testcase Setup    count=2    AND    Home Screen Enable     device=device_1   AND   Clear notifications from home screen   device=device_1
#   Create meeting  device=device_2     participants=device_1       meeting=Cancel_meeting
#   Refresh for Meeting Visibility      device=device_1
#   Wait for Some Time    time=${wait_time}
#   Come back to home screen page and verify   device=device_1
#   Verify meeting present on home screen   device=device_1     meeting=Cancel_meeting
#   Delete meeting      devices=device_2     meeting=Cancel_meeting
#   Wait for Some Time    time=${wait_time}
#   Verify meeting notification remove from home screen    device=device_1
#   [Teardown]   Run Keywords    Capture on Failure    AND  Home screen Disable    device=device_1   AND   Come back to home screen    device_list=device_2
#
#TC5 : [Meeting Reminder] Notifications should not be overlapped even though many meetings are scheduled at the same time
#   [Tags]   205005    P2
#   [Setup]   Run Keywords   Testcase Setup    count=2    AND    Home Screen Enable    device=device_1   AND   Remove Meeting   devices=device_1,device_2   AND   Clear notifications from home screen   device=device_1
#   Create meeting   device=device_2      participants=device_1    meeting=device_meeting1
#   Create meeting   device=device_2      participants=device_1    meeting=device_meeting2
#   Create meeting   device=device_2      participants=device_1    meeting=device_meeting3
#   Create meeting   device=device_2      participants=device_1    meeting=device_meeting4
#   Create meeting   device=device_2      participants=device_1    meeting=device_meeting5
#   Refresh for Meeting Visibility      device=device_1
#   Wait for Some Time    time=${wait_time}
#   Come back to home screen page and verify   device=device_1
#   Verify meeting notifications should not overlap when meetings scheduled at same time  device=device_1    meetings= device_meeting1,device_meeting2,device_meeting3,device_meeting4,device_meeting5
#   [Teardown]  Run Keywords    Capture on Failure   AND   Home screen Disable    device=device_1   AND   Delete multiple meetings Test Case Teardown     devices=device_2    meeting=device_meeting1,device_meeting2,device_meeting3,device_meeting4,device_meeting5   count=2


*** Keywords ***
Test Case Teardown
   [Arguments]     ${devices}      ${meeting}   ${count}
   come_back_home_screen_for_user    ${count}
   Teardown Meeting Test Case     ${devices}
   Delete meeting      ${devices}    ${meeting}
   remove_meeting_from_calender_for_user   ${count}
   Come back to home screen    ${devices}

Delete multiple meetings Test Case Teardown
   [Arguments]     ${devices}      ${meeting}   ${count}
   Come back to home screen    ${devices}
   Teardown Meeting Test Case     ${devices}
   Delete multiple meetings      ${devices}    ${meeting}
   remove_meeting_from_calender_for_user      ${count}

Send Voicemail
   [Arguments]     ${from_device}   ${to_device}
   Make outgoing call using display name    ${from_device}      ${to_device}
   Wait for Some Time    time=${wait_time}
   Verify Call State    device_list=${from_device}   state=Connected
   Disconnect call     ${from_device}
   Come back to home screen    device_list=${from_device}


Repeat send voicemail
   [Arguments]     ${from_device}   ${to_device}
   Send Voicemail    ${from_device}   ${to_device}
   Send Voicemail    ${from_device}   ${to_device}
   Come back to home screen    ${from_device}

Clear notifications from home screen
   [Arguments]     ${device}
   Clear notification from home screen  ${device}

Remove Meeting
   [Arguments]     ${devices}
   Remove meeting from calender   ${devices}