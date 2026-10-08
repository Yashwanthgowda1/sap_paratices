*** Settings ***
Resource       ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Call Merge] Recent call history should be updated properly after successful call merge
    [Tags]   309863  sanity_tp                  alt_bug     Certification_audio
    [Setup]     Testcase Setup      count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call     device=device_2
    Wait for Some Time     time=${wait_time}
    verify call state     device_list=device_1,device_2     state=Connected
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3        to_device=device_1
    Pick incoming call from call notification    device=device_1
    Wait for Some Time     time=${wait_time}
    verify call state      device_list=device_1,device_3      state=Connected
    verify call state      device_list=device_2                       state=Hold
    Verify and merge call      device=device_1         from_device=device_2
    Wait for Some Time     time=${wait_time}
    verify call state       device_list=device_1,device_2,device_3         state=Connected
    disconnect call       device=device_2,device_3
    Verify Call State     device_list=device_1,device_2,device_3      state=Disconnected
    verify group call in call history    device=device_1    call_participants=device_2,device_3
   [Teardown]   Run Keywords     Capture on Failure  AND    Test Case Teardown   devices=device_1,device_2,device_3

TC2 : [Call Merge] Verify call should continue between TDC users when DUT user drops call after call merge
    [Tags]   309869         alt_bug
    [Setup]     Testcase Setup      count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name     from_device=device_1     to_device=device_2
    Pick incoming call     device=device_2
    Wait for Some Time      time=${wait_time}
    verify call state     device_list=device_1,device_2     state=Connected
    Click on calls tab   device=device_3
    Make outgoing call using display name     from_device=device_3     to_device=device_1
    Pick incoming call from call notification    device=device_1
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
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC3 : [Call Merge] DUT user merges one TDC user call with another TDC user
    [Tags]   309878  sanity_tp        bvt_pr         alt_bug      Certification_audio
    [Setup]     Testcase Setup      count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1            to_device=device_2
    Pick incoming call    device=device_2
    verify call state   device_list=device_1,device_2   state=Connected
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3            to_device=device_1
    Pick incoming call from call notification    device=device_1
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Verify and merge call    device=device_1     from_device=device_2
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    disconnect call       device=device_2,device_3
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC4 : [Call Merge] Merge P2P and group call
    [Tags]   309890  sanity_tp            alt_blocked     Certification_audio
    [Setup]     Testcase Setup      count=4
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1       to_device=device_2
    Pick incoming call     device=device_2
    Wait for Some Time     time=${wait_time}
    verify call state      device_list=device_1,device_2     state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call     device=device_3
    Wait for Some Time     time=${wait_time}
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    click back          device=device_1
    navigate to calls tab       device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_4
    Pick incoming call     device=device_4
    Wait for Some Time     time=${wait_time}
    verify call state     device_list=device_1,device_4     state=Connected
    verify call state    device_list=device_2,device_3     state=Connected
    Verify and merge call    device=device_1    from_device=device_2,device_3
    verify call state     device_list=device_2,device_3,device_4   state=Connected
    disconnect call     device=device_2,device_3,device_4
    verify call state      device_list=device_1,device_2,device_3,device_4   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC5 : [Call Merge] Merge option should choose between the available calls
    [Tags]   309875      sanity_tp            alt_blocked
    [Setup]     Testcase Setup      count=4
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    verify call state    device_list=device_1,device_2    state=Connected
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Pick incoming call from call notification    device=device_1
    Wait for Some Time   time=${wait_time}
    verify call state    device_list=device_1,device_3    state=Connected
    verify call state     device_list=device_2    state=Hold
    Click on calls tab   device=device_4
    Make outgoing call using display name    from_device=device_4    to_device=device_1
    Pick incoming call from call notification    device=device_1
    Wait for Some Time    time=${wait_time}
    verify call state     device_list=device_1,device_4    state=Connected
    verify call state     device_list=device_2,device_3    state=Hold
    verify call merge option ability with multiple calls    device=device_1     from_device=device_2,device_3
    verify call state     device_list=device_2    state=Hold
    verify call state     device_list=device_1,device_3,device_4      state=Connected
    disconnect call    device=device_2,device_3,device_4
    verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC6 : [Call Merge] DUT user is in merged call and adds another user as participant
    [Tags]   309883           09_bvt  alt_blocked
    [Setup]     Testcase Setup      count=4
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    verify call state     device_list=device_1,device_2     state=Connected
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Pick incoming call from call notification    device=device_1
    Wait for Some Time     time=${wait_time}
    verify call state     device_list=device_1,device_3      state=Connected
    verify call state     device_list=device_2     state=Hold
    Verify and merge call     device=device_1     from_device=device_2
    verify call state     device_list=device_1,device_2,device_3    state=Connected
    Add participant to conversation using display name    from_device=device_1    to_device=device_4
    Pick incoming call   device=device_4
    Wait for Some Time    time=${wait_time}
    verify call state    device_list=device_1,device_2,device_3,device_4     state=Connected
    verify participant list    from_device=device_1    connected_device_list=device_1,device_2,device_3,device_4
    disconnect call    device=device_1,device_2,device_3
    verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC:7 [Call Merge] Verify an active call can be merged into an MoH call.
   [Tags]   309894     P2  alt_credentials
   [Setup]     Testcase Setup      count=3
   Click on calls tab   device=device_1
   Make outgoing call using display name    from_device=device_1   to_device=device_2
   Pick incoming call    device=device_2
   verify call state      device_list=device_1,device_2      state=Connected
   Click on calls tab   device=device_3
   Make outgoing call using display name    from_device=device_3   to_device=device_1
   Pick incoming call from call notification    device=device_1
   verify call state   device_list=device_1,device_3    state=Connected
   verify call state    device_list=device_2     state=Hold
   Verify and merge call  device=device_1    from_device=device_2
   Verify call state   device_list=device_1,device_2,device_3    state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC8 : [Call Merge] Merge option is available for held calls.
    [Tags]   482794        P2
    [Setup]     Testcase Setup      count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1            to_device=device_2
    Pick incoming call    device=device_2
    verify call state   device_list=device_1,device_2   state=Connected
    Navigate to calls tab       device=device_1
    Make outgoing call using display name    from_device=device_1            to_device=device_3
    Pick incoming call   device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify call state    device_list=device_2              state=Hold
    Hold the call   device=device_3
    verify call state    device_list=device_3             state=Hold
    Verify and merge call    device=device_1     from_device=device_2       status=verify
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    verify call state and disconnect    device=device_1,device_2,device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC9 :[Call Merge] Verify merge failure messages are displayed properly when call merge fails.
  [Tags]   309872     
  [Setup]     Testcase Setup      count=3
  Click on calls tab   device=device_1
  Make outgoing call using display name    from_device=device_1   to_device=device_2
  Pick incoming call    device=device_2
  verify call state      device_list=device_1,device_2      state=Connected
  Click on calls tab   device=device_3
  Make outgoing call using display name    from_device=device_3   to_device=device_1
  Pick incoming call   device=device_1
  verify call state   device_list=device_1,device_3    state=Connected
  verify call state    device_list=device_2     state=Hold
  verify call merge failure scenario  device=device_1    merge_with_device=device_2    disconnect_from_device=device_3
  resume call from call hold banner    device=device_1
  verify call state   device_list=device_1,device_2   state=Connected
  disconnect call   device=device_2
  verify Call State  device_list=device_1,device_2,device_3      state=Disconnected
  [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC10: [Call Merge] Verify that user should be able to Merge DUT user call with TDC user
    [Tags]      318507
    [Setup]  Testcase Setup     count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click on calls tab   device=device_3
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

TC11: [Call Merge] Verify that user should be able to Merge TDC user call with DUT user
    [Tags]      318496
    [Setup]  Testcase Setup     count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click on calls tab   device=device_3
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

TC12 : [Call Merge] Verify that user should be able to merge active call to a group call
    [Tags]      318465
    [Setup]  Testcase Setup     count=4
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State   device_list=device_1,device_2     state=Connected
    Make outgoing call using display name    from_device=device_3      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State   device_list=device_3,device_4   state=Connected
    Add participant to conversation using display name   from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=10
    Verify Call State   device_list=device_1,device_2,device_3    state=Connected
    verify_merge_option_available   device=device_1     status=absent
    resume call from call hold banner   device=device_1
    Wait for Some Time    time=5
    verify merge option available   device=device_1     status=present
    Verify and merge call    device=device_1    from_device=device_4,device_3
    Verify Call State   device_list=device_1,device_2,device_3,device_4     state=Connected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}

verify devices and teardown
    Capture on Failure
    Come back to home screen   device_list=device_2,device_3,device_4,device_5

verify device criteria and teardown
    Run Keyword If      ${tc_flag}==True    run keyword     verify devices and teardown