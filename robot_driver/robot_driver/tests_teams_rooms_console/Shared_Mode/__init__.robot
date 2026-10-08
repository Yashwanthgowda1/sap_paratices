*** Settings ***
Resource    resources/keywords/common.robot
Suite Setup     run keywords    Teams Console Setup For Shared Mode    AND     setup tdc meetings

*** Variables ***


*** Keywords ***

setup tdc meetings
    ${passed} =    Run Keyword And Return Status  launch browser and signin   device=tdc_1:meeting_user
     # Retry once if necessary:
    Run Keyword If  ${passed} == False  launch browser and signin   device=tdc_1:meeting_user
    setup meeting user meetings    device=tdc_1:meeting_user
    ${passed} =    Run Keyword And Return Status  launch browser and signin   device=tdc_1:user
     # Retry once if necessary:
    Run Keyword If  ${passed} == False  launch browser and signin   device=tdc_1:user
    ${passed} =    Run Keyword And Return Status  setup regular user meeting    device=tdc_1:user
    close_web_driver    device=tdc_1:user

launch browser and signin
    [Arguments]     ${device}
    initiate web driver     device=${device}
    perform web signin method    device=${device}

setup meeting user meetings
    [Arguments]     ${device}
    ${passed} =    Run Keyword And Return Status  delete all meetings from tdc     device=${device}
    ${passed} =    Run Keyword And Return Status  create TDC meeting on desktop    device=${device}     meeting_name=rooms_console_meeting    time_duration=20 hr     participants=device_2,device_3   use_current_time=True
    ${passed} =    Run Keyword And Return Status  create TDC meeting on desktop    device=${device}     meeting_name=all_day_meeting      all_day_meeting=on
    ${passed} =    Run Keyword And Return Status  create TDC meeting on desktop    device=${device}     meeting_name=all_day_meeting_1        all_day_meeting=on
    ${passed} =    Run Keyword And Return Status  create TDC meeting on desktop    device=${device}     meeting_name=all_day_meeting_2        all_day_meeting=on
    ${passed} =    Run Keyword And Return Status  create TDC meeting on desktop    device=${device}     meeting_name=non_allday_meeting       use_current_time=True       following_day_meeting=on
    ${passed} =    Run Keyword And Return Status  create TDC meeting on desktop    device=${device}     meeting_name=rooms_private_meeting        time_duration=20 hr     private_meeting=on      use_current_time=True

setup regular user meeting
    [Arguments]     ${device}
    ${passed} =    Run Keyword And Return Status  delete all meetings from tdc        device=${device}
    ${meeting_id}    ${passcode} =  create TDC meeting on desktop       device=${device}     meeting_name=console_lock_meeting      time_duration=20 hr     participants=device_1:meeting_user,device_1:pstn_user,device_3,tdc_1:non_pro_user   use_current_time=True       fetch_meeting_info=True
    Set Global Variable    ${tdc_meeting_id}    ${meeting_id}
    Set Global Variable    ${tdc_meeting_passcode}    ${passcode}
