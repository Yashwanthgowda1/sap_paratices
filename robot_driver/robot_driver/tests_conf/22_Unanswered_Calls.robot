*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Run Keywords        Suite Failure Capture        AND     Disable unanswered call    device=device_1      contact_device=device_2

*** Variables ***
${wait_time1} =  10
${wait_time2} =  25

*** Test Cases ***
TC1 : [Call Forward]DUT user redirects unanswered calls to a contact
    [Tags]    320259     sanity_tpc     P1
    [Setup]     run keywords     Testcase Setup for Meeting User    count=3   AND     Enable unanswered call and add contact   from_device=device_1    contact_device=device_2
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Verify incoming call    device=device_1     status=appear
    Wait for Some Time    time=${wait_time2}
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Unanswered call Teardown    devices=device_1,device_2,device_3

TC2 : [Call Forward]DUT user redirects unanswered calls to PSTN number
    [Tags]  316057   P1
    [Setup]  run keywords  Testcase Meeting PSTN Setup Main   count=3  AND     Enable unanswered call and add contact     from_device=device_1    contact_device=device_2:pstn_user
    click on calls tab      device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Wait for Some Time    time=${wait_time2}
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Unanswered call Teardown    devices=device_1,device_2,device_3

TC3 : [Call Forward]DUT user redirects unanswered calls to delegates
    [Tags]  318561   sanity_tpc
    [Setup]  run keywords   Testcase Setup for Meeting delegate user   count=3  AND   Enable unanswered call to delegates     from_device=device_1    contact_device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1:meeting_user
    Wait for Some Time    time=${wait_time1}
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time1}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3      AND     Disable unanswered call    device=device_1      contact_device=device_2
 
*** Keywords ***
Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

