*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1: [Call forward on home screen] Verify DUT after adding delegates from TDC /DUT.
    [Tags]    452424        sanity_lcp      bvt_lcp
    [Setup]  run keywords  Testcase Setup for Delegate User     count=3  AND     enable call forwarding display on home screen         device=device_1
    verify call forwarding icon     device=device_1
    verify call forwarding option in call forward icon      device=device_1
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    navigate to people tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    reject incoming call    device_list=device_2
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3   AND   disable call forwarding display on home screen   device=device_1

TC2: [Call forward on home screen] Verify that Call should be forwarded to delegates, When DUT user selects Forward to my delegates option from the Call forwarding section.
    [Tags]    452128        sanity_lcp      bvt_lcp
    [Setup]  run keywords  Testcase Setup for Delegate User     count=3    AND     enable call forwarding display on home screen         device=device_1
    verify call forwarding icon     device=device_1
    verify call forwarding option in call forward icon      device=device_1
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    navigate to people tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    reject incoming call    device_list=device_2
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3   AND   disable call forwarding display on home screen   device=device_1

TC3: Verify DUT user should get the Private line call from TDC user when DUT user set the Call forwarding to Delegates
    [Tags]    476770           
    [Setup]     run keywords  Testcase Setup for Delegate User     count=3  AND     Enable call forwarding to delegates     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1
    verify privateline label on call screen     device=device_1
    Verify incoming call    device=device_2     status=disappear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3   AND   Disable Call forward lcp   devices=device_1

TC4 : [Call Forward] DUT user to forward the call to delegates - Call from TDC user
    [Tags]  243552
    [Setup]  run keywords  Testcase Setup for Delegate User     count=3  AND     Enable call forwarding to delegates     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward lcp   devices=device_1,device_2,device_3

TC5 : [Call Forward] DUT user to forward the call to delegates - Call from another DUT user
    [Tags]  243553
    [Setup]  run keywords  Testcase Setup for Delegate User     count=3  AND     Enable call forwarding to delegates     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward lcp   devices=device_1,device_2,device_3

*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

Disable Call forward lcp
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    open settings page  device=device_1
    disable call forwarding    device=device_1

enable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=on

disable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=off
