*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${2_minutes_wait_time} =  2 minutes


*** Test Cases ***
TC1: [Call Transfer] DUT user blind transfer the TDC call to PSTN
    [Tags]  242940      P0        Certification_lcp    bvt_lcp    sanity_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify call state and disconnect   device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Call Transfer] DUT user blind transfers the PSTN call to TDC
    [Tags]  244104      P1        Certification_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify call state and disconnect   device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Call Transfer] DUT user consultative transfers the PSTN call to TDC
    [Tags]  244109      P0       sanity_lcp       bvt_lcp
    [Setup]  Testcase Setup for LCP PSTN User  count=3
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Call Transfer] DUT user to transfer the PSTN call to another DUT
    [Tags]  244105      P1    sanity_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify call state and disconnect   device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5: [Call Transfer] DUT user resume while consultative transfers the PSTN call to TDC
    [Tags]      339421        p1    sanity_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    swap calls   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6: [Esc to Conf.] DUT user in P2P call with TDC, adds PSTN user
    [Tags]  243223      bvt_lcp     sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Mute all participants       device=device_1
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7: [Esc to Conf.] DUT user in P2P call with another DUT user, adds PSTN user to call
    [Tags]  243225          sanity_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Mute all participants       device=device_1
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8: [Esc to Conf.] DUT user to add Teams Client again to the call
    [Tags]  243233    sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3    state=Disconnected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9: [Call Forward] DUT user redirects unanswered calls to PSTN number
    [Tags]  243601      
    [Setup]  run keywords   Testcase Setup for LCP PSTN User   count=3   AND     Enable unanswered call and add contact   from_device=device_1    contact_device=device_2:pstn_user
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_1     status=appear
    #Waiting for unanswered call
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Unanswered call Teardown   devices=device_1,device_2,device_3

TC10: [Call Forward] DUT user to forward PSTN user call to TDC
    [Tags]  242934
    [Setup]  run keywords   Testcase Setup for LCP PSTN User    count=3   AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_3
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Verify incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable Call forward lcp   devices=device_1,device_2,device_3

TC11: [Call Forward] DUT user to forward TDC's call to PSTN user
    [Tags]  242930     
    [Setup]  run keywords   Testcase Setup for LCP PSTN User   count=3   AND     Enable call forwarding and add contact   from_device=device_1    contact_device=device_2:pstn_user
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable Call forward lcp   devices=device_1,device_2,device_3

TC12: [Call Merge] DUT user merge PSTN user call with TDC user
    [Tags]  244124      bvt_lcp     sanity_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    Verify and merge call    device=device_1     from_device=device_2:pstn_user
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC13: [Call Park] DUT user to park the PSTN call
    [Tags]  452472      bvt_lcp    sanity_lcp
    [Setup]  Testcase Setup for LCP PSTN User   count=3
   navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    Come back to home screen    device_list=device_1,device_2,device_3
   navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC14: DUT user able to receive the voicemail from the PSTN user by tapping on Send to voicemail option in Incoming call UI
    [Tags]  452359      bvt_lcp    sanity_lcp   phonesCY23_4
    [Setup]  Testcase Setup for LCP PSTN User   count=2
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber   from_device=device_2      to_device=device_1
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2:pstn_user
    Play voicemail    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC15 : [Call Forward] DUT user to forward the call to delegates - Call from PSTN user
    [Tags]  243551      sanity_lcp
    [Setup]  Run Keywords  Testcase Setup for Delegate PSTN User   count=3     AND     Enable call forwarding to delegates     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward lcp   devices=device_1,device_2,device_3

TC16: [Call Park] DUT user parks and retrieve a PSTN call
    [Tags]    452530
    [Setup]     Testcase Setup for PSTN User    count=2
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${2_minutes_wait_time}
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   verify and close call park banner    device=device_1    AND    Come back to home screen   device_list=device_1,device_2

