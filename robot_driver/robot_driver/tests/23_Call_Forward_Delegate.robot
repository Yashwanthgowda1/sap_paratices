*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 should add Device_2:delegate_user as Delegate and enable Call Forwarding to Delegates.

Suite Setup     Call Forward Suite Setup
Suite Teardown      Call Forward Suite Teardown


*** Variables ***
${wait_time} =  10
${wait_time2} =  20

*** Test Cases ***
TC1 : [OBO] While DUT user on search a contact page receives delegate call_call forwarding
    [Tags]    308710   P2  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=3
    Navigate contact search page   device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC2 : [OBO] DUT user while playing voicemail receives a delegate call_call forwarding
    [Tags]  308716   P2  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=3
    Navigate to voicemail tab   device=device_2
    Play voicemail    device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC3 : [OBO]DUT user while leaving a voicemail receives delegate call_call forwarding
    [Tags]  308719   P2  alt_blocked
    [Setup]   run keywords     Testcase Setup for Delegate User  count=3    AND     Set Call Forwarding    device=device_3
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=myself
    Verify Call State    device_list=device_2,device_3   state=Connected
    Wait for Some Time    time=${wait_time}
    Come back to home screen    device_list=device_3   disconnect=False
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3    AND    verify and disable call forwarding    device=device_3

TC4 : [OBO] DUT user on calendar tab receive delegate call_ call forwarding
    [Tags]  308722   P1  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=3
    Navigate to calendar tab   device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC5 : [OBO] When DUT user on Teams App settings page receive delegate call_ call forwarding
    [Tags]  308729   P1  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=3
    Open settings page   device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC6 :Verify DUT user should get the Private line call from TDC user when DUT user set the Call forwarding to Delegates
    [Tags]  476405     P2
    [Setup]  Testcase Setup for Delegate User   count=3
    Click on calls tab   device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_2     status=disappear
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen   device_list=device_1,device_2,device_3

*** Keywords ***
Call Forward Suite Setup
    Testcase Setup for Delegate User   count=3
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    Enable call forwarding to delegates     from_device=device_1    contact_device=device_2

Call Forward Suite Teardown
    Suite Failure Capture
    verify and disable call forwarding    device=device_1

Call forward teardown
    verify and disable call forwarding    device=device_1
    verify and disable call forwarding    device=device_3
    Delete delegate from manage delegate   from_device=device_3    to_device=device_2:delegate_user

verify devices and call forward teardown
    Capture on Failure
    Come back to home screen   device_list=device_2,device_3,device_4,device_5
    Call forward teardown

Verify device criteria and call forward teardown
    Run Keyword If      ${tc_flag}==True    run keyword     verify devices and call forward teardown
