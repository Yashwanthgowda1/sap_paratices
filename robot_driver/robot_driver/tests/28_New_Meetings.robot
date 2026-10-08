*** Settings ***
Resource    resources/keywords/common.robot
Documentation    Suite Setup Requirements : This suite requires minimum of 3 devices in config
...              Purpose: Device_1,Device_2 & Device_3 should clear meetings from calendar tab

Suite Setup    Meeting Suite Setup
Suite Teardown    Run keyword and ignore error    Meeting Suite Teardown

*** Variables ***
${wait_time} =  10
${Long_meeting_title} =  Meeeeeeeeeeeeeeeeeeeeettttttttttttttttiiiiiiiiiiiiiiiinnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnggggggggggg


*** Test Cases ***
TC1 : [Calendar] Organizer can cancel the scheduled meeting
    [Tags]  306802   sanity_tp      bvt_pr  alt_bug     Certification_audio
    [Setup]    Testcase Setup    count=2
    create meeting  device=device_1     participants=device_2       meeting=Cancel_meeting
    Navigate to Calendar tab   device=device_2
    Refresh for Meeting Visibility      device=device_2
    delete specific meeting    device=device_1    meeting=Cancel_meeting
    Refresh for Meeting Visibility      device=device_2
    verify canceled meeting should not visible for organizer     device=device_1   meeting=Canceled: Cancel_meeting
    Verify meeting has meeting name     device=device_2  meeting=Canceled: Cancel_meeting
    [Teardown]   Run Keywords    Capture on Failure   AND     Test Case Teardown without deleting meeting   devices=device_1,device_2

TC2 : [Calendar] For Participants on DUT, cancelled calendar should be displayed with "Cancelled:" text on calendar tab UI
    [Tags]  307134         alt_bug    sanity_tp
    [Setup]    Testcase Setup   count=2
    create meeting  device=device_2       participants=device_1    meeting=meetings_cancel
    Refresh for Meeting Visibility      device=device_1
    delete specific meeting    device=device_2    meeting=meetings_cancel
    Refresh for Meeting Visibility      device=device_1
    Verify meeting has meeting name     device=device_1  meeting=Canceled: meetings_cancel
    [Teardown]  Run Keywords    Capture on Failure   AND     Test Case Teardown without deleting meeting   devices=device_1,device_2

TC3 : [Calendar] Verify all day meetings
    [Tags]  306801  alt_bug       Certification_audio
    [Setup]    Run keywords     Testcase Setup   count=2    AND     clear all meetings except test meeting    device=device_1
    create meeting  device=device_2       participants=device_1   meeting=meeting1    all_day_meeting=ON
    create meeting  device=device_2       participants=device_1   meeting=meeting2    all_day_meeting=ON
    Wait for Some Time    time=${wait_time}
    Refresh for Meeting Visibility      device=device_1
    Verify meeting under all day event   device=device_1     meetings=meeting1,meeting2
    [Teardown]  Run Keywords    Capture on Failure   AND     Test Case Teardown   devices=device_1,device_2

TC4 : [Calendar] DUT user to edit the scheduled meeting from the device
    [Tags]  308325   sanity_tp     alt_bug      Certification_audio
    [Setup]    Testcase Setup   count=3
    create meeting   device=device_1    meeting=edit_meeting    participants=device_3
    Select Meeting      device=device_1        meeting=edit_meeting
    Edit the meeting and add new participant    device=device_1     participants=device_2
    #Verify invited user list in Meeting Details     from_device=device_1     participants=device_2,device_3     meeting=edit_meeting
    Select Meeting      device=device_1        meeting=edit_meeting
    Verify invited user list in meeting     from_device=device_1     participants=device_2,device_3     meeting=edit_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1

TC5 : [Calendar] DUT user gets multiple meetings at same time
    [Tags]  307164    alt_blocked
    [Setup]    Run keywords     Testcase Setup   count=3    AND     clear meetings from calendar tab    devices=device_1,device_2,device_3
    create meeting  device=device_2       participants=device_1   meeting=tdc1_meeting1
    create meeting  device=device_2       participants=device_1    meeting=tdc1_meeting2
    create meeting  device=device_3       participants=device_1    meeting=tdc2_meeting1
    create meeting  device=device_3       participants=device_1    meeting=tdc2_meeting2
    Join meeting   device=device_1    meeting=tdc1_meeting2
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1   state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND     Test Case Teardown   devices=device_1,device_2,device_3

