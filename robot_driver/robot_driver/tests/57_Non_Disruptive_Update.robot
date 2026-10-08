*** Settings ***
Resource    ../resources/keywords/common.robot
Resource    ../resources/keywords/non_disruptive_update.robot

Suite Teardown     Suite Failure Capture

*** Variables ***

*** Test Cases ***

TC1: Verify the consent notification banner is displayed on home screen.
    [Tags]    488664    Sanity_tp    tp_audio
    [Setup]  Testcase Setup  count=1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Postpone the request    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    [Teardown]    Run Keywords    Capture On Failure

TC2: Verify the consent banner is dismissed when user taps on "X" button.
    [Tags]    488666    Sanity_tp    tp_audio
    [Setup]    Testcase Setup    count=1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Dismiss the request    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    [Teardown]    Run Keywords    Capture On Failure

TC3: Verify the consent banner is auto dismissed after 30 seconds.
    [Tags]    488667    Sanity_tp    tp_audio
    [Setup]  Testcase Setup  count=1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=30s
    Verify auto dismiss pattern    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    [Teardown]    Run Keywords    Capture On Failure

TC4: Verify the rejected request consent is sent when user taps on postpone button.
    [Tags]    488665    sanity_tp    tp_audio
    [Setup]    Testcase Setup    count=1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Click On Postpone Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify presence of Intents     device=device_1      feature=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION       state=present
    [Teardown]    Run Keywords    Capture On Failure

TC5: Verify the consent notification banner is displayed on home screen when dark theme is enabled.
    [Tags]    488674    tp_audio
    [Setup]    Testcase Setup    count=1
    verify and enable dark theme    device=device_1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Postpone the request    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    [Teardown]    Run Keywords    Capture On Failure    AND     Verify And Disable Dark Theme    device=device_1    AND     Come Back To Home Screen    device_list=device_1

TC6: Verify that No crash is observed when user runs the adb command in cmd prompt.
    [Tags]    488669     tp_audio
    [Setup]    Testcase Setup    count=1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    action=true
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify presence of Intents     device=device_1      feature=SoftwareUpdateCommandHandler       state=present
    [Teardown]    Run Keywords    Capture On Failure

TC7: Verify the consent notification banner is displayed on calendar, calls, voicemail, people tab.
    [Tags]    488668    bvt_tp  sanity_tp      bvt_pr
    [Setup]    Testcase Setup    count=1
    Navigate To Calendar Tab    device=device_1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Dismiss the request    device=device_1
    Wait For Some Time    10s
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Return To Home Screen    device_list=device_1
    Navigate To Calls Tab    device=device_1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Dismiss the request    device=device_1
    Wait For Some Time    10s
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Return To Home Screen    device_list=device_1
    Navigate To People Tab    device=device_1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Dismiss the request    device=device_1
    Wait For Some Time    10s
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Return To Home Screen    device_list=device_1
    Navigate To Voicemail Tab    device=device_1
    Send Software Update intent   device=device_1
    Wait for Some Time    time=10s
    Dismiss the request    device=device_1
    Wait For Some Time    10s
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Return To Home Screen    device_list=device_1
    [Teardown]    Run Keywords    Capture On Failure

TC8: Verify the logs for deferral Duration In Minutes and execute command When user is in a call.
    [Tags]    488682   p2
    Create Meeting    device=device_2    participants=device_1    meeting=deferral_meeting    meeting_time=on    meeting_duration=60    start_meeting_time=on    start_meeting_time_after=60
    Return To Home Screen    device_list=device_2
    Navigate To Calendar Tab    device=device_1
    Refresh For Meeting Visibility    device=device_1
    Verify Meetings Displayed In Calendar Tab    device=device_1    meeting_list=deferral_meeting
    Return To Home Screen    device_list=device_1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=40
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Return To Home Screen    device_list=device_1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=40
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify presence of Intents     device=device_1      feature=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION       state=present
    Tap To Return To Call    device=device_1
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2  state=Disconnected
	Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=40
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify presence of Intents     device=device_1      feature=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION       state=present
    [Teardown]    Run Keywords    Capture On Failure    AND    clear all day meeting and meeting history from calendar   devices=device_1,device_2    AND    Come Back To Home Screen    device_list=device_1,device_2

