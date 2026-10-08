*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture
*** Variables ***
${action_time} =  5

*** Test Cases ***
TC1: [Call Merge] DUT user merges one TDC user call with another TDC user
    [Tags]  244123    sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Call Merge] Merge option should only be available for the current active call
    [Tags]  244116    sanity_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    verify merge call option      to_device=device_2     from_device=device_1
    Hold the call    device=device_1
    Verify Call State    device_list=device_3     state=Hold
    verify merge call option      to_device=device_2     from_device=device_1   merge_option=absent
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Call Merge] Recent call history should be updated properly after successful call merge
    [Tags]  244118    sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    Come back to home screen     device_list=device_1
    navigate to calls tab       device=device_1
    verify group call in call history    device=device_1     call_participants=device_2,device_3
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Call Merge] Merge option should choose between the available calls
    [Tags]  244122    sanity_lcp
    [Setup]  Testcase Setup     count=4
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    verify call state    device_list=device_1,device_4     state=Connected
    verify call state    device_list=device_3              state=Hold
    verify call merge option ability with multiple calls    device=device_1     from_device=device_2,device_3
    verify call state     device_list=device_1,device_3,device_4      state=Connected
    disconnect call    device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5: [Call Merge] DUT user is in merged call and adds another user as participant
    [Tags]  244125    
    [Setup]  Testcase Setup     count=4
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Add participant to conversation using display name    from_device=device_1    to_device=device_4
    Pick incoming call   device=device_4
    Wait for Some Time    time=${wait_time}
    verify call state    device_list=device_1,device_2,device_3,device_4     state=Connected
    Disconnect call     device=device_1,device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6: [Call Merge][1:1 call] Verify that correct name appears with Merge call in more option menu
    [Tags]      318432
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2    status=verify
    resume call from call hold banner    device=device_1
    verify call state    device_list=device_3              state=Hold
    Verify and merge call    device=device_1     from_device=device_3    status=verify
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7: [Call Merge] Verify active call ends and merged call appears on the screen after merge completion
    [Tags]      244119
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8: [Call Merge] Verify merge failure messages are displayed properly when call merge fails.
    [Tags]      244121
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  3 times     device setting back     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    verify call merge failure scenario  device=device_1    merge_with_device=device_2    disconnect_from_device=device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9 : [Call Merge] Verify call should continue between TDC users when DUT user drops call after call merge
    [Tags]   244120
    [Setup]     Testcase Setup      count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name     from_device=device_1     to_device=device_2
    Pick incoming call     device=device_2
    Wait for Some Time      time=${wait_time}
    verify call state     device_list=device_1,device_2     state=Connected
    navigate to people tab   device=device_3
    Make outgoing call using display name     from_device=device_3     to_device=device_1
    Pick incoming call       device=device_1
    Wait for Some Time      time=${wait_time}
    verify call state      device_list=device_1,device_3     state=Connected
    verify call state      device_list=device_2     state=Hold
    Verify and merge call      device=device_1      from_device=device_2
    Wait for Some Time      time=${wait_time}
    verify call state     device_list=device_1,device_2,device_3      state=Connected
    disconnect call     device=device_1
    verify call state    device_list=device_2,device_3      state=Connected
    verify call state     device_list=device_1      state=Disconnected
    disconnect call     device=device_2
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC10: [Call Merge] Name in call roster header should update after merging two 1:1 calls successfully
   [Tags]   244115
   [Setup]     Testcase Setup      count=3
   navigate to people tab    device=device_1
   Make outgoing call using display name    from_device=device_1   to_device=device_2
   Pick incoming call    device=device_2
   verify call state      device_list=device_1,device_2      state=Connected
   navigate to people tab   device=device_3
   Make outgoing call using display name    from_device=device_3   to_device=device_1
   Pick incoming call   device=device_1
   verify call state   device_list=device_1,device_3    state=Connected
   verify call state    device_list=device_2     state=Hold
   Verify and merge call  device=device_1    from_device=device_2
   Verify transition screen during call merge   device=device_1
   verify call state   device_list=device_1,device_2,device_3    state=Connected
   Verify header of call roster   device=device_1    from_device=device_2,device_3
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3

TC11: [Call Merge] Verify that user should be able to Merge TDC user call with DUT user
    [Tags]  318505
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC12: [Call Merge] Verify that user should be able to Merge DUT user call with TDC user
    [Tags]  318511
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC13: [Call Merge] Verify that user should be able to Merge DUT user 1 call with another DUT
    [Tags]  318512
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC14 : [Call Merge] Merge P2P and group call
    [Tags]    318112    sanity_lcp     Certification_audio     FTP_Scope
    [Setup]     Testcase Setup      count=4
    navigate to people tab       device=device_1
    Make outgoing call using display name    from_device=device_1       to_device=device_2
    Pick incoming call     device=device_2
    verify call state      device_list=device_1,device_2     state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
    Pick incoming call     device=device_3
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    Device Setting Back     device=device_1
    navigate to people tab       device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_4
    Pick incoming call     device=device_4
    verify call state     device_list=device_1,device_4     state=Connected
    verify call state    device_list=device_2,device_3     state=Connected
    Verify and merge call    device=device_1    from_device=device_2,device_3
    verify call state     device_list=device_2,device_3,device_4   state=Connected
    disconnect call     device=device_2,device_3,device_4
    verify call state      device_list=device_1,device_2,device_3,device_4   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4