TC6 : [Calendar] Meeting tab should be empty when all the meeting objects are deleted
    [Tags]  309001         alt_blocked
    [Setup]    Run keywords     Testcase Setup   count=1    AND    clear all day meeting and meeting history from calendar   devices=device_1
    Create Meeting  device=device_1   meeting=test_meeting
    delete specific meeting    device=device_1      meeting=test_meeting
    Refresh main tab    device=device_1
    verify calendar empty   device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7 : [Calendar] : User should be in creating meeting screen, after Accept/Reject of incoming call.
    [Tags]    309227   sanity_tp    P1
    [Setup]   Testcase Setup    count=2
    Navigate to create meeting page     device=device_1
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify create meeting screen    device=device_1
    Come back to home screen    device_list=device_2
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1
    Rejects the incoming call   device_list=device_1
    Verify create meeting screen    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1

TC8 : [Calendar App] Cancel a meeting occurrence from Calendar.
    [Tags]   321103         sanity_tp    bvt_tp
    [Setup]  Testcase Setup    count=1
    create meeting      device=device_1    meeting=cancel_test_meeting
    delete specific meeting      device=device_1    meeting=cancel_test_meeting
    verify meeting after organizer cancel event  device=device_1    meeting=cancel_test_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1

TC9: [Meetings] Verify Canceled meetings when user enable & disable "Show meeting names"
    [Tags]    311569        P1
    [Setup]    Testcase Setup   count=2
    disable show meeting names  device=device_1
    Create Meeting  device=device_2     meeting=hide_meeting     participants=device_1
    delete specific meeting     device=device_2     meeting=hide_meeting
    verify meeting name after meeting canceled  device=device_1     organizer=device_2      meeting=hide_meeting   show_meeting_toggle=off
    Enable show meeting names     device=device_1
    verify meeting name after meeting canceled  device=device_1   organizer=device_2    meeting=hide_meeting    show_meeting_toggle=on
    [Teardown]   Run Keywords    Capture on Failure   AND   Test Case Teardown without deleting meeting   devices=device_1,device_2      AND      Enable show meeting names     device=device_1

TC10: [Calendar App] Validate deleting an All Day meeting
    [Tags]  320319        P2
    [Setup]    Testcase Setup   count=2
    Disable show meeting names     device=device_1
    Create Meeting  device=device_1     meeting=hide_meeting1     participants=device_2         all_day_meeting=ON
    verify meeting title shows meeting organizer name   device=device_1      organizer=device_1     all_day_meeting=on
    clear all day meeting and meeting history from calendar   devices=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Test Case Teardown without deleting meeting   devices=device_1,device_2  AND    Enable show meeting names     device=device_1

TC11 :[Light weight meeting] Verify the UI after joining the meeting from Home screen
    [Tags]    401809        P0      bvt_tp   sanity_tp
    [Setup]   Testcase Setup    count=2
    Clear notification from home screen     device=device_1
    create meeting   device=device_2    meeting=home_screen_meeting    participants=device_1
    Click on calls tab  device=device_1
    Navigate to calendar tab     device=device_1
    come back to home screen page and verify    device=device_1
    verify meeting name and join meeting from home screen  device=device_1    meeting=home_screen_meeting
    Join Meeting    device=device_2     meeting=home_screen_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting   devices=device_1,device_2

TC12 : [Meeting Reminder] DUT to show reminder for upcoming meetings in 15mins, 10mins and 5mins before the meeting starts only on Home screen
    [Tags]    310174           sanity_tp
    [Setup]    Testcase Setup    count=2
    Clear notification from home screen     device=device_1
    Create Meeting    device=device_2    meeting=upcoming_meetings_1    participants=device_1   meeting_time=on    start_meeting_time=on    start_meeting_time_after=15
    Navigate To Calendar Tab    device=device_1
    Wait for Some Time    time=${wait_time}
    Come back to home screen page and verify   device=device_1
    Refresh Main Tab    device=device_1
    Verify meeting present on home screen   device=device_1      meeting=upcoming_meetings_1
    Test Case Teardown    devices=device_1,device_2
    Clear notification from home screen     device=device_1
    Create Meeting    device=device_2    meeting=upcoming_meetings_2    participants=device_1    meeting_time=on    start_meeting_time=on    start_meeting_time_after=10
    Navigate To Calendar Tab    device=device_1
    Wait for Some Time    time=${wait_time}
    Come back to home screen page and verify   device=device_1
    Refresh Main Tab    device=device_1
    Verify meeting present on home screen   device=device_1      meeting=upcoming_meetings_2
    Test Case Teardown    devices=device_1,device_2
    Clear notification from home screen     device=device_1
    Create Meeting    device=device_2    meeting=upcoming_meetings_3    participants=device_1    meeting_time=on    start_meeting_time=on    start_meeting_time_after=5
    Navigate To Calendar Tab    device=device_1
    Wait for Some Time    time=${wait_time}
    Come back to home screen page and verify   device=device_1
    Refresh Main Tab    device=device_1
    Verify meeting present on home screen   device=device_1      meeting=upcoming_meetings_3
    [Teardown]    Run Keywords    Capture on Failure    AND    Test Case Teardown    devices=device_1,device_2

