*** Settings ***
Library         DateTime
Library         OperatingSystem
Resource       ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Call Merge] Merge option should only be available for the current active call
    [Tags]   316099    P1    Sanity_cap
    [Setup]   Testcase Setup for CAP User     count=3
    click on people tab      device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    Pick incoming call    device=device_2
    verify call state     device_list=device_1,device_2        state=Connected
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3    to_device=device_1:cap_search_enabled
    Pick incoming call     device=device_1
    verify call state      device_list=device_1,device_3      state=Connected
    verify call state      device_list=device_2       state=hold
    Verify and merge call      device=device_1     from_device=device_2
    Wait for Some Time          time=${wait_time}
    verify call state       device_list=device_1,device_2,device_3         state=Connected
    disconnect call        device=device_1,device_2
    Verify Call State           device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown   devices=device_1,device_2,device_3

TC2 : [Call Merge] Verify call should continue between TDC users when DUT user drops call after call merge
    [Tags]   316103      P2
    [Setup]    Testcase Setup for CAP User       count=3
    click on people tab    device=device_1
    Make outgoing call using display name     from_device=device_1     to_device=device_2
    Pick incoming call     device=device_2
    verify call state     device_list=device_1,device_2     state=Connected
    Add participant to conversation using display name    from_device=device_1    to_device=device_3
    Pick incoming call       device=device_3
    verify call state      device_list=device_1,device_3     state=Connected
    verify call state      device_list=device_2     state=Hold
    Verify and merge call      device=device_1      from_device=device_2
    Wait for Some Time      time=${wait_time}
    verify call state     device_list=device_1,device_2,device_3      state=Connected
    disconnect call     device=device_1
    verify call state     device_list=device_1      state=Disconnected
    verify call state    device_list=device_2,device_3      state=Connected
    disconnect call     device=device_2
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC3 : [Call Merge] Merge option should choose between the available calls
    [Tags]   316105      P1    sanity_cap
    [Setup]   Testcase Setup for CAP User      count=4
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    Pick incoming call   device=device_2
    verify call state    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_1    to_device=device_3
    Pick incoming call    device=device_3
    verify call state    device_list=device_1,device_3    state=Connected
    verify call state     device_list=device_2    state=Hold
    Add participant to conversation using display name    from_device=device_1    to_device=device_4
    Pick incoming call    device=device_4
    verify call state     device_list=device_1,device_4    state=Connected
    verify call state     device_list=device_2,device_3    state=Hold
    verify call merge option ability with multiple calls    device=device_1     from_device=device_2,device_3
    verify call state     device_list=device_2    state=Hold
    verify call state     device_list=device_1,device_3,device_4      state=Connected
    disconnect call    device=device_1,device_2,device_3
    verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC4 : [Call Merge] Merge P2P and group call
    [Tags]   316110    P1    sanity_cap
    [Setup]    Testcase Setup for CAP User        count=4
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1       to_device=device_2
    Pick incoming call     device=device_2
    verify call state      device_list=device_1,device_2     state=Connected
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
    Pick incoming call     device=device_1
    verify call state     device_list=device_1,device_3      state=Connected
    verify call state    device_list=device_2     state=Hold
    Verify and merge call     device=device_1     from_device=device_2
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    click on calls tab    device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1:cap_search_enabled
    Pick incoming call     device=device_1
    verify call state     device_list=device_1,device_2,device_3,device_4     state=Connected
    Verify and merge call    device=device_1    from_device=device_2,device_3
    verify call state     device_list=device_2,device_3,device_4   state=Connected
    disconnect call     device=device_2,device_3,device_4
    verify call state      device_list=device_1,device_2,device_3,device_4   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC5 : [Call Merge] Verify that user should be able to Merge TDC user call with DUT user
   [Tags]   318504    P2
   [Setup]    Testcase Setup for CAP User        count=3
   click on people tab      device=device_1
   Make outgoing call using display name    from_device=device_1   to_device=device_2
   Pick incoming call    device=device_2
   verify call state      device_list=device_1,device_2      state=Connected
   click on calls tab    device=device_3
   Make outgoing call using display name    from_device=device_3   to_device=device_1:cap_search_enabled
   Pick incoming call   device=device_1
   verify call state   device_list=device_1,device_3    state=Connected
   verify call state    device_list=device_2     state=Hold
   Verify and merge call  device=device_1    from_device=device_2
   verify call state     device_list=device_1,device_2,device_3    state=Connected
   disconnect call     device=device_2,device_3
   verify Call State  device_list=device_1,device_2,device_3      state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Call Merge] Verify that user should be able to Merge DUT user call with TDC user
   [Tags]   318513    P2
   [Setup]    Testcase Setup for CAP User        count=3
   click on calls tab    device=device_3
   Make outgoing call using display name    from_device=device_3   to_device=device_1:cap_search_enabled
   Pick incoming call    device=device_1
   verify call state      device_list=device_1,device_3      state=Connected
   click on calls tab    device=device_2
   Make outgoing call using display name    from_device=device_2   to_device=device_1:cap_search_enabled
   Pick incoming call   device=device_1
   verify call state   device_list=device_2,device_3    state=Connected
   verify call state    device_list=device_3     state=Hold
   Verify and merge call  device=device_1    from_device=device_3
   verify call state     device_list=device_1,device_2,device_3    state=Connected
   disconnect call     device=device_2,device_3
   verify Call State  device_list=device_1,device_2,device_3      state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7: [Call Merge][1:1 call] Verify that correct name appears with Merge call in more option menu
   [Tags]   318428     P2
   [Setup]    Testcase Setup for CAP User     count=3
   Click on calls tab   device=device_2
   Make outgoing call using display name    from_device=device_2    to_device=device_1:cap_search_enabled
   Pick incoming call    device=device_1
   verify call state      device_list=device_1,device_2      state=Connected
   Click on calls tab   device=device_3
   Make outgoing call using display name    from_device=device_3    to_device=device_1:cap_search_enabled
   Pick incoming call   device=device_1
   verify call state   device_list=device_1,device_3    state=Connected
   verify call state    device_list=device_2     state=Hold
   Verify and merge call  device=device_1    from_device=device_2     status=verify
   resume call from call hold banner    device=device_1
   Verify and merge call  device=device_1    from_device=device_3       status=verify
   verify call state   device_list=device_1,device_2    state=Connected
   verify call state    device_list=device_3     state=Hold
   disconnect call       device=device_2,device_3
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC8:[Call Merge] Verify call merge option shows up in more options (…)
   [Tags]    316097    P2  alt_credentials      Certification_cap
   [Setup]    Testcase Setup for CAP User        count=3
   Click on people tab   device=device_1
   Make outgoing call using display name    from_device=device_1     to_device=device_2
   Pick incoming call   device=device_2
   verify call state    device_list=device_1,device_2     state=Connected
   Click on calls tab   device=device_3
   Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
   Pick incoming call    device=device_1
   verify call state     device_list=device_1,device_3      state=Connected
   verify call state     device_list=device_2     state=Hold
   verify call control visibility    device_list=device_1
   Verify merge call option    from_device=device_1     to_device=device_2
   disconnect call       device=device_2,device_1
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC9 : [Call Merge] DUT user is in merged call and adds another user as participant
    [Tags]   316108
    [Setup]     Testcase Setup for CAP User      count=4
    click on people tab      device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    verify call state     device_list=device_1,device_2     state=Connected
    Come back to home screen    device_list=device_1    disconnect=False
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
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

