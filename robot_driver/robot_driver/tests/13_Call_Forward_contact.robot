*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  25

*** Test Cases ***
TC1 : [Call Forward]DUT user redirects unanswered calls to a contact
    [Tags]  308312   sanity_tp      advance_calling         bvt_pr  alt_blocked
    [Setup]     run keywords   Testcase Setup    count=3   AND     Enable unanswered call and add contact   from_device=device_1    contact_device=device_2
    Click on calls tab      device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_1     status=appear
    Wait for Some Time    time=${wait_time2}
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Unanswered call Teardown    devices=device_1,device_2,device_3

TC2 : [Call Forward] DUT user to forward the incoming call from one TDC to another TDC
    [Tags]  306784      advance_calling     P2  alt_credentials
    [Setup]     run keywords   Testcase Setup    count=3   AND     Enable unanswered call and add contact   from_device=device_1    contact_device=device_2
    Click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Unanswered call Teardown    devices=device_1,device_2,device_3

TC3 : [Incoming Calls] DUT user receives the forwarded call from TDC
    [Tags]  306764      incoming_call    P2  alt_credentials
    [Setup]  run keywords   Testcase Setup    count=3   AND     Enable unanswered call and add contact   from_device=device_1    contact_device=device_2
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify display name on call toast   to_device=device_2    from_device=device_3
    Verify forward by call text     device=device_2    from_device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Unanswered call Teardown    devices=device_1,device_2,device_3

TC4 : [Busy on Busy][Call] Verify Unanswered call is forwarded to Contact,When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]      451973    sanity_tp  phonesCY23_4
    [Setup]      run keywords      Testcase Setup   count=4   AND     Enable unanswered call and add contact   from_device=device_1    contact_device=device_2
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab  device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
    Disconnect call     device=device_1,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Unanswered call Teardown    devices=device_1    AND      select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_4

TC5 : [Simul-ring] DUT user can configure a second Teams App user to ring simultaneously for an incoming call from third Teams App user
    [Tags]  307793    P2  alt_credentials
    [Setup]     run keywords   Testcase Setup    count=3    AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2
    Click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3

*** Keywords ***
Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

Call Ring Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    Disable Also Ring    device=device_1

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Click on calls tab   ${from_device}
    Make outgoing call using phonenumber    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=35s
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1