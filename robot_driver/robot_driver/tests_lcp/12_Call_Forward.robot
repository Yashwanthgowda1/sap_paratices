*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Run Keywords    Suite Failure Capture        AND     Unanswered call Teardown   devices=device_1,device_2,device_3


*** Variables ***
${wait_time} =  10
${wait_time_20s} =  20

*** Test Cases ***
TC1:[Call Forward] DUT user redirects unanswered calls to a contact
    [Tags]  243600      sanity_lcp      phonesCY23_4
    [Setup]  run keywords   Testcase Setup    count=3   AND     Enable unanswered call and add contact   from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_1     status=appear
    #Waiting for unanswered call
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Unanswered call Teardown   devices=device_1,device_2,device_3

TC2: [Call Forward] DUT user to forward the incoming call from one TDC call to another TDC
    [Tags]  242936      
    [Setup]  run keywords   Testcase Setup    count=3   AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable Call forward lcp   devices=device_1,device_2,device_3

*** Keywords ***
Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

Disable Call forward lcp
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    open settings page  device=device_1
    disable call forwarding    device=device_1

