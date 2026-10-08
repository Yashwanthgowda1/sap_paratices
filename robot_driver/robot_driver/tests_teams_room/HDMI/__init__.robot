*** Settings ***
Resource    ../../resources/keywords/common.robot
Suite Setup     run keywords   teams desktop client creating meeting for meeting user   AND     teams desktop client creating meeting for user      AND     Sign In     user_list=meeting_user,user,user
Suite Teardown    Suite Failure Capture
*** Variables ***


*** Keywords ***

teams desktop client creating meeting for meeting user
    initiate web driver     tdc_1
    perform web signin method    tdc_1:meeting_user
    create meetings with main teams desktop

teams desktop client creating meeting for user
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    create meetings with secondrary teams desktop

create meetings with main teams desktop
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=cnf_device_meeting    time_duration=20 hr     participants=device_2,device_3   use_current_time=True

create meetings with secondrary teams desktop
    delete all meetings from tdc        device=tdc_1
    create TDC meeting on desktop       device=tdc_1     meeting_name=lock_meeting      time_duration=20 hr     participants=device_1:meeting_user,device_3,tdc_1:non_pro_user     use_current_time=True
