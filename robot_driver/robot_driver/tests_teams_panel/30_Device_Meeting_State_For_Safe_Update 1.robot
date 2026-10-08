*** Settings ***
Resource    ../resources/keywords/common.robot
Resource    ../resources/keywords/non_disruptive_update.robot


Suite Teardown     Suite Failure Capture

*** Test Cases ***
TC1:Verify the output in logcat when user runs the command in the command prmpt.
    [Tags]    532322    bvt_panels    sanity
    [Setup]   Testcase Setup    count=1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_cancelled
    [Teardown]    Run Keywords    Capture On Failure    AND       Come back to home screen    device_list=device_1

TC2:Verify that No crash is observed when user runs the adb command in cmd prompt.
    [Tags]    532323    sanity    bvt_panels
    [Setup]    Testcase Setup    count=1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    action=true
    Verify homescreen on panel   device=device_1
    Verify presence of Intents     device=device_1      feature=SoftwareUpdateCommandHandler    state=present
    [Teardown]    Run Keywords    Capture On Failure    AND       Come back to home screen    device_list=device_1

TC3:Verify the logcat logs when the device has a reservation for 30min.
    [Tags]    532325 
    [Setup]    Testcase Setup    count=1
    create TDC meeting      device=tdc_1:meeting_user     meeting_name=test_meeting      time_duration=30 min       participants=device_1     use_current_time=True      start_meeting_time=on    start_meeting_time_after=30
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_scheduled
    [Teardown]    Run Keywords    Capture On Failure    AND   delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=test_meeting    AND       Come back to home screen    device_list=device_1

TC4:Verify the logcat logs when the device does not have reservation in next 120 mins.
    [Tags]    532324   sanity
    [Setup]    Testcase Setup    count=1
    validate room availability status   device=device_1   status=available
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_cancelled
    [Teardown]    Run Keywords    Capture On Failure    AND   Come back to home screen    device=device_1

TC5:Verify the logs for deferralDurationInMinutes and executecommand when there is a reservation in next timespanRequestedInMinutes
    [Tags]    532327
    [Setup]    Testcase Setup    count=1
    create TDC meeting      device=tdc_1:meeting_user     meeting_name=test_meeting      time_duration=30 min       participants=device_1     use_current_time=False     start_meeting_time=on    start_meeting_time_after=60
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=40
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_cancelled
    [Teardown]    Run Keywords    Capture On Failure    AND   delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=test_meeting    AND   Come back to home screen    device_list=device_1

TC6:Verify the logs for deferralDurationInMinutes and executecommand when there is a reservation in next timespanRequestedInMinutes
    [Tags]    532328    sanity
    [Setup]    Testcase Setup    count=1
    create TDC meeting      device=tdc_1:meeting_user     meeting_name=test_meeting      time_duration=30 min       participants=device_1     use_current_time=False     start_meeting_time=on    start_meeting_time_after=60
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=80
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_scheduled
    [Teardown]    Run Keywords    Capture On Failure    AND   delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=test_meeting    AND   Come back to home screen    device_list=device_1

*** Keywords ***

Create TDC Meeting
    [Arguments]       ${device}      ${meeting_name}     ${time_duration}    ${participants}     ${use_current_time}   ${start_meeting_time}    ${start_meeting_time_after}
    create TDC meeting on desktop      ${device}     ${meeting_name}      ${time_duration}     participants=${participants}     use_current_time=${use_current_time}   start_meeting_time=${start_meeting_time}   start_meeting_time_after=${start_meeting_time_after}
 