*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10
${2wait_time} =  20

*** Test Cases ***
TC1 : [Advance calling][Call Forward] DUT user to forward TDC call to voicemail
    [Tags]  329245     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   run keywords   Testcase Setup for CAP Premium User   count=2    AND    Set Call Forwarding    device=device_1
    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1:cap_search_enabled
    refresh for voicemail visibility for cap    device=device_1
    ${voicemail_count_after_new_voicemail}=    Get unread voicemail count    device=device_1
    run keyword if  ${voicemail_count_before_new_voicemail}+1 == ${voicemail_count_after_new_voicemail}    Log   voicemail count got increased
    ...   ELSE   fail   Voicemail count didn't increased
    Play And Validate Voicemail Count   new_vm_num=1     device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Disable Call forward   devices=device_1,device_2

TC2 : [Advance calling][Call Forward] DUT user redirects unanswered calls to voicemail
    [Tags]   329247    P1     Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User     count=2
    Enable unanswered call to voicemail     from_device=device_1        contact_device=device_2
    ${voicemail_count_before_new_voicemail}=     Get unread voicemail count    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Wait for Some Time    time=${2wait_time}
    Verify Call State    device_list=device_2   state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    refresh for voicemail visibility for cap    device=device_1
    ${voicemail_count_after_new_voicemail}=     Get unread voicemail count    device=device_1
    run keyword if  ${voicemail_count_before_new_voicemail} + 1 == ${voicemail_count_after_new_voicemail}    Log   voicemail count got increased
    ...   ELSE   fail   Voicemail count didn't increased
    Play And Validate Voicemail Count   new_vm_num=1     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Unanswered call Teardown   devices=device_1,device_2

TC3 : [Advance calling][Call Forward]DUT user redirects unanswered calls to a contact
    [Tags]   329248     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User     count=3
    Enable unanswered call and add contact   from_device=device_1    contact_device=device_3
    click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1     status=appear
    Wait for Some Time    time=${2wait_time}
    Verify incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND      Disable unanswered call    device=device_1     contact_device=device_3    AND     come back to home screen    device_list=device_1,device_2,device_3

TC4 :[Call forward on home screen] Verify Forward to my delegates option should not display in the call forwarding section & by default Don't forward my calls should get update in call forwarding section, When user DUT user removes the delegates.
    [Tags]  452863     BVT_CAPPremium     Sanity_CAPPremium      phonesCY23_4
    [Setup]   run keywords   Testcase Setup for CAP Premium User    count=2     AND    enable call forwarding display on home screen         device=device_1
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2
    verify call forwarding option in call forward icon    device=device_1      verify_call_group=off
    verify and set call forwarding on home screen     device=device_1       option=delegate           to_device=device_2
    Delete delegate from manage delegate    from_device=device_1     to_device=device_2
    verify call forwarding label status on home screen      device=device_1         status=off
    verify call forwarding option when no delegate present on device   device=device_1
    [Teardown]   run keywords  Capture on Failure    AND        dismiss call forwarding pop up on home screen       device=device_1    AND     Disable Call forward   devices=device_1,device_2

TC5 : [Advance calling][Call Forward] DUT user to forward TDC call to PSTN user
    [Tags]   329244      P2
    [Setup]     Testcase Setup for CAP Premium PSTN User     count=3
    Enable call forwarding and add contact     from_device=device_1    contact_device=device_2:pstn_user
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3        to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND     verify and disable call forwarding    device=device_1   AND     Come back to home screen       device_list=device_1,device_2,device_3

TC6 : [Advance calling][Call Forward] DUT user to forward the call to delegates - Call from TDC user
    [Tags]   329246      P1     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User     count=3
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    Enable call forwarding to delegates     from_device=device_1    contact_device=device_2
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_2     status=appear
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Delete delegate from manage delegate    from_device=device_1    to_device=device_2:delegate_user
    [Teardown]  run keywords  Capture on Failure    AND     verify and disable call forwarding    device=device_1    AND     come back to home screen   device_list=device_1,device_2,device_3

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    click on calls tab    ${from_device}
    Make outgoing call using phonenumber    ${from_device}      ${to_device}
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected

Unread voicemail count
    [Arguments]     ${device}
    Navigate to calls tab       device=device_1
    ${voicemail_count}=    get_missed_voicemail_count    ${device}
    log    ${voicemail_count}
    [Return]    ${voicemail_count}

Add new delegates with both permission and validate
    [Arguments]     ${from_device}     ${to_device}
    open_settings_page      ${from_device}
    open_manage_delegate_page    ${from_device}
    Add new delegate      ${from_device}      ${to_device}
    validate added delegate user name      ${from_device}      ${to_device}
    Come back to home screen    ${from_device}
    navigate to calls favorites page  ${to_device}
    refresh calls main tab  ${to_device}

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

enable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=on