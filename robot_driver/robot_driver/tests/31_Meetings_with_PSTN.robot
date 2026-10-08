*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation   Suite Setup Requirements : This suite requires minimum of 3 devices in config
...             Purpose : Device_1,Device_2 & Device_3 should clear meetings from calendar tab
...                       Device_1 & Device_3 create different meetings and add Device_3 & Device_1 as participants respetively

Suite Setup     Meeting Setup
Suite Teardown     Run keyword and ignore error    Meeting Teardown

*** Variables ***
${wait_time} =  10
${20s_wait_time} =  20

*** Test Cases ***
TC 01: [Calendar] DUT user joins Teams meeting using Dial-in info
    [Tags]  306787  meeting_pstn    sanity_tp    bvt_pr         alt_blocked       Certification_audio
    [Setup]    Testcase Setup for PSTN User   count=3
    Navigate to Calendar tab   device=device_1
    Wait for Some Time    time=${wait_time}
    ${phone_no}     ${conference_id}     Get meeting conference id   device=device_1    meeting=pstn_meeting
    Refresh for Meeting Visibility      device=device_3
    Join meeting   device=device_1,device_3    meeting=pstn_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_3    state=Connected
    join meeting by dial in conference   device_2     ${phone_no}     ${conference_id}
    Verify lobby notification    devices=device_1
    View lobby and select option    from_device=device_1     option=admit
    wait for some time  time=20s
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Verify participant list from meeting roster     device=device_1      connected_device_list=device_1,device_2:pstn_user,device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC 02: [Calendar] DUT user admit user from lobby to meeting
    [Tags]      308750      P1  alt_blocked     Certification_audio
    [Setup]    Testcase Setup for PSTN User   count=3
    Navigate to Calendar tab   device=device_1
    Wait for Some Time    time=${wait_time}
    ${phone_no}     ${conference_id}     Get meeting conference id   device=device_1    meeting=pstn_meeting
    Refresh for Meeting Visibility      device=device_3
    Join meeting   device=device_1,device_3    meeting=pstn_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_3    state=Connected
    join meeting by dial in conference   device_2     ${phone_no}     ${conference_id}
    Wait for Some Time    time=${20s_wait_time}
    Verify lobby notification    devices=device_1,device_3
    View lobby and select option    from_device=device_1     option=admit
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Verify participant list from meeting roster     device=device_1      connected_device_list=device_2:pstn_user,device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1

TC 03: [Lightweight meeting] Verify the UI when DUT user makes an outgoing PSTN call in an ongoing meeting
    [Tags]      401856   sanity_tp    P1
    [Setup]     Testcase Setup for PSTN User    count=3
    Join Meeting    device=device_1,device_3     meeting=meeting_pstn
    verify meeting state   device_list=device_1,device_3       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_3
    click back      device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2    state=Disconnected
    resume the meeting      device=device_1
    verify lightweight meeting ui   device=device_1     participants=device_3
    End meeting     device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Test Case Teardown without deleting meeting     devices=device_1

TC04 : [Attendee] Add participant option should not be available for PSTN user
    [Tags]  311008   p2  alt_blocked
    [Setup]     Testcase Setup for PSTN User   count=2
    Join Meeting    device=device_1   meeting=meeting_pstn
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1   state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify add participant button should not visible for attendee    device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Test Case Teardown without deleting meeting    devices=device_1,device_2

TC5 :[Hard Key] DUT user to press hard key while on Calendar description page
    [Tags]      308984           Certification_audio
    [Setup]     Testcase Setup for PSTN User   count=2
    ${dailpad_device}   Is Hard Dial Pad Present   device=device_1
    pass execution if   '${dailpad_device}'=='False'  device_1, device is not have dailpad
    Navigate to Calendar tab   device=device_1
    Wait for Some Time    time=${wait_time}
    Get meeting conference id   device=device_1    meeting=pstn_meeting
    dail phone number from hard keys   device=device_1    to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Meeting Setup
    Testcase Setup    count=1
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    Create meeting   device=device_1    meeting=pstn_meeting     participants=device_3
    create meeting   device=device_3    meeting=meeting_pstn    participants=device_1

Meeting Teardown
    Suite Failure Capture
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    Come back to home screen   device_list=device_1,device_2,device_3

Remove Meeting
    [Arguments]     ${devices}
    Remove meeting from calender   ${devices}

Test Case Teardown
    [Arguments]     ${devices}      ${meeting}    ${count}
    come_back_home_screen_for_user    ${count}
    Teardown Meeting Test Case     ${devices}
    Delete meeting      ${devices}    ${meeting}
    remove_meeting_from_calender_for_user   ${count}

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}
    Come back to home screen    ${devices}
    Teardown Meeting Test Case     ${devices}
