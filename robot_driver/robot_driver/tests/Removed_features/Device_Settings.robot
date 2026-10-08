*** Settings ***
Force Tags    device_settings
Resource    ../resources/keywords/common.robot

#Suite Setup     User Setup Main
#Suite Teardown  User Teardown

*** Variables ***
${wait_time} =      10s
${device_lock_time} =  35


*** Test Cases ***
#TC1 : [Device Settings] User has the option to exit/ come back to teams page
#    [Tags]  146600  bvt  43_bvt
#    [Setup]  Testcase Setup    count=1
#    opens partner settings page  device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Back to home screen fron device settings    device_1
#
#TC2 : [Device Settings] User to access Device Settings from Sign-in page
#    [Tags]  146691  bvt     43_bvt
#    [Setup]  Testcase Setup    count=1
#    sign out method    device_1
#    Access device settings from Signin page    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     sign in method     device_1
#
#TC3 : Sign out option for CAP user should be behind admin settings
#    [Tags]  120888  P1
#    [Setup]  Testcase Setup for CAP User    count=1
#    Verify that sign in is successful   device_list=device_1     state=Sign in
#    Verify user do not have sign out option     device_list=device_1
#    verify signout option should be in device settings    device_list=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Device Setting Teardown   device=device_1
#
#TC4 : [CAP Policy] CAP user should not have the option to enable/disable phone lock
#    [Tags]  147508     P1
#    [Setup]  Testcase Setup for CAP User    count=1
#    Opens partner settings page     device=device_1
#    Verify Phonelock option is not present    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Device Setting Teardown   device=device_1
#
#TC5 : [Calls] Teams App user's call log in the recent tab entry displays the correct time stamp
#    [Tags]  146819  P1
#    [Setup]  Run Keywords    Testcase Setup    count=2  AND    Navigate to calls tab   device=device_1,device_2
#    Make outgoing call using display name    from_device=device_1   to_device=device_2
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Come back to home screen   device_list=device_1
#    ${timezone_value}  Get device current TimeZone    device=device_1
#    ${timezone_name}   get timezone name   ${timezone_value}
#    Change device TimeFormat   device=device_1      required_timeformat=24
#    ${first_call_time}   get call time   device=device_1
#    Change device TimeZone     device=device_1    required_timezone=IST
#    ${call_time_after_tz_change}  get call time   device=device_1
#    ${converted_time}     convert timezone  ${first_call_time}     ${timezone_name}     IST
#    run keyword if  '${call_time_after_tz_change}' == '${converted_time}'    Log   Call Log time got changed according to Changed timezone.
#    ...   ELSE   fail   Unable to change Call Log time according to Changed timezone.
#    [Teardown]   Run Keywords   Capture on Failure     AND     Test Case Teardown    device=device_1,device_2
#
#TC6 : [Calendar] Meetings time synced with the Time zone of the device
#    [Tags]  146239   147600  bvt     43_bvt
#    [Setup]  Run Keywords    Testcase Setup    count=2    AND    Meeting Setup   count=2
#    ${timezone_value}  Get device current TimeZone    device=device_1
#    ${current_timezone_name}   get timezone name   ${timezone_value}
#    Change device TimeFormat   device=device_1      required_timeformat=24
#    Navigate to Calendar tab   device=device_1
#    Select Meeting      device=device_1
#    ${meeting_time}   get_meeting_time   device=device_1
#    Come back to home screen    device_list=device_1
#    Change device TimeZone     device=device_1    required_timezone=IST
#    Navigate to Calendar tab   device=device_1
#    Select Meeting      device=device_1
#    ${meeting_time_after_tz_change}  get_meeting_time   device=device_1
#    Come back to home screen    device_list=device_1
#    ${converted_time}     get_converted_meeting_tz      ${meeting_time}     ${current_timezone_name}     IST
#    run keyword if  '${meeting_time_after_tz_change}' == '${converted_time}'    Log   Meeting time got changed according to Changed timezone.
#    ...   ELSE   fail   Unable to change Meeting time according to Changed timezone.
#    [Teardown]  Capture on Failure
#
#TC7 : [Voicemail] Teams App to display the voicemail's time according to the device time Zone
#    [Tags]  146250    P2
#    [Setup]  Testcase Setup    count=1
#    Navigate to voicemail tab    device=device_1
#    ${timezone_value}  Get device current TimeZone    device=device_1
#    ${current_timezone_name}   get timezone name   ${timezone_value}
#    Change device TimeFormat   device=device_1      required_timeformat=24
#    Navigate to voicemail tab    device=device_1
#    ${voicemail_time}=    get first voicemail time    device=device_1
#    Change device TimeZone     device=device_1    required_timezone=IST
#    Navigate to voicemail tab    device=device_1
#    ${voicemail_time_after_tz_change}=    get first voicemail time    device=device_1
#    ${converted_time}     get_converted_meeting_tz      ${voicemail_time}     ${current_timezone_name}     IST
#    run keyword if  '${voicemail_time_after_tz_change}' == '${converted_time}'    Log   Voicemail time got changed according to Changed timezone.
#    ...   ELSE   fail   Unable to change Voicemail time according to Changed timezone.
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#


*** Keywords ***
Test Case Teardown
    [Arguments]     ${device}
    Device back from tz     device=device_1
    Come back to home screen    device_list=${device}

Back to home screen fron device settings
    [Arguments]     ${device}
    Device Setting Back    ${device}
    Come back to home screen    ${device}

Device Setting Teardown
    [Arguments]     ${device}
    Device Setting Back     ${device}
    Come back to home screen    ${device}

Meeting Setup
    [Arguments]     ${count}
    Remove meeting from calender for meeting policy test      ${count}
    Create Meeting  device=device_1
