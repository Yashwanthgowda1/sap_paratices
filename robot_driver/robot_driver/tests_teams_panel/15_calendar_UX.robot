*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown   Run Keywords   Suite Failure Capture       AND     Come back to home screen    device_list=device_1

*** Variables ***
${Long_meeting_title} =  Meeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeetttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiinnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
${display_time} =  5

*** Test Cases ***
TC1:[Refresh Calendar UX] Verify Default screen UI in Available state
    [Tags]  321262
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    verify scrollable agenda view  device=device_1
    verify meeting details in scrollable agenda view  device=device_1
    [Teardown]  Capture on Failure

TC2:[Refresh Calendar UX] Verify "All daymeeting count should be displayed in the home screen calendar tile, and verify list is scrollable
    [Tags]  316442   bvt   sanity	 bvt_panels     bvt_panels_pr       TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=m1      participants=device_1    all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=m2       participants=device_1   all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=m3       participants=device_1   all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=m4       participants=device_1   all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=m5       participants=device_1   all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=m6       participants=device_1   all_day_meeting=on
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    Refresh calls main tab  device=device_1
    Verify multiple all day meetings in panel   device=device_1     meeting_list=m1,m2,m3,m4,m5,m6
    [Teardown]  Run Keywords    Capture on Failure   AND    delete all meetings from tdc     device=tdc_1:meeting_user     meeting_list=m1,m2,m3,m4,m5,m6

TC3:[Calendar UX] Verify Default screen UI with only one all day available meeting, date/time text says "All-day"
    [Tags]  322028      TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_1     participants=device_1    all_day_meeting=on
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    Verify one all day meeting in panel   device=device_1     meeting=panel_1
    [Teardown]  Run Keywords    Capture on Failure      AND    delete all meetings from tdc     device=tdc_1:meeting_user      meeting_list=panel_1

TC4:[CHD][Teams Panel][Calendar Layout]Verify available current time slot when all day and 2 consecutive meeting scheduled
    [Tags]  322227      TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    validate room availability status   device=device_1   status=available
    verify room availability to reserve  device=device_1    action=reserve
    validate room availability status   device=device_1   status=reserved
    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=panel_all_day       participants=device_1    all_day_meeting=on
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    verify no meeting can be reserved on panel      device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    cancel the current reserved meeting     device=device_1     AND     delete all meetings from tdc    device=tdc_1:meeting_user    meeting_list=panel_all_day

TC6: [Home screen] Verify that the Teams Logo shows for an teams meeting
    [Tags]  321295      TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=m1      participants=device_1    all_day_meeting=on
    Refresh calls main tab  device=device_1
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=m1       count_of_other_meetings=1
    [Teardown]  Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user     meeting_list=m1

TC7: [Calendar Enhancement] Current meeting tile should scroll with the rest of the calendar
    [Tags]  333206      TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=panel1      time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=panel2       time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=panel3       time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=panel4       time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=panel1,panel2,panel3,panel4      count_of_other_meetings=4
    [Teardown]  Run Keywords    Capture on Failure   AND   delete all meetings from tdc     device=tdc_1:meeting_user       meeting_list=panel1,panel2,panel3,panel4

TC8: [Calendar Enhancement] Verify that All day meeting count should be shown when All day meetings are scheduled more than 2
    [Tags]  333207   bvt   sanity	 bvt_panels     bvt_panels_pr       TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=Panel_allday1       participants=device_1    all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=Panel_allday2        participants=device_1   all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=Panel_allday3        participants=device_1   all_day_meeting=on
    Wait for Some Time    time=${display_time}
    Refresh calls main tab  device=device_1
    Refresh calls main tab  device=device_1
    Verify multiple all day meetings in panel   device=device_1     meeting_list=Panel_allday1,Panel_allday2,Panel_allday3
    [Teardown]  Run Keywords    Capture on Failure      AND    delete all meetings from tdc     device=tdc_1:meeting_user       meeting_list=Panel_allday1,Panel_allday2,Panel_allday3