TC13 : [Meeting Reminder] Once meeting time is reached, the countdown timer on notifications disappears.
    [Tags]    310169
    [Setup]    Testcase Setup    count=2
    Clear notification from home screen     device=device_1
    Create Meeting    device=device_2    meeting=upcoming_meetings    participants=device_1    meeting_time=on    start_meeting_time=on    start_meeting_time_after=2
    Click on calls tab  device=device_1
    Navigate to calendar tab     device=device_1
    come back to home screen page and verify    device=device_1
    Wait For Some Time    time=${wait_time}
    Verify meeting present on home screen   device=device_1      meeting=upcoming_meetings
    Clear notification from home screen     device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Test Case Teardown    devices=device_1,device_2

TC14 : [Calendar] Calendar tab should sync after reboot.
    [Tags]    309256
    [Setup]    Testcase Setup   count=2
    Clear Notification From Home Screen    device=device_1
    Create Meeting    device=device_1   meeting=new_meeting    participants=device_2
    Come Back To Home Screen Page And Verify    device=device_1
    Reboot Phones    device=device_1
    Wait For Some Time    time=${wait_time}
    Navigate To Calendar Tab  device=device_1
    verify meeting has meeting name    device=device_1    meeting=new_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown    devices=device_1

TC15 : [ Meeting Stage] verify participant view profile option in menu
    [Tags]    321019
    [Setup]    Testcase Setup    count=4
    Create Meeting    device=device_2    meeting=new_meeting    participants=device_1
    Join Meeting    device=device_2,device_1   meeting=new_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Wait For Some Time    time=${wait_time}
    Click Participants In Meeting    from_device=device_1    to_device=device_4
    Verify Option Present In Menu And Click Viewoption    device=device_1
    End Meeting    device=device_1,device_2,device_3,device_4
    Verify meeting state    device_list=device_1,device_2,device_3,device_4   state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3,device_4

TC16: [Calendar] DUT user creates multiple meetings at the same time
    [Tags]    309251   tp_audio
    [Setup]    Testcase Setup   count=1
    create meeting   device=device_1    meeting=multiple_meeting1
    create meeting   device=device_1    meeting=multiple_meeting2
    verify meetings displayed in calendar tab   device=device_1   meeting_list=multiple_meeting1,multiple_meeting2
    [Teardown]  Run Keywords    Capture on Failure   AND     Test Case Teardown   devices=device_1

TC17: [Calendar] DUT user has the option to view recurring meeting series on calendar tab UI
    [Tags]    307142
    [Setup]    Testcase Setup   count=2
    create meeting  device=device_2       participants=device_1    meeting=recurring_meeting    repeat=Every week
    Refresh for Meeting Visibility      device=device_1
    Select Meeting      device=device_1        meeting=recurring_meeting
    Verify meeting recurrence indicator symbol     device=device_1
    Verify meeting series   device=device_1     meeting=recurring_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown     devices=device_1,device_2

TC18:[Calendar] Teams App user can respond to multiple occurrence of recurrence meeting
    [Tags]    307148
    [Setup]    Testcase Setup   count=2
    create meeting  device=device_2       participants=device_1    meeting=recurring_meeting2    repeat=Every weekday (Mon-Fri)
    Decline meeting for multiple days   device=device_1    meeting=recurring_meeting2
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown   devices=device_1,device_2

