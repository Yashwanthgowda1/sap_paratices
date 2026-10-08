*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [GCP] DUT user accept group call and perform Mute/hold
    [Documentation]  Precondition device_3 add device_1 and device_2 as call group members
    [Tags]      449964
    [Setup]   run keywords     Testcase Setup for CAP Premium User    count=4   AND     Enable call forwarding to call group     from_device=device_3    contact_device=device_1
    click on calls tab     device=device_4
    Make outgoing call using phonenumber    from_device=device_4      to_device=device_3
    Verify call notification    device=device_1,device_2     status=appear
    Verify gcp call name on call toast      device=device_1,device_2     from_device=device_3
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Verify Call mute State    device_list=device_4    state=Unmute
    Unmutes the phone call   device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_4    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_4     state=Resume
    Disconnect call     device=device_4
    Verify Call State    device_list=device_1,device_4     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4     AND     verify and disable call forwarding    device=device_3

TC2 :Verify Send to Voicemail option should not present for incoming forwarded group call notification.
    [Tags]     452853       Sanity_CAPPremium           phonesCY23_4
   [Setup]   run keywords     Testcase Setup for CAP Premium and GCP User    count=3   AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    verify group incoming call notification should not contains redirect to voicemail     device=device_2         from_device=device_3      to_device=device_1:cap_search_enabled
    [Teardown]  run keywords  Capture on Failure   AND     Disable Call forward    devices=device_1,device_3


*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1