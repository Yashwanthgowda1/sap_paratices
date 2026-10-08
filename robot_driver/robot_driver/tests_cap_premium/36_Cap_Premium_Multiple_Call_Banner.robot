*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  20

*** Test Cases ***

TC1 : [Multiple Call Banner] DUT user to tap on the banner when call is on hold with DUT user
    [Tags]   449062    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User      count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    tap on the banner    device=device_1
    Verify Call State    device_list=device_1        state=Connected
    Disconnect call      device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Multiple Call Banner] DUT user to get multiple incoming calls at the same time
     [Tags]  449075     BVT_CAPPremium     Sanity_CAPPremium
     [Setup]  Testcase Setup for CAP Premium User     count=3
     Navigate to calls tab   device=device_2,device_3
     initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
     verify multiple incoming calls   device=device_1
     disconnect call   device=device_2,device_3
     [Teardown]  run keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Multiple Call Banner] DUT user to tap on back button when call is on hold and take the call to full screen when tap on call hold banner if single call on hold
    [Tags]   449059    Sanity_CAPPremium    P1
    [Setup]   Testcase Setup for CAP User      count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    tap on the banner    device=device_1
    Verify Call State    device_list=device_1        state=Connected
    Disconnect call      device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Multi Call Banner] DUT user holds the incoming call with TDC user
    [Tags]  449053    P1
    [Setup]  Testcase Setup for CAP Premium User     count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Multiple Call Banner] DUT user holds the outgoing call with TDC
    [Tags]  449054    P1
    [Setup]  Testcase Setup for CAP Premium User     count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Multiple Call Banner] DUT user can hold the muted call with the TDC user
    [Tags]  449055    P1
    [Setup]  Testcase Setup for CAP Premium User     count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_2
    verify call mute state    device_list=device_2    state=mute
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Multiple Call Banner] DUT user holds the incoming call with another DUT user
    [Tags]  449057    P1
    [Setup]  Testcase Setup for CAP Premium User     count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
