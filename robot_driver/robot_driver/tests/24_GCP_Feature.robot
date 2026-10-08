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
TC1 : [GCP] DUT user accepts forwarded group call and perform Mute/hold
    [Tags]  308624   P1  alt_blocked
    [Setup]   Testcase Setup for GCP User   count=3
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Mutes the phone call    device=device_2
    Verify meeting Mute State    device_list=device_2    state=mute
    Verify meeting Mute State    device_list=device_3    state=Unmute
    Unmutes the phone call   device=device_2
    Verify meeting Mute State    device_list=device_2    state=Unmute
    Hold the call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Hold
    Resume the call   device=device_2
    Verify Call State    device_list=device_2,device_3     state=Resume
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_2,device_3

TC2 : [GCP] DUT user is on contact search page and receive forwarded GCP call
    [Tags]  308642   P2  alt_blocked
    [Setup]   Testcase Setup for GCP User   count=3
    Navigate contact search page   device=device_2
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_2,device_3

TC3 : [GCP] DUT user playing a VM and receive forwarded GCP call
    [Tags]  308648   P2  alt_blocked
    [Setup]  run keywords  Testcase Setup for GCP User   count=3    AND    Voicemail Setup
    Navigate to voicemail tab   device=device_2
    refresh the page  device=device_2
    Play voicemail    device=device_2
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_2,device_3

TC4 : [GCP]DUT user leaving a VM and receive forwarded GCP call
    [Tags]  308650   P1  alt_blocked
    [Setup]  run keywords  Testcase Setup for GCP User   count=3    AND     Set Call Forwarding    device=device_3
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Verify Call State    device_list=device_2   state=Connected
    Wait for Some Time    time=${wait_time}
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_2,device_3    AND    verify and disable call forwarding    device=device_3

TC5 : [GCP] DUT user receives the incoming call group when TDC user set "Also ring" to call group
    [Tags]  308663   P1  alt_blocked
    [Setup]  run keywords   Testcase Setup for GCP User  count=3   AND    Disable Call forward   AND   Enable Also Ring Call group     device=device_1
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3   AND    Disable Also Ring    device=device_1

TC6 : [GCP] DUT user already in P2P call, accept forwarded GCP call, toggle between calls
    [Tags]  308635   P1  alt_blocked        Certification_audio
    [Setup]  run keywords   Testcase Setup for GCP User   count=3   AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:gcp_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_1     state=Hold
    Verify Call State    device_list=device_2,device_3    state=Connected
    resume call from call hold banner     device=device_2
    Verify Call State    device_list=device_3     state=Hold
    Disconnect call     device=device_3,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward

TC7 : [GCP] DUT user already in meeting, accept forwarded GCP call, toggle between calls
    [Tags]  308632   P1  alt_blocked
    [Setup]  run keywords   Testcase Setup for GCP User   count=3   AND   Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    create meeting  device=device_1     participants=device_2:gcp_user       meeting=GCP_meeting
    Navigate to Calendar tab   device=device_2
    Refresh for Meeting Visibility      device=device_2
    Wait until Meeting is Reflected     device=device_2    meeting=GCP_meeting
    Join Meeting    device=device_1,device_2     meeting=GCP_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    resume call from call hold banner     device=device_2
    Verify Call State    device_list=device_3     state=Hold
    Disconnect call     device=device_1,device_3,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Meeting Teardown     devices=device_1,device_2

TC8 : [GCP] User should be able to receive incoming forwarded group call at recent tab
    [Tags]  320074   P2
    [Setup]  Run Keywords   Testcase Setup for GCP User   count=3    AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    navigate to calls tab   device=device_2
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward


*** Keywords ***
GCP Setup
    Enable call forwarding to call group     from_device=device_1    contact_device=device_2

GCP Teardown
    Disable Call forward

Voicemail Setup
    Set Call Forwarding    device=device_2
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:gcp_user
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1   state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Come back to home screen    device_list=device_1
    verify and disable call forwarding    device=device_2

Disable Call forward
    verify call state and disconnect      device=device_1,device_2,device_3
    Come back to home screen    device_list=device_1,device_2,device_3
    verify and disable call forwarding    device=device_1

Meeting Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      device=device_1,device_2,device_3
    Come back to home screen    device_list=device_1,device_2,device_3
    Teardown Meeting Test Case     ${devices}
    clear meetings from calendar tab      ${devices}
    Come back to home screen    device_list=device_1,device_2,device_3
    verify and disable call forwarding    device=device_1