TC9: Verify the logs for deferral Duration In Minutes and execute command When user is not in a call.
    [Tags]    488677    p2
    [Setup]    Testcase Setup    count=2
    Create Meeting    device=device_2    participants=device_1    meeting=deferral_meeting    meeting_time=on    meeting_duration=60    start_meeting_time=on    start_meeting_time_after=60
    Return To Home Screen    device_list=device_2
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=80
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify Call State    device_list=device_1    state=disconnected
    Navigate To Calendar Tab    device=device_1
    Refresh For Meeting Visibility    device=device_1
    Verify Meetings Displayed In Calendar Tab    device=device_1    meeting_list=deferral_meeting
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=80
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify presence of Intents     device=device_1      feature=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION       state=present
    [Teardown]    Run Keywords    Capture On Failure    AND    clear all day meeting and meeting history from calendar   devices=device_1,device_2    AND    Come Back To Home Screen    device_list=device_1,device_2

TC10: Verify the logs for deferral Duration In Minutes and execute command When user is not in a call.
    [Tags]    488676    tp_audio
    [Setup]    Testcase Setup    count=2
    Create Meeting    device=device_2    participants=device_1    meeting=deferral_meeting    meeting_time=on    meeting_duration=60    start_meeting_time=on    start_meeting_time_after=60
    Return To Home Screen    device_list=device_2
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=40
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify Call State    device_list=device_1    state=disconnected
    Navigate To Calendar Tab    device=device_1
    Refresh For Meeting Visibility    device=device_1
    Verify Meetings Displayed In Calendar Tab    device=device_1    meeting_list=deferral_meeting
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_cancelled
    [Teardown]    Run Keywords    Capture On Failure    AND    clear all day meeting and meeting history from calendar   devices=device_1,device_2    AND    Come Back To Home Screen    device_list=device_1,device_2

TC11: Verify the logs for deferral Duration In Minutes and execute command When user is not in a call & meeting is cancelled
    [Tags]    488681    tp_audio
    [Setup]    Testcase Setup    count=2
    Create Meeting    device=device_2    participants=device_2    meeting=deferral_meeting    meeting_time=on    meeting_duration=60    start_meeting_time=on    start_meeting_time_after=60
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Call State     device_list=device_1    state=disconnected
    Delete Meeting    devices=device_2   meeting=deferral_meeting
    Return To Home Screen    device_list=device_1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=80
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_cancelled
    [Teardown]    Run Keywords    Capture On Failure    AND    clear all day meeting and meeting history from calendar   devices=device_1,device_2    AND    Come Back To Home Screen    device_list=device_1,device_2
    
TC12: Verify the logs for deferralDurationInMinutes and executecommand When user is in a call.
    [Tags]    488675    tp_audio
    [Setup]    Testcase Setup    count=2
    Create Meeting    device=device_2    participants=device_1    meeting=deferral_meeting    meeting_time=on    meeting_duration=60    start_meeting_time=on    start_meeting_time_after=60
    Return To Home Screen    device_list=device_2
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=80
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Return To Home Screen    device_list=device_1
    Navigate To Calendar Tab    device=device_1
    Verify Meetings Displayed In Calendar Tab    device=device_1    meeting_list=deferral_meeting
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=80
    Wait for Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_scheduled
    Tap To Return To Call    device=device_1
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2  state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    clear all day meeting and meeting history from calendar   devices=device_1,device_2    AND    Come Back To Home Screen    device_list=device_1,device_2

TC13: Verify the logs when the user does not respond to the consent banner and user is not in a call and have no meetings in next 120 mins.
    [Tags]    488670    sanity_tp
    [Setup]    Testcase Setup    count=1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=present
    Wait for Some Time    time=40s
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify Call State    device_list=device_1    state=disconnected
    Verify Calendar Empty    device=device_1
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_cancelled
    [Teardown]    Run Keywords    Capture On Failure    AND     Come Back To Home Screen    device_list=device_1


TC14: Verify the output when the user does clicks on dismiss button and user is not in a call and user does not have meetings in next 120 mins.
    [Tags]    488672    Sanity_TP    P1
    [Setup]    Testcase Setup    count=1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Wait For Some Time    time=10s
    Click On Postpone Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify Call State    device_list=device_1    state=disconnected
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=UserDeferred
    [Teardown]    Run Keywords    Capture On Failure

TC15: Verify the output when the user does clicks on dismiss button and user is not in a call and user does not have meetings in next 120 mins.
    [Tags]    488673    Sanity_TP    P1
    [Setup]    Testcase Setup    count=1
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120
    Wait For Some Time    time=10s
    Click On Dismiss Button    device=device_1
    Verify Postpone And Dismiss Button On Consent Banner    device=device_1    status=absent
    Verify Call State    device_list=device_1    state=disconnected
    Broadcast Disruptive Command Intent    device=device_1    command_type=SoftwareUpdate    timespan_requested_in_minutes=120    
    Verify Multiple Intents    device=device_1      features_list=TEAMS_NOTIFIED_FOR_COMMAND_EXECUTION    intents_list=meeting_cancelled
    [Teardown]    Run Keywords    Capture On Failure
    