TC9: [Calendar UX] Verify Default screen UI with All day meeting with other meeting and no other meeting
    [Tags]  322025   sanity     TDC_meeting_test
    [Setup]  Testcase Setup   count=1
    verify room parameters   device=device_1
    # all-day meeting = 3 and other meeting = 0
    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=allday1     participants=device_1    all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=allday2      participants=device_1   all_day_meeting=on
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=allday3      participants=device_1   all_day_meeting=on
    Refresh calls main tab  device=device_1
    verify all all day reserved meeting parameters in panel     device=device_1     organizer=tdc_1:meeting_user   all_day_meeting_list=allday2,allday3       count_of_all_day_meetings=3
    # all-day meeting = 3 and other meeting = 1
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=other_meeting1      time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    verify all all day reserved meeting parameters in panel     device=device_1     organizer=tdc_1:meeting_user   all_day_meeting_list=allday1,allday2,allday3       count_of_all_day_meetings=3
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=other_meeting1       count_of_other_meetings=1
    # all-day meeting = 3 and other meeting = 3
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=other_meeting2      time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=other_meeting3       time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    Refresh calls main tab  device=device_1
    verify all all day reserved meeting parameters in panel     device=device_1     organizer=tdc_1:meeting_user   all_day_meeting_list=allday1,allday2,allday3       count_of_all_day_meetings=3
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=other_meeting1,other_meeting2,other_meeting3       count_of_other_meetings=3
    # removing all other meetings
    delete all meetings from tdc     device=tdc_1:meeting_user     meeting_list=other_meeting1,other_meeing2,other_meeting3
    #verify all-day meeting = 3 and other meeting = 0
    Refresh calls main tab  device=device_1
    verify all all day reserved meeting parameters in panel     device=device_1     organizer=tdc_1:meeting_user   all_day_meeting_list=allday1,allday2,allday3       count_of_all_day_meetings=3
    # removing all all-day meeting
    delete all meetings from tdc     device=tdc_1:meeting_user      meeting_list=allday1,allday2,allday3
    Refresh calls main tab  device=device_1
    # verifying other meeting = 3 and all-day meeting = 0
    create TDC meeting    device=tdc_1:meeting_user     meeting_name=other_meeting1      time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=other_meeting2       time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=other_meeting3       time_duration=30 min       participants=device_1      use_current_time=True      roundup_end_time=off
    Refresh calls main tab  device=device_1
    verify all normal reserved meeting parameters in panel      device=device_1     other_meeting_list=other_meeting1,other_meeting2,other_meeting3       count_of_other_meetings=3
    [Teardown]  Run Keywords    Capture on Failure      AND    delete all meetings from tdc     device=tdc_1:meeting_user       meeting_list=allday1,allday2,allday3,other_meeting1,other_meeing2,other_meeting3

TC10: [Refresh Calendar UX] Verify Default screen UI after refresh/pull to refresh
    [Tags]  321993
    [Setup]  Testcase Setup   count=1
    verify room parameters    device=device_1
    verify scrollable agenda view  device=device_1
    verify meeting details in scrollable agenda view  device=device_1
    [Teardown]  Run Keywords    Capture on Failure


*** Keywords ***

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1


cancel the current reserved meeting
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    Come back to home screen    device_list=device_1
    checkout of the reserved meeting   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

Cancel all All Day Events
    [Arguments]     ${devices}      ${meeting}
    Come back to home screen    ${devices}
    Teardown Meeting Test Case     ${devices}
    Delete all day meetings      ${devices}    ${meeting}
    Come back to home screen    ${devices}

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}    ${roundup_end_time}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}     roundup_end_time=${roundup_end_time}

Create all day TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${participants}     ${all_day_meeting}
    create TDC meeting on desktop      ${device}     ${meeting_name}     participants=${participants}     all_day_meeting=${all_day_meeting}