TC19:[Calendar] Participant on DUT can respond with tentative for the meeting scheduled from TDC
    [Tags]    307154
    [Setup]     Testcase Setup    count=2
    create meeting  device=device_2     participants=device_1       meeting=Tentative_meeting
    Navigate to Calendar tab   device=device_1
    Refresh for Meeting Visibility      device=device_1
    Select Meeting      device=device_1    meeting=Tentative_meeting
    Check rsvp status   device=device_1
    Respond to meeting     device=device_1     respond_option=Tentative
    Verify meeting response     device=device_1     respond_option=Tentative
    [Teardown]   Run Keywords    Capture on Failure   AND   Test Case Teardown without deleting meeting   devices=device_1,device_2

TC20:[Calendar] Respond options should not be displayed for organizer on Teams App
    [Tags]    307157
    [Setup]     Testcase Setup   count=2
    create meeting  device=device_1       participants=device_2    meeting=respond_mtng    location=
    Select Meeting      device=device_1   meeting=respond_mtng
    Verify meeting respond option should not visible for organizer   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown   devices=device_1

TC21:[Calendar] Teams App should not be displayed with event created for the recurring week, when no meeting is scheduled
    [Tags]    309222
    [Setup]    Testcase Setup   count=1
    create meeting  device=device_1   meeting=recurring_meeting3    repeat=Every week   date=forward date
    Verify meeting should not be displayed   device=device_1      meeting=recurring_meeting3
    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown     devices=device_1

TC22:[Calendar] Teams App user should sync automatically when edited the meeting
    [Tags]    309225
    [Setup]    Testcase Setup    count=3
    create meeting   device=device_1    meeting=edit_meeting2   participants=device_2
    Select Meeting      device=device_1        meeting=edit_meeting2
    Verify invited user list in Meeting Details     from_device=device_1     participants=device_2
    Edit meeting name and validate    device=device_1    new_meeting=edit_meeting2_edited
    Wait for Some Time    time=${wait_time}
    Select Meeting      device=device_1        meeting=edit_meeting2_edited
    Edit the meeting and add new participant    device=device_1     participants=device_3
    Select Meeting      device=device_1        meeting=edit_meeting2_edited
    Verify invited user list in Meeting Details     from_device=device_1     participants=device_2,device_3
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1

TC23:[Calendar] Meeting object on Teams App without location information
    [Tags]    307183
    [Setup]    Testcase Setup   count=2
    create meeting  device=device_1       participants=device_2    meeting=without_location_mtng    location=
    Select Meeting      device=device_1   meeting=without_location_mtng
    Verify meeting does not have location   device=device_1     meeting=without_location_mtng
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1

TC24:[Calendar] Long meeting titles should be truncated with ellipses in meeting object on Teams App
    [Tags]   307190
    [Setup]    Testcase Setup   count=2
    create meeting  device=device_1       participants=device_2    meeting=${Long_meeting_title}
    Refresh for Meeting Visibility      device=device_2
    Select long title meeting      device=device_1    meeting=${Long_meeting_title}
    Verify truncated meeting title      devices=device_1   meeting=${Long_meeting_title}
    [Teardown]  Run Keywords    Capture on Failure    AND     Test Case Teardown    devices=device_1,device_2

TC25 : [Calendar] DUT user should receive any updates, after declining the meeting
    [Tags]  309230   P2  alt_bug
    [Setup]  Testcase Setup    count=2
    create meeting  device=device_2     participants=device_1       meeting=Decline_meeting2
    Navigate to Calendar tab   device=device_1
    Refresh for Meeting Visibility      device=device_1
    Select Meeting      device=device_1    meeting=Decline_meeting2
    Check rsvp status   device=device_1
    Respond to meeting     device=device_1     respond_option=Decline
    Verify declined meeting should not visible    device=device_1    meeting=Decline_meeting2
    Select Meeting      device=device_2    meeting=Decline_meeting2
    Edit meeting name and validate    device=device_2    new_meeting=Decline_meeting2_edited
    Refresh for Meeting Visibility      device=device_1
    verify meeting is visible    device=device_1    meeting=Decline_meeting2_edited
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2

TC6 : [Meetings] For Organizer on DUT, Cancelled meetings should not be displayed in meeting tab
    [Tags]  307139   p2
    [Setup]    Testcase Setup   count=2
    create meeting  device=device_2     participants=device_1    meeting=Cancel_meeting
    Wait for Some Time    time=${wait_time}
    refresh cnf device for meeting visibility     device=device_1
    Select Meeting      device=device_1    meeting=Cancel_meeting
    delete specific meeting    device=device_1    meeting=Cancel_meeting
    Verify meeting should not be displayed   device=device_1      meeting=Cancel_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown     devices=device_1,device_2

