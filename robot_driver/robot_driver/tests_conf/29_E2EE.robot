*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [E2EE] User to verify End to end encrypted calls option under calling page
    [Tags]   319506     P2
    [Setup]  Testcase Setup for Meeting User    count=1
    verify E2EE option inside calling option     device=device_1
    enable E2EE option inside calling option       device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND    Disable E2EE    device=device_1

TC2 : [E2EE] DUT user to enable/disable end-to-end encrypted option
    [Tags]  319511    P2
    [Setup]  Testcase Setup for Meeting User    count=1
    enable E2EE option inside calling option       device=device_1
    disable E2EE option inside calling option    device=device_1
    enable E2EE option inside calling option       device=device_1
    disable E2EE option inside calling option     device=device_1
    [Teardown]  Run Keywords   Capture on Failure     AND   Disable E2EE    device=device_1

TC3 : [E2EE] DUT user to check the "Learn more" option under Encryption
    [Tags]   319516    P2
    [Setup]  Testcase Setup for Meeting User    count=1
    navigate to learn more link under E2EE calls     device=device_1
    [Teardown]   Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC4 : [E2EE] DUT user check for Ubar and overflow options for encrypted call
    [Tags]  319507    P1    sanity_tpc
    [Setup]  Testcase Setup for Meeting User    count=2
    Enable E2EE    device=device_1,device_2
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call UI when e2ee is enabled     device=device_1
    verify search option not present in add participant when e2ee enabled   device=device_1
    Disconnect call      device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    Disable E2EE    device=device_1,device_2

TC5 : [E2EE] DUT user checks for Ubar and overflow options when one of the user non-E2EE
    [Tags]  319509   P2
    [Setup]  Testcase Setup for Meeting User    count=3
    Enable E2EE    device=device_1
    Wait for Some Time    time=${wait_time}
    click on calls tab     device=device_2
    Make outgoing call using phonenumber   from_device=device_2     to_device=device_1:meeting_user
    Verify Incoming call    device=device_1    status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1    to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3      state=Connected
    Verify call control visibility      device_list=device_1   e2ee=enabled
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_2,device_3   AND  Disable E2EE    device=device_1

TC6 : [E2EE] E2EE user calls to PSTN user
    [Tags]  316116    P0    bvt_tpc     sanity_tpc
    [Setup]  Testcase Meeting PSTN Setup Main   count=2
    Enable E2EE    device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify E2EE icon is not displaying in call UI   device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_2   AND  Disable E2EE    device=device_1

TC7 :[E2EE] User to verify end to end encryption enabled for calls
    [Tags]      316114    P1
    [Setup]  Testcase Setup for Meeting User    count=2
    Enable E2EE    device=device_1,device_2
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify e2ee security code on user  device_list=device_1,device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    Disable E2EE    device=device_1,device_2

*** Keywords ***
Enable E2EE
    [Arguments]     ${device}
    enable E2EE option inside calling option      ${device}
    come back to home screen    ${device}

Disable E2EE
    [Arguments]     ${device}
    disable E2EE option inside calling option     ${device}
    Come back to home screen    ${device}