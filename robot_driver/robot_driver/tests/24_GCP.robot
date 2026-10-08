*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 2 devices in config
...                Purpose: Device_1 should enable call forwarding to call group and add Device_2

Suite Setup         GCP Setup
Suite Teardown      run keywords   Suite Failure Capture     AND     GCP Teardown


*** Variables ***
${wait_time} =  10
${wait_time2} =  25

*** Test Cases ***
TC1 : [GCP] DUT user is on calendar tab and receive forwarded GCP call
    [Tags]  308653   alt_blocked
    [Setup]    Testcase Setup for GCP User  count=3
    Navigate to calendar tab   device=device_2
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_2,device_3

TC2 : [GCP] DUT user is on Device Settings page and receive forwarded GCP call
    [Tags]  308661    alt_blocked        Certification_audio
    [Setup]   Testcase Setup for GCP User  count=3
    Navigate to device setting page     device=device_2
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Pick incoming call in device settings page    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Device Setting Back   device=device_2   AND   Come back to home screen   device_list=device_2,device_3

TC3 :[Group Call] Incoming forwarded group calls should collapse to a banner when more then one call hits to the device
    [Tags]      321015      P2
    [Setup]   Testcase Setup for GCP User  count=4
    Navigate to calls tab   device=device_3,device_4
    initiate simultaneous call  devices=device_3,device_4   target_device=device_1    method=display_name
    verify multiple incoming group call notification  device=device_2
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3,device_4

TC4 :[Group Call] Verify Menu from Audio group call
    [Tags]      334106      P2
    [Setup]   Testcase Setup for GCP User  count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call from call notification    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    verify call control visibility      device_list=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3

TC5 :[GCP] DUT user should be able to ignore the incoming forwarded group call
    [Tags]     318192      P2
    [Setup]   Testcase Setup for GCP User  count=4
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Reject incoming call from call notification    device=device_4
    Verify call notification    device=device_4     status=disappear
    Pick incoming call from call notification    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3,device_4

TC6 :Verify Send to Voicemail option should not present for incoming forwarded group call notification
    [Tags]     452360      sanity_tp           phonesCY23_4
    [Setup]   Testcase Setup for GCP User  count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    verify group incoming call notification should not contains redirect to voicemail     device=device_2         from_device=device_3      to_device=device_1
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3

TC7 : [Home Screen] DUT user is on home screen and receive GCP call
    [Tags]    310376     P2  alt_credentials
    [Setup]    Testcase Setup for GCP User    count=3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3

*** Keywords ***
GCP Setup
    Enable call forwarding to call group     from_device=device_1    contact_device=device_2

GCP Teardown
    Disable Call forward

Call Ring Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    Come back to home screen    device_list=device_1,device_2,device_3
    Disable Also Ring    device=device_1

Test Case Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    Come back to home screen    device_list=device_1,device_2,device_3

Unanswered call Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    Come back to home screen    device_list=device_1,device_2,device_3
    Disable unanswered call    device=device_1      contact_device=device_2

Disable Call forward
    #device_setting_back     device=device_2
    Come back to home screen    device_list=device_1,device_2,device_3
    verify and disable call forwarding    device=device_1

verify devices and teardown
    Capture on Failure
    Device Setting Back   device=device_2
    Come back to home screen   device_list=device_2,device_3,device_4,device_5

verify device criteria and teardown
    Run Keyword If      ${tc_flag}==True    run keyword     verify devices and teardown