*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Call Transfer] Search option should be available in the call transfer section
    [Tags]   306073   P2
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify search option in call transfer section     device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Call Transfer] DUT user blind transfer one TDC call to another TDC
    [Tags]  306075
    [Setup]  Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Call Transfer] Initial list contacts in the call transfer section.
    [Tags]      306074
    [Setup]  Testcase Setup for Meeting User    count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify initial list contacts in the call transfer section     from_device=device_1      to_device=device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Call Transfer] DUT user consultative transfer the TDC's call to another TDC
    [Tags]  306081   bvt_tpc     sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_1    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5: [Call Transfer] DUT user to consult transfer the TDC call to another DUT user
    [Tags]  306084   bvt_tpc     sanity_tpc     P0
    [Setup]  Testcase Setup for Meeting User     count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_1    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3


*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}