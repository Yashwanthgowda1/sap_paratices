*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1 : [Multiple Call Banner] DUT user to tap on the banner when call is on hold with TDC user
    [Tags]    298908    P1
    [Setup]   Testcase Setup   count=2
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Device setting back     device=device_1
    verify call hold banner   from_device=device_1    to_device=device_2
    tap on the banner    device=device_1
    Disconnect call      device=device_1
    verify call state and disconnect        device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Multiple Call Banner] DUT user to get incoming call from TDC user when other calls are on hold
    [Tags]    298909    P1
    [Setup]   Testcase Setup   count=4
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab   device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    navigate to people tab   device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1
    verify incoming call     device=device_1    status=appear
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    Disconnect call      device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC3 : [Multiple Call Banner] DUT user to get multiple incoming calls at the same time
    [Tags]   298913     P0      Ftp_lcp     Sanity_lcp      bvt_lcp
    [Setup]   Testcase Setup   count=3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1   method=display_name
    verify multiple incoming calls   device=device_1
    disconnect call   device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Multiple Call Banner] DUT user to get incoming call from another DUT user when other calls are on hold
    [Tags]     298910   P1      Ftp_lcp
    [Setup]   Testcase Setup   count=4
    navigate to people tab      device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to people tab    device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_3    state=Hold
    Verify Call State    device_list=device_1,device_4    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Hold
    navigate to people tab      device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    verify incoming call     device=device_1    status=appear
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_3,device_4
    Disconnect call      device=device_2,device_3,device_4
    verify call state and disconnect    device=device_1
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC5 : [Multiple calls] DUT user on device setting page, receives multiple calls.
    [Tags]   298915    P2
    [Setup]    Testcase Setup   count=3
    navigate to device setting page   device=device_1
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
    disconnect call   device_1
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  run keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3
