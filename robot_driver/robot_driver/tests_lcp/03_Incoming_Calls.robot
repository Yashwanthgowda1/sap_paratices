*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  3 minute

*** Test Cases ***
TC1: [Incoming Calls] DUT user receives call from TDC
    [Tags]  243592      bvt_lcp     sanity_lcp
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2: [Incoming Calls] DUT receives call from TDC using DID
    [Tags]  242888      bvt_lcp     sanity_lcp
    [Setup]  Testcase Setup     count=2
    navigate to calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: [Incoming Calls] DUT user to receive the call when UI view is in Device settings
    [Tags]  243567     sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Navigate to device setting page from Home Screen enable page    device=device_1
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4: [Incoming Calls] TDC user calls to DUT user which is set to "DND"
    [Tags]  242896      bvt_lcp     sanity_lcp
    [Setup]  Testcase Setup     count=2
    Select user presence   device=device_1     state=DND
    Verify user presence   device=device_1     state=DND
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call    device=device_1     status=disappear
    [Teardown]  Run Keywords    Capture on Failure   AND   Select user presence   device=device_1     state=available    AND    Come back to home screen    device_list=device_1,device_2

TC5: [Incoming Calls] DUT user to answer second incoming call
    [Tags]  243308      bvt_lcp     sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify call state    device_list=device_2              state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6: [Incoming Calls] DUT user receives the forwarded call from TDC
    [Tags]  242890      sanity_lcp
    [Setup]  run keywords   Testcase Setup    count=3   AND     Enable call forwarding and add contact     from_device=device_2    contact_device=device_1        AND        Come back to home screen    device_list=device_2     
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Verify display name on call toast   to_device=device_1    from_device=device_3
    Verify forward by call text     device=device_1    from_device=device_2
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable Call forward lcp   devices=device_1,device_2,device_3

TC7: [Calls] Verify DUT user able to navigate the Device Settings page and stay there 2-3 minutes while on a P2P Call.
    [Tags]  402702  sanity_lcp
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  4 times     device setting back     device=device_1
    Navigate to device setting page from Home Screen enable page    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8: [Incoming Calls] TDC user hangs up the call before DUT user picks up
    [Tags]  242892
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify incoming call    device=device_1     status=appear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_1     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Multiple Call Banner] DUT user holds the incoming call with another DUT user
    [Tags]  298903    P2
    [Setup]   Testcase Setup   count=2
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    verify call state and disconnect    device=device_2,device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Multiple Call Banner] DUT user to tap on the banner when call is on hold with DUT user
    [Tags]  298907    P0    bvt_lcp     sanity_lcp
    [Setup]   Testcase Setup   count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    tap on the banner    device=device_1
    Verify Call State    device_list=device_1,device_2     state=hold
    Disconnect call      device=device_1
    verify call state and disconnect        device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC11 : [Multiple Call Banner] DUT user to verify the "multiple call Banner" while in a ongoing call
    [Tags]   298916   P0    Sanity_lcp     Bvt_lcp     Ftp_lcp
    [Setup]   Testcase Setup   count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Hold
    Wait for Some Time    time=${wait_time}
    device setting back       device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
    Disconnect call      device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC12 : [Multi Call Banner] Verify If there is a new incoming call and other call is on hold, the incoming call is drawn into full screen.
    [Tags]   321008    P2
    [Setup]   Testcase Setup   count=3
    navigate to people tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    click back       device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    Make outgoing call using display name  from_device=device_3   to_device=device_1
    verify incoming call    device=device_1   status=appear
    verify call state and disconnect        device=device_1,device_2,device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Disable Call forward lcp
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    open settings page  device=device_2
    disable call forwarding    device=device_2