TC26 : [Calendar] DUT as Organizer, can be able to search the organizer name in add participant's page.
   [Tags]       309244
   [Setup]  Testcase Setup    count=2
   Verify organizer allowed to be added as participant in meeting     device=device_1     participant=device_1   meeting=organizer_meeting
   [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting   devices=device_1

TC27 :[Calendar] DUT has global search and Call Retrieve option in Calendar tab
   [Tags]      307173
   [Setup]  Testcase Setup    count=1
   Navigate to Calendar tab   device=device_1
   Verify teams app has global search option   device=device_1
   [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC26: [Calendar]DUT User Should Be Able to Save Meeting After Editing, and 'Edit' and 'Cancel' Options Should Not Appear for DUT User as Participant
    [Tags]    309241
    [Setup]    Testcase Setup    count=2
    create meeting  device=device_1     participants=device_2       meeting=test_meeting
    Select Meeting      device=device_1    meeting=test_meeting
    verify user not allowed to save meeting after removing all objects in edit mode    device=device_1
    create meeting  device=device_2     participants=device_1       meeting=test_meeting1
    Select Meeting      device=device_1    meeting=test_meeting1
    Check rsvp status   device=device_1
    Verify Join Button Displayed    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     Test Case Teardown    devices=device_1,device_2

TC27 : [Calendar] DUT user should be allowed to create meeting in past time.
    [Tags]    309235    tp_audio    P2
    [Setup]    Testcase Setup    count=1
    Create Meeting  device=device_1       participants=device_2    meeting=device_meeting3    meeting_time=on    start_meeting_time=on    start_meeting_before=on
    [Teardown]    Run Keywords    Capture On Failure    AND    Delete Meeting    devices=device_1    meeting=device_meeting3

TC18: [Meeting] Verify that Recurrence meeting should be reflected on DUT user 1.
    [Tags]    456115    sanity_tp
    [Setup]    Run Keywords    Testcase Setup    count=3    AND    Clear Notification From Home Screen    device=device_1
    Create Meeting    device=device_2    participants=device_1    meeting=recurrence_meeting    repeat=Every weekday (Mon-Fri)    meeting_time=on    start_meeting_time=on    start_meeting_time_after=10
    Navigate To Calendar Tab    device=device_1
    Verify Meeting Recurrence Indicator    device=device_1
    Come back to home screen page and verify   device=device_1
    Verify Meeting Present On Home Screen    device=device_1    meeting=recurrence_meeting
    delete meeting   devices=device_2    meeting=recurrence_meeting    recurrence=ON
    Clear Notification From Home Screen    device=device_1
    Create Meeting    device=device_3    participants=device_1    meeting=recurrence_meeting    repeat=Every weekday (Mon-Fri)    meeting_time=on    start_meeting_time=on    start_meeting_time_after=10
    Navigate To Calendar Tab    device=device_1
    Verify Meeting Recurrence Indicator    device=device_1
    Come back to home screen page and verify   device=device_1
    Verify Meeting Present On Home Screen    device=device_1    meeting=recurrence_meeting
    [Teardown]    Run Keywords    Capture On Failure    AND    Delete Meeting    devices=device_1    meeting=recurrence_meeting     recurrence=ON

*** Keywords ***
Meeting Suite Setup
    Testcase Setup    count=3
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

Meeting Suite Teardown
    Suite Failure Capture
    Teardown meeting test case      devices=device_1,device_2,device_3
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

Test Case Teardown
    [Arguments]     ${devices}
    Teardown Meeting Test Case     ${devices}
    clear meetings from calendar tab   ${devices}
    Come back to home screen    ${devices}

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}
    Teardown Meeting Test Case     ${devices}
    Come back to home screen    ${devices}

Decline meeting for multiple days
    [Arguments]     ${device}      ${meeting}
    FOR    ${INDEX}    IN RANGE    0    3
       Log    ${INDEX}
       Refresh for Meeting Visibility      device=${device}
       Scroll till meeting visible     device=${device}   meeting=${meeting}
       Select Meeting      device=${device}        meeting=${meeting}
       Verify meeting recurrence indicator symbol     device=${device}
       Check rsvp status   device=${device}
       Respond to meeting     device=${device}     respond_option=Decline
    END
