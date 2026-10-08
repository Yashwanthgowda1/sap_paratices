*** Settings ***
Resource    ../../resources/keywords/common.robot

Suite Setup     run keywords   teams desktop client creating meeting for meeting user      AND    Teams Console Setup For Shared Mode
Suite Teardown      run keywords    Delete all meetings if exist    AND     Suite Failure Capture

*** Variables ***

*** Keywords ***
teams desktop client creating meeting for meeting user
    initiate web driver     tdc_1
    perform web signin method    tdc_1:meeting_user
    create meetings with main teams desktop

create meetings with main teams desktop
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=room_camera_meeting    time_duration=3 hr     participants=device_2,device_3   use_current_time=True

Delete all meetings if exist
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    delete all meetings from tdc     device=tdc_1
    close web driver        tdc_1