*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time_20s} =  20
${wait_time} =    10

*** Test Cases ***
TC1: DUT user able to receive the Voicemail by tapping on Send to voicemail option on Incoming call UI.
    [Tags]  452348  bvt_lcp    sanity_lcp      phonesCY23_4
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2
    Play voicemail    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC2: DUT user to get Send to Voicemail button when user receive multiple incoming calls at the same time
    [Tags]  452361
    [Setup]  Testcase Setup     count=2
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    verify and click send to voicemail option for incoming call          device=device_1    option=appear
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Call Forward] DUT user to forward TDC call to voicemail
	[Tags]  242938  bvt_lcp    sanity_lcp    tp_lcp
	[Setup]  Testcase Setup    count=2
	Enable unanswered call to voicemail    from_device=device_1    contact_device=device_2
	navigate to people tab    device=device_2
	Make outgoing call using display name    from_device=device_2      to_device=device_1
	verify incoming call        device=device_1         status=appear
	Wait For Some Time    time=50s
	Verify Call State    device_list=device_1    state=disconnected
	Wait for Some Time    time=${wait_time}
	Verify Call State    device_list=device_2    state=connected
	Disconnect call        device=device_2
	Verify Call State    device_list=device_2     state=Disconnected
	Wait for Some Time    time=${wait_time}
	Verify Call State    device_list=device_1,device_2    state=disconnected
	Navigate to voicemail tab    device=device_1
	Wait For Some Time    time=${wait_time}
	verify first voicemail displayname  to_device=device_1    from_device=device_2
	Play voicemail    device=device_1
	[Teardown]  Run Keywords    Capture on Failure    AND   Disable unanswered call   device=device_1    contact_device=device_2    AND   Come back to home screen    device_list=device_1,device_2

TC4: [Outgoing Calls] DUT user calls TDC user for which VM is enabled and VM is disabled
    [Tags]    318558
    [Setup]  run keywords   Testcase Setup   count=2   AND     Enable unanswered call to voicemail     from_device=device_2    contact_device=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    verify incoming call    device=device_2    status=appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1    state=Connected
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=disconnected
    Navigate to voicemail tab    device=device_2
    verify first voicemail displayname    to_device=device_2    from_device=device_1
    Play voicemail    device=device_2
    Device Setting Back     device=device_2
    Disable unanswered call   device=device_2    contact_device=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    verify incoming call    device=device_2    status=appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_2
    Verify Call State    device_list=device_2,device_1     state=Disconnected
    Navigate to voicemail tab    device=device_2
    [Teardown]   Run Keywords    Capture on Failure     AND    Disable unanswered call   device=device_2    contact_device=device_1    AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Presence] DUT user can see the correct presence in Voice mail tab (in the form of presence icon only)
    [Tags]    243342    p2
    [Setup]   Testcase Setup     count=2
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname    to_device=device_1    from_device=device_2
    verify presence status in voicemail tab    from_device=device_1    to_device=device_2
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC6: [Voicemail] DUT to receive the Voicemail
    [Tags]    242915    BVT_LCP    FTP_Scope    Sanity_LCP    tp_lcp    p1
    [Setup]   Run Keywords    Testcase Setup    count=2    AND    Enable call forwarding to voicemail    from_device=device_1   contact_device=device_2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Wait For Some Time    time=30
    Disconnect call        device=device_2
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_15      state=present
    Wait for Some Time    time=${wait_time_20s}
    verify first voicemail displayname    to_device=device_1    from_device=device_2
    Play voicemail    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2    AND     verify and disable call forwarding   device=device_1

TC7: [Voicemail] DUT user can decline the incoming call while playing VM
    [Tags]    243204    tp_lcp    p2
    [Setup]   Run Keywords    Testcase Setup    count=3    AND    Enable call forwarding to voicemail    from_device=device_1   contact_device=device_2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Wait For Some Time    time=120
    Disconnect call        device=device_2
    verify and disable call forwarding   device=device_1
    Navigate to voicemail tab    device=device_1
    Wait For Some Time    time=${wait_time_20s}
    verify first voicemail displayname    to_device=device_1    from_device=device_2
    navigate to people tab    device=device_3
    Play voicemail    device=device_1
    Make outgoing call using display name    from_device=device_3      to_device=device_1    
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3    AND    verify and disable call forwarding    device=device_1

TC8:DUT user able to receive the voicemail by tapping send to Voicemail button in incoming Call UI for forwarding call.
    [Tags]    452363        P1
    [Setup]  Testcase Setup  count=3
    Enable call forwarding to contacts     from_device=device_2   contact_device=device_1
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_3    state=Connected
    Verify Call State    device_list=device_1,device_2        state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_3
    Play voicemail    device=device_1
    [Teardown]   run keywords  Capture on Failure    AND       verify and Disable Call forwarding       device=device_2    AND    come back to home screen  device_list=device_1,device_2,device_3
    
