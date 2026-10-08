*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 should add Device_2:delegate_user as Delegate and enable Also Ring.

Suite Setup       Simul Ring Suite Setup
Suite Teardown    Run keyword and ignore error      Simul Ring Suite Teardown


*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [OBO] DUT user on Search a contact page receive delegate call_also ring
    [Tags]  308684   P2  alt_blocked
    [Setup]  Testcase Setup for Delegate User  count=3
    Navigate contact search page   device=device_2
    Click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC2 : [OBO] DUT user while playing a VM Receive delegate call_Also ring
    [Tags]  308690   P2  alt_blocked
    [Setup]  run keywords    Testcase Setup for Delegate User  count=3   AND    Voicemail Setup
    Navigate to voicemail tab   device=device_2
    Play voicemail    device=device_2
    Click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC3 : [OBO]DUT user while leaving a VM Receive delegate call_Also ring
    [Tags]  308693   P2  alt_blocked
    [Setup]   run keywords   Testcase Setup for Delegate User  count=3    AND     Set Call Forwarding    device=device_3
    Initiate OBO call using display name  from_device=device_2      to_device=device_3      obo_option=myself
    Verify Call State    device_list=device_2   state=Connected
    Wait for Some Time    time=${wait_time}
    return to home screen    device_list=device_3
    Click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call   device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    verify call state and disconnect     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3    AND    verify and disable call forwarding    device=device_3

TC4 : [OBO] DUT user on calendar tab receive delegate call_ Also ring
    [Tags]  308696   P1  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=3
    Navigate to calendar tab   device=device_2
    Click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC5 : [OBO] When DUT user on Teams App settings Page receive delegate call_Also ring
    [Tags]  308702   P1  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=3
    Open settings page   device=device_2
    Click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC6 : [OBO]DUT user to set "Also ring" for the delegate.
    [Tags]  309330   P2  alt_blocked
    [Setup]    Testcase Setup for Delegate User  count=3
    Click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2      status=appear
    Disconnect call     device=device_3
    Verify Incoming call    device=device_1     status=disappear
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC7 : [OBO] [Call Hold] Boss's call on hold, notification banner should be displayed
    [Tags]  309416   P1  alt_blocked
    [Setup]  Testcase Setup for Delegate User  count=3
    Click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_2     status=disappear
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Resume the call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC8 : [Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from another DUT user
    [Tags]  307803   bvt_tp  sanity_tp    bvt_pr  alt_blocked
    [Setup]     Testcase Setup for Delegate User   count=3
    Click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC9 :[Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from TDC user
   [Tags]      307799  
   [Setup]     Testcase Setup for Delegate User   count=3
   Click on calls tab      device=device_3
   Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
   Verify Incoming call    device=device_1,device_2     status=appear
   Pick incoming call    device=device_2
   Verify Incoming call    device=device_1     status=disappear
   Verify Call State    device_list=device_2,device_3    state=Connected
   Disconnect call     device=device_3
   Verify Call State    device_list=device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC10 :[Simul-ring] DUT user can configure a call group to ring simultaneously for an incoming call from TDC user
    [Tags]      307813  
    [Setup]    Testcase Setup for GCP User    count=3
    Enable Also Ring Call group     device=device_1
    Click on calls tab      device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC11 : [Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from PSTN user
   [Tags]      307796
   [Setup]      Testcase Setup for Delegate PSTN User   count=3   
   Enable Also Ring delegates     device=device_1
   Click on calls tab   device=device_3
   Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
   Verify Incoming call    device=device_1,device_2     status=appear
   Pick incoming call    device=device_2
   Verify Incoming call    device=device_1     status=disappear
   Verify Call State    device_list=device_2,device_3    state=Connected
   Disconnect call     device=device_3
   Verify Call State    device_list=device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Simul Ring Suite Teardown

*** Keywords ***
Simul Ring Suite Setup
    Testcase Setup for Delegate User  count=3
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    Enable Also Ring delegates     device=device_1

Simul Ring Suite Teardown
    Suite Failure Capture
    Disable Also Ring    device=device_1
    come back to home screen   device_list=device_1,device_2,device_3

Voicemail Setup
    Set Call Forwarding    device=device_2
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:gcp_user
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1   state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device_1
    Verify Call State    device_list=device_1     state=Disconnected
    return to home screen    device_list=device_1
    verify and disable call forwarding    device=device_2

Also Ring teardown
    Disable Also Ring    device=device_3
    Delete delegate from manage delegate   from_device=device_3    to_device=device_2:delegate_user

verify devices and also ring teardown
    Capture on Failure
    Come back to home screen   device_list=device_2,device_3,device_4,device_5
    Also Ring teardown

Verify device criteria and also ring teardown
    Run Keyword If      ${tc_flag}==True    run keyword     verify devices and also ring teardown