TC10: [Call Merge] DUT user merges one TDC user call with another TDC user
    [Tags]  316106    sanity_cap
    [Setup]  Testcase Setup for CAP User     count=3
    click on people tab      device=device_1
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

TC11 : [Call Merge] Verify active call ends and merged call appears on the screen after merge completion
   [Tags]   316102
   [Setup]   Testcase Setup for CAP User      count=3
   click on people tab      device=device_1
   Make outgoing call using display name    from_device=device_1     to_device=device_2
   Pick incoming call   device=device_2
   verify call state    device_list=device_1,device_2     state=Connected
   Come back to home screen    device_list=device_1    disconnect=False
   click on people tab    device=device_1
   Make outgoing call using display name    from_device=device_1     to_device=device_3
   Pick incoming call   device=device_3
   verify call state     device_list=device_1,device_3      state=Connected
   verify call state     device_list=device_2     state=Hold
   Verify and merge call    device=device_1     from_device=device_2
   verify call state     device_list=device_1,device_2,device_3     state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC12: [Call Merge] Name in call roster header should update after merging two 1:1 calls successfully
   [Tags]   316098
   [Setup]     Testcase Setup for CAP User      count=3
   click on people tab      device=device_1
   Make outgoing call using display name    from_device=device_1   to_device=device_2
   Pick incoming call    device=device_2
   verify call state      device_list=device_1,device_2      state=Connected
   Come back to home screen    device_list=device_1    disconnect=False
   click on people tab    device=device_1
   Make outgoing call using display name    from_device=device_1     to_device=device_3
   Pick incoming call   device=device_3
   verify call state   device_list=device_1,device_3    state=Connected
   verify call state    device_list=device_2     state=Hold
   Verify and merge call  device=device_1    from_device=device_2
   Verify transition screen during call merge   device=device_1
   verify call state   device_list=device_1,device_2,device_3    state=Connected
   Verify header of call roster   device=device_1    from_device=device_3,device_2
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}