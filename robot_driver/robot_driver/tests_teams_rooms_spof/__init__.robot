*** Settings ***
Resource    ../resources/keywords/common.robot
Suite Setup     run keywords   teams desktop client creating meeting for meeting user      AND     Teams Room Setup
Suite Teardown      Spof teardown

*** Variables ***

*** Keywords ***
Teams Room Setup
    ${config} =     Read Config
    set suite variable      ${config}   ${config}
    Capture config    ${config}
    Start proxy     device_1
    Setup Devices
    Sign in    device_list=device_1      user_list=meeting_user

teams desktop client creating meeting for meeting user
    initiate web driver     tdc_1
    perform web signin method    tdc_1:meeting_user
    create meetings with main teams desktop

create meetings with main teams desktop
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=spof_room_meeting    time_duration=3 hr   use_current_time=True

Delete all meetings if exist
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    delete all meetings from tdc     device=tdc_1
    close web driver        tdc_1

Spof teardown
    Delete all meetings if exist
    System Teardown
    Stop proxy