TC17 : Validate that 'private line' label present after incoming call
    [Tags]      459069   bvt_lcp    sanity_lcp   phonesCY23_4
    [Setup]   Testcase Setup for LCP PSTN User   count=3
    navigate to calls tab  device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    navigate to calls tab  device=device_1
    verify privateline on recent tab  device=device_1
    come back to home screen  device_list=device_1
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to calls tab  device=device_1
    verify privateline on recent tab  device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC18 : [Call Merge] Verify an user should be able to merge PSTN call with another DUT user, another DUT's call is on hold
   [Tags]   318526
   [Setup]   Testcase Setup for PSTN User    count=3
   navigate to people tab  device=device_1
   Make outgoing call using display name    from_device=device_1            to_device=device_3
   Pick incoming call    device=device_3
   verify call state   device_list=device_1,device_3   state=Connected
   navigate to calls tab  device=device_2
   Make outgoing call using phonenumber    from_device=device_2            to_device=device_1
   Pick incoming call   device=device_1
   verify call state    device_list=device_1,device_2     state=Connected
   verify call state    device_list=device_3     state=hold
   Verify and merge call    device=device_1     from_device=device_3
   verify call state     device_list=device_1,device_2,device_3     state=Connected
   disconnect call       device=device_1,device_3
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC19: [Call Merge] Verify an active call with another DUT user can be merged into an MoH call.
   [Tags]   318525
   [Setup]   Testcase Setup for PSTN User    count=3
   navigate to calls tab  device=device_2
   Make outgoing call using phonenumber    from_device=device_2            to_device=device_1
   Pick incoming call   device=device_1
   verify call state    device_list=device_1,device_2     state=Connected
   navigate to people tab  device=device_3
   Make outgoing call using display name    from_device=device_3            to_device=device_1
   Pick incoming call    device=device_1
   verify call state   device_list=device_1,device_3   state=Connected
   Verify and merge call    device=device_1     from_device=device_2:pstn_user
   verify call state     device_list=device_1,device_2,device_3     state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC20: [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from TDC user
    [Tags]   243537     
    [Setup]    run keywords   Testcase Setup for PSTN User    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2:pstn_user
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Call Ring Teardown   devices=device_1,device_2,device_3

TC21: [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from another DUT user
    [Tags]   243538      
    [Setup]    run keywords   Testcase Setup for PSTN User    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2:pstn_user
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Call Ring Teardown   devices=device_1,device_2,device_3

TC22: [Simul-ring] DUT user can configure a TDC user to ring simultaneously for an incoming call from PSTN user
    [Tags]   243539      
    [Setup]    run keywords   Testcase Setup for PSTN User    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_3
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Call Ring Teardown   devices=device_1,device_2,device_3

TC23: [Simul-ring] DUT user can configure a second DUT user to ring simultaneously for an incoming call from PSTN user
    [Tags]   243542
    [Setup]    run keywords   Testcase Setup for PSTN User    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_3
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Call Ring Teardown   devices=device_1,device_2,device_3

TC24: [Call Transfer] DUT user End the call while consultative transfers the PSTN call to TDC
	[Tags]    339422    tp_lcp
	[Setup]    Testcase Setup for LCP PSTN User    count=3
	navigate to calls tab  device=device_2
	Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
	Pick incoming call    device=device_1
	Verify Call State    device_list=device_1,device_2    state=Connected
	Wait For Some Time    time=${wait_time}
	Consult first to transfer the call using display name    from_device=device_1      to_device=device_3
	Pick Incoming Call    device=device_3
	Verify Call State    device_list=device_1,device_3    state=Connected
	Disconnect Call    device=device_2
	Verify Call State    device_list=device_2    state=Disconnected
	Verify Call State    device_list=device_1,device_3    state=Connected
	Disconnect Call    device=device_1
	Verify Call State    device_list=device_1,device_3     state=Disconnected
	[Teardown]  Run Keywords    Capture on Failure  AND    Call Ring Teardown   devices=device_1,device_2,device_3

T25 : [Call Transfer] TDC user End the call while consultative transfers the PSTN call from DUT
	[Tags]    339423    
	[Setup]  run keywords   Testcase Setup for LCP PSTN User   count=3   AND     Enable unanswered call to voicemail     from_device=device_3    contact_device=device_2:pstn_user
	navigate to calls tab  device=device_2
	Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
	verify incoming call    device=device_1    status=appear
	Pick Incoming Call    device=device_1
	Verify Call State    device_list=device_1,device_2    state=Connected
	Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
	verify incoming call    device=device_3    status=appear
	Disconnect Call    device=device_3
	Verify Call State    device_list=device_3    state=Disconnected
	Disconnect Call    device=device_1
	Resume Call From Call Hold Banner    device=device_1
	Verify Call State    device_list=device_2,device_1    state=Connected
	Disconnect Call    device=device_1
	Verify Call State    device_list=device_2,device_1   state=Disconnected
	Wait For Some Time    time=${wait_time}
	Navigate to voicemail tab    device=device_3
	verify first voicemail displayname    to_device=device_3    from_device=device_1
	Wait For Some Time    time=${wait_time}
	Disable unanswered call   device=device_3    contact_device=device_2:pstn_user
	navigate to calls tab  device=device_2
	Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
	verify incoming call    device=device_1    status=appear
	Pick Incoming Call    device=device_1
	Verify Call State    device_list=device_1,device_2    state=Connected
	Consult first to transfer the call using display name    from_device=device_1    to_device=device_3
	verify incoming call    device=device_3    status=appear
	Disconnect Call    device=device_3
	Verify Call State    device_list=device_3    state=Disconnected
	Resume Call From Call Hold Banner    device=device_1
	Verify Call State    device_list=device_2,device_1    state=connected
	Disconnect Call    device=device_1
	Verify Call State    device_list=device_2,device_1    state=Disconnected
	[Teardown]    Run Keywords    Capture on Failure   AND    Call Ring Teardown   devices=device_1,device_2,device_3

TC26: [Hard key] Verify DUT user able to hold & Resume the call using hard hold key
    [Tags]      438787    sanity_lcp
    [Setup]    Testcase Setup for PSTN User    count=3
    ${redial_button}   has hardkey call hold button present      device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have hold  button
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1    state=Hold
    verify resume banner  device_list=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2    state=connected
    verify resume banner  device_list=device_1      state=disappear
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=disconnected
    Navigate To People Tab    device=device_1
    Make outgoing call using display name       from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Hold
    verify resume banner  device_list=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=connected
    verify resume banner  device_list=device_1      state=disappear
    Wait For Some Time    time=10s
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC27 : [Home Screen] Verify that user should be able to dial a PSTN number using dial pad
    [Tags]      319047
    [Setup]    Testcase Setup for PSTN User    count=2
    dail phone number from hard keys   device=device_1    to_device=device_2:pstn_user
    verify incoming call    device=device_2   status=appear
    pick incoming call    device=device_2
    verify call state    device_list=device_1,device_2   state=connected
    disconnect call    device=device_1
    verify call state    device_list=device_1,device_2   state=disconnected
    [Teardown]    run keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC28: [Incoming Calls] DUT displays the phone number of PSTN user
   [Tags]      314134
   [Setup]  Testcase Setup for PSTN User   count=2
   navigate to calls tab  device=device_2
   Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
   Pick incoming call    device=device_1
   Wait for Some Time    time=${wait_time}
   Verify Call State    device_list=device_1,device_2    state=Connected
   Verify number of caller and receiver displayed    from_device=device_1      to_device=device_2:pstn_user
   Disconnect call     device=device_2
   Verify Call State    device_list=device_1,device_2     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


*** Keywords ***
Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

Disable Call forward lcp
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    open settings page  device=device_1
    disable call forwarding    device=device_1

Call Ring Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    Disable Also Ring    device=device_1