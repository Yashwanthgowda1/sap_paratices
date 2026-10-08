*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      run keywords   Suite Failure Capture     AND     Simultaneous Call Ring Teardown        devices=device_1

*** Variables ***



*** Test Cases ***
TC1: [Simul-ring] DUT user can configure a TDC user to ring simultaneously for an incoming call from another TDC user
    [Tags]   243540
    [Setup]    run keywords   Testcase Setup    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC2: [Simul-ring] DUT user can configure a TDC user to ring simultaneously for an incoming call from another DUT user
    [Tags]   243541
    [Setup]    run keywords   Testcase Setup    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC4: [Simul-ring] DUT user can configure a second DUT user to ring simultaneously for an incoming call from TDC user
    [Tags]   243543
    [Setup]    run keywords   Testcase Setup    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC5: [Simul-ring] DUT user can configure a second DUT user to ring simultaneously for an incoming call from third DUT user
    [Tags]   243544
    [Setup]    run keywords   Testcase Setup    count=3   AND     Enable Also Ring and add contact     device=device_1   contact_device=device_3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC6: [Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from TDC user
    [Tags]   243546    sanity_lcp    p1
    [Setup]    run keywords   Testcase Setup for Delegate User     count=3   AND     Enable Also Ring delegates     device=device_1
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC7: [Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from another DUT user
    [Tags]   243547
    [Setup]    run keywords   Testcase Setup for Delegate User     count=3   AND     Enable Also Ring delegates     device=device_1
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC8: [Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from PSTN user
   [Tags]      243545
   [Setup]      Testcase Setup for Delegate PSTN User   count=3   
   Enable Also Ring delegates     device=device_1
   navigate to people tab    device=device_3
   Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
   Verify Incoming call    device=device_1,device_2     status=appear
   Pick incoming call    device=device_2
   Verify Incoming call    device=device_1     status=disappear
   Verify Call State    device_list=device_2,device_3    state=Connected
   Disconnect call     device=device_3
   Verify Call State    device_list=device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND     Simultaneous Call Ring Teardown        devices=device_1


*** Keywords ***

Simultaneous Call Ring Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    Disable Also Ring    device=device_1