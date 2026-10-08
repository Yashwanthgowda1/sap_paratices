*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  25
${wait_time3} =  15

*** Test Cases ***
TC1 : [Call Forward] DUT user to forward TDC call to voicemail
    [Tags]  306785   bvt_tp  sanity_tp      advance_calling     P2  alt_blocked
    [Setup]    run keywords   Testcase Setup    count=2   AND    Set Call Forwarding    device=device_1
    Clear notification from home screen     device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Wait for Some Time    time=20
    Verify voicemail notification     to_device=device_1     from_device=device_2
    navigate to voicemail tab    device=device_1
    play voicemail    device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Disable Call forward   devices=device_1,device_2

TC2 : [Call Forward] DUT user redirects unanswered calls to voicemail
    [Tags]      308309      advance_calling     P2  alt_bug      sanity_tp
    [Setup]     run keywords   Testcase Setup    count=2   AND    Enable unanswered call to voicemail      from_device=device_1     contact_device=device_2
    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2   to_device=device_1
    Verify Call State    device_list=device_2   state=Connected
    Verify incoming call     device=device_1    status=appear
    Wait for Some Time    time=${wait_time2}
    Verify Call State    device_list=device_2   state=Connected
    Verify incoming call     device=device_1    status=disappear
    Wait for Some Time    time=${wait_time2}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Refresh for voicemail visibility    device=device_1
    Verify voicemail notification     to_device=device_1     from_device=device_2
    navigate to voicemail tab    device=device_1
    play voicemail    device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Unanswered call Teardown   devices=device_1,device_2

TC3 :Verify DUT user able to forward the Private line call from TDC user to Voicemail
    [Tags]       476403    P2
    [Setup]    run keywords   Testcase Setup    count=2   AND    Set Call Forwarding    device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    verify and click send to voicemail option for incoming call          device=device_1            option=disappear
    Pick incoming call    device=device_1
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND     Disable Call forward   devices=device_1,device_2


TC5 : [Call Forward] DUT user call shouldn't forward to any point when VM is not enabled
    [Tags]    307065
    [Setup]    Run Keywords    Testcase Setup    count=2    AND    Signin With Other User    device=device_1    other_user_account=device_1:unified_messaging_policy_disabled
    Enable Call Forwarding To Voicemail    from_device=device_1    contact_device=device_2
    Click On Calls Tab    device=device_2
    Place call      from_device=device_2    to_device=device_1:unified_messaging_policy_disabled    method=display_name    hang_up_button=absent
    Verify Incoming Call    device=device_1    status=Disappear
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    Verify And Disable Call Forwarding    device=device_1    AND    Signin With Other User    device=device_1    other_user_account